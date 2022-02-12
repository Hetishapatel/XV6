
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	300080e7          	jalr	768(ra) # 310 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2d4080e7          	jalr	724(ra) # 310 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2b2080e7          	jalr	690(ra) # 310 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	aaa98993          	addi	s3,s3,-1366 # b10 <buf.1112>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	412080e7          	jalr	1042(ra) # 488 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	290080e7          	jalr	656(ra) # 310 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	282080e7          	jalr	642(ra) # 310 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	292080e7          	jalr	658(ra) # 33a <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <find>:

void find(char *path, char *file )
{
  b4:	d8010113          	addi	sp,sp,-640
  b8:	26113c23          	sd	ra,632(sp)
  bc:	26813823          	sd	s0,624(sp)
  c0:	26913423          	sd	s1,616(sp)
  c4:	27213023          	sd	s2,608(sp)
  c8:	25313c23          	sd	s3,600(sp)
  cc:	25413823          	sd	s4,592(sp)
  d0:	25513423          	sd	s5,584(sp)
  d4:	25613023          	sd	s6,576(sp)
  d8:	23713c23          	sd	s7,568(sp)
  dc:	0500                	addi	s0,sp,640
  de:	892a                	mv	s2,a0
  e0:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){  // open the path
  e2:	4581                	li	a1,0
  e4:	00000097          	auipc	ra,0x0
  e8:	49a080e7          	jalr	1178(ra) # 57e <open>
  ec:	0e054963          	bltz	a0,1de <find+0x12a>
  f0:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){  // check the size of the path
  f2:	854a                	mv	a0,s2
  f4:	00000097          	auipc	ra,0x0
  f8:	21c080e7          	jalr	540(ra) # 310 <strlen>
  fc:	2541                	addiw	a0,a0,16
  fe:	20000793          	li	a5,512
 102:	0ea7e963          	bltu	a5,a0,1f4 <find+0x140>
      printf("find: path too long\n");
      exit(0);
    }
    strcpy(buf, path);
 106:	85ca                	mv	a1,s2
 108:	db040513          	addi	a0,s0,-592
 10c:	00000097          	auipc	ra,0x0
 110:	1bc080e7          	jalr	444(ra) # 2c8 <strcpy>
    p = buf+strlen(buf);
 114:	db040513          	addi	a0,s0,-592
 118:	00000097          	auipc	ra,0x0
 11c:	1f8080e7          	jalr	504(ra) # 310 <strlen>
 120:	02051913          	slli	s2,a0,0x20
 124:	02095913          	srli	s2,s2,0x20
 128:	db040793          	addi	a5,s0,-592
 12c:	993e                	add	s2,s2,a5
    *p++ = '/';
 12e:	00190b13          	addi	s6,s2,1
 132:	02f00793          	li	a5,47
 136:	00f90023          	sb	a5,0(s2)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){  // do not read '.' or '..' 
      if(de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 13a:	00001a97          	auipc	s5,0x1
 13e:	95ea8a93          	addi	s5,s5,-1698 # a98 <malloc+0x114>
 142:	00001b97          	auipc	s7,0x1
 146:	95eb8b93          	addi	s7,s7,-1698 # aa0 <malloc+0x11c>
 14a:	da240a13          	addi	s4,s0,-606
    while(read(fd, &de, sizeof(de)) == sizeof(de)){  // do not read '.' or '..' 
 14e:	4641                	li	a2,16
 150:	da040593          	addi	a1,s0,-608
 154:	8526                	mv	a0,s1
 156:	00000097          	auipc	ra,0x0
 15a:	400080e7          	jalr	1024(ra) # 556 <read>
 15e:	47c1                	li	a5,16
 160:	0cf51a63          	bne	a0,a5,234 <find+0x180>
      if(de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 164:	da045783          	lhu	a5,-608(s0)
 168:	d3fd                	beqz	a5,14e <find+0x9a>
 16a:	85d6                	mv	a1,s5
 16c:	8552                	mv	a0,s4
 16e:	00000097          	auipc	ra,0x0
 172:	176080e7          	jalr	374(ra) # 2e4 <strcmp>
 176:	dd61                	beqz	a0,14e <find+0x9a>
 178:	85de                	mv	a1,s7
 17a:	8552                	mv	a0,s4
 17c:	00000097          	auipc	ra,0x0
 180:	168080e7          	jalr	360(ra) # 2e4 <strcmp>
 184:	d569                	beqz	a0,14e <find+0x9a>
        continue;
      memmove(p, de.name, DIRSIZ);
 186:	4639                	li	a2,14
 188:	da240593          	addi	a1,s0,-606
 18c:	855a                	mv	a0,s6
 18e:	00000097          	auipc	ra,0x0
 192:	2fa080e7          	jalr	762(ra) # 488 <memmove>
      p[DIRSIZ] = 0;
 196:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){  // check status 
 19a:	d8840593          	addi	a1,s0,-632
 19e:	db040513          	addi	a0,s0,-592
 1a2:	00000097          	auipc	ra,0x0
 1a6:	256080e7          	jalr	598(ra) # 3f8 <stat>
 1aa:	06054263          	bltz	a0,20e <find+0x15a>
        printf("find: cannot stat %s\n", buf);
        continue;
      }
      if (st.type == T_DIR) { //if dir traverse through it
 1ae:	d9041703          	lh	a4,-624(s0)
 1b2:	4785                	li	a5,1
 1b4:	06f70863          	beq	a4,a5,224 <find+0x170>
            find(buf, file);
        } else if (strcmp(de.name, file) == 0) {    // if matched then output the file
 1b8:	85ce                	mv	a1,s3
 1ba:	da240513          	addi	a0,s0,-606
 1be:	00000097          	auipc	ra,0x0
 1c2:	126080e7          	jalr	294(ra) # 2e4 <strcmp>
 1c6:	f541                	bnez	a0,14e <find+0x9a>
            printf("%s\n", buf);
 1c8:	db040593          	addi	a1,s0,-592
 1cc:	00001517          	auipc	a0,0x1
 1d0:	8f450513          	addi	a0,a0,-1804 # ac0 <malloc+0x13c>
 1d4:	00000097          	auipc	ra,0x0
 1d8:	6f2080e7          	jalr	1778(ra) # 8c6 <printf>
 1dc:	bf8d                	j	14e <find+0x9a>
    fprintf(2, "find: cannot open %s\n", path);
 1de:	864a                	mv	a2,s2
 1e0:	00001597          	auipc	a1,0x1
 1e4:	88858593          	addi	a1,a1,-1912 # a68 <malloc+0xe4>
 1e8:	4509                	li	a0,2
 1ea:	00000097          	auipc	ra,0x0
 1ee:	6ae080e7          	jalr	1710(ra) # 898 <fprintf>
    return;
 1f2:	a0b1                	j	23e <find+0x18a>
      printf("find: path too long\n");
 1f4:	00001517          	auipc	a0,0x1
 1f8:	88c50513          	addi	a0,a0,-1908 # a80 <malloc+0xfc>
 1fc:	00000097          	auipc	ra,0x0
 200:	6ca080e7          	jalr	1738(ra) # 8c6 <printf>
      exit(0);
 204:	4501                	li	a0,0
 206:	00000097          	auipc	ra,0x0
 20a:	338080e7          	jalr	824(ra) # 53e <exit>
        printf("find: cannot stat %s\n", buf);
 20e:	db040593          	addi	a1,s0,-592
 212:	00001517          	auipc	a0,0x1
 216:	89650513          	addi	a0,a0,-1898 # aa8 <malloc+0x124>
 21a:	00000097          	auipc	ra,0x0
 21e:	6ac080e7          	jalr	1708(ra) # 8c6 <printf>
        continue;
 222:	b735                	j	14e <find+0x9a>
            find(buf, file);
 224:	85ce                	mv	a1,s3
 226:	db040513          	addi	a0,s0,-592
 22a:	00000097          	auipc	ra,0x0
 22e:	e8a080e7          	jalr	-374(ra) # b4 <find>
 232:	bf31                	j	14e <find+0x9a>
        }
    }
  close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	330080e7          	jalr	816(ra) # 566 <close>
}
 23e:	27813083          	ld	ra,632(sp)
 242:	27013403          	ld	s0,624(sp)
 246:	26813483          	ld	s1,616(sp)
 24a:	26013903          	ld	s2,608(sp)
 24e:	25813983          	ld	s3,600(sp)
 252:	25013a03          	ld	s4,592(sp)
 256:	24813a83          	ld	s5,584(sp)
 25a:	24013b03          	ld	s6,576(sp)
 25e:	23813b83          	ld	s7,568(sp)
 262:	28010113          	addi	sp,sp,640
 266:	8082                	ret

0000000000000268 <main>:

int
main(int argc, char *argv[])
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16

  if(argc >3 || argc < 2){
 270:	ffe5069b          	addiw	a3,a0,-2
 274:	4705                	li	a4,1
 276:	02d76463          	bltu	a4,a3,29e <main+0x36>
 27a:	87ae                	mv	a5,a1
    fprintf(2,"Usage: find <path> <file>\n ");
    exit(0);
    }
  else if(argc<3){
 27c:	4709                	li	a4,2
 27e:	02a74e63          	blt	a4,a0,2ba <main+0x52>
      find(".",argv[1]);
 282:	658c                	ld	a1,8(a1)
 284:	00001517          	auipc	a0,0x1
 288:	81450513          	addi	a0,a0,-2028 # a98 <malloc+0x114>
 28c:	00000097          	auipc	ra,0x0
 290:	e28080e7          	jalr	-472(ra) # b4 <find>
  else {
    find(argv[1],argv[2]);
  } 
    
  
  exit(0);
 294:	4501                	li	a0,0
 296:	00000097          	auipc	ra,0x0
 29a:	2a8080e7          	jalr	680(ra) # 53e <exit>
    fprintf(2,"Usage: find <path> <file>\n ");
 29e:	00001597          	auipc	a1,0x1
 2a2:	82a58593          	addi	a1,a1,-2006 # ac8 <malloc+0x144>
 2a6:	4509                	li	a0,2
 2a8:	00000097          	auipc	ra,0x0
 2ac:	5f0080e7          	jalr	1520(ra) # 898 <fprintf>
    exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	28c080e7          	jalr	652(ra) # 53e <exit>
    find(argv[1],argv[2]);
 2ba:	698c                	ld	a1,16(a1)
 2bc:	6788                	ld	a0,8(a5)
 2be:	00000097          	auipc	ra,0x0
 2c2:	df6080e7          	jalr	-522(ra) # b4 <find>
 2c6:	b7f9                	j	294 <main+0x2c>

00000000000002c8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ce:	87aa                	mv	a5,a0
 2d0:	0585                	addi	a1,a1,1
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff5c703          	lbu	a4,-1(a1)
 2d8:	fee78fa3          	sb	a4,-1(a5)
 2dc:	fb75                	bnez	a4,2d0 <strcpy+0x8>
    ;
  return os;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	cb91                	beqz	a5,302 <strcmp+0x1e>
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00f71763          	bne	a4,a5,302 <strcmp+0x1e>
    p++, q++;
 2f8:	0505                	addi	a0,a0,1
 2fa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	fbe5                	bnez	a5,2f0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 302:	0005c503          	lbu	a0,0(a1)
}
 306:	40a7853b          	subw	a0,a5,a0
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <strlen>:

uint
strlen(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cf91                	beqz	a5,336 <strlen+0x26>
 31c:	0505                	addi	a0,a0,1
 31e:	87aa                	mv	a5,a0
 320:	4685                	li	a3,1
 322:	9e89                	subw	a3,a3,a0
 324:	00f6853b          	addw	a0,a3,a5
 328:	0785                	addi	a5,a5,1
 32a:	fff7c703          	lbu	a4,-1(a5)
 32e:	fb7d                	bnez	a4,324 <strlen+0x14>
    ;
  return n;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
  for(n = 0; s[n]; n++)
 336:	4501                	li	a0,0
 338:	bfe5                	j	330 <strlen+0x20>

000000000000033a <memset>:

void*
memset(void *dst, int c, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 340:	ce09                	beqz	a2,35a <memset+0x20>
 342:	87aa                	mv	a5,a0
 344:	fff6071b          	addiw	a4,a2,-1
 348:	1702                	slli	a4,a4,0x20
 34a:	9301                	srli	a4,a4,0x20
 34c:	0705                	addi	a4,a4,1
 34e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 350:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 354:	0785                	addi	a5,a5,1
 356:	fee79de3          	bne	a5,a4,350 <memset+0x16>
  }
  return dst;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
  for(; *s; s++)
 366:	00054783          	lbu	a5,0(a0)
 36a:	cb99                	beqz	a5,380 <strchr+0x20>
    if(*s == c)
 36c:	00f58763          	beq	a1,a5,37a <strchr+0x1a>
  for(; *s; s++)
 370:	0505                	addi	a0,a0,1
 372:	00054783          	lbu	a5,0(a0)
 376:	fbfd                	bnez	a5,36c <strchr+0xc>
      return (char*)s;
  return 0;
 378:	4501                	li	a0,0
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  return 0;
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <strchr+0x1a>

0000000000000384 <gets>:

char*
gets(char *buf, int max)
{
 384:	711d                	addi	sp,sp,-96
 386:	ec86                	sd	ra,88(sp)
 388:	e8a2                	sd	s0,80(sp)
 38a:	e4a6                	sd	s1,72(sp)
 38c:	e0ca                	sd	s2,64(sp)
 38e:	fc4e                	sd	s3,56(sp)
 390:	f852                	sd	s4,48(sp)
 392:	f456                	sd	s5,40(sp)
 394:	f05a                	sd	s6,32(sp)
 396:	ec5e                	sd	s7,24(sp)
 398:	1080                	addi	s0,sp,96
 39a:	8baa                	mv	s7,a0
 39c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39e:	892a                	mv	s2,a0
 3a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3a2:	4aa9                	li	s5,10
 3a4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3a6:	89a6                	mv	s3,s1
 3a8:	2485                	addiw	s1,s1,1
 3aa:	0344d863          	bge	s1,s4,3da <gets+0x56>
    cc = read(0, &c, 1);
 3ae:	4605                	li	a2,1
 3b0:	faf40593          	addi	a1,s0,-81
 3b4:	4501                	li	a0,0
 3b6:	00000097          	auipc	ra,0x0
 3ba:	1a0080e7          	jalr	416(ra) # 556 <read>
    if(cc < 1)
 3be:	00a05e63          	blez	a0,3da <gets+0x56>
    buf[i++] = c;
 3c2:	faf44783          	lbu	a5,-81(s0)
 3c6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ca:	01578763          	beq	a5,s5,3d8 <gets+0x54>
 3ce:	0905                	addi	s2,s2,1
 3d0:	fd679be3          	bne	a5,s6,3a6 <gets+0x22>
  for(i=0; i+1 < max; ){
 3d4:	89a6                	mv	s3,s1
 3d6:	a011                	j	3da <gets+0x56>
 3d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3da:	99de                	add	s3,s3,s7
 3dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 3e0:	855e                	mv	a0,s7
 3e2:	60e6                	ld	ra,88(sp)
 3e4:	6446                	ld	s0,80(sp)
 3e6:	64a6                	ld	s1,72(sp)
 3e8:	6906                	ld	s2,64(sp)
 3ea:	79e2                	ld	s3,56(sp)
 3ec:	7a42                	ld	s4,48(sp)
 3ee:	7aa2                	ld	s5,40(sp)
 3f0:	7b02                	ld	s6,32(sp)
 3f2:	6be2                	ld	s7,24(sp)
 3f4:	6125                	addi	sp,sp,96
 3f6:	8082                	ret

00000000000003f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f8:	1101                	addi	sp,sp,-32
 3fa:	ec06                	sd	ra,24(sp)
 3fc:	e822                	sd	s0,16(sp)
 3fe:	e426                	sd	s1,8(sp)
 400:	e04a                	sd	s2,0(sp)
 402:	1000                	addi	s0,sp,32
 404:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 406:	4581                	li	a1,0
 408:	00000097          	auipc	ra,0x0
 40c:	176080e7          	jalr	374(ra) # 57e <open>
  if(fd < 0)
 410:	02054563          	bltz	a0,43a <stat+0x42>
 414:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 416:	85ca                	mv	a1,s2
 418:	00000097          	auipc	ra,0x0
 41c:	17e080e7          	jalr	382(ra) # 596 <fstat>
 420:	892a                	mv	s2,a0
  close(fd);
 422:	8526                	mv	a0,s1
 424:	00000097          	auipc	ra,0x0
 428:	142080e7          	jalr	322(ra) # 566 <close>
  return r;
}
 42c:	854a                	mv	a0,s2
 42e:	60e2                	ld	ra,24(sp)
 430:	6442                	ld	s0,16(sp)
 432:	64a2                	ld	s1,8(sp)
 434:	6902                	ld	s2,0(sp)
 436:	6105                	addi	sp,sp,32
 438:	8082                	ret
    return -1;
 43a:	597d                	li	s2,-1
 43c:	bfc5                	j	42c <stat+0x34>

000000000000043e <atoi>:

int
atoi(const char *s)
{
 43e:	1141                	addi	sp,sp,-16
 440:	e422                	sd	s0,8(sp)
 442:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 444:	00054603          	lbu	a2,0(a0)
 448:	fd06079b          	addiw	a5,a2,-48
 44c:	0ff7f793          	andi	a5,a5,255
 450:	4725                	li	a4,9
 452:	02f76963          	bltu	a4,a5,484 <atoi+0x46>
 456:	86aa                	mv	a3,a0
  n = 0;
 458:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 45a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 45c:	0685                	addi	a3,a3,1
 45e:	0025179b          	slliw	a5,a0,0x2
 462:	9fa9                	addw	a5,a5,a0
 464:	0017979b          	slliw	a5,a5,0x1
 468:	9fb1                	addw	a5,a5,a2
 46a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 46e:	0006c603          	lbu	a2,0(a3)
 472:	fd06071b          	addiw	a4,a2,-48
 476:	0ff77713          	andi	a4,a4,255
 47a:	fee5f1e3          	bgeu	a1,a4,45c <atoi+0x1e>
  return n;
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  n = 0;
 484:	4501                	li	a0,0
 486:	bfe5                	j	47e <atoi+0x40>

0000000000000488 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e422                	sd	s0,8(sp)
 48c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 48e:	02b57663          	bgeu	a0,a1,4ba <memmove+0x32>
    while(n-- > 0)
 492:	02c05163          	blez	a2,4b4 <memmove+0x2c>
 496:	fff6079b          	addiw	a5,a2,-1
 49a:	1782                	slli	a5,a5,0x20
 49c:	9381                	srli	a5,a5,0x20
 49e:	0785                	addi	a5,a5,1
 4a0:	97aa                	add	a5,a5,a0
  dst = vdst;
 4a2:	872a                	mv	a4,a0
      *dst++ = *src++;
 4a4:	0585                	addi	a1,a1,1
 4a6:	0705                	addi	a4,a4,1
 4a8:	fff5c683          	lbu	a3,-1(a1)
 4ac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4b0:	fee79ae3          	bne	a5,a4,4a4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4b4:	6422                	ld	s0,8(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret
    dst += n;
 4ba:	00c50733          	add	a4,a0,a2
    src += n;
 4be:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4c0:	fec05ae3          	blez	a2,4b4 <memmove+0x2c>
 4c4:	fff6079b          	addiw	a5,a2,-1
 4c8:	1782                	slli	a5,a5,0x20
 4ca:	9381                	srli	a5,a5,0x20
 4cc:	fff7c793          	not	a5,a5
 4d0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d2:	15fd                	addi	a1,a1,-1
 4d4:	177d                	addi	a4,a4,-1
 4d6:	0005c683          	lbu	a3,0(a1)
 4da:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4de:	fee79ae3          	bne	a5,a4,4d2 <memmove+0x4a>
 4e2:	bfc9                	j	4b4 <memmove+0x2c>

00000000000004e4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4e4:	1141                	addi	sp,sp,-16
 4e6:	e422                	sd	s0,8(sp)
 4e8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ea:	ca05                	beqz	a2,51a <memcmp+0x36>
 4ec:	fff6069b          	addiw	a3,a2,-1
 4f0:	1682                	slli	a3,a3,0x20
 4f2:	9281                	srli	a3,a3,0x20
 4f4:	0685                	addi	a3,a3,1
 4f6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4f8:	00054783          	lbu	a5,0(a0)
 4fc:	0005c703          	lbu	a4,0(a1)
 500:	00e79863          	bne	a5,a4,510 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 504:	0505                	addi	a0,a0,1
    p2++;
 506:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 508:	fed518e3          	bne	a0,a3,4f8 <memcmp+0x14>
  }
  return 0;
 50c:	4501                	li	a0,0
 50e:	a019                	j	514 <memcmp+0x30>
      return *p1 - *p2;
 510:	40e7853b          	subw	a0,a5,a4
}
 514:	6422                	ld	s0,8(sp)
 516:	0141                	addi	sp,sp,16
 518:	8082                	ret
  return 0;
 51a:	4501                	li	a0,0
 51c:	bfe5                	j	514 <memcmp+0x30>

000000000000051e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 51e:	1141                	addi	sp,sp,-16
 520:	e406                	sd	ra,8(sp)
 522:	e022                	sd	s0,0(sp)
 524:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 526:	00000097          	auipc	ra,0x0
 52a:	f62080e7          	jalr	-158(ra) # 488 <memmove>
}
 52e:	60a2                	ld	ra,8(sp)
 530:	6402                	ld	s0,0(sp)
 532:	0141                	addi	sp,sp,16
 534:	8082                	ret

0000000000000536 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 536:	4885                	li	a7,1
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <exit>:
.global exit
exit:
 li a7, SYS_exit
 53e:	4889                	li	a7,2
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <wait>:
.global wait
wait:
 li a7, SYS_wait
 546:	488d                	li	a7,3
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 54e:	4891                	li	a7,4
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <read>:
.global read
read:
 li a7, SYS_read
 556:	4895                	li	a7,5
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <write>:
.global write
write:
 li a7, SYS_write
 55e:	48c1                	li	a7,16
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <close>:
.global close
close:
 li a7, SYS_close
 566:	48d5                	li	a7,21
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <kill>:
.global kill
kill:
 li a7, SYS_kill
 56e:	4899                	li	a7,6
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <exec>:
.global exec
exec:
 li a7, SYS_exec
 576:	489d                	li	a7,7
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <open>:
.global open
open:
 li a7, SYS_open
 57e:	48bd                	li	a7,15
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 586:	48c5                	li	a7,17
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 58e:	48c9                	li	a7,18
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 596:	48a1                	li	a7,8
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <link>:
.global link
link:
 li a7, SYS_link
 59e:	48cd                	li	a7,19
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5a6:	48d1                	li	a7,20
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ae:	48a5                	li	a7,9
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5b6:	48a9                	li	a7,10
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5be:	48ad                	li	a7,11
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5c6:	48b1                	li	a7,12
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ce:	48b5                	li	a7,13
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5d6:	48b9                	li	a7,14
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <trace>:
.global trace
trace:
 li a7, SYS_trace
 5de:	48d9                	li	a7,22
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5e6:	48dd                	li	a7,23
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ee:	1101                	addi	sp,sp,-32
 5f0:	ec06                	sd	ra,24(sp)
 5f2:	e822                	sd	s0,16(sp)
 5f4:	1000                	addi	s0,sp,32
 5f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5fa:	4605                	li	a2,1
 5fc:	fef40593          	addi	a1,s0,-17
 600:	00000097          	auipc	ra,0x0
 604:	f5e080e7          	jalr	-162(ra) # 55e <write>
}
 608:	60e2                	ld	ra,24(sp)
 60a:	6442                	ld	s0,16(sp)
 60c:	6105                	addi	sp,sp,32
 60e:	8082                	ret

0000000000000610 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 610:	7139                	addi	sp,sp,-64
 612:	fc06                	sd	ra,56(sp)
 614:	f822                	sd	s0,48(sp)
 616:	f426                	sd	s1,40(sp)
 618:	f04a                	sd	s2,32(sp)
 61a:	ec4e                	sd	s3,24(sp)
 61c:	0080                	addi	s0,sp,64
 61e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 620:	c299                	beqz	a3,626 <printint+0x16>
 622:	0805c863          	bltz	a1,6b2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 626:	2581                	sext.w	a1,a1
  neg = 0;
 628:	4881                	li	a7,0
 62a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 62e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 630:	2601                	sext.w	a2,a2
 632:	00000517          	auipc	a0,0x0
 636:	4be50513          	addi	a0,a0,1214 # af0 <digits>
 63a:	883a                	mv	a6,a4
 63c:	2705                	addiw	a4,a4,1
 63e:	02c5f7bb          	remuw	a5,a1,a2
 642:	1782                	slli	a5,a5,0x20
 644:	9381                	srli	a5,a5,0x20
 646:	97aa                	add	a5,a5,a0
 648:	0007c783          	lbu	a5,0(a5)
 64c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 650:	0005879b          	sext.w	a5,a1
 654:	02c5d5bb          	divuw	a1,a1,a2
 658:	0685                	addi	a3,a3,1
 65a:	fec7f0e3          	bgeu	a5,a2,63a <printint+0x2a>
  if(neg)
 65e:	00088b63          	beqz	a7,674 <printint+0x64>
    buf[i++] = '-';
 662:	fd040793          	addi	a5,s0,-48
 666:	973e                	add	a4,a4,a5
 668:	02d00793          	li	a5,45
 66c:	fef70823          	sb	a5,-16(a4)
 670:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 674:	02e05863          	blez	a4,6a4 <printint+0x94>
 678:	fc040793          	addi	a5,s0,-64
 67c:	00e78933          	add	s2,a5,a4
 680:	fff78993          	addi	s3,a5,-1
 684:	99ba                	add	s3,s3,a4
 686:	377d                	addiw	a4,a4,-1
 688:	1702                	slli	a4,a4,0x20
 68a:	9301                	srli	a4,a4,0x20
 68c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 690:	fff94583          	lbu	a1,-1(s2)
 694:	8526                	mv	a0,s1
 696:	00000097          	auipc	ra,0x0
 69a:	f58080e7          	jalr	-168(ra) # 5ee <putc>
  while(--i >= 0)
 69e:	197d                	addi	s2,s2,-1
 6a0:	ff3918e3          	bne	s2,s3,690 <printint+0x80>
}
 6a4:	70e2                	ld	ra,56(sp)
 6a6:	7442                	ld	s0,48(sp)
 6a8:	74a2                	ld	s1,40(sp)
 6aa:	7902                	ld	s2,32(sp)
 6ac:	69e2                	ld	s3,24(sp)
 6ae:	6121                	addi	sp,sp,64
 6b0:	8082                	ret
    x = -xx;
 6b2:	40b005bb          	negw	a1,a1
    neg = 1;
 6b6:	4885                	li	a7,1
    x = -xx;
 6b8:	bf8d                	j	62a <printint+0x1a>

00000000000006ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ba:	7119                	addi	sp,sp,-128
 6bc:	fc86                	sd	ra,120(sp)
 6be:	f8a2                	sd	s0,112(sp)
 6c0:	f4a6                	sd	s1,104(sp)
 6c2:	f0ca                	sd	s2,96(sp)
 6c4:	ecce                	sd	s3,88(sp)
 6c6:	e8d2                	sd	s4,80(sp)
 6c8:	e4d6                	sd	s5,72(sp)
 6ca:	e0da                	sd	s6,64(sp)
 6cc:	fc5e                	sd	s7,56(sp)
 6ce:	f862                	sd	s8,48(sp)
 6d0:	f466                	sd	s9,40(sp)
 6d2:	f06a                	sd	s10,32(sp)
 6d4:	ec6e                	sd	s11,24(sp)
 6d6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d8:	0005c903          	lbu	s2,0(a1)
 6dc:	18090f63          	beqz	s2,87a <vprintf+0x1c0>
 6e0:	8aaa                	mv	s5,a0
 6e2:	8b32                	mv	s6,a2
 6e4:	00158493          	addi	s1,a1,1
  state = 0;
 6e8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ea:	02500a13          	li	s4,37
      if(c == 'd'){
 6ee:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6f2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6f6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6fa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fe:	00000b97          	auipc	s7,0x0
 702:	3f2b8b93          	addi	s7,s7,1010 # af0 <digits>
 706:	a839                	j	724 <vprintf+0x6a>
        putc(fd, c);
 708:	85ca                	mv	a1,s2
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	ee2080e7          	jalr	-286(ra) # 5ee <putc>
 714:	a019                	j	71a <vprintf+0x60>
    } else if(state == '%'){
 716:	01498f63          	beq	s3,s4,734 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 71a:	0485                	addi	s1,s1,1
 71c:	fff4c903          	lbu	s2,-1(s1)
 720:	14090d63          	beqz	s2,87a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 724:	0009079b          	sext.w	a5,s2
    if(state == 0){
 728:	fe0997e3          	bnez	s3,716 <vprintf+0x5c>
      if(c == '%'){
 72c:	fd479ee3          	bne	a5,s4,708 <vprintf+0x4e>
        state = '%';
 730:	89be                	mv	s3,a5
 732:	b7e5                	j	71a <vprintf+0x60>
      if(c == 'd'){
 734:	05878063          	beq	a5,s8,774 <vprintf+0xba>
      } else if(c == 'l') {
 738:	05978c63          	beq	a5,s9,790 <vprintf+0xd6>
      } else if(c == 'x') {
 73c:	07a78863          	beq	a5,s10,7ac <vprintf+0xf2>
      } else if(c == 'p') {
 740:	09b78463          	beq	a5,s11,7c8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 744:	07300713          	li	a4,115
 748:	0ce78663          	beq	a5,a4,814 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74c:	06300713          	li	a4,99
 750:	0ee78e63          	beq	a5,a4,84c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 754:	11478863          	beq	a5,s4,864 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 758:	85d2                	mv	a1,s4
 75a:	8556                	mv	a0,s5
 75c:	00000097          	auipc	ra,0x0
 760:	e92080e7          	jalr	-366(ra) # 5ee <putc>
        putc(fd, c);
 764:	85ca                	mv	a1,s2
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	e86080e7          	jalr	-378(ra) # 5ee <putc>
      }
      state = 0;
 770:	4981                	li	s3,0
 772:	b765                	j	71a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 774:	008b0913          	addi	s2,s6,8
 778:	4685                	li	a3,1
 77a:	4629                	li	a2,10
 77c:	000b2583          	lw	a1,0(s6)
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	e8e080e7          	jalr	-370(ra) # 610 <printint>
 78a:	8b4a                	mv	s6,s2
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b771                	j	71a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 790:	008b0913          	addi	s2,s6,8
 794:	4681                	li	a3,0
 796:	4629                	li	a2,10
 798:	000b2583          	lw	a1,0(s6)
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	e72080e7          	jalr	-398(ra) # 610 <printint>
 7a6:	8b4a                	mv	s6,s2
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bf85                	j	71a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ac:	008b0913          	addi	s2,s6,8
 7b0:	4681                	li	a3,0
 7b2:	4641                	li	a2,16
 7b4:	000b2583          	lw	a1,0(s6)
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	e56080e7          	jalr	-426(ra) # 610 <printint>
 7c2:	8b4a                	mv	s6,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bf91                	j	71a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7c8:	008b0793          	addi	a5,s6,8
 7cc:	f8f43423          	sd	a5,-120(s0)
 7d0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7d4:	03000593          	li	a1,48
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	e14080e7          	jalr	-492(ra) # 5ee <putc>
  putc(fd, 'x');
 7e2:	85ea                	mv	a1,s10
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e08080e7          	jalr	-504(ra) # 5ee <putc>
 7ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f0:	03c9d793          	srli	a5,s3,0x3c
 7f4:	97de                	add	a5,a5,s7
 7f6:	0007c583          	lbu	a1,0(a5)
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	df2080e7          	jalr	-526(ra) # 5ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 804:	0992                	slli	s3,s3,0x4
 806:	397d                	addiw	s2,s2,-1
 808:	fe0914e3          	bnez	s2,7f0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 80c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 810:	4981                	li	s3,0
 812:	b721                	j	71a <vprintf+0x60>
        s = va_arg(ap, char*);
 814:	008b0993          	addi	s3,s6,8
 818:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 81c:	02090163          	beqz	s2,83e <vprintf+0x184>
        while(*s != 0){
 820:	00094583          	lbu	a1,0(s2)
 824:	c9a1                	beqz	a1,874 <vprintf+0x1ba>
          putc(fd, *s);
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	dc6080e7          	jalr	-570(ra) # 5ee <putc>
          s++;
 830:	0905                	addi	s2,s2,1
        while(*s != 0){
 832:	00094583          	lbu	a1,0(s2)
 836:	f9e5                	bnez	a1,826 <vprintf+0x16c>
        s = va_arg(ap, char*);
 838:	8b4e                	mv	s6,s3
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bdf9                	j	71a <vprintf+0x60>
          s = "(null)";
 83e:	00000917          	auipc	s2,0x0
 842:	2aa90913          	addi	s2,s2,682 # ae8 <malloc+0x164>
        while(*s != 0){
 846:	02800593          	li	a1,40
 84a:	bff1                	j	826 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 84c:	008b0913          	addi	s2,s6,8
 850:	000b4583          	lbu	a1,0(s6)
 854:	8556                	mv	a0,s5
 856:	00000097          	auipc	ra,0x0
 85a:	d98080e7          	jalr	-616(ra) # 5ee <putc>
 85e:	8b4a                	mv	s6,s2
      state = 0;
 860:	4981                	li	s3,0
 862:	bd65                	j	71a <vprintf+0x60>
        putc(fd, c);
 864:	85d2                	mv	a1,s4
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	d86080e7          	jalr	-634(ra) # 5ee <putc>
      state = 0;
 870:	4981                	li	s3,0
 872:	b565                	j	71a <vprintf+0x60>
        s = va_arg(ap, char*);
 874:	8b4e                	mv	s6,s3
      state = 0;
 876:	4981                	li	s3,0
 878:	b54d                	j	71a <vprintf+0x60>
    }
  }
}
 87a:	70e6                	ld	ra,120(sp)
 87c:	7446                	ld	s0,112(sp)
 87e:	74a6                	ld	s1,104(sp)
 880:	7906                	ld	s2,96(sp)
 882:	69e6                	ld	s3,88(sp)
 884:	6a46                	ld	s4,80(sp)
 886:	6aa6                	ld	s5,72(sp)
 888:	6b06                	ld	s6,64(sp)
 88a:	7be2                	ld	s7,56(sp)
 88c:	7c42                	ld	s8,48(sp)
 88e:	7ca2                	ld	s9,40(sp)
 890:	7d02                	ld	s10,32(sp)
 892:	6de2                	ld	s11,24(sp)
 894:	6109                	addi	sp,sp,128
 896:	8082                	ret

0000000000000898 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 898:	715d                	addi	sp,sp,-80
 89a:	ec06                	sd	ra,24(sp)
 89c:	e822                	sd	s0,16(sp)
 89e:	1000                	addi	s0,sp,32
 8a0:	e010                	sd	a2,0(s0)
 8a2:	e414                	sd	a3,8(s0)
 8a4:	e818                	sd	a4,16(s0)
 8a6:	ec1c                	sd	a5,24(s0)
 8a8:	03043023          	sd	a6,32(s0)
 8ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b4:	8622                	mv	a2,s0
 8b6:	00000097          	auipc	ra,0x0
 8ba:	e04080e7          	jalr	-508(ra) # 6ba <vprintf>
}
 8be:	60e2                	ld	ra,24(sp)
 8c0:	6442                	ld	s0,16(sp)
 8c2:	6161                	addi	sp,sp,80
 8c4:	8082                	ret

00000000000008c6 <printf>:

void
printf(const char *fmt, ...)
{
 8c6:	711d                	addi	sp,sp,-96
 8c8:	ec06                	sd	ra,24(sp)
 8ca:	e822                	sd	s0,16(sp)
 8cc:	1000                	addi	s0,sp,32
 8ce:	e40c                	sd	a1,8(s0)
 8d0:	e810                	sd	a2,16(s0)
 8d2:	ec14                	sd	a3,24(s0)
 8d4:	f018                	sd	a4,32(s0)
 8d6:	f41c                	sd	a5,40(s0)
 8d8:	03043823          	sd	a6,48(s0)
 8dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e0:	00840613          	addi	a2,s0,8
 8e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e8:	85aa                	mv	a1,a0
 8ea:	4505                	li	a0,1
 8ec:	00000097          	auipc	ra,0x0
 8f0:	dce080e7          	jalr	-562(ra) # 6ba <vprintf>
}
 8f4:	60e2                	ld	ra,24(sp)
 8f6:	6442                	ld	s0,16(sp)
 8f8:	6125                	addi	sp,sp,96
 8fa:	8082                	ret

00000000000008fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fc:	1141                	addi	sp,sp,-16
 8fe:	e422                	sd	s0,8(sp)
 900:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 902:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 906:	00000797          	auipc	a5,0x0
 90a:	2027b783          	ld	a5,514(a5) # b08 <freep>
 90e:	a805                	j	93e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 910:	4618                	lw	a4,8(a2)
 912:	9db9                	addw	a1,a1,a4
 914:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	6318                	ld	a4,0(a4)
 91c:	fee53823          	sd	a4,-16(a0)
 920:	a091                	j	964 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 922:	ff852703          	lw	a4,-8(a0)
 926:	9e39                	addw	a2,a2,a4
 928:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 92a:	ff053703          	ld	a4,-16(a0)
 92e:	e398                	sd	a4,0(a5)
 930:	a099                	j	976 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 932:	6398                	ld	a4,0(a5)
 934:	00e7e463          	bltu	a5,a4,93c <free+0x40>
 938:	00e6ea63          	bltu	a3,a4,94c <free+0x50>
{
 93c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93e:	fed7fae3          	bgeu	a5,a3,932 <free+0x36>
 942:	6398                	ld	a4,0(a5)
 944:	00e6e463          	bltu	a3,a4,94c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 948:	fee7eae3          	bltu	a5,a4,93c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 94c:	ff852583          	lw	a1,-8(a0)
 950:	6390                	ld	a2,0(a5)
 952:	02059713          	slli	a4,a1,0x20
 956:	9301                	srli	a4,a4,0x20
 958:	0712                	slli	a4,a4,0x4
 95a:	9736                	add	a4,a4,a3
 95c:	fae60ae3          	beq	a2,a4,910 <free+0x14>
    bp->s.ptr = p->s.ptr;
 960:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 964:	4790                	lw	a2,8(a5)
 966:	02061713          	slli	a4,a2,0x20
 96a:	9301                	srli	a4,a4,0x20
 96c:	0712                	slli	a4,a4,0x4
 96e:	973e                	add	a4,a4,a5
 970:	fae689e3          	beq	a3,a4,922 <free+0x26>
  } else
    p->s.ptr = bp;
 974:	e394                	sd	a3,0(a5)
  freep = p;
 976:	00000717          	auipc	a4,0x0
 97a:	18f73923          	sd	a5,402(a4) # b08 <freep>
}
 97e:	6422                	ld	s0,8(sp)
 980:	0141                	addi	sp,sp,16
 982:	8082                	ret

0000000000000984 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 984:	7139                	addi	sp,sp,-64
 986:	fc06                	sd	ra,56(sp)
 988:	f822                	sd	s0,48(sp)
 98a:	f426                	sd	s1,40(sp)
 98c:	f04a                	sd	s2,32(sp)
 98e:	ec4e                	sd	s3,24(sp)
 990:	e852                	sd	s4,16(sp)
 992:	e456                	sd	s5,8(sp)
 994:	e05a                	sd	s6,0(sp)
 996:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 998:	02051493          	slli	s1,a0,0x20
 99c:	9081                	srli	s1,s1,0x20
 99e:	04bd                	addi	s1,s1,15
 9a0:	8091                	srli	s1,s1,0x4
 9a2:	0014899b          	addiw	s3,s1,1
 9a6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9a8:	00000517          	auipc	a0,0x0
 9ac:	16053503          	ld	a0,352(a0) # b08 <freep>
 9b0:	c515                	beqz	a0,9dc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b4:	4798                	lw	a4,8(a5)
 9b6:	02977f63          	bgeu	a4,s1,9f4 <malloc+0x70>
 9ba:	8a4e                	mv	s4,s3
 9bc:	0009871b          	sext.w	a4,s3
 9c0:	6685                	lui	a3,0x1
 9c2:	00d77363          	bgeu	a4,a3,9c8 <malloc+0x44>
 9c6:	6a05                	lui	s4,0x1
 9c8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9cc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d0:	00000917          	auipc	s2,0x0
 9d4:	13890913          	addi	s2,s2,312 # b08 <freep>
  if(p == (char*)-1)
 9d8:	5afd                	li	s5,-1
 9da:	a88d                	j	a4c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9dc:	00000797          	auipc	a5,0x0
 9e0:	14478793          	addi	a5,a5,324 # b20 <base>
 9e4:	00000717          	auipc	a4,0x0
 9e8:	12f73223          	sd	a5,292(a4) # b08 <freep>
 9ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f2:	b7e1                	j	9ba <malloc+0x36>
      if(p->s.size == nunits)
 9f4:	02e48b63          	beq	s1,a4,a2a <malloc+0xa6>
        p->s.size -= nunits;
 9f8:	4137073b          	subw	a4,a4,s3
 9fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fe:	1702                	slli	a4,a4,0x20
 a00:	9301                	srli	a4,a4,0x20
 a02:	0712                	slli	a4,a4,0x4
 a04:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a06:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a0a:	00000717          	auipc	a4,0x0
 a0e:	0ea73f23          	sd	a0,254(a4) # b08 <freep>
      return (void*)(p + 1);
 a12:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a16:	70e2                	ld	ra,56(sp)
 a18:	7442                	ld	s0,48(sp)
 a1a:	74a2                	ld	s1,40(sp)
 a1c:	7902                	ld	s2,32(sp)
 a1e:	69e2                	ld	s3,24(sp)
 a20:	6a42                	ld	s4,16(sp)
 a22:	6aa2                	ld	s5,8(sp)
 a24:	6b02                	ld	s6,0(sp)
 a26:	6121                	addi	sp,sp,64
 a28:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a2a:	6398                	ld	a4,0(a5)
 a2c:	e118                	sd	a4,0(a0)
 a2e:	bff1                	j	a0a <malloc+0x86>
  hp->s.size = nu;
 a30:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a34:	0541                	addi	a0,a0,16
 a36:	00000097          	auipc	ra,0x0
 a3a:	ec6080e7          	jalr	-314(ra) # 8fc <free>
  return freep;
 a3e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a42:	d971                	beqz	a0,a16 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a44:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a46:	4798                	lw	a4,8(a5)
 a48:	fa9776e3          	bgeu	a4,s1,9f4 <malloc+0x70>
    if(p == freep)
 a4c:	00093703          	ld	a4,0(s2)
 a50:	853e                	mv	a0,a5
 a52:	fef719e3          	bne	a4,a5,a44 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a56:	8552                	mv	a0,s4
 a58:	00000097          	auipc	ra,0x0
 a5c:	b6e080e7          	jalr	-1170(ra) # 5c6 <sbrk>
  if(p == (char*)-1)
 a60:	fd5518e3          	bne	a0,s5,a30 <malloc+0xac>
        return 0;
 a64:	4501                	li	a0,0
 a66:	bf45                	j	a16 <malloc+0x92>
