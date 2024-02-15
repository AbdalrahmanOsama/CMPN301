from os.path import dirname, join
current_dir = dirname(__file__)
from tkinter import*

DC_ImmVal="0000000000000000"
ZERO_OP_filler="0000000000000000000000000"
ONE_OP_filler="0000000000000000000000"

#handle all upper case strings
#handle invalid (false) instructions
#handle outrange register number

def register_to_binary(decimal_number):
    register_number = int(decimal_number[1:])
    if register_number>7:
        binary_number="XXX"
        return binary_number
    binary_number = bin(register_number)[2:]  # Remove the '0b' prefix
    binary_number = binary_number.zfill(3)  # Pad the binary number with leading zeros to make it 3 bits
    return binary_number

def decimal_to_16bit_binary(decimal_number):
    binary_number = bin(decimal_number)[2:]  # Convert decimal to binary and remove '0b' prefix
    binary_number = binary_number.zfill(16)  # Pad the binary number with leading zeros to make it 16 bits
    return binary_number

def Assemble():
    # Open the file in read mode
    
    inputfile=label1Entry.get()+".txt"
    file_path = join(current_dir, inputfile)
    outputfile="./"+label2Entry.get()+".mem"
    output_path= join(current_dir, outputfile)
    with open(file_path, "r") as file:
        # Open the output file in write mode
        with open(output_path, "w") as output_file:
            # Loop over each line in the file
            line_number = 0
            line_index = 0
            for line in file:
                # Remove commas and comments from the line
                line_without_commas_or_comments = line.split("#")[0].replace(",", " ")

                # Split the line into words
                operands = line_without_commas_or_comments.split()

                # Convert operands to uppercase
                operands = [operand.upper() for operand in operands]


                # Create variables for each word
                variables = []
                for i in range(len(operands)):
                    variable_name = "operand_" + str(i + 1)
                    variables.append(variable_name)
                
                if not variables:
                    continue
                else:
                    exec(', '.join(variables) + " = operands")
                    # Execute the variable assignments
                    # Increment the line counter
                    line_number += 1
                    

                    # Check for ".org" directive and adjust line number accordingly
                    if len(operands) >= 2 and operands[0] == ".ORG":
                        org_value = int(operands[1], 16)
                        line_number = org_value

                        for i in range(line_number):
                         output_file.write(str(line_index)+": "+"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n")
                         line_index += 1
                    
                    if operands[0] == ".ORG":
                        continue
                    else:

                        print(operands[0])

                        # Access the variables
                        if operands == ['NOP']:
                            operands[0]="0000000"
                            output_file.write(str(line_index)+": "+operands[0]+" "+ZERO_OP_filler+ "\n")
                        
                        elif operands == ['SETC']:
                            operands[0]="0000010"
                            output_file.write(str(line_index)+": "+operands[0]+" "+ZERO_OP_filler+ "\n")
                        
                        elif operands == ['CLRC']:
                            operands[0]="0000011"
                            output_file.write(str(line_index)+": "+operands[0]+" "+ZERO_OP_filler+ "\n")
                        
                        elif operands == ['RET']:
                            operands[0]="1100001"
                            output_file.write(str(line_index)+": "+operands[0]+" "+ZERO_OP_filler+ "\n")
                        
                        elif operands == ['RTI']:
                            operands[0]="1100011"
                            output_file.write(str(line_index)+": "+operands[0]+" "+ZERO_OP_filler+ "\n")
                        
                        elif operands[0] == "OUT":
                            operands[0]="1001101"
                            Rsrc1=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" 000 "+Rsrc1+ " 0000000000000000000\n")
                        
                        elif operands[0] == "PUSH":
                            operands[0]="1001101"
                            Rsrc1=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" 000 "+Rsrc1+ " 0000000000000000000\n")
                        
                        elif operands[0] == "IN":
                            operands[0]="1001101"
                            Rdst=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+ " 0000000000000000000000\n")
                        
                        elif operands[0] == "POP":
                            operands[0]="1000010"
                            Rdst=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+ " 0000000000000000000000\n")

                        elif operands[0] == "JZ":
                            operands[0]="1100111"
                            Rdst=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+ " 0000000000000000000000\n")

                        elif operands[0] == "JC":
                            operands[0]="100110"
                            Rdst=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+ " 0000000000000000000000\n")

                        elif operands[0] == "JMP":
                            operands[0]="1100100"
                            Rdst=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+ " 0000000000000000000000\n")

                        elif operands[0] == "CALL":
                            operands[0]="1100000"
                            Rdst=register_to_binary(operands[1])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+ " 0000000000000000000000\n")

                        elif operands[0] == "NOT":
                            operands[0]="0101000"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" 0000000000000000000\n")
                        
                        elif operands[0] == "INC":
                            operands[0]="0101010"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" 0000000000000000000\n")
                        
                        elif operands[0] == "DEC":
                            operands[0]="0101011"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" 0000000000000000000\n")
                        
                        elif operands[0] == "MOV":
                            operands[0]="0101100"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" 0000000000000000000\n")

                        elif operands[0] == "LDD":
                            operands[0]="1001000"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" 0000000000000000000\n")
                        
                        elif operands[0] == "LDM":
                            operands[0]="0110100"
                            Rdst=register_to_binary(operands[1])
                            IMM=decimal_to_16bit_binary(operands[2])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" 000000000 "+IMM+ "\n")
                        
                        elif operands[0] == "STD":
                            operands[0]="1011001"
                            Rsrc2=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            output_file.write(str(line_index)+": "+operands[0]+" 000 "+Rsrc1+ " "+Rsrc2+" 0000000000000000\n")
                        
                        elif operands[0] == "ADD":
                            operands[0]="0111010"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" "+Rsrc2+" "+DC_ImmVal+ "\n")

                        elif operands[0] == "SUB":
                            operands[0]="0111011"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" "+Rsrc2+" "+DC_ImmVal+ "\n")
                        
                        elif operands[0] == "AND":
                            operands[0]="0111000"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" "+Rsrc2+" "+DC_ImmVal+ "\n")

                        elif operands[0] == "OR":
                            operands[0]="0111001"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" "+Rsrc2+" "+DC_ImmVal+ "\n")

                        elif operands[0] == "IADD":
                            operands[0]="0110010"
                            Rdst=register_to_binary(operands[1])
                            Rsrc1=register_to_binary(operands[2])
                            IMM=decimal_to_16bit_binary(operands[3])
                            output_file.write(str(line_index)+": "+operands[0]+" "+Rdst+" "+Rsrc1+" 000 "+IMM)+ "\n"

                        else:
                            output_file.write(str(line_index)+": "+"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n")
                            print("INVALID INSTRUCTION, FILLED WITH UNDEFINED")
                line_index += 1
    Messagelabel=Label(text="The File is Assembled Successfully!")
    Messagelabel.pack()

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