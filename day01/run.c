#include <stdio.h>

extern int get_passwd();

int main() {
  int result = get_passwd();
  printf("The password is: %d\n", result);
  return 0;
}
