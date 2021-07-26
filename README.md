# Compiler

Oberon compiler with code generation for the VM

Changes in OBNC
- OBNCConfig.h
    - #define OBNC_CONFIG_C_REAL_TYPE OBNC_CONFIG_DOUBLE
    + #define OBNC_CONFIG_C_REAL_TYPE OBNC_CONFIG_FLOAT

- OBNC.h
    - #define OBNC_VAL(T, n) ( (T ) (n))
    + #define OBNC_VAL(T, n) (*(T *) &(n))


# VM

Definition and implementation of the Virtual Machine
