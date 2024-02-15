from os.path import dirname, join
current_dir = dirname(__file__)
from tkinter import*


def register_to_binary(decimal_number):
    if decimal_number[0] == "R":                           #remove the notation of Register, change the string if the register is named with another letter
        decimal_number = decimal_number[1:]
    register_number = int(decimal_number)
    if register_number > 7:                                #check if the register number is out of the range (available number of registers)
        binary_number = "999"
        return binary_number
    binary_number = bin(register_number)[2:]               # Remove the '0b' prefix
    binary_number = binary_number.zfill(3)                 # Pad the binary number with leading zeros to make it 3 bits
    return binary_number

def decimal_to_16bit_binary(decimal_number):
    binary_number = bin(decimal_number)[2:]                 # Convert decimal to binary and remove '0b' prefix
    binary_number = binary_number.zfill(16)                 # Pad the binary number with leading zeros to make it 16 bits
    return binary_number


def Assemble():
    instruction="0"
    IMM="0"
    inputfile=label1Entry.get()                             #getting input file name with its format
    file_path = join(current_dir, inputfile)                #working in the same directory as the code
    outputfile="./"+label2Entry.get()+".mem"                #setting the output file format to ".mem" file, can be changed according to desired output file format
    output_path= join(current_dir, outputfile)  

    
    with open(file_path, "r") as file:                      # Open the file in read mode   
        with open(output_path, "w") as output_file:         # Open the output file in write mode                 

            line_number = 0
            
            for line in file:                               # Loop over each line in the file
                line_without_commas_or_comments = line.split("#")[0].replace(",", " ").replace('\xef\xbb\xbf',' ')      # Remove commas and comments and (byte order mark BOM) Ï»¿ of the .asm format from the line
                operands = line_without_commas_or_comments.split()                          # Split the line into words (operands)
                operands = [operand.upper() for operand in operands]                        # Convert operands to uppercase
                skipflag=False
                IMMflag=False
                variables = []                                      # Create variables for each word (operand)
                for i in range(len(operands)):
                    variable_name = "operand_" + str(i + 1)
                    variables.append(variable_name)

                if not variables:                                   #ignoring empty lines
                    continue
                else:
                    exec(', '.join(variables) + " = operands")      # Execute the variable assignments
                    line_number += 1                                # Increment the line counter

                    
                    if len(operands) >= 2 and operands[0] == ".ORG":    # Check for ".org" directive and adjust line number accordingly
                        org_value = int(operands[1], 16)
                        line_number = org_value-1

                    if operands[0] == ".ORG":                           #ignore ".org" line from checking for opcode
                        continue
                    else:
                        print(operands[0])                              #print operation in the terminal
                        #looking for operating and converting instruction to its opcode (in binary) 
                        if operands == ['NOP']:
                            opcode="0000000"
                            instruction=(opcode+"000000000")

                        elif operands == ['SETC']:
                            opcode="0000010"
                            instruction=(opcode+"000000000")
                        
                        elif operands == ['CLRC']:
                            opcode="0000011"
                            instruction=(opcode+"000000000")
                        
                        elif operands == ['RET']:
                            opcode="1100001"
                            instruction=(opcode+"000000000")
                        
                        elif operands == ['RTI']:
                            opcode="1100011"
                            instruction=(opcode+"000000000")
                        
                        elif operands[0] == "OUT":
                            opcode="1001101"
                            Rsrc1=register_to_binary(operands[1])
                            instruction=(opcode+"000"+Rsrc1+"000")
                        
                        elif operands[0] == "PUSH":
                            opcode="1001101"
                            Rsrc1=register_to_binary(operands[1])
                            instruction=(opcode+"000"+Rsrc1+"000")

                        elif operands[0] == "IN":
                            opcode="1001101"
                            Rdst=register_to_binary(operands[1])
                            instruction=(opcode+Rdst+"000000")

                        elif operands[0] == "POP":
                            opcode="1000010"
                            Rdst=register_to_binary(operands[1])
                            instruction=(opcode+Rdst+"000000")

                        elif operands[0] == "JZ":
                            opcode="1100111"
                            Rdst=register_to_binary(operands[1])
                            instruction=(opcode+Rdst+"000000")

                        elif operands[0] == "JC":
                            opcode="100110"
                            Rdst=register_to_binary(operands[1])
                            instruction=(opcode+Rdst+"000000")

                        elif operands[0] == "JMP":
                            opcode="1100100"
                            Rdst=register_to_binary(operands[1])
                            instruction=(opcode+Rdst+"000000")

                        elif operands[0] == "CALL":
                            opcode="1100000"
                            Rdst=register_to_binary(operands[1])
                            instruction=(opcode+Rdst+"000000")

                        elif operands[0] == "NOT":
                            opcode="0101000"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rdst+Rsrc1+"000")
                        
                        elif operands[0] == "INC":
                            opcode="0101010"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rdst+Rsrc1+"000")

                        elif operands[0] == "DEC":
                            opcode="0101011"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rdst+Rsrc1+"000")
                        
                        elif operands[0] == "MOV":
                            opcode="0101100"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rdst+Rsrc1+"000")

                        elif operands[0] == "LDD":
                            opcode="1001000"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rdst+Rsrc1+"000")
                        
                        elif operands[0] == "LDM":
                            opcode="0110100"
                            Rdst=register_to_binary(operands[1])
                            IMM=operands[2]
                            instruction=(opcode+Rdst+"000000")
                            IMMflag=True
                        
                        elif operands[0] == "STD":
                            opcode="1011001"
                            Rsrc2=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rdst+Rsrc1+"000")
                        
                        elif operands[0] == "ADD":
                            opcode="0111010"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            instruction=(opcode+Rdst+Rsrc1+Rsrc2)

                        elif operands[0] == "SUB":
                            opcode="0111011"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            instruction=(opcode+Rdst+Rsrc1+Rsrc2)
                        
                        elif operands[0] == "AND":
                            opcode="0111000"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            instruction=(opcode+Rdst+Rsrc1+Rsrc2)

                        elif operands[0] == "OR":
                            opcode="0111001"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            instruction=(opcode+Rdst+Rsrc1+Rsrc2)

                        elif operands[0] == "IADD":
                            opcode="0110010"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            IMM=operands[3]
                            instruction=(opcode+Rdst+Rsrc1+"000")
                            IMMflag=True

                        elif operands[0]>"0":                                #stores the value in the memory cache
                            instruction=operands[0]
                            output_file.write(str(line_number)+": "+instruction+"\n")
                            skipflag=True

                        else:
                            output_file.write(str(line_number)+": "+"XXXXXXXX\n")
                            print("INVALID INSTRUCTION, FILLED WITH UNDEFINED")
                    
                    if skipflag:
                        continue
                    else:
                        if "999" in instruction:
                            output_file.write(str(line_number)+": "+"XXXXXXXX\n")
                            print("REGISTER IS OUT OF RANGE, FILLED WITH UNDEFINED")
                            continue
                        else:
                            instruction_bin=int(instruction,2)
                            instruction_hex=hex(instruction_bin)[2:]
                            instruction_hex = instruction_hex.zfill(4)              # Pad the hex number with leading zeros to make it 1 byte
                            output_file.write(str(line_number)+": "+instruction_hex+"\n")
                            if IMMflag:
                                line_number+=1
                                output_file.write(str(line_number)+": "+IMM+"\n")
                            

    Messagelabel=Label(text="The File is Assembled Successfully!\n please check the operations from the terminal")
    Messagelabel.pack()                    
                        

#GUI section
root=Tk()
root.title("Assembler App")
root.minsize(400,200)

label1=Label(root, text="Input File")
label1.pack()
label1Entry=Entry()
label1Entry.pack()

label2=Label(root, text="Output File")
label2.pack()
label2Entry=Entry()
label2Entry.pack()

but=Button(text="Assemble", command=Assemble)
but.pack()

root.mainloop()