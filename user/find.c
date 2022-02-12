#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void find(char *path, char *file )
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){  // open the path
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){  // check the size of the path
      printf("find: path too long\n");
      exit(0);
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){  // do not read '.' or '..' 
      if(de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){  // check status 
        printf("find: cannot stat %s\n", buf);
        continue;
      }
      if (st.type == T_DIR) { //if dir traverse through it
            find(buf, file);
        } else if (strcmp(de.name, file) == 0) {    // if matched then output the file
            printf("%s\n", buf);
        }
    }
  close(fd);
}

int
main(int argc, char *argv[])
{

  if(argc >3 || argc < 2){
    fprintf(2,"Usage: find <path> <file>\n ");
    exit(0);
    }
  else if(argc<3){
      find(".",argv[1]);
  } 
  else {
    find(argv[1],argv[2]);
  } 
    
  
  exit(0);
}