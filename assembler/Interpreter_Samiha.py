import string
def Convert_Hex_Binary(HexValue):
    BinaryValue = bin(int(HexValue, 16))
    width = len(BinaryValue) -2  
    if width < 32:
        BinaryValue = "0"*(32-width) + BinaryValue[-width:]
    else:
        BinaryValue = BinaryValue[-32:]
    return BinaryValue

def Register_Interpreter(RegisterName):
    RegAddress = 0
    Offset = ""
    OffsetNum = RegisterName[0]
    if(all(c in string.hexdigits for c in OffsetNum)):
        number=""
        x=RegisterName[0]
        i=0
        while all(c in string.hexdigits for c in x):
            if(len(number)<1):
                number=x
                i+=1
                if(i>len(RegisterName)-1):
                    break
                x=RegisterName[i]
            else:
                number=number+x
                i+=1
                if(i>len(RegisterName)-1):
                    break
                x=RegisterName[i]
        OffsetNum=number
        Offset=Convert_Hex_Binary(OffsetNum)
        RegisterName=RegisterName.replace("(","")
        RegisterName=RegisterName.replace(")","")
        if(("R" in RegisterName) or ("r" in RegisterName)):
            RegisterName=RegisterName.replace(OffsetNum,"")
    RegNum = RegisterName[1]
    if(not(all(c in string.hexdigits for c in RegNum))):
        return None
    else:
        RegNum = bin(int(RegNum))
        width = len(RegNum) - 2
        if width < 3:
            RegAddress = "0"*(3-width) + RegNum[-width:]
        else:
            RegAddress = RegNum[-3:]
        return [RegAddress,Offset]

def Interpreter(Opcode, operand1=None, operand2=None, operand3=None):
    MemData = 0
    if operand1 is None:
        # Data
        if all(c in string.hexdigits for c in Opcode):
            MemData = Convert_Hex_Binary(Opcode)  
            return MemData
        # NOP
        if Opcode == "NOP":
            MemData = "00000" + "0"*27
        # HLT
        elif Opcode == "HLT":
            MemData = "00001" + "0"*27
        # SETC
        elif Opcode == "SETC":
            MemData = "00010" + "0"*27
        # RET
        elif Opcode == "RET":
            MemData = "11101" + "0"*27
        # RTI 
        elif Opcode == "RTI":
            MemData = "11111" + "0"*27
        return MemData
    elif operand2 is None:
        # ORG., NOT, INC, OUT, IN, PUSH, POP, JZ, JN, JC, JMP, CALL, INT
        if all(c in string.hexdigits for c in Opcode):
            MemData = Convert_Hex_Binary(Opcode)  
            return MemData
        # NOT
        if Opcode == "NOT":
            oper1andoffset = Register_Interpreter(operand1)
            oper1 = oper1andoffset[0]
            MemData = "00011" + oper1 + "0"*24
        # INC
        elif Opcode == "INC":
            oper1andoffset = Register_Interpreter(operand1)
            oper1 = oper1andoffset[0]
            MemData = "00100" + oper1 + "0"*24
        # OUT
        elif Opcode == "OUT":
            oper1andoffset = Register_Interpreter(operand1)
            oper1 = oper1andoffset[0]
            MemData = "00101" + oper1 + "0"*24
        # IN
        elif Opcode == "IN":
            oper1andoffset = Register_Interpreter(operand1)
            oper1 = oper1andoffset[0]
            MemData = "00110" + oper1 + "0"*24
        # PUSH 
        elif Opcode == "PUSH":
            oper1andoffset = Register_Interpreter(operand1)
            oper1 = oper1andoffset[0]
            MemData = "10000" + "000" + oper1 + "0"*21
        # POP
        elif Opcode == "POP":
            oper1andoffset = Register_Interpreter(operand1)
            oper1 = oper1andoffset[0]
            MemData = "10001" + oper1 + "0"*24
        # JZ
        elif Opcode == "JZ":
            oper1 = Convert_Hex_Binary(operand1)
            MemData = "11000"  + "0"*11 + oper1[16:32]
        # JN
        elif Opcode == "JN":
            oper1 = Convert_Hex_Binary(operand1)
            MemData = "11001" + "0"*11 + oper1[16:32]
        # JC    
        elif Opcode == "JC":
            oper1 = Convert_Hex_Binary(operand1)
            MemData = "11010" + "0"*11 + oper1[16:32]
        # JMP
        elif Opcode == "JMP":
            oper1 = Convert_Hex_Binary(operand1)
            MemData = "11011" + "0"*11 + oper1[16:32]
        # CALL
        elif Opcode == "CALL":
            oper1 = Convert_Hex_Binary(operand1)
            MemData = "11100" + "0"*11 + oper1[16:32]
        #INT
        elif Opcode == "INT":
            oper1 = operand1
            MemData = "11110" + "0" + oper1 + "0"*22
        return MemData

    elif operand3 is None:
        # MOV, SWAP, LDM, LDD, STD
        if all(c in string.hexdigits for c in Opcode):
            MemData = Convert_Hex_Binary(Opcode)  
            return MemData
        if Opcode == "MOV":
            oper1andoffset = Register_Interpreter(operand1)
            oper1 = oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2 = oper2andoffset[0]
            MemData = "01000" + oper2 + oper1 + "0"*21
        elif Opcode == "SWAP":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2=oper2andoffset[0]
            MemData = "01001" + oper2 + oper1 + "0"*21
        elif Opcode == "LDM":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2 = Convert_Hex_Binary(operand2)
            MemData = "10010" + "000" + oper1 + "00000" + oper2[16:32]
        elif Opcode == "LDD":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2=oper2andoffset[0]
            offset2=oper2andoffset[1]
            MemData = "10011" + oper1 + oper2 + "0"*5 + offset2[16:32]
        elif Opcode == "STD":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2=oper2andoffset[0]
            offset2=oper2andoffset[1]
            MemData = "10100" + oper2 + oper1 + "0"*5 + offset2[16:32]
        return MemData

    else:
        # ADD, SUB, AND, IADD
        if all(c in string.hexdigits for c in Opcode):
            MemData = Convert_Hex_Binary(Opcode)  
            return MemData
        if Opcode == "ADD":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2=oper2andoffset[0]
            oper3andoffset = Register_Interpreter(operand3)
            oper3=oper3andoffset[0]
            MemData = "01010" + oper2 + oper3 + oper1 + "0"*18 
        elif Opcode == "SUB":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2=oper2andoffset[0]
            oper3andoffset = Register_Interpreter(operand3)
            oper3=oper3andoffset[0]
            MemData = "01011" + oper2 + oper3 + oper1 + "0"*18 
        elif Opcode == "AND":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2=oper2andoffset[0]
            oper3andoffset = Register_Interpreter(operand3)
            oper3=oper3andoffset[0]
            MemData = "01100" + oper2 + oper3 + oper1 + "0"*18
        elif Opcode == "IADD":
            oper1andoffset = Register_Interpreter(operand1)
            oper1=oper1andoffset[0]
            oper2andoffset = Register_Interpreter(operand2)
            oper2=oper2andoffset[0]
            oper3 = Convert_Hex_Binary(operand3)
            MemData = "01101" + oper2 + oper1 + "0"*5+ oper3[16:32]
        return MemData