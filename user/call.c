#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
  return x+3;
}

int f(int x) {
  return g(x);
}

void main(void) {
  printf("%d %d\n", f(8)+1, 13);
  // unsigned int i = 0x00646c72;
	// printf("H%x Wo%s", 57616, &i);
  // printf("x=%d y=%d", 3);
   exit(0);
}
/* 0x72 -> r
   0x6c -> l
   0x64 -> d
  if RISC-V was big endian the value of i should be 0x726c6400 to get same output
  and 57616 is 0xE110 so no need to change this 
  */

 /* prints out random value*/
 /* An inline function is one for which the compiler copies the code from the function definition 
  directly into the code of the calling function rather than 
  creating a separate set of instructions in memory.*/