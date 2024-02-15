-how the assembler works
when the code runs, a window appears the assembler app takes 2 inputs, the input file name with its format format which contains the required instructions, and the output file name which can be named as desired in (.mem) format
	=>at line 28 u can change the format of the output file instead of (.mem)
after entering the input/output files names, press on the "Assemble" button
	=>if the instructions assembled succesfully, the window will show "The File is Assembled Successfully! please check the operations 	from the terminal" msg, if not the msg will not show
	after the instructions are assembled successfully isA:D, the operations will be shown in the terminal as a check

-features
_the assembler handles the byte order mark BOM (Ï»¿)of the (.asm) format
_the assembler converts all the strings into upper case
_the assembler detects if the register number is larger, and a "REGISTER IS OUT OF RANGE, FILLED WITH UNDEFINED" msg will be shown and the instruction will be filled with "XXXXXXXX"
_the assembler detects if the instruction is valid
ex. NOP R1
a "INVALID INSTRUCTION, FILLED WITH UNDEFINED" will ne shown and the instruction will be filled with "XXXXXXXX"


