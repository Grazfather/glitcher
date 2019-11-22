"""
    Script to test serial devices
"""

import struct
import time
import sys
import re

from pylibftdi import Device, Driver, INTERFACE_B

CMD_FPGA_RESET = b"\x00\xff"
CMD_BOARD_RESET = b"\x00\xfe"
CMD_GLITCH = b"\x00\x00"

passthrough = False

def expect_read(dev, expected):
    result = b""
    # Don"t attempt to read more than 10 times
    for i in range(0, 10):
        result += dev.read(len(expected))
        if expected in result:
            # print("[=] Expected = " + repr(expected) + " got " + repr(result))
            return None;

    print("[!] Expected = " + repr(expected) + " got " + repr(result))
    raise Exception
    # return result


def synchronize():
    while True:
        try:
            # Detect baud rate
            board_write(b"?")

            # Wait for "Synchronized\r\n"
            expect_read(dev, b"Synchronized\r\n")

            # Reply "Synchronized\r\n"
            board_write(b"Synchronized\r\n")

            # Verify "Synchronized\rOK\r\n"
            expect_read(dev, b"Synchronized\rOK\r\n")

            # Set a clock rate (value doesn't matter)
            board_write(b"12000\r\n")

            # Verify OK
            expect_read(dev, b"12000\rOK\r\n")
        except Exception:
            reset_board()
            continue

        break
    print("Synced!")


def read_address(address, length):
    cmd = "R {:d} {:d}\r\n".format(address, length).encode("ascii")
    board_write(cmd)

    result = b""
    # Don't attempt to read more than 10 times
    for i in range(0, 10):
        result += dev.read(61)
        if b"\r\n" in result:
            break

    # Check if command succeeded.
    if b"\r0" in result:
        board_write(b"OK\r\n")
        expect_read(dev, b"OK\r\n")
        return result

    return None


def test_crp():
    result = read_address(0, 4)
    if result:
        print("DEVICE UNLOCKED")
        print(repr(result))
        return result

    print("device is locked.")
    return None


def reset_fpga():
    global passthrough
    print("Resetting fpga")
    passthrough = False
    dev.write(CMD_FPGA_RESET)


def reset_board():
    print("Resetting target")
    dev.write(CMD_BOARD_RESET)


def glitch():
    dev.write(CMD_GLITCH)


def board_write(msg):
    print("Writing [" + repr(msg) + "]")
    if not passthrough:
        length = struct.pack("B", len(msg))
        msg = length + msg
    dev.write(msg)


def enable_passthrough():
    global passthrough
    passthrough = True
    dev.write("\x00\xfd")


#8'h40:
#    state <= STATE_PWM;
def get_cmd_pwm(pwm_value):
    return b"\x00\x40" + struct.pack("B", int(pwm_value, 2))

#8'h10:
#    state <= STATE_PATTERN0;
def get_cmd_pulse_width(width):
    if(width < 256):
        return b"\x00\x10" + struct.pack("B", width)
    else:
        print("ERROR, invalid pulse_wdith")
        exit(1)

#8'h11:
#    state <= STATE_PATTERN1;
def get_cmd_pulse_cnt(cnt):
    if(cnt < 256):
        return b"\x00\x11" + struct.pack("B", cnt)
    else:
        print("ERROR, invalid pulse_cnt")
        exit(1)


def get_cmd_delay(delay):
    delay0 = delay & 0xff
    delay1 = (delay >> 8) & 0xff
    delay2 = (delay >> 16) & 0xff
    delay3 = (delay >> 24) & 0xff
    delay4 = (delay >> 32) & 0xff
    delay5 = (delay >> 40) & 0xff
    delay6 = (delay >> 48) & 0xff
    delay7 = (delay >> 56) & 0xff

    result = b"\x00\x20"
    result += struct.pack("B", delay0)
    result += b"\x00\x21"
    result += struct.pack("B", delay1)
    result += b"\x00\x22"
    result += struct.pack("B", delay2)
    result += b"\x00\x23"
    result += struct.pack("B", delay3)
    result += b"\x00\x24"
    result += struct.pack("B", delay4)
    result += b"\x00\x25"
    result += struct.pack("B", delay5)
    result += b"\x00\x26"
    result += struct.pack("B", delay6)
    result += b"\x00\x27"
    result += struct.pack("B", delay7)
    return result


def line_parse(s):
    # return everything between 0 and the \r\n, following the UU data
    match = re.findall(r"\$.*\r\n", s.decode("ascii"))[0]
    return match[1:-2]


def uu_decode_line(uudata):
    result = uu_decode(uudata[:4])
    result.append(uu_decode(uudata[4:])[0])
    return result


def uu_decode(uudata):
    data = [ord(c) for c in uudata]
    s0 = 0;
    s1 = 0;
    s2 = 0;

    s0 = ((data[0]-32)<<2) & 0xff
    s0 = s0 | (((data[1]-32)>>4) & 0x03)

    s1 = ((data[1]-32)<<4) & 0xf0
    s1 = s1 | (((data[2]-32)>>2) & 0x0f)

    s2 =((data[2]-32)<<6) & 0xC0
    s2 = s2 | (((data[3]-32))    & 0x3F)
    return [s0, s1, s2]


def unlock(delay_range, width_range):
    for delay in range(delay_range[0], delay_range[1]):
        for width in range (width_range[0], width_range[1]):
            sys.stdout.write("[w:%02d,d:%010d]: " % (width, delay))
            cmd = get_cmd_pulse_width(width)
            cmd += get_cmd_pulse_cnt(0)
            cmd += get_cmd_delay(delay)
            cmd += CMD_BOARD_RESET
            dev.write(cmd)

            synchronize()

            crp = test_crp()
            if crp:
                return crp

if __name__ == "__main__":
    with Device(mode="b", interface_select=INTERFACE_B) as dev:
        dev.baudrate = 115200
        reset_fpga()
        reset_board()
        synchronize()
        reset_board()

        unlock(delay_range=(200, 500), width_range=(10, 25))

        f = open("workfile", "wb")

        for i in range(0, 0x8000):
            address = i * 4
            result = read_address(address, 4)
            if result:
                data = uu_decode_line(line_parse(result))
                output = "[0x%06x]: " % address
                output += "".join(["%02X " % x for x in data])
                print(output)
                f.write(bytearray(data))
            else:
                print("[!!!] Error")

        exit(0)
