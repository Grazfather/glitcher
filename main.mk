
all: $(PROJ).rpt $(PROJ).bin

%.blif: $(ADD_SRC) $(ADD_DEPS) $(ADD_BOARD_SRC)
	yosys -ql $*.log -p 'synth_ice40 -top top -blif $@' $(ADD_SRC) $(ADD_BOARD_SRC)

%.json: $(ADD_SRC) $(ADD_DEPS) $(ADD_BOARD_SRC)
	yosys -ql $*.log -p 'synth_ice40 -top top -json $@' $(ADD_SRC) $(ADD_BOARD_SRC)

ifeq ($(USE_ARACHNEPNR),)
%.asc: $(PIN_DEF) %.json
	nextpnr-ice40 --$(DEVICE) --json $(filter-out $<,$^) --package sg48 --pcf $< --asc $@
else
%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst up,,$(subst hx,,$(subst lp,,$(DEVICE)))) -o $@ -p $^
endif


%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%_tb: sim/%_tb.v $(ADD_SRC) $(ADD_TB_SRC)
	iverilog -o $@ $^

%_tb.vcd: %_tb
	vvp -N $< +vcd=$@

%_syn.v: %.blif
	yosys -p 'read_blif -wideports $^; write_verilog $@'

%_syntb: sim/%_tb.v %_syn.v
	iverilog -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

%_syntb.vcd: %_syntb
	vvp -N $< +vcd=$@

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin $(PROJ).json $(PROJ).log $(ADD_CLEAN)

.SECONDARY:
.PHONY: all prog clean
