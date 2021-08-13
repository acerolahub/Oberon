MODULE ORG; (* N.Wirth, 16.4.2016 / 4.4.2017 / 31.5.2019  Oberon compiler; code generator for RISC*)
    IMPORT SYSTEM, Out, Files, ORS, ORB;
    (*Code generator for Oberon compiler for RISC processor.
         Procedural interface to Parser OSAP; result in array "code".
         Procedure Close writes code-files*)

    CONST WordSize* = 4;
        maxCode = 8000; maxStrx = 2400; maxTD = 160; 
        DEBUG* = 1;

    (*frequently used opcodes*) 
        ldw=77; ldb = 78; stw = 79; stb = 80; ldm = 81;
        (* L quand l'adresse de retour est dans R15
                R quand l'adresse de dest est dans un registre
                C *)

        (* conditions codes and branch codes *)

(* stcm1 3 : stocke la constante 3 dans l'addresse présente dans l'accumulateur 1 *)
(* stm : stocke la valeur présente dans l'accu 2 dans l'addresse présente dans l'accumulateur 1 *)

(* 0 byte *)
 SYSCALL  = 0;
 add      = 1;
 sub      = 2;
 mul      = 3;
 div      = 4;
 abs      = 5;
 neg      = 6;
 fadd     = 7;
 fsub     = 8;
 fmul     = 9;
 fdiv     = 10;
 fabs     = 11;
 fneg     = 12;
 mod      = 13;
 odd      = 14;
 inc      = 15;
 inc2     = 16;
 inc4     = 17;
 incp     = 18;
 incp2    = 19;
 incp4    = 20;
 dec      = 21;
 dec2     = 22;
 dec4     = 23;
 decp     = 24;
 decp2    = 25;
 decp4    = 26;
 addp     = 27;
 subp     = 28;
 floor    = 29;
 float    = 30;
 in       = 31;
 not      = 32;
 lsl      = 33;
 asr      = 34;
 lsr      = 35;
 ror      = 36;
 and      = 37;
 ann      = 38;
 ior      = 39;
 xor      = 40;
 push     = 41;
 pop1     = 42;
 pop2     = 43;
 leave    = 44;
 ac1to2   = 45;
 ac2to1   = 46;
 ldacc1   = 47;
 ldacc2   = 48;
 stm      = 49;
 inclp    = 50;
 exclp    = 51;
 copy     = 52;
 copyw    = 53;
 EQ       = 54;
 NE       = 55;
 GT       = 56;
 LT       = 57;
 GE       = 58;
 LE       = 59;
 EQ0      = 60;
 NE0      = 61;
 GE0      = 62;
 GT0      = 63;
 LE0      = 64;
 LT0      = 65;
 FEQ      = 66;
 FNE      = 67;
 FGT      = 68;
 FLT      = 69;
 FGE      = 70;
 FLE      = 71;
 FEQ0     = 72;
 FNE0     = 73;
 FGE0     = 74;
 FGT0     = 75;
 FLE0     = 76;
 FLT0     = 77;
 SEQ      = 78;
 SNE      = 79;
 SLE      = 80;
 SLT      = 81;
 EQP      = 82;
 put      = 83;
 get      = 84;
 bit      = 85;
 TRAP     = 86;
 pushc    = 87;
 ldc1     = 88;
 ldc2     = 89;
 stcwm    = 90;
 stcbm    = 91;
 pushlm   = 92;
 pushgm   = 93;
 enter    = 94;
 pushret  = 95;
 JUMP     = 96;
 BEQ0     = 97;
 BNE0     = 98;
 BLT      = 99;
 stlw     = 100;
 stlb     = 101;
 stgw     = 102;
 stgb     = 103;
 ldlm1    = 104;
 ldlm2    = 105;
 ldgm1    = 106;
 ldgm2    = 107;
 ldgw1    = 108;
 ldgw2    = 109;
 ldgb1    = 110;
 ldgb2    = 111;
 ldlw1    = 112;
 ldlw2    = 113;
 ldlb1    = 114;
 ldlb2    = 115;
 call     = 116;
 callext  = 117;
 ldwext1  = 118;
 ldwext2  = 119;
 ldmext1  = 120;
 ldmext2  = 121;
 stlcb    = 122;
 stgcb    = 123;
 stlcw    = 124;
 stgcw    = 125;
 pushlml  = 126;
 pushgml  = 127;
 enterl   = 128;
 pushretl = 129;
 JUMPL    = 130;
 BEQ0L    = 131;
 BNE0L    = 132;
 BLTL     = 133;
 stlwl    = 134;
 stlbl    = 135;
 stgwl    = 136;
 stgbl    = 137;
 ldlm1l   = 138;
 ldlm2l   = 139;
 ldgm1l   = 140;
 ldgm2l   = 141;
 ldgw1l   = 142;
 ldgw2l   = 143;
 ldgb1l   = 144;
 ldgb2l   = 145;
 ldlw1l   = 146;
 ldlw2l   = 147;
 ldlb1l   = 148;
 ldlb2l   = 149;
 calll    = 150;
 callextl = 151;
 ldwext1l = 152;
 ldwext2l = 153;
 ldmext1l = 154;
 ldmext2l = 155;
 stlcbl   = 156;
 stgcbl   = 157;
 stlcwl   = 158;
 stgcwl   = 159;

(*
 <= bit:        0 byte
 <= TRAP:       3 bits + 13 bits + 4 bytes
 <= stcwm:      4 bytes
 <= call:       1 byte
 <= ldmext2:    4 bits + 12 bits
 <= stgcb:      1 byte + 1 byte
 <= stgcw:      4 byte + 1 byte
 <= calll:      2 bytes
 <= ldmext2l:   4 bits + 20 bits 
 <= stgcbl:     1 byte + 2 bytes
 <= stgcwl:     4 bytes + 2 bytes
*)


    SOUTCHAR*       = 1;
    SOUTSTRING*     = 2;
    SOUTSTRINGLN*   = 3;
    SOUTINT*        = 4;
    SOUTINTFORMAT*  = 5;
    SOUTHEX*        = 6;
    SOUTREAL*       = 7;
    SOUTREALFORMAT* = 8;
    SOUTLN*         = 9;


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
            acc*: INTEGER;   (* 1 is the object is in accu1, 2 if it is in accu2, 3 if it is on the stack 0 if it is a variable not in a accu, -1 if it is a const*)
            Lseq*: Ptr;
            Lnext*: Ptr;
            Lexit*: Ptr;
            name*: ORS.Ident
         END ;

        INSTRUCTION* = RECORD
          op*: BYTE;
          a*, b*: INTEGER
        END;

        SYSTEMCALLS* = RECORD
            ops*: ARRAY 6 OF Item
        END;
            

    (* Item forms and meaning of fields:
        mode    r      a       b
        --------------------------------
        Const   -     value (proc adr)      (immediate value)
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
        Out.Int(pc, 6); 

        code[pc].op := op;
        INC(pcbytes);
        INC(pc);
        IF    op = SYSCALL THEN Out.String(" SYSCALL ")
        ELSIF op = add     THEN Out.String(" ADD     ")
        ELSIF op = sub     THEN Out.String(" SUB     ")
        ELSIF op = mul     THEN Out.String(" MUL     ")
        ELSIF op = div     THEN Out.String(" DIV     ")
        ELSIF op = abs     THEN Out.String(" ABS     ")
        ELSIF op = fadd    THEN Out.String(" FADD    ")
        ELSIF op = fsub    THEN Out.String(" FSUB    ")
        ELSIF op = fmul    THEN Out.String(" FMUL    ")
        ELSIF op = fdiv    THEN Out.String(" FDIV    ")
        ELSIF op = fabs    THEN Out.String(" FABS    ")
        ELSIF op = mod     THEN Out.String(" MOD     ")
        ELSIF op = neg     THEN Out.String(" NEG     ")
        ELSIF op = fneg    THEN Out.String(" FNEG    ")
        ELSIF op = odd     THEN Out.String(" ODD     ")
        ELSIF op = floor   THEN Out.String(" FLOOR   ")
        ELSIF op = float   THEN Out.String(" FLOAT   ")
        ELSIF op = in      THEN Out.String(" IN      ")
        ELSIF op = not     THEN Out.String(" NOT     ")
        ELSIF op = lsl     THEN Out.String(" LSL     ")
        ELSIF op = asr     THEN Out.String(" ASR     ")
        ELSIF op = lsr     THEN Out.String(" LSR     ")
        ELSIF op = ror     THEN Out.String(" ROR     ")
        ELSIF op = and     THEN Out.String(" AND     ")
        ELSIF op = ann     THEN Out.String(" ANN     ")
        ELSIF op = ior     THEN Out.String(" IOR     ")
        ELSIF op = xor     THEN Out.String(" XOR     ")
        ELSIF op = push    THEN Out.String(" PUSH    ")
        ELSIF op = pop1    THEN Out.String(" POP1    ")
        ELSIF op = pop2    THEN Out.String(" POP2    ")
        ELSIF op = ac1to2  THEN Out.String(" AC1TO2  ")
        ELSIF op = ac2to1  THEN Out.String(" AC2TO1  ")
        ELSIF op = ldacc1  THEN Out.String(" LDACC1  ")
        ELSIF op = ldacc2  THEN Out.String(" LDACC2  ")
        ELSIF op = stm     THEN Out.String(" STM     ")
        ELSIF op = inc     THEN Out.String(" INC     ")
        ELSIF op = inc2    THEN Out.String(" INC2    ")
        ELSIF op = inc4    THEN Out.String(" INC4    ")
        ELSIF op = incp    THEN Out.String(" INCP    ")
        ELSIF op = incp2   THEN Out.String(" INCP2   ")
        ELSIF op = incp4   THEN Out.String(" INCP4   ")
        ELSIF op = dec     THEN Out.String(" DEC     ")
        ELSIF op = dec2    THEN Out.String(" DEC2    ")
        ELSIF op = dec4    THEN Out.String(" DEC4    ")
        ELSIF op = decp    THEN Out.String(" DECP    ")
        ELSIF op = leave   THEN Out.String(" LEAVE   ") 
        ELSIF op = decp2   THEN Out.String(" DECP2   ")
        ELSIF op = decp4   THEN Out.String(" DECP4   ")
        ELSIF op = addp    THEN Out.String(" ADDP    ")
        ELSIF op = subp    THEN Out.String(" SUBP    ")
        ELSIF op = inclp   THEN Out.String(" INCLP   ")
        ELSIF op = exclp   THEN Out.String(" EXCLP   ")
        ELSIF op = copy    THEN Out.String(" COPY    ")
        ELSIF op = copyw   THEN Out.String(" COPYW   ")
        ELSIF op = EQ      THEN Out.String(" EQ      ")
        ELSIF op = NE      THEN Out.String(" NE      ")
        ELSIF op = GT      THEN Out.String(" GT      ")
        ELSIF op = LT      THEN Out.String(" LT      ")
        ELSIF op = GE      THEN Out.String(" GE      ")
        ELSIF op = LE      THEN Out.String(" LE      ")
        ELSIF op = EQ0     THEN Out.String(" EQ0     ")
        ELSIF op = NE0     THEN Out.String(" NE0     ")
        ELSIF op = GE0     THEN Out.String(" GE0     ")
        ELSIF op = GT0     THEN Out.String(" GT0     ")
        ELSIF op = LE0     THEN Out.String(" LE0     ")
        ELSIF op = LT0     THEN Out.String(" LT0     ")
        ELSIF op = FEQ     THEN Out.String(" FEQ     ")
        ELSIF op = FNE     THEN Out.String(" FNE     ")
        ELSIF op = FGT     THEN Out.String(" FGT     ")
        ELSIF op = FLT     THEN Out.String(" FLT     ")
        ELSIF op = FGE     THEN Out.String(" FGE     ")
        ELSIF op = FLE     THEN Out.String(" FLE     ")
        ELSIF op = FEQ0    THEN Out.String(" FEQ0    ")
        ELSIF op = FNE0    THEN Out.String(" FNE0    ")
        ELSIF op = FGE0    THEN Out.String(" FGE0    ")
        ELSIF op = FGT0    THEN Out.String(" FGT0    ")
        ELSIF op = FLE0    THEN Out.String(" FLE0    ")
        ELSIF op = FLT0    THEN Out.String(" FLT0    ")
        ELSIF op = SEQ     THEN Out.String(" SEQ     ")
        ELSIF op = SNE     THEN Out.String(" SNE     ")
        ELSIF op = SLE     THEN Out.String(" SLE     ")
        ELSIF op = SLT     THEN Out.String(" SLT     ")
        ELSIF op = EQP     THEN Out.String(" EQP     ")
        ELSIF op = put     THEN Out.String(" PUT     ")
        ELSIF op = get     THEN Out.String(" GET     ")
        ELSIF op = bit     THEN Out.String(" BIT     ")
      END;
      Out.Ln;
    END PUT0;

    PROCEDURE PUT1(op, ofs: INTEGER);
    BEGIN
        Out.Int(pc, 6);

        IF    op <= stcwm   THEN INC(pcbytes, 5)
        ELSIF op <= pushret THEN
            IF ofs < 100H THEN INC(pcbytes, 2)
            ELSE op := op + (pushretl-pushret); INC(pcbytes, 3)
            END
        ELSE
            IF (-128 <= op) & (op <= 127) THEN INC(pcbytes, 2)
            ELSE op := op + (JUMPL-JUMP); INC(pcbytes, 3)
            END
        END;
        code[pc].op := op; code[pc].a := ofs;
        IF    op = pushc    THEN Out.String(" PUSHC    ")
        ELSIF op = ldc1     THEN Out.String(" LDC1     ")
        ELSIF op = ldc2     THEN Out.String(" LDC2     ")

        ELSIF op = pushlm   THEN Out.String(" PUSHLM   ")
        ELSIF op = pushgm   THEN Out.String(" PUSHGM   ")
        ELSIF op = enter    THEN Out.String(" ENTER    ") 
        ELSIF op = pushret  THEN Out.String(" PUSHRET  ")

        ELSIF op = JUMP     THEN Out.String(" JUMP     ")
        ELSIF op = BEQ0     THEN Out.String(" BEQ0     ")
        ELSIF op = BNE0     THEN Out.String(" BNE0     ")
        ELSIF op = BLT      THEN Out.String(" BLT      ")

        ELSIF op = pushlml  THEN Out.String(" PUSHLML  ")
        ELSIF op = pushgml  THEN Out.String(" PUSHGML  ")
        ELSIF op = enterl   THEN Out.String(" ENTERL   ") 
        ELSIF op = pushretl THEN Out.String(" PUSHRETL ")

        ELSIF op = JUMPL    THEN Out.String(" JUMPL    ")
        ELSIF op = BEQ0L    THEN Out.String(" BEQ0L    ")
        ELSIF op = BNE0L    THEN Out.String(" BNE0L    ")
        ELSIF op = BLTL     THEN Out.String(" BLTL     ")
        END;
        Out.Int(ofs, 2); Out.Ln;
        INC(pc)
    END PUT1;

    PROCEDURE PUTCall(mod, ofs: INTEGER);
        VAR op: INTEGER;
    BEGIN
        Out.Int(pc, 6);

        IF mod >= 0 THEN
            IF  ofs < 100H THEN 
                 op := call;  INC(pcbytes, 2); Out.String(" CALL   ")
            ELSE op := calll; INC(pcbytes, 3); Out.String(" CALLL  ")
            END;
            code[pc].a := ofs;
        ELSE
            IF   ofs < 4096 (* 2^12 bits *) THEN 
                op := callext; INC(pcbytes, 3); 
                code[pc].a := LSL(-mod, 12) + ofs; 
                Out.String(" CALLEXT ")
            ELSE 
                op := callextl; INC(pcbytes, 4); 
                code[pc].a := LSL(-mod, 20) + ofs; 
                Out.String(" CALLEXTL ")
            END;
            Out.Int(-mod, 2); 
        END;
        Out.Int(ofs, 5); Out.Ln;
        code[pc].op := op; INC(pc)
    END PUTCall;

    PROCEDURE PUTTrap(trapnum, operand: INTEGER);
    BEGIN 
        INC(pcbytes, 7);
        code[pc].op := TRAP;
        Out.Int(pc, 6); Out.String(" TRAP "); Out.Int(trapnum, 6);
        IF trapnum = 1 THEN 
            (* operand = operand & 0x1FFF *)
            IF    operand = -1 THEN operand := 8191
            ELSIF operand = -2 THEN operand := 8190
            END;
            code[pc].a := LSL(trapnum, 13) + operand
        ELSE code[pc].a := LSL(trapnum, 13)
        END;
        Out.Ln;
        code[pc].b := ORS.Pos();
        INC(pc)
    END PUTTrap;

    PROCEDURE PUTStoreM(op, cst: INTEGER);
    (* we put the const a in the memory address indicated in acc *)
    BEGIN
        Out.Int(pc, 6);
        IF    op = stb THEN op := stcbm; Out.String(" STCBM "); INC(pcbytes, 2);
        ELSIF op = stw THEN op := stcwm; Out.String(" STCWM "); INC(pcbytes, 5);
        END;
        Out.Int(cst, 6); Out.Ln;
        code[pc].op := op; code[pc].a := cst;
        INC(pc)
    END PUTStoreM;

    PROCEDURE OutLevel(lev: INTEGER);
    BEGIN
        IF lev>0 THEN Out.String("LOC+") ELSE Out.String("GLO+") END
    END OutLevel;

    PROCEDURE PUTStoreLong(op, cst, level, ofs, acc: INTEGER);
    BEGIN (*emit load/store instruction*)
        Out.Int(pc, 6);
        IF acc = -1 THEN
            IF level > 0 THEN
                IF    op = stw THEN op := stlcwl; Out.String(" STLCWL "); INC(pcbytes, 7);
                ELSIF op = stb THEN op := stlcbl; Out.String(" STLCBL "); INC(pcbytes, 4);
                END
            ELSIF level = 0 THEN
                IF    op = stw THEN op := stgcwl; Out.String(" STGCWL "); INC(pcbytes, 7);
                ELSIF op = stb THEN op := stgcbl; Out.String(" STGCBL "); INC(pcbytes, 4);
              END
            END;
            code[pc].op := op;
            code[pc].a := cst; code[pc].b := ofs;
            Out.Int(cst, 6);
        ELSE
            IF level > 0 THEN
                IF    op = stw THEN op := stlwl; Out.String(" STLWL  ")
                ELSIF op = stb THEN op := stlbl; Out.String(" STLBL  ")
              END
            ELSIF level = 0 THEN
                IF    op = stw THEN op := stgwl; Out.String(" STGWL  ")
                ELSIF op = stb THEN op := stgbl; Out.String(" STGBL  ")
              END
            END;
            INC(pcbytes, 3);
            code[pc].op := op;
            code[pc].a := ofs;
        END;
        Out.String("   "); OutLevel(level); Out.Int(ofs, 2); Out.Ln; 
        INC(pc)
    END PUTStoreLong;

    PROCEDURE PUTStore(op, cst, level, ofs, acc: INTEGER);
    BEGIN (*emit load/store instruction*)
        IF ofs >= 100H THEN PUTStoreLong(op, cst, level, ofs, acc)
        ELSE
            Out.Int(pc, 6);
            IF acc = -1 THEN
                IF level > 0 THEN
                    IF    op = stw THEN op := stlcw ; Out.String(" STLCW  "); INC(pcbytes, 6);
                    ELSIF op = stb THEN op := stlcb ; Out.String(" STLCB  "); INC(pcbytes, 3);
                    END
                ELSIF level = 0 THEN
                    IF    op = stw THEN op := stgcw ; Out.String(" STGCW  "); INC(pcbytes, 6);
                    ELSIF op = stb THEN op := stgcb ; Out.String(" STGCB  "); INC(pcbytes, 3);
                    END
                END;
                code[pc].op := op;
                code[pc].a := cst; code[pc].b := ofs;
                Out.Int(cst, 6);
            ELSE
                IF level > 0 THEN
                    IF    op = stw THEN op := stlw ; Out.String(" STLW   ")
                    ELSIF op = stb THEN op := stlb ; Out.String(" STLB   ")
                    END
                ELSIF level = 0 THEN
                    IF    op = stw THEN op := stgw ; Out.String(" STGW   ")
                    ELSIF op = stb THEN op := stgb ; Out.String(" STGB   ")
                    END
                END;
                INC(pcbytes, 2);
                code[pc].op := op;
                code[pc].a := ofs;
            END;
            Out.String("   "); OutLevel(level); Out.Int(ofs, 2); Out.Ln; 
            INC(pc)
        END
    END PUTStore;

    PROCEDURE PUTLoadExtLong*(op, modnmb, ofs, acc: INTEGER);
    BEGIN
        Out.Int(pc, 6);

        INC(pcbytes, 4);
        IF acc = 1 THEN 
            IF op = ldw THEN op := ldwext1l ELSE op := ldmext1l END;
        ELSE 
            IF op = ldw THEN op := ldwext2l ELSE op := ldmext2l END;
        END;
        code[pc].op := op;
        code[pc].a  := LSL(modnmb, 20) + ofs;
        IF    op = ldwext1l THEN Out.String(" LDWEXT1L ") 
        ELSIF op = ldmext1l THEN Out.String(" LDMEXT1L ") 
        ELSIF op = ldwext2l THEN Out.String(" LDWEXT2L ") 
        ELSIF op = ldmext2l THEN Out.String(" LDMEXT2L ") 
        END;
        Out.Int(modnmb, 3); Out.Int(ofs, 3); Out.Ln;

        INC(pc)
    END PUTLoadExtLong;

    PROCEDURE PUTLoadExt*(op, modnmb, ofs, acc: INTEGER);
    BEGIN
        IF ofs >= 4096 (* 2^12 bits *) THEN PUTLoadExtLong(op, modnmb, ofs, acc)
        ELSE
            Out.Int(pc, 6);

            INC(pcbytes, 3);
            IF acc = 1 THEN 
                IF op = ldw THEN op := ldwext1 ELSE op := ldmext1 END;
            ELSE 
                IF op = ldw THEN op := ldwext2 ELSE op := ldmext2 END;
            END;
            code[pc].op := op;
            code[pc].a  := LSL(modnmb, 12) + ofs;
            IF    op = ldwext1 THEN Out.String(" LDWEXT1 ") 
            ELSIF op = ldmext1 THEN Out.String(" LDMEXT1 ") 
            ELSIF op = ldwext2 THEN Out.String(" LDWEXT2 ") 
            ELSIF op = ldmext2 THEN Out.String(" LDMEXT2 ") 
            END;
            Out.Int(modnmb, 3); Out.Int(ofs, 3); Out.Ln;

            INC(pc)
        END
    END PUTLoadExt;

    PROCEDURE PUTLoadLong(op, level, ofs, acc: INTEGER);
    BEGIN (*emit load/store instruction*)
        Out.Int(pc, 6);
        IF op = ldm THEN
            IF level = 0 (*global*) THEN
                IF    acc = 1 THEN op := ldgm1l; Out.String(" LDGM1L ")
                ELSIF acc = 2 THEN op := ldgm2l; Out.String(" LDGM2L ")
                END
            ELSE (*local*)
                IF    acc = 1 THEN op := ldlm1l; Out.String(" LDLM1L ")
                ELSIF acc = 2 THEN op := ldlm2l; Out.String(" LDLM2L ")
                END
            END;
            Out.String("   "); OutLevel(level); Out.Int(ofs, 2);
        ELSE
            IF level = 0 (*global*) THEN
                IF acc = 1 THEN 
                    IF    op = ldw THEN op := ldgw1l; Out.String(" LDGW1L ")
                    ELSIF op = ldb THEN op := ldgb1l; Out.String(" LDGB1L ")
                    END
                ELSE
                    IF    op = ldw THEN op := ldgw2l; Out.String(" LDGW2L ")
                    ELSIF op = ldb THEN op := ldgb2l; Out.String(" LDGB2L ")
                    END
                END
            ELSE (*local*)
                IF acc = 1 THEN 
                    IF    op = ldw THEN op := ldlw1l; Out.String(" LDLW1L ")
                    ELSIF op = ldb THEN op := ldlb1l; Out.String(" LDLB1L ")
                    END
                ELSE
                    IF    op = ldw THEN op := ldlw2l; Out.String(" LDLW2L ")
                    ELSIF op = ldb THEN op := ldlb2l; Out.String(" LDLB2L ")
                    END
                END
            END;
            Out.String("   ["); OutLevel(level); Out.Int(ofs, 2); Out.String("]")
        END;
        INC(pcbytes, 3);
        code[pc].op := op;
        code[pc].a := ofs;
        INC(pc);

        Out.Ln;
    END PUTLoadLong;

    PROCEDURE PUTLoad(op, level, ofs, acc: INTEGER);
    BEGIN
        IF level < 0 (* extern *) THEN PUTLoadExt(op, -level, ofs, acc)
        ELSE
            IF ofs >= 100H THEN PUTLoadLong(op, level, ofs, acc) 
            ELSE 
                Out.Int(pc, 6);
                IF op = ldm THEN
                    IF level = 0 (*global*) THEN
                        IF    acc = 1 THEN op := ldgm1; Out.String(" LDGM1  ")
                        ELSIF acc = 2 THEN op := ldgm2; Out.String(" LDGM2  ")
                        END
                    ELSE (*local*)
                        IF    acc = 1 THEN op := ldlm1; Out.String(" LDLM1  ")
                        ELSIF acc = 2 THEN op := ldlm2; Out.String(" LDLM2  ")
                        END
                    END;
                    Out.String("   "); OutLevel(level); Out.Int(ofs, 2);
                ELSE
                    IF level = 0 (*global*) THEN
                        IF acc = 1 THEN 
                            IF    op = ldw THEN op := ldgw1; Out.String(" LDGW1 ")
                            ELSIF op = ldb THEN op := ldgb1; Out.String(" LDGB1 ")
                            END
                        ELSE
                            IF    op = ldw THEN op := ldgw2; Out.String(" LDGW2 ")
                            ELSIF op = ldb THEN op := ldgb2; Out.String(" LDGB2 ")
                            END
                        END
                    ELSE (*local*)
                        IF acc = 1 THEN 
                            IF    op = ldw THEN op := ldlw1; Out.String(" LDLW1 ")
                            ELSIF op = ldb THEN op := ldlb1; Out.String(" LDLB1 ")
                            END
                        ELSE
                            IF    op = ldw THEN op := ldlw2; Out.String(" LDLW2 ")
                            ELSIF op = ldb THEN op := ldlb2; Out.String(" LDLB2 ")
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
    BEGIN
        IF a # 0 THEN
            IF (mem = 1) & (op = add) THEN
                IF    a = 1 THEN PUT0(incp)
                ELSIF a = 2 THEN PUT0(incp2)
                ELSIF a = 4 THEN PUT0(incp4)
                END
            ELSIF (mem = 1) & (op = sub) THEN
                IF    a = 1 THEN PUT0(decp)
                ELSIF a = 2 THEN PUT0(decp2)
                ELSIF a = 4 THEN PUT0(decp4)
              END
            ELSIF (mem = 0) & (op = add) THEN
                IF    a = 1 THEN PUT0(inc)
                ELSIF a = 2 THEN PUT0(inc2)
                ELSIF a = 4 THEN PUT0(inc4)
              END
            ELSIF (mem = 0) & (op = sub) THEN
                IF    a = 1 THEN PUT0(dec)
                ELSIF a = 2 THEN PUT0(dec2)
                ELSIF a = 4 THEN PUT0(dec4)
              END
            END
        END
    END PUTInc;

    PROCEDURE PUTRel(op, a, cst: INTEGER);
    BEGIN (*emit load/store instruction*)
        IF (cst = ORB.String) THEN
            IF    op = ORS.eql THEN PUT0(SEQ)
            ELSIF op = ORS.neq THEN PUT0(SNE)
            ELSIF op = ORS.lss THEN PUT0(SLT)
            ELSIF op = ORS.leq THEN PUT0(SLE)
            END
        ELSIF (cst IN {ORB.Int, ORB.Char, ORB.Set, ORB.Pointer, ORB.Byte, ORB.Bool}) THEN 
            IF (a = 0) THEN
                IF    op = ORS.eql THEN PUT0(EQ0)
                ELSIF op = ORS.neq THEN PUT0(NE0)
                ELSIF op = ORS.lss THEN PUT0(LT0)
                ELSIF op = ORS.leq THEN PUT0(LE0)
                ELSIF op = ORS.gtr THEN PUT0(GT0)
                ELSIF op = ORS.geq THEN PUT0(GE0)
                END 
            ELSE
                IF    op = ORS.eql THEN PUT0(EQ)
                ELSIF op = ORS.neq THEN PUT0(NE)
                ELSIF op = ORS.lss THEN PUT0(LT)
                ELSIF op = ORS.leq THEN PUT0(LE)
                ELSIF op = ORS.gtr THEN PUT0(GT)
                ELSIF op = ORS.geq THEN PUT0(GE)
                END 
            END
        ELSIF (cst = ORB.Real) THEN
            IF (a = 0) THEN
                IF    op = ORS.eql THEN PUT0(FEQ0)
                ELSIF op = ORS.neq THEN PUT0(FNE0)
                ELSIF op = ORS.lss THEN PUT0(FLT0)
                ELSIF op = ORS.leq THEN PUT0(FLE0)
                ELSIF op = ORS.gtr THEN PUT0(FGT0)
                ELSIF op = ORS.geq THEN PUT0(FGE0)
                END 
            ELSE
                IF    op = ORS.eql THEN PUT0(FEQ)
                ELSIF op = ORS.neq THEN PUT0(FNE)
                ELSIF op = ORS.lss THEN PUT0(FLT)
                ELSIF op = ORS.leq THEN PUT0(FLE)
                ELSIF op = ORS.gtr THEN PUT0(FGT)
                ELSIF op = ORS.geq THEN PUT0(FGE)
                END 
            END
        END
    END PUTRel;

    PROCEDURE loadStringAdr(VAR x: Item; acc: INTEGER);
    BEGIN 
        PUTLoad(ldm, x.r, x.a, acc); x.acc := acc;
    END loadStringAdr;

    PROCEDURE loadAdr*(VAR x: Item; acc: INTEGER);
    BEGIN
        IF x.mode = ORB.Var THEN 
            IF x.acc = 0 THEN
                IF    acc IN {1, 2} THEN PUTLoad(ldm, x.r, x.a, acc);
                ELSIF acc = 3       THEN loadAdr(x, 1); PUT0(push)
                END
            ELSIF x.acc = 1 THEN
                IF acc = 2 THEN PUT0(ac1to2); 
                ELSIF acc = 3 THEN PUT0(push)
                END
            ELSIF x.acc = 2 THEN
                IF    acc = 1 THEN PUT0(ac2to1);
                ELSIF acc = 3 THEN PUT0(ac2to1); PUT0(push)
                END
            ELSIF x.acc = 3 THEN
                IF    acc = 1 THEN PUT0(pop1)
                ELSIF acc = 2 THEN PUT0(pop2)
                END
            END
        ELSIF x.mode = ORB.Par THEN 
            IF x.acc = 0 THEN
                IF    acc IN {1, 2} THEN PUTLoad(ldw, x.r, x.a, acc);
                ELSIF acc = 3       THEN loadAdr(x, 1); PUT0(push)
                END
            ELSIF x.acc = 1 THEN
                IF acc = 2 THEN PUT0(ac1to2)
                ELSIF acc = 3 THEN PUT0(push)
                END
            ELSIF x.acc = 2 THEN
                IF    acc = 1 THEN PUT0(ac2to1)
                ELSIF acc = 2 THEN PUT0(ldacc2)
                ELSIF acc = 3 THEN PUT0(ac2to1); PUT0(push)
                END
            ELSIF x.acc = 3 THEN
                IF    acc = 1 THEN PUT0(pop1)
                ELSIF acc = 2 THEN PUT0(pop2)
                END
            END
        END;    
        x.acc := acc
    END loadAdr;

    PROCEDURE loadacc*(VAR x: Item; acc: INTEGER);
        VAR op: INTEGER;
    BEGIN
        IF x.type.size = 1 THEN op := ldw+1 ELSE op := ldw END;
        IF (x.type = ORB.strType) OR (x.type.form = ORB.Array) THEN loadAdr(x, acc);
        ELSE
            IF x.mode = ORB.Const THEN     (* x.acc == -1 OR x.acc == 1 *)
                IF    x.acc = -1 THEN
                    IF    acc = 1 THEN 
                        IF (x.type.form = ORB.String) THEN
                            IF (x.b = 2) THEN PUT1(ldc1, ORD(str[x.a-varsize]));
                            ELSE loadStringAdr(x, 1)
                            END
                        ELSE PUT1(ldc1, x.a)
                        END
                    ELSIF acc = 2 THEN
                        IF (x.type.form = ORB.String) THEN
                            IF (x.b = 2) THEN PUT1(ldc2, ORD(str[x.a-varsize]));
                            ELSE loadStringAdr(x, 2)
                            END
                        ELSE PUT1(ldc2, x.a)
                        END
                    ELSIF acc = 3 THEN
                        IF (x.type.form = ORB.String) & (x.b = 2) THEN PUT1(pushc, ORD(str[x.a-varsize]));
                        ELSIF (x.type.form = ORB.String) THEN 
                            IF x.r > 0 THEN PUT1(pushlm, x.a)
                            ELSIF x.r = 0 THEN PUT1(pushgm, x.a)
                            END
                        ELSE PUT1(pushc, x.a)
                        END
                    END
                ELSIF x.acc = 0 THEN  (* Const String *)
                    PUTLoad(ldm, x.r, x.a, 1);
                    IF acc = 3 THEN PUT0(push) END
                ELSIF x.acc = 1 THEN
                    IF    acc = 2 THEN PUT0(ac1to2)
                    ELSIF acc = 3 THEN PUT0(push)
                    END
                ELSIF x.acc = 2 THEN
                    IF    acc = 1 THEN PUT0(ac2to1)
                    ELSIF acc = 3 THEN PUT0(ac2to1); PUT0(push)
                    END
                ELSIF x.acc = 3 THEN
                    IF    acc = 1 THEN PUT0(pop1)
                    ELSIF acc = 2 THEN PUT0(pop2)
                    END
                END
            ELSIF x.mode = ORB.Var THEN 
                IF x.acc = 0 THEN
                    IF    acc IN {1, 2} THEN PUTLoad(op, x.r, x.a, acc)
                    ELSIF acc = 3       THEN loadacc(x, 1); PUT0(push)
                    END
                ELSIF x.acc = 1 THEN
                    IF acc = 2 THEN PUT0(ac1to2); 
                    ELSIF acc = 3 THEN PUT0(push)
                    END
                ELSIF x.acc = 2 THEN
                    IF    acc = 1 THEN PUT0(ac2to1);
                    ELSIF acc = 3 THEN PUT0(ac2to1); PUT0(push)
                    END
                ELSIF x.acc = 3 THEN
                    IF    acc = 1 THEN PUT0(pop1)
                    ELSIF acc = 2 THEN PUT0(pop2)
                    END
                END
            ELSIF x.mode = ORB.Par THEN 
                IF x.acc = 0 THEN
                    IF    acc IN {1, 2} THEN PUTLoad(op, x.r, x.a, acc);
                        IF    acc = 1 THEN PUT0(ldacc1)
                        ELSIF acc = 2 THEN PUT0(ldacc2)
                        END
                    ELSIF acc = 3       THEN loadacc(x, 1); PUT0(push)
                    END
                ELSIF x.acc = 1 THEN
                    IF    (acc = 1) THEN PUT0(ldacc1)
                    ELSIF acc = 2 THEN PUT0(ac1to2); PUT0(ldacc2)
                    ELSIF acc = 3 THEN PUT0(ldacc1); PUT0(push)
                    END
                ELSIF x.acc = 2 THEN
                    IF    acc = 1 THEN PUT0(ac2to1); PUT0(ldacc1)
                    ELSIF acc = 2 THEN PUT0(ldacc2)
                    ELSIF acc = 3 THEN PUT0(ac2to1); PUT0(push)
                    END
                ELSIF x.acc = 3 THEN
                    IF    acc = 1 THEN PUT0(pop1)
                    ELSIF acc = 2 THEN PUT0(pop2)
                    END
                END
            END;    
            x.acc := acc
        END
    END loadacc;



    PROCEDURE SysCall*(sys: INTEGER);
    BEGIN
        PUT1(ldc1, sys); 
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
    BEGIN PUT1(JUMP, pc)
    END JumpExit;

    PROCEDURE JumpWhile*(L: INTEGER);
    BEGIN
        JumpExit;
        FixAt(pc-1, L);
    END JumpWhile;

    PROCEDURE JumpRepeat*(p: Ptr; L: INTEGER);
    BEGIN
        WHILE p # NIL DO
            IF (p.label # 0) THEN FixAt(p.label, L) END; 
            p := p.next
        END
    END JumpRepeat;

    PROCEDURE NilCheck;
    BEGIN PUTTrap(4, 0)
    END NilCheck;

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


    (* Items: Conversion from constants or from Objects on the Heap to Items on the Stack*)

    PROCEDURE MakeConstItem*(VAR x: Item; typ: ORB.Type; val: INTEGER);
    BEGIN x.mode := ORB.Const; x.type := typ; x.a := val; x.acc := -1;
        x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL;
    END MakeConstItem;

    PROCEDURE MakeRealItem*(VAR x: Item; val: REAL);
    BEGIN x.mode := ORB.Const; x.type := ORB.realType; x.a := SYSTEM.VAL(INTEGER, val); 
        x.acc := -1;
        x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL;
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
        x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL;
    END MakeStringItem;

    PROCEDURE MakeItem*(VAR x: Item; y: ORB.Object; curlev: INTEGER);
    BEGIN x.mode := y.class; x.type := y.type; x.a := y.val; x.rdo := y.rdo;
        IF y.class = ORB.Par THEN x.b := 0; x.r := 1;
        ELSIF (y.class = ORB.Const) & (y.type.form = ORB.String) THEN x.b := y.lev  (*len*) ;
        ELSE x.r := y.lev
        END ;
        IF (y.lev > 0) & (y.lev # curlev) & (y.class # ORB.Const) THEN ORS.Mark("not accessible ") END;
        x.acc := 0; x.name := y.name;
        x.Lseq := NIL; x.Lexit := NIL; x.Lnext := NIL;
    END MakeItem;

    (* Code generation for Selectors, Variables, Constants *)

    PROCEDURE Field*(VAR x: Item; y: ORB.Object);   (* x := x.y *)
    BEGIN
        IF x.mode = ORB.Var THEN
            IF (x.r >= 0) & (x.acc # 1) THEN x.a := x.a + y.val 
            ELSE 
                loadAdr(x, 1); IF y.val IN {0, 1, 2, 4} THEN PUTInc(add, y.val, 0) ELSE PUT1(ldc2, y.val); PUT0(add) END; x.mode := ORB.Par
            END;
        ELSIF x.mode = ORB.Par THEN (* x.b := x.b + y.val *)
                loadAdr(x, 1); IF y.val IN {0, 1, 2, 4} THEN PUTInc(add, y.val, 0) ELSE PUT1(ldc2, y.val); PUT0(add) END; x.mode := ORB.Par
        END;
    END Field;

    PROCEDURE Index*(VAR x, y: Item);   (* x := x[y] *)
    VAR s, lim: INTEGER;
    BEGIN s := x.type.base.size; lim := x.type.len; 
        IF (y.mode = ORB.Const) & (lim >= 0) THEN 
            IF (y.a < 0) OR (y.a >= lim) THEN ORS.Mark("bad index") END ;
            IF ~((y.acc = -1) & (y.a = 0)) THEN
                IF x.mode = ORB.Var THEN
                    IF (x.r >= 0) & (x.acc # 1) THEN x.a := y.a*s + x.a;
                    ELSE
                        x.a := y.a*s;
                        IF x.a IN {0, 1, 2, 4} THEN PUTInc(add, x.a, 1) ELSE PUT1(ldc2, x.a); PUT0(addp) END;
                        x.a := 0;
                    END
                ELSIF x.mode = ORB.Par THEN x.b := y.a * s + x.b
                END
            END
        ELSE 
            IF ~((y.type.form = ORB.Int) & (y.acc = -1) & (y.a = 0)) THEN
                IF x.acc = 1 THEN x.acc := 3; PUT0(push) END; 
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
                IF x.acc = 3 THEN PUT0(pop1); x.acc := 1
                ELSE
                    loadAdr(x, 1)
                END;
                PUT0(add);
            END;
            x.mode := ORB.Par;
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
            IF varpar THEN
                PUTLoad(ldw, x.r, x.a+4, 1); PUT0(ldacc1);
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
        ELSE PUT1(ldc1, 1);
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

    PROCEDURE displaylist(x: Item);
        VAR Lcur: Ptr;
    BEGIN
        Out.String("LSEQ: "); Lcur := x.Lseq; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
        Out.String("LNEXT: "); Lcur := x.Lnext; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
        Out.String("LEXIT: "); Lcur := x.Lexit; WHILE Lcur # NIL DO Out.Int(Lcur.label, 4); Lcur := Lcur.next END; Out.Ln;
    END displaylist;
    
    PROCEDURE Not*(VAR x: Item);   (* x := ~x *)
        VAR Lcur: Ptr;
    BEGIN

IF DEBUG = 1 THEN Out.String("Not DEB"); Out.Ln; END;

        IF (x.Lseq = NIL) & (x.Lnext = NIL) & (x.Lexit = NIL) THEN
            FixNot(pc-1); 
        ELSE

IF DEBUG = 1 THEN displaylist(x) END;

            FixList(x.Lseq);
            FixList(x.Lexit);
            x.Lseq := NIL;
            x.Lexit := NIL;
            AddPtr(x.Lseq, pc);
            PUT0(not);

IF DEBUG = 1 THEN WSTR("After exchange:"); displaylist(x) END;

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
        CopyPtrs(x.Lseq, y.Lseq);
        CopyPtrs(x.Lnext, y.Lnext);
        CopyPtrs(x.Lexit, y.Lexit);

(*
        CopyPtrs(x.Lnext, x.Lseq); x.Lseq := NIL;  (* TODO A vérifier si cette ligne est nécessaire *)
*)

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
            ELSE loadacc(x, 1); PUT0(fneg)
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
        END;
        IF x.mode = ORB.Par THEN x.mode := ORB.Var END;
        IF y.mode = ORB.Par THEN y.mode := ORB.Var END;
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
        END;
        IF x.mode = ORB.Par THEN x.mode := ORB.Var END;
        IF y.mode = ORB.Par THEN y.mode := ORB.Var END;
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
        IF x.mode = ORB.Par THEN x.mode := ORB.Var END;
        IF y.mode = ORB.Par THEN y.mode := ORB.Var END;
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
        IF x.mode = ORB.Par THEN x.mode := ORB.Var END;
        IF y.mode = ORB.Par THEN y.mode := ORB.Var END;
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
        VAR L0, L1: INTEGER;
    BEGIN
        IF (x.mode = ORB.Const) & ( y.mode = ORB.Const) THEN
            IF x.a <= y.a THEN x.a := LSL(2, y.a) - LSL(1, x.a) ELSE x.a := 0 END
        ELSE
            loadacc(x, 1); loadacc(y, 2); PUT1(BLT, pc); L0 := pc;
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
            x.acc := 1; y.acc := 2;
            JumpExit;  L1 := pc;
            FixAt(L0-1, L1);
            PUT1(ldc1, 0);
            x.mode := ORB.Const; x.acc := -1; x.a := 0;
            FixAt(L1-1, pc);
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

    PROCEDURE Loadxy(VAR x, y: Item);
    BEGIN
        IF (x.acc = -1) OR (x.acc = 0) THEN
            IF y.acc <= 0 THEN loadacc(x, 1); loadacc(y, 2)
            ELSIF y.acc = 1 THEN PUT0(ac1to2); loadacc(x, 1)
            ELSIF y.acc = 2 THEN loadacc(x, 1)
            END
        ELSIF x.acc = 1 THEN
            IF y.acc <= 0 THEN loadacc(x, 1); loadacc(y, 2)
            ELSIF y.acc = 1 THEN loadacc(y, 2); loadacc(x, 1);
            END
        ELSE
            IF y.acc = 0 THEN loadacc(x, 1); loadacc(y, 2)
            ELSIF y.acc = 1 THEN x.acc := 0; y.acc := 0; loadacc(x, 1); loadacc(y, 2)
            END
        END
    END Loadxy;

    PROCEDURE IntRealRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
    BEGIN
        IF (x.mode = ORB.Const) & (y.mode = ORB.Const) & (x.type.form # ORB.String) THEN 
            IF (x.acc = -1) & (y.acc = -1) THEN
            CASE op OF
                ORS.eql : IF x.a  = y.a THEN PUT1(ldc1, 1); ELSE PUT1(ldc1, 0) END
              | ORS.neq : IF x.a  # y.a THEN PUT1(ldc1, 1); ELSE PUT1(ldc1, 0) END
              | ORS.lss : IF x.a  < y.a THEN PUT1(ldc1, 1); ELSE PUT1(ldc1, 0) END
              | ORS.leq : IF x.a <= y.a THEN PUT1(ldc1, 1); ELSE PUT1(ldc1, 0) END
              | ORS.gtr : IF x.a  > y.a THEN PUT1(ldc1, 1); ELSE PUT1(ldc1, 0) END
              | ORS.geq : IF x.a >= y.a THEN PUT1(ldc1, 1); ELSE PUT1(ldc1, 0) END
            END;
            ELSIF (x.acc # -1) & (y.acc = -1) THEN
                loadacc(x, 1);
                IF y.a # 0 THEN PUT1(ldc2, y.a) END;
                PUTRel(op, y.a, x.type.form)
            ELSIF (x.acc = -1) & (y.acc # -1) THEN
                IF    op = ORS.lss THEN op := ORS.gtr
                ELSIF op = ORS.leq THEN op := ORS.geq
                ELSIF op = ORS.gtr THEN op := ORS.lss
                ELSIF op = ORS.geq THEN op := ORS.leq
                END; 
                loadacc(y, 1);
                IF x.a # 0 THEN PUT1(ldc2, x.a) END;
                PUTRel(op, x.a, x.type.form)
            ELSE
                Loadxy(x, y);
                PUTRel(op, 1, x.type.form)
            END;
        ELSE
            IF (x.mode = ORB.Const) & (y.mode # ORB.Const) THEN 
                IF    op = ORS.lss THEN op := ORS.gtr
                ELSIF op = ORS.leq THEN op := ORS.geq
                ELSIF op = ORS.gtr THEN op := ORS.lss
                ELSIF op = ORS.geq THEN op := ORS.leq
                END; 
                (* (x.mode = ORB.Const) ==  a cst, a procedure, or a cst string *)
                IF (x.acc = -1) THEN (* a cst or a cst string *)
                    IF (x.type.form = ORB.String) THEN (* a cst string *)
                        Loadxy(y, x);
                    ELSIF x.a # 0 THEN
                        Loadxy(y, x);
                    ELSE
                        loadacc(y, 1);
                    END;
                    PUTRel(op, x.a, x.type.form)
                ELSE (* a procedure *)
                    Loadxy(x, y);
                    PUTRel(op, 1, x.type.form)
                END;
                x.mode := y.mode; x.acc := 1;
            ELSIF (x.mode # ORB.Const) & (y.mode = ORB.Const) THEN
                IF (y.acc = -1) THEN (* a cst or a cst string *)
                    IF (y.type.form = ORB.String) THEN
                        Loadxy(x, y);
                    ELSIF y.a # 0 THEN
                        Loadxy(x, y);
                    ELSE
                        loadacc(x, 1);
                    END;
                    PUTRel(op, y.a, x.type.form)
                ELSE (* a procedure *)
                    Loadxy(x, y);
                    PUTRel(op, 1, x.type.form)
                END;
            ELSE
                Loadxy(x,y);
                PUTRel(op, 1, x.type.form)
            END;
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
      PUTRel(op, 0, ORB.String);
    END StringRelation;

    (* Code generation of Assignments *)

    PROCEDURE Push*(VAR x: Item);
    BEGIN
        loadacc(x, 3)
    END Push;

    PROCEDURE Pop*(VAR x: Item; acc: INTEGER);
    BEGIN
        IF    acc = 1 THEN PUT0(pop1)
        ELSIF acc = 2 THEN PUT0(pop2)
        END;
        x.acc := acc
    END Pop;

    PROCEDURE PushAdd*(VAR x: Item; L0: INTEGER);
    VAR tmp: INTEGER;
    BEGIN
      Out.String("; Add an instruction push between instruction "); Out.Int(L0-1, 2); Out.String(" and instruction "); Out.Int(L0, 2); Out.Ln;
      x.acc := 3;
      (* now we convert the code table *)
      tmp := pc;
      REPEAT code[tmp] := code[tmp-1]; DEC(tmp) UNTIL tmp = L0; 
      code[tmp].op := push;
      INC(pc);
      INC(pcbytes);
    END PushAdd;

    PROCEDURE StrToChar*(VAR x: Item);
    BEGIN x.type := ORB.charType; DEC(strx, 4); x.a := ORD(str[x.a-varsize]); 
    END StrToChar;

    PROCEDURE SearchObjByName(x: Item): ORB.Object;
        VAR s, obj: ORB.Object;
            i: INTEGER;
    BEGIN 
        s := ORB.topScope;
        IF x.r >= 0 THEN  (* local *)
            REPEAT obj := s.next;
              WHILE (obj # NIL) & (obj.name # x.name) DO obj := obj.next END ;
              s := s.dsc
            UNTIL (obj # NIL) OR (s = NIL);
        ELSE (* extern *)
        IF s.next IS ORB.Module THEN obj := s.next ELSE obj := s.dsc END;
            i := 1;
            WHILE i <= -x.r DO 
                obj := obj.next;
                IF (obj.name # "SYSTEM") & (obj.name # "Out2") THEN INC(i) END;    
            END;
        END;
        IF x.r < 0 THEN
            obj := obj.dsc;
            WHILE (x.name # obj.name) DO obj := obj.next END;
        END;
        RETURN obj
    END SearchObjByName;

    PROCEDURE StoreProc(VAR x, y: Item); (* x := y *)
        VAR xobj, yobj: ORB.Object;
    BEGIN
        yobj := SearchObjByName(y);
        xobj := SearchObjByName(x);
        xobj.lev := y.r;
        xobj.val := yobj.val;
    END StoreProc;
    
    PROCEDURE Store*(VAR x, y: Item); (* x := y *)
        VAR op: INTEGER;
    BEGIN 
        IF x.type.form = ORB.Proc THEN StoreProc(x, y)  (* procedure assignment *)
        ELSE
            IF x.type.size = 1 THEN op := stb ELSE op := stw END ;
            IF x.mode = ORB.Var THEN
                IF y.acc = -1 THEN
                    PUTStore(op, y.a, x.r, x.a, y.acc);
                ELSE 
                    loadacc(y, 1);
                    PUTStore(op, y.a, x.r, x.a, y.acc);
                END
            ELSIF x.mode = ORB.Par THEN
                IF y.acc = -1 THEN
                    loadAdr(x, 1);
                    PUTStoreM(op, y.a);
                ELSE
                    loadacc(y, 2);
                    loadAdr(x, 1);
                    PUT0(stm);
                END
            END
        END
    END Store;


    PROCEDURE StoreStruct*(VAR x, y: Item); (* x := y, frame = 0 *)
        VAR s, len: INTEGER;
    BEGIN 
        WSTR("STORESTRUCT");
        IF x.type.form = ORB.Array THEN
            s := y.type.base.size;
            len := x.type.len;
            IF s = 1 THEN
                IF len < 0 THEN
                    PUTLoad(ldw, y.r, y.a+4, 1); PUTLoad(ldw, x.r, x.a+4, 2); PUTTrap(1, -1); (*open array len, frame = 0*)
                    loadAdr(x, 1);
                    loadAdr(y, 2);
                    PUT0(copy);
                ELSIF y.type.len < 0 THEN
                    PUTLoad(ldw, y.r, y.a+4, 1); PUTTrap(1, len); (*open array len, frame = 0*)
                    loadAdr(x, 1);
                    loadAdr(y, 2);
                    PUT0(copy);
                ELSE 
                    PUT1(ldc1, y.type.len); PUTTrap(1, len); (*open array len, frame = 0*)
                    loadAdr(x, 1);
                    loadAdr(y, 2);
                    PUT0(copy);
                END
            ELSE
                IF len < 0 THEN
                    PUTLoad(ldw, y.r, y.a+4, 1); PUTLoad(ldw, x.r, x.a+4, 2); PUTTrap(1, -2); (*open array len, frame = 0*)
                    PUT0(push);
                    loadAdr(x, 1);
                    loadAdr(y, 2);
                    PUT0(copyw);
                    PUT0(pop1);
                ELSIF y.type.len < 0 THEN
                    PUTLoad(ldw, y.r, y.a+4, 1); PUT1(ldc2, len); PUTTrap(1, -2); (*open array len, frame = 0*)
                    PUT0(push);
                    loadAdr(x, 1);
                    loadAdr(y, 2);
                    PUT0(copyw);
                    PUT0(pop1);
                ELSE
                    PUT1(ldc1, y.type.len); PUT1(ldc2, len); PUTTrap(1, -2); (*open array len, frame = 0*)
                    PUT0(push);
                    loadAdr(x, 1);
                    loadAdr(y, 2);
                    PUT0(copyw);
                    PUT0(pop1);
                END
            END
        ELSIF x.type.form = ORB.Record THEN
            WINT(x.type.size);
            PUT1(pushc, x.type.size);
            loadAdr(x, 1);
            loadAdr(y, 2);
            PUT0(copyw);
            PUT0(pop1);
        ELSE ORS.Mark("inadmissible assignment")
        END ;

    END StoreStruct;

    PROCEDURE CopyString*(VAR x, y: Item);  (* x := y *) 
         VAR len: INTEGER;
     BEGIN len := x.type.len;
        IF len >= 0 THEN
            IF len < y.b THEN ORS.Mark("string too long") END
        ELSE PUT1(ldc1, y.b); PUTLoad(ldw, 1, x.a+4, 2); PUTTrap(1, -1) (*open array len, frame = 0*)
        END;
        loadAdr(x, 1);
        loadStringAdr(y, 2);
        PUT0(copy);
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
            IF xmd = ORB.Par THEN
                PUTLoad(ldw, x.r, x.a+4, 1);
                PUT0(push)
            ELSE 
                loadTypTagAdr(x.type, 3) 
            END; 
        END
    END VarParam;

    PROCEDURE ValueParam*(VAR x: Item);
    BEGIN 
        loadacc(x, 3)
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
      Out.String("; Replace instruction 'PUSHRET @ret<"); Out.Int(r-1, 2); Out.String(">' by instruction 'PUSHRET @ret<+"); Out.Int(pc-r+1, 2); Out.String(">'"); Out.Ln;
      (* now we convert the code table *)
      code[r-1].a := pc-r+1;
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
        IF (x.mode = ORB.Var) & (x.r >= 0) THEN
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
        IF y.r >= 0 THEN PUTStore(stw, 0, y.r, y.a, 0) END; 
        PUT1(ldc2, 23); PUT0(lsl); PUT0(ac1to2); loadAdr(x, 1); PUT0(subp); 
    END Unpk;

    PROCEDURE Get*(VAR x, y: Item);
    BEGIN Loadxy(x, y); PUT0(get); x.a := 0; PUTStore(stw, 0, y.r, y.a, 1)
    END Get;

    PROCEDURE Put*(VAR x, y: Item);
    BEGIN Loadxy(x, y); PUT0(put); x.type := y.type; x.a := 0;
    END Put;

    PROCEDURE Copy*();
    BEGIN 
        PUT0(copyw);
        PUT0(pop1);
        PUT0(pop2);
        PUT0(pop1);
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
    BEGIN loadacc(x, 1); PUT0(float)
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
        IF fct = 7 THEN op := lsl 
        ELSIF fct = 8  THEN op := asr 
        ELSIF fct = 9  THEN op := ror
        ELSIF fct = 14 THEN op := lsr
        END ;
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
    BEGIN  (*exit code*) tmp := 0; newSF := TRUE;
        obj := ORB.topScope.next; nofimps := 0; comsize := 4; nofptrs := 0;
        WHILE obj # NIL DO
            IF (obj.class = ORB.Mod) & (obj.dsc # ORB.system) & (obj.dsc # ORB.OUT2) THEN INC(nofimps) (*count imports*)
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
        obj := ORB.topScope.next;
        WHILE (obj # NIL) & (obj.class = ORB.Mod) DO  (*imports*)
            IF (obj.dsc # ORB.system) & (obj.dsc # ORB.OUT2) THEN Files.WriteString(R, obj(ORB.Module).orgname) END ;
            obj := obj.next
        END ;
        Out.Char(0X);
        Files.WriteInt(R, tdx*4);
        i := 0;
        WHILE i < tdx DO Files.WriteInt(R, data[i]); INC(i) END ; (*type descriptors*)
        Files.WriteInt(R, varsize - tdx*4);  (*data*)
        Files.WriteInt(R, strx);
        FOR i := 0 TO strx-1 DO Files.Write(R, ORD(str[i])); Out.Char(str[i]) END ;  (*strings*)
        Files.WriteInt(R, pcbytes);
        Files.WriteInt(R, pc);  (*code len*)


        FOR i := 0 TO pc-1 DO 
          Files.Write(R, code[i].op);
          IF code[i].op > bit THEN
            IF    code[i].op  = TRAP     THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp); Files.WriteInt(R, code[i].b);
            ELSIF code[i].op <= stcwm    THEN Files.WriteInt(R, code[i].a)
            ELSIF code[i].op <= call     THEN Files.Write(R, code[i].a)
            ELSIF code[i].op <= ldmext2  THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp);
            ELSIF code[i].op <= stgcb    THEN Files.Write(R, code[i].a); Files.Write(R, code[i].b) 
            ELSIF code[i].op <= stgcw    THEN Files.WriteInt(R, code[i].a); Files.Write(R, code[i].b);
            ELSIF code[i].op <= calll    THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp)
            ELSIF code[i].op <= ldmext2l THEN by := code[i].a; Files.Write(R, by); tmp := ASR(code[i].a, 8); Files.Write(R, tmp); tmp := ASR(code[i].a, 16); Files.Write(R, tmp)
            ELSIF code[i].op <= stgcbl   THEN Files.Write(R, code[i].a); by := code[i].b; Files.Write(R, by); tmp := ASR(code[i].b, 8); Files.Write(R, tmp);
            ELSIF code[i].op <= stgcwl   THEN Files.WriteInt(R, code[i].a); by := code[i].b; Files.Write(R, by); tmp := ASR(code[i].b, 8); Files.Write(R, tmp);
            END
          END
        END ;  (*program*)

        Out.Char(0X);
        Files.WriteInt(R, nofent); 

        (*
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
        *)

        obj := ORB.topScope.next;
        WHILE obj # NIL DO  (*pointer variables*)
            IF obj.class = ORB.Var THEN FindPtrs(R, obj.type, obj.val) END ;
            obj := obj.next
        END ;
        Files.WriteInt(R, -1);
        Files.WriteInt(R, entry);
        Out.Char("O"); Files.Register(F); Files.Close(F)

    END Close;

BEGIN 
END ORG.
