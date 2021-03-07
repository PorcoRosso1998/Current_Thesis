vlog +define+Table="LogTableRange1024bits11_11.v"+bit_size=22 Adder_tables.v
vlog +define+bit_size=22+bits=22 adder_tb_tables.v
vsim -gui work.adder_tb_tables
run

