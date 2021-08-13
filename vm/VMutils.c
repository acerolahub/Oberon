#include "VMutils.h"

const int

 SYSCALL  = 0,
 ADD      = 1,
 SUB      = 2,
 MUL      = 3,
 DIV      = 4,
 ABS      = 5,
 NEG      = 6,
 FADD     = 7,
 FSUB     = 8,
 FMUL     = 9,
 FDIV     = 10,
 FABS     = 11,
 FNEG     = 12,
 MOD      = 13,
 ODD      = 14,
 INC      = 15,
 INC2     = 16,
 INC4     = 17,
 INCP     = 18,
 INCP2    = 19,
 INCP4    = 20,
 DEC      = 21,
 DEC2     = 22,
 DEC4     = 23,
 DECP     = 24,
 DECP2    = 25,
 DECP4    = 26,
 ADDP     = 27,
 SUBP     = 28,
 FLOOR    = 29,
 FLOAT    = 30,
 IN       = 31,
 NOT      = 32,
 LSL      = 33,
 ASR      = 34,
 LSR      = 35,
 ROR      = 36,
 AND      = 37,
 ANN      = 38,
 IOR      = 39,
 XOR      = 40,
 PUSH     = 41,
 POP1     = 42,
 POP2     = 43,
 LEAVE    = 44,
 AC1TO2   = 45,
 AC2TO1   = 46,
 LDACC1   = 47,
 LDACC2   = 48,
 STM      = 49,
 INCLP    = 50,
 EXCLP    = 51,
 COPY     = 52,
 COPYW    = 53,
 EQ       = 54,
 NE       = 55,
 GT       = 56,
 LT       = 57,
 GE       = 58,
 LE       = 59,
 EQ0      = 60,
 NE0      = 61,
 GE0      = 62,
 GT0      = 63,
 LE0      = 64,
 LT0      = 65,
 FEQ      = 66,
 FNE      = 67,
 FGT      = 68,
 FLT      = 69,
 FGE      = 70,
 FLE      = 71,
 FEQ0     = 72,
 FNE0     = 73,
 FGE0     = 74,
 FGT0     = 75,
 FLE0     = 76,
 FLT0     = 77,
 SEQ      = 78,
 SNE      = 79,
 SLE      = 80,
 SLT      = 81,
 EQP      = 82,
 PUT      = 83,
 GET      = 84,
 BIT      = 85,
 TRAP     = 86,
 PUSHC    = 87,
 LDC1     = 88,
 LDC2     = 89,
 STCWM    = 90,
 STCBM    = 91,
 PUSHLM   = 92,
 PUSHGM   = 93,
 ENTER    = 94,
 PUSHRET  = 95,
 JUMP     = 96,
 BEQ0     = 97,
 BNE0     = 98,
 BLT      = 99,
 STLW     = 100,
 STLB     = 101,
 STGW     = 102,
 STGB     = 103,
 LDLM1    = 104,
 LDLM2    = 105,
 LDGM1    = 106,
 LDGM2    = 107,
 LDGW1    = 108,
 LDGW2    = 109,
 LDGB1    = 110,
 LDGB2    = 111,
 LDLW1    = 112,
 LDLW2    = 113,
 LDLB1    = 114,
 LDLB2    = 115,
 CALL     = 116,
 CALLEXT  = 117,
 LDWEXT1  = 118,
 LDWEXT2  = 119,
 LDMEXT1  = 120,
 LDMEXT2  = 121,
 STLCB    = 122,
 STGCB    = 123,
 STLCW    = 124,
 STGCW    = 125,
 PUSHLML  = 126,
 PUSHGML  = 127,
 ENTERL   = 128,
 PUSHRETL = 129,
 JUMPL    = 130,
 BEQ0L    = 131,
 BNE0L    = 132,
 BLTL     = 133,
 STLWL    = 134,
 STLBL    = 135,
 STGWL    = 136,
 STGBL    = 137,
 LDLM1L   = 138,
 LDLM2L   = 139,
 LDGM1L   = 140,
 LDGM2L   = 141,
 LDGW1L   = 142,
 LDGW2L   = 143,
 LDGB1L   = 144,
 LDGB2L   = 145,
 LDLW1L   = 146,
 LDLW2L   = 147,
 LDLB1L   = 148,
 LDLB2L   = 149,
 CALLL    = 150,
 CALLEXTL = 151,
 LDWEXT1L = 152,
 LDWEXT2L = 153,
 LDMEXT1L = 154,
 LDMEXT2L = 155,
 STLCBL   = 156,
 STGCBL   = 157,
 STLCWL   = 158,
 STGCWL   = 159;

const int
SOUTCHAR        = 1,
SOUTSTRING      = 2,
SOUTSTRINGLN    = 3,
SOUTINT         = 4,
SOUTINTFORMAT   = 5,
SOUTHEX         = 6,
SOUTREAL        = 7,
SOUTREALFORMAT  = 8,
SOUTLN          = 9;


void instruction(int op, char code[]){
    if     (op == SYSCALL ) strcat(code, "SYSCALL ");
    else if(op == ADD     ) strcat(code, "ADD     ");
    else if(op == SUB     ) strcat(code, "SUB     ");
    else if(op == MUL     ) strcat(code, "MUL     ");
    else if(op == DIV     ) strcat(code, "DIV     ");
    else if(op == ABS     ) strcat(code, "ABS     ");
    else if(op == FADD    ) strcat(code, "FADD    ");
    else if(op == FSUB    ) strcat(code, "FSUB    ");
    else if(op == FMUL    ) strcat(code, "FMUL    ");
    else if(op == FDIV    ) strcat(code, "FDIV    ");
    else if(op == FABS    ) strcat(code, "FABS    ");
    else if(op == MOD     ) strcat(code, "MOD     ");
    else if(op == NEG     ) strcat(code, "NEG     ");
    else if(op == FNEG    ) strcat(code, "FNEG    ");
    else if(op == ODD     ) strcat(code, "ODD     ");
    else if(op == FLOOR   ) strcat(code, "FLOOR   ");
    else if(op == FLOAT   ) strcat(code, "FLOAT   ");
    else if(op == IN      ) strcat(code, "IN      ");
    else if(op == NOT     ) strcat(code, "NOT     ");
    else if(op == LSL     ) strcat(code, "LSL     ");
    else if(op == ASR     ) strcat(code, "ASR     ");
    else if(op == LSR     ) strcat(code, "LSR     ");
    else if(op == ROR     ) strcat(code, "ROR     ");
    else if(op == AND     ) strcat(code, "AND     ");
    else if(op == ANN     ) strcat(code, "ANN     ");
    else if(op == IOR     ) strcat(code, "IOR     ");
    else if(op == XOR     ) strcat(code, "XOR     ");
    else if(op == PUSH    ) strcat(code, "PUSH    ");
    else if(op == POP1    ) strcat(code, "POP1    ");
    else if(op == POP2    ) strcat(code, "POP2    ");
    else if(op == AC1TO2  ) strcat(code, "AC1TO2  ");
    else if(op == AC2TO1  ) strcat(code, "AC2TO1  ");
    else if(op == LDACC1  ) strcat(code, "LDACC1  ");
    else if(op == LDACC2  ) strcat(code, "LDACC2  ");
    else if(op == STM     ) strcat(code, "STM     ");
    else if(op == INC     ) strcat(code, "INC     ");
    else if(op == INC2    ) strcat(code, "INC2    ");
    else if(op == INC4    ) strcat(code, "INC4    ");
    else if(op == INCP    ) strcat(code, "INCP    ");
    else if(op == INCP2   ) strcat(code, "INCP2   ");
    else if(op == INCP4   ) strcat(code, "INCP4   ");
    else if(op == DEC     ) strcat(code, "DEC     ");
    else if(op == DEC2    ) strcat(code, "DEC2    ");
    else if(op == DEC4    ) strcat(code, "DEC4    ");
    else if(op == DECP    ) strcat(code, "DECP    ");
    else if(op == LEAVE   ) strcat(code, "LEAVE   ");
    else if(op == DECP2   ) strcat(code, "DECP2   ");
    else if(op == DECP4   ) strcat(code, "DECP4   ");
    else if(op == ADDP    ) strcat(code, "ADDP    ");
    else if(op == SUBP    ) strcat(code, "SUBP    ");
    else if(op == INCLP   ) strcat(code, "INCLP   ");
    else if(op == EXCLP   ) strcat(code, "EXCLP   ");
    else if(op == COPY    ) strcat(code, "COPY    ");
    else if(op == COPYW   ) strcat(code, "COPYW   ");
    else if(op == EQ      ) strcat(code, "EQ      ");
    else if(op == NE      ) strcat(code, "NE      ");
    else if(op == GT      ) strcat(code, "GT      ");
    else if(op == LT      ) strcat(code, "LT      ");
    else if(op == GE      ) strcat(code, "GE      ");
    else if(op == LE      ) strcat(code, "LE      ");
    else if(op == EQ0     ) strcat(code, "EQ0     ");
    else if(op == NE0     ) strcat(code, "NE0     ");
    else if(op == GE0     ) strcat(code, "GE0     ");
    else if(op == GT0     ) strcat(code, "GT0     ");
    else if(op == LE0     ) strcat(code, "LE0     ");
    else if(op == LT0     ) strcat(code, "LT0     ");
    else if(op == FEQ     ) strcat(code, "FEQ     ");
    else if(op == FNE     ) strcat(code, "FNE     ");
    else if(op == FGT     ) strcat(code, "FGT     ");
    else if(op == FLT     ) strcat(code, "FLT     ");
    else if(op == FGE     ) strcat(code, "FGE     ");
    else if(op == FLE     ) strcat(code, "FLE     ");
    else if(op == FEQ0    ) strcat(code, "FEQ0    ");
    else if(op == FNE0    ) strcat(code, "FNE0    ");
    else if(op == FGE0    ) strcat(code, "FGE0    ");
    else if(op == FGT0    ) strcat(code, "FGT0    ");
    else if(op == FLE0    ) strcat(code, "FLE0    ");
    else if(op == FLT0    ) strcat(code, "FLT0    ");
    else if(op == SEQ     ) strcat(code, "SEQ     ");
    else if(op == SNE     ) strcat(code, "SNE     ");
    else if(op == SLE     ) strcat(code, "SLE     ");
    else if(op == SLT     ) strcat(code, "SLT     ");
    else if(op == EQP     ) strcat(code, "EQP     ");
    else if(op == PUT     ) strcat(code, "PUT     ");
    else if(op == GET     ) strcat(code, "GET     ");
    else if(op == BIT     ) strcat(code, "BIT     ");
    else if(op == PUSHC   ) strcat(code, "PUSHC   ");
    else if(op == LDC1    ) strcat(code, "LDC1    ");
    else if(op == LDC2    ) strcat(code, "LDC2    ");
    else if(op == STCWM   ) strcat(code, "STCWM   ");
    else if(op == STCBM   ) strcat(code, "STCBM   ");
    else if(op == ENTER   ) strcat(code, "ENTER   ");
    else if(op == PUSHRET ) strcat(code, "PUSHRET ");
    else if(op == JUMP    ) strcat(code, "JUMP    ");
    else if(op == BEQ0    ) strcat(code, "BEQ0    ");
    else if(op == BNE0    ) strcat(code, "BNE0    ");
    else if(op == BLT     ) strcat(code, "BLT     ");
    else if(op == STLW    ) strcat(code, "STLW    ");
    else if(op == STLB    ) strcat(code, "STLB    ");
    else if(op == STGW    ) strcat(code, "STGW    ");
    else if(op == STGB    ) strcat(code, "STGB    ");
    else if(op == PUSHLM  ) strcat(code, "PUSHLM  ");
    else if(op == PUSHGM  ) strcat(code, "PUSHGM  ");
    else if(op == LDLM1   ) strcat(code, "LDLM1   ");
    else if(op == LDGM1   ) strcat(code, "LDGM1   ");
    else if(op == LDLM2   ) strcat(code, "LDLM2   ");
    else if(op == LDGM2   ) strcat(code, "LDGM2   ");
    else if(op == LDGW1   ) strcat(code, "LDGW1   ");
    else if(op == LDGB1   ) strcat(code, "LDGB1   ");
    else if(op == LDGW2   ) strcat(code, "LDGW2   ");
    else if(op == LDGB2   ) strcat(code, "LDGB2   ");
    else if(op == LDLW1   ) strcat(code, "LDLW1   ");
    else if(op == LDLB1   ) strcat(code, "LDLB1   ");
    else if(op == LDLW2   ) strcat(code, "LDLW2   ");
    else if(op == LDLB2   ) strcat(code, "LDLB2   ");
    else if(op == CALL    ) strcat(code, "CALL    ");
    else if(op == ENTERL  ) strcat(code, "ENTERL  ");
    else if(op == PUSHRETL) strcat(code, "PUSHRETL");
    else if(op == JUMPL   ) strcat(code, "JUMPL   ");
    else if(op == BNE0L   ) strcat(code, "BNE0L   ");
    else if(op == BEQ0L   ) strcat(code, "BEQ0L   ");
    else if(op == BLTL    ) strcat(code, "BLTL    ");
    else if(op == STLWL   ) strcat(code, "STLWL   ");
    else if(op == STLBL   ) strcat(code, "STLBL   ");
    else if(op == STGWL   ) strcat(code, "STGWL   ");
    else if(op == STGBL   ) strcat(code, "STGBL   ");
    else if(op == PUSHLML ) strcat(code, "PUSHLML ");
    else if(op == PUSHGML ) strcat(code, "PUSHGML ");
    else if(op == LDLM1L  ) strcat(code, "LDLM1L  ");
    else if(op == LDGM1L  ) strcat(code, "LDGM1L  ");
    else if(op == LDLM2L  ) strcat(code, "LDLM2L  ");
    else if(op == LDGM2L  ) strcat(code, "LDGM2L  ");
    else if(op == LDGW1L  ) strcat(code, "LDGW1L  ");
    else if(op == LDGB1L  ) strcat(code, "LDGB1L  ");
    else if(op == LDGW2L  ) strcat(code, "LDGW2L  ");
    else if(op == LDGB2L  ) strcat(code, "LDGB2L  ");
    else if(op == LDLW1L  ) strcat(code, "LDLW1L  ");
    else if(op == LDLB1L  ) strcat(code, "LDLB1L  ");
    else if(op == LDLW2L  ) strcat(code, "LDLW2L  ");
    else if(op == LDLB2L  ) strcat(code, "LDLB2L  ");
    else if(op == CALLL   ) strcat(code, "CALLL   ");
    else if(op == CALLEXT ) strcat(code, "CALLEXT ");
    else if(op == LDWEXT1 ) strcat(code, "LDWEXT1 ");
    else if(op == LDMEXT1 ) strcat(code, "LDMEXT1 ");
    else if(op == LDWEXT2 ) strcat(code, "LDWEXT2 ");
    else if(op == LDMEXT2 ) strcat(code, "LDMEXT2 ");
    else if(op == CALLEXTL) strcat(code, "CALLEXTL");
    else if(op == LDWEXT1L) strcat(code, "LDWEXT1L");
    else if(op == LDMEXT1L) strcat(code, "LDMEXT1L");
    else if(op == LDWEXT2L) strcat(code, "LDWEXT2L");
    else if(op == LDMEXT2L) strcat(code, "LDMEXT2L");
    else if(op == TRAP    ) strcat(code, "TRAP    ");
    else if(op == STLCB   ) strcat(code, "STLCB   ");
    else if(op == STGCB   ) strcat(code, "STGCB   ");
    else if(op == STLCW   ) strcat(code, "STLCW   ");
    else if(op == STGCW   ) strcat(code, "STGCW   ");
    else if(op == STLCBL  ) strcat(code, "STLCBL  ");
    else if(op == STGCBL  ) strcat(code, "STGCBL  ");
    else if(op == STLCWL  ) strcat(code, "STLCWL  ");
    else if(op == STGCWL  ) strcat(code, "STGCWL  ");
    else printf("Bad opcode: %X\n", op);
}

int Size(int op){
    if (op <= BIT)          return 0;
    else if(op <= TRAP)     return 6;
    else if(op <= STCWM)    return 4;
    else if(op <= CALL)     return 1;
    else if(op <= LDMEXT2)  return 2;
    else if(op <= STGCB)    return 2;
    else if(op <= STGCW)    return 5;
    else if(op <= CALLL)    return 2;
    else if(op <= LDMEXT2L) return 3;
    else if(op <= STGCBL)   return 3;
    else if(op <= STGCWL)   return 6;
    else 
        fprintf(stderr, "INSTRUCTION %d UNKNOWN\n", op);
        exit(EXIT_FAILURE);
}

int Read(FILE* file, int nbbytes){
    int result = 0, i = 0;
    unsigned char buffer[nbbytes];
    fread(buffer, 1, nbbytes, file);
    while(i < nbbytes){
        result = (result << 8) + buffer[nbbytes-i-1];
        i++;
    }
    return result;
}

int ReadVM(int pos, int nbytes){
    int result = 0;
    for(int i=pos+nbytes-1; i>=pos; i--) result = (result << 8) + VMTABLE[i];
    return result;
}

int ReadBuf(unsigned char* pos, int nbytes){
    int result = 0;
    for(unsigned char* i=pos+nbytes-1; i>=pos; i--) result = (result << 8) + i[0];
    return result;
}

void Write(int number, int nbbytes, int* pos){
    unsigned char tmp;
    for(int i=0; i<nbbytes; i++){
        tmp = number & 0x000000FF;
        VMTABLE[*pos] = tmp; *pos = *pos+1;
        number = number >> 8;
    }
}

// https://stackoverflow.com/questions/8968363/bit-rotation-in-c
int rightrot(int x, int n) {
    int lowbit;

    if (n < 0) n = 32+n;
    while (n-- > 0) {
        lowbit = x & 1;            /* save low bit */
        x = (x >> 1) & (~0u >> 1); /* shift right by one, and clear the high bit (in case of sign extension) */
        if (lowbit)
            x = x | ~(~0u >> 1);   /* set the high bit if the low bit was set */
    }

    return x;
}

int ReadWord(FILE* file, char word[]){
    int size = 0, tmp = 0;
    tmp = Read(file, 1);
    while(tmp != 0){
        word[size++] = tmp;
        tmp = Read(file, 1);
    }
    word[size] = 0;
    return size;
}

void AddModuleCode(char name[]){
    MODULES[searchMod(name)].pos_code = posVM;
}

void AddModuleDecl(char name[]){
    MODULES[searchMod(name)].pos_decl = posVM;
}

void WriteVM(int nbyte, unsigned char buffer[]){
    for(int i=0; i<nbyte; i++) VMTABLE[posVM++] = buffer[i];
}

void disassemble(int opcode, unsigned char buffer[], char* disassfile){
    char op[14];
    int size = Size(opcode), tmp, tmp2;
    sprintf(op, "%07d:  %02X ", posVM-1, opcode);
    strcat(disassfile, op);
    instruction(opcode, disassfile);
    if(opcode > BIT) {
        if(opcode == TRAP){
            tmp = ReadBuf(buffer, 2);
            printf("%d = tmp\n", tmp);
            tmp2 = tmp  & 0x1FFF;
            if (tmp2 == 8191) tmp2 = -1;
            else if (tmp2 == 8190) tmp2 = -2;
            sprintf(disassfile+sizestring(disassfile), " %3d %4d ", tmp>>13, tmp2);
            tmp = ReadBuf(buffer+2, 4);
            sprintf(op, "%08X", tmp);
        }
        else if(opcode <= STCWM){
            strcat(disassfile, " ");
            tmp = ReadBuf(buffer, 4);
            sprintf(op, "%08X", tmp);
        }
        else if(opcode <= CALL){
            strcat(disassfile, "       ");
            sprintf(op, "%02X", buffer[0]);
        }
        else if(opcode <= LDMEXT2){
            strcat(disassfile, "     ");
            tmp = ReadBuf(buffer, 2);
            sprintf(op, "%08X", tmp);
        }
        else if(opcode <= STGCB){
            strcat(disassfile, "       ");
            sprintf(op, "%02X", buffer[0]);
            strcat(disassfile, op);
            strcat(disassfile, "       ");
            sprintf(op, "%02X", buffer[1]);
        }
        else if(opcode <= STGCW){
            strcat(disassfile, " ");
            tmp = ReadBuf(buffer, 4);
            sprintf(op, "%08X", tmp);
            strcat(disassfile, op);
            sprintf(op, " %02X", buffer[4]);
        }
        else if(opcode <= CALLL){
            strcat(disassfile, "     ");
            tmp = ReadBuf(buffer, 2);
            sprintf(op, "%04X", tmp);
        }
        else if(opcode <= LDMEXT2L){
            strcat(disassfile, "   ");
            tmp = ReadBuf(buffer, 3);
            sprintf(op, "%04X", tmp);
        }
        else if(opcode <= STGCBL){
            strcat(disassfile, "       ");
            sprintf(op, "%02X", buffer[0]);
            strcat(disassfile, op);
            tmp = ReadBuf(buffer+1, 2);
            sprintf(op, "     %04X", tmp);
        }
        else if(opcode <= STGCWL){
            strcat(disassfile, " ");
            tmp = ReadBuf(buffer, 4);
            sprintf(op, "%08X", tmp);
            strcat(disassfile, op);
            tmp = ReadBuf(buffer+1, 2);
            sprintf(op, "     %04X", tmp);
        }
        else printf("Bad opcode: %X\n", opcode);
        strcat(disassfile, op);
    }
}

void DeclLoading(FILE* in_file, char modname[]){
    int td, tmp, varsize, strx;

    AddModuleDecl(modname);
    // type descriptor
    td = Read(in_file, 4);
    for(int i=0; i < td/4; i++) Write(Read(in_file, 4), 4, &posVM);

    // variables
    varsize = Read(in_file, 4);
    Write(0, varsize, &posVM);

    // strx
    strx = Read(in_file, 4);

    for(int i=0; i < strx; i++) Write(Read(in_file, 1), 1, &posVM);

}

void CodeLoading(FILE* file, int pc, int disass, char* modname){
    char* file_contents, *disassfile = NULL;
    unsigned char opcode;
    int i=0, nbytes;

    file_contents = (char*)malloc(1000);

    if(disass == 1) disassfile = (char*)malloc(40*pc);

    AddModuleCode(modname);

    while(i<pc){
        fread(file_contents, 1, 1, file);
        WriteVM(1, file_contents);

        opcode = file_contents[0];
        nbytes = Size(opcode);

        // operands
        fread(file_contents, nbytes, 1, file);

        if (disass == 1) {
            disassemble(opcode, file_contents, disassfile);
            strcat(disassfile, "\n");
        }
        WriteVM(nbytes, file_contents);

        i++;
    }

    if(disass == 1 ) {
        printf("%s", disassfile);
        free(disassfile);
    }
    free(file_contents);
}

void displayMod(){
    printf("List of loaded modules:\n");
    for(int i=0; i<nbmod; i++){
        printf("Module %s: Decl = %d; Code = %d; IMPORTS: ", MODULES[i].name, MODULES[i].pos_decl, MODULES[i].pos_code);
        for(int j=0; j<MODULES[i].nbmod; j++) printf("%s ", MODULES[i].listmod[j]);
        printf("\n");
    }
}

int searchMod(char* mod){
    int pos = -1;
    for(int i=0; i<nbmod; i++) {
        if(strcmp(MODULES[i].name, mod) == 0) {
            pos = i; 
            break;
        }
    }
    return pos;
}

void initVM(){
    VMVAR.ACCU1 = 0;
    VMVAR.ACCU2 = 0;
    VMVAR.RSP = VMLEN;
    VMVAR.RBP = VMLEN;
}

void addtracemem(int max){
    char* op, *optmp = (char*)malloc(30);
    int start = MODULES[searchMod(MODULE)].pos_decl, end = MODULES[searchMod(MODULE)].pos_code, tmp;
    tmp = (end-start % 16 != 0) ? end-start + (16 - (end-start)%16) : end-start;
    max = tmp > max ? max : tmp;
    op = (char*)malloc((max/16)*46+10);
    end = max + start;

    sprintf(optmp, "MEMORY: "); strcpy(op, optmp); strcat(op, "\0");
    for(int i=start; i<end; i++) {
        if((i-start)%16 == 0) {sprintf(optmp, "\n%08d: ", i); strcat(op, optmp);}
        else if((i-start)%4 == 0) {sprintf(optmp, " "); strcat(op, optmp);}
        sprintf(optmp, "%02X", VMTABLE[i]); strcat(op, optmp);
    }
    fwrite(op, sizestring(op), 1, TRACEFILE);
    free(op);
    free(optmp);
}

void addtrace(){
    char* op = (char*)malloc(100);
    sprintf(op, "ACCU1: %d\nACCU2: %d\nRSP: %d\nRBP: %d\nPC: %d\n\0", VMVAR.ACCU1, VMVAR.ACCU2, VMVAR.RSP, VMVAR.RBP, VMVAR.PC);
    fwrite(op, sizestring(op), 1, TRACEFILE);
    addtracemem(80);


    fprintf(TRACEFILE, "\n");
    addtracestack(5);
    fprintf(TRACEFILE, "\n\n");

    free(op);
}

void addtracestack(int max){
    char* op = (char*)malloc(max*400), *optmp = (char*)malloc(40);
    int size, tmp;
    sprintf(optmp, "STACK: "); strcpy(op, optmp); strcat(op, "\0");
    if(VMVAR.RSP == VMLEN) strcat(op, "(EMPTY)");
    else {
        size = (max*30) > VMLEN - VMVAR.RSP + 8 ? VMLEN - VMVAR.RSP + 8 : max*30;

        size = (VMVAR.RSP+size < VMLEN) ? VMVAR.RSP+size : VMLEN;

        for(int i=VMVAR.RSP; i<size; i++) {
            if((i-VMVAR.RSP)%4 == 0) {
                tmp = (i - VMVAR.RBP);
                if (tmp >= 0) 
                    sprintf(optmp, "\nRBP + %2d: ", tmp);
                else
                    sprintf(optmp, "\nRBP - %2d: ", -tmp);
                strcat(op, optmp);
            }
            sprintf(optmp, "%02X", VMTABLE[i]); strcat(op, optmp);
        }
    }
    fwrite(op, sizestring(op), 1, TRACEFILE);

    free(op);
    free(optmp);
}

void Load(char* module, int disass){

    char* filename = (char*)malloc(16);
    char** imports;

    int nofimps, i, td, pc, nbbytes;
    char buffer[maxlength];

    strcpy(MODULES[nbmod].name, module); strcat(MODULES[nbmod].name, "\0");
    nbmod++;

    sprintf(filename, "%s.rsc", module);
    FILE* in_file = fopen(filename, "rb");
    if (!in_file) {
        perror("fopen");
    printf("%s is missing\n", filename);
        exit(EXIT_FAILURE);
    }

    struct stat sb;
    if (stat(filename, &sb) == -1) {
        perror("stat");
        exit(EXIT_FAILURE);
    }

    fseek(in_file, 0, SEEK_SET);
    ReadWord(in_file, buffer);

    Read(in_file, 4);  // we read the key

    // nbr of imported modules
    nofimps = Read(in_file, 1);
    imports = (char**)malloc(nofimps*sizeof(char*));

    i = 0;
    while(i<nofimps){
        // Charger les modules importés
        ReadWord(in_file, buffer);
        imports[i] = (char*)malloc(sizestring(buffer)+1);
        strcpy(imports[i], buffer); strcat(imports[i], "\0");
        if(searchMod(buffer) == -1) Load(imports[i], 0);
        i++;
    }

    DeclLoading(in_file, module);
    MODULES[searchMod(module)].nbmod = nofimps;
    MODULES[searchMod(module)].listmod = imports;

    // bytesnbr
    nbbytes = Read(in_file, 4);
    printf("\nnbbytes = %d\n", nbbytes);

    // pc number
    pc = Read(in_file, 4);
    printf("\npc = %d\n", pc);

    // code loading
    strcpy(MODULE, module); strcat(MODULE, "\0");
    CodeLoading(in_file, pc, disass, module);
    
    displayMod();

    fseek(in_file, sb.st_size-4, SEEK_SET);
    MODULES[searchMod(module)].init_start = Read(in_file, 4) + MODULES[searchMod(module)].pos_code;
    MODULES[searchMod(module)].init_end = posVM;
    printf("END OF CODE for module %s: %d\n", module, posVM);


    Run(MODULES[searchMod(module)].init_start, MODULES[searchMod(module)].init_end);

    MODULES[searchMod(module)].nbmod = 0;

    for(i=0; i<nofimps; i++) free(imports[i]);
    free(imports);
    free(filename);
    fclose(in_file);
}

int sizestring(char* string){
    int i=0;
    while(string[i] != '\0') i++;
    return i;
}

void ReadStringVM(char* string, int start){
    int op1 = 0;
    while(VMTABLE[start+op1] != 0) op1++;
    string = (char*)malloc(op1+1);
    for(int i=0; i<=op1; i++) string[i] = VMTABLE[start+i];
}

int jumpinstructions(int start, int nbins){
    int end;
    if(nbins < 0){
        int tmp = MODULES[searchMod(MODULE)].pos_code, nbrins=0;
        for(int i=tmp; i<start; i+=Size(VMTABLE[i])+1){
            nbrins++;
        }
        return jumpinstructions(tmp, nbrins+nbins);
    }
    else{
        end = start;
        for(int i=0; i<nbins; i++){
            end += Size(VMTABLE[end]) + 1;
        }
    }
    return end;
}

void Run(int init_start, int init_end){
    char *opstr = (char*)malloc(100), *string1, *string2, buffer[6];
    int op, op1, op2, tmp, prev, prevRBP, retadr;
    union FLOATDATA float1, float2, float3;
    char *prevMODULE = (char *)malloc(100);

    signed char sop;
    
    for(VMVAR.PC=init_start; VMVAR.PC<init_end;){
        prev = VMVAR.PC;
        op = VMTABLE[VMVAR.PC];
        if     (op == SYSCALL ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            if     (VMVAR.ACCU1 == SOUTCHAR) {
                printf("%c", ReadVM(VMVAR.RSP, 4));
                VMVAR.RSP += 4;
            }
            else if(VMVAR.ACCU1 == SOUTSTRING) {
                printf("%s", VMTABLE + ReadVM(VMVAR.RSP, 4));
                VMVAR.RSP += 4;
            }
            else if(VMVAR.ACCU1 == SOUTSTRINGLN) {
                printf("%s\n", VMTABLE + ReadVM(VMVAR.RSP, 4));
                VMVAR.RSP += 4;
            }
            else if(VMVAR.ACCU1 == SOUTINT     ) {
                printf("%d", ReadVM(VMVAR.RSP, 4));
                VMVAR.RSP += 4;
            }
            else if(VMVAR.ACCU1 == SOUTINTFORMAT){
                int format = ReadVM(VMVAR.RSP, 4);
                int integer = ReadVM(VMVAR.RSP+4, 4);
                string1 = (char*)malloc(10);
                strcpy(string1, "%");
                sprintf(string1+1, "%d", format);
                strcat(string1, "d");
                printf(string1, integer);
                free(string1);
                VMVAR.RSP += 8;
            }
            else if(VMVAR.ACCU1 == SOUTHEX     ) {
                printf("0x%X", ReadVM(VMVAR.RSP, 4));
                VMVAR.RSP += 4;
            }
            else if(VMVAR.ACCU1 == SOUTREAL    ) {
                float1.i = ReadVM(VMVAR.RSP, 4);
                printf("%f", float1.f);
                VMVAR.RSP += 4;
            }
            else if(VMVAR.ACCU1 == SOUTREALFORMAT) {
                int format = ReadVM(VMVAR.RSP, 4);
                float1.i = ReadVM(VMVAR.RSP+4, 4);
                string1 = (char*)malloc(10);
                strcpy(string1, "%");
                sprintf(string1+1, "%d", format);
                strcat(string1, "f");
                printf(string1, float1.f);
                free(string1);
                VMVAR.RSP += 8;
            }
            else if(VMVAR.ACCU1 == SOUTLN      ) {
                printf("\n");
            }
        }
        else if(op == ADD     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 += VMVAR.ACCU2;
        }
        else if(op == SUB     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 -= VMVAR.ACCU2;
        }
        else if(op == MUL )     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 *= VMVAR.ACCU2;
        }
        else if(op == DIV )     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            if(VMVAR.ACCU2 == 0) {
                perror("Division by 0");
                exit(EXIT_FAILURE);
            }
            else VMVAR.ACCU1 /= VMVAR.ACCU2;
        }
        else if(op == ABS )     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            if (VMVAR.ACCU1 < 0) VMVAR.ACCU1 = -VMVAR.ACCU1;
        }
        else if(op == FADD)     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            float3.f = float1.f + float2.f;
            VMVAR.ACCU1 = float3.i;
        }
        else if(op == FSUB)     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            float3.f = float1.f - float2.f;
            VMVAR.ACCU1 = float3.i;
        }
        else if(op == FMUL)     ;
        else if(op == FDIV)     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            if(VMVAR.ACCU2 == 0) {
                perror("Division by 0");
                exit(EXIT_FAILURE);
            }
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            float3.f = float1.f / float2.f;
            VMVAR.ACCU1 = float3.i;
        }
        else if(op == FABS)     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            if (float1.f < 0) {
                float1.f = -float1.f;
                VMVAR.ACCU1 = float1.i;
            }
        }
        else if(op == MOD )     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 %= VMVAR.ACCU2;
        }
        else if(op == NEG )     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = -VMVAR.ACCU1;
        }
        else if(op == FNEG)     {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float1.f = -float1.f;
            VMVAR.ACCU1 = float1.i;
        }
        else if(op == ODD     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = VMVAR.ACCU1 % 2 == 1;
        }
        else if(op == FLOOR   ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float1.i = floor(float1.f);
            VMVAR.ACCU1 = float1.i;
        }
        else if(op == FLOAT   ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.f = VMVAR.ACCU1;
            VMVAR.ACCU1 = float1.i;
        }
        else if(op == IN      ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = (VMVAR.ACCU1 >> VMVAR.ACCU2) % 2;
        }
        else if(op == NOT     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = 1-VMVAR.ACCU1;
        }
        else if(op == LSL     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = VMVAR.ACCU1 << VMVAR.ACCU2;
        }
        else if(op == ASR     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = VMVAR.ACCU1 >> VMVAR.ACCU2;
        }
        else if(op == LSR     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = (unsigned int)VMVAR.ACCU1 >> VMVAR.ACCU2;
        }
        else if(op == ROR     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = rightrot(VMVAR.ACCU1, VMVAR.ACCU2);
        }
        else if(op == AND     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = VMVAR.ACCU1 & VMVAR.ACCU2;
        }
        else if(op == ANN     ) ;
        else if(op == IOR     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = VMVAR.ACCU1 | VMVAR.ACCU2;
        }
        else if(op == XOR     ) ;
        else if(op == PUSH    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            tmp = VMVAR.RSP;
            tmp -= 4;
            Write(VMVAR.ACCU1, 4, &tmp);
            VMVAR.RSP -= 4;
        }
        else if(op == POP1    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = ReadVM(VMVAR.RSP, 4);
            VMVAR.RSP += 4;
        }
        else if(op == POP2    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU2 = ReadVM(VMVAR.RSP, 4);
            VMVAR.RSP += 4;
        }
        else if(op == AC1TO2  ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU2 = VMVAR.ACCU1;
        }
        else if(op == AC2TO1  ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = VMVAR.ACCU2;
        }
        else if(op == LDACC1  ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1 = ReadVM(VMVAR.ACCU1, 4);
        }
        else if(op == LDACC2  ) ;
        else if(op == STM     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = VMVAR.ACCU1;
            Write(VMVAR.ACCU2, 4, &op1);
        }
        else if(op == INC     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1++;
        }
        else if(op == INC2    ) ;
        else if(op == INC4    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1+=4;
        }
        else if(op == INCP    ) {
            tmp = VMVAR.ACCU1;
            op1 = ReadVM(tmp, 4);
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            Write(op1+1, 4, &tmp);
        }
        else if(op == INCP2   ) {
            tmp = VMVAR.ACCU1;
            op1 = ReadVM(tmp, 4);
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            Write(op1+2, 4, &tmp);
        }
        else if(op == INCP4   ) ;
        else if(op == DEC     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            VMVAR.ACCU1--;
        }
        else if(op == DEC2    ) ;
        else if(op == DEC4    ) ;
        else if(op == DECP    ) {
            tmp = VMVAR.ACCU1;
            op1 = ReadVM(tmp, 4);
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            Write(op1-1, 4, &tmp);
        }
        else if(op == LEAVE   ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = ReadVM(VMVAR.RBP, 4);
            VMVAR.PC = ReadVM(VMVAR.RBP + 4, 4);
            VMVAR.RSP = VMVAR.RBP + 8;
            VMVAR.RBP = op1;
            strcpy(MODULE, prevMODULE);
        }
        else if(op == DECP2   ) ;
        else if(op == DECP4   ) ;
        else if(op == ADDP    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = VMVAR.ACCU1;
            op2 = ReadVM(op1, 4);
            op2 += VMVAR.ACCU2;
            Write(op2, 4, &op1);
        }
        else if(op == SUBP    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = VMVAR.ACCU1;
            op2 = ReadVM(op1, 4);
            op2 -= VMVAR.ACCU2;
            Write(op2, 4, &op1);
        }
        else if(op == INCLP   ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = VMVAR.ACCU1;
            op2 = ReadVM(op1, 4);
            tmp = 1 << VMVAR.ACCU2;
            Write(op2 | tmp, 4, &op1);
        }
        else if(op == EXCLP   ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = VMVAR.ACCU1;
            op2 = ReadVM(op1, 4);
            tmp = 1 << VMVAR.ACCU2;
            if (tmp <= op2) Write(op2 & ~tmp, 4, &op1);
        }
        else if(op == COPY    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op2 = 0;
            while(VMTABLE[VMVAR.ACCU2+op2] != 0) op2++;
            for(int i=0; i<=op2; i++) VMTABLE[VMVAR.ACCU1+i] = VMTABLE[VMVAR.ACCU2+i];
        }
        else if(op == COPYW   ) {
            op1 = ReadVM(VMVAR.RSP, 4);
            for(int i=0; i<op1; i++) VMTABLE[VMVAR.ACCU1+i] = VMTABLE[VMVAR.ACCU2+i];
        }
        else if(op == EQ      ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 == VMVAR.ACCU2;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == NE      ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 != VMVAR.ACCU2;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == GT      ) ;
        else if(op == LT      ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 < VMVAR.ACCU2;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == GE      ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 >= VMVAR.ACCU2;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == LE      ) ;
        else if(op == EQ0     ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 == 0;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == NE0     ) ;
        else if(op == GE0     ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 >= 0;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == GT0     ) ;
        else if(op == LE0     ) ;
        else if(op == LT0     ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 < 0;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == FEQ     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            VMVAR.ACCU1 = float1.f == float2.f;
        }
        else if(op == FNE     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            VMVAR.ACCU1 = float1.f != float2.f;
        }
        else if(op == FGT     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            VMVAR.ACCU1 = float1.f > float2.f;
        }
        else if(op == FLT     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            VMVAR.ACCU1 = float1.f < float2.f;
        }
        else if(op == FGE     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            VMVAR.ACCU1 = float1.f >= float2.f;
        }
        else if(op == FLE     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            float2.i = VMVAR.ACCU2;
            VMVAR.ACCU1 = float1.f <= float2.f;
        }
        else if(op == FEQ0    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            VMVAR.ACCU1 = float1.f == 0;
        }
        else if(op == FNE0    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            VMVAR.ACCU1 = float1.f != 0;
        }
        else if(op == FGE0    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            VMVAR.ACCU1 = float1.f >= 0;
        }
        else if(op == FGT0    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            VMVAR.ACCU1 = float1.f > 0;
        }
        else if(op == FLE0    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            VMVAR.ACCU1 = float1.f <= 0;
        }
        else if(op == FLT0    ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            float1.i = VMVAR.ACCU1;
            VMVAR.ACCU1 = float1.f < 0;
        }
        else if(op == SEQ     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = 0;
            while(VMTABLE[VMVAR.ACCU1+op1] != 0) op1++;
            string1 = (char*)malloc(op1+1);
            for(int i=0; i<=op1; i++) string1[i] = VMTABLE[VMVAR.ACCU1+i];
            op2 = 0;
            while(VMTABLE[VMVAR.ACCU2+op2] != 0) op2++;
            string2 = (char*)malloc(op2+1);
            for(int i=0; i<=op2; i++) string2[i] = VMTABLE[VMVAR.ACCU2+i];
            VMVAR.ACCU1 = strcmp(string1, string2) == 0;
            free(string1);
            free(string2);
        }
        else if(op == SNE     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = 0;
            while(VMTABLE[VMVAR.ACCU1+op1] != 0) op1++;
            string1 = (char*)malloc(op1+1);
            for(int i=0; i<=op1; i++) string1[i] = VMTABLE[VMVAR.ACCU1+i];
            op2 = 0;
            while(VMTABLE[VMVAR.ACCU2+op2] != 0) op2++;
            string2 = (char*)malloc(op2+1);
            for(int i=0; i<=op2; i++) string2[i] = VMTABLE[VMVAR.ACCU2+i];
            VMVAR.ACCU1 = strcmp(string1, string2) != 0;
            free(string1);
            free(string2);
        }
        else if(op == SLE     ) ;
        else if(op == SLT     ) {
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
            op1 = 0;
            while(VMTABLE[VMVAR.ACCU1+op1] != 0) op1++;
            string1 = (char*)malloc(op1+1);
            for(int i=0; i<=op1; i++) string1[i] = VMTABLE[VMVAR.ACCU1+i];
            op2 = 0;
            while(VMTABLE[VMVAR.ACCU2+op2] != 0) op2++;
            string2 = (char*)malloc(op2+1);
            for(int i=0; i<=op2; i++) string2[i] = VMTABLE[VMVAR.ACCU2+i];
            VMVAR.ACCU1 = strcmp(string1, string2) < 0;
            free(string1);
            free(string2);
        }
        else if(op == EQP     ) {
            VMVAR.ACCU1 = VMVAR.ACCU1 == VMVAR.ACCU2;
            sprintf(opstr, "Instruction %d: %02x\n\0", VMVAR.PC, VMTABLE[VMVAR.PC]);
        }
        else if(op == PUT     ) ;
        else if(op == GET     ) ;
        else if(op == BIT     ) ;
        else if(op == PUSHC   ) {
            op1 = VMVAR.RSP-4;
            op2 = ReadVM(VMVAR.PC+1, 4);

            Write(op2, 4, &op1);
            VMVAR.RSP = VMVAR.RSP - 4;

            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op2);
            
        }
        else if(op == LDC1    ) {
            op1 = 0;
            for(int i=4; i>=1; i--) op1 = (op1 << 8) + VMTABLE[VMVAR.PC+i];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            VMVAR.ACCU1 = op1;
        }
        else if(op == LDC2    ) {
            op1 = 0;
            for(int i=4; i>=1; i--) op1 = (op1 << 8) + VMTABLE[VMVAR.PC+i];
            sprintf(opstr, "Instruction %d: %02x %8X\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            VMVAR.ACCU2 = op1;
        }
        else if(op == STCWM   ) {
            op1 = 0;
            for(int i=4; i>=1; i--) op1 = (op1 << 8) + VMTABLE[VMVAR.PC+i];
            op2 = VMVAR.ACCU1;
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            Write(op1, 4, &op2);
        }
        else if(op == STCBM   ) {
            op1 = ReadVM(VMVAR.PC+1, 1);
            op2 = VMVAR.ACCU1;
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            Write(op1, 1, &op2);
        }
        else if(op == ENTER   ) {
            op1 = ReadVM(VMVAR.PC+1, 1);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            VMVAR.RSP -= op1;
        }
        else if(op == PUSHRET ) {
            // We push the ret addr on the stack

            op1 = ReadVM(VMVAR.PC+1, 1);
            retadr = jumpinstructions(VMVAR.PC, op1);

                op1 = VMVAR.RSP - 4;
                Write(retadr, 4, &op1);
                op1 -= 8;
                Write(VMVAR.RBP, 4, &op1);
                VMVAR.RSP = VMVAR.RSP - 8;
                prevRBP = VMVAR.RSP;

            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], retadr);
            
        }
        else if(op == JUMP    ) {
            sop = ReadVM(VMVAR.PC+1, 1);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], sop);
            VMVAR.PC = jumpinstructions(VMVAR.PC, sop);
        }
        else if(op == BEQ0    ) {
            sop = ReadVM(VMVAR.PC+1, 1);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], sop);
            if(VMVAR.ACCU1 == 0) VMVAR.PC = jumpinstructions(VMVAR.PC, sop);
        }
        else if(op == BNE0    ) {
            sop = ReadVM(VMVAR.PC+1, 1);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], sop);
            if(VMVAR.ACCU1 == 1) VMVAR.PC = jumpinstructions(VMVAR.PC, sop);
        }
        else if(op == BLT     ) {
            sop = ReadVM(VMVAR.PC+1, 1);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], sop);
            if(VMVAR.ACCU1 < VMVAR.ACCU2) VMVAR.PC = jumpinstructions(VMVAR.PC, sop);
        }
        else if(op == STLW    ) {
            op1 = VMVAR.RBP - VMTABLE[VMVAR.PC + 1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], VMTABLE[VMVAR.PC+1]);

            Write(VMVAR.ACCU1, 4, &op1);
        }
        else if(op == STLB    ) ;
        else if(op == STGW    ) {
            op1 = MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC + 1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            Write(VMVAR.ACCU1, 4, &op1);
        }
        else if(op == STGB    ) {
            op1 = MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC + 1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);

            Write(VMVAR.ACCU1, 1, &op1);
        }
        else if(op == PUSHLM  ) ;
        else if(op == PUSHGM  ) {
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC + 1]);
            op1 = VMVAR.RSP - 4;
            Write(MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC + 1], 4, &op1);
            VMVAR.RSP -= 4;
        }
        else if(op == LDLM1   ) ;
        else if(op == LDGM1   ) {
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU1 = MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1];
        }
        else if(op == LDLM2   ) ;
        else if(op == LDGM2   ) {
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU2 = MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1];
        }
        else if(op == LDGW1   ) {
            op1 = ReadVM(VMVAR.PC+1, 1);
            op1 = ReadVM(op1+MODULES[searchMod(MODULE)].pos_decl, 4);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU1 = op1;
        }
        else if(op == LDGB1   ) {
            op1 = VMTABLE[VMVAR.PC+1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU1 = VMTABLE[MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1]];
        }
        else if(op == LDGW2   ) {
            op1 = 0;
            for(int i=3; i>=0; i--) {
                tmp = MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC + 1] + i;
                op1 = (op1 << 8) + VMTABLE[tmp];
            }
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], MODULES[searchMod(MODULE)].pos_decl + VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU2 = op1;
        }
        else if(op == LDGB2   ) ;
        else if(op == LDLW1   ) {
            op1 = VMTABLE[VMVAR.PC+1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU1 = ReadVM(VMVAR.RBP-op1, 4);
        }
        else if(op == LDLB1   ) {
            op1 = VMTABLE[VMVAR.PC+1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU1 = ReadVM(VMVAR.RBP-op1, 4);
        }
        else if(op == LDLW2   ) {
            op1 = VMTABLE[VMVAR.PC+1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], VMTABLE[VMVAR.PC+1]);
            VMVAR.ACCU2 = ReadVM(VMVAR.RBP-op1, 4);
        }
        else if(op == LDLB2   ) ;
        else if(op == CALL    ) {
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], MODULES[searchMod(MODULE)].pos_code + VMTABLE[VMVAR.PC+1]);
            VMVAR.RBP = prevRBP;
            
            VMVAR.PC = VMTABLE[VMVAR.PC+1] + MODULES[searchMod(MODULE)].pos_code;
            strcpy(prevMODULE, MODULE);
        }
        else if(op == ENTERL  ) ;
        else if(op == PUSHRETL) ;
        else if(op == JUMPL   ) ;
        else if(op == BNE0L   ) ;
        else if(op == BEQ0L   ) ;
        else if(op == BLTL    ) ;
        else if(op == STLWL   ) ;
        else if(op == STLBL   ) ;
        else if(op == STGWL   ) {
            op1 = MODULES[searchMod(MODULE)].pos_decl + ReadVM(VMVAR.PC + 1, 2);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            Write(VMVAR.ACCU1, 4, &op1);
        }
        else if(op == STGBL   ) ;
        else if(op == PUSHLML ) ;
        else if(op == PUSHGML ) ;
        else if(op == LDLM1L  ) ;
        else if(op == LDGM1L  ) {
            op1 = ReadVM(VMVAR.PC+1, 2);
            VMVAR.ACCU1 = MODULES[searchMod(MODULE)].pos_decl + op1;
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], VMVAR.ACCU1);
        }
        else if(op == LDLM2L  ) ;
        else if(op == LDGM2L  ) {
            op1 = ReadVM(VMVAR.PC+1, 2);
            VMVAR.ACCU2 = MODULES[searchMod(MODULE)].pos_decl + op1;
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], VMVAR.ACCU2);
        }
        else if(op == LDGW1L  ) {
            op1 = ReadVM(VMVAR.PC+1, 2);
            VMVAR.ACCU1 = VMTABLE[MODULES[searchMod(MODULE)].pos_decl + op1];
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], VMVAR.ACCU1);
        }
        else if(op == LDGB1L  ) ;
        else if(op == LDGW2L  ) ;
        else if(op == LDGB2L  ) ;
        else if(op == LDLW1L  ) {
            op1 = ReadVM(VMVAR.PC+1, 2);
            sprintf(opstr, "Instruction %d: %02x %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1);
            VMVAR.ACCU1 = ReadVM(VMVAR.RBP-op1, 4);
        }
        else if(op == LDLB1L  ) ;
        else if(op == LDLW2L  ) ;
        else if(op == LDLB2L  ) ;
        else if(op == CALLL   ) ;
        else if(op == CALLEXT ) {
            op1 = ReadVM(VMVAR.PC + 1, 2);
            tmp = op1 >> 12;
            op2 = op1 & 0xFFF;
            tmp = searchMod(MODULES[searchMod(MODULE)].listmod[tmp-1]);
            sprintf(opstr, "Instruction %d: %02x %5d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], tmp, op2+MODULES[tmp].pos_code);
            VMVAR.PC = op2 + MODULES[tmp].pos_code;
            VMVAR.RBP = prevRBP;
            strcpy(prevMODULE, MODULE);
            strcpy(MODULE, MODULES[tmp].name);
        }
        else if(op == LDWEXT1 ) {
            displayMod();
            op1 = ReadVM(VMVAR.PC + 1, 2);
            tmp = op1 >> 12;
            op2 = op1 & 0xFFF;
            tmp = searchMod(MODULES[searchMod(MODULE)].listmod[tmp-1]);
            sprintf(opstr, "Instruction %d: %02x %5d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], tmp, op2);

            
            VMVAR.ACCU1 = ReadVM(MODULES[tmp].pos_decl + op2, 4);
        }
        else if(op == LDMEXT1 ) {
            op1 = ReadVM(VMVAR.PC + 1, 2);
            tmp = op1 >> 12;
            op2 = op1 & 0xFFF;
            tmp = searchMod(MODULES[searchMod(MODULE)].listmod[tmp-1]);
            sprintf(opstr, "Instruction %d: %02x %5d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], tmp, op2);

            
            VMVAR.ACCU1 = MODULES[tmp].pos_decl + op2, 4;
        }
        else if(op == LDWEXT2 ) {
            op1 = ReadVM(VMVAR.PC + 1, 2);
            tmp = op1 >> 12;
            op2 = op1 & 0xFFF;
            tmp = searchMod(MODULES[searchMod(MODULE)].listmod[tmp-1]);
            sprintf(opstr, "Instruction %d: %02x %5d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], tmp, op2);
            
            VMVAR.ACCU2 = ReadVM(MODULES[tmp].pos_decl + op2, 4);
        }
        else if(op == LDMEXT2 ) ;
        else if(op == CALLEXTL) ;
        else if(op == LDWEXT1L) ;
        else if(op == LDMEXT1L) ;
        else if(op == LDWEXT2L) ;
        else if(op == LDMEXT2L) ;
        else if(op == TRAP    ) {
            int trapnum;

            op1 = ReadVM(VMVAR.PC+1, 2);
            trapnum = op1 >> 13;


            op2 = ReadVM(VMVAR.PC+3, 4);

            if(trapnum == 1) sprintf(opstr, "Instruction %d: %02x %3d %4d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], trapnum, op1 & 0x1FFF, op2);
            else sprintf(opstr, "Instruction %d: %02x %3d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1>>13, op2);

            if(trapnum == 1){
                tmp = op1 & 0x1FFF;
                if ((tmp == 8191) & (VMVAR.ACCU1 > VMVAR.ACCU2)){
                    // -1 on 13 bits
                    printf("index array out of range at position -1 %d\n", op2);
                    exit(EXIT_FAILURE);
                }
                else if ((tmp == 8190) & (VMVAR.ACCU1 != VMVAR.ACCU2)){
                    // -2 on 13 bits
                    printf("index array out of range at position -2 %d\n", op2);
                    exit(EXIT_FAILURE);
                }
                else if(VMVAR.ACCU1 > tmp){
                    printf("index array out of range at position > %d\n", op2);
                    exit(EXIT_FAILURE);
                }
            }
            else if(trapnum == 7){
                
                if(VMVAR.ACCU1 == 0){
                    fprintf(stderr, "ASSERT ERROR AT POSITION: %d\n", op2);
                    exit(EXIT_FAILURE);
                } 
            }
        }
        else if(op == STLCB   ) {
            op1 = VMTABLE[VMVAR.PC+1];
            op2 = VMVAR.RBP - VMTABLE[VMVAR.PC+2];
            sprintf(opstr, "Instruction %d: %02x %8d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1, op2);
            Write(op1, 1, &op2);
        }
        else if(op == STGCB   ) {
            op1 = VMTABLE[VMVAR.PC+1];
            op2 = VMTABLE[VMVAR.PC+2];
            sprintf(opstr, "Instruction %d: %02x %8d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1, MODULES[searchMod(MODULE)].pos_decl+op2);
            VMTABLE[MODULES[searchMod(MODULE)].pos_decl + op2] = op1;
        }
        else if(op == STLCW   ) {
            op1 = ReadVM(VMVAR.PC+1, 4);
            op2 = VMVAR.RBP - VMTABLE[VMVAR.PC+5];
            sprintf(opstr, "Instruction %d: %02x %8d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1, op2);
            Write(op1, 4, &op2);
        }
        else if(op == STGCW   ) {
            op1 = 0;
            for(int i=4; i>=1; i--) op1 = (op1 << 8) + VMTABLE[VMVAR.PC+i];
            op2 = VMTABLE[VMVAR.PC+5];

            sprintf(opstr, "Instruction %d: %02x %8d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1, op2+MODULES[searchMod(MODULE)].pos_decl);

            for(int i=0; i<4; i++) VMTABLE[MODULES[searchMod(MODULE)].pos_decl + op2 + i] = VMTABLE[VMVAR.PC+i+1];
        }
        else if(op == STLCBL  ) ;
        else if(op == STGCBL  ) ;
        else if(op == STLCWL  ) ;
        else if(op == STGCWL  ) {
            op1 = ReadVM(VMVAR.PC+1, 4);
            op2 = MODULES[searchMod(MODULE)].pos_decl + ReadVM(VMVAR.PC+5, 2);
            sprintf(opstr, "Instruction %d: %02x %8d %8d\n", VMVAR.PC, VMTABLE[VMVAR.PC], op1, op2);
            Write(op1, 4, &op2);
        }

        if (prev == VMVAR.PC) VMVAR.PC = VMVAR.PC + Size(op)+1;
        fwrite(opstr, sizestring(opstr), 1, TRACEFILE);
        addtrace();
    }
    free(opstr);
    free(prevMODULE);
}
