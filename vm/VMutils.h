#ifndef VMUTILS_H
#define VMUTILS_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <inttypes.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>

/* header file contents go here */

extern const int 

 SYSCALL  ,
 ADD      ,
 SUB      ,
 MUL      ,
 DIV      ,
 ABS      ,
 NEG      ,
 FADD     ,
 FSUB     ,
 FMUL     ,
 FDIV     ,
 FABS     ,
 FNEG     ,
 MOD      ,
 ODD      ,
 INC      ,
 INC2     ,
 INC4     ,
 INCP     ,
 INCP2    ,
 INCP4    ,
 DEC      ,
 DEC2     ,
 DEC4     ,
 DECP     ,
 DECP2    ,
 DECP4    ,
 ADDP     ,
 SUBP     ,
 FLOOR    ,
 FLOAT    ,
 IN       ,
 NOT      ,
 LSL      ,
 ASR      ,
 LSR      ,
 ROR      ,
 AND      ,
 ANN      ,
 IOR      ,
 XOR      ,
 PUSH     ,
 POP1     ,
 POP2     ,
 LEAVE    ,
 AC1TO2   ,
 AC2TO1   ,
 LDACC1   ,
 LDACC2   ,
 STM      ,
 INCLP    ,
 EXCLP    ,
 COPY     ,
 COPYW    ,
 EQ       ,
 NE       ,
 GT       ,
 LT       ,
 GE       ,
 LE       ,
 EQ0      ,
 NE0      ,
 GE0      ,
 GT0      ,
 LE0      ,
 LT0      ,
 FEQ      ,
 FNE      ,
 FGT      ,
 FLT      ,
 FGE      ,
 FLE      ,
 FEQ0     ,
 FNE0     ,
 FGE0     ,
 FGT0     ,
 FLE0     ,
 FLT0     ,
 SEQ      ,
 SNE      ,
 SLE      ,
 SLT      ,
 EQP      ,
 PUT      ,
 GET      ,
 BIT      ,
 TRAP     ,
 PUSHC    ,
 LDC1     ,
 LDC2     ,
 STCWM    ,
 STCBM    ,
 PUSHLM   ,
 PUSHGM   ,
 ENTER    ,
 PUSHRET  ,
 JUMP     ,
 BEQ0     ,
 BNE0     ,
 BLT      ,
 STLW     ,
 STLB     ,
 STGW     ,
 STGB     ,
 LDLM1    ,
 LDLM2    ,
 LDGM1    ,
 LDGM2    ,
 LDGW1    ,
 LDGW2    ,
 LDGB1    ,
 LDGB2    ,
 LDLW1    ,
 LDLW2    ,
 LDLB1    ,
 LDLB2    ,
 CALL     ,
 CALLEXT  ,
 LDWEXT1  ,
 LDWEXT2  ,
 LDMEXT1  ,
 LDMEXT2  ,
 STLCB    ,
 STGCB    ,
 STLCW    ,
 STGCW    ,
 PUSHLML  ,
 PUSHGML  ,
 ENTERL   ,
 PUSHRETL ,
 JUMPL    ,
 BEQ0L    ,
 BNE0L    ,
 BLTL     ,
 STLWL    ,
 STLBL    ,
 STGWL    ,
 STGBL    ,
 LDLM1L   ,
 LDLM2L   ,
 LDGM1L   ,
 LDGM2L   ,
 LDGW1L   ,
 LDGW2L   ,
 LDGB1L   ,
 LDGB2L   ,
 LDLW1L   ,
 LDLW2L   ,
 LDLB1L   ,
 LDLB2L   ,
 CALLL    ,
 CALLEXTL ,
 LDWEXT1L ,
 LDWEXT2L ,
 LDMEXT1L ,
 LDMEXT2L ,
 STLCBL   ,
 STGCBL   ,
 STLCWL   ,
 STGCWL   ,

SOUTCHAR        ,
SOUTSTRING      ,
SOUTSTRINGLN    ,
SOUTINT         ,
SOUTINTFORMAT   ,
SOUTHEX         ,
SOUTREAL        ,
SOUTREALFORMAT  ,
SOUTLN          ;

#define maxlength 16 
#define VMLEN 262144 // 2^16*4
#define NBMOD 16

 // A linked list node
typedef struct Node {
    int     pos_decl;
    int     pos_code;
    int     init_start;
    int     init_end;
    char    name[maxlength];
    int     nbmod;
    char**  listmod;
} Node;

typedef struct VMvar {
    int ACCU1;
    int ACCU2;
    int RSP;
    int RBP;
    int PC;
} VMvar;

union FLOATDATA {
    int i;
    float f;
};

extern int posVM, nbmod;
extern unsigned char VMTABLE[VMLEN];
extern struct Node MODULES[NBMOD];
extern char* MODULE; 
extern FILE* TRACEFILE;
extern VMvar VMVAR;

void displayMod();

void instruction(int op, char code[]);

int Size(int op);

int Read(FILE* file, int nbbytes);

int ReadVM(int pos, int nbytes);

void Write(int number, int nbbytes, int* pos);

int ReadWord(FILE* file, char word[]);

void AddModuleCode(char name[]);

void AddModuleDecl(char name[]);

void WriteVM(int nbyte, unsigned char buffer[]);

int buffertoint(unsigned char buffer[], int size);

void disassemble(int opcode, unsigned char buffer[], char* disassfile);

void CodeLoading(FILE* file, int pc, int disass, char modname[]);

void DeclLoading(FILE* in_file, char modname[]);

void initVM();

void addtracemem(int);

void addtrace();

void addtracestack(int max);

void Load(char* optarg, int disass);

int sizestring(char* string);

int jumpinstructions(int, int);

int searchMod(char*);

void Run(int, int);

#endif
