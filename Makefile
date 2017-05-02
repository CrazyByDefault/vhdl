all : 
	ghdl -a src/i2c.vhdl
	ghdl -e i2c
	ghdl -r i2c
	ghdl -a src/i2c_tb.vhdl
	ghdl -e i2c_tb

run :
	ghdl -r i2c_tb

with-gtkwave : all
	ghdl -r i2c_tb --vcd=i2c.vcd

clean : 
	rm *.o
	rm *.cf
	rm i2c
	rm i2c_tb
	rm *.vcd