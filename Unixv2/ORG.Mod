MODULE ORG; (* N.Wirth, 16.4.2016 / 4.4.2017 / 31.5.2019  Oberon compiler; code generator for RISC*)
    IMPORT SYSTEM, Out, Files, ORS, ORB;
    (*Code generator for Oberon compiler for RISC processor.
         Procedural interface to Parser OSAP; result in array "code".
         Procedure Close writes code-files*)

    CONST WordSize* = 4;
        maxCode = 8000; maxStrx = 2400; maxTD = 160; 
        DEBUG* = 0;

    (*frequently used opcodes*) 
        ldw=77; ldb = 78; stw = 79; stb = 80; ldm = 81; lddata = 82;
        (* L quand l'adresse de retour est dans R15
                R quand l'adresse de dest est dans un registre
                C *)

        (* conditions codes and branch codes *)

(* stcm1 3 : stocke la constante 3 dans l'addresse présente dans l'accumulateur 1 *)
(* stm : stocke la valeur présente dans l'accu 2 dans l'addresse présente dans l'accumulateur 1 *)

(* 0 byte *)
 add    = 0;
 sub    = 1;
 mul    = 2;
 div    = 3;
 abs    = 4;
 fadd   = 5;
 fsub   = 6;
 fmul   = 7;
 fdiv   = 8;
 fabs   = 9;
 mod    = 10;
 neg    = 11;
 odd    = 12;
 floor  = 13;
 flt    = 14;
 in     = 15;
 not    = 16;
 lsl    = 17;
 asr    = 18;
 lsr    = 19;
 ror    = 20;
 and    = 21;
 ann    = 22;
 ior    = 23;
 xor    = 24;
 push   = 25;
 pop1   = 26;
 pop2   = 27;
 ac1to2 = 28;
 ac2to1 = 29;
 ldacc1 = 30;
 ldacc2 = 31;
 stm    = 32;
 inc    = 33;
 inc2   = 34;
 inc4   = 35;
 incp   = 36;
 incp2  = 37;
 incp4  = 38;
 dec    = 39;
 dec2   = 40;
 dec4   = 41;
 decp   = 42;
 leave  = 43;
 decp2  = 44;
 decp4  = 45;
 addp   = 46;
 subp   = 47;
 inclp  = 48;
 exclp  = 49;
 copy   = 50;
 copyw  = 51;
 jumpm  = 52;
 EQ     = 53;
 NE     = 54;
 GT     = 55;
 LT     = 56;
 GE     = 57;
 LE     = 58;
 EQ0    = 59;
 NE0    = 60;
 GE0    = 61;
 GT0    = 62;
 LE0    = 63;
 LT0    = 64;
 SEQ    = 65;
 SNE    = 66;
 SLE    = 67;
 SLT    = 68;
 EQP    = 69;
 put    = 70;
 get    = 71;
 bit    = 72;

 (* 4 bytes *)
 pushc  = 73;
 ldc1   = 74;
 ldc2   = 75;
 stcm1  = 76;
 stcm2  = 77;

 (* 1 byte *)
 enter  = 78;
 pushret= 79;
 JUMP    = 80;
 BEQ0    = 81;
 BNE0    = 82;
 BLT     = 83;
 stlw  = 84;
 stlb  = 85;
 stgw  = 86;
 stgb  = 87;
 ldm1 = 88;
 ldm2 = 89;
 lddata1 = 90;
 lddata2 = 91;
 ldgw1 = 92;
 ldgb1 = 93;
 ldgw2 = 94;
 ldgb2 = 95;
 ldlw1 = 96;
 ldlb1 = 97;
 ldlw2 = 98;
 ldlb2 = 99;
 call  = 100;

 (* 2 bytes *)
 enterl  = 101;
 pushretl = 102;
 JUMPL   = 103;
 BNE0L   = 104;
 BEQ0L   = 105;
 BLTL    = 106;
 stlwl  = 107;
 stlbl  = 108;
 stgwl  = 109;
 stgbl  = 110;
 ldm1l = 111;
 ldm2l = 112;
 lddata1l = 113;
 lddata2l = 114;
 ldgw1l = 115;
 ldgb1l = 116;
 ldgw2l = 117;
 ldgb2l = 118;
 ldlw1l = 119;
 ldlb1l = 120;
 ldlw2l = 121;
 ldlb2l = 122;
 calll = 123;

 (* 4 bits + 12 bits *)
 callext  = 124;
 ldwext1  = 125;
 ldmext1  = 126;
 ldwext2  = 127;
 ldmext2  = 128;

 (* 4 bits + 20 bits *)
 callextl  = 129;
 ldwext1l  = 130;
 ldmext1l  = 131;
 ldwext2l  = 132;
 ldmext2l  = 133;

 (* 3 bits + 13 bits + 4 bytes *)
 TRAP  = 134;

 (* 4 bytes + 1 byte *)
 stlcw  = 135;
 stlcb  = 136;
 stgcw  = 137;
 stgcb  = 138;

 (* 4 bytes + 2 bytes *)
 stlcwl  = 139;
 stlcbl  = 140;
 stgcwl  = 141;
 stgcbl  = 142;


 SYSCALL = 143;


        TYPE  Ptr* = POINTER TO Exit;
            Exit* = RECORD
                label*: INTEGER;
                next*: Ptr
            END;

         Item* = RECORD
            mode*: INTEGER;
            type*: ORB.Type;
            a*, b*, r: INTEGER;
            rdo*: BOOLEAN;  (*read only*)
            acc*: INTEGER;   (* 1 is the object is in accu1, 2 if it is in accu2, 0 if it is a variable not in a accu yet and -1 if it is a const*)
            push*: INTEGER;   (* position of the object on the stack *)
            rel*: INTEGER;   (* position of the object on the stack *)
            Lseq*: Ptr;
            Lnext*: Ptr;
            Lexit*: Ptr;
            name*: ORS.Ident
         END ;

        INSTRUCTION* = RECORD
          op*: BYTE;
          a*, b*: INTEGER
        END;
            

    (* Item forms and meaning of fields:
        mode    r      a       b
        --------------------------------
        Const   -     value (proc adr)  (immediate value)
        Var     base   off     -               (direct adr)
        Par      -     off0     off1         (indirect adr)
        Reg    regno
        RegI   regno   off     -
        Cond  cond   Fchain  Tchain  *)

    VAR pc*, pcbytes*, varsize*: INTEGER;   (*program counter, data index*)
        tdx, strx: INTEGER;
        entry: INTEGER;   (*main entry point*)
        frame: INTEGER;  (*frame offset changed in SaveRegs and RestoreRegs*)
        fixorgP, fixorgD, fixorgT: INTEGER;   (*origins of lists of locations to be fixed up by loader*)
        codestart: INTEGER;
        version: INTEGER;  (* 0 = RISC-0, 1 = RISC-5 *)
        
        code: ARRAY maxCode OF INSTRUCTION;
        data: ARRAY maxTD OF INTEGER;  (*type descriptors*)
        str: ARRAY maxStrx OF CHAR;

    
    PROCEDURE mm;
    BEGIN
        Out.String("YYYYYYYYYYYYYYY"); Out.Ln;
    END mm;
    
    PROCEDURE WINT(x: INTEGER);
    BEGIN
        Out.Int(x, 3); Out.Ln;
    END WINT;
    
    PROCEDURE WSTR(x: ARRAY OF CHAR);
    BEGIN
        Out.String(x); Out.Ln;
    END WSTR;

    (*instruction assemblers according to formats*)

    PROCEDURE PUT0(op: INTEGER);
    BEGIN
      code[pc].op := op;
      INC(pcbytes);
      Out.Int(pc, 6); INC(pc);
      CASE op OF 
          add     : Out.String(" ADD    ")
        | sub     : Out.String(" SUB    ")
        | mul     : Out.String(" MUL    ")
        | div     : Out.String(" DIV    ")
        | abs     : Out.String(" ABS    ")
        | fadd    : Out.String(" FADD   ")
        | fsub    : Out.String(" FSUB   ")
        | fmul    : Out.String(" FMUL   ")
        | fdiv    : Out.String(" FDIV   ")
        | fabs    : Out.String(" FABS   ")
        | mod     : Out.String(" MOD    ")
        | neg     : Out.String(" NEG    ")
        | odd     : Out.String(" ODD    ")
        | floor   : Out.String(" FLOOR  ")
        | flt     : Out.String(" FLT    ")
        | in      : Out.String(" IN     ")
        | not     : Out.String(" NOT    ")
        | lsl     : Out.String(" LSL    ")
        | asr     : Out.String(" ASR    ")
        | lsr     : Out.String(" LSR    ")
        | ror     : Out.String(" ROR    ")
        | and     : Out.String(" AND    ")
        | ann     : Out.String(" ANN    ")
        | ior     : Out.String(" IOR    ")
        | xor     : Out.String(" XOR    ")
        | push    : Out.String(" PUSH   ")
        | pop1    : Out.String(" POP1   ")
        | pop2    : Out.String(" POP2   ")
        | ac1to2  : Out.String(" AC1TO2 ")
        | ac2to1  : Out.String(" AC2TO1 ")
        | ldacc1  : Out.String(" LDACC1 ")
        | ldacc2  : Out.String(" LDACC2 ")
        | stm     : Out.String(" STM    ")
        | inc     : Out.String(" INC    ")
        | inc2    : Out.String(" INC2   ")
        | inc4    : Out.String(" INC4   ")
        | incp    : Out.String(" INCP   ")
        | incp2   : Out.String(" INCP2  ")
        | incp4   : Out.String(" INCP4  ")
        | dec     : Out.String(" DEC    ")
        | dec2    : Out.String(" DEC2   ")
        | dec4    : Out.String(" DEC4   ")
        | decp    : Out.String(" DECP   ")
        | leave   : Out.String(" LEAVE  ") 
        | decp2   : Out.String(" DECP2  ")
        | decp4   : Out.String(" DECP4  ")
        | addp    : Out.String(" ADDP   ")
        | subp    : Out.String(" SUBP   ")
        | inclp   : Out.String(" INCLP  ")
        | exclp   : Out.String(" EXCLP  ")
        | copy    : Out.String(" COPY   ")
        | copyw   : Out.String(" COPYW  ")
        | jumpm   : Out.String(" JUMPM  ")
        | EQ      : Out.String(" EQ     ")
        | NE      : Out.String(" NE     ")
        | GT      : Out.String(" GT     ")
        | LT      : Out.String(" LT     ")
        | GE      : Out.String(" GE     ")
        | LE      : Out.String(" LE     ")
        | EQ0     : Out.String(" EQ0    ")
        | NE0     : Out.String(" NE0    ")
        | GE0     : Out.String(" GE0    ")
        | GT0     : Out.String(" GT0    ")
        | LE0     : Out.String(" LE0    ")
        | LT0     : Out.String(" LT0    ")
        | SEQ     : Out.String(" SEQ    ")
        | SNE     : Out.String(" SNE    ")
        | SLE     : Out.String(" SLE    ")
        | SLT     : Out.String(" SLT    ")
        | EQP     : Out.String(" EQP    ")
        | put     : Out.String(" PUT    ")
        | get     : Out.String(" GET    ")
        | bit     : Out.String(" BIT    ")
        | SYSCALL : Out.String(" SYSCALL")
      END;
      Out.Ln;
    END PUT0;

    PROCEDURE PUT1(op, ofs: INTEGER);
    BEGIN
        IF op <= ldc2 THEN INC(pcbytes, 5)
        ELSIF (op <= pushret) THEN
            IF ofs < 100H THEN INC(pcbytes, 2)
            ELSE op := op + (pushretl-pushret); INC(pcbytes, 3)
            END
        ELSE
            IF (-128 <= op) & (op <= 127) THEN INC(pcbytes, 2)
            ELSE op := op + (JUMPL-JUMP); INC(pcbytes, 3)
            END
        END;
        code[pc].op := op; code[pc].a := ofs;
        Out.Int(pc, 6);
        CASE op OF
          pushc   : Out.String(" PUSHC    ")
        | ldc1    : Out.String(" LDC1     ")
        | ldc2    : Out.String(" LDC2     ")

        | enter   : Out.String(" ENTER    ") 
        | pushret : Out.String(" PUSHRET  ")

        | JUMP    : Out.String(" JUMP     ")
        | BEQ0    : Out.String(" BEQ0     ")
        | BNE0    : Out.String(" BNE0     ")
        | BLT     : Out.String(" BLT      ")

        | enterl  : Out.String(" ENTERL   ") 
        | pushretl: Out.String(" PUSHRETL ")
        | BNE0L   : Out.String(" BNE0L    ")
        | JUMPL   : Out.String(" JUMPL    ")
        | BEQ0L   : Out.String(" BEQ0L    ")
        | BLTL    : Out.String(" BLTL     ")
        END;
        Out.Int(ofs, 2); Out.Ln;
        INC(pc)
    END PUT1;

    PROCEDURE PUTCall(mod, ofs: INTEGER);
        VAR op: INTEGER;
    BEGIN
        Out.Int(pc, 6);
        IF mod >= 0 THEN
            IF ofs < 100H THEN op := call; INC(pcbytes, 2); Out.String(" CALL +")
            ELSE op := calll; INC(pcbytes, 3); Out.String(" CALLL +")
            END;
            code[pc].a := ofs;
        ELSE
            IF ofs < 4096 (* 2^12 bits *) THEN op := callext; INC(pcbytes, 3); code[pc].a := LSL(-mod, 12) + ofs; Out.String(" CALLEXT ")
            ELSE op := callextl; INC(pcbytes, 4); code[pc].a := LSL(-mod, 20) + ofs; Out.String(" CALLEXTL ")
            END;
            Out.Int(-mod, 2); 
        END;
        Out.Int(ofs, 5); Out.Ln;
        code[pc].op := op; INC(pc)
    END PUTCall;

    PROCEDURE PUTTrap(trapnum, operand: INTEGER);
    BEGIN (*emit format-0 instruction*)
        INC(pcbytes, 7);
        code[pc].op := TRAP;
        Out.Int(pc, 6); Out.String(" TRAP "); Out.Int(trapnum, 6);
        IF trapnum = 1 THEN Out.Int(operand, 3); code[pc].a := LSL(trapnum, 13) + operand
        ELSE code[pc].a := trapnum
        END;
        Out.Ln;
        code[pc].b := ORS.Pos();
        INC(pc)
    END PUTTrap;

    PROCEDURE PUTStoreMem(acc, cst: INTEGER);
    (* we put the const a in the memory address indicated in acc *)
        VAR op: INTEGER;
    BEGIN
        INC(pcbytes, 5);
        Out.Int(pc, 6);
        CASE acc OF
          1 : op := stcm1; Out.String(" STCM1 ")
        | 2 : op := stcm2; Out.String(" STCM2 ")
        END;
        Out.Int(cst, 6); Out.Ln;
        code[pc].op := op; code[pc].a := cst;
        INC(pc)
    END PUTStoreMem;

    PROCEDURE OutLevel(lev: INTEGER);
    BEGIN
      IF lev>0 THEN Out.String("LOC+") ELSE Out.String("GLO+") END
    END OutLevel;

    PROCEDURE PUTStoreLong(op, cst, level, ofs, acc: INTEGER);
    BEGIN (*emit load/store instruction*)
        Out.Int(pc, 6);
        IF acc = -1 THEN
            IF level > 0 THEN
              CASE op OF
                  stw : op := stlcwl; Out.String(" STLCWL ")
                | stb : op := stlcbl; Out.String(" STLCBL ")
              END
            ELSIF level = 0 THEN
              CASE op OF
                  stw : op := stgcwl; Out.String(" STGCWL ")
                | stb : op := stgcbl; Out.String(" STGCBL ")
              END
            END;
            INC(pcbytes, 7);
            code[pc].op := op;
            code[pc].a := cst; code[pc].b := ofs;
            Out.Int(cst, 6);
        ELSE
            IF level > 0 THEN
              CASE op OF
                  stw : op := stlwl; Out.String(" STLWL  ")
                | stb : op := stlbl; Out.String(" STLBL  ")
              END
            ELSIF level = 0 THEN
              CASE op OF
                  stw : op := stgwl; Out.String(" STGWL  ")
                | stb : op := stgbl; Out.String(" STGBL  ")
              END
            END;
            INC(pcbytes, 3);
            code[pc].op := op;
            code[pc].a := ofs;
        END;
        Out.String("   "); OutLevel(level); Out.Int(ofs, 2); 
        Out.Ln; 
        INC(pc)
    END PUTStoreLong;

    PROCEDURE PUTStore(op, cst, level, ofs, acc: INTEGER);
    BEGIN (*emit load/store instruction*)
        IF ofs >= 100H THEN PUTStoreLong(op, cst, level, ofs, acc)
        ELSE
            Out.Int(pc, 6);
            IF acc = -1 THEN
                IF level > 0 THEN
                  CASE op OF
                      stw : op := stlcw ; Out.String(" STLCW  ")
                    | stb : op := stlcb ; Out.String(" STLCB  ")
                  END
                ELSIF level = 0 THEN
                  CASE op OF
                      stw : op := stgcw ; Out.String(" STGCW  ")
                    | stb : op := stgcb ; Out.String(" STGCB  ")
                  END
                END;
                INC(pcbytes, 6);
                code[pc].op := op;
                code[pc].a := cst; code[pc].b := ofs;
                Out.Int(cst, 6);
            ELSE
                IF level > 0 THEN
                  CASE op OF
                      stw : op := stlw ; Out.String(" STLW   ")
                    | stb : op := stlb ; Out.String(" STLB   ")
                  END
                ELSIF level = 0 THEN
                  CASE op OF
                      stw : op := stgw ; Out.String(" STGW   ")
                    | stb : op := stgb ; Out.String(" STGB   ")
                  END
                END;
                INC(pcbytes, 2);
                code[pc].op := op;
                code[pc].a := ofs;
            END;
            Out.String("   "); OutLevel(level); Out.Int(ofs, 2); 
            Out.Ln; 
            INC(pc)
        END
    END PUTStore;

    PROCEDURE PUTLoadExtLong*(op, modnmb, ofs, acc: INTEGER);
    BEGIN
        INC(pcbytes, 4);
        Out.Int(pc, 6);
        IF acc = 1 THEN 
            IF op = ldw THEN op := ldwext1l ELSE op := ldmext1l END;
        ELSE 
            IF op = ldw THEN op := ldwext2l ELSE op := ldmext2l END;
        END;
        code[pc].op := op;
        code[pc].a  := LSL(modnmb, 20) + ofs;
        CASE op OF
          ldwext1l : Out.String(" LDWEXT1L ") 
        | ldmext1l : Out.String(" LDMEXT1L ") 
        | ldwext2l : Out.String(" LDWEXT2L ") 
        | ldmext2l : Out.String(" LDMEXT2L ") 
        END;
        Out.Int(modnmb, 3); Out.Int(ofs, 3); Out.Ln;
        INC(pc)
    END PUTLoadExtLong;

    PROCEDURE PUTLoadExt*(op, modnmb, ofs, acc: INTEGER);
    BEGIN
        IF ofs >= 4096 (* 2^12 bits *) THEN PUTLoadExtLong(op, modnmb, ofs, acc)
        ELSE
            INC(pcbytes, 3);
            Out.Int(pc, 6);
            IF acc = 1 THEN 
                IF op = ldw THEN op := ldwext1 ELSE op := ldmext1 END;
            ELSE 
                IF op = ldw THEN op := ldwext2 ELSE op := ldmext2 END;
            END;
            code[pc].op := op;
            code[pc].a  := LSL(modnmb, 12) + ofs;
            CASE op OF
              ldwext1 : Out.String(" LDWEXT1 ") 
            | ldmext1 : Out.String(" LDMEXT1 ") 
            | ldwext2 : Out.String(" LDWEXT2 ") 
            | ldmext2 : Out.String(" LDMEXT2 ") 
            END;
            Out.Int(modnmb, 3); Out.Int(ofs, 3); Out.Ln;
            INC(pc)
        END
    END PUTLoadExt;

    PROCEDURE PUTLoadLong(op, level, ofs, acc: INTEGER);
    BEGIN (*emit load/store instruction*)
        Out.Int(pc, 6);
        IF op = ldm THEN
          CASE acc OF
              1 : op := ldm1l; Out.String(" LDM1L ")
            | 2 : op := ldm2l; Out.String(" LDM2L ")
          END;
          Out.String("   "); OutLevel(level); Out.Int(ofs, 2)
        ELSIF op = lddata THEN
          CASE acc OF
              1 : op := lddata1l; Out.String(" LDDATA1L ")
            | 2 : op := lddata2l; Out.String(" LDDATA2L ")
          END;
          Out.Int(ofs, 3)
        ELSE
          IF level = 0 (*global*) THEN
            IF acc = 1 THEN 
              CASE op OF
                  ldw : op := ldgw1l; Out.String(" LDGW1L ")
                | ldb : op := ldgb1l; Out.String(" LDGB1L ")
              END
            ELSE
              CASE op OF
                  ldw : op := ldgw2l; Out.String(" LDGW2L ")
                | ldb : op := ldgb2l; Out.String(" LDGB2L ")
              END
            END
          ELSE (*local*)
            IF acc = 1 THEN 
              CASE op OF
                  ldw : op := ldlw1l; Out.String(" LDLW1L ")
                | ldb : op := ldlb1l; Out.String(" LDLB1L ")
              END
            ELSE
              CASE op OF
                  ldw : op := ldlw2l; Out.String(" LDLW2L ")
                | ldb : op := ldlb2l; Out.String(" LDLB2L ")
              END
            END
          END;
          Out.String("   ["); OutLevel(level); Out.Int(ofs, 2); Out.String("]")
        END;
        INC(pcbytes, 3);
        Out.Ln;
        code[pc].op := op;
        code[pc].a := ofs;
        INC(pc)
    END PUTLoadLong;

    PROCEDURE PUTLoad(op, level, ofs, acc: INTEGER);
    BEGIN (*emit load/store instruction*)
        IF level < 0 (* extern *) THEN PUTLoadExt(op, -level, ofs, acc)
        ELSE
            IF ofs >= 100H THEN PUTLoadLong(op, level, ofs, acc) 
            ELSE 
                Out.Int(pc, 6);
                IF op = ldm THEN
                  CASE acc OF
                      1 : op := ldm1; Out.String(" LDM1 ")
                    | 2 : op := ldm2; Out.String(" LDM2 ")
                  END;
                  Out.String("   "); OutLevel(level); Out.Int(ofs, 2)
                ELSIF op = lddata THEN
                  CASE acc OF
                      1 : op := lddata1; Out.String(" LDDATA1 ")
                    | 2 : op := lddata2; Out.String(" LDDATA2 ")
                  END;
                  Out.Int(ofs, 3)
                ELSE
                  IF level = 0 (*global*) THEN
                    IF acc = 1 THEN 
                      CASE op OF
                          ldw : op := ldgw1; Out.String(" LDGW1 ")
                        | ldb : op := ldgb1; Out.String(" LDGB1 ")
                      END
                    ELSE
                      CASE op OF
                          ldw : op := ldgw2; Out.String(" LDGW2 ")
                        | ldb : op := ldgb2; Out.String(" LDGB2 ")
                      END
                    END
                  ELSE (*local*)
                    IF acc = 1 THEN 
                      CASE op OF
                          ldw : op := ldlw1; Out.String(" LDLW1 ")
                        | ldb : op := ldlb1; Out.String(" LDLB1 ")
                      END
                    ELSE
                      CASE op OF
                          ldw : op := ldlw2; Out.String(" LDLW2 ")
                        | ldb : op := ldlb2; Out.String(" LDLB2 ")
                      END
                    END
                  END;
                  Out.String("   ["); OutLevel(level); Out.Int(ofs, 2); Out.String("]")
                END;
                INC(pcbytes, 2);
                Out.Ln;
                code[pc].op := op;
                code[pc].a := ofs;
                INC(pc)
            END
        END
    END PUTLoad;

    PROCEDURE PUTInc(op, a, mem: INTEGER);
    BEGIN (*emit load/store instruction*)
      IF a # 0 THEN
        IF (mem = 1) & (op = add) THEN
          CASE a OF
              1 : PUT0(incp)
            | 2 : PUT0(incp2)
            | 4 : PUT0(incp4)
          END
        ELSIF (mem = 1) & (op = sub) THEN
          CASE a OF
              1 : PUT0(decp)
            | 2 : PUT0(decp2)
            | 4 : PUT0(decp4)
          END
        ELSIF (mem = 0) & (op = add) THEN
          CASE a OF
              1 : PUT0(inc)
            | 2 : PUT0(inc2)
            | 4 : PUT0(inc4)
          END
        ELSIF (mem = 0) & (op = sub) THEN
          CASE a OF
              1 : PUT0(dec)
            | 2 : PUT0(dec2)
            | 4 : PUT0(dec4)
          END
        END
      END
    END PUTInc;

    PROCEDURE PUTRel(op, a, cst: INTEGER; VAR x: Item);
    BEGIN (*emit load/store instruction*)
      IF (a = 0) & (cst = 1) (* constante *) THEN
        CASE op OF
            ORS.eql : PUT0(EQ0); x.rel := EQ0
          | ORS.neq : PUT0(NE0); x.rel := NE0
          | ORS.lss : PUT0(LT0); x.rel := LT0
          | ORS.leq : PUT0(LE0); x.rel := LE0
          | ORS.gtr : PUT0(GT0); x.rel := GT0
          | ORS.geq : PUT0(GE0); x.rel := GE0
        END 
      ELSIF (cst = 0) OR (cst = 1) (* variable or const # 0 *) THEN
        CASE op OF
            ORS.eql : PUT0(EQ); x.rel := EQ
          | ORS.neq : PUT0(NE); x.rel := NE
          | ORS.lss : PUT0(LT); x.rel := LT
          | ORS.leq : PUT0(LE); x.rel := LE
          | ORS.gtr : PUT0(GT); x.rel := GT
          | ORS.geq : PUT0(GE); x.rel := GE
        END 
      ELSIF cst = 2 (* string *) THEN
        CASE op OF
            ORS.eql : PUT0(SEQ); x.rel := SEQ
          | ORS.neq : PUT0(SNE); x.rel := SNE
          | ORS.lss : PUT0(SLT); x.rel := SLT
          | ORS.leq : PUT0(SLE); x.rel := SLE
        END
      END
    END PUTRel;

    PROCEDURE SysCall*(VAR x, y: Item);
    BEGIN
      PUT0(SYSCALL);
    END SysCall;

    (*handling of forward reference, fixups of branch addresses and constant tables*)

    PROCEDURE FixAt*(L0, new: INTEGER);
    BEGIN
      Out.String("; fix instruction at pc="); Out.Int(L0, 2); Out.String(" with value ");
      Out.Int(new, 2); Out.String(" or more precisely: "); Out.Int(new-L0, 3); Out.Ln;
      code[L0].a := new-L0
    END FixAt;

    PROCEDURE FixOr*(L0: INTEGER);
    BEGIN
      PUT1(BNE0, L0+1);
    END FixOr;

    PROCEDURE FixIf*(VAR L0: INTEGER);
    BEGIN
      PUT1(BEQ0, L0+1);
      INC(L0);
    END FixIf;

    PROCEDURE FixList*(p: Ptr);
    BEGIN
      WHILE p # NIL DO 
        IF (p.label # 0) THEN FixAt(p.label, pc)
        ELSIF code[p.label].op = not THEN FixAt(p.label+1, pc) END; 
        p := p.next
      END 
    END FixList;

    PROCEDURE FixNot*(L: INTEGER);
    BEGIN
      Out.String("; fix instruction at pc="); Out.Int(L, 2); Out.String(" with inverse intruction: ");
      IF    code[L].op = EQ  THEN Out.String("EQ  => NE  "); code[L].op := NE
      ELSIF code[L].op = NE  THEN Out.String("NE  => EQ  "); code[L].op := EQ
      ELSIF code[L].op = LT  THEN Out.String("LT  => GE  "); code[L].op := GE
      ELSIF code[L].op = GE  THEN Out.String("GE  => LT  "); code[L].op := LT
      ELSIF code[L].op = LE  THEN Out.String("LE  => GT  "); code[L].op := GT
      ELSIF code[L].op = GT  THEN Out.String("GT  => LE  "); code[L].op := LE
      ELSIF code[L].op = EQ0 THEN Out.String("EQ0 => NE0 "); code[L].op := NE0
      ELSIF code[L].op = NE0 THEN Out.String("NE0 => EQ0 "); code[L].op := EQ0
      ELSIF code[L].op = GE0 THEN Out.String("GE0 => LT0 "); code[L].op := LT0
      ELSIF code[L].op = GT0 THEN Out.String("GT0 => LE0 "); code[L].op := LE0
      ELSIF code[L].op = LE0 THEN Out.String("LE0 => GT0 "); code[L].op := GT0
      ELSIF code[L].op = LT0 THEN Out.String("LT0 => GE0 "); code[L].op := GE0
      ELSIF code[L].op = SEQ THEN Out.String("SEQ => SNE "); code[L].op := SNE
      ELSIF code[L].op = SNE THEN Out.String("SNE => SEQ "); code[L].op := SEQ
      ELSE Out.Ln; Out.String("Finaly nevermind, just add a 'NOT' instruction here"); 
        PUT0(not);
      END; 
      Out.Ln
    END FixNot;

    PROCEDURE Here*(): INTEGER;
    BEGIN RETURN pc
    END Here;

    PROCEDURE JumpExit*;
    BEGIN
      PUT1(JUMP, pc)
    END JumpExit;

    PROCEDURE JumpWhile*(L: INTEGER);
    BEGIN
      JumpExit;
      FixAt(pc-1, L);
    END JumpWhile;

    PROCEDURE JumpRepeat*(p: Ptr; L: INTEGER);
    BEGIN
      WHILE p # NIL DO
        IF (p.label # 0) THEN FixAt(p.label, L) 
        END; 
        p := p.next
      END
    END JumpRepeat;

    (* loading of operands and addresses into registers *)

    PROCEDURE NilCheck;
    BEGIN PUTTrap(4, 0)
    END NilCheck;

    PROCEDURE loadacc(VAR x: Item; acc: INTEGER);
        VAR op: INTEGER;
    BEGIN
        IF x.type.size = 1 THEN op := ldw+1 ELSE op := ldw END;
        IF    (x.acc = 1) & (acc = 2) THEN PUT0(ac1to2)
        ELSIF (x.acc = 2) & (acc = 1) THEN PUT0(ac2to1)
        ELSIF (x.acc # acc) THEN
            IF x.mode = ORB.Const THEN
                IF x.push # 0 THEN 
                    IF acc = 1 THEN PUT0(pop1) ELSE PUT0(pop2) END;
                    x.push := 0;
                ELSE
                    IF x.type.base = NIL THEN
                        IF acc=1 THEN PUT1(ldc1, x.a) ELSE PUT1(ldc2, x.a) END
                    END
                END
            ELSIF x.mode IN {ORB.Var, ORB.Par} THEN
                IF x.push # 0 THEN
                    IF acc = 1 THEN PUT0(pop1)
                    ELSE PUT0(pop2)
                    END;
                    x.push := 0;
                ELSE
                    PUTLoad(op, x.r, x.a, acc)
                END
            END
        END;    
        x.acc := acc
    END loadacc;

    PROCEDURE loadAdr(VAR x: Item; acc: INTEGER);
    BEGIN
        IF x.acc = 0 THEN
            IF x.mode IN {ORB.Var, ORB.Par} THEN PUTLoad(ldm, x.r, x.a, acc)
            ELSE ORS.Mark("address error")
            END ;
        END;
        x.acc := acc
    END loadAdr;

    PROCEDURE LoadAdrxy(VAR x, y: Item);
    BEGIN
        IF (x.acc = -1) OR (x.acc = 0) THEN
            IF y.acc = 0 THEN loadAdr(x, 1); loadAdr(y, 2)
            ELSIF y.acc = 1 THEN PUT0(ac1to2); loadAdr(x, 1)
            ELSIF y.acc = 2 THEN loadAdr(x, 1)
            END
        ELSIF x.acc = 1 THEN
            IF y.acc = 0 THEN loadAdr(y, 2)
            ELSIF y.acc = 1 THEN x.acc := 0; y.acc := 0; loadAdr(x, 1); loadAdr(y, 2)
            END
        ELSE
            IF y.acc = 0 THEN loadAdr(x, 1); loadAdr(y, 2)
            ELSIF y.acc = 1 THEN x.acc := 0; y.acc := 0; loadAdr(x, 1); loadAdr(y, 2)
            END
        END
    END LoadAdrxy;

    PROCEDURE loadTypTagAdr(T: ORB.Type; acc: INTEGER);
        VAR x: Item;
    BEGIN x.mode := ORB.Var; x.a := T.len; x.r := -T.mno; loadAdr(x, acc); x.acc := acc
    END loadTypTagAdr;

    PROCEDURE loadStringAdr(VAR x: Item; acc: INTEGER);
    BEGIN PUTLoad(lddata, x.r, x.a, acc); x.acc := acc;
    END loadStringAdr;

    (* Items: Conversion from constants or from Objects on the Heap to Items on the Stack*)

    PROCEDURE MakeConstItem*(VAR x: Item; typ: ORB.Type; val: INTEGER);
    BEGIN x.mode := ORB.Const; x.type := typ; x.a := val; x.acc := -1; x.rel := 0;
        x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL; x.push := 0;
    END MakeConstItem;

    PROCEDURE MakeRealItem*(VAR x: Item; val: REAL);
    BEGIN x.mode := ORB.Const; x.type := ORB.realType; x.a := SYSTEM.VAL(INTEGER, val); 
        x.acc := -1; x.rel := 0;
        x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL; x.push := 0
    END MakeRealItem;

    PROCEDURE MakeStringItem*(VAR x: Item; len: INTEGER); (*copies string from ORS-buffer to ORG-string array*)
        VAR i: INTEGER;
    BEGIN x.mode := ORB.Const; x.type := ORB.strType; x.a := strx+varsize; x.b := len; i := 0;
        IF strx + len + 4 < maxStrx THEN
            WHILE len > 0 DO str[strx] := ORS.str[i]; INC(strx); INC(i); DEC(len) END ;
            WHILE strx MOD 4 # 0 DO str[strx] := 0X; INC(strx) END
        ELSE ORS.Mark("too many strings")
        END;
        x.acc := -1;
        x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL; x.rel := 0; x.push := 0;
    END MakeStringItem;

    PROCEDURE MakeItem*(VAR x: Item; y: ORB.Object; curlev: INTEGER);
    BEGIN x.mode := y.class; x.type := y.type; x.a := y.val; x.rdo := y.rdo;
        IF y.class = ORB.Par THEN x.b := 0; x.r := 1;
        ELSIF (y.class = ORB.Const) & (y.type.form = ORB.String) THEN x.b := y.lev  (*len*) ;
        ELSE x.r := y.lev
        END ;
        IF (y.lev > 0) & (y.lev # curlev) & (y.class # ORB.Const) THEN ORS.Mark("not accessible ") END;
        IF y.type.form = ORB.Proc THEN x.name := y.name END;
        x.acc := 0; x.rel := 0;
    x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL; x.push := 0;
    END MakeItem;

    (* Code generation for Selectors, Variables, Constants *)

    PROCEDURE Field*(VAR x: Item; y: ORB.Object);   (* x := x.y *)
    BEGIN;
        IF x.mode = ORB.Var THEN
            IF (x.r >= 0) & (x.acc # 1) THEN x.a := x.a + y.val 
            ELSE 
                loadacc(x, 1); IF y.val IN {0, 1, 2, 4} THEN PUTInc(add, y.val, 1) ELSE PUT1(ldc2, y.val); PUT0(addp) END 
            END;
        ELSIF x.mode = ORB.Par THEN x.b := x.b + y.val
        END
    END Field;

    PROCEDURE Index*(VAR x, y: Item);   (* x := x[y] *)
    VAR s, lim: INTEGER;
    BEGIN s := x.type.base.size; lim := x.type.len; 
        IF (y.mode = ORB.Const) & (lim >= 0) THEN 
            IF (y.a < 0) OR (y.a >= lim) THEN ORS.Mark("bad index") END ;
            IF x.mode = ORB.Var THEN
                IF (x.r >= 0) & (x.acc # 1) THEN x.a := y.a*s + x.a;
                ELSE
                    x.a := y.a*s;
                    IF x.a IN {0, 1, 2, 4} THEN PUTInc(add, x.a, 1) ELSE PUT1(ldc2, x.a); PUT0(addp) END;
                    x.a := 0;
                END
            ELSIF x.mode = ORB.Par THEN x.b := y.a * s + x.b
            END
        ELSE 
            IF x.acc = 1 THEN x.push := 1; PUT0(push); x.acc := 0 END; 
            loadacc(y, 1);
            IF lim < 0 THEN
             (*open array*)
                IF x.mode IN {ORB.Var, ORB.Par} THEN PUTLoad(ldw, 1, x.a+4, 2); lim := -1
                ELSE ORS.Mark("error in Index")
                END
            END;
            PUTTrap(1, lim);
            IF s = 4 THEN PUT1(ldc2, 2); PUT0(lsl) ELSIF s > 1 THEN PUT1(ldc2, s); PUT0(mul) END;
            PUT0(ac1to2); 
            IF x.push = 1 THEN PUT0(pop1); x.push := 0; x.acc := 1
            ELSIF x.mode IN {ORB.Var, ORB.Par} THEN
                loadAdr(x, 1)
            END;
            PUT0(addp);
        END;
    END Index;

    PROCEDURE DeRef*(VAR x: Item);
    BEGIN 
        loadAdr(x, 1); PUT0(ldacc1); NilCheck; 
    END DeRef;

    PROCEDURE Q(T: ORB.Type; VAR dcw: INTEGER);
    BEGIN (*one entry of type descriptor extension table*)
        IF T.base # NIL THEN
            Q(T.base, dcw); data[dcw] := (T.mno*1000H + T.len) * 1000H + dcw - fixorgT;
            fixorgT := dcw; INC(dcw)
        END
    END Q;

    PROCEDURE FindPtrFlds(typ: ORB.Type; off: INTEGER; VAR dcw: INTEGER);
        VAR fld: ORB.Object; i, s: INTEGER;
    BEGIN
        IF (typ.form = ORB.Pointer) OR (typ.form = ORB.NilTyp) THEN data[dcw] := off; INC(dcw)
        ELSIF typ.form = ORB.Record THEN
            fld := typ.dsc;
            WHILE fld # NIL DO FindPtrFlds(fld.type, fld.val + off, dcw); fld := fld.next END
        ELSIF typ.form = ORB.Array THEN
            s := typ.base.size;
            FOR i := 0 TO typ.len-1 DO FindPtrFlds(typ.base, i*s + off, dcw) END
        END
    END FindPtrFlds;

    PROCEDURE BuildTD*(T: ORB.Type; VAR dc: INTEGER);
        VAR dcw, k, s: INTEGER;  (*dcw = word address*)
    BEGIN dcw := dc DIV 4; s := T.size; (*convert size for heap allocation*)
        IF s <= 24 THEN s := 32 ELSIF s <= 56 THEN s := 64 ELSIF s <= 120 THEN s := 128
        ELSE s := (s+263) DIV 256 * 256
        END ;
        T.len := dc; data[dcw] := s; INC(dcw);  (*len used as address*)
        k := T.nofpar;   (*extension level!*)
        IF k > 3 THEN ORS.Mark("ext level too large")
        ELSE Q(T, dcw);
            WHILE k < 3 DO data[dcw] := -1; INC(dcw); INC(k) END
        END ;
        FindPtrFlds(T, 0, dcw); data[dcw] := -1; INC(dcw); tdx := dcw; dc := dcw*4;
        IF tdx >= maxTD THEN ORS.Mark("too many record types"); tdx := 0 END
    END BuildTD;

    PROCEDURE TypeTest*(VAR x: Item; T: ORB.Type; varpar, isguard: BOOLEAN);
        VAR tmp: INTEGER;
    BEGIN
        IF T # NIL THEN
            IF varpar THEN PUTLoad(ldw, x.r, x.a+4, 1); PUT0(ldacc1);
                tmp := T.nofpar*4;
                IF tmp IN {0, 1, 2, 4} THEN PUTInc(add, tmp, 1) ELSE PUT1(ldc2, tmp); PUT0(addp) END;
            ELSE 
                loadAdr(x, 1); PUT1(ldc2, 8); PUT0(subp); PUT0(ldacc1);
                tmp := T.nofpar*4;
                IF tmp IN {0, 1, 2, 4} THEN PUTInc(add, tmp, 1) ELSE PUT1(ldc2, tmp); PUT0(addp) END;
                x.acc := 0; x.a := x.a + 8;
            END ;
            loadTypTagAdr(T, 2);  (*tag of T*)
            PUT0(EQP);
            IF isguard THEN PUTTrap(2, 0) END
        END
    END TypeTest;

    (* Code generation for Boolean operators *)

    PROCEDURE CopyPtrs*(VAR x, y: Ptr);
(* x := y + x *)
        VAR Lx, Ly: Ptr;
            tmp: INTEGER;
    BEGIN
        Lx := x; Ly := y;
        IF y # NIL THEN 
            IF x = NIL THEN
                WHILE Ly # NIL DO
                    IF Lx = NIL THEN NEW(Lx); x := Lx ELSE NEW(Lx.next); Lx := Lx.next END; 
                    Lx.label := Ly.label; Ly := Ly.next; 
                END
            ELSE
                WHILE Ly # NIL DO
                    tmp := 0; Lx := x;
                    WHILE Lx.next # NIL DO IF Lx.label = Ly.label THEN tmp := 1 END; Lx := Lx.next END;
                    IF (tmp = 0) & (Lx.label # Ly.label) THEN
                        NEW(Lx.next); Lx := Lx.next; 
                        Lx.label := Ly.label
                    END;
                    Ly := Ly.next;
                END
            END
        END
    END CopyPtrs;
    
    PROCEDURE AddPtr*(VAR x: Ptr; L0: INTEGER);
        VAR Lx: Ptr;
            tmp: INTEGER;
    BEGIN
        IF x = NIL THEN NEW(x); x.label := L0;
        ELSE Lx := x; tmp := 0;
            WHILE Lx.next # NIL DO IF Lx.label = L0 THEN tmp := 1 END; Lx := Lx.next END;
            IF (tmp = 0) & (Lx.label # L0) THEN
                NEW(Lx.next); Lx := Lx.next;
                Lx.label := L0
            END
        END;
    END AddPtr;
    
    PROCEDURE Not*(VAR x: Item);   (* x := ~x *)
        VAR Lcur: Ptr;
    BEGIN
IF DEBUG = 1 THEN Out.String("Not DEB"); Out.Ln; END;
        IF (x.Lseq = NIL) & (x.Lnext = NIL) & (x.Lexit = NIL) THEN
            FixNot(pc-1); 
        ELSE
IF DEBUG = 1 THEN 
Out.String("LSEQ: "); Lcur := x.Lseq; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LNEXT: "); Lcur := x.Lnext; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LEXIT: "); Lcur := x.Lexit; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
END;
            FixList(x.Lseq);
            FixList(x.Lexit);
            x.Lseq := NIL;
            x.Lexit := NIL;
            AddPtr(x.Lseq, pc);
            PUT0(not);
IF DEBUG = 1 THEN
Out.String("After exchange:"); Out.Ln;
Out.String("LSEQ: "); Lcur := x.Lseq; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LNEXT: "); Lcur := x.Lnext; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LEXIT: "); Lcur := x.Lexit; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
END;
        END;
IF DEBUG = 1 THEN Out.String("Not FIN"); Out.Ln; END;
    END Not;

    PROCEDURE SubPtr*(VAR x: Ptr; L0: INTEGER);
        VAR Lx1, Lx2: Ptr;
    BEGIN
        IF x # NIL THEN 
            IF (x.next = NIL) & (x.label = L0) THEN x := NIL 
            ELSIF (x.next # NIL) & (x.label = L0) THEN x := x.next
            ELSIF x.next # NIL THEN Lx1 := x; Lx2 := x.next;
                WHILE (Lx2 # NIL) & (Lx2.label # L0) DO Lx1 := Lx1.next; Lx2 := Lx2.next END;
                IF Lx2 # NIL THEN Lx1.next := Lx2.next END
            END
        END
    END SubPtr;

    PROCEDURE And1*(VAR x: Item);   (* x := x & *)
        VAR tmp: INTEGER;
            Lcur: Ptr;
    BEGIN 
IF DEBUG = 1 THEN Out.String("And1 DEB"); Out.Ln; END;
        tmp := pc-1;
        FixIf(tmp);
        IF tmp # pc-1 THEN FixList(x.Lexit) END;
(*    ELSIF (x.rel = 0) THEN PUT1(BNEQ0, pc) END; *)

        AddPtr(x.Lexit, pc-1);
        SubPtr(x.Lseq, pc-1);

IF DEBUG = 1 THEN
Out.String("LSEQ: "); Lcur := x.Lseq; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LNEXT: "); Lcur := x.Lnext; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LEXIT: "); Lcur := x.Lexit; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;

        Out.String("And1 FIN"); Out.Ln;
END;

    END And1;

    PROCEDURE And2*(VAR x, y: Item);
        VAR Lcur: Ptr;
            tmp: INTEGER;
    BEGIN tmp := 0;
IF DEBUG = 1 THEN
        Out.String("And2 DEB"); Out.Ln;
END;
        x.rel := y.rel;
        CopyPtrs(x.Lseq, y.Lseq);
        CopyPtrs(x.Lnext, y.Lnext);
        CopyPtrs(x.Lexit, y.Lexit);

        CopyPtrs(x.Lnext, x.Lseq); x.Lseq := NIL;

IF DEBUG = 1 THEN
Out.String("LSEQ: "); Lcur := x.Lseq; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LNEXT: "); Lcur := x.Lnext; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LEXIT: "); Lcur := x.Lexit; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
        Out.String("And2 FIN"); Out.Ln;
END;
    END And2;
    

    PROCEDURE Or1*(VAR x: Item);   (* x := x OR *)
        VAR tmp: INTEGER;
            Lcur: Ptr;
    BEGIN

IF DEBUG = 1 THEN Out.String("Or1 DEB"); Out.Ln END;

        tmp := pc;
        FixOr(pc-1);
        IF tmp # pc THEN FixList(x.Lexit) END;
(*    ELSIF x.rel = 0 THEN PUT1(BNE0, pc) END; *)

        AddPtr(x.Lseq, pc-1); 
        SubPtr(x.Lexit, pc-1); 
        CopyPtrs(x.Lnext, x.Lexit); x.Lexit := NIL;

IF DEBUG = 1 THEN 
Out.String("LSEQ: "); Lcur := x.Lseq; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LNEXT: "); Lcur := x.Lnext; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LEXIT: "); Lcur := x.Lexit; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;

        Out.String("Or1 FIN"); Out.Ln;
END;

    END Or1;

    PROCEDURE Or2*(VAR x, y: Item);
        VAR Lcur: Ptr;
            tmp: INTEGER;
    BEGIN tmp := 0;
IF DEBUG = 1 THEN Out.String("Or2 DEB"); Out.Ln; END;

        CopyPtrs(x.Lseq, y.Lseq);
        CopyPtrs(x.Lnext, y.Lnext);
        CopyPtrs(x.Lexit, y.Lexit);

        x.rel := y.rel;

IF DEBUG = 1 THEN
Out.String("LSEQ: "); Lcur := x.Lseq; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LNEXT: "); Lcur := x.Lnext; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
Out.String("LEXIT: "); Lcur := x.Lexit; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;

        Out.String("Or2 FIN"); Out.Ln;
END;

    END Or2;

    (* Code generation for arithmetic operators *)

    PROCEDURE Neg*(VAR x: Item);   (* x := -x *)
    BEGIN 
        IF x.type.form = ORB.Int THEN
            IF x.mode = ORB.Const THEN x.a := -x.a
            ELSE loadacc(x, 1); PUT0(neg)
            END
        ELSIF x.type.form = ORB.Real THEN
            IF x.mode = ORB.Const THEN x.a := x.a + 7FFFFFFFH + 1
            ELSE loadacc(x, 1); PUT0(neg)
            END
        ELSE (*form = Set*)
            IF x.mode = ORB.Const THEN x.a := -x.a-1 
            ELSE loadacc(x, 1); PUT1(ldc2, -1); PUT0(xor)
            END
        END
    END Neg;

    PROCEDURE AddOp*(op: INTEGER; VAR x, y: Item);   (* x := x +- y *)
    BEGIN
        IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
            IF op = ORS.plus THEN x.a := x.a + y.a
            ELSIF op = ORS.minus  THEN x.a := x.a - y.a
            END
        ELSE 
            IF op = ORS.plus THEN op := add ELSE op := sub END;
            IF (y.mode = ORB.Const) & (x.mode # ORB.Const) THEN
                loadacc(x, 1);
                IF y.a IN {0, 1, 2, 4} THEN PUTInc(op, y.a, 0) ELSE loadacc(y, 2); PUT0(op) END
            ELSIF (x.mode = ORB.Const) THEN
(* A VOIR: x := F(j) - j *)
                loadacc(y, 1);
                IF x.a IN {0, 1, 2, 4} THEN PUTInc(op, x.a, 0) ELSE loadacc(x, 2); PUT0(op) END;
                IF op = sub THEN PUT0(neg) END;
                x.acc := 1; y.acc := 2; x.mode := y.mode;
            ELSE
                IF y.acc = 1 THEN PUT0(ac1to2); y.acc := 2
                ELSIF x.acc = 2 THEN PUT0(ac2to1); x.acc := 1
                END;
                loadacc(x, 1); loadacc(y, 2); PUT0(op);
            END
        END
    END AddOp;

    PROCEDURE log2(m: INTEGER; VAR e: INTEGER): INTEGER;
    BEGIN e := 0;
        WHILE ~ODD(m) DO m := m DIV 2; INC(e) END ;
        RETURN m
    END log2;
    
    PROCEDURE MulOp*(VAR x, y: Item);   (* x := x * y *)
        VAR e: INTEGER;
    BEGIN
        IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN x.a := x.a * y.a
        ELSE
            IF (y.mode = ORB.Const) THEN
                IF (y.a >= 2) & (log2(y.a, e) = 1) THEN loadacc(x, 1); PUT1(ldc2, e); PUT0(lsl);
                ELSIF (y.a = 1) THEN loadacc(x, 1)
                ELSIF (y.a = 0) THEN PUT1(ldc1, 0);
                ELSE loadacc(x, 1); PUT1(ldc2, y.a); PUT0(mul)
                END
            ELSIF (x.mode = ORB.Const) THEN
                IF (x.a >= 2) & (log2(x.a, e) = 1) THEN loadacc(y, 1); PUT1(ldc2, e); PUT0(lsl)
                ELSIF (x.a = 1) THEN loadacc(y, 1)
                ELSIF (x.a = 0) THEN PUT1(ldc1, 0)
                ELSE loadacc(y, 1); PUT1(ldc2, x.a); PUT0(mul)
                END;
                x.acc := 1; y.acc := 2; x.mode := y.mode;
            ELSE 
                IF y.acc = 1 THEN PUT0(ac1to2); y.acc := 2
                ELSIF x.acc = 2 THEN PUT0(ac2to1); x.acc := 1
                END;
                loadacc(x, 1); loadacc(y, 2); PUT0(mul)
            END;
        END
    END MulOp;

    PROCEDURE DivOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
        VAR e: INTEGER;
    BEGIN
        IF op = ORS.div THEN
            IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
                IF y.a > 0 THEN x.a := x.a DIV y.a ELSE ORS.Mark("bad divisor") END
            ELSIF (y.mode = ORB.Const) THEN
                IF (y.a >= 2) & (log2(y.a, e) = 1) THEN loadacc(x, 1); PUT1(ldc2, e); PUT0(asr) 
                ELSIF (y.a = 0) THEN ORS.Mark("division by 0")
                ELSIF (y.a = 1) THEN loadacc(x, 1)
                ELSE loadacc(x, 1); PUT1(ldc2, y.a); PUT0(div)
                END
            ELSIF (x.mode = ORB.Const) THEN
                IF (x.a = 0) THEN PUT1(ldc1, 0)
                ELSE loadacc(x, 1); PUTTrap(6, 0) ; loadacc(y, 2); PUT0(div)
                END;
                x.acc := 1; y.acc := 2; x.mode := y.mode;
            ELSE
                IF y.acc = 1 THEN PUT0(ac1to2); y.acc := 2
                ELSIF x.acc = 2 THEN PUT0(ac2to1); x.acc := 1
                END;
                loadacc(x, 1); PUTTrap(6, 0) ; loadacc(y, 2); PUT0(div)
            END
        ELSE (*op = ORS.mod*)
            IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
                IF y.a > 0 THEN x.a := x.a DIV y.a ELSE ORS.Mark("bad modulus") END
            ELSIF (y.mode = ORB.Const) THEN
                IF (y.a = 0) THEN ORS.Mark("division by 0")
                ELSIF (y.a = 1) THEN loadacc(x, 1)
                ELSE loadacc(x, 1); PUT1(ldc2, y.a); PUT0(mod)
                END
            ELSIF (x.mode = ORB.Const) THEN
                IF (x.a = 0) THEN PUT1(ldc1, 0)
                ELSE loadacc(x, 1); PUTTrap(6, 0) ; loadacc(y, 2); PUT0(mod)
                END;
                x.acc := 1; y.acc := 2; x.mode := y.mode;
            ELSE
                IF y.acc = 1 THEN PUT0(ac1to2); y.acc := 2
                ELSIF x.acc = 2 THEN PUT0(ac2to1); x.acc := 1
                END;
                loadacc(x, 1); PUTTrap(6, 0); loadacc(y, 2); PUT0(mod)
            END
        END;
    END DivOp;

    (* Code generation for REAL operators *)

    PROCEDURE RealOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
    BEGIN 
        IF y.acc = 1 THEN PUT0(ac1to2); y.acc := 2
        ELSIF x.acc = 2 THEN PUT0(ac2to1); x.acc := 1
        END;
        loadacc(x, 1); loadacc(y, 2); 
        IF op = ORS.plus THEN PUT0(fadd)
        ELSIF op = ORS.minus THEN PUT0(fsub)
        ELSIF op = ORS.times THEN PUT0(fmul)
        ELSIF op = ORS.rdiv THEN PUT0(fdiv)
        END;
    END RealOp;

    (* Code generation for set operators *)

    PROCEDURE Singleton*(VAR x: Item);  (* x := {x} *)
    BEGIN
        IF x.mode = ORB.Const THEN x.a := LSL(1, x.a) 
        ELSE PUT1(ldc1, 1); loadacc(x, 2); PUT0(lsl);
        x.acc := 1
        END;
    END Singleton;

    PROCEDURE Set*(VAR x, y: Item);   (* x := {x .. y} *)
    BEGIN
        IF (x.mode = ORB.Const) & ( y.mode = ORB.Const) THEN
            IF x.a <= y.a THEN x.a := LSL(2, y.a) - LSL(1, x.a) ELSE x.a := 0 END
        ELSE
            loadacc(x, 1); loadacc(y, 2); PUT0(LT); PUTTrap(7, 0);
            x.acc := 0; y.acc := 0;
            IF (x.mode = ORB.Const) & (y.mode # ORB.Const) THEN
                PUT1(ldc1, -2);
                loadacc(y, 2); PUT0(lsl);
                PUT1(ldc2, LSL(-1, x.a))
            ELSIF (x.mode # ORB.Const) & (y.mode = ORB.Const) THEN
                PUT1(ldc1, -1);
                loadacc(x, 2); PUT0(lsl);
                PUT1(ldc2, LSL(-2, y.a))
            ELSE
                PUT1(ldc1, -2);
                loadacc(y, 2); PUT0(lsl);
                PUT0(push);
                PUT1(ldc1, -1);
                loadacc(x, 2); PUT0(lsl);
                PUT0(pop2);
            END;
            PUT0(xor);
            x.acc := 1; y.acc := 2
        END;
    END Set;

    PROCEDURE In*(VAR x, y: Item);  (* x := x IN y *)
    BEGIN 
        loadacc(x, 2); loadacc(y, 1); PUT0(in); x.acc := 1; x.mode := y.mode;
    END In;

    PROCEDURE SetOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
        VAR xset, yset: SET; (*x.type.form = Set*)
    BEGIN
        IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
            xset := SYSTEM.VAL(SET, x.a); yset := SYSTEM.VAL(SET, y.a);
            IF op = ORS.plus THEN xset := xset + yset
            ELSIF op = ORS.minus THEN xset := xset - yset
            ELSIF op = ORS.times THEN xset := xset * yset
            ELSIF op = ORS.rdiv THEN xset := xset / yset
            END ;
            x.a := SYSTEM.VAL(INTEGER, xset)
        ELSE
            IF y.acc = 1 THEN PUT0(ac1to2); y.acc := 2
            ELSIF x.acc = 2 THEN PUT0(ac2to1); x.acc := 1
            END;
            loadacc(x, 1); loadacc(y, 2);
            IF op = ORS.plus THEN PUT0(ior)
            ELSIF op = ORS.minus THEN PUT0(ann)
            ELSIF op = ORS.times THEN PUT0(and)
            ELSIF op = ORS.rdiv THEN PUT0(xor)
            END ;
        END
    END SetOp;

    (* Code generation for relations *)

    PROCEDURE IntRealRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
    BEGIN
    IF y.mode = ORB.Const THEN
      IF y.acc = 1 THEN
        loadacc(y, 2); loadacc(x, 1);
        PUTRel(op, y.a, 0, x)
      ELSE
        loadacc(x, 1); IF y.a # 0 THEN PUT1(ldc2, y.a) END; 
        PUTRel(op, y.a, 1, x)
      END;
    ELSIF x.mode = ORB.Const THEN 
      IF    op = ORS.lss THEN op := ORS.gtr
      ELSIF op = ORS.leq THEN op := ORS.geq
      ELSIF op = ORS.gtr THEN op := ORS.lss
      ELSIF op = ORS.geq THEN op := ORS.leq
      END; 
      IF x.acc = 1 THEN
        loadacc(x, 2); loadacc(y, 1);
        PUTRel(op, x.a, 0, x)
      ELSE
        loadacc(y, 1); IF x.a # 0 THEN PUT1(ldc2, x.a) END;
        PUTRel(op, x.a, 1, x)
      END;
      x.mode := y.mode
    ELSE
      IF y.acc = 1 THEN PUT0(ac1to2); y.acc := 2
      ELSIF x.acc = 2 THEN PUT0(ac2to1); x.acc := 1
      END;
      loadacc(x, 1); loadacc(y, 2); PUTRel(op, 0, 0, x)
    END
    END IntRealRelation;

    PROCEDURE StringRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
        (*x, y are char arrays or strings*)
    BEGIN
      IF (op = ORS.geq) OR (op = ORS.gtr) THEN
          IF y.type.form = ORB.String THEN loadStringAdr(y, 1) ELSE loadAdr(y, 1) END ;
          IF x.type.form = ORB.String THEN loadStringAdr(x, 2) ELSE loadAdr(x, 2) END ;
          IF op = ORS.geq THEN op := ORS.leq ELSE op := ORS.lss END;
          x.mode := y.mode; x.acc := 1; y.acc := 2;
      ELSE
          IF x.type.form = ORB.String THEN loadStringAdr(x, 1) ELSE loadAdr(x, 1) END ;
          IF y.type.form = ORB.String THEN loadStringAdr(y, 2) ELSE loadAdr(y, 2) END ;
      END;
      PUTRel(op, 0, 2, x);
    END StringRelation;

    (* Code generation of Assignments *)

    PROCEDURE Push*(VAR x: Item);
    BEGIN
        PUT0(push); x.push := 1; x.acc := 0;
    END Push;

    PROCEDURE PushAdd*(VAR x: Item; L0: INTEGER);
    VAR tmp: INTEGER;
    BEGIN
      Out.String("; Add an instruction push between instruction "); Out.Int(L0-1, 2); Out.String(" and instruction "); Out.Int(L0, 2); Out.Ln;
      x.push := 1; x.acc := 0;
      (* now we convert the code table *)
      tmp := pc;
      REPEAT code[tmp] := code[tmp-1]; DEC(tmp) UNTIL tmp = L0; 
      code[tmp].op := push;
      INC(pc);
      INC(pcbytes);
    END PushAdd;

    PROCEDURE StrToChar*(VAR x: Item);
    BEGIN x.type := ORB.charType; DEC(strx, 4); x.a := ORD(str[x.a])
    END StrToChar;

    PROCEDURE Store*(VAR x, y: Item); (* x := y *)
        VAR op: INTEGER;
    BEGIN 
    IF y.type.base # NIL THEN Out.Int(y.type.base.form, 3) END;
        IF x.type.size = 1 THEN op := stb ELSE op := stw END ;
        IF (x.mode = ORB.Par) OR ((x.mode = ORB.Var) & (x.acc = 1)) THEN
            IF y.mode = ORB.Const THEN
(* TODO: PP := P; PP; *)
                loadacc(x, 1);
                PUTStoreMem(1, y.a)
            ELSIF y.mode = ORB.Var THEN
                loadacc(y, 2);
                loadacc(x, 1);
                PUT0(stm);
            ELSIF y.mode = ORB.Par THEN
                loadacc(y, 2);
                PUT0(ldacc2);
                PUT0(stm);
            END;
        ELSIF x.mode = ORB.Var THEN
            IF y.acc # -1 THEN loadacc(y, 1) END;
            PUTStore(op, y.a, x.r, x.a, y.acc)
        ELSE ORS.Mark("bad mode in Store")
        END ;
    END Store;

    PROCEDURE StoreStruct*(VAR x, y: Item); (* x := y, frame = 0 *)
        VAR s: INTEGER;
    BEGIN 
        WSTR("YEEEEEEEEEEEEEEEEEE");

        IF y.type.size # 0 THEN
            IF (x.type.form = ORB.Array) &  (x.type.len > 0) THEN
                IF y.type.len >= 0 THEN 
                    IF x.type.size = y.type.size THEN WINT(y.type.size); s := y.type.base.size; 
                        IF s=1 THEN PUT1(pushc, (y.type.size+3) DIV 4) ELSE PUT1(pushc, y.type.size) END;
                        LoadAdrxy(x, y);
                    ELSE ORS.Mark("different length/size, not implemented")
                    END
                ELSE (*y  open array*) PUTLoad(ldw, y.r, y.a+4, 1); PUT0(push); s := y.type.base.size;  (*element size*)
                WINT(s);
                WINT(x.type.size);
                    IF s = 1 THEN PUT1(ldc1, 3); PUT0(add); PUT1(ldc2, 2); PUT0(asr)
                    ELSIF s # 4 THEN PUT1(ldc2, s DIV 4); PUT0(mul)
                    END ;
                    PUT1(ldc1, (x.type.size+3) DIV 8); PUTTrap(1, -1)
                END
            ELSIF x.type.form = ORB.Record THEN (* Put1a(Mov, RH, 0, x.type.size DIV 4) *)
            ELSE ORS.Mark("inadmissible assignment")
            END ;
            PUT0(copy);
            PUT0(pop2);
        END ;
    END StoreStruct;

    PROCEDURE CopyString*(VAR x, y: Item);  (* x := y *) 
         VAR len: INTEGER;
     BEGIN len := x.type.len;
        IF len >= 0 THEN
            IF len < y.b THEN ORS.Mark("string too long") END
        ELSE PUT1(ldc1, y.b); PUTLoad(ldw, 1, x.a+4, 2); PUTTrap(1, -1) (*open array len, frame = 0*)
        END;
        PUT1(pushc, y.b);
        loadAdr(x, 1);
        loadStringAdr(y, 2);
        PUT0(copy);
        PUT0(pop2);
     END CopyString;
    
    (* Code generation for parameters *)
    
    PROCEDURE OpenArrayParam*(VAR x: Item);
    BEGIN loadAdr(x, 1); PUT0(push);
        IF x.type.len >= 0 THEN PUT1(pushc, x.type.len) ELSE PUTLoad(ldw, x.r, x.a+4, 1); PUT0(push); 
        END ;
    END OpenArrayParam;

    PROCEDURE VarParam*(VAR x: Item; ftype: ORB.Type);
        VAR xmd: INTEGER;
    BEGIN xmd := x.mode; loadAdr(x, 1); PUT0(push);
        IF (ftype.form = ORB.Array) & (ftype.len < 0) THEN (*open array*)
            IF x.type.len >= 0 THEN PUT1(pushc, x.type.len) ELSE PUTLoad(ldw, x.r, x.a+4, 1); PUT0(push); END ;
            
        ELSIF ftype.form = ORB.Record THEN
            IF xmd = ORB.Par THEN PUTLoad(ldw, x.r, x.a+4, 1)  ELSE loadTypTagAdr(x.type, 1) END; PUT0(push)
        END;
    END VarParam;

    PROCEDURE ValueParam*(VAR x: Item);
    BEGIN 
        IF (x.mode = ORB.Const) & (x.type.form # ORB.Proc) THEN IF x.acc = 1 THEN PUT0(push) ELSE PUT1(pushc, x.a) END;
        ELSE
            loadacc(x, 1); PUT0(push);
        END;
    END ValueParam;

    PROCEDURE StringParam*(VAR x: Item);
    BEGIN loadStringAdr(x, 1); PUT0(push); PUT1(pushc, x.b)  (*len*)
    END StringParam;

    (*For Statements*)

    PROCEDURE For0*(VAR x, y: Item);
    BEGIN Store(x, y)
    END For0;
    
    PROCEDURE For1*(VAR x, z: Item);
    BEGIN
        IF x.acc = 1 THEN PUT0(ac1to2); x.acc := 2
        ELSIF z.acc = 2 THEN PUT0(ac2to1); z.acc := 1
        END;
        loadacc(z, 1);
        loadacc(x, 2);
        PUT1(BLT, pc);
        AddPtr(x.Lexit, pc-1);
    END For1;

    PROCEDURE For2*(VAR x, w: Item);
    BEGIN 
        x.acc := 0; 
        loadAdr(x, 1); 
        IF w.mode = ORB.Const THEN
            IF w.a IN {0, 1, 2, 4} THEN PUTInc(add, w.a, 1)
            ELSE PUT1(ldc2, w.a); PUT0(addp) 
            END
        ELSE loadacc(w, 2); PUT0(addp)
        END;
    END For2;

    (* Branches, procedure calls, procedure prolog and epilog *)

    PROCEDURE PrepCall*(VAR x: Item; VAR r: INTEGER);
    BEGIN (*x.type.form = ORB.Proc*)
        PUT1(pushret, pc);
        IF x.mode > ORB.Par THEN loadacc(x, 1) END ;
        r := pc;
    END PrepCall;

    PROCEDURE Call*(VAR x: Item; r: INTEGER);
    BEGIN (*x.type.form = ORB.Proc*)
      PUTCall(x.r, x.a);
      Out.String("; Replace instruction 'PUSHRET @ret<"); Out.Int(r-1, 2); Out.String(">' by instruction 'PUSHRET @ret<"); Out.Int(pc, 2); Out.String(">'"); Out.Ln;
      (* now we convert the code table *)
      code[r].op := pushret;
      code[r].a := pc;
      IF x.type.base.form # ORB.NoTyp THEN x.acc := 1 END;
    END Call;

    PROCEDURE Enter*(parblksize, locblksize: INTEGER; VAR prevframe: INTEGER);
    BEGIN 
        prevframe := frame;
        frame := parblksize;
        IF locblksize # 0 THEN PUT1(enter, locblksize) END;
    END Enter;

    PROCEDURE Return*(form: INTEGER; VAR x: Item; size, prevframe: INTEGER);
    BEGIN
        IF form # ORB.NoTyp THEN loadacc(x, 1) END ;
        PUT0(leave);
        frame := prevframe; 
    END Return;

    (* In-line code procedures*)

    PROCEDURE Increment*(upordown: INTEGER; VAR x, y: Item);
        VAR op, v: INTEGER;
    BEGIN (*frame = 0*)
        IF upordown = 0 THEN op := add ELSE op := sub END ;
        IF x.type = ORB.byteType THEN v := 1 ELSE v := 0 END ;
        IF y.type.form = ORB.NoTyp THEN y.mode := ORB.Const; y.a := 1 END ;
        IF (x.mode = ORB.Var) & (x.r > 0) THEN
            loadAdr(x, 1);
            IF (y.mode = ORB.Const) & (y.type.form # ORB.Proc) & (y.a IN {0, 1, 2, 4}) THEN PUTInc(op, y.a, 1)
            ELSE loadacc(y, 2); 
                IF op=add THEN PUT0(addp) ELSE PUT0(subp) END
            END;
        END;
        x.acc := 1
    END Increment;

    PROCEDURE Include*(inorex: INTEGER; VAR x, y: Item);
        VAR op: INTEGER;
    BEGIN loadAdr(x, 1); 
        IF inorex = 0 THEN op := ior ELSE op := ann END ;
        loadacc(y, 2); 
        IF op = ior THEN PUT0(inclp) ELSE PUT0(exclp) END
    END Include;

    PROCEDURE Assert*(VAR x: Item);
    BEGIN
        PUTTrap(7, 0);
    END Assert; 

    PROCEDURE New*(VAR x: Item);
    BEGIN loadAdr(x, 1); loadTypTagAdr(x.type.base, 1); PUTTrap(0, 0); 
    END New;

    PROCEDURE Pack*(VAR x, y: Item);
        VAR z: Item;
    BEGIN z := x; loadacc(y, 1);
         PUT1(ldc2, 23); PUT0(lsl); PUT0(ac1to2); loadAdr(x, 1); PUT0(addp)
    END Pack;

    PROCEDURE Unpk*(VAR x, y: Item);
        VAR z: Item;
    BEGIN
        IF y.mode = ORB.Const THEN ORS.Mark("argument #2 is not const") END;
        z := x; loadacc(x, 1);
        PUT1(ldc2, 23); PUT0(asr); PUT1(ldc2, 127); PUT0(sub); 
        IF y.r >= 0 THEN PUTStore(stw, 0, 1, y.a, 0) END; 
        PUT1(ldc2, 23); PUT0(lsl); PUT0(ac1to2); loadAdr(x, 1); PUT0(subp); 
    END Unpk;

    PROCEDURE Loadxy(VAR x, y: Item);
    BEGIN
        IF (x.acc = -1) OR (x.acc = 0) THEN
            IF y.acc = 0 THEN loadacc(x, 1); loadacc(y, 2)
            ELSIF y.acc = 1 THEN PUT0(ac1to2); loadacc(x, 1)
            ELSIF y.acc = 2 THEN loadacc(x, 1)
            END
        ELSIF x.acc = 1 THEN
            IF y.acc = 0 THEN loadacc(y, 2)
            ELSIF y.acc = 1 THEN x.acc := 0; y.acc := 0; loadacc(x, 1); loadacc(y, 2)
            END
        ELSE
            IF y.acc = 0 THEN loadacc(x, 1); loadacc(y, 2)
            ELSIF y.acc = 1 THEN x.acc := 0; y.acc := 0; loadacc(x, 1); loadacc(y, 2)
            END
        END
    END Loadxy;


    PROCEDURE Get*(VAR x, y: Item);
    BEGIN Loadxy(x, y); PUT0(get); x.a := 0; PUTStore(stw, 0, y.r, y.a, 1)
    END Get;

    PROCEDURE Put*(VAR x, y: Item);
    BEGIN Loadxy(x, y); PUT0(put); x.type := y.type; x.a := 0;
    END Put;

    PROCEDURE Copy*(VAR x, y, z: Item);
    BEGIN 
        IF z.mode = ORB.Const THEN
            Loadxy(x, y);
            IF z.a > 0 THEN PUT1(pushc, z.a) ELSE ORS.Mark("bad count") END
        ELSE loadacc(z, 1); PUT0(push); Loadxy(x, y); PUTTrap(3, 0);
        END ;
        PUT0(copyw);
        PUT0(pop2);
    END Copy;


    (*In-line code functions*)

    PROCEDURE Abs*(VAR x: Item);
    BEGIN
        IF x.mode = ORB.Const THEN x.a := ABS(x.a)
        ELSE loadacc(x, 1); IF x.type.form = ORB.Real THEN PUT0(fabs) ELSE PUT0(abs) END
        END
    END Abs;

    PROCEDURE Odd*(VAR x: Item);
    BEGIN loadacc(x, 1); PUT0(odd)
    END Odd;

    PROCEDURE Floor*(VAR x: Item);
    BEGIN loadacc(x, 1); PUT0(floor) 
    END Floor;

    PROCEDURE Float*(VAR x: Item);
    BEGIN loadacc(x, 1); PUT0(flt) 
    END Float;

    PROCEDURE Ord*(VAR x: Item);
    BEGIN
        IF x.mode IN {ORB.Var, ORB.Par} THEN loadacc(x, 1) END
    END Ord;

    PROCEDURE Len*(VAR x: Item);
    BEGIN
        IF x.type.len >= 0 THEN
            x.mode := ORB.Const; x.a := x.type.len
        ELSE (*open array*) PUTLoad(ldw, x.r, x.a+4, 1); x.acc := 1
        END 
    END Len;

    PROCEDURE Shift*(fct: INTEGER; VAR x, y: Item);
        VAR op: INTEGER;
    BEGIN loadacc(x, 1);
        IF fct = 0 THEN op := lsl 
        ELSIF fct = 1 THEN op := asr 
        ELSE op := ror END ;
        loadacc(y, 2); 
        PUT0(op);
    END Shift;

    PROCEDURE ADC*(VAR x, y: Item);
    BEGIN AddOp(ORS.plus, x, y)
    END ADC;

    PROCEDURE SBC*(VAR x, y: Item);
    BEGIN AddOp(ORS.minus, x, y)
    END SBC;

    PROCEDURE UML*(VAR x, y: Item);
    BEGIN MulOp(x, y)
    END UML;

    PROCEDURE Bit*(VAR x, y: Item);
    BEGIN
        Loadxy(x, y); PUT0(bit);
    END Bit;

    PROCEDURE Adr*(VAR x: Item);
    BEGIN 
        IF x.mode IN {ORB.Var, ORB.Par} THEN loadAdr(x, 1)
        ELSIF (x.mode = ORB.Const) & (x.type.form = ORB.Proc) THEN loadacc(x, 1)
        ELSIF (x.mode = ORB.Const) & (x.type.form = ORB.String) THEN loadStringAdr(x, 1)
        ELSE ORS.Mark("not addressable")
        END
    END Adr;

    PROCEDURE Open*(v: INTEGER);
    BEGIN pc := 0; tdx := 0; strx := 0; fixorgP := 0; fixorgD := 0; fixorgT := 0;  version := v;
        IF v = 0 THEN pc := 1;
            REPEAT code[pc].op := 0; INC(pc) UNTIL pc = 8
        END
    END Open;

    PROCEDURE SetDataSize*(dc: INTEGER);
      VAR obj: ORB.Object;
    BEGIN varsize := dc;
      obj := ORB.topScope.next;
      WHILE (obj # NIL) DO 
        IF (obj.class = ORB.Const) & (obj.type.form = ORB.String) THEN obj.val := obj.val + varsize END;
        obj := obj.next
      END ;
    END SetDataSize;

    PROCEDURE Header*;
    BEGIN entry := pcbytes;
    END Header;

    PROCEDURE NofPtrs(typ: ORB.Type): INTEGER;
        VAR fld: ORB.Object; n: INTEGER;
    BEGIN
        IF (typ.form = ORB.Pointer) OR (typ.form = ORB.NilTyp) THEN n := 1
        ELSIF typ.form = ORB.Record THEN
            fld := typ.dsc; n := 0;
            WHILE fld # NIL DO n := NofPtrs(fld.type) + n; fld := fld.next END
        ELSIF typ.form = ORB.Array THEN n := NofPtrs(typ.base) * typ.len
        ELSE n := 0
        END ;
        RETURN n
    END NofPtrs;

    PROCEDURE FindPtrs(VAR R: Files.Rider; typ: ORB.Type; adr: INTEGER);
        VAR fld: ORB.Object; i, s: INTEGER;
    BEGIN
        IF (typ.form = ORB.Pointer) OR (typ.form = ORB.NilTyp) THEN Files.WriteInt(R, adr)
        ELSIF typ.form = ORB.Record THEN
            fld := typ.dsc;
            WHILE fld # NIL DO FindPtrs(R, fld.type, fld.val + adr); fld := fld.next END
        ELSIF typ.form = ORB.Array THEN
            s := typ.base.size;
            FOR i := 0 TO typ.len-1 DO FindPtrs(R, typ.base, i*s + adr) END
        END
    END FindPtrs;

    PROCEDURE Init*;
    BEGIN
      pcbytes := 0;
    END Init;

    PROCEDURE Size(name: ORS.Ident): INTEGER;
      VAR len: INTEGER;
    BEGIN
      len := 0;
      WHILE name[len] # 0X DO INC(len) END;
      RETURN len
    END Size;

    PROCEDURE Close*(VAR modid: ORS.Ident; key, nofent: INTEGER);
        VAR obj: ORB.Object;
            i, comsize, nofimps, nofptrs, size, tmp: INTEGER;
            name: ORS.Ident;
            F: Files.File; R: Files.Rider;
            by: BYTE;
            newSF: BOOLEAN;
    BEGIN  (*exit code*) tmp := 0; newSF := TRUE; codestart := 0;
        PUT0(leave);
        obj := ORB.topScope.next; nofimps := 0; comsize := 4; nofptrs := 0;
        WHILE obj # NIL DO
            IF (obj.class = ORB.Mod) & (obj.dsc # ORB.system) THEN INC(nofimps) (*count imports*)
            ELSIF (obj.exno # 0) & (obj.class = ORB.Const) & (obj.type.form = ORB.Proc)
                    & (obj.type.nofpar = 0) & (obj.type.base = ORB.noType) THEN i := 0; (*count commands*)
                WHILE obj.name[i] # 0X DO INC(i) END ;
                i := (i+4) DIV 4 * 4; INC(comsize, i+4)
            ELSIF obj.class = ORB.Var THEN INC(nofptrs, NofPtrs(obj.type))  (*count pointers*)
            END ;
            obj := obj.next
        END ;
        size := varsize + strx + comsize + (pc + nofimps + nofent + nofptrs + 1)*4;  (*varsize includes type descriptors*)
        
        ORB.MakeFileName(name, modid, ".rsc"); (*write code file*)
        F := Files.New(name); Files.Set(R, F, 0); Files.WriteString(R, modid); Files.WriteInt(R, key); Out.Char(CHR(version));
        Files.Write(R, nofimps);
        INC(codestart, Size(modid)+6);
        obj := ORB.topScope.next;
        WHILE (obj # NIL) & (obj.class = ORB.Mod) DO  (*imports*)
            IF obj.dsc # ORB.system THEN Files.WriteString(R, obj(ORB.Module).orgname) END ;
            INC(codestart, Size(obj(ORB.Module).orgname)+1);
            obj := obj.next
        END ;
        Out.Char(0X);
        Files.WriteInt(R, tdx*4); INC(codestart, 4);
        i := 0;
        WHILE i < tdx DO Files.WriteInt(R, data[i]); INC(codestart, 4); INC(i) END ; (*type descriptors*)
        Files.WriteInt(R, varsize - tdx*4);  (*data*)
        Files.WriteInt(R, strx);
        FOR i := 0 TO strx-1 DO Out.Char(str[i]) END ;  (*strings*)
        Files.WriteInt(R, pcbytes);
        Files.WriteInt(R, pc);  (*code len*)
        INC(codestart, 12);

        FOR i := 0 TO pc-1 DO 
          Files.Write(R, code[i].op);
          IF code[i].op > bit THEN
            IF code[i].op <= stcm2 THEN Files.WriteInt(R, code[i].a)
            ELSIF code[i].op <= call THEN Files.Write(R, code[i].a)
            ELSIF code[i].op <= calll THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp)
            ELSIF code[i].op <= ldmext2 THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp);
            ELSIF code[i].op <= ldmext2l THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp); tmp := ASR(code[i].a, 16); Files.Write(R, tmp)
            ELSIF code[i].op = TRAP THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp); Files.WriteInt(R, code[i].b);
            ELSIF code[i].op <= stgcb THEN Files.WriteInt(R, code[i].a); by := code[i].b; Files.Write(R, by) 
            ELSIF code[i].op <= stgcbl THEN Files.WriteInt(R, code[i].a); by := code[i].b; Files.Write(R, by); tmp := ASR(code[i].b, 8); Files.Write(R, tmp)
            END
          END
        END ;  (*program*)

        Out.Char(0X);
        Files.WriteInt(R, nofent); 
        obj := ORB.topScope.next;
        WHILE obj # NIL DO  (*entries*)
            IF obj.exno # 0 THEN
                IF (obj.class = ORB.Const) & (obj.type.form = ORB.Proc) OR (obj.class = ORB.Var) THEN
                    Files.WriteInt(R, obj.val);
                ELSIF obj.class = ORB.Typ THEN
                    IF obj.type.form = ORB.Record THEN Files.WriteInt(R,  obj.type.len MOD 10000H)
                    ELSIF (obj.type.form = ORB.Pointer) & ((obj.type.base.typobj = NIL) OR (obj.type.base.typobj.exno = 0)) THEN
                        Files.WriteInt(R,  obj.type.base.len MOD 10000H)
                    END
                END
            END ;
            obj := obj.next
        END ;
        obj := ORB.topScope.next;
        WHILE obj # NIL DO  (*pointer variables*)
            IF obj.class = ORB.Var THEN FindPtrs(R, obj.type, obj.val) END ;
            obj := obj.next
        END ;
        Files.WriteInt(R, -1);
        Files.WriteInt(R, entry);
        Files.WriteInt(R, codestart);
        Out.Char("O"); Files.Register(F); Files.Close(F)

    END Close;

BEGIN 
END ORG.
