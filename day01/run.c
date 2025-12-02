#include <stdio.h>

extern int read_from_file(FILE* p_file, char* p_direction, int* p_offset);

extern int read_from_file(FILE* p_file, char* p_direction, int* p_offset) {
  char dir = 0;
  int offs = 0;
  int res = fscanf(p_file, "%c%d\n", &dir, &offs);
  *p_direction = dir;
  *p_offset = offs;
  return res;
}

extern int get_passwd();

int main() {
  int result = get_passwd();
  printf("The password is: %d\n", result);
  return 0;
}
