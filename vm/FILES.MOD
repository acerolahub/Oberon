MODULE FILES;
  IMPORT SYSTEM;

  CONST UnixOpenFile = 1;
  
  TYPE FILE*    = POINTER TO FileDesc;
       FileDesc = RECORD
                    name: ARRAY 32 OF CHAR;
                    unixFileNum: INTEGER;
                  END;


  PROCEDURE Open*(VAR f: FILE; name: ARRAY OF CHAR): BOOLEAN;
  BEGIN
    NEW(f);
    f.name := name;
    f.unixFileNum := SYSTEM.CALL(UnixOpenFile, f);
    RETURN f.unixFileNum # -1
  END Open;

END FILES.
