vsim work.pipeline(structure)
restart -f
delete wave *
mem load -i {./Testcase.mem} /pipeline/Fetch/InstCache/ram
add wave -color "white" -radix bin -position end  sim:/pipeline/clk
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/rst
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/interrupt
add wave -color "yellow" -radix hex -position end  sim:/pipeline/InPort
add wave -color "yellow" -radix hex -position end  sim:/pipeline/OutPort
add wave -divider
add wave -color "yellow" -radix bin -position end  sim:/pipeline/FD_Instruction
add wave -color "yellow" -radix hex -position end  sim:/pipeline/FD_InPortData
add wave -divider
add wave -color "dark orange" -radix bin -position end  sim:/pipeline/Execute/FlagRegister/q
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/DE_ALUFlagEnable
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/DE_ALUOperation
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/DE_ImmediateValue
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/DE_WriteBackEnable
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/DE_MemoryReadEnable
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/DE_MemoryWriteEnable
add wave -color "yellow" -radix hex -position end  sim:/pipeline/DE_Data1
add wave -color "yellow" -radix hex -position end  sim:/pipeline/DE_Data2
add wave -color "green" -radix unsigned -position end  sim:/pipeline/DE_DestAdr
add wave -color "yellow" -radix hex -position end  sim:/pipeline/DE_InPortData
add wave -divider
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/EM_WriteBackEnable
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/EM_MemoryReadEnable
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/EM_MemoryWriteEnable
add wave -color "yellow" -radix hex -position end  sim:/pipeline/EM_Data1
add wave -color "yellow" -radix hex -position end  sim:/pipeline/EM_Data2
add wave -color "green" -radix unsigned -position end  sim:/pipeline/EM_DestAdr
add wave -color "yellow" -radix hex -position end  sim:/pipeline/EM_InPortData
add wave -divider
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/MWB_WriteBackEnable
add wave -color "yellow" -radix hex -position end  sim:/pipeline/MWB_WriteData
add wave -color "green" -radix unsigned -position end  sim:/pipeline/MWB_WriteAdr
add wave -color "yellow" -radix hex -position end  sim:/pipeline/MWB_OutPortData
add wave -divider
add wave -color "dodger blue" -radix bin -position end  sim:/pipeline/WriteBackEnable
add wave -color "yellow" -radix hex -position end  sim:/pipeline/WriteData
add wave -color "green" -radix unsigned -position end  sim:/pipeline/WriteAdr
add wave -color "yellow" -radix hex -position end  sim:/pipeline/OutPortData
force -freeze sim:/pipeline/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pipeline/rst 1 0
force -freeze sim:/pipeline/rst 0 100
force -freeze sim:/pipeline/InPort x\"0000\" 0
force -freeze sim:/pipeline/InPort x\"FFFE\" 300
force -freeze sim:/pipeline/InPort x\"0001\" 1400
force -freeze sim:/pipeline/InPort x\"000F\" 1500
force -freeze sim:/pipeline/InPort x\"00C8\" 1600
force -freeze sim:/pipeline/InPort x\"001F\" 1700
force -freeze sim:/pipeline/InPort x\"00FC\" 1800
force -freeze sim:/pipeline/InPort x\"0000\" 2000
run 6900
