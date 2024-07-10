verilog:
	iverilog -o tb.vvp Testbench_Trans.v
	vvp tb.vvp
	gtkwave tb.vcd

.PHONY: clean
clean:
	rm -rf tb.vvp tb.vcd