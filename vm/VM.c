#include "VMutils.h"

const char* filename = "Pattern1.rsc";

int main(void) {
    int nofimps, i, td, datasize, strx, pc, nbbytes;

    char buffer[maxlength];

    FILE* in_file = fopen(filename, "rb");
    if (!in_file) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    struct stat sb;
    if (stat(filename, &sb) == -1) {
        perror("stat");
        exit(EXIT_FAILURE);
    }

    fseek(in_file, 0, SEEK_SET);
    ReadWord(in_file, buffer);
    printf("\nModule: %s\n", buffer);

    Read(in_file, 4);  // we read the key

    // nbr of imported modules
    nofimps = Read(in_file, 1);
    printf("\nNbr of imports: %d\n", nofimps);

    i = 0;
    while(i<nofimps){
        // Loader les modules importés ici
        ReadWord(in_file, buffer);
        i++;
    }

    // type descriptor
    td = Read(in_file, 4);
    printf("\ntdx*4 = %d\n", td);

    i = 0;
    while(i < td/4){
        printf("%d ", Read(in_file, 4));
        i++;
    }
    printf("\n");

    // data
    datasize = Read(in_file, 4);
    printf("\ndatasize = %d\n", datasize);

    // strx
    strx = Read(in_file, 4);
    printf("\nstrx = %d\n", strx);

    // bytesnbr
    nbbytes = Read(in_file, 4);
    printf("\nnbbytes = %d\n", nbbytes);

    // pc number
    pc = Read(in_file, 4);
    printf("\npc = %d\n", pc);

    // code loading
    CodeLoading(in_file, pc);
    


    char* file_contents = malloc(sb.st_size);
    fread(file_contents, sb.st_size, 1, in_file);

    fseek(in_file, sb.st_size-4, SEEK_SET);

    printf("read data: %s\n", file_contents);
    printf("%d %d", sb.st_size, Read(in_file, 4));

    fseek(in_file, 0, SEEK_SET);
    printf("\n%d, %s\n", ReadWord(in_file, buffer), buffer);

    fclose(in_file);

    free(file_contents);
    exit(EXIT_SUCCESS);
}

