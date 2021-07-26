#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>

typedef enum {BADCALL, OPENFILE, CREATFILE, CONOUT} syscalls;

const int TRAP = 0xC3;

int traps(int syscallnum, void *param){
  char *name;
  switch (syscallnum){
    case OPENFILE: 
      name = (char *) param;
      return open(name, O_RDWR);
    case CREATFILE:
      name = (char *) param;
      return creat(name, 0);
    case CONOUT:
      putchar((char)name[0]);
      return 0;
    default:
      return 0;
  }
}
