verilog:
	iverilog -o tb.vvp Testbench_Recep.v
	vvp tb.vvp
	gtkwave tb.vcd

.PHONY: clean
clean:
	rm -rf tb.vvp tb.vcd