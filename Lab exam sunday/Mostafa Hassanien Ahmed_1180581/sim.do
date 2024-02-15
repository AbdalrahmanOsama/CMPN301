# vsim work.top 
# Start time: 12:54:30 on May 08,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.top(arch1)
# Loading work.nbit_reg(arch1)
# Loading work.mux2(arch1)
# Loading work.my_nadder(a_my_nadder)
# Loading work.my_adder(a_my_adder)
# Loading work.comp(arch2)
# Loading work.mux2x1(arch1)
# Loading ieee.std_logic_signed(body)
# Loading work.shift_one(arch1)
# Loading work.counter(arch1)
# Loading work.ctr(arch1)
add wave -position insertpoint  \
sim:/top/clk \
sim:/top/rst \
sim:/top/A \
sim:/top/F1 \
sim:/top/F2 \
sim:/top/F3 \
sim:/top/A_out \
sim:/top/V \
sim:/top/data \
sim:/top/A1 \
sim:/top/A_final \
sim:/top/A_reg \
sim:/top/A_op \
sim:/top/A_shift \
sim:/top/sel \
sim:/top/en \
sim:/top/c1 \
sim:/top/c2 \
sim:/top/c3 \
sim:/top/ones_add \
sim:/top/tens_add \
sim:/top/hund_add \
sim:/top/ones_f \
sim:/top/tens_f \
sim:/top/hund_f \
sim:/top/ones_flag \
sim:/top/tens_flag \
sim:/top/hundereds_flag \
sim:/top/count
force -freeze sim:/top/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/top/rst 0 0
force -freeze sim:/top/rst 1 10
force -freeze sim:/top/rst 0 20
force -freeze sim:/top/A 11110011 0