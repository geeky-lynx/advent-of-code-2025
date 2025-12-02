#include <stdio.h>
#include <stdlib.h>

static FILE* s_file;
static char c;
static int i;

extern int get_passwd();
extern int read_from_file(char* p_direction, int* p_offset);

extern int read_from_file(char* p_direction, int* p_offset) {
  static int rc = 0;
  int r = fscanf(s_file, "%c%d\n", &c, &i); // but not dis
  printf("fscanf ret val = %d\n", r);
  printf("#%d: read done (with c = %c, i = %d)\n", rc++, c, i);
  *p_direction = c;
  *p_offset = i;
  return r;
}

int main() {
  s_file = fopen("input.txt", "r");
  if (s_file == NULL) {
    printf("Error opening a file\n");
    return -1;
  }
  int result = get_passwd();
  printf("The password is: %d (%x)\n", result, result);
  fclose(s_file);
  return 0;
}
