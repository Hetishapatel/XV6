#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int main(int argc, char *argv[])
{
    int p1[2],p2[2];  // file descriptors for pipe
    char buf[1];

    pipe(p1);
    pipe(p2);

    if (fork() == 0) {  // child
        read(p1[0], buf, 1);
        printf("%d: received ping\n", getpid());
        close(p1[0]);

        write(p2[1], buf, 1);
        close(p2[1]);

    } else {  // parent
        write(p1[1], buf, 1);
        //wait(0); // this fixes the problem.  but why?
        close(p1[1]);

        read(p2[0], buf, 1);
        printf("%d: received pong\n", getpid());
        close(p2[0]);
    }
    exit(0);
}