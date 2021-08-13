#include "VMutils.h"

int posVM = 0, nbmod = 0;
Node MODULES[NBMOD];
unsigned char VMTABLE[VMLEN];
VMvar VMVAR;
char* MODULE;
FILE* TRACEFILE;

int main(int argc, char *argv[])
{
    int opt, disass = 0;
    char* tracefile = calloc(16, 1); 
    char* module = calloc(16, 1);
    MODULE = calloc(20, 1);

    while((opt = getopt(argc, argv, "df:")) != -1)
    {
        switch(opt)
        {
            case 'd':
                printf("disassemble\n");
                disass = 1;
                break;
            case 'f':
                printf("filename: %s\n", optarg);
                strcpy(module, optarg);
        }
    }

    sprintf(tracefile, "%s.trace", module);
    TRACEFILE = fopen(tracefile, "w");
    if (!TRACEFILE) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    initVM();
    Load(module, disass);

    free(tracefile);
    fclose(TRACEFILE);
    free(MODULE);
    free(module);
    exit(EXIT_SUCCESS);
}
