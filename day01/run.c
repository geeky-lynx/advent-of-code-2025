#include <stdio.h>
#include <stdlib.h>

static FILE* s_file;

extern int get_passwd();
extern int read_from_file(char* p_direction, int* p_offset);

extern int read_from_file(char* p_direction, int* p_offset) {
  return fscanf(s_file, "%c%d\n", p_direction, p_offset);
}

int main(int argc, char **argv) {
  if (argc != 2) {
    printf(".txt source is needed\n");
    return -2;
  }
  s_file = fopen(argv[1], "r");
  if (s_file == NULL) {
    printf("Error opening a file\n");
    return -1;
  }
  int result = get_passwd();
  printf("The password is: %d (%x)\n", result, result);
  fclose(s_file);
  return 0;
}
