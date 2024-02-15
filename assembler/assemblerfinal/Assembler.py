import re

from Interpreter import Interpreter

def AddLine(Address, MemData, Lines): 
    Lines[Address] = str(MemData) + "\n"
    return Lines

def Convert_Hex_Dec(HexValue):
    DecValue = int(HexValue, 16)
    return DecValue

FileName = input("Enter File Name: ")
ReadFile = open(FileName, "r")
Modified = open("Modified.txt", "w")

#This Loop Removes the comments and empty lines
#Add the code in another file
for line in ReadFile:
    if line[0] == "#" or line[0] == "\n" :
        continue

    for word in line.split():
        if word[0] == "#":
            break
        Modified.write(word.upper()+" ")
    Modified.write("\n")
ReadFile.close()
Modified.close()

Modified = open("Modified.txt", "r")

#array of data in representing each space in memory
Lines = ["00000000000000000000000000000000\n"] * (2**20)
Address = 0
MemData = ""
ORGInst = False

for line in Modified:
    word = re.split(r"\s+|,\s|,", line)
    Length = len(word) -1
    if Length == 1:
        # Data, NOP, HLT, SETC, RET, RTI
        MemData = Interpreter(word[0])
        #if Org instruction was not detected in the previous line then increment adddress
        if ORGInst == False:
            Address += 1
        else:
            ORGInst = False
        #Write data in memory array
        Lines = AddLine(Address,MemData,Lines)

    elif Length == 2:
        # ORG., NOT, INC, OUT, IN, PUSH, POP, JZ, JN, JC, JMP, CALL, INT
        # If ORG. then, the address = next element
        if word[0] == ".ORG":
            Address = word[1]
            Address = Convert_Hex_Dec(Address)
            ORGInst = True
            continue
        MemData = Interpreter(word[0], word[1])
        #if Org instruction was not detected in the previous line then increment adddress
        if ORGInst == False:
            Address += 1
        else:
            ORGInst = False
        #Write data in memory array
        Lines = AddLine(Address,MemData,Lines)

    elif Length == 3:
        # MOV, SWAP, LDM, LDD, STD
        MemData = Interpreter(word[0], word[1], word[2])
        #if Org instruction was not detected in the previous line then increment adddress
        if ORGInst == False:
            Address += 1
        else:
            ORGInst = False
        #Write data in memory array
        Lines = AddLine(Address,MemData,Lines)

    elif Length == 4:
        # ADD, SUB, AND, IADD
        MemData = Interpreter(word[0], word[1], word[2], word[3])
        #if Org instruction was not detected in the previous line then increment adddress
        if ORGInst == False:
            Address += 1
        else:
            ORGInst = False
        #Write data in memory array
        Lines = AddLine(Address,MemData,Lines)

#Write memory data in a file
MemoryFile = open("MemoryFile.txt", "w")
for i in range(2**20):
    MemoryFile.write(Lines[i])
MemoryFile.close()
Modified.close()
