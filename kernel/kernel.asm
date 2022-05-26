
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	87013103          	ld	sp,-1936(sp) # 80008870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	103050ef          	jal	ra,80005918 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	21078793          	addi	a5,a5,528 # 80021240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2b8080e7          	jalr	696(ra) # 80006312 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	358080e7          	jalr	856(ra) # 800063c6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d3e080e7          	jalr	-706(ra) # 80005dc8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	18e080e7          	jalr	398(ra) # 80006282 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00021517          	auipc	a0,0x21
    80000104:	14050513          	addi	a0,a0,320 # 80021240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	1e6080e7          	jalr	486(ra) # 80006312 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	282080e7          	jalr	642(ra) # 800063c6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	258080e7          	jalr	600(ra) # 800063c6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	ab6080e7          	jalr	-1354(ra) # 80005e12 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	728080e7          	jalr	1832(ra) # 80001a94 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f2c080e7          	jalr	-212(ra) # 800052a0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd6080e7          	jalr	-42(ra) # 80001352 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	956080e7          	jalr	-1706(ra) # 80005cda <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c6c080e7          	jalr	-916(ra) # 80005ff8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a76080e7          	jalr	-1418(ra) # 80005e12 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a66080e7          	jalr	-1434(ra) # 80005e12 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a56080e7          	jalr	-1450(ra) # 80005e12 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	688080e7          	jalr	1672(ra) # 80001a6c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6a8080e7          	jalr	1704(ra) # 80001a94 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e96080e7          	jalr	-362(ra) # 8000528a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	ea4080e7          	jalr	-348(ra) # 800052a0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	dd2080e7          	jalr	-558(ra) # 800021d6 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	524080e7          	jalr	1316(ra) # 80002930 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	576080e7          	jalr	1398(ra) # 8000398a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	fa6080e7          	jalr	-90(ra) # 800053c2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfc080e7          	jalr	-772(ra) # 80001120 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	93a080e7          	jalr	-1734(ra) # 80005dc8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	842080e7          	jalr	-1982(ra) # 80005dc8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	832080e7          	jalr	-1998(ra) # 80005dc8 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	7b8080e7          	jalr	1976(ra) # 80005dc8 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	66c080e7          	jalr	1644(ra) # 80005dc8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	65c080e7          	jalr	1628(ra) # 80005dc8 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	64c080e7          	jalr	1612(ra) # 80005dc8 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	63c080e7          	jalr	1596(ra) # 80005dc8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	55e080e7          	jalr	1374(ra) # 80005dc8 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	41c080e7          	jalr	1052(ra) # 80005dc8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	340080e7          	jalr	832(ra) # 80005dc8 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	330080e7          	jalr	816(ra) # 80005dc8 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	2c6080e7          	jalr	710(ra) # 80005dc8 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00009a17          	auipc	s4,0x9
    80000d0a:	58aa0a13          	addi	s4,s4,1418 # 8000a290 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	16848493          	addi	s1,s1,360
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	064080e7          	jalr	100(ra) # 80005dc8 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	4f2080e7          	jalr	1266(ra) # 80006282 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	4da080e7          	jalr	1242(ra) # 80006282 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00009997          	auipc	s3,0x9
    80000dd6:	4be98993          	addi	s3,s3,1214 # 8000a290 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	4a4080e7          	jalr	1188(ra) # 80006282 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	16848493          	addi	s1,s1,360
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	474080e7          	jalr	1140(ra) # 800062c6 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	4fa080e7          	jalr	1274(ra) # 80006366 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	536080e7          	jalr	1334(ra) # 800063c6 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9887a783          	lw	a5,-1656(a5) # 80008820 <first.1672>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c0a080e7          	jalr	-1014(ra) # 80001aac <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9607a723          	sw	zero,-1682(a5) # 80008820 <first.1672>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	9f4080e7          	jalr	-1548(ra) # 800028b0 <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	436080e7          	jalr	1078(ra) # 80006312 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	94078793          	addi	a5,a5,-1728 # 80008824 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	4d0080e7          	jalr	1232(ra) # 800063c6 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	00009917          	auipc	s2,0x9
    8000106a:	22a90913          	addi	s2,s2,554 # 8000a290 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	2a2080e7          	jalr	674(ra) # 80006312 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	c395                	beqz	a5,8000109e <allocproc+0x4c>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	348080e7          	jalr	840(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	16848493          	addi	s1,s1,360
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
}
    80001090:	8526                	mv	a0,s1
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6902                	ld	s2,0(sp)
    8000109a:	6105                	addi	sp,sp,32
    8000109c:	8082                	ret
  p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e28080e7          	jalr	-472(ra) # 80000ec6 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06c080e7          	jalr	108(ra) # 80000118 <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	cd05                	beqz	a0,800010f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e50080e7          	jalr	-432(ra) # 80000f0c <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c8:	c121                	beqz	a0,80001108 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ca:	07000613          	li	a2,112
    800010ce:	4581                	li	a1,0
    800010d0:	06048513          	addi	a0,s1,96
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	0a4080e7          	jalr	164(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010dc:	00000797          	auipc	a5,0x0
    800010e0:	da478793          	addi	a5,a5,-604 # 80000e80 <forkret>
    800010e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e6:	60bc                	ld	a5,64(s1)
    800010e8:	6705                	lui	a4,0x1
    800010ea:	97ba                	add	a5,a5,a4
    800010ec:	f4bc                	sd	a5,104(s1)
  return p;
    800010ee:	b74d                	j	80001090 <allocproc+0x3e>
    freeproc(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f08080e7          	jalr	-248(ra) # 80000ffa <freeproc>
    release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	2ca080e7          	jalr	714(ra) # 800063c6 <release>
    return 0;
    80001104:	84ca                	mv	s1,s2
    80001106:	b769                	j	80001090 <allocproc+0x3e>
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef0080e7          	jalr	-272(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	2b2080e7          	jalr	690(ra) # 800063c6 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	bf8d                	j	80001090 <allocproc+0x3e>

0000000080001120 <userinit>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	1000                	addi	s0,sp,32
  p = allocproc();
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f28080e7          	jalr	-216(ra) # 80001052 <allocproc>
    80001132:	84aa                	mv	s1,a0
  initproc = p;
    80001134:	00008797          	auipc	a5,0x8
    80001138:	eca7be23          	sd	a0,-292(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113c:	03400613          	li	a2,52
    80001140:	00007597          	auipc	a1,0x7
    80001144:	6f058593          	addi	a1,a1,1776 # 80008830 <initcode>
    80001148:	6928                	ld	a0,80(a0)
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	6b6080e7          	jalr	1718(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001152:	6785                	lui	a5,0x1
    80001154:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115c:	6cb8                	ld	a4,88(s1)
    8000115e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001160:	4641                	li	a2,16
    80001162:	00007597          	auipc	a1,0x7
    80001166:	01e58593          	addi	a1,a1,30 # 80008180 <etext+0x180>
    8000116a:	15848513          	addi	a0,s1,344
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	15c080e7          	jalr	348(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001176:	00007517          	auipc	a0,0x7
    8000117a:	01a50513          	addi	a0,a0,26 # 80008190 <etext+0x190>
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	208080e7          	jalr	520(ra) # 80003386 <namei>
    80001186:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000118a:	478d                	li	a5,3
    8000118c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	236080e7          	jalr	566(ra) # 800063c6 <release>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <growproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	e04a                	sd	s2,0(sp)
    800011ac:	1000                	addi	s0,sp,32
    800011ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	c98080e7          	jalr	-872(ra) # 80000e48 <myproc>
    800011b8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ba:	652c                	ld	a1,72(a0)
    800011bc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c0:	00904f63          	bgtz	s1,800011de <growproc+0x3c>
  } else if(n < 0){
    800011c4:	0204cc63          	bltz	s1,800011fc <growproc+0x5a>
  p->sz = sz;
    800011c8:	1602                	slli	a2,a2,0x20
    800011ca:	9201                	srli	a2,a2,0x20
    800011cc:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011de:	9e25                	addw	a2,a2,s1
    800011e0:	1602                	slli	a2,a2,0x20
    800011e2:	9201                	srli	a2,a2,0x20
    800011e4:	1582                	slli	a1,a1,0x20
    800011e6:	9181                	srli	a1,a1,0x20
    800011e8:	6928                	ld	a0,80(a0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	6d0080e7          	jalr	1744(ra) # 800008ba <uvmalloc>
    800011f2:	0005061b          	sext.w	a2,a0
    800011f6:	fa69                	bnez	a2,800011c8 <growproc+0x26>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bfe1                	j	800011d2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	9e25                	addw	a2,a2,s1
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	66a080e7          	jalr	1642(ra) # 80000872 <uvmdealloc>
    80001210:	0005061b          	sext.w	a2,a0
    80001214:	bf55                	j	800011c8 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7179                	addi	sp,sp,-48
    80001218:	f406                	sd	ra,40(sp)
    8000121a:	f022                	sd	s0,32(sp)
    8000121c:	ec26                	sd	s1,24(sp)
    8000121e:	e84a                	sd	s2,16(sp)
    80001220:	e44e                	sd	s3,8(sp)
    80001222:	e052                	sd	s4,0(sp)
    80001224:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	c22080e7          	jalr	-990(ra) # 80000e48 <myproc>
    8000122e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001230:	00000097          	auipc	ra,0x0
    80001234:	e22080e7          	jalr	-478(ra) # 80001052 <allocproc>
    80001238:	10050b63          	beqz	a0,8000134e <fork+0x138>
    8000123c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123e:	04893603          	ld	a2,72(s2)
    80001242:	692c                	ld	a1,80(a0)
    80001244:	05093503          	ld	a0,80(s2)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	7be080e7          	jalr	1982(ra) # 80000a06 <uvmcopy>
    80001250:	04054663          	bltz	a0,8000129c <fork+0x86>
  np->sz = p->sz;
    80001254:	04893783          	ld	a5,72(s2)
    80001258:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000125c:	05893683          	ld	a3,88(s2)
    80001260:	87b6                	mv	a5,a3
    80001262:	0589b703          	ld	a4,88(s3)
    80001266:	12068693          	addi	a3,a3,288
    8000126a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126e:	6788                	ld	a0,8(a5)
    80001270:	6b8c                	ld	a1,16(a5)
    80001272:	6f90                	ld	a2,24(a5)
    80001274:	01073023          	sd	a6,0(a4)
    80001278:	e708                	sd	a0,8(a4)
    8000127a:	eb0c                	sd	a1,16(a4)
    8000127c:	ef10                	sd	a2,24(a4)
    8000127e:	02078793          	addi	a5,a5,32
    80001282:	02070713          	addi	a4,a4,32
    80001286:	fed792e3          	bne	a5,a3,8000126a <fork+0x54>
  np->trapframe->a0 = 0;
    8000128a:	0589b783          	ld	a5,88(s3)
    8000128e:	0607b823          	sd	zero,112(a5)
    80001292:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001296:	15000a13          	li	s4,336
    8000129a:	a03d                	j	800012c8 <fork+0xb2>
    freeproc(np);
    8000129c:	854e                	mv	a0,s3
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	d5c080e7          	jalr	-676(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012a6:	854e                	mv	a0,s3
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	11e080e7          	jalr	286(ra) # 800063c6 <release>
    return -1;
    800012b0:	5a7d                	li	s4,-1
    800012b2:	a069                	j	8000133c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b4:	00002097          	auipc	ra,0x2
    800012b8:	768080e7          	jalr	1896(ra) # 80003a1c <filedup>
    800012bc:	009987b3          	add	a5,s3,s1
    800012c0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012c2:	04a1                	addi	s1,s1,8
    800012c4:	01448763          	beq	s1,s4,800012d2 <fork+0xbc>
    if(p->ofile[i])
    800012c8:	009907b3          	add	a5,s2,s1
    800012cc:	6388                	ld	a0,0(a5)
    800012ce:	f17d                	bnez	a0,800012b4 <fork+0x9e>
    800012d0:	bfcd                	j	800012c2 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012d2:	15093503          	ld	a0,336(s2)
    800012d6:	00002097          	auipc	ra,0x2
    800012da:	814080e7          	jalr	-2028(ra) # 80002aea <idup>
    800012de:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e2:	4641                	li	a2,16
    800012e4:	15890593          	addi	a1,s2,344
    800012e8:	15898513          	addi	a0,s3,344
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	fde080e7          	jalr	-34(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012f4:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	0cc080e7          	jalr	204(ra) # 800063c6 <release>
  acquire(&wait_lock);
    80001302:	00008497          	auipc	s1,0x8
    80001306:	d6648493          	addi	s1,s1,-666 # 80009068 <wait_lock>
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	006080e7          	jalr	6(ra) # 80006312 <acquire>
  np->parent = p;
    80001314:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	0ac080e7          	jalr	172(ra) # 800063c6 <release>
  acquire(&np->lock);
    80001322:	854e                	mv	a0,s3
    80001324:	00005097          	auipc	ra,0x5
    80001328:	fee080e7          	jalr	-18(ra) # 80006312 <acquire>
  np->state = RUNNABLE;
    8000132c:	478d                	li	a5,3
    8000132e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	092080e7          	jalr	146(ra) # 800063c6 <release>
}
    8000133c:	8552                	mv	a0,s4
    8000133e:	70a2                	ld	ra,40(sp)
    80001340:	7402                	ld	s0,32(sp)
    80001342:	64e2                	ld	s1,24(sp)
    80001344:	6942                	ld	s2,16(sp)
    80001346:	69a2                	ld	s3,8(sp)
    80001348:	6a02                	ld	s4,0(sp)
    8000134a:	6145                	addi	sp,sp,48
    8000134c:	8082                	ret
    return -1;
    8000134e:	5a7d                	li	s4,-1
    80001350:	b7f5                	j	8000133c <fork+0x126>

0000000080001352 <scheduler>:
{
    80001352:	7139                	addi	sp,sp,-64
    80001354:	fc06                	sd	ra,56(sp)
    80001356:	f822                	sd	s0,48(sp)
    80001358:	f426                	sd	s1,40(sp)
    8000135a:	f04a                	sd	s2,32(sp)
    8000135c:	ec4e                	sd	s3,24(sp)
    8000135e:	e852                	sd	s4,16(sp)
    80001360:	e456                	sd	s5,8(sp)
    80001362:	e05a                	sd	s6,0(sp)
    80001364:	0080                	addi	s0,sp,64
    80001366:	8792                	mv	a5,tp
  int id = r_tp();
    80001368:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136a:	00779a93          	slli	s5,a5,0x7
    8000136e:	00008717          	auipc	a4,0x8
    80001372:	ce270713          	addi	a4,a4,-798 # 80009050 <pid_lock>
    80001376:	9756                	add	a4,a4,s5
    80001378:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000137c:	00008717          	auipc	a4,0x8
    80001380:	d0c70713          	addi	a4,a4,-756 # 80009088 <cpus+0x8>
    80001384:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001386:	498d                	li	s3,3
        p->state = RUNNING;
    80001388:	4b11                	li	s6,4
        c->proc = p;
    8000138a:	079e                	slli	a5,a5,0x7
    8000138c:	00008a17          	auipc	s4,0x8
    80001390:	cc4a0a13          	addi	s4,s4,-828 # 80009050 <pid_lock>
    80001394:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	00009917          	auipc	s2,0x9
    8000139a:	efa90913          	addi	s2,s2,-262 # 8000a290 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a6:	10079073          	csrw	sstatus,a5
    800013aa:	00008497          	auipc	s1,0x8
    800013ae:	0d648493          	addi	s1,s1,214 # 80009480 <proc>
    800013b2:	a03d                	j	800013e0 <scheduler+0x8e>
        p->state = RUNNING;
    800013b4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013bc:	06048593          	addi	a1,s1,96
    800013c0:	8556                	mv	a0,s5
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	640080e7          	jalr	1600(ra) # 80001a02 <swtch>
        c->proc = 0;
    800013ca:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013ce:	8526                	mv	a0,s1
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	ff6080e7          	jalr	-10(ra) # 800063c6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d8:	16848493          	addi	s1,s1,360
    800013dc:	fd2481e3          	beq	s1,s2,8000139e <scheduler+0x4c>
      acquire(&p->lock);
    800013e0:	8526                	mv	a0,s1
    800013e2:	00005097          	auipc	ra,0x5
    800013e6:	f30080e7          	jalr	-208(ra) # 80006312 <acquire>
      if(p->state == RUNNABLE) {
    800013ea:	4c9c                	lw	a5,24(s1)
    800013ec:	ff3791e3          	bne	a5,s3,800013ce <scheduler+0x7c>
    800013f0:	b7d1                	j	800013b4 <scheduler+0x62>

00000000800013f2 <sched>:
{
    800013f2:	7179                	addi	sp,sp,-48
    800013f4:	f406                	sd	ra,40(sp)
    800013f6:	f022                	sd	s0,32(sp)
    800013f8:	ec26                	sd	s1,24(sp)
    800013fa:	e84a                	sd	s2,16(sp)
    800013fc:	e44e                	sd	s3,8(sp)
    800013fe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001400:	00000097          	auipc	ra,0x0
    80001404:	a48080e7          	jalr	-1464(ra) # 80000e48 <myproc>
    80001408:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	e8e080e7          	jalr	-370(ra) # 80006298 <holding>
    80001412:	c93d                	beqz	a0,80001488 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001414:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001416:	2781                	sext.w	a5,a5
    80001418:	079e                	slli	a5,a5,0x7
    8000141a:	00008717          	auipc	a4,0x8
    8000141e:	c3670713          	addi	a4,a4,-970 # 80009050 <pid_lock>
    80001422:	97ba                	add	a5,a5,a4
    80001424:	0a87a703          	lw	a4,168(a5)
    80001428:	4785                	li	a5,1
    8000142a:	06f71763          	bne	a4,a5,80001498 <sched+0xa6>
  if(p->state == RUNNING)
    8000142e:	4c98                	lw	a4,24(s1)
    80001430:	4791                	li	a5,4
    80001432:	06f70b63          	beq	a4,a5,800014a8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001436:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000143c:	efb5                	bnez	a5,800014b8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001440:	00008917          	auipc	s2,0x8
    80001444:	c1090913          	addi	s2,s2,-1008 # 80009050 <pid_lock>
    80001448:	2781                	sext.w	a5,a5
    8000144a:	079e                	slli	a5,a5,0x7
    8000144c:	97ca                	add	a5,a5,s2
    8000144e:	0ac7a983          	lw	s3,172(a5)
    80001452:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	00008597          	auipc	a1,0x8
    8000145c:	c3058593          	addi	a1,a1,-976 # 80009088 <cpus+0x8>
    80001460:	95be                	add	a1,a1,a5
    80001462:	06048513          	addi	a0,s1,96
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	59c080e7          	jalr	1436(ra) # 80001a02 <swtch>
    8000146e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	97ca                	add	a5,a5,s2
    80001476:	0b37a623          	sw	s3,172(a5)
}
    8000147a:	70a2                	ld	ra,40(sp)
    8000147c:	7402                	ld	s0,32(sp)
    8000147e:	64e2                	ld	s1,24(sp)
    80001480:	6942                	ld	s2,16(sp)
    80001482:	69a2                	ld	s3,8(sp)
    80001484:	6145                	addi	sp,sp,48
    80001486:	8082                	ret
    panic("sched p->lock");
    80001488:	00007517          	auipc	a0,0x7
    8000148c:	d1050513          	addi	a0,a0,-752 # 80008198 <etext+0x198>
    80001490:	00005097          	auipc	ra,0x5
    80001494:	938080e7          	jalr	-1736(ra) # 80005dc8 <panic>
    panic("sched locks");
    80001498:	00007517          	auipc	a0,0x7
    8000149c:	d1050513          	addi	a0,a0,-752 # 800081a8 <etext+0x1a8>
    800014a0:	00005097          	auipc	ra,0x5
    800014a4:	928080e7          	jalr	-1752(ra) # 80005dc8 <panic>
    panic("sched running");
    800014a8:	00007517          	auipc	a0,0x7
    800014ac:	d1050513          	addi	a0,a0,-752 # 800081b8 <etext+0x1b8>
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	918080e7          	jalr	-1768(ra) # 80005dc8 <panic>
    panic("sched interruptible");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d1050513          	addi	a0,a0,-752 # 800081c8 <etext+0x1c8>
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	908080e7          	jalr	-1784(ra) # 80005dc8 <panic>

00000000800014c8 <yield>:
{
    800014c8:	1101                	addi	sp,sp,-32
    800014ca:	ec06                	sd	ra,24(sp)
    800014cc:	e822                	sd	s0,16(sp)
    800014ce:	e426                	sd	s1,8(sp)
    800014d0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	976080e7          	jalr	-1674(ra) # 80000e48 <myproc>
    800014da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	e36080e7          	jalr	-458(ra) # 80006312 <acquire>
  p->state = RUNNABLE;
    800014e4:	478d                	li	a5,3
    800014e6:	cc9c                	sw	a5,24(s1)
  sched();
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	f0a080e7          	jalr	-246(ra) # 800013f2 <sched>
  release(&p->lock);
    800014f0:	8526                	mv	a0,s1
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	ed4080e7          	jalr	-300(ra) # 800063c6 <release>
}
    800014fa:	60e2                	ld	ra,24(sp)
    800014fc:	6442                	ld	s0,16(sp)
    800014fe:	64a2                	ld	s1,8(sp)
    80001500:	6105                	addi	sp,sp,32
    80001502:	8082                	ret

0000000080001504 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001504:	7179                	addi	sp,sp,-48
    80001506:	f406                	sd	ra,40(sp)
    80001508:	f022                	sd	s0,32(sp)
    8000150a:	ec26                	sd	s1,24(sp)
    8000150c:	e84a                	sd	s2,16(sp)
    8000150e:	e44e                	sd	s3,8(sp)
    80001510:	1800                	addi	s0,sp,48
    80001512:	89aa                	mv	s3,a0
    80001514:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	932080e7          	jalr	-1742(ra) # 80000e48 <myproc>
    8000151e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001520:	00005097          	auipc	ra,0x5
    80001524:	df2080e7          	jalr	-526(ra) # 80006312 <acquire>
  release(lk);
    80001528:	854a                	mv	a0,s2
    8000152a:	00005097          	auipc	ra,0x5
    8000152e:	e9c080e7          	jalr	-356(ra) # 800063c6 <release>

  // Go to sleep.
  p->chan = chan;
    80001532:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001536:	4789                	li	a5,2
    80001538:	cc9c                	sw	a5,24(s1)

  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	eb8080e7          	jalr	-328(ra) # 800013f2 <sched>

  // Tidy up.
  p->chan = 0;
    80001542:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	e7e080e7          	jalr	-386(ra) # 800063c6 <release>
  acquire(lk);
    80001550:	854a                	mv	a0,s2
    80001552:	00005097          	auipc	ra,0x5
    80001556:	dc0080e7          	jalr	-576(ra) # 80006312 <acquire>
}
    8000155a:	70a2                	ld	ra,40(sp)
    8000155c:	7402                	ld	s0,32(sp)
    8000155e:	64e2                	ld	s1,24(sp)
    80001560:	6942                	ld	s2,16(sp)
    80001562:	69a2                	ld	s3,8(sp)
    80001564:	6145                	addi	sp,sp,48
    80001566:	8082                	ret

0000000080001568 <wait>:
{
    80001568:	715d                	addi	sp,sp,-80
    8000156a:	e486                	sd	ra,72(sp)
    8000156c:	e0a2                	sd	s0,64(sp)
    8000156e:	fc26                	sd	s1,56(sp)
    80001570:	f84a                	sd	s2,48(sp)
    80001572:	f44e                	sd	s3,40(sp)
    80001574:	f052                	sd	s4,32(sp)
    80001576:	ec56                	sd	s5,24(sp)
    80001578:	e85a                	sd	s6,16(sp)
    8000157a:	e45e                	sd	s7,8(sp)
    8000157c:	e062                	sd	s8,0(sp)
    8000157e:	0880                	addi	s0,sp,80
    80001580:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	8c6080e7          	jalr	-1850(ra) # 80000e48 <myproc>
    8000158a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000158c:	00008517          	auipc	a0,0x8
    80001590:	adc50513          	addi	a0,a0,-1316 # 80009068 <wait_lock>
    80001594:	00005097          	auipc	ra,0x5
    80001598:	d7e080e7          	jalr	-642(ra) # 80006312 <acquire>
    havekids = 0;
    8000159c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000159e:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015a0:	00009997          	auipc	s3,0x9
    800015a4:	cf098993          	addi	s3,s3,-784 # 8000a290 <tickslock>
        havekids = 1;
    800015a8:	4b05                	li	s6,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015aa:	00008c17          	auipc	s8,0x8
    800015ae:	abec0c13          	addi	s8,s8,-1346 # 80009068 <wait_lock>
    havekids = 0;
    800015b2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b4:	00008497          	auipc	s1,0x8
    800015b8:	ecc48493          	addi	s1,s1,-308 # 80009480 <proc>
    800015bc:	a0bd                	j	8000162a <wait+0xc2>
          pid = np->pid;
    800015be:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c2:	000a8e63          	beqz	s5,800015de <wait+0x76>
    800015c6:	4691                	li	a3,4
    800015c8:	02c48613          	addi	a2,s1,44
    800015cc:	85d6                	mv	a1,s5
    800015ce:	05093503          	ld	a0,80(s2)
    800015d2:	fffff097          	auipc	ra,0xfffff
    800015d6:	538080e7          	jalr	1336(ra) # 80000b0a <copyout>
    800015da:	02054563          	bltz	a0,80001604 <wait+0x9c>
          freeproc(np);
    800015de:	8526                	mv	a0,s1
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	a1a080e7          	jalr	-1510(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015e8:	8526                	mv	a0,s1
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	ddc080e7          	jalr	-548(ra) # 800063c6 <release>
          release(&wait_lock);
    800015f2:	00008517          	auipc	a0,0x8
    800015f6:	a7650513          	addi	a0,a0,-1418 # 80009068 <wait_lock>
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	dcc080e7          	jalr	-564(ra) # 800063c6 <release>
          return pid;
    80001602:	a09d                	j	80001668 <wait+0x100>
            release(&np->lock);
    80001604:	8526                	mv	a0,s1
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	dc0080e7          	jalr	-576(ra) # 800063c6 <release>
            release(&wait_lock);
    8000160e:	00008517          	auipc	a0,0x8
    80001612:	a5a50513          	addi	a0,a0,-1446 # 80009068 <wait_lock>
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	db0080e7          	jalr	-592(ra) # 800063c6 <release>
            return -1;
    8000161e:	59fd                	li	s3,-1
    80001620:	a0a1                	j	80001668 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001622:	16848493          	addi	s1,s1,360
    80001626:	03348463          	beq	s1,s3,8000164e <wait+0xe6>
      if(np->parent == p){
    8000162a:	7c9c                	ld	a5,56(s1)
    8000162c:	ff279be3          	bne	a5,s2,80001622 <wait+0xba>
        acquire(&np->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	ce0080e7          	jalr	-800(ra) # 80006312 <acquire>
        if(np->state == ZOMBIE){
    8000163a:	4c9c                	lw	a5,24(s1)
    8000163c:	f94781e3          	beq	a5,s4,800015be <wait+0x56>
        release(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	d84080e7          	jalr	-636(ra) # 800063c6 <release>
        havekids = 1;
    8000164a:	875a                	mv	a4,s6
    8000164c:	bfd9                	j	80001622 <wait+0xba>
    if(!havekids || p->killed){
    8000164e:	c701                	beqz	a4,80001656 <wait+0xee>
    80001650:	02892783          	lw	a5,40(s2)
    80001654:	c79d                	beqz	a5,80001682 <wait+0x11a>
      release(&wait_lock);
    80001656:	00008517          	auipc	a0,0x8
    8000165a:	a1250513          	addi	a0,a0,-1518 # 80009068 <wait_lock>
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	d68080e7          	jalr	-664(ra) # 800063c6 <release>
      return -1;
    80001666:	59fd                	li	s3,-1
}
    80001668:	854e                	mv	a0,s3
    8000166a:	60a6                	ld	ra,72(sp)
    8000166c:	6406                	ld	s0,64(sp)
    8000166e:	74e2                	ld	s1,56(sp)
    80001670:	7942                	ld	s2,48(sp)
    80001672:	79a2                	ld	s3,40(sp)
    80001674:	7a02                	ld	s4,32(sp)
    80001676:	6ae2                	ld	s5,24(sp)
    80001678:	6b42                	ld	s6,16(sp)
    8000167a:	6ba2                	ld	s7,8(sp)
    8000167c:	6c02                	ld	s8,0(sp)
    8000167e:	6161                	addi	sp,sp,80
    80001680:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001682:	85e2                	mv	a1,s8
    80001684:	854a                	mv	a0,s2
    80001686:	00000097          	auipc	ra,0x0
    8000168a:	e7e080e7          	jalr	-386(ra) # 80001504 <sleep>
    havekids = 0;
    8000168e:	b715                	j	800015b2 <wait+0x4a>

0000000080001690 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001690:	7139                	addi	sp,sp,-64
    80001692:	fc06                	sd	ra,56(sp)
    80001694:	f822                	sd	s0,48(sp)
    80001696:	f426                	sd	s1,40(sp)
    80001698:	f04a                	sd	s2,32(sp)
    8000169a:	ec4e                	sd	s3,24(sp)
    8000169c:	e852                	sd	s4,16(sp)
    8000169e:	e456                	sd	s5,8(sp)
    800016a0:	0080                	addi	s0,sp,64
    800016a2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a4:	00008497          	auipc	s1,0x8
    800016a8:	ddc48493          	addi	s1,s1,-548 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ac:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ae:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	00009917          	auipc	s2,0x9
    800016b4:	be090913          	addi	s2,s2,-1056 # 8000a290 <tickslock>
    800016b8:	a811                	j	800016cc <wakeup+0x3c>
      }
      release(&p->lock);
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	d0a080e7          	jalr	-758(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c4:	16848493          	addi	s1,s1,360
    800016c8:	03248663          	beq	s1,s2,800016f4 <wakeup+0x64>
    if(p != myproc()){
    800016cc:	fffff097          	auipc	ra,0xfffff
    800016d0:	77c080e7          	jalr	1916(ra) # 80000e48 <myproc>
    800016d4:	fea488e3          	beq	s1,a0,800016c4 <wakeup+0x34>
      acquire(&p->lock);
    800016d8:	8526                	mv	a0,s1
    800016da:	00005097          	auipc	ra,0x5
    800016de:	c38080e7          	jalr	-968(ra) # 80006312 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e2:	4c9c                	lw	a5,24(s1)
    800016e4:	fd379be3          	bne	a5,s3,800016ba <wakeup+0x2a>
    800016e8:	709c                	ld	a5,32(s1)
    800016ea:	fd4798e3          	bne	a5,s4,800016ba <wakeup+0x2a>
        p->state = RUNNABLE;
    800016ee:	0154ac23          	sw	s5,24(s1)
    800016f2:	b7e1                	j	800016ba <wakeup+0x2a>
    }
  }
}
    800016f4:	70e2                	ld	ra,56(sp)
    800016f6:	7442                	ld	s0,48(sp)
    800016f8:	74a2                	ld	s1,40(sp)
    800016fa:	7902                	ld	s2,32(sp)
    800016fc:	69e2                	ld	s3,24(sp)
    800016fe:	6a42                	ld	s4,16(sp)
    80001700:	6aa2                	ld	s5,8(sp)
    80001702:	6121                	addi	sp,sp,64
    80001704:	8082                	ret

0000000080001706 <reparent>:
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	e052                	sd	s4,0(sp)
    80001714:	1800                	addi	s0,sp,48
    80001716:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001718:	00008497          	auipc	s1,0x8
    8000171c:	d6848493          	addi	s1,s1,-664 # 80009480 <proc>
      pp->parent = initproc;
    80001720:	00008a17          	auipc	s4,0x8
    80001724:	8f0a0a13          	addi	s4,s4,-1808 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001728:	00009997          	auipc	s3,0x9
    8000172c:	b6898993          	addi	s3,s3,-1176 # 8000a290 <tickslock>
    80001730:	a029                	j	8000173a <reparent+0x34>
    80001732:	16848493          	addi	s1,s1,360
    80001736:	01348d63          	beq	s1,s3,80001750 <reparent+0x4a>
    if(pp->parent == p){
    8000173a:	7c9c                	ld	a5,56(s1)
    8000173c:	ff279be3          	bne	a5,s2,80001732 <reparent+0x2c>
      pp->parent = initproc;
    80001740:	000a3503          	ld	a0,0(s4)
    80001744:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	f4a080e7          	jalr	-182(ra) # 80001690 <wakeup>
    8000174e:	b7d5                	j	80001732 <reparent+0x2c>
}
    80001750:	70a2                	ld	ra,40(sp)
    80001752:	7402                	ld	s0,32(sp)
    80001754:	64e2                	ld	s1,24(sp)
    80001756:	6942                	ld	s2,16(sp)
    80001758:	69a2                	ld	s3,8(sp)
    8000175a:	6a02                	ld	s4,0(sp)
    8000175c:	6145                	addi	sp,sp,48
    8000175e:	8082                	ret

0000000080001760 <exit>:
{
    80001760:	7179                	addi	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	e052                	sd	s4,0(sp)
    8000176e:	1800                	addi	s0,sp,48
    80001770:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001772:	fffff097          	auipc	ra,0xfffff
    80001776:	6d6080e7          	jalr	1750(ra) # 80000e48 <myproc>
    8000177a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000177c:	00008797          	auipc	a5,0x8
    80001780:	8947b783          	ld	a5,-1900(a5) # 80009010 <initproc>
    80001784:	0d050493          	addi	s1,a0,208
    80001788:	15050913          	addi	s2,a0,336
    8000178c:	02a79363          	bne	a5,a0,800017b2 <exit+0x52>
    panic("init exiting");
    80001790:	00007517          	auipc	a0,0x7
    80001794:	a5050513          	addi	a0,a0,-1456 # 800081e0 <etext+0x1e0>
    80001798:	00004097          	auipc	ra,0x4
    8000179c:	630080e7          	jalr	1584(ra) # 80005dc8 <panic>
      fileclose(f);
    800017a0:	00002097          	auipc	ra,0x2
    800017a4:	2ce080e7          	jalr	718(ra) # 80003a6e <fileclose>
      p->ofile[fd] = 0;
    800017a8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ac:	04a1                	addi	s1,s1,8
    800017ae:	01248563          	beq	s1,s2,800017b8 <exit+0x58>
    if(p->ofile[fd]){
    800017b2:	6088                	ld	a0,0(s1)
    800017b4:	f575                	bnez	a0,800017a0 <exit+0x40>
    800017b6:	bfdd                	j	800017ac <exit+0x4c>
  begin_op();
    800017b8:	00002097          	auipc	ra,0x2
    800017bc:	dea080e7          	jalr	-534(ra) # 800035a2 <begin_op>
  iput(p->cwd);
    800017c0:	1509b503          	ld	a0,336(s3)
    800017c4:	00001097          	auipc	ra,0x1
    800017c8:	5c4080e7          	jalr	1476(ra) # 80002d88 <iput>
  end_op();
    800017cc:	00002097          	auipc	ra,0x2
    800017d0:	e56080e7          	jalr	-426(ra) # 80003622 <end_op>
  p->cwd = 0;
    800017d4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017d8:	00008497          	auipc	s1,0x8
    800017dc:	89048493          	addi	s1,s1,-1904 # 80009068 <wait_lock>
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	b30080e7          	jalr	-1232(ra) # 80006312 <acquire>
  reparent(p);
    800017ea:	854e                	mv	a0,s3
    800017ec:	00000097          	auipc	ra,0x0
    800017f0:	f1a080e7          	jalr	-230(ra) # 80001706 <reparent>
  wakeup(p->parent);
    800017f4:	0389b503          	ld	a0,56(s3)
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	e98080e7          	jalr	-360(ra) # 80001690 <wakeup>
  acquire(&p->lock);
    80001800:	854e                	mv	a0,s3
    80001802:	00005097          	auipc	ra,0x5
    80001806:	b10080e7          	jalr	-1264(ra) # 80006312 <acquire>
  p->xstate = status;
    8000180a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000180e:	4795                	li	a5,5
    80001810:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001814:	8526                	mv	a0,s1
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	bb0080e7          	jalr	-1104(ra) # 800063c6 <release>
  sched();
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	bd4080e7          	jalr	-1068(ra) # 800013f2 <sched>
  panic("zombie exit");
    80001826:	00007517          	auipc	a0,0x7
    8000182a:	9ca50513          	addi	a0,a0,-1590 # 800081f0 <etext+0x1f0>
    8000182e:	00004097          	auipc	ra,0x4
    80001832:	59a080e7          	jalr	1434(ra) # 80005dc8 <panic>

0000000080001836 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001836:	7179                	addi	sp,sp,-48
    80001838:	f406                	sd	ra,40(sp)
    8000183a:	f022                	sd	s0,32(sp)
    8000183c:	ec26                	sd	s1,24(sp)
    8000183e:	e84a                	sd	s2,16(sp)
    80001840:	e44e                	sd	s3,8(sp)
    80001842:	1800                	addi	s0,sp,48
    80001844:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001846:	00008497          	auipc	s1,0x8
    8000184a:	c3a48493          	addi	s1,s1,-966 # 80009480 <proc>
    8000184e:	00009997          	auipc	s3,0x9
    80001852:	a4298993          	addi	s3,s3,-1470 # 8000a290 <tickslock>
    acquire(&p->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	aba080e7          	jalr	-1350(ra) # 80006312 <acquire>
    if(p->pid == pid){
    80001860:	589c                	lw	a5,48(s1)
    80001862:	03278363          	beq	a5,s2,80001888 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	b5e080e7          	jalr	-1186(ra) # 800063c6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001870:	16848493          	addi	s1,s1,360
    80001874:	ff3491e3          	bne	s1,s3,80001856 <kill+0x20>
  }
  return -1;
    80001878:	557d                	li	a0,-1
}
    8000187a:	70a2                	ld	ra,40(sp)
    8000187c:	7402                	ld	s0,32(sp)
    8000187e:	64e2                	ld	s1,24(sp)
    80001880:	6942                	ld	s2,16(sp)
    80001882:	69a2                	ld	s3,8(sp)
    80001884:	6145                	addi	sp,sp,48
    80001886:	8082                	ret
      p->killed = 1;
    80001888:	4785                	li	a5,1
    8000188a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188c:	4c98                	lw	a4,24(s1)
    8000188e:	4789                	li	a5,2
    80001890:	00f70963          	beq	a4,a5,800018a2 <kill+0x6c>
      release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	b30080e7          	jalr	-1232(ra) # 800063c6 <release>
      return 0;
    8000189e:	4501                	li	a0,0
    800018a0:	bfe9                	j	8000187a <kill+0x44>
        p->state = RUNNABLE;
    800018a2:	478d                	li	a5,3
    800018a4:	cc9c                	sw	a5,24(s1)
    800018a6:	b7fd                	j	80001894 <kill+0x5e>

00000000800018a8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a8:	7179                	addi	sp,sp,-48
    800018aa:	f406                	sd	ra,40(sp)
    800018ac:	f022                	sd	s0,32(sp)
    800018ae:	ec26                	sd	s1,24(sp)
    800018b0:	e84a                	sd	s2,16(sp)
    800018b2:	e44e                	sd	s3,8(sp)
    800018b4:	e052                	sd	s4,0(sp)
    800018b6:	1800                	addi	s0,sp,48
    800018b8:	84aa                	mv	s1,a0
    800018ba:	892e                	mv	s2,a1
    800018bc:	89b2                	mv	s3,a2
    800018be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c0:	fffff097          	auipc	ra,0xfffff
    800018c4:	588080e7          	jalr	1416(ra) # 80000e48 <myproc>
  if(user_dst){
    800018c8:	c08d                	beqz	s1,800018ea <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018ca:	86d2                	mv	a3,s4
    800018cc:	864e                	mv	a2,s3
    800018ce:	85ca                	mv	a1,s2
    800018d0:	6928                	ld	a0,80(a0)
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	238080e7          	jalr	568(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018da:	70a2                	ld	ra,40(sp)
    800018dc:	7402                	ld	s0,32(sp)
    800018de:	64e2                	ld	s1,24(sp)
    800018e0:	6942                	ld	s2,16(sp)
    800018e2:	69a2                	ld	s3,8(sp)
    800018e4:	6a02                	ld	s4,0(sp)
    800018e6:	6145                	addi	sp,sp,48
    800018e8:	8082                	ret
    memmove((char *)dst, src, len);
    800018ea:	000a061b          	sext.w	a2,s4
    800018ee:	85ce                	mv	a1,s3
    800018f0:	854a                	mv	a0,s2
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	8e6080e7          	jalr	-1818(ra) # 800001d8 <memmove>
    return 0;
    800018fa:	8526                	mv	a0,s1
    800018fc:	bff9                	j	800018da <either_copyout+0x32>

00000000800018fe <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	892a                	mv	s2,a0
    80001910:	84ae                	mv	s1,a1
    80001912:	89b2                	mv	s3,a2
    80001914:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	532080e7          	jalr	1330(ra) # 80000e48 <myproc>
  if(user_src){
    8000191e:	c08d                	beqz	s1,80001940 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001920:	86d2                	mv	a3,s4
    80001922:	864e                	mv	a2,s3
    80001924:	85ca                	mv	a1,s2
    80001926:	6928                	ld	a0,80(a0)
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	26e080e7          	jalr	622(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001930:	70a2                	ld	ra,40(sp)
    80001932:	7402                	ld	s0,32(sp)
    80001934:	64e2                	ld	s1,24(sp)
    80001936:	6942                	ld	s2,16(sp)
    80001938:	69a2                	ld	s3,8(sp)
    8000193a:	6a02                	ld	s4,0(sp)
    8000193c:	6145                	addi	sp,sp,48
    8000193e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001940:	000a061b          	sext.w	a2,s4
    80001944:	85ce                	mv	a1,s3
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	890080e7          	jalr	-1904(ra) # 800001d8 <memmove>
    return 0;
    80001950:	8526                	mv	a0,s1
    80001952:	bff9                	j	80001930 <either_copyin+0x32>

0000000080001954 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001954:	715d                	addi	sp,sp,-80
    80001956:	e486                	sd	ra,72(sp)
    80001958:	e0a2                	sd	s0,64(sp)
    8000195a:	fc26                	sd	s1,56(sp)
    8000195c:	f84a                	sd	s2,48(sp)
    8000195e:	f44e                	sd	s3,40(sp)
    80001960:	f052                	sd	s4,32(sp)
    80001962:	ec56                	sd	s5,24(sp)
    80001964:	e85a                	sd	s6,16(sp)
    80001966:	e45e                	sd	s7,8(sp)
    80001968:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000196a:	00006517          	auipc	a0,0x6
    8000196e:	6de50513          	addi	a0,a0,1758 # 80008048 <etext+0x48>
    80001972:	00004097          	auipc	ra,0x4
    80001976:	4a0080e7          	jalr	1184(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197a:	00008497          	auipc	s1,0x8
    8000197e:	c5e48493          	addi	s1,s1,-930 # 800095d8 <proc+0x158>
    80001982:	00009917          	auipc	s2,0x9
    80001986:	a6690913          	addi	s2,s2,-1434 # 8000a3e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000198a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000198c:	00007997          	auipc	s3,0x7
    80001990:	87498993          	addi	s3,s3,-1932 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001994:	00007a97          	auipc	s5,0x7
    80001998:	874a8a93          	addi	s5,s5,-1932 # 80008208 <etext+0x208>
    printf("\n");
    8000199c:	00006a17          	auipc	s4,0x6
    800019a0:	6aca0a13          	addi	s4,s4,1708 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a4:	00007b97          	auipc	s7,0x7
    800019a8:	89cb8b93          	addi	s7,s7,-1892 # 80008240 <states.1709>
    800019ac:	a00d                	j	800019ce <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ae:	ed86a583          	lw	a1,-296(a3)
    800019b2:	8556                	mv	a0,s5
    800019b4:	00004097          	auipc	ra,0x4
    800019b8:	45e080e7          	jalr	1118(ra) # 80005e12 <printf>
    printf("\n");
    800019bc:	8552                	mv	a0,s4
    800019be:	00004097          	auipc	ra,0x4
    800019c2:	454080e7          	jalr	1108(ra) # 80005e12 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c6:	16848493          	addi	s1,s1,360
    800019ca:	03248163          	beq	s1,s2,800019ec <procdump+0x98>
    if(p->state == UNUSED)
    800019ce:	86a6                	mv	a3,s1
    800019d0:	ec04a783          	lw	a5,-320(s1)
    800019d4:	dbed                	beqz	a5,800019c6 <procdump+0x72>
      state = "???";
    800019d6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d8:	fcfb6be3          	bltu	s6,a5,800019ae <procdump+0x5a>
    800019dc:	1782                	slli	a5,a5,0x20
    800019de:	9381                	srli	a5,a5,0x20
    800019e0:	078e                	slli	a5,a5,0x3
    800019e2:	97de                	add	a5,a5,s7
    800019e4:	6390                	ld	a2,0(a5)
    800019e6:	f661                	bnez	a2,800019ae <procdump+0x5a>
      state = "???";
    800019e8:	864e                	mv	a2,s3
    800019ea:	b7d1                	j	800019ae <procdump+0x5a>
  }
}
    800019ec:	60a6                	ld	ra,72(sp)
    800019ee:	6406                	ld	s0,64(sp)
    800019f0:	74e2                	ld	s1,56(sp)
    800019f2:	7942                	ld	s2,48(sp)
    800019f4:	79a2                	ld	s3,40(sp)
    800019f6:	7a02                	ld	s4,32(sp)
    800019f8:	6ae2                	ld	s5,24(sp)
    800019fa:	6b42                	ld	s6,16(sp)
    800019fc:	6ba2                	ld	s7,8(sp)
    800019fe:	6161                	addi	sp,sp,80
    80001a00:	8082                	ret

0000000080001a02 <swtch>:
    80001a02:	00153023          	sd	ra,0(a0)
    80001a06:	00253423          	sd	sp,8(a0)
    80001a0a:	e900                	sd	s0,16(a0)
    80001a0c:	ed04                	sd	s1,24(a0)
    80001a0e:	03253023          	sd	s2,32(a0)
    80001a12:	03353423          	sd	s3,40(a0)
    80001a16:	03453823          	sd	s4,48(a0)
    80001a1a:	03553c23          	sd	s5,56(a0)
    80001a1e:	05653023          	sd	s6,64(a0)
    80001a22:	05753423          	sd	s7,72(a0)
    80001a26:	05853823          	sd	s8,80(a0)
    80001a2a:	05953c23          	sd	s9,88(a0)
    80001a2e:	07a53023          	sd	s10,96(a0)
    80001a32:	07b53423          	sd	s11,104(a0)
    80001a36:	0005b083          	ld	ra,0(a1)
    80001a3a:	0085b103          	ld	sp,8(a1)
    80001a3e:	6980                	ld	s0,16(a1)
    80001a40:	6d84                	ld	s1,24(a1)
    80001a42:	0205b903          	ld	s2,32(a1)
    80001a46:	0285b983          	ld	s3,40(a1)
    80001a4a:	0305ba03          	ld	s4,48(a1)
    80001a4e:	0385ba83          	ld	s5,56(a1)
    80001a52:	0405bb03          	ld	s6,64(a1)
    80001a56:	0485bb83          	ld	s7,72(a1)
    80001a5a:	0505bc03          	ld	s8,80(a1)
    80001a5e:	0585bc83          	ld	s9,88(a1)
    80001a62:	0605bd03          	ld	s10,96(a1)
    80001a66:	0685bd83          	ld	s11,104(a1)
    80001a6a:	8082                	ret

0000000080001a6c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a6c:	1141                	addi	sp,sp,-16
    80001a6e:	e406                	sd	ra,8(sp)
    80001a70:	e022                	sd	s0,0(sp)
    80001a72:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a74:	00006597          	auipc	a1,0x6
    80001a78:	7fc58593          	addi	a1,a1,2044 # 80008270 <states.1709+0x30>
    80001a7c:	00009517          	auipc	a0,0x9
    80001a80:	81450513          	addi	a0,a0,-2028 # 8000a290 <tickslock>
    80001a84:	00004097          	auipc	ra,0x4
    80001a88:	7fe080e7          	jalr	2046(ra) # 80006282 <initlock>
}
    80001a8c:	60a2                	ld	ra,8(sp)
    80001a8e:	6402                	ld	s0,0(sp)
    80001a90:	0141                	addi	sp,sp,16
    80001a92:	8082                	ret

0000000080001a94 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a94:	1141                	addi	sp,sp,-16
    80001a96:	e422                	sd	s0,8(sp)
    80001a98:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a9a:	00003797          	auipc	a5,0x3
    80001a9e:	73678793          	addi	a5,a5,1846 # 800051d0 <kernelvec>
    80001aa2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa6:	6422                	ld	s0,8(sp)
    80001aa8:	0141                	addi	sp,sp,16
    80001aaa:	8082                	ret

0000000080001aac <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aac:	1141                	addi	sp,sp,-16
    80001aae:	e406                	sd	ra,8(sp)
    80001ab0:	e022                	sd	s0,0(sp)
    80001ab2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	394080e7          	jalr	916(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ac6:	00005617          	auipc	a2,0x5
    80001aca:	53a60613          	addi	a2,a2,1338 # 80007000 <_trampoline>
    80001ace:	00005697          	auipc	a3,0x5
    80001ad2:	53268693          	addi	a3,a3,1330 # 80007000 <_trampoline>
    80001ad6:	8e91                	sub	a3,a3,a2
    80001ad8:	040007b7          	lui	a5,0x4000
    80001adc:	17fd                	addi	a5,a5,-1
    80001ade:	07b2                	slli	a5,a5,0xc
    80001ae0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae8:	180026f3          	csrr	a3,satp
    80001aec:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aee:	6d38                	ld	a4,88(a0)
    80001af0:	6134                	ld	a3,64(a0)
    80001af2:	6585                	lui	a1,0x1
    80001af4:	96ae                	add	a3,a3,a1
    80001af6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af8:	6d38                	ld	a4,88(a0)
    80001afa:	00000697          	auipc	a3,0x0
    80001afe:	13868693          	addi	a3,a3,312 # 80001c32 <usertrap>
    80001b02:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b04:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b06:	8692                	mv	a3,tp
    80001b08:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b12:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b16:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b1a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b1c:	6f18                	ld	a4,24(a4)
    80001b1e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b22:	692c                	ld	a1,80(a0)
    80001b24:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b26:	00005717          	auipc	a4,0x5
    80001b2a:	56a70713          	addi	a4,a4,1386 # 80007090 <userret>
    80001b2e:	8f11                	sub	a4,a4,a2
    80001b30:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b32:	577d                	li	a4,-1
    80001b34:	177e                	slli	a4,a4,0x3f
    80001b36:	8dd9                	or	a1,a1,a4
    80001b38:	02000537          	lui	a0,0x2000
    80001b3c:	157d                	addi	a0,a0,-1
    80001b3e:	0536                	slli	a0,a0,0xd
    80001b40:	9782                	jalr	a5
}
    80001b42:	60a2                	ld	ra,8(sp)
    80001b44:	6402                	ld	s0,0(sp)
    80001b46:	0141                	addi	sp,sp,16
    80001b48:	8082                	ret

0000000080001b4a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b4a:	1101                	addi	sp,sp,-32
    80001b4c:	ec06                	sd	ra,24(sp)
    80001b4e:	e822                	sd	s0,16(sp)
    80001b50:	e426                	sd	s1,8(sp)
    80001b52:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b54:	00008497          	auipc	s1,0x8
    80001b58:	73c48493          	addi	s1,s1,1852 # 8000a290 <tickslock>
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	00004097          	auipc	ra,0x4
    80001b62:	7b4080e7          	jalr	1972(ra) # 80006312 <acquire>
  ticks++;
    80001b66:	00007517          	auipc	a0,0x7
    80001b6a:	4b250513          	addi	a0,a0,1202 # 80009018 <ticks>
    80001b6e:	411c                	lw	a5,0(a0)
    80001b70:	2785                	addiw	a5,a5,1
    80001b72:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b74:	00000097          	auipc	ra,0x0
    80001b78:	b1c080e7          	jalr	-1252(ra) # 80001690 <wakeup>
  release(&tickslock);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	00005097          	auipc	ra,0x5
    80001b82:	848080e7          	jalr	-1976(ra) # 800063c6 <release>
}
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6105                	addi	sp,sp,32
    80001b8e:	8082                	ret

0000000080001b90 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b9a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001b9e:	00074d63          	bltz	a4,80001bb8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba2:	57fd                	li	a5,-1
    80001ba4:	17fe                	slli	a5,a5,0x3f
    80001ba6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001baa:	06f70363          	beq	a4,a5,80001c10 <devintr+0x80>
  }
}
    80001bae:	60e2                	ld	ra,24(sp)
    80001bb0:	6442                	ld	s0,16(sp)
    80001bb2:	64a2                	ld	s1,8(sp)
    80001bb4:	6105                	addi	sp,sp,32
    80001bb6:	8082                	ret
     (scause & 0xff) == 9){
    80001bb8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bbc:	46a5                	li	a3,9
    80001bbe:	fed792e3          	bne	a5,a3,80001ba2 <devintr+0x12>
    int irq = plic_claim();
    80001bc2:	00003097          	auipc	ra,0x3
    80001bc6:	716080e7          	jalr	1814(ra) # 800052d8 <plic_claim>
    80001bca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bcc:	47a9                	li	a5,10
    80001bce:	02f50763          	beq	a0,a5,80001bfc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd2:	4785                	li	a5,1
    80001bd4:	02f50963          	beq	a0,a5,80001c06 <devintr+0x76>
    return 1;
    80001bd8:	4505                	li	a0,1
    } else if(irq){
    80001bda:	d8f1                	beqz	s1,80001bae <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bdc:	85a6                	mv	a1,s1
    80001bde:	00006517          	auipc	a0,0x6
    80001be2:	69a50513          	addi	a0,a0,1690 # 80008278 <states.1709+0x38>
    80001be6:	00004097          	auipc	ra,0x4
    80001bea:	22c080e7          	jalr	556(ra) # 80005e12 <printf>
      plic_complete(irq);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	00003097          	auipc	ra,0x3
    80001bf4:	70c080e7          	jalr	1804(ra) # 800052fc <plic_complete>
    return 1;
    80001bf8:	4505                	li	a0,1
    80001bfa:	bf55                	j	80001bae <devintr+0x1e>
      uartintr();
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	636080e7          	jalr	1590(ra) # 80006232 <uartintr>
    80001c04:	b7ed                	j	80001bee <devintr+0x5e>
      virtio_disk_intr();
    80001c06:	00004097          	auipc	ra,0x4
    80001c0a:	bd6080e7          	jalr	-1066(ra) # 800057dc <virtio_disk_intr>
    80001c0e:	b7c5                	j	80001bee <devintr+0x5e>
    if(cpuid() == 0){
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	20c080e7          	jalr	524(ra) # 80000e1c <cpuid>
    80001c18:	c901                	beqz	a0,80001c28 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c1a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c20:	14479073          	csrw	sip,a5
    return 2;
    80001c24:	4509                	li	a0,2
    80001c26:	b761                	j	80001bae <devintr+0x1e>
      clockintr();
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	f22080e7          	jalr	-222(ra) # 80001b4a <clockintr>
    80001c30:	b7ed                	j	80001c1a <devintr+0x8a>

0000000080001c32 <usertrap>:
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	e04a                	sd	s2,0(sp)
    80001c3c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c42:	1007f793          	andi	a5,a5,256
    80001c46:	e3ad                	bnez	a5,80001ca8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c48:	00003797          	auipc	a5,0x3
    80001c4c:	58878793          	addi	a5,a5,1416 # 800051d0 <kernelvec>
    80001c50:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c54:	fffff097          	auipc	ra,0xfffff
    80001c58:	1f4080e7          	jalr	500(ra) # 80000e48 <myproc>
    80001c5c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c5e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c60:	14102773          	csrr	a4,sepc
    80001c64:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c66:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c6a:	47a1                	li	a5,8
    80001c6c:	04f71c63          	bne	a4,a5,80001cc4 <usertrap+0x92>
    if(p->killed)
    80001c70:	551c                	lw	a5,40(a0)
    80001c72:	e3b9                	bnez	a5,80001cb8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c74:	6cb8                	ld	a4,88(s1)
    80001c76:	6f1c                	ld	a5,24(a4)
    80001c78:	0791                	addi	a5,a5,4
    80001c7a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c84:	10079073          	csrw	sstatus,a5
    syscall();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	2e0080e7          	jalr	736(ra) # 80001f68 <syscall>
  if(p->killed)
    80001c90:	549c                	lw	a5,40(s1)
    80001c92:	ebc1                	bnez	a5,80001d22 <usertrap+0xf0>
  usertrapret();
    80001c94:	00000097          	auipc	ra,0x0
    80001c98:	e18080e7          	jalr	-488(ra) # 80001aac <usertrapret>
}
    80001c9c:	60e2                	ld	ra,24(sp)
    80001c9e:	6442                	ld	s0,16(sp)
    80001ca0:	64a2                	ld	s1,8(sp)
    80001ca2:	6902                	ld	s2,0(sp)
    80001ca4:	6105                	addi	sp,sp,32
    80001ca6:	8082                	ret
    panic("usertrap: not from user mode");
    80001ca8:	00006517          	auipc	a0,0x6
    80001cac:	5f050513          	addi	a0,a0,1520 # 80008298 <states.1709+0x58>
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	118080e7          	jalr	280(ra) # 80005dc8 <panic>
      exit(-1);
    80001cb8:	557d                	li	a0,-1
    80001cba:	00000097          	auipc	ra,0x0
    80001cbe:	aa6080e7          	jalr	-1370(ra) # 80001760 <exit>
    80001cc2:	bf4d                	j	80001c74 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cc4:	00000097          	auipc	ra,0x0
    80001cc8:	ecc080e7          	jalr	-308(ra) # 80001b90 <devintr>
    80001ccc:	892a                	mv	s2,a0
    80001cce:	c501                	beqz	a0,80001cd6 <usertrap+0xa4>
  if(p->killed)
    80001cd0:	549c                	lw	a5,40(s1)
    80001cd2:	c3a1                	beqz	a5,80001d12 <usertrap+0xe0>
    80001cd4:	a815                	j	80001d08 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cda:	5890                	lw	a2,48(s1)
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5dc50513          	addi	a0,a0,1500 # 800082b8 <states.1709+0x78>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	12e080e7          	jalr	302(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf4:	00006517          	auipc	a0,0x6
    80001cf8:	5f450513          	addi	a0,a0,1524 # 800082e8 <states.1709+0xa8>
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	116080e7          	jalr	278(ra) # 80005e12 <printf>
    p->killed = 1;
    80001d04:	4785                	li	a5,1
    80001d06:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d08:	557d                	li	a0,-1
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	a56080e7          	jalr	-1450(ra) # 80001760 <exit>
  if(which_dev == 2)
    80001d12:	4789                	li	a5,2
    80001d14:	f8f910e3          	bne	s2,a5,80001c94 <usertrap+0x62>
    yield();
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	7b0080e7          	jalr	1968(ra) # 800014c8 <yield>
    80001d20:	bf95                	j	80001c94 <usertrap+0x62>
  int which_dev = 0;
    80001d22:	4901                	li	s2,0
    80001d24:	b7d5                	j	80001d08 <usertrap+0xd6>

0000000080001d26 <kerneltrap>:
{
    80001d26:	7179                	addi	sp,sp,-48
    80001d28:	f406                	sd	ra,40(sp)
    80001d2a:	f022                	sd	s0,32(sp)
    80001d2c:	ec26                	sd	s1,24(sp)
    80001d2e:	e84a                	sd	s2,16(sp)
    80001d30:	e44e                	sd	s3,8(sp)
    80001d32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d40:	1004f793          	andi	a5,s1,256
    80001d44:	cb85                	beqz	a5,80001d74 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d4a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d4c:	ef85                	bnez	a5,80001d84 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	e42080e7          	jalr	-446(ra) # 80001b90 <devintr>
    80001d56:	cd1d                	beqz	a0,80001d94 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d58:	4789                	li	a5,2
    80001d5a:	06f50a63          	beq	a0,a5,80001dce <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d5e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d62:	10049073          	csrw	sstatus,s1
}
    80001d66:	70a2                	ld	ra,40(sp)
    80001d68:	7402                	ld	s0,32(sp)
    80001d6a:	64e2                	ld	s1,24(sp)
    80001d6c:	6942                	ld	s2,16(sp)
    80001d6e:	69a2                	ld	s3,8(sp)
    80001d70:	6145                	addi	sp,sp,48
    80001d72:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	59450513          	addi	a0,a0,1428 # 80008308 <states.1709+0xc8>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	04c080e7          	jalr	76(ra) # 80005dc8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	5ac50513          	addi	a0,a0,1452 # 80008330 <states.1709+0xf0>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	03c080e7          	jalr	60(ra) # 80005dc8 <panic>
    printf("scause %p\n", scause);
    80001d94:	85ce                	mv	a1,s3
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	5ba50513          	addi	a0,a0,1466 # 80008350 <states.1709+0x110>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	074080e7          	jalr	116(ra) # 80005e12 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001daa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dae:	00006517          	auipc	a0,0x6
    80001db2:	5b250513          	addi	a0,a0,1458 # 80008360 <states.1709+0x120>
    80001db6:	00004097          	auipc	ra,0x4
    80001dba:	05c080e7          	jalr	92(ra) # 80005e12 <printf>
    panic("kerneltrap");
    80001dbe:	00006517          	auipc	a0,0x6
    80001dc2:	5ba50513          	addi	a0,a0,1466 # 80008378 <states.1709+0x138>
    80001dc6:	00004097          	auipc	ra,0x4
    80001dca:	002080e7          	jalr	2(ra) # 80005dc8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	07a080e7          	jalr	122(ra) # 80000e48 <myproc>
    80001dd6:	d541                	beqz	a0,80001d5e <kerneltrap+0x38>
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	070080e7          	jalr	112(ra) # 80000e48 <myproc>
    80001de0:	4d18                	lw	a4,24(a0)
    80001de2:	4791                	li	a5,4
    80001de4:	f6f71de3          	bne	a4,a5,80001d5e <kerneltrap+0x38>
    yield();
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	6e0080e7          	jalr	1760(ra) # 800014c8 <yield>
    80001df0:	b7bd                	j	80001d5e <kerneltrap+0x38>

0000000080001df2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	e426                	sd	s1,8(sp)
    80001dfa:	1000                	addi	s0,sp,32
    80001dfc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	04a080e7          	jalr	74(ra) # 80000e48 <myproc>
  switch (n) {
    80001e06:	4795                	li	a5,5
    80001e08:	0497e163          	bltu	a5,s1,80001e4a <argraw+0x58>
    80001e0c:	048a                	slli	s1,s1,0x2
    80001e0e:	00006717          	auipc	a4,0x6
    80001e12:	5a270713          	addi	a4,a4,1442 # 800083b0 <states.1709+0x170>
    80001e16:	94ba                	add	s1,s1,a4
    80001e18:	409c                	lw	a5,0(s1)
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e1e:	6d3c                	ld	a5,88(a0)
    80001e20:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e22:	60e2                	ld	ra,24(sp)
    80001e24:	6442                	ld	s0,16(sp)
    80001e26:	64a2                	ld	s1,8(sp)
    80001e28:	6105                	addi	sp,sp,32
    80001e2a:	8082                	ret
    return p->trapframe->a1;
    80001e2c:	6d3c                	ld	a5,88(a0)
    80001e2e:	7fa8                	ld	a0,120(a5)
    80001e30:	bfcd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a2;
    80001e32:	6d3c                	ld	a5,88(a0)
    80001e34:	63c8                	ld	a0,128(a5)
    80001e36:	b7f5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a3;
    80001e38:	6d3c                	ld	a5,88(a0)
    80001e3a:	67c8                	ld	a0,136(a5)
    80001e3c:	b7dd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a4;
    80001e3e:	6d3c                	ld	a5,88(a0)
    80001e40:	6bc8                	ld	a0,144(a5)
    80001e42:	b7c5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a5;
    80001e44:	6d3c                	ld	a5,88(a0)
    80001e46:	6fc8                	ld	a0,152(a5)
    80001e48:	bfe9                	j	80001e22 <argraw+0x30>
  panic("argraw");
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	53e50513          	addi	a0,a0,1342 # 80008388 <states.1709+0x148>
    80001e52:	00004097          	auipc	ra,0x4
    80001e56:	f76080e7          	jalr	-138(ra) # 80005dc8 <panic>

0000000080001e5a <fetchaddr>:
{
    80001e5a:	1101                	addi	sp,sp,-32
    80001e5c:	ec06                	sd	ra,24(sp)
    80001e5e:	e822                	sd	s0,16(sp)
    80001e60:	e426                	sd	s1,8(sp)
    80001e62:	e04a                	sd	s2,0(sp)
    80001e64:	1000                	addi	s0,sp,32
    80001e66:	84aa                	mv	s1,a0
    80001e68:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	fde080e7          	jalr	-34(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e72:	653c                	ld	a5,72(a0)
    80001e74:	02f4f863          	bgeu	s1,a5,80001ea4 <fetchaddr+0x4a>
    80001e78:	00848713          	addi	a4,s1,8
    80001e7c:	02e7e663          	bltu	a5,a4,80001ea8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e80:	46a1                	li	a3,8
    80001e82:	8626                	mv	a2,s1
    80001e84:	85ca                	mv	a1,s2
    80001e86:	6928                	ld	a0,80(a0)
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	d0e080e7          	jalr	-754(ra) # 80000b96 <copyin>
    80001e90:	00a03533          	snez	a0,a0
    80001e94:	40a00533          	neg	a0,a0
}
    80001e98:	60e2                	ld	ra,24(sp)
    80001e9a:	6442                	ld	s0,16(sp)
    80001e9c:	64a2                	ld	s1,8(sp)
    80001e9e:	6902                	ld	s2,0(sp)
    80001ea0:	6105                	addi	sp,sp,32
    80001ea2:	8082                	ret
    return -1;
    80001ea4:	557d                	li	a0,-1
    80001ea6:	bfcd                	j	80001e98 <fetchaddr+0x3e>
    80001ea8:	557d                	li	a0,-1
    80001eaa:	b7fd                	j	80001e98 <fetchaddr+0x3e>

0000000080001eac <fetchstr>:
{
    80001eac:	7179                	addi	sp,sp,-48
    80001eae:	f406                	sd	ra,40(sp)
    80001eb0:	f022                	sd	s0,32(sp)
    80001eb2:	ec26                	sd	s1,24(sp)
    80001eb4:	e84a                	sd	s2,16(sp)
    80001eb6:	e44e                	sd	s3,8(sp)
    80001eb8:	1800                	addi	s0,sp,48
    80001eba:	892a                	mv	s2,a0
    80001ebc:	84ae                	mv	s1,a1
    80001ebe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	f88080e7          	jalr	-120(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ec8:	86ce                	mv	a3,s3
    80001eca:	864a                	mv	a2,s2
    80001ecc:	85a6                	mv	a1,s1
    80001ece:	6928                	ld	a0,80(a0)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	d52080e7          	jalr	-686(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ed8:	00054763          	bltz	a0,80001ee6 <fetchstr+0x3a>
  return strlen(buf);
    80001edc:	8526                	mv	a0,s1
    80001ede:	ffffe097          	auipc	ra,0xffffe
    80001ee2:	41e080e7          	jalr	1054(ra) # 800002fc <strlen>
}
    80001ee6:	70a2                	ld	ra,40(sp)
    80001ee8:	7402                	ld	s0,32(sp)
    80001eea:	64e2                	ld	s1,24(sp)
    80001eec:	6942                	ld	s2,16(sp)
    80001eee:	69a2                	ld	s3,8(sp)
    80001ef0:	6145                	addi	sp,sp,48
    80001ef2:	8082                	ret

0000000080001ef4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ef4:	1101                	addi	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	e426                	sd	s1,8(sp)
    80001efc:	1000                	addi	s0,sp,32
    80001efe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	ef2080e7          	jalr	-270(ra) # 80001df2 <argraw>
    80001f08:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f0a:	4501                	li	a0,0
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret

0000000080001f16 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	1000                	addi	s0,sp,32
    80001f20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	ed0080e7          	jalr	-304(ra) # 80001df2 <argraw>
    80001f2a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f2c:	4501                	li	a0,0
    80001f2e:	60e2                	ld	ra,24(sp)
    80001f30:	6442                	ld	s0,16(sp)
    80001f32:	64a2                	ld	s1,8(sp)
    80001f34:	6105                	addi	sp,sp,32
    80001f36:	8082                	ret

0000000080001f38 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	e04a                	sd	s2,0(sp)
    80001f42:	1000                	addi	s0,sp,32
    80001f44:	84ae                	mv	s1,a1
    80001f46:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	eaa080e7          	jalr	-342(ra) # 80001df2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f50:	864a                	mv	a2,s2
    80001f52:	85a6                	mv	a1,s1
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	f58080e7          	jalr	-168(ra) # 80001eac <fetchstr>
}
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6902                	ld	s2,0(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret

0000000080001f68 <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	e04a                	sd	s2,0(sp)
    80001f72:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	ed4080e7          	jalr	-300(ra) # 80000e48 <myproc>
    80001f7c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f7e:	05853903          	ld	s2,88(a0)
    80001f82:	0a893783          	ld	a5,168(s2)
    80001f86:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f8a:	37fd                	addiw	a5,a5,-1
    80001f8c:	4755                	li	a4,21
    80001f8e:	00f76f63          	bltu	a4,a5,80001fac <syscall+0x44>
    80001f92:	00369713          	slli	a4,a3,0x3
    80001f96:	00006797          	auipc	a5,0x6
    80001f9a:	43278793          	addi	a5,a5,1074 # 800083c8 <syscalls>
    80001f9e:	97ba                	add	a5,a5,a4
    80001fa0:	639c                	ld	a5,0(a5)
    80001fa2:	c789                	beqz	a5,80001fac <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fa4:	9782                	jalr	a5
    80001fa6:	06a93823          	sd	a0,112(s2)
    80001faa:	a839                	j	80001fc8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fac:	15848613          	addi	a2,s1,344
    80001fb0:	588c                	lw	a1,48(s1)
    80001fb2:	00006517          	auipc	a0,0x6
    80001fb6:	3de50513          	addi	a0,a0,990 # 80008390 <states.1709+0x150>
    80001fba:	00004097          	auipc	ra,0x4
    80001fbe:	e58080e7          	jalr	-424(ra) # 80005e12 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc2:	6cbc                	ld	a5,88(s1)
    80001fc4:	577d                	li	a4,-1
    80001fc6:	fbb8                	sd	a4,112(a5)
  }
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fdc:	fec40593          	addi	a1,s0,-20
    80001fe0:	4501                	li	a0,0
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	f12080e7          	jalr	-238(ra) # 80001ef4 <argint>
    return -1;
    80001fea:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001fec:	00054963          	bltz	a0,80001ffe <sys_exit+0x2a>
  exit(n);
    80001ff0:	fec42503          	lw	a0,-20(s0)
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	76c080e7          	jalr	1900(ra) # 80001760 <exit>
  return 0;  // not reached
    80001ffc:	4781                	li	a5,0
}
    80001ffe:	853e                	mv	a0,a5
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret

0000000080002008 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002008:	1141                	addi	sp,sp,-16
    8000200a:	e406                	sd	ra,8(sp)
    8000200c:	e022                	sd	s0,0(sp)
    8000200e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	e38080e7          	jalr	-456(ra) # 80000e48 <myproc>
}
    80002018:	5908                	lw	a0,48(a0)
    8000201a:	60a2                	ld	ra,8(sp)
    8000201c:	6402                	ld	s0,0(sp)
    8000201e:	0141                	addi	sp,sp,16
    80002020:	8082                	ret

0000000080002022 <sys_fork>:

uint64
sys_fork(void)
{
    80002022:	1141                	addi	sp,sp,-16
    80002024:	e406                	sd	ra,8(sp)
    80002026:	e022                	sd	s0,0(sp)
    80002028:	0800                	addi	s0,sp,16
  return fork();
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	1ec080e7          	jalr	492(ra) # 80001216 <fork>
}
    80002032:	60a2                	ld	ra,8(sp)
    80002034:	6402                	ld	s0,0(sp)
    80002036:	0141                	addi	sp,sp,16
    80002038:	8082                	ret

000000008000203a <sys_wait>:

uint64
sys_wait(void)
{
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002042:	fe840593          	addi	a1,s0,-24
    80002046:	4501                	li	a0,0
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	ece080e7          	jalr	-306(ra) # 80001f16 <argaddr>
    80002050:	87aa                	mv	a5,a0
    return -1;
    80002052:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002054:	0007c863          	bltz	a5,80002064 <sys_wait+0x2a>
  return wait(p);
    80002058:	fe843503          	ld	a0,-24(s0)
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	50c080e7          	jalr	1292(ra) # 80001568 <wait>
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret

000000008000206c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000206c:	7179                	addi	sp,sp,-48
    8000206e:	f406                	sd	ra,40(sp)
    80002070:	f022                	sd	s0,32(sp)
    80002072:	ec26                	sd	s1,24(sp)
    80002074:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002076:	fdc40593          	addi	a1,s0,-36
    8000207a:	4501                	li	a0,0
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	e78080e7          	jalr	-392(ra) # 80001ef4 <argint>
    80002084:	87aa                	mv	a5,a0
    return -1;
    80002086:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002088:	0207c063          	bltz	a5,800020a8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	dbc080e7          	jalr	-580(ra) # 80000e48 <myproc>
    80002094:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002096:	fdc42503          	lw	a0,-36(s0)
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	108080e7          	jalr	264(ra) # 800011a2 <growproc>
    800020a2:	00054863          	bltz	a0,800020b2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020a6:	8526                	mv	a0,s1
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret
    return -1;
    800020b2:	557d                	li	a0,-1
    800020b4:	bfd5                	j	800020a8 <sys_sbrk+0x3c>

00000000800020b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020b6:	7139                	addi	sp,sp,-64
    800020b8:	fc06                	sd	ra,56(sp)
    800020ba:	f822                	sd	s0,48(sp)
    800020bc:	f426                	sd	s1,40(sp)
    800020be:	f04a                	sd	s2,32(sp)
    800020c0:	ec4e                	sd	s3,24(sp)
    800020c2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020c4:	fcc40593          	addi	a1,s0,-52
    800020c8:	4501                	li	a0,0
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	e2a080e7          	jalr	-470(ra) # 80001ef4 <argint>
    return -1;
    800020d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d4:	06054563          	bltz	a0,8000213e <sys_sleep+0x88>
  acquire(&tickslock);
    800020d8:	00008517          	auipc	a0,0x8
    800020dc:	1b850513          	addi	a0,a0,440 # 8000a290 <tickslock>
    800020e0:	00004097          	auipc	ra,0x4
    800020e4:	232080e7          	jalr	562(ra) # 80006312 <acquire>
  ticks0 = ticks;
    800020e8:	00007917          	auipc	s2,0x7
    800020ec:	f3092903          	lw	s2,-208(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020f0:	fcc42783          	lw	a5,-52(s0)
    800020f4:	cf85                	beqz	a5,8000212c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020f6:	00008997          	auipc	s3,0x8
    800020fa:	19a98993          	addi	s3,s3,410 # 8000a290 <tickslock>
    800020fe:	00007497          	auipc	s1,0x7
    80002102:	f1a48493          	addi	s1,s1,-230 # 80009018 <ticks>
    if(myproc()->killed){
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	d42080e7          	jalr	-702(ra) # 80000e48 <myproc>
    8000210e:	551c                	lw	a5,40(a0)
    80002110:	ef9d                	bnez	a5,8000214e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002112:	85ce                	mv	a1,s3
    80002114:	8526                	mv	a0,s1
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	3ee080e7          	jalr	1006(ra) # 80001504 <sleep>
  while(ticks - ticks0 < n){
    8000211e:	409c                	lw	a5,0(s1)
    80002120:	412787bb          	subw	a5,a5,s2
    80002124:	fcc42703          	lw	a4,-52(s0)
    80002128:	fce7efe3          	bltu	a5,a4,80002106 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000212c:	00008517          	auipc	a0,0x8
    80002130:	16450513          	addi	a0,a0,356 # 8000a290 <tickslock>
    80002134:	00004097          	auipc	ra,0x4
    80002138:	292080e7          	jalr	658(ra) # 800063c6 <release>
  return 0;
    8000213c:	4781                	li	a5,0
}
    8000213e:	853e                	mv	a0,a5
    80002140:	70e2                	ld	ra,56(sp)
    80002142:	7442                	ld	s0,48(sp)
    80002144:	74a2                	ld	s1,40(sp)
    80002146:	7902                	ld	s2,32(sp)
    80002148:	69e2                	ld	s3,24(sp)
    8000214a:	6121                	addi	sp,sp,64
    8000214c:	8082                	ret
      release(&tickslock);
    8000214e:	00008517          	auipc	a0,0x8
    80002152:	14250513          	addi	a0,a0,322 # 8000a290 <tickslock>
    80002156:	00004097          	auipc	ra,0x4
    8000215a:	270080e7          	jalr	624(ra) # 800063c6 <release>
      return -1;
    8000215e:	57fd                	li	a5,-1
    80002160:	bff9                	j	8000213e <sys_sleep+0x88>

0000000080002162 <sys_kill>:

uint64
sys_kill(void)
{
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000216a:	fec40593          	addi	a1,s0,-20
    8000216e:	4501                	li	a0,0
    80002170:	00000097          	auipc	ra,0x0
    80002174:	d84080e7          	jalr	-636(ra) # 80001ef4 <argint>
    80002178:	87aa                	mv	a5,a0
    return -1;
    8000217a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000217c:	0007c863          	bltz	a5,8000218c <sys_kill+0x2a>
  return kill(pid);
    80002180:	fec42503          	lw	a0,-20(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	6b2080e7          	jalr	1714(ra) # 80001836 <kill>
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000219e:	00008517          	auipc	a0,0x8
    800021a2:	0f250513          	addi	a0,a0,242 # 8000a290 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	16c080e7          	jalr	364(ra) # 80006312 <acquire>
  xticks = ticks;
    800021ae:	00007497          	auipc	s1,0x7
    800021b2:	e6a4a483          	lw	s1,-406(s1) # 80009018 <ticks>
  release(&tickslock);
    800021b6:	00008517          	auipc	a0,0x8
    800021ba:	0da50513          	addi	a0,a0,218 # 8000a290 <tickslock>
    800021be:	00004097          	auipc	ra,0x4
    800021c2:	208080e7          	jalr	520(ra) # 800063c6 <release>
  return xticks;
}
    800021c6:	02049513          	slli	a0,s1,0x20
    800021ca:	9101                	srli	a0,a0,0x20
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	64a2                	ld	s1,8(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021d6:	7179                	addi	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	e84a                	sd	s2,16(sp)
    800021e0:	e44e                	sd	s3,8(sp)
    800021e2:	e052                	sd	s4,0(sp)
    800021e4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021e6:	00006597          	auipc	a1,0x6
    800021ea:	29a58593          	addi	a1,a1,666 # 80008480 <syscalls+0xb8>
    800021ee:	00008517          	auipc	a0,0x8
    800021f2:	0ba50513          	addi	a0,a0,186 # 8000a2a8 <bcache>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	08c080e7          	jalr	140(ra) # 80006282 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021fe:	00010797          	auipc	a5,0x10
    80002202:	0aa78793          	addi	a5,a5,170 # 800122a8 <bcache+0x8000>
    80002206:	00010717          	auipc	a4,0x10
    8000220a:	30a70713          	addi	a4,a4,778 # 80012510 <bcache+0x8268>
    8000220e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002212:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002216:	00008497          	auipc	s1,0x8
    8000221a:	0aa48493          	addi	s1,s1,170 # 8000a2c0 <bcache+0x18>
    b->next = bcache.head.next;
    8000221e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002220:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002222:	00006a17          	auipc	s4,0x6
    80002226:	266a0a13          	addi	s4,s4,614 # 80008488 <syscalls+0xc0>
    b->next = bcache.head.next;
    8000222a:	2b893783          	ld	a5,696(s2)
    8000222e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002230:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002234:	85d2                	mv	a1,s4
    80002236:	01048513          	addi	a0,s1,16
    8000223a:	00001097          	auipc	ra,0x1
    8000223e:	626080e7          	jalr	1574(ra) # 80003860 <initsleeplock>
    bcache.head.next->prev = b;
    80002242:	2b893783          	ld	a5,696(s2)
    80002246:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002248:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000224c:	45848493          	addi	s1,s1,1112
    80002250:	fd349de3          	bne	s1,s3,8000222a <binit+0x54>
  }
}
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6942                	ld	s2,16(sp)
    8000225c:	69a2                	ld	s3,8(sp)
    8000225e:	6a02                	ld	s4,0(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret

0000000080002264 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	e84a                	sd	s2,16(sp)
    8000226e:	e44e                	sd	s3,8(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	89aa                	mv	s3,a0
    80002274:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002276:	00008517          	auipc	a0,0x8
    8000227a:	03250513          	addi	a0,a0,50 # 8000a2a8 <bcache>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	094080e7          	jalr	148(ra) # 80006312 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002286:	00010497          	auipc	s1,0x10
    8000228a:	2da4b483          	ld	s1,730(s1) # 80012560 <bcache+0x82b8>
    8000228e:	00010797          	auipc	a5,0x10
    80002292:	28278793          	addi	a5,a5,642 # 80012510 <bcache+0x8268>
    80002296:	02f48f63          	beq	s1,a5,800022d4 <bread+0x70>
    8000229a:	873e                	mv	a4,a5
    8000229c:	a021                	j	800022a4 <bread+0x40>
    8000229e:	68a4                	ld	s1,80(s1)
    800022a0:	02e48a63          	beq	s1,a4,800022d4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022a4:	449c                	lw	a5,8(s1)
    800022a6:	ff379ce3          	bne	a5,s3,8000229e <bread+0x3a>
    800022aa:	44dc                	lw	a5,12(s1)
    800022ac:	ff2799e3          	bne	a5,s2,8000229e <bread+0x3a>
      b->refcnt++;
    800022b0:	40bc                	lw	a5,64(s1)
    800022b2:	2785                	addiw	a5,a5,1
    800022b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022b6:	00008517          	auipc	a0,0x8
    800022ba:	ff250513          	addi	a0,a0,-14 # 8000a2a8 <bcache>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	108080e7          	jalr	264(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    800022c6:	01048513          	addi	a0,s1,16
    800022ca:	00001097          	auipc	ra,0x1
    800022ce:	5d0080e7          	jalr	1488(ra) # 8000389a <acquiresleep>
      return b;
    800022d2:	a8b9                	j	80002330 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022d4:	00010497          	auipc	s1,0x10
    800022d8:	2844b483          	ld	s1,644(s1) # 80012558 <bcache+0x82b0>
    800022dc:	00010797          	auipc	a5,0x10
    800022e0:	23478793          	addi	a5,a5,564 # 80012510 <bcache+0x8268>
    800022e4:	00f48863          	beq	s1,a5,800022f4 <bread+0x90>
    800022e8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022ea:	40bc                	lw	a5,64(s1)
    800022ec:	cf81                	beqz	a5,80002304 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ee:	64a4                	ld	s1,72(s1)
    800022f0:	fee49de3          	bne	s1,a4,800022ea <bread+0x86>
  panic("bget: no buffers");
    800022f4:	00006517          	auipc	a0,0x6
    800022f8:	19c50513          	addi	a0,a0,412 # 80008490 <syscalls+0xc8>
    800022fc:	00004097          	auipc	ra,0x4
    80002300:	acc080e7          	jalr	-1332(ra) # 80005dc8 <panic>
      b->dev = dev;
    80002304:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002308:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000230c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002310:	4785                	li	a5,1
    80002312:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002314:	00008517          	auipc	a0,0x8
    80002318:	f9450513          	addi	a0,a0,-108 # 8000a2a8 <bcache>
    8000231c:	00004097          	auipc	ra,0x4
    80002320:	0aa080e7          	jalr	170(ra) # 800063c6 <release>
      acquiresleep(&b->lock);
    80002324:	01048513          	addi	a0,s1,16
    80002328:	00001097          	auipc	ra,0x1
    8000232c:	572080e7          	jalr	1394(ra) # 8000389a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002330:	409c                	lw	a5,0(s1)
    80002332:	cb89                	beqz	a5,80002344 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002334:	8526                	mv	a0,s1
    80002336:	70a2                	ld	ra,40(sp)
    80002338:	7402                	ld	s0,32(sp)
    8000233a:	64e2                	ld	s1,24(sp)
    8000233c:	6942                	ld	s2,16(sp)
    8000233e:	69a2                	ld	s3,8(sp)
    80002340:	6145                	addi	sp,sp,48
    80002342:	8082                	ret
    virtio_disk_rw(b, 0);
    80002344:	4581                	li	a1,0
    80002346:	8526                	mv	a0,s1
    80002348:	00003097          	auipc	ra,0x3
    8000234c:	1be080e7          	jalr	446(ra) # 80005506 <virtio_disk_rw>
    b->valid = 1;
    80002350:	4785                	li	a5,1
    80002352:	c09c                	sw	a5,0(s1)
  return b;
    80002354:	b7c5                	j	80002334 <bread+0xd0>

0000000080002356 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	e426                	sd	s1,8(sp)
    8000235e:	1000                	addi	s0,sp,32
    80002360:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002362:	0541                	addi	a0,a0,16
    80002364:	00001097          	auipc	ra,0x1
    80002368:	5d0080e7          	jalr	1488(ra) # 80003934 <holdingsleep>
    8000236c:	cd01                	beqz	a0,80002384 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000236e:	4585                	li	a1,1
    80002370:	8526                	mv	a0,s1
    80002372:	00003097          	auipc	ra,0x3
    80002376:	194080e7          	jalr	404(ra) # 80005506 <virtio_disk_rw>
}
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	addi	sp,sp,32
    80002382:	8082                	ret
    panic("bwrite");
    80002384:	00006517          	auipc	a0,0x6
    80002388:	12450513          	addi	a0,a0,292 # 800084a8 <syscalls+0xe0>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	a3c080e7          	jalr	-1476(ra) # 80005dc8 <panic>

0000000080002394 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002394:	1101                	addi	sp,sp,-32
    80002396:	ec06                	sd	ra,24(sp)
    80002398:	e822                	sd	s0,16(sp)
    8000239a:	e426                	sd	s1,8(sp)
    8000239c:	e04a                	sd	s2,0(sp)
    8000239e:	1000                	addi	s0,sp,32
    800023a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a2:	01050913          	addi	s2,a0,16
    800023a6:	854a                	mv	a0,s2
    800023a8:	00001097          	auipc	ra,0x1
    800023ac:	58c080e7          	jalr	1420(ra) # 80003934 <holdingsleep>
    800023b0:	c92d                	beqz	a0,80002422 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023b2:	854a                	mv	a0,s2
    800023b4:	00001097          	auipc	ra,0x1
    800023b8:	53c080e7          	jalr	1340(ra) # 800038f0 <releasesleep>

  acquire(&bcache.lock);
    800023bc:	00008517          	auipc	a0,0x8
    800023c0:	eec50513          	addi	a0,a0,-276 # 8000a2a8 <bcache>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	f4e080e7          	jalr	-178(ra) # 80006312 <acquire>
  b->refcnt--;
    800023cc:	40bc                	lw	a5,64(s1)
    800023ce:	37fd                	addiw	a5,a5,-1
    800023d0:	0007871b          	sext.w	a4,a5
    800023d4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023d6:	eb05                	bnez	a4,80002406 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023d8:	68bc                	ld	a5,80(s1)
    800023da:	64b8                	ld	a4,72(s1)
    800023dc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023de:	64bc                	ld	a5,72(s1)
    800023e0:	68b8                	ld	a4,80(s1)
    800023e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023e4:	00010797          	auipc	a5,0x10
    800023e8:	ec478793          	addi	a5,a5,-316 # 800122a8 <bcache+0x8000>
    800023ec:	2b87b703          	ld	a4,696(a5)
    800023f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023f2:	00010717          	auipc	a4,0x10
    800023f6:	11e70713          	addi	a4,a4,286 # 80012510 <bcache+0x8268>
    800023fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023fc:	2b87b703          	ld	a4,696(a5)
    80002400:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002402:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002406:	00008517          	auipc	a0,0x8
    8000240a:	ea250513          	addi	a0,a0,-350 # 8000a2a8 <bcache>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	fb8080e7          	jalr	-72(ra) # 800063c6 <release>
}
    80002416:	60e2                	ld	ra,24(sp)
    80002418:	6442                	ld	s0,16(sp)
    8000241a:	64a2                	ld	s1,8(sp)
    8000241c:	6902                	ld	s2,0(sp)
    8000241e:	6105                	addi	sp,sp,32
    80002420:	8082                	ret
    panic("brelse");
    80002422:	00006517          	auipc	a0,0x6
    80002426:	08e50513          	addi	a0,a0,142 # 800084b0 <syscalls+0xe8>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	99e080e7          	jalr	-1634(ra) # 80005dc8 <panic>

0000000080002432 <bpin>:

void
bpin(struct buf *b) {
    80002432:	1101                	addi	sp,sp,-32
    80002434:	ec06                	sd	ra,24(sp)
    80002436:	e822                	sd	s0,16(sp)
    80002438:	e426                	sd	s1,8(sp)
    8000243a:	1000                	addi	s0,sp,32
    8000243c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000243e:	00008517          	auipc	a0,0x8
    80002442:	e6a50513          	addi	a0,a0,-406 # 8000a2a8 <bcache>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	ecc080e7          	jalr	-308(ra) # 80006312 <acquire>
  b->refcnt++;
    8000244e:	40bc                	lw	a5,64(s1)
    80002450:	2785                	addiw	a5,a5,1
    80002452:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002454:	00008517          	auipc	a0,0x8
    80002458:	e5450513          	addi	a0,a0,-428 # 8000a2a8 <bcache>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	f6a080e7          	jalr	-150(ra) # 800063c6 <release>
}
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	64a2                	ld	s1,8(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <bunpin>:

void
bunpin(struct buf *b) {
    8000246e:	1101                	addi	sp,sp,-32
    80002470:	ec06                	sd	ra,24(sp)
    80002472:	e822                	sd	s0,16(sp)
    80002474:	e426                	sd	s1,8(sp)
    80002476:	1000                	addi	s0,sp,32
    80002478:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000247a:	00008517          	auipc	a0,0x8
    8000247e:	e2e50513          	addi	a0,a0,-466 # 8000a2a8 <bcache>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	e90080e7          	jalr	-368(ra) # 80006312 <acquire>
  b->refcnt--;
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	37fd                	addiw	a5,a5,-1
    8000248e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002490:	00008517          	auipc	a0,0x8
    80002494:	e1850513          	addi	a0,a0,-488 # 8000a2a8 <bcache>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	f2e080e7          	jalr	-210(ra) # 800063c6 <release>
}
    800024a0:	60e2                	ld	ra,24(sp)
    800024a2:	6442                	ld	s0,16(sp)
    800024a4:	64a2                	ld	s1,8(sp)
    800024a6:	6105                	addi	sp,sp,32
    800024a8:	8082                	ret

00000000800024aa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024aa:	1101                	addi	sp,sp,-32
    800024ac:	ec06                	sd	ra,24(sp)
    800024ae:	e822                	sd	s0,16(sp)
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	e04a                	sd	s2,0(sp)
    800024b4:	1000                	addi	s0,sp,32
    800024b6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024b8:	00d5d59b          	srliw	a1,a1,0xd
    800024bc:	00010797          	auipc	a5,0x10
    800024c0:	4c87a783          	lw	a5,1224(a5) # 80012984 <sb+0x1c>
    800024c4:	9dbd                	addw	a1,a1,a5
    800024c6:	00000097          	auipc	ra,0x0
    800024ca:	d9e080e7          	jalr	-610(ra) # 80002264 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024ce:	0074f713          	andi	a4,s1,7
    800024d2:	4785                	li	a5,1
    800024d4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024d8:	14ce                	slli	s1,s1,0x33
    800024da:	90d9                	srli	s1,s1,0x36
    800024dc:	00950733          	add	a4,a0,s1
    800024e0:	05874703          	lbu	a4,88(a4)
    800024e4:	00e7f6b3          	and	a3,a5,a4
    800024e8:	c69d                	beqz	a3,80002516 <bfree+0x6c>
    800024ea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024ec:	94aa                	add	s1,s1,a0
    800024ee:	fff7c793          	not	a5,a5
    800024f2:	8ff9                	and	a5,a5,a4
    800024f4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800024f8:	00001097          	auipc	ra,0x1
    800024fc:	282080e7          	jalr	642(ra) # 8000377a <log_write>
  brelse(bp);
    80002500:	854a                	mv	a0,s2
    80002502:	00000097          	auipc	ra,0x0
    80002506:	e92080e7          	jalr	-366(ra) # 80002394 <brelse>
}
    8000250a:	60e2                	ld	ra,24(sp)
    8000250c:	6442                	ld	s0,16(sp)
    8000250e:	64a2                	ld	s1,8(sp)
    80002510:	6902                	ld	s2,0(sp)
    80002512:	6105                	addi	sp,sp,32
    80002514:	8082                	ret
    panic("freeing free block");
    80002516:	00006517          	auipc	a0,0x6
    8000251a:	fa250513          	addi	a0,a0,-94 # 800084b8 <syscalls+0xf0>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	8aa080e7          	jalr	-1878(ra) # 80005dc8 <panic>

0000000080002526 <balloc>:
{
    80002526:	711d                	addi	sp,sp,-96
    80002528:	ec86                	sd	ra,88(sp)
    8000252a:	e8a2                	sd	s0,80(sp)
    8000252c:	e4a6                	sd	s1,72(sp)
    8000252e:	e0ca                	sd	s2,64(sp)
    80002530:	fc4e                	sd	s3,56(sp)
    80002532:	f852                	sd	s4,48(sp)
    80002534:	f456                	sd	s5,40(sp)
    80002536:	f05a                	sd	s6,32(sp)
    80002538:	ec5e                	sd	s7,24(sp)
    8000253a:	e862                	sd	s8,16(sp)
    8000253c:	e466                	sd	s9,8(sp)
    8000253e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002540:	00010797          	auipc	a5,0x10
    80002544:	42c7a783          	lw	a5,1068(a5) # 8001296c <sb+0x4>
    80002548:	cbd1                	beqz	a5,800025dc <balloc+0xb6>
    8000254a:	8baa                	mv	s7,a0
    8000254c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000254e:	00010b17          	auipc	s6,0x10
    80002552:	41ab0b13          	addi	s6,s6,1050 # 80012968 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002556:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002558:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000255a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000255c:	6c89                	lui	s9,0x2
    8000255e:	a831                	j	8000257a <balloc+0x54>
    brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	00000097          	auipc	ra,0x0
    80002566:	e32080e7          	jalr	-462(ra) # 80002394 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000256a:	015c87bb          	addw	a5,s9,s5
    8000256e:	00078a9b          	sext.w	s5,a5
    80002572:	004b2703          	lw	a4,4(s6)
    80002576:	06eaf363          	bgeu	s5,a4,800025dc <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000257a:	41fad79b          	sraiw	a5,s5,0x1f
    8000257e:	0137d79b          	srliw	a5,a5,0x13
    80002582:	015787bb          	addw	a5,a5,s5
    80002586:	40d7d79b          	sraiw	a5,a5,0xd
    8000258a:	01cb2583          	lw	a1,28(s6)
    8000258e:	9dbd                	addw	a1,a1,a5
    80002590:	855e                	mv	a0,s7
    80002592:	00000097          	auipc	ra,0x0
    80002596:	cd2080e7          	jalr	-814(ra) # 80002264 <bread>
    8000259a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000259c:	004b2503          	lw	a0,4(s6)
    800025a0:	000a849b          	sext.w	s1,s5
    800025a4:	8662                	mv	a2,s8
    800025a6:	faa4fde3          	bgeu	s1,a0,80002560 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025aa:	41f6579b          	sraiw	a5,a2,0x1f
    800025ae:	01d7d69b          	srliw	a3,a5,0x1d
    800025b2:	00c6873b          	addw	a4,a3,a2
    800025b6:	00777793          	andi	a5,a4,7
    800025ba:	9f95                	subw	a5,a5,a3
    800025bc:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025c0:	4037571b          	sraiw	a4,a4,0x3
    800025c4:	00e906b3          	add	a3,s2,a4
    800025c8:	0586c683          	lbu	a3,88(a3)
    800025cc:	00d7f5b3          	and	a1,a5,a3
    800025d0:	cd91                	beqz	a1,800025ec <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d2:	2605                	addiw	a2,a2,1
    800025d4:	2485                	addiw	s1,s1,1
    800025d6:	fd4618e3          	bne	a2,s4,800025a6 <balloc+0x80>
    800025da:	b759                	j	80002560 <balloc+0x3a>
  panic("balloc: out of blocks");
    800025dc:	00006517          	auipc	a0,0x6
    800025e0:	ef450513          	addi	a0,a0,-268 # 800084d0 <syscalls+0x108>
    800025e4:	00003097          	auipc	ra,0x3
    800025e8:	7e4080e7          	jalr	2020(ra) # 80005dc8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025ec:	974a                	add	a4,a4,s2
    800025ee:	8fd5                	or	a5,a5,a3
    800025f0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	184080e7          	jalr	388(ra) # 8000377a <log_write>
        brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00000097          	auipc	ra,0x0
    80002604:	d94080e7          	jalr	-620(ra) # 80002394 <brelse>
  bp = bread(dev, bno);
    80002608:	85a6                	mv	a1,s1
    8000260a:	855e                	mv	a0,s7
    8000260c:	00000097          	auipc	ra,0x0
    80002610:	c58080e7          	jalr	-936(ra) # 80002264 <bread>
    80002614:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002616:	40000613          	li	a2,1024
    8000261a:	4581                	li	a1,0
    8000261c:	05850513          	addi	a0,a0,88
    80002620:	ffffe097          	auipc	ra,0xffffe
    80002624:	b58080e7          	jalr	-1192(ra) # 80000178 <memset>
  log_write(bp);
    80002628:	854a                	mv	a0,s2
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	150080e7          	jalr	336(ra) # 8000377a <log_write>
  brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	d60080e7          	jalr	-672(ra) # 80002394 <brelse>
}
    8000263c:	8526                	mv	a0,s1
    8000263e:	60e6                	ld	ra,88(sp)
    80002640:	6446                	ld	s0,80(sp)
    80002642:	64a6                	ld	s1,72(sp)
    80002644:	6906                	ld	s2,64(sp)
    80002646:	79e2                	ld	s3,56(sp)
    80002648:	7a42                	ld	s4,48(sp)
    8000264a:	7aa2                	ld	s5,40(sp)
    8000264c:	7b02                	ld	s6,32(sp)
    8000264e:	6be2                	ld	s7,24(sp)
    80002650:	6c42                	ld	s8,16(sp)
    80002652:	6ca2                	ld	s9,8(sp)
    80002654:	6125                	addi	sp,sp,96
    80002656:	8082                	ret

0000000080002658 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002658:	7139                	addi	sp,sp,-64
    8000265a:	fc06                	sd	ra,56(sp)
    8000265c:	f822                	sd	s0,48(sp)
    8000265e:	f426                	sd	s1,40(sp)
    80002660:	f04a                	sd	s2,32(sp)
    80002662:	ec4e                	sd	s3,24(sp)
    80002664:	e852                	sd	s4,16(sp)
    80002666:	e456                	sd	s5,8(sp)
    80002668:	0080                	addi	s0,sp,64
    8000266a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000266c:	47a9                	li	a5,10
    8000266e:	08b7fb63          	bgeu	a5,a1,80002704 <bmap+0xac>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002672:	ff55849b          	addiw	s1,a1,-11
    80002676:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000267a:	0ff00793          	li	a5,255
    8000267e:	0ae7f663          	bgeu	a5,a4,8000272a <bmap+0xd2>
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }
   bn -= NINDIRECT;
    80002682:	ef55859b          	addiw	a1,a1,-267
    80002686:	0005871b          	sext.w	a4,a1

  if(bn < NDINDIRECT){
    8000268a:	67c1                	lui	a5,0x10
    8000268c:	14f77c63          	bgeu	a4,a5,800027e4 <bmap+0x18c>
   int idx = bn / NINDIRECT;
    80002690:	0085da9b          	srliw	s5,a1,0x8
    int off = bn % NINDIRECT;
    80002694:	0ff5f493          	andi	s1,a1,255
    if((addr = ip->addrs[NDIRECT + 1]) == 0)
    80002698:	08052583          	lw	a1,128(a0)
    8000269c:	c9f5                	beqz	a1,80002790 <bmap+0x138>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000269e:	00092503          	lw	a0,0(s2)
    800026a2:	00000097          	auipc	ra,0x0
    800026a6:	bc2080e7          	jalr	-1086(ra) # 80002264 <bread>
    800026aa:	89aa                	mv	s3,a0
    a = (uint*)bp->data;
    800026ac:	05850a13          	addi	s4,a0,88
    // load second layer
    if((addr = a[idx]) == 0){
    800026b0:	0a8a                	slli	s5,s5,0x2
    800026b2:	9a56                	add	s4,s4,s5
    800026b4:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    800026b8:	0e0a8663          	beqz	s5,800027a4 <bmap+0x14c>
      a[idx] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026bc:	854e                	mv	a0,s3
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	cd6080e7          	jalr	-810(ra) # 80002394 <brelse>
// find the disk block
    bp = bread(ip->dev, addr);
    800026c6:	85d6                	mv	a1,s5
    800026c8:	00092503          	lw	a0,0(s2)
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	b98080e7          	jalr	-1128(ra) # 80002264 <bread>
    800026d4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026d6:	05850793          	addi	a5,a0,88
    if((addr = a[off]) == 0){
    800026da:	048a                	slli	s1,s1,0x2
    800026dc:	94be                	add	s1,s1,a5
    800026de:	0004a983          	lw	s3,0(s1)
    800026e2:	0e098163          	beqz	s3,800027c4 <bmap+0x16c>
      a[off] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026e6:	8552                	mv	a0,s4
    800026e8:	00000097          	auipc	ra,0x0
    800026ec:	cac080e7          	jalr	-852(ra) # 80002394 <brelse>
    return addr;
  } 
  panic("bmap: out of range");
}
    800026f0:	854e                	mv	a0,s3
    800026f2:	70e2                	ld	ra,56(sp)
    800026f4:	7442                	ld	s0,48(sp)
    800026f6:	74a2                	ld	s1,40(sp)
    800026f8:	7902                	ld	s2,32(sp)
    800026fa:	69e2                	ld	s3,24(sp)
    800026fc:	6a42                	ld	s4,16(sp)
    800026fe:	6aa2                	ld	s5,8(sp)
    80002700:	6121                	addi	sp,sp,64
    80002702:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002704:	02059493          	slli	s1,a1,0x20
    80002708:	9081                	srli	s1,s1,0x20
    8000270a:	048a                	slli	s1,s1,0x2
    8000270c:	94aa                	add	s1,s1,a0
    8000270e:	0504a983          	lw	s3,80(s1)
    80002712:	fc099fe3          	bnez	s3,800026f0 <bmap+0x98>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002716:	4108                	lw	a0,0(a0)
    80002718:	00000097          	auipc	ra,0x0
    8000271c:	e0e080e7          	jalr	-498(ra) # 80002526 <balloc>
    80002720:	0005099b          	sext.w	s3,a0
    80002724:	0534a823          	sw	s3,80(s1)
    80002728:	b7e1                	j	800026f0 <bmap+0x98>
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000272a:	5d6c                	lw	a1,124(a0)
    8000272c:	c985                	beqz	a1,8000275c <bmap+0x104>
    bp = bread(ip->dev, addr);
    8000272e:	00092503          	lw	a0,0(s2)
    80002732:	00000097          	auipc	ra,0x0
    80002736:	b32080e7          	jalr	-1230(ra) # 80002264 <bread>
    8000273a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000273c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002740:	1482                	slli	s1,s1,0x20
    80002742:	9081                	srli	s1,s1,0x20
    80002744:	048a                	slli	s1,s1,0x2
    80002746:	94be                	add	s1,s1,a5
    80002748:	0004a983          	lw	s3,0(s1)
    8000274c:	02098263          	beqz	s3,80002770 <bmap+0x118>
    brelse(bp);
    80002750:	8552                	mv	a0,s4
    80002752:	00000097          	auipc	ra,0x0
    80002756:	c42080e7          	jalr	-958(ra) # 80002394 <brelse>
    return addr;
    8000275a:	bf59                	j	800026f0 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000275c:	4108                	lw	a0,0(a0)
    8000275e:	00000097          	auipc	ra,0x0
    80002762:	dc8080e7          	jalr	-568(ra) # 80002526 <balloc>
    80002766:	0005059b          	sext.w	a1,a0
    8000276a:	06b92e23          	sw	a1,124(s2)
    8000276e:	b7c1                	j	8000272e <bmap+0xd6>
      a[bn] = addr = balloc(ip->dev);
    80002770:	00092503          	lw	a0,0(s2)
    80002774:	00000097          	auipc	ra,0x0
    80002778:	db2080e7          	jalr	-590(ra) # 80002526 <balloc>
    8000277c:	0005099b          	sext.w	s3,a0
    80002780:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002784:	8552                	mv	a0,s4
    80002786:	00001097          	auipc	ra,0x1
    8000278a:	ff4080e7          	jalr	-12(ra) # 8000377a <log_write>
    8000278e:	b7c9                	j	80002750 <bmap+0xf8>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    80002790:	4108                	lw	a0,0(a0)
    80002792:	00000097          	auipc	ra,0x0
    80002796:	d94080e7          	jalr	-620(ra) # 80002526 <balloc>
    8000279a:	0005059b          	sext.w	a1,a0
    8000279e:	08b92023          	sw	a1,128(s2)
    800027a2:	bdf5                	j	8000269e <bmap+0x46>
      a[idx] = addr = balloc(ip->dev);
    800027a4:	00092503          	lw	a0,0(s2)
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	d7e080e7          	jalr	-642(ra) # 80002526 <balloc>
    800027b0:	00050a9b          	sext.w	s5,a0
    800027b4:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    800027b8:	854e                	mv	a0,s3
    800027ba:	00001097          	auipc	ra,0x1
    800027be:	fc0080e7          	jalr	-64(ra) # 8000377a <log_write>
    800027c2:	bded                	j	800026bc <bmap+0x64>
      a[off] = addr = balloc(ip->dev);
    800027c4:	00092503          	lw	a0,0(s2)
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	d5e080e7          	jalr	-674(ra) # 80002526 <balloc>
    800027d0:	0005099b          	sext.w	s3,a0
    800027d4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027d8:	8552                	mv	a0,s4
    800027da:	00001097          	auipc	ra,0x1
    800027de:	fa0080e7          	jalr	-96(ra) # 8000377a <log_write>
    800027e2:	b711                	j	800026e6 <bmap+0x8e>
  panic("bmap: out of range");
    800027e4:	00006517          	auipc	a0,0x6
    800027e8:	d0450513          	addi	a0,a0,-764 # 800084e8 <syscalls+0x120>
    800027ec:	00003097          	auipc	ra,0x3
    800027f0:	5dc080e7          	jalr	1500(ra) # 80005dc8 <panic>

00000000800027f4 <iget>:
{
    800027f4:	7179                	addi	sp,sp,-48
    800027f6:	f406                	sd	ra,40(sp)
    800027f8:	f022                	sd	s0,32(sp)
    800027fa:	ec26                	sd	s1,24(sp)
    800027fc:	e84a                	sd	s2,16(sp)
    800027fe:	e44e                	sd	s3,8(sp)
    80002800:	e052                	sd	s4,0(sp)
    80002802:	1800                	addi	s0,sp,48
    80002804:	89aa                	mv	s3,a0
    80002806:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002808:	00010517          	auipc	a0,0x10
    8000280c:	18050513          	addi	a0,a0,384 # 80012988 <itable>
    80002810:	00004097          	auipc	ra,0x4
    80002814:	b02080e7          	jalr	-1278(ra) # 80006312 <acquire>
  empty = 0;
    80002818:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000281a:	00010497          	auipc	s1,0x10
    8000281e:	18648493          	addi	s1,s1,390 # 800129a0 <itable+0x18>
    80002822:	00012697          	auipc	a3,0x12
    80002826:	c0e68693          	addi	a3,a3,-1010 # 80014430 <log>
    8000282a:	a039                	j	80002838 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000282c:	02090b63          	beqz	s2,80002862 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002830:	08848493          	addi	s1,s1,136
    80002834:	02d48a63          	beq	s1,a3,80002868 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002838:	449c                	lw	a5,8(s1)
    8000283a:	fef059e3          	blez	a5,8000282c <iget+0x38>
    8000283e:	4098                	lw	a4,0(s1)
    80002840:	ff3716e3          	bne	a4,s3,8000282c <iget+0x38>
    80002844:	40d8                	lw	a4,4(s1)
    80002846:	ff4713e3          	bne	a4,s4,8000282c <iget+0x38>
      ip->ref++;
    8000284a:	2785                	addiw	a5,a5,1
    8000284c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000284e:	00010517          	auipc	a0,0x10
    80002852:	13a50513          	addi	a0,a0,314 # 80012988 <itable>
    80002856:	00004097          	auipc	ra,0x4
    8000285a:	b70080e7          	jalr	-1168(ra) # 800063c6 <release>
      return ip;
    8000285e:	8926                	mv	s2,s1
    80002860:	a03d                	j	8000288e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002862:	f7f9                	bnez	a5,80002830 <iget+0x3c>
    80002864:	8926                	mv	s2,s1
    80002866:	b7e9                	j	80002830 <iget+0x3c>
  if(empty == 0)
    80002868:	02090c63          	beqz	s2,800028a0 <iget+0xac>
  ip->dev = dev;
    8000286c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002870:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002874:	4785                	li	a5,1
    80002876:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000287a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000287e:	00010517          	auipc	a0,0x10
    80002882:	10a50513          	addi	a0,a0,266 # 80012988 <itable>
    80002886:	00004097          	auipc	ra,0x4
    8000288a:	b40080e7          	jalr	-1216(ra) # 800063c6 <release>
}
    8000288e:	854a                	mv	a0,s2
    80002890:	70a2                	ld	ra,40(sp)
    80002892:	7402                	ld	s0,32(sp)
    80002894:	64e2                	ld	s1,24(sp)
    80002896:	6942                	ld	s2,16(sp)
    80002898:	69a2                	ld	s3,8(sp)
    8000289a:	6a02                	ld	s4,0(sp)
    8000289c:	6145                	addi	sp,sp,48
    8000289e:	8082                	ret
    panic("iget: no inodes");
    800028a0:	00006517          	auipc	a0,0x6
    800028a4:	c6050513          	addi	a0,a0,-928 # 80008500 <syscalls+0x138>
    800028a8:	00003097          	auipc	ra,0x3
    800028ac:	520080e7          	jalr	1312(ra) # 80005dc8 <panic>

00000000800028b0 <fsinit>:
fsinit(int dev) {
    800028b0:	7179                	addi	sp,sp,-48
    800028b2:	f406                	sd	ra,40(sp)
    800028b4:	f022                	sd	s0,32(sp)
    800028b6:	ec26                	sd	s1,24(sp)
    800028b8:	e84a                	sd	s2,16(sp)
    800028ba:	e44e                	sd	s3,8(sp)
    800028bc:	1800                	addi	s0,sp,48
    800028be:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028c0:	4585                	li	a1,1
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	9a2080e7          	jalr	-1630(ra) # 80002264 <bread>
    800028ca:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028cc:	00010997          	auipc	s3,0x10
    800028d0:	09c98993          	addi	s3,s3,156 # 80012968 <sb>
    800028d4:	02000613          	li	a2,32
    800028d8:	05850593          	addi	a1,a0,88
    800028dc:	854e                	mv	a0,s3
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	8fa080e7          	jalr	-1798(ra) # 800001d8 <memmove>
  brelse(bp);
    800028e6:	8526                	mv	a0,s1
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	aac080e7          	jalr	-1364(ra) # 80002394 <brelse>
  if(sb.magic != FSMAGIC)
    800028f0:	0009a703          	lw	a4,0(s3)
    800028f4:	102037b7          	lui	a5,0x10203
    800028f8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028fc:	02f71263          	bne	a4,a5,80002920 <fsinit+0x70>
  initlog(dev, &sb);
    80002900:	00010597          	auipc	a1,0x10
    80002904:	06858593          	addi	a1,a1,104 # 80012968 <sb>
    80002908:	854a                	mv	a0,s2
    8000290a:	00001097          	auipc	ra,0x1
    8000290e:	bf4080e7          	jalr	-1036(ra) # 800034fe <initlog>
}
    80002912:	70a2                	ld	ra,40(sp)
    80002914:	7402                	ld	s0,32(sp)
    80002916:	64e2                	ld	s1,24(sp)
    80002918:	6942                	ld	s2,16(sp)
    8000291a:	69a2                	ld	s3,8(sp)
    8000291c:	6145                	addi	sp,sp,48
    8000291e:	8082                	ret
    panic("invalid file system");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	bf050513          	addi	a0,a0,-1040 # 80008510 <syscalls+0x148>
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	4a0080e7          	jalr	1184(ra) # 80005dc8 <panic>

0000000080002930 <iinit>:
{
    80002930:	7179                	addi	sp,sp,-48
    80002932:	f406                	sd	ra,40(sp)
    80002934:	f022                	sd	s0,32(sp)
    80002936:	ec26                	sd	s1,24(sp)
    80002938:	e84a                	sd	s2,16(sp)
    8000293a:	e44e                	sd	s3,8(sp)
    8000293c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000293e:	00006597          	auipc	a1,0x6
    80002942:	bea58593          	addi	a1,a1,-1046 # 80008528 <syscalls+0x160>
    80002946:	00010517          	auipc	a0,0x10
    8000294a:	04250513          	addi	a0,a0,66 # 80012988 <itable>
    8000294e:	00004097          	auipc	ra,0x4
    80002952:	934080e7          	jalr	-1740(ra) # 80006282 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002956:	00010497          	auipc	s1,0x10
    8000295a:	05a48493          	addi	s1,s1,90 # 800129b0 <itable+0x28>
    8000295e:	00012997          	auipc	s3,0x12
    80002962:	ae298993          	addi	s3,s3,-1310 # 80014440 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002966:	00006917          	auipc	s2,0x6
    8000296a:	bca90913          	addi	s2,s2,-1078 # 80008530 <syscalls+0x168>
    8000296e:	85ca                	mv	a1,s2
    80002970:	8526                	mv	a0,s1
    80002972:	00001097          	auipc	ra,0x1
    80002976:	eee080e7          	jalr	-274(ra) # 80003860 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000297a:	08848493          	addi	s1,s1,136
    8000297e:	ff3498e3          	bne	s1,s3,8000296e <iinit+0x3e>
}
    80002982:	70a2                	ld	ra,40(sp)
    80002984:	7402                	ld	s0,32(sp)
    80002986:	64e2                	ld	s1,24(sp)
    80002988:	6942                	ld	s2,16(sp)
    8000298a:	69a2                	ld	s3,8(sp)
    8000298c:	6145                	addi	sp,sp,48
    8000298e:	8082                	ret

0000000080002990 <ialloc>:
{
    80002990:	715d                	addi	sp,sp,-80
    80002992:	e486                	sd	ra,72(sp)
    80002994:	e0a2                	sd	s0,64(sp)
    80002996:	fc26                	sd	s1,56(sp)
    80002998:	f84a                	sd	s2,48(sp)
    8000299a:	f44e                	sd	s3,40(sp)
    8000299c:	f052                	sd	s4,32(sp)
    8000299e:	ec56                	sd	s5,24(sp)
    800029a0:	e85a                	sd	s6,16(sp)
    800029a2:	e45e                	sd	s7,8(sp)
    800029a4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a6:	00010717          	auipc	a4,0x10
    800029aa:	fce72703          	lw	a4,-50(a4) # 80012974 <sb+0xc>
    800029ae:	4785                	li	a5,1
    800029b0:	04e7fa63          	bgeu	a5,a4,80002a04 <ialloc+0x74>
    800029b4:	8aaa                	mv	s5,a0
    800029b6:	8bae                	mv	s7,a1
    800029b8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029ba:	00010a17          	auipc	s4,0x10
    800029be:	faea0a13          	addi	s4,s4,-82 # 80012968 <sb>
    800029c2:	00048b1b          	sext.w	s6,s1
    800029c6:	0044d593          	srli	a1,s1,0x4
    800029ca:	018a2783          	lw	a5,24(s4)
    800029ce:	9dbd                	addw	a1,a1,a5
    800029d0:	8556                	mv	a0,s5
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	892080e7          	jalr	-1902(ra) # 80002264 <bread>
    800029da:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029dc:	05850993          	addi	s3,a0,88
    800029e0:	00f4f793          	andi	a5,s1,15
    800029e4:	079a                	slli	a5,a5,0x6
    800029e6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029e8:	00099783          	lh	a5,0(s3)
    800029ec:	c785                	beqz	a5,80002a14 <ialloc+0x84>
    brelse(bp);
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	9a6080e7          	jalr	-1626(ra) # 80002394 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029f6:	0485                	addi	s1,s1,1
    800029f8:	00ca2703          	lw	a4,12(s4)
    800029fc:	0004879b          	sext.w	a5,s1
    80002a00:	fce7e1e3          	bltu	a5,a4,800029c2 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a04:	00006517          	auipc	a0,0x6
    80002a08:	b3450513          	addi	a0,a0,-1228 # 80008538 <syscalls+0x170>
    80002a0c:	00003097          	auipc	ra,0x3
    80002a10:	3bc080e7          	jalr	956(ra) # 80005dc8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a14:	04000613          	li	a2,64
    80002a18:	4581                	li	a1,0
    80002a1a:	854e                	mv	a0,s3
    80002a1c:	ffffd097          	auipc	ra,0xffffd
    80002a20:	75c080e7          	jalr	1884(ra) # 80000178 <memset>
      dip->type = type;
    80002a24:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a28:	854a                	mv	a0,s2
    80002a2a:	00001097          	auipc	ra,0x1
    80002a2e:	d50080e7          	jalr	-688(ra) # 8000377a <log_write>
      brelse(bp);
    80002a32:	854a                	mv	a0,s2
    80002a34:	00000097          	auipc	ra,0x0
    80002a38:	960080e7          	jalr	-1696(ra) # 80002394 <brelse>
      return iget(dev, inum);
    80002a3c:	85da                	mv	a1,s6
    80002a3e:	8556                	mv	a0,s5
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	db4080e7          	jalr	-588(ra) # 800027f4 <iget>
}
    80002a48:	60a6                	ld	ra,72(sp)
    80002a4a:	6406                	ld	s0,64(sp)
    80002a4c:	74e2                	ld	s1,56(sp)
    80002a4e:	7942                	ld	s2,48(sp)
    80002a50:	79a2                	ld	s3,40(sp)
    80002a52:	7a02                	ld	s4,32(sp)
    80002a54:	6ae2                	ld	s5,24(sp)
    80002a56:	6b42                	ld	s6,16(sp)
    80002a58:	6ba2                	ld	s7,8(sp)
    80002a5a:	6161                	addi	sp,sp,80
    80002a5c:	8082                	ret

0000000080002a5e <iupdate>:
{
    80002a5e:	1101                	addi	sp,sp,-32
    80002a60:	ec06                	sd	ra,24(sp)
    80002a62:	e822                	sd	s0,16(sp)
    80002a64:	e426                	sd	s1,8(sp)
    80002a66:	e04a                	sd	s2,0(sp)
    80002a68:	1000                	addi	s0,sp,32
    80002a6a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a6c:	415c                	lw	a5,4(a0)
    80002a6e:	0047d79b          	srliw	a5,a5,0x4
    80002a72:	00010597          	auipc	a1,0x10
    80002a76:	f0e5a583          	lw	a1,-242(a1) # 80012980 <sb+0x18>
    80002a7a:	9dbd                	addw	a1,a1,a5
    80002a7c:	4108                	lw	a0,0(a0)
    80002a7e:	fffff097          	auipc	ra,0xfffff
    80002a82:	7e6080e7          	jalr	2022(ra) # 80002264 <bread>
    80002a86:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a88:	05850793          	addi	a5,a0,88
    80002a8c:	40c8                	lw	a0,4(s1)
    80002a8e:	893d                	andi	a0,a0,15
    80002a90:	051a                	slli	a0,a0,0x6
    80002a92:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a94:	04449703          	lh	a4,68(s1)
    80002a98:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a9c:	04649703          	lh	a4,70(s1)
    80002aa0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002aa4:	04849703          	lh	a4,72(s1)
    80002aa8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002aac:	04a49703          	lh	a4,74(s1)
    80002ab0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ab4:	44f8                	lw	a4,76(s1)
    80002ab6:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ab8:	03400613          	li	a2,52
    80002abc:	05048593          	addi	a1,s1,80
    80002ac0:	0531                	addi	a0,a0,12
    80002ac2:	ffffd097          	auipc	ra,0xffffd
    80002ac6:	716080e7          	jalr	1814(ra) # 800001d8 <memmove>
  log_write(bp);
    80002aca:	854a                	mv	a0,s2
    80002acc:	00001097          	auipc	ra,0x1
    80002ad0:	cae080e7          	jalr	-850(ra) # 8000377a <log_write>
  brelse(bp);
    80002ad4:	854a                	mv	a0,s2
    80002ad6:	00000097          	auipc	ra,0x0
    80002ada:	8be080e7          	jalr	-1858(ra) # 80002394 <brelse>
}
    80002ade:	60e2                	ld	ra,24(sp)
    80002ae0:	6442                	ld	s0,16(sp)
    80002ae2:	64a2                	ld	s1,8(sp)
    80002ae4:	6902                	ld	s2,0(sp)
    80002ae6:	6105                	addi	sp,sp,32
    80002ae8:	8082                	ret

0000000080002aea <idup>:
{
    80002aea:	1101                	addi	sp,sp,-32
    80002aec:	ec06                	sd	ra,24(sp)
    80002aee:	e822                	sd	s0,16(sp)
    80002af0:	e426                	sd	s1,8(sp)
    80002af2:	1000                	addi	s0,sp,32
    80002af4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002af6:	00010517          	auipc	a0,0x10
    80002afa:	e9250513          	addi	a0,a0,-366 # 80012988 <itable>
    80002afe:	00004097          	auipc	ra,0x4
    80002b02:	814080e7          	jalr	-2028(ra) # 80006312 <acquire>
  ip->ref++;
    80002b06:	449c                	lw	a5,8(s1)
    80002b08:	2785                	addiw	a5,a5,1
    80002b0a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b0c:	00010517          	auipc	a0,0x10
    80002b10:	e7c50513          	addi	a0,a0,-388 # 80012988 <itable>
    80002b14:	00004097          	auipc	ra,0x4
    80002b18:	8b2080e7          	jalr	-1870(ra) # 800063c6 <release>
}
    80002b1c:	8526                	mv	a0,s1
    80002b1e:	60e2                	ld	ra,24(sp)
    80002b20:	6442                	ld	s0,16(sp)
    80002b22:	64a2                	ld	s1,8(sp)
    80002b24:	6105                	addi	sp,sp,32
    80002b26:	8082                	ret

0000000080002b28 <ilock>:
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	e04a                	sd	s2,0(sp)
    80002b32:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b34:	c115                	beqz	a0,80002b58 <ilock+0x30>
    80002b36:	84aa                	mv	s1,a0
    80002b38:	451c                	lw	a5,8(a0)
    80002b3a:	00f05f63          	blez	a5,80002b58 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b3e:	0541                	addi	a0,a0,16
    80002b40:	00001097          	auipc	ra,0x1
    80002b44:	d5a080e7          	jalr	-678(ra) # 8000389a <acquiresleep>
  if(ip->valid == 0){
    80002b48:	40bc                	lw	a5,64(s1)
    80002b4a:	cf99                	beqz	a5,80002b68 <ilock+0x40>
}
    80002b4c:	60e2                	ld	ra,24(sp)
    80002b4e:	6442                	ld	s0,16(sp)
    80002b50:	64a2                	ld	s1,8(sp)
    80002b52:	6902                	ld	s2,0(sp)
    80002b54:	6105                	addi	sp,sp,32
    80002b56:	8082                	ret
    panic("ilock");
    80002b58:	00006517          	auipc	a0,0x6
    80002b5c:	9f850513          	addi	a0,a0,-1544 # 80008550 <syscalls+0x188>
    80002b60:	00003097          	auipc	ra,0x3
    80002b64:	268080e7          	jalr	616(ra) # 80005dc8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b68:	40dc                	lw	a5,4(s1)
    80002b6a:	0047d79b          	srliw	a5,a5,0x4
    80002b6e:	00010597          	auipc	a1,0x10
    80002b72:	e125a583          	lw	a1,-494(a1) # 80012980 <sb+0x18>
    80002b76:	9dbd                	addw	a1,a1,a5
    80002b78:	4088                	lw	a0,0(s1)
    80002b7a:	fffff097          	auipc	ra,0xfffff
    80002b7e:	6ea080e7          	jalr	1770(ra) # 80002264 <bread>
    80002b82:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b84:	05850593          	addi	a1,a0,88
    80002b88:	40dc                	lw	a5,4(s1)
    80002b8a:	8bbd                	andi	a5,a5,15
    80002b8c:	079a                	slli	a5,a5,0x6
    80002b8e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b90:	00059783          	lh	a5,0(a1)
    80002b94:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b98:	00259783          	lh	a5,2(a1)
    80002b9c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ba0:	00459783          	lh	a5,4(a1)
    80002ba4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ba8:	00659783          	lh	a5,6(a1)
    80002bac:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bb0:	459c                	lw	a5,8(a1)
    80002bb2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bb4:	03400613          	li	a2,52
    80002bb8:	05b1                	addi	a1,a1,12
    80002bba:	05048513          	addi	a0,s1,80
    80002bbe:	ffffd097          	auipc	ra,0xffffd
    80002bc2:	61a080e7          	jalr	1562(ra) # 800001d8 <memmove>
    brelse(bp);
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	fffff097          	auipc	ra,0xfffff
    80002bcc:	7cc080e7          	jalr	1996(ra) # 80002394 <brelse>
    ip->valid = 1;
    80002bd0:	4785                	li	a5,1
    80002bd2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bd4:	04449783          	lh	a5,68(s1)
    80002bd8:	fbb5                	bnez	a5,80002b4c <ilock+0x24>
      panic("ilock: no type");
    80002bda:	00006517          	auipc	a0,0x6
    80002bde:	97e50513          	addi	a0,a0,-1666 # 80008558 <syscalls+0x190>
    80002be2:	00003097          	auipc	ra,0x3
    80002be6:	1e6080e7          	jalr	486(ra) # 80005dc8 <panic>

0000000080002bea <iunlock>:
{
    80002bea:	1101                	addi	sp,sp,-32
    80002bec:	ec06                	sd	ra,24(sp)
    80002bee:	e822                	sd	s0,16(sp)
    80002bf0:	e426                	sd	s1,8(sp)
    80002bf2:	e04a                	sd	s2,0(sp)
    80002bf4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bf6:	c905                	beqz	a0,80002c26 <iunlock+0x3c>
    80002bf8:	84aa                	mv	s1,a0
    80002bfa:	01050913          	addi	s2,a0,16
    80002bfe:	854a                	mv	a0,s2
    80002c00:	00001097          	auipc	ra,0x1
    80002c04:	d34080e7          	jalr	-716(ra) # 80003934 <holdingsleep>
    80002c08:	cd19                	beqz	a0,80002c26 <iunlock+0x3c>
    80002c0a:	449c                	lw	a5,8(s1)
    80002c0c:	00f05d63          	blez	a5,80002c26 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c10:	854a                	mv	a0,s2
    80002c12:	00001097          	auipc	ra,0x1
    80002c16:	cde080e7          	jalr	-802(ra) # 800038f0 <releasesleep>
}
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6902                	ld	s2,0(sp)
    80002c22:	6105                	addi	sp,sp,32
    80002c24:	8082                	ret
    panic("iunlock");
    80002c26:	00006517          	auipc	a0,0x6
    80002c2a:	94250513          	addi	a0,a0,-1726 # 80008568 <syscalls+0x1a0>
    80002c2e:	00003097          	auipc	ra,0x3
    80002c32:	19a080e7          	jalr	410(ra) # 80005dc8 <panic>

0000000080002c36 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c36:	715d                	addi	sp,sp,-80
    80002c38:	e486                	sd	ra,72(sp)
    80002c3a:	e0a2                	sd	s0,64(sp)
    80002c3c:	fc26                	sd	s1,56(sp)
    80002c3e:	f84a                	sd	s2,48(sp)
    80002c40:	f44e                	sd	s3,40(sp)
    80002c42:	f052                	sd	s4,32(sp)
    80002c44:	ec56                	sd	s5,24(sp)
    80002c46:	e85a                	sd	s6,16(sp)
    80002c48:	e45e                	sd	s7,8(sp)
    80002c4a:	e062                	sd	s8,0(sp)
    80002c4c:	0880                	addi	s0,sp,80
    80002c4e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c50:	05050493          	addi	s1,a0,80
    80002c54:	07c50913          	addi	s2,a0,124
    80002c58:	a021                	j	80002c60 <itrunc+0x2a>
    80002c5a:	0491                	addi	s1,s1,4
    80002c5c:	01248d63          	beq	s1,s2,80002c76 <itrunc+0x40>
    if(ip->addrs[i]){
    80002c60:	408c                	lw	a1,0(s1)
    80002c62:	dde5                	beqz	a1,80002c5a <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    80002c64:	0009a503          	lw	a0,0(s3)
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	842080e7          	jalr	-1982(ra) # 800024aa <bfree>
      ip->addrs[i] = 0;
    80002c70:	0004a023          	sw	zero,0(s1)
    80002c74:	b7dd                	j	80002c5a <itrunc+0x24>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c76:	07c9a583          	lw	a1,124(s3)
    80002c7a:	e59d                	bnez	a1,80002ca8 <itrunc+0x72>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  
  if(ip->addrs[NDIRECT + 1]){
    80002c7c:	0809a583          	lw	a1,128(s3)
    80002c80:	eda5                	bnez	a1,80002cf8 <itrunc+0xc2>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    ip->addrs[NDIRECT + 1] = 0;
  }

  ip->size = 0;
    80002c82:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c86:	854e                	mv	a0,s3
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	dd6080e7          	jalr	-554(ra) # 80002a5e <iupdate>
}
    80002c90:	60a6                	ld	ra,72(sp)
    80002c92:	6406                	ld	s0,64(sp)
    80002c94:	74e2                	ld	s1,56(sp)
    80002c96:	7942                	ld	s2,48(sp)
    80002c98:	79a2                	ld	s3,40(sp)
    80002c9a:	7a02                	ld	s4,32(sp)
    80002c9c:	6ae2                	ld	s5,24(sp)
    80002c9e:	6b42                	ld	s6,16(sp)
    80002ca0:	6ba2                	ld	s7,8(sp)
    80002ca2:	6c02                	ld	s8,0(sp)
    80002ca4:	6161                	addi	sp,sp,80
    80002ca6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca8:	0009a503          	lw	a0,0(s3)
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	5b8080e7          	jalr	1464(ra) # 80002264 <bread>
    80002cb4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb6:	05850493          	addi	s1,a0,88
    80002cba:	45850913          	addi	s2,a0,1112
    80002cbe:	a021                	j	80002cc6 <itrunc+0x90>
    80002cc0:	0491                	addi	s1,s1,4
    80002cc2:	01248b63          	beq	s1,s2,80002cd8 <itrunc+0xa2>
      if(a[j])
    80002cc6:	408c                	lw	a1,0(s1)
    80002cc8:	dde5                	beqz	a1,80002cc0 <itrunc+0x8a>
        bfree(ip->dev, a[j]);
    80002cca:	0009a503          	lw	a0,0(s3)
    80002cce:	fffff097          	auipc	ra,0xfffff
    80002cd2:	7dc080e7          	jalr	2012(ra) # 800024aa <bfree>
    80002cd6:	b7ed                	j	80002cc0 <itrunc+0x8a>
    brelse(bp);
    80002cd8:	8552                	mv	a0,s4
    80002cda:	fffff097          	auipc	ra,0xfffff
    80002cde:	6ba080e7          	jalr	1722(ra) # 80002394 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ce2:	07c9a583          	lw	a1,124(s3)
    80002ce6:	0009a503          	lw	a0,0(s3)
    80002cea:	fffff097          	auipc	ra,0xfffff
    80002cee:	7c0080e7          	jalr	1984(ra) # 800024aa <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cf2:	0609ae23          	sw	zero,124(s3)
    80002cf6:	b759                	j	80002c7c <itrunc+0x46>
    bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    80002cf8:	0009a503          	lw	a0,0(s3)
    80002cfc:	fffff097          	auipc	ra,0xfffff
    80002d00:	568080e7          	jalr	1384(ra) # 80002264 <bread>
    80002d04:	8c2a                	mv	s8,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d06:	05850a13          	addi	s4,a0,88
    80002d0a:	45850b13          	addi	s6,a0,1112
    80002d0e:	a82d                	j	80002d48 <itrunc+0x112>
            bfree(ip->dev, b[k]);
    80002d10:	0009a503          	lw	a0,0(s3)
    80002d14:	fffff097          	auipc	ra,0xfffff
    80002d18:	796080e7          	jalr	1942(ra) # 800024aa <bfree>
        for(int k = 0; k < NINDIRECT; k++){
    80002d1c:	0491                	addi	s1,s1,4
    80002d1e:	00990563          	beq	s2,s1,80002d28 <itrunc+0xf2>
          if(b[k])
    80002d22:	408c                	lw	a1,0(s1)
    80002d24:	dde5                	beqz	a1,80002d1c <itrunc+0xe6>
    80002d26:	b7ed                	j	80002d10 <itrunc+0xda>
        brelse(bpd);
    80002d28:	855e                	mv	a0,s7
    80002d2a:	fffff097          	auipc	ra,0xfffff
    80002d2e:	66a080e7          	jalr	1642(ra) # 80002394 <brelse>
        bfree(ip->dev, a[j]);
    80002d32:	000aa583          	lw	a1,0(s5)
    80002d36:	0009a503          	lw	a0,0(s3)
    80002d3a:	fffff097          	auipc	ra,0xfffff
    80002d3e:	770080e7          	jalr	1904(ra) # 800024aa <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d42:	0a11                	addi	s4,s4,4
    80002d44:	034b0263          	beq	s6,s4,80002d68 <itrunc+0x132>
      if(a[j]){
    80002d48:	8ad2                	mv	s5,s4
    80002d4a:	000a2583          	lw	a1,0(s4)
    80002d4e:	d9f5                	beqz	a1,80002d42 <itrunc+0x10c>
        bpd = bread(ip->dev, a[j]);
    80002d50:	0009a503          	lw	a0,0(s3)
    80002d54:	fffff097          	auipc	ra,0xfffff
    80002d58:	510080e7          	jalr	1296(ra) # 80002264 <bread>
    80002d5c:	8baa                	mv	s7,a0
        for(int k = 0; k < NINDIRECT; k++){
    80002d5e:	05850493          	addi	s1,a0,88
    80002d62:	45850913          	addi	s2,a0,1112
    80002d66:	bf75                	j	80002d22 <itrunc+0xec>
    brelse(bp);
    80002d68:	8562                	mv	a0,s8
    80002d6a:	fffff097          	auipc	ra,0xfffff
    80002d6e:	62a080e7          	jalr	1578(ra) # 80002394 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d72:	0809a583          	lw	a1,128(s3)
    80002d76:	0009a503          	lw	a0,0(s3)
    80002d7a:	fffff097          	auipc	ra,0xfffff
    80002d7e:	730080e7          	jalr	1840(ra) # 800024aa <bfree>
    ip->addrs[NDIRECT + 1] = 0;
    80002d82:	0809a023          	sw	zero,128(s3)
    80002d86:	bdf5                	j	80002c82 <itrunc+0x4c>

0000000080002d88 <iput>:
{
    80002d88:	1101                	addi	sp,sp,-32
    80002d8a:	ec06                	sd	ra,24(sp)
    80002d8c:	e822                	sd	s0,16(sp)
    80002d8e:	e426                	sd	s1,8(sp)
    80002d90:	e04a                	sd	s2,0(sp)
    80002d92:	1000                	addi	s0,sp,32
    80002d94:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d96:	00010517          	auipc	a0,0x10
    80002d9a:	bf250513          	addi	a0,a0,-1038 # 80012988 <itable>
    80002d9e:	00003097          	auipc	ra,0x3
    80002da2:	574080e7          	jalr	1396(ra) # 80006312 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da6:	4498                	lw	a4,8(s1)
    80002da8:	4785                	li	a5,1
    80002daa:	02f70363          	beq	a4,a5,80002dd0 <iput+0x48>
  ip->ref--;
    80002dae:	449c                	lw	a5,8(s1)
    80002db0:	37fd                	addiw	a5,a5,-1
    80002db2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002db4:	00010517          	auipc	a0,0x10
    80002db8:	bd450513          	addi	a0,a0,-1068 # 80012988 <itable>
    80002dbc:	00003097          	auipc	ra,0x3
    80002dc0:	60a080e7          	jalr	1546(ra) # 800063c6 <release>
}
    80002dc4:	60e2                	ld	ra,24(sp)
    80002dc6:	6442                	ld	s0,16(sp)
    80002dc8:	64a2                	ld	s1,8(sp)
    80002dca:	6902                	ld	s2,0(sp)
    80002dcc:	6105                	addi	sp,sp,32
    80002dce:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd0:	40bc                	lw	a5,64(s1)
    80002dd2:	dff1                	beqz	a5,80002dae <iput+0x26>
    80002dd4:	04a49783          	lh	a5,74(s1)
    80002dd8:	fbf9                	bnez	a5,80002dae <iput+0x26>
    acquiresleep(&ip->lock);
    80002dda:	01048913          	addi	s2,s1,16
    80002dde:	854a                	mv	a0,s2
    80002de0:	00001097          	auipc	ra,0x1
    80002de4:	aba080e7          	jalr	-1350(ra) # 8000389a <acquiresleep>
    release(&itable.lock);
    80002de8:	00010517          	auipc	a0,0x10
    80002dec:	ba050513          	addi	a0,a0,-1120 # 80012988 <itable>
    80002df0:	00003097          	auipc	ra,0x3
    80002df4:	5d6080e7          	jalr	1494(ra) # 800063c6 <release>
    itrunc(ip);
    80002df8:	8526                	mv	a0,s1
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	e3c080e7          	jalr	-452(ra) # 80002c36 <itrunc>
    ip->type = 0;
    80002e02:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e06:	8526                	mv	a0,s1
    80002e08:	00000097          	auipc	ra,0x0
    80002e0c:	c56080e7          	jalr	-938(ra) # 80002a5e <iupdate>
    ip->valid = 0;
    80002e10:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e14:	854a                	mv	a0,s2
    80002e16:	00001097          	auipc	ra,0x1
    80002e1a:	ada080e7          	jalr	-1318(ra) # 800038f0 <releasesleep>
    acquire(&itable.lock);
    80002e1e:	00010517          	auipc	a0,0x10
    80002e22:	b6a50513          	addi	a0,a0,-1174 # 80012988 <itable>
    80002e26:	00003097          	auipc	ra,0x3
    80002e2a:	4ec080e7          	jalr	1260(ra) # 80006312 <acquire>
    80002e2e:	b741                	j	80002dae <iput+0x26>

0000000080002e30 <iunlockput>:
{
    80002e30:	1101                	addi	sp,sp,-32
    80002e32:	ec06                	sd	ra,24(sp)
    80002e34:	e822                	sd	s0,16(sp)
    80002e36:	e426                	sd	s1,8(sp)
    80002e38:	1000                	addi	s0,sp,32
    80002e3a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	dae080e7          	jalr	-594(ra) # 80002bea <iunlock>
  iput(ip);
    80002e44:	8526                	mv	a0,s1
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	f42080e7          	jalr	-190(ra) # 80002d88 <iput>
}
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	64a2                	ld	s1,8(sp)
    80002e54:	6105                	addi	sp,sp,32
    80002e56:	8082                	ret

0000000080002e58 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e58:	1141                	addi	sp,sp,-16
    80002e5a:	e422                	sd	s0,8(sp)
    80002e5c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e5e:	411c                	lw	a5,0(a0)
    80002e60:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e62:	415c                	lw	a5,4(a0)
    80002e64:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e66:	04451783          	lh	a5,68(a0)
    80002e6a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e6e:	04a51783          	lh	a5,74(a0)
    80002e72:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e76:	04c56783          	lwu	a5,76(a0)
    80002e7a:	e99c                	sd	a5,16(a1)
}
    80002e7c:	6422                	ld	s0,8(sp)
    80002e7e:	0141                	addi	sp,sp,16
    80002e80:	8082                	ret

0000000080002e82 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e82:	457c                	lw	a5,76(a0)
    80002e84:	0ed7e963          	bltu	a5,a3,80002f76 <readi+0xf4>
{
    80002e88:	7159                	addi	sp,sp,-112
    80002e8a:	f486                	sd	ra,104(sp)
    80002e8c:	f0a2                	sd	s0,96(sp)
    80002e8e:	eca6                	sd	s1,88(sp)
    80002e90:	e8ca                	sd	s2,80(sp)
    80002e92:	e4ce                	sd	s3,72(sp)
    80002e94:	e0d2                	sd	s4,64(sp)
    80002e96:	fc56                	sd	s5,56(sp)
    80002e98:	f85a                	sd	s6,48(sp)
    80002e9a:	f45e                	sd	s7,40(sp)
    80002e9c:	f062                	sd	s8,32(sp)
    80002e9e:	ec66                	sd	s9,24(sp)
    80002ea0:	e86a                	sd	s10,16(sp)
    80002ea2:	e46e                	sd	s11,8(sp)
    80002ea4:	1880                	addi	s0,sp,112
    80002ea6:	8baa                	mv	s7,a0
    80002ea8:	8c2e                	mv	s8,a1
    80002eaa:	8ab2                	mv	s5,a2
    80002eac:	84b6                	mv	s1,a3
    80002eae:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eb0:	9f35                	addw	a4,a4,a3
    return 0;
    80002eb2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eb4:	0ad76063          	bltu	a4,a3,80002f54 <readi+0xd2>
  if(off + n > ip->size)
    80002eb8:	00e7f463          	bgeu	a5,a4,80002ec0 <readi+0x3e>
    n = ip->size - off;
    80002ebc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec0:	0a0b0963          	beqz	s6,80002f72 <readi+0xf0>
    80002ec4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eca:	5cfd                	li	s9,-1
    80002ecc:	a82d                	j	80002f06 <readi+0x84>
    80002ece:	020a1d93          	slli	s11,s4,0x20
    80002ed2:	020ddd93          	srli	s11,s11,0x20
    80002ed6:	05890613          	addi	a2,s2,88
    80002eda:	86ee                	mv	a3,s11
    80002edc:	963a                	add	a2,a2,a4
    80002ede:	85d6                	mv	a1,s5
    80002ee0:	8562                	mv	a0,s8
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	9c6080e7          	jalr	-1594(ra) # 800018a8 <either_copyout>
    80002eea:	05950d63          	beq	a0,s9,80002f44 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eee:	854a                	mv	a0,s2
    80002ef0:	fffff097          	auipc	ra,0xfffff
    80002ef4:	4a4080e7          	jalr	1188(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef8:	013a09bb          	addw	s3,s4,s3
    80002efc:	009a04bb          	addw	s1,s4,s1
    80002f00:	9aee                	add	s5,s5,s11
    80002f02:	0569f763          	bgeu	s3,s6,80002f50 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f06:	000ba903          	lw	s2,0(s7)
    80002f0a:	00a4d59b          	srliw	a1,s1,0xa
    80002f0e:	855e                	mv	a0,s7
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	748080e7          	jalr	1864(ra) # 80002658 <bmap>
    80002f18:	0005059b          	sext.w	a1,a0
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	fffff097          	auipc	ra,0xfffff
    80002f22:	346080e7          	jalr	838(ra) # 80002264 <bread>
    80002f26:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f28:	3ff4f713          	andi	a4,s1,1023
    80002f2c:	40ed07bb          	subw	a5,s10,a4
    80002f30:	413b06bb          	subw	a3,s6,s3
    80002f34:	8a3e                	mv	s4,a5
    80002f36:	2781                	sext.w	a5,a5
    80002f38:	0006861b          	sext.w	a2,a3
    80002f3c:	f8f679e3          	bgeu	a2,a5,80002ece <readi+0x4c>
    80002f40:	8a36                	mv	s4,a3
    80002f42:	b771                	j	80002ece <readi+0x4c>
      brelse(bp);
    80002f44:	854a                	mv	a0,s2
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	44e080e7          	jalr	1102(ra) # 80002394 <brelse>
      tot = -1;
    80002f4e:	59fd                	li	s3,-1
  }
  return tot;
    80002f50:	0009851b          	sext.w	a0,s3
}
    80002f54:	70a6                	ld	ra,104(sp)
    80002f56:	7406                	ld	s0,96(sp)
    80002f58:	64e6                	ld	s1,88(sp)
    80002f5a:	6946                	ld	s2,80(sp)
    80002f5c:	69a6                	ld	s3,72(sp)
    80002f5e:	6a06                	ld	s4,64(sp)
    80002f60:	7ae2                	ld	s5,56(sp)
    80002f62:	7b42                	ld	s6,48(sp)
    80002f64:	7ba2                	ld	s7,40(sp)
    80002f66:	7c02                	ld	s8,32(sp)
    80002f68:	6ce2                	ld	s9,24(sp)
    80002f6a:	6d42                	ld	s10,16(sp)
    80002f6c:	6da2                	ld	s11,8(sp)
    80002f6e:	6165                	addi	sp,sp,112
    80002f70:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f72:	89da                	mv	s3,s6
    80002f74:	bff1                	j	80002f50 <readi+0xce>
    return 0;
    80002f76:	4501                	li	a0,0
}
    80002f78:	8082                	ret

0000000080002f7a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f7a:	457c                	lw	a5,76(a0)
    80002f7c:	10d7e963          	bltu	a5,a3,8000308e <writei+0x114>
{
    80002f80:	7159                	addi	sp,sp,-112
    80002f82:	f486                	sd	ra,104(sp)
    80002f84:	f0a2                	sd	s0,96(sp)
    80002f86:	eca6                	sd	s1,88(sp)
    80002f88:	e8ca                	sd	s2,80(sp)
    80002f8a:	e4ce                	sd	s3,72(sp)
    80002f8c:	e0d2                	sd	s4,64(sp)
    80002f8e:	fc56                	sd	s5,56(sp)
    80002f90:	f85a                	sd	s6,48(sp)
    80002f92:	f45e                	sd	s7,40(sp)
    80002f94:	f062                	sd	s8,32(sp)
    80002f96:	ec66                	sd	s9,24(sp)
    80002f98:	e86a                	sd	s10,16(sp)
    80002f9a:	e46e                	sd	s11,8(sp)
    80002f9c:	1880                	addi	s0,sp,112
    80002f9e:	8b2a                	mv	s6,a0
    80002fa0:	8c2e                	mv	s8,a1
    80002fa2:	8ab2                	mv	s5,a2
    80002fa4:	8936                	mv	s2,a3
    80002fa6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fa8:	9f35                	addw	a4,a4,a3
    80002faa:	0ed76463          	bltu	a4,a3,80003092 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fae:	040437b7          	lui	a5,0x4043
    80002fb2:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002fb6:	0ee7e063          	bltu	a5,a4,80003096 <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fba:	0c0b8863          	beqz	s7,8000308a <writei+0x110>
    80002fbe:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc0:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fc4:	5cfd                	li	s9,-1
    80002fc6:	a091                	j	8000300a <writei+0x90>
    80002fc8:	02099d93          	slli	s11,s3,0x20
    80002fcc:	020ddd93          	srli	s11,s11,0x20
    80002fd0:	05848513          	addi	a0,s1,88
    80002fd4:	86ee                	mv	a3,s11
    80002fd6:	8656                	mv	a2,s5
    80002fd8:	85e2                	mv	a1,s8
    80002fda:	953a                	add	a0,a0,a4
    80002fdc:	fffff097          	auipc	ra,0xfffff
    80002fe0:	922080e7          	jalr	-1758(ra) # 800018fe <either_copyin>
    80002fe4:	07950263          	beq	a0,s9,80003048 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fe8:	8526                	mv	a0,s1
    80002fea:	00000097          	auipc	ra,0x0
    80002fee:	790080e7          	jalr	1936(ra) # 8000377a <log_write>
    brelse(bp);
    80002ff2:	8526                	mv	a0,s1
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	3a0080e7          	jalr	928(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ffc:	01498a3b          	addw	s4,s3,s4
    80003000:	0129893b          	addw	s2,s3,s2
    80003004:	9aee                	add	s5,s5,s11
    80003006:	057a7663          	bgeu	s4,s7,80003052 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000300a:	000b2483          	lw	s1,0(s6)
    8000300e:	00a9559b          	srliw	a1,s2,0xa
    80003012:	855a                	mv	a0,s6
    80003014:	fffff097          	auipc	ra,0xfffff
    80003018:	644080e7          	jalr	1604(ra) # 80002658 <bmap>
    8000301c:	0005059b          	sext.w	a1,a0
    80003020:	8526                	mv	a0,s1
    80003022:	fffff097          	auipc	ra,0xfffff
    80003026:	242080e7          	jalr	578(ra) # 80002264 <bread>
    8000302a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302c:	3ff97713          	andi	a4,s2,1023
    80003030:	40ed07bb          	subw	a5,s10,a4
    80003034:	414b86bb          	subw	a3,s7,s4
    80003038:	89be                	mv	s3,a5
    8000303a:	2781                	sext.w	a5,a5
    8000303c:	0006861b          	sext.w	a2,a3
    80003040:	f8f674e3          	bgeu	a2,a5,80002fc8 <writei+0x4e>
    80003044:	89b6                	mv	s3,a3
    80003046:	b749                	j	80002fc8 <writei+0x4e>
      brelse(bp);
    80003048:	8526                	mv	a0,s1
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	34a080e7          	jalr	842(ra) # 80002394 <brelse>
  }

  if(off > ip->size)
    80003052:	04cb2783          	lw	a5,76(s6)
    80003056:	0127f463          	bgeu	a5,s2,8000305e <writei+0xe4>
    ip->size = off;
    8000305a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000305e:	855a                	mv	a0,s6
    80003060:	00000097          	auipc	ra,0x0
    80003064:	9fe080e7          	jalr	-1538(ra) # 80002a5e <iupdate>

  return tot;
    80003068:	000a051b          	sext.w	a0,s4
}
    8000306c:	70a6                	ld	ra,104(sp)
    8000306e:	7406                	ld	s0,96(sp)
    80003070:	64e6                	ld	s1,88(sp)
    80003072:	6946                	ld	s2,80(sp)
    80003074:	69a6                	ld	s3,72(sp)
    80003076:	6a06                	ld	s4,64(sp)
    80003078:	7ae2                	ld	s5,56(sp)
    8000307a:	7b42                	ld	s6,48(sp)
    8000307c:	7ba2                	ld	s7,40(sp)
    8000307e:	7c02                	ld	s8,32(sp)
    80003080:	6ce2                	ld	s9,24(sp)
    80003082:	6d42                	ld	s10,16(sp)
    80003084:	6da2                	ld	s11,8(sp)
    80003086:	6165                	addi	sp,sp,112
    80003088:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000308a:	8a5e                	mv	s4,s7
    8000308c:	bfc9                	j	8000305e <writei+0xe4>
    return -1;
    8000308e:	557d                	li	a0,-1
}
    80003090:	8082                	ret
    return -1;
    80003092:	557d                	li	a0,-1
    80003094:	bfe1                	j	8000306c <writei+0xf2>
    return -1;
    80003096:	557d                	li	a0,-1
    80003098:	bfd1                	j	8000306c <writei+0xf2>

000000008000309a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000309a:	1141                	addi	sp,sp,-16
    8000309c:	e406                	sd	ra,8(sp)
    8000309e:	e022                	sd	s0,0(sp)
    800030a0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030a2:	4639                	li	a2,14
    800030a4:	ffffd097          	auipc	ra,0xffffd
    800030a8:	1ac080e7          	jalr	428(ra) # 80000250 <strncmp>
}
    800030ac:	60a2                	ld	ra,8(sp)
    800030ae:	6402                	ld	s0,0(sp)
    800030b0:	0141                	addi	sp,sp,16
    800030b2:	8082                	ret

00000000800030b4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030b4:	7139                	addi	sp,sp,-64
    800030b6:	fc06                	sd	ra,56(sp)
    800030b8:	f822                	sd	s0,48(sp)
    800030ba:	f426                	sd	s1,40(sp)
    800030bc:	f04a                	sd	s2,32(sp)
    800030be:	ec4e                	sd	s3,24(sp)
    800030c0:	e852                	sd	s4,16(sp)
    800030c2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030c4:	04451703          	lh	a4,68(a0)
    800030c8:	4785                	li	a5,1
    800030ca:	00f71a63          	bne	a4,a5,800030de <dirlookup+0x2a>
    800030ce:	892a                	mv	s2,a0
    800030d0:	89ae                	mv	s3,a1
    800030d2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d4:	457c                	lw	a5,76(a0)
    800030d6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030d8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030da:	e79d                	bnez	a5,80003108 <dirlookup+0x54>
    800030dc:	a8a5                	j	80003154 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030de:	00005517          	auipc	a0,0x5
    800030e2:	49250513          	addi	a0,a0,1170 # 80008570 <syscalls+0x1a8>
    800030e6:	00003097          	auipc	ra,0x3
    800030ea:	ce2080e7          	jalr	-798(ra) # 80005dc8 <panic>
      panic("dirlookup read");
    800030ee:	00005517          	auipc	a0,0x5
    800030f2:	49a50513          	addi	a0,a0,1178 # 80008588 <syscalls+0x1c0>
    800030f6:	00003097          	auipc	ra,0x3
    800030fa:	cd2080e7          	jalr	-814(ra) # 80005dc8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fe:	24c1                	addiw	s1,s1,16
    80003100:	04c92783          	lw	a5,76(s2)
    80003104:	04f4f763          	bgeu	s1,a5,80003152 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003108:	4741                	li	a4,16
    8000310a:	86a6                	mv	a3,s1
    8000310c:	fc040613          	addi	a2,s0,-64
    80003110:	4581                	li	a1,0
    80003112:	854a                	mv	a0,s2
    80003114:	00000097          	auipc	ra,0x0
    80003118:	d6e080e7          	jalr	-658(ra) # 80002e82 <readi>
    8000311c:	47c1                	li	a5,16
    8000311e:	fcf518e3          	bne	a0,a5,800030ee <dirlookup+0x3a>
    if(de.inum == 0)
    80003122:	fc045783          	lhu	a5,-64(s0)
    80003126:	dfe1                	beqz	a5,800030fe <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003128:	fc240593          	addi	a1,s0,-62
    8000312c:	854e                	mv	a0,s3
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	f6c080e7          	jalr	-148(ra) # 8000309a <namecmp>
    80003136:	f561                	bnez	a0,800030fe <dirlookup+0x4a>
      if(poff)
    80003138:	000a0463          	beqz	s4,80003140 <dirlookup+0x8c>
        *poff = off;
    8000313c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003140:	fc045583          	lhu	a1,-64(s0)
    80003144:	00092503          	lw	a0,0(s2)
    80003148:	fffff097          	auipc	ra,0xfffff
    8000314c:	6ac080e7          	jalr	1708(ra) # 800027f4 <iget>
    80003150:	a011                	j	80003154 <dirlookup+0xa0>
  return 0;
    80003152:	4501                	li	a0,0
}
    80003154:	70e2                	ld	ra,56(sp)
    80003156:	7442                	ld	s0,48(sp)
    80003158:	74a2                	ld	s1,40(sp)
    8000315a:	7902                	ld	s2,32(sp)
    8000315c:	69e2                	ld	s3,24(sp)
    8000315e:	6a42                	ld	s4,16(sp)
    80003160:	6121                	addi	sp,sp,64
    80003162:	8082                	ret

0000000080003164 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003164:	711d                	addi	sp,sp,-96
    80003166:	ec86                	sd	ra,88(sp)
    80003168:	e8a2                	sd	s0,80(sp)
    8000316a:	e4a6                	sd	s1,72(sp)
    8000316c:	e0ca                	sd	s2,64(sp)
    8000316e:	fc4e                	sd	s3,56(sp)
    80003170:	f852                	sd	s4,48(sp)
    80003172:	f456                	sd	s5,40(sp)
    80003174:	f05a                	sd	s6,32(sp)
    80003176:	ec5e                	sd	s7,24(sp)
    80003178:	e862                	sd	s8,16(sp)
    8000317a:	e466                	sd	s9,8(sp)
    8000317c:	1080                	addi	s0,sp,96
    8000317e:	84aa                	mv	s1,a0
    80003180:	8b2e                	mv	s6,a1
    80003182:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003184:	00054703          	lbu	a4,0(a0)
    80003188:	02f00793          	li	a5,47
    8000318c:	02f70363          	beq	a4,a5,800031b2 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003190:	ffffe097          	auipc	ra,0xffffe
    80003194:	cb8080e7          	jalr	-840(ra) # 80000e48 <myproc>
    80003198:	15053503          	ld	a0,336(a0)
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	94e080e7          	jalr	-1714(ra) # 80002aea <idup>
    800031a4:	89aa                	mv	s3,a0
  while(*path == '/')
    800031a6:	02f00913          	li	s2,47
  len = path - s;
    800031aa:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031ac:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031ae:	4c05                	li	s8,1
    800031b0:	a865                	j	80003268 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031b2:	4585                	li	a1,1
    800031b4:	4505                	li	a0,1
    800031b6:	fffff097          	auipc	ra,0xfffff
    800031ba:	63e080e7          	jalr	1598(ra) # 800027f4 <iget>
    800031be:	89aa                	mv	s3,a0
    800031c0:	b7dd                	j	800031a6 <namex+0x42>
      iunlockput(ip);
    800031c2:	854e                	mv	a0,s3
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	c6c080e7          	jalr	-916(ra) # 80002e30 <iunlockput>
      return 0;
    800031cc:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ce:	854e                	mv	a0,s3
    800031d0:	60e6                	ld	ra,88(sp)
    800031d2:	6446                	ld	s0,80(sp)
    800031d4:	64a6                	ld	s1,72(sp)
    800031d6:	6906                	ld	s2,64(sp)
    800031d8:	79e2                	ld	s3,56(sp)
    800031da:	7a42                	ld	s4,48(sp)
    800031dc:	7aa2                	ld	s5,40(sp)
    800031de:	7b02                	ld	s6,32(sp)
    800031e0:	6be2                	ld	s7,24(sp)
    800031e2:	6c42                	ld	s8,16(sp)
    800031e4:	6ca2                	ld	s9,8(sp)
    800031e6:	6125                	addi	sp,sp,96
    800031e8:	8082                	ret
      iunlock(ip);
    800031ea:	854e                	mv	a0,s3
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	9fe080e7          	jalr	-1538(ra) # 80002bea <iunlock>
      return ip;
    800031f4:	bfe9                	j	800031ce <namex+0x6a>
      iunlockput(ip);
    800031f6:	854e                	mv	a0,s3
    800031f8:	00000097          	auipc	ra,0x0
    800031fc:	c38080e7          	jalr	-968(ra) # 80002e30 <iunlockput>
      return 0;
    80003200:	89d2                	mv	s3,s4
    80003202:	b7f1                	j	800031ce <namex+0x6a>
  len = path - s;
    80003204:	40b48633          	sub	a2,s1,a1
    80003208:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000320c:	094cd463          	bge	s9,s4,80003294 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003210:	4639                	li	a2,14
    80003212:	8556                	mv	a0,s5
    80003214:	ffffd097          	auipc	ra,0xffffd
    80003218:	fc4080e7          	jalr	-60(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000321c:	0004c783          	lbu	a5,0(s1)
    80003220:	01279763          	bne	a5,s2,8000322e <namex+0xca>
    path++;
    80003224:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003226:	0004c783          	lbu	a5,0(s1)
    8000322a:	ff278de3          	beq	a5,s2,80003224 <namex+0xc0>
    ilock(ip);
    8000322e:	854e                	mv	a0,s3
    80003230:	00000097          	auipc	ra,0x0
    80003234:	8f8080e7          	jalr	-1800(ra) # 80002b28 <ilock>
    if(ip->type != T_DIR){
    80003238:	04499783          	lh	a5,68(s3)
    8000323c:	f98793e3          	bne	a5,s8,800031c2 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003240:	000b0563          	beqz	s6,8000324a <namex+0xe6>
    80003244:	0004c783          	lbu	a5,0(s1)
    80003248:	d3cd                	beqz	a5,800031ea <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000324a:	865e                	mv	a2,s7
    8000324c:	85d6                	mv	a1,s5
    8000324e:	854e                	mv	a0,s3
    80003250:	00000097          	auipc	ra,0x0
    80003254:	e64080e7          	jalr	-412(ra) # 800030b4 <dirlookup>
    80003258:	8a2a                	mv	s4,a0
    8000325a:	dd51                	beqz	a0,800031f6 <namex+0x92>
    iunlockput(ip);
    8000325c:	854e                	mv	a0,s3
    8000325e:	00000097          	auipc	ra,0x0
    80003262:	bd2080e7          	jalr	-1070(ra) # 80002e30 <iunlockput>
    ip = next;
    80003266:	89d2                	mv	s3,s4
  while(*path == '/')
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	05279763          	bne	a5,s2,800032ba <namex+0x156>
    path++;
    80003270:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	ff278de3          	beq	a5,s2,80003270 <namex+0x10c>
  if(*path == 0)
    8000327a:	c79d                	beqz	a5,800032a8 <namex+0x144>
    path++;
    8000327c:	85a6                	mv	a1,s1
  len = path - s;
    8000327e:	8a5e                	mv	s4,s7
    80003280:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003282:	01278963          	beq	a5,s2,80003294 <namex+0x130>
    80003286:	dfbd                	beqz	a5,80003204 <namex+0xa0>
    path++;
    80003288:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	ff279ce3          	bne	a5,s2,80003286 <namex+0x122>
    80003292:	bf8d                	j	80003204 <namex+0xa0>
    memmove(name, s, len);
    80003294:	2601                	sext.w	a2,a2
    80003296:	8556                	mv	a0,s5
    80003298:	ffffd097          	auipc	ra,0xffffd
    8000329c:	f40080e7          	jalr	-192(ra) # 800001d8 <memmove>
    name[len] = 0;
    800032a0:	9a56                	add	s4,s4,s5
    800032a2:	000a0023          	sb	zero,0(s4)
    800032a6:	bf9d                	j	8000321c <namex+0xb8>
  if(nameiparent){
    800032a8:	f20b03e3          	beqz	s6,800031ce <namex+0x6a>
    iput(ip);
    800032ac:	854e                	mv	a0,s3
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	ada080e7          	jalr	-1318(ra) # 80002d88 <iput>
    return 0;
    800032b6:	4981                	li	s3,0
    800032b8:	bf19                	j	800031ce <namex+0x6a>
  if(*path == 0)
    800032ba:	d7fd                	beqz	a5,800032a8 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032bc:	0004c783          	lbu	a5,0(s1)
    800032c0:	85a6                	mv	a1,s1
    800032c2:	b7d1                	j	80003286 <namex+0x122>

00000000800032c4 <dirlink>:
{
    800032c4:	7139                	addi	sp,sp,-64
    800032c6:	fc06                	sd	ra,56(sp)
    800032c8:	f822                	sd	s0,48(sp)
    800032ca:	f426                	sd	s1,40(sp)
    800032cc:	f04a                	sd	s2,32(sp)
    800032ce:	ec4e                	sd	s3,24(sp)
    800032d0:	e852                	sd	s4,16(sp)
    800032d2:	0080                	addi	s0,sp,64
    800032d4:	892a                	mv	s2,a0
    800032d6:	8a2e                	mv	s4,a1
    800032d8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032da:	4601                	li	a2,0
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	dd8080e7          	jalr	-552(ra) # 800030b4 <dirlookup>
    800032e4:	e93d                	bnez	a0,8000335a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e6:	04c92483          	lw	s1,76(s2)
    800032ea:	c49d                	beqz	s1,80003318 <dirlink+0x54>
    800032ec:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ee:	4741                	li	a4,16
    800032f0:	86a6                	mv	a3,s1
    800032f2:	fc040613          	addi	a2,s0,-64
    800032f6:	4581                	li	a1,0
    800032f8:	854a                	mv	a0,s2
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	b88080e7          	jalr	-1144(ra) # 80002e82 <readi>
    80003302:	47c1                	li	a5,16
    80003304:	06f51163          	bne	a0,a5,80003366 <dirlink+0xa2>
    if(de.inum == 0)
    80003308:	fc045783          	lhu	a5,-64(s0)
    8000330c:	c791                	beqz	a5,80003318 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000330e:	24c1                	addiw	s1,s1,16
    80003310:	04c92783          	lw	a5,76(s2)
    80003314:	fcf4ede3          	bltu	s1,a5,800032ee <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003318:	4639                	li	a2,14
    8000331a:	85d2                	mv	a1,s4
    8000331c:	fc240513          	addi	a0,s0,-62
    80003320:	ffffd097          	auipc	ra,0xffffd
    80003324:	f6c080e7          	jalr	-148(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003328:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000332c:	4741                	li	a4,16
    8000332e:	86a6                	mv	a3,s1
    80003330:	fc040613          	addi	a2,s0,-64
    80003334:	4581                	li	a1,0
    80003336:	854a                	mv	a0,s2
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	c42080e7          	jalr	-958(ra) # 80002f7a <writei>
    80003340:	872a                	mv	a4,a0
    80003342:	47c1                	li	a5,16
  return 0;
    80003344:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003346:	02f71863          	bne	a4,a5,80003376 <dirlink+0xb2>
}
    8000334a:	70e2                	ld	ra,56(sp)
    8000334c:	7442                	ld	s0,48(sp)
    8000334e:	74a2                	ld	s1,40(sp)
    80003350:	7902                	ld	s2,32(sp)
    80003352:	69e2                	ld	s3,24(sp)
    80003354:	6a42                	ld	s4,16(sp)
    80003356:	6121                	addi	sp,sp,64
    80003358:	8082                	ret
    iput(ip);
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	a2e080e7          	jalr	-1490(ra) # 80002d88 <iput>
    return -1;
    80003362:	557d                	li	a0,-1
    80003364:	b7dd                	j	8000334a <dirlink+0x86>
      panic("dirlink read");
    80003366:	00005517          	auipc	a0,0x5
    8000336a:	23250513          	addi	a0,a0,562 # 80008598 <syscalls+0x1d0>
    8000336e:	00003097          	auipc	ra,0x3
    80003372:	a5a080e7          	jalr	-1446(ra) # 80005dc8 <panic>
    panic("dirlink");
    80003376:	00005517          	auipc	a0,0x5
    8000337a:	33250513          	addi	a0,a0,818 # 800086a8 <syscalls+0x2e0>
    8000337e:	00003097          	auipc	ra,0x3
    80003382:	a4a080e7          	jalr	-1462(ra) # 80005dc8 <panic>

0000000080003386 <namei>:

struct inode*
namei(char *path)
{
    80003386:	1101                	addi	sp,sp,-32
    80003388:	ec06                	sd	ra,24(sp)
    8000338a:	e822                	sd	s0,16(sp)
    8000338c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000338e:	fe040613          	addi	a2,s0,-32
    80003392:	4581                	li	a1,0
    80003394:	00000097          	auipc	ra,0x0
    80003398:	dd0080e7          	jalr	-560(ra) # 80003164 <namex>
}
    8000339c:	60e2                	ld	ra,24(sp)
    8000339e:	6442                	ld	s0,16(sp)
    800033a0:	6105                	addi	sp,sp,32
    800033a2:	8082                	ret

00000000800033a4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033a4:	1141                	addi	sp,sp,-16
    800033a6:	e406                	sd	ra,8(sp)
    800033a8:	e022                	sd	s0,0(sp)
    800033aa:	0800                	addi	s0,sp,16
    800033ac:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033ae:	4585                	li	a1,1
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	db4080e7          	jalr	-588(ra) # 80003164 <namex>
}
    800033b8:	60a2                	ld	ra,8(sp)
    800033ba:	6402                	ld	s0,0(sp)
    800033bc:	0141                	addi	sp,sp,16
    800033be:	8082                	ret

00000000800033c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033c0:	1101                	addi	sp,sp,-32
    800033c2:	ec06                	sd	ra,24(sp)
    800033c4:	e822                	sd	s0,16(sp)
    800033c6:	e426                	sd	s1,8(sp)
    800033c8:	e04a                	sd	s2,0(sp)
    800033ca:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033cc:	00011917          	auipc	s2,0x11
    800033d0:	06490913          	addi	s2,s2,100 # 80014430 <log>
    800033d4:	01892583          	lw	a1,24(s2)
    800033d8:	02892503          	lw	a0,40(s2)
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	e88080e7          	jalr	-376(ra) # 80002264 <bread>
    800033e4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033e6:	02c92683          	lw	a3,44(s2)
    800033ea:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033ec:	02d05763          	blez	a3,8000341a <write_head+0x5a>
    800033f0:	00011797          	auipc	a5,0x11
    800033f4:	07078793          	addi	a5,a5,112 # 80014460 <log+0x30>
    800033f8:	05c50713          	addi	a4,a0,92
    800033fc:	36fd                	addiw	a3,a3,-1
    800033fe:	1682                	slli	a3,a3,0x20
    80003400:	9281                	srli	a3,a3,0x20
    80003402:	068a                	slli	a3,a3,0x2
    80003404:	00011617          	auipc	a2,0x11
    80003408:	06060613          	addi	a2,a2,96 # 80014464 <log+0x34>
    8000340c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000340e:	4390                	lw	a2,0(a5)
    80003410:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003412:	0791                	addi	a5,a5,4
    80003414:	0711                	addi	a4,a4,4
    80003416:	fed79ce3          	bne	a5,a3,8000340e <write_head+0x4e>
  }
  bwrite(buf);
    8000341a:	8526                	mv	a0,s1
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	f3a080e7          	jalr	-198(ra) # 80002356 <bwrite>
  brelse(buf);
    80003424:	8526                	mv	a0,s1
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	f6e080e7          	jalr	-146(ra) # 80002394 <brelse>
}
    8000342e:	60e2                	ld	ra,24(sp)
    80003430:	6442                	ld	s0,16(sp)
    80003432:	64a2                	ld	s1,8(sp)
    80003434:	6902                	ld	s2,0(sp)
    80003436:	6105                	addi	sp,sp,32
    80003438:	8082                	ret

000000008000343a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343a:	00011797          	auipc	a5,0x11
    8000343e:	0227a783          	lw	a5,34(a5) # 8001445c <log+0x2c>
    80003442:	0af05d63          	blez	a5,800034fc <install_trans+0xc2>
{
    80003446:	7139                	addi	sp,sp,-64
    80003448:	fc06                	sd	ra,56(sp)
    8000344a:	f822                	sd	s0,48(sp)
    8000344c:	f426                	sd	s1,40(sp)
    8000344e:	f04a                	sd	s2,32(sp)
    80003450:	ec4e                	sd	s3,24(sp)
    80003452:	e852                	sd	s4,16(sp)
    80003454:	e456                	sd	s5,8(sp)
    80003456:	e05a                	sd	s6,0(sp)
    80003458:	0080                	addi	s0,sp,64
    8000345a:	8b2a                	mv	s6,a0
    8000345c:	00011a97          	auipc	s5,0x11
    80003460:	004a8a93          	addi	s5,s5,4 # 80014460 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003464:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003466:	00011997          	auipc	s3,0x11
    8000346a:	fca98993          	addi	s3,s3,-54 # 80014430 <log>
    8000346e:	a035                	j	8000349a <install_trans+0x60>
      bunpin(dbuf);
    80003470:	8526                	mv	a0,s1
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	ffc080e7          	jalr	-4(ra) # 8000246e <bunpin>
    brelse(lbuf);
    8000347a:	854a                	mv	a0,s2
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	f18080e7          	jalr	-232(ra) # 80002394 <brelse>
    brelse(dbuf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	f0e080e7          	jalr	-242(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000348e:	2a05                	addiw	s4,s4,1
    80003490:	0a91                	addi	s5,s5,4
    80003492:	02c9a783          	lw	a5,44(s3)
    80003496:	04fa5963          	bge	s4,a5,800034e8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000349a:	0189a583          	lw	a1,24(s3)
    8000349e:	014585bb          	addw	a1,a1,s4
    800034a2:	2585                	addiw	a1,a1,1
    800034a4:	0289a503          	lw	a0,40(s3)
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	dbc080e7          	jalr	-580(ra) # 80002264 <bread>
    800034b0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034b2:	000aa583          	lw	a1,0(s5)
    800034b6:	0289a503          	lw	a0,40(s3)
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	daa080e7          	jalr	-598(ra) # 80002264 <bread>
    800034c2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034c4:	40000613          	li	a2,1024
    800034c8:	05890593          	addi	a1,s2,88
    800034cc:	05850513          	addi	a0,a0,88
    800034d0:	ffffd097          	auipc	ra,0xffffd
    800034d4:	d08080e7          	jalr	-760(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034d8:	8526                	mv	a0,s1
    800034da:	fffff097          	auipc	ra,0xfffff
    800034de:	e7c080e7          	jalr	-388(ra) # 80002356 <bwrite>
    if(recovering == 0)
    800034e2:	f80b1ce3          	bnez	s6,8000347a <install_trans+0x40>
    800034e6:	b769                	j	80003470 <install_trans+0x36>
}
    800034e8:	70e2                	ld	ra,56(sp)
    800034ea:	7442                	ld	s0,48(sp)
    800034ec:	74a2                	ld	s1,40(sp)
    800034ee:	7902                	ld	s2,32(sp)
    800034f0:	69e2                	ld	s3,24(sp)
    800034f2:	6a42                	ld	s4,16(sp)
    800034f4:	6aa2                	ld	s5,8(sp)
    800034f6:	6b02                	ld	s6,0(sp)
    800034f8:	6121                	addi	sp,sp,64
    800034fa:	8082                	ret
    800034fc:	8082                	ret

00000000800034fe <initlog>:
{
    800034fe:	7179                	addi	sp,sp,-48
    80003500:	f406                	sd	ra,40(sp)
    80003502:	f022                	sd	s0,32(sp)
    80003504:	ec26                	sd	s1,24(sp)
    80003506:	e84a                	sd	s2,16(sp)
    80003508:	e44e                	sd	s3,8(sp)
    8000350a:	1800                	addi	s0,sp,48
    8000350c:	892a                	mv	s2,a0
    8000350e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003510:	00011497          	auipc	s1,0x11
    80003514:	f2048493          	addi	s1,s1,-224 # 80014430 <log>
    80003518:	00005597          	auipc	a1,0x5
    8000351c:	09058593          	addi	a1,a1,144 # 800085a8 <syscalls+0x1e0>
    80003520:	8526                	mv	a0,s1
    80003522:	00003097          	auipc	ra,0x3
    80003526:	d60080e7          	jalr	-672(ra) # 80006282 <initlock>
  log.start = sb->logstart;
    8000352a:	0149a583          	lw	a1,20(s3)
    8000352e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003530:	0109a783          	lw	a5,16(s3)
    80003534:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003536:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000353a:	854a                	mv	a0,s2
    8000353c:	fffff097          	auipc	ra,0xfffff
    80003540:	d28080e7          	jalr	-728(ra) # 80002264 <bread>
  log.lh.n = lh->n;
    80003544:	4d3c                	lw	a5,88(a0)
    80003546:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003548:	02f05563          	blez	a5,80003572 <initlog+0x74>
    8000354c:	05c50713          	addi	a4,a0,92
    80003550:	00011697          	auipc	a3,0x11
    80003554:	f1068693          	addi	a3,a3,-240 # 80014460 <log+0x30>
    80003558:	37fd                	addiw	a5,a5,-1
    8000355a:	1782                	slli	a5,a5,0x20
    8000355c:	9381                	srli	a5,a5,0x20
    8000355e:	078a                	slli	a5,a5,0x2
    80003560:	06050613          	addi	a2,a0,96
    80003564:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003566:	4310                	lw	a2,0(a4)
    80003568:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000356a:	0711                	addi	a4,a4,4
    8000356c:	0691                	addi	a3,a3,4
    8000356e:	fef71ce3          	bne	a4,a5,80003566 <initlog+0x68>
  brelse(buf);
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	e22080e7          	jalr	-478(ra) # 80002394 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000357a:	4505                	li	a0,1
    8000357c:	00000097          	auipc	ra,0x0
    80003580:	ebe080e7          	jalr	-322(ra) # 8000343a <install_trans>
  log.lh.n = 0;
    80003584:	00011797          	auipc	a5,0x11
    80003588:	ec07ac23          	sw	zero,-296(a5) # 8001445c <log+0x2c>
  write_head(); // clear the log
    8000358c:	00000097          	auipc	ra,0x0
    80003590:	e34080e7          	jalr	-460(ra) # 800033c0 <write_head>
}
    80003594:	70a2                	ld	ra,40(sp)
    80003596:	7402                	ld	s0,32(sp)
    80003598:	64e2                	ld	s1,24(sp)
    8000359a:	6942                	ld	s2,16(sp)
    8000359c:	69a2                	ld	s3,8(sp)
    8000359e:	6145                	addi	sp,sp,48
    800035a0:	8082                	ret

00000000800035a2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035a2:	1101                	addi	sp,sp,-32
    800035a4:	ec06                	sd	ra,24(sp)
    800035a6:	e822                	sd	s0,16(sp)
    800035a8:	e426                	sd	s1,8(sp)
    800035aa:	e04a                	sd	s2,0(sp)
    800035ac:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035ae:	00011517          	auipc	a0,0x11
    800035b2:	e8250513          	addi	a0,a0,-382 # 80014430 <log>
    800035b6:	00003097          	auipc	ra,0x3
    800035ba:	d5c080e7          	jalr	-676(ra) # 80006312 <acquire>
  while(1){
    if(log.committing){
    800035be:	00011497          	auipc	s1,0x11
    800035c2:	e7248493          	addi	s1,s1,-398 # 80014430 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c6:	4979                	li	s2,30
    800035c8:	a039                	j	800035d6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035ca:	85a6                	mv	a1,s1
    800035cc:	8526                	mv	a0,s1
    800035ce:	ffffe097          	auipc	ra,0xffffe
    800035d2:	f36080e7          	jalr	-202(ra) # 80001504 <sleep>
    if(log.committing){
    800035d6:	50dc                	lw	a5,36(s1)
    800035d8:	fbed                	bnez	a5,800035ca <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035da:	509c                	lw	a5,32(s1)
    800035dc:	0017871b          	addiw	a4,a5,1
    800035e0:	0007069b          	sext.w	a3,a4
    800035e4:	0027179b          	slliw	a5,a4,0x2
    800035e8:	9fb9                	addw	a5,a5,a4
    800035ea:	0017979b          	slliw	a5,a5,0x1
    800035ee:	54d8                	lw	a4,44(s1)
    800035f0:	9fb9                	addw	a5,a5,a4
    800035f2:	00f95963          	bge	s2,a5,80003604 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035f6:	85a6                	mv	a1,s1
    800035f8:	8526                	mv	a0,s1
    800035fa:	ffffe097          	auipc	ra,0xffffe
    800035fe:	f0a080e7          	jalr	-246(ra) # 80001504 <sleep>
    80003602:	bfd1                	j	800035d6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003604:	00011517          	auipc	a0,0x11
    80003608:	e2c50513          	addi	a0,a0,-468 # 80014430 <log>
    8000360c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000360e:	00003097          	auipc	ra,0x3
    80003612:	db8080e7          	jalr	-584(ra) # 800063c6 <release>
      break;
    }
  }
}
    80003616:	60e2                	ld	ra,24(sp)
    80003618:	6442                	ld	s0,16(sp)
    8000361a:	64a2                	ld	s1,8(sp)
    8000361c:	6902                	ld	s2,0(sp)
    8000361e:	6105                	addi	sp,sp,32
    80003620:	8082                	ret

0000000080003622 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003622:	7139                	addi	sp,sp,-64
    80003624:	fc06                	sd	ra,56(sp)
    80003626:	f822                	sd	s0,48(sp)
    80003628:	f426                	sd	s1,40(sp)
    8000362a:	f04a                	sd	s2,32(sp)
    8000362c:	ec4e                	sd	s3,24(sp)
    8000362e:	e852                	sd	s4,16(sp)
    80003630:	e456                	sd	s5,8(sp)
    80003632:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003634:	00011497          	auipc	s1,0x11
    80003638:	dfc48493          	addi	s1,s1,-516 # 80014430 <log>
    8000363c:	8526                	mv	a0,s1
    8000363e:	00003097          	auipc	ra,0x3
    80003642:	cd4080e7          	jalr	-812(ra) # 80006312 <acquire>
  log.outstanding -= 1;
    80003646:	509c                	lw	a5,32(s1)
    80003648:	37fd                	addiw	a5,a5,-1
    8000364a:	0007891b          	sext.w	s2,a5
    8000364e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003650:	50dc                	lw	a5,36(s1)
    80003652:	efb9                	bnez	a5,800036b0 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003654:	06091663          	bnez	s2,800036c0 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003658:	00011497          	auipc	s1,0x11
    8000365c:	dd848493          	addi	s1,s1,-552 # 80014430 <log>
    80003660:	4785                	li	a5,1
    80003662:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	d60080e7          	jalr	-672(ra) # 800063c6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000366e:	54dc                	lw	a5,44(s1)
    80003670:	06f04763          	bgtz	a5,800036de <end_op+0xbc>
    acquire(&log.lock);
    80003674:	00011497          	auipc	s1,0x11
    80003678:	dbc48493          	addi	s1,s1,-580 # 80014430 <log>
    8000367c:	8526                	mv	a0,s1
    8000367e:	00003097          	auipc	ra,0x3
    80003682:	c94080e7          	jalr	-876(ra) # 80006312 <acquire>
    log.committing = 0;
    80003686:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000368a:	8526                	mv	a0,s1
    8000368c:	ffffe097          	auipc	ra,0xffffe
    80003690:	004080e7          	jalr	4(ra) # 80001690 <wakeup>
    release(&log.lock);
    80003694:	8526                	mv	a0,s1
    80003696:	00003097          	auipc	ra,0x3
    8000369a:	d30080e7          	jalr	-720(ra) # 800063c6 <release>
}
    8000369e:	70e2                	ld	ra,56(sp)
    800036a0:	7442                	ld	s0,48(sp)
    800036a2:	74a2                	ld	s1,40(sp)
    800036a4:	7902                	ld	s2,32(sp)
    800036a6:	69e2                	ld	s3,24(sp)
    800036a8:	6a42                	ld	s4,16(sp)
    800036aa:	6aa2                	ld	s5,8(sp)
    800036ac:	6121                	addi	sp,sp,64
    800036ae:	8082                	ret
    panic("log.committing");
    800036b0:	00005517          	auipc	a0,0x5
    800036b4:	f0050513          	addi	a0,a0,-256 # 800085b0 <syscalls+0x1e8>
    800036b8:	00002097          	auipc	ra,0x2
    800036bc:	710080e7          	jalr	1808(ra) # 80005dc8 <panic>
    wakeup(&log);
    800036c0:	00011497          	auipc	s1,0x11
    800036c4:	d7048493          	addi	s1,s1,-656 # 80014430 <log>
    800036c8:	8526                	mv	a0,s1
    800036ca:	ffffe097          	auipc	ra,0xffffe
    800036ce:	fc6080e7          	jalr	-58(ra) # 80001690 <wakeup>
  release(&log.lock);
    800036d2:	8526                	mv	a0,s1
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	cf2080e7          	jalr	-782(ra) # 800063c6 <release>
  if(do_commit){
    800036dc:	b7c9                	j	8000369e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036de:	00011a97          	auipc	s5,0x11
    800036e2:	d82a8a93          	addi	s5,s5,-638 # 80014460 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036e6:	00011a17          	auipc	s4,0x11
    800036ea:	d4aa0a13          	addi	s4,s4,-694 # 80014430 <log>
    800036ee:	018a2583          	lw	a1,24(s4)
    800036f2:	012585bb          	addw	a1,a1,s2
    800036f6:	2585                	addiw	a1,a1,1
    800036f8:	028a2503          	lw	a0,40(s4)
    800036fc:	fffff097          	auipc	ra,0xfffff
    80003700:	b68080e7          	jalr	-1176(ra) # 80002264 <bread>
    80003704:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003706:	000aa583          	lw	a1,0(s5)
    8000370a:	028a2503          	lw	a0,40(s4)
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	b56080e7          	jalr	-1194(ra) # 80002264 <bread>
    80003716:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003718:	40000613          	li	a2,1024
    8000371c:	05850593          	addi	a1,a0,88
    80003720:	05848513          	addi	a0,s1,88
    80003724:	ffffd097          	auipc	ra,0xffffd
    80003728:	ab4080e7          	jalr	-1356(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000372c:	8526                	mv	a0,s1
    8000372e:	fffff097          	auipc	ra,0xfffff
    80003732:	c28080e7          	jalr	-984(ra) # 80002356 <bwrite>
    brelse(from);
    80003736:	854e                	mv	a0,s3
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	c5c080e7          	jalr	-932(ra) # 80002394 <brelse>
    brelse(to);
    80003740:	8526                	mv	a0,s1
    80003742:	fffff097          	auipc	ra,0xfffff
    80003746:	c52080e7          	jalr	-942(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000374a:	2905                	addiw	s2,s2,1
    8000374c:	0a91                	addi	s5,s5,4
    8000374e:	02ca2783          	lw	a5,44(s4)
    80003752:	f8f94ee3          	blt	s2,a5,800036ee <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	c6a080e7          	jalr	-918(ra) # 800033c0 <write_head>
    install_trans(0); // Now install writes to home locations
    8000375e:	4501                	li	a0,0
    80003760:	00000097          	auipc	ra,0x0
    80003764:	cda080e7          	jalr	-806(ra) # 8000343a <install_trans>
    log.lh.n = 0;
    80003768:	00011797          	auipc	a5,0x11
    8000376c:	ce07aa23          	sw	zero,-780(a5) # 8001445c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003770:	00000097          	auipc	ra,0x0
    80003774:	c50080e7          	jalr	-944(ra) # 800033c0 <write_head>
    80003778:	bdf5                	j	80003674 <end_op+0x52>

000000008000377a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000377a:	1101                	addi	sp,sp,-32
    8000377c:	ec06                	sd	ra,24(sp)
    8000377e:	e822                	sd	s0,16(sp)
    80003780:	e426                	sd	s1,8(sp)
    80003782:	e04a                	sd	s2,0(sp)
    80003784:	1000                	addi	s0,sp,32
    80003786:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003788:	00011917          	auipc	s2,0x11
    8000378c:	ca890913          	addi	s2,s2,-856 # 80014430 <log>
    80003790:	854a                	mv	a0,s2
    80003792:	00003097          	auipc	ra,0x3
    80003796:	b80080e7          	jalr	-1152(ra) # 80006312 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000379a:	02c92603          	lw	a2,44(s2)
    8000379e:	47f5                	li	a5,29
    800037a0:	06c7c563          	blt	a5,a2,8000380a <log_write+0x90>
    800037a4:	00011797          	auipc	a5,0x11
    800037a8:	ca87a783          	lw	a5,-856(a5) # 8001444c <log+0x1c>
    800037ac:	37fd                	addiw	a5,a5,-1
    800037ae:	04f65e63          	bge	a2,a5,8000380a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037b2:	00011797          	auipc	a5,0x11
    800037b6:	c9e7a783          	lw	a5,-866(a5) # 80014450 <log+0x20>
    800037ba:	06f05063          	blez	a5,8000381a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037be:	4781                	li	a5,0
    800037c0:	06c05563          	blez	a2,8000382a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c4:	44cc                	lw	a1,12(s1)
    800037c6:	00011717          	auipc	a4,0x11
    800037ca:	c9a70713          	addi	a4,a4,-870 # 80014460 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ce:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d0:	4314                	lw	a3,0(a4)
    800037d2:	04b68c63          	beq	a3,a1,8000382a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037d6:	2785                	addiw	a5,a5,1
    800037d8:	0711                	addi	a4,a4,4
    800037da:	fef61be3          	bne	a2,a5,800037d0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037de:	0621                	addi	a2,a2,8
    800037e0:	060a                	slli	a2,a2,0x2
    800037e2:	00011797          	auipc	a5,0x11
    800037e6:	c4e78793          	addi	a5,a5,-946 # 80014430 <log>
    800037ea:	963e                	add	a2,a2,a5
    800037ec:	44dc                	lw	a5,12(s1)
    800037ee:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037f0:	8526                	mv	a0,s1
    800037f2:	fffff097          	auipc	ra,0xfffff
    800037f6:	c40080e7          	jalr	-960(ra) # 80002432 <bpin>
    log.lh.n++;
    800037fa:	00011717          	auipc	a4,0x11
    800037fe:	c3670713          	addi	a4,a4,-970 # 80014430 <log>
    80003802:	575c                	lw	a5,44(a4)
    80003804:	2785                	addiw	a5,a5,1
    80003806:	d75c                	sw	a5,44(a4)
    80003808:	a835                	j	80003844 <log_write+0xca>
    panic("too big a transaction");
    8000380a:	00005517          	auipc	a0,0x5
    8000380e:	db650513          	addi	a0,a0,-586 # 800085c0 <syscalls+0x1f8>
    80003812:	00002097          	auipc	ra,0x2
    80003816:	5b6080e7          	jalr	1462(ra) # 80005dc8 <panic>
    panic("log_write outside of trans");
    8000381a:	00005517          	auipc	a0,0x5
    8000381e:	dbe50513          	addi	a0,a0,-578 # 800085d8 <syscalls+0x210>
    80003822:	00002097          	auipc	ra,0x2
    80003826:	5a6080e7          	jalr	1446(ra) # 80005dc8 <panic>
  log.lh.block[i] = b->blockno;
    8000382a:	00878713          	addi	a4,a5,8
    8000382e:	00271693          	slli	a3,a4,0x2
    80003832:	00011717          	auipc	a4,0x11
    80003836:	bfe70713          	addi	a4,a4,-1026 # 80014430 <log>
    8000383a:	9736                	add	a4,a4,a3
    8000383c:	44d4                	lw	a3,12(s1)
    8000383e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003840:	faf608e3          	beq	a2,a5,800037f0 <log_write+0x76>
  }
  release(&log.lock);
    80003844:	00011517          	auipc	a0,0x11
    80003848:	bec50513          	addi	a0,a0,-1044 # 80014430 <log>
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	b7a080e7          	jalr	-1158(ra) # 800063c6 <release>
}
    80003854:	60e2                	ld	ra,24(sp)
    80003856:	6442                	ld	s0,16(sp)
    80003858:	64a2                	ld	s1,8(sp)
    8000385a:	6902                	ld	s2,0(sp)
    8000385c:	6105                	addi	sp,sp,32
    8000385e:	8082                	ret

0000000080003860 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003860:	1101                	addi	sp,sp,-32
    80003862:	ec06                	sd	ra,24(sp)
    80003864:	e822                	sd	s0,16(sp)
    80003866:	e426                	sd	s1,8(sp)
    80003868:	e04a                	sd	s2,0(sp)
    8000386a:	1000                	addi	s0,sp,32
    8000386c:	84aa                	mv	s1,a0
    8000386e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003870:	00005597          	auipc	a1,0x5
    80003874:	d8858593          	addi	a1,a1,-632 # 800085f8 <syscalls+0x230>
    80003878:	0521                	addi	a0,a0,8
    8000387a:	00003097          	auipc	ra,0x3
    8000387e:	a08080e7          	jalr	-1528(ra) # 80006282 <initlock>
  lk->name = name;
    80003882:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003886:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000388a:	0204a423          	sw	zero,40(s1)
}
    8000388e:	60e2                	ld	ra,24(sp)
    80003890:	6442                	ld	s0,16(sp)
    80003892:	64a2                	ld	s1,8(sp)
    80003894:	6902                	ld	s2,0(sp)
    80003896:	6105                	addi	sp,sp,32
    80003898:	8082                	ret

000000008000389a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000389a:	1101                	addi	sp,sp,-32
    8000389c:	ec06                	sd	ra,24(sp)
    8000389e:	e822                	sd	s0,16(sp)
    800038a0:	e426                	sd	s1,8(sp)
    800038a2:	e04a                	sd	s2,0(sp)
    800038a4:	1000                	addi	s0,sp,32
    800038a6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038a8:	00850913          	addi	s2,a0,8
    800038ac:	854a                	mv	a0,s2
    800038ae:	00003097          	auipc	ra,0x3
    800038b2:	a64080e7          	jalr	-1436(ra) # 80006312 <acquire>
  while (lk->locked) {
    800038b6:	409c                	lw	a5,0(s1)
    800038b8:	cb89                	beqz	a5,800038ca <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ba:	85ca                	mv	a1,s2
    800038bc:	8526                	mv	a0,s1
    800038be:	ffffe097          	auipc	ra,0xffffe
    800038c2:	c46080e7          	jalr	-954(ra) # 80001504 <sleep>
  while (lk->locked) {
    800038c6:	409c                	lw	a5,0(s1)
    800038c8:	fbed                	bnez	a5,800038ba <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038ca:	4785                	li	a5,1
    800038cc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	57a080e7          	jalr	1402(ra) # 80000e48 <myproc>
    800038d6:	591c                	lw	a5,48(a0)
    800038d8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038da:	854a                	mv	a0,s2
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	aea080e7          	jalr	-1302(ra) # 800063c6 <release>
}
    800038e4:	60e2                	ld	ra,24(sp)
    800038e6:	6442                	ld	s0,16(sp)
    800038e8:	64a2                	ld	s1,8(sp)
    800038ea:	6902                	ld	s2,0(sp)
    800038ec:	6105                	addi	sp,sp,32
    800038ee:	8082                	ret

00000000800038f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038f0:	1101                	addi	sp,sp,-32
    800038f2:	ec06                	sd	ra,24(sp)
    800038f4:	e822                	sd	s0,16(sp)
    800038f6:	e426                	sd	s1,8(sp)
    800038f8:	e04a                	sd	s2,0(sp)
    800038fa:	1000                	addi	s0,sp,32
    800038fc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038fe:	00850913          	addi	s2,a0,8
    80003902:	854a                	mv	a0,s2
    80003904:	00003097          	auipc	ra,0x3
    80003908:	a0e080e7          	jalr	-1522(ra) # 80006312 <acquire>
  lk->locked = 0;
    8000390c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003910:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003914:	8526                	mv	a0,s1
    80003916:	ffffe097          	auipc	ra,0xffffe
    8000391a:	d7a080e7          	jalr	-646(ra) # 80001690 <wakeup>
  release(&lk->lk);
    8000391e:	854a                	mv	a0,s2
    80003920:	00003097          	auipc	ra,0x3
    80003924:	aa6080e7          	jalr	-1370(ra) # 800063c6 <release>
}
    80003928:	60e2                	ld	ra,24(sp)
    8000392a:	6442                	ld	s0,16(sp)
    8000392c:	64a2                	ld	s1,8(sp)
    8000392e:	6902                	ld	s2,0(sp)
    80003930:	6105                	addi	sp,sp,32
    80003932:	8082                	ret

0000000080003934 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003934:	7179                	addi	sp,sp,-48
    80003936:	f406                	sd	ra,40(sp)
    80003938:	f022                	sd	s0,32(sp)
    8000393a:	ec26                	sd	s1,24(sp)
    8000393c:	e84a                	sd	s2,16(sp)
    8000393e:	e44e                	sd	s3,8(sp)
    80003940:	1800                	addi	s0,sp,48
    80003942:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003944:	00850913          	addi	s2,a0,8
    80003948:	854a                	mv	a0,s2
    8000394a:	00003097          	auipc	ra,0x3
    8000394e:	9c8080e7          	jalr	-1592(ra) # 80006312 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003952:	409c                	lw	a5,0(s1)
    80003954:	ef99                	bnez	a5,80003972 <holdingsleep+0x3e>
    80003956:	4481                	li	s1,0
  release(&lk->lk);
    80003958:	854a                	mv	a0,s2
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	a6c080e7          	jalr	-1428(ra) # 800063c6 <release>
  return r;
}
    80003962:	8526                	mv	a0,s1
    80003964:	70a2                	ld	ra,40(sp)
    80003966:	7402                	ld	s0,32(sp)
    80003968:	64e2                	ld	s1,24(sp)
    8000396a:	6942                	ld	s2,16(sp)
    8000396c:	69a2                	ld	s3,8(sp)
    8000396e:	6145                	addi	sp,sp,48
    80003970:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003972:	0284a983          	lw	s3,40(s1)
    80003976:	ffffd097          	auipc	ra,0xffffd
    8000397a:	4d2080e7          	jalr	1234(ra) # 80000e48 <myproc>
    8000397e:	5904                	lw	s1,48(a0)
    80003980:	413484b3          	sub	s1,s1,s3
    80003984:	0014b493          	seqz	s1,s1
    80003988:	bfc1                	j	80003958 <holdingsleep+0x24>

000000008000398a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000398a:	1141                	addi	sp,sp,-16
    8000398c:	e406                	sd	ra,8(sp)
    8000398e:	e022                	sd	s0,0(sp)
    80003990:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003992:	00005597          	auipc	a1,0x5
    80003996:	c7658593          	addi	a1,a1,-906 # 80008608 <syscalls+0x240>
    8000399a:	00011517          	auipc	a0,0x11
    8000399e:	bde50513          	addi	a0,a0,-1058 # 80014578 <ftable>
    800039a2:	00003097          	auipc	ra,0x3
    800039a6:	8e0080e7          	jalr	-1824(ra) # 80006282 <initlock>
}
    800039aa:	60a2                	ld	ra,8(sp)
    800039ac:	6402                	ld	s0,0(sp)
    800039ae:	0141                	addi	sp,sp,16
    800039b0:	8082                	ret

00000000800039b2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039b2:	1101                	addi	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039bc:	00011517          	auipc	a0,0x11
    800039c0:	bbc50513          	addi	a0,a0,-1092 # 80014578 <ftable>
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	94e080e7          	jalr	-1714(ra) # 80006312 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039cc:	00011497          	auipc	s1,0x11
    800039d0:	bc448493          	addi	s1,s1,-1084 # 80014590 <ftable+0x18>
    800039d4:	00012717          	auipc	a4,0x12
    800039d8:	b5c70713          	addi	a4,a4,-1188 # 80015530 <ftable+0xfb8>
    if(f->ref == 0){
    800039dc:	40dc                	lw	a5,4(s1)
    800039de:	cf99                	beqz	a5,800039fc <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e0:	02848493          	addi	s1,s1,40
    800039e4:	fee49ce3          	bne	s1,a4,800039dc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039e8:	00011517          	auipc	a0,0x11
    800039ec:	b9050513          	addi	a0,a0,-1136 # 80014578 <ftable>
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	9d6080e7          	jalr	-1578(ra) # 800063c6 <release>
  return 0;
    800039f8:	4481                	li	s1,0
    800039fa:	a819                	j	80003a10 <filealloc+0x5e>
      f->ref = 1;
    800039fc:	4785                	li	a5,1
    800039fe:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a00:	00011517          	auipc	a0,0x11
    80003a04:	b7850513          	addi	a0,a0,-1160 # 80014578 <ftable>
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	9be080e7          	jalr	-1602(ra) # 800063c6 <release>
}
    80003a10:	8526                	mv	a0,s1
    80003a12:	60e2                	ld	ra,24(sp)
    80003a14:	6442                	ld	s0,16(sp)
    80003a16:	64a2                	ld	s1,8(sp)
    80003a18:	6105                	addi	sp,sp,32
    80003a1a:	8082                	ret

0000000080003a1c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a1c:	1101                	addi	sp,sp,-32
    80003a1e:	ec06                	sd	ra,24(sp)
    80003a20:	e822                	sd	s0,16(sp)
    80003a22:	e426                	sd	s1,8(sp)
    80003a24:	1000                	addi	s0,sp,32
    80003a26:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a28:	00011517          	auipc	a0,0x11
    80003a2c:	b5050513          	addi	a0,a0,-1200 # 80014578 <ftable>
    80003a30:	00003097          	auipc	ra,0x3
    80003a34:	8e2080e7          	jalr	-1822(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003a38:	40dc                	lw	a5,4(s1)
    80003a3a:	02f05263          	blez	a5,80003a5e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a3e:	2785                	addiw	a5,a5,1
    80003a40:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a42:	00011517          	auipc	a0,0x11
    80003a46:	b3650513          	addi	a0,a0,-1226 # 80014578 <ftable>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	97c080e7          	jalr	-1668(ra) # 800063c6 <release>
  return f;
}
    80003a52:	8526                	mv	a0,s1
    80003a54:	60e2                	ld	ra,24(sp)
    80003a56:	6442                	ld	s0,16(sp)
    80003a58:	64a2                	ld	s1,8(sp)
    80003a5a:	6105                	addi	sp,sp,32
    80003a5c:	8082                	ret
    panic("filedup");
    80003a5e:	00005517          	auipc	a0,0x5
    80003a62:	bb250513          	addi	a0,a0,-1102 # 80008610 <syscalls+0x248>
    80003a66:	00002097          	auipc	ra,0x2
    80003a6a:	362080e7          	jalr	866(ra) # 80005dc8 <panic>

0000000080003a6e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a6e:	7139                	addi	sp,sp,-64
    80003a70:	fc06                	sd	ra,56(sp)
    80003a72:	f822                	sd	s0,48(sp)
    80003a74:	f426                	sd	s1,40(sp)
    80003a76:	f04a                	sd	s2,32(sp)
    80003a78:	ec4e                	sd	s3,24(sp)
    80003a7a:	e852                	sd	s4,16(sp)
    80003a7c:	e456                	sd	s5,8(sp)
    80003a7e:	0080                	addi	s0,sp,64
    80003a80:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a82:	00011517          	auipc	a0,0x11
    80003a86:	af650513          	addi	a0,a0,-1290 # 80014578 <ftable>
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	888080e7          	jalr	-1912(ra) # 80006312 <acquire>
  if(f->ref < 1)
    80003a92:	40dc                	lw	a5,4(s1)
    80003a94:	06f05163          	blez	a5,80003af6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a98:	37fd                	addiw	a5,a5,-1
    80003a9a:	0007871b          	sext.w	a4,a5
    80003a9e:	c0dc                	sw	a5,4(s1)
    80003aa0:	06e04363          	bgtz	a4,80003b06 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aa4:	0004a903          	lw	s2,0(s1)
    80003aa8:	0094ca83          	lbu	s5,9(s1)
    80003aac:	0104ba03          	ld	s4,16(s1)
    80003ab0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ab4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ab8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003abc:	00011517          	auipc	a0,0x11
    80003ac0:	abc50513          	addi	a0,a0,-1348 # 80014578 <ftable>
    80003ac4:	00003097          	auipc	ra,0x3
    80003ac8:	902080e7          	jalr	-1790(ra) # 800063c6 <release>

  if(ff.type == FD_PIPE){
    80003acc:	4785                	li	a5,1
    80003ace:	04f90d63          	beq	s2,a5,80003b28 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ad2:	3979                	addiw	s2,s2,-2
    80003ad4:	4785                	li	a5,1
    80003ad6:	0527e063          	bltu	a5,s2,80003b16 <fileclose+0xa8>
    begin_op();
    80003ada:	00000097          	auipc	ra,0x0
    80003ade:	ac8080e7          	jalr	-1336(ra) # 800035a2 <begin_op>
    iput(ff.ip);
    80003ae2:	854e                	mv	a0,s3
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	2a4080e7          	jalr	676(ra) # 80002d88 <iput>
    end_op();
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	b36080e7          	jalr	-1226(ra) # 80003622 <end_op>
    80003af4:	a00d                	j	80003b16 <fileclose+0xa8>
    panic("fileclose");
    80003af6:	00005517          	auipc	a0,0x5
    80003afa:	b2250513          	addi	a0,a0,-1246 # 80008618 <syscalls+0x250>
    80003afe:	00002097          	auipc	ra,0x2
    80003b02:	2ca080e7          	jalr	714(ra) # 80005dc8 <panic>
    release(&ftable.lock);
    80003b06:	00011517          	auipc	a0,0x11
    80003b0a:	a7250513          	addi	a0,a0,-1422 # 80014578 <ftable>
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	8b8080e7          	jalr	-1864(ra) # 800063c6 <release>
  }
}
    80003b16:	70e2                	ld	ra,56(sp)
    80003b18:	7442                	ld	s0,48(sp)
    80003b1a:	74a2                	ld	s1,40(sp)
    80003b1c:	7902                	ld	s2,32(sp)
    80003b1e:	69e2                	ld	s3,24(sp)
    80003b20:	6a42                	ld	s4,16(sp)
    80003b22:	6aa2                	ld	s5,8(sp)
    80003b24:	6121                	addi	sp,sp,64
    80003b26:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b28:	85d6                	mv	a1,s5
    80003b2a:	8552                	mv	a0,s4
    80003b2c:	00000097          	auipc	ra,0x0
    80003b30:	34c080e7          	jalr	844(ra) # 80003e78 <pipeclose>
    80003b34:	b7cd                	j	80003b16 <fileclose+0xa8>

0000000080003b36 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b36:	715d                	addi	sp,sp,-80
    80003b38:	e486                	sd	ra,72(sp)
    80003b3a:	e0a2                	sd	s0,64(sp)
    80003b3c:	fc26                	sd	s1,56(sp)
    80003b3e:	f84a                	sd	s2,48(sp)
    80003b40:	f44e                	sd	s3,40(sp)
    80003b42:	0880                	addi	s0,sp,80
    80003b44:	84aa                	mv	s1,a0
    80003b46:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b48:	ffffd097          	auipc	ra,0xffffd
    80003b4c:	300080e7          	jalr	768(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b50:	409c                	lw	a5,0(s1)
    80003b52:	37f9                	addiw	a5,a5,-2
    80003b54:	4705                	li	a4,1
    80003b56:	04f76763          	bltu	a4,a5,80003ba4 <filestat+0x6e>
    80003b5a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b5c:	6c88                	ld	a0,24(s1)
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	fca080e7          	jalr	-54(ra) # 80002b28 <ilock>
    stati(f->ip, &st);
    80003b66:	fb840593          	addi	a1,s0,-72
    80003b6a:	6c88                	ld	a0,24(s1)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	2ec080e7          	jalr	748(ra) # 80002e58 <stati>
    iunlock(f->ip);
    80003b74:	6c88                	ld	a0,24(s1)
    80003b76:	fffff097          	auipc	ra,0xfffff
    80003b7a:	074080e7          	jalr	116(ra) # 80002bea <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b7e:	46e1                	li	a3,24
    80003b80:	fb840613          	addi	a2,s0,-72
    80003b84:	85ce                	mv	a1,s3
    80003b86:	05093503          	ld	a0,80(s2)
    80003b8a:	ffffd097          	auipc	ra,0xffffd
    80003b8e:	f80080e7          	jalr	-128(ra) # 80000b0a <copyout>
    80003b92:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b96:	60a6                	ld	ra,72(sp)
    80003b98:	6406                	ld	s0,64(sp)
    80003b9a:	74e2                	ld	s1,56(sp)
    80003b9c:	7942                	ld	s2,48(sp)
    80003b9e:	79a2                	ld	s3,40(sp)
    80003ba0:	6161                	addi	sp,sp,80
    80003ba2:	8082                	ret
  return -1;
    80003ba4:	557d                	li	a0,-1
    80003ba6:	bfc5                	j	80003b96 <filestat+0x60>

0000000080003ba8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ba8:	7179                	addi	sp,sp,-48
    80003baa:	f406                	sd	ra,40(sp)
    80003bac:	f022                	sd	s0,32(sp)
    80003bae:	ec26                	sd	s1,24(sp)
    80003bb0:	e84a                	sd	s2,16(sp)
    80003bb2:	e44e                	sd	s3,8(sp)
    80003bb4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bb6:	00854783          	lbu	a5,8(a0)
    80003bba:	c3d5                	beqz	a5,80003c5e <fileread+0xb6>
    80003bbc:	84aa                	mv	s1,a0
    80003bbe:	89ae                	mv	s3,a1
    80003bc0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bc2:	411c                	lw	a5,0(a0)
    80003bc4:	4705                	li	a4,1
    80003bc6:	04e78963          	beq	a5,a4,80003c18 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bca:	470d                	li	a4,3
    80003bcc:	04e78d63          	beq	a5,a4,80003c26 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd0:	4709                	li	a4,2
    80003bd2:	06e79e63          	bne	a5,a4,80003c4e <fileread+0xa6>
    ilock(f->ip);
    80003bd6:	6d08                	ld	a0,24(a0)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	f50080e7          	jalr	-176(ra) # 80002b28 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003be0:	874a                	mv	a4,s2
    80003be2:	5094                	lw	a3,32(s1)
    80003be4:	864e                	mv	a2,s3
    80003be6:	4585                	li	a1,1
    80003be8:	6c88                	ld	a0,24(s1)
    80003bea:	fffff097          	auipc	ra,0xfffff
    80003bee:	298080e7          	jalr	664(ra) # 80002e82 <readi>
    80003bf2:	892a                	mv	s2,a0
    80003bf4:	00a05563          	blez	a0,80003bfe <fileread+0x56>
      f->off += r;
    80003bf8:	509c                	lw	a5,32(s1)
    80003bfa:	9fa9                	addw	a5,a5,a0
    80003bfc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bfe:	6c88                	ld	a0,24(s1)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	fea080e7          	jalr	-22(ra) # 80002bea <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c08:	854a                	mv	a0,s2
    80003c0a:	70a2                	ld	ra,40(sp)
    80003c0c:	7402                	ld	s0,32(sp)
    80003c0e:	64e2                	ld	s1,24(sp)
    80003c10:	6942                	ld	s2,16(sp)
    80003c12:	69a2                	ld	s3,8(sp)
    80003c14:	6145                	addi	sp,sp,48
    80003c16:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c18:	6908                	ld	a0,16(a0)
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	3c8080e7          	jalr	968(ra) # 80003fe2 <piperead>
    80003c22:	892a                	mv	s2,a0
    80003c24:	b7d5                	j	80003c08 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c26:	02451783          	lh	a5,36(a0)
    80003c2a:	03079693          	slli	a3,a5,0x30
    80003c2e:	92c1                	srli	a3,a3,0x30
    80003c30:	4725                	li	a4,9
    80003c32:	02d76863          	bltu	a4,a3,80003c62 <fileread+0xba>
    80003c36:	0792                	slli	a5,a5,0x4
    80003c38:	00011717          	auipc	a4,0x11
    80003c3c:	8a070713          	addi	a4,a4,-1888 # 800144d8 <devsw>
    80003c40:	97ba                	add	a5,a5,a4
    80003c42:	639c                	ld	a5,0(a5)
    80003c44:	c38d                	beqz	a5,80003c66 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c46:	4505                	li	a0,1
    80003c48:	9782                	jalr	a5
    80003c4a:	892a                	mv	s2,a0
    80003c4c:	bf75                	j	80003c08 <fileread+0x60>
    panic("fileread");
    80003c4e:	00005517          	auipc	a0,0x5
    80003c52:	9da50513          	addi	a0,a0,-1574 # 80008628 <syscalls+0x260>
    80003c56:	00002097          	auipc	ra,0x2
    80003c5a:	172080e7          	jalr	370(ra) # 80005dc8 <panic>
    return -1;
    80003c5e:	597d                	li	s2,-1
    80003c60:	b765                	j	80003c08 <fileread+0x60>
      return -1;
    80003c62:	597d                	li	s2,-1
    80003c64:	b755                	j	80003c08 <fileread+0x60>
    80003c66:	597d                	li	s2,-1
    80003c68:	b745                	j	80003c08 <fileread+0x60>

0000000080003c6a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c6a:	715d                	addi	sp,sp,-80
    80003c6c:	e486                	sd	ra,72(sp)
    80003c6e:	e0a2                	sd	s0,64(sp)
    80003c70:	fc26                	sd	s1,56(sp)
    80003c72:	f84a                	sd	s2,48(sp)
    80003c74:	f44e                	sd	s3,40(sp)
    80003c76:	f052                	sd	s4,32(sp)
    80003c78:	ec56                	sd	s5,24(sp)
    80003c7a:	e85a                	sd	s6,16(sp)
    80003c7c:	e45e                	sd	s7,8(sp)
    80003c7e:	e062                	sd	s8,0(sp)
    80003c80:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c82:	00954783          	lbu	a5,9(a0)
    80003c86:	10078663          	beqz	a5,80003d92 <filewrite+0x128>
    80003c8a:	892a                	mv	s2,a0
    80003c8c:	8aae                	mv	s5,a1
    80003c8e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c90:	411c                	lw	a5,0(a0)
    80003c92:	4705                	li	a4,1
    80003c94:	02e78263          	beq	a5,a4,80003cb8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c98:	470d                	li	a4,3
    80003c9a:	02e78663          	beq	a5,a4,80003cc6 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c9e:	4709                	li	a4,2
    80003ca0:	0ee79163          	bne	a5,a4,80003d82 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ca4:	0ac05d63          	blez	a2,80003d5e <filewrite+0xf4>
    int i = 0;
    80003ca8:	4981                	li	s3,0
    80003caa:	6b05                	lui	s6,0x1
    80003cac:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cb0:	6b85                	lui	s7,0x1
    80003cb2:	c00b8b9b          	addiw	s7,s7,-1024
    80003cb6:	a861                	j	80003d4e <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cb8:	6908                	ld	a0,16(a0)
    80003cba:	00000097          	auipc	ra,0x0
    80003cbe:	22e080e7          	jalr	558(ra) # 80003ee8 <pipewrite>
    80003cc2:	8a2a                	mv	s4,a0
    80003cc4:	a045                	j	80003d64 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cc6:	02451783          	lh	a5,36(a0)
    80003cca:	03079693          	slli	a3,a5,0x30
    80003cce:	92c1                	srli	a3,a3,0x30
    80003cd0:	4725                	li	a4,9
    80003cd2:	0cd76263          	bltu	a4,a3,80003d96 <filewrite+0x12c>
    80003cd6:	0792                	slli	a5,a5,0x4
    80003cd8:	00011717          	auipc	a4,0x11
    80003cdc:	80070713          	addi	a4,a4,-2048 # 800144d8 <devsw>
    80003ce0:	97ba                	add	a5,a5,a4
    80003ce2:	679c                	ld	a5,8(a5)
    80003ce4:	cbdd                	beqz	a5,80003d9a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ce6:	4505                	li	a0,1
    80003ce8:	9782                	jalr	a5
    80003cea:	8a2a                	mv	s4,a0
    80003cec:	a8a5                	j	80003d64 <filewrite+0xfa>
    80003cee:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	8b0080e7          	jalr	-1872(ra) # 800035a2 <begin_op>
      ilock(f->ip);
    80003cfa:	01893503          	ld	a0,24(s2)
    80003cfe:	fffff097          	auipc	ra,0xfffff
    80003d02:	e2a080e7          	jalr	-470(ra) # 80002b28 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d06:	8762                	mv	a4,s8
    80003d08:	02092683          	lw	a3,32(s2)
    80003d0c:	01598633          	add	a2,s3,s5
    80003d10:	4585                	li	a1,1
    80003d12:	01893503          	ld	a0,24(s2)
    80003d16:	fffff097          	auipc	ra,0xfffff
    80003d1a:	264080e7          	jalr	612(ra) # 80002f7a <writei>
    80003d1e:	84aa                	mv	s1,a0
    80003d20:	00a05763          	blez	a0,80003d2e <filewrite+0xc4>
        f->off += r;
    80003d24:	02092783          	lw	a5,32(s2)
    80003d28:	9fa9                	addw	a5,a5,a0
    80003d2a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d2e:	01893503          	ld	a0,24(s2)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	eb8080e7          	jalr	-328(ra) # 80002bea <iunlock>
      end_op();
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	8e8080e7          	jalr	-1816(ra) # 80003622 <end_op>

      if(r != n1){
    80003d42:	009c1f63          	bne	s8,s1,80003d60 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d46:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d4a:	0149db63          	bge	s3,s4,80003d60 <filewrite+0xf6>
      int n1 = n - i;
    80003d4e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d52:	84be                	mv	s1,a5
    80003d54:	2781                	sext.w	a5,a5
    80003d56:	f8fb5ce3          	bge	s6,a5,80003cee <filewrite+0x84>
    80003d5a:	84de                	mv	s1,s7
    80003d5c:	bf49                	j	80003cee <filewrite+0x84>
    int i = 0;
    80003d5e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d60:	013a1f63          	bne	s4,s3,80003d7e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d64:	8552                	mv	a0,s4
    80003d66:	60a6                	ld	ra,72(sp)
    80003d68:	6406                	ld	s0,64(sp)
    80003d6a:	74e2                	ld	s1,56(sp)
    80003d6c:	7942                	ld	s2,48(sp)
    80003d6e:	79a2                	ld	s3,40(sp)
    80003d70:	7a02                	ld	s4,32(sp)
    80003d72:	6ae2                	ld	s5,24(sp)
    80003d74:	6b42                	ld	s6,16(sp)
    80003d76:	6ba2                	ld	s7,8(sp)
    80003d78:	6c02                	ld	s8,0(sp)
    80003d7a:	6161                	addi	sp,sp,80
    80003d7c:	8082                	ret
    ret = (i == n ? n : -1);
    80003d7e:	5a7d                	li	s4,-1
    80003d80:	b7d5                	j	80003d64 <filewrite+0xfa>
    panic("filewrite");
    80003d82:	00005517          	auipc	a0,0x5
    80003d86:	8b650513          	addi	a0,a0,-1866 # 80008638 <syscalls+0x270>
    80003d8a:	00002097          	auipc	ra,0x2
    80003d8e:	03e080e7          	jalr	62(ra) # 80005dc8 <panic>
    return -1;
    80003d92:	5a7d                	li	s4,-1
    80003d94:	bfc1                	j	80003d64 <filewrite+0xfa>
      return -1;
    80003d96:	5a7d                	li	s4,-1
    80003d98:	b7f1                	j	80003d64 <filewrite+0xfa>
    80003d9a:	5a7d                	li	s4,-1
    80003d9c:	b7e1                	j	80003d64 <filewrite+0xfa>

0000000080003d9e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d9e:	7179                	addi	sp,sp,-48
    80003da0:	f406                	sd	ra,40(sp)
    80003da2:	f022                	sd	s0,32(sp)
    80003da4:	ec26                	sd	s1,24(sp)
    80003da6:	e84a                	sd	s2,16(sp)
    80003da8:	e44e                	sd	s3,8(sp)
    80003daa:	e052                	sd	s4,0(sp)
    80003dac:	1800                	addi	s0,sp,48
    80003dae:	84aa                	mv	s1,a0
    80003db0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003db2:	0005b023          	sd	zero,0(a1)
    80003db6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	bf8080e7          	jalr	-1032(ra) # 800039b2 <filealloc>
    80003dc2:	e088                	sd	a0,0(s1)
    80003dc4:	c551                	beqz	a0,80003e50 <pipealloc+0xb2>
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	bec080e7          	jalr	-1044(ra) # 800039b2 <filealloc>
    80003dce:	00aa3023          	sd	a0,0(s4)
    80003dd2:	c92d                	beqz	a0,80003e44 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dd4:	ffffc097          	auipc	ra,0xffffc
    80003dd8:	344080e7          	jalr	836(ra) # 80000118 <kalloc>
    80003ddc:	892a                	mv	s2,a0
    80003dde:	c125                	beqz	a0,80003e3e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003de0:	4985                	li	s3,1
    80003de2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003de6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dea:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dee:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003df2:	00005597          	auipc	a1,0x5
    80003df6:	85658593          	addi	a1,a1,-1962 # 80008648 <syscalls+0x280>
    80003dfa:	00002097          	auipc	ra,0x2
    80003dfe:	488080e7          	jalr	1160(ra) # 80006282 <initlock>
  (*f0)->type = FD_PIPE;
    80003e02:	609c                	ld	a5,0(s1)
    80003e04:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e08:	609c                	ld	a5,0(s1)
    80003e0a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e0e:	609c                	ld	a5,0(s1)
    80003e10:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e14:	609c                	ld	a5,0(s1)
    80003e16:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e1a:	000a3783          	ld	a5,0(s4)
    80003e1e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e22:	000a3783          	ld	a5,0(s4)
    80003e26:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e2a:	000a3783          	ld	a5,0(s4)
    80003e2e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e32:	000a3783          	ld	a5,0(s4)
    80003e36:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e3a:	4501                	li	a0,0
    80003e3c:	a025                	j	80003e64 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e3e:	6088                	ld	a0,0(s1)
    80003e40:	e501                	bnez	a0,80003e48 <pipealloc+0xaa>
    80003e42:	a039                	j	80003e50 <pipealloc+0xb2>
    80003e44:	6088                	ld	a0,0(s1)
    80003e46:	c51d                	beqz	a0,80003e74 <pipealloc+0xd6>
    fileclose(*f0);
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	c26080e7          	jalr	-986(ra) # 80003a6e <fileclose>
  if(*f1)
    80003e50:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e54:	557d                	li	a0,-1
  if(*f1)
    80003e56:	c799                	beqz	a5,80003e64 <pipealloc+0xc6>
    fileclose(*f1);
    80003e58:	853e                	mv	a0,a5
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	c14080e7          	jalr	-1004(ra) # 80003a6e <fileclose>
  return -1;
    80003e62:	557d                	li	a0,-1
}
    80003e64:	70a2                	ld	ra,40(sp)
    80003e66:	7402                	ld	s0,32(sp)
    80003e68:	64e2                	ld	s1,24(sp)
    80003e6a:	6942                	ld	s2,16(sp)
    80003e6c:	69a2                	ld	s3,8(sp)
    80003e6e:	6a02                	ld	s4,0(sp)
    80003e70:	6145                	addi	sp,sp,48
    80003e72:	8082                	ret
  return -1;
    80003e74:	557d                	li	a0,-1
    80003e76:	b7fd                	j	80003e64 <pipealloc+0xc6>

0000000080003e78 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e78:	1101                	addi	sp,sp,-32
    80003e7a:	ec06                	sd	ra,24(sp)
    80003e7c:	e822                	sd	s0,16(sp)
    80003e7e:	e426                	sd	s1,8(sp)
    80003e80:	e04a                	sd	s2,0(sp)
    80003e82:	1000                	addi	s0,sp,32
    80003e84:	84aa                	mv	s1,a0
    80003e86:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e88:	00002097          	auipc	ra,0x2
    80003e8c:	48a080e7          	jalr	1162(ra) # 80006312 <acquire>
  if(writable){
    80003e90:	02090d63          	beqz	s2,80003eca <pipeclose+0x52>
    pi->writeopen = 0;
    80003e94:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e98:	21848513          	addi	a0,s1,536
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	7f4080e7          	jalr	2036(ra) # 80001690 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ea4:	2204b783          	ld	a5,544(s1)
    80003ea8:	eb95                	bnez	a5,80003edc <pipeclose+0x64>
    release(&pi->lock);
    80003eaa:	8526                	mv	a0,s1
    80003eac:	00002097          	auipc	ra,0x2
    80003eb0:	51a080e7          	jalr	1306(ra) # 800063c6 <release>
    kfree((char*)pi);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	ffffc097          	auipc	ra,0xffffc
    80003eba:	166080e7          	jalr	358(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ebe:	60e2                	ld	ra,24(sp)
    80003ec0:	6442                	ld	s0,16(sp)
    80003ec2:	64a2                	ld	s1,8(sp)
    80003ec4:	6902                	ld	s2,0(sp)
    80003ec6:	6105                	addi	sp,sp,32
    80003ec8:	8082                	ret
    pi->readopen = 0;
    80003eca:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ece:	21c48513          	addi	a0,s1,540
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	7be080e7          	jalr	1982(ra) # 80001690 <wakeup>
    80003eda:	b7e9                	j	80003ea4 <pipeclose+0x2c>
    release(&pi->lock);
    80003edc:	8526                	mv	a0,s1
    80003ede:	00002097          	auipc	ra,0x2
    80003ee2:	4e8080e7          	jalr	1256(ra) # 800063c6 <release>
}
    80003ee6:	bfe1                	j	80003ebe <pipeclose+0x46>

0000000080003ee8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ee8:	7159                	addi	sp,sp,-112
    80003eea:	f486                	sd	ra,104(sp)
    80003eec:	f0a2                	sd	s0,96(sp)
    80003eee:	eca6                	sd	s1,88(sp)
    80003ef0:	e8ca                	sd	s2,80(sp)
    80003ef2:	e4ce                	sd	s3,72(sp)
    80003ef4:	e0d2                	sd	s4,64(sp)
    80003ef6:	fc56                	sd	s5,56(sp)
    80003ef8:	f85a                	sd	s6,48(sp)
    80003efa:	f45e                	sd	s7,40(sp)
    80003efc:	f062                	sd	s8,32(sp)
    80003efe:	ec66                	sd	s9,24(sp)
    80003f00:	1880                	addi	s0,sp,112
    80003f02:	84aa                	mv	s1,a0
    80003f04:	8aae                	mv	s5,a1
    80003f06:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	f40080e7          	jalr	-192(ra) # 80000e48 <myproc>
    80003f10:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f12:	8526                	mv	a0,s1
    80003f14:	00002097          	auipc	ra,0x2
    80003f18:	3fe080e7          	jalr	1022(ra) # 80006312 <acquire>
  while(i < n){
    80003f1c:	0d405163          	blez	s4,80003fde <pipewrite+0xf6>
    80003f20:	8ba6                	mv	s7,s1
  int i = 0;
    80003f22:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f24:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f26:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f2a:	21c48c13          	addi	s8,s1,540
    80003f2e:	a08d                	j	80003f90 <pipewrite+0xa8>
      release(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	494080e7          	jalr	1172(ra) # 800063c6 <release>
      return -1;
    80003f3a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f3c:	854a                	mv	a0,s2
    80003f3e:	70a6                	ld	ra,104(sp)
    80003f40:	7406                	ld	s0,96(sp)
    80003f42:	64e6                	ld	s1,88(sp)
    80003f44:	6946                	ld	s2,80(sp)
    80003f46:	69a6                	ld	s3,72(sp)
    80003f48:	6a06                	ld	s4,64(sp)
    80003f4a:	7ae2                	ld	s5,56(sp)
    80003f4c:	7b42                	ld	s6,48(sp)
    80003f4e:	7ba2                	ld	s7,40(sp)
    80003f50:	7c02                	ld	s8,32(sp)
    80003f52:	6ce2                	ld	s9,24(sp)
    80003f54:	6165                	addi	sp,sp,112
    80003f56:	8082                	ret
      wakeup(&pi->nread);
    80003f58:	8566                	mv	a0,s9
    80003f5a:	ffffd097          	auipc	ra,0xffffd
    80003f5e:	736080e7          	jalr	1846(ra) # 80001690 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f62:	85de                	mv	a1,s7
    80003f64:	8562                	mv	a0,s8
    80003f66:	ffffd097          	auipc	ra,0xffffd
    80003f6a:	59e080e7          	jalr	1438(ra) # 80001504 <sleep>
    80003f6e:	a839                	j	80003f8c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f70:	21c4a783          	lw	a5,540(s1)
    80003f74:	0017871b          	addiw	a4,a5,1
    80003f78:	20e4ae23          	sw	a4,540(s1)
    80003f7c:	1ff7f793          	andi	a5,a5,511
    80003f80:	97a6                	add	a5,a5,s1
    80003f82:	f9f44703          	lbu	a4,-97(s0)
    80003f86:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f8a:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f8c:	03495d63          	bge	s2,s4,80003fc6 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f90:	2204a783          	lw	a5,544(s1)
    80003f94:	dfd1                	beqz	a5,80003f30 <pipewrite+0x48>
    80003f96:	0289a783          	lw	a5,40(s3)
    80003f9a:	fbd9                	bnez	a5,80003f30 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f9c:	2184a783          	lw	a5,536(s1)
    80003fa0:	21c4a703          	lw	a4,540(s1)
    80003fa4:	2007879b          	addiw	a5,a5,512
    80003fa8:	faf708e3          	beq	a4,a5,80003f58 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fac:	4685                	li	a3,1
    80003fae:	01590633          	add	a2,s2,s5
    80003fb2:	f9f40593          	addi	a1,s0,-97
    80003fb6:	0509b503          	ld	a0,80(s3)
    80003fba:	ffffd097          	auipc	ra,0xffffd
    80003fbe:	bdc080e7          	jalr	-1060(ra) # 80000b96 <copyin>
    80003fc2:	fb6517e3          	bne	a0,s6,80003f70 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fc6:	21848513          	addi	a0,s1,536
    80003fca:	ffffd097          	auipc	ra,0xffffd
    80003fce:	6c6080e7          	jalr	1734(ra) # 80001690 <wakeup>
  release(&pi->lock);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	00002097          	auipc	ra,0x2
    80003fd8:	3f2080e7          	jalr	1010(ra) # 800063c6 <release>
  return i;
    80003fdc:	b785                	j	80003f3c <pipewrite+0x54>
  int i = 0;
    80003fde:	4901                	li	s2,0
    80003fe0:	b7dd                	j	80003fc6 <pipewrite+0xde>

0000000080003fe2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fe2:	715d                	addi	sp,sp,-80
    80003fe4:	e486                	sd	ra,72(sp)
    80003fe6:	e0a2                	sd	s0,64(sp)
    80003fe8:	fc26                	sd	s1,56(sp)
    80003fea:	f84a                	sd	s2,48(sp)
    80003fec:	f44e                	sd	s3,40(sp)
    80003fee:	f052                	sd	s4,32(sp)
    80003ff0:	ec56                	sd	s5,24(sp)
    80003ff2:	e85a                	sd	s6,16(sp)
    80003ff4:	0880                	addi	s0,sp,80
    80003ff6:	84aa                	mv	s1,a0
    80003ff8:	892e                	mv	s2,a1
    80003ffa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	e4c080e7          	jalr	-436(ra) # 80000e48 <myproc>
    80004004:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004006:	8b26                	mv	s6,s1
    80004008:	8526                	mv	a0,s1
    8000400a:	00002097          	auipc	ra,0x2
    8000400e:	308080e7          	jalr	776(ra) # 80006312 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004012:	2184a703          	lw	a4,536(s1)
    80004016:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000401a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401e:	02f71463          	bne	a4,a5,80004046 <piperead+0x64>
    80004022:	2244a783          	lw	a5,548(s1)
    80004026:	c385                	beqz	a5,80004046 <piperead+0x64>
    if(pr->killed){
    80004028:	028a2783          	lw	a5,40(s4)
    8000402c:	ebc1                	bnez	a5,800040bc <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000402e:	85da                	mv	a1,s6
    80004030:	854e                	mv	a0,s3
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	4d2080e7          	jalr	1234(ra) # 80001504 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403a:	2184a703          	lw	a4,536(s1)
    8000403e:	21c4a783          	lw	a5,540(s1)
    80004042:	fef700e3          	beq	a4,a5,80004022 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004046:	09505263          	blez	s5,800040ca <piperead+0xe8>
    8000404a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000404c:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000404e:	2184a783          	lw	a5,536(s1)
    80004052:	21c4a703          	lw	a4,540(s1)
    80004056:	02f70d63          	beq	a4,a5,80004090 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000405a:	0017871b          	addiw	a4,a5,1
    8000405e:	20e4ac23          	sw	a4,536(s1)
    80004062:	1ff7f793          	andi	a5,a5,511
    80004066:	97a6                	add	a5,a5,s1
    80004068:	0187c783          	lbu	a5,24(a5)
    8000406c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004070:	4685                	li	a3,1
    80004072:	fbf40613          	addi	a2,s0,-65
    80004076:	85ca                	mv	a1,s2
    80004078:	050a3503          	ld	a0,80(s4)
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	a8e080e7          	jalr	-1394(ra) # 80000b0a <copyout>
    80004084:	01650663          	beq	a0,s6,80004090 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004088:	2985                	addiw	s3,s3,1
    8000408a:	0905                	addi	s2,s2,1
    8000408c:	fd3a91e3          	bne	s5,s3,8000404e <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004090:	21c48513          	addi	a0,s1,540
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	5fc080e7          	jalr	1532(ra) # 80001690 <wakeup>
  release(&pi->lock);
    8000409c:	8526                	mv	a0,s1
    8000409e:	00002097          	auipc	ra,0x2
    800040a2:	328080e7          	jalr	808(ra) # 800063c6 <release>
  return i;
}
    800040a6:	854e                	mv	a0,s3
    800040a8:	60a6                	ld	ra,72(sp)
    800040aa:	6406                	ld	s0,64(sp)
    800040ac:	74e2                	ld	s1,56(sp)
    800040ae:	7942                	ld	s2,48(sp)
    800040b0:	79a2                	ld	s3,40(sp)
    800040b2:	7a02                	ld	s4,32(sp)
    800040b4:	6ae2                	ld	s5,24(sp)
    800040b6:	6b42                	ld	s6,16(sp)
    800040b8:	6161                	addi	sp,sp,80
    800040ba:	8082                	ret
      release(&pi->lock);
    800040bc:	8526                	mv	a0,s1
    800040be:	00002097          	auipc	ra,0x2
    800040c2:	308080e7          	jalr	776(ra) # 800063c6 <release>
      return -1;
    800040c6:	59fd                	li	s3,-1
    800040c8:	bff9                	j	800040a6 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ca:	4981                	li	s3,0
    800040cc:	b7d1                	j	80004090 <piperead+0xae>

00000000800040ce <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040ce:	df010113          	addi	sp,sp,-528
    800040d2:	20113423          	sd	ra,520(sp)
    800040d6:	20813023          	sd	s0,512(sp)
    800040da:	ffa6                	sd	s1,504(sp)
    800040dc:	fbca                	sd	s2,496(sp)
    800040de:	f7ce                	sd	s3,488(sp)
    800040e0:	f3d2                	sd	s4,480(sp)
    800040e2:	efd6                	sd	s5,472(sp)
    800040e4:	ebda                	sd	s6,464(sp)
    800040e6:	e7de                	sd	s7,456(sp)
    800040e8:	e3e2                	sd	s8,448(sp)
    800040ea:	ff66                	sd	s9,440(sp)
    800040ec:	fb6a                	sd	s10,432(sp)
    800040ee:	f76e                	sd	s11,424(sp)
    800040f0:	0c00                	addi	s0,sp,528
    800040f2:	84aa                	mv	s1,a0
    800040f4:	dea43c23          	sd	a0,-520(s0)
    800040f8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	d4c080e7          	jalr	-692(ra) # 80000e48 <myproc>
    80004104:	892a                	mv	s2,a0

  begin_op();
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	49c080e7          	jalr	1180(ra) # 800035a2 <begin_op>

  if((ip = namei(path)) == 0){
    8000410e:	8526                	mv	a0,s1
    80004110:	fffff097          	auipc	ra,0xfffff
    80004114:	276080e7          	jalr	630(ra) # 80003386 <namei>
    80004118:	c92d                	beqz	a0,8000418a <exec+0xbc>
    8000411a:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	a0c080e7          	jalr	-1524(ra) # 80002b28 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004124:	04000713          	li	a4,64
    80004128:	4681                	li	a3,0
    8000412a:	e5040613          	addi	a2,s0,-432
    8000412e:	4581                	li	a1,0
    80004130:	8526                	mv	a0,s1
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	d50080e7          	jalr	-688(ra) # 80002e82 <readi>
    8000413a:	04000793          	li	a5,64
    8000413e:	00f51a63          	bne	a0,a5,80004152 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004142:	e5042703          	lw	a4,-432(s0)
    80004146:	464c47b7          	lui	a5,0x464c4
    8000414a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000414e:	04f70463          	beq	a4,a5,80004196 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004152:	8526                	mv	a0,s1
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	cdc080e7          	jalr	-804(ra) # 80002e30 <iunlockput>
    end_op();
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	4c6080e7          	jalr	1222(ra) # 80003622 <end_op>
  }
  return -1;
    80004164:	557d                	li	a0,-1
}
    80004166:	20813083          	ld	ra,520(sp)
    8000416a:	20013403          	ld	s0,512(sp)
    8000416e:	74fe                	ld	s1,504(sp)
    80004170:	795e                	ld	s2,496(sp)
    80004172:	79be                	ld	s3,488(sp)
    80004174:	7a1e                	ld	s4,480(sp)
    80004176:	6afe                	ld	s5,472(sp)
    80004178:	6b5e                	ld	s6,464(sp)
    8000417a:	6bbe                	ld	s7,456(sp)
    8000417c:	6c1e                	ld	s8,448(sp)
    8000417e:	7cfa                	ld	s9,440(sp)
    80004180:	7d5a                	ld	s10,432(sp)
    80004182:	7dba                	ld	s11,424(sp)
    80004184:	21010113          	addi	sp,sp,528
    80004188:	8082                	ret
    end_op();
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	498080e7          	jalr	1176(ra) # 80003622 <end_op>
    return -1;
    80004192:	557d                	li	a0,-1
    80004194:	bfc9                	j	80004166 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004196:	854a                	mv	a0,s2
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	d74080e7          	jalr	-652(ra) # 80000f0c <proc_pagetable>
    800041a0:	8baa                	mv	s7,a0
    800041a2:	d945                	beqz	a0,80004152 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a4:	e7042983          	lw	s3,-400(s0)
    800041a8:	e8845783          	lhu	a5,-376(s0)
    800041ac:	c7ad                	beqz	a5,80004216 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ae:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b0:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041b2:	6c85                	lui	s9,0x1
    800041b4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041b8:	def43823          	sd	a5,-528(s0)
    800041bc:	a42d                	j	800043e6 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041be:	00004517          	auipc	a0,0x4
    800041c2:	49250513          	addi	a0,a0,1170 # 80008650 <syscalls+0x288>
    800041c6:	00002097          	auipc	ra,0x2
    800041ca:	c02080e7          	jalr	-1022(ra) # 80005dc8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ce:	8756                	mv	a4,s5
    800041d0:	012d86bb          	addw	a3,s11,s2
    800041d4:	4581                	li	a1,0
    800041d6:	8526                	mv	a0,s1
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	caa080e7          	jalr	-854(ra) # 80002e82 <readi>
    800041e0:	2501                	sext.w	a0,a0
    800041e2:	1aaa9963          	bne	s5,a0,80004394 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041e6:	6785                	lui	a5,0x1
    800041e8:	0127893b          	addw	s2,a5,s2
    800041ec:	77fd                	lui	a5,0xfffff
    800041ee:	01478a3b          	addw	s4,a5,s4
    800041f2:	1f897163          	bgeu	s2,s8,800043d4 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041f6:	02091593          	slli	a1,s2,0x20
    800041fa:	9181                	srli	a1,a1,0x20
    800041fc:	95ea                	add	a1,a1,s10
    800041fe:	855e                	mv	a0,s7
    80004200:	ffffc097          	auipc	ra,0xffffc
    80004204:	306080e7          	jalr	774(ra) # 80000506 <walkaddr>
    80004208:	862a                	mv	a2,a0
    if(pa == 0)
    8000420a:	d955                	beqz	a0,800041be <exec+0xf0>
      n = PGSIZE;
    8000420c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000420e:	fd9a70e3          	bgeu	s4,s9,800041ce <exec+0x100>
      n = sz - i;
    80004212:	8ad2                	mv	s5,s4
    80004214:	bf6d                	j	800041ce <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004216:	4901                	li	s2,0
  iunlockput(ip);
    80004218:	8526                	mv	a0,s1
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	c16080e7          	jalr	-1002(ra) # 80002e30 <iunlockput>
  end_op();
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	400080e7          	jalr	1024(ra) # 80003622 <end_op>
  p = myproc();
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	c1e080e7          	jalr	-994(ra) # 80000e48 <myproc>
    80004232:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004234:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004238:	6785                	lui	a5,0x1
    8000423a:	17fd                	addi	a5,a5,-1
    8000423c:	993e                	add	s2,s2,a5
    8000423e:	757d                	lui	a0,0xfffff
    80004240:	00a977b3          	and	a5,s2,a0
    80004244:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004248:	6609                	lui	a2,0x2
    8000424a:	963e                	add	a2,a2,a5
    8000424c:	85be                	mv	a1,a5
    8000424e:	855e                	mv	a0,s7
    80004250:	ffffc097          	auipc	ra,0xffffc
    80004254:	66a080e7          	jalr	1642(ra) # 800008ba <uvmalloc>
    80004258:	8b2a                	mv	s6,a0
  ip = 0;
    8000425a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000425c:	12050c63          	beqz	a0,80004394 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004260:	75f9                	lui	a1,0xffffe
    80004262:	95aa                	add	a1,a1,a0
    80004264:	855e                	mv	a0,s7
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	872080e7          	jalr	-1934(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000426e:	7c7d                	lui	s8,0xfffff
    80004270:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004272:	e0043783          	ld	a5,-512(s0)
    80004276:	6388                	ld	a0,0(a5)
    80004278:	c535                	beqz	a0,800042e4 <exec+0x216>
    8000427a:	e9040993          	addi	s3,s0,-368
    8000427e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004282:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004284:	ffffc097          	auipc	ra,0xffffc
    80004288:	078080e7          	jalr	120(ra) # 800002fc <strlen>
    8000428c:	2505                	addiw	a0,a0,1
    8000428e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004292:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004296:	13896363          	bltu	s2,s8,800043bc <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000429a:	e0043d83          	ld	s11,-512(s0)
    8000429e:	000dba03          	ld	s4,0(s11)
    800042a2:	8552                	mv	a0,s4
    800042a4:	ffffc097          	auipc	ra,0xffffc
    800042a8:	058080e7          	jalr	88(ra) # 800002fc <strlen>
    800042ac:	0015069b          	addiw	a3,a0,1
    800042b0:	8652                	mv	a2,s4
    800042b2:	85ca                	mv	a1,s2
    800042b4:	855e                	mv	a0,s7
    800042b6:	ffffd097          	auipc	ra,0xffffd
    800042ba:	854080e7          	jalr	-1964(ra) # 80000b0a <copyout>
    800042be:	10054363          	bltz	a0,800043c4 <exec+0x2f6>
    ustack[argc] = sp;
    800042c2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042c6:	0485                	addi	s1,s1,1
    800042c8:	008d8793          	addi	a5,s11,8
    800042cc:	e0f43023          	sd	a5,-512(s0)
    800042d0:	008db503          	ld	a0,8(s11)
    800042d4:	c911                	beqz	a0,800042e8 <exec+0x21a>
    if(argc >= MAXARG)
    800042d6:	09a1                	addi	s3,s3,8
    800042d8:	fb3c96e3          	bne	s9,s3,80004284 <exec+0x1b6>
  sz = sz1;
    800042dc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042e0:	4481                	li	s1,0
    800042e2:	a84d                	j	80004394 <exec+0x2c6>
  sp = sz;
    800042e4:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042e6:	4481                	li	s1,0
  ustack[argc] = 0;
    800042e8:	00349793          	slli	a5,s1,0x3
    800042ec:	f9040713          	addi	a4,s0,-112
    800042f0:	97ba                	add	a5,a5,a4
    800042f2:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042f6:	00148693          	addi	a3,s1,1
    800042fa:	068e                	slli	a3,a3,0x3
    800042fc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004300:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004304:	01897663          	bgeu	s2,s8,80004310 <exec+0x242>
  sz = sz1;
    80004308:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000430c:	4481                	li	s1,0
    8000430e:	a059                	j	80004394 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004310:	e9040613          	addi	a2,s0,-368
    80004314:	85ca                	mv	a1,s2
    80004316:	855e                	mv	a0,s7
    80004318:	ffffc097          	auipc	ra,0xffffc
    8000431c:	7f2080e7          	jalr	2034(ra) # 80000b0a <copyout>
    80004320:	0a054663          	bltz	a0,800043cc <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004324:	058ab783          	ld	a5,88(s5)
    80004328:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000432c:	df843783          	ld	a5,-520(s0)
    80004330:	0007c703          	lbu	a4,0(a5)
    80004334:	cf11                	beqz	a4,80004350 <exec+0x282>
    80004336:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004338:	02f00693          	li	a3,47
    8000433c:	a039                	j	8000434a <exec+0x27c>
      last = s+1;
    8000433e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004342:	0785                	addi	a5,a5,1
    80004344:	fff7c703          	lbu	a4,-1(a5)
    80004348:	c701                	beqz	a4,80004350 <exec+0x282>
    if(*s == '/')
    8000434a:	fed71ce3          	bne	a4,a3,80004342 <exec+0x274>
    8000434e:	bfc5                	j	8000433e <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004350:	4641                	li	a2,16
    80004352:	df843583          	ld	a1,-520(s0)
    80004356:	158a8513          	addi	a0,s5,344
    8000435a:	ffffc097          	auipc	ra,0xffffc
    8000435e:	f70080e7          	jalr	-144(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004362:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004366:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000436a:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000436e:	058ab783          	ld	a5,88(s5)
    80004372:	e6843703          	ld	a4,-408(s0)
    80004376:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004378:	058ab783          	ld	a5,88(s5)
    8000437c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004380:	85ea                	mv	a1,s10
    80004382:	ffffd097          	auipc	ra,0xffffd
    80004386:	c26080e7          	jalr	-986(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000438a:	0004851b          	sext.w	a0,s1
    8000438e:	bbe1                	j	80004166 <exec+0x98>
    80004390:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004394:	e0843583          	ld	a1,-504(s0)
    80004398:	855e                	mv	a0,s7
    8000439a:	ffffd097          	auipc	ra,0xffffd
    8000439e:	c0e080e7          	jalr	-1010(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    800043a2:	da0498e3          	bnez	s1,80004152 <exec+0x84>
  return -1;
    800043a6:	557d                	li	a0,-1
    800043a8:	bb7d                	j	80004166 <exec+0x98>
    800043aa:	e1243423          	sd	s2,-504(s0)
    800043ae:	b7dd                	j	80004394 <exec+0x2c6>
    800043b0:	e1243423          	sd	s2,-504(s0)
    800043b4:	b7c5                	j	80004394 <exec+0x2c6>
    800043b6:	e1243423          	sd	s2,-504(s0)
    800043ba:	bfe9                	j	80004394 <exec+0x2c6>
  sz = sz1;
    800043bc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c0:	4481                	li	s1,0
    800043c2:	bfc9                	j	80004394 <exec+0x2c6>
  sz = sz1;
    800043c4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c8:	4481                	li	s1,0
    800043ca:	b7e9                	j	80004394 <exec+0x2c6>
  sz = sz1;
    800043cc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d0:	4481                	li	s1,0
    800043d2:	b7c9                	j	80004394 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043d4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043d8:	2b05                	addiw	s6,s6,1
    800043da:	0389899b          	addiw	s3,s3,56
    800043de:	e8845783          	lhu	a5,-376(s0)
    800043e2:	e2fb5be3          	bge	s6,a5,80004218 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043e6:	2981                	sext.w	s3,s3
    800043e8:	03800713          	li	a4,56
    800043ec:	86ce                	mv	a3,s3
    800043ee:	e1840613          	addi	a2,s0,-488
    800043f2:	4581                	li	a1,0
    800043f4:	8526                	mv	a0,s1
    800043f6:	fffff097          	auipc	ra,0xfffff
    800043fa:	a8c080e7          	jalr	-1396(ra) # 80002e82 <readi>
    800043fe:	03800793          	li	a5,56
    80004402:	f8f517e3          	bne	a0,a5,80004390 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004406:	e1842783          	lw	a5,-488(s0)
    8000440a:	4705                	li	a4,1
    8000440c:	fce796e3          	bne	a5,a4,800043d8 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004410:	e4043603          	ld	a2,-448(s0)
    80004414:	e3843783          	ld	a5,-456(s0)
    80004418:	f8f669e3          	bltu	a2,a5,800043aa <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000441c:	e2843783          	ld	a5,-472(s0)
    80004420:	963e                	add	a2,a2,a5
    80004422:	f8f667e3          	bltu	a2,a5,800043b0 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004426:	85ca                	mv	a1,s2
    80004428:	855e                	mv	a0,s7
    8000442a:	ffffc097          	auipc	ra,0xffffc
    8000442e:	490080e7          	jalr	1168(ra) # 800008ba <uvmalloc>
    80004432:	e0a43423          	sd	a0,-504(s0)
    80004436:	d141                	beqz	a0,800043b6 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004438:	e2843d03          	ld	s10,-472(s0)
    8000443c:	df043783          	ld	a5,-528(s0)
    80004440:	00fd77b3          	and	a5,s10,a5
    80004444:	fba1                	bnez	a5,80004394 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004446:	e2042d83          	lw	s11,-480(s0)
    8000444a:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000444e:	f80c03e3          	beqz	s8,800043d4 <exec+0x306>
    80004452:	8a62                	mv	s4,s8
    80004454:	4901                	li	s2,0
    80004456:	b345                	j	800041f6 <exec+0x128>

0000000080004458 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004458:	7179                	addi	sp,sp,-48
    8000445a:	f406                	sd	ra,40(sp)
    8000445c:	f022                	sd	s0,32(sp)
    8000445e:	ec26                	sd	s1,24(sp)
    80004460:	e84a                	sd	s2,16(sp)
    80004462:	1800                	addi	s0,sp,48
    80004464:	892e                	mv	s2,a1
    80004466:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004468:	fdc40593          	addi	a1,s0,-36
    8000446c:	ffffe097          	auipc	ra,0xffffe
    80004470:	a88080e7          	jalr	-1400(ra) # 80001ef4 <argint>
    80004474:	04054063          	bltz	a0,800044b4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004478:	fdc42703          	lw	a4,-36(s0)
    8000447c:	47bd                	li	a5,15
    8000447e:	02e7ed63          	bltu	a5,a4,800044b8 <argfd+0x60>
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	9c6080e7          	jalr	-1594(ra) # 80000e48 <myproc>
    8000448a:	fdc42703          	lw	a4,-36(s0)
    8000448e:	01a70793          	addi	a5,a4,26
    80004492:	078e                	slli	a5,a5,0x3
    80004494:	953e                	add	a0,a0,a5
    80004496:	611c                	ld	a5,0(a0)
    80004498:	c395                	beqz	a5,800044bc <argfd+0x64>
    return -1;
  if(pfd)
    8000449a:	00090463          	beqz	s2,800044a2 <argfd+0x4a>
    *pfd = fd;
    8000449e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044a2:	4501                	li	a0,0
  if(pf)
    800044a4:	c091                	beqz	s1,800044a8 <argfd+0x50>
    *pf = f;
    800044a6:	e09c                	sd	a5,0(s1)
}
    800044a8:	70a2                	ld	ra,40(sp)
    800044aa:	7402                	ld	s0,32(sp)
    800044ac:	64e2                	ld	s1,24(sp)
    800044ae:	6942                	ld	s2,16(sp)
    800044b0:	6145                	addi	sp,sp,48
    800044b2:	8082                	ret
    return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	bfcd                	j	800044a8 <argfd+0x50>
    return -1;
    800044b8:	557d                	li	a0,-1
    800044ba:	b7fd                	j	800044a8 <argfd+0x50>
    800044bc:	557d                	li	a0,-1
    800044be:	b7ed                	j	800044a8 <argfd+0x50>

00000000800044c0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044c0:	1101                	addi	sp,sp,-32
    800044c2:	ec06                	sd	ra,24(sp)
    800044c4:	e822                	sd	s0,16(sp)
    800044c6:	e426                	sd	s1,8(sp)
    800044c8:	1000                	addi	s0,sp,32
    800044ca:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044cc:	ffffd097          	auipc	ra,0xffffd
    800044d0:	97c080e7          	jalr	-1668(ra) # 80000e48 <myproc>
    800044d4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044d6:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdde90>
    800044da:	4501                	li	a0,0
    800044dc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044de:	6398                	ld	a4,0(a5)
    800044e0:	cb19                	beqz	a4,800044f6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044e2:	2505                	addiw	a0,a0,1
    800044e4:	07a1                	addi	a5,a5,8
    800044e6:	fed51ce3          	bne	a0,a3,800044de <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ea:	557d                	li	a0,-1
}
    800044ec:	60e2                	ld	ra,24(sp)
    800044ee:	6442                	ld	s0,16(sp)
    800044f0:	64a2                	ld	s1,8(sp)
    800044f2:	6105                	addi	sp,sp,32
    800044f4:	8082                	ret
      p->ofile[fd] = f;
    800044f6:	01a50793          	addi	a5,a0,26
    800044fa:	078e                	slli	a5,a5,0x3
    800044fc:	963e                	add	a2,a2,a5
    800044fe:	e204                	sd	s1,0(a2)
      return fd;
    80004500:	b7f5                	j	800044ec <fdalloc+0x2c>

0000000080004502 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004502:	715d                	addi	sp,sp,-80
    80004504:	e486                	sd	ra,72(sp)
    80004506:	e0a2                	sd	s0,64(sp)
    80004508:	fc26                	sd	s1,56(sp)
    8000450a:	f84a                	sd	s2,48(sp)
    8000450c:	f44e                	sd	s3,40(sp)
    8000450e:	f052                	sd	s4,32(sp)
    80004510:	ec56                	sd	s5,24(sp)
    80004512:	0880                	addi	s0,sp,80
    80004514:	89ae                	mv	s3,a1
    80004516:	8ab2                	mv	s5,a2
    80004518:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000451a:	fb040593          	addi	a1,s0,-80
    8000451e:	fffff097          	auipc	ra,0xfffff
    80004522:	e86080e7          	jalr	-378(ra) # 800033a4 <nameiparent>
    80004526:	892a                	mv	s2,a0
    80004528:	12050f63          	beqz	a0,80004666 <create+0x164>
    return 0;

  ilock(dp);
    8000452c:	ffffe097          	auipc	ra,0xffffe
    80004530:	5fc080e7          	jalr	1532(ra) # 80002b28 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004534:	4601                	li	a2,0
    80004536:	fb040593          	addi	a1,s0,-80
    8000453a:	854a                	mv	a0,s2
    8000453c:	fffff097          	auipc	ra,0xfffff
    80004540:	b78080e7          	jalr	-1160(ra) # 800030b4 <dirlookup>
    80004544:	84aa                	mv	s1,a0
    80004546:	c921                	beqz	a0,80004596 <create+0x94>
    iunlockput(dp);
    80004548:	854a                	mv	a0,s2
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	8e6080e7          	jalr	-1818(ra) # 80002e30 <iunlockput>
    ilock(ip);
    80004552:	8526                	mv	a0,s1
    80004554:	ffffe097          	auipc	ra,0xffffe
    80004558:	5d4080e7          	jalr	1492(ra) # 80002b28 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000455c:	2981                	sext.w	s3,s3
    8000455e:	4789                	li	a5,2
    80004560:	02f99463          	bne	s3,a5,80004588 <create+0x86>
    80004564:	0444d783          	lhu	a5,68(s1)
    80004568:	37f9                	addiw	a5,a5,-2
    8000456a:	17c2                	slli	a5,a5,0x30
    8000456c:	93c1                	srli	a5,a5,0x30
    8000456e:	4705                	li	a4,1
    80004570:	00f76c63          	bltu	a4,a5,80004588 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004574:	8526                	mv	a0,s1
    80004576:	60a6                	ld	ra,72(sp)
    80004578:	6406                	ld	s0,64(sp)
    8000457a:	74e2                	ld	s1,56(sp)
    8000457c:	7942                	ld	s2,48(sp)
    8000457e:	79a2                	ld	s3,40(sp)
    80004580:	7a02                	ld	s4,32(sp)
    80004582:	6ae2                	ld	s5,24(sp)
    80004584:	6161                	addi	sp,sp,80
    80004586:	8082                	ret
    iunlockput(ip);
    80004588:	8526                	mv	a0,s1
    8000458a:	fffff097          	auipc	ra,0xfffff
    8000458e:	8a6080e7          	jalr	-1882(ra) # 80002e30 <iunlockput>
    return 0;
    80004592:	4481                	li	s1,0
    80004594:	b7c5                	j	80004574 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004596:	85ce                	mv	a1,s3
    80004598:	00092503          	lw	a0,0(s2)
    8000459c:	ffffe097          	auipc	ra,0xffffe
    800045a0:	3f4080e7          	jalr	1012(ra) # 80002990 <ialloc>
    800045a4:	84aa                	mv	s1,a0
    800045a6:	c529                	beqz	a0,800045f0 <create+0xee>
  ilock(ip);
    800045a8:	ffffe097          	auipc	ra,0xffffe
    800045ac:	580080e7          	jalr	1408(ra) # 80002b28 <ilock>
  ip->major = major;
    800045b0:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045b4:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045b8:	4785                	li	a5,1
    800045ba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045be:	8526                	mv	a0,s1
    800045c0:	ffffe097          	auipc	ra,0xffffe
    800045c4:	49e080e7          	jalr	1182(ra) # 80002a5e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045c8:	2981                	sext.w	s3,s3
    800045ca:	4785                	li	a5,1
    800045cc:	02f98a63          	beq	s3,a5,80004600 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d0:	40d0                	lw	a2,4(s1)
    800045d2:	fb040593          	addi	a1,s0,-80
    800045d6:	854a                	mv	a0,s2
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	cec080e7          	jalr	-788(ra) # 800032c4 <dirlink>
    800045e0:	06054b63          	bltz	a0,80004656 <create+0x154>
  iunlockput(dp);
    800045e4:	854a                	mv	a0,s2
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	84a080e7          	jalr	-1974(ra) # 80002e30 <iunlockput>
  return ip;
    800045ee:	b759                	j	80004574 <create+0x72>
    panic("create: ialloc");
    800045f0:	00004517          	auipc	a0,0x4
    800045f4:	08050513          	addi	a0,a0,128 # 80008670 <syscalls+0x2a8>
    800045f8:	00001097          	auipc	ra,0x1
    800045fc:	7d0080e7          	jalr	2000(ra) # 80005dc8 <panic>
    dp->nlink++;  // for ".."
    80004600:	04a95783          	lhu	a5,74(s2)
    80004604:	2785                	addiw	a5,a5,1
    80004606:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000460a:	854a                	mv	a0,s2
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	452080e7          	jalr	1106(ra) # 80002a5e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004614:	40d0                	lw	a2,4(s1)
    80004616:	00004597          	auipc	a1,0x4
    8000461a:	06a58593          	addi	a1,a1,106 # 80008680 <syscalls+0x2b8>
    8000461e:	8526                	mv	a0,s1
    80004620:	fffff097          	auipc	ra,0xfffff
    80004624:	ca4080e7          	jalr	-860(ra) # 800032c4 <dirlink>
    80004628:	00054f63          	bltz	a0,80004646 <create+0x144>
    8000462c:	00492603          	lw	a2,4(s2)
    80004630:	00004597          	auipc	a1,0x4
    80004634:	05858593          	addi	a1,a1,88 # 80008688 <syscalls+0x2c0>
    80004638:	8526                	mv	a0,s1
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	c8a080e7          	jalr	-886(ra) # 800032c4 <dirlink>
    80004642:	f80557e3          	bgez	a0,800045d0 <create+0xce>
      panic("create dots");
    80004646:	00004517          	auipc	a0,0x4
    8000464a:	04a50513          	addi	a0,a0,74 # 80008690 <syscalls+0x2c8>
    8000464e:	00001097          	auipc	ra,0x1
    80004652:	77a080e7          	jalr	1914(ra) # 80005dc8 <panic>
    panic("create: dirlink");
    80004656:	00004517          	auipc	a0,0x4
    8000465a:	04a50513          	addi	a0,a0,74 # 800086a0 <syscalls+0x2d8>
    8000465e:	00001097          	auipc	ra,0x1
    80004662:	76a080e7          	jalr	1898(ra) # 80005dc8 <panic>
    return 0;
    80004666:	84aa                	mv	s1,a0
    80004668:	b731                	j	80004574 <create+0x72>

000000008000466a <sys_dup>:
{
    8000466a:	7179                	addi	sp,sp,-48
    8000466c:	f406                	sd	ra,40(sp)
    8000466e:	f022                	sd	s0,32(sp)
    80004670:	ec26                	sd	s1,24(sp)
    80004672:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004674:	fd840613          	addi	a2,s0,-40
    80004678:	4581                	li	a1,0
    8000467a:	4501                	li	a0,0
    8000467c:	00000097          	auipc	ra,0x0
    80004680:	ddc080e7          	jalr	-548(ra) # 80004458 <argfd>
    return -1;
    80004684:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004686:	02054363          	bltz	a0,800046ac <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000468a:	fd843503          	ld	a0,-40(s0)
    8000468e:	00000097          	auipc	ra,0x0
    80004692:	e32080e7          	jalr	-462(ra) # 800044c0 <fdalloc>
    80004696:	84aa                	mv	s1,a0
    return -1;
    80004698:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000469a:	00054963          	bltz	a0,800046ac <sys_dup+0x42>
  filedup(f);
    8000469e:	fd843503          	ld	a0,-40(s0)
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	37a080e7          	jalr	890(ra) # 80003a1c <filedup>
  return fd;
    800046aa:	87a6                	mv	a5,s1
}
    800046ac:	853e                	mv	a0,a5
    800046ae:	70a2                	ld	ra,40(sp)
    800046b0:	7402                	ld	s0,32(sp)
    800046b2:	64e2                	ld	s1,24(sp)
    800046b4:	6145                	addi	sp,sp,48
    800046b6:	8082                	ret

00000000800046b8 <sys_read>:
{
    800046b8:	7179                	addi	sp,sp,-48
    800046ba:	f406                	sd	ra,40(sp)
    800046bc:	f022                	sd	s0,32(sp)
    800046be:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c0:	fe840613          	addi	a2,s0,-24
    800046c4:	4581                	li	a1,0
    800046c6:	4501                	li	a0,0
    800046c8:	00000097          	auipc	ra,0x0
    800046cc:	d90080e7          	jalr	-624(ra) # 80004458 <argfd>
    return -1;
    800046d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d2:	04054163          	bltz	a0,80004714 <sys_read+0x5c>
    800046d6:	fe440593          	addi	a1,s0,-28
    800046da:	4509                	li	a0,2
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	818080e7          	jalr	-2024(ra) # 80001ef4 <argint>
    return -1;
    800046e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e6:	02054763          	bltz	a0,80004714 <sys_read+0x5c>
    800046ea:	fd840593          	addi	a1,s0,-40
    800046ee:	4505                	li	a0,1
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	826080e7          	jalr	-2010(ra) # 80001f16 <argaddr>
    return -1;
    800046f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fa:	00054d63          	bltz	a0,80004714 <sys_read+0x5c>
  return fileread(f, p, n);
    800046fe:	fe442603          	lw	a2,-28(s0)
    80004702:	fd843583          	ld	a1,-40(s0)
    80004706:	fe843503          	ld	a0,-24(s0)
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	49e080e7          	jalr	1182(ra) # 80003ba8 <fileread>
    80004712:	87aa                	mv	a5,a0
}
    80004714:	853e                	mv	a0,a5
    80004716:	70a2                	ld	ra,40(sp)
    80004718:	7402                	ld	s0,32(sp)
    8000471a:	6145                	addi	sp,sp,48
    8000471c:	8082                	ret

000000008000471e <sys_write>:
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004726:	fe840613          	addi	a2,s0,-24
    8000472a:	4581                	li	a1,0
    8000472c:	4501                	li	a0,0
    8000472e:	00000097          	auipc	ra,0x0
    80004732:	d2a080e7          	jalr	-726(ra) # 80004458 <argfd>
    return -1;
    80004736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004738:	04054163          	bltz	a0,8000477a <sys_write+0x5c>
    8000473c:	fe440593          	addi	a1,s0,-28
    80004740:	4509                	li	a0,2
    80004742:	ffffd097          	auipc	ra,0xffffd
    80004746:	7b2080e7          	jalr	1970(ra) # 80001ef4 <argint>
    return -1;
    8000474a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474c:	02054763          	bltz	a0,8000477a <sys_write+0x5c>
    80004750:	fd840593          	addi	a1,s0,-40
    80004754:	4505                	li	a0,1
    80004756:	ffffd097          	auipc	ra,0xffffd
    8000475a:	7c0080e7          	jalr	1984(ra) # 80001f16 <argaddr>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004760:	00054d63          	bltz	a0,8000477a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004764:	fe442603          	lw	a2,-28(s0)
    80004768:	fd843583          	ld	a1,-40(s0)
    8000476c:	fe843503          	ld	a0,-24(s0)
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	4fa080e7          	jalr	1274(ra) # 80003c6a <filewrite>
    80004778:	87aa                	mv	a5,a0
}
    8000477a:	853e                	mv	a0,a5
    8000477c:	70a2                	ld	ra,40(sp)
    8000477e:	7402                	ld	s0,32(sp)
    80004780:	6145                	addi	sp,sp,48
    80004782:	8082                	ret

0000000080004784 <sys_close>:
{
    80004784:	1101                	addi	sp,sp,-32
    80004786:	ec06                	sd	ra,24(sp)
    80004788:	e822                	sd	s0,16(sp)
    8000478a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000478c:	fe040613          	addi	a2,s0,-32
    80004790:	fec40593          	addi	a1,s0,-20
    80004794:	4501                	li	a0,0
    80004796:	00000097          	auipc	ra,0x0
    8000479a:	cc2080e7          	jalr	-830(ra) # 80004458 <argfd>
    return -1;
    8000479e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047a0:	02054463          	bltz	a0,800047c8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	6a4080e7          	jalr	1700(ra) # 80000e48 <myproc>
    800047ac:	fec42783          	lw	a5,-20(s0)
    800047b0:	07e9                	addi	a5,a5,26
    800047b2:	078e                	slli	a5,a5,0x3
    800047b4:	97aa                	add	a5,a5,a0
    800047b6:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047ba:	fe043503          	ld	a0,-32(s0)
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	2b0080e7          	jalr	688(ra) # 80003a6e <fileclose>
  return 0;
    800047c6:	4781                	li	a5,0
}
    800047c8:	853e                	mv	a0,a5
    800047ca:	60e2                	ld	ra,24(sp)
    800047cc:	6442                	ld	s0,16(sp)
    800047ce:	6105                	addi	sp,sp,32
    800047d0:	8082                	ret

00000000800047d2 <sys_fstat>:
{
    800047d2:	1101                	addi	sp,sp,-32
    800047d4:	ec06                	sd	ra,24(sp)
    800047d6:	e822                	sd	s0,16(sp)
    800047d8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047da:	fe840613          	addi	a2,s0,-24
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	c76080e7          	jalr	-906(ra) # 80004458 <argfd>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ec:	02054563          	bltz	a0,80004816 <sys_fstat+0x44>
    800047f0:	fe040593          	addi	a1,s0,-32
    800047f4:	4505                	li	a0,1
    800047f6:	ffffd097          	auipc	ra,0xffffd
    800047fa:	720080e7          	jalr	1824(ra) # 80001f16 <argaddr>
    return -1;
    800047fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004800:	00054b63          	bltz	a0,80004816 <sys_fstat+0x44>
  return filestat(f, st);
    80004804:	fe043583          	ld	a1,-32(s0)
    80004808:	fe843503          	ld	a0,-24(s0)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	32a080e7          	jalr	810(ra) # 80003b36 <filestat>
    80004814:	87aa                	mv	a5,a0
}
    80004816:	853e                	mv	a0,a5
    80004818:	60e2                	ld	ra,24(sp)
    8000481a:	6442                	ld	s0,16(sp)
    8000481c:	6105                	addi	sp,sp,32
    8000481e:	8082                	ret

0000000080004820 <sys_link>:
{
    80004820:	7169                	addi	sp,sp,-304
    80004822:	f606                	sd	ra,296(sp)
    80004824:	f222                	sd	s0,288(sp)
    80004826:	ee26                	sd	s1,280(sp)
    80004828:	ea4a                	sd	s2,272(sp)
    8000482a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000482c:	08000613          	li	a2,128
    80004830:	ed040593          	addi	a1,s0,-304
    80004834:	4501                	li	a0,0
    80004836:	ffffd097          	auipc	ra,0xffffd
    8000483a:	702080e7          	jalr	1794(ra) # 80001f38 <argstr>
    return -1;
    8000483e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004840:	10054e63          	bltz	a0,8000495c <sys_link+0x13c>
    80004844:	08000613          	li	a2,128
    80004848:	f5040593          	addi	a1,s0,-176
    8000484c:	4505                	li	a0,1
    8000484e:	ffffd097          	auipc	ra,0xffffd
    80004852:	6ea080e7          	jalr	1770(ra) # 80001f38 <argstr>
    return -1;
    80004856:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004858:	10054263          	bltz	a0,8000495c <sys_link+0x13c>
  begin_op();
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	d46080e7          	jalr	-698(ra) # 800035a2 <begin_op>
  if((ip = namei(old)) == 0){
    80004864:	ed040513          	addi	a0,s0,-304
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	b1e080e7          	jalr	-1250(ra) # 80003386 <namei>
    80004870:	84aa                	mv	s1,a0
    80004872:	c551                	beqz	a0,800048fe <sys_link+0xde>
  ilock(ip);
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	2b4080e7          	jalr	692(ra) # 80002b28 <ilock>
  if(ip->type == T_DIR){
    8000487c:	04449703          	lh	a4,68(s1)
    80004880:	4785                	li	a5,1
    80004882:	08f70463          	beq	a4,a5,8000490a <sys_link+0xea>
  ip->nlink++;
    80004886:	04a4d783          	lhu	a5,74(s1)
    8000488a:	2785                	addiw	a5,a5,1
    8000488c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004890:	8526                	mv	a0,s1
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	1cc080e7          	jalr	460(ra) # 80002a5e <iupdate>
  iunlock(ip);
    8000489a:	8526                	mv	a0,s1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	34e080e7          	jalr	846(ra) # 80002bea <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048a4:	fd040593          	addi	a1,s0,-48
    800048a8:	f5040513          	addi	a0,s0,-176
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	af8080e7          	jalr	-1288(ra) # 800033a4 <nameiparent>
    800048b4:	892a                	mv	s2,a0
    800048b6:	c935                	beqz	a0,8000492a <sys_link+0x10a>
  ilock(dp);
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	270080e7          	jalr	624(ra) # 80002b28 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048c0:	00092703          	lw	a4,0(s2)
    800048c4:	409c                	lw	a5,0(s1)
    800048c6:	04f71d63          	bne	a4,a5,80004920 <sys_link+0x100>
    800048ca:	40d0                	lw	a2,4(s1)
    800048cc:	fd040593          	addi	a1,s0,-48
    800048d0:	854a                	mv	a0,s2
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	9f2080e7          	jalr	-1550(ra) # 800032c4 <dirlink>
    800048da:	04054363          	bltz	a0,80004920 <sys_link+0x100>
  iunlockput(dp);
    800048de:	854a                	mv	a0,s2
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	550080e7          	jalr	1360(ra) # 80002e30 <iunlockput>
  iput(ip);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	49e080e7          	jalr	1182(ra) # 80002d88 <iput>
  end_op();
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	d30080e7          	jalr	-720(ra) # 80003622 <end_op>
  return 0;
    800048fa:	4781                	li	a5,0
    800048fc:	a085                	j	8000495c <sys_link+0x13c>
    end_op();
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	d24080e7          	jalr	-732(ra) # 80003622 <end_op>
    return -1;
    80004906:	57fd                	li	a5,-1
    80004908:	a891                	j	8000495c <sys_link+0x13c>
    iunlockput(ip);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	524080e7          	jalr	1316(ra) # 80002e30 <iunlockput>
    end_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	d0e080e7          	jalr	-754(ra) # 80003622 <end_op>
    return -1;
    8000491c:	57fd                	li	a5,-1
    8000491e:	a83d                	j	8000495c <sys_link+0x13c>
    iunlockput(dp);
    80004920:	854a                	mv	a0,s2
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	50e080e7          	jalr	1294(ra) # 80002e30 <iunlockput>
  ilock(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	1fc080e7          	jalr	508(ra) # 80002b28 <ilock>
  ip->nlink--;
    80004934:	04a4d783          	lhu	a5,74(s1)
    80004938:	37fd                	addiw	a5,a5,-1
    8000493a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000493e:	8526                	mv	a0,s1
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	11e080e7          	jalr	286(ra) # 80002a5e <iupdate>
  iunlockput(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	4e6080e7          	jalr	1254(ra) # 80002e30 <iunlockput>
  end_op();
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	cd0080e7          	jalr	-816(ra) # 80003622 <end_op>
  return -1;
    8000495a:	57fd                	li	a5,-1
}
    8000495c:	853e                	mv	a0,a5
    8000495e:	70b2                	ld	ra,296(sp)
    80004960:	7412                	ld	s0,288(sp)
    80004962:	64f2                	ld	s1,280(sp)
    80004964:	6952                	ld	s2,272(sp)
    80004966:	6155                	addi	sp,sp,304
    80004968:	8082                	ret

000000008000496a <sys_unlink>:
{
    8000496a:	7151                	addi	sp,sp,-240
    8000496c:	f586                	sd	ra,232(sp)
    8000496e:	f1a2                	sd	s0,224(sp)
    80004970:	eda6                	sd	s1,216(sp)
    80004972:	e9ca                	sd	s2,208(sp)
    80004974:	e5ce                	sd	s3,200(sp)
    80004976:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004978:	08000613          	li	a2,128
    8000497c:	f3040593          	addi	a1,s0,-208
    80004980:	4501                	li	a0,0
    80004982:	ffffd097          	auipc	ra,0xffffd
    80004986:	5b6080e7          	jalr	1462(ra) # 80001f38 <argstr>
    8000498a:	18054163          	bltz	a0,80004b0c <sys_unlink+0x1a2>
  begin_op();
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	c14080e7          	jalr	-1004(ra) # 800035a2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004996:	fb040593          	addi	a1,s0,-80
    8000499a:	f3040513          	addi	a0,s0,-208
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	a06080e7          	jalr	-1530(ra) # 800033a4 <nameiparent>
    800049a6:	84aa                	mv	s1,a0
    800049a8:	c979                	beqz	a0,80004a7e <sys_unlink+0x114>
  ilock(dp);
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	17e080e7          	jalr	382(ra) # 80002b28 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049b2:	00004597          	auipc	a1,0x4
    800049b6:	cce58593          	addi	a1,a1,-818 # 80008680 <syscalls+0x2b8>
    800049ba:	fb040513          	addi	a0,s0,-80
    800049be:	ffffe097          	auipc	ra,0xffffe
    800049c2:	6dc080e7          	jalr	1756(ra) # 8000309a <namecmp>
    800049c6:	14050a63          	beqz	a0,80004b1a <sys_unlink+0x1b0>
    800049ca:	00004597          	auipc	a1,0x4
    800049ce:	cbe58593          	addi	a1,a1,-834 # 80008688 <syscalls+0x2c0>
    800049d2:	fb040513          	addi	a0,s0,-80
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	6c4080e7          	jalr	1732(ra) # 8000309a <namecmp>
    800049de:	12050e63          	beqz	a0,80004b1a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049e2:	f2c40613          	addi	a2,s0,-212
    800049e6:	fb040593          	addi	a1,s0,-80
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	6c8080e7          	jalr	1736(ra) # 800030b4 <dirlookup>
    800049f4:	892a                	mv	s2,a0
    800049f6:	12050263          	beqz	a0,80004b1a <sys_unlink+0x1b0>
  ilock(ip);
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	12e080e7          	jalr	302(ra) # 80002b28 <ilock>
  if(ip->nlink < 1)
    80004a02:	04a91783          	lh	a5,74(s2)
    80004a06:	08f05263          	blez	a5,80004a8a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a0a:	04491703          	lh	a4,68(s2)
    80004a0e:	4785                	li	a5,1
    80004a10:	08f70563          	beq	a4,a5,80004a9a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a14:	4641                	li	a2,16
    80004a16:	4581                	li	a1,0
    80004a18:	fc040513          	addi	a0,s0,-64
    80004a1c:	ffffb097          	auipc	ra,0xffffb
    80004a20:	75c080e7          	jalr	1884(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a24:	4741                	li	a4,16
    80004a26:	f2c42683          	lw	a3,-212(s0)
    80004a2a:	fc040613          	addi	a2,s0,-64
    80004a2e:	4581                	li	a1,0
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	548080e7          	jalr	1352(ra) # 80002f7a <writei>
    80004a3a:	47c1                	li	a5,16
    80004a3c:	0af51563          	bne	a0,a5,80004ae6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a40:	04491703          	lh	a4,68(s2)
    80004a44:	4785                	li	a5,1
    80004a46:	0af70863          	beq	a4,a5,80004af6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	3e4080e7          	jalr	996(ra) # 80002e30 <iunlockput>
  ip->nlink--;
    80004a54:	04a95783          	lhu	a5,74(s2)
    80004a58:	37fd                	addiw	a5,a5,-1
    80004a5a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	ffe080e7          	jalr	-2(ra) # 80002a5e <iupdate>
  iunlockput(ip);
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	3c6080e7          	jalr	966(ra) # 80002e30 <iunlockput>
  end_op();
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	bb0080e7          	jalr	-1104(ra) # 80003622 <end_op>
  return 0;
    80004a7a:	4501                	li	a0,0
    80004a7c:	a84d                	j	80004b2e <sys_unlink+0x1c4>
    end_op();
    80004a7e:	fffff097          	auipc	ra,0xfffff
    80004a82:	ba4080e7          	jalr	-1116(ra) # 80003622 <end_op>
    return -1;
    80004a86:	557d                	li	a0,-1
    80004a88:	a05d                	j	80004b2e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a8a:	00004517          	auipc	a0,0x4
    80004a8e:	c2650513          	addi	a0,a0,-986 # 800086b0 <syscalls+0x2e8>
    80004a92:	00001097          	auipc	ra,0x1
    80004a96:	336080e7          	jalr	822(ra) # 80005dc8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a9a:	04c92703          	lw	a4,76(s2)
    80004a9e:	02000793          	li	a5,32
    80004aa2:	f6e7f9e3          	bgeu	a5,a4,80004a14 <sys_unlink+0xaa>
    80004aa6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aaa:	4741                	li	a4,16
    80004aac:	86ce                	mv	a3,s3
    80004aae:	f1840613          	addi	a2,s0,-232
    80004ab2:	4581                	li	a1,0
    80004ab4:	854a                	mv	a0,s2
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	3cc080e7          	jalr	972(ra) # 80002e82 <readi>
    80004abe:	47c1                	li	a5,16
    80004ac0:	00f51b63          	bne	a0,a5,80004ad6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ac4:	f1845783          	lhu	a5,-232(s0)
    80004ac8:	e7a1                	bnez	a5,80004b10 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aca:	29c1                	addiw	s3,s3,16
    80004acc:	04c92783          	lw	a5,76(s2)
    80004ad0:	fcf9ede3          	bltu	s3,a5,80004aaa <sys_unlink+0x140>
    80004ad4:	b781                	j	80004a14 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ad6:	00004517          	auipc	a0,0x4
    80004ada:	bf250513          	addi	a0,a0,-1038 # 800086c8 <syscalls+0x300>
    80004ade:	00001097          	auipc	ra,0x1
    80004ae2:	2ea080e7          	jalr	746(ra) # 80005dc8 <panic>
    panic("unlink: writei");
    80004ae6:	00004517          	auipc	a0,0x4
    80004aea:	bfa50513          	addi	a0,a0,-1030 # 800086e0 <syscalls+0x318>
    80004aee:	00001097          	auipc	ra,0x1
    80004af2:	2da080e7          	jalr	730(ra) # 80005dc8 <panic>
    dp->nlink--;
    80004af6:	04a4d783          	lhu	a5,74(s1)
    80004afa:	37fd                	addiw	a5,a5,-1
    80004afc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	f5c080e7          	jalr	-164(ra) # 80002a5e <iupdate>
    80004b0a:	b781                	j	80004a4a <sys_unlink+0xe0>
    return -1;
    80004b0c:	557d                	li	a0,-1
    80004b0e:	a005                	j	80004b2e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b10:	854a                	mv	a0,s2
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	31e080e7          	jalr	798(ra) # 80002e30 <iunlockput>
  iunlockput(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	314080e7          	jalr	788(ra) # 80002e30 <iunlockput>
  end_op();
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	afe080e7          	jalr	-1282(ra) # 80003622 <end_op>
  return -1;
    80004b2c:	557d                	li	a0,-1
}
    80004b2e:	70ae                	ld	ra,232(sp)
    80004b30:	740e                	ld	s0,224(sp)
    80004b32:	64ee                	ld	s1,216(sp)
    80004b34:	694e                	ld	s2,208(sp)
    80004b36:	69ae                	ld	s3,200(sp)
    80004b38:	616d                	addi	sp,sp,240
    80004b3a:	8082                	ret

0000000080004b3c <sys_open>:

uint64
sys_open(void)
{
    80004b3c:	7129                	addi	sp,sp,-320
    80004b3e:	fe06                	sd	ra,312(sp)
    80004b40:	fa22                	sd	s0,304(sp)
    80004b42:	f626                	sd	s1,296(sp)
    80004b44:	f24a                	sd	s2,288(sp)
    80004b46:	ee4e                	sd	s3,280(sp)
    80004b48:	0280                	addi	s0,sp,320
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b4a:	08000613          	li	a2,128
    80004b4e:	f5040593          	addi	a1,s0,-176
    80004b52:	4501                	li	a0,0
    80004b54:	ffffd097          	auipc	ra,0xffffd
    80004b58:	3e4080e7          	jalr	996(ra) # 80001f38 <argstr>
    return -1;
    80004b5c:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b5e:	1a054163          	bltz	a0,80004d00 <sys_open+0x1c4>
    80004b62:	f4c40593          	addi	a1,s0,-180
    80004b66:	4505                	li	a0,1
    80004b68:	ffffd097          	auipc	ra,0xffffd
    80004b6c:	38c080e7          	jalr	908(ra) # 80001ef4 <argint>
    80004b70:	18054863          	bltz	a0,80004d00 <sys_open+0x1c4>

  begin_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	a2e080e7          	jalr	-1490(ra) # 800035a2 <begin_op>

  if(omode & O_CREATE){
    80004b7c:	f4c42783          	lw	a5,-180(s0)
    80004b80:	2007f793          	andi	a5,a5,512
    80004b84:	cfcd                	beqz	a5,80004c3e <sys_open+0x102>
    ip = create(path, T_FILE, 0, 0);
    80004b86:	4681                	li	a3,0
    80004b88:	4601                	li	a2,0
    80004b8a:	4589                	li	a1,2
    80004b8c:	f5040513          	addi	a0,s0,-176
    80004b90:	00000097          	auipc	ra,0x0
    80004b94:	972080e7          	jalr	-1678(ra) # 80004502 <create>
    80004b98:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b9a:	cd49                	beqz	a0,80004c34 <sys_open+0xf8>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b9c:	04449783          	lh	a5,68(s1)
    80004ba0:	0007869b          	sext.w	a3,a5
    80004ba4:	470d                	li	a4,3
    80004ba6:	0ee68163          	beq	a3,a4,80004c88 <sys_open+0x14c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_SYMLINK){
    80004baa:	2781                	sext.w	a5,a5
    80004bac:	4711                	li	a4,4
    80004bae:	0ee79263          	bne	a5,a4,80004c92 <sys_open+0x156>
    if(!(omode & O_NOFOLLOW)){
    80004bb2:	f4c42703          	lw	a4,-180(s0)
    80004bb6:	6785                	lui	a5,0x1
    80004bb8:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80004bbc:	8ff9                	and	a5,a5,a4
    80004bbe:	ebf1                	bnez	a5,80004c92 <sys_open+0x156>
    80004bc0:	4929                	li	s2,10
      int cycle = 0;
      char target[MAXPATH];
      while(ip->type == T_SYMLINK){
    80004bc2:	4991                	li	s3,4
          iunlockput(ip);
          end_op();
          return -1; // max cycle
        }
        cycle++;
        memset(target, 0, sizeof(target));
    80004bc4:	08000613          	li	a2,128
    80004bc8:	4581                	li	a1,0
    80004bca:	ec840513          	addi	a0,s0,-312
    80004bce:	ffffb097          	auipc	ra,0xffffb
    80004bd2:	5aa080e7          	jalr	1450(ra) # 80000178 <memset>
        readi(ip, 0, (uint64)target, 0, MAXPATH);
    80004bd6:	08000713          	li	a4,128
    80004bda:	4681                	li	a3,0
    80004bdc:	ec840613          	addi	a2,s0,-312
    80004be0:	4581                	li	a1,0
    80004be2:	8526                	mv	a0,s1
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	29e080e7          	jalr	670(ra) # 80002e82 <readi>
        iunlockput(ip);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	242080e7          	jalr	578(ra) # 80002e30 <iunlockput>
        if((ip = namei(target)) == 0){
    80004bf6:	ec840513          	addi	a0,s0,-312
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	78c080e7          	jalr	1932(ra) # 80003386 <namei>
    80004c02:	84aa                	mv	s1,a0
    80004c04:	12050163          	beqz	a0,80004d26 <sys_open+0x1ea>
          end_op();
          return -1; // target not exist
        }
        ilock(ip);
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	f20080e7          	jalr	-224(ra) # 80002b28 <ilock>
      while(ip->type == T_SYMLINK){
    80004c10:	04449783          	lh	a5,68(s1)
    80004c14:	07379f63          	bne	a5,s3,80004c92 <sys_open+0x156>
        if(cycle == 10){
    80004c18:	397d                	addiw	s2,s2,-1
    80004c1a:	fa0915e3          	bnez	s2,80004bc4 <sys_open+0x88>
          iunlockput(ip);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	210080e7          	jalr	528(ra) # 80002e30 <iunlockput>
          end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	9fa080e7          	jalr	-1542(ra) # 80003622 <end_op>
          return -1; // max cycle
    80004c30:	597d                	li	s2,-1
    80004c32:	a0f9                	j	80004d00 <sys_open+0x1c4>
      end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	9ee080e7          	jalr	-1554(ra) # 80003622 <end_op>
      return -1;
    80004c3c:	a0d1                	j	80004d00 <sys_open+0x1c4>
    if((ip = namei(path)) == 0){
    80004c3e:	f5040513          	addi	a0,s0,-176
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	744080e7          	jalr	1860(ra) # 80003386 <namei>
    80004c4a:	84aa                	mv	s1,a0
    80004c4c:	c905                	beqz	a0,80004c7c <sys_open+0x140>
    ilock(ip);
    80004c4e:	ffffe097          	auipc	ra,0xffffe
    80004c52:	eda080e7          	jalr	-294(ra) # 80002b28 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c56:	04449703          	lh	a4,68(s1)
    80004c5a:	4785                	li	a5,1
    80004c5c:	f4f710e3          	bne	a4,a5,80004b9c <sys_open+0x60>
    80004c60:	f4c42783          	lw	a5,-180(s0)
    80004c64:	c79d                	beqz	a5,80004c92 <sys_open+0x156>
      iunlockput(ip);
    80004c66:	8526                	mv	a0,s1
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	1c8080e7          	jalr	456(ra) # 80002e30 <iunlockput>
      end_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	9b2080e7          	jalr	-1614(ra) # 80003622 <end_op>
      return -1;
    80004c78:	597d                	li	s2,-1
    80004c7a:	a059                	j	80004d00 <sys_open+0x1c4>
      end_op();
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	9a6080e7          	jalr	-1626(ra) # 80003622 <end_op>
      return -1;
    80004c84:	597d                	li	s2,-1
    80004c86:	a8ad                	j	80004d00 <sys_open+0x1c4>
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c88:	0464d703          	lhu	a4,70(s1)
    80004c8c:	47a5                	li	a5,9
    80004c8e:	08e7e163          	bltu	a5,a4,80004d10 <sys_open+0x1d4>
      }
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	d20080e7          	jalr	-736(ra) # 800039b2 <filealloc>
    80004c9a:	89aa                	mv	s3,a0
    80004c9c:	cd45                	beqz	a0,80004d54 <sys_open+0x218>
    80004c9e:	00000097          	auipc	ra,0x0
    80004ca2:	822080e7          	jalr	-2014(ra) # 800044c0 <fdalloc>
    80004ca6:	892a                	mv	s2,a0
    80004ca8:	0a054163          	bltz	a0,80004d4a <sys_open+0x20e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cac:	04449703          	lh	a4,68(s1)
    80004cb0:	478d                	li	a5,3
    80004cb2:	06f70f63          	beq	a4,a5,80004d30 <sys_open+0x1f4>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cb6:	4789                	li	a5,2
    80004cb8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cbc:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cc0:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cc4:	f4c42783          	lw	a5,-180(s0)
    80004cc8:	0017c713          	xori	a4,a5,1
    80004ccc:	8b05                	andi	a4,a4,1
    80004cce:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cd2:	0037f713          	andi	a4,a5,3
    80004cd6:	00e03733          	snez	a4,a4
    80004cda:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cde:	4007f793          	andi	a5,a5,1024
    80004ce2:	c791                	beqz	a5,80004cee <sys_open+0x1b2>
    80004ce4:	04449703          	lh	a4,68(s1)
    80004ce8:	4789                	li	a5,2
    80004cea:	04f70a63          	beq	a4,a5,80004d3e <sys_open+0x202>
    itrunc(ip);
  }

  iunlock(ip);
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	efa080e7          	jalr	-262(ra) # 80002bea <iunlock>
  end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	92a080e7          	jalr	-1750(ra) # 80003622 <end_op>

  return fd;
}
    80004d00:	854a                	mv	a0,s2
    80004d02:	70f2                	ld	ra,312(sp)
    80004d04:	7452                	ld	s0,304(sp)
    80004d06:	74b2                	ld	s1,296(sp)
    80004d08:	7912                	ld	s2,288(sp)
    80004d0a:	69f2                	ld	s3,280(sp)
    80004d0c:	6131                	addi	sp,sp,320
    80004d0e:	8082                	ret
    iunlockput(ip);
    80004d10:	8526                	mv	a0,s1
    80004d12:	ffffe097          	auipc	ra,0xffffe
    80004d16:	11e080e7          	jalr	286(ra) # 80002e30 <iunlockput>
    end_op();
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	908080e7          	jalr	-1784(ra) # 80003622 <end_op>
    return -1;
    80004d22:	597d                	li	s2,-1
    80004d24:	bff1                	j	80004d00 <sys_open+0x1c4>
          end_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	8fc080e7          	jalr	-1796(ra) # 80003622 <end_op>
          return -1; // target not exist
    80004d2e:	b709                	j	80004c30 <sys_open+0xf4>
    f->type = FD_DEVICE;
    80004d30:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d34:	04649783          	lh	a5,70(s1)
    80004d38:	02f99223          	sh	a5,36(s3)
    80004d3c:	b751                	j	80004cc0 <sys_open+0x184>
    itrunc(ip);
    80004d3e:	8526                	mv	a0,s1
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	ef6080e7          	jalr	-266(ra) # 80002c36 <itrunc>
    80004d48:	b75d                	j	80004cee <sys_open+0x1b2>
      fileclose(f);
    80004d4a:	854e                	mv	a0,s3
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	d22080e7          	jalr	-734(ra) # 80003a6e <fileclose>
    iunlockput(ip);
    80004d54:	8526                	mv	a0,s1
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	0da080e7          	jalr	218(ra) # 80002e30 <iunlockput>
    end_op();
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	8c4080e7          	jalr	-1852(ra) # 80003622 <end_op>
    return -1;
    80004d66:	597d                	li	s2,-1
    80004d68:	bf61                	j	80004d00 <sys_open+0x1c4>

0000000080004d6a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d6a:	7175                	addi	sp,sp,-144
    80004d6c:	e506                	sd	ra,136(sp)
    80004d6e:	e122                	sd	s0,128(sp)
    80004d70:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	830080e7          	jalr	-2000(ra) # 800035a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d7a:	08000613          	li	a2,128
    80004d7e:	f7040593          	addi	a1,s0,-144
    80004d82:	4501                	li	a0,0
    80004d84:	ffffd097          	auipc	ra,0xffffd
    80004d88:	1b4080e7          	jalr	436(ra) # 80001f38 <argstr>
    80004d8c:	02054963          	bltz	a0,80004dbe <sys_mkdir+0x54>
    80004d90:	4681                	li	a3,0
    80004d92:	4601                	li	a2,0
    80004d94:	4585                	li	a1,1
    80004d96:	f7040513          	addi	a0,s0,-144
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	768080e7          	jalr	1896(ra) # 80004502 <create>
    80004da2:	cd11                	beqz	a0,80004dbe <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	08c080e7          	jalr	140(ra) # 80002e30 <iunlockput>
  end_op();
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	876080e7          	jalr	-1930(ra) # 80003622 <end_op>
  return 0;
    80004db4:	4501                	li	a0,0
}
    80004db6:	60aa                	ld	ra,136(sp)
    80004db8:	640a                	ld	s0,128(sp)
    80004dba:	6149                	addi	sp,sp,144
    80004dbc:	8082                	ret
    end_op();
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	864080e7          	jalr	-1948(ra) # 80003622 <end_op>
    return -1;
    80004dc6:	557d                	li	a0,-1
    80004dc8:	b7fd                	j	80004db6 <sys_mkdir+0x4c>

0000000080004dca <sys_mknod>:

uint64
sys_mknod(void)
{
    80004dca:	7135                	addi	sp,sp,-160
    80004dcc:	ed06                	sd	ra,152(sp)
    80004dce:	e922                	sd	s0,144(sp)
    80004dd0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	7d0080e7          	jalr	2000(ra) # 800035a2 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dda:	08000613          	li	a2,128
    80004dde:	f7040593          	addi	a1,s0,-144
    80004de2:	4501                	li	a0,0
    80004de4:	ffffd097          	auipc	ra,0xffffd
    80004de8:	154080e7          	jalr	340(ra) # 80001f38 <argstr>
    80004dec:	04054a63          	bltz	a0,80004e40 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004df0:	f6c40593          	addi	a1,s0,-148
    80004df4:	4505                	li	a0,1
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	0fe080e7          	jalr	254(ra) # 80001ef4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dfe:	04054163          	bltz	a0,80004e40 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e02:	f6840593          	addi	a1,s0,-152
    80004e06:	4509                	li	a0,2
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	0ec080e7          	jalr	236(ra) # 80001ef4 <argint>
     argint(1, &major) < 0 ||
    80004e10:	02054863          	bltz	a0,80004e40 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e14:	f6841683          	lh	a3,-152(s0)
    80004e18:	f6c41603          	lh	a2,-148(s0)
    80004e1c:	458d                	li	a1,3
    80004e1e:	f7040513          	addi	a0,s0,-144
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	6e0080e7          	jalr	1760(ra) # 80004502 <create>
     argint(2, &minor) < 0 ||
    80004e2a:	c919                	beqz	a0,80004e40 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	004080e7          	jalr	4(ra) # 80002e30 <iunlockput>
  end_op();
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	7ee080e7          	jalr	2030(ra) # 80003622 <end_op>
  return 0;
    80004e3c:	4501                	li	a0,0
    80004e3e:	a031                	j	80004e4a <sys_mknod+0x80>
    end_op();
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	7e2080e7          	jalr	2018(ra) # 80003622 <end_op>
    return -1;
    80004e48:	557d                	li	a0,-1
}
    80004e4a:	60ea                	ld	ra,152(sp)
    80004e4c:	644a                	ld	s0,144(sp)
    80004e4e:	610d                	addi	sp,sp,160
    80004e50:	8082                	ret

0000000080004e52 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e52:	7135                	addi	sp,sp,-160
    80004e54:	ed06                	sd	ra,152(sp)
    80004e56:	e922                	sd	s0,144(sp)
    80004e58:	e526                	sd	s1,136(sp)
    80004e5a:	e14a                	sd	s2,128(sp)
    80004e5c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e5e:	ffffc097          	auipc	ra,0xffffc
    80004e62:	fea080e7          	jalr	-22(ra) # 80000e48 <myproc>
    80004e66:	892a                	mv	s2,a0
  
  begin_op();
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	73a080e7          	jalr	1850(ra) # 800035a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e70:	08000613          	li	a2,128
    80004e74:	f6040593          	addi	a1,s0,-160
    80004e78:	4501                	li	a0,0
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	0be080e7          	jalr	190(ra) # 80001f38 <argstr>
    80004e82:	04054b63          	bltz	a0,80004ed8 <sys_chdir+0x86>
    80004e86:	f6040513          	addi	a0,s0,-160
    80004e8a:	ffffe097          	auipc	ra,0xffffe
    80004e8e:	4fc080e7          	jalr	1276(ra) # 80003386 <namei>
    80004e92:	84aa                	mv	s1,a0
    80004e94:	c131                	beqz	a0,80004ed8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	c92080e7          	jalr	-878(ra) # 80002b28 <ilock>
  if(ip->type != T_DIR){
    80004e9e:	04449703          	lh	a4,68(s1)
    80004ea2:	4785                	li	a5,1
    80004ea4:	04f71063          	bne	a4,a5,80004ee4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ea8:	8526                	mv	a0,s1
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	d40080e7          	jalr	-704(ra) # 80002bea <iunlock>
  iput(p->cwd);
    80004eb2:	15093503          	ld	a0,336(s2)
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	ed2080e7          	jalr	-302(ra) # 80002d88 <iput>
  end_op();
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	764080e7          	jalr	1892(ra) # 80003622 <end_op>
  p->cwd = ip;
    80004ec6:	14993823          	sd	s1,336(s2)
  return 0;
    80004eca:	4501                	li	a0,0
}
    80004ecc:	60ea                	ld	ra,152(sp)
    80004ece:	644a                	ld	s0,144(sp)
    80004ed0:	64aa                	ld	s1,136(sp)
    80004ed2:	690a                	ld	s2,128(sp)
    80004ed4:	610d                	addi	sp,sp,160
    80004ed6:	8082                	ret
    end_op();
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	74a080e7          	jalr	1866(ra) # 80003622 <end_op>
    return -1;
    80004ee0:	557d                	li	a0,-1
    80004ee2:	b7ed                	j	80004ecc <sys_chdir+0x7a>
    iunlockput(ip);
    80004ee4:	8526                	mv	a0,s1
    80004ee6:	ffffe097          	auipc	ra,0xffffe
    80004eea:	f4a080e7          	jalr	-182(ra) # 80002e30 <iunlockput>
    end_op();
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	734080e7          	jalr	1844(ra) # 80003622 <end_op>
    return -1;
    80004ef6:	557d                	li	a0,-1
    80004ef8:	bfd1                	j	80004ecc <sys_chdir+0x7a>

0000000080004efa <sys_exec>:

uint64
sys_exec(void)
{
    80004efa:	7145                	addi	sp,sp,-464
    80004efc:	e786                	sd	ra,456(sp)
    80004efe:	e3a2                	sd	s0,448(sp)
    80004f00:	ff26                	sd	s1,440(sp)
    80004f02:	fb4a                	sd	s2,432(sp)
    80004f04:	f74e                	sd	s3,424(sp)
    80004f06:	f352                	sd	s4,416(sp)
    80004f08:	ef56                	sd	s5,408(sp)
    80004f0a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f0c:	08000613          	li	a2,128
    80004f10:	f4040593          	addi	a1,s0,-192
    80004f14:	4501                	li	a0,0
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	022080e7          	jalr	34(ra) # 80001f38 <argstr>
    return -1;
    80004f1e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f20:	0c054a63          	bltz	a0,80004ff4 <sys_exec+0xfa>
    80004f24:	e3840593          	addi	a1,s0,-456
    80004f28:	4505                	li	a0,1
    80004f2a:	ffffd097          	auipc	ra,0xffffd
    80004f2e:	fec080e7          	jalr	-20(ra) # 80001f16 <argaddr>
    80004f32:	0c054163          	bltz	a0,80004ff4 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f36:	10000613          	li	a2,256
    80004f3a:	4581                	li	a1,0
    80004f3c:	e4040513          	addi	a0,s0,-448
    80004f40:	ffffb097          	auipc	ra,0xffffb
    80004f44:	238080e7          	jalr	568(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f48:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f4c:	89a6                	mv	s3,s1
    80004f4e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f50:	02000a13          	li	s4,32
    80004f54:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f58:	00391513          	slli	a0,s2,0x3
    80004f5c:	e3040593          	addi	a1,s0,-464
    80004f60:	e3843783          	ld	a5,-456(s0)
    80004f64:	953e                	add	a0,a0,a5
    80004f66:	ffffd097          	auipc	ra,0xffffd
    80004f6a:	ef4080e7          	jalr	-268(ra) # 80001e5a <fetchaddr>
    80004f6e:	02054a63          	bltz	a0,80004fa2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f72:	e3043783          	ld	a5,-464(s0)
    80004f76:	c3b9                	beqz	a5,80004fbc <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f78:	ffffb097          	auipc	ra,0xffffb
    80004f7c:	1a0080e7          	jalr	416(ra) # 80000118 <kalloc>
    80004f80:	85aa                	mv	a1,a0
    80004f82:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f86:	cd11                	beqz	a0,80004fa2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f88:	6605                	lui	a2,0x1
    80004f8a:	e3043503          	ld	a0,-464(s0)
    80004f8e:	ffffd097          	auipc	ra,0xffffd
    80004f92:	f1e080e7          	jalr	-226(ra) # 80001eac <fetchstr>
    80004f96:	00054663          	bltz	a0,80004fa2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f9a:	0905                	addi	s2,s2,1
    80004f9c:	09a1                	addi	s3,s3,8
    80004f9e:	fb491be3          	bne	s2,s4,80004f54 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa2:	10048913          	addi	s2,s1,256
    80004fa6:	6088                	ld	a0,0(s1)
    80004fa8:	c529                	beqz	a0,80004ff2 <sys_exec+0xf8>
    kfree(argv[i]);
    80004faa:	ffffb097          	auipc	ra,0xffffb
    80004fae:	072080e7          	jalr	114(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb2:	04a1                	addi	s1,s1,8
    80004fb4:	ff2499e3          	bne	s1,s2,80004fa6 <sys_exec+0xac>
  return -1;
    80004fb8:	597d                	li	s2,-1
    80004fba:	a82d                	j	80004ff4 <sys_exec+0xfa>
      argv[i] = 0;
    80004fbc:	0a8e                	slli	s5,s5,0x3
    80004fbe:	fc040793          	addi	a5,s0,-64
    80004fc2:	9abe                	add	s5,s5,a5
    80004fc4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fc8:	e4040593          	addi	a1,s0,-448
    80004fcc:	f4040513          	addi	a0,s0,-192
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	0fe080e7          	jalr	254(ra) # 800040ce <exec>
    80004fd8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fda:	10048993          	addi	s3,s1,256
    80004fde:	6088                	ld	a0,0(s1)
    80004fe0:	c911                	beqz	a0,80004ff4 <sys_exec+0xfa>
    kfree(argv[i]);
    80004fe2:	ffffb097          	auipc	ra,0xffffb
    80004fe6:	03a080e7          	jalr	58(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fea:	04a1                	addi	s1,s1,8
    80004fec:	ff3499e3          	bne	s1,s3,80004fde <sys_exec+0xe4>
    80004ff0:	a011                	j	80004ff4 <sys_exec+0xfa>
  return -1;
    80004ff2:	597d                	li	s2,-1
}
    80004ff4:	854a                	mv	a0,s2
    80004ff6:	60be                	ld	ra,456(sp)
    80004ff8:	641e                	ld	s0,448(sp)
    80004ffa:	74fa                	ld	s1,440(sp)
    80004ffc:	795a                	ld	s2,432(sp)
    80004ffe:	79ba                	ld	s3,424(sp)
    80005000:	7a1a                	ld	s4,416(sp)
    80005002:	6afa                	ld	s5,408(sp)
    80005004:	6179                	addi	sp,sp,464
    80005006:	8082                	ret

0000000080005008 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005008:	7139                	addi	sp,sp,-64
    8000500a:	fc06                	sd	ra,56(sp)
    8000500c:	f822                	sd	s0,48(sp)
    8000500e:	f426                	sd	s1,40(sp)
    80005010:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	e36080e7          	jalr	-458(ra) # 80000e48 <myproc>
    8000501a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000501c:	fd840593          	addi	a1,s0,-40
    80005020:	4501                	li	a0,0
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	ef4080e7          	jalr	-268(ra) # 80001f16 <argaddr>
    return -1;
    8000502a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000502c:	0e054063          	bltz	a0,8000510c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005030:	fc840593          	addi	a1,s0,-56
    80005034:	fd040513          	addi	a0,s0,-48
    80005038:	fffff097          	auipc	ra,0xfffff
    8000503c:	d66080e7          	jalr	-666(ra) # 80003d9e <pipealloc>
    return -1;
    80005040:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005042:	0c054563          	bltz	a0,8000510c <sys_pipe+0x104>
  fd0 = -1;
    80005046:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000504a:	fd043503          	ld	a0,-48(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	472080e7          	jalr	1138(ra) # 800044c0 <fdalloc>
    80005056:	fca42223          	sw	a0,-60(s0)
    8000505a:	08054c63          	bltz	a0,800050f2 <sys_pipe+0xea>
    8000505e:	fc843503          	ld	a0,-56(s0)
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	45e080e7          	jalr	1118(ra) # 800044c0 <fdalloc>
    8000506a:	fca42023          	sw	a0,-64(s0)
    8000506e:	06054863          	bltz	a0,800050de <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005072:	4691                	li	a3,4
    80005074:	fc440613          	addi	a2,s0,-60
    80005078:	fd843583          	ld	a1,-40(s0)
    8000507c:	68a8                	ld	a0,80(s1)
    8000507e:	ffffc097          	auipc	ra,0xffffc
    80005082:	a8c080e7          	jalr	-1396(ra) # 80000b0a <copyout>
    80005086:	02054063          	bltz	a0,800050a6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000508a:	4691                	li	a3,4
    8000508c:	fc040613          	addi	a2,s0,-64
    80005090:	fd843583          	ld	a1,-40(s0)
    80005094:	0591                	addi	a1,a1,4
    80005096:	68a8                	ld	a0,80(s1)
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	a72080e7          	jalr	-1422(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050a0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050a2:	06055563          	bgez	a0,8000510c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050a6:	fc442783          	lw	a5,-60(s0)
    800050aa:	07e9                	addi	a5,a5,26
    800050ac:	078e                	slli	a5,a5,0x3
    800050ae:	97a6                	add	a5,a5,s1
    800050b0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050b4:	fc042503          	lw	a0,-64(s0)
    800050b8:	0569                	addi	a0,a0,26
    800050ba:	050e                	slli	a0,a0,0x3
    800050bc:	9526                	add	a0,a0,s1
    800050be:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050c2:	fd043503          	ld	a0,-48(s0)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	9a8080e7          	jalr	-1624(ra) # 80003a6e <fileclose>
    fileclose(wf);
    800050ce:	fc843503          	ld	a0,-56(s0)
    800050d2:	fffff097          	auipc	ra,0xfffff
    800050d6:	99c080e7          	jalr	-1636(ra) # 80003a6e <fileclose>
    return -1;
    800050da:	57fd                	li	a5,-1
    800050dc:	a805                	j	8000510c <sys_pipe+0x104>
    if(fd0 >= 0)
    800050de:	fc442783          	lw	a5,-60(s0)
    800050e2:	0007c863          	bltz	a5,800050f2 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050e6:	01a78513          	addi	a0,a5,26
    800050ea:	050e                	slli	a0,a0,0x3
    800050ec:	9526                	add	a0,a0,s1
    800050ee:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050f2:	fd043503          	ld	a0,-48(s0)
    800050f6:	fffff097          	auipc	ra,0xfffff
    800050fa:	978080e7          	jalr	-1672(ra) # 80003a6e <fileclose>
    fileclose(wf);
    800050fe:	fc843503          	ld	a0,-56(s0)
    80005102:	fffff097          	auipc	ra,0xfffff
    80005106:	96c080e7          	jalr	-1684(ra) # 80003a6e <fileclose>
    return -1;
    8000510a:	57fd                	li	a5,-1
}
    8000510c:	853e                	mv	a0,a5
    8000510e:	70e2                	ld	ra,56(sp)
    80005110:	7442                	ld	s0,48(sp)
    80005112:	74a2                	ld	s1,40(sp)
    80005114:	6121                	addi	sp,sp,64
    80005116:	8082                	ret

0000000080005118 <sys_symlink>:


uint64
sys_symlink(void)
{
    80005118:	712d                	addi	sp,sp,-288
    8000511a:	ee06                	sd	ra,280(sp)
    8000511c:	ea22                	sd	s0,272(sp)
    8000511e:	e626                	sd	s1,264(sp)
    80005120:	1200                	addi	s0,sp,288
  char target[MAXPATH];
  memset(target, 0, sizeof(target));
    80005122:	08000613          	li	a2,128
    80005126:	4581                	li	a1,0
    80005128:	f6040513          	addi	a0,s0,-160
    8000512c:	ffffb097          	auipc	ra,0xffffb
    80005130:	04c080e7          	jalr	76(ra) # 80000178 <memset>
  char path[MAXPATH];
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    80005134:	08000613          	li	a2,128
    80005138:	f6040593          	addi	a1,s0,-160
    8000513c:	4501                	li	a0,0
    8000513e:	ffffd097          	auipc	ra,0xffffd
    80005142:	dfa080e7          	jalr	-518(ra) # 80001f38 <argstr>
    return -1;
    80005146:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    80005148:	04054c63          	bltz	a0,800051a0 <sys_symlink+0x88>
    8000514c:	08000613          	li	a2,128
    80005150:	ee040593          	addi	a1,s0,-288
    80005154:	4505                	li	a0,1
    80005156:	ffffd097          	auipc	ra,0xffffd
    8000515a:	de2080e7          	jalr	-542(ra) # 80001f38 <argstr>
    return -1;
    8000515e:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0){
    80005160:	04054063          	bltz	a0,800051a0 <sys_symlink+0x88>
  }
  
  struct inode *ip;

  begin_op();
    80005164:	ffffe097          	auipc	ra,0xffffe
    80005168:	43e080e7          	jalr	1086(ra) # 800035a2 <begin_op>
  if((ip = create(path, T_SYMLINK, 0, 0)) == 0){
    8000516c:	4681                	li	a3,0
    8000516e:	4601                	li	a2,0
    80005170:	4591                	li	a1,4
    80005172:	ee040513          	addi	a0,s0,-288
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	38c080e7          	jalr	908(ra) # 80004502 <create>
    8000517e:	84aa                	mv	s1,a0
    80005180:	c515                	beqz	a0,800051ac <sys_symlink+0x94>
    end_op();
    return -1;
  }

  if(writei(ip, 0, (uint64)target, 0, MAXPATH) != MAXPATH){
    80005182:	08000713          	li	a4,128
    80005186:	4681                	li	a3,0
    80005188:	f6040613          	addi	a2,s0,-160
    8000518c:	4581                	li	a1,0
    8000518e:	ffffe097          	auipc	ra,0xffffe
    80005192:	dec080e7          	jalr	-532(ra) # 80002f7a <writei>
    80005196:	08000713          	li	a4,128
    // panic("symlink write failed");
    return -1;
    8000519a:	57fd                	li	a5,-1
  if(writei(ip, 0, (uint64)target, 0, MAXPATH) != MAXPATH){
    8000519c:	00e50e63          	beq	a0,a4,800051b8 <sys_symlink+0xa0>
  }

  iunlockput(ip);
  end_op();
  return 0;
    800051a0:	853e                	mv	a0,a5
    800051a2:	60f2                	ld	ra,280(sp)
    800051a4:	6452                	ld	s0,272(sp)
    800051a6:	64b2                	ld	s1,264(sp)
    800051a8:	6115                	addi	sp,sp,288
    800051aa:	8082                	ret
    end_op();
    800051ac:	ffffe097          	auipc	ra,0xffffe
    800051b0:	476080e7          	jalr	1142(ra) # 80003622 <end_op>
    return -1;
    800051b4:	57fd                	li	a5,-1
    800051b6:	b7ed                	j	800051a0 <sys_symlink+0x88>
  iunlockput(ip);
    800051b8:	8526                	mv	a0,s1
    800051ba:	ffffe097          	auipc	ra,0xffffe
    800051be:	c76080e7          	jalr	-906(ra) # 80002e30 <iunlockput>
  end_op();
    800051c2:	ffffe097          	auipc	ra,0xffffe
    800051c6:	460080e7          	jalr	1120(ra) # 80003622 <end_op>
  return 0;
    800051ca:	4781                	li	a5,0
    800051cc:	bfd1                	j	800051a0 <sys_symlink+0x88>
	...

00000000800051d0 <kernelvec>:
    800051d0:	7111                	addi	sp,sp,-256
    800051d2:	e006                	sd	ra,0(sp)
    800051d4:	e40a                	sd	sp,8(sp)
    800051d6:	e80e                	sd	gp,16(sp)
    800051d8:	ec12                	sd	tp,24(sp)
    800051da:	f016                	sd	t0,32(sp)
    800051dc:	f41a                	sd	t1,40(sp)
    800051de:	f81e                	sd	t2,48(sp)
    800051e0:	fc22                	sd	s0,56(sp)
    800051e2:	e0a6                	sd	s1,64(sp)
    800051e4:	e4aa                	sd	a0,72(sp)
    800051e6:	e8ae                	sd	a1,80(sp)
    800051e8:	ecb2                	sd	a2,88(sp)
    800051ea:	f0b6                	sd	a3,96(sp)
    800051ec:	f4ba                	sd	a4,104(sp)
    800051ee:	f8be                	sd	a5,112(sp)
    800051f0:	fcc2                	sd	a6,120(sp)
    800051f2:	e146                	sd	a7,128(sp)
    800051f4:	e54a                	sd	s2,136(sp)
    800051f6:	e94e                	sd	s3,144(sp)
    800051f8:	ed52                	sd	s4,152(sp)
    800051fa:	f156                	sd	s5,160(sp)
    800051fc:	f55a                	sd	s6,168(sp)
    800051fe:	f95e                	sd	s7,176(sp)
    80005200:	fd62                	sd	s8,184(sp)
    80005202:	e1e6                	sd	s9,192(sp)
    80005204:	e5ea                	sd	s10,200(sp)
    80005206:	e9ee                	sd	s11,208(sp)
    80005208:	edf2                	sd	t3,216(sp)
    8000520a:	f1f6                	sd	t4,224(sp)
    8000520c:	f5fa                	sd	t5,232(sp)
    8000520e:	f9fe                	sd	t6,240(sp)
    80005210:	b17fc0ef          	jal	ra,80001d26 <kerneltrap>
    80005214:	6082                	ld	ra,0(sp)
    80005216:	6122                	ld	sp,8(sp)
    80005218:	61c2                	ld	gp,16(sp)
    8000521a:	7282                	ld	t0,32(sp)
    8000521c:	7322                	ld	t1,40(sp)
    8000521e:	73c2                	ld	t2,48(sp)
    80005220:	7462                	ld	s0,56(sp)
    80005222:	6486                	ld	s1,64(sp)
    80005224:	6526                	ld	a0,72(sp)
    80005226:	65c6                	ld	a1,80(sp)
    80005228:	6666                	ld	a2,88(sp)
    8000522a:	7686                	ld	a3,96(sp)
    8000522c:	7726                	ld	a4,104(sp)
    8000522e:	77c6                	ld	a5,112(sp)
    80005230:	7866                	ld	a6,120(sp)
    80005232:	688a                	ld	a7,128(sp)
    80005234:	692a                	ld	s2,136(sp)
    80005236:	69ca                	ld	s3,144(sp)
    80005238:	6a6a                	ld	s4,152(sp)
    8000523a:	7a8a                	ld	s5,160(sp)
    8000523c:	7b2a                	ld	s6,168(sp)
    8000523e:	7bca                	ld	s7,176(sp)
    80005240:	7c6a                	ld	s8,184(sp)
    80005242:	6c8e                	ld	s9,192(sp)
    80005244:	6d2e                	ld	s10,200(sp)
    80005246:	6dce                	ld	s11,208(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
    80005256:	00000013          	nop
    8000525a:	00000013          	nop
    8000525e:	0001                	nop

0000000080005260 <timervec>:
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	e10c                	sd	a1,0(a0)
    80005266:	e510                	sd	a2,8(a0)
    80005268:	e914                	sd	a3,16(a0)
    8000526a:	6d0c                	ld	a1,24(a0)
    8000526c:	7110                	ld	a2,32(a0)
    8000526e:	6194                	ld	a3,0(a1)
    80005270:	96b2                	add	a3,a3,a2
    80005272:	e194                	sd	a3,0(a1)
    80005274:	4589                	li	a1,2
    80005276:	14459073          	csrw	sip,a1
    8000527a:	6914                	ld	a3,16(a0)
    8000527c:	6510                	ld	a2,8(a0)
    8000527e:	610c                	ld	a1,0(a0)
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	30200073          	mret
	...

000000008000528a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e422                	sd	s0,8(sp)
    8000528e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005290:	0c0007b7          	lui	a5,0xc000
    80005294:	4705                	li	a4,1
    80005296:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005298:	c3d8                	sw	a4,4(a5)
}
    8000529a:	6422                	ld	s0,8(sp)
    8000529c:	0141                	addi	sp,sp,16
    8000529e:	8082                	ret

00000000800052a0 <plicinithart>:

void
plicinithart(void)
{
    800052a0:	1141                	addi	sp,sp,-16
    800052a2:	e406                	sd	ra,8(sp)
    800052a4:	e022                	sd	s0,0(sp)
    800052a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	b74080e7          	jalr	-1164(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b0:	0085171b          	slliw	a4,a0,0x8
    800052b4:	0c0027b7          	lui	a5,0xc002
    800052b8:	97ba                	add	a5,a5,a4
    800052ba:	40200713          	li	a4,1026
    800052be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c2:	00d5151b          	slliw	a0,a0,0xd
    800052c6:	0c2017b7          	lui	a5,0xc201
    800052ca:	953e                	add	a0,a0,a5
    800052cc:	00052023          	sw	zero,0(a0)
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052d8:	1141                	addi	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	b3c080e7          	jalr	-1220(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e8:	00d5179b          	slliw	a5,a0,0xd
    800052ec:	0c201537          	lui	a0,0xc201
    800052f0:	953e                	add	a0,a0,a5
  return irq;
}
    800052f2:	4148                	lw	a0,4(a0)
    800052f4:	60a2                	ld	ra,8(sp)
    800052f6:	6402                	ld	s0,0(sp)
    800052f8:	0141                	addi	sp,sp,16
    800052fa:	8082                	ret

00000000800052fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052fc:	1101                	addi	sp,sp,-32
    800052fe:	ec06                	sd	ra,24(sp)
    80005300:	e822                	sd	s0,16(sp)
    80005302:	e426                	sd	s1,8(sp)
    80005304:	1000                	addi	s0,sp,32
    80005306:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	b14080e7          	jalr	-1260(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005310:	00d5151b          	slliw	a0,a0,0xd
    80005314:	0c2017b7          	lui	a5,0xc201
    80005318:	97aa                	add	a5,a5,a0
    8000531a:	c3c4                	sw	s1,4(a5)
}
    8000531c:	60e2                	ld	ra,24(sp)
    8000531e:	6442                	ld	s0,16(sp)
    80005320:	64a2                	ld	s1,8(sp)
    80005322:	6105                	addi	sp,sp,32
    80005324:	8082                	ret

0000000080005326 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005326:	1141                	addi	sp,sp,-16
    80005328:	e406                	sd	ra,8(sp)
    8000532a:	e022                	sd	s0,0(sp)
    8000532c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000532e:	479d                	li	a5,7
    80005330:	06a7c963          	blt	a5,a0,800053a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005334:	00011797          	auipc	a5,0x11
    80005338:	ccc78793          	addi	a5,a5,-820 # 80016000 <disk>
    8000533c:	00a78733          	add	a4,a5,a0
    80005340:	6789                	lui	a5,0x2
    80005342:	97ba                	add	a5,a5,a4
    80005344:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005348:	e7ad                	bnez	a5,800053b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000534a:	00451793          	slli	a5,a0,0x4
    8000534e:	00013717          	auipc	a4,0x13
    80005352:	cb270713          	addi	a4,a4,-846 # 80018000 <disk+0x2000>
    80005356:	6314                	ld	a3,0(a4)
    80005358:	96be                	add	a3,a3,a5
    8000535a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000535e:	6314                	ld	a3,0(a4)
    80005360:	96be                	add	a3,a3,a5
    80005362:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005366:	6314                	ld	a3,0(a4)
    80005368:	96be                	add	a3,a3,a5
    8000536a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000536e:	6318                	ld	a4,0(a4)
    80005370:	97ba                	add	a5,a5,a4
    80005372:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005376:	00011797          	auipc	a5,0x11
    8000537a:	c8a78793          	addi	a5,a5,-886 # 80016000 <disk>
    8000537e:	97aa                	add	a5,a5,a0
    80005380:	6509                	lui	a0,0x2
    80005382:	953e                	add	a0,a0,a5
    80005384:	4785                	li	a5,1
    80005386:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000538a:	00013517          	auipc	a0,0x13
    8000538e:	c8e50513          	addi	a0,a0,-882 # 80018018 <disk+0x2018>
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	2fe080e7          	jalr	766(ra) # 80001690 <wakeup>
}
    8000539a:	60a2                	ld	ra,8(sp)
    8000539c:	6402                	ld	s0,0(sp)
    8000539e:	0141                	addi	sp,sp,16
    800053a0:	8082                	ret
    panic("free_desc 1");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	34e50513          	addi	a0,a0,846 # 800086f0 <syscalls+0x328>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	a1e080e7          	jalr	-1506(ra) # 80005dc8 <panic>
    panic("free_desc 2");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	34e50513          	addi	a0,a0,846 # 80008700 <syscalls+0x338>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	a0e080e7          	jalr	-1522(ra) # 80005dc8 <panic>

00000000800053c2 <virtio_disk_init>:
{
    800053c2:	1101                	addi	sp,sp,-32
    800053c4:	ec06                	sd	ra,24(sp)
    800053c6:	e822                	sd	s0,16(sp)
    800053c8:	e426                	sd	s1,8(sp)
    800053ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053cc:	00003597          	auipc	a1,0x3
    800053d0:	34458593          	addi	a1,a1,836 # 80008710 <syscalls+0x348>
    800053d4:	00013517          	auipc	a0,0x13
    800053d8:	d5450513          	addi	a0,a0,-684 # 80018128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	ea6080e7          	jalr	-346(ra) # 80006282 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	4398                	lw	a4,0(a5)
    800053ea:	2701                	sext.w	a4,a4
    800053ec:	747277b7          	lui	a5,0x74727
    800053f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053f4:	0ef71163          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	43dc                	lw	a5,4(a5)
    800053fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005400:	4705                	li	a4,1
    80005402:	0ce79a63          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005406:	100017b7          	lui	a5,0x10001
    8000540a:	479c                	lw	a5,8(a5)
    8000540c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000540e:	4709                	li	a4,2
    80005410:	0ce79363          	bne	a5,a4,800054d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	47d8                	lw	a4,12(a5)
    8000541a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000541c:	554d47b7          	lui	a5,0x554d4
    80005420:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005424:	0af71963          	bne	a4,a5,800054d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	100017b7          	lui	a5,0x10001
    8000542c:	4705                	li	a4,1
    8000542e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005430:	470d                	li	a4,3
    80005432:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005434:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005436:	c7ffe737          	lui	a4,0xc7ffe
    8000543a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd51f>
    8000543e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005440:	2701                	sext.w	a4,a4
    80005442:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005444:	472d                	li	a4,11
    80005446:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005448:	473d                	li	a4,15
    8000544a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000544c:	6705                	lui	a4,0x1
    8000544e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005450:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005454:	5bdc                	lw	a5,52(a5)
    80005456:	2781                	sext.w	a5,a5
  if(max == 0)
    80005458:	c7d9                	beqz	a5,800054e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000545a:	471d                	li	a4,7
    8000545c:	08f77d63          	bgeu	a4,a5,800054f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005460:	100014b7          	lui	s1,0x10001
    80005464:	47a1                	li	a5,8
    80005466:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005468:	6609                	lui	a2,0x2
    8000546a:	4581                	li	a1,0
    8000546c:	00011517          	auipc	a0,0x11
    80005470:	b9450513          	addi	a0,a0,-1132 # 80016000 <disk>
    80005474:	ffffb097          	auipc	ra,0xffffb
    80005478:	d04080e7          	jalr	-764(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000547c:	00011717          	auipc	a4,0x11
    80005480:	b8470713          	addi	a4,a4,-1148 # 80016000 <disk>
    80005484:	00c75793          	srli	a5,a4,0xc
    80005488:	2781                	sext.w	a5,a5
    8000548a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000548c:	00013797          	auipc	a5,0x13
    80005490:	b7478793          	addi	a5,a5,-1164 # 80018000 <disk+0x2000>
    80005494:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005496:	00011717          	auipc	a4,0x11
    8000549a:	bea70713          	addi	a4,a4,-1046 # 80016080 <disk+0x80>
    8000549e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054a0:	00012717          	auipc	a4,0x12
    800054a4:	b6070713          	addi	a4,a4,-1184 # 80017000 <disk+0x1000>
    800054a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054aa:	4705                	li	a4,1
    800054ac:	00e78c23          	sb	a4,24(a5)
    800054b0:	00e78ca3          	sb	a4,25(a5)
    800054b4:	00e78d23          	sb	a4,26(a5)
    800054b8:	00e78da3          	sb	a4,27(a5)
    800054bc:	00e78e23          	sb	a4,28(a5)
    800054c0:	00e78ea3          	sb	a4,29(a5)
    800054c4:	00e78f23          	sb	a4,30(a5)
    800054c8:	00e78fa3          	sb	a4,31(a5)
}
    800054cc:	60e2                	ld	ra,24(sp)
    800054ce:	6442                	ld	s0,16(sp)
    800054d0:	64a2                	ld	s1,8(sp)
    800054d2:	6105                	addi	sp,sp,32
    800054d4:	8082                	ret
    panic("could not find virtio disk");
    800054d6:	00003517          	auipc	a0,0x3
    800054da:	24a50513          	addi	a0,a0,586 # 80008720 <syscalls+0x358>
    800054de:	00001097          	auipc	ra,0x1
    800054e2:	8ea080e7          	jalr	-1814(ra) # 80005dc8 <panic>
    panic("virtio disk has no queue 0");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	25a50513          	addi	a0,a0,602 # 80008740 <syscalls+0x378>
    800054ee:	00001097          	auipc	ra,0x1
    800054f2:	8da080e7          	jalr	-1830(ra) # 80005dc8 <panic>
    panic("virtio disk max queue too short");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	26a50513          	addi	a0,a0,618 # 80008760 <syscalls+0x398>
    800054fe:	00001097          	auipc	ra,0x1
    80005502:	8ca080e7          	jalr	-1846(ra) # 80005dc8 <panic>

0000000080005506 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005506:	7159                	addi	sp,sp,-112
    80005508:	f486                	sd	ra,104(sp)
    8000550a:	f0a2                	sd	s0,96(sp)
    8000550c:	eca6                	sd	s1,88(sp)
    8000550e:	e8ca                	sd	s2,80(sp)
    80005510:	e4ce                	sd	s3,72(sp)
    80005512:	e0d2                	sd	s4,64(sp)
    80005514:	fc56                	sd	s5,56(sp)
    80005516:	f85a                	sd	s6,48(sp)
    80005518:	f45e                	sd	s7,40(sp)
    8000551a:	f062                	sd	s8,32(sp)
    8000551c:	ec66                	sd	s9,24(sp)
    8000551e:	e86a                	sd	s10,16(sp)
    80005520:	1880                	addi	s0,sp,112
    80005522:	892a                	mv	s2,a0
    80005524:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005526:	00c52c83          	lw	s9,12(a0)
    8000552a:	001c9c9b          	slliw	s9,s9,0x1
    8000552e:	1c82                	slli	s9,s9,0x20
    80005530:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005534:	00013517          	auipc	a0,0x13
    80005538:	bf450513          	addi	a0,a0,-1036 # 80018128 <disk+0x2128>
    8000553c:	00001097          	auipc	ra,0x1
    80005540:	dd6080e7          	jalr	-554(ra) # 80006312 <acquire>
  for(int i = 0; i < 3; i++){
    80005544:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005546:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005548:	00011b97          	auipc	s7,0x11
    8000554c:	ab8b8b93          	addi	s7,s7,-1352 # 80016000 <disk>
    80005550:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005552:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005554:	8a4e                	mv	s4,s3
    80005556:	a051                	j	800055da <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005558:	00fb86b3          	add	a3,s7,a5
    8000555c:	96da                	add	a3,a3,s6
    8000555e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005562:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005564:	0207c563          	bltz	a5,8000558e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005568:	2485                	addiw	s1,s1,1
    8000556a:	0711                	addi	a4,a4,4
    8000556c:	25548063          	beq	s1,s5,800057ac <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005570:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005572:	00013697          	auipc	a3,0x13
    80005576:	aa668693          	addi	a3,a3,-1370 # 80018018 <disk+0x2018>
    8000557a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000557c:	0006c583          	lbu	a1,0(a3)
    80005580:	fde1                	bnez	a1,80005558 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005582:	2785                	addiw	a5,a5,1
    80005584:	0685                	addi	a3,a3,1
    80005586:	ff879be3          	bne	a5,s8,8000557c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000558a:	57fd                	li	a5,-1
    8000558c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000558e:	02905a63          	blez	s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005592:	f9042503          	lw	a0,-112(s0)
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	d90080e7          	jalr	-624(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    8000559e:	4785                	li	a5,1
    800055a0:	0297d163          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055a4:	f9442503          	lw	a0,-108(s0)
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	d7e080e7          	jalr	-642(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    800055b0:	4789                	li	a5,2
    800055b2:	0097d863          	bge	a5,s1,800055c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055b6:	f9842503          	lw	a0,-104(s0)
    800055ba:	00000097          	auipc	ra,0x0
    800055be:	d6c080e7          	jalr	-660(ra) # 80005326 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055c2:	00013597          	auipc	a1,0x13
    800055c6:	b6658593          	addi	a1,a1,-1178 # 80018128 <disk+0x2128>
    800055ca:	00013517          	auipc	a0,0x13
    800055ce:	a4e50513          	addi	a0,a0,-1458 # 80018018 <disk+0x2018>
    800055d2:	ffffc097          	auipc	ra,0xffffc
    800055d6:	f32080e7          	jalr	-206(ra) # 80001504 <sleep>
  for(int i = 0; i < 3; i++){
    800055da:	f9040713          	addi	a4,s0,-112
    800055de:	84ce                	mv	s1,s3
    800055e0:	bf41                	j	80005570 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055e2:	20058713          	addi	a4,a1,512
    800055e6:	00471693          	slli	a3,a4,0x4
    800055ea:	00011717          	auipc	a4,0x11
    800055ee:	a1670713          	addi	a4,a4,-1514 # 80016000 <disk>
    800055f2:	9736                	add	a4,a4,a3
    800055f4:	4685                	li	a3,1
    800055f6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055fa:	20058713          	addi	a4,a1,512
    800055fe:	00471693          	slli	a3,a4,0x4
    80005602:	00011717          	auipc	a4,0x11
    80005606:	9fe70713          	addi	a4,a4,-1538 # 80016000 <disk>
    8000560a:	9736                	add	a4,a4,a3
    8000560c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005610:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005614:	7679                	lui	a2,0xffffe
    80005616:	963e                	add	a2,a2,a5
    80005618:	00013697          	auipc	a3,0x13
    8000561c:	9e868693          	addi	a3,a3,-1560 # 80018000 <disk+0x2000>
    80005620:	6298                	ld	a4,0(a3)
    80005622:	9732                	add	a4,a4,a2
    80005624:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005626:	6298                	ld	a4,0(a3)
    80005628:	9732                	add	a4,a4,a2
    8000562a:	4541                	li	a0,16
    8000562c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000562e:	6298                	ld	a4,0(a3)
    80005630:	9732                	add	a4,a4,a2
    80005632:	4505                	li	a0,1
    80005634:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442703          	lw	a4,-108(s0)
    8000563c:	6288                	ld	a0,0(a3)
    8000563e:	962a                	add	a2,a2,a0
    80005640:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffdcdce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005644:	0712                	slli	a4,a4,0x4
    80005646:	6290                	ld	a2,0(a3)
    80005648:	963a                	add	a2,a2,a4
    8000564a:	05890513          	addi	a0,s2,88
    8000564e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005650:	6294                	ld	a3,0(a3)
    80005652:	96ba                	add	a3,a3,a4
    80005654:	40000613          	li	a2,1024
    80005658:	c690                	sw	a2,8(a3)
  if(write)
    8000565a:	140d0063          	beqz	s10,8000579a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000565e:	00013697          	auipc	a3,0x13
    80005662:	9a26b683          	ld	a3,-1630(a3) # 80018000 <disk+0x2000>
    80005666:	96ba                	add	a3,a3,a4
    80005668:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000566c:	00011817          	auipc	a6,0x11
    80005670:	99480813          	addi	a6,a6,-1644 # 80016000 <disk>
    80005674:	00013517          	auipc	a0,0x13
    80005678:	98c50513          	addi	a0,a0,-1652 # 80018000 <disk+0x2000>
    8000567c:	6114                	ld	a3,0(a0)
    8000567e:	96ba                	add	a3,a3,a4
    80005680:	00c6d603          	lhu	a2,12(a3)
    80005684:	00166613          	ori	a2,a2,1
    80005688:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000568c:	f9842683          	lw	a3,-104(s0)
    80005690:	6110                	ld	a2,0(a0)
    80005692:	9732                	add	a4,a4,a2
    80005694:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005698:	20058613          	addi	a2,a1,512
    8000569c:	0612                	slli	a2,a2,0x4
    8000569e:	9642                	add	a2,a2,a6
    800056a0:	577d                	li	a4,-1
    800056a2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056a6:	00469713          	slli	a4,a3,0x4
    800056aa:	6114                	ld	a3,0(a0)
    800056ac:	96ba                	add	a3,a3,a4
    800056ae:	03078793          	addi	a5,a5,48
    800056b2:	97c2                	add	a5,a5,a6
    800056b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056b6:	611c                	ld	a5,0(a0)
    800056b8:	97ba                	add	a5,a5,a4
    800056ba:	4685                	li	a3,1
    800056bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056be:	611c                	ld	a5,0(a0)
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	4809                	li	a6,2
    800056c4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056c8:	611c                	ld	a5,0(a0)
    800056ca:	973e                	add	a4,a4,a5
    800056cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056d4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056d8:	6518                	ld	a4,8(a0)
    800056da:	00275783          	lhu	a5,2(a4)
    800056de:	8b9d                	andi	a5,a5,7
    800056e0:	0786                	slli	a5,a5,0x1
    800056e2:	97ba                	add	a5,a5,a4
    800056e4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056e8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ec:	6518                	ld	a4,8(a0)
    800056ee:	00275783          	lhu	a5,2(a4)
    800056f2:	2785                	addiw	a5,a5,1
    800056f4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056f8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056fc:	100017b7          	lui	a5,0x10001
    80005700:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005704:	00492703          	lw	a4,4(s2)
    80005708:	4785                	li	a5,1
    8000570a:	02f71163          	bne	a4,a5,8000572c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000570e:	00013997          	auipc	s3,0x13
    80005712:	a1a98993          	addi	s3,s3,-1510 # 80018128 <disk+0x2128>
  while(b->disk == 1) {
    80005716:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005718:	85ce                	mv	a1,s3
    8000571a:	854a                	mv	a0,s2
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	de8080e7          	jalr	-536(ra) # 80001504 <sleep>
  while(b->disk == 1) {
    80005724:	00492783          	lw	a5,4(s2)
    80005728:	fe9788e3          	beq	a5,s1,80005718 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000572c:	f9042903          	lw	s2,-112(s0)
    80005730:	20090793          	addi	a5,s2,512
    80005734:	00479713          	slli	a4,a5,0x4
    80005738:	00011797          	auipc	a5,0x11
    8000573c:	8c878793          	addi	a5,a5,-1848 # 80016000 <disk>
    80005740:	97ba                	add	a5,a5,a4
    80005742:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005746:	00013997          	auipc	s3,0x13
    8000574a:	8ba98993          	addi	s3,s3,-1862 # 80018000 <disk+0x2000>
    8000574e:	00491713          	slli	a4,s2,0x4
    80005752:	0009b783          	ld	a5,0(s3)
    80005756:	97ba                	add	a5,a5,a4
    80005758:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000575c:	854a                	mv	a0,s2
    8000575e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005762:	00000097          	auipc	ra,0x0
    80005766:	bc4080e7          	jalr	-1084(ra) # 80005326 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000576a:	8885                	andi	s1,s1,1
    8000576c:	f0ed                	bnez	s1,8000574e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000576e:	00013517          	auipc	a0,0x13
    80005772:	9ba50513          	addi	a0,a0,-1606 # 80018128 <disk+0x2128>
    80005776:	00001097          	auipc	ra,0x1
    8000577a:	c50080e7          	jalr	-944(ra) # 800063c6 <release>
}
    8000577e:	70a6                	ld	ra,104(sp)
    80005780:	7406                	ld	s0,96(sp)
    80005782:	64e6                	ld	s1,88(sp)
    80005784:	6946                	ld	s2,80(sp)
    80005786:	69a6                	ld	s3,72(sp)
    80005788:	6a06                	ld	s4,64(sp)
    8000578a:	7ae2                	ld	s5,56(sp)
    8000578c:	7b42                	ld	s6,48(sp)
    8000578e:	7ba2                	ld	s7,40(sp)
    80005790:	7c02                	ld	s8,32(sp)
    80005792:	6ce2                	ld	s9,24(sp)
    80005794:	6d42                	ld	s10,16(sp)
    80005796:	6165                	addi	sp,sp,112
    80005798:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000579a:	00013697          	auipc	a3,0x13
    8000579e:	8666b683          	ld	a3,-1946(a3) # 80018000 <disk+0x2000>
    800057a2:	96ba                	add	a3,a3,a4
    800057a4:	4609                	li	a2,2
    800057a6:	00c69623          	sh	a2,12(a3)
    800057aa:	b5c9                	j	8000566c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ac:	f9042583          	lw	a1,-112(s0)
    800057b0:	20058793          	addi	a5,a1,512
    800057b4:	0792                	slli	a5,a5,0x4
    800057b6:	00011517          	auipc	a0,0x11
    800057ba:	8f250513          	addi	a0,a0,-1806 # 800160a8 <disk+0xa8>
    800057be:	953e                	add	a0,a0,a5
  if(write)
    800057c0:	e20d11e3          	bnez	s10,800055e2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057c4:	20058713          	addi	a4,a1,512
    800057c8:	00471693          	slli	a3,a4,0x4
    800057cc:	00011717          	auipc	a4,0x11
    800057d0:	83470713          	addi	a4,a4,-1996 # 80016000 <disk>
    800057d4:	9736                	add	a4,a4,a3
    800057d6:	0a072423          	sw	zero,168(a4)
    800057da:	b505                	j	800055fa <virtio_disk_rw+0xf4>

00000000800057dc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057dc:	1101                	addi	sp,sp,-32
    800057de:	ec06                	sd	ra,24(sp)
    800057e0:	e822                	sd	s0,16(sp)
    800057e2:	e426                	sd	s1,8(sp)
    800057e4:	e04a                	sd	s2,0(sp)
    800057e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057e8:	00013517          	auipc	a0,0x13
    800057ec:	94050513          	addi	a0,a0,-1728 # 80018128 <disk+0x2128>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	b22080e7          	jalr	-1246(ra) # 80006312 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057f8:	10001737          	lui	a4,0x10001
    800057fc:	533c                	lw	a5,96(a4)
    800057fe:	8b8d                	andi	a5,a5,3
    80005800:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005802:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005806:	00012797          	auipc	a5,0x12
    8000580a:	7fa78793          	addi	a5,a5,2042 # 80018000 <disk+0x2000>
    8000580e:	6b94                	ld	a3,16(a5)
    80005810:	0207d703          	lhu	a4,32(a5)
    80005814:	0026d783          	lhu	a5,2(a3)
    80005818:	06f70163          	beq	a4,a5,8000587a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000581c:	00010917          	auipc	s2,0x10
    80005820:	7e490913          	addi	s2,s2,2020 # 80016000 <disk>
    80005824:	00012497          	auipc	s1,0x12
    80005828:	7dc48493          	addi	s1,s1,2012 # 80018000 <disk+0x2000>
    __sync_synchronize();
    8000582c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005830:	6898                	ld	a4,16(s1)
    80005832:	0204d783          	lhu	a5,32(s1)
    80005836:	8b9d                	andi	a5,a5,7
    80005838:	078e                	slli	a5,a5,0x3
    8000583a:	97ba                	add	a5,a5,a4
    8000583c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000583e:	20078713          	addi	a4,a5,512
    80005842:	0712                	slli	a4,a4,0x4
    80005844:	974a                	add	a4,a4,s2
    80005846:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000584a:	e731                	bnez	a4,80005896 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000584c:	20078793          	addi	a5,a5,512
    80005850:	0792                	slli	a5,a5,0x4
    80005852:	97ca                	add	a5,a5,s2
    80005854:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005856:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000585a:	ffffc097          	auipc	ra,0xffffc
    8000585e:	e36080e7          	jalr	-458(ra) # 80001690 <wakeup>

    disk.used_idx += 1;
    80005862:	0204d783          	lhu	a5,32(s1)
    80005866:	2785                	addiw	a5,a5,1
    80005868:	17c2                	slli	a5,a5,0x30
    8000586a:	93c1                	srli	a5,a5,0x30
    8000586c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005870:	6898                	ld	a4,16(s1)
    80005872:	00275703          	lhu	a4,2(a4)
    80005876:	faf71be3          	bne	a4,a5,8000582c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000587a:	00013517          	auipc	a0,0x13
    8000587e:	8ae50513          	addi	a0,a0,-1874 # 80018128 <disk+0x2128>
    80005882:	00001097          	auipc	ra,0x1
    80005886:	b44080e7          	jalr	-1212(ra) # 800063c6 <release>
}
    8000588a:	60e2                	ld	ra,24(sp)
    8000588c:	6442                	ld	s0,16(sp)
    8000588e:	64a2                	ld	s1,8(sp)
    80005890:	6902                	ld	s2,0(sp)
    80005892:	6105                	addi	sp,sp,32
    80005894:	8082                	ret
      panic("virtio_disk_intr status");
    80005896:	00003517          	auipc	a0,0x3
    8000589a:	eea50513          	addi	a0,a0,-278 # 80008780 <syscalls+0x3b8>
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	52a080e7          	jalr	1322(ra) # 80005dc8 <panic>

00000000800058a6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058a6:	1141                	addi	sp,sp,-16
    800058a8:	e422                	sd	s0,8(sp)
    800058aa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058ac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058b0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b4:	0037979b          	slliw	a5,a5,0x3
    800058b8:	02004737          	lui	a4,0x2004
    800058bc:	97ba                	add	a5,a5,a4
    800058be:	0200c737          	lui	a4,0x200c
    800058c2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058c6:	000f4637          	lui	a2,0xf4
    800058ca:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ce:	95b2                	add	a1,a1,a2
    800058d0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058d2:	00269713          	slli	a4,a3,0x2
    800058d6:	9736                	add	a4,a4,a3
    800058d8:	00371693          	slli	a3,a4,0x3
    800058dc:	00013717          	auipc	a4,0x13
    800058e0:	72470713          	addi	a4,a4,1828 # 80019000 <timer_scratch>
    800058e4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058e6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058e8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058ee:	00000797          	auipc	a5,0x0
    800058f2:	97278793          	addi	a5,a5,-1678 # 80005260 <timervec>
    800058f6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058fe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005902:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005906:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000590a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000590e:	30479073          	csrw	mie,a5
}
    80005912:	6422                	ld	s0,8(sp)
    80005914:	0141                	addi	sp,sp,16
    80005916:	8082                	ret

0000000080005918 <start>:
{
    80005918:	1141                	addi	sp,sp,-16
    8000591a:	e406                	sd	ra,8(sp)
    8000591c:	e022                	sd	s0,0(sp)
    8000591e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005920:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005924:	7779                	lui	a4,0xffffe
    80005926:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd5bf>
    8000592a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000592c:	6705                	lui	a4,0x1
    8000592e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005932:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005934:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005938:	ffffb797          	auipc	a5,0xffffb
    8000593c:	9ee78793          	addi	a5,a5,-1554 # 80000326 <main>
    80005940:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005944:	4781                	li	a5,0
    80005946:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000594a:	67c1                	lui	a5,0x10
    8000594c:	17fd                	addi	a5,a5,-1
    8000594e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005952:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005956:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000595a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000595e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005962:	57fd                	li	a5,-1
    80005964:	83a9                	srli	a5,a5,0xa
    80005966:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000596a:	47bd                	li	a5,15
    8000596c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005970:	00000097          	auipc	ra,0x0
    80005974:	f36080e7          	jalr	-202(ra) # 800058a6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005978:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000597c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000597e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005980:	30200073          	mret
}
    80005984:	60a2                	ld	ra,8(sp)
    80005986:	6402                	ld	s0,0(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret

000000008000598c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000598c:	715d                	addi	sp,sp,-80
    8000598e:	e486                	sd	ra,72(sp)
    80005990:	e0a2                	sd	s0,64(sp)
    80005992:	fc26                	sd	s1,56(sp)
    80005994:	f84a                	sd	s2,48(sp)
    80005996:	f44e                	sd	s3,40(sp)
    80005998:	f052                	sd	s4,32(sp)
    8000599a:	ec56                	sd	s5,24(sp)
    8000599c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000599e:	04c05663          	blez	a2,800059ea <consolewrite+0x5e>
    800059a2:	8a2a                	mv	s4,a0
    800059a4:	84ae                	mv	s1,a1
    800059a6:	89b2                	mv	s3,a2
    800059a8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059aa:	5afd                	li	s5,-1
    800059ac:	4685                	li	a3,1
    800059ae:	8626                	mv	a2,s1
    800059b0:	85d2                	mv	a1,s4
    800059b2:	fbf40513          	addi	a0,s0,-65
    800059b6:	ffffc097          	auipc	ra,0xffffc
    800059ba:	f48080e7          	jalr	-184(ra) # 800018fe <either_copyin>
    800059be:	01550c63          	beq	a0,s5,800059d6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059c2:	fbf44503          	lbu	a0,-65(s0)
    800059c6:	00000097          	auipc	ra,0x0
    800059ca:	78e080e7          	jalr	1934(ra) # 80006154 <uartputc>
  for(i = 0; i < n; i++){
    800059ce:	2905                	addiw	s2,s2,1
    800059d0:	0485                	addi	s1,s1,1
    800059d2:	fd299de3          	bne	s3,s2,800059ac <consolewrite+0x20>
  }

  return i;
}
    800059d6:	854a                	mv	a0,s2
    800059d8:	60a6                	ld	ra,72(sp)
    800059da:	6406                	ld	s0,64(sp)
    800059dc:	74e2                	ld	s1,56(sp)
    800059de:	7942                	ld	s2,48(sp)
    800059e0:	79a2                	ld	s3,40(sp)
    800059e2:	7a02                	ld	s4,32(sp)
    800059e4:	6ae2                	ld	s5,24(sp)
    800059e6:	6161                	addi	sp,sp,80
    800059e8:	8082                	ret
  for(i = 0; i < n; i++){
    800059ea:	4901                	li	s2,0
    800059ec:	b7ed                	j	800059d6 <consolewrite+0x4a>

00000000800059ee <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ee:	7119                	addi	sp,sp,-128
    800059f0:	fc86                	sd	ra,120(sp)
    800059f2:	f8a2                	sd	s0,112(sp)
    800059f4:	f4a6                	sd	s1,104(sp)
    800059f6:	f0ca                	sd	s2,96(sp)
    800059f8:	ecce                	sd	s3,88(sp)
    800059fa:	e8d2                	sd	s4,80(sp)
    800059fc:	e4d6                	sd	s5,72(sp)
    800059fe:	e0da                	sd	s6,64(sp)
    80005a00:	fc5e                	sd	s7,56(sp)
    80005a02:	f862                	sd	s8,48(sp)
    80005a04:	f466                	sd	s9,40(sp)
    80005a06:	f06a                	sd	s10,32(sp)
    80005a08:	ec6e                	sd	s11,24(sp)
    80005a0a:	0100                	addi	s0,sp,128
    80005a0c:	8b2a                	mv	s6,a0
    80005a0e:	8aae                	mv	s5,a1
    80005a10:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a12:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a16:	0001b517          	auipc	a0,0x1b
    80005a1a:	72a50513          	addi	a0,a0,1834 # 80021140 <cons>
    80005a1e:	00001097          	auipc	ra,0x1
    80005a22:	8f4080e7          	jalr	-1804(ra) # 80006312 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a26:	0001b497          	auipc	s1,0x1b
    80005a2a:	71a48493          	addi	s1,s1,1818 # 80021140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a2e:	89a6                	mv	s3,s1
    80005a30:	0001b917          	auipc	s2,0x1b
    80005a34:	7a890913          	addi	s2,s2,1960 # 800211d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a38:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a3a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a3c:	4da9                	li	s11,10
  while(n > 0){
    80005a3e:	07405863          	blez	s4,80005aae <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a42:	0984a783          	lw	a5,152(s1)
    80005a46:	09c4a703          	lw	a4,156(s1)
    80005a4a:	02f71463          	bne	a4,a5,80005a72 <consoleread+0x84>
      if(myproc()->killed){
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	3fa080e7          	jalr	1018(ra) # 80000e48 <myproc>
    80005a56:	551c                	lw	a5,40(a0)
    80005a58:	e7b5                	bnez	a5,80005ac4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a5a:	85ce                	mv	a1,s3
    80005a5c:	854a                	mv	a0,s2
    80005a5e:	ffffc097          	auipc	ra,0xffffc
    80005a62:	aa6080e7          	jalr	-1370(ra) # 80001504 <sleep>
    while(cons.r == cons.w){
    80005a66:	0984a783          	lw	a5,152(s1)
    80005a6a:	09c4a703          	lw	a4,156(s1)
    80005a6e:	fef700e3          	beq	a4,a5,80005a4e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a72:	0017871b          	addiw	a4,a5,1
    80005a76:	08e4ac23          	sw	a4,152(s1)
    80005a7a:	07f7f713          	andi	a4,a5,127
    80005a7e:	9726                	add	a4,a4,s1
    80005a80:	01874703          	lbu	a4,24(a4)
    80005a84:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a88:	079c0663          	beq	s8,s9,80005af4 <consoleread+0x106>
    cbuf = c;
    80005a8c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a90:	4685                	li	a3,1
    80005a92:	f8f40613          	addi	a2,s0,-113
    80005a96:	85d6                	mv	a1,s5
    80005a98:	855a                	mv	a0,s6
    80005a9a:	ffffc097          	auipc	ra,0xffffc
    80005a9e:	e0e080e7          	jalr	-498(ra) # 800018a8 <either_copyout>
    80005aa2:	01a50663          	beq	a0,s10,80005aae <consoleread+0xc0>
    dst++;
    80005aa6:	0a85                	addi	s5,s5,1
    --n;
    80005aa8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005aaa:	f9bc1ae3          	bne	s8,s11,80005a3e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aae:	0001b517          	auipc	a0,0x1b
    80005ab2:	69250513          	addi	a0,a0,1682 # 80021140 <cons>
    80005ab6:	00001097          	auipc	ra,0x1
    80005aba:	910080e7          	jalr	-1776(ra) # 800063c6 <release>

  return target - n;
    80005abe:	414b853b          	subw	a0,s7,s4
    80005ac2:	a811                	j	80005ad6 <consoleread+0xe8>
        release(&cons.lock);
    80005ac4:	0001b517          	auipc	a0,0x1b
    80005ac8:	67c50513          	addi	a0,a0,1660 # 80021140 <cons>
    80005acc:	00001097          	auipc	ra,0x1
    80005ad0:	8fa080e7          	jalr	-1798(ra) # 800063c6 <release>
        return -1;
    80005ad4:	557d                	li	a0,-1
}
    80005ad6:	70e6                	ld	ra,120(sp)
    80005ad8:	7446                	ld	s0,112(sp)
    80005ada:	74a6                	ld	s1,104(sp)
    80005adc:	7906                	ld	s2,96(sp)
    80005ade:	69e6                	ld	s3,88(sp)
    80005ae0:	6a46                	ld	s4,80(sp)
    80005ae2:	6aa6                	ld	s5,72(sp)
    80005ae4:	6b06                	ld	s6,64(sp)
    80005ae6:	7be2                	ld	s7,56(sp)
    80005ae8:	7c42                	ld	s8,48(sp)
    80005aea:	7ca2                	ld	s9,40(sp)
    80005aec:	7d02                	ld	s10,32(sp)
    80005aee:	6de2                	ld	s11,24(sp)
    80005af0:	6109                	addi	sp,sp,128
    80005af2:	8082                	ret
      if(n < target){
    80005af4:	000a071b          	sext.w	a4,s4
    80005af8:	fb777be3          	bgeu	a4,s7,80005aae <consoleread+0xc0>
        cons.r--;
    80005afc:	0001b717          	auipc	a4,0x1b
    80005b00:	6cf72e23          	sw	a5,1756(a4) # 800211d8 <cons+0x98>
    80005b04:	b76d                	j	80005aae <consoleread+0xc0>

0000000080005b06 <consputc>:
{
    80005b06:	1141                	addi	sp,sp,-16
    80005b08:	e406                	sd	ra,8(sp)
    80005b0a:	e022                	sd	s0,0(sp)
    80005b0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b0e:	10000793          	li	a5,256
    80005b12:	00f50a63          	beq	a0,a5,80005b26 <consputc+0x20>
    uartputc_sync(c);
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	564080e7          	jalr	1380(ra) # 8000607a <uartputc_sync>
}
    80005b1e:	60a2                	ld	ra,8(sp)
    80005b20:	6402                	ld	s0,0(sp)
    80005b22:	0141                	addi	sp,sp,16
    80005b24:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b26:	4521                	li	a0,8
    80005b28:	00000097          	auipc	ra,0x0
    80005b2c:	552080e7          	jalr	1362(ra) # 8000607a <uartputc_sync>
    80005b30:	02000513          	li	a0,32
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	546080e7          	jalr	1350(ra) # 8000607a <uartputc_sync>
    80005b3c:	4521                	li	a0,8
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	53c080e7          	jalr	1340(ra) # 8000607a <uartputc_sync>
    80005b46:	bfe1                	j	80005b1e <consputc+0x18>

0000000080005b48 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b48:	1101                	addi	sp,sp,-32
    80005b4a:	ec06                	sd	ra,24(sp)
    80005b4c:	e822                	sd	s0,16(sp)
    80005b4e:	e426                	sd	s1,8(sp)
    80005b50:	e04a                	sd	s2,0(sp)
    80005b52:	1000                	addi	s0,sp,32
    80005b54:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b56:	0001b517          	auipc	a0,0x1b
    80005b5a:	5ea50513          	addi	a0,a0,1514 # 80021140 <cons>
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	7b4080e7          	jalr	1972(ra) # 80006312 <acquire>

  switch(c){
    80005b66:	47d5                	li	a5,21
    80005b68:	0af48663          	beq	s1,a5,80005c14 <consoleintr+0xcc>
    80005b6c:	0297ca63          	blt	a5,s1,80005ba0 <consoleintr+0x58>
    80005b70:	47a1                	li	a5,8
    80005b72:	0ef48763          	beq	s1,a5,80005c60 <consoleintr+0x118>
    80005b76:	47c1                	li	a5,16
    80005b78:	10f49a63          	bne	s1,a5,80005c8c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b7c:	ffffc097          	auipc	ra,0xffffc
    80005b80:	dd8080e7          	jalr	-552(ra) # 80001954 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b84:	0001b517          	auipc	a0,0x1b
    80005b88:	5bc50513          	addi	a0,a0,1468 # 80021140 <cons>
    80005b8c:	00001097          	auipc	ra,0x1
    80005b90:	83a080e7          	jalr	-1990(ra) # 800063c6 <release>
}
    80005b94:	60e2                	ld	ra,24(sp)
    80005b96:	6442                	ld	s0,16(sp)
    80005b98:	64a2                	ld	s1,8(sp)
    80005b9a:	6902                	ld	s2,0(sp)
    80005b9c:	6105                	addi	sp,sp,32
    80005b9e:	8082                	ret
  switch(c){
    80005ba0:	07f00793          	li	a5,127
    80005ba4:	0af48e63          	beq	s1,a5,80005c60 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ba8:	0001b717          	auipc	a4,0x1b
    80005bac:	59870713          	addi	a4,a4,1432 # 80021140 <cons>
    80005bb0:	0a072783          	lw	a5,160(a4)
    80005bb4:	09872703          	lw	a4,152(a4)
    80005bb8:	9f99                	subw	a5,a5,a4
    80005bba:	07f00713          	li	a4,127
    80005bbe:	fcf763e3          	bltu	a4,a5,80005b84 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bc2:	47b5                	li	a5,13
    80005bc4:	0cf48763          	beq	s1,a5,80005c92 <consoleintr+0x14a>
      consputc(c);
    80005bc8:	8526                	mv	a0,s1
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	f3c080e7          	jalr	-196(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bd2:	0001b797          	auipc	a5,0x1b
    80005bd6:	56e78793          	addi	a5,a5,1390 # 80021140 <cons>
    80005bda:	0a07a703          	lw	a4,160(a5)
    80005bde:	0017069b          	addiw	a3,a4,1
    80005be2:	0006861b          	sext.w	a2,a3
    80005be6:	0ad7a023          	sw	a3,160(a5)
    80005bea:	07f77713          	andi	a4,a4,127
    80005bee:	97ba                	add	a5,a5,a4
    80005bf0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bf4:	47a9                	li	a5,10
    80005bf6:	0cf48563          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005bfa:	4791                	li	a5,4
    80005bfc:	0cf48263          	beq	s1,a5,80005cc0 <consoleintr+0x178>
    80005c00:	0001b797          	auipc	a5,0x1b
    80005c04:	5d87a783          	lw	a5,1496(a5) # 800211d8 <cons+0x98>
    80005c08:	0807879b          	addiw	a5,a5,128
    80005c0c:	f6f61ce3          	bne	a2,a5,80005b84 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c10:	863e                	mv	a2,a5
    80005c12:	a07d                	j	80005cc0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c14:	0001b717          	auipc	a4,0x1b
    80005c18:	52c70713          	addi	a4,a4,1324 # 80021140 <cons>
    80005c1c:	0a072783          	lw	a5,160(a4)
    80005c20:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c24:	0001b497          	auipc	s1,0x1b
    80005c28:	51c48493          	addi	s1,s1,1308 # 80021140 <cons>
    while(cons.e != cons.w &&
    80005c2c:	4929                	li	s2,10
    80005c2e:	f4f70be3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c32:	37fd                	addiw	a5,a5,-1
    80005c34:	07f7f713          	andi	a4,a5,127
    80005c38:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c3a:	01874703          	lbu	a4,24(a4)
    80005c3e:	f52703e3          	beq	a4,s2,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c42:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c46:	10000513          	li	a0,256
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	ebc080e7          	jalr	-324(ra) # 80005b06 <consputc>
    while(cons.e != cons.w &&
    80005c52:	0a04a783          	lw	a5,160(s1)
    80005c56:	09c4a703          	lw	a4,156(s1)
    80005c5a:	fcf71ce3          	bne	a4,a5,80005c32 <consoleintr+0xea>
    80005c5e:	b71d                	j	80005b84 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c60:	0001b717          	auipc	a4,0x1b
    80005c64:	4e070713          	addi	a4,a4,1248 # 80021140 <cons>
    80005c68:	0a072783          	lw	a5,160(a4)
    80005c6c:	09c72703          	lw	a4,156(a4)
    80005c70:	f0f70ae3          	beq	a4,a5,80005b84 <consoleintr+0x3c>
      cons.e--;
    80005c74:	37fd                	addiw	a5,a5,-1
    80005c76:	0001b717          	auipc	a4,0x1b
    80005c7a:	56f72523          	sw	a5,1386(a4) # 800211e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c7e:	10000513          	li	a0,256
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	e84080e7          	jalr	-380(ra) # 80005b06 <consputc>
    80005c8a:	bded                	j	80005b84 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c8c:	ee048ce3          	beqz	s1,80005b84 <consoleintr+0x3c>
    80005c90:	bf21                	j	80005ba8 <consoleintr+0x60>
      consputc(c);
    80005c92:	4529                	li	a0,10
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	e72080e7          	jalr	-398(ra) # 80005b06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c9c:	0001b797          	auipc	a5,0x1b
    80005ca0:	4a478793          	addi	a5,a5,1188 # 80021140 <cons>
    80005ca4:	0a07a703          	lw	a4,160(a5)
    80005ca8:	0017069b          	addiw	a3,a4,1
    80005cac:	0006861b          	sext.w	a2,a3
    80005cb0:	0ad7a023          	sw	a3,160(a5)
    80005cb4:	07f77713          	andi	a4,a4,127
    80005cb8:	97ba                	add	a5,a5,a4
    80005cba:	4729                	li	a4,10
    80005cbc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cc0:	0001b797          	auipc	a5,0x1b
    80005cc4:	50c7ae23          	sw	a2,1308(a5) # 800211dc <cons+0x9c>
        wakeup(&cons.r);
    80005cc8:	0001b517          	auipc	a0,0x1b
    80005ccc:	51050513          	addi	a0,a0,1296 # 800211d8 <cons+0x98>
    80005cd0:	ffffc097          	auipc	ra,0xffffc
    80005cd4:	9c0080e7          	jalr	-1600(ra) # 80001690 <wakeup>
    80005cd8:	b575                	j	80005b84 <consoleintr+0x3c>

0000000080005cda <consoleinit>:

void
consoleinit(void)
{
    80005cda:	1141                	addi	sp,sp,-16
    80005cdc:	e406                	sd	ra,8(sp)
    80005cde:	e022                	sd	s0,0(sp)
    80005ce0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ce2:	00003597          	auipc	a1,0x3
    80005ce6:	ab658593          	addi	a1,a1,-1354 # 80008798 <syscalls+0x3d0>
    80005cea:	0001b517          	auipc	a0,0x1b
    80005cee:	45650513          	addi	a0,a0,1110 # 80021140 <cons>
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	590080e7          	jalr	1424(ra) # 80006282 <initlock>

  uartinit();
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	330080e7          	jalr	816(ra) # 8000602a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d02:	0000e797          	auipc	a5,0xe
    80005d06:	7d678793          	addi	a5,a5,2006 # 800144d8 <devsw>
    80005d0a:	00000717          	auipc	a4,0x0
    80005d0e:	ce470713          	addi	a4,a4,-796 # 800059ee <consoleread>
    80005d12:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d14:	00000717          	auipc	a4,0x0
    80005d18:	c7870713          	addi	a4,a4,-904 # 8000598c <consolewrite>
    80005d1c:	ef98                	sd	a4,24(a5)
}
    80005d1e:	60a2                	ld	ra,8(sp)
    80005d20:	6402                	ld	s0,0(sp)
    80005d22:	0141                	addi	sp,sp,16
    80005d24:	8082                	ret

0000000080005d26 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d26:	7179                	addi	sp,sp,-48
    80005d28:	f406                	sd	ra,40(sp)
    80005d2a:	f022                	sd	s0,32(sp)
    80005d2c:	ec26                	sd	s1,24(sp)
    80005d2e:	e84a                	sd	s2,16(sp)
    80005d30:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d32:	c219                	beqz	a2,80005d38 <printint+0x12>
    80005d34:	08054663          	bltz	a0,80005dc0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d38:	2501                	sext.w	a0,a0
    80005d3a:	4881                	li	a7,0
    80005d3c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d40:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d42:	2581                	sext.w	a1,a1
    80005d44:	00003617          	auipc	a2,0x3
    80005d48:	a8460613          	addi	a2,a2,-1404 # 800087c8 <digits>
    80005d4c:	883a                	mv	a6,a4
    80005d4e:	2705                	addiw	a4,a4,1
    80005d50:	02b577bb          	remuw	a5,a0,a1
    80005d54:	1782                	slli	a5,a5,0x20
    80005d56:	9381                	srli	a5,a5,0x20
    80005d58:	97b2                	add	a5,a5,a2
    80005d5a:	0007c783          	lbu	a5,0(a5)
    80005d5e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d62:	0005079b          	sext.w	a5,a0
    80005d66:	02b5553b          	divuw	a0,a0,a1
    80005d6a:	0685                	addi	a3,a3,1
    80005d6c:	feb7f0e3          	bgeu	a5,a1,80005d4c <printint+0x26>

  if(sign)
    80005d70:	00088b63          	beqz	a7,80005d86 <printint+0x60>
    buf[i++] = '-';
    80005d74:	fe040793          	addi	a5,s0,-32
    80005d78:	973e                	add	a4,a4,a5
    80005d7a:	02d00793          	li	a5,45
    80005d7e:	fef70823          	sb	a5,-16(a4)
    80005d82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d86:	02e05763          	blez	a4,80005db4 <printint+0x8e>
    80005d8a:	fd040793          	addi	a5,s0,-48
    80005d8e:	00e784b3          	add	s1,a5,a4
    80005d92:	fff78913          	addi	s2,a5,-1
    80005d96:	993a                	add	s2,s2,a4
    80005d98:	377d                	addiw	a4,a4,-1
    80005d9a:	1702                	slli	a4,a4,0x20
    80005d9c:	9301                	srli	a4,a4,0x20
    80005d9e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005da2:	fff4c503          	lbu	a0,-1(s1)
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	d60080e7          	jalr	-672(ra) # 80005b06 <consputc>
  while(--i >= 0)
    80005dae:	14fd                	addi	s1,s1,-1
    80005db0:	ff2499e3          	bne	s1,s2,80005da2 <printint+0x7c>
}
    80005db4:	70a2                	ld	ra,40(sp)
    80005db6:	7402                	ld	s0,32(sp)
    80005db8:	64e2                	ld	s1,24(sp)
    80005dba:	6942                	ld	s2,16(sp)
    80005dbc:	6145                	addi	sp,sp,48
    80005dbe:	8082                	ret
    x = -xx;
    80005dc0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dc4:	4885                	li	a7,1
    x = -xx;
    80005dc6:	bf9d                	j	80005d3c <printint+0x16>

0000000080005dc8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dc8:	1101                	addi	sp,sp,-32
    80005dca:	ec06                	sd	ra,24(sp)
    80005dcc:	e822                	sd	s0,16(sp)
    80005dce:	e426                	sd	s1,8(sp)
    80005dd0:	1000                	addi	s0,sp,32
    80005dd2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dd4:	0001b797          	auipc	a5,0x1b
    80005dd8:	4207a623          	sw	zero,1068(a5) # 80021200 <pr+0x18>
  printf("panic: ");
    80005ddc:	00003517          	auipc	a0,0x3
    80005de0:	9c450513          	addi	a0,a0,-1596 # 800087a0 <syscalls+0x3d8>
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	02e080e7          	jalr	46(ra) # 80005e12 <printf>
  printf(s);
    80005dec:	8526                	mv	a0,s1
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	024080e7          	jalr	36(ra) # 80005e12 <printf>
  printf("\n");
    80005df6:	00002517          	auipc	a0,0x2
    80005dfa:	25250513          	addi	a0,a0,594 # 80008048 <etext+0x48>
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	014080e7          	jalr	20(ra) # 80005e12 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e06:	4785                	li	a5,1
    80005e08:	00003717          	auipc	a4,0x3
    80005e0c:	20f72a23          	sw	a5,532(a4) # 8000901c <panicked>
  for(;;)
    80005e10:	a001                	j	80005e10 <panic+0x48>

0000000080005e12 <printf>:
{
    80005e12:	7131                	addi	sp,sp,-192
    80005e14:	fc86                	sd	ra,120(sp)
    80005e16:	f8a2                	sd	s0,112(sp)
    80005e18:	f4a6                	sd	s1,104(sp)
    80005e1a:	f0ca                	sd	s2,96(sp)
    80005e1c:	ecce                	sd	s3,88(sp)
    80005e1e:	e8d2                	sd	s4,80(sp)
    80005e20:	e4d6                	sd	s5,72(sp)
    80005e22:	e0da                	sd	s6,64(sp)
    80005e24:	fc5e                	sd	s7,56(sp)
    80005e26:	f862                	sd	s8,48(sp)
    80005e28:	f466                	sd	s9,40(sp)
    80005e2a:	f06a                	sd	s10,32(sp)
    80005e2c:	ec6e                	sd	s11,24(sp)
    80005e2e:	0100                	addi	s0,sp,128
    80005e30:	8a2a                	mv	s4,a0
    80005e32:	e40c                	sd	a1,8(s0)
    80005e34:	e810                	sd	a2,16(s0)
    80005e36:	ec14                	sd	a3,24(s0)
    80005e38:	f018                	sd	a4,32(s0)
    80005e3a:	f41c                	sd	a5,40(s0)
    80005e3c:	03043823          	sd	a6,48(s0)
    80005e40:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e44:	0001bd97          	auipc	s11,0x1b
    80005e48:	3bcdad83          	lw	s11,956(s11) # 80021200 <pr+0x18>
  if(locking)
    80005e4c:	020d9b63          	bnez	s11,80005e82 <printf+0x70>
  if (fmt == 0)
    80005e50:	040a0263          	beqz	s4,80005e94 <printf+0x82>
  va_start(ap, fmt);
    80005e54:	00840793          	addi	a5,s0,8
    80005e58:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e5c:	000a4503          	lbu	a0,0(s4)
    80005e60:	16050263          	beqz	a0,80005fc4 <printf+0x1b2>
    80005e64:	4481                	li	s1,0
    if(c != '%'){
    80005e66:	02500a93          	li	s5,37
    switch(c){
    80005e6a:	07000b13          	li	s6,112
  consputc('x');
    80005e6e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e70:	00003b97          	auipc	s7,0x3
    80005e74:	958b8b93          	addi	s7,s7,-1704 # 800087c8 <digits>
    switch(c){
    80005e78:	07300c93          	li	s9,115
    80005e7c:	06400c13          	li	s8,100
    80005e80:	a82d                	j	80005eba <printf+0xa8>
    acquire(&pr.lock);
    80005e82:	0001b517          	auipc	a0,0x1b
    80005e86:	36650513          	addi	a0,a0,870 # 800211e8 <pr>
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	488080e7          	jalr	1160(ra) # 80006312 <acquire>
    80005e92:	bf7d                	j	80005e50 <printf+0x3e>
    panic("null fmt");
    80005e94:	00003517          	auipc	a0,0x3
    80005e98:	91c50513          	addi	a0,a0,-1764 # 800087b0 <syscalls+0x3e8>
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	f2c080e7          	jalr	-212(ra) # 80005dc8 <panic>
      consputc(c);
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	c62080e7          	jalr	-926(ra) # 80005b06 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eac:	2485                	addiw	s1,s1,1
    80005eae:	009a07b3          	add	a5,s4,s1
    80005eb2:	0007c503          	lbu	a0,0(a5)
    80005eb6:	10050763          	beqz	a0,80005fc4 <printf+0x1b2>
    if(c != '%'){
    80005eba:	ff5515e3          	bne	a0,s5,80005ea4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ebe:	2485                	addiw	s1,s1,1
    80005ec0:	009a07b3          	add	a5,s4,s1
    80005ec4:	0007c783          	lbu	a5,0(a5)
    80005ec8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ecc:	cfe5                	beqz	a5,80005fc4 <printf+0x1b2>
    switch(c){
    80005ece:	05678a63          	beq	a5,s6,80005f22 <printf+0x110>
    80005ed2:	02fb7663          	bgeu	s6,a5,80005efe <printf+0xec>
    80005ed6:	09978963          	beq	a5,s9,80005f68 <printf+0x156>
    80005eda:	07800713          	li	a4,120
    80005ede:	0ce79863          	bne	a5,a4,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ee2:	f8843783          	ld	a5,-120(s0)
    80005ee6:	00878713          	addi	a4,a5,8
    80005eea:	f8e43423          	sd	a4,-120(s0)
    80005eee:	4605                	li	a2,1
    80005ef0:	85ea                	mv	a1,s10
    80005ef2:	4388                	lw	a0,0(a5)
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	e32080e7          	jalr	-462(ra) # 80005d26 <printint>
      break;
    80005efc:	bf45                	j	80005eac <printf+0x9a>
    switch(c){
    80005efe:	0b578263          	beq	a5,s5,80005fa2 <printf+0x190>
    80005f02:	0b879663          	bne	a5,s8,80005fae <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f06:	f8843783          	ld	a5,-120(s0)
    80005f0a:	00878713          	addi	a4,a5,8
    80005f0e:	f8e43423          	sd	a4,-120(s0)
    80005f12:	4605                	li	a2,1
    80005f14:	45a9                	li	a1,10
    80005f16:	4388                	lw	a0,0(a5)
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	e0e080e7          	jalr	-498(ra) # 80005d26 <printint>
      break;
    80005f20:	b771                	j	80005eac <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f22:	f8843783          	ld	a5,-120(s0)
    80005f26:	00878713          	addi	a4,a5,8
    80005f2a:	f8e43423          	sd	a4,-120(s0)
    80005f2e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f32:	03000513          	li	a0,48
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	bd0080e7          	jalr	-1072(ra) # 80005b06 <consputc>
  consputc('x');
    80005f3e:	07800513          	li	a0,120
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	bc4080e7          	jalr	-1084(ra) # 80005b06 <consputc>
    80005f4a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f4c:	03c9d793          	srli	a5,s3,0x3c
    80005f50:	97de                	add	a5,a5,s7
    80005f52:	0007c503          	lbu	a0,0(a5)
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	bb0080e7          	jalr	-1104(ra) # 80005b06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f5e:	0992                	slli	s3,s3,0x4
    80005f60:	397d                	addiw	s2,s2,-1
    80005f62:	fe0915e3          	bnez	s2,80005f4c <printf+0x13a>
    80005f66:	b799                	j	80005eac <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f68:	f8843783          	ld	a5,-120(s0)
    80005f6c:	00878713          	addi	a4,a5,8
    80005f70:	f8e43423          	sd	a4,-120(s0)
    80005f74:	0007b903          	ld	s2,0(a5)
    80005f78:	00090e63          	beqz	s2,80005f94 <printf+0x182>
      for(; *s; s++)
    80005f7c:	00094503          	lbu	a0,0(s2)
    80005f80:	d515                	beqz	a0,80005eac <printf+0x9a>
        consputc(*s);
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b84080e7          	jalr	-1148(ra) # 80005b06 <consputc>
      for(; *s; s++)
    80005f8a:	0905                	addi	s2,s2,1
    80005f8c:	00094503          	lbu	a0,0(s2)
    80005f90:	f96d                	bnez	a0,80005f82 <printf+0x170>
    80005f92:	bf29                	j	80005eac <printf+0x9a>
        s = "(null)";
    80005f94:	00003917          	auipc	s2,0x3
    80005f98:	81490913          	addi	s2,s2,-2028 # 800087a8 <syscalls+0x3e0>
      for(; *s; s++)
    80005f9c:	02800513          	li	a0,40
    80005fa0:	b7cd                	j	80005f82 <printf+0x170>
      consputc('%');
    80005fa2:	8556                	mv	a0,s5
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	b62080e7          	jalr	-1182(ra) # 80005b06 <consputc>
      break;
    80005fac:	b701                	j	80005eac <printf+0x9a>
      consputc('%');
    80005fae:	8556                	mv	a0,s5
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	b56080e7          	jalr	-1194(ra) # 80005b06 <consputc>
      consputc(c);
    80005fb8:	854a                	mv	a0,s2
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	b4c080e7          	jalr	-1204(ra) # 80005b06 <consputc>
      break;
    80005fc2:	b5ed                	j	80005eac <printf+0x9a>
  if(locking)
    80005fc4:	020d9163          	bnez	s11,80005fe6 <printf+0x1d4>
}
    80005fc8:	70e6                	ld	ra,120(sp)
    80005fca:	7446                	ld	s0,112(sp)
    80005fcc:	74a6                	ld	s1,104(sp)
    80005fce:	7906                	ld	s2,96(sp)
    80005fd0:	69e6                	ld	s3,88(sp)
    80005fd2:	6a46                	ld	s4,80(sp)
    80005fd4:	6aa6                	ld	s5,72(sp)
    80005fd6:	6b06                	ld	s6,64(sp)
    80005fd8:	7be2                	ld	s7,56(sp)
    80005fda:	7c42                	ld	s8,48(sp)
    80005fdc:	7ca2                	ld	s9,40(sp)
    80005fde:	7d02                	ld	s10,32(sp)
    80005fe0:	6de2                	ld	s11,24(sp)
    80005fe2:	6129                	addi	sp,sp,192
    80005fe4:	8082                	ret
    release(&pr.lock);
    80005fe6:	0001b517          	auipc	a0,0x1b
    80005fea:	20250513          	addi	a0,a0,514 # 800211e8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	3d8080e7          	jalr	984(ra) # 800063c6 <release>
}
    80005ff6:	bfc9                	j	80005fc8 <printf+0x1b6>

0000000080005ff8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ff8:	1101                	addi	sp,sp,-32
    80005ffa:	ec06                	sd	ra,24(sp)
    80005ffc:	e822                	sd	s0,16(sp)
    80005ffe:	e426                	sd	s1,8(sp)
    80006000:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006002:	0001b497          	auipc	s1,0x1b
    80006006:	1e648493          	addi	s1,s1,486 # 800211e8 <pr>
    8000600a:	00002597          	auipc	a1,0x2
    8000600e:	7b658593          	addi	a1,a1,1974 # 800087c0 <syscalls+0x3f8>
    80006012:	8526                	mv	a0,s1
    80006014:	00000097          	auipc	ra,0x0
    80006018:	26e080e7          	jalr	622(ra) # 80006282 <initlock>
  pr.locking = 1;
    8000601c:	4785                	li	a5,1
    8000601e:	cc9c                	sw	a5,24(s1)
}
    80006020:	60e2                	ld	ra,24(sp)
    80006022:	6442                	ld	s0,16(sp)
    80006024:	64a2                	ld	s1,8(sp)
    80006026:	6105                	addi	sp,sp,32
    80006028:	8082                	ret

000000008000602a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000602a:	1141                	addi	sp,sp,-16
    8000602c:	e406                	sd	ra,8(sp)
    8000602e:	e022                	sd	s0,0(sp)
    80006030:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006032:	100007b7          	lui	a5,0x10000
    80006036:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000603a:	f8000713          	li	a4,-128
    8000603e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006042:	470d                	li	a4,3
    80006044:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006048:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000604c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006050:	469d                	li	a3,7
    80006052:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006056:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000605a:	00002597          	auipc	a1,0x2
    8000605e:	78658593          	addi	a1,a1,1926 # 800087e0 <digits+0x18>
    80006062:	0001b517          	auipc	a0,0x1b
    80006066:	1a650513          	addi	a0,a0,422 # 80021208 <uart_tx_lock>
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	218080e7          	jalr	536(ra) # 80006282 <initlock>
}
    80006072:	60a2                	ld	ra,8(sp)
    80006074:	6402                	ld	s0,0(sp)
    80006076:	0141                	addi	sp,sp,16
    80006078:	8082                	ret

000000008000607a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000607a:	1101                	addi	sp,sp,-32
    8000607c:	ec06                	sd	ra,24(sp)
    8000607e:	e822                	sd	s0,16(sp)
    80006080:	e426                	sd	s1,8(sp)
    80006082:	1000                	addi	s0,sp,32
    80006084:	84aa                	mv	s1,a0
  push_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	240080e7          	jalr	576(ra) # 800062c6 <push_off>

  if(panicked){
    8000608e:	00003797          	auipc	a5,0x3
    80006092:	f8e7a783          	lw	a5,-114(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006096:	10000737          	lui	a4,0x10000
  if(panicked){
    8000609a:	c391                	beqz	a5,8000609e <uartputc_sync+0x24>
    for(;;)
    8000609c:	a001                	j	8000609c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000609e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060a2:	0ff7f793          	andi	a5,a5,255
    800060a6:	0207f793          	andi	a5,a5,32
    800060aa:	dbf5                	beqz	a5,8000609e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060ac:	0ff4f793          	andi	a5,s1,255
    800060b0:	10000737          	lui	a4,0x10000
    800060b4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	2ae080e7          	jalr	686(ra) # 80006366 <pop_off>
}
    800060c0:	60e2                	ld	ra,24(sp)
    800060c2:	6442                	ld	s0,16(sp)
    800060c4:	64a2                	ld	s1,8(sp)
    800060c6:	6105                	addi	sp,sp,32
    800060c8:	8082                	ret

00000000800060ca <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ca:	00003717          	auipc	a4,0x3
    800060ce:	f5673703          	ld	a4,-170(a4) # 80009020 <uart_tx_r>
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f567b783          	ld	a5,-170(a5) # 80009028 <uart_tx_w>
    800060da:	06e78c63          	beq	a5,a4,80006152 <uartstart+0x88>
{
    800060de:	7139                	addi	sp,sp,-64
    800060e0:	fc06                	sd	ra,56(sp)
    800060e2:	f822                	sd	s0,48(sp)
    800060e4:	f426                	sd	s1,40(sp)
    800060e6:	f04a                	sd	s2,32(sp)
    800060e8:	ec4e                	sd	s3,24(sp)
    800060ea:	e852                	sd	s4,16(sp)
    800060ec:	e456                	sd	s5,8(sp)
    800060ee:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060f4:	0001ba17          	auipc	s4,0x1b
    800060f8:	114a0a13          	addi	s4,s4,276 # 80021208 <uart_tx_lock>
    uart_tx_r += 1;
    800060fc:	00003497          	auipc	s1,0x3
    80006100:	f2448493          	addi	s1,s1,-220 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006104:	00003997          	auipc	s3,0x3
    80006108:	f2498993          	addi	s3,s3,-220 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000610c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006110:	0ff7f793          	andi	a5,a5,255
    80006114:	0207f793          	andi	a5,a5,32
    80006118:	c785                	beqz	a5,80006140 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611a:	01f77793          	andi	a5,a4,31
    8000611e:	97d2                	add	a5,a5,s4
    80006120:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006124:	0705                	addi	a4,a4,1
    80006126:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006128:	8526                	mv	a0,s1
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	566080e7          	jalr	1382(ra) # 80001690 <wakeup>
    
    WriteReg(THR, c);
    80006132:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006136:	6098                	ld	a4,0(s1)
    80006138:	0009b783          	ld	a5,0(s3)
    8000613c:	fce798e3          	bne	a5,a4,8000610c <uartstart+0x42>
  }
}
    80006140:	70e2                	ld	ra,56(sp)
    80006142:	7442                	ld	s0,48(sp)
    80006144:	74a2                	ld	s1,40(sp)
    80006146:	7902                	ld	s2,32(sp)
    80006148:	69e2                	ld	s3,24(sp)
    8000614a:	6a42                	ld	s4,16(sp)
    8000614c:	6aa2                	ld	s5,8(sp)
    8000614e:	6121                	addi	sp,sp,64
    80006150:	8082                	ret
    80006152:	8082                	ret

0000000080006154 <uartputc>:
{
    80006154:	7179                	addi	sp,sp,-48
    80006156:	f406                	sd	ra,40(sp)
    80006158:	f022                	sd	s0,32(sp)
    8000615a:	ec26                	sd	s1,24(sp)
    8000615c:	e84a                	sd	s2,16(sp)
    8000615e:	e44e                	sd	s3,8(sp)
    80006160:	e052                	sd	s4,0(sp)
    80006162:	1800                	addi	s0,sp,48
    80006164:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006166:	0001b517          	auipc	a0,0x1b
    8000616a:	0a250513          	addi	a0,a0,162 # 80021208 <uart_tx_lock>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	1a4080e7          	jalr	420(ra) # 80006312 <acquire>
  if(panicked){
    80006176:	00003797          	auipc	a5,0x3
    8000617a:	ea67a783          	lw	a5,-346(a5) # 8000901c <panicked>
    8000617e:	c391                	beqz	a5,80006182 <uartputc+0x2e>
    for(;;)
    80006180:	a001                	j	80006180 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006182:	00003797          	auipc	a5,0x3
    80006186:	ea67b783          	ld	a5,-346(a5) # 80009028 <uart_tx_w>
    8000618a:	00003717          	auipc	a4,0x3
    8000618e:	e9673703          	ld	a4,-362(a4) # 80009020 <uart_tx_r>
    80006192:	02070713          	addi	a4,a4,32
    80006196:	02f71b63          	bne	a4,a5,800061cc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000619a:	0001ba17          	auipc	s4,0x1b
    8000619e:	06ea0a13          	addi	s4,s4,110 # 80021208 <uart_tx_lock>
    800061a2:	00003497          	auipc	s1,0x3
    800061a6:	e7e48493          	addi	s1,s1,-386 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061aa:	00003917          	auipc	s2,0x3
    800061ae:	e7e90913          	addi	s2,s2,-386 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061b2:	85d2                	mv	a1,s4
    800061b4:	8526                	mv	a0,s1
    800061b6:	ffffb097          	auipc	ra,0xffffb
    800061ba:	34e080e7          	jalr	846(ra) # 80001504 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061be:	00093783          	ld	a5,0(s2)
    800061c2:	6098                	ld	a4,0(s1)
    800061c4:	02070713          	addi	a4,a4,32
    800061c8:	fef705e3          	beq	a4,a5,800061b2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061cc:	0001b497          	auipc	s1,0x1b
    800061d0:	03c48493          	addi	s1,s1,60 # 80021208 <uart_tx_lock>
    800061d4:	01f7f713          	andi	a4,a5,31
    800061d8:	9726                	add	a4,a4,s1
    800061da:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800061de:	0785                	addi	a5,a5,1
    800061e0:	00003717          	auipc	a4,0x3
    800061e4:	e4f73423          	sd	a5,-440(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	ee2080e7          	jalr	-286(ra) # 800060ca <uartstart>
      release(&uart_tx_lock);
    800061f0:	8526                	mv	a0,s1
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	1d4080e7          	jalr	468(ra) # 800063c6 <release>
}
    800061fa:	70a2                	ld	ra,40(sp)
    800061fc:	7402                	ld	s0,32(sp)
    800061fe:	64e2                	ld	s1,24(sp)
    80006200:	6942                	ld	s2,16(sp)
    80006202:	69a2                	ld	s3,8(sp)
    80006204:	6a02                	ld	s4,0(sp)
    80006206:	6145                	addi	sp,sp,48
    80006208:	8082                	ret

000000008000620a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000620a:	1141                	addi	sp,sp,-16
    8000620c:	e422                	sd	s0,8(sp)
    8000620e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006210:	100007b7          	lui	a5,0x10000
    80006214:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006218:	8b85                	andi	a5,a5,1
    8000621a:	cb91                	beqz	a5,8000622e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000621c:	100007b7          	lui	a5,0x10000
    80006220:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006224:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006228:	6422                	ld	s0,8(sp)
    8000622a:	0141                	addi	sp,sp,16
    8000622c:	8082                	ret
    return -1;
    8000622e:	557d                	li	a0,-1
    80006230:	bfe5                	j	80006228 <uartgetc+0x1e>

0000000080006232 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006232:	1101                	addi	sp,sp,-32
    80006234:	ec06                	sd	ra,24(sp)
    80006236:	e822                	sd	s0,16(sp)
    80006238:	e426                	sd	s1,8(sp)
    8000623a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000623c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	fcc080e7          	jalr	-52(ra) # 8000620a <uartgetc>
    if(c == -1)
    80006246:	00950763          	beq	a0,s1,80006254 <uartintr+0x22>
      break;
    consoleintr(c);
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	8fe080e7          	jalr	-1794(ra) # 80005b48 <consoleintr>
  while(1){
    80006252:	b7f5                	j	8000623e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006254:	0001b497          	auipc	s1,0x1b
    80006258:	fb448493          	addi	s1,s1,-76 # 80021208 <uart_tx_lock>
    8000625c:	8526                	mv	a0,s1
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	0b4080e7          	jalr	180(ra) # 80006312 <acquire>
  uartstart();
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	e64080e7          	jalr	-412(ra) # 800060ca <uartstart>
  release(&uart_tx_lock);
    8000626e:	8526                	mv	a0,s1
    80006270:	00000097          	auipc	ra,0x0
    80006274:	156080e7          	jalr	342(ra) # 800063c6 <release>
}
    80006278:	60e2                	ld	ra,24(sp)
    8000627a:	6442                	ld	s0,16(sp)
    8000627c:	64a2                	ld	s1,8(sp)
    8000627e:	6105                	addi	sp,sp,32
    80006280:	8082                	ret

0000000080006282 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006282:	1141                	addi	sp,sp,-16
    80006284:	e422                	sd	s0,8(sp)
    80006286:	0800                	addi	s0,sp,16
  lk->name = name;
    80006288:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000628a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000628e:	00053823          	sd	zero,16(a0)
}
    80006292:	6422                	ld	s0,8(sp)
    80006294:	0141                	addi	sp,sp,16
    80006296:	8082                	ret

0000000080006298 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006298:	411c                	lw	a5,0(a0)
    8000629a:	e399                	bnez	a5,800062a0 <holding+0x8>
    8000629c:	4501                	li	a0,0
  return r;
}
    8000629e:	8082                	ret
{
    800062a0:	1101                	addi	sp,sp,-32
    800062a2:	ec06                	sd	ra,24(sp)
    800062a4:	e822                	sd	s0,16(sp)
    800062a6:	e426                	sd	s1,8(sp)
    800062a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062aa:	6904                	ld	s1,16(a0)
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	b80080e7          	jalr	-1152(ra) # 80000e2c <mycpu>
    800062b4:	40a48533          	sub	a0,s1,a0
    800062b8:	00153513          	seqz	a0,a0
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret

00000000800062c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062c6:	1101                	addi	sp,sp,-32
    800062c8:	ec06                	sd	ra,24(sp)
    800062ca:	e822                	sd	s0,16(sp)
    800062cc:	e426                	sd	s1,8(sp)
    800062ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d0:	100024f3          	csrr	s1,sstatus
    800062d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	b4e080e7          	jalr	-1202(ra) # 80000e2c <mycpu>
    800062e6:	5d3c                	lw	a5,120(a0)
    800062e8:	cf89                	beqz	a5,80006302 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062ea:	ffffb097          	auipc	ra,0xffffb
    800062ee:	b42080e7          	jalr	-1214(ra) # 80000e2c <mycpu>
    800062f2:	5d3c                	lw	a5,120(a0)
    800062f4:	2785                	addiw	a5,a5,1
    800062f6:	dd3c                	sw	a5,120(a0)
}
    800062f8:	60e2                	ld	ra,24(sp)
    800062fa:	6442                	ld	s0,16(sp)
    800062fc:	64a2                	ld	s1,8(sp)
    800062fe:	6105                	addi	sp,sp,32
    80006300:	8082                	ret
    mycpu()->intena = old;
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	b2a080e7          	jalr	-1238(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000630a:	8085                	srli	s1,s1,0x1
    8000630c:	8885                	andi	s1,s1,1
    8000630e:	dd64                	sw	s1,124(a0)
    80006310:	bfe9                	j	800062ea <push_off+0x24>

0000000080006312 <acquire>:
{
    80006312:	1101                	addi	sp,sp,-32
    80006314:	ec06                	sd	ra,24(sp)
    80006316:	e822                	sd	s0,16(sp)
    80006318:	e426                	sd	s1,8(sp)
    8000631a:	1000                	addi	s0,sp,32
    8000631c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	fa8080e7          	jalr	-88(ra) # 800062c6 <push_off>
  if(holding(lk))
    80006326:	8526                	mv	a0,s1
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	f70080e7          	jalr	-144(ra) # 80006298 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006330:	4705                	li	a4,1
  if(holding(lk))
    80006332:	e115                	bnez	a0,80006356 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006334:	87ba                	mv	a5,a4
    80006336:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000633a:	2781                	sext.w	a5,a5
    8000633c:	ffe5                	bnez	a5,80006334 <acquire+0x22>
  __sync_synchronize();
    8000633e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	aea080e7          	jalr	-1302(ra) # 80000e2c <mycpu>
    8000634a:	e888                	sd	a0,16(s1)
}
    8000634c:	60e2                	ld	ra,24(sp)
    8000634e:	6442                	ld	s0,16(sp)
    80006350:	64a2                	ld	s1,8(sp)
    80006352:	6105                	addi	sp,sp,32
    80006354:	8082                	ret
    panic("acquire");
    80006356:	00002517          	auipc	a0,0x2
    8000635a:	49250513          	addi	a0,a0,1170 # 800087e8 <digits+0x20>
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	a6a080e7          	jalr	-1430(ra) # 80005dc8 <panic>

0000000080006366 <pop_off>:

void
pop_off(void)
{
    80006366:	1141                	addi	sp,sp,-16
    80006368:	e406                	sd	ra,8(sp)
    8000636a:	e022                	sd	s0,0(sp)
    8000636c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000636e:	ffffb097          	auipc	ra,0xffffb
    80006372:	abe080e7          	jalr	-1346(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006376:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000637a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000637c:	e78d                	bnez	a5,800063a6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000637e:	5d3c                	lw	a5,120(a0)
    80006380:	02f05b63          	blez	a5,800063b6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006384:	37fd                	addiw	a5,a5,-1
    80006386:	0007871b          	sext.w	a4,a5
    8000638a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000638c:	eb09                	bnez	a4,8000639e <pop_off+0x38>
    8000638e:	5d7c                	lw	a5,124(a0)
    80006390:	c799                	beqz	a5,8000639e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006392:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006396:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000639a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000639e:	60a2                	ld	ra,8(sp)
    800063a0:	6402                	ld	s0,0(sp)
    800063a2:	0141                	addi	sp,sp,16
    800063a4:	8082                	ret
    panic("pop_off - interruptible");
    800063a6:	00002517          	auipc	a0,0x2
    800063aa:	44a50513          	addi	a0,a0,1098 # 800087f0 <digits+0x28>
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	a1a080e7          	jalr	-1510(ra) # 80005dc8 <panic>
    panic("pop_off");
    800063b6:	00002517          	auipc	a0,0x2
    800063ba:	45250513          	addi	a0,a0,1106 # 80008808 <digits+0x40>
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	a0a080e7          	jalr	-1526(ra) # 80005dc8 <panic>

00000000800063c6 <release>:
{
    800063c6:	1101                	addi	sp,sp,-32
    800063c8:	ec06                	sd	ra,24(sp)
    800063ca:	e822                	sd	s0,16(sp)
    800063cc:	e426                	sd	s1,8(sp)
    800063ce:	1000                	addi	s0,sp,32
    800063d0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	ec6080e7          	jalr	-314(ra) # 80006298 <holding>
    800063da:	c115                	beqz	a0,800063fe <release+0x38>
  lk->cpu = 0;
    800063dc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063e0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063e4:	0f50000f          	fence	iorw,ow
    800063e8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	f7a080e7          	jalr	-134(ra) # 80006366 <pop_off>
}
    800063f4:	60e2                	ld	ra,24(sp)
    800063f6:	6442                	ld	s0,16(sp)
    800063f8:	64a2                	ld	s1,8(sp)
    800063fa:	6105                	addi	sp,sp,32
    800063fc:	8082                	ret
    panic("release");
    800063fe:	00002517          	auipc	a0,0x2
    80006402:	41250513          	addi	a0,a0,1042 # 80008810 <digits+0x48>
    80006406:	00000097          	auipc	ra,0x0
    8000640a:	9c2080e7          	jalr	-1598(ra) # 80005dc8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
