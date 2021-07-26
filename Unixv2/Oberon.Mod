MODULE Oberon;
  IMPORT In, Out, Files, ORS, ORP;

  VAR 
    file: Files.File;
    filename: ARRAY 32 OF CHAR;

BEGIN
  WHILE 1=1 DO
    Out.String("File to compile: "); In.String(filename);
    file := Files.Old(filename);
    IF file=NIL THEN Out.String("File not found."); Out.Ln
    ELSE
      ORS.Init(file, 0);
      ORP.Module
    END;
    Files.Close(file)
  END
END Oberon.
