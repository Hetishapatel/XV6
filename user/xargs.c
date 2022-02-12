# include  "kernel/types.h"
# include  "kernel/stat.h"
# include  "user/user.h"
# include  "kernel/param.h"   // MAXARG


int
 main( int argc, char *argv[]) 
{ 
    char buf[1024], character; 
    char *p = buf; 
    char *args[MAXARG]; 
    int i; 
    int offset = 0 ;
		
	

	if (argc < 2)
    { 
        fprintf(2, "usage: xargs <command> [argv...]\n" );
         exit (0);
    }	


	for (i = 1 ; i < argc; i++) { 
		args[i-1 ] = argv[i]; 
	} 
    
	i--;   // i= argc-1

	while (read(0, &character, 1 ) > 0 ) {

		if (character == '\n' || character == ' ') { 
            //printf("*\n");
			args[i] = p;            
            i++; 
			p = buf + offset;
	        if (fork()==0) 
            {
               exec(args[0], args);
               exit(0); 
            }
                wait(0);
                i = argc-1;
			
		} 
        else { 
            buf[offset++] = character; 
        }  
    }
    exit ( 0 ); 
}