import linecache
def OPcodeInterpreter(OPword):
    if (OPword=="NOP"):
        OPcode = "00000"
    elif(OPword=="HLT"):
        OPcode = "00001"
    elif(OPword=="SETC"):
        OPcode = "00010"
    elif(OPword=="NOT"):
        OPcode = "00011"
    elif(OPword=="INC"):
        OPcode = "00100"
    elif(OPword=="OUT"):
        OPcode = "00101"
    elif(OPword=="IN"):
        OPcode = "00110"
    elif(OPword=="MOV"):
        OPcode = "01000"
    elif(OPword=="SWAP"):
        OPcode = "01001"
    elif(OPword=="ADD"):
        OPcode = "01010"
    elif(OPword=="SUB"):
        OPcode = "01011"
    elif(OPword=="AND"):
        OPcode = "01100"
    elif(OPword=="IADD"):
        OPcode = "01101"
    elif(OPword=="PUSH"):
        OPcode = "10000"
    elif(OPword=="POP"):
        OPcode = "10001"
    elif(OPword=="LDM"):
        OPcode = "10010"
    elif(OPword=="LDD"):
        OPcode = "10011"
    elif(OPword=="STD"):
        OPcode = "10100"
    elif(OPword=="JZ"):
        OPcode = "11000"
    elif(OPword=="JN"):
        OPcode = "11001"
    elif(OPword=="JC"):
        OPcode = "11010"
    elif(OPword=="JMP"):
        OPcode = "11011"
    elif(OPword=="CALL"):
        OPcode = "11100"
    elif(OPword=="RET"):
        OPcode = "11101"
    elif(OPword=="INT"):
        OPcode = "11110"
    elif(OPword=="RTI"):
        OPcode = "11111"
    
    return OPcode
def OPcodeReader(InstLine):
    i = 1
    OPcode = ""
    for x in InstLine: 
        if (x==" " and i<2):
            print("invalid Command")
            return
        elif(x!=" "):
            if(len(OPcode)<1):
                OPcode = x
                i+=1
            else:
                OPcode = OPcode+x
                i+=1
        elif(x==" " and i>=2):
            return [OPcode,i]
def OperandReader(InstLine,Start):
    Operands=[]
    CurrentOper=""
    OperIndex=0
    CharCount=1
    for x in InstLine:
        if(CharCount<=Start):
            CharCount+=1
            continue
        elif(x == " "):
            continue
        elif(x == ","):
            Operands.append(CurrentOper)
            OperIndex+=1
            CurrentOper=""
        elif(x!=";"):
            if(len(CurrentOper)<1):
                CurrentOper=x
            else:
                CurrentOper=CurrentOper+x
        elif(x == ";"):
            Operands.append(CurrentOper)
            OperIndex+=1
            CurrentOper=""
            return Operands

        
        

#capilise all letters in file then rewrite it
with open('test.asm', 'r') as ReqFile:
    y = ReqFile.read().upper()
with open('test.asm', 'w') as out:
    out.write(y)

Reqfile = open('test.asm','r')
count = 0
while True:
    count+=1
    line = Reqfile.readline()
    if not line:
        break
    line = line.strip()
    OPread= OPcodeReader(line)
    OPcode = OPread[0]
    i = OPread[1] - 1
    #i determines when OP ends to let operand reader determine where to start
    Operands = OperandReader(line,i)
    OPcodeBin = OPcodeInterpreter(OPcode)
    print(OPcodeBin)
    print(Operands)
    
Reqfile.close()