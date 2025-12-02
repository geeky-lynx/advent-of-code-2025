#include <stdio.h>
#include <stdlib.h>

static FILE* s_file;
static char c;
static int i;

extern int get_passwd();
extern int read_from_file(char* p_direction, int* p_offset);

extern int read_from_file(char* p_direction, int* p_offset) {
  printf("%p %p\n", &c, &i);
  printf("%p %p\n", p_direction, p_offset);
  printf("%c %d\n", *p_direction, *p_offset);
  int r = fscanf(s_file, "%c%d\n", &c, &i);
  printf("read done\n");
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
  printf("The password is: %d\n", result);
  fclose(s_file);
  return 0;
}
