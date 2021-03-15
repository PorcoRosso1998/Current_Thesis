vlog +define+Table="LogTableRange16bits5_5.v"+bit_size=18 log_bitshift.v
vlog +define+bit_size=18+bits=18 adder_tb_tables.v
vsim -gui work.adder_tb_tables
run

