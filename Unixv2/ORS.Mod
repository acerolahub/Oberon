MODULE ORS; (* NW 19.9.93 / 15.3.2017  Scanner in Oberon-07*)
  (* FF 05/01/2019: replaced dependances to unknown module Texts *)
  IMPORT SYSTEM,Out,Files; (* , Texts, Oberon; *)

(* Oberon Scanner does lexical analysis. Input is Oberon-Text, output is
  sequence of symbols, i.e identifiers, numbers, strings, and special symbols.
  Recognises all Oberon keywords and skips comments. The keywords are
  recorded in a table.
  Get(sym) delivers next symbol from input text with Reader R.
  Mark(msg) records error and delivers error message with Writer W.
  If Get delivers ident, then the identifier (a string) is in variable id, if int or char
  in ival, if real in rval, and if string in str (and slen) *)
  
  CONST IdLen* = 32;
    NKW = 34;  (*nof keywords*)
    maxExp = 38; stringBufSize = 256;
  
    (*lexical symbols*)
    null = 0; times* = 1; rdiv* = 2; div* = 3; mod* = 4;
    and* = 5; plus* = 6; minus* = 7; or* = 8; eql* = 9;
    neq* = 10; lss* = 11; leq* = 12; gtr* = 13; geq* = 14;
    in* = 15; is* = 16; arrow* = 17; period* = 18;
    char* = 20; int* = 21; real* = 22; false* = 23; true* = 24;
    nil* = 25; string* = 26; not* = 27; lparen* = 28; lbrak* = 29;
    lbrace* = 30; ident* = 31;
    if* = 32; while* = 34; repeat* = 35; case* = 36; for* = 37;
    comma* = 40; colon* = 41; becomes* = 42; upto* = 43; rparen* = 44;
    rbrak* = 45; rbrace* = 46; then* = 47; of* = 48; do* = 49;
    to* = 50; by* = 51; semicolon* = 52; end* = 53; bar* = 54;
    else* = 55; elsif* = 56; until* = 57; return* = 58;
    array* = 60; record* = 61; pointer* = 62; const* = 63; type* = 64;
    var* = 65; procedure* = 66; begin* = 67; import* = 68; module* = 69; eot = 70;

  TYPE Ident* = ARRAY IdLen OF CHAR;

  VAR ival*, slen*: INTEGER;  (*results of Get*)
    rval*: REAL;
    id*: Ident;  (*for identifiers*)
    str*: ARRAY stringBufSize OF CHAR;
    errcnt*: INTEGER;

    ch: CHAR;  (*last character read*)
    errpos, lastSym: INTEGER;
    k: INTEGER;
    KWX: ARRAY 10 OF INTEGER;
    keyTab: ARRAY NKW OF
        RECORD sym: INTEGER; id: ARRAY 12 OF CHAR END;
  
(****** dependances sur Texts et Texts.Reader : *********)

    R*: Files.Rider; (* R : Texts.Reader *)
                    (* W : Texts.Writer *)
    
    FF*: Files.File;

  PROCEDURE ReadNext;  (* le source Oberon est lu caractere par caractere via cette procedure *)
    VAR b: BYTE;
  BEGIN Files.Read(R, b); ch:=CHR(b) (* Texts.Read(R, ch) *)
  END ReadNext;

  PROCEDURE Init*(F: Files.File; pos: INTEGER); (* (T: Texts.Text; pos: INTEGER); *)
  BEGIN 
    FF := F;
    errpos := pos; errcnt := 0;
    Files.Set(R, F, pos); (* Texts.OpenReader(R, T, pos); *)
    ReadNext
  END Init;

  PROCEDURE EndOfText(): BOOLEAN;
  BEGIN RETURN R.eof (* R.eot *)
  END EndOfText;

  PROCEDURE Pos*(): INTEGER;
  BEGIN RETURN Files.Pos(R) - 1 (* RETURN Texts.Pos(R) - 1 *)
  END Pos;

  PROCEDURE OpenWriter;
  BEGIN Out.Open (* Texts.OpenWriter(W) *)
  END OpenWriter;

  PROCEDURE Mark*(msg: ARRAY OF CHAR);
    VAR p: INTEGER;
  BEGIN p := Pos();
    IF (p > errpos) & (errcnt < 20) THEN
(* 
    Texts.WriteLn(W);
    Texts.WriteString(W, "  pos "); 
    Texts.WriteInt(W, p, 1); 
    Texts.Write(W, " ");
    Texts.WriteString(W, msg); 
    Texts.Append(Oberon.Log, W.buf)
*)
      Out.Ln;
      Out.String("  pos ");
      Out.Int(p,5);
      Out.String(" (sym=");
      Out.Int(lastSym,3);
      Out.String("): ");
      Out.String(msg);
      Out.Ln;
    END ;
    INC(errcnt); errpos := p + 4
  END Mark;

(********************************************************)

  PROCEDURE CopyId*(VAR ident: Ident);
  BEGIN ident := id
  END CopyId;

  PROCEDURE Identifier(VAR sym: INTEGER);
    VAR i, k: INTEGER;
  BEGIN i := 0;
    REPEAT
      IF i < IdLen-1 THEN id[i] := ch; INC(i) END ;
      ReadNext
    UNTIL (ch < "0") OR (ch > "9") & (ch < "A") OR (ch > "Z") & (ch < "a") OR (ch > "z");
    id[i] := 0X; 
    IF i < 10 THEN k := KWX[i-1];  (*search for keyword*)
      WHILE (id # keyTab[k].id) & (k < KWX[i]) DO INC(k) END ;
      IF k < KWX[i] THEN sym := keyTab[k].sym ELSE sym := ident END
    ELSE sym := ident
    END
  END Identifier;

  PROCEDURE String;
    VAR i: INTEGER;
  BEGIN i := 0; ReadNext;
    WHILE ~EndOfText() & (ch # 22X) DO
      IF ch >= " " THEN
        IF i < stringBufSize-1 THEN str[i] := ch; INC(i) ELSE Mark("string too long") END ;
      END ;
      ReadNext
    END ;
    str[i] := 0X; INC(i); ReadNext; slen := i
  END String;

  PROCEDURE HexString;
    VAR i, m, n: INTEGER;
  BEGIN i := 0; ReadNext;
    WHILE ~EndOfText() & (ch # "$") DO
      WHILE ~EndOfText()  & (ch <= " ") DO ReadNext END ;  (*skip*)
      IF ("0" <= ch) & (ch <= "9") THEN m := ORD(ch) - 30H
      ELSIF ("A" <= ch) & (ch <= "F") THEN m := ORD(ch) - 37H
      ELSE m := 0; Mark("hexdig expected")
      END ;
      ReadNext;
      IF ("0" <= ch) & (ch <= "9") THEN n := ORD(ch) - 30H
      ELSIF ("A" <= ch) & (ch <= "F") THEN n := ORD(ch) - 37H
      ELSE n := 0; Mark("hexdig expected")
      END ;
      IF i < stringBufSize THEN str[i] := CHR(m*10H + n); INC(i) ELSE Mark("string too long") END ;
      ReadNext
    END ;
    ReadNext; slen := i  (*no 0X appended!*)
  END HexString;

  PROCEDURE Ten(e: INTEGER): REAL;
    VAR x, t: REAL;
  BEGIN x := 1.0; t := 10.0;
    WHILE e > 0 DO
      IF ODD(e) THEN x := t * x END ;
      t := t * t; e := e DIV 2
    END ;
    RETURN x
  END Ten;

  PROCEDURE Number(VAR sym: INTEGER);
    CONST max = 2147483647 (*2^31 - 1*);
    VAR i, k, e, n, s, h: INTEGER; x: REAL;
      d: ARRAY 16 OF INTEGER;
      negE, realNum: BOOLEAN;
  BEGIN ival := 0; i := 0; n := 0; k := 0; realNum := FALSE;
    REPEAT
      IF n < 16 THEN d[n] := ORD(ch)-30H; INC(n) ELSE Mark("too many digits"); n := 0 END ;
      ReadNext
    UNTIL (ch < "0") OR (ch > "9") & (ch < "A") OR (ch > "F");
    IF (ch = "H") OR (ch = "R") OR (ch = "X") THEN  (*hex*)
      REPEAT h := d[i];
        IF h >= 10 THEN h := h-7 END ;
        k := k*10H + h; (*no overflow check*)
        INC(i)
      UNTIL i = n;
      IF ch = "X" THEN sym := char;
        IF k < 100H THEN ival := k ELSE Mark("illegal value"); ival := 0 END
      ELSIF ch = "R" THEN sym := real; rval := SYSTEM.VAL(REAL, k)
      ELSE sym := int; ival := k
      END ;
      ReadNext
    ELSE
      IF ch = "." THEN realNum := TRUE;
        ReadNext; IF ch = "." THEN (*double dot*) ch := 7FX; realNum := FALSE END; (*interval*)
      END;
      IF realNum THEN x := 0.0; e := 0;
        REPEAT  (*integer part*)
          x := x * 10.0 + FLT(d[i]); 
          INC(i) 
        UNTIL i = n;
        WHILE (ch >= "0") & (ch <= "9") DO  (*fraction*)
          x := x * 10.0 + FLT(ORD(ch) - 30H);
          DEC(e); ReadNext
        END ;
        IF (ch = "E") OR (ch = "D") THEN  (*scale factor*)
          ReadNext; s := 0; 
          IF ch = "-" THEN negE := TRUE; ReadNext
          ELSE negE := FALSE;
            IF ch = "+" THEN ReadNext END
          END ;
          IF (ch >= "0") & (ch <= "9") THEN
            REPEAT s := s*10 + ORD(ch)-30H; ReadNext
            UNTIL (ch < "0") OR (ch >"9");
            IF negE THEN e := e-s ELSE e := e+s END
          ELSE Mark("digit?")
          END
        END ;
        IF e < 0 THEN
          IF e >= -maxExp THEN x := x / Ten(-e) ELSE x := 0.0 END
        ELSIF e > 0 THEN
          IF e <= maxExp THEN x := Ten(e) * x ELSE x := 0.0; Mark("too large") END
        END ;
        sym := real; rval := x
      ELSE  (*decimal integer*)
        REPEAT
          IF d[i] < 10 THEN
            IF k <= (max-d[i]) DIV 10 THEN k := k*10 + d[i] ELSE Mark("too large"); k := 0 END
          ELSE Mark("bad integer")
          END ;
          INC(i)
        UNTIL i = n;
        sym := int; ival := k
      END
    END
  END Number;

  PROCEDURE comment;
  BEGIN ReadNext;
    REPEAT
      WHILE ~EndOfText() & (ch # "*") DO
        IF ch = "(" THEN ReadNext;
          IF ch = "*" THEN comment END
        ELSE ReadNext
        END
      END ;
      WHILE ch = "*" DO ReadNext END
    UNTIL (ch = ")") OR EndOfText();
    IF ~EndOfText() THEN ReadNext ELSE Mark("unterminated comment") END
  END comment;

  PROCEDURE Get*(VAR sym: INTEGER);
  BEGIN
    REPEAT
      WHILE ~EndOfText() & (ch <= " ") DO ReadNext END;
      IF EndOfText() THEN sym := eot
      ELSIF ch < "A" THEN
        IF ch < "0" THEN
          IF ch = 22X THEN String; sym := string
          ELSIF ch = "#" THEN ReadNext; sym := neq
          ELSIF ch = "$" THEN HexString; sym := string
          ELSIF ch = "&" THEN ReadNext; sym := and
          ELSIF ch = "(" THEN ReadNext; 
            IF ch = "*" THEN sym := null; comment ELSE sym := lparen END
          ELSIF ch = ")" THEN ReadNext; sym := rparen
          ELSIF ch = "*" THEN ReadNext; sym := times
          ELSIF ch = "+" THEN ReadNext; sym := plus
          ELSIF ch = "," THEN ReadNext; sym := comma
          ELSIF ch = "-" THEN ReadNext; sym := minus
          ELSIF ch = "." THEN ReadNext;
            IF ch = "." THEN ReadNext; sym := upto ELSE sym := period END
          ELSIF ch = "/" THEN ReadNext; sym := rdiv
          ELSE ReadNext; (* ! % ' *) sym := null
          END
        ELSIF ch < ":" THEN Number(sym)
        ELSIF ch = ":" THEN ReadNext;
          IF ch = "=" THEN ReadNext; sym := becomes ELSE sym := colon END 
        ELSIF ch = ";" THEN ReadNext; sym := semicolon
        ELSIF ch = "<" THEN  ReadNext;
          IF ch = "=" THEN ReadNext; sym := leq ELSE sym := lss END
        ELSIF ch = "=" THEN ReadNext; sym := eql
        ELSIF ch = ">" THEN ReadNext;
          IF ch = "=" THEN ReadNext; sym := geq ELSE sym := gtr END
        ELSE (* ? @ *) ReadNext; sym := null
        END
      ELSIF ch < "[" THEN Identifier(sym)
      ELSIF ch < "a" THEN
        IF ch = "[" THEN sym := lbrak
        ELSIF ch = "]" THEN  sym := rbrak
        ELSIF ch = "^" THEN sym := arrow
        ELSE (* _ ` *) sym := null
        END ;
        ReadNext
      ELSIF ch < "{" THEN Identifier(sym) ELSE
        IF ch = "{" THEN sym := lbrace
        ELSIF ch = "}" THEN sym := rbrace
        ELSIF ch = "|" THEN sym := bar
        ELSIF ch = "~" THEN  sym := not
        ELSIF ch = 7FX THEN  sym := upto
        ELSE sym := null
        END ;
        ReadNext
      END
    UNTIL sym # null;
    lastSym := sym
  END Get;

  PROCEDURE EnterKW(sym: INTEGER; name: ARRAY OF CHAR);
  BEGIN keyTab[k].id := name; keyTab[k].sym := sym; INC(k)
  END EnterKW;

BEGIN OpenWriter;
  k := 0; KWX[0] := 0; KWX[1] := 0;
  EnterKW(if, "IF");
  EnterKW(do, "DO");
  EnterKW(of, "OF");
  EnterKW(or, "OR");
  EnterKW(to, "TO");
  EnterKW(in, "IN");
  EnterKW(is, "IS");
  EnterKW(by, "BY");
  KWX[2] := k;
  EnterKW(end, "END");
  EnterKW(nil, "NIL");
  EnterKW(var, "VAR");
  EnterKW(div, "DIV");
  EnterKW(mod, "MOD");
  EnterKW(for, "FOR");
  KWX[3] := k;
  EnterKW(else, "ELSE");
  EnterKW(then, "THEN");
  EnterKW(true, "TRUE");
  EnterKW(type, "TYPE");
  EnterKW(case, "CASE");
  KWX[4] := k;
  EnterKW(elsif, "ELSIF");
  EnterKW(false, "FALSE");
  EnterKW(array, "ARRAY");
  EnterKW(begin, "BEGIN");
  EnterKW(const, "CONST");
  EnterKW(until, "UNTIL");
  EnterKW(while, "WHILE");
  KWX[5] := k;
  EnterKW(record, "RECORD");
  EnterKW(repeat, "REPEAT");
  EnterKW(return, "RETURN");
  EnterKW(import, "IMPORT");
  EnterKW(module, "MODULE");
  KWX[6] := k;
  EnterKW(pointer, "POINTER");
  KWX[7] := k; KWX[8] := k;
  EnterKW(procedure, "PROCEDURE");
  KWX[9] := k
END ORS.

