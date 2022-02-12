#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
void filter(int *p);
int main(int argc, char *argv[])
{
   if (argc > 1) {
    fprintf(2, "Usage: primes\n");
    exit(1);
  }
    int pin[2];
    pipe(pin);
    for(int i=2; i<= 35; i++)
    {
      write(pin[1],&i, sizeof(int));
    }
    close(pin[1]);
    filter(pin);
    exit(0);
    return 0;
}
void filter(int *pin)
{
    close(pin[1]);
    int pout[2],first,n; 
    if(read(pin[0], &first, sizeof(int)))
    {
    printf("prime %d\n", first);
    pipe(pout);
    if(fork()==0)
    {   
        filter(pout);
        exit (0);
    }
    close(pout[0]);
    while(read(pin[0],&n, sizeof(int)>0))
    {
      if(n % first != 0)
      {
          write(pout[1],&n, sizeof(int));
      }
    }
    close(pin[0]);
    close(pout[1]);
    }
    exit (0);
    
    

}