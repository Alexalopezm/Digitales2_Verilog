Calculadora:
	iverilog -o tb1.vvp testbench.v
	vvp tb1.vvp
	gtkwave tb1.vcd
	rm -rf tb1.vvp tb1.vcd 
Calculadora_yosys:
	iverilog -o tb.vvp testbench_yosys.v
	vvp tb.vvp
	gtkwave tb.vcd
	rm -rf tb.vvp tb.vcd 

clean:
	rm -rf tb.vvp tb.vcd
	rm -rf tb1.vvp tb1.vcd 
