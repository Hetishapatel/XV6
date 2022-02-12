
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	053050ef          	jal	ra,80005868 <start>

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
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
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
    8000005e:	208080e7          	jalr	520(ra) # 80006262 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2a8080e7          	jalr	680(ra) # 80006316 <release>
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
    8000008e:	c8e080e7          	jalr	-882(ra) # 80005d18 <panic>

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
    800000f8:	0de080e7          	jalr	222(ra) # 800061d2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
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
    80000130:	136080e7          	jalr	310(ra) # 80006262 <acquire>
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
    80000148:	1d2080e7          	jalr	466(ra) # 80006316 <release>

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
    80000172:	1a8080e7          	jalr	424(ra) # 80006316 <release>
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
    80000332:	c1a080e7          	jalr	-998(ra) # 80000f48 <cpuid>
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
    8000034e:	bfe080e7          	jalr	-1026(ra) # 80000f48 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	a06080e7          	jalr	-1530(ra) # 80005d62 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	904080e7          	jalr	-1788(ra) # 80001c70 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	e7c080e7          	jalr	-388(ra) # 800051f0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	1b2080e7          	jalr	434(ra) # 8000152e <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	8a6080e7          	jalr	-1882(ra) # 80005c2a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	bbc080e7          	jalr	-1092(ra) # 80005f48 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	9c6080e7          	jalr	-1594(ra) # 80005d62 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	9b6080e7          	jalr	-1610(ra) # 80005d62 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	9a6080e7          	jalr	-1626(ra) # 80005d62 <printf>
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
    800003e0:	abe080e7          	jalr	-1346(ra) # 80000e9a <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	864080e7          	jalr	-1948(ra) # 80001c48 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	884080e7          	jalr	-1916(ra) # 80001c70 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	de6080e7          	jalr	-538(ra) # 800051da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	df4080e7          	jalr	-524(ra) # 800051f0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	fbc080e7          	jalr	-68(ra) # 800023c0 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	64c080e7          	jalr	1612(ra) # 80002a58 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	5f6080e7          	jalr	1526(ra) # 80003a0a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	ef6080e7          	jalr	-266(ra) # 80005312 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	ed8080e7          	jalr	-296(ra) # 800012fc <userinit>
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
    80000492:	88a080e7          	jalr	-1910(ra) # 80005d18 <panic>
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
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	792080e7          	jalr	1938(ra) # 80005d18 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	782080e7          	jalr	1922(ra) # 80005d18 <panic>
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
    80000614:	708080e7          	jalr	1800(ra) # 80005d18 <panic>

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
    800006dc:	72e080e7          	jalr	1838(ra) # 80000e06 <proc_mapstacks>
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
    80000760:	5bc080e7          	jalr	1468(ra) # 80005d18 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	5ac080e7          	jalr	1452(ra) # 80005d18 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	59c080e7          	jalr	1436(ra) # 80005d18 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	58c080e7          	jalr	1420(ra) # 80005d18 <panic>
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
    8000086e:	4ae080e7          	jalr	1198(ra) # 80005d18 <panic>

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
    800009b0:	36c080e7          	jalr	876(ra) # 80005d18 <panic>
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
    80000a8c:	290080e7          	jalr	656(ra) # 80005d18 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	280080e7          	jalr	640(ra) # 80005d18 <panic>
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
    80000b06:	216080e7          	jalr	534(ra) # 80005d18 <panic>

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

0000000080000cd6 <vmprintwalk>:


void vmprintwalk(pagetable_t pagetable, int level)
{
    80000cd6:	711d                	addi	sp,sp,-96
    80000cd8:	ec86                	sd	ra,88(sp)
    80000cda:	e8a2                	sd	s0,80(sp)
    80000cdc:	e4a6                	sd	s1,72(sp)
    80000cde:	e0ca                	sd	s2,64(sp)
    80000ce0:	fc4e                	sd	s3,56(sp)
    80000ce2:	f852                	sd	s4,48(sp)
    80000ce4:	f456                	sd	s5,40(sp)
    80000ce6:	f05a                	sd	s6,32(sp)
    80000ce8:	ec5e                	sd	s7,24(sp)
    80000cea:	e862                	sd	s8,16(sp)
    80000cec:	e466                	sd	s9,8(sp)
    80000cee:	1080                	addi	s0,sp,96
    80000cf0:	89ae                	mv	s3,a1
  for(int i=0; i<512; i++)
    80000cf2:	892a                	mv	s2,a0
    80000cf4:	4481                	li	s1,0
  {
   pte_t pte = pagetable[i];
  
   if(level==1)
    80000cf6:	4a05                	li	s4,1
       printf(".. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
       uint64 child = PTE2PA(pte);
       vmprintwalk((pagetable_t)child, level+1);
     }
    }
   if(level==2)
    80000cf8:	4b09                	li	s6,2
   {
     if(pte & PTE_V) 
     printf(".. .. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000cfa:	00007b97          	auipc	s7,0x7
    80000cfe:	476b8b93          	addi	s7,s7,1142 # 80008170 <etext+0x170>
       printf(".. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000d02:	00007c17          	auipc	s8,0x7
    80000d06:	456c0c13          	addi	s8,s8,1110 # 80008158 <etext+0x158>
  for(int i=0; i<512; i++)
    80000d0a:	20000a93          	li	s5,512
    80000d0e:	a809                	j	80000d20 <vmprintwalk+0x4a>
     if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000d10:	00f67793          	andi	a5,a2,15
    80000d14:	03478963          	beq	a5,s4,80000d46 <vmprintwalk+0x70>
  for(int i=0; i<512; i++)
    80000d18:	2485                	addiw	s1,s1,1
    80000d1a:	0921                	addi	s2,s2,8
    80000d1c:	05548663          	beq	s1,s5,80000d68 <vmprintwalk+0x92>
   pte_t pte = pagetable[i];
    80000d20:	00093603          	ld	a2,0(s2) # 1000 <_entry-0x7ffff000>
   if(level==1)
    80000d24:	ff4986e3          	beq	s3,s4,80000d10 <vmprintwalk+0x3a>
   if(level==2)
    80000d28:	ff6998e3          	bne	s3,s6,80000d18 <vmprintwalk+0x42>
     if(pte & PTE_V) 
    80000d2c:	00167793          	andi	a5,a2,1
    80000d30:	d7e5                	beqz	a5,80000d18 <vmprintwalk+0x42>
     printf(".. .. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000d32:	00a65693          	srli	a3,a2,0xa
    80000d36:	06b2                	slli	a3,a3,0xc
    80000d38:	85a6                	mv	a1,s1
    80000d3a:	855e                	mv	a0,s7
    80000d3c:	00005097          	auipc	ra,0x5
    80000d40:	026080e7          	jalr	38(ra) # 80005d62 <printf>
    80000d44:	bfd1                	j	80000d18 <vmprintwalk+0x42>
       printf(".. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000d46:	00a65c93          	srli	s9,a2,0xa
    80000d4a:	0cb2                	slli	s9,s9,0xc
    80000d4c:	86e6                	mv	a3,s9
    80000d4e:	85a6                	mv	a1,s1
    80000d50:	8562                	mv	a0,s8
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	010080e7          	jalr	16(ra) # 80005d62 <printf>
       vmprintwalk((pagetable_t)child, level+1);
    80000d5a:	85da                	mv	a1,s6
    80000d5c:	8566                	mv	a0,s9
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	f78080e7          	jalr	-136(ra) # 80000cd6 <vmprintwalk>
    80000d66:	bf4d                	j	80000d18 <vmprintwalk+0x42>
  //   uint64 child = PTE2PA(pte);
  //   if (level != 2) vmprintwalk((pagetable_t)child, level + 1);
  // }
  
 
}
    80000d68:	60e6                	ld	ra,88(sp)
    80000d6a:	6446                	ld	s0,80(sp)
    80000d6c:	64a6                	ld	s1,72(sp)
    80000d6e:	6906                	ld	s2,64(sp)
    80000d70:	79e2                	ld	s3,56(sp)
    80000d72:	7a42                	ld	s4,48(sp)
    80000d74:	7aa2                	ld	s5,40(sp)
    80000d76:	7b02                	ld	s6,32(sp)
    80000d78:	6be2                	ld	s7,24(sp)
    80000d7a:	6c42                	ld	s8,16(sp)
    80000d7c:	6ca2                	ld	s9,8(sp)
    80000d7e:	6125                	addi	sp,sp,96
    80000d80:	8082                	ret

0000000080000d82 <vmprint>:


// this function is added to print out the page table info.

void vmprint(pagetable_t pagetable)
{
    80000d82:	7139                	addi	sp,sp,-64
    80000d84:	fc06                	sd	ra,56(sp)
    80000d86:	f822                	sd	s0,48(sp)
    80000d88:	f426                	sd	s1,40(sp)
    80000d8a:	f04a                	sd	s2,32(sp)
    80000d8c:	ec4e                	sd	s3,24(sp)
    80000d8e:	e852                	sd	s4,16(sp)
    80000d90:	e456                	sd	s5,8(sp)
    80000d92:	e05a                	sd	s6,0(sp)
    80000d94:	0080                	addi	s0,sp,64
    80000d96:	892a                	mv	s2,a0
  printf("page table %p\n", pagetable);
    80000d98:	85aa                	mv	a1,a0
    80000d9a:	00007517          	auipc	a0,0x7
    80000d9e:	3f650513          	addi	a0,a0,1014 # 80008190 <etext+0x190>
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	fc0080e7          	jalr	-64(ra) # 80005d62 <printf>
  //vmprintwalk(pagetable,0);
  for(int i = 0; i < 512; i++){
    80000daa:	4481                	li	s1,0
    pte_t pte = pagetable[i];
    
 
   if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000dac:	4985                	li	s3,1
   {
     printf("..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000dae:	00007b17          	auipc	s6,0x7
    80000db2:	3f2b0b13          	addi	s6,s6,1010 # 800081a0 <etext+0x1a0>
  for(int i = 0; i < 512; i++){
    80000db6:	20000a13          	li	s4,512
    80000dba:	a02d                	j	80000de4 <vmprint+0x62>
     printf("..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000dbc:	00a65a93          	srli	s5,a2,0xa
    80000dc0:	0ab2                	slli	s5,s5,0xc
    80000dc2:	86d6                	mv	a3,s5
    80000dc4:	85a6                	mv	a1,s1
    80000dc6:	855a                	mv	a0,s6
    80000dc8:	00005097          	auipc	ra,0x5
    80000dcc:	f9a080e7          	jalr	-102(ra) # 80005d62 <printf>
     uint64 child = PTE2PA(pte);
     vmprintwalk((pagetable_t)child, 1);
    80000dd0:	85ce                	mv	a1,s3
    80000dd2:	8556                	mv	a0,s5
    80000dd4:	00000097          	auipc	ra,0x0
    80000dd8:	f02080e7          	jalr	-254(ra) # 80000cd6 <vmprintwalk>
  for(int i = 0; i < 512; i++){
    80000ddc:	2485                	addiw	s1,s1,1
    80000dde:	0921                	addi	s2,s2,8
    80000de0:	01448963          	beq	s1,s4,80000df2 <vmprint+0x70>
    pte_t pte = pagetable[i];
    80000de4:	00093603          	ld	a2,0(s2)
   if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000de8:	00f67793          	andi	a5,a2,15
    80000dec:	ff3798e3          	bne	a5,s3,80000ddc <vmprint+0x5a>
    80000df0:	b7f1                	j	80000dbc <vmprint+0x3a>
   }
  }
    80000df2:	70e2                	ld	ra,56(sp)
    80000df4:	7442                	ld	s0,48(sp)
    80000df6:	74a2                	ld	s1,40(sp)
    80000df8:	7902                	ld	s2,32(sp)
    80000dfa:	69e2                	ld	s3,24(sp)
    80000dfc:	6a42                	ld	s4,16(sp)
    80000dfe:	6aa2                	ld	s5,8(sp)
    80000e00:	6b02                	ld	s6,0(sp)
    80000e02:	6121                	addi	sp,sp,64
    80000e04:	8082                	ret

0000000080000e06 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e06:	7139                	addi	sp,sp,-64
    80000e08:	fc06                	sd	ra,56(sp)
    80000e0a:	f822                	sd	s0,48(sp)
    80000e0c:	f426                	sd	s1,40(sp)
    80000e0e:	f04a                	sd	s2,32(sp)
    80000e10:	ec4e                	sd	s3,24(sp)
    80000e12:	e852                	sd	s4,16(sp)
    80000e14:	e456                	sd	s5,8(sp)
    80000e16:	e05a                	sd	s6,0(sp)
    80000e18:	0080                	addi	s0,sp,64
    80000e1a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	00008497          	auipc	s1,0x8
    80000e20:	66448493          	addi	s1,s1,1636 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e24:	8b26                	mv	s6,s1
    80000e26:	00007a97          	auipc	s5,0x7
    80000e2a:	1daa8a93          	addi	s5,s5,474 # 80008000 <etext>
    80000e2e:	01000937          	lui	s2,0x1000
    80000e32:	197d                	addi	s2,s2,-1
    80000e34:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	0000ea17          	auipc	s4,0xe
    80000e3a:	24aa0a13          	addi	s4,s4,586 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e3e:	fffff097          	auipc	ra,0xfffff
    80000e42:	2da080e7          	jalr	730(ra) # 80000118 <kalloc>
    80000e46:	862a                	mv	a2,a0
    if(pa == 0)
    80000e48:	c129                	beqz	a0,80000e8a <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e4a:	416485b3          	sub	a1,s1,s6
    80000e4e:	8591                	srai	a1,a1,0x4
    80000e50:	000ab783          	ld	a5,0(s5)
    80000e54:	02f585b3          	mul	a1,a1,a5
    80000e58:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e5c:	4719                	li	a4,6
    80000e5e:	6685                	lui	a3,0x1
    80000e60:	40b905b3          	sub	a1,s2,a1
    80000e64:	854e                	mv	a0,s3
    80000e66:	fffff097          	auipc	ra,0xfffff
    80000e6a:	782080e7          	jalr	1922(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e6e:	17048493          	addi	s1,s1,368
    80000e72:	fd4496e3          	bne	s1,s4,80000e3e <proc_mapstacks+0x38>
  }
}
    80000e76:	70e2                	ld	ra,56(sp)
    80000e78:	7442                	ld	s0,48(sp)
    80000e7a:	74a2                	ld	s1,40(sp)
    80000e7c:	7902                	ld	s2,32(sp)
    80000e7e:	69e2                	ld	s3,24(sp)
    80000e80:	6a42                	ld	s4,16(sp)
    80000e82:	6aa2                	ld	s5,8(sp)
    80000e84:	6b02                	ld	s6,0(sp)
    80000e86:	6121                	addi	sp,sp,64
    80000e88:	8082                	ret
      panic("kalloc");
    80000e8a:	00007517          	auipc	a0,0x7
    80000e8e:	32e50513          	addi	a0,a0,814 # 800081b8 <etext+0x1b8>
    80000e92:	00005097          	auipc	ra,0x5
    80000e96:	e86080e7          	jalr	-378(ra) # 80005d18 <panic>

0000000080000e9a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e9a:	7139                	addi	sp,sp,-64
    80000e9c:	fc06                	sd	ra,56(sp)
    80000e9e:	f822                	sd	s0,48(sp)
    80000ea0:	f426                	sd	s1,40(sp)
    80000ea2:	f04a                	sd	s2,32(sp)
    80000ea4:	ec4e                	sd	s3,24(sp)
    80000ea6:	e852                	sd	s4,16(sp)
    80000ea8:	e456                	sd	s5,8(sp)
    80000eaa:	e05a                	sd	s6,0(sp)
    80000eac:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000eae:	00007597          	auipc	a1,0x7
    80000eb2:	31258593          	addi	a1,a1,786 # 800081c0 <etext+0x1c0>
    80000eb6:	00008517          	auipc	a0,0x8
    80000eba:	19a50513          	addi	a0,a0,410 # 80009050 <pid_lock>
    80000ebe:	00005097          	auipc	ra,0x5
    80000ec2:	314080e7          	jalr	788(ra) # 800061d2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ec6:	00007597          	auipc	a1,0x7
    80000eca:	30258593          	addi	a1,a1,770 # 800081c8 <etext+0x1c8>
    80000ece:	00008517          	auipc	a0,0x8
    80000ed2:	19a50513          	addi	a0,a0,410 # 80009068 <wait_lock>
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	2fc080e7          	jalr	764(ra) # 800061d2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ede:	00008497          	auipc	s1,0x8
    80000ee2:	5a248493          	addi	s1,s1,1442 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ee6:	00007b17          	auipc	s6,0x7
    80000eea:	2f2b0b13          	addi	s6,s6,754 # 800081d8 <etext+0x1d8>
      p->kstack = KSTACK((int) (p - proc));
    80000eee:	8aa6                	mv	s5,s1
    80000ef0:	00007a17          	auipc	s4,0x7
    80000ef4:	110a0a13          	addi	s4,s4,272 # 80008000 <etext>
    80000ef8:	01000937          	lui	s2,0x1000
    80000efc:	197d                	addi	s2,s2,-1
    80000efe:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f00:	0000e997          	auipc	s3,0xe
    80000f04:	18098993          	addi	s3,s3,384 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000f08:	85da                	mv	a1,s6
    80000f0a:	8526                	mv	a0,s1
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	2c6080e7          	jalr	710(ra) # 800061d2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f14:	415487b3          	sub	a5,s1,s5
    80000f18:	8791                	srai	a5,a5,0x4
    80000f1a:	000a3703          	ld	a4,0(s4)
    80000f1e:	02e787b3          	mul	a5,a5,a4
    80000f22:	00d7979b          	slliw	a5,a5,0xd
    80000f26:	40f907b3          	sub	a5,s2,a5
    80000f2a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2c:	17048493          	addi	s1,s1,368
    80000f30:	fd349ce3          	bne	s1,s3,80000f08 <procinit+0x6e>
  }
}
    80000f34:	70e2                	ld	ra,56(sp)
    80000f36:	7442                	ld	s0,48(sp)
    80000f38:	74a2                	ld	s1,40(sp)
    80000f3a:	7902                	ld	s2,32(sp)
    80000f3c:	69e2                	ld	s3,24(sp)
    80000f3e:	6a42                	ld	s4,16(sp)
    80000f40:	6aa2                	ld	s5,8(sp)
    80000f42:	6b02                	ld	s6,0(sp)
    80000f44:	6121                	addi	sp,sp,64
    80000f46:	8082                	ret

0000000080000f48 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f48:	1141                	addi	sp,sp,-16
    80000f4a:	e422                	sd	s0,8(sp)
    80000f4c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f4e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f50:	2501                	sext.w	a0,a0
    80000f52:	6422                	ld	s0,8(sp)
    80000f54:	0141                	addi	sp,sp,16
    80000f56:	8082                	ret

0000000080000f58 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f58:	1141                	addi	sp,sp,-16
    80000f5a:	e422                	sd	s0,8(sp)
    80000f5c:	0800                	addi	s0,sp,16
    80000f5e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f60:	2781                	sext.w	a5,a5
    80000f62:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f64:	00008517          	auipc	a0,0x8
    80000f68:	11c50513          	addi	a0,a0,284 # 80009080 <cpus>
    80000f6c:	953e                	add	a0,a0,a5
    80000f6e:	6422                	ld	s0,8(sp)
    80000f70:	0141                	addi	sp,sp,16
    80000f72:	8082                	ret

0000000080000f74 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f74:	1101                	addi	sp,sp,-32
    80000f76:	ec06                	sd	ra,24(sp)
    80000f78:	e822                	sd	s0,16(sp)
    80000f7a:	e426                	sd	s1,8(sp)
    80000f7c:	1000                	addi	s0,sp,32
  push_off();
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	298080e7          	jalr	664(ra) # 80006216 <push_off>
    80000f86:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f88:	2781                	sext.w	a5,a5
    80000f8a:	079e                	slli	a5,a5,0x7
    80000f8c:	00008717          	auipc	a4,0x8
    80000f90:	0c470713          	addi	a4,a4,196 # 80009050 <pid_lock>
    80000f94:	97ba                	add	a5,a5,a4
    80000f96:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f98:	00005097          	auipc	ra,0x5
    80000f9c:	31e080e7          	jalr	798(ra) # 800062b6 <pop_off>
  return p;
}
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	60e2                	ld	ra,24(sp)
    80000fa4:	6442                	ld	s0,16(sp)
    80000fa6:	64a2                	ld	s1,8(sp)
    80000fa8:	6105                	addi	sp,sp,32
    80000faa:	8082                	ret

0000000080000fac <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fac:	1141                	addi	sp,sp,-16
    80000fae:	e406                	sd	ra,8(sp)
    80000fb0:	e022                	sd	s0,0(sp)
    80000fb2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fb4:	00000097          	auipc	ra,0x0
    80000fb8:	fc0080e7          	jalr	-64(ra) # 80000f74 <myproc>
    80000fbc:	00005097          	auipc	ra,0x5
    80000fc0:	35a080e7          	jalr	858(ra) # 80006316 <release>

  if (first) {
    80000fc4:	00008797          	auipc	a5,0x8
    80000fc8:	8fc7a783          	lw	a5,-1796(a5) # 800088c0 <first.1681>
    80000fcc:	eb89                	bnez	a5,80000fde <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fce:	00001097          	auipc	ra,0x1
    80000fd2:	cba080e7          	jalr	-838(ra) # 80001c88 <usertrapret>
}
    80000fd6:	60a2                	ld	ra,8(sp)
    80000fd8:	6402                	ld	s0,0(sp)
    80000fda:	0141                	addi	sp,sp,16
    80000fdc:	8082                	ret
    first = 0;
    80000fde:	00008797          	auipc	a5,0x8
    80000fe2:	8e07a123          	sw	zero,-1822(a5) # 800088c0 <first.1681>
    fsinit(ROOTDEV);
    80000fe6:	4505                	li	a0,1
    80000fe8:	00002097          	auipc	ra,0x2
    80000fec:	9f0080e7          	jalr	-1552(ra) # 800029d8 <fsinit>
    80000ff0:	bff9                	j	80000fce <forkret+0x22>

0000000080000ff2 <allocpid>:
allocpid() {
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ffe:	00008917          	auipc	s2,0x8
    80001002:	05290913          	addi	s2,s2,82 # 80009050 <pid_lock>
    80001006:	854a                	mv	a0,s2
    80001008:	00005097          	auipc	ra,0x5
    8000100c:	25a080e7          	jalr	602(ra) # 80006262 <acquire>
  pid = nextpid;
    80001010:	00008797          	auipc	a5,0x8
    80001014:	8b478793          	addi	a5,a5,-1868 # 800088c4 <nextpid>
    80001018:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000101a:	0014871b          	addiw	a4,s1,1
    8000101e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001020:	854a                	mv	a0,s2
    80001022:	00005097          	auipc	ra,0x5
    80001026:	2f4080e7          	jalr	756(ra) # 80006316 <release>
}
    8000102a:	8526                	mv	a0,s1
    8000102c:	60e2                	ld	ra,24(sp)
    8000102e:	6442                	ld	s0,16(sp)
    80001030:	64a2                	ld	s1,8(sp)
    80001032:	6902                	ld	s2,0(sp)
    80001034:	6105                	addi	sp,sp,32
    80001036:	8082                	ret

0000000080001038 <proc_pagetable>:
{
    80001038:	1101                	addi	sp,sp,-32
    8000103a:	ec06                	sd	ra,24(sp)
    8000103c:	e822                	sd	s0,16(sp)
    8000103e:	e426                	sd	s1,8(sp)
    80001040:	e04a                	sd	s2,0(sp)
    80001042:	1000                	addi	s0,sp,32
    80001044:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	78c080e7          	jalr	1932(ra) # 800007d2 <uvmcreate>
    8000104e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001050:	cd39                	beqz	a0,800010ae <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001052:	4729                	li	a4,10
    80001054:	00006697          	auipc	a3,0x6
    80001058:	fac68693          	addi	a3,a3,-84 # 80007000 <_trampoline>
    8000105c:	6605                	lui	a2,0x1
    8000105e:	040005b7          	lui	a1,0x4000
    80001062:	15fd                	addi	a1,a1,-1
    80001064:	05b2                	slli	a1,a1,0xc
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	4e2080e7          	jalr	1250(ra) # 80000548 <mappages>
    8000106e:	04054763          	bltz	a0,800010bc <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001072:	4719                	li	a4,6
    80001074:	06093683          	ld	a3,96(s2)
    80001078:	6605                	lui	a2,0x1
    8000107a:	020005b7          	lui	a1,0x2000
    8000107e:	15fd                	addi	a1,a1,-1
    80001080:	05b6                	slli	a1,a1,0xd
    80001082:	8526                	mv	a0,s1
    80001084:	fffff097          	auipc	ra,0xfffff
    80001088:	4c4080e7          	jalr	1220(ra) # 80000548 <mappages>
    8000108c:	04054063          	bltz	a0,800010cc <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001090:	4749                	li	a4,18
    80001092:	05893683          	ld	a3,88(s2)
    80001096:	6605                	lui	a2,0x1
    80001098:	040005b7          	lui	a1,0x4000
    8000109c:	15f5                	addi	a1,a1,-3
    8000109e:	05b2                	slli	a1,a1,0xc
    800010a0:	8526                	mv	a0,s1
    800010a2:	fffff097          	auipc	ra,0xfffff
    800010a6:	4a6080e7          	jalr	1190(ra) # 80000548 <mappages>
    800010aa:	04054463          	bltz	a0,800010f2 <proc_pagetable+0xba>
}
    800010ae:	8526                	mv	a0,s1
    800010b0:	60e2                	ld	ra,24(sp)
    800010b2:	6442                	ld	s0,16(sp)
    800010b4:	64a2                	ld	s1,8(sp)
    800010b6:	6902                	ld	s2,0(sp)
    800010b8:	6105                	addi	sp,sp,32
    800010ba:	8082                	ret
    uvmfree(pagetable, 0);
    800010bc:	4581                	li	a1,0
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	90e080e7          	jalr	-1778(ra) # 800009ce <uvmfree>
    return 0;
    800010c8:	4481                	li	s1,0
    800010ca:	b7d5                	j	800010ae <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010cc:	4681                	li	a3,0
    800010ce:	4605                	li	a2,1
    800010d0:	040005b7          	lui	a1,0x4000
    800010d4:	15fd                	addi	a1,a1,-1
    800010d6:	05b2                	slli	a1,a1,0xc
    800010d8:	8526                	mv	a0,s1
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	634080e7          	jalr	1588(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    800010e2:	4581                	li	a1,0
    800010e4:	8526                	mv	a0,s1
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	8e8080e7          	jalr	-1816(ra) # 800009ce <uvmfree>
    return 0;
    800010ee:	4481                	li	s1,0
    800010f0:	bf7d                	j	800010ae <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f2:	4681                	li	a3,0
    800010f4:	4605                	li	a2,1
    800010f6:	040005b7          	lui	a1,0x4000
    800010fa:	15fd                	addi	a1,a1,-1
    800010fc:	05b2                	slli	a1,a1,0xc
    800010fe:	8526                	mv	a0,s1
    80001100:	fffff097          	auipc	ra,0xfffff
    80001104:	60e080e7          	jalr	1550(ra) # 8000070e <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001108:	4681                	li	a3,0
    8000110a:	4605                	li	a2,1
    8000110c:	020005b7          	lui	a1,0x2000
    80001110:	15fd                	addi	a1,a1,-1
    80001112:	05b6                	slli	a1,a1,0xd
    80001114:	8526                	mv	a0,s1
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	5f8080e7          	jalr	1528(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    8000111e:	4581                	li	a1,0
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	8ac080e7          	jalr	-1876(ra) # 800009ce <uvmfree>
    return 0;
    8000112a:	4481                	li	s1,0
    8000112c:	b749                	j	800010ae <proc_pagetable+0x76>

000000008000112e <proc_freepagetable>:
{
    8000112e:	7179                	addi	sp,sp,-48
    80001130:	f406                	sd	ra,40(sp)
    80001132:	f022                	sd	s0,32(sp)
    80001134:	ec26                	sd	s1,24(sp)
    80001136:	e84a                	sd	s2,16(sp)
    80001138:	e44e                	sd	s3,8(sp)
    8000113a:	1800                	addi	s0,sp,48
    8000113c:	84aa                	mv	s1,a0
    8000113e:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001140:	4681                	li	a3,0
    80001142:	4605                	li	a2,1
    80001144:	04000937          	lui	s2,0x4000
    80001148:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000114c:	05b2                	slli	a1,a1,0xc
    8000114e:	fffff097          	auipc	ra,0xfffff
    80001152:	5c0080e7          	jalr	1472(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001156:	4681                	li	a3,0
    80001158:	4605                	li	a2,1
    8000115a:	020005b7          	lui	a1,0x2000
    8000115e:	15fd                	addi	a1,a1,-1
    80001160:	05b6                	slli	a1,a1,0xd
    80001162:	8526                	mv	a0,s1
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	5aa080e7          	jalr	1450(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000116c:	4681                	li	a3,0
    8000116e:	4605                	li	a2,1
    80001170:	1975                	addi	s2,s2,-3
    80001172:	00c91593          	slli	a1,s2,0xc
    80001176:	8526                	mv	a0,s1
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	596080e7          	jalr	1430(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001180:	85ce                	mv	a1,s3
    80001182:	8526                	mv	a0,s1
    80001184:	00000097          	auipc	ra,0x0
    80001188:	84a080e7          	jalr	-1974(ra) # 800009ce <uvmfree>
}
    8000118c:	70a2                	ld	ra,40(sp)
    8000118e:	7402                	ld	s0,32(sp)
    80001190:	64e2                	ld	s1,24(sp)
    80001192:	6942                	ld	s2,16(sp)
    80001194:	69a2                	ld	s3,8(sp)
    80001196:	6145                	addi	sp,sp,48
    80001198:	8082                	ret

000000008000119a <freeproc>:
{
    8000119a:	1101                	addi	sp,sp,-32
    8000119c:	ec06                	sd	ra,24(sp)
    8000119e:	e822                	sd	s0,16(sp)
    800011a0:	e426                	sd	s1,8(sp)
    800011a2:	1000                	addi	s0,sp,32
    800011a4:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011a6:	7128                	ld	a0,96(a0)
    800011a8:	c509                	beqz	a0,800011b2 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011aa:	fffff097          	auipc	ra,0xfffff
    800011ae:	e72080e7          	jalr	-398(ra) # 8000001c <kfree>
  if(p->readonlypage)
    800011b2:	6ca8                	ld	a0,88(s1)
    800011b4:	c509                	beqz	a0,800011be <freeproc+0x24>
    kfree((void*)p->readonlypage);
    800011b6:	fffff097          	auipc	ra,0xfffff
    800011ba:	e66080e7          	jalr	-410(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011be:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011c2:	68a8                	ld	a0,80(s1)
    800011c4:	c511                	beqz	a0,800011d0 <freeproc+0x36>
    proc_freepagetable(p->pagetable, p->sz);
    800011c6:	64ac                	ld	a1,72(s1)
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	f66080e7          	jalr	-154(ra) # 8000112e <proc_freepagetable>
  p->pagetable = 0;
    800011d0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011d4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011d8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011dc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011e0:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011e4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011e8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011ec:	0204a623          	sw	zero,44(s1)
  p->readonlypage=0;
    800011f0:	0404bc23          	sd	zero,88(s1)
  p->state = UNUSED;
    800011f4:	0004ac23          	sw	zero,24(s1)
}
    800011f8:	60e2                	ld	ra,24(sp)
    800011fa:	6442                	ld	s0,16(sp)
    800011fc:	64a2                	ld	s1,8(sp)
    800011fe:	6105                	addi	sp,sp,32
    80001200:	8082                	ret

0000000080001202 <allocproc>:
{
    80001202:	1101                	addi	sp,sp,-32
    80001204:	ec06                	sd	ra,24(sp)
    80001206:	e822                	sd	s0,16(sp)
    80001208:	e426                	sd	s1,8(sp)
    8000120a:	e04a                	sd	s2,0(sp)
    8000120c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000120e:	00008497          	auipc	s1,0x8
    80001212:	27248493          	addi	s1,s1,626 # 80009480 <proc>
    80001216:	0000e917          	auipc	s2,0xe
    8000121a:	e6a90913          	addi	s2,s2,-406 # 8000f080 <tickslock>
    acquire(&p->lock);
    8000121e:	8526                	mv	a0,s1
    80001220:	00005097          	auipc	ra,0x5
    80001224:	042080e7          	jalr	66(ra) # 80006262 <acquire>
    if(p->state == UNUSED) {
    80001228:	4c9c                	lw	a5,24(s1)
    8000122a:	cf81                	beqz	a5,80001242 <allocproc+0x40>
      release(&p->lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	00005097          	auipc	ra,0x5
    80001232:	0e8080e7          	jalr	232(ra) # 80006316 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001236:	17048493          	addi	s1,s1,368
    8000123a:	ff2492e3          	bne	s1,s2,8000121e <allocproc+0x1c>
  return 0;
    8000123e:	4481                	li	s1,0
    80001240:	a09d                	j	800012a6 <allocproc+0xa4>
  p->pid = allocpid();
    80001242:	00000097          	auipc	ra,0x0
    80001246:	db0080e7          	jalr	-592(ra) # 80000ff2 <allocpid>
    8000124a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000124c:	4785                	li	a5,1
    8000124e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	ec8080e7          	jalr	-312(ra) # 80000118 <kalloc>
    80001258:	892a                	mv	s2,a0
    8000125a:	f0a8                	sd	a0,96(s1)
    8000125c:	cd21                	beqz	a0,800012b4 <allocproc+0xb2>
  if((p->readonlypage = (struct usyscall *)kalloc()) == 0){
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	eba080e7          	jalr	-326(ra) # 80000118 <kalloc>
    80001266:	892a                	mv	s2,a0
    80001268:	eca8                	sd	a0,88(s1)
    8000126a:	c12d                	beqz	a0,800012cc <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    8000126c:	8526                	mv	a0,s1
    8000126e:	00000097          	auipc	ra,0x0
    80001272:	dca080e7          	jalr	-566(ra) # 80001038 <proc_pagetable>
    80001276:	892a                	mv	s2,a0
    80001278:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000127a:	c52d                	beqz	a0,800012e4 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    8000127c:	07000613          	li	a2,112
    80001280:	4581                	li	a1,0
    80001282:	06848513          	addi	a0,s1,104
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	ef2080e7          	jalr	-270(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000128e:	00000797          	auipc	a5,0x0
    80001292:	d1e78793          	addi	a5,a5,-738 # 80000fac <forkret>
    80001296:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001298:	60bc                	ld	a5,64(s1)
    8000129a:	6705                	lui	a4,0x1
    8000129c:	97ba                	add	a5,a5,a4
    8000129e:	f8bc                	sd	a5,112(s1)
  p->readonlypage->pid = p->pid;
    800012a0:	6cbc                	ld	a5,88(s1)
    800012a2:	5898                	lw	a4,48(s1)
    800012a4:	c398                	sw	a4,0(a5)
}
    800012a6:	8526                	mv	a0,s1
    800012a8:	60e2                	ld	ra,24(sp)
    800012aa:	6442                	ld	s0,16(sp)
    800012ac:	64a2                	ld	s1,8(sp)
    800012ae:	6902                	ld	s2,0(sp)
    800012b0:	6105                	addi	sp,sp,32
    800012b2:	8082                	ret
    freeproc(p);
    800012b4:	8526                	mv	a0,s1
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	ee4080e7          	jalr	-284(ra) # 8000119a <freeproc>
    release(&p->lock);
    800012be:	8526                	mv	a0,s1
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	056080e7          	jalr	86(ra) # 80006316 <release>
    return 0;
    800012c8:	84ca                	mv	s1,s2
    800012ca:	bff1                	j	800012a6 <allocproc+0xa4>
    freeproc(p);
    800012cc:	8526                	mv	a0,s1
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	ecc080e7          	jalr	-308(ra) # 8000119a <freeproc>
    release(&p->lock);
    800012d6:	8526                	mv	a0,s1
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	03e080e7          	jalr	62(ra) # 80006316 <release>
    return 0;
    800012e0:	84ca                	mv	s1,s2
    800012e2:	b7d1                	j	800012a6 <allocproc+0xa4>
    freeproc(p);
    800012e4:	8526                	mv	a0,s1
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	eb4080e7          	jalr	-332(ra) # 8000119a <freeproc>
    release(&p->lock);
    800012ee:	8526                	mv	a0,s1
    800012f0:	00005097          	auipc	ra,0x5
    800012f4:	026080e7          	jalr	38(ra) # 80006316 <release>
    return 0;
    800012f8:	84ca                	mv	s1,s2
    800012fa:	b775                	j	800012a6 <allocproc+0xa4>

00000000800012fc <userinit>:
{
    800012fc:	1101                	addi	sp,sp,-32
    800012fe:	ec06                	sd	ra,24(sp)
    80001300:	e822                	sd	s0,16(sp)
    80001302:	e426                	sd	s1,8(sp)
    80001304:	1000                	addi	s0,sp,32
  p = allocproc();
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	efc080e7          	jalr	-260(ra) # 80001202 <allocproc>
    8000130e:	84aa                	mv	s1,a0
  initproc = p;
    80001310:	00008797          	auipc	a5,0x8
    80001314:	d0a7b023          	sd	a0,-768(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001318:	03400613          	li	a2,52
    8000131c:	00007597          	auipc	a1,0x7
    80001320:	5b458593          	addi	a1,a1,1460 # 800088d0 <initcode>
    80001324:	6928                	ld	a0,80(a0)
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	4da080e7          	jalr	1242(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    8000132e:	6785                	lui	a5,0x1
    80001330:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001332:	70b8                	ld	a4,96(s1)
    80001334:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001338:	70b8                	ld	a4,96(s1)
    8000133a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000133c:	4641                	li	a2,16
    8000133e:	00007597          	auipc	a1,0x7
    80001342:	ea258593          	addi	a1,a1,-350 # 800081e0 <etext+0x1e0>
    80001346:	16048513          	addi	a0,s1,352
    8000134a:	fffff097          	auipc	ra,0xfffff
    8000134e:	f80080e7          	jalr	-128(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001352:	00007517          	auipc	a0,0x7
    80001356:	e9e50513          	addi	a0,a0,-354 # 800081f0 <etext+0x1f0>
    8000135a:	00002097          	auipc	ra,0x2
    8000135e:	0ac080e7          	jalr	172(ra) # 80003406 <namei>
    80001362:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	faa080e7          	jalr	-86(ra) # 80006316 <release>
}
    80001374:	60e2                	ld	ra,24(sp)
    80001376:	6442                	ld	s0,16(sp)
    80001378:	64a2                	ld	s1,8(sp)
    8000137a:	6105                	addi	sp,sp,32
    8000137c:	8082                	ret

000000008000137e <growproc>:
{
    8000137e:	1101                	addi	sp,sp,-32
    80001380:	ec06                	sd	ra,24(sp)
    80001382:	e822                	sd	s0,16(sp)
    80001384:	e426                	sd	s1,8(sp)
    80001386:	e04a                	sd	s2,0(sp)
    80001388:	1000                	addi	s0,sp,32
    8000138a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	be8080e7          	jalr	-1048(ra) # 80000f74 <myproc>
    80001394:	892a                	mv	s2,a0
  sz = p->sz;
    80001396:	652c                	ld	a1,72(a0)
    80001398:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000139c:	00904f63          	bgtz	s1,800013ba <growproc+0x3c>
  } else if(n < 0){
    800013a0:	0204cc63          	bltz	s1,800013d8 <growproc+0x5a>
  p->sz = sz;
    800013a4:	1602                	slli	a2,a2,0x20
    800013a6:	9201                	srli	a2,a2,0x20
    800013a8:	04c93423          	sd	a2,72(s2)
  return 0;
    800013ac:	4501                	li	a0,0
}
    800013ae:	60e2                	ld	ra,24(sp)
    800013b0:	6442                	ld	s0,16(sp)
    800013b2:	64a2                	ld	s1,8(sp)
    800013b4:	6902                	ld	s2,0(sp)
    800013b6:	6105                	addi	sp,sp,32
    800013b8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013ba:	9e25                	addw	a2,a2,s1
    800013bc:	1602                	slli	a2,a2,0x20
    800013be:	9201                	srli	a2,a2,0x20
    800013c0:	1582                	slli	a1,a1,0x20
    800013c2:	9181                	srli	a1,a1,0x20
    800013c4:	6928                	ld	a0,80(a0)
    800013c6:	fffff097          	auipc	ra,0xfffff
    800013ca:	4f4080e7          	jalr	1268(ra) # 800008ba <uvmalloc>
    800013ce:	0005061b          	sext.w	a2,a0
    800013d2:	fa69                	bnez	a2,800013a4 <growproc+0x26>
      return -1;
    800013d4:	557d                	li	a0,-1
    800013d6:	bfe1                	j	800013ae <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013d8:	9e25                	addw	a2,a2,s1
    800013da:	1602                	slli	a2,a2,0x20
    800013dc:	9201                	srli	a2,a2,0x20
    800013de:	1582                	slli	a1,a1,0x20
    800013e0:	9181                	srli	a1,a1,0x20
    800013e2:	6928                	ld	a0,80(a0)
    800013e4:	fffff097          	auipc	ra,0xfffff
    800013e8:	48e080e7          	jalr	1166(ra) # 80000872 <uvmdealloc>
    800013ec:	0005061b          	sext.w	a2,a0
    800013f0:	bf55                	j	800013a4 <growproc+0x26>

00000000800013f2 <fork>:
{
    800013f2:	7179                	addi	sp,sp,-48
    800013f4:	f406                	sd	ra,40(sp)
    800013f6:	f022                	sd	s0,32(sp)
    800013f8:	ec26                	sd	s1,24(sp)
    800013fa:	e84a                	sd	s2,16(sp)
    800013fc:	e44e                	sd	s3,8(sp)
    800013fe:	e052                	sd	s4,0(sp)
    80001400:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001402:	00000097          	auipc	ra,0x0
    80001406:	b72080e7          	jalr	-1166(ra) # 80000f74 <myproc>
    8000140a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	df6080e7          	jalr	-522(ra) # 80001202 <allocproc>
    80001414:	10050b63          	beqz	a0,8000152a <fork+0x138>
    80001418:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000141a:	04893603          	ld	a2,72(s2)
    8000141e:	692c                	ld	a1,80(a0)
    80001420:	05093503          	ld	a0,80(s2)
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	5e2080e7          	jalr	1506(ra) # 80000a06 <uvmcopy>
    8000142c:	04054663          	bltz	a0,80001478 <fork+0x86>
  np->sz = p->sz;
    80001430:	04893783          	ld	a5,72(s2)
    80001434:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001438:	06093683          	ld	a3,96(s2)
    8000143c:	87b6                	mv	a5,a3
    8000143e:	0609b703          	ld	a4,96(s3)
    80001442:	12068693          	addi	a3,a3,288
    80001446:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000144a:	6788                	ld	a0,8(a5)
    8000144c:	6b8c                	ld	a1,16(a5)
    8000144e:	6f90                	ld	a2,24(a5)
    80001450:	01073023          	sd	a6,0(a4)
    80001454:	e708                	sd	a0,8(a4)
    80001456:	eb0c                	sd	a1,16(a4)
    80001458:	ef10                	sd	a2,24(a4)
    8000145a:	02078793          	addi	a5,a5,32
    8000145e:	02070713          	addi	a4,a4,32
    80001462:	fed792e3          	bne	a5,a3,80001446 <fork+0x54>
  np->trapframe->a0 = 0;
    80001466:	0609b783          	ld	a5,96(s3)
    8000146a:	0607b823          	sd	zero,112(a5)
    8000146e:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001472:	15800a13          	li	s4,344
    80001476:	a03d                	j	800014a4 <fork+0xb2>
    freeproc(np);
    80001478:	854e                	mv	a0,s3
    8000147a:	00000097          	auipc	ra,0x0
    8000147e:	d20080e7          	jalr	-736(ra) # 8000119a <freeproc>
    release(&np->lock);
    80001482:	854e                	mv	a0,s3
    80001484:	00005097          	auipc	ra,0x5
    80001488:	e92080e7          	jalr	-366(ra) # 80006316 <release>
    return -1;
    8000148c:	5a7d                	li	s4,-1
    8000148e:	a069                	j	80001518 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001490:	00002097          	auipc	ra,0x2
    80001494:	60c080e7          	jalr	1548(ra) # 80003a9c <filedup>
    80001498:	009987b3          	add	a5,s3,s1
    8000149c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000149e:	04a1                	addi	s1,s1,8
    800014a0:	01448763          	beq	s1,s4,800014ae <fork+0xbc>
    if(p->ofile[i])
    800014a4:	009907b3          	add	a5,s2,s1
    800014a8:	6388                	ld	a0,0(a5)
    800014aa:	f17d                	bnez	a0,80001490 <fork+0x9e>
    800014ac:	bfcd                	j	8000149e <fork+0xac>
  np->cwd = idup(p->cwd);
    800014ae:	15893503          	ld	a0,344(s2)
    800014b2:	00001097          	auipc	ra,0x1
    800014b6:	760080e7          	jalr	1888(ra) # 80002c12 <idup>
    800014ba:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014be:	4641                	li	a2,16
    800014c0:	16090593          	addi	a1,s2,352
    800014c4:	16098513          	addi	a0,s3,352
    800014c8:	fffff097          	auipc	ra,0xfffff
    800014cc:	e02080e7          	jalr	-510(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800014d0:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014d4:	854e                	mv	a0,s3
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	e40080e7          	jalr	-448(ra) # 80006316 <release>
  acquire(&wait_lock);
    800014de:	00008497          	auipc	s1,0x8
    800014e2:	b8a48493          	addi	s1,s1,-1142 # 80009068 <wait_lock>
    800014e6:	8526                	mv	a0,s1
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	d7a080e7          	jalr	-646(ra) # 80006262 <acquire>
  np->parent = p;
    800014f0:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	e20080e7          	jalr	-480(ra) # 80006316 <release>
  acquire(&np->lock);
    800014fe:	854e                	mv	a0,s3
    80001500:	00005097          	auipc	ra,0x5
    80001504:	d62080e7          	jalr	-670(ra) # 80006262 <acquire>
  np->state = RUNNABLE;
    80001508:	478d                	li	a5,3
    8000150a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000150e:	854e                	mv	a0,s3
    80001510:	00005097          	auipc	ra,0x5
    80001514:	e06080e7          	jalr	-506(ra) # 80006316 <release>
}
    80001518:	8552                	mv	a0,s4
    8000151a:	70a2                	ld	ra,40(sp)
    8000151c:	7402                	ld	s0,32(sp)
    8000151e:	64e2                	ld	s1,24(sp)
    80001520:	6942                	ld	s2,16(sp)
    80001522:	69a2                	ld	s3,8(sp)
    80001524:	6a02                	ld	s4,0(sp)
    80001526:	6145                	addi	sp,sp,48
    80001528:	8082                	ret
    return -1;
    8000152a:	5a7d                	li	s4,-1
    8000152c:	b7f5                	j	80001518 <fork+0x126>

000000008000152e <scheduler>:
{
    8000152e:	7139                	addi	sp,sp,-64
    80001530:	fc06                	sd	ra,56(sp)
    80001532:	f822                	sd	s0,48(sp)
    80001534:	f426                	sd	s1,40(sp)
    80001536:	f04a                	sd	s2,32(sp)
    80001538:	ec4e                	sd	s3,24(sp)
    8000153a:	e852                	sd	s4,16(sp)
    8000153c:	e456                	sd	s5,8(sp)
    8000153e:	e05a                	sd	s6,0(sp)
    80001540:	0080                	addi	s0,sp,64
    80001542:	8792                	mv	a5,tp
  int id = r_tp();
    80001544:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001546:	00779a93          	slli	s5,a5,0x7
    8000154a:	00008717          	auipc	a4,0x8
    8000154e:	b0670713          	addi	a4,a4,-1274 # 80009050 <pid_lock>
    80001552:	9756                	add	a4,a4,s5
    80001554:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001558:	00008717          	auipc	a4,0x8
    8000155c:	b3070713          	addi	a4,a4,-1232 # 80009088 <cpus+0x8>
    80001560:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001562:	498d                	li	s3,3
        p->state = RUNNING;
    80001564:	4b11                	li	s6,4
        c->proc = p;
    80001566:	079e                	slli	a5,a5,0x7
    80001568:	00008a17          	auipc	s4,0x8
    8000156c:	ae8a0a13          	addi	s4,s4,-1304 # 80009050 <pid_lock>
    80001570:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001572:	0000e917          	auipc	s2,0xe
    80001576:	b0e90913          	addi	s2,s2,-1266 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000157a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000157e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001582:	10079073          	csrw	sstatus,a5
    80001586:	00008497          	auipc	s1,0x8
    8000158a:	efa48493          	addi	s1,s1,-262 # 80009480 <proc>
    8000158e:	a03d                	j	800015bc <scheduler+0x8e>
        p->state = RUNNING;
    80001590:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001594:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001598:	06848593          	addi	a1,s1,104
    8000159c:	8556                	mv	a0,s5
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	640080e7          	jalr	1600(ra) # 80001bde <swtch>
        c->proc = 0;
    800015a6:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800015aa:	8526                	mv	a0,s1
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	d6a080e7          	jalr	-662(ra) # 80006316 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015b4:	17048493          	addi	s1,s1,368
    800015b8:	fd2481e3          	beq	s1,s2,8000157a <scheduler+0x4c>
      acquire(&p->lock);
    800015bc:	8526                	mv	a0,s1
    800015be:	00005097          	auipc	ra,0x5
    800015c2:	ca4080e7          	jalr	-860(ra) # 80006262 <acquire>
      if(p->state == RUNNABLE) {
    800015c6:	4c9c                	lw	a5,24(s1)
    800015c8:	ff3791e3          	bne	a5,s3,800015aa <scheduler+0x7c>
    800015cc:	b7d1                	j	80001590 <scheduler+0x62>

00000000800015ce <sched>:
{
    800015ce:	7179                	addi	sp,sp,-48
    800015d0:	f406                	sd	ra,40(sp)
    800015d2:	f022                	sd	s0,32(sp)
    800015d4:	ec26                	sd	s1,24(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	e44e                	sd	s3,8(sp)
    800015da:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	998080e7          	jalr	-1640(ra) # 80000f74 <myproc>
    800015e4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	c02080e7          	jalr	-1022(ra) # 800061e8 <holding>
    800015ee:	c93d                	beqz	a0,80001664 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015f0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015f2:	2781                	sext.w	a5,a5
    800015f4:	079e                	slli	a5,a5,0x7
    800015f6:	00008717          	auipc	a4,0x8
    800015fa:	a5a70713          	addi	a4,a4,-1446 # 80009050 <pid_lock>
    800015fe:	97ba                	add	a5,a5,a4
    80001600:	0a87a703          	lw	a4,168(a5)
    80001604:	4785                	li	a5,1
    80001606:	06f71763          	bne	a4,a5,80001674 <sched+0xa6>
  if(p->state == RUNNING)
    8000160a:	4c98                	lw	a4,24(s1)
    8000160c:	4791                	li	a5,4
    8000160e:	06f70b63          	beq	a4,a5,80001684 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001612:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001616:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001618:	efb5                	bnez	a5,80001694 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000161a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000161c:	00008917          	auipc	s2,0x8
    80001620:	a3490913          	addi	s2,s2,-1484 # 80009050 <pid_lock>
    80001624:	2781                	sext.w	a5,a5
    80001626:	079e                	slli	a5,a5,0x7
    80001628:	97ca                	add	a5,a5,s2
    8000162a:	0ac7a983          	lw	s3,172(a5)
    8000162e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001630:	2781                	sext.w	a5,a5
    80001632:	079e                	slli	a5,a5,0x7
    80001634:	00008597          	auipc	a1,0x8
    80001638:	a5458593          	addi	a1,a1,-1452 # 80009088 <cpus+0x8>
    8000163c:	95be                	add	a1,a1,a5
    8000163e:	06848513          	addi	a0,s1,104
    80001642:	00000097          	auipc	ra,0x0
    80001646:	59c080e7          	jalr	1436(ra) # 80001bde <swtch>
    8000164a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000164c:	2781                	sext.w	a5,a5
    8000164e:	079e                	slli	a5,a5,0x7
    80001650:	97ca                	add	a5,a5,s2
    80001652:	0b37a623          	sw	s3,172(a5)
}
    80001656:	70a2                	ld	ra,40(sp)
    80001658:	7402                	ld	s0,32(sp)
    8000165a:	64e2                	ld	s1,24(sp)
    8000165c:	6942                	ld	s2,16(sp)
    8000165e:	69a2                	ld	s3,8(sp)
    80001660:	6145                	addi	sp,sp,48
    80001662:	8082                	ret
    panic("sched p->lock");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	b9450513          	addi	a0,a0,-1132 # 800081f8 <etext+0x1f8>
    8000166c:	00004097          	auipc	ra,0x4
    80001670:	6ac080e7          	jalr	1708(ra) # 80005d18 <panic>
    panic("sched locks");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	b9450513          	addi	a0,a0,-1132 # 80008208 <etext+0x208>
    8000167c:	00004097          	auipc	ra,0x4
    80001680:	69c080e7          	jalr	1692(ra) # 80005d18 <panic>
    panic("sched running");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	b9450513          	addi	a0,a0,-1132 # 80008218 <etext+0x218>
    8000168c:	00004097          	auipc	ra,0x4
    80001690:	68c080e7          	jalr	1676(ra) # 80005d18 <panic>
    panic("sched interruptible");
    80001694:	00007517          	auipc	a0,0x7
    80001698:	b9450513          	addi	a0,a0,-1132 # 80008228 <etext+0x228>
    8000169c:	00004097          	auipc	ra,0x4
    800016a0:	67c080e7          	jalr	1660(ra) # 80005d18 <panic>

00000000800016a4 <yield>:
{
    800016a4:	1101                	addi	sp,sp,-32
    800016a6:	ec06                	sd	ra,24(sp)
    800016a8:	e822                	sd	s0,16(sp)
    800016aa:	e426                	sd	s1,8(sp)
    800016ac:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	8c6080e7          	jalr	-1850(ra) # 80000f74 <myproc>
    800016b6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	baa080e7          	jalr	-1110(ra) # 80006262 <acquire>
  p->state = RUNNABLE;
    800016c0:	478d                	li	a5,3
    800016c2:	cc9c                	sw	a5,24(s1)
  sched();
    800016c4:	00000097          	auipc	ra,0x0
    800016c8:	f0a080e7          	jalr	-246(ra) # 800015ce <sched>
  release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	c48080e7          	jalr	-952(ra) # 80006316 <release>
}
    800016d6:	60e2                	ld	ra,24(sp)
    800016d8:	6442                	ld	s0,16(sp)
    800016da:	64a2                	ld	s1,8(sp)
    800016dc:	6105                	addi	sp,sp,32
    800016de:	8082                	ret

00000000800016e0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016e0:	7179                	addi	sp,sp,-48
    800016e2:	f406                	sd	ra,40(sp)
    800016e4:	f022                	sd	s0,32(sp)
    800016e6:	ec26                	sd	s1,24(sp)
    800016e8:	e84a                	sd	s2,16(sp)
    800016ea:	e44e                	sd	s3,8(sp)
    800016ec:	1800                	addi	s0,sp,48
    800016ee:	89aa                	mv	s3,a0
    800016f0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016f2:	00000097          	auipc	ra,0x0
    800016f6:	882080e7          	jalr	-1918(ra) # 80000f74 <myproc>
    800016fa:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	b66080e7          	jalr	-1178(ra) # 80006262 <acquire>
  release(lk);
    80001704:	854a                	mv	a0,s2
    80001706:	00005097          	auipc	ra,0x5
    8000170a:	c10080e7          	jalr	-1008(ra) # 80006316 <release>

  // Go to sleep.
  p->chan = chan;
    8000170e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001712:	4789                	li	a5,2
    80001714:	cc9c                	sw	a5,24(s1)

  sched();
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	eb8080e7          	jalr	-328(ra) # 800015ce <sched>

  // Tidy up.
  p->chan = 0;
    8000171e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001722:	8526                	mv	a0,s1
    80001724:	00005097          	auipc	ra,0x5
    80001728:	bf2080e7          	jalr	-1038(ra) # 80006316 <release>
  acquire(lk);
    8000172c:	854a                	mv	a0,s2
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	b34080e7          	jalr	-1228(ra) # 80006262 <acquire>
}
    80001736:	70a2                	ld	ra,40(sp)
    80001738:	7402                	ld	s0,32(sp)
    8000173a:	64e2                	ld	s1,24(sp)
    8000173c:	6942                	ld	s2,16(sp)
    8000173e:	69a2                	ld	s3,8(sp)
    80001740:	6145                	addi	sp,sp,48
    80001742:	8082                	ret

0000000080001744 <wait>:
{
    80001744:	715d                	addi	sp,sp,-80
    80001746:	e486                	sd	ra,72(sp)
    80001748:	e0a2                	sd	s0,64(sp)
    8000174a:	fc26                	sd	s1,56(sp)
    8000174c:	f84a                	sd	s2,48(sp)
    8000174e:	f44e                	sd	s3,40(sp)
    80001750:	f052                	sd	s4,32(sp)
    80001752:	ec56                	sd	s5,24(sp)
    80001754:	e85a                	sd	s6,16(sp)
    80001756:	e45e                	sd	s7,8(sp)
    80001758:	e062                	sd	s8,0(sp)
    8000175a:	0880                	addi	s0,sp,80
    8000175c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000175e:	00000097          	auipc	ra,0x0
    80001762:	816080e7          	jalr	-2026(ra) # 80000f74 <myproc>
    80001766:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001768:	00008517          	auipc	a0,0x8
    8000176c:	90050513          	addi	a0,a0,-1792 # 80009068 <wait_lock>
    80001770:	00005097          	auipc	ra,0x5
    80001774:	af2080e7          	jalr	-1294(ra) # 80006262 <acquire>
    havekids = 0;
    80001778:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000177a:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000177c:	0000e997          	auipc	s3,0xe
    80001780:	90498993          	addi	s3,s3,-1788 # 8000f080 <tickslock>
        havekids = 1;
    80001784:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001786:	00008c17          	auipc	s8,0x8
    8000178a:	8e2c0c13          	addi	s8,s8,-1822 # 80009068 <wait_lock>
    havekids = 0;
    8000178e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001790:	00008497          	auipc	s1,0x8
    80001794:	cf048493          	addi	s1,s1,-784 # 80009480 <proc>
    80001798:	a0bd                	j	80001806 <wait+0xc2>
          pid = np->pid;
    8000179a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000179e:	000b0e63          	beqz	s6,800017ba <wait+0x76>
    800017a2:	4691                	li	a3,4
    800017a4:	02c48613          	addi	a2,s1,44
    800017a8:	85da                	mv	a1,s6
    800017aa:	05093503          	ld	a0,80(s2)
    800017ae:	fffff097          	auipc	ra,0xfffff
    800017b2:	35c080e7          	jalr	860(ra) # 80000b0a <copyout>
    800017b6:	02054563          	bltz	a0,800017e0 <wait+0x9c>
          freeproc(np);
    800017ba:	8526                	mv	a0,s1
    800017bc:	00000097          	auipc	ra,0x0
    800017c0:	9de080e7          	jalr	-1570(ra) # 8000119a <freeproc>
          release(&np->lock);
    800017c4:	8526                	mv	a0,s1
    800017c6:	00005097          	auipc	ra,0x5
    800017ca:	b50080e7          	jalr	-1200(ra) # 80006316 <release>
          release(&wait_lock);
    800017ce:	00008517          	auipc	a0,0x8
    800017d2:	89a50513          	addi	a0,a0,-1894 # 80009068 <wait_lock>
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	b40080e7          	jalr	-1216(ra) # 80006316 <release>
          return pid;
    800017de:	a09d                	j	80001844 <wait+0x100>
            release(&np->lock);
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	b34080e7          	jalr	-1228(ra) # 80006316 <release>
            release(&wait_lock);
    800017ea:	00008517          	auipc	a0,0x8
    800017ee:	87e50513          	addi	a0,a0,-1922 # 80009068 <wait_lock>
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	b24080e7          	jalr	-1244(ra) # 80006316 <release>
            return -1;
    800017fa:	59fd                	li	s3,-1
    800017fc:	a0a1                	j	80001844 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017fe:	17048493          	addi	s1,s1,368
    80001802:	03348463          	beq	s1,s3,8000182a <wait+0xe6>
      if(np->parent == p){
    80001806:	7c9c                	ld	a5,56(s1)
    80001808:	ff279be3          	bne	a5,s2,800017fe <wait+0xba>
        acquire(&np->lock);
    8000180c:	8526                	mv	a0,s1
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	a54080e7          	jalr	-1452(ra) # 80006262 <acquire>
        if(np->state == ZOMBIE){
    80001816:	4c9c                	lw	a5,24(s1)
    80001818:	f94781e3          	beq	a5,s4,8000179a <wait+0x56>
        release(&np->lock);
    8000181c:	8526                	mv	a0,s1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	af8080e7          	jalr	-1288(ra) # 80006316 <release>
        havekids = 1;
    80001826:	8756                	mv	a4,s5
    80001828:	bfd9                	j	800017fe <wait+0xba>
    if(!havekids || p->killed){
    8000182a:	c701                	beqz	a4,80001832 <wait+0xee>
    8000182c:	02892783          	lw	a5,40(s2)
    80001830:	c79d                	beqz	a5,8000185e <wait+0x11a>
      release(&wait_lock);
    80001832:	00008517          	auipc	a0,0x8
    80001836:	83650513          	addi	a0,a0,-1994 # 80009068 <wait_lock>
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	adc080e7          	jalr	-1316(ra) # 80006316 <release>
      return -1;
    80001842:	59fd                	li	s3,-1
}
    80001844:	854e                	mv	a0,s3
    80001846:	60a6                	ld	ra,72(sp)
    80001848:	6406                	ld	s0,64(sp)
    8000184a:	74e2                	ld	s1,56(sp)
    8000184c:	7942                	ld	s2,48(sp)
    8000184e:	79a2                	ld	s3,40(sp)
    80001850:	7a02                	ld	s4,32(sp)
    80001852:	6ae2                	ld	s5,24(sp)
    80001854:	6b42                	ld	s6,16(sp)
    80001856:	6ba2                	ld	s7,8(sp)
    80001858:	6c02                	ld	s8,0(sp)
    8000185a:	6161                	addi	sp,sp,80
    8000185c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000185e:	85e2                	mv	a1,s8
    80001860:	854a                	mv	a0,s2
    80001862:	00000097          	auipc	ra,0x0
    80001866:	e7e080e7          	jalr	-386(ra) # 800016e0 <sleep>
    havekids = 0;
    8000186a:	b715                	j	8000178e <wait+0x4a>

000000008000186c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000186c:	7139                	addi	sp,sp,-64
    8000186e:	fc06                	sd	ra,56(sp)
    80001870:	f822                	sd	s0,48(sp)
    80001872:	f426                	sd	s1,40(sp)
    80001874:	f04a                	sd	s2,32(sp)
    80001876:	ec4e                	sd	s3,24(sp)
    80001878:	e852                	sd	s4,16(sp)
    8000187a:	e456                	sd	s5,8(sp)
    8000187c:	0080                	addi	s0,sp,64
    8000187e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001880:	00008497          	auipc	s1,0x8
    80001884:	c0048493          	addi	s1,s1,-1024 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001888:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000188a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188c:	0000d917          	auipc	s2,0xd
    80001890:	7f490913          	addi	s2,s2,2036 # 8000f080 <tickslock>
    80001894:	a821                	j	800018ac <wakeup+0x40>
        p->state = RUNNABLE;
    80001896:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000189a:	8526                	mv	a0,s1
    8000189c:	00005097          	auipc	ra,0x5
    800018a0:	a7a080e7          	jalr	-1414(ra) # 80006316 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a4:	17048493          	addi	s1,s1,368
    800018a8:	03248463          	beq	s1,s2,800018d0 <wakeup+0x64>
    if(p != myproc()){
    800018ac:	fffff097          	auipc	ra,0xfffff
    800018b0:	6c8080e7          	jalr	1736(ra) # 80000f74 <myproc>
    800018b4:	fea488e3          	beq	s1,a0,800018a4 <wakeup+0x38>
      acquire(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	9a8080e7          	jalr	-1624(ra) # 80006262 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018c2:	4c9c                	lw	a5,24(s1)
    800018c4:	fd379be3          	bne	a5,s3,8000189a <wakeup+0x2e>
    800018c8:	709c                	ld	a5,32(s1)
    800018ca:	fd4798e3          	bne	a5,s4,8000189a <wakeup+0x2e>
    800018ce:	b7e1                	j	80001896 <wakeup+0x2a>
    }
  }
}
    800018d0:	70e2                	ld	ra,56(sp)
    800018d2:	7442                	ld	s0,48(sp)
    800018d4:	74a2                	ld	s1,40(sp)
    800018d6:	7902                	ld	s2,32(sp)
    800018d8:	69e2                	ld	s3,24(sp)
    800018da:	6a42                	ld	s4,16(sp)
    800018dc:	6aa2                	ld	s5,8(sp)
    800018de:	6121                	addi	sp,sp,64
    800018e0:	8082                	ret

00000000800018e2 <reparent>:
{
    800018e2:	7179                	addi	sp,sp,-48
    800018e4:	f406                	sd	ra,40(sp)
    800018e6:	f022                	sd	s0,32(sp)
    800018e8:	ec26                	sd	s1,24(sp)
    800018ea:	e84a                	sd	s2,16(sp)
    800018ec:	e44e                	sd	s3,8(sp)
    800018ee:	e052                	sd	s4,0(sp)
    800018f0:	1800                	addi	s0,sp,48
    800018f2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f4:	00008497          	auipc	s1,0x8
    800018f8:	b8c48493          	addi	s1,s1,-1140 # 80009480 <proc>
      pp->parent = initproc;
    800018fc:	00007a17          	auipc	s4,0x7
    80001900:	714a0a13          	addi	s4,s4,1812 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001904:	0000d997          	auipc	s3,0xd
    80001908:	77c98993          	addi	s3,s3,1916 # 8000f080 <tickslock>
    8000190c:	a029                	j	80001916 <reparent+0x34>
    8000190e:	17048493          	addi	s1,s1,368
    80001912:	01348d63          	beq	s1,s3,8000192c <reparent+0x4a>
    if(pp->parent == p){
    80001916:	7c9c                	ld	a5,56(s1)
    80001918:	ff279be3          	bne	a5,s2,8000190e <reparent+0x2c>
      pp->parent = initproc;
    8000191c:	000a3503          	ld	a0,0(s4)
    80001920:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001922:	00000097          	auipc	ra,0x0
    80001926:	f4a080e7          	jalr	-182(ra) # 8000186c <wakeup>
    8000192a:	b7d5                	j	8000190e <reparent+0x2c>
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret

000000008000193c <exit>:
{
    8000193c:	7179                	addi	sp,sp,-48
    8000193e:	f406                	sd	ra,40(sp)
    80001940:	f022                	sd	s0,32(sp)
    80001942:	ec26                	sd	s1,24(sp)
    80001944:	e84a                	sd	s2,16(sp)
    80001946:	e44e                	sd	s3,8(sp)
    80001948:	e052                	sd	s4,0(sp)
    8000194a:	1800                	addi	s0,sp,48
    8000194c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	626080e7          	jalr	1574(ra) # 80000f74 <myproc>
    80001956:	89aa                	mv	s3,a0
  if(p == initproc)
    80001958:	00007797          	auipc	a5,0x7
    8000195c:	6b87b783          	ld	a5,1720(a5) # 80009010 <initproc>
    80001960:	0d850493          	addi	s1,a0,216
    80001964:	15850913          	addi	s2,a0,344
    80001968:	02a79363          	bne	a5,a0,8000198e <exit+0x52>
    panic("init exiting");
    8000196c:	00007517          	auipc	a0,0x7
    80001970:	8d450513          	addi	a0,a0,-1836 # 80008240 <etext+0x240>
    80001974:	00004097          	auipc	ra,0x4
    80001978:	3a4080e7          	jalr	932(ra) # 80005d18 <panic>
      fileclose(f);
    8000197c:	00002097          	auipc	ra,0x2
    80001980:	172080e7          	jalr	370(ra) # 80003aee <fileclose>
      p->ofile[fd] = 0;
    80001984:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001988:	04a1                	addi	s1,s1,8
    8000198a:	01248563          	beq	s1,s2,80001994 <exit+0x58>
    if(p->ofile[fd]){
    8000198e:	6088                	ld	a0,0(s1)
    80001990:	f575                	bnez	a0,8000197c <exit+0x40>
    80001992:	bfdd                	j	80001988 <exit+0x4c>
  begin_op();
    80001994:	00002097          	auipc	ra,0x2
    80001998:	c8e080e7          	jalr	-882(ra) # 80003622 <begin_op>
  iput(p->cwd);
    8000199c:	1589b503          	ld	a0,344(s3)
    800019a0:	00001097          	auipc	ra,0x1
    800019a4:	46a080e7          	jalr	1130(ra) # 80002e0a <iput>
  end_op();
    800019a8:	00002097          	auipc	ra,0x2
    800019ac:	cfa080e7          	jalr	-774(ra) # 800036a2 <end_op>
  p->cwd = 0;
    800019b0:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019b4:	00007497          	auipc	s1,0x7
    800019b8:	6b448493          	addi	s1,s1,1716 # 80009068 <wait_lock>
    800019bc:	8526                	mv	a0,s1
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	8a4080e7          	jalr	-1884(ra) # 80006262 <acquire>
  reparent(p);
    800019c6:	854e                	mv	a0,s3
    800019c8:	00000097          	auipc	ra,0x0
    800019cc:	f1a080e7          	jalr	-230(ra) # 800018e2 <reparent>
  wakeup(p->parent);
    800019d0:	0389b503          	ld	a0,56(s3)
    800019d4:	00000097          	auipc	ra,0x0
    800019d8:	e98080e7          	jalr	-360(ra) # 8000186c <wakeup>
  acquire(&p->lock);
    800019dc:	854e                	mv	a0,s3
    800019de:	00005097          	auipc	ra,0x5
    800019e2:	884080e7          	jalr	-1916(ra) # 80006262 <acquire>
  p->xstate = status;
    800019e6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019ea:	4795                	li	a5,5
    800019ec:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019f0:	8526                	mv	a0,s1
    800019f2:	00005097          	auipc	ra,0x5
    800019f6:	924080e7          	jalr	-1756(ra) # 80006316 <release>
  sched();
    800019fa:	00000097          	auipc	ra,0x0
    800019fe:	bd4080e7          	jalr	-1068(ra) # 800015ce <sched>
  panic("zombie exit");
    80001a02:	00007517          	auipc	a0,0x7
    80001a06:	84e50513          	addi	a0,a0,-1970 # 80008250 <etext+0x250>
    80001a0a:	00004097          	auipc	ra,0x4
    80001a0e:	30e080e7          	jalr	782(ra) # 80005d18 <panic>

0000000080001a12 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a12:	7179                	addi	sp,sp,-48
    80001a14:	f406                	sd	ra,40(sp)
    80001a16:	f022                	sd	s0,32(sp)
    80001a18:	ec26                	sd	s1,24(sp)
    80001a1a:	e84a                	sd	s2,16(sp)
    80001a1c:	e44e                	sd	s3,8(sp)
    80001a1e:	1800                	addi	s0,sp,48
    80001a20:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a22:	00008497          	auipc	s1,0x8
    80001a26:	a5e48493          	addi	s1,s1,-1442 # 80009480 <proc>
    80001a2a:	0000d997          	auipc	s3,0xd
    80001a2e:	65698993          	addi	s3,s3,1622 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001a32:	8526                	mv	a0,s1
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	82e080e7          	jalr	-2002(ra) # 80006262 <acquire>
    if(p->pid == pid){
    80001a3c:	589c                	lw	a5,48(s1)
    80001a3e:	01278d63          	beq	a5,s2,80001a58 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a42:	8526                	mv	a0,s1
    80001a44:	00005097          	auipc	ra,0x5
    80001a48:	8d2080e7          	jalr	-1838(ra) # 80006316 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a4c:	17048493          	addi	s1,s1,368
    80001a50:	ff3491e3          	bne	s1,s3,80001a32 <kill+0x20>
  }
  return -1;
    80001a54:	557d                	li	a0,-1
    80001a56:	a829                	j	80001a70 <kill+0x5e>
      p->killed = 1;
    80001a58:	4785                	li	a5,1
    80001a5a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a5c:	4c98                	lw	a4,24(s1)
    80001a5e:	4789                	li	a5,2
    80001a60:	00f70f63          	beq	a4,a5,80001a7e <kill+0x6c>
      release(&p->lock);
    80001a64:	8526                	mv	a0,s1
    80001a66:	00005097          	auipc	ra,0x5
    80001a6a:	8b0080e7          	jalr	-1872(ra) # 80006316 <release>
      return 0;
    80001a6e:	4501                	li	a0,0
}
    80001a70:	70a2                	ld	ra,40(sp)
    80001a72:	7402                	ld	s0,32(sp)
    80001a74:	64e2                	ld	s1,24(sp)
    80001a76:	6942                	ld	s2,16(sp)
    80001a78:	69a2                	ld	s3,8(sp)
    80001a7a:	6145                	addi	sp,sp,48
    80001a7c:	8082                	ret
        p->state = RUNNABLE;
    80001a7e:	478d                	li	a5,3
    80001a80:	cc9c                	sw	a5,24(s1)
    80001a82:	b7cd                	j	80001a64 <kill+0x52>

0000000080001a84 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a84:	7179                	addi	sp,sp,-48
    80001a86:	f406                	sd	ra,40(sp)
    80001a88:	f022                	sd	s0,32(sp)
    80001a8a:	ec26                	sd	s1,24(sp)
    80001a8c:	e84a                	sd	s2,16(sp)
    80001a8e:	e44e                	sd	s3,8(sp)
    80001a90:	e052                	sd	s4,0(sp)
    80001a92:	1800                	addi	s0,sp,48
    80001a94:	84aa                	mv	s1,a0
    80001a96:	892e                	mv	s2,a1
    80001a98:	89b2                	mv	s3,a2
    80001a9a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	4d8080e7          	jalr	1240(ra) # 80000f74 <myproc>
  if(user_dst){
    80001aa4:	c08d                	beqz	s1,80001ac6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001aa6:	86d2                	mv	a3,s4
    80001aa8:	864e                	mv	a2,s3
    80001aaa:	85ca                	mv	a1,s2
    80001aac:	6928                	ld	a0,80(a0)
    80001aae:	fffff097          	auipc	ra,0xfffff
    80001ab2:	05c080e7          	jalr	92(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ab6:	70a2                	ld	ra,40(sp)
    80001ab8:	7402                	ld	s0,32(sp)
    80001aba:	64e2                	ld	s1,24(sp)
    80001abc:	6942                	ld	s2,16(sp)
    80001abe:	69a2                	ld	s3,8(sp)
    80001ac0:	6a02                	ld	s4,0(sp)
    80001ac2:	6145                	addi	sp,sp,48
    80001ac4:	8082                	ret
    memmove((char *)dst, src, len);
    80001ac6:	000a061b          	sext.w	a2,s4
    80001aca:	85ce                	mv	a1,s3
    80001acc:	854a                	mv	a0,s2
    80001ace:	ffffe097          	auipc	ra,0xffffe
    80001ad2:	70a080e7          	jalr	1802(ra) # 800001d8 <memmove>
    return 0;
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	bff9                	j	80001ab6 <either_copyout+0x32>

0000000080001ada <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ada:	7179                	addi	sp,sp,-48
    80001adc:	f406                	sd	ra,40(sp)
    80001ade:	f022                	sd	s0,32(sp)
    80001ae0:	ec26                	sd	s1,24(sp)
    80001ae2:	e84a                	sd	s2,16(sp)
    80001ae4:	e44e                	sd	s3,8(sp)
    80001ae6:	e052                	sd	s4,0(sp)
    80001ae8:	1800                	addi	s0,sp,48
    80001aea:	892a                	mv	s2,a0
    80001aec:	84ae                	mv	s1,a1
    80001aee:	89b2                	mv	s3,a2
    80001af0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	482080e7          	jalr	1154(ra) # 80000f74 <myproc>
  if(user_src){
    80001afa:	c08d                	beqz	s1,80001b1c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001afc:	86d2                	mv	a3,s4
    80001afe:	864e                	mv	a2,s3
    80001b00:	85ca                	mv	a1,s2
    80001b02:	6928                	ld	a0,80(a0)
    80001b04:	fffff097          	auipc	ra,0xfffff
    80001b08:	092080e7          	jalr	146(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b0c:	70a2                	ld	ra,40(sp)
    80001b0e:	7402                	ld	s0,32(sp)
    80001b10:	64e2                	ld	s1,24(sp)
    80001b12:	6942                	ld	s2,16(sp)
    80001b14:	69a2                	ld	s3,8(sp)
    80001b16:	6a02                	ld	s4,0(sp)
    80001b18:	6145                	addi	sp,sp,48
    80001b1a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b1c:	000a061b          	sext.w	a2,s4
    80001b20:	85ce                	mv	a1,s3
    80001b22:	854a                	mv	a0,s2
    80001b24:	ffffe097          	auipc	ra,0xffffe
    80001b28:	6b4080e7          	jalr	1716(ra) # 800001d8 <memmove>
    return 0;
    80001b2c:	8526                	mv	a0,s1
    80001b2e:	bff9                	j	80001b0c <either_copyin+0x32>

0000000080001b30 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b30:	715d                	addi	sp,sp,-80
    80001b32:	e486                	sd	ra,72(sp)
    80001b34:	e0a2                	sd	s0,64(sp)
    80001b36:	fc26                	sd	s1,56(sp)
    80001b38:	f84a                	sd	s2,48(sp)
    80001b3a:	f44e                	sd	s3,40(sp)
    80001b3c:	f052                	sd	s4,32(sp)
    80001b3e:	ec56                	sd	s5,24(sp)
    80001b40:	e85a                	sd	s6,16(sp)
    80001b42:	e45e                	sd	s7,8(sp)
    80001b44:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b46:	00006517          	auipc	a0,0x6
    80001b4a:	50250513          	addi	a0,a0,1282 # 80008048 <etext+0x48>
    80001b4e:	00004097          	auipc	ra,0x4
    80001b52:	214080e7          	jalr	532(ra) # 80005d62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b56:	00008497          	auipc	s1,0x8
    80001b5a:	a8a48493          	addi	s1,s1,-1398 # 800095e0 <proc+0x160>
    80001b5e:	0000d917          	auipc	s2,0xd
    80001b62:	68290913          	addi	s2,s2,1666 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b66:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b68:	00006997          	auipc	s3,0x6
    80001b6c:	6f898993          	addi	s3,s3,1784 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80001b70:	00006a97          	auipc	s5,0x6
    80001b74:	6f8a8a93          	addi	s5,s5,1784 # 80008268 <etext+0x268>
    printf("\n");
    80001b78:	00006a17          	auipc	s4,0x6
    80001b7c:	4d0a0a13          	addi	s4,s4,1232 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b80:	00006b97          	auipc	s7,0x6
    80001b84:	720b8b93          	addi	s7,s7,1824 # 800082a0 <states.1718>
    80001b88:	a00d                	j	80001baa <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b8a:	ed06a583          	lw	a1,-304(a3)
    80001b8e:	8556                	mv	a0,s5
    80001b90:	00004097          	auipc	ra,0x4
    80001b94:	1d2080e7          	jalr	466(ra) # 80005d62 <printf>
    printf("\n");
    80001b98:	8552                	mv	a0,s4
    80001b9a:	00004097          	auipc	ra,0x4
    80001b9e:	1c8080e7          	jalr	456(ra) # 80005d62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba2:	17048493          	addi	s1,s1,368
    80001ba6:	03248163          	beq	s1,s2,80001bc8 <procdump+0x98>
    if(p->state == UNUSED)
    80001baa:	86a6                	mv	a3,s1
    80001bac:	eb84a783          	lw	a5,-328(s1)
    80001bb0:	dbed                	beqz	a5,80001ba2 <procdump+0x72>
      state = "???";
    80001bb2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb4:	fcfb6be3          	bltu	s6,a5,80001b8a <procdump+0x5a>
    80001bb8:	1782                	slli	a5,a5,0x20
    80001bba:	9381                	srli	a5,a5,0x20
    80001bbc:	078e                	slli	a5,a5,0x3
    80001bbe:	97de                	add	a5,a5,s7
    80001bc0:	6390                	ld	a2,0(a5)
    80001bc2:	f661                	bnez	a2,80001b8a <procdump+0x5a>
      state = "???";
    80001bc4:	864e                	mv	a2,s3
    80001bc6:	b7d1                	j	80001b8a <procdump+0x5a>
  }
}
    80001bc8:	60a6                	ld	ra,72(sp)
    80001bca:	6406                	ld	s0,64(sp)
    80001bcc:	74e2                	ld	s1,56(sp)
    80001bce:	7942                	ld	s2,48(sp)
    80001bd0:	79a2                	ld	s3,40(sp)
    80001bd2:	7a02                	ld	s4,32(sp)
    80001bd4:	6ae2                	ld	s5,24(sp)
    80001bd6:	6b42                	ld	s6,16(sp)
    80001bd8:	6ba2                	ld	s7,8(sp)
    80001bda:	6161                	addi	sp,sp,80
    80001bdc:	8082                	ret

0000000080001bde <swtch>:
    80001bde:	00153023          	sd	ra,0(a0)
    80001be2:	00253423          	sd	sp,8(a0)
    80001be6:	e900                	sd	s0,16(a0)
    80001be8:	ed04                	sd	s1,24(a0)
    80001bea:	03253023          	sd	s2,32(a0)
    80001bee:	03353423          	sd	s3,40(a0)
    80001bf2:	03453823          	sd	s4,48(a0)
    80001bf6:	03553c23          	sd	s5,56(a0)
    80001bfa:	05653023          	sd	s6,64(a0)
    80001bfe:	05753423          	sd	s7,72(a0)
    80001c02:	05853823          	sd	s8,80(a0)
    80001c06:	05953c23          	sd	s9,88(a0)
    80001c0a:	07a53023          	sd	s10,96(a0)
    80001c0e:	07b53423          	sd	s11,104(a0)
    80001c12:	0005b083          	ld	ra,0(a1)
    80001c16:	0085b103          	ld	sp,8(a1)
    80001c1a:	6980                	ld	s0,16(a1)
    80001c1c:	6d84                	ld	s1,24(a1)
    80001c1e:	0205b903          	ld	s2,32(a1)
    80001c22:	0285b983          	ld	s3,40(a1)
    80001c26:	0305ba03          	ld	s4,48(a1)
    80001c2a:	0385ba83          	ld	s5,56(a1)
    80001c2e:	0405bb03          	ld	s6,64(a1)
    80001c32:	0485bb83          	ld	s7,72(a1)
    80001c36:	0505bc03          	ld	s8,80(a1)
    80001c3a:	0585bc83          	ld	s9,88(a1)
    80001c3e:	0605bd03          	ld	s10,96(a1)
    80001c42:	0685bd83          	ld	s11,104(a1)
    80001c46:	8082                	ret

0000000080001c48 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c48:	1141                	addi	sp,sp,-16
    80001c4a:	e406                	sd	ra,8(sp)
    80001c4c:	e022                	sd	s0,0(sp)
    80001c4e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c50:	00006597          	auipc	a1,0x6
    80001c54:	68058593          	addi	a1,a1,1664 # 800082d0 <states.1718+0x30>
    80001c58:	0000d517          	auipc	a0,0xd
    80001c5c:	42850513          	addi	a0,a0,1064 # 8000f080 <tickslock>
    80001c60:	00004097          	auipc	ra,0x4
    80001c64:	572080e7          	jalr	1394(ra) # 800061d2 <initlock>
}
    80001c68:	60a2                	ld	ra,8(sp)
    80001c6a:	6402                	ld	s0,0(sp)
    80001c6c:	0141                	addi	sp,sp,16
    80001c6e:	8082                	ret

0000000080001c70 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c70:	1141                	addi	sp,sp,-16
    80001c72:	e422                	sd	s0,8(sp)
    80001c74:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c76:	00003797          	auipc	a5,0x3
    80001c7a:	4aa78793          	addi	a5,a5,1194 # 80005120 <kernelvec>
    80001c7e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c82:	6422                	ld	s0,8(sp)
    80001c84:	0141                	addi	sp,sp,16
    80001c86:	8082                	ret

0000000080001c88 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c88:	1141                	addi	sp,sp,-16
    80001c8a:	e406                	sd	ra,8(sp)
    80001c8c:	e022                	sd	s0,0(sp)
    80001c8e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	2e4080e7          	jalr	740(ra) # 80000f74 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c9c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c9e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ca2:	00005617          	auipc	a2,0x5
    80001ca6:	35e60613          	addi	a2,a2,862 # 80007000 <_trampoline>
    80001caa:	00005697          	auipc	a3,0x5
    80001cae:	35668693          	addi	a3,a3,854 # 80007000 <_trampoline>
    80001cb2:	8e91                	sub	a3,a3,a2
    80001cb4:	040007b7          	lui	a5,0x4000
    80001cb8:	17fd                	addi	a5,a5,-1
    80001cba:	07b2                	slli	a5,a5,0xc
    80001cbc:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cbe:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cc2:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cc4:	180026f3          	csrr	a3,satp
    80001cc8:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cca:	7138                	ld	a4,96(a0)
    80001ccc:	6134                	ld	a3,64(a0)
    80001cce:	6585                	lui	a1,0x1
    80001cd0:	96ae                	add	a3,a3,a1
    80001cd2:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cd4:	7138                	ld	a4,96(a0)
    80001cd6:	00000697          	auipc	a3,0x0
    80001cda:	13868693          	addi	a3,a3,312 # 80001e0e <usertrap>
    80001cde:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ce0:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ce2:	8692                	mv	a3,tp
    80001ce4:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce6:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cea:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cee:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cf6:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cf8:	6f18                	ld	a4,24(a4)
    80001cfa:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cfe:	692c                	ld	a1,80(a0)
    80001d00:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d02:	00005717          	auipc	a4,0x5
    80001d06:	38e70713          	addi	a4,a4,910 # 80007090 <userret>
    80001d0a:	8f11                	sub	a4,a4,a2
    80001d0c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d0e:	577d                	li	a4,-1
    80001d10:	177e                	slli	a4,a4,0x3f
    80001d12:	8dd9                	or	a1,a1,a4
    80001d14:	02000537          	lui	a0,0x2000
    80001d18:	157d                	addi	a0,a0,-1
    80001d1a:	0536                	slli	a0,a0,0xd
    80001d1c:	9782                	jalr	a5
}
    80001d1e:	60a2                	ld	ra,8(sp)
    80001d20:	6402                	ld	s0,0(sp)
    80001d22:	0141                	addi	sp,sp,16
    80001d24:	8082                	ret

0000000080001d26 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d26:	1101                	addi	sp,sp,-32
    80001d28:	ec06                	sd	ra,24(sp)
    80001d2a:	e822                	sd	s0,16(sp)
    80001d2c:	e426                	sd	s1,8(sp)
    80001d2e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d30:	0000d497          	auipc	s1,0xd
    80001d34:	35048493          	addi	s1,s1,848 # 8000f080 <tickslock>
    80001d38:	8526                	mv	a0,s1
    80001d3a:	00004097          	auipc	ra,0x4
    80001d3e:	528080e7          	jalr	1320(ra) # 80006262 <acquire>
  ticks++;
    80001d42:	00007517          	auipc	a0,0x7
    80001d46:	2d650513          	addi	a0,a0,726 # 80009018 <ticks>
    80001d4a:	411c                	lw	a5,0(a0)
    80001d4c:	2785                	addiw	a5,a5,1
    80001d4e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d50:	00000097          	auipc	ra,0x0
    80001d54:	b1c080e7          	jalr	-1252(ra) # 8000186c <wakeup>
  release(&tickslock);
    80001d58:	8526                	mv	a0,s1
    80001d5a:	00004097          	auipc	ra,0x4
    80001d5e:	5bc080e7          	jalr	1468(ra) # 80006316 <release>
}
    80001d62:	60e2                	ld	ra,24(sp)
    80001d64:	6442                	ld	s0,16(sp)
    80001d66:	64a2                	ld	s1,8(sp)
    80001d68:	6105                	addi	sp,sp,32
    80001d6a:	8082                	ret

0000000080001d6c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d6c:	1101                	addi	sp,sp,-32
    80001d6e:	ec06                	sd	ra,24(sp)
    80001d70:	e822                	sd	s0,16(sp)
    80001d72:	e426                	sd	s1,8(sp)
    80001d74:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d76:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d7a:	00074d63          	bltz	a4,80001d94 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d7e:	57fd                	li	a5,-1
    80001d80:	17fe                	slli	a5,a5,0x3f
    80001d82:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d84:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d86:	06f70363          	beq	a4,a5,80001dec <devintr+0x80>
  }
}
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6105                	addi	sp,sp,32
    80001d92:	8082                	ret
     (scause & 0xff) == 9){
    80001d94:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d98:	46a5                	li	a3,9
    80001d9a:	fed792e3          	bne	a5,a3,80001d7e <devintr+0x12>
    int irq = plic_claim();
    80001d9e:	00003097          	auipc	ra,0x3
    80001da2:	48a080e7          	jalr	1162(ra) # 80005228 <plic_claim>
    80001da6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001da8:	47a9                	li	a5,10
    80001daa:	02f50763          	beq	a0,a5,80001dd8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dae:	4785                	li	a5,1
    80001db0:	02f50963          	beq	a0,a5,80001de2 <devintr+0x76>
    return 1;
    80001db4:	4505                	li	a0,1
    } else if(irq){
    80001db6:	d8f1                	beqz	s1,80001d8a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001db8:	85a6                	mv	a1,s1
    80001dba:	00006517          	auipc	a0,0x6
    80001dbe:	51e50513          	addi	a0,a0,1310 # 800082d8 <states.1718+0x38>
    80001dc2:	00004097          	auipc	ra,0x4
    80001dc6:	fa0080e7          	jalr	-96(ra) # 80005d62 <printf>
      plic_complete(irq);
    80001dca:	8526                	mv	a0,s1
    80001dcc:	00003097          	auipc	ra,0x3
    80001dd0:	480080e7          	jalr	1152(ra) # 8000524c <plic_complete>
    return 1;
    80001dd4:	4505                	li	a0,1
    80001dd6:	bf55                	j	80001d8a <devintr+0x1e>
      uartintr();
    80001dd8:	00004097          	auipc	ra,0x4
    80001ddc:	3aa080e7          	jalr	938(ra) # 80006182 <uartintr>
    80001de0:	b7ed                	j	80001dca <devintr+0x5e>
      virtio_disk_intr();
    80001de2:	00004097          	auipc	ra,0x4
    80001de6:	94a080e7          	jalr	-1718(ra) # 8000572c <virtio_disk_intr>
    80001dea:	b7c5                	j	80001dca <devintr+0x5e>
    if(cpuid() == 0){
    80001dec:	fffff097          	auipc	ra,0xfffff
    80001df0:	15c080e7          	jalr	348(ra) # 80000f48 <cpuid>
    80001df4:	c901                	beqz	a0,80001e04 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001df6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dfa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dfc:	14479073          	csrw	sip,a5
    return 2;
    80001e00:	4509                	li	a0,2
    80001e02:	b761                	j	80001d8a <devintr+0x1e>
      clockintr();
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	f22080e7          	jalr	-222(ra) # 80001d26 <clockintr>
    80001e0c:	b7ed                	j	80001df6 <devintr+0x8a>

0000000080001e0e <usertrap>:
{
    80001e0e:	1101                	addi	sp,sp,-32
    80001e10:	ec06                	sd	ra,24(sp)
    80001e12:	e822                	sd	s0,16(sp)
    80001e14:	e426                	sd	s1,8(sp)
    80001e16:	e04a                	sd	s2,0(sp)
    80001e18:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e1e:	1007f793          	andi	a5,a5,256
    80001e22:	e3ad                	bnez	a5,80001e84 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e24:	00003797          	auipc	a5,0x3
    80001e28:	2fc78793          	addi	a5,a5,764 # 80005120 <kernelvec>
    80001e2c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	144080e7          	jalr	324(ra) # 80000f74 <myproc>
    80001e38:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e3a:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e3c:	14102773          	csrr	a4,sepc
    80001e40:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e42:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e46:	47a1                	li	a5,8
    80001e48:	04f71c63          	bne	a4,a5,80001ea0 <usertrap+0x92>
    if(p->killed)
    80001e4c:	551c                	lw	a5,40(a0)
    80001e4e:	e3b9                	bnez	a5,80001e94 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e50:	70b8                	ld	a4,96(s1)
    80001e52:	6f1c                	ld	a5,24(a4)
    80001e54:	0791                	addi	a5,a5,4
    80001e56:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e58:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e5c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e60:	10079073          	csrw	sstatus,a5
    syscall();
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	2e0080e7          	jalr	736(ra) # 80002144 <syscall>
  if(p->killed)
    80001e6c:	549c                	lw	a5,40(s1)
    80001e6e:	ebc1                	bnez	a5,80001efe <usertrap+0xf0>
  usertrapret();
    80001e70:	00000097          	auipc	ra,0x0
    80001e74:	e18080e7          	jalr	-488(ra) # 80001c88 <usertrapret>
}
    80001e78:	60e2                	ld	ra,24(sp)
    80001e7a:	6442                	ld	s0,16(sp)
    80001e7c:	64a2                	ld	s1,8(sp)
    80001e7e:	6902                	ld	s2,0(sp)
    80001e80:	6105                	addi	sp,sp,32
    80001e82:	8082                	ret
    panic("usertrap: not from user mode");
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	47450513          	addi	a0,a0,1140 # 800082f8 <states.1718+0x58>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	e8c080e7          	jalr	-372(ra) # 80005d18 <panic>
      exit(-1);
    80001e94:	557d                	li	a0,-1
    80001e96:	00000097          	auipc	ra,0x0
    80001e9a:	aa6080e7          	jalr	-1370(ra) # 8000193c <exit>
    80001e9e:	bf4d                	j	80001e50 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	ecc080e7          	jalr	-308(ra) # 80001d6c <devintr>
    80001ea8:	892a                	mv	s2,a0
    80001eaa:	c501                	beqz	a0,80001eb2 <usertrap+0xa4>
  if(p->killed)
    80001eac:	549c                	lw	a5,40(s1)
    80001eae:	c3a1                	beqz	a5,80001eee <usertrap+0xe0>
    80001eb0:	a815                	j	80001ee4 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eb2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001eb6:	5890                	lw	a2,48(s1)
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	46050513          	addi	a0,a0,1120 # 80008318 <states.1718+0x78>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	ea2080e7          	jalr	-350(ra) # 80005d62 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ecc:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ed0:	00006517          	auipc	a0,0x6
    80001ed4:	47850513          	addi	a0,a0,1144 # 80008348 <states.1718+0xa8>
    80001ed8:	00004097          	auipc	ra,0x4
    80001edc:	e8a080e7          	jalr	-374(ra) # 80005d62 <printf>
    p->killed = 1;
    80001ee0:	4785                	li	a5,1
    80001ee2:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ee4:	557d                	li	a0,-1
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	a56080e7          	jalr	-1450(ra) # 8000193c <exit>
  if(which_dev == 2)
    80001eee:	4789                	li	a5,2
    80001ef0:	f8f910e3          	bne	s2,a5,80001e70 <usertrap+0x62>
    yield();
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	7b0080e7          	jalr	1968(ra) # 800016a4 <yield>
    80001efc:	bf95                	j	80001e70 <usertrap+0x62>
  int which_dev = 0;
    80001efe:	4901                	li	s2,0
    80001f00:	b7d5                	j	80001ee4 <usertrap+0xd6>

0000000080001f02 <kerneltrap>:
{
    80001f02:	7179                	addi	sp,sp,-48
    80001f04:	f406                	sd	ra,40(sp)
    80001f06:	f022                	sd	s0,32(sp)
    80001f08:	ec26                	sd	s1,24(sp)
    80001f0a:	e84a                	sd	s2,16(sp)
    80001f0c:	e44e                	sd	s3,8(sp)
    80001f0e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f10:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f14:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f18:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f1c:	1004f793          	andi	a5,s1,256
    80001f20:	cb85                	beqz	a5,80001f50 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f22:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f26:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f28:	ef85                	bnez	a5,80001f60 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	e42080e7          	jalr	-446(ra) # 80001d6c <devintr>
    80001f32:	cd1d                	beqz	a0,80001f70 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f34:	4789                	li	a5,2
    80001f36:	06f50a63          	beq	a0,a5,80001faa <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f3a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f3e:	10049073          	csrw	sstatus,s1
}
    80001f42:	70a2                	ld	ra,40(sp)
    80001f44:	7402                	ld	s0,32(sp)
    80001f46:	64e2                	ld	s1,24(sp)
    80001f48:	6942                	ld	s2,16(sp)
    80001f4a:	69a2                	ld	s3,8(sp)
    80001f4c:	6145                	addi	sp,sp,48
    80001f4e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f50:	00006517          	auipc	a0,0x6
    80001f54:	41850513          	addi	a0,a0,1048 # 80008368 <states.1718+0xc8>
    80001f58:	00004097          	auipc	ra,0x4
    80001f5c:	dc0080e7          	jalr	-576(ra) # 80005d18 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f60:	00006517          	auipc	a0,0x6
    80001f64:	43050513          	addi	a0,a0,1072 # 80008390 <states.1718+0xf0>
    80001f68:	00004097          	auipc	ra,0x4
    80001f6c:	db0080e7          	jalr	-592(ra) # 80005d18 <panic>
    printf("scause %p\n", scause);
    80001f70:	85ce                	mv	a1,s3
    80001f72:	00006517          	auipc	a0,0x6
    80001f76:	43e50513          	addi	a0,a0,1086 # 800083b0 <states.1718+0x110>
    80001f7a:	00004097          	auipc	ra,0x4
    80001f7e:	de8080e7          	jalr	-536(ra) # 80005d62 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f82:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f86:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f8a:	00006517          	auipc	a0,0x6
    80001f8e:	43650513          	addi	a0,a0,1078 # 800083c0 <states.1718+0x120>
    80001f92:	00004097          	auipc	ra,0x4
    80001f96:	dd0080e7          	jalr	-560(ra) # 80005d62 <printf>
    panic("kerneltrap");
    80001f9a:	00006517          	auipc	a0,0x6
    80001f9e:	43e50513          	addi	a0,a0,1086 # 800083d8 <states.1718+0x138>
    80001fa2:	00004097          	auipc	ra,0x4
    80001fa6:	d76080e7          	jalr	-650(ra) # 80005d18 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	fca080e7          	jalr	-54(ra) # 80000f74 <myproc>
    80001fb2:	d541                	beqz	a0,80001f3a <kerneltrap+0x38>
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	fc0080e7          	jalr	-64(ra) # 80000f74 <myproc>
    80001fbc:	4d18                	lw	a4,24(a0)
    80001fbe:	4791                	li	a5,4
    80001fc0:	f6f71de3          	bne	a4,a5,80001f3a <kerneltrap+0x38>
    yield();
    80001fc4:	fffff097          	auipc	ra,0xfffff
    80001fc8:	6e0080e7          	jalr	1760(ra) # 800016a4 <yield>
    80001fcc:	b7bd                	j	80001f3a <kerneltrap+0x38>

0000000080001fce <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fce:	1101                	addi	sp,sp,-32
    80001fd0:	ec06                	sd	ra,24(sp)
    80001fd2:	e822                	sd	s0,16(sp)
    80001fd4:	e426                	sd	s1,8(sp)
    80001fd6:	1000                	addi	s0,sp,32
    80001fd8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	f9a080e7          	jalr	-102(ra) # 80000f74 <myproc>
  switch (n) {
    80001fe2:	4795                	li	a5,5
    80001fe4:	0497e163          	bltu	a5,s1,80002026 <argraw+0x58>
    80001fe8:	048a                	slli	s1,s1,0x2
    80001fea:	00006717          	auipc	a4,0x6
    80001fee:	42670713          	addi	a4,a4,1062 # 80008410 <states.1718+0x170>
    80001ff2:	94ba                	add	s1,s1,a4
    80001ff4:	409c                	lw	a5,0(s1)
    80001ff6:	97ba                	add	a5,a5,a4
    80001ff8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ffa:	713c                	ld	a5,96(a0)
    80001ffc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ffe:	60e2                	ld	ra,24(sp)
    80002000:	6442                	ld	s0,16(sp)
    80002002:	64a2                	ld	s1,8(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret
    return p->trapframe->a1;
    80002008:	713c                	ld	a5,96(a0)
    8000200a:	7fa8                	ld	a0,120(a5)
    8000200c:	bfcd                	j	80001ffe <argraw+0x30>
    return p->trapframe->a2;
    8000200e:	713c                	ld	a5,96(a0)
    80002010:	63c8                	ld	a0,128(a5)
    80002012:	b7f5                	j	80001ffe <argraw+0x30>
    return p->trapframe->a3;
    80002014:	713c                	ld	a5,96(a0)
    80002016:	67c8                	ld	a0,136(a5)
    80002018:	b7dd                	j	80001ffe <argraw+0x30>
    return p->trapframe->a4;
    8000201a:	713c                	ld	a5,96(a0)
    8000201c:	6bc8                	ld	a0,144(a5)
    8000201e:	b7c5                	j	80001ffe <argraw+0x30>
    return p->trapframe->a5;
    80002020:	713c                	ld	a5,96(a0)
    80002022:	6fc8                	ld	a0,152(a5)
    80002024:	bfe9                	j	80001ffe <argraw+0x30>
  panic("argraw");
    80002026:	00006517          	auipc	a0,0x6
    8000202a:	3c250513          	addi	a0,a0,962 # 800083e8 <states.1718+0x148>
    8000202e:	00004097          	auipc	ra,0x4
    80002032:	cea080e7          	jalr	-790(ra) # 80005d18 <panic>

0000000080002036 <fetchaddr>:
{
    80002036:	1101                	addi	sp,sp,-32
    80002038:	ec06                	sd	ra,24(sp)
    8000203a:	e822                	sd	s0,16(sp)
    8000203c:	e426                	sd	s1,8(sp)
    8000203e:	e04a                	sd	s2,0(sp)
    80002040:	1000                	addi	s0,sp,32
    80002042:	84aa                	mv	s1,a0
    80002044:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	f2e080e7          	jalr	-210(ra) # 80000f74 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000204e:	653c                	ld	a5,72(a0)
    80002050:	02f4f863          	bgeu	s1,a5,80002080 <fetchaddr+0x4a>
    80002054:	00848713          	addi	a4,s1,8
    80002058:	02e7e663          	bltu	a5,a4,80002084 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000205c:	46a1                	li	a3,8
    8000205e:	8626                	mv	a2,s1
    80002060:	85ca                	mv	a1,s2
    80002062:	6928                	ld	a0,80(a0)
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	b32080e7          	jalr	-1230(ra) # 80000b96 <copyin>
    8000206c:	00a03533          	snez	a0,a0
    80002070:	40a00533          	neg	a0,a0
}
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	64a2                	ld	s1,8(sp)
    8000207a:	6902                	ld	s2,0(sp)
    8000207c:	6105                	addi	sp,sp,32
    8000207e:	8082                	ret
    return -1;
    80002080:	557d                	li	a0,-1
    80002082:	bfcd                	j	80002074 <fetchaddr+0x3e>
    80002084:	557d                	li	a0,-1
    80002086:	b7fd                	j	80002074 <fetchaddr+0x3e>

0000000080002088 <fetchstr>:
{
    80002088:	7179                	addi	sp,sp,-48
    8000208a:	f406                	sd	ra,40(sp)
    8000208c:	f022                	sd	s0,32(sp)
    8000208e:	ec26                	sd	s1,24(sp)
    80002090:	e84a                	sd	s2,16(sp)
    80002092:	e44e                	sd	s3,8(sp)
    80002094:	1800                	addi	s0,sp,48
    80002096:	892a                	mv	s2,a0
    80002098:	84ae                	mv	s1,a1
    8000209a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	ed8080e7          	jalr	-296(ra) # 80000f74 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020a4:	86ce                	mv	a3,s3
    800020a6:	864a                	mv	a2,s2
    800020a8:	85a6                	mv	a1,s1
    800020aa:	6928                	ld	a0,80(a0)
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	b76080e7          	jalr	-1162(ra) # 80000c22 <copyinstr>
  if(err < 0)
    800020b4:	00054763          	bltz	a0,800020c2 <fetchstr+0x3a>
  return strlen(buf);
    800020b8:	8526                	mv	a0,s1
    800020ba:	ffffe097          	auipc	ra,0xffffe
    800020be:	242080e7          	jalr	578(ra) # 800002fc <strlen>
}
    800020c2:	70a2                	ld	ra,40(sp)
    800020c4:	7402                	ld	s0,32(sp)
    800020c6:	64e2                	ld	s1,24(sp)
    800020c8:	6942                	ld	s2,16(sp)
    800020ca:	69a2                	ld	s3,8(sp)
    800020cc:	6145                	addi	sp,sp,48
    800020ce:	8082                	ret

00000000800020d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	ef2080e7          	jalr	-270(ra) # 80001fce <argraw>
    800020e4:	c088                	sw	a0,0(s1)
  return 0;
}
    800020e6:	4501                	li	a0,0
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	1000                	addi	s0,sp,32
    800020fc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	ed0080e7          	jalr	-304(ra) # 80001fce <argraw>
    80002106:	e088                	sd	a0,0(s1)
  return 0;
}
    80002108:	4501                	li	a0,0
    8000210a:	60e2                	ld	ra,24(sp)
    8000210c:	6442                	ld	s0,16(sp)
    8000210e:	64a2                	ld	s1,8(sp)
    80002110:	6105                	addi	sp,sp,32
    80002112:	8082                	ret

0000000080002114 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	e426                	sd	s1,8(sp)
    8000211c:	e04a                	sd	s2,0(sp)
    8000211e:	1000                	addi	s0,sp,32
    80002120:	84ae                	mv	s1,a1
    80002122:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002124:	00000097          	auipc	ra,0x0
    80002128:	eaa080e7          	jalr	-342(ra) # 80001fce <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000212c:	864a                	mv	a2,s2
    8000212e:	85a6                	mv	a1,s1
    80002130:	00000097          	auipc	ra,0x0
    80002134:	f58080e7          	jalr	-168(ra) # 80002088 <fetchstr>
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6902                	ld	s2,0(sp)
    80002140:	6105                	addi	sp,sp,32
    80002142:	8082                	ret

0000000080002144 <syscall>:



void
syscall(void)
{
    80002144:	1101                	addi	sp,sp,-32
    80002146:	ec06                	sd	ra,24(sp)
    80002148:	e822                	sd	s0,16(sp)
    8000214a:	e426                	sd	s1,8(sp)
    8000214c:	e04a                	sd	s2,0(sp)
    8000214e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	e24080e7          	jalr	-476(ra) # 80000f74 <myproc>
    80002158:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000215a:	06053903          	ld	s2,96(a0)
    8000215e:	0a893783          	ld	a5,168(s2)
    80002162:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002166:	37fd                	addiw	a5,a5,-1
    80002168:	4775                	li	a4,29
    8000216a:	00f76f63          	bltu	a4,a5,80002188 <syscall+0x44>
    8000216e:	00369713          	slli	a4,a3,0x3
    80002172:	00006797          	auipc	a5,0x6
    80002176:	2b678793          	addi	a5,a5,694 # 80008428 <syscalls>
    8000217a:	97ba                	add	a5,a5,a4
    8000217c:	639c                	ld	a5,0(a5)
    8000217e:	c789                	beqz	a5,80002188 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002180:	9782                	jalr	a5
    80002182:	06a93823          	sd	a0,112(s2)
    80002186:	a839                	j	800021a4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002188:	16048613          	addi	a2,s1,352
    8000218c:	588c                	lw	a1,48(s1)
    8000218e:	00006517          	auipc	a0,0x6
    80002192:	26250513          	addi	a0,a0,610 # 800083f0 <states.1718+0x150>
    80002196:	00004097          	auipc	ra,0x4
    8000219a:	bcc080e7          	jalr	-1076(ra) # 80005d62 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000219e:	70bc                	ld	a5,96(s1)
    800021a0:	577d                	li	a4,-1
    800021a2:	fbb8                	sd	a4,112(a5)
  }
}
    800021a4:	60e2                	ld	ra,24(sp)
    800021a6:	6442                	ld	s0,16(sp)
    800021a8:	64a2                	ld	s1,8(sp)
    800021aa:	6902                	ld	s2,0(sp)
    800021ac:	6105                	addi	sp,sp,32
    800021ae:	8082                	ret

00000000800021b0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021b0:	1101                	addi	sp,sp,-32
    800021b2:	ec06                	sd	ra,24(sp)
    800021b4:	e822                	sd	s0,16(sp)
    800021b6:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021b8:	fec40593          	addi	a1,s0,-20
    800021bc:	4501                	li	a0,0
    800021be:	00000097          	auipc	ra,0x0
    800021c2:	f12080e7          	jalr	-238(ra) # 800020d0 <argint>
    return -1;
    800021c6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021c8:	00054963          	bltz	a0,800021da <sys_exit+0x2a>
  exit(n);
    800021cc:	fec42503          	lw	a0,-20(s0)
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	76c080e7          	jalr	1900(ra) # 8000193c <exit>
  return 0;  // not reached
    800021d8:	4781                	li	a5,0
}
    800021da:	853e                	mv	a0,a5
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret

00000000800021e4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021e4:	1141                	addi	sp,sp,-16
    800021e6:	e406                	sd	ra,8(sp)
    800021e8:	e022                	sd	s0,0(sp)
    800021ea:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	d88080e7          	jalr	-632(ra) # 80000f74 <myproc>
}
    800021f4:	5908                	lw	a0,48(a0)
    800021f6:	60a2                	ld	ra,8(sp)
    800021f8:	6402                	ld	s0,0(sp)
    800021fa:	0141                	addi	sp,sp,16
    800021fc:	8082                	ret

00000000800021fe <sys_fork>:

uint64
sys_fork(void)
{
    800021fe:	1141                	addi	sp,sp,-16
    80002200:	e406                	sd	ra,8(sp)
    80002202:	e022                	sd	s0,0(sp)
    80002204:	0800                	addi	s0,sp,16
  return fork();
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	1ec080e7          	jalr	492(ra) # 800013f2 <fork>
}
    8000220e:	60a2                	ld	ra,8(sp)
    80002210:	6402                	ld	s0,0(sp)
    80002212:	0141                	addi	sp,sp,16
    80002214:	8082                	ret

0000000080002216 <sys_wait>:

uint64
sys_wait(void)
{
    80002216:	1101                	addi	sp,sp,-32
    80002218:	ec06                	sd	ra,24(sp)
    8000221a:	e822                	sd	s0,16(sp)
    8000221c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000221e:	fe840593          	addi	a1,s0,-24
    80002222:	4501                	li	a0,0
    80002224:	00000097          	auipc	ra,0x0
    80002228:	ece080e7          	jalr	-306(ra) # 800020f2 <argaddr>
    8000222c:	87aa                	mv	a5,a0
    return -1;
    8000222e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002230:	0007c863          	bltz	a5,80002240 <sys_wait+0x2a>
  return wait(p);
    80002234:	fe843503          	ld	a0,-24(s0)
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	50c080e7          	jalr	1292(ra) # 80001744 <wait>
}
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002252:	fdc40593          	addi	a1,s0,-36
    80002256:	4501                	li	a0,0
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	e78080e7          	jalr	-392(ra) # 800020d0 <argint>
    80002260:	87aa                	mv	a5,a0
    return -1;
    80002262:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002264:	0207c063          	bltz	a5,80002284 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	d0c080e7          	jalr	-756(ra) # 80000f74 <myproc>
    80002270:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002272:	fdc42503          	lw	a0,-36(s0)
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	108080e7          	jalr	264(ra) # 8000137e <growproc>
    8000227e:	00054863          	bltz	a0,8000228e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002282:	8526                	mv	a0,s1
}
    80002284:	70a2                	ld	ra,40(sp)
    80002286:	7402                	ld	s0,32(sp)
    80002288:	64e2                	ld	s1,24(sp)
    8000228a:	6145                	addi	sp,sp,48
    8000228c:	8082                	ret
    return -1;
    8000228e:	557d                	li	a0,-1
    80002290:	bfd5                	j	80002284 <sys_sbrk+0x3c>

0000000080002292 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002292:	7139                	addi	sp,sp,-64
    80002294:	fc06                	sd	ra,56(sp)
    80002296:	f822                	sd	s0,48(sp)
    80002298:	f426                	sd	s1,40(sp)
    8000229a:	f04a                	sd	s2,32(sp)
    8000229c:	ec4e                	sd	s3,24(sp)
    8000229e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    800022a0:	fcc40593          	addi	a1,s0,-52
    800022a4:	4501                	li	a0,0
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	e2a080e7          	jalr	-470(ra) # 800020d0 <argint>
    return -1;
    800022ae:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022b0:	06054563          	bltz	a0,8000231a <sys_sleep+0x88>
  acquire(&tickslock);
    800022b4:	0000d517          	auipc	a0,0xd
    800022b8:	dcc50513          	addi	a0,a0,-564 # 8000f080 <tickslock>
    800022bc:	00004097          	auipc	ra,0x4
    800022c0:	fa6080e7          	jalr	-90(ra) # 80006262 <acquire>
  ticks0 = ticks;
    800022c4:	00007917          	auipc	s2,0x7
    800022c8:	d5492903          	lw	s2,-684(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022cc:	fcc42783          	lw	a5,-52(s0)
    800022d0:	cf85                	beqz	a5,80002308 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022d2:	0000d997          	auipc	s3,0xd
    800022d6:	dae98993          	addi	s3,s3,-594 # 8000f080 <tickslock>
    800022da:	00007497          	auipc	s1,0x7
    800022de:	d3e48493          	addi	s1,s1,-706 # 80009018 <ticks>
    if(myproc()->killed){
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	c92080e7          	jalr	-878(ra) # 80000f74 <myproc>
    800022ea:	551c                	lw	a5,40(a0)
    800022ec:	ef9d                	bnez	a5,8000232a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022ee:	85ce                	mv	a1,s3
    800022f0:	8526                	mv	a0,s1
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	3ee080e7          	jalr	1006(ra) # 800016e0 <sleep>
  while(ticks - ticks0 < n){
    800022fa:	409c                	lw	a5,0(s1)
    800022fc:	412787bb          	subw	a5,a5,s2
    80002300:	fcc42703          	lw	a4,-52(s0)
    80002304:	fce7efe3          	bltu	a5,a4,800022e2 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002308:	0000d517          	auipc	a0,0xd
    8000230c:	d7850513          	addi	a0,a0,-648 # 8000f080 <tickslock>
    80002310:	00004097          	auipc	ra,0x4
    80002314:	006080e7          	jalr	6(ra) # 80006316 <release>
  return 0;
    80002318:	4781                	li	a5,0
}
    8000231a:	853e                	mv	a0,a5
    8000231c:	70e2                	ld	ra,56(sp)
    8000231e:	7442                	ld	s0,48(sp)
    80002320:	74a2                	ld	s1,40(sp)
    80002322:	7902                	ld	s2,32(sp)
    80002324:	69e2                	ld	s3,24(sp)
    80002326:	6121                	addi	sp,sp,64
    80002328:	8082                	ret
      release(&tickslock);
    8000232a:	0000d517          	auipc	a0,0xd
    8000232e:	d5650513          	addi	a0,a0,-682 # 8000f080 <tickslock>
    80002332:	00004097          	auipc	ra,0x4
    80002336:	fe4080e7          	jalr	-28(ra) # 80006316 <release>
      return -1;
    8000233a:	57fd                	li	a5,-1
    8000233c:	bff9                	j	8000231a <sys_sleep+0x88>

000000008000233e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000233e:	1141                	addi	sp,sp,-16
    80002340:	e422                	sd	s0,8(sp)
    80002342:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002344:	4501                	li	a0,0
    80002346:	6422                	ld	s0,8(sp)
    80002348:	0141                	addi	sp,sp,16
    8000234a:	8082                	ret

000000008000234c <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000234c:	1101                	addi	sp,sp,-32
    8000234e:	ec06                	sd	ra,24(sp)
    80002350:	e822                	sd	s0,16(sp)
    80002352:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002354:	fec40593          	addi	a1,s0,-20
    80002358:	4501                	li	a0,0
    8000235a:	00000097          	auipc	ra,0x0
    8000235e:	d76080e7          	jalr	-650(ra) # 800020d0 <argint>
    80002362:	87aa                	mv	a5,a0
    return -1;
    80002364:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002366:	0007c863          	bltz	a5,80002376 <sys_kill+0x2a>
  return kill(pid);
    8000236a:	fec42503          	lw	a0,-20(s0)
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	6a4080e7          	jalr	1700(ra) # 80001a12 <kill>
}
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	6105                	addi	sp,sp,32
    8000237c:	8082                	ret

000000008000237e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000237e:	1101                	addi	sp,sp,-32
    80002380:	ec06                	sd	ra,24(sp)
    80002382:	e822                	sd	s0,16(sp)
    80002384:	e426                	sd	s1,8(sp)
    80002386:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002388:	0000d517          	auipc	a0,0xd
    8000238c:	cf850513          	addi	a0,a0,-776 # 8000f080 <tickslock>
    80002390:	00004097          	auipc	ra,0x4
    80002394:	ed2080e7          	jalr	-302(ra) # 80006262 <acquire>
  xticks = ticks;
    80002398:	00007497          	auipc	s1,0x7
    8000239c:	c804a483          	lw	s1,-896(s1) # 80009018 <ticks>
  release(&tickslock);
    800023a0:	0000d517          	auipc	a0,0xd
    800023a4:	ce050513          	addi	a0,a0,-800 # 8000f080 <tickslock>
    800023a8:	00004097          	auipc	ra,0x4
    800023ac:	f6e080e7          	jalr	-146(ra) # 80006316 <release>
  return xticks;
}
    800023b0:	02049513          	slli	a0,s1,0x20
    800023b4:	9101                	srli	a0,a0,0x20
    800023b6:	60e2                	ld	ra,24(sp)
    800023b8:	6442                	ld	s0,16(sp)
    800023ba:	64a2                	ld	s1,8(sp)
    800023bc:	6105                	addi	sp,sp,32
    800023be:	8082                	ret

00000000800023c0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023c0:	7179                	addi	sp,sp,-48
    800023c2:	f406                	sd	ra,40(sp)
    800023c4:	f022                	sd	s0,32(sp)
    800023c6:	ec26                	sd	s1,24(sp)
    800023c8:	e84a                	sd	s2,16(sp)
    800023ca:	e44e                	sd	s3,8(sp)
    800023cc:	e052                	sd	s4,0(sp)
    800023ce:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023d0:	00006597          	auipc	a1,0x6
    800023d4:	15058593          	addi	a1,a1,336 # 80008520 <syscalls+0xf8>
    800023d8:	0000d517          	auipc	a0,0xd
    800023dc:	cc050513          	addi	a0,a0,-832 # 8000f098 <bcache>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	df2080e7          	jalr	-526(ra) # 800061d2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023e8:	00015797          	auipc	a5,0x15
    800023ec:	cb078793          	addi	a5,a5,-848 # 80017098 <bcache+0x8000>
    800023f0:	00015717          	auipc	a4,0x15
    800023f4:	f1070713          	addi	a4,a4,-240 # 80017300 <bcache+0x8268>
    800023f8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023fc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002400:	0000d497          	auipc	s1,0xd
    80002404:	cb048493          	addi	s1,s1,-848 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002408:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000240a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000240c:	00006a17          	auipc	s4,0x6
    80002410:	11ca0a13          	addi	s4,s4,284 # 80008528 <syscalls+0x100>
    b->next = bcache.head.next;
    80002414:	2b893783          	ld	a5,696(s2)
    80002418:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000241a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000241e:	85d2                	mv	a1,s4
    80002420:	01048513          	addi	a0,s1,16
    80002424:	00001097          	auipc	ra,0x1
    80002428:	4bc080e7          	jalr	1212(ra) # 800038e0 <initsleeplock>
    bcache.head.next->prev = b;
    8000242c:	2b893783          	ld	a5,696(s2)
    80002430:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002432:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002436:	45848493          	addi	s1,s1,1112
    8000243a:	fd349de3          	bne	s1,s3,80002414 <binit+0x54>
  }
}
    8000243e:	70a2                	ld	ra,40(sp)
    80002440:	7402                	ld	s0,32(sp)
    80002442:	64e2                	ld	s1,24(sp)
    80002444:	6942                	ld	s2,16(sp)
    80002446:	69a2                	ld	s3,8(sp)
    80002448:	6a02                	ld	s4,0(sp)
    8000244a:	6145                	addi	sp,sp,48
    8000244c:	8082                	ret

000000008000244e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000244e:	7179                	addi	sp,sp,-48
    80002450:	f406                	sd	ra,40(sp)
    80002452:	f022                	sd	s0,32(sp)
    80002454:	ec26                	sd	s1,24(sp)
    80002456:	e84a                	sd	s2,16(sp)
    80002458:	e44e                	sd	s3,8(sp)
    8000245a:	1800                	addi	s0,sp,48
    8000245c:	89aa                	mv	s3,a0
    8000245e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002460:	0000d517          	auipc	a0,0xd
    80002464:	c3850513          	addi	a0,a0,-968 # 8000f098 <bcache>
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	dfa080e7          	jalr	-518(ra) # 80006262 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002470:	00015497          	auipc	s1,0x15
    80002474:	ee04b483          	ld	s1,-288(s1) # 80017350 <bcache+0x82b8>
    80002478:	00015797          	auipc	a5,0x15
    8000247c:	e8878793          	addi	a5,a5,-376 # 80017300 <bcache+0x8268>
    80002480:	02f48f63          	beq	s1,a5,800024be <bread+0x70>
    80002484:	873e                	mv	a4,a5
    80002486:	a021                	j	8000248e <bread+0x40>
    80002488:	68a4                	ld	s1,80(s1)
    8000248a:	02e48a63          	beq	s1,a4,800024be <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000248e:	449c                	lw	a5,8(s1)
    80002490:	ff379ce3          	bne	a5,s3,80002488 <bread+0x3a>
    80002494:	44dc                	lw	a5,12(s1)
    80002496:	ff2799e3          	bne	a5,s2,80002488 <bread+0x3a>
      b->refcnt++;
    8000249a:	40bc                	lw	a5,64(s1)
    8000249c:	2785                	addiw	a5,a5,1
    8000249e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024a0:	0000d517          	auipc	a0,0xd
    800024a4:	bf850513          	addi	a0,a0,-1032 # 8000f098 <bcache>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	e6e080e7          	jalr	-402(ra) # 80006316 <release>
      acquiresleep(&b->lock);
    800024b0:	01048513          	addi	a0,s1,16
    800024b4:	00001097          	auipc	ra,0x1
    800024b8:	466080e7          	jalr	1126(ra) # 8000391a <acquiresleep>
      return b;
    800024bc:	a8b9                	j	8000251a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024be:	00015497          	auipc	s1,0x15
    800024c2:	e8a4b483          	ld	s1,-374(s1) # 80017348 <bcache+0x82b0>
    800024c6:	00015797          	auipc	a5,0x15
    800024ca:	e3a78793          	addi	a5,a5,-454 # 80017300 <bcache+0x8268>
    800024ce:	00f48863          	beq	s1,a5,800024de <bread+0x90>
    800024d2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024d4:	40bc                	lw	a5,64(s1)
    800024d6:	cf81                	beqz	a5,800024ee <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d8:	64a4                	ld	s1,72(s1)
    800024da:	fee49de3          	bne	s1,a4,800024d4 <bread+0x86>
  panic("bget: no buffers");
    800024de:	00006517          	auipc	a0,0x6
    800024e2:	05250513          	addi	a0,a0,82 # 80008530 <syscalls+0x108>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	832080e7          	jalr	-1998(ra) # 80005d18 <panic>
      b->dev = dev;
    800024ee:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024f2:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024f6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024fa:	4785                	li	a5,1
    800024fc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024fe:	0000d517          	auipc	a0,0xd
    80002502:	b9a50513          	addi	a0,a0,-1126 # 8000f098 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	e10080e7          	jalr	-496(ra) # 80006316 <release>
      acquiresleep(&b->lock);
    8000250e:	01048513          	addi	a0,s1,16
    80002512:	00001097          	auipc	ra,0x1
    80002516:	408080e7          	jalr	1032(ra) # 8000391a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000251a:	409c                	lw	a5,0(s1)
    8000251c:	cb89                	beqz	a5,8000252e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000251e:	8526                	mv	a0,s1
    80002520:	70a2                	ld	ra,40(sp)
    80002522:	7402                	ld	s0,32(sp)
    80002524:	64e2                	ld	s1,24(sp)
    80002526:	6942                	ld	s2,16(sp)
    80002528:	69a2                	ld	s3,8(sp)
    8000252a:	6145                	addi	sp,sp,48
    8000252c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000252e:	4581                	li	a1,0
    80002530:	8526                	mv	a0,s1
    80002532:	00003097          	auipc	ra,0x3
    80002536:	f24080e7          	jalr	-220(ra) # 80005456 <virtio_disk_rw>
    b->valid = 1;
    8000253a:	4785                	li	a5,1
    8000253c:	c09c                	sw	a5,0(s1)
  return b;
    8000253e:	b7c5                	j	8000251e <bread+0xd0>

0000000080002540 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002540:	1101                	addi	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	1000                	addi	s0,sp,32
    8000254a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000254c:	0541                	addi	a0,a0,16
    8000254e:	00001097          	auipc	ra,0x1
    80002552:	466080e7          	jalr	1126(ra) # 800039b4 <holdingsleep>
    80002556:	cd01                	beqz	a0,8000256e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002558:	4585                	li	a1,1
    8000255a:	8526                	mv	a0,s1
    8000255c:	00003097          	auipc	ra,0x3
    80002560:	efa080e7          	jalr	-262(ra) # 80005456 <virtio_disk_rw>
}
    80002564:	60e2                	ld	ra,24(sp)
    80002566:	6442                	ld	s0,16(sp)
    80002568:	64a2                	ld	s1,8(sp)
    8000256a:	6105                	addi	sp,sp,32
    8000256c:	8082                	ret
    panic("bwrite");
    8000256e:	00006517          	auipc	a0,0x6
    80002572:	fda50513          	addi	a0,a0,-38 # 80008548 <syscalls+0x120>
    80002576:	00003097          	auipc	ra,0x3
    8000257a:	7a2080e7          	jalr	1954(ra) # 80005d18 <panic>

000000008000257e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000257e:	1101                	addi	sp,sp,-32
    80002580:	ec06                	sd	ra,24(sp)
    80002582:	e822                	sd	s0,16(sp)
    80002584:	e426                	sd	s1,8(sp)
    80002586:	e04a                	sd	s2,0(sp)
    80002588:	1000                	addi	s0,sp,32
    8000258a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000258c:	01050913          	addi	s2,a0,16
    80002590:	854a                	mv	a0,s2
    80002592:	00001097          	auipc	ra,0x1
    80002596:	422080e7          	jalr	1058(ra) # 800039b4 <holdingsleep>
    8000259a:	c92d                	beqz	a0,8000260c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000259c:	854a                	mv	a0,s2
    8000259e:	00001097          	auipc	ra,0x1
    800025a2:	3d2080e7          	jalr	978(ra) # 80003970 <releasesleep>

  acquire(&bcache.lock);
    800025a6:	0000d517          	auipc	a0,0xd
    800025aa:	af250513          	addi	a0,a0,-1294 # 8000f098 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	cb4080e7          	jalr	-844(ra) # 80006262 <acquire>
  b->refcnt--;
    800025b6:	40bc                	lw	a5,64(s1)
    800025b8:	37fd                	addiw	a5,a5,-1
    800025ba:	0007871b          	sext.w	a4,a5
    800025be:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025c0:	eb05                	bnez	a4,800025f0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025c2:	68bc                	ld	a5,80(s1)
    800025c4:	64b8                	ld	a4,72(s1)
    800025c6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025c8:	64bc                	ld	a5,72(s1)
    800025ca:	68b8                	ld	a4,80(s1)
    800025cc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025ce:	00015797          	auipc	a5,0x15
    800025d2:	aca78793          	addi	a5,a5,-1334 # 80017098 <bcache+0x8000>
    800025d6:	2b87b703          	ld	a4,696(a5)
    800025da:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025dc:	00015717          	auipc	a4,0x15
    800025e0:	d2470713          	addi	a4,a4,-732 # 80017300 <bcache+0x8268>
    800025e4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025e6:	2b87b703          	ld	a4,696(a5)
    800025ea:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025ec:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025f0:	0000d517          	auipc	a0,0xd
    800025f4:	aa850513          	addi	a0,a0,-1368 # 8000f098 <bcache>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	d1e080e7          	jalr	-738(ra) # 80006316 <release>
}
    80002600:	60e2                	ld	ra,24(sp)
    80002602:	6442                	ld	s0,16(sp)
    80002604:	64a2                	ld	s1,8(sp)
    80002606:	6902                	ld	s2,0(sp)
    80002608:	6105                	addi	sp,sp,32
    8000260a:	8082                	ret
    panic("brelse");
    8000260c:	00006517          	auipc	a0,0x6
    80002610:	f4450513          	addi	a0,a0,-188 # 80008550 <syscalls+0x128>
    80002614:	00003097          	auipc	ra,0x3
    80002618:	704080e7          	jalr	1796(ra) # 80005d18 <panic>

000000008000261c <bpin>:

void
bpin(struct buf *b) {
    8000261c:	1101                	addi	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	1000                	addi	s0,sp,32
    80002626:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002628:	0000d517          	auipc	a0,0xd
    8000262c:	a7050513          	addi	a0,a0,-1424 # 8000f098 <bcache>
    80002630:	00004097          	auipc	ra,0x4
    80002634:	c32080e7          	jalr	-974(ra) # 80006262 <acquire>
  b->refcnt++;
    80002638:	40bc                	lw	a5,64(s1)
    8000263a:	2785                	addiw	a5,a5,1
    8000263c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000263e:	0000d517          	auipc	a0,0xd
    80002642:	a5a50513          	addi	a0,a0,-1446 # 8000f098 <bcache>
    80002646:	00004097          	auipc	ra,0x4
    8000264a:	cd0080e7          	jalr	-816(ra) # 80006316 <release>
}
    8000264e:	60e2                	ld	ra,24(sp)
    80002650:	6442                	ld	s0,16(sp)
    80002652:	64a2                	ld	s1,8(sp)
    80002654:	6105                	addi	sp,sp,32
    80002656:	8082                	ret

0000000080002658 <bunpin>:

void
bunpin(struct buf *b) {
    80002658:	1101                	addi	sp,sp,-32
    8000265a:	ec06                	sd	ra,24(sp)
    8000265c:	e822                	sd	s0,16(sp)
    8000265e:	e426                	sd	s1,8(sp)
    80002660:	1000                	addi	s0,sp,32
    80002662:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002664:	0000d517          	auipc	a0,0xd
    80002668:	a3450513          	addi	a0,a0,-1484 # 8000f098 <bcache>
    8000266c:	00004097          	auipc	ra,0x4
    80002670:	bf6080e7          	jalr	-1034(ra) # 80006262 <acquire>
  b->refcnt--;
    80002674:	40bc                	lw	a5,64(s1)
    80002676:	37fd                	addiw	a5,a5,-1
    80002678:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000267a:	0000d517          	auipc	a0,0xd
    8000267e:	a1e50513          	addi	a0,a0,-1506 # 8000f098 <bcache>
    80002682:	00004097          	auipc	ra,0x4
    80002686:	c94080e7          	jalr	-876(ra) # 80006316 <release>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6105                	addi	sp,sp,32
    80002692:	8082                	ret

0000000080002694 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002694:	1101                	addi	sp,sp,-32
    80002696:	ec06                	sd	ra,24(sp)
    80002698:	e822                	sd	s0,16(sp)
    8000269a:	e426                	sd	s1,8(sp)
    8000269c:	e04a                	sd	s2,0(sp)
    8000269e:	1000                	addi	s0,sp,32
    800026a0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026a2:	00d5d59b          	srliw	a1,a1,0xd
    800026a6:	00015797          	auipc	a5,0x15
    800026aa:	0ce7a783          	lw	a5,206(a5) # 80017774 <sb+0x1c>
    800026ae:	9dbd                	addw	a1,a1,a5
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	d9e080e7          	jalr	-610(ra) # 8000244e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026b8:	0074f713          	andi	a4,s1,7
    800026bc:	4785                	li	a5,1
    800026be:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026c2:	14ce                	slli	s1,s1,0x33
    800026c4:	90d9                	srli	s1,s1,0x36
    800026c6:	00950733          	add	a4,a0,s1
    800026ca:	05874703          	lbu	a4,88(a4)
    800026ce:	00e7f6b3          	and	a3,a5,a4
    800026d2:	c69d                	beqz	a3,80002700 <bfree+0x6c>
    800026d4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026d6:	94aa                	add	s1,s1,a0
    800026d8:	fff7c793          	not	a5,a5
    800026dc:	8ff9                	and	a5,a5,a4
    800026de:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026e2:	00001097          	auipc	ra,0x1
    800026e6:	118080e7          	jalr	280(ra) # 800037fa <log_write>
  brelse(bp);
    800026ea:	854a                	mv	a0,s2
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	e92080e7          	jalr	-366(ra) # 8000257e <brelse>
}
    800026f4:	60e2                	ld	ra,24(sp)
    800026f6:	6442                	ld	s0,16(sp)
    800026f8:	64a2                	ld	s1,8(sp)
    800026fa:	6902                	ld	s2,0(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret
    panic("freeing free block");
    80002700:	00006517          	auipc	a0,0x6
    80002704:	e5850513          	addi	a0,a0,-424 # 80008558 <syscalls+0x130>
    80002708:	00003097          	auipc	ra,0x3
    8000270c:	610080e7          	jalr	1552(ra) # 80005d18 <panic>

0000000080002710 <balloc>:
{
    80002710:	711d                	addi	sp,sp,-96
    80002712:	ec86                	sd	ra,88(sp)
    80002714:	e8a2                	sd	s0,80(sp)
    80002716:	e4a6                	sd	s1,72(sp)
    80002718:	e0ca                	sd	s2,64(sp)
    8000271a:	fc4e                	sd	s3,56(sp)
    8000271c:	f852                	sd	s4,48(sp)
    8000271e:	f456                	sd	s5,40(sp)
    80002720:	f05a                	sd	s6,32(sp)
    80002722:	ec5e                	sd	s7,24(sp)
    80002724:	e862                	sd	s8,16(sp)
    80002726:	e466                	sd	s9,8(sp)
    80002728:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000272a:	00015797          	auipc	a5,0x15
    8000272e:	0327a783          	lw	a5,50(a5) # 8001775c <sb+0x4>
    80002732:	cbd1                	beqz	a5,800027c6 <balloc+0xb6>
    80002734:	8baa                	mv	s7,a0
    80002736:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002738:	00015b17          	auipc	s6,0x15
    8000273c:	020b0b13          	addi	s6,s6,32 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002740:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002742:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002744:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002746:	6c89                	lui	s9,0x2
    80002748:	a831                	j	80002764 <balloc+0x54>
    brelse(bp);
    8000274a:	854a                	mv	a0,s2
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	e32080e7          	jalr	-462(ra) # 8000257e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002754:	015c87bb          	addw	a5,s9,s5
    80002758:	00078a9b          	sext.w	s5,a5
    8000275c:	004b2703          	lw	a4,4(s6)
    80002760:	06eaf363          	bgeu	s5,a4,800027c6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002764:	41fad79b          	sraiw	a5,s5,0x1f
    80002768:	0137d79b          	srliw	a5,a5,0x13
    8000276c:	015787bb          	addw	a5,a5,s5
    80002770:	40d7d79b          	sraiw	a5,a5,0xd
    80002774:	01cb2583          	lw	a1,28(s6)
    80002778:	9dbd                	addw	a1,a1,a5
    8000277a:	855e                	mv	a0,s7
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	cd2080e7          	jalr	-814(ra) # 8000244e <bread>
    80002784:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002786:	004b2503          	lw	a0,4(s6)
    8000278a:	000a849b          	sext.w	s1,s5
    8000278e:	8662                	mv	a2,s8
    80002790:	faa4fde3          	bgeu	s1,a0,8000274a <balloc+0x3a>
      m = 1 << (bi % 8);
    80002794:	41f6579b          	sraiw	a5,a2,0x1f
    80002798:	01d7d69b          	srliw	a3,a5,0x1d
    8000279c:	00c6873b          	addw	a4,a3,a2
    800027a0:	00777793          	andi	a5,a4,7
    800027a4:	9f95                	subw	a5,a5,a3
    800027a6:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027aa:	4037571b          	sraiw	a4,a4,0x3
    800027ae:	00e906b3          	add	a3,s2,a4
    800027b2:	0586c683          	lbu	a3,88(a3)
    800027b6:	00d7f5b3          	and	a1,a5,a3
    800027ba:	cd91                	beqz	a1,800027d6 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027bc:	2605                	addiw	a2,a2,1
    800027be:	2485                	addiw	s1,s1,1
    800027c0:	fd4618e3          	bne	a2,s4,80002790 <balloc+0x80>
    800027c4:	b759                	j	8000274a <balloc+0x3a>
  panic("balloc: out of blocks");
    800027c6:	00006517          	auipc	a0,0x6
    800027ca:	daa50513          	addi	a0,a0,-598 # 80008570 <syscalls+0x148>
    800027ce:	00003097          	auipc	ra,0x3
    800027d2:	54a080e7          	jalr	1354(ra) # 80005d18 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027d6:	974a                	add	a4,a4,s2
    800027d8:	8fd5                	or	a5,a5,a3
    800027da:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800027de:	854a                	mv	a0,s2
    800027e0:	00001097          	auipc	ra,0x1
    800027e4:	01a080e7          	jalr	26(ra) # 800037fa <log_write>
        brelse(bp);
    800027e8:	854a                	mv	a0,s2
    800027ea:	00000097          	auipc	ra,0x0
    800027ee:	d94080e7          	jalr	-620(ra) # 8000257e <brelse>
  bp = bread(dev, bno);
    800027f2:	85a6                	mv	a1,s1
    800027f4:	855e                	mv	a0,s7
    800027f6:	00000097          	auipc	ra,0x0
    800027fa:	c58080e7          	jalr	-936(ra) # 8000244e <bread>
    800027fe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002800:	40000613          	li	a2,1024
    80002804:	4581                	li	a1,0
    80002806:	05850513          	addi	a0,a0,88
    8000280a:	ffffe097          	auipc	ra,0xffffe
    8000280e:	96e080e7          	jalr	-1682(ra) # 80000178 <memset>
  log_write(bp);
    80002812:	854a                	mv	a0,s2
    80002814:	00001097          	auipc	ra,0x1
    80002818:	fe6080e7          	jalr	-26(ra) # 800037fa <log_write>
  brelse(bp);
    8000281c:	854a                	mv	a0,s2
    8000281e:	00000097          	auipc	ra,0x0
    80002822:	d60080e7          	jalr	-672(ra) # 8000257e <brelse>
}
    80002826:	8526                	mv	a0,s1
    80002828:	60e6                	ld	ra,88(sp)
    8000282a:	6446                	ld	s0,80(sp)
    8000282c:	64a6                	ld	s1,72(sp)
    8000282e:	6906                	ld	s2,64(sp)
    80002830:	79e2                	ld	s3,56(sp)
    80002832:	7a42                	ld	s4,48(sp)
    80002834:	7aa2                	ld	s5,40(sp)
    80002836:	7b02                	ld	s6,32(sp)
    80002838:	6be2                	ld	s7,24(sp)
    8000283a:	6c42                	ld	s8,16(sp)
    8000283c:	6ca2                	ld	s9,8(sp)
    8000283e:	6125                	addi	sp,sp,96
    80002840:	8082                	ret

0000000080002842 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002842:	7179                	addi	sp,sp,-48
    80002844:	f406                	sd	ra,40(sp)
    80002846:	f022                	sd	s0,32(sp)
    80002848:	ec26                	sd	s1,24(sp)
    8000284a:	e84a                	sd	s2,16(sp)
    8000284c:	e44e                	sd	s3,8(sp)
    8000284e:	e052                	sd	s4,0(sp)
    80002850:	1800                	addi	s0,sp,48
    80002852:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002854:	47ad                	li	a5,11
    80002856:	04b7fe63          	bgeu	a5,a1,800028b2 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000285a:	ff45849b          	addiw	s1,a1,-12
    8000285e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002862:	0ff00793          	li	a5,255
    80002866:	0ae7e363          	bltu	a5,a4,8000290c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000286a:	08052583          	lw	a1,128(a0)
    8000286e:	c5ad                	beqz	a1,800028d8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002870:	00092503          	lw	a0,0(s2)
    80002874:	00000097          	auipc	ra,0x0
    80002878:	bda080e7          	jalr	-1062(ra) # 8000244e <bread>
    8000287c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000287e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002882:	02049593          	slli	a1,s1,0x20
    80002886:	9181                	srli	a1,a1,0x20
    80002888:	058a                	slli	a1,a1,0x2
    8000288a:	00b784b3          	add	s1,a5,a1
    8000288e:	0004a983          	lw	s3,0(s1)
    80002892:	04098d63          	beqz	s3,800028ec <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002896:	8552                	mv	a0,s4
    80002898:	00000097          	auipc	ra,0x0
    8000289c:	ce6080e7          	jalr	-794(ra) # 8000257e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028a0:	854e                	mv	a0,s3
    800028a2:	70a2                	ld	ra,40(sp)
    800028a4:	7402                	ld	s0,32(sp)
    800028a6:	64e2                	ld	s1,24(sp)
    800028a8:	6942                	ld	s2,16(sp)
    800028aa:	69a2                	ld	s3,8(sp)
    800028ac:	6a02                	ld	s4,0(sp)
    800028ae:	6145                	addi	sp,sp,48
    800028b0:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028b2:	02059493          	slli	s1,a1,0x20
    800028b6:	9081                	srli	s1,s1,0x20
    800028b8:	048a                	slli	s1,s1,0x2
    800028ba:	94aa                	add	s1,s1,a0
    800028bc:	0504a983          	lw	s3,80(s1)
    800028c0:	fe0990e3          	bnez	s3,800028a0 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028c4:	4108                	lw	a0,0(a0)
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	e4a080e7          	jalr	-438(ra) # 80002710 <balloc>
    800028ce:	0005099b          	sext.w	s3,a0
    800028d2:	0534a823          	sw	s3,80(s1)
    800028d6:	b7e9                	j	800028a0 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028d8:	4108                	lw	a0,0(a0)
    800028da:	00000097          	auipc	ra,0x0
    800028de:	e36080e7          	jalr	-458(ra) # 80002710 <balloc>
    800028e2:	0005059b          	sext.w	a1,a0
    800028e6:	08b92023          	sw	a1,128(s2)
    800028ea:	b759                	j	80002870 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028ec:	00092503          	lw	a0,0(s2)
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	e20080e7          	jalr	-480(ra) # 80002710 <balloc>
    800028f8:	0005099b          	sext.w	s3,a0
    800028fc:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002900:	8552                	mv	a0,s4
    80002902:	00001097          	auipc	ra,0x1
    80002906:	ef8080e7          	jalr	-264(ra) # 800037fa <log_write>
    8000290a:	b771                	j	80002896 <bmap+0x54>
  panic("bmap: out of range");
    8000290c:	00006517          	auipc	a0,0x6
    80002910:	c7c50513          	addi	a0,a0,-900 # 80008588 <syscalls+0x160>
    80002914:	00003097          	auipc	ra,0x3
    80002918:	404080e7          	jalr	1028(ra) # 80005d18 <panic>

000000008000291c <iget>:
{
    8000291c:	7179                	addi	sp,sp,-48
    8000291e:	f406                	sd	ra,40(sp)
    80002920:	f022                	sd	s0,32(sp)
    80002922:	ec26                	sd	s1,24(sp)
    80002924:	e84a                	sd	s2,16(sp)
    80002926:	e44e                	sd	s3,8(sp)
    80002928:	e052                	sd	s4,0(sp)
    8000292a:	1800                	addi	s0,sp,48
    8000292c:	89aa                	mv	s3,a0
    8000292e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002930:	00015517          	auipc	a0,0x15
    80002934:	e4850513          	addi	a0,a0,-440 # 80017778 <itable>
    80002938:	00004097          	auipc	ra,0x4
    8000293c:	92a080e7          	jalr	-1750(ra) # 80006262 <acquire>
  empty = 0;
    80002940:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002942:	00015497          	auipc	s1,0x15
    80002946:	e4e48493          	addi	s1,s1,-434 # 80017790 <itable+0x18>
    8000294a:	00017697          	auipc	a3,0x17
    8000294e:	8d668693          	addi	a3,a3,-1834 # 80019220 <log>
    80002952:	a039                	j	80002960 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002954:	02090b63          	beqz	s2,8000298a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002958:	08848493          	addi	s1,s1,136
    8000295c:	02d48a63          	beq	s1,a3,80002990 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002960:	449c                	lw	a5,8(s1)
    80002962:	fef059e3          	blez	a5,80002954 <iget+0x38>
    80002966:	4098                	lw	a4,0(s1)
    80002968:	ff3716e3          	bne	a4,s3,80002954 <iget+0x38>
    8000296c:	40d8                	lw	a4,4(s1)
    8000296e:	ff4713e3          	bne	a4,s4,80002954 <iget+0x38>
      ip->ref++;
    80002972:	2785                	addiw	a5,a5,1
    80002974:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002976:	00015517          	auipc	a0,0x15
    8000297a:	e0250513          	addi	a0,a0,-510 # 80017778 <itable>
    8000297e:	00004097          	auipc	ra,0x4
    80002982:	998080e7          	jalr	-1640(ra) # 80006316 <release>
      return ip;
    80002986:	8926                	mv	s2,s1
    80002988:	a03d                	j	800029b6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000298a:	f7f9                	bnez	a5,80002958 <iget+0x3c>
    8000298c:	8926                	mv	s2,s1
    8000298e:	b7e9                	j	80002958 <iget+0x3c>
  if(empty == 0)
    80002990:	02090c63          	beqz	s2,800029c8 <iget+0xac>
  ip->dev = dev;
    80002994:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002998:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000299c:	4785                	li	a5,1
    8000299e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029a2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029a6:	00015517          	auipc	a0,0x15
    800029aa:	dd250513          	addi	a0,a0,-558 # 80017778 <itable>
    800029ae:	00004097          	auipc	ra,0x4
    800029b2:	968080e7          	jalr	-1688(ra) # 80006316 <release>
}
    800029b6:	854a                	mv	a0,s2
    800029b8:	70a2                	ld	ra,40(sp)
    800029ba:	7402                	ld	s0,32(sp)
    800029bc:	64e2                	ld	s1,24(sp)
    800029be:	6942                	ld	s2,16(sp)
    800029c0:	69a2                	ld	s3,8(sp)
    800029c2:	6a02                	ld	s4,0(sp)
    800029c4:	6145                	addi	sp,sp,48
    800029c6:	8082                	ret
    panic("iget: no inodes");
    800029c8:	00006517          	auipc	a0,0x6
    800029cc:	bd850513          	addi	a0,a0,-1064 # 800085a0 <syscalls+0x178>
    800029d0:	00003097          	auipc	ra,0x3
    800029d4:	348080e7          	jalr	840(ra) # 80005d18 <panic>

00000000800029d8 <fsinit>:
fsinit(int dev) {
    800029d8:	7179                	addi	sp,sp,-48
    800029da:	f406                	sd	ra,40(sp)
    800029dc:	f022                	sd	s0,32(sp)
    800029de:	ec26                	sd	s1,24(sp)
    800029e0:	e84a                	sd	s2,16(sp)
    800029e2:	e44e                	sd	s3,8(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029e8:	4585                	li	a1,1
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	a64080e7          	jalr	-1436(ra) # 8000244e <bread>
    800029f2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029f4:	00015997          	auipc	s3,0x15
    800029f8:	d6498993          	addi	s3,s3,-668 # 80017758 <sb>
    800029fc:	02000613          	li	a2,32
    80002a00:	05850593          	addi	a1,a0,88
    80002a04:	854e                	mv	a0,s3
    80002a06:	ffffd097          	auipc	ra,0xffffd
    80002a0a:	7d2080e7          	jalr	2002(ra) # 800001d8 <memmove>
  brelse(bp);
    80002a0e:	8526                	mv	a0,s1
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	b6e080e7          	jalr	-1170(ra) # 8000257e <brelse>
  if(sb.magic != FSMAGIC)
    80002a18:	0009a703          	lw	a4,0(s3)
    80002a1c:	102037b7          	lui	a5,0x10203
    80002a20:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a24:	02f71263          	bne	a4,a5,80002a48 <fsinit+0x70>
  initlog(dev, &sb);
    80002a28:	00015597          	auipc	a1,0x15
    80002a2c:	d3058593          	addi	a1,a1,-720 # 80017758 <sb>
    80002a30:	854a                	mv	a0,s2
    80002a32:	00001097          	auipc	ra,0x1
    80002a36:	b4c080e7          	jalr	-1204(ra) # 8000357e <initlog>
}
    80002a3a:	70a2                	ld	ra,40(sp)
    80002a3c:	7402                	ld	s0,32(sp)
    80002a3e:	64e2                	ld	s1,24(sp)
    80002a40:	6942                	ld	s2,16(sp)
    80002a42:	69a2                	ld	s3,8(sp)
    80002a44:	6145                	addi	sp,sp,48
    80002a46:	8082                	ret
    panic("invalid file system");
    80002a48:	00006517          	auipc	a0,0x6
    80002a4c:	b6850513          	addi	a0,a0,-1176 # 800085b0 <syscalls+0x188>
    80002a50:	00003097          	auipc	ra,0x3
    80002a54:	2c8080e7          	jalr	712(ra) # 80005d18 <panic>

0000000080002a58 <iinit>:
{
    80002a58:	7179                	addi	sp,sp,-48
    80002a5a:	f406                	sd	ra,40(sp)
    80002a5c:	f022                	sd	s0,32(sp)
    80002a5e:	ec26                	sd	s1,24(sp)
    80002a60:	e84a                	sd	s2,16(sp)
    80002a62:	e44e                	sd	s3,8(sp)
    80002a64:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a66:	00006597          	auipc	a1,0x6
    80002a6a:	b6258593          	addi	a1,a1,-1182 # 800085c8 <syscalls+0x1a0>
    80002a6e:	00015517          	auipc	a0,0x15
    80002a72:	d0a50513          	addi	a0,a0,-758 # 80017778 <itable>
    80002a76:	00003097          	auipc	ra,0x3
    80002a7a:	75c080e7          	jalr	1884(ra) # 800061d2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a7e:	00015497          	auipc	s1,0x15
    80002a82:	d2248493          	addi	s1,s1,-734 # 800177a0 <itable+0x28>
    80002a86:	00016997          	auipc	s3,0x16
    80002a8a:	7aa98993          	addi	s3,s3,1962 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a8e:	00006917          	auipc	s2,0x6
    80002a92:	b4290913          	addi	s2,s2,-1214 # 800085d0 <syscalls+0x1a8>
    80002a96:	85ca                	mv	a1,s2
    80002a98:	8526                	mv	a0,s1
    80002a9a:	00001097          	auipc	ra,0x1
    80002a9e:	e46080e7          	jalr	-442(ra) # 800038e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002aa2:	08848493          	addi	s1,s1,136
    80002aa6:	ff3498e3          	bne	s1,s3,80002a96 <iinit+0x3e>
}
    80002aaa:	70a2                	ld	ra,40(sp)
    80002aac:	7402                	ld	s0,32(sp)
    80002aae:	64e2                	ld	s1,24(sp)
    80002ab0:	6942                	ld	s2,16(sp)
    80002ab2:	69a2                	ld	s3,8(sp)
    80002ab4:	6145                	addi	sp,sp,48
    80002ab6:	8082                	ret

0000000080002ab8 <ialloc>:
{
    80002ab8:	715d                	addi	sp,sp,-80
    80002aba:	e486                	sd	ra,72(sp)
    80002abc:	e0a2                	sd	s0,64(sp)
    80002abe:	fc26                	sd	s1,56(sp)
    80002ac0:	f84a                	sd	s2,48(sp)
    80002ac2:	f44e                	sd	s3,40(sp)
    80002ac4:	f052                	sd	s4,32(sp)
    80002ac6:	ec56                	sd	s5,24(sp)
    80002ac8:	e85a                	sd	s6,16(sp)
    80002aca:	e45e                	sd	s7,8(sp)
    80002acc:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ace:	00015717          	auipc	a4,0x15
    80002ad2:	c9672703          	lw	a4,-874(a4) # 80017764 <sb+0xc>
    80002ad6:	4785                	li	a5,1
    80002ad8:	04e7fa63          	bgeu	a5,a4,80002b2c <ialloc+0x74>
    80002adc:	8aaa                	mv	s5,a0
    80002ade:	8bae                	mv	s7,a1
    80002ae0:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ae2:	00015a17          	auipc	s4,0x15
    80002ae6:	c76a0a13          	addi	s4,s4,-906 # 80017758 <sb>
    80002aea:	00048b1b          	sext.w	s6,s1
    80002aee:	0044d593          	srli	a1,s1,0x4
    80002af2:	018a2783          	lw	a5,24(s4)
    80002af6:	9dbd                	addw	a1,a1,a5
    80002af8:	8556                	mv	a0,s5
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	954080e7          	jalr	-1708(ra) # 8000244e <bread>
    80002b02:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b04:	05850993          	addi	s3,a0,88
    80002b08:	00f4f793          	andi	a5,s1,15
    80002b0c:	079a                	slli	a5,a5,0x6
    80002b0e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b10:	00099783          	lh	a5,0(s3)
    80002b14:	c785                	beqz	a5,80002b3c <ialloc+0x84>
    brelse(bp);
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	a68080e7          	jalr	-1432(ra) # 8000257e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b1e:	0485                	addi	s1,s1,1
    80002b20:	00ca2703          	lw	a4,12(s4)
    80002b24:	0004879b          	sext.w	a5,s1
    80002b28:	fce7e1e3          	bltu	a5,a4,80002aea <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b2c:	00006517          	auipc	a0,0x6
    80002b30:	aac50513          	addi	a0,a0,-1364 # 800085d8 <syscalls+0x1b0>
    80002b34:	00003097          	auipc	ra,0x3
    80002b38:	1e4080e7          	jalr	484(ra) # 80005d18 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b3c:	04000613          	li	a2,64
    80002b40:	4581                	li	a1,0
    80002b42:	854e                	mv	a0,s3
    80002b44:	ffffd097          	auipc	ra,0xffffd
    80002b48:	634080e7          	jalr	1588(ra) # 80000178 <memset>
      dip->type = type;
    80002b4c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b50:	854a                	mv	a0,s2
    80002b52:	00001097          	auipc	ra,0x1
    80002b56:	ca8080e7          	jalr	-856(ra) # 800037fa <log_write>
      brelse(bp);
    80002b5a:	854a                	mv	a0,s2
    80002b5c:	00000097          	auipc	ra,0x0
    80002b60:	a22080e7          	jalr	-1502(ra) # 8000257e <brelse>
      return iget(dev, inum);
    80002b64:	85da                	mv	a1,s6
    80002b66:	8556                	mv	a0,s5
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	db4080e7          	jalr	-588(ra) # 8000291c <iget>
}
    80002b70:	60a6                	ld	ra,72(sp)
    80002b72:	6406                	ld	s0,64(sp)
    80002b74:	74e2                	ld	s1,56(sp)
    80002b76:	7942                	ld	s2,48(sp)
    80002b78:	79a2                	ld	s3,40(sp)
    80002b7a:	7a02                	ld	s4,32(sp)
    80002b7c:	6ae2                	ld	s5,24(sp)
    80002b7e:	6b42                	ld	s6,16(sp)
    80002b80:	6ba2                	ld	s7,8(sp)
    80002b82:	6161                	addi	sp,sp,80
    80002b84:	8082                	ret

0000000080002b86 <iupdate>:
{
    80002b86:	1101                	addi	sp,sp,-32
    80002b88:	ec06                	sd	ra,24(sp)
    80002b8a:	e822                	sd	s0,16(sp)
    80002b8c:	e426                	sd	s1,8(sp)
    80002b8e:	e04a                	sd	s2,0(sp)
    80002b90:	1000                	addi	s0,sp,32
    80002b92:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b94:	415c                	lw	a5,4(a0)
    80002b96:	0047d79b          	srliw	a5,a5,0x4
    80002b9a:	00015597          	auipc	a1,0x15
    80002b9e:	bd65a583          	lw	a1,-1066(a1) # 80017770 <sb+0x18>
    80002ba2:	9dbd                	addw	a1,a1,a5
    80002ba4:	4108                	lw	a0,0(a0)
    80002ba6:	00000097          	auipc	ra,0x0
    80002baa:	8a8080e7          	jalr	-1880(ra) # 8000244e <bread>
    80002bae:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bb0:	05850793          	addi	a5,a0,88
    80002bb4:	40c8                	lw	a0,4(s1)
    80002bb6:	893d                	andi	a0,a0,15
    80002bb8:	051a                	slli	a0,a0,0x6
    80002bba:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002bbc:	04449703          	lh	a4,68(s1)
    80002bc0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bc4:	04649703          	lh	a4,70(s1)
    80002bc8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002bcc:	04849703          	lh	a4,72(s1)
    80002bd0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bd4:	04a49703          	lh	a4,74(s1)
    80002bd8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bdc:	44f8                	lw	a4,76(s1)
    80002bde:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002be0:	03400613          	li	a2,52
    80002be4:	05048593          	addi	a1,s1,80
    80002be8:	0531                	addi	a0,a0,12
    80002bea:	ffffd097          	auipc	ra,0xffffd
    80002bee:	5ee080e7          	jalr	1518(ra) # 800001d8 <memmove>
  log_write(bp);
    80002bf2:	854a                	mv	a0,s2
    80002bf4:	00001097          	auipc	ra,0x1
    80002bf8:	c06080e7          	jalr	-1018(ra) # 800037fa <log_write>
  brelse(bp);
    80002bfc:	854a                	mv	a0,s2
    80002bfe:	00000097          	auipc	ra,0x0
    80002c02:	980080e7          	jalr	-1664(ra) # 8000257e <brelse>
}
    80002c06:	60e2                	ld	ra,24(sp)
    80002c08:	6442                	ld	s0,16(sp)
    80002c0a:	64a2                	ld	s1,8(sp)
    80002c0c:	6902                	ld	s2,0(sp)
    80002c0e:	6105                	addi	sp,sp,32
    80002c10:	8082                	ret

0000000080002c12 <idup>:
{
    80002c12:	1101                	addi	sp,sp,-32
    80002c14:	ec06                	sd	ra,24(sp)
    80002c16:	e822                	sd	s0,16(sp)
    80002c18:	e426                	sd	s1,8(sp)
    80002c1a:	1000                	addi	s0,sp,32
    80002c1c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c1e:	00015517          	auipc	a0,0x15
    80002c22:	b5a50513          	addi	a0,a0,-1190 # 80017778 <itable>
    80002c26:	00003097          	auipc	ra,0x3
    80002c2a:	63c080e7          	jalr	1596(ra) # 80006262 <acquire>
  ip->ref++;
    80002c2e:	449c                	lw	a5,8(s1)
    80002c30:	2785                	addiw	a5,a5,1
    80002c32:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c34:	00015517          	auipc	a0,0x15
    80002c38:	b4450513          	addi	a0,a0,-1212 # 80017778 <itable>
    80002c3c:	00003097          	auipc	ra,0x3
    80002c40:	6da080e7          	jalr	1754(ra) # 80006316 <release>
}
    80002c44:	8526                	mv	a0,s1
    80002c46:	60e2                	ld	ra,24(sp)
    80002c48:	6442                	ld	s0,16(sp)
    80002c4a:	64a2                	ld	s1,8(sp)
    80002c4c:	6105                	addi	sp,sp,32
    80002c4e:	8082                	ret

0000000080002c50 <ilock>:
{
    80002c50:	1101                	addi	sp,sp,-32
    80002c52:	ec06                	sd	ra,24(sp)
    80002c54:	e822                	sd	s0,16(sp)
    80002c56:	e426                	sd	s1,8(sp)
    80002c58:	e04a                	sd	s2,0(sp)
    80002c5a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c5c:	c115                	beqz	a0,80002c80 <ilock+0x30>
    80002c5e:	84aa                	mv	s1,a0
    80002c60:	451c                	lw	a5,8(a0)
    80002c62:	00f05f63          	blez	a5,80002c80 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c66:	0541                	addi	a0,a0,16
    80002c68:	00001097          	auipc	ra,0x1
    80002c6c:	cb2080e7          	jalr	-846(ra) # 8000391a <acquiresleep>
  if(ip->valid == 0){
    80002c70:	40bc                	lw	a5,64(s1)
    80002c72:	cf99                	beqz	a5,80002c90 <ilock+0x40>
}
    80002c74:	60e2                	ld	ra,24(sp)
    80002c76:	6442                	ld	s0,16(sp)
    80002c78:	64a2                	ld	s1,8(sp)
    80002c7a:	6902                	ld	s2,0(sp)
    80002c7c:	6105                	addi	sp,sp,32
    80002c7e:	8082                	ret
    panic("ilock");
    80002c80:	00006517          	auipc	a0,0x6
    80002c84:	97050513          	addi	a0,a0,-1680 # 800085f0 <syscalls+0x1c8>
    80002c88:	00003097          	auipc	ra,0x3
    80002c8c:	090080e7          	jalr	144(ra) # 80005d18 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c90:	40dc                	lw	a5,4(s1)
    80002c92:	0047d79b          	srliw	a5,a5,0x4
    80002c96:	00015597          	auipc	a1,0x15
    80002c9a:	ada5a583          	lw	a1,-1318(a1) # 80017770 <sb+0x18>
    80002c9e:	9dbd                	addw	a1,a1,a5
    80002ca0:	4088                	lw	a0,0(s1)
    80002ca2:	fffff097          	auipc	ra,0xfffff
    80002ca6:	7ac080e7          	jalr	1964(ra) # 8000244e <bread>
    80002caa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cac:	05850593          	addi	a1,a0,88
    80002cb0:	40dc                	lw	a5,4(s1)
    80002cb2:	8bbd                	andi	a5,a5,15
    80002cb4:	079a                	slli	a5,a5,0x6
    80002cb6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cb8:	00059783          	lh	a5,0(a1)
    80002cbc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cc0:	00259783          	lh	a5,2(a1)
    80002cc4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cc8:	00459783          	lh	a5,4(a1)
    80002ccc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cd0:	00659783          	lh	a5,6(a1)
    80002cd4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cd8:	459c                	lw	a5,8(a1)
    80002cda:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cdc:	03400613          	li	a2,52
    80002ce0:	05b1                	addi	a1,a1,12
    80002ce2:	05048513          	addi	a0,s1,80
    80002ce6:	ffffd097          	auipc	ra,0xffffd
    80002cea:	4f2080e7          	jalr	1266(ra) # 800001d8 <memmove>
    brelse(bp);
    80002cee:	854a                	mv	a0,s2
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	88e080e7          	jalr	-1906(ra) # 8000257e <brelse>
    ip->valid = 1;
    80002cf8:	4785                	li	a5,1
    80002cfa:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cfc:	04449783          	lh	a5,68(s1)
    80002d00:	fbb5                	bnez	a5,80002c74 <ilock+0x24>
      panic("ilock: no type");
    80002d02:	00006517          	auipc	a0,0x6
    80002d06:	8f650513          	addi	a0,a0,-1802 # 800085f8 <syscalls+0x1d0>
    80002d0a:	00003097          	auipc	ra,0x3
    80002d0e:	00e080e7          	jalr	14(ra) # 80005d18 <panic>

0000000080002d12 <iunlock>:
{
    80002d12:	1101                	addi	sp,sp,-32
    80002d14:	ec06                	sd	ra,24(sp)
    80002d16:	e822                	sd	s0,16(sp)
    80002d18:	e426                	sd	s1,8(sp)
    80002d1a:	e04a                	sd	s2,0(sp)
    80002d1c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d1e:	c905                	beqz	a0,80002d4e <iunlock+0x3c>
    80002d20:	84aa                	mv	s1,a0
    80002d22:	01050913          	addi	s2,a0,16
    80002d26:	854a                	mv	a0,s2
    80002d28:	00001097          	auipc	ra,0x1
    80002d2c:	c8c080e7          	jalr	-884(ra) # 800039b4 <holdingsleep>
    80002d30:	cd19                	beqz	a0,80002d4e <iunlock+0x3c>
    80002d32:	449c                	lw	a5,8(s1)
    80002d34:	00f05d63          	blez	a5,80002d4e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d38:	854a                	mv	a0,s2
    80002d3a:	00001097          	auipc	ra,0x1
    80002d3e:	c36080e7          	jalr	-970(ra) # 80003970 <releasesleep>
}
    80002d42:	60e2                	ld	ra,24(sp)
    80002d44:	6442                	ld	s0,16(sp)
    80002d46:	64a2                	ld	s1,8(sp)
    80002d48:	6902                	ld	s2,0(sp)
    80002d4a:	6105                	addi	sp,sp,32
    80002d4c:	8082                	ret
    panic("iunlock");
    80002d4e:	00006517          	auipc	a0,0x6
    80002d52:	8ba50513          	addi	a0,a0,-1862 # 80008608 <syscalls+0x1e0>
    80002d56:	00003097          	auipc	ra,0x3
    80002d5a:	fc2080e7          	jalr	-62(ra) # 80005d18 <panic>

0000000080002d5e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d5e:	7179                	addi	sp,sp,-48
    80002d60:	f406                	sd	ra,40(sp)
    80002d62:	f022                	sd	s0,32(sp)
    80002d64:	ec26                	sd	s1,24(sp)
    80002d66:	e84a                	sd	s2,16(sp)
    80002d68:	e44e                	sd	s3,8(sp)
    80002d6a:	e052                	sd	s4,0(sp)
    80002d6c:	1800                	addi	s0,sp,48
    80002d6e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d70:	05050493          	addi	s1,a0,80
    80002d74:	08050913          	addi	s2,a0,128
    80002d78:	a021                	j	80002d80 <itrunc+0x22>
    80002d7a:	0491                	addi	s1,s1,4
    80002d7c:	01248d63          	beq	s1,s2,80002d96 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d80:	408c                	lw	a1,0(s1)
    80002d82:	dde5                	beqz	a1,80002d7a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d84:	0009a503          	lw	a0,0(s3)
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	90c080e7          	jalr	-1780(ra) # 80002694 <bfree>
      ip->addrs[i] = 0;
    80002d90:	0004a023          	sw	zero,0(s1)
    80002d94:	b7dd                	j	80002d7a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d96:	0809a583          	lw	a1,128(s3)
    80002d9a:	e185                	bnez	a1,80002dba <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d9c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002da0:	854e                	mv	a0,s3
    80002da2:	00000097          	auipc	ra,0x0
    80002da6:	de4080e7          	jalr	-540(ra) # 80002b86 <iupdate>
}
    80002daa:	70a2                	ld	ra,40(sp)
    80002dac:	7402                	ld	s0,32(sp)
    80002dae:	64e2                	ld	s1,24(sp)
    80002db0:	6942                	ld	s2,16(sp)
    80002db2:	69a2                	ld	s3,8(sp)
    80002db4:	6a02                	ld	s4,0(sp)
    80002db6:	6145                	addi	sp,sp,48
    80002db8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dba:	0009a503          	lw	a0,0(s3)
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	690080e7          	jalr	1680(ra) # 8000244e <bread>
    80002dc6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dc8:	05850493          	addi	s1,a0,88
    80002dcc:	45850913          	addi	s2,a0,1112
    80002dd0:	a811                	j	80002de4 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002dd2:	0009a503          	lw	a0,0(s3)
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	8be080e7          	jalr	-1858(ra) # 80002694 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002dde:	0491                	addi	s1,s1,4
    80002de0:	01248563          	beq	s1,s2,80002dea <itrunc+0x8c>
      if(a[j])
    80002de4:	408c                	lw	a1,0(s1)
    80002de6:	dde5                	beqz	a1,80002dde <itrunc+0x80>
    80002de8:	b7ed                	j	80002dd2 <itrunc+0x74>
    brelse(bp);
    80002dea:	8552                	mv	a0,s4
    80002dec:	fffff097          	auipc	ra,0xfffff
    80002df0:	792080e7          	jalr	1938(ra) # 8000257e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002df4:	0809a583          	lw	a1,128(s3)
    80002df8:	0009a503          	lw	a0,0(s3)
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	898080e7          	jalr	-1896(ra) # 80002694 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e04:	0809a023          	sw	zero,128(s3)
    80002e08:	bf51                	j	80002d9c <itrunc+0x3e>

0000000080002e0a <iput>:
{
    80002e0a:	1101                	addi	sp,sp,-32
    80002e0c:	ec06                	sd	ra,24(sp)
    80002e0e:	e822                	sd	s0,16(sp)
    80002e10:	e426                	sd	s1,8(sp)
    80002e12:	e04a                	sd	s2,0(sp)
    80002e14:	1000                	addi	s0,sp,32
    80002e16:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e18:	00015517          	auipc	a0,0x15
    80002e1c:	96050513          	addi	a0,a0,-1696 # 80017778 <itable>
    80002e20:	00003097          	auipc	ra,0x3
    80002e24:	442080e7          	jalr	1090(ra) # 80006262 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e28:	4498                	lw	a4,8(s1)
    80002e2a:	4785                	li	a5,1
    80002e2c:	02f70363          	beq	a4,a5,80002e52 <iput+0x48>
  ip->ref--;
    80002e30:	449c                	lw	a5,8(s1)
    80002e32:	37fd                	addiw	a5,a5,-1
    80002e34:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e36:	00015517          	auipc	a0,0x15
    80002e3a:	94250513          	addi	a0,a0,-1726 # 80017778 <itable>
    80002e3e:	00003097          	auipc	ra,0x3
    80002e42:	4d8080e7          	jalr	1240(ra) # 80006316 <release>
}
    80002e46:	60e2                	ld	ra,24(sp)
    80002e48:	6442                	ld	s0,16(sp)
    80002e4a:	64a2                	ld	s1,8(sp)
    80002e4c:	6902                	ld	s2,0(sp)
    80002e4e:	6105                	addi	sp,sp,32
    80002e50:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e52:	40bc                	lw	a5,64(s1)
    80002e54:	dff1                	beqz	a5,80002e30 <iput+0x26>
    80002e56:	04a49783          	lh	a5,74(s1)
    80002e5a:	fbf9                	bnez	a5,80002e30 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e5c:	01048913          	addi	s2,s1,16
    80002e60:	854a                	mv	a0,s2
    80002e62:	00001097          	auipc	ra,0x1
    80002e66:	ab8080e7          	jalr	-1352(ra) # 8000391a <acquiresleep>
    release(&itable.lock);
    80002e6a:	00015517          	auipc	a0,0x15
    80002e6e:	90e50513          	addi	a0,a0,-1778 # 80017778 <itable>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	4a4080e7          	jalr	1188(ra) # 80006316 <release>
    itrunc(ip);
    80002e7a:	8526                	mv	a0,s1
    80002e7c:	00000097          	auipc	ra,0x0
    80002e80:	ee2080e7          	jalr	-286(ra) # 80002d5e <itrunc>
    ip->type = 0;
    80002e84:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e88:	8526                	mv	a0,s1
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	cfc080e7          	jalr	-772(ra) # 80002b86 <iupdate>
    ip->valid = 0;
    80002e92:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e96:	854a                	mv	a0,s2
    80002e98:	00001097          	auipc	ra,0x1
    80002e9c:	ad8080e7          	jalr	-1320(ra) # 80003970 <releasesleep>
    acquire(&itable.lock);
    80002ea0:	00015517          	auipc	a0,0x15
    80002ea4:	8d850513          	addi	a0,a0,-1832 # 80017778 <itable>
    80002ea8:	00003097          	auipc	ra,0x3
    80002eac:	3ba080e7          	jalr	954(ra) # 80006262 <acquire>
    80002eb0:	b741                	j	80002e30 <iput+0x26>

0000000080002eb2 <iunlockput>:
{
    80002eb2:	1101                	addi	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	e426                	sd	s1,8(sp)
    80002eba:	1000                	addi	s0,sp,32
    80002ebc:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	e54080e7          	jalr	-428(ra) # 80002d12 <iunlock>
  iput(ip);
    80002ec6:	8526                	mv	a0,s1
    80002ec8:	00000097          	auipc	ra,0x0
    80002ecc:	f42080e7          	jalr	-190(ra) # 80002e0a <iput>
}
    80002ed0:	60e2                	ld	ra,24(sp)
    80002ed2:	6442                	ld	s0,16(sp)
    80002ed4:	64a2                	ld	s1,8(sp)
    80002ed6:	6105                	addi	sp,sp,32
    80002ed8:	8082                	ret

0000000080002eda <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002eda:	1141                	addi	sp,sp,-16
    80002edc:	e422                	sd	s0,8(sp)
    80002ede:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ee0:	411c                	lw	a5,0(a0)
    80002ee2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ee4:	415c                	lw	a5,4(a0)
    80002ee6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ee8:	04451783          	lh	a5,68(a0)
    80002eec:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ef0:	04a51783          	lh	a5,74(a0)
    80002ef4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ef8:	04c56783          	lwu	a5,76(a0)
    80002efc:	e99c                	sd	a5,16(a1)
}
    80002efe:	6422                	ld	s0,8(sp)
    80002f00:	0141                	addi	sp,sp,16
    80002f02:	8082                	ret

0000000080002f04 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f04:	457c                	lw	a5,76(a0)
    80002f06:	0ed7e963          	bltu	a5,a3,80002ff8 <readi+0xf4>
{
    80002f0a:	7159                	addi	sp,sp,-112
    80002f0c:	f486                	sd	ra,104(sp)
    80002f0e:	f0a2                	sd	s0,96(sp)
    80002f10:	eca6                	sd	s1,88(sp)
    80002f12:	e8ca                	sd	s2,80(sp)
    80002f14:	e4ce                	sd	s3,72(sp)
    80002f16:	e0d2                	sd	s4,64(sp)
    80002f18:	fc56                	sd	s5,56(sp)
    80002f1a:	f85a                	sd	s6,48(sp)
    80002f1c:	f45e                	sd	s7,40(sp)
    80002f1e:	f062                	sd	s8,32(sp)
    80002f20:	ec66                	sd	s9,24(sp)
    80002f22:	e86a                	sd	s10,16(sp)
    80002f24:	e46e                	sd	s11,8(sp)
    80002f26:	1880                	addi	s0,sp,112
    80002f28:	8baa                	mv	s7,a0
    80002f2a:	8c2e                	mv	s8,a1
    80002f2c:	8ab2                	mv	s5,a2
    80002f2e:	84b6                	mv	s1,a3
    80002f30:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f32:	9f35                	addw	a4,a4,a3
    return 0;
    80002f34:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f36:	0ad76063          	bltu	a4,a3,80002fd6 <readi+0xd2>
  if(off + n > ip->size)
    80002f3a:	00e7f463          	bgeu	a5,a4,80002f42 <readi+0x3e>
    n = ip->size - off;
    80002f3e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f42:	0a0b0963          	beqz	s6,80002ff4 <readi+0xf0>
    80002f46:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f48:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f4c:	5cfd                	li	s9,-1
    80002f4e:	a82d                	j	80002f88 <readi+0x84>
    80002f50:	020a1d93          	slli	s11,s4,0x20
    80002f54:	020ddd93          	srli	s11,s11,0x20
    80002f58:	05890613          	addi	a2,s2,88
    80002f5c:	86ee                	mv	a3,s11
    80002f5e:	963a                	add	a2,a2,a4
    80002f60:	85d6                	mv	a1,s5
    80002f62:	8562                	mv	a0,s8
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	b20080e7          	jalr	-1248(ra) # 80001a84 <either_copyout>
    80002f6c:	05950d63          	beq	a0,s9,80002fc6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f70:	854a                	mv	a0,s2
    80002f72:	fffff097          	auipc	ra,0xfffff
    80002f76:	60c080e7          	jalr	1548(ra) # 8000257e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f7a:	013a09bb          	addw	s3,s4,s3
    80002f7e:	009a04bb          	addw	s1,s4,s1
    80002f82:	9aee                	add	s5,s5,s11
    80002f84:	0569f763          	bgeu	s3,s6,80002fd2 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f88:	000ba903          	lw	s2,0(s7)
    80002f8c:	00a4d59b          	srliw	a1,s1,0xa
    80002f90:	855e                	mv	a0,s7
    80002f92:	00000097          	auipc	ra,0x0
    80002f96:	8b0080e7          	jalr	-1872(ra) # 80002842 <bmap>
    80002f9a:	0005059b          	sext.w	a1,a0
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	fffff097          	auipc	ra,0xfffff
    80002fa4:	4ae080e7          	jalr	1198(ra) # 8000244e <bread>
    80002fa8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002faa:	3ff4f713          	andi	a4,s1,1023
    80002fae:	40ed07bb          	subw	a5,s10,a4
    80002fb2:	413b06bb          	subw	a3,s6,s3
    80002fb6:	8a3e                	mv	s4,a5
    80002fb8:	2781                	sext.w	a5,a5
    80002fba:	0006861b          	sext.w	a2,a3
    80002fbe:	f8f679e3          	bgeu	a2,a5,80002f50 <readi+0x4c>
    80002fc2:	8a36                	mv	s4,a3
    80002fc4:	b771                	j	80002f50 <readi+0x4c>
      brelse(bp);
    80002fc6:	854a                	mv	a0,s2
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	5b6080e7          	jalr	1462(ra) # 8000257e <brelse>
      tot = -1;
    80002fd0:	59fd                	li	s3,-1
  }
  return tot;
    80002fd2:	0009851b          	sext.w	a0,s3
}
    80002fd6:	70a6                	ld	ra,104(sp)
    80002fd8:	7406                	ld	s0,96(sp)
    80002fda:	64e6                	ld	s1,88(sp)
    80002fdc:	6946                	ld	s2,80(sp)
    80002fde:	69a6                	ld	s3,72(sp)
    80002fe0:	6a06                	ld	s4,64(sp)
    80002fe2:	7ae2                	ld	s5,56(sp)
    80002fe4:	7b42                	ld	s6,48(sp)
    80002fe6:	7ba2                	ld	s7,40(sp)
    80002fe8:	7c02                	ld	s8,32(sp)
    80002fea:	6ce2                	ld	s9,24(sp)
    80002fec:	6d42                	ld	s10,16(sp)
    80002fee:	6da2                	ld	s11,8(sp)
    80002ff0:	6165                	addi	sp,sp,112
    80002ff2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ff4:	89da                	mv	s3,s6
    80002ff6:	bff1                	j	80002fd2 <readi+0xce>
    return 0;
    80002ff8:	4501                	li	a0,0
}
    80002ffa:	8082                	ret

0000000080002ffc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ffc:	457c                	lw	a5,76(a0)
    80002ffe:	10d7e863          	bltu	a5,a3,8000310e <writei+0x112>
{
    80003002:	7159                	addi	sp,sp,-112
    80003004:	f486                	sd	ra,104(sp)
    80003006:	f0a2                	sd	s0,96(sp)
    80003008:	eca6                	sd	s1,88(sp)
    8000300a:	e8ca                	sd	s2,80(sp)
    8000300c:	e4ce                	sd	s3,72(sp)
    8000300e:	e0d2                	sd	s4,64(sp)
    80003010:	fc56                	sd	s5,56(sp)
    80003012:	f85a                	sd	s6,48(sp)
    80003014:	f45e                	sd	s7,40(sp)
    80003016:	f062                	sd	s8,32(sp)
    80003018:	ec66                	sd	s9,24(sp)
    8000301a:	e86a                	sd	s10,16(sp)
    8000301c:	e46e                	sd	s11,8(sp)
    8000301e:	1880                	addi	s0,sp,112
    80003020:	8b2a                	mv	s6,a0
    80003022:	8c2e                	mv	s8,a1
    80003024:	8ab2                	mv	s5,a2
    80003026:	8936                	mv	s2,a3
    80003028:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000302a:	00e687bb          	addw	a5,a3,a4
    8000302e:	0ed7e263          	bltu	a5,a3,80003112 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003032:	00043737          	lui	a4,0x43
    80003036:	0ef76063          	bltu	a4,a5,80003116 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000303a:	0c0b8863          	beqz	s7,8000310a <writei+0x10e>
    8000303e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003040:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003044:	5cfd                	li	s9,-1
    80003046:	a091                	j	8000308a <writei+0x8e>
    80003048:	02099d93          	slli	s11,s3,0x20
    8000304c:	020ddd93          	srli	s11,s11,0x20
    80003050:	05848513          	addi	a0,s1,88
    80003054:	86ee                	mv	a3,s11
    80003056:	8656                	mv	a2,s5
    80003058:	85e2                	mv	a1,s8
    8000305a:	953a                	add	a0,a0,a4
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	a7e080e7          	jalr	-1410(ra) # 80001ada <either_copyin>
    80003064:	07950263          	beq	a0,s9,800030c8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003068:	8526                	mv	a0,s1
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	790080e7          	jalr	1936(ra) # 800037fa <log_write>
    brelse(bp);
    80003072:	8526                	mv	a0,s1
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	50a080e7          	jalr	1290(ra) # 8000257e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000307c:	01498a3b          	addw	s4,s3,s4
    80003080:	0129893b          	addw	s2,s3,s2
    80003084:	9aee                	add	s5,s5,s11
    80003086:	057a7663          	bgeu	s4,s7,800030d2 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000308a:	000b2483          	lw	s1,0(s6)
    8000308e:	00a9559b          	srliw	a1,s2,0xa
    80003092:	855a                	mv	a0,s6
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	7ae080e7          	jalr	1966(ra) # 80002842 <bmap>
    8000309c:	0005059b          	sext.w	a1,a0
    800030a0:	8526                	mv	a0,s1
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	3ac080e7          	jalr	940(ra) # 8000244e <bread>
    800030aa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ac:	3ff97713          	andi	a4,s2,1023
    800030b0:	40ed07bb          	subw	a5,s10,a4
    800030b4:	414b86bb          	subw	a3,s7,s4
    800030b8:	89be                	mv	s3,a5
    800030ba:	2781                	sext.w	a5,a5
    800030bc:	0006861b          	sext.w	a2,a3
    800030c0:	f8f674e3          	bgeu	a2,a5,80003048 <writei+0x4c>
    800030c4:	89b6                	mv	s3,a3
    800030c6:	b749                	j	80003048 <writei+0x4c>
      brelse(bp);
    800030c8:	8526                	mv	a0,s1
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	4b4080e7          	jalr	1204(ra) # 8000257e <brelse>
  }

  if(off > ip->size)
    800030d2:	04cb2783          	lw	a5,76(s6)
    800030d6:	0127f463          	bgeu	a5,s2,800030de <writei+0xe2>
    ip->size = off;
    800030da:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030de:	855a                	mv	a0,s6
    800030e0:	00000097          	auipc	ra,0x0
    800030e4:	aa6080e7          	jalr	-1370(ra) # 80002b86 <iupdate>

  return tot;
    800030e8:	000a051b          	sext.w	a0,s4
}
    800030ec:	70a6                	ld	ra,104(sp)
    800030ee:	7406                	ld	s0,96(sp)
    800030f0:	64e6                	ld	s1,88(sp)
    800030f2:	6946                	ld	s2,80(sp)
    800030f4:	69a6                	ld	s3,72(sp)
    800030f6:	6a06                	ld	s4,64(sp)
    800030f8:	7ae2                	ld	s5,56(sp)
    800030fa:	7b42                	ld	s6,48(sp)
    800030fc:	7ba2                	ld	s7,40(sp)
    800030fe:	7c02                	ld	s8,32(sp)
    80003100:	6ce2                	ld	s9,24(sp)
    80003102:	6d42                	ld	s10,16(sp)
    80003104:	6da2                	ld	s11,8(sp)
    80003106:	6165                	addi	sp,sp,112
    80003108:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000310a:	8a5e                	mv	s4,s7
    8000310c:	bfc9                	j	800030de <writei+0xe2>
    return -1;
    8000310e:	557d                	li	a0,-1
}
    80003110:	8082                	ret
    return -1;
    80003112:	557d                	li	a0,-1
    80003114:	bfe1                	j	800030ec <writei+0xf0>
    return -1;
    80003116:	557d                	li	a0,-1
    80003118:	bfd1                	j	800030ec <writei+0xf0>

000000008000311a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000311a:	1141                	addi	sp,sp,-16
    8000311c:	e406                	sd	ra,8(sp)
    8000311e:	e022                	sd	s0,0(sp)
    80003120:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003122:	4639                	li	a2,14
    80003124:	ffffd097          	auipc	ra,0xffffd
    80003128:	12c080e7          	jalr	300(ra) # 80000250 <strncmp>
}
    8000312c:	60a2                	ld	ra,8(sp)
    8000312e:	6402                	ld	s0,0(sp)
    80003130:	0141                	addi	sp,sp,16
    80003132:	8082                	ret

0000000080003134 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003134:	7139                	addi	sp,sp,-64
    80003136:	fc06                	sd	ra,56(sp)
    80003138:	f822                	sd	s0,48(sp)
    8000313a:	f426                	sd	s1,40(sp)
    8000313c:	f04a                	sd	s2,32(sp)
    8000313e:	ec4e                	sd	s3,24(sp)
    80003140:	e852                	sd	s4,16(sp)
    80003142:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003144:	04451703          	lh	a4,68(a0)
    80003148:	4785                	li	a5,1
    8000314a:	00f71a63          	bne	a4,a5,8000315e <dirlookup+0x2a>
    8000314e:	892a                	mv	s2,a0
    80003150:	89ae                	mv	s3,a1
    80003152:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003154:	457c                	lw	a5,76(a0)
    80003156:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003158:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000315a:	e79d                	bnez	a5,80003188 <dirlookup+0x54>
    8000315c:	a8a5                	j	800031d4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000315e:	00005517          	auipc	a0,0x5
    80003162:	4b250513          	addi	a0,a0,1202 # 80008610 <syscalls+0x1e8>
    80003166:	00003097          	auipc	ra,0x3
    8000316a:	bb2080e7          	jalr	-1102(ra) # 80005d18 <panic>
      panic("dirlookup read");
    8000316e:	00005517          	auipc	a0,0x5
    80003172:	4ba50513          	addi	a0,a0,1210 # 80008628 <syscalls+0x200>
    80003176:	00003097          	auipc	ra,0x3
    8000317a:	ba2080e7          	jalr	-1118(ra) # 80005d18 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000317e:	24c1                	addiw	s1,s1,16
    80003180:	04c92783          	lw	a5,76(s2)
    80003184:	04f4f763          	bgeu	s1,a5,800031d2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003188:	4741                	li	a4,16
    8000318a:	86a6                	mv	a3,s1
    8000318c:	fc040613          	addi	a2,s0,-64
    80003190:	4581                	li	a1,0
    80003192:	854a                	mv	a0,s2
    80003194:	00000097          	auipc	ra,0x0
    80003198:	d70080e7          	jalr	-656(ra) # 80002f04 <readi>
    8000319c:	47c1                	li	a5,16
    8000319e:	fcf518e3          	bne	a0,a5,8000316e <dirlookup+0x3a>
    if(de.inum == 0)
    800031a2:	fc045783          	lhu	a5,-64(s0)
    800031a6:	dfe1                	beqz	a5,8000317e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031a8:	fc240593          	addi	a1,s0,-62
    800031ac:	854e                	mv	a0,s3
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	f6c080e7          	jalr	-148(ra) # 8000311a <namecmp>
    800031b6:	f561                	bnez	a0,8000317e <dirlookup+0x4a>
      if(poff)
    800031b8:	000a0463          	beqz	s4,800031c0 <dirlookup+0x8c>
        *poff = off;
    800031bc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031c0:	fc045583          	lhu	a1,-64(s0)
    800031c4:	00092503          	lw	a0,0(s2)
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	754080e7          	jalr	1876(ra) # 8000291c <iget>
    800031d0:	a011                	j	800031d4 <dirlookup+0xa0>
  return 0;
    800031d2:	4501                	li	a0,0
}
    800031d4:	70e2                	ld	ra,56(sp)
    800031d6:	7442                	ld	s0,48(sp)
    800031d8:	74a2                	ld	s1,40(sp)
    800031da:	7902                	ld	s2,32(sp)
    800031dc:	69e2                	ld	s3,24(sp)
    800031de:	6a42                	ld	s4,16(sp)
    800031e0:	6121                	addi	sp,sp,64
    800031e2:	8082                	ret

00000000800031e4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031e4:	711d                	addi	sp,sp,-96
    800031e6:	ec86                	sd	ra,88(sp)
    800031e8:	e8a2                	sd	s0,80(sp)
    800031ea:	e4a6                	sd	s1,72(sp)
    800031ec:	e0ca                	sd	s2,64(sp)
    800031ee:	fc4e                	sd	s3,56(sp)
    800031f0:	f852                	sd	s4,48(sp)
    800031f2:	f456                	sd	s5,40(sp)
    800031f4:	f05a                	sd	s6,32(sp)
    800031f6:	ec5e                	sd	s7,24(sp)
    800031f8:	e862                	sd	s8,16(sp)
    800031fa:	e466                	sd	s9,8(sp)
    800031fc:	1080                	addi	s0,sp,96
    800031fe:	84aa                	mv	s1,a0
    80003200:	8b2e                	mv	s6,a1
    80003202:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003204:	00054703          	lbu	a4,0(a0)
    80003208:	02f00793          	li	a5,47
    8000320c:	02f70363          	beq	a4,a5,80003232 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003210:	ffffe097          	auipc	ra,0xffffe
    80003214:	d64080e7          	jalr	-668(ra) # 80000f74 <myproc>
    80003218:	15853503          	ld	a0,344(a0)
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	9f6080e7          	jalr	-1546(ra) # 80002c12 <idup>
    80003224:	89aa                	mv	s3,a0
  while(*path == '/')
    80003226:	02f00913          	li	s2,47
  len = path - s;
    8000322a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000322c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000322e:	4c05                	li	s8,1
    80003230:	a865                	j	800032e8 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003232:	4585                	li	a1,1
    80003234:	4505                	li	a0,1
    80003236:	fffff097          	auipc	ra,0xfffff
    8000323a:	6e6080e7          	jalr	1766(ra) # 8000291c <iget>
    8000323e:	89aa                	mv	s3,a0
    80003240:	b7dd                	j	80003226 <namex+0x42>
      iunlockput(ip);
    80003242:	854e                	mv	a0,s3
    80003244:	00000097          	auipc	ra,0x0
    80003248:	c6e080e7          	jalr	-914(ra) # 80002eb2 <iunlockput>
      return 0;
    8000324c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000324e:	854e                	mv	a0,s3
    80003250:	60e6                	ld	ra,88(sp)
    80003252:	6446                	ld	s0,80(sp)
    80003254:	64a6                	ld	s1,72(sp)
    80003256:	6906                	ld	s2,64(sp)
    80003258:	79e2                	ld	s3,56(sp)
    8000325a:	7a42                	ld	s4,48(sp)
    8000325c:	7aa2                	ld	s5,40(sp)
    8000325e:	7b02                	ld	s6,32(sp)
    80003260:	6be2                	ld	s7,24(sp)
    80003262:	6c42                	ld	s8,16(sp)
    80003264:	6ca2                	ld	s9,8(sp)
    80003266:	6125                	addi	sp,sp,96
    80003268:	8082                	ret
      iunlock(ip);
    8000326a:	854e                	mv	a0,s3
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	aa6080e7          	jalr	-1370(ra) # 80002d12 <iunlock>
      return ip;
    80003274:	bfe9                	j	8000324e <namex+0x6a>
      iunlockput(ip);
    80003276:	854e                	mv	a0,s3
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	c3a080e7          	jalr	-966(ra) # 80002eb2 <iunlockput>
      return 0;
    80003280:	89d2                	mv	s3,s4
    80003282:	b7f1                	j	8000324e <namex+0x6a>
  len = path - s;
    80003284:	40b48633          	sub	a2,s1,a1
    80003288:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000328c:	094cd463          	bge	s9,s4,80003314 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003290:	4639                	li	a2,14
    80003292:	8556                	mv	a0,s5
    80003294:	ffffd097          	auipc	ra,0xffffd
    80003298:	f44080e7          	jalr	-188(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000329c:	0004c783          	lbu	a5,0(s1)
    800032a0:	01279763          	bne	a5,s2,800032ae <namex+0xca>
    path++;
    800032a4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032a6:	0004c783          	lbu	a5,0(s1)
    800032aa:	ff278de3          	beq	a5,s2,800032a4 <namex+0xc0>
    ilock(ip);
    800032ae:	854e                	mv	a0,s3
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	9a0080e7          	jalr	-1632(ra) # 80002c50 <ilock>
    if(ip->type != T_DIR){
    800032b8:	04499783          	lh	a5,68(s3)
    800032bc:	f98793e3          	bne	a5,s8,80003242 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032c0:	000b0563          	beqz	s6,800032ca <namex+0xe6>
    800032c4:	0004c783          	lbu	a5,0(s1)
    800032c8:	d3cd                	beqz	a5,8000326a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032ca:	865e                	mv	a2,s7
    800032cc:	85d6                	mv	a1,s5
    800032ce:	854e                	mv	a0,s3
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	e64080e7          	jalr	-412(ra) # 80003134 <dirlookup>
    800032d8:	8a2a                	mv	s4,a0
    800032da:	dd51                	beqz	a0,80003276 <namex+0x92>
    iunlockput(ip);
    800032dc:	854e                	mv	a0,s3
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	bd4080e7          	jalr	-1068(ra) # 80002eb2 <iunlockput>
    ip = next;
    800032e6:	89d2                	mv	s3,s4
  while(*path == '/')
    800032e8:	0004c783          	lbu	a5,0(s1)
    800032ec:	05279763          	bne	a5,s2,8000333a <namex+0x156>
    path++;
    800032f0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032f2:	0004c783          	lbu	a5,0(s1)
    800032f6:	ff278de3          	beq	a5,s2,800032f0 <namex+0x10c>
  if(*path == 0)
    800032fa:	c79d                	beqz	a5,80003328 <namex+0x144>
    path++;
    800032fc:	85a6                	mv	a1,s1
  len = path - s;
    800032fe:	8a5e                	mv	s4,s7
    80003300:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003302:	01278963          	beq	a5,s2,80003314 <namex+0x130>
    80003306:	dfbd                	beqz	a5,80003284 <namex+0xa0>
    path++;
    80003308:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000330a:	0004c783          	lbu	a5,0(s1)
    8000330e:	ff279ce3          	bne	a5,s2,80003306 <namex+0x122>
    80003312:	bf8d                	j	80003284 <namex+0xa0>
    memmove(name, s, len);
    80003314:	2601                	sext.w	a2,a2
    80003316:	8556                	mv	a0,s5
    80003318:	ffffd097          	auipc	ra,0xffffd
    8000331c:	ec0080e7          	jalr	-320(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003320:	9a56                	add	s4,s4,s5
    80003322:	000a0023          	sb	zero,0(s4)
    80003326:	bf9d                	j	8000329c <namex+0xb8>
  if(nameiparent){
    80003328:	f20b03e3          	beqz	s6,8000324e <namex+0x6a>
    iput(ip);
    8000332c:	854e                	mv	a0,s3
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	adc080e7          	jalr	-1316(ra) # 80002e0a <iput>
    return 0;
    80003336:	4981                	li	s3,0
    80003338:	bf19                	j	8000324e <namex+0x6a>
  if(*path == 0)
    8000333a:	d7fd                	beqz	a5,80003328 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000333c:	0004c783          	lbu	a5,0(s1)
    80003340:	85a6                	mv	a1,s1
    80003342:	b7d1                	j	80003306 <namex+0x122>

0000000080003344 <dirlink>:
{
    80003344:	7139                	addi	sp,sp,-64
    80003346:	fc06                	sd	ra,56(sp)
    80003348:	f822                	sd	s0,48(sp)
    8000334a:	f426                	sd	s1,40(sp)
    8000334c:	f04a                	sd	s2,32(sp)
    8000334e:	ec4e                	sd	s3,24(sp)
    80003350:	e852                	sd	s4,16(sp)
    80003352:	0080                	addi	s0,sp,64
    80003354:	892a                	mv	s2,a0
    80003356:	8a2e                	mv	s4,a1
    80003358:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000335a:	4601                	li	a2,0
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	dd8080e7          	jalr	-552(ra) # 80003134 <dirlookup>
    80003364:	e93d                	bnez	a0,800033da <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003366:	04c92483          	lw	s1,76(s2)
    8000336a:	c49d                	beqz	s1,80003398 <dirlink+0x54>
    8000336c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000336e:	4741                	li	a4,16
    80003370:	86a6                	mv	a3,s1
    80003372:	fc040613          	addi	a2,s0,-64
    80003376:	4581                	li	a1,0
    80003378:	854a                	mv	a0,s2
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	b8a080e7          	jalr	-1142(ra) # 80002f04 <readi>
    80003382:	47c1                	li	a5,16
    80003384:	06f51163          	bne	a0,a5,800033e6 <dirlink+0xa2>
    if(de.inum == 0)
    80003388:	fc045783          	lhu	a5,-64(s0)
    8000338c:	c791                	beqz	a5,80003398 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000338e:	24c1                	addiw	s1,s1,16
    80003390:	04c92783          	lw	a5,76(s2)
    80003394:	fcf4ede3          	bltu	s1,a5,8000336e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003398:	4639                	li	a2,14
    8000339a:	85d2                	mv	a1,s4
    8000339c:	fc240513          	addi	a0,s0,-62
    800033a0:	ffffd097          	auipc	ra,0xffffd
    800033a4:	eec080e7          	jalr	-276(ra) # 8000028c <strncpy>
  de.inum = inum;
    800033a8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ac:	4741                	li	a4,16
    800033ae:	86a6                	mv	a3,s1
    800033b0:	fc040613          	addi	a2,s0,-64
    800033b4:	4581                	li	a1,0
    800033b6:	854a                	mv	a0,s2
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	c44080e7          	jalr	-956(ra) # 80002ffc <writei>
    800033c0:	872a                	mv	a4,a0
    800033c2:	47c1                	li	a5,16
  return 0;
    800033c4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c6:	02f71863          	bne	a4,a5,800033f6 <dirlink+0xb2>
}
    800033ca:	70e2                	ld	ra,56(sp)
    800033cc:	7442                	ld	s0,48(sp)
    800033ce:	74a2                	ld	s1,40(sp)
    800033d0:	7902                	ld	s2,32(sp)
    800033d2:	69e2                	ld	s3,24(sp)
    800033d4:	6a42                	ld	s4,16(sp)
    800033d6:	6121                	addi	sp,sp,64
    800033d8:	8082                	ret
    iput(ip);
    800033da:	00000097          	auipc	ra,0x0
    800033de:	a30080e7          	jalr	-1488(ra) # 80002e0a <iput>
    return -1;
    800033e2:	557d                	li	a0,-1
    800033e4:	b7dd                	j	800033ca <dirlink+0x86>
      panic("dirlink read");
    800033e6:	00005517          	auipc	a0,0x5
    800033ea:	25250513          	addi	a0,a0,594 # 80008638 <syscalls+0x210>
    800033ee:	00003097          	auipc	ra,0x3
    800033f2:	92a080e7          	jalr	-1750(ra) # 80005d18 <panic>
    panic("dirlink");
    800033f6:	00005517          	auipc	a0,0x5
    800033fa:	35250513          	addi	a0,a0,850 # 80008748 <syscalls+0x320>
    800033fe:	00003097          	auipc	ra,0x3
    80003402:	91a080e7          	jalr	-1766(ra) # 80005d18 <panic>

0000000080003406 <namei>:

struct inode*
namei(char *path)
{
    80003406:	1101                	addi	sp,sp,-32
    80003408:	ec06                	sd	ra,24(sp)
    8000340a:	e822                	sd	s0,16(sp)
    8000340c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000340e:	fe040613          	addi	a2,s0,-32
    80003412:	4581                	li	a1,0
    80003414:	00000097          	auipc	ra,0x0
    80003418:	dd0080e7          	jalr	-560(ra) # 800031e4 <namex>
}
    8000341c:	60e2                	ld	ra,24(sp)
    8000341e:	6442                	ld	s0,16(sp)
    80003420:	6105                	addi	sp,sp,32
    80003422:	8082                	ret

0000000080003424 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003424:	1141                	addi	sp,sp,-16
    80003426:	e406                	sd	ra,8(sp)
    80003428:	e022                	sd	s0,0(sp)
    8000342a:	0800                	addi	s0,sp,16
    8000342c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000342e:	4585                	li	a1,1
    80003430:	00000097          	auipc	ra,0x0
    80003434:	db4080e7          	jalr	-588(ra) # 800031e4 <namex>
}
    80003438:	60a2                	ld	ra,8(sp)
    8000343a:	6402                	ld	s0,0(sp)
    8000343c:	0141                	addi	sp,sp,16
    8000343e:	8082                	ret

0000000080003440 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003440:	1101                	addi	sp,sp,-32
    80003442:	ec06                	sd	ra,24(sp)
    80003444:	e822                	sd	s0,16(sp)
    80003446:	e426                	sd	s1,8(sp)
    80003448:	e04a                	sd	s2,0(sp)
    8000344a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000344c:	00016917          	auipc	s2,0x16
    80003450:	dd490913          	addi	s2,s2,-556 # 80019220 <log>
    80003454:	01892583          	lw	a1,24(s2)
    80003458:	02892503          	lw	a0,40(s2)
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	ff2080e7          	jalr	-14(ra) # 8000244e <bread>
    80003464:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003466:	02c92683          	lw	a3,44(s2)
    8000346a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000346c:	02d05763          	blez	a3,8000349a <write_head+0x5a>
    80003470:	00016797          	auipc	a5,0x16
    80003474:	de078793          	addi	a5,a5,-544 # 80019250 <log+0x30>
    80003478:	05c50713          	addi	a4,a0,92
    8000347c:	36fd                	addiw	a3,a3,-1
    8000347e:	1682                	slli	a3,a3,0x20
    80003480:	9281                	srli	a3,a3,0x20
    80003482:	068a                	slli	a3,a3,0x2
    80003484:	00016617          	auipc	a2,0x16
    80003488:	dd060613          	addi	a2,a2,-560 # 80019254 <log+0x34>
    8000348c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000348e:	4390                	lw	a2,0(a5)
    80003490:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003492:	0791                	addi	a5,a5,4
    80003494:	0711                	addi	a4,a4,4
    80003496:	fed79ce3          	bne	a5,a3,8000348e <write_head+0x4e>
  }
  bwrite(buf);
    8000349a:	8526                	mv	a0,s1
    8000349c:	fffff097          	auipc	ra,0xfffff
    800034a0:	0a4080e7          	jalr	164(ra) # 80002540 <bwrite>
  brelse(buf);
    800034a4:	8526                	mv	a0,s1
    800034a6:	fffff097          	auipc	ra,0xfffff
    800034aa:	0d8080e7          	jalr	216(ra) # 8000257e <brelse>
}
    800034ae:	60e2                	ld	ra,24(sp)
    800034b0:	6442                	ld	s0,16(sp)
    800034b2:	64a2                	ld	s1,8(sp)
    800034b4:	6902                	ld	s2,0(sp)
    800034b6:	6105                	addi	sp,sp,32
    800034b8:	8082                	ret

00000000800034ba <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ba:	00016797          	auipc	a5,0x16
    800034be:	d927a783          	lw	a5,-622(a5) # 8001924c <log+0x2c>
    800034c2:	0af05d63          	blez	a5,8000357c <install_trans+0xc2>
{
    800034c6:	7139                	addi	sp,sp,-64
    800034c8:	fc06                	sd	ra,56(sp)
    800034ca:	f822                	sd	s0,48(sp)
    800034cc:	f426                	sd	s1,40(sp)
    800034ce:	f04a                	sd	s2,32(sp)
    800034d0:	ec4e                	sd	s3,24(sp)
    800034d2:	e852                	sd	s4,16(sp)
    800034d4:	e456                	sd	s5,8(sp)
    800034d6:	e05a                	sd	s6,0(sp)
    800034d8:	0080                	addi	s0,sp,64
    800034da:	8b2a                	mv	s6,a0
    800034dc:	00016a97          	auipc	s5,0x16
    800034e0:	d74a8a93          	addi	s5,s5,-652 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034e6:	00016997          	auipc	s3,0x16
    800034ea:	d3a98993          	addi	s3,s3,-710 # 80019220 <log>
    800034ee:	a035                	j	8000351a <install_trans+0x60>
      bunpin(dbuf);
    800034f0:	8526                	mv	a0,s1
    800034f2:	fffff097          	auipc	ra,0xfffff
    800034f6:	166080e7          	jalr	358(ra) # 80002658 <bunpin>
    brelse(lbuf);
    800034fa:	854a                	mv	a0,s2
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	082080e7          	jalr	130(ra) # 8000257e <brelse>
    brelse(dbuf);
    80003504:	8526                	mv	a0,s1
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	078080e7          	jalr	120(ra) # 8000257e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000350e:	2a05                	addiw	s4,s4,1
    80003510:	0a91                	addi	s5,s5,4
    80003512:	02c9a783          	lw	a5,44(s3)
    80003516:	04fa5963          	bge	s4,a5,80003568 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000351a:	0189a583          	lw	a1,24(s3)
    8000351e:	014585bb          	addw	a1,a1,s4
    80003522:	2585                	addiw	a1,a1,1
    80003524:	0289a503          	lw	a0,40(s3)
    80003528:	fffff097          	auipc	ra,0xfffff
    8000352c:	f26080e7          	jalr	-218(ra) # 8000244e <bread>
    80003530:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003532:	000aa583          	lw	a1,0(s5)
    80003536:	0289a503          	lw	a0,40(s3)
    8000353a:	fffff097          	auipc	ra,0xfffff
    8000353e:	f14080e7          	jalr	-236(ra) # 8000244e <bread>
    80003542:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003544:	40000613          	li	a2,1024
    80003548:	05890593          	addi	a1,s2,88
    8000354c:	05850513          	addi	a0,a0,88
    80003550:	ffffd097          	auipc	ra,0xffffd
    80003554:	c88080e7          	jalr	-888(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003558:	8526                	mv	a0,s1
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	fe6080e7          	jalr	-26(ra) # 80002540 <bwrite>
    if(recovering == 0)
    80003562:	f80b1ce3          	bnez	s6,800034fa <install_trans+0x40>
    80003566:	b769                	j	800034f0 <install_trans+0x36>
}
    80003568:	70e2                	ld	ra,56(sp)
    8000356a:	7442                	ld	s0,48(sp)
    8000356c:	74a2                	ld	s1,40(sp)
    8000356e:	7902                	ld	s2,32(sp)
    80003570:	69e2                	ld	s3,24(sp)
    80003572:	6a42                	ld	s4,16(sp)
    80003574:	6aa2                	ld	s5,8(sp)
    80003576:	6b02                	ld	s6,0(sp)
    80003578:	6121                	addi	sp,sp,64
    8000357a:	8082                	ret
    8000357c:	8082                	ret

000000008000357e <initlog>:
{
    8000357e:	7179                	addi	sp,sp,-48
    80003580:	f406                	sd	ra,40(sp)
    80003582:	f022                	sd	s0,32(sp)
    80003584:	ec26                	sd	s1,24(sp)
    80003586:	e84a                	sd	s2,16(sp)
    80003588:	e44e                	sd	s3,8(sp)
    8000358a:	1800                	addi	s0,sp,48
    8000358c:	892a                	mv	s2,a0
    8000358e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003590:	00016497          	auipc	s1,0x16
    80003594:	c9048493          	addi	s1,s1,-880 # 80019220 <log>
    80003598:	00005597          	auipc	a1,0x5
    8000359c:	0b058593          	addi	a1,a1,176 # 80008648 <syscalls+0x220>
    800035a0:	8526                	mv	a0,s1
    800035a2:	00003097          	auipc	ra,0x3
    800035a6:	c30080e7          	jalr	-976(ra) # 800061d2 <initlock>
  log.start = sb->logstart;
    800035aa:	0149a583          	lw	a1,20(s3)
    800035ae:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035b0:	0109a783          	lw	a5,16(s3)
    800035b4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035b6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035ba:	854a                	mv	a0,s2
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	e92080e7          	jalr	-366(ra) # 8000244e <bread>
  log.lh.n = lh->n;
    800035c4:	4d3c                	lw	a5,88(a0)
    800035c6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035c8:	02f05563          	blez	a5,800035f2 <initlog+0x74>
    800035cc:	05c50713          	addi	a4,a0,92
    800035d0:	00016697          	auipc	a3,0x16
    800035d4:	c8068693          	addi	a3,a3,-896 # 80019250 <log+0x30>
    800035d8:	37fd                	addiw	a5,a5,-1
    800035da:	1782                	slli	a5,a5,0x20
    800035dc:	9381                	srli	a5,a5,0x20
    800035de:	078a                	slli	a5,a5,0x2
    800035e0:	06050613          	addi	a2,a0,96
    800035e4:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035e6:	4310                	lw	a2,0(a4)
    800035e8:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035ea:	0711                	addi	a4,a4,4
    800035ec:	0691                	addi	a3,a3,4
    800035ee:	fef71ce3          	bne	a4,a5,800035e6 <initlog+0x68>
  brelse(buf);
    800035f2:	fffff097          	auipc	ra,0xfffff
    800035f6:	f8c080e7          	jalr	-116(ra) # 8000257e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035fa:	4505                	li	a0,1
    800035fc:	00000097          	auipc	ra,0x0
    80003600:	ebe080e7          	jalr	-322(ra) # 800034ba <install_trans>
  log.lh.n = 0;
    80003604:	00016797          	auipc	a5,0x16
    80003608:	c407a423          	sw	zero,-952(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    8000360c:	00000097          	auipc	ra,0x0
    80003610:	e34080e7          	jalr	-460(ra) # 80003440 <write_head>
}
    80003614:	70a2                	ld	ra,40(sp)
    80003616:	7402                	ld	s0,32(sp)
    80003618:	64e2                	ld	s1,24(sp)
    8000361a:	6942                	ld	s2,16(sp)
    8000361c:	69a2                	ld	s3,8(sp)
    8000361e:	6145                	addi	sp,sp,48
    80003620:	8082                	ret

0000000080003622 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003622:	1101                	addi	sp,sp,-32
    80003624:	ec06                	sd	ra,24(sp)
    80003626:	e822                	sd	s0,16(sp)
    80003628:	e426                	sd	s1,8(sp)
    8000362a:	e04a                	sd	s2,0(sp)
    8000362c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000362e:	00016517          	auipc	a0,0x16
    80003632:	bf250513          	addi	a0,a0,-1038 # 80019220 <log>
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	c2c080e7          	jalr	-980(ra) # 80006262 <acquire>
  while(1){
    if(log.committing){
    8000363e:	00016497          	auipc	s1,0x16
    80003642:	be248493          	addi	s1,s1,-1054 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003646:	4979                	li	s2,30
    80003648:	a039                	j	80003656 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000364a:	85a6                	mv	a1,s1
    8000364c:	8526                	mv	a0,s1
    8000364e:	ffffe097          	auipc	ra,0xffffe
    80003652:	092080e7          	jalr	146(ra) # 800016e0 <sleep>
    if(log.committing){
    80003656:	50dc                	lw	a5,36(s1)
    80003658:	fbed                	bnez	a5,8000364a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000365a:	509c                	lw	a5,32(s1)
    8000365c:	0017871b          	addiw	a4,a5,1
    80003660:	0007069b          	sext.w	a3,a4
    80003664:	0027179b          	slliw	a5,a4,0x2
    80003668:	9fb9                	addw	a5,a5,a4
    8000366a:	0017979b          	slliw	a5,a5,0x1
    8000366e:	54d8                	lw	a4,44(s1)
    80003670:	9fb9                	addw	a5,a5,a4
    80003672:	00f95963          	bge	s2,a5,80003684 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003676:	85a6                	mv	a1,s1
    80003678:	8526                	mv	a0,s1
    8000367a:	ffffe097          	auipc	ra,0xffffe
    8000367e:	066080e7          	jalr	102(ra) # 800016e0 <sleep>
    80003682:	bfd1                	j	80003656 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003684:	00016517          	auipc	a0,0x16
    80003688:	b9c50513          	addi	a0,a0,-1124 # 80019220 <log>
    8000368c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	c88080e7          	jalr	-888(ra) # 80006316 <release>
      break;
    }
  }
}
    80003696:	60e2                	ld	ra,24(sp)
    80003698:	6442                	ld	s0,16(sp)
    8000369a:	64a2                	ld	s1,8(sp)
    8000369c:	6902                	ld	s2,0(sp)
    8000369e:	6105                	addi	sp,sp,32
    800036a0:	8082                	ret

00000000800036a2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036a2:	7139                	addi	sp,sp,-64
    800036a4:	fc06                	sd	ra,56(sp)
    800036a6:	f822                	sd	s0,48(sp)
    800036a8:	f426                	sd	s1,40(sp)
    800036aa:	f04a                	sd	s2,32(sp)
    800036ac:	ec4e                	sd	s3,24(sp)
    800036ae:	e852                	sd	s4,16(sp)
    800036b0:	e456                	sd	s5,8(sp)
    800036b2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036b4:	00016497          	auipc	s1,0x16
    800036b8:	b6c48493          	addi	s1,s1,-1172 # 80019220 <log>
    800036bc:	8526                	mv	a0,s1
    800036be:	00003097          	auipc	ra,0x3
    800036c2:	ba4080e7          	jalr	-1116(ra) # 80006262 <acquire>
  log.outstanding -= 1;
    800036c6:	509c                	lw	a5,32(s1)
    800036c8:	37fd                	addiw	a5,a5,-1
    800036ca:	0007891b          	sext.w	s2,a5
    800036ce:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036d0:	50dc                	lw	a5,36(s1)
    800036d2:	efb9                	bnez	a5,80003730 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036d4:	06091663          	bnez	s2,80003740 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036d8:	00016497          	auipc	s1,0x16
    800036dc:	b4848493          	addi	s1,s1,-1208 # 80019220 <log>
    800036e0:	4785                	li	a5,1
    800036e2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036e4:	8526                	mv	a0,s1
    800036e6:	00003097          	auipc	ra,0x3
    800036ea:	c30080e7          	jalr	-976(ra) # 80006316 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036ee:	54dc                	lw	a5,44(s1)
    800036f0:	06f04763          	bgtz	a5,8000375e <end_op+0xbc>
    acquire(&log.lock);
    800036f4:	00016497          	auipc	s1,0x16
    800036f8:	b2c48493          	addi	s1,s1,-1236 # 80019220 <log>
    800036fc:	8526                	mv	a0,s1
    800036fe:	00003097          	auipc	ra,0x3
    80003702:	b64080e7          	jalr	-1180(ra) # 80006262 <acquire>
    log.committing = 0;
    80003706:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000370a:	8526                	mv	a0,s1
    8000370c:	ffffe097          	auipc	ra,0xffffe
    80003710:	160080e7          	jalr	352(ra) # 8000186c <wakeup>
    release(&log.lock);
    80003714:	8526                	mv	a0,s1
    80003716:	00003097          	auipc	ra,0x3
    8000371a:	c00080e7          	jalr	-1024(ra) # 80006316 <release>
}
    8000371e:	70e2                	ld	ra,56(sp)
    80003720:	7442                	ld	s0,48(sp)
    80003722:	74a2                	ld	s1,40(sp)
    80003724:	7902                	ld	s2,32(sp)
    80003726:	69e2                	ld	s3,24(sp)
    80003728:	6a42                	ld	s4,16(sp)
    8000372a:	6aa2                	ld	s5,8(sp)
    8000372c:	6121                	addi	sp,sp,64
    8000372e:	8082                	ret
    panic("log.committing");
    80003730:	00005517          	auipc	a0,0x5
    80003734:	f2050513          	addi	a0,a0,-224 # 80008650 <syscalls+0x228>
    80003738:	00002097          	auipc	ra,0x2
    8000373c:	5e0080e7          	jalr	1504(ra) # 80005d18 <panic>
    wakeup(&log);
    80003740:	00016497          	auipc	s1,0x16
    80003744:	ae048493          	addi	s1,s1,-1312 # 80019220 <log>
    80003748:	8526                	mv	a0,s1
    8000374a:	ffffe097          	auipc	ra,0xffffe
    8000374e:	122080e7          	jalr	290(ra) # 8000186c <wakeup>
  release(&log.lock);
    80003752:	8526                	mv	a0,s1
    80003754:	00003097          	auipc	ra,0x3
    80003758:	bc2080e7          	jalr	-1086(ra) # 80006316 <release>
  if(do_commit){
    8000375c:	b7c9                	j	8000371e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375e:	00016a97          	auipc	s5,0x16
    80003762:	af2a8a93          	addi	s5,s5,-1294 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003766:	00016a17          	auipc	s4,0x16
    8000376a:	abaa0a13          	addi	s4,s4,-1350 # 80019220 <log>
    8000376e:	018a2583          	lw	a1,24(s4)
    80003772:	012585bb          	addw	a1,a1,s2
    80003776:	2585                	addiw	a1,a1,1
    80003778:	028a2503          	lw	a0,40(s4)
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	cd2080e7          	jalr	-814(ra) # 8000244e <bread>
    80003784:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003786:	000aa583          	lw	a1,0(s5)
    8000378a:	028a2503          	lw	a0,40(s4)
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	cc0080e7          	jalr	-832(ra) # 8000244e <bread>
    80003796:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003798:	40000613          	li	a2,1024
    8000379c:	05850593          	addi	a1,a0,88
    800037a0:	05848513          	addi	a0,s1,88
    800037a4:	ffffd097          	auipc	ra,0xffffd
    800037a8:	a34080e7          	jalr	-1484(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800037ac:	8526                	mv	a0,s1
    800037ae:	fffff097          	auipc	ra,0xfffff
    800037b2:	d92080e7          	jalr	-622(ra) # 80002540 <bwrite>
    brelse(from);
    800037b6:	854e                	mv	a0,s3
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	dc6080e7          	jalr	-570(ra) # 8000257e <brelse>
    brelse(to);
    800037c0:	8526                	mv	a0,s1
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	dbc080e7          	jalr	-580(ra) # 8000257e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ca:	2905                	addiw	s2,s2,1
    800037cc:	0a91                	addi	s5,s5,4
    800037ce:	02ca2783          	lw	a5,44(s4)
    800037d2:	f8f94ee3          	blt	s2,a5,8000376e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037d6:	00000097          	auipc	ra,0x0
    800037da:	c6a080e7          	jalr	-918(ra) # 80003440 <write_head>
    install_trans(0); // Now install writes to home locations
    800037de:	4501                	li	a0,0
    800037e0:	00000097          	auipc	ra,0x0
    800037e4:	cda080e7          	jalr	-806(ra) # 800034ba <install_trans>
    log.lh.n = 0;
    800037e8:	00016797          	auipc	a5,0x16
    800037ec:	a607a223          	sw	zero,-1436(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037f0:	00000097          	auipc	ra,0x0
    800037f4:	c50080e7          	jalr	-944(ra) # 80003440 <write_head>
    800037f8:	bdf5                	j	800036f4 <end_op+0x52>

00000000800037fa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037fa:	1101                	addi	sp,sp,-32
    800037fc:	ec06                	sd	ra,24(sp)
    800037fe:	e822                	sd	s0,16(sp)
    80003800:	e426                	sd	s1,8(sp)
    80003802:	e04a                	sd	s2,0(sp)
    80003804:	1000                	addi	s0,sp,32
    80003806:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003808:	00016917          	auipc	s2,0x16
    8000380c:	a1890913          	addi	s2,s2,-1512 # 80019220 <log>
    80003810:	854a                	mv	a0,s2
    80003812:	00003097          	auipc	ra,0x3
    80003816:	a50080e7          	jalr	-1456(ra) # 80006262 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000381a:	02c92603          	lw	a2,44(s2)
    8000381e:	47f5                	li	a5,29
    80003820:	06c7c563          	blt	a5,a2,8000388a <log_write+0x90>
    80003824:	00016797          	auipc	a5,0x16
    80003828:	a187a783          	lw	a5,-1512(a5) # 8001923c <log+0x1c>
    8000382c:	37fd                	addiw	a5,a5,-1
    8000382e:	04f65e63          	bge	a2,a5,8000388a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003832:	00016797          	auipc	a5,0x16
    80003836:	a0e7a783          	lw	a5,-1522(a5) # 80019240 <log+0x20>
    8000383a:	06f05063          	blez	a5,8000389a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000383e:	4781                	li	a5,0
    80003840:	06c05563          	blez	a2,800038aa <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003844:	44cc                	lw	a1,12(s1)
    80003846:	00016717          	auipc	a4,0x16
    8000384a:	a0a70713          	addi	a4,a4,-1526 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000384e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003850:	4314                	lw	a3,0(a4)
    80003852:	04b68c63          	beq	a3,a1,800038aa <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003856:	2785                	addiw	a5,a5,1
    80003858:	0711                	addi	a4,a4,4
    8000385a:	fef61be3          	bne	a2,a5,80003850 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000385e:	0621                	addi	a2,a2,8
    80003860:	060a                	slli	a2,a2,0x2
    80003862:	00016797          	auipc	a5,0x16
    80003866:	9be78793          	addi	a5,a5,-1602 # 80019220 <log>
    8000386a:	963e                	add	a2,a2,a5
    8000386c:	44dc                	lw	a5,12(s1)
    8000386e:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003870:	8526                	mv	a0,s1
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	daa080e7          	jalr	-598(ra) # 8000261c <bpin>
    log.lh.n++;
    8000387a:	00016717          	auipc	a4,0x16
    8000387e:	9a670713          	addi	a4,a4,-1626 # 80019220 <log>
    80003882:	575c                	lw	a5,44(a4)
    80003884:	2785                	addiw	a5,a5,1
    80003886:	d75c                	sw	a5,44(a4)
    80003888:	a835                	j	800038c4 <log_write+0xca>
    panic("too big a transaction");
    8000388a:	00005517          	auipc	a0,0x5
    8000388e:	dd650513          	addi	a0,a0,-554 # 80008660 <syscalls+0x238>
    80003892:	00002097          	auipc	ra,0x2
    80003896:	486080e7          	jalr	1158(ra) # 80005d18 <panic>
    panic("log_write outside of trans");
    8000389a:	00005517          	auipc	a0,0x5
    8000389e:	dde50513          	addi	a0,a0,-546 # 80008678 <syscalls+0x250>
    800038a2:	00002097          	auipc	ra,0x2
    800038a6:	476080e7          	jalr	1142(ra) # 80005d18 <panic>
  log.lh.block[i] = b->blockno;
    800038aa:	00878713          	addi	a4,a5,8
    800038ae:	00271693          	slli	a3,a4,0x2
    800038b2:	00016717          	auipc	a4,0x16
    800038b6:	96e70713          	addi	a4,a4,-1682 # 80019220 <log>
    800038ba:	9736                	add	a4,a4,a3
    800038bc:	44d4                	lw	a3,12(s1)
    800038be:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038c0:	faf608e3          	beq	a2,a5,80003870 <log_write+0x76>
  }
  release(&log.lock);
    800038c4:	00016517          	auipc	a0,0x16
    800038c8:	95c50513          	addi	a0,a0,-1700 # 80019220 <log>
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	a4a080e7          	jalr	-1462(ra) # 80006316 <release>
}
    800038d4:	60e2                	ld	ra,24(sp)
    800038d6:	6442                	ld	s0,16(sp)
    800038d8:	64a2                	ld	s1,8(sp)
    800038da:	6902                	ld	s2,0(sp)
    800038dc:	6105                	addi	sp,sp,32
    800038de:	8082                	ret

00000000800038e0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038e0:	1101                	addi	sp,sp,-32
    800038e2:	ec06                	sd	ra,24(sp)
    800038e4:	e822                	sd	s0,16(sp)
    800038e6:	e426                	sd	s1,8(sp)
    800038e8:	e04a                	sd	s2,0(sp)
    800038ea:	1000                	addi	s0,sp,32
    800038ec:	84aa                	mv	s1,a0
    800038ee:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038f0:	00005597          	auipc	a1,0x5
    800038f4:	da858593          	addi	a1,a1,-600 # 80008698 <syscalls+0x270>
    800038f8:	0521                	addi	a0,a0,8
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	8d8080e7          	jalr	-1832(ra) # 800061d2 <initlock>
  lk->name = name;
    80003902:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003906:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000390a:	0204a423          	sw	zero,40(s1)
}
    8000390e:	60e2                	ld	ra,24(sp)
    80003910:	6442                	ld	s0,16(sp)
    80003912:	64a2                	ld	s1,8(sp)
    80003914:	6902                	ld	s2,0(sp)
    80003916:	6105                	addi	sp,sp,32
    80003918:	8082                	ret

000000008000391a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000391a:	1101                	addi	sp,sp,-32
    8000391c:	ec06                	sd	ra,24(sp)
    8000391e:	e822                	sd	s0,16(sp)
    80003920:	e426                	sd	s1,8(sp)
    80003922:	e04a                	sd	s2,0(sp)
    80003924:	1000                	addi	s0,sp,32
    80003926:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003928:	00850913          	addi	s2,a0,8
    8000392c:	854a                	mv	a0,s2
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	934080e7          	jalr	-1740(ra) # 80006262 <acquire>
  while (lk->locked) {
    80003936:	409c                	lw	a5,0(s1)
    80003938:	cb89                	beqz	a5,8000394a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000393a:	85ca                	mv	a1,s2
    8000393c:	8526                	mv	a0,s1
    8000393e:	ffffe097          	auipc	ra,0xffffe
    80003942:	da2080e7          	jalr	-606(ra) # 800016e0 <sleep>
  while (lk->locked) {
    80003946:	409c                	lw	a5,0(s1)
    80003948:	fbed                	bnez	a5,8000393a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000394a:	4785                	li	a5,1
    8000394c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000394e:	ffffd097          	auipc	ra,0xffffd
    80003952:	626080e7          	jalr	1574(ra) # 80000f74 <myproc>
    80003956:	591c                	lw	a5,48(a0)
    80003958:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000395a:	854a                	mv	a0,s2
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	9ba080e7          	jalr	-1606(ra) # 80006316 <release>
}
    80003964:	60e2                	ld	ra,24(sp)
    80003966:	6442                	ld	s0,16(sp)
    80003968:	64a2                	ld	s1,8(sp)
    8000396a:	6902                	ld	s2,0(sp)
    8000396c:	6105                	addi	sp,sp,32
    8000396e:	8082                	ret

0000000080003970 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003970:	1101                	addi	sp,sp,-32
    80003972:	ec06                	sd	ra,24(sp)
    80003974:	e822                	sd	s0,16(sp)
    80003976:	e426                	sd	s1,8(sp)
    80003978:	e04a                	sd	s2,0(sp)
    8000397a:	1000                	addi	s0,sp,32
    8000397c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000397e:	00850913          	addi	s2,a0,8
    80003982:	854a                	mv	a0,s2
    80003984:	00003097          	auipc	ra,0x3
    80003988:	8de080e7          	jalr	-1826(ra) # 80006262 <acquire>
  lk->locked = 0;
    8000398c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003990:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003994:	8526                	mv	a0,s1
    80003996:	ffffe097          	auipc	ra,0xffffe
    8000399a:	ed6080e7          	jalr	-298(ra) # 8000186c <wakeup>
  release(&lk->lk);
    8000399e:	854a                	mv	a0,s2
    800039a0:	00003097          	auipc	ra,0x3
    800039a4:	976080e7          	jalr	-1674(ra) # 80006316 <release>
}
    800039a8:	60e2                	ld	ra,24(sp)
    800039aa:	6442                	ld	s0,16(sp)
    800039ac:	64a2                	ld	s1,8(sp)
    800039ae:	6902                	ld	s2,0(sp)
    800039b0:	6105                	addi	sp,sp,32
    800039b2:	8082                	ret

00000000800039b4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039b4:	7179                	addi	sp,sp,-48
    800039b6:	f406                	sd	ra,40(sp)
    800039b8:	f022                	sd	s0,32(sp)
    800039ba:	ec26                	sd	s1,24(sp)
    800039bc:	e84a                	sd	s2,16(sp)
    800039be:	e44e                	sd	s3,8(sp)
    800039c0:	1800                	addi	s0,sp,48
    800039c2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039c4:	00850913          	addi	s2,a0,8
    800039c8:	854a                	mv	a0,s2
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	898080e7          	jalr	-1896(ra) # 80006262 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039d2:	409c                	lw	a5,0(s1)
    800039d4:	ef99                	bnez	a5,800039f2 <holdingsleep+0x3e>
    800039d6:	4481                	li	s1,0
  release(&lk->lk);
    800039d8:	854a                	mv	a0,s2
    800039da:	00003097          	auipc	ra,0x3
    800039de:	93c080e7          	jalr	-1732(ra) # 80006316 <release>
  return r;
}
    800039e2:	8526                	mv	a0,s1
    800039e4:	70a2                	ld	ra,40(sp)
    800039e6:	7402                	ld	s0,32(sp)
    800039e8:	64e2                	ld	s1,24(sp)
    800039ea:	6942                	ld	s2,16(sp)
    800039ec:	69a2                	ld	s3,8(sp)
    800039ee:	6145                	addi	sp,sp,48
    800039f0:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039f2:	0284a983          	lw	s3,40(s1)
    800039f6:	ffffd097          	auipc	ra,0xffffd
    800039fa:	57e080e7          	jalr	1406(ra) # 80000f74 <myproc>
    800039fe:	5904                	lw	s1,48(a0)
    80003a00:	413484b3          	sub	s1,s1,s3
    80003a04:	0014b493          	seqz	s1,s1
    80003a08:	bfc1                	j	800039d8 <holdingsleep+0x24>

0000000080003a0a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a0a:	1141                	addi	sp,sp,-16
    80003a0c:	e406                	sd	ra,8(sp)
    80003a0e:	e022                	sd	s0,0(sp)
    80003a10:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a12:	00005597          	auipc	a1,0x5
    80003a16:	c9658593          	addi	a1,a1,-874 # 800086a8 <syscalls+0x280>
    80003a1a:	00016517          	auipc	a0,0x16
    80003a1e:	94e50513          	addi	a0,a0,-1714 # 80019368 <ftable>
    80003a22:	00002097          	auipc	ra,0x2
    80003a26:	7b0080e7          	jalr	1968(ra) # 800061d2 <initlock>
}
    80003a2a:	60a2                	ld	ra,8(sp)
    80003a2c:	6402                	ld	s0,0(sp)
    80003a2e:	0141                	addi	sp,sp,16
    80003a30:	8082                	ret

0000000080003a32 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a3c:	00016517          	auipc	a0,0x16
    80003a40:	92c50513          	addi	a0,a0,-1748 # 80019368 <ftable>
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	81e080e7          	jalr	-2018(ra) # 80006262 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a4c:	00016497          	auipc	s1,0x16
    80003a50:	93448493          	addi	s1,s1,-1740 # 80019380 <ftable+0x18>
    80003a54:	00017717          	auipc	a4,0x17
    80003a58:	8cc70713          	addi	a4,a4,-1844 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003a5c:	40dc                	lw	a5,4(s1)
    80003a5e:	cf99                	beqz	a5,80003a7c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a60:	02848493          	addi	s1,s1,40
    80003a64:	fee49ce3          	bne	s1,a4,80003a5c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a68:	00016517          	auipc	a0,0x16
    80003a6c:	90050513          	addi	a0,a0,-1792 # 80019368 <ftable>
    80003a70:	00003097          	auipc	ra,0x3
    80003a74:	8a6080e7          	jalr	-1882(ra) # 80006316 <release>
  return 0;
    80003a78:	4481                	li	s1,0
    80003a7a:	a819                	j	80003a90 <filealloc+0x5e>
      f->ref = 1;
    80003a7c:	4785                	li	a5,1
    80003a7e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a80:	00016517          	auipc	a0,0x16
    80003a84:	8e850513          	addi	a0,a0,-1816 # 80019368 <ftable>
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	88e080e7          	jalr	-1906(ra) # 80006316 <release>
}
    80003a90:	8526                	mv	a0,s1
    80003a92:	60e2                	ld	ra,24(sp)
    80003a94:	6442                	ld	s0,16(sp)
    80003a96:	64a2                	ld	s1,8(sp)
    80003a98:	6105                	addi	sp,sp,32
    80003a9a:	8082                	ret

0000000080003a9c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a9c:	1101                	addi	sp,sp,-32
    80003a9e:	ec06                	sd	ra,24(sp)
    80003aa0:	e822                	sd	s0,16(sp)
    80003aa2:	e426                	sd	s1,8(sp)
    80003aa4:	1000                	addi	s0,sp,32
    80003aa6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aa8:	00016517          	auipc	a0,0x16
    80003aac:	8c050513          	addi	a0,a0,-1856 # 80019368 <ftable>
    80003ab0:	00002097          	auipc	ra,0x2
    80003ab4:	7b2080e7          	jalr	1970(ra) # 80006262 <acquire>
  if(f->ref < 1)
    80003ab8:	40dc                	lw	a5,4(s1)
    80003aba:	02f05263          	blez	a5,80003ade <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003abe:	2785                	addiw	a5,a5,1
    80003ac0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ac2:	00016517          	auipc	a0,0x16
    80003ac6:	8a650513          	addi	a0,a0,-1882 # 80019368 <ftable>
    80003aca:	00003097          	auipc	ra,0x3
    80003ace:	84c080e7          	jalr	-1972(ra) # 80006316 <release>
  return f;
}
    80003ad2:	8526                	mv	a0,s1
    80003ad4:	60e2                	ld	ra,24(sp)
    80003ad6:	6442                	ld	s0,16(sp)
    80003ad8:	64a2                	ld	s1,8(sp)
    80003ada:	6105                	addi	sp,sp,32
    80003adc:	8082                	ret
    panic("filedup");
    80003ade:	00005517          	auipc	a0,0x5
    80003ae2:	bd250513          	addi	a0,a0,-1070 # 800086b0 <syscalls+0x288>
    80003ae6:	00002097          	auipc	ra,0x2
    80003aea:	232080e7          	jalr	562(ra) # 80005d18 <panic>

0000000080003aee <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003aee:	7139                	addi	sp,sp,-64
    80003af0:	fc06                	sd	ra,56(sp)
    80003af2:	f822                	sd	s0,48(sp)
    80003af4:	f426                	sd	s1,40(sp)
    80003af6:	f04a                	sd	s2,32(sp)
    80003af8:	ec4e                	sd	s3,24(sp)
    80003afa:	e852                	sd	s4,16(sp)
    80003afc:	e456                	sd	s5,8(sp)
    80003afe:	0080                	addi	s0,sp,64
    80003b00:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b02:	00016517          	auipc	a0,0x16
    80003b06:	86650513          	addi	a0,a0,-1946 # 80019368 <ftable>
    80003b0a:	00002097          	auipc	ra,0x2
    80003b0e:	758080e7          	jalr	1880(ra) # 80006262 <acquire>
  if(f->ref < 1)
    80003b12:	40dc                	lw	a5,4(s1)
    80003b14:	06f05163          	blez	a5,80003b76 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b18:	37fd                	addiw	a5,a5,-1
    80003b1a:	0007871b          	sext.w	a4,a5
    80003b1e:	c0dc                	sw	a5,4(s1)
    80003b20:	06e04363          	bgtz	a4,80003b86 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b24:	0004a903          	lw	s2,0(s1)
    80003b28:	0094ca83          	lbu	s5,9(s1)
    80003b2c:	0104ba03          	ld	s4,16(s1)
    80003b30:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b34:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b38:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b3c:	00016517          	auipc	a0,0x16
    80003b40:	82c50513          	addi	a0,a0,-2004 # 80019368 <ftable>
    80003b44:	00002097          	auipc	ra,0x2
    80003b48:	7d2080e7          	jalr	2002(ra) # 80006316 <release>

  if(ff.type == FD_PIPE){
    80003b4c:	4785                	li	a5,1
    80003b4e:	04f90d63          	beq	s2,a5,80003ba8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b52:	3979                	addiw	s2,s2,-2
    80003b54:	4785                	li	a5,1
    80003b56:	0527e063          	bltu	a5,s2,80003b96 <fileclose+0xa8>
    begin_op();
    80003b5a:	00000097          	auipc	ra,0x0
    80003b5e:	ac8080e7          	jalr	-1336(ra) # 80003622 <begin_op>
    iput(ff.ip);
    80003b62:	854e                	mv	a0,s3
    80003b64:	fffff097          	auipc	ra,0xfffff
    80003b68:	2a6080e7          	jalr	678(ra) # 80002e0a <iput>
    end_op();
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	b36080e7          	jalr	-1226(ra) # 800036a2 <end_op>
    80003b74:	a00d                	j	80003b96 <fileclose+0xa8>
    panic("fileclose");
    80003b76:	00005517          	auipc	a0,0x5
    80003b7a:	b4250513          	addi	a0,a0,-1214 # 800086b8 <syscalls+0x290>
    80003b7e:	00002097          	auipc	ra,0x2
    80003b82:	19a080e7          	jalr	410(ra) # 80005d18 <panic>
    release(&ftable.lock);
    80003b86:	00015517          	auipc	a0,0x15
    80003b8a:	7e250513          	addi	a0,a0,2018 # 80019368 <ftable>
    80003b8e:	00002097          	auipc	ra,0x2
    80003b92:	788080e7          	jalr	1928(ra) # 80006316 <release>
  }
}
    80003b96:	70e2                	ld	ra,56(sp)
    80003b98:	7442                	ld	s0,48(sp)
    80003b9a:	74a2                	ld	s1,40(sp)
    80003b9c:	7902                	ld	s2,32(sp)
    80003b9e:	69e2                	ld	s3,24(sp)
    80003ba0:	6a42                	ld	s4,16(sp)
    80003ba2:	6aa2                	ld	s5,8(sp)
    80003ba4:	6121                	addi	sp,sp,64
    80003ba6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ba8:	85d6                	mv	a1,s5
    80003baa:	8552                	mv	a0,s4
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	34c080e7          	jalr	844(ra) # 80003ef8 <pipeclose>
    80003bb4:	b7cd                	j	80003b96 <fileclose+0xa8>

0000000080003bb6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bb6:	715d                	addi	sp,sp,-80
    80003bb8:	e486                	sd	ra,72(sp)
    80003bba:	e0a2                	sd	s0,64(sp)
    80003bbc:	fc26                	sd	s1,56(sp)
    80003bbe:	f84a                	sd	s2,48(sp)
    80003bc0:	f44e                	sd	s3,40(sp)
    80003bc2:	0880                	addi	s0,sp,80
    80003bc4:	84aa                	mv	s1,a0
    80003bc6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bc8:	ffffd097          	auipc	ra,0xffffd
    80003bcc:	3ac080e7          	jalr	940(ra) # 80000f74 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bd0:	409c                	lw	a5,0(s1)
    80003bd2:	37f9                	addiw	a5,a5,-2
    80003bd4:	4705                	li	a4,1
    80003bd6:	04f76763          	bltu	a4,a5,80003c24 <filestat+0x6e>
    80003bda:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bdc:	6c88                	ld	a0,24(s1)
    80003bde:	fffff097          	auipc	ra,0xfffff
    80003be2:	072080e7          	jalr	114(ra) # 80002c50 <ilock>
    stati(f->ip, &st);
    80003be6:	fb840593          	addi	a1,s0,-72
    80003bea:	6c88                	ld	a0,24(s1)
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	2ee080e7          	jalr	750(ra) # 80002eda <stati>
    iunlock(f->ip);
    80003bf4:	6c88                	ld	a0,24(s1)
    80003bf6:	fffff097          	auipc	ra,0xfffff
    80003bfa:	11c080e7          	jalr	284(ra) # 80002d12 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bfe:	46e1                	li	a3,24
    80003c00:	fb840613          	addi	a2,s0,-72
    80003c04:	85ce                	mv	a1,s3
    80003c06:	05093503          	ld	a0,80(s2)
    80003c0a:	ffffd097          	auipc	ra,0xffffd
    80003c0e:	f00080e7          	jalr	-256(ra) # 80000b0a <copyout>
    80003c12:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c16:	60a6                	ld	ra,72(sp)
    80003c18:	6406                	ld	s0,64(sp)
    80003c1a:	74e2                	ld	s1,56(sp)
    80003c1c:	7942                	ld	s2,48(sp)
    80003c1e:	79a2                	ld	s3,40(sp)
    80003c20:	6161                	addi	sp,sp,80
    80003c22:	8082                	ret
  return -1;
    80003c24:	557d                	li	a0,-1
    80003c26:	bfc5                	j	80003c16 <filestat+0x60>

0000000080003c28 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c28:	7179                	addi	sp,sp,-48
    80003c2a:	f406                	sd	ra,40(sp)
    80003c2c:	f022                	sd	s0,32(sp)
    80003c2e:	ec26                	sd	s1,24(sp)
    80003c30:	e84a                	sd	s2,16(sp)
    80003c32:	e44e                	sd	s3,8(sp)
    80003c34:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c36:	00854783          	lbu	a5,8(a0)
    80003c3a:	c3d5                	beqz	a5,80003cde <fileread+0xb6>
    80003c3c:	84aa                	mv	s1,a0
    80003c3e:	89ae                	mv	s3,a1
    80003c40:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c42:	411c                	lw	a5,0(a0)
    80003c44:	4705                	li	a4,1
    80003c46:	04e78963          	beq	a5,a4,80003c98 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c4a:	470d                	li	a4,3
    80003c4c:	04e78d63          	beq	a5,a4,80003ca6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c50:	4709                	li	a4,2
    80003c52:	06e79e63          	bne	a5,a4,80003cce <fileread+0xa6>
    ilock(f->ip);
    80003c56:	6d08                	ld	a0,24(a0)
    80003c58:	fffff097          	auipc	ra,0xfffff
    80003c5c:	ff8080e7          	jalr	-8(ra) # 80002c50 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c60:	874a                	mv	a4,s2
    80003c62:	5094                	lw	a3,32(s1)
    80003c64:	864e                	mv	a2,s3
    80003c66:	4585                	li	a1,1
    80003c68:	6c88                	ld	a0,24(s1)
    80003c6a:	fffff097          	auipc	ra,0xfffff
    80003c6e:	29a080e7          	jalr	666(ra) # 80002f04 <readi>
    80003c72:	892a                	mv	s2,a0
    80003c74:	00a05563          	blez	a0,80003c7e <fileread+0x56>
      f->off += r;
    80003c78:	509c                	lw	a5,32(s1)
    80003c7a:	9fa9                	addw	a5,a5,a0
    80003c7c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c7e:	6c88                	ld	a0,24(s1)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	092080e7          	jalr	146(ra) # 80002d12 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c88:	854a                	mv	a0,s2
    80003c8a:	70a2                	ld	ra,40(sp)
    80003c8c:	7402                	ld	s0,32(sp)
    80003c8e:	64e2                	ld	s1,24(sp)
    80003c90:	6942                	ld	s2,16(sp)
    80003c92:	69a2                	ld	s3,8(sp)
    80003c94:	6145                	addi	sp,sp,48
    80003c96:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c98:	6908                	ld	a0,16(a0)
    80003c9a:	00000097          	auipc	ra,0x0
    80003c9e:	3c8080e7          	jalr	968(ra) # 80004062 <piperead>
    80003ca2:	892a                	mv	s2,a0
    80003ca4:	b7d5                	j	80003c88 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ca6:	02451783          	lh	a5,36(a0)
    80003caa:	03079693          	slli	a3,a5,0x30
    80003cae:	92c1                	srli	a3,a3,0x30
    80003cb0:	4725                	li	a4,9
    80003cb2:	02d76863          	bltu	a4,a3,80003ce2 <fileread+0xba>
    80003cb6:	0792                	slli	a5,a5,0x4
    80003cb8:	00015717          	auipc	a4,0x15
    80003cbc:	61070713          	addi	a4,a4,1552 # 800192c8 <devsw>
    80003cc0:	97ba                	add	a5,a5,a4
    80003cc2:	639c                	ld	a5,0(a5)
    80003cc4:	c38d                	beqz	a5,80003ce6 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cc6:	4505                	li	a0,1
    80003cc8:	9782                	jalr	a5
    80003cca:	892a                	mv	s2,a0
    80003ccc:	bf75                	j	80003c88 <fileread+0x60>
    panic("fileread");
    80003cce:	00005517          	auipc	a0,0x5
    80003cd2:	9fa50513          	addi	a0,a0,-1542 # 800086c8 <syscalls+0x2a0>
    80003cd6:	00002097          	auipc	ra,0x2
    80003cda:	042080e7          	jalr	66(ra) # 80005d18 <panic>
    return -1;
    80003cde:	597d                	li	s2,-1
    80003ce0:	b765                	j	80003c88 <fileread+0x60>
      return -1;
    80003ce2:	597d                	li	s2,-1
    80003ce4:	b755                	j	80003c88 <fileread+0x60>
    80003ce6:	597d                	li	s2,-1
    80003ce8:	b745                	j	80003c88 <fileread+0x60>

0000000080003cea <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cea:	715d                	addi	sp,sp,-80
    80003cec:	e486                	sd	ra,72(sp)
    80003cee:	e0a2                	sd	s0,64(sp)
    80003cf0:	fc26                	sd	s1,56(sp)
    80003cf2:	f84a                	sd	s2,48(sp)
    80003cf4:	f44e                	sd	s3,40(sp)
    80003cf6:	f052                	sd	s4,32(sp)
    80003cf8:	ec56                	sd	s5,24(sp)
    80003cfa:	e85a                	sd	s6,16(sp)
    80003cfc:	e45e                	sd	s7,8(sp)
    80003cfe:	e062                	sd	s8,0(sp)
    80003d00:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d02:	00954783          	lbu	a5,9(a0)
    80003d06:	10078663          	beqz	a5,80003e12 <filewrite+0x128>
    80003d0a:	892a                	mv	s2,a0
    80003d0c:	8aae                	mv	s5,a1
    80003d0e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d10:	411c                	lw	a5,0(a0)
    80003d12:	4705                	li	a4,1
    80003d14:	02e78263          	beq	a5,a4,80003d38 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d18:	470d                	li	a4,3
    80003d1a:	02e78663          	beq	a5,a4,80003d46 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d1e:	4709                	li	a4,2
    80003d20:	0ee79163          	bne	a5,a4,80003e02 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d24:	0ac05d63          	blez	a2,80003dde <filewrite+0xf4>
    int i = 0;
    80003d28:	4981                	li	s3,0
    80003d2a:	6b05                	lui	s6,0x1
    80003d2c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d30:	6b85                	lui	s7,0x1
    80003d32:	c00b8b9b          	addiw	s7,s7,-1024
    80003d36:	a861                	j	80003dce <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d38:	6908                	ld	a0,16(a0)
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	22e080e7          	jalr	558(ra) # 80003f68 <pipewrite>
    80003d42:	8a2a                	mv	s4,a0
    80003d44:	a045                	j	80003de4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d46:	02451783          	lh	a5,36(a0)
    80003d4a:	03079693          	slli	a3,a5,0x30
    80003d4e:	92c1                	srli	a3,a3,0x30
    80003d50:	4725                	li	a4,9
    80003d52:	0cd76263          	bltu	a4,a3,80003e16 <filewrite+0x12c>
    80003d56:	0792                	slli	a5,a5,0x4
    80003d58:	00015717          	auipc	a4,0x15
    80003d5c:	57070713          	addi	a4,a4,1392 # 800192c8 <devsw>
    80003d60:	97ba                	add	a5,a5,a4
    80003d62:	679c                	ld	a5,8(a5)
    80003d64:	cbdd                	beqz	a5,80003e1a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d66:	4505                	li	a0,1
    80003d68:	9782                	jalr	a5
    80003d6a:	8a2a                	mv	s4,a0
    80003d6c:	a8a5                	j	80003de4 <filewrite+0xfa>
    80003d6e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d72:	00000097          	auipc	ra,0x0
    80003d76:	8b0080e7          	jalr	-1872(ra) # 80003622 <begin_op>
      ilock(f->ip);
    80003d7a:	01893503          	ld	a0,24(s2)
    80003d7e:	fffff097          	auipc	ra,0xfffff
    80003d82:	ed2080e7          	jalr	-302(ra) # 80002c50 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d86:	8762                	mv	a4,s8
    80003d88:	02092683          	lw	a3,32(s2)
    80003d8c:	01598633          	add	a2,s3,s5
    80003d90:	4585                	li	a1,1
    80003d92:	01893503          	ld	a0,24(s2)
    80003d96:	fffff097          	auipc	ra,0xfffff
    80003d9a:	266080e7          	jalr	614(ra) # 80002ffc <writei>
    80003d9e:	84aa                	mv	s1,a0
    80003da0:	00a05763          	blez	a0,80003dae <filewrite+0xc4>
        f->off += r;
    80003da4:	02092783          	lw	a5,32(s2)
    80003da8:	9fa9                	addw	a5,a5,a0
    80003daa:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dae:	01893503          	ld	a0,24(s2)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	f60080e7          	jalr	-160(ra) # 80002d12 <iunlock>
      end_op();
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	8e8080e7          	jalr	-1816(ra) # 800036a2 <end_op>

      if(r != n1){
    80003dc2:	009c1f63          	bne	s8,s1,80003de0 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dc6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dca:	0149db63          	bge	s3,s4,80003de0 <filewrite+0xf6>
      int n1 = n - i;
    80003dce:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dd2:	84be                	mv	s1,a5
    80003dd4:	2781                	sext.w	a5,a5
    80003dd6:	f8fb5ce3          	bge	s6,a5,80003d6e <filewrite+0x84>
    80003dda:	84de                	mv	s1,s7
    80003ddc:	bf49                	j	80003d6e <filewrite+0x84>
    int i = 0;
    80003dde:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003de0:	013a1f63          	bne	s4,s3,80003dfe <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003de4:	8552                	mv	a0,s4
    80003de6:	60a6                	ld	ra,72(sp)
    80003de8:	6406                	ld	s0,64(sp)
    80003dea:	74e2                	ld	s1,56(sp)
    80003dec:	7942                	ld	s2,48(sp)
    80003dee:	79a2                	ld	s3,40(sp)
    80003df0:	7a02                	ld	s4,32(sp)
    80003df2:	6ae2                	ld	s5,24(sp)
    80003df4:	6b42                	ld	s6,16(sp)
    80003df6:	6ba2                	ld	s7,8(sp)
    80003df8:	6c02                	ld	s8,0(sp)
    80003dfa:	6161                	addi	sp,sp,80
    80003dfc:	8082                	ret
    ret = (i == n ? n : -1);
    80003dfe:	5a7d                	li	s4,-1
    80003e00:	b7d5                	j	80003de4 <filewrite+0xfa>
    panic("filewrite");
    80003e02:	00005517          	auipc	a0,0x5
    80003e06:	8d650513          	addi	a0,a0,-1834 # 800086d8 <syscalls+0x2b0>
    80003e0a:	00002097          	auipc	ra,0x2
    80003e0e:	f0e080e7          	jalr	-242(ra) # 80005d18 <panic>
    return -1;
    80003e12:	5a7d                	li	s4,-1
    80003e14:	bfc1                	j	80003de4 <filewrite+0xfa>
      return -1;
    80003e16:	5a7d                	li	s4,-1
    80003e18:	b7f1                	j	80003de4 <filewrite+0xfa>
    80003e1a:	5a7d                	li	s4,-1
    80003e1c:	b7e1                	j	80003de4 <filewrite+0xfa>

0000000080003e1e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e1e:	7179                	addi	sp,sp,-48
    80003e20:	f406                	sd	ra,40(sp)
    80003e22:	f022                	sd	s0,32(sp)
    80003e24:	ec26                	sd	s1,24(sp)
    80003e26:	e84a                	sd	s2,16(sp)
    80003e28:	e44e                	sd	s3,8(sp)
    80003e2a:	e052                	sd	s4,0(sp)
    80003e2c:	1800                	addi	s0,sp,48
    80003e2e:	84aa                	mv	s1,a0
    80003e30:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e32:	0005b023          	sd	zero,0(a1)
    80003e36:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e3a:	00000097          	auipc	ra,0x0
    80003e3e:	bf8080e7          	jalr	-1032(ra) # 80003a32 <filealloc>
    80003e42:	e088                	sd	a0,0(s1)
    80003e44:	c551                	beqz	a0,80003ed0 <pipealloc+0xb2>
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	bec080e7          	jalr	-1044(ra) # 80003a32 <filealloc>
    80003e4e:	00aa3023          	sd	a0,0(s4)
    80003e52:	c92d                	beqz	a0,80003ec4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e54:	ffffc097          	auipc	ra,0xffffc
    80003e58:	2c4080e7          	jalr	708(ra) # 80000118 <kalloc>
    80003e5c:	892a                	mv	s2,a0
    80003e5e:	c125                	beqz	a0,80003ebe <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e60:	4985                	li	s3,1
    80003e62:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e66:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e6a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e6e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e72:	00005597          	auipc	a1,0x5
    80003e76:	87658593          	addi	a1,a1,-1930 # 800086e8 <syscalls+0x2c0>
    80003e7a:	00002097          	auipc	ra,0x2
    80003e7e:	358080e7          	jalr	856(ra) # 800061d2 <initlock>
  (*f0)->type = FD_PIPE;
    80003e82:	609c                	ld	a5,0(s1)
    80003e84:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e88:	609c                	ld	a5,0(s1)
    80003e8a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e8e:	609c                	ld	a5,0(s1)
    80003e90:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e94:	609c                	ld	a5,0(s1)
    80003e96:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e9a:	000a3783          	ld	a5,0(s4)
    80003e9e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ea2:	000a3783          	ld	a5,0(s4)
    80003ea6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eaa:	000a3783          	ld	a5,0(s4)
    80003eae:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eb2:	000a3783          	ld	a5,0(s4)
    80003eb6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eba:	4501                	li	a0,0
    80003ebc:	a025                	j	80003ee4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ebe:	6088                	ld	a0,0(s1)
    80003ec0:	e501                	bnez	a0,80003ec8 <pipealloc+0xaa>
    80003ec2:	a039                	j	80003ed0 <pipealloc+0xb2>
    80003ec4:	6088                	ld	a0,0(s1)
    80003ec6:	c51d                	beqz	a0,80003ef4 <pipealloc+0xd6>
    fileclose(*f0);
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	c26080e7          	jalr	-986(ra) # 80003aee <fileclose>
  if(*f1)
    80003ed0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ed4:	557d                	li	a0,-1
  if(*f1)
    80003ed6:	c799                	beqz	a5,80003ee4 <pipealloc+0xc6>
    fileclose(*f1);
    80003ed8:	853e                	mv	a0,a5
    80003eda:	00000097          	auipc	ra,0x0
    80003ede:	c14080e7          	jalr	-1004(ra) # 80003aee <fileclose>
  return -1;
    80003ee2:	557d                	li	a0,-1
}
    80003ee4:	70a2                	ld	ra,40(sp)
    80003ee6:	7402                	ld	s0,32(sp)
    80003ee8:	64e2                	ld	s1,24(sp)
    80003eea:	6942                	ld	s2,16(sp)
    80003eec:	69a2                	ld	s3,8(sp)
    80003eee:	6a02                	ld	s4,0(sp)
    80003ef0:	6145                	addi	sp,sp,48
    80003ef2:	8082                	ret
  return -1;
    80003ef4:	557d                	li	a0,-1
    80003ef6:	b7fd                	j	80003ee4 <pipealloc+0xc6>

0000000080003ef8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ef8:	1101                	addi	sp,sp,-32
    80003efa:	ec06                	sd	ra,24(sp)
    80003efc:	e822                	sd	s0,16(sp)
    80003efe:	e426                	sd	s1,8(sp)
    80003f00:	e04a                	sd	s2,0(sp)
    80003f02:	1000                	addi	s0,sp,32
    80003f04:	84aa                	mv	s1,a0
    80003f06:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f08:	00002097          	auipc	ra,0x2
    80003f0c:	35a080e7          	jalr	858(ra) # 80006262 <acquire>
  if(writable){
    80003f10:	02090d63          	beqz	s2,80003f4a <pipeclose+0x52>
    pi->writeopen = 0;
    80003f14:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f18:	21848513          	addi	a0,s1,536
    80003f1c:	ffffe097          	auipc	ra,0xffffe
    80003f20:	950080e7          	jalr	-1712(ra) # 8000186c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f24:	2204b783          	ld	a5,544(s1)
    80003f28:	eb95                	bnez	a5,80003f5c <pipeclose+0x64>
    release(&pi->lock);
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	00002097          	auipc	ra,0x2
    80003f30:	3ea080e7          	jalr	1002(ra) # 80006316 <release>
    kfree((char*)pi);
    80003f34:	8526                	mv	a0,s1
    80003f36:	ffffc097          	auipc	ra,0xffffc
    80003f3a:	0e6080e7          	jalr	230(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f3e:	60e2                	ld	ra,24(sp)
    80003f40:	6442                	ld	s0,16(sp)
    80003f42:	64a2                	ld	s1,8(sp)
    80003f44:	6902                	ld	s2,0(sp)
    80003f46:	6105                	addi	sp,sp,32
    80003f48:	8082                	ret
    pi->readopen = 0;
    80003f4a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f4e:	21c48513          	addi	a0,s1,540
    80003f52:	ffffe097          	auipc	ra,0xffffe
    80003f56:	91a080e7          	jalr	-1766(ra) # 8000186c <wakeup>
    80003f5a:	b7e9                	j	80003f24 <pipeclose+0x2c>
    release(&pi->lock);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	00002097          	auipc	ra,0x2
    80003f62:	3b8080e7          	jalr	952(ra) # 80006316 <release>
}
    80003f66:	bfe1                	j	80003f3e <pipeclose+0x46>

0000000080003f68 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f68:	7159                	addi	sp,sp,-112
    80003f6a:	f486                	sd	ra,104(sp)
    80003f6c:	f0a2                	sd	s0,96(sp)
    80003f6e:	eca6                	sd	s1,88(sp)
    80003f70:	e8ca                	sd	s2,80(sp)
    80003f72:	e4ce                	sd	s3,72(sp)
    80003f74:	e0d2                	sd	s4,64(sp)
    80003f76:	fc56                	sd	s5,56(sp)
    80003f78:	f85a                	sd	s6,48(sp)
    80003f7a:	f45e                	sd	s7,40(sp)
    80003f7c:	f062                	sd	s8,32(sp)
    80003f7e:	ec66                	sd	s9,24(sp)
    80003f80:	1880                	addi	s0,sp,112
    80003f82:	84aa                	mv	s1,a0
    80003f84:	8aae                	mv	s5,a1
    80003f86:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	fec080e7          	jalr	-20(ra) # 80000f74 <myproc>
    80003f90:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f92:	8526                	mv	a0,s1
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	2ce080e7          	jalr	718(ra) # 80006262 <acquire>
  while(i < n){
    80003f9c:	0d405163          	blez	s4,8000405e <pipewrite+0xf6>
    80003fa0:	8ba6                	mv	s7,s1
  int i = 0;
    80003fa2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fa4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fa6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003faa:	21c48c13          	addi	s8,s1,540
    80003fae:	a08d                	j	80004010 <pipewrite+0xa8>
      release(&pi->lock);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	00002097          	auipc	ra,0x2
    80003fb6:	364080e7          	jalr	868(ra) # 80006316 <release>
      return -1;
    80003fba:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fbc:	854a                	mv	a0,s2
    80003fbe:	70a6                	ld	ra,104(sp)
    80003fc0:	7406                	ld	s0,96(sp)
    80003fc2:	64e6                	ld	s1,88(sp)
    80003fc4:	6946                	ld	s2,80(sp)
    80003fc6:	69a6                	ld	s3,72(sp)
    80003fc8:	6a06                	ld	s4,64(sp)
    80003fca:	7ae2                	ld	s5,56(sp)
    80003fcc:	7b42                	ld	s6,48(sp)
    80003fce:	7ba2                	ld	s7,40(sp)
    80003fd0:	7c02                	ld	s8,32(sp)
    80003fd2:	6ce2                	ld	s9,24(sp)
    80003fd4:	6165                	addi	sp,sp,112
    80003fd6:	8082                	ret
      wakeup(&pi->nread);
    80003fd8:	8566                	mv	a0,s9
    80003fda:	ffffe097          	auipc	ra,0xffffe
    80003fde:	892080e7          	jalr	-1902(ra) # 8000186c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fe2:	85de                	mv	a1,s7
    80003fe4:	8562                	mv	a0,s8
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	6fa080e7          	jalr	1786(ra) # 800016e0 <sleep>
    80003fee:	a839                	j	8000400c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ff0:	21c4a783          	lw	a5,540(s1)
    80003ff4:	0017871b          	addiw	a4,a5,1
    80003ff8:	20e4ae23          	sw	a4,540(s1)
    80003ffc:	1ff7f793          	andi	a5,a5,511
    80004000:	97a6                	add	a5,a5,s1
    80004002:	f9f44703          	lbu	a4,-97(s0)
    80004006:	00e78c23          	sb	a4,24(a5)
      i++;
    8000400a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000400c:	03495d63          	bge	s2,s4,80004046 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004010:	2204a783          	lw	a5,544(s1)
    80004014:	dfd1                	beqz	a5,80003fb0 <pipewrite+0x48>
    80004016:	0289a783          	lw	a5,40(s3)
    8000401a:	fbd9                	bnez	a5,80003fb0 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000401c:	2184a783          	lw	a5,536(s1)
    80004020:	21c4a703          	lw	a4,540(s1)
    80004024:	2007879b          	addiw	a5,a5,512
    80004028:	faf708e3          	beq	a4,a5,80003fd8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000402c:	4685                	li	a3,1
    8000402e:	01590633          	add	a2,s2,s5
    80004032:	f9f40593          	addi	a1,s0,-97
    80004036:	0509b503          	ld	a0,80(s3)
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	b5c080e7          	jalr	-1188(ra) # 80000b96 <copyin>
    80004042:	fb6517e3          	bne	a0,s6,80003ff0 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004046:	21848513          	addi	a0,s1,536
    8000404a:	ffffe097          	auipc	ra,0xffffe
    8000404e:	822080e7          	jalr	-2014(ra) # 8000186c <wakeup>
  release(&pi->lock);
    80004052:	8526                	mv	a0,s1
    80004054:	00002097          	auipc	ra,0x2
    80004058:	2c2080e7          	jalr	706(ra) # 80006316 <release>
  return i;
    8000405c:	b785                	j	80003fbc <pipewrite+0x54>
  int i = 0;
    8000405e:	4901                	li	s2,0
    80004060:	b7dd                	j	80004046 <pipewrite+0xde>

0000000080004062 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004062:	715d                	addi	sp,sp,-80
    80004064:	e486                	sd	ra,72(sp)
    80004066:	e0a2                	sd	s0,64(sp)
    80004068:	fc26                	sd	s1,56(sp)
    8000406a:	f84a                	sd	s2,48(sp)
    8000406c:	f44e                	sd	s3,40(sp)
    8000406e:	f052                	sd	s4,32(sp)
    80004070:	ec56                	sd	s5,24(sp)
    80004072:	e85a                	sd	s6,16(sp)
    80004074:	0880                	addi	s0,sp,80
    80004076:	84aa                	mv	s1,a0
    80004078:	892e                	mv	s2,a1
    8000407a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	ef8080e7          	jalr	-264(ra) # 80000f74 <myproc>
    80004084:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004086:	8b26                	mv	s6,s1
    80004088:	8526                	mv	a0,s1
    8000408a:	00002097          	auipc	ra,0x2
    8000408e:	1d8080e7          	jalr	472(ra) # 80006262 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004092:	2184a703          	lw	a4,536(s1)
    80004096:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000409a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000409e:	02f71463          	bne	a4,a5,800040c6 <piperead+0x64>
    800040a2:	2244a783          	lw	a5,548(s1)
    800040a6:	c385                	beqz	a5,800040c6 <piperead+0x64>
    if(pr->killed){
    800040a8:	028a2783          	lw	a5,40(s4)
    800040ac:	ebc1                	bnez	a5,8000413c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ae:	85da                	mv	a1,s6
    800040b0:	854e                	mv	a0,s3
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	62e080e7          	jalr	1582(ra) # 800016e0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ba:	2184a703          	lw	a4,536(s1)
    800040be:	21c4a783          	lw	a5,540(s1)
    800040c2:	fef700e3          	beq	a4,a5,800040a2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040c6:	09505263          	blez	s5,8000414a <piperead+0xe8>
    800040ca:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040cc:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040ce:	2184a783          	lw	a5,536(s1)
    800040d2:	21c4a703          	lw	a4,540(s1)
    800040d6:	02f70d63          	beq	a4,a5,80004110 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040da:	0017871b          	addiw	a4,a5,1
    800040de:	20e4ac23          	sw	a4,536(s1)
    800040e2:	1ff7f793          	andi	a5,a5,511
    800040e6:	97a6                	add	a5,a5,s1
    800040e8:	0187c783          	lbu	a5,24(a5)
    800040ec:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f0:	4685                	li	a3,1
    800040f2:	fbf40613          	addi	a2,s0,-65
    800040f6:	85ca                	mv	a1,s2
    800040f8:	050a3503          	ld	a0,80(s4)
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	a0e080e7          	jalr	-1522(ra) # 80000b0a <copyout>
    80004104:	01650663          	beq	a0,s6,80004110 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004108:	2985                	addiw	s3,s3,1
    8000410a:	0905                	addi	s2,s2,1
    8000410c:	fd3a91e3          	bne	s5,s3,800040ce <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004110:	21c48513          	addi	a0,s1,540
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	758080e7          	jalr	1880(ra) # 8000186c <wakeup>
  release(&pi->lock);
    8000411c:	8526                	mv	a0,s1
    8000411e:	00002097          	auipc	ra,0x2
    80004122:	1f8080e7          	jalr	504(ra) # 80006316 <release>
  return i;
}
    80004126:	854e                	mv	a0,s3
    80004128:	60a6                	ld	ra,72(sp)
    8000412a:	6406                	ld	s0,64(sp)
    8000412c:	74e2                	ld	s1,56(sp)
    8000412e:	7942                	ld	s2,48(sp)
    80004130:	79a2                	ld	s3,40(sp)
    80004132:	7a02                	ld	s4,32(sp)
    80004134:	6ae2                	ld	s5,24(sp)
    80004136:	6b42                	ld	s6,16(sp)
    80004138:	6161                	addi	sp,sp,80
    8000413a:	8082                	ret
      release(&pi->lock);
    8000413c:	8526                	mv	a0,s1
    8000413e:	00002097          	auipc	ra,0x2
    80004142:	1d8080e7          	jalr	472(ra) # 80006316 <release>
      return -1;
    80004146:	59fd                	li	s3,-1
    80004148:	bff9                	j	80004126 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000414a:	4981                	li	s3,0
    8000414c:	b7d1                	j	80004110 <piperead+0xae>

000000008000414e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000414e:	df010113          	addi	sp,sp,-528
    80004152:	20113423          	sd	ra,520(sp)
    80004156:	20813023          	sd	s0,512(sp)
    8000415a:	ffa6                	sd	s1,504(sp)
    8000415c:	fbca                	sd	s2,496(sp)
    8000415e:	f7ce                	sd	s3,488(sp)
    80004160:	f3d2                	sd	s4,480(sp)
    80004162:	efd6                	sd	s5,472(sp)
    80004164:	ebda                	sd	s6,464(sp)
    80004166:	e7de                	sd	s7,456(sp)
    80004168:	e3e2                	sd	s8,448(sp)
    8000416a:	ff66                	sd	s9,440(sp)
    8000416c:	fb6a                	sd	s10,432(sp)
    8000416e:	f76e                	sd	s11,424(sp)
    80004170:	0c00                	addi	s0,sp,528
    80004172:	84aa                	mv	s1,a0
    80004174:	dea43c23          	sd	a0,-520(s0)
    80004178:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	df8080e7          	jalr	-520(ra) # 80000f74 <myproc>
    80004184:	892a                	mv	s2,a0

  begin_op();
    80004186:	fffff097          	auipc	ra,0xfffff
    8000418a:	49c080e7          	jalr	1180(ra) # 80003622 <begin_op>

  if((ip = namei(path)) == 0){
    8000418e:	8526                	mv	a0,s1
    80004190:	fffff097          	auipc	ra,0xfffff
    80004194:	276080e7          	jalr	630(ra) # 80003406 <namei>
    80004198:	c92d                	beqz	a0,8000420a <exec+0xbc>
    8000419a:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	ab4080e7          	jalr	-1356(ra) # 80002c50 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041a4:	04000713          	li	a4,64
    800041a8:	4681                	li	a3,0
    800041aa:	e5040613          	addi	a2,s0,-432
    800041ae:	4581                	li	a1,0
    800041b0:	8526                	mv	a0,s1
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	d52080e7          	jalr	-686(ra) # 80002f04 <readi>
    800041ba:	04000793          	li	a5,64
    800041be:	00f51a63          	bne	a0,a5,800041d2 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041c2:	e5042703          	lw	a4,-432(s0)
    800041c6:	464c47b7          	lui	a5,0x464c4
    800041ca:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041ce:	04f70463          	beq	a4,a5,80004216 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041d2:	8526                	mv	a0,s1
    800041d4:	fffff097          	auipc	ra,0xfffff
    800041d8:	cde080e7          	jalr	-802(ra) # 80002eb2 <iunlockput>
    end_op();
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	4c6080e7          	jalr	1222(ra) # 800036a2 <end_op>
  }
  return -1;
    800041e4:	557d                	li	a0,-1
}
    800041e6:	20813083          	ld	ra,520(sp)
    800041ea:	20013403          	ld	s0,512(sp)
    800041ee:	74fe                	ld	s1,504(sp)
    800041f0:	795e                	ld	s2,496(sp)
    800041f2:	79be                	ld	s3,488(sp)
    800041f4:	7a1e                	ld	s4,480(sp)
    800041f6:	6afe                	ld	s5,472(sp)
    800041f8:	6b5e                	ld	s6,464(sp)
    800041fa:	6bbe                	ld	s7,456(sp)
    800041fc:	6c1e                	ld	s8,448(sp)
    800041fe:	7cfa                	ld	s9,440(sp)
    80004200:	7d5a                	ld	s10,432(sp)
    80004202:	7dba                	ld	s11,424(sp)
    80004204:	21010113          	addi	sp,sp,528
    80004208:	8082                	ret
    end_op();
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	498080e7          	jalr	1176(ra) # 800036a2 <end_op>
    return -1;
    80004212:	557d                	li	a0,-1
    80004214:	bfc9                	j	800041e6 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004216:	854a                	mv	a0,s2
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	e20080e7          	jalr	-480(ra) # 80001038 <proc_pagetable>
    80004220:	8baa                	mv	s7,a0
    80004222:	d945                	beqz	a0,800041d2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004224:	e7042983          	lw	s3,-400(s0)
    80004228:	e8845783          	lhu	a5,-376(s0)
    8000422c:	c7ad                	beqz	a5,80004296 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000422e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004230:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004232:	6c85                	lui	s9,0x1
    80004234:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004238:	def43823          	sd	a5,-528(s0)
    8000423c:	a489                	j	8000447e <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000423e:	00004517          	auipc	a0,0x4
    80004242:	4b250513          	addi	a0,a0,1202 # 800086f0 <syscalls+0x2c8>
    80004246:	00002097          	auipc	ra,0x2
    8000424a:	ad2080e7          	jalr	-1326(ra) # 80005d18 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000424e:	8756                	mv	a4,s5
    80004250:	012d86bb          	addw	a3,s11,s2
    80004254:	4581                	li	a1,0
    80004256:	8526                	mv	a0,s1
    80004258:	fffff097          	auipc	ra,0xfffff
    8000425c:	cac080e7          	jalr	-852(ra) # 80002f04 <readi>
    80004260:	2501                	sext.w	a0,a0
    80004262:	1caa9563          	bne	s5,a0,8000442c <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    80004266:	6785                	lui	a5,0x1
    80004268:	0127893b          	addw	s2,a5,s2
    8000426c:	77fd                	lui	a5,0xfffff
    8000426e:	01478a3b          	addw	s4,a5,s4
    80004272:	1f897d63          	bgeu	s2,s8,8000446c <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    80004276:	02091593          	slli	a1,s2,0x20
    8000427a:	9181                	srli	a1,a1,0x20
    8000427c:	95ea                	add	a1,a1,s10
    8000427e:	855e                	mv	a0,s7
    80004280:	ffffc097          	auipc	ra,0xffffc
    80004284:	286080e7          	jalr	646(ra) # 80000506 <walkaddr>
    80004288:	862a                	mv	a2,a0
    if(pa == 0)
    8000428a:	d955                	beqz	a0,8000423e <exec+0xf0>
      n = PGSIZE;
    8000428c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000428e:	fd9a70e3          	bgeu	s4,s9,8000424e <exec+0x100>
      n = sz - i;
    80004292:	8ad2                	mv	s5,s4
    80004294:	bf6d                	j	8000424e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004296:	4901                	li	s2,0
  iunlockput(ip);
    80004298:	8526                	mv	a0,s1
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	c18080e7          	jalr	-1000(ra) # 80002eb2 <iunlockput>
  end_op();
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	400080e7          	jalr	1024(ra) # 800036a2 <end_op>
  p = myproc();
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	cca080e7          	jalr	-822(ra) # 80000f74 <myproc>
    800042b2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042b4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042b8:	6785                	lui	a5,0x1
    800042ba:	17fd                	addi	a5,a5,-1
    800042bc:	993e                	add	s2,s2,a5
    800042be:	757d                	lui	a0,0xfffff
    800042c0:	00a977b3          	and	a5,s2,a0
    800042c4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042c8:	6609                	lui	a2,0x2
    800042ca:	963e                	add	a2,a2,a5
    800042cc:	85be                	mv	a1,a5
    800042ce:	855e                	mv	a0,s7
    800042d0:	ffffc097          	auipc	ra,0xffffc
    800042d4:	5ea080e7          	jalr	1514(ra) # 800008ba <uvmalloc>
    800042d8:	8b2a                	mv	s6,a0
  ip = 0;
    800042da:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042dc:	14050863          	beqz	a0,8000442c <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042e0:	75f9                	lui	a1,0xffffe
    800042e2:	95aa                	add	a1,a1,a0
    800042e4:	855e                	mv	a0,s7
    800042e6:	ffffc097          	auipc	ra,0xffffc
    800042ea:	7f2080e7          	jalr	2034(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    800042ee:	7c7d                	lui	s8,0xfffff
    800042f0:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800042f2:	e0043783          	ld	a5,-512(s0)
    800042f6:	6388                	ld	a0,0(a5)
    800042f8:	c535                	beqz	a0,80004364 <exec+0x216>
    800042fa:	e9040993          	addi	s3,s0,-368
    800042fe:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004302:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004304:	ffffc097          	auipc	ra,0xffffc
    80004308:	ff8080e7          	jalr	-8(ra) # 800002fc <strlen>
    8000430c:	2505                	addiw	a0,a0,1
    8000430e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004312:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004316:	13896f63          	bltu	s2,s8,80004454 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000431a:	e0043d83          	ld	s11,-512(s0)
    8000431e:	000dba03          	ld	s4,0(s11)
    80004322:	8552                	mv	a0,s4
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	fd8080e7          	jalr	-40(ra) # 800002fc <strlen>
    8000432c:	0015069b          	addiw	a3,a0,1
    80004330:	8652                	mv	a2,s4
    80004332:	85ca                	mv	a1,s2
    80004334:	855e                	mv	a0,s7
    80004336:	ffffc097          	auipc	ra,0xffffc
    8000433a:	7d4080e7          	jalr	2004(ra) # 80000b0a <copyout>
    8000433e:	10054f63          	bltz	a0,8000445c <exec+0x30e>
    ustack[argc] = sp;
    80004342:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004346:	0485                	addi	s1,s1,1
    80004348:	008d8793          	addi	a5,s11,8
    8000434c:	e0f43023          	sd	a5,-512(s0)
    80004350:	008db503          	ld	a0,8(s11)
    80004354:	c911                	beqz	a0,80004368 <exec+0x21a>
    if(argc >= MAXARG)
    80004356:	09a1                	addi	s3,s3,8
    80004358:	fb3c96e3          	bne	s9,s3,80004304 <exec+0x1b6>
  sz = sz1;
    8000435c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004360:	4481                	li	s1,0
    80004362:	a0e9                	j	8000442c <exec+0x2de>
  sp = sz;
    80004364:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004366:	4481                	li	s1,0
  ustack[argc] = 0;
    80004368:	00349793          	slli	a5,s1,0x3
    8000436c:	f9040713          	addi	a4,s0,-112
    80004370:	97ba                	add	a5,a5,a4
    80004372:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004376:	00148693          	addi	a3,s1,1
    8000437a:	068e                	slli	a3,a3,0x3
    8000437c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004380:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004384:	01897663          	bgeu	s2,s8,80004390 <exec+0x242>
  sz = sz1;
    80004388:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000438c:	4481                	li	s1,0
    8000438e:	a879                	j	8000442c <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004390:	e9040613          	addi	a2,s0,-368
    80004394:	85ca                	mv	a1,s2
    80004396:	855e                	mv	a0,s7
    80004398:	ffffc097          	auipc	ra,0xffffc
    8000439c:	772080e7          	jalr	1906(ra) # 80000b0a <copyout>
    800043a0:	0c054263          	bltz	a0,80004464 <exec+0x316>
  p->trapframe->a1 = sp;
    800043a4:	060ab783          	ld	a5,96(s5)
    800043a8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043ac:	df843783          	ld	a5,-520(s0)
    800043b0:	0007c703          	lbu	a4,0(a5)
    800043b4:	cf11                	beqz	a4,800043d0 <exec+0x282>
    800043b6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043b8:	02f00693          	li	a3,47
    800043bc:	a039                	j	800043ca <exec+0x27c>
      last = s+1;
    800043be:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043c2:	0785                	addi	a5,a5,1
    800043c4:	fff7c703          	lbu	a4,-1(a5)
    800043c8:	c701                	beqz	a4,800043d0 <exec+0x282>
    if(*s == '/')
    800043ca:	fed71ce3          	bne	a4,a3,800043c2 <exec+0x274>
    800043ce:	bfc5                	j	800043be <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800043d0:	4641                	li	a2,16
    800043d2:	df843583          	ld	a1,-520(s0)
    800043d6:	160a8513          	addi	a0,s5,352
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	ef0080e7          	jalr	-272(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800043e2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043e6:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800043ea:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043ee:	060ab783          	ld	a5,96(s5)
    800043f2:	e6843703          	ld	a4,-408(s0)
    800043f6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043f8:	060ab783          	ld	a5,96(s5)
    800043fc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004400:	85ea                	mv	a1,s10
    80004402:	ffffd097          	auipc	ra,0xffffd
    80004406:	d2c080e7          	jalr	-724(ra) # 8000112e <proc_freepagetable>
  if(p->pid==1)  // ******* to print first process's page table
    8000440a:	030aa703          	lw	a4,48(s5)
    8000440e:	4785                	li	a5,1
    80004410:	00f70563          	beq	a4,a5,8000441a <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004414:	0004851b          	sext.w	a0,s1
    80004418:	b3f9                	j	800041e6 <exec+0x98>
    vmprint(p->pagetable);
    8000441a:	050ab503          	ld	a0,80(s5)
    8000441e:	ffffd097          	auipc	ra,0xffffd
    80004422:	964080e7          	jalr	-1692(ra) # 80000d82 <vmprint>
    80004426:	b7fd                	j	80004414 <exec+0x2c6>
    80004428:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000442c:	e0843583          	ld	a1,-504(s0)
    80004430:	855e                	mv	a0,s7
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	cfc080e7          	jalr	-772(ra) # 8000112e <proc_freepagetable>
  if(ip){
    8000443a:	d8049ce3          	bnez	s1,800041d2 <exec+0x84>
  return -1;
    8000443e:	557d                	li	a0,-1
    80004440:	b35d                	j	800041e6 <exec+0x98>
    80004442:	e1243423          	sd	s2,-504(s0)
    80004446:	b7dd                	j	8000442c <exec+0x2de>
    80004448:	e1243423          	sd	s2,-504(s0)
    8000444c:	b7c5                	j	8000442c <exec+0x2de>
    8000444e:	e1243423          	sd	s2,-504(s0)
    80004452:	bfe9                	j	8000442c <exec+0x2de>
  sz = sz1;
    80004454:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004458:	4481                	li	s1,0
    8000445a:	bfc9                	j	8000442c <exec+0x2de>
  sz = sz1;
    8000445c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004460:	4481                	li	s1,0
    80004462:	b7e9                	j	8000442c <exec+0x2de>
  sz = sz1;
    80004464:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004468:	4481                	li	s1,0
    8000446a:	b7c9                	j	8000442c <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000446c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004470:	2b05                	addiw	s6,s6,1
    80004472:	0389899b          	addiw	s3,s3,56
    80004476:	e8845783          	lhu	a5,-376(s0)
    8000447a:	e0fb5fe3          	bge	s6,a5,80004298 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000447e:	2981                	sext.w	s3,s3
    80004480:	03800713          	li	a4,56
    80004484:	86ce                	mv	a3,s3
    80004486:	e1840613          	addi	a2,s0,-488
    8000448a:	4581                	li	a1,0
    8000448c:	8526                	mv	a0,s1
    8000448e:	fffff097          	auipc	ra,0xfffff
    80004492:	a76080e7          	jalr	-1418(ra) # 80002f04 <readi>
    80004496:	03800793          	li	a5,56
    8000449a:	f8f517e3          	bne	a0,a5,80004428 <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    8000449e:	e1842783          	lw	a5,-488(s0)
    800044a2:	4705                	li	a4,1
    800044a4:	fce796e3          	bne	a5,a4,80004470 <exec+0x322>
    if(ph.memsz < ph.filesz)
    800044a8:	e4043603          	ld	a2,-448(s0)
    800044ac:	e3843783          	ld	a5,-456(s0)
    800044b0:	f8f669e3          	bltu	a2,a5,80004442 <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044b4:	e2843783          	ld	a5,-472(s0)
    800044b8:	963e                	add	a2,a2,a5
    800044ba:	f8f667e3          	bltu	a2,a5,80004448 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044be:	85ca                	mv	a1,s2
    800044c0:	855e                	mv	a0,s7
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	3f8080e7          	jalr	1016(ra) # 800008ba <uvmalloc>
    800044ca:	e0a43423          	sd	a0,-504(s0)
    800044ce:	d141                	beqz	a0,8000444e <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    800044d0:	e2843d03          	ld	s10,-472(s0)
    800044d4:	df043783          	ld	a5,-528(s0)
    800044d8:	00fd77b3          	and	a5,s10,a5
    800044dc:	fba1                	bnez	a5,8000442c <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044de:	e2042d83          	lw	s11,-480(s0)
    800044e2:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044e6:	f80c03e3          	beqz	s8,8000446c <exec+0x31e>
    800044ea:	8a62                	mv	s4,s8
    800044ec:	4901                	li	s2,0
    800044ee:	b361                	j	80004276 <exec+0x128>

00000000800044f0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044f0:	7179                	addi	sp,sp,-48
    800044f2:	f406                	sd	ra,40(sp)
    800044f4:	f022                	sd	s0,32(sp)
    800044f6:	ec26                	sd	s1,24(sp)
    800044f8:	e84a                	sd	s2,16(sp)
    800044fa:	1800                	addi	s0,sp,48
    800044fc:	892e                	mv	s2,a1
    800044fe:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004500:	fdc40593          	addi	a1,s0,-36
    80004504:	ffffe097          	auipc	ra,0xffffe
    80004508:	bcc080e7          	jalr	-1076(ra) # 800020d0 <argint>
    8000450c:	04054063          	bltz	a0,8000454c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004510:	fdc42703          	lw	a4,-36(s0)
    80004514:	47bd                	li	a5,15
    80004516:	02e7ed63          	bltu	a5,a4,80004550 <argfd+0x60>
    8000451a:	ffffd097          	auipc	ra,0xffffd
    8000451e:	a5a080e7          	jalr	-1446(ra) # 80000f74 <myproc>
    80004522:	fdc42703          	lw	a4,-36(s0)
    80004526:	01a70793          	addi	a5,a4,26
    8000452a:	078e                	slli	a5,a5,0x3
    8000452c:	953e                	add	a0,a0,a5
    8000452e:	651c                	ld	a5,8(a0)
    80004530:	c395                	beqz	a5,80004554 <argfd+0x64>
    return -1;
  if(pfd)
    80004532:	00090463          	beqz	s2,8000453a <argfd+0x4a>
    *pfd = fd;
    80004536:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000453a:	4501                	li	a0,0
  if(pf)
    8000453c:	c091                	beqz	s1,80004540 <argfd+0x50>
    *pf = f;
    8000453e:	e09c                	sd	a5,0(s1)
}
    80004540:	70a2                	ld	ra,40(sp)
    80004542:	7402                	ld	s0,32(sp)
    80004544:	64e2                	ld	s1,24(sp)
    80004546:	6942                	ld	s2,16(sp)
    80004548:	6145                	addi	sp,sp,48
    8000454a:	8082                	ret
    return -1;
    8000454c:	557d                	li	a0,-1
    8000454e:	bfcd                	j	80004540 <argfd+0x50>
    return -1;
    80004550:	557d                	li	a0,-1
    80004552:	b7fd                	j	80004540 <argfd+0x50>
    80004554:	557d                	li	a0,-1
    80004556:	b7ed                	j	80004540 <argfd+0x50>

0000000080004558 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004558:	1101                	addi	sp,sp,-32
    8000455a:	ec06                	sd	ra,24(sp)
    8000455c:	e822                	sd	s0,16(sp)
    8000455e:	e426                	sd	s1,8(sp)
    80004560:	1000                	addi	s0,sp,32
    80004562:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004564:	ffffd097          	auipc	ra,0xffffd
    80004568:	a10080e7          	jalr	-1520(ra) # 80000f74 <myproc>
    8000456c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000456e:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    80004572:	4501                	li	a0,0
    80004574:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004576:	6398                	ld	a4,0(a5)
    80004578:	cb19                	beqz	a4,8000458e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000457a:	2505                	addiw	a0,a0,1
    8000457c:	07a1                	addi	a5,a5,8
    8000457e:	fed51ce3          	bne	a0,a3,80004576 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004582:	557d                	li	a0,-1
}
    80004584:	60e2                	ld	ra,24(sp)
    80004586:	6442                	ld	s0,16(sp)
    80004588:	64a2                	ld	s1,8(sp)
    8000458a:	6105                	addi	sp,sp,32
    8000458c:	8082                	ret
      p->ofile[fd] = f;
    8000458e:	01a50793          	addi	a5,a0,26
    80004592:	078e                	slli	a5,a5,0x3
    80004594:	963e                	add	a2,a2,a5
    80004596:	e604                	sd	s1,8(a2)
      return fd;
    80004598:	b7f5                	j	80004584 <fdalloc+0x2c>

000000008000459a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000459a:	715d                	addi	sp,sp,-80
    8000459c:	e486                	sd	ra,72(sp)
    8000459e:	e0a2                	sd	s0,64(sp)
    800045a0:	fc26                	sd	s1,56(sp)
    800045a2:	f84a                	sd	s2,48(sp)
    800045a4:	f44e                	sd	s3,40(sp)
    800045a6:	f052                	sd	s4,32(sp)
    800045a8:	ec56                	sd	s5,24(sp)
    800045aa:	0880                	addi	s0,sp,80
    800045ac:	89ae                	mv	s3,a1
    800045ae:	8ab2                	mv	s5,a2
    800045b0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045b2:	fb040593          	addi	a1,s0,-80
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	e6e080e7          	jalr	-402(ra) # 80003424 <nameiparent>
    800045be:	892a                	mv	s2,a0
    800045c0:	12050f63          	beqz	a0,800046fe <create+0x164>
    return 0;

  ilock(dp);
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	68c080e7          	jalr	1676(ra) # 80002c50 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045cc:	4601                	li	a2,0
    800045ce:	fb040593          	addi	a1,s0,-80
    800045d2:	854a                	mv	a0,s2
    800045d4:	fffff097          	auipc	ra,0xfffff
    800045d8:	b60080e7          	jalr	-1184(ra) # 80003134 <dirlookup>
    800045dc:	84aa                	mv	s1,a0
    800045de:	c921                	beqz	a0,8000462e <create+0x94>
    iunlockput(dp);
    800045e0:	854a                	mv	a0,s2
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	8d0080e7          	jalr	-1840(ra) # 80002eb2 <iunlockput>
    ilock(ip);
    800045ea:	8526                	mv	a0,s1
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	664080e7          	jalr	1636(ra) # 80002c50 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045f4:	2981                	sext.w	s3,s3
    800045f6:	4789                	li	a5,2
    800045f8:	02f99463          	bne	s3,a5,80004620 <create+0x86>
    800045fc:	0444d783          	lhu	a5,68(s1)
    80004600:	37f9                	addiw	a5,a5,-2
    80004602:	17c2                	slli	a5,a5,0x30
    80004604:	93c1                	srli	a5,a5,0x30
    80004606:	4705                	li	a4,1
    80004608:	00f76c63          	bltu	a4,a5,80004620 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000460c:	8526                	mv	a0,s1
    8000460e:	60a6                	ld	ra,72(sp)
    80004610:	6406                	ld	s0,64(sp)
    80004612:	74e2                	ld	s1,56(sp)
    80004614:	7942                	ld	s2,48(sp)
    80004616:	79a2                	ld	s3,40(sp)
    80004618:	7a02                	ld	s4,32(sp)
    8000461a:	6ae2                	ld	s5,24(sp)
    8000461c:	6161                	addi	sp,sp,80
    8000461e:	8082                	ret
    iunlockput(ip);
    80004620:	8526                	mv	a0,s1
    80004622:	fffff097          	auipc	ra,0xfffff
    80004626:	890080e7          	jalr	-1904(ra) # 80002eb2 <iunlockput>
    return 0;
    8000462a:	4481                	li	s1,0
    8000462c:	b7c5                	j	8000460c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000462e:	85ce                	mv	a1,s3
    80004630:	00092503          	lw	a0,0(s2)
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	484080e7          	jalr	1156(ra) # 80002ab8 <ialloc>
    8000463c:	84aa                	mv	s1,a0
    8000463e:	c529                	beqz	a0,80004688 <create+0xee>
  ilock(ip);
    80004640:	ffffe097          	auipc	ra,0xffffe
    80004644:	610080e7          	jalr	1552(ra) # 80002c50 <ilock>
  ip->major = major;
    80004648:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000464c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004650:	4785                	li	a5,1
    80004652:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004656:	8526                	mv	a0,s1
    80004658:	ffffe097          	auipc	ra,0xffffe
    8000465c:	52e080e7          	jalr	1326(ra) # 80002b86 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004660:	2981                	sext.w	s3,s3
    80004662:	4785                	li	a5,1
    80004664:	02f98a63          	beq	s3,a5,80004698 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004668:	40d0                	lw	a2,4(s1)
    8000466a:	fb040593          	addi	a1,s0,-80
    8000466e:	854a                	mv	a0,s2
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	cd4080e7          	jalr	-812(ra) # 80003344 <dirlink>
    80004678:	06054b63          	bltz	a0,800046ee <create+0x154>
  iunlockput(dp);
    8000467c:	854a                	mv	a0,s2
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	834080e7          	jalr	-1996(ra) # 80002eb2 <iunlockput>
  return ip;
    80004686:	b759                	j	8000460c <create+0x72>
    panic("create: ialloc");
    80004688:	00004517          	auipc	a0,0x4
    8000468c:	08850513          	addi	a0,a0,136 # 80008710 <syscalls+0x2e8>
    80004690:	00001097          	auipc	ra,0x1
    80004694:	688080e7          	jalr	1672(ra) # 80005d18 <panic>
    dp->nlink++;  // for ".."
    80004698:	04a95783          	lhu	a5,74(s2)
    8000469c:	2785                	addiw	a5,a5,1
    8000469e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046a2:	854a                	mv	a0,s2
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	4e2080e7          	jalr	1250(ra) # 80002b86 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ac:	40d0                	lw	a2,4(s1)
    800046ae:	00004597          	auipc	a1,0x4
    800046b2:	07258593          	addi	a1,a1,114 # 80008720 <syscalls+0x2f8>
    800046b6:	8526                	mv	a0,s1
    800046b8:	fffff097          	auipc	ra,0xfffff
    800046bc:	c8c080e7          	jalr	-884(ra) # 80003344 <dirlink>
    800046c0:	00054f63          	bltz	a0,800046de <create+0x144>
    800046c4:	00492603          	lw	a2,4(s2)
    800046c8:	00004597          	auipc	a1,0x4
    800046cc:	06058593          	addi	a1,a1,96 # 80008728 <syscalls+0x300>
    800046d0:	8526                	mv	a0,s1
    800046d2:	fffff097          	auipc	ra,0xfffff
    800046d6:	c72080e7          	jalr	-910(ra) # 80003344 <dirlink>
    800046da:	f80557e3          	bgez	a0,80004668 <create+0xce>
      panic("create dots");
    800046de:	00004517          	auipc	a0,0x4
    800046e2:	05250513          	addi	a0,a0,82 # 80008730 <syscalls+0x308>
    800046e6:	00001097          	auipc	ra,0x1
    800046ea:	632080e7          	jalr	1586(ra) # 80005d18 <panic>
    panic("create: dirlink");
    800046ee:	00004517          	auipc	a0,0x4
    800046f2:	05250513          	addi	a0,a0,82 # 80008740 <syscalls+0x318>
    800046f6:	00001097          	auipc	ra,0x1
    800046fa:	622080e7          	jalr	1570(ra) # 80005d18 <panic>
    return 0;
    800046fe:	84aa                	mv	s1,a0
    80004700:	b731                	j	8000460c <create+0x72>

0000000080004702 <sys_dup>:
{
    80004702:	7179                	addi	sp,sp,-48
    80004704:	f406                	sd	ra,40(sp)
    80004706:	f022                	sd	s0,32(sp)
    80004708:	ec26                	sd	s1,24(sp)
    8000470a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000470c:	fd840613          	addi	a2,s0,-40
    80004710:	4581                	li	a1,0
    80004712:	4501                	li	a0,0
    80004714:	00000097          	auipc	ra,0x0
    80004718:	ddc080e7          	jalr	-548(ra) # 800044f0 <argfd>
    return -1;
    8000471c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000471e:	02054363          	bltz	a0,80004744 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004722:	fd843503          	ld	a0,-40(s0)
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	e32080e7          	jalr	-462(ra) # 80004558 <fdalloc>
    8000472e:	84aa                	mv	s1,a0
    return -1;
    80004730:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004732:	00054963          	bltz	a0,80004744 <sys_dup+0x42>
  filedup(f);
    80004736:	fd843503          	ld	a0,-40(s0)
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	362080e7          	jalr	866(ra) # 80003a9c <filedup>
  return fd;
    80004742:	87a6                	mv	a5,s1
}
    80004744:	853e                	mv	a0,a5
    80004746:	70a2                	ld	ra,40(sp)
    80004748:	7402                	ld	s0,32(sp)
    8000474a:	64e2                	ld	s1,24(sp)
    8000474c:	6145                	addi	sp,sp,48
    8000474e:	8082                	ret

0000000080004750 <sys_read>:
{
    80004750:	7179                	addi	sp,sp,-48
    80004752:	f406                	sd	ra,40(sp)
    80004754:	f022                	sd	s0,32(sp)
    80004756:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004758:	fe840613          	addi	a2,s0,-24
    8000475c:	4581                	li	a1,0
    8000475e:	4501                	li	a0,0
    80004760:	00000097          	auipc	ra,0x0
    80004764:	d90080e7          	jalr	-624(ra) # 800044f0 <argfd>
    return -1;
    80004768:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476a:	04054163          	bltz	a0,800047ac <sys_read+0x5c>
    8000476e:	fe440593          	addi	a1,s0,-28
    80004772:	4509                	li	a0,2
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	95c080e7          	jalr	-1700(ra) # 800020d0 <argint>
    return -1;
    8000477c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477e:	02054763          	bltz	a0,800047ac <sys_read+0x5c>
    80004782:	fd840593          	addi	a1,s0,-40
    80004786:	4505                	li	a0,1
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	96a080e7          	jalr	-1686(ra) # 800020f2 <argaddr>
    return -1;
    80004790:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004792:	00054d63          	bltz	a0,800047ac <sys_read+0x5c>
  return fileread(f, p, n);
    80004796:	fe442603          	lw	a2,-28(s0)
    8000479a:	fd843583          	ld	a1,-40(s0)
    8000479e:	fe843503          	ld	a0,-24(s0)
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	486080e7          	jalr	1158(ra) # 80003c28 <fileread>
    800047aa:	87aa                	mv	a5,a0
}
    800047ac:	853e                	mv	a0,a5
    800047ae:	70a2                	ld	ra,40(sp)
    800047b0:	7402                	ld	s0,32(sp)
    800047b2:	6145                	addi	sp,sp,48
    800047b4:	8082                	ret

00000000800047b6 <sys_write>:
{
    800047b6:	7179                	addi	sp,sp,-48
    800047b8:	f406                	sd	ra,40(sp)
    800047ba:	f022                	sd	s0,32(sp)
    800047bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047be:	fe840613          	addi	a2,s0,-24
    800047c2:	4581                	li	a1,0
    800047c4:	4501                	li	a0,0
    800047c6:	00000097          	auipc	ra,0x0
    800047ca:	d2a080e7          	jalr	-726(ra) # 800044f0 <argfd>
    return -1;
    800047ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d0:	04054163          	bltz	a0,80004812 <sys_write+0x5c>
    800047d4:	fe440593          	addi	a1,s0,-28
    800047d8:	4509                	li	a0,2
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	8f6080e7          	jalr	-1802(ra) # 800020d0 <argint>
    return -1;
    800047e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e4:	02054763          	bltz	a0,80004812 <sys_write+0x5c>
    800047e8:	fd840593          	addi	a1,s0,-40
    800047ec:	4505                	li	a0,1
    800047ee:	ffffe097          	auipc	ra,0xffffe
    800047f2:	904080e7          	jalr	-1788(ra) # 800020f2 <argaddr>
    return -1;
    800047f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f8:	00054d63          	bltz	a0,80004812 <sys_write+0x5c>
  return filewrite(f, p, n);
    800047fc:	fe442603          	lw	a2,-28(s0)
    80004800:	fd843583          	ld	a1,-40(s0)
    80004804:	fe843503          	ld	a0,-24(s0)
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	4e2080e7          	jalr	1250(ra) # 80003cea <filewrite>
    80004810:	87aa                	mv	a5,a0
}
    80004812:	853e                	mv	a0,a5
    80004814:	70a2                	ld	ra,40(sp)
    80004816:	7402                	ld	s0,32(sp)
    80004818:	6145                	addi	sp,sp,48
    8000481a:	8082                	ret

000000008000481c <sys_close>:
{
    8000481c:	1101                	addi	sp,sp,-32
    8000481e:	ec06                	sd	ra,24(sp)
    80004820:	e822                	sd	s0,16(sp)
    80004822:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004824:	fe040613          	addi	a2,s0,-32
    80004828:	fec40593          	addi	a1,s0,-20
    8000482c:	4501                	li	a0,0
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	cc2080e7          	jalr	-830(ra) # 800044f0 <argfd>
    return -1;
    80004836:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004838:	02054463          	bltz	a0,80004860 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000483c:	ffffc097          	auipc	ra,0xffffc
    80004840:	738080e7          	jalr	1848(ra) # 80000f74 <myproc>
    80004844:	fec42783          	lw	a5,-20(s0)
    80004848:	07e9                	addi	a5,a5,26
    8000484a:	078e                	slli	a5,a5,0x3
    8000484c:	97aa                	add	a5,a5,a0
    8000484e:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80004852:	fe043503          	ld	a0,-32(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	298080e7          	jalr	664(ra) # 80003aee <fileclose>
  return 0;
    8000485e:	4781                	li	a5,0
}
    80004860:	853e                	mv	a0,a5
    80004862:	60e2                	ld	ra,24(sp)
    80004864:	6442                	ld	s0,16(sp)
    80004866:	6105                	addi	sp,sp,32
    80004868:	8082                	ret

000000008000486a <sys_fstat>:
{
    8000486a:	1101                	addi	sp,sp,-32
    8000486c:	ec06                	sd	ra,24(sp)
    8000486e:	e822                	sd	s0,16(sp)
    80004870:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004872:	fe840613          	addi	a2,s0,-24
    80004876:	4581                	li	a1,0
    80004878:	4501                	li	a0,0
    8000487a:	00000097          	auipc	ra,0x0
    8000487e:	c76080e7          	jalr	-906(ra) # 800044f0 <argfd>
    return -1;
    80004882:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004884:	02054563          	bltz	a0,800048ae <sys_fstat+0x44>
    80004888:	fe040593          	addi	a1,s0,-32
    8000488c:	4505                	li	a0,1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	864080e7          	jalr	-1948(ra) # 800020f2 <argaddr>
    return -1;
    80004896:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004898:	00054b63          	bltz	a0,800048ae <sys_fstat+0x44>
  return filestat(f, st);
    8000489c:	fe043583          	ld	a1,-32(s0)
    800048a0:	fe843503          	ld	a0,-24(s0)
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	312080e7          	jalr	786(ra) # 80003bb6 <filestat>
    800048ac:	87aa                	mv	a5,a0
}
    800048ae:	853e                	mv	a0,a5
    800048b0:	60e2                	ld	ra,24(sp)
    800048b2:	6442                	ld	s0,16(sp)
    800048b4:	6105                	addi	sp,sp,32
    800048b6:	8082                	ret

00000000800048b8 <sys_link>:
{
    800048b8:	7169                	addi	sp,sp,-304
    800048ba:	f606                	sd	ra,296(sp)
    800048bc:	f222                	sd	s0,288(sp)
    800048be:	ee26                	sd	s1,280(sp)
    800048c0:	ea4a                	sd	s2,272(sp)
    800048c2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048c4:	08000613          	li	a2,128
    800048c8:	ed040593          	addi	a1,s0,-304
    800048cc:	4501                	li	a0,0
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	846080e7          	jalr	-1978(ra) # 80002114 <argstr>
    return -1;
    800048d6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048d8:	10054e63          	bltz	a0,800049f4 <sys_link+0x13c>
    800048dc:	08000613          	li	a2,128
    800048e0:	f5040593          	addi	a1,s0,-176
    800048e4:	4505                	li	a0,1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	82e080e7          	jalr	-2002(ra) # 80002114 <argstr>
    return -1;
    800048ee:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f0:	10054263          	bltz	a0,800049f4 <sys_link+0x13c>
  begin_op();
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	d2e080e7          	jalr	-722(ra) # 80003622 <begin_op>
  if((ip = namei(old)) == 0){
    800048fc:	ed040513          	addi	a0,s0,-304
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	b06080e7          	jalr	-1274(ra) # 80003406 <namei>
    80004908:	84aa                	mv	s1,a0
    8000490a:	c551                	beqz	a0,80004996 <sys_link+0xde>
  ilock(ip);
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	344080e7          	jalr	836(ra) # 80002c50 <ilock>
  if(ip->type == T_DIR){
    80004914:	04449703          	lh	a4,68(s1)
    80004918:	4785                	li	a5,1
    8000491a:	08f70463          	beq	a4,a5,800049a2 <sys_link+0xea>
  ip->nlink++;
    8000491e:	04a4d783          	lhu	a5,74(s1)
    80004922:	2785                	addiw	a5,a5,1
    80004924:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	25c080e7          	jalr	604(ra) # 80002b86 <iupdate>
  iunlock(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	3de080e7          	jalr	990(ra) # 80002d12 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000493c:	fd040593          	addi	a1,s0,-48
    80004940:	f5040513          	addi	a0,s0,-176
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	ae0080e7          	jalr	-1312(ra) # 80003424 <nameiparent>
    8000494c:	892a                	mv	s2,a0
    8000494e:	c935                	beqz	a0,800049c2 <sys_link+0x10a>
  ilock(dp);
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	300080e7          	jalr	768(ra) # 80002c50 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004958:	00092703          	lw	a4,0(s2)
    8000495c:	409c                	lw	a5,0(s1)
    8000495e:	04f71d63          	bne	a4,a5,800049b8 <sys_link+0x100>
    80004962:	40d0                	lw	a2,4(s1)
    80004964:	fd040593          	addi	a1,s0,-48
    80004968:	854a                	mv	a0,s2
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	9da080e7          	jalr	-1574(ra) # 80003344 <dirlink>
    80004972:	04054363          	bltz	a0,800049b8 <sys_link+0x100>
  iunlockput(dp);
    80004976:	854a                	mv	a0,s2
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	53a080e7          	jalr	1338(ra) # 80002eb2 <iunlockput>
  iput(ip);
    80004980:	8526                	mv	a0,s1
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	488080e7          	jalr	1160(ra) # 80002e0a <iput>
  end_op();
    8000498a:	fffff097          	auipc	ra,0xfffff
    8000498e:	d18080e7          	jalr	-744(ra) # 800036a2 <end_op>
  return 0;
    80004992:	4781                	li	a5,0
    80004994:	a085                	j	800049f4 <sys_link+0x13c>
    end_op();
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	d0c080e7          	jalr	-756(ra) # 800036a2 <end_op>
    return -1;
    8000499e:	57fd                	li	a5,-1
    800049a0:	a891                	j	800049f4 <sys_link+0x13c>
    iunlockput(ip);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	50e080e7          	jalr	1294(ra) # 80002eb2 <iunlockput>
    end_op();
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	cf6080e7          	jalr	-778(ra) # 800036a2 <end_op>
    return -1;
    800049b4:	57fd                	li	a5,-1
    800049b6:	a83d                	j	800049f4 <sys_link+0x13c>
    iunlockput(dp);
    800049b8:	854a                	mv	a0,s2
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	4f8080e7          	jalr	1272(ra) # 80002eb2 <iunlockput>
  ilock(ip);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	28c080e7          	jalr	652(ra) # 80002c50 <ilock>
  ip->nlink--;
    800049cc:	04a4d783          	lhu	a5,74(s1)
    800049d0:	37fd                	addiw	a5,a5,-1
    800049d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	1ae080e7          	jalr	430(ra) # 80002b86 <iupdate>
  iunlockput(ip);
    800049e0:	8526                	mv	a0,s1
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	4d0080e7          	jalr	1232(ra) # 80002eb2 <iunlockput>
  end_op();
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	cb8080e7          	jalr	-840(ra) # 800036a2 <end_op>
  return -1;
    800049f2:	57fd                	li	a5,-1
}
    800049f4:	853e                	mv	a0,a5
    800049f6:	70b2                	ld	ra,296(sp)
    800049f8:	7412                	ld	s0,288(sp)
    800049fa:	64f2                	ld	s1,280(sp)
    800049fc:	6952                	ld	s2,272(sp)
    800049fe:	6155                	addi	sp,sp,304
    80004a00:	8082                	ret

0000000080004a02 <sys_unlink>:
{
    80004a02:	7151                	addi	sp,sp,-240
    80004a04:	f586                	sd	ra,232(sp)
    80004a06:	f1a2                	sd	s0,224(sp)
    80004a08:	eda6                	sd	s1,216(sp)
    80004a0a:	e9ca                	sd	s2,208(sp)
    80004a0c:	e5ce                	sd	s3,200(sp)
    80004a0e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a10:	08000613          	li	a2,128
    80004a14:	f3040593          	addi	a1,s0,-208
    80004a18:	4501                	li	a0,0
    80004a1a:	ffffd097          	auipc	ra,0xffffd
    80004a1e:	6fa080e7          	jalr	1786(ra) # 80002114 <argstr>
    80004a22:	18054163          	bltz	a0,80004ba4 <sys_unlink+0x1a2>
  begin_op();
    80004a26:	fffff097          	auipc	ra,0xfffff
    80004a2a:	bfc080e7          	jalr	-1028(ra) # 80003622 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a2e:	fb040593          	addi	a1,s0,-80
    80004a32:	f3040513          	addi	a0,s0,-208
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	9ee080e7          	jalr	-1554(ra) # 80003424 <nameiparent>
    80004a3e:	84aa                	mv	s1,a0
    80004a40:	c979                	beqz	a0,80004b16 <sys_unlink+0x114>
  ilock(dp);
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	20e080e7          	jalr	526(ra) # 80002c50 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a4a:	00004597          	auipc	a1,0x4
    80004a4e:	cd658593          	addi	a1,a1,-810 # 80008720 <syscalls+0x2f8>
    80004a52:	fb040513          	addi	a0,s0,-80
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	6c4080e7          	jalr	1732(ra) # 8000311a <namecmp>
    80004a5e:	14050a63          	beqz	a0,80004bb2 <sys_unlink+0x1b0>
    80004a62:	00004597          	auipc	a1,0x4
    80004a66:	cc658593          	addi	a1,a1,-826 # 80008728 <syscalls+0x300>
    80004a6a:	fb040513          	addi	a0,s0,-80
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	6ac080e7          	jalr	1708(ra) # 8000311a <namecmp>
    80004a76:	12050e63          	beqz	a0,80004bb2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a7a:	f2c40613          	addi	a2,s0,-212
    80004a7e:	fb040593          	addi	a1,s0,-80
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	6b0080e7          	jalr	1712(ra) # 80003134 <dirlookup>
    80004a8c:	892a                	mv	s2,a0
    80004a8e:	12050263          	beqz	a0,80004bb2 <sys_unlink+0x1b0>
  ilock(ip);
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	1be080e7          	jalr	446(ra) # 80002c50 <ilock>
  if(ip->nlink < 1)
    80004a9a:	04a91783          	lh	a5,74(s2)
    80004a9e:	08f05263          	blez	a5,80004b22 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004aa2:	04491703          	lh	a4,68(s2)
    80004aa6:	4785                	li	a5,1
    80004aa8:	08f70563          	beq	a4,a5,80004b32 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004aac:	4641                	li	a2,16
    80004aae:	4581                	li	a1,0
    80004ab0:	fc040513          	addi	a0,s0,-64
    80004ab4:	ffffb097          	auipc	ra,0xffffb
    80004ab8:	6c4080e7          	jalr	1732(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004abc:	4741                	li	a4,16
    80004abe:	f2c42683          	lw	a3,-212(s0)
    80004ac2:	fc040613          	addi	a2,s0,-64
    80004ac6:	4581                	li	a1,0
    80004ac8:	8526                	mv	a0,s1
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	532080e7          	jalr	1330(ra) # 80002ffc <writei>
    80004ad2:	47c1                	li	a5,16
    80004ad4:	0af51563          	bne	a0,a5,80004b7e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004ad8:	04491703          	lh	a4,68(s2)
    80004adc:	4785                	li	a5,1
    80004ade:	0af70863          	beq	a4,a5,80004b8e <sys_unlink+0x18c>
  iunlockput(dp);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	3ce080e7          	jalr	974(ra) # 80002eb2 <iunlockput>
  ip->nlink--;
    80004aec:	04a95783          	lhu	a5,74(s2)
    80004af0:	37fd                	addiw	a5,a5,-1
    80004af2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004af6:	854a                	mv	a0,s2
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	08e080e7          	jalr	142(ra) # 80002b86 <iupdate>
  iunlockput(ip);
    80004b00:	854a                	mv	a0,s2
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	3b0080e7          	jalr	944(ra) # 80002eb2 <iunlockput>
  end_op();
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	b98080e7          	jalr	-1128(ra) # 800036a2 <end_op>
  return 0;
    80004b12:	4501                	li	a0,0
    80004b14:	a84d                	j	80004bc6 <sys_unlink+0x1c4>
    end_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	b8c080e7          	jalr	-1140(ra) # 800036a2 <end_op>
    return -1;
    80004b1e:	557d                	li	a0,-1
    80004b20:	a05d                	j	80004bc6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b22:	00004517          	auipc	a0,0x4
    80004b26:	c2e50513          	addi	a0,a0,-978 # 80008750 <syscalls+0x328>
    80004b2a:	00001097          	auipc	ra,0x1
    80004b2e:	1ee080e7          	jalr	494(ra) # 80005d18 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b32:	04c92703          	lw	a4,76(s2)
    80004b36:	02000793          	li	a5,32
    80004b3a:	f6e7f9e3          	bgeu	a5,a4,80004aac <sys_unlink+0xaa>
    80004b3e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b42:	4741                	li	a4,16
    80004b44:	86ce                	mv	a3,s3
    80004b46:	f1840613          	addi	a2,s0,-232
    80004b4a:	4581                	li	a1,0
    80004b4c:	854a                	mv	a0,s2
    80004b4e:	ffffe097          	auipc	ra,0xffffe
    80004b52:	3b6080e7          	jalr	950(ra) # 80002f04 <readi>
    80004b56:	47c1                	li	a5,16
    80004b58:	00f51b63          	bne	a0,a5,80004b6e <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b5c:	f1845783          	lhu	a5,-232(s0)
    80004b60:	e7a1                	bnez	a5,80004ba8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b62:	29c1                	addiw	s3,s3,16
    80004b64:	04c92783          	lw	a5,76(s2)
    80004b68:	fcf9ede3          	bltu	s3,a5,80004b42 <sys_unlink+0x140>
    80004b6c:	b781                	j	80004aac <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b6e:	00004517          	auipc	a0,0x4
    80004b72:	bfa50513          	addi	a0,a0,-1030 # 80008768 <syscalls+0x340>
    80004b76:	00001097          	auipc	ra,0x1
    80004b7a:	1a2080e7          	jalr	418(ra) # 80005d18 <panic>
    panic("unlink: writei");
    80004b7e:	00004517          	auipc	a0,0x4
    80004b82:	c0250513          	addi	a0,a0,-1022 # 80008780 <syscalls+0x358>
    80004b86:	00001097          	auipc	ra,0x1
    80004b8a:	192080e7          	jalr	402(ra) # 80005d18 <panic>
    dp->nlink--;
    80004b8e:	04a4d783          	lhu	a5,74(s1)
    80004b92:	37fd                	addiw	a5,a5,-1
    80004b94:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	fec080e7          	jalr	-20(ra) # 80002b86 <iupdate>
    80004ba2:	b781                	j	80004ae2 <sys_unlink+0xe0>
    return -1;
    80004ba4:	557d                	li	a0,-1
    80004ba6:	a005                	j	80004bc6 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ba8:	854a                	mv	a0,s2
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	308080e7          	jalr	776(ra) # 80002eb2 <iunlockput>
  iunlockput(dp);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	2fe080e7          	jalr	766(ra) # 80002eb2 <iunlockput>
  end_op();
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	ae6080e7          	jalr	-1306(ra) # 800036a2 <end_op>
  return -1;
    80004bc4:	557d                	li	a0,-1
}
    80004bc6:	70ae                	ld	ra,232(sp)
    80004bc8:	740e                	ld	s0,224(sp)
    80004bca:	64ee                	ld	s1,216(sp)
    80004bcc:	694e                	ld	s2,208(sp)
    80004bce:	69ae                	ld	s3,200(sp)
    80004bd0:	616d                	addi	sp,sp,240
    80004bd2:	8082                	ret

0000000080004bd4 <sys_open>:

uint64
sys_open(void)
{
    80004bd4:	7131                	addi	sp,sp,-192
    80004bd6:	fd06                	sd	ra,184(sp)
    80004bd8:	f922                	sd	s0,176(sp)
    80004bda:	f526                	sd	s1,168(sp)
    80004bdc:	f14a                	sd	s2,160(sp)
    80004bde:	ed4e                	sd	s3,152(sp)
    80004be0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004be2:	08000613          	li	a2,128
    80004be6:	f5040593          	addi	a1,s0,-176
    80004bea:	4501                	li	a0,0
    80004bec:	ffffd097          	auipc	ra,0xffffd
    80004bf0:	528080e7          	jalr	1320(ra) # 80002114 <argstr>
    return -1;
    80004bf4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bf6:	0c054163          	bltz	a0,80004cb8 <sys_open+0xe4>
    80004bfa:	f4c40593          	addi	a1,s0,-180
    80004bfe:	4505                	li	a0,1
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	4d0080e7          	jalr	1232(ra) # 800020d0 <argint>
    80004c08:	0a054863          	bltz	a0,80004cb8 <sys_open+0xe4>

  begin_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	a16080e7          	jalr	-1514(ra) # 80003622 <begin_op>

  if(omode & O_CREATE){
    80004c14:	f4c42783          	lw	a5,-180(s0)
    80004c18:	2007f793          	andi	a5,a5,512
    80004c1c:	cbdd                	beqz	a5,80004cd2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c1e:	4681                	li	a3,0
    80004c20:	4601                	li	a2,0
    80004c22:	4589                	li	a1,2
    80004c24:	f5040513          	addi	a0,s0,-176
    80004c28:	00000097          	auipc	ra,0x0
    80004c2c:	972080e7          	jalr	-1678(ra) # 8000459a <create>
    80004c30:	892a                	mv	s2,a0
    if(ip == 0){
    80004c32:	c959                	beqz	a0,80004cc8 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c34:	04491703          	lh	a4,68(s2)
    80004c38:	478d                	li	a5,3
    80004c3a:	00f71763          	bne	a4,a5,80004c48 <sys_open+0x74>
    80004c3e:	04695703          	lhu	a4,70(s2)
    80004c42:	47a5                	li	a5,9
    80004c44:	0ce7ec63          	bltu	a5,a4,80004d1c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	dea080e7          	jalr	-534(ra) # 80003a32 <filealloc>
    80004c50:	89aa                	mv	s3,a0
    80004c52:	10050263          	beqz	a0,80004d56 <sys_open+0x182>
    80004c56:	00000097          	auipc	ra,0x0
    80004c5a:	902080e7          	jalr	-1790(ra) # 80004558 <fdalloc>
    80004c5e:	84aa                	mv	s1,a0
    80004c60:	0e054663          	bltz	a0,80004d4c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c64:	04491703          	lh	a4,68(s2)
    80004c68:	478d                	li	a5,3
    80004c6a:	0cf70463          	beq	a4,a5,80004d32 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c6e:	4789                	li	a5,2
    80004c70:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c74:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c78:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c7c:	f4c42783          	lw	a5,-180(s0)
    80004c80:	0017c713          	xori	a4,a5,1
    80004c84:	8b05                	andi	a4,a4,1
    80004c86:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c8a:	0037f713          	andi	a4,a5,3
    80004c8e:	00e03733          	snez	a4,a4
    80004c92:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c96:	4007f793          	andi	a5,a5,1024
    80004c9a:	c791                	beqz	a5,80004ca6 <sys_open+0xd2>
    80004c9c:	04491703          	lh	a4,68(s2)
    80004ca0:	4789                	li	a5,2
    80004ca2:	08f70f63          	beq	a4,a5,80004d40 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ca6:	854a                	mv	a0,s2
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	06a080e7          	jalr	106(ra) # 80002d12 <iunlock>
  end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	9f2080e7          	jalr	-1550(ra) # 800036a2 <end_op>

  return fd;
}
    80004cb8:	8526                	mv	a0,s1
    80004cba:	70ea                	ld	ra,184(sp)
    80004cbc:	744a                	ld	s0,176(sp)
    80004cbe:	74aa                	ld	s1,168(sp)
    80004cc0:	790a                	ld	s2,160(sp)
    80004cc2:	69ea                	ld	s3,152(sp)
    80004cc4:	6129                	addi	sp,sp,192
    80004cc6:	8082                	ret
      end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	9da080e7          	jalr	-1574(ra) # 800036a2 <end_op>
      return -1;
    80004cd0:	b7e5                	j	80004cb8 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004cd2:	f5040513          	addi	a0,s0,-176
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	730080e7          	jalr	1840(ra) # 80003406 <namei>
    80004cde:	892a                	mv	s2,a0
    80004ce0:	c905                	beqz	a0,80004d10 <sys_open+0x13c>
    ilock(ip);
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	f6e080e7          	jalr	-146(ra) # 80002c50 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cea:	04491703          	lh	a4,68(s2)
    80004cee:	4785                	li	a5,1
    80004cf0:	f4f712e3          	bne	a4,a5,80004c34 <sys_open+0x60>
    80004cf4:	f4c42783          	lw	a5,-180(s0)
    80004cf8:	dba1                	beqz	a5,80004c48 <sys_open+0x74>
      iunlockput(ip);
    80004cfa:	854a                	mv	a0,s2
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	1b6080e7          	jalr	438(ra) # 80002eb2 <iunlockput>
      end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	99e080e7          	jalr	-1634(ra) # 800036a2 <end_op>
      return -1;
    80004d0c:	54fd                	li	s1,-1
    80004d0e:	b76d                	j	80004cb8 <sys_open+0xe4>
      end_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	992080e7          	jalr	-1646(ra) # 800036a2 <end_op>
      return -1;
    80004d18:	54fd                	li	s1,-1
    80004d1a:	bf79                	j	80004cb8 <sys_open+0xe4>
    iunlockput(ip);
    80004d1c:	854a                	mv	a0,s2
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	194080e7          	jalr	404(ra) # 80002eb2 <iunlockput>
    end_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	97c080e7          	jalr	-1668(ra) # 800036a2 <end_op>
    return -1;
    80004d2e:	54fd                	li	s1,-1
    80004d30:	b761                	j	80004cb8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d32:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d36:	04691783          	lh	a5,70(s2)
    80004d3a:	02f99223          	sh	a5,36(s3)
    80004d3e:	bf2d                	j	80004c78 <sys_open+0xa4>
    itrunc(ip);
    80004d40:	854a                	mv	a0,s2
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	01c080e7          	jalr	28(ra) # 80002d5e <itrunc>
    80004d4a:	bfb1                	j	80004ca6 <sys_open+0xd2>
      fileclose(f);
    80004d4c:	854e                	mv	a0,s3
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	da0080e7          	jalr	-608(ra) # 80003aee <fileclose>
    iunlockput(ip);
    80004d56:	854a                	mv	a0,s2
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	15a080e7          	jalr	346(ra) # 80002eb2 <iunlockput>
    end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	942080e7          	jalr	-1726(ra) # 800036a2 <end_op>
    return -1;
    80004d68:	54fd                	li	s1,-1
    80004d6a:	b7b9                	j	80004cb8 <sys_open+0xe4>

0000000080004d6c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d6c:	7175                	addi	sp,sp,-144
    80004d6e:	e506                	sd	ra,136(sp)
    80004d70:	e122                	sd	s0,128(sp)
    80004d72:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	8ae080e7          	jalr	-1874(ra) # 80003622 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d7c:	08000613          	li	a2,128
    80004d80:	f7040593          	addi	a1,s0,-144
    80004d84:	4501                	li	a0,0
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	38e080e7          	jalr	910(ra) # 80002114 <argstr>
    80004d8e:	02054963          	bltz	a0,80004dc0 <sys_mkdir+0x54>
    80004d92:	4681                	li	a3,0
    80004d94:	4601                	li	a2,0
    80004d96:	4585                	li	a1,1
    80004d98:	f7040513          	addi	a0,s0,-144
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	7fe080e7          	jalr	2046(ra) # 8000459a <create>
    80004da4:	cd11                	beqz	a0,80004dc0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	10c080e7          	jalr	268(ra) # 80002eb2 <iunlockput>
  end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	8f4080e7          	jalr	-1804(ra) # 800036a2 <end_op>
  return 0;
    80004db6:	4501                	li	a0,0
}
    80004db8:	60aa                	ld	ra,136(sp)
    80004dba:	640a                	ld	s0,128(sp)
    80004dbc:	6149                	addi	sp,sp,144
    80004dbe:	8082                	ret
    end_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	8e2080e7          	jalr	-1822(ra) # 800036a2 <end_op>
    return -1;
    80004dc8:	557d                	li	a0,-1
    80004dca:	b7fd                	j	80004db8 <sys_mkdir+0x4c>

0000000080004dcc <sys_mknod>:

uint64
sys_mknod(void)
{
    80004dcc:	7135                	addi	sp,sp,-160
    80004dce:	ed06                	sd	ra,152(sp)
    80004dd0:	e922                	sd	s0,144(sp)
    80004dd2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	84e080e7          	jalr	-1970(ra) # 80003622 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ddc:	08000613          	li	a2,128
    80004de0:	f7040593          	addi	a1,s0,-144
    80004de4:	4501                	li	a0,0
    80004de6:	ffffd097          	auipc	ra,0xffffd
    80004dea:	32e080e7          	jalr	814(ra) # 80002114 <argstr>
    80004dee:	04054a63          	bltz	a0,80004e42 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004df2:	f6c40593          	addi	a1,s0,-148
    80004df6:	4505                	li	a0,1
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	2d8080e7          	jalr	728(ra) # 800020d0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e00:	04054163          	bltz	a0,80004e42 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e04:	f6840593          	addi	a1,s0,-152
    80004e08:	4509                	li	a0,2
    80004e0a:	ffffd097          	auipc	ra,0xffffd
    80004e0e:	2c6080e7          	jalr	710(ra) # 800020d0 <argint>
     argint(1, &major) < 0 ||
    80004e12:	02054863          	bltz	a0,80004e42 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e16:	f6841683          	lh	a3,-152(s0)
    80004e1a:	f6c41603          	lh	a2,-148(s0)
    80004e1e:	458d                	li	a1,3
    80004e20:	f7040513          	addi	a0,s0,-144
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	776080e7          	jalr	1910(ra) # 8000459a <create>
     argint(2, &minor) < 0 ||
    80004e2c:	c919                	beqz	a0,80004e42 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	084080e7          	jalr	132(ra) # 80002eb2 <iunlockput>
  end_op();
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	86c080e7          	jalr	-1940(ra) # 800036a2 <end_op>
  return 0;
    80004e3e:	4501                	li	a0,0
    80004e40:	a031                	j	80004e4c <sys_mknod+0x80>
    end_op();
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	860080e7          	jalr	-1952(ra) # 800036a2 <end_op>
    return -1;
    80004e4a:	557d                	li	a0,-1
}
    80004e4c:	60ea                	ld	ra,152(sp)
    80004e4e:	644a                	ld	s0,144(sp)
    80004e50:	610d                	addi	sp,sp,160
    80004e52:	8082                	ret

0000000080004e54 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e54:	7135                	addi	sp,sp,-160
    80004e56:	ed06                	sd	ra,152(sp)
    80004e58:	e922                	sd	s0,144(sp)
    80004e5a:	e526                	sd	s1,136(sp)
    80004e5c:	e14a                	sd	s2,128(sp)
    80004e5e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	114080e7          	jalr	276(ra) # 80000f74 <myproc>
    80004e68:	892a                	mv	s2,a0
  
  begin_op();
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	7b8080e7          	jalr	1976(ra) # 80003622 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e72:	08000613          	li	a2,128
    80004e76:	f6040593          	addi	a1,s0,-160
    80004e7a:	4501                	li	a0,0
    80004e7c:	ffffd097          	auipc	ra,0xffffd
    80004e80:	298080e7          	jalr	664(ra) # 80002114 <argstr>
    80004e84:	04054b63          	bltz	a0,80004eda <sys_chdir+0x86>
    80004e88:	f6040513          	addi	a0,s0,-160
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	57a080e7          	jalr	1402(ra) # 80003406 <namei>
    80004e94:	84aa                	mv	s1,a0
    80004e96:	c131                	beqz	a0,80004eda <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	db8080e7          	jalr	-584(ra) # 80002c50 <ilock>
  if(ip->type != T_DIR){
    80004ea0:	04449703          	lh	a4,68(s1)
    80004ea4:	4785                	li	a5,1
    80004ea6:	04f71063          	bne	a4,a5,80004ee6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eaa:	8526                	mv	a0,s1
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	e66080e7          	jalr	-410(ra) # 80002d12 <iunlock>
  iput(p->cwd);
    80004eb4:	15893503          	ld	a0,344(s2)
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	f52080e7          	jalr	-174(ra) # 80002e0a <iput>
  end_op();
    80004ec0:	ffffe097          	auipc	ra,0xffffe
    80004ec4:	7e2080e7          	jalr	2018(ra) # 800036a2 <end_op>
  p->cwd = ip;
    80004ec8:	14993c23          	sd	s1,344(s2)
  return 0;
    80004ecc:	4501                	li	a0,0
}
    80004ece:	60ea                	ld	ra,152(sp)
    80004ed0:	644a                	ld	s0,144(sp)
    80004ed2:	64aa                	ld	s1,136(sp)
    80004ed4:	690a                	ld	s2,128(sp)
    80004ed6:	610d                	addi	sp,sp,160
    80004ed8:	8082                	ret
    end_op();
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	7c8080e7          	jalr	1992(ra) # 800036a2 <end_op>
    return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	b7ed                	j	80004ece <sys_chdir+0x7a>
    iunlockput(ip);
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	fca080e7          	jalr	-54(ra) # 80002eb2 <iunlockput>
    end_op();
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	7b2080e7          	jalr	1970(ra) # 800036a2 <end_op>
    return -1;
    80004ef8:	557d                	li	a0,-1
    80004efa:	bfd1                	j	80004ece <sys_chdir+0x7a>

0000000080004efc <sys_exec>:

uint64
sys_exec(void)
{
    80004efc:	7145                	addi	sp,sp,-464
    80004efe:	e786                	sd	ra,456(sp)
    80004f00:	e3a2                	sd	s0,448(sp)
    80004f02:	ff26                	sd	s1,440(sp)
    80004f04:	fb4a                	sd	s2,432(sp)
    80004f06:	f74e                	sd	s3,424(sp)
    80004f08:	f352                	sd	s4,416(sp)
    80004f0a:	ef56                	sd	s5,408(sp)
    80004f0c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f0e:	08000613          	li	a2,128
    80004f12:	f4040593          	addi	a1,s0,-192
    80004f16:	4501                	li	a0,0
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	1fc080e7          	jalr	508(ra) # 80002114 <argstr>
    return -1;
    80004f20:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f22:	0c054a63          	bltz	a0,80004ff6 <sys_exec+0xfa>
    80004f26:	e3840593          	addi	a1,s0,-456
    80004f2a:	4505                	li	a0,1
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	1c6080e7          	jalr	454(ra) # 800020f2 <argaddr>
    80004f34:	0c054163          	bltz	a0,80004ff6 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f38:	10000613          	li	a2,256
    80004f3c:	4581                	li	a1,0
    80004f3e:	e4040513          	addi	a0,s0,-448
    80004f42:	ffffb097          	auipc	ra,0xffffb
    80004f46:	236080e7          	jalr	566(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f4a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f4e:	89a6                	mv	s3,s1
    80004f50:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f52:	02000a13          	li	s4,32
    80004f56:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f5a:	00391513          	slli	a0,s2,0x3
    80004f5e:	e3040593          	addi	a1,s0,-464
    80004f62:	e3843783          	ld	a5,-456(s0)
    80004f66:	953e                	add	a0,a0,a5
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	0ce080e7          	jalr	206(ra) # 80002036 <fetchaddr>
    80004f70:	02054a63          	bltz	a0,80004fa4 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f74:	e3043783          	ld	a5,-464(s0)
    80004f78:	c3b9                	beqz	a5,80004fbe <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f7a:	ffffb097          	auipc	ra,0xffffb
    80004f7e:	19e080e7          	jalr	414(ra) # 80000118 <kalloc>
    80004f82:	85aa                	mv	a1,a0
    80004f84:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f88:	cd11                	beqz	a0,80004fa4 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f8a:	6605                	lui	a2,0x1
    80004f8c:	e3043503          	ld	a0,-464(s0)
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	0f8080e7          	jalr	248(ra) # 80002088 <fetchstr>
    80004f98:	00054663          	bltz	a0,80004fa4 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f9c:	0905                	addi	s2,s2,1
    80004f9e:	09a1                	addi	s3,s3,8
    80004fa0:	fb491be3          	bne	s2,s4,80004f56 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa4:	10048913          	addi	s2,s1,256
    80004fa8:	6088                	ld	a0,0(s1)
    80004faa:	c529                	beqz	a0,80004ff4 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fac:	ffffb097          	auipc	ra,0xffffb
    80004fb0:	070080e7          	jalr	112(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb4:	04a1                	addi	s1,s1,8
    80004fb6:	ff2499e3          	bne	s1,s2,80004fa8 <sys_exec+0xac>
  return -1;
    80004fba:	597d                	li	s2,-1
    80004fbc:	a82d                	j	80004ff6 <sys_exec+0xfa>
      argv[i] = 0;
    80004fbe:	0a8e                	slli	s5,s5,0x3
    80004fc0:	fc040793          	addi	a5,s0,-64
    80004fc4:	9abe                	add	s5,s5,a5
    80004fc6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fca:	e4040593          	addi	a1,s0,-448
    80004fce:	f4040513          	addi	a0,s0,-192
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	17c080e7          	jalr	380(ra) # 8000414e <exec>
    80004fda:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fdc:	10048993          	addi	s3,s1,256
    80004fe0:	6088                	ld	a0,0(s1)
    80004fe2:	c911                	beqz	a0,80004ff6 <sys_exec+0xfa>
    kfree(argv[i]);
    80004fe4:	ffffb097          	auipc	ra,0xffffb
    80004fe8:	038080e7          	jalr	56(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fec:	04a1                	addi	s1,s1,8
    80004fee:	ff3499e3          	bne	s1,s3,80004fe0 <sys_exec+0xe4>
    80004ff2:	a011                	j	80004ff6 <sys_exec+0xfa>
  return -1;
    80004ff4:	597d                	li	s2,-1
}
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	60be                	ld	ra,456(sp)
    80004ffa:	641e                	ld	s0,448(sp)
    80004ffc:	74fa                	ld	s1,440(sp)
    80004ffe:	795a                	ld	s2,432(sp)
    80005000:	79ba                	ld	s3,424(sp)
    80005002:	7a1a                	ld	s4,416(sp)
    80005004:	6afa                	ld	s5,408(sp)
    80005006:	6179                	addi	sp,sp,464
    80005008:	8082                	ret

000000008000500a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000500a:	7139                	addi	sp,sp,-64
    8000500c:	fc06                	sd	ra,56(sp)
    8000500e:	f822                	sd	s0,48(sp)
    80005010:	f426                	sd	s1,40(sp)
    80005012:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	f60080e7          	jalr	-160(ra) # 80000f74 <myproc>
    8000501c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000501e:	fd840593          	addi	a1,s0,-40
    80005022:	4501                	li	a0,0
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	0ce080e7          	jalr	206(ra) # 800020f2 <argaddr>
    return -1;
    8000502c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000502e:	0e054063          	bltz	a0,8000510e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005032:	fc840593          	addi	a1,s0,-56
    80005036:	fd040513          	addi	a0,s0,-48
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	de4080e7          	jalr	-540(ra) # 80003e1e <pipealloc>
    return -1;
    80005042:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005044:	0c054563          	bltz	a0,8000510e <sys_pipe+0x104>
  fd0 = -1;
    80005048:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000504c:	fd043503          	ld	a0,-48(s0)
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	508080e7          	jalr	1288(ra) # 80004558 <fdalloc>
    80005058:	fca42223          	sw	a0,-60(s0)
    8000505c:	08054c63          	bltz	a0,800050f4 <sys_pipe+0xea>
    80005060:	fc843503          	ld	a0,-56(s0)
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	4f4080e7          	jalr	1268(ra) # 80004558 <fdalloc>
    8000506c:	fca42023          	sw	a0,-64(s0)
    80005070:	06054863          	bltz	a0,800050e0 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005074:	4691                	li	a3,4
    80005076:	fc440613          	addi	a2,s0,-60
    8000507a:	fd843583          	ld	a1,-40(s0)
    8000507e:	68a8                	ld	a0,80(s1)
    80005080:	ffffc097          	auipc	ra,0xffffc
    80005084:	a8a080e7          	jalr	-1398(ra) # 80000b0a <copyout>
    80005088:	02054063          	bltz	a0,800050a8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000508c:	4691                	li	a3,4
    8000508e:	fc040613          	addi	a2,s0,-64
    80005092:	fd843583          	ld	a1,-40(s0)
    80005096:	0591                	addi	a1,a1,4
    80005098:	68a8                	ld	a0,80(s1)
    8000509a:	ffffc097          	auipc	ra,0xffffc
    8000509e:	a70080e7          	jalr	-1424(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050a2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050a4:	06055563          	bgez	a0,8000510e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050a8:	fc442783          	lw	a5,-60(s0)
    800050ac:	07e9                	addi	a5,a5,26
    800050ae:	078e                	slli	a5,a5,0x3
    800050b0:	97a6                	add	a5,a5,s1
    800050b2:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800050b6:	fc042503          	lw	a0,-64(s0)
    800050ba:	0569                	addi	a0,a0,26
    800050bc:	050e                	slli	a0,a0,0x3
    800050be:	9526                	add	a0,a0,s1
    800050c0:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800050c4:	fd043503          	ld	a0,-48(s0)
    800050c8:	fffff097          	auipc	ra,0xfffff
    800050cc:	a26080e7          	jalr	-1498(ra) # 80003aee <fileclose>
    fileclose(wf);
    800050d0:	fc843503          	ld	a0,-56(s0)
    800050d4:	fffff097          	auipc	ra,0xfffff
    800050d8:	a1a080e7          	jalr	-1510(ra) # 80003aee <fileclose>
    return -1;
    800050dc:	57fd                	li	a5,-1
    800050de:	a805                	j	8000510e <sys_pipe+0x104>
    if(fd0 >= 0)
    800050e0:	fc442783          	lw	a5,-60(s0)
    800050e4:	0007c863          	bltz	a5,800050f4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050e8:	01a78513          	addi	a0,a5,26
    800050ec:	050e                	slli	a0,a0,0x3
    800050ee:	9526                	add	a0,a0,s1
    800050f0:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800050f4:	fd043503          	ld	a0,-48(s0)
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	9f6080e7          	jalr	-1546(ra) # 80003aee <fileclose>
    fileclose(wf);
    80005100:	fc843503          	ld	a0,-56(s0)
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	9ea080e7          	jalr	-1558(ra) # 80003aee <fileclose>
    return -1;
    8000510c:	57fd                	li	a5,-1
}
    8000510e:	853e                	mv	a0,a5
    80005110:	70e2                	ld	ra,56(sp)
    80005112:	7442                	ld	s0,48(sp)
    80005114:	74a2                	ld	s1,40(sp)
    80005116:	6121                	addi	sp,sp,64
    80005118:	8082                	ret
    8000511a:	0000                	unimp
    8000511c:	0000                	unimp
	...

0000000080005120 <kernelvec>:
    80005120:	7111                	addi	sp,sp,-256
    80005122:	e006                	sd	ra,0(sp)
    80005124:	e40a                	sd	sp,8(sp)
    80005126:	e80e                	sd	gp,16(sp)
    80005128:	ec12                	sd	tp,24(sp)
    8000512a:	f016                	sd	t0,32(sp)
    8000512c:	f41a                	sd	t1,40(sp)
    8000512e:	f81e                	sd	t2,48(sp)
    80005130:	fc22                	sd	s0,56(sp)
    80005132:	e0a6                	sd	s1,64(sp)
    80005134:	e4aa                	sd	a0,72(sp)
    80005136:	e8ae                	sd	a1,80(sp)
    80005138:	ecb2                	sd	a2,88(sp)
    8000513a:	f0b6                	sd	a3,96(sp)
    8000513c:	f4ba                	sd	a4,104(sp)
    8000513e:	f8be                	sd	a5,112(sp)
    80005140:	fcc2                	sd	a6,120(sp)
    80005142:	e146                	sd	a7,128(sp)
    80005144:	e54a                	sd	s2,136(sp)
    80005146:	e94e                	sd	s3,144(sp)
    80005148:	ed52                	sd	s4,152(sp)
    8000514a:	f156                	sd	s5,160(sp)
    8000514c:	f55a                	sd	s6,168(sp)
    8000514e:	f95e                	sd	s7,176(sp)
    80005150:	fd62                	sd	s8,184(sp)
    80005152:	e1e6                	sd	s9,192(sp)
    80005154:	e5ea                	sd	s10,200(sp)
    80005156:	e9ee                	sd	s11,208(sp)
    80005158:	edf2                	sd	t3,216(sp)
    8000515a:	f1f6                	sd	t4,224(sp)
    8000515c:	f5fa                	sd	t5,232(sp)
    8000515e:	f9fe                	sd	t6,240(sp)
    80005160:	da3fc0ef          	jal	ra,80001f02 <kerneltrap>
    80005164:	6082                	ld	ra,0(sp)
    80005166:	6122                	ld	sp,8(sp)
    80005168:	61c2                	ld	gp,16(sp)
    8000516a:	7282                	ld	t0,32(sp)
    8000516c:	7322                	ld	t1,40(sp)
    8000516e:	73c2                	ld	t2,48(sp)
    80005170:	7462                	ld	s0,56(sp)
    80005172:	6486                	ld	s1,64(sp)
    80005174:	6526                	ld	a0,72(sp)
    80005176:	65c6                	ld	a1,80(sp)
    80005178:	6666                	ld	a2,88(sp)
    8000517a:	7686                	ld	a3,96(sp)
    8000517c:	7726                	ld	a4,104(sp)
    8000517e:	77c6                	ld	a5,112(sp)
    80005180:	7866                	ld	a6,120(sp)
    80005182:	688a                	ld	a7,128(sp)
    80005184:	692a                	ld	s2,136(sp)
    80005186:	69ca                	ld	s3,144(sp)
    80005188:	6a6a                	ld	s4,152(sp)
    8000518a:	7a8a                	ld	s5,160(sp)
    8000518c:	7b2a                	ld	s6,168(sp)
    8000518e:	7bca                	ld	s7,176(sp)
    80005190:	7c6a                	ld	s8,184(sp)
    80005192:	6c8e                	ld	s9,192(sp)
    80005194:	6d2e                	ld	s10,200(sp)
    80005196:	6dce                	ld	s11,208(sp)
    80005198:	6e6e                	ld	t3,216(sp)
    8000519a:	7e8e                	ld	t4,224(sp)
    8000519c:	7f2e                	ld	t5,232(sp)
    8000519e:	7fce                	ld	t6,240(sp)
    800051a0:	6111                	addi	sp,sp,256
    800051a2:	10200073          	sret
    800051a6:	00000013          	nop
    800051aa:	00000013          	nop
    800051ae:	0001                	nop

00000000800051b0 <timervec>:
    800051b0:	34051573          	csrrw	a0,mscratch,a0
    800051b4:	e10c                	sd	a1,0(a0)
    800051b6:	e510                	sd	a2,8(a0)
    800051b8:	e914                	sd	a3,16(a0)
    800051ba:	6d0c                	ld	a1,24(a0)
    800051bc:	7110                	ld	a2,32(a0)
    800051be:	6194                	ld	a3,0(a1)
    800051c0:	96b2                	add	a3,a3,a2
    800051c2:	e194                	sd	a3,0(a1)
    800051c4:	4589                	li	a1,2
    800051c6:	14459073          	csrw	sip,a1
    800051ca:	6914                	ld	a3,16(a0)
    800051cc:	6510                	ld	a2,8(a0)
    800051ce:	610c                	ld	a1,0(a0)
    800051d0:	34051573          	csrrw	a0,mscratch,a0
    800051d4:	30200073          	mret
	...

00000000800051da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051da:	1141                	addi	sp,sp,-16
    800051dc:	e422                	sd	s0,8(sp)
    800051de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051e0:	0c0007b7          	lui	a5,0xc000
    800051e4:	4705                	li	a4,1
    800051e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051e8:	c3d8                	sw	a4,4(a5)
}
    800051ea:	6422                	ld	s0,8(sp)
    800051ec:	0141                	addi	sp,sp,16
    800051ee:	8082                	ret

00000000800051f0 <plicinithart>:

void
plicinithart(void)
{
    800051f0:	1141                	addi	sp,sp,-16
    800051f2:	e406                	sd	ra,8(sp)
    800051f4:	e022                	sd	s0,0(sp)
    800051f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	d50080e7          	jalr	-688(ra) # 80000f48 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005200:	0085171b          	slliw	a4,a0,0x8
    80005204:	0c0027b7          	lui	a5,0xc002
    80005208:	97ba                	add	a5,a5,a4
    8000520a:	40200713          	li	a4,1026
    8000520e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005212:	00d5151b          	slliw	a0,a0,0xd
    80005216:	0c2017b7          	lui	a5,0xc201
    8000521a:	953e                	add	a0,a0,a5
    8000521c:	00052023          	sw	zero,0(a0)
}
    80005220:	60a2                	ld	ra,8(sp)
    80005222:	6402                	ld	s0,0(sp)
    80005224:	0141                	addi	sp,sp,16
    80005226:	8082                	ret

0000000080005228 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005228:	1141                	addi	sp,sp,-16
    8000522a:	e406                	sd	ra,8(sp)
    8000522c:	e022                	sd	s0,0(sp)
    8000522e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005230:	ffffc097          	auipc	ra,0xffffc
    80005234:	d18080e7          	jalr	-744(ra) # 80000f48 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005238:	00d5179b          	slliw	a5,a0,0xd
    8000523c:	0c201537          	lui	a0,0xc201
    80005240:	953e                	add	a0,a0,a5
  return irq;
}
    80005242:	4148                	lw	a0,4(a0)
    80005244:	60a2                	ld	ra,8(sp)
    80005246:	6402                	ld	s0,0(sp)
    80005248:	0141                	addi	sp,sp,16
    8000524a:	8082                	ret

000000008000524c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000524c:	1101                	addi	sp,sp,-32
    8000524e:	ec06                	sd	ra,24(sp)
    80005250:	e822                	sd	s0,16(sp)
    80005252:	e426                	sd	s1,8(sp)
    80005254:	1000                	addi	s0,sp,32
    80005256:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	cf0080e7          	jalr	-784(ra) # 80000f48 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005260:	00d5151b          	slliw	a0,a0,0xd
    80005264:	0c2017b7          	lui	a5,0xc201
    80005268:	97aa                	add	a5,a5,a0
    8000526a:	c3c4                	sw	s1,4(a5)
}
    8000526c:	60e2                	ld	ra,24(sp)
    8000526e:	6442                	ld	s0,16(sp)
    80005270:	64a2                	ld	s1,8(sp)
    80005272:	6105                	addi	sp,sp,32
    80005274:	8082                	ret

0000000080005276 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005276:	1141                	addi	sp,sp,-16
    80005278:	e406                	sd	ra,8(sp)
    8000527a:	e022                	sd	s0,0(sp)
    8000527c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000527e:	479d                	li	a5,7
    80005280:	06a7c963          	blt	a5,a0,800052f2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005284:	00016797          	auipc	a5,0x16
    80005288:	d7c78793          	addi	a5,a5,-644 # 8001b000 <disk>
    8000528c:	00a78733          	add	a4,a5,a0
    80005290:	6789                	lui	a5,0x2
    80005292:	97ba                	add	a5,a5,a4
    80005294:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005298:	e7ad                	bnez	a5,80005302 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000529a:	00451793          	slli	a5,a0,0x4
    8000529e:	00018717          	auipc	a4,0x18
    800052a2:	d6270713          	addi	a4,a4,-670 # 8001d000 <disk+0x2000>
    800052a6:	6314                	ld	a3,0(a4)
    800052a8:	96be                	add	a3,a3,a5
    800052aa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052ae:	6314                	ld	a3,0(a4)
    800052b0:	96be                	add	a3,a3,a5
    800052b2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052b6:	6314                	ld	a3,0(a4)
    800052b8:	96be                	add	a3,a3,a5
    800052ba:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052be:	6318                	ld	a4,0(a4)
    800052c0:	97ba                	add	a5,a5,a4
    800052c2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800052c6:	00016797          	auipc	a5,0x16
    800052ca:	d3a78793          	addi	a5,a5,-710 # 8001b000 <disk>
    800052ce:	97aa                	add	a5,a5,a0
    800052d0:	6509                	lui	a0,0x2
    800052d2:	953e                	add	a0,a0,a5
    800052d4:	4785                	li	a5,1
    800052d6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800052da:	00018517          	auipc	a0,0x18
    800052de:	d3e50513          	addi	a0,a0,-706 # 8001d018 <disk+0x2018>
    800052e2:	ffffc097          	auipc	ra,0xffffc
    800052e6:	58a080e7          	jalr	1418(ra) # 8000186c <wakeup>
}
    800052ea:	60a2                	ld	ra,8(sp)
    800052ec:	6402                	ld	s0,0(sp)
    800052ee:	0141                	addi	sp,sp,16
    800052f0:	8082                	ret
    panic("free_desc 1");
    800052f2:	00003517          	auipc	a0,0x3
    800052f6:	49e50513          	addi	a0,a0,1182 # 80008790 <syscalls+0x368>
    800052fa:	00001097          	auipc	ra,0x1
    800052fe:	a1e080e7          	jalr	-1506(ra) # 80005d18 <panic>
    panic("free_desc 2");
    80005302:	00003517          	auipc	a0,0x3
    80005306:	49e50513          	addi	a0,a0,1182 # 800087a0 <syscalls+0x378>
    8000530a:	00001097          	auipc	ra,0x1
    8000530e:	a0e080e7          	jalr	-1522(ra) # 80005d18 <panic>

0000000080005312 <virtio_disk_init>:
{
    80005312:	1101                	addi	sp,sp,-32
    80005314:	ec06                	sd	ra,24(sp)
    80005316:	e822                	sd	s0,16(sp)
    80005318:	e426                	sd	s1,8(sp)
    8000531a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000531c:	00003597          	auipc	a1,0x3
    80005320:	49458593          	addi	a1,a1,1172 # 800087b0 <syscalls+0x388>
    80005324:	00018517          	auipc	a0,0x18
    80005328:	e0450513          	addi	a0,a0,-508 # 8001d128 <disk+0x2128>
    8000532c:	00001097          	auipc	ra,0x1
    80005330:	ea6080e7          	jalr	-346(ra) # 800061d2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005334:	100017b7          	lui	a5,0x10001
    80005338:	4398                	lw	a4,0(a5)
    8000533a:	2701                	sext.w	a4,a4
    8000533c:	747277b7          	lui	a5,0x74727
    80005340:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005344:	0ef71163          	bne	a4,a5,80005426 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005348:	100017b7          	lui	a5,0x10001
    8000534c:	43dc                	lw	a5,4(a5)
    8000534e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005350:	4705                	li	a4,1
    80005352:	0ce79a63          	bne	a5,a4,80005426 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005356:	100017b7          	lui	a5,0x10001
    8000535a:	479c                	lw	a5,8(a5)
    8000535c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000535e:	4709                	li	a4,2
    80005360:	0ce79363          	bne	a5,a4,80005426 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005364:	100017b7          	lui	a5,0x10001
    80005368:	47d8                	lw	a4,12(a5)
    8000536a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000536c:	554d47b7          	lui	a5,0x554d4
    80005370:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005374:	0af71963          	bne	a4,a5,80005426 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005378:	100017b7          	lui	a5,0x10001
    8000537c:	4705                	li	a4,1
    8000537e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005380:	470d                	li	a4,3
    80005382:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005384:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005386:	c7ffe737          	lui	a4,0xc7ffe
    8000538a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000538e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005390:	2701                	sext.w	a4,a4
    80005392:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005394:	472d                	li	a4,11
    80005396:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005398:	473d                	li	a4,15
    8000539a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000539c:	6705                	lui	a4,0x1
    8000539e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053a4:	5bdc                	lw	a5,52(a5)
    800053a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053a8:	c7d9                	beqz	a5,80005436 <virtio_disk_init+0x124>
  if(max < NUM)
    800053aa:	471d                	li	a4,7
    800053ac:	08f77d63          	bgeu	a4,a5,80005446 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053b0:	100014b7          	lui	s1,0x10001
    800053b4:	47a1                	li	a5,8
    800053b6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053b8:	6609                	lui	a2,0x2
    800053ba:	4581                	li	a1,0
    800053bc:	00016517          	auipc	a0,0x16
    800053c0:	c4450513          	addi	a0,a0,-956 # 8001b000 <disk>
    800053c4:	ffffb097          	auipc	ra,0xffffb
    800053c8:	db4080e7          	jalr	-588(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800053cc:	00016717          	auipc	a4,0x16
    800053d0:	c3470713          	addi	a4,a4,-972 # 8001b000 <disk>
    800053d4:	00c75793          	srli	a5,a4,0xc
    800053d8:	2781                	sext.w	a5,a5
    800053da:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800053dc:	00018797          	auipc	a5,0x18
    800053e0:	c2478793          	addi	a5,a5,-988 # 8001d000 <disk+0x2000>
    800053e4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800053e6:	00016717          	auipc	a4,0x16
    800053ea:	c9a70713          	addi	a4,a4,-870 # 8001b080 <disk+0x80>
    800053ee:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800053f0:	00017717          	auipc	a4,0x17
    800053f4:	c1070713          	addi	a4,a4,-1008 # 8001c000 <disk+0x1000>
    800053f8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800053fa:	4705                	li	a4,1
    800053fc:	00e78c23          	sb	a4,24(a5)
    80005400:	00e78ca3          	sb	a4,25(a5)
    80005404:	00e78d23          	sb	a4,26(a5)
    80005408:	00e78da3          	sb	a4,27(a5)
    8000540c:	00e78e23          	sb	a4,28(a5)
    80005410:	00e78ea3          	sb	a4,29(a5)
    80005414:	00e78f23          	sb	a4,30(a5)
    80005418:	00e78fa3          	sb	a4,31(a5)
}
    8000541c:	60e2                	ld	ra,24(sp)
    8000541e:	6442                	ld	s0,16(sp)
    80005420:	64a2                	ld	s1,8(sp)
    80005422:	6105                	addi	sp,sp,32
    80005424:	8082                	ret
    panic("could not find virtio disk");
    80005426:	00003517          	auipc	a0,0x3
    8000542a:	39a50513          	addi	a0,a0,922 # 800087c0 <syscalls+0x398>
    8000542e:	00001097          	auipc	ra,0x1
    80005432:	8ea080e7          	jalr	-1814(ra) # 80005d18 <panic>
    panic("virtio disk has no queue 0");
    80005436:	00003517          	auipc	a0,0x3
    8000543a:	3aa50513          	addi	a0,a0,938 # 800087e0 <syscalls+0x3b8>
    8000543e:	00001097          	auipc	ra,0x1
    80005442:	8da080e7          	jalr	-1830(ra) # 80005d18 <panic>
    panic("virtio disk max queue too short");
    80005446:	00003517          	auipc	a0,0x3
    8000544a:	3ba50513          	addi	a0,a0,954 # 80008800 <syscalls+0x3d8>
    8000544e:	00001097          	auipc	ra,0x1
    80005452:	8ca080e7          	jalr	-1846(ra) # 80005d18 <panic>

0000000080005456 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005456:	7159                	addi	sp,sp,-112
    80005458:	f486                	sd	ra,104(sp)
    8000545a:	f0a2                	sd	s0,96(sp)
    8000545c:	eca6                	sd	s1,88(sp)
    8000545e:	e8ca                	sd	s2,80(sp)
    80005460:	e4ce                	sd	s3,72(sp)
    80005462:	e0d2                	sd	s4,64(sp)
    80005464:	fc56                	sd	s5,56(sp)
    80005466:	f85a                	sd	s6,48(sp)
    80005468:	f45e                	sd	s7,40(sp)
    8000546a:	f062                	sd	s8,32(sp)
    8000546c:	ec66                	sd	s9,24(sp)
    8000546e:	e86a                	sd	s10,16(sp)
    80005470:	1880                	addi	s0,sp,112
    80005472:	892a                	mv	s2,a0
    80005474:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005476:	00c52c83          	lw	s9,12(a0)
    8000547a:	001c9c9b          	slliw	s9,s9,0x1
    8000547e:	1c82                	slli	s9,s9,0x20
    80005480:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005484:	00018517          	auipc	a0,0x18
    80005488:	ca450513          	addi	a0,a0,-860 # 8001d128 <disk+0x2128>
    8000548c:	00001097          	auipc	ra,0x1
    80005490:	dd6080e7          	jalr	-554(ra) # 80006262 <acquire>
  for(int i = 0; i < 3; i++){
    80005494:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005496:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005498:	00016b97          	auipc	s7,0x16
    8000549c:	b68b8b93          	addi	s7,s7,-1176 # 8001b000 <disk>
    800054a0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054a4:	8a4e                	mv	s4,s3
    800054a6:	a051                	j	8000552a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054a8:	00fb86b3          	add	a3,s7,a5
    800054ac:	96da                	add	a3,a3,s6
    800054ae:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054b2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054b4:	0207c563          	bltz	a5,800054de <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054b8:	2485                	addiw	s1,s1,1
    800054ba:	0711                	addi	a4,a4,4
    800054bc:	25548063          	beq	s1,s5,800056fc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800054c0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054c2:	00018697          	auipc	a3,0x18
    800054c6:	b5668693          	addi	a3,a3,-1194 # 8001d018 <disk+0x2018>
    800054ca:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054cc:	0006c583          	lbu	a1,0(a3)
    800054d0:	fde1                	bnez	a1,800054a8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800054d2:	2785                	addiw	a5,a5,1
    800054d4:	0685                	addi	a3,a3,1
    800054d6:	ff879be3          	bne	a5,s8,800054cc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800054da:	57fd                	li	a5,-1
    800054dc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800054de:	02905a63          	blez	s1,80005512 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054e2:	f9042503          	lw	a0,-112(s0)
    800054e6:	00000097          	auipc	ra,0x0
    800054ea:	d90080e7          	jalr	-624(ra) # 80005276 <free_desc>
      for(int j = 0; j < i; j++)
    800054ee:	4785                	li	a5,1
    800054f0:	0297d163          	bge	a5,s1,80005512 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800054f4:	f9442503          	lw	a0,-108(s0)
    800054f8:	00000097          	auipc	ra,0x0
    800054fc:	d7e080e7          	jalr	-642(ra) # 80005276 <free_desc>
      for(int j = 0; j < i; j++)
    80005500:	4789                	li	a5,2
    80005502:	0097d863          	bge	a5,s1,80005512 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005506:	f9842503          	lw	a0,-104(s0)
    8000550a:	00000097          	auipc	ra,0x0
    8000550e:	d6c080e7          	jalr	-660(ra) # 80005276 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005512:	00018597          	auipc	a1,0x18
    80005516:	c1658593          	addi	a1,a1,-1002 # 8001d128 <disk+0x2128>
    8000551a:	00018517          	auipc	a0,0x18
    8000551e:	afe50513          	addi	a0,a0,-1282 # 8001d018 <disk+0x2018>
    80005522:	ffffc097          	auipc	ra,0xffffc
    80005526:	1be080e7          	jalr	446(ra) # 800016e0 <sleep>
  for(int i = 0; i < 3; i++){
    8000552a:	f9040713          	addi	a4,s0,-112
    8000552e:	84ce                	mv	s1,s3
    80005530:	bf41                	j	800054c0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005532:	20058713          	addi	a4,a1,512
    80005536:	00471693          	slli	a3,a4,0x4
    8000553a:	00016717          	auipc	a4,0x16
    8000553e:	ac670713          	addi	a4,a4,-1338 # 8001b000 <disk>
    80005542:	9736                	add	a4,a4,a3
    80005544:	4685                	li	a3,1
    80005546:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000554a:	20058713          	addi	a4,a1,512
    8000554e:	00471693          	slli	a3,a4,0x4
    80005552:	00016717          	auipc	a4,0x16
    80005556:	aae70713          	addi	a4,a4,-1362 # 8001b000 <disk>
    8000555a:	9736                	add	a4,a4,a3
    8000555c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005560:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005564:	7679                	lui	a2,0xffffe
    80005566:	963e                	add	a2,a2,a5
    80005568:	00018697          	auipc	a3,0x18
    8000556c:	a9868693          	addi	a3,a3,-1384 # 8001d000 <disk+0x2000>
    80005570:	6298                	ld	a4,0(a3)
    80005572:	9732                	add	a4,a4,a2
    80005574:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005576:	6298                	ld	a4,0(a3)
    80005578:	9732                	add	a4,a4,a2
    8000557a:	4541                	li	a0,16
    8000557c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000557e:	6298                	ld	a4,0(a3)
    80005580:	9732                	add	a4,a4,a2
    80005582:	4505                	li	a0,1
    80005584:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005588:	f9442703          	lw	a4,-108(s0)
    8000558c:	6288                	ld	a0,0(a3)
    8000558e:	962a                	add	a2,a2,a0
    80005590:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005594:	0712                	slli	a4,a4,0x4
    80005596:	6290                	ld	a2,0(a3)
    80005598:	963a                	add	a2,a2,a4
    8000559a:	05890513          	addi	a0,s2,88
    8000559e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055a0:	6294                	ld	a3,0(a3)
    800055a2:	96ba                	add	a3,a3,a4
    800055a4:	40000613          	li	a2,1024
    800055a8:	c690                	sw	a2,8(a3)
  if(write)
    800055aa:	140d0063          	beqz	s10,800056ea <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055ae:	00018697          	auipc	a3,0x18
    800055b2:	a526b683          	ld	a3,-1454(a3) # 8001d000 <disk+0x2000>
    800055b6:	96ba                	add	a3,a3,a4
    800055b8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055bc:	00016817          	auipc	a6,0x16
    800055c0:	a4480813          	addi	a6,a6,-1468 # 8001b000 <disk>
    800055c4:	00018517          	auipc	a0,0x18
    800055c8:	a3c50513          	addi	a0,a0,-1476 # 8001d000 <disk+0x2000>
    800055cc:	6114                	ld	a3,0(a0)
    800055ce:	96ba                	add	a3,a3,a4
    800055d0:	00c6d603          	lhu	a2,12(a3)
    800055d4:	00166613          	ori	a2,a2,1
    800055d8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055dc:	f9842683          	lw	a3,-104(s0)
    800055e0:	6110                	ld	a2,0(a0)
    800055e2:	9732                	add	a4,a4,a2
    800055e4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055e8:	20058613          	addi	a2,a1,512
    800055ec:	0612                	slli	a2,a2,0x4
    800055ee:	9642                	add	a2,a2,a6
    800055f0:	577d                	li	a4,-1
    800055f2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055f6:	00469713          	slli	a4,a3,0x4
    800055fa:	6114                	ld	a3,0(a0)
    800055fc:	96ba                	add	a3,a3,a4
    800055fe:	03078793          	addi	a5,a5,48
    80005602:	97c2                	add	a5,a5,a6
    80005604:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005606:	611c                	ld	a5,0(a0)
    80005608:	97ba                	add	a5,a5,a4
    8000560a:	4685                	li	a3,1
    8000560c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000560e:	611c                	ld	a5,0(a0)
    80005610:	97ba                	add	a5,a5,a4
    80005612:	4809                	li	a6,2
    80005614:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005618:	611c                	ld	a5,0(a0)
    8000561a:	973e                	add	a4,a4,a5
    8000561c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005620:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005624:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005628:	6518                	ld	a4,8(a0)
    8000562a:	00275783          	lhu	a5,2(a4)
    8000562e:	8b9d                	andi	a5,a5,7
    80005630:	0786                	slli	a5,a5,0x1
    80005632:	97ba                	add	a5,a5,a4
    80005634:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005638:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000563c:	6518                	ld	a4,8(a0)
    8000563e:	00275783          	lhu	a5,2(a4)
    80005642:	2785                	addiw	a5,a5,1
    80005644:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005648:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000564c:	100017b7          	lui	a5,0x10001
    80005650:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005654:	00492703          	lw	a4,4(s2)
    80005658:	4785                	li	a5,1
    8000565a:	02f71163          	bne	a4,a5,8000567c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000565e:	00018997          	auipc	s3,0x18
    80005662:	aca98993          	addi	s3,s3,-1334 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005666:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005668:	85ce                	mv	a1,s3
    8000566a:	854a                	mv	a0,s2
    8000566c:	ffffc097          	auipc	ra,0xffffc
    80005670:	074080e7          	jalr	116(ra) # 800016e0 <sleep>
  while(b->disk == 1) {
    80005674:	00492783          	lw	a5,4(s2)
    80005678:	fe9788e3          	beq	a5,s1,80005668 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000567c:	f9042903          	lw	s2,-112(s0)
    80005680:	20090793          	addi	a5,s2,512
    80005684:	00479713          	slli	a4,a5,0x4
    80005688:	00016797          	auipc	a5,0x16
    8000568c:	97878793          	addi	a5,a5,-1672 # 8001b000 <disk>
    80005690:	97ba                	add	a5,a5,a4
    80005692:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005696:	00018997          	auipc	s3,0x18
    8000569a:	96a98993          	addi	s3,s3,-1686 # 8001d000 <disk+0x2000>
    8000569e:	00491713          	slli	a4,s2,0x4
    800056a2:	0009b783          	ld	a5,0(s3)
    800056a6:	97ba                	add	a5,a5,a4
    800056a8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ac:	854a                	mv	a0,s2
    800056ae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056b2:	00000097          	auipc	ra,0x0
    800056b6:	bc4080e7          	jalr	-1084(ra) # 80005276 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056ba:	8885                	andi	s1,s1,1
    800056bc:	f0ed                	bnez	s1,8000569e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056be:	00018517          	auipc	a0,0x18
    800056c2:	a6a50513          	addi	a0,a0,-1430 # 8001d128 <disk+0x2128>
    800056c6:	00001097          	auipc	ra,0x1
    800056ca:	c50080e7          	jalr	-944(ra) # 80006316 <release>
}
    800056ce:	70a6                	ld	ra,104(sp)
    800056d0:	7406                	ld	s0,96(sp)
    800056d2:	64e6                	ld	s1,88(sp)
    800056d4:	6946                	ld	s2,80(sp)
    800056d6:	69a6                	ld	s3,72(sp)
    800056d8:	6a06                	ld	s4,64(sp)
    800056da:	7ae2                	ld	s5,56(sp)
    800056dc:	7b42                	ld	s6,48(sp)
    800056de:	7ba2                	ld	s7,40(sp)
    800056e0:	7c02                	ld	s8,32(sp)
    800056e2:	6ce2                	ld	s9,24(sp)
    800056e4:	6d42                	ld	s10,16(sp)
    800056e6:	6165                	addi	sp,sp,112
    800056e8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056ea:	00018697          	auipc	a3,0x18
    800056ee:	9166b683          	ld	a3,-1770(a3) # 8001d000 <disk+0x2000>
    800056f2:	96ba                	add	a3,a3,a4
    800056f4:	4609                	li	a2,2
    800056f6:	00c69623          	sh	a2,12(a3)
    800056fa:	b5c9                	j	800055bc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056fc:	f9042583          	lw	a1,-112(s0)
    80005700:	20058793          	addi	a5,a1,512
    80005704:	0792                	slli	a5,a5,0x4
    80005706:	00016517          	auipc	a0,0x16
    8000570a:	9a250513          	addi	a0,a0,-1630 # 8001b0a8 <disk+0xa8>
    8000570e:	953e                	add	a0,a0,a5
  if(write)
    80005710:	e20d11e3          	bnez	s10,80005532 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005714:	20058713          	addi	a4,a1,512
    80005718:	00471693          	slli	a3,a4,0x4
    8000571c:	00016717          	auipc	a4,0x16
    80005720:	8e470713          	addi	a4,a4,-1820 # 8001b000 <disk>
    80005724:	9736                	add	a4,a4,a3
    80005726:	0a072423          	sw	zero,168(a4)
    8000572a:	b505                	j	8000554a <virtio_disk_rw+0xf4>

000000008000572c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000572c:	1101                	addi	sp,sp,-32
    8000572e:	ec06                	sd	ra,24(sp)
    80005730:	e822                	sd	s0,16(sp)
    80005732:	e426                	sd	s1,8(sp)
    80005734:	e04a                	sd	s2,0(sp)
    80005736:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005738:	00018517          	auipc	a0,0x18
    8000573c:	9f050513          	addi	a0,a0,-1552 # 8001d128 <disk+0x2128>
    80005740:	00001097          	auipc	ra,0x1
    80005744:	b22080e7          	jalr	-1246(ra) # 80006262 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005748:	10001737          	lui	a4,0x10001
    8000574c:	533c                	lw	a5,96(a4)
    8000574e:	8b8d                	andi	a5,a5,3
    80005750:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005752:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005756:	00018797          	auipc	a5,0x18
    8000575a:	8aa78793          	addi	a5,a5,-1878 # 8001d000 <disk+0x2000>
    8000575e:	6b94                	ld	a3,16(a5)
    80005760:	0207d703          	lhu	a4,32(a5)
    80005764:	0026d783          	lhu	a5,2(a3)
    80005768:	06f70163          	beq	a4,a5,800057ca <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000576c:	00016917          	auipc	s2,0x16
    80005770:	89490913          	addi	s2,s2,-1900 # 8001b000 <disk>
    80005774:	00018497          	auipc	s1,0x18
    80005778:	88c48493          	addi	s1,s1,-1908 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000577c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005780:	6898                	ld	a4,16(s1)
    80005782:	0204d783          	lhu	a5,32(s1)
    80005786:	8b9d                	andi	a5,a5,7
    80005788:	078e                	slli	a5,a5,0x3
    8000578a:	97ba                	add	a5,a5,a4
    8000578c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000578e:	20078713          	addi	a4,a5,512
    80005792:	0712                	slli	a4,a4,0x4
    80005794:	974a                	add	a4,a4,s2
    80005796:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000579a:	e731                	bnez	a4,800057e6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000579c:	20078793          	addi	a5,a5,512
    800057a0:	0792                	slli	a5,a5,0x4
    800057a2:	97ca                	add	a5,a5,s2
    800057a4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057a6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057aa:	ffffc097          	auipc	ra,0xffffc
    800057ae:	0c2080e7          	jalr	194(ra) # 8000186c <wakeup>

    disk.used_idx += 1;
    800057b2:	0204d783          	lhu	a5,32(s1)
    800057b6:	2785                	addiw	a5,a5,1
    800057b8:	17c2                	slli	a5,a5,0x30
    800057ba:	93c1                	srli	a5,a5,0x30
    800057bc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057c0:	6898                	ld	a4,16(s1)
    800057c2:	00275703          	lhu	a4,2(a4)
    800057c6:	faf71be3          	bne	a4,a5,8000577c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800057ca:	00018517          	auipc	a0,0x18
    800057ce:	95e50513          	addi	a0,a0,-1698 # 8001d128 <disk+0x2128>
    800057d2:	00001097          	auipc	ra,0x1
    800057d6:	b44080e7          	jalr	-1212(ra) # 80006316 <release>
}
    800057da:	60e2                	ld	ra,24(sp)
    800057dc:	6442                	ld	s0,16(sp)
    800057de:	64a2                	ld	s1,8(sp)
    800057e0:	6902                	ld	s2,0(sp)
    800057e2:	6105                	addi	sp,sp,32
    800057e4:	8082                	ret
      panic("virtio_disk_intr status");
    800057e6:	00003517          	auipc	a0,0x3
    800057ea:	03a50513          	addi	a0,a0,58 # 80008820 <syscalls+0x3f8>
    800057ee:	00000097          	auipc	ra,0x0
    800057f2:	52a080e7          	jalr	1322(ra) # 80005d18 <panic>

00000000800057f6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057f6:	1141                	addi	sp,sp,-16
    800057f8:	e422                	sd	s0,8(sp)
    800057fa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057fc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005800:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005804:	0037979b          	slliw	a5,a5,0x3
    80005808:	02004737          	lui	a4,0x2004
    8000580c:	97ba                	add	a5,a5,a4
    8000580e:	0200c737          	lui	a4,0x200c
    80005812:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005816:	000f4637          	lui	a2,0xf4
    8000581a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000581e:	95b2                	add	a1,a1,a2
    80005820:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005822:	00269713          	slli	a4,a3,0x2
    80005826:	9736                	add	a4,a4,a3
    80005828:	00371693          	slli	a3,a4,0x3
    8000582c:	00018717          	auipc	a4,0x18
    80005830:	7d470713          	addi	a4,a4,2004 # 8001e000 <timer_scratch>
    80005834:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005836:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005838:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000583a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000583e:	00000797          	auipc	a5,0x0
    80005842:	97278793          	addi	a5,a5,-1678 # 800051b0 <timervec>
    80005846:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000584a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000584e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005852:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005856:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000585a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000585e:	30479073          	csrw	mie,a5
}
    80005862:	6422                	ld	s0,8(sp)
    80005864:	0141                	addi	sp,sp,16
    80005866:	8082                	ret

0000000080005868 <start>:
{
    80005868:	1141                	addi	sp,sp,-16
    8000586a:	e406                	sd	ra,8(sp)
    8000586c:	e022                	sd	s0,0(sp)
    8000586e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005870:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005874:	7779                	lui	a4,0xffffe
    80005876:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000587a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000587c:	6705                	lui	a4,0x1
    8000587e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005882:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005884:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005888:	ffffb797          	auipc	a5,0xffffb
    8000588c:	a9e78793          	addi	a5,a5,-1378 # 80000326 <main>
    80005890:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005894:	4781                	li	a5,0
    80005896:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000589a:	67c1                	lui	a5,0x10
    8000589c:	17fd                	addi	a5,a5,-1
    8000589e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058a2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058a6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058aa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058ae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058b2:	57fd                	li	a5,-1
    800058b4:	83a9                	srli	a5,a5,0xa
    800058b6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058ba:	47bd                	li	a5,15
    800058bc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058c0:	00000097          	auipc	ra,0x0
    800058c4:	f36080e7          	jalr	-202(ra) # 800057f6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058c8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058cc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058ce:	823e                	mv	tp,a5
  asm volatile("mret");
    800058d0:	30200073          	mret
}
    800058d4:	60a2                	ld	ra,8(sp)
    800058d6:	6402                	ld	s0,0(sp)
    800058d8:	0141                	addi	sp,sp,16
    800058da:	8082                	ret

00000000800058dc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058dc:	715d                	addi	sp,sp,-80
    800058de:	e486                	sd	ra,72(sp)
    800058e0:	e0a2                	sd	s0,64(sp)
    800058e2:	fc26                	sd	s1,56(sp)
    800058e4:	f84a                	sd	s2,48(sp)
    800058e6:	f44e                	sd	s3,40(sp)
    800058e8:	f052                	sd	s4,32(sp)
    800058ea:	ec56                	sd	s5,24(sp)
    800058ec:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058ee:	04c05663          	blez	a2,8000593a <consolewrite+0x5e>
    800058f2:	8a2a                	mv	s4,a0
    800058f4:	84ae                	mv	s1,a1
    800058f6:	89b2                	mv	s3,a2
    800058f8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058fa:	5afd                	li	s5,-1
    800058fc:	4685                	li	a3,1
    800058fe:	8626                	mv	a2,s1
    80005900:	85d2                	mv	a1,s4
    80005902:	fbf40513          	addi	a0,s0,-65
    80005906:	ffffc097          	auipc	ra,0xffffc
    8000590a:	1d4080e7          	jalr	468(ra) # 80001ada <either_copyin>
    8000590e:	01550c63          	beq	a0,s5,80005926 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005912:	fbf44503          	lbu	a0,-65(s0)
    80005916:	00000097          	auipc	ra,0x0
    8000591a:	78e080e7          	jalr	1934(ra) # 800060a4 <uartputc>
  for(i = 0; i < n; i++){
    8000591e:	2905                	addiw	s2,s2,1
    80005920:	0485                	addi	s1,s1,1
    80005922:	fd299de3          	bne	s3,s2,800058fc <consolewrite+0x20>
  }

  return i;
}
    80005926:	854a                	mv	a0,s2
    80005928:	60a6                	ld	ra,72(sp)
    8000592a:	6406                	ld	s0,64(sp)
    8000592c:	74e2                	ld	s1,56(sp)
    8000592e:	7942                	ld	s2,48(sp)
    80005930:	79a2                	ld	s3,40(sp)
    80005932:	7a02                	ld	s4,32(sp)
    80005934:	6ae2                	ld	s5,24(sp)
    80005936:	6161                	addi	sp,sp,80
    80005938:	8082                	ret
  for(i = 0; i < n; i++){
    8000593a:	4901                	li	s2,0
    8000593c:	b7ed                	j	80005926 <consolewrite+0x4a>

000000008000593e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000593e:	7119                	addi	sp,sp,-128
    80005940:	fc86                	sd	ra,120(sp)
    80005942:	f8a2                	sd	s0,112(sp)
    80005944:	f4a6                	sd	s1,104(sp)
    80005946:	f0ca                	sd	s2,96(sp)
    80005948:	ecce                	sd	s3,88(sp)
    8000594a:	e8d2                	sd	s4,80(sp)
    8000594c:	e4d6                	sd	s5,72(sp)
    8000594e:	e0da                	sd	s6,64(sp)
    80005950:	fc5e                	sd	s7,56(sp)
    80005952:	f862                	sd	s8,48(sp)
    80005954:	f466                	sd	s9,40(sp)
    80005956:	f06a                	sd	s10,32(sp)
    80005958:	ec6e                	sd	s11,24(sp)
    8000595a:	0100                	addi	s0,sp,128
    8000595c:	8b2a                	mv	s6,a0
    8000595e:	8aae                	mv	s5,a1
    80005960:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005962:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005966:	00020517          	auipc	a0,0x20
    8000596a:	7da50513          	addi	a0,a0,2010 # 80026140 <cons>
    8000596e:	00001097          	auipc	ra,0x1
    80005972:	8f4080e7          	jalr	-1804(ra) # 80006262 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005976:	00020497          	auipc	s1,0x20
    8000597a:	7ca48493          	addi	s1,s1,1994 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000597e:	89a6                	mv	s3,s1
    80005980:	00021917          	auipc	s2,0x21
    80005984:	85890913          	addi	s2,s2,-1960 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005988:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000598a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000598c:	4da9                	li	s11,10
  while(n > 0){
    8000598e:	07405863          	blez	s4,800059fe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005992:	0984a783          	lw	a5,152(s1)
    80005996:	09c4a703          	lw	a4,156(s1)
    8000599a:	02f71463          	bne	a4,a5,800059c2 <consoleread+0x84>
      if(myproc()->killed){
    8000599e:	ffffb097          	auipc	ra,0xffffb
    800059a2:	5d6080e7          	jalr	1494(ra) # 80000f74 <myproc>
    800059a6:	551c                	lw	a5,40(a0)
    800059a8:	e7b5                	bnez	a5,80005a14 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059aa:	85ce                	mv	a1,s3
    800059ac:	854a                	mv	a0,s2
    800059ae:	ffffc097          	auipc	ra,0xffffc
    800059b2:	d32080e7          	jalr	-718(ra) # 800016e0 <sleep>
    while(cons.r == cons.w){
    800059b6:	0984a783          	lw	a5,152(s1)
    800059ba:	09c4a703          	lw	a4,156(s1)
    800059be:	fef700e3          	beq	a4,a5,8000599e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800059c2:	0017871b          	addiw	a4,a5,1
    800059c6:	08e4ac23          	sw	a4,152(s1)
    800059ca:	07f7f713          	andi	a4,a5,127
    800059ce:	9726                	add	a4,a4,s1
    800059d0:	01874703          	lbu	a4,24(a4)
    800059d4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800059d8:	079c0663          	beq	s8,s9,80005a44 <consoleread+0x106>
    cbuf = c;
    800059dc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059e0:	4685                	li	a3,1
    800059e2:	f8f40613          	addi	a2,s0,-113
    800059e6:	85d6                	mv	a1,s5
    800059e8:	855a                	mv	a0,s6
    800059ea:	ffffc097          	auipc	ra,0xffffc
    800059ee:	09a080e7          	jalr	154(ra) # 80001a84 <either_copyout>
    800059f2:	01a50663          	beq	a0,s10,800059fe <consoleread+0xc0>
    dst++;
    800059f6:	0a85                	addi	s5,s5,1
    --n;
    800059f8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800059fa:	f9bc1ae3          	bne	s8,s11,8000598e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059fe:	00020517          	auipc	a0,0x20
    80005a02:	74250513          	addi	a0,a0,1858 # 80026140 <cons>
    80005a06:	00001097          	auipc	ra,0x1
    80005a0a:	910080e7          	jalr	-1776(ra) # 80006316 <release>

  return target - n;
    80005a0e:	414b853b          	subw	a0,s7,s4
    80005a12:	a811                	j	80005a26 <consoleread+0xe8>
        release(&cons.lock);
    80005a14:	00020517          	auipc	a0,0x20
    80005a18:	72c50513          	addi	a0,a0,1836 # 80026140 <cons>
    80005a1c:	00001097          	auipc	ra,0x1
    80005a20:	8fa080e7          	jalr	-1798(ra) # 80006316 <release>
        return -1;
    80005a24:	557d                	li	a0,-1
}
    80005a26:	70e6                	ld	ra,120(sp)
    80005a28:	7446                	ld	s0,112(sp)
    80005a2a:	74a6                	ld	s1,104(sp)
    80005a2c:	7906                	ld	s2,96(sp)
    80005a2e:	69e6                	ld	s3,88(sp)
    80005a30:	6a46                	ld	s4,80(sp)
    80005a32:	6aa6                	ld	s5,72(sp)
    80005a34:	6b06                	ld	s6,64(sp)
    80005a36:	7be2                	ld	s7,56(sp)
    80005a38:	7c42                	ld	s8,48(sp)
    80005a3a:	7ca2                	ld	s9,40(sp)
    80005a3c:	7d02                	ld	s10,32(sp)
    80005a3e:	6de2                	ld	s11,24(sp)
    80005a40:	6109                	addi	sp,sp,128
    80005a42:	8082                	ret
      if(n < target){
    80005a44:	000a071b          	sext.w	a4,s4
    80005a48:	fb777be3          	bgeu	a4,s7,800059fe <consoleread+0xc0>
        cons.r--;
    80005a4c:	00020717          	auipc	a4,0x20
    80005a50:	78f72623          	sw	a5,1932(a4) # 800261d8 <cons+0x98>
    80005a54:	b76d                	j	800059fe <consoleread+0xc0>

0000000080005a56 <consputc>:
{
    80005a56:	1141                	addi	sp,sp,-16
    80005a58:	e406                	sd	ra,8(sp)
    80005a5a:	e022                	sd	s0,0(sp)
    80005a5c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a5e:	10000793          	li	a5,256
    80005a62:	00f50a63          	beq	a0,a5,80005a76 <consputc+0x20>
    uartputc_sync(c);
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	564080e7          	jalr	1380(ra) # 80005fca <uartputc_sync>
}
    80005a6e:	60a2                	ld	ra,8(sp)
    80005a70:	6402                	ld	s0,0(sp)
    80005a72:	0141                	addi	sp,sp,16
    80005a74:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a76:	4521                	li	a0,8
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	552080e7          	jalr	1362(ra) # 80005fca <uartputc_sync>
    80005a80:	02000513          	li	a0,32
    80005a84:	00000097          	auipc	ra,0x0
    80005a88:	546080e7          	jalr	1350(ra) # 80005fca <uartputc_sync>
    80005a8c:	4521                	li	a0,8
    80005a8e:	00000097          	auipc	ra,0x0
    80005a92:	53c080e7          	jalr	1340(ra) # 80005fca <uartputc_sync>
    80005a96:	bfe1                	j	80005a6e <consputc+0x18>

0000000080005a98 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a98:	1101                	addi	sp,sp,-32
    80005a9a:	ec06                	sd	ra,24(sp)
    80005a9c:	e822                	sd	s0,16(sp)
    80005a9e:	e426                	sd	s1,8(sp)
    80005aa0:	e04a                	sd	s2,0(sp)
    80005aa2:	1000                	addi	s0,sp,32
    80005aa4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005aa6:	00020517          	auipc	a0,0x20
    80005aaa:	69a50513          	addi	a0,a0,1690 # 80026140 <cons>
    80005aae:	00000097          	auipc	ra,0x0
    80005ab2:	7b4080e7          	jalr	1972(ra) # 80006262 <acquire>

  switch(c){
    80005ab6:	47d5                	li	a5,21
    80005ab8:	0af48663          	beq	s1,a5,80005b64 <consoleintr+0xcc>
    80005abc:	0297ca63          	blt	a5,s1,80005af0 <consoleintr+0x58>
    80005ac0:	47a1                	li	a5,8
    80005ac2:	0ef48763          	beq	s1,a5,80005bb0 <consoleintr+0x118>
    80005ac6:	47c1                	li	a5,16
    80005ac8:	10f49a63          	bne	s1,a5,80005bdc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005acc:	ffffc097          	auipc	ra,0xffffc
    80005ad0:	064080e7          	jalr	100(ra) # 80001b30 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ad4:	00020517          	auipc	a0,0x20
    80005ad8:	66c50513          	addi	a0,a0,1644 # 80026140 <cons>
    80005adc:	00001097          	auipc	ra,0x1
    80005ae0:	83a080e7          	jalr	-1990(ra) # 80006316 <release>
}
    80005ae4:	60e2                	ld	ra,24(sp)
    80005ae6:	6442                	ld	s0,16(sp)
    80005ae8:	64a2                	ld	s1,8(sp)
    80005aea:	6902                	ld	s2,0(sp)
    80005aec:	6105                	addi	sp,sp,32
    80005aee:	8082                	ret
  switch(c){
    80005af0:	07f00793          	li	a5,127
    80005af4:	0af48e63          	beq	s1,a5,80005bb0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005af8:	00020717          	auipc	a4,0x20
    80005afc:	64870713          	addi	a4,a4,1608 # 80026140 <cons>
    80005b00:	0a072783          	lw	a5,160(a4)
    80005b04:	09872703          	lw	a4,152(a4)
    80005b08:	9f99                	subw	a5,a5,a4
    80005b0a:	07f00713          	li	a4,127
    80005b0e:	fcf763e3          	bltu	a4,a5,80005ad4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b12:	47b5                	li	a5,13
    80005b14:	0cf48763          	beq	s1,a5,80005be2 <consoleintr+0x14a>
      consputc(c);
    80005b18:	8526                	mv	a0,s1
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	f3c080e7          	jalr	-196(ra) # 80005a56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b22:	00020797          	auipc	a5,0x20
    80005b26:	61e78793          	addi	a5,a5,1566 # 80026140 <cons>
    80005b2a:	0a07a703          	lw	a4,160(a5)
    80005b2e:	0017069b          	addiw	a3,a4,1
    80005b32:	0006861b          	sext.w	a2,a3
    80005b36:	0ad7a023          	sw	a3,160(a5)
    80005b3a:	07f77713          	andi	a4,a4,127
    80005b3e:	97ba                	add	a5,a5,a4
    80005b40:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b44:	47a9                	li	a5,10
    80005b46:	0cf48563          	beq	s1,a5,80005c10 <consoleintr+0x178>
    80005b4a:	4791                	li	a5,4
    80005b4c:	0cf48263          	beq	s1,a5,80005c10 <consoleintr+0x178>
    80005b50:	00020797          	auipc	a5,0x20
    80005b54:	6887a783          	lw	a5,1672(a5) # 800261d8 <cons+0x98>
    80005b58:	0807879b          	addiw	a5,a5,128
    80005b5c:	f6f61ce3          	bne	a2,a5,80005ad4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b60:	863e                	mv	a2,a5
    80005b62:	a07d                	j	80005c10 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b64:	00020717          	auipc	a4,0x20
    80005b68:	5dc70713          	addi	a4,a4,1500 # 80026140 <cons>
    80005b6c:	0a072783          	lw	a5,160(a4)
    80005b70:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b74:	00020497          	auipc	s1,0x20
    80005b78:	5cc48493          	addi	s1,s1,1484 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005b7c:	4929                	li	s2,10
    80005b7e:	f4f70be3          	beq	a4,a5,80005ad4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b82:	37fd                	addiw	a5,a5,-1
    80005b84:	07f7f713          	andi	a4,a5,127
    80005b88:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b8a:	01874703          	lbu	a4,24(a4)
    80005b8e:	f52703e3          	beq	a4,s2,80005ad4 <consoleintr+0x3c>
      cons.e--;
    80005b92:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b96:	10000513          	li	a0,256
    80005b9a:	00000097          	auipc	ra,0x0
    80005b9e:	ebc080e7          	jalr	-324(ra) # 80005a56 <consputc>
    while(cons.e != cons.w &&
    80005ba2:	0a04a783          	lw	a5,160(s1)
    80005ba6:	09c4a703          	lw	a4,156(s1)
    80005baa:	fcf71ce3          	bne	a4,a5,80005b82 <consoleintr+0xea>
    80005bae:	b71d                	j	80005ad4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bb0:	00020717          	auipc	a4,0x20
    80005bb4:	59070713          	addi	a4,a4,1424 # 80026140 <cons>
    80005bb8:	0a072783          	lw	a5,160(a4)
    80005bbc:	09c72703          	lw	a4,156(a4)
    80005bc0:	f0f70ae3          	beq	a4,a5,80005ad4 <consoleintr+0x3c>
      cons.e--;
    80005bc4:	37fd                	addiw	a5,a5,-1
    80005bc6:	00020717          	auipc	a4,0x20
    80005bca:	60f72d23          	sw	a5,1562(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005bce:	10000513          	li	a0,256
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	e84080e7          	jalr	-380(ra) # 80005a56 <consputc>
    80005bda:	bded                	j	80005ad4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bdc:	ee048ce3          	beqz	s1,80005ad4 <consoleintr+0x3c>
    80005be0:	bf21                	j	80005af8 <consoleintr+0x60>
      consputc(c);
    80005be2:	4529                	li	a0,10
    80005be4:	00000097          	auipc	ra,0x0
    80005be8:	e72080e7          	jalr	-398(ra) # 80005a56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bec:	00020797          	auipc	a5,0x20
    80005bf0:	55478793          	addi	a5,a5,1364 # 80026140 <cons>
    80005bf4:	0a07a703          	lw	a4,160(a5)
    80005bf8:	0017069b          	addiw	a3,a4,1
    80005bfc:	0006861b          	sext.w	a2,a3
    80005c00:	0ad7a023          	sw	a3,160(a5)
    80005c04:	07f77713          	andi	a4,a4,127
    80005c08:	97ba                	add	a5,a5,a4
    80005c0a:	4729                	li	a4,10
    80005c0c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c10:	00020797          	auipc	a5,0x20
    80005c14:	5cc7a623          	sw	a2,1484(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c18:	00020517          	auipc	a0,0x20
    80005c1c:	5c050513          	addi	a0,a0,1472 # 800261d8 <cons+0x98>
    80005c20:	ffffc097          	auipc	ra,0xffffc
    80005c24:	c4c080e7          	jalr	-948(ra) # 8000186c <wakeup>
    80005c28:	b575                	j	80005ad4 <consoleintr+0x3c>

0000000080005c2a <consoleinit>:

void
consoleinit(void)
{
    80005c2a:	1141                	addi	sp,sp,-16
    80005c2c:	e406                	sd	ra,8(sp)
    80005c2e:	e022                	sd	s0,0(sp)
    80005c30:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c32:	00003597          	auipc	a1,0x3
    80005c36:	c0658593          	addi	a1,a1,-1018 # 80008838 <syscalls+0x410>
    80005c3a:	00020517          	auipc	a0,0x20
    80005c3e:	50650513          	addi	a0,a0,1286 # 80026140 <cons>
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	590080e7          	jalr	1424(ra) # 800061d2 <initlock>

  uartinit();
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	330080e7          	jalr	816(ra) # 80005f7a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c52:	00013797          	auipc	a5,0x13
    80005c56:	67678793          	addi	a5,a5,1654 # 800192c8 <devsw>
    80005c5a:	00000717          	auipc	a4,0x0
    80005c5e:	ce470713          	addi	a4,a4,-796 # 8000593e <consoleread>
    80005c62:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c64:	00000717          	auipc	a4,0x0
    80005c68:	c7870713          	addi	a4,a4,-904 # 800058dc <consolewrite>
    80005c6c:	ef98                	sd	a4,24(a5)
}
    80005c6e:	60a2                	ld	ra,8(sp)
    80005c70:	6402                	ld	s0,0(sp)
    80005c72:	0141                	addi	sp,sp,16
    80005c74:	8082                	ret

0000000080005c76 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c76:	7179                	addi	sp,sp,-48
    80005c78:	f406                	sd	ra,40(sp)
    80005c7a:	f022                	sd	s0,32(sp)
    80005c7c:	ec26                	sd	s1,24(sp)
    80005c7e:	e84a                	sd	s2,16(sp)
    80005c80:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c82:	c219                	beqz	a2,80005c88 <printint+0x12>
    80005c84:	08054663          	bltz	a0,80005d10 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c88:	2501                	sext.w	a0,a0
    80005c8a:	4881                	li	a7,0
    80005c8c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c90:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c92:	2581                	sext.w	a1,a1
    80005c94:	00003617          	auipc	a2,0x3
    80005c98:	bd460613          	addi	a2,a2,-1068 # 80008868 <digits>
    80005c9c:	883a                	mv	a6,a4
    80005c9e:	2705                	addiw	a4,a4,1
    80005ca0:	02b577bb          	remuw	a5,a0,a1
    80005ca4:	1782                	slli	a5,a5,0x20
    80005ca6:	9381                	srli	a5,a5,0x20
    80005ca8:	97b2                	add	a5,a5,a2
    80005caa:	0007c783          	lbu	a5,0(a5)
    80005cae:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cb2:	0005079b          	sext.w	a5,a0
    80005cb6:	02b5553b          	divuw	a0,a0,a1
    80005cba:	0685                	addi	a3,a3,1
    80005cbc:	feb7f0e3          	bgeu	a5,a1,80005c9c <printint+0x26>

  if(sign)
    80005cc0:	00088b63          	beqz	a7,80005cd6 <printint+0x60>
    buf[i++] = '-';
    80005cc4:	fe040793          	addi	a5,s0,-32
    80005cc8:	973e                	add	a4,a4,a5
    80005cca:	02d00793          	li	a5,45
    80005cce:	fef70823          	sb	a5,-16(a4)
    80005cd2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cd6:	02e05763          	blez	a4,80005d04 <printint+0x8e>
    80005cda:	fd040793          	addi	a5,s0,-48
    80005cde:	00e784b3          	add	s1,a5,a4
    80005ce2:	fff78913          	addi	s2,a5,-1
    80005ce6:	993a                	add	s2,s2,a4
    80005ce8:	377d                	addiw	a4,a4,-1
    80005cea:	1702                	slli	a4,a4,0x20
    80005cec:	9301                	srli	a4,a4,0x20
    80005cee:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cf2:	fff4c503          	lbu	a0,-1(s1)
    80005cf6:	00000097          	auipc	ra,0x0
    80005cfa:	d60080e7          	jalr	-672(ra) # 80005a56 <consputc>
  while(--i >= 0)
    80005cfe:	14fd                	addi	s1,s1,-1
    80005d00:	ff2499e3          	bne	s1,s2,80005cf2 <printint+0x7c>
}
    80005d04:	70a2                	ld	ra,40(sp)
    80005d06:	7402                	ld	s0,32(sp)
    80005d08:	64e2                	ld	s1,24(sp)
    80005d0a:	6942                	ld	s2,16(sp)
    80005d0c:	6145                	addi	sp,sp,48
    80005d0e:	8082                	ret
    x = -xx;
    80005d10:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d14:	4885                	li	a7,1
    x = -xx;
    80005d16:	bf9d                	j	80005c8c <printint+0x16>

0000000080005d18 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d18:	1101                	addi	sp,sp,-32
    80005d1a:	ec06                	sd	ra,24(sp)
    80005d1c:	e822                	sd	s0,16(sp)
    80005d1e:	e426                	sd	s1,8(sp)
    80005d20:	1000                	addi	s0,sp,32
    80005d22:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d24:	00020797          	auipc	a5,0x20
    80005d28:	4c07ae23          	sw	zero,1244(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005d2c:	00003517          	auipc	a0,0x3
    80005d30:	b1450513          	addi	a0,a0,-1260 # 80008840 <syscalls+0x418>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	02e080e7          	jalr	46(ra) # 80005d62 <printf>
  printf(s);
    80005d3c:	8526                	mv	a0,s1
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	024080e7          	jalr	36(ra) # 80005d62 <printf>
  printf("\n");
    80005d46:	00002517          	auipc	a0,0x2
    80005d4a:	30250513          	addi	a0,a0,770 # 80008048 <etext+0x48>
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	014080e7          	jalr	20(ra) # 80005d62 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d56:	4785                	li	a5,1
    80005d58:	00003717          	auipc	a4,0x3
    80005d5c:	2cf72223          	sw	a5,708(a4) # 8000901c <panicked>
  for(;;)
    80005d60:	a001                	j	80005d60 <panic+0x48>

0000000080005d62 <printf>:
{
    80005d62:	7131                	addi	sp,sp,-192
    80005d64:	fc86                	sd	ra,120(sp)
    80005d66:	f8a2                	sd	s0,112(sp)
    80005d68:	f4a6                	sd	s1,104(sp)
    80005d6a:	f0ca                	sd	s2,96(sp)
    80005d6c:	ecce                	sd	s3,88(sp)
    80005d6e:	e8d2                	sd	s4,80(sp)
    80005d70:	e4d6                	sd	s5,72(sp)
    80005d72:	e0da                	sd	s6,64(sp)
    80005d74:	fc5e                	sd	s7,56(sp)
    80005d76:	f862                	sd	s8,48(sp)
    80005d78:	f466                	sd	s9,40(sp)
    80005d7a:	f06a                	sd	s10,32(sp)
    80005d7c:	ec6e                	sd	s11,24(sp)
    80005d7e:	0100                	addi	s0,sp,128
    80005d80:	8a2a                	mv	s4,a0
    80005d82:	e40c                	sd	a1,8(s0)
    80005d84:	e810                	sd	a2,16(s0)
    80005d86:	ec14                	sd	a3,24(s0)
    80005d88:	f018                	sd	a4,32(s0)
    80005d8a:	f41c                	sd	a5,40(s0)
    80005d8c:	03043823          	sd	a6,48(s0)
    80005d90:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d94:	00020d97          	auipc	s11,0x20
    80005d98:	46cdad83          	lw	s11,1132(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d9c:	020d9b63          	bnez	s11,80005dd2 <printf+0x70>
  if (fmt == 0)
    80005da0:	040a0263          	beqz	s4,80005de4 <printf+0x82>
  va_start(ap, fmt);
    80005da4:	00840793          	addi	a5,s0,8
    80005da8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dac:	000a4503          	lbu	a0,0(s4)
    80005db0:	16050263          	beqz	a0,80005f14 <printf+0x1b2>
    80005db4:	4481                	li	s1,0
    if(c != '%'){
    80005db6:	02500a93          	li	s5,37
    switch(c){
    80005dba:	07000b13          	li	s6,112
  consputc('x');
    80005dbe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc0:	00003b97          	auipc	s7,0x3
    80005dc4:	aa8b8b93          	addi	s7,s7,-1368 # 80008868 <digits>
    switch(c){
    80005dc8:	07300c93          	li	s9,115
    80005dcc:	06400c13          	li	s8,100
    80005dd0:	a82d                	j	80005e0a <printf+0xa8>
    acquire(&pr.lock);
    80005dd2:	00020517          	auipc	a0,0x20
    80005dd6:	41650513          	addi	a0,a0,1046 # 800261e8 <pr>
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	488080e7          	jalr	1160(ra) # 80006262 <acquire>
    80005de2:	bf7d                	j	80005da0 <printf+0x3e>
    panic("null fmt");
    80005de4:	00003517          	auipc	a0,0x3
    80005de8:	a6c50513          	addi	a0,a0,-1428 # 80008850 <syscalls+0x428>
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	f2c080e7          	jalr	-212(ra) # 80005d18 <panic>
      consputc(c);
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	c62080e7          	jalr	-926(ra) # 80005a56 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dfc:	2485                	addiw	s1,s1,1
    80005dfe:	009a07b3          	add	a5,s4,s1
    80005e02:	0007c503          	lbu	a0,0(a5)
    80005e06:	10050763          	beqz	a0,80005f14 <printf+0x1b2>
    if(c != '%'){
    80005e0a:	ff5515e3          	bne	a0,s5,80005df4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e0e:	2485                	addiw	s1,s1,1
    80005e10:	009a07b3          	add	a5,s4,s1
    80005e14:	0007c783          	lbu	a5,0(a5)
    80005e18:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e1c:	cfe5                	beqz	a5,80005f14 <printf+0x1b2>
    switch(c){
    80005e1e:	05678a63          	beq	a5,s6,80005e72 <printf+0x110>
    80005e22:	02fb7663          	bgeu	s6,a5,80005e4e <printf+0xec>
    80005e26:	09978963          	beq	a5,s9,80005eb8 <printf+0x156>
    80005e2a:	07800713          	li	a4,120
    80005e2e:	0ce79863          	bne	a5,a4,80005efe <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e32:	f8843783          	ld	a5,-120(s0)
    80005e36:	00878713          	addi	a4,a5,8
    80005e3a:	f8e43423          	sd	a4,-120(s0)
    80005e3e:	4605                	li	a2,1
    80005e40:	85ea                	mv	a1,s10
    80005e42:	4388                	lw	a0,0(a5)
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	e32080e7          	jalr	-462(ra) # 80005c76 <printint>
      break;
    80005e4c:	bf45                	j	80005dfc <printf+0x9a>
    switch(c){
    80005e4e:	0b578263          	beq	a5,s5,80005ef2 <printf+0x190>
    80005e52:	0b879663          	bne	a5,s8,80005efe <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e56:	f8843783          	ld	a5,-120(s0)
    80005e5a:	00878713          	addi	a4,a5,8
    80005e5e:	f8e43423          	sd	a4,-120(s0)
    80005e62:	4605                	li	a2,1
    80005e64:	45a9                	li	a1,10
    80005e66:	4388                	lw	a0,0(a5)
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	e0e080e7          	jalr	-498(ra) # 80005c76 <printint>
      break;
    80005e70:	b771                	j	80005dfc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e72:	f8843783          	ld	a5,-120(s0)
    80005e76:	00878713          	addi	a4,a5,8
    80005e7a:	f8e43423          	sd	a4,-120(s0)
    80005e7e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e82:	03000513          	li	a0,48
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	bd0080e7          	jalr	-1072(ra) # 80005a56 <consputc>
  consputc('x');
    80005e8e:	07800513          	li	a0,120
    80005e92:	00000097          	auipc	ra,0x0
    80005e96:	bc4080e7          	jalr	-1084(ra) # 80005a56 <consputc>
    80005e9a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e9c:	03c9d793          	srli	a5,s3,0x3c
    80005ea0:	97de                	add	a5,a5,s7
    80005ea2:	0007c503          	lbu	a0,0(a5)
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	bb0080e7          	jalr	-1104(ra) # 80005a56 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005eae:	0992                	slli	s3,s3,0x4
    80005eb0:	397d                	addiw	s2,s2,-1
    80005eb2:	fe0915e3          	bnez	s2,80005e9c <printf+0x13a>
    80005eb6:	b799                	j	80005dfc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005eb8:	f8843783          	ld	a5,-120(s0)
    80005ebc:	00878713          	addi	a4,a5,8
    80005ec0:	f8e43423          	sd	a4,-120(s0)
    80005ec4:	0007b903          	ld	s2,0(a5)
    80005ec8:	00090e63          	beqz	s2,80005ee4 <printf+0x182>
      for(; *s; s++)
    80005ecc:	00094503          	lbu	a0,0(s2)
    80005ed0:	d515                	beqz	a0,80005dfc <printf+0x9a>
        consputc(*s);
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	b84080e7          	jalr	-1148(ra) # 80005a56 <consputc>
      for(; *s; s++)
    80005eda:	0905                	addi	s2,s2,1
    80005edc:	00094503          	lbu	a0,0(s2)
    80005ee0:	f96d                	bnez	a0,80005ed2 <printf+0x170>
    80005ee2:	bf29                	j	80005dfc <printf+0x9a>
        s = "(null)";
    80005ee4:	00003917          	auipc	s2,0x3
    80005ee8:	96490913          	addi	s2,s2,-1692 # 80008848 <syscalls+0x420>
      for(; *s; s++)
    80005eec:	02800513          	li	a0,40
    80005ef0:	b7cd                	j	80005ed2 <printf+0x170>
      consputc('%');
    80005ef2:	8556                	mv	a0,s5
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	b62080e7          	jalr	-1182(ra) # 80005a56 <consputc>
      break;
    80005efc:	b701                	j	80005dfc <printf+0x9a>
      consputc('%');
    80005efe:	8556                	mv	a0,s5
    80005f00:	00000097          	auipc	ra,0x0
    80005f04:	b56080e7          	jalr	-1194(ra) # 80005a56 <consputc>
      consputc(c);
    80005f08:	854a                	mv	a0,s2
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	b4c080e7          	jalr	-1204(ra) # 80005a56 <consputc>
      break;
    80005f12:	b5ed                	j	80005dfc <printf+0x9a>
  if(locking)
    80005f14:	020d9163          	bnez	s11,80005f36 <printf+0x1d4>
}
    80005f18:	70e6                	ld	ra,120(sp)
    80005f1a:	7446                	ld	s0,112(sp)
    80005f1c:	74a6                	ld	s1,104(sp)
    80005f1e:	7906                	ld	s2,96(sp)
    80005f20:	69e6                	ld	s3,88(sp)
    80005f22:	6a46                	ld	s4,80(sp)
    80005f24:	6aa6                	ld	s5,72(sp)
    80005f26:	6b06                	ld	s6,64(sp)
    80005f28:	7be2                	ld	s7,56(sp)
    80005f2a:	7c42                	ld	s8,48(sp)
    80005f2c:	7ca2                	ld	s9,40(sp)
    80005f2e:	7d02                	ld	s10,32(sp)
    80005f30:	6de2                	ld	s11,24(sp)
    80005f32:	6129                	addi	sp,sp,192
    80005f34:	8082                	ret
    release(&pr.lock);
    80005f36:	00020517          	auipc	a0,0x20
    80005f3a:	2b250513          	addi	a0,a0,690 # 800261e8 <pr>
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	3d8080e7          	jalr	984(ra) # 80006316 <release>
}
    80005f46:	bfc9                	j	80005f18 <printf+0x1b6>

0000000080005f48 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f48:	1101                	addi	sp,sp,-32
    80005f4a:	ec06                	sd	ra,24(sp)
    80005f4c:	e822                	sd	s0,16(sp)
    80005f4e:	e426                	sd	s1,8(sp)
    80005f50:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f52:	00020497          	auipc	s1,0x20
    80005f56:	29648493          	addi	s1,s1,662 # 800261e8 <pr>
    80005f5a:	00003597          	auipc	a1,0x3
    80005f5e:	90658593          	addi	a1,a1,-1786 # 80008860 <syscalls+0x438>
    80005f62:	8526                	mv	a0,s1
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	26e080e7          	jalr	622(ra) # 800061d2 <initlock>
  pr.locking = 1;
    80005f6c:	4785                	li	a5,1
    80005f6e:	cc9c                	sw	a5,24(s1)
}
    80005f70:	60e2                	ld	ra,24(sp)
    80005f72:	6442                	ld	s0,16(sp)
    80005f74:	64a2                	ld	s1,8(sp)
    80005f76:	6105                	addi	sp,sp,32
    80005f78:	8082                	ret

0000000080005f7a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f7a:	1141                	addi	sp,sp,-16
    80005f7c:	e406                	sd	ra,8(sp)
    80005f7e:	e022                	sd	s0,0(sp)
    80005f80:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f82:	100007b7          	lui	a5,0x10000
    80005f86:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f8a:	f8000713          	li	a4,-128
    80005f8e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f92:	470d                	li	a4,3
    80005f94:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f98:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f9c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fa0:	469d                	li	a3,7
    80005fa2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fa6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005faa:	00003597          	auipc	a1,0x3
    80005fae:	8d658593          	addi	a1,a1,-1834 # 80008880 <digits+0x18>
    80005fb2:	00020517          	auipc	a0,0x20
    80005fb6:	25650513          	addi	a0,a0,598 # 80026208 <uart_tx_lock>
    80005fba:	00000097          	auipc	ra,0x0
    80005fbe:	218080e7          	jalr	536(ra) # 800061d2 <initlock>
}
    80005fc2:	60a2                	ld	ra,8(sp)
    80005fc4:	6402                	ld	s0,0(sp)
    80005fc6:	0141                	addi	sp,sp,16
    80005fc8:	8082                	ret

0000000080005fca <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fca:	1101                	addi	sp,sp,-32
    80005fcc:	ec06                	sd	ra,24(sp)
    80005fce:	e822                	sd	s0,16(sp)
    80005fd0:	e426                	sd	s1,8(sp)
    80005fd2:	1000                	addi	s0,sp,32
    80005fd4:	84aa                	mv	s1,a0
  push_off();
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	240080e7          	jalr	576(ra) # 80006216 <push_off>

  if(panicked){
    80005fde:	00003797          	auipc	a5,0x3
    80005fe2:	03e7a783          	lw	a5,62(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fe6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fea:	c391                	beqz	a5,80005fee <uartputc_sync+0x24>
    for(;;)
    80005fec:	a001                	j	80005fec <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fee:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ff2:	0ff7f793          	andi	a5,a5,255
    80005ff6:	0207f793          	andi	a5,a5,32
    80005ffa:	dbf5                	beqz	a5,80005fee <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ffc:	0ff4f793          	andi	a5,s1,255
    80006000:	10000737          	lui	a4,0x10000
    80006004:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	2ae080e7          	jalr	686(ra) # 800062b6 <pop_off>
}
    80006010:	60e2                	ld	ra,24(sp)
    80006012:	6442                	ld	s0,16(sp)
    80006014:	64a2                	ld	s1,8(sp)
    80006016:	6105                	addi	sp,sp,32
    80006018:	8082                	ret

000000008000601a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000601a:	00003717          	auipc	a4,0x3
    8000601e:	00673703          	ld	a4,6(a4) # 80009020 <uart_tx_r>
    80006022:	00003797          	auipc	a5,0x3
    80006026:	0067b783          	ld	a5,6(a5) # 80009028 <uart_tx_w>
    8000602a:	06e78c63          	beq	a5,a4,800060a2 <uartstart+0x88>
{
    8000602e:	7139                	addi	sp,sp,-64
    80006030:	fc06                	sd	ra,56(sp)
    80006032:	f822                	sd	s0,48(sp)
    80006034:	f426                	sd	s1,40(sp)
    80006036:	f04a                	sd	s2,32(sp)
    80006038:	ec4e                	sd	s3,24(sp)
    8000603a:	e852                	sd	s4,16(sp)
    8000603c:	e456                	sd	s5,8(sp)
    8000603e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006040:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006044:	00020a17          	auipc	s4,0x20
    80006048:	1c4a0a13          	addi	s4,s4,452 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000604c:	00003497          	auipc	s1,0x3
    80006050:	fd448493          	addi	s1,s1,-44 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006054:	00003997          	auipc	s3,0x3
    80006058:	fd498993          	addi	s3,s3,-44 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000605c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006060:	0ff7f793          	andi	a5,a5,255
    80006064:	0207f793          	andi	a5,a5,32
    80006068:	c785                	beqz	a5,80006090 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000606a:	01f77793          	andi	a5,a4,31
    8000606e:	97d2                	add	a5,a5,s4
    80006070:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006074:	0705                	addi	a4,a4,1
    80006076:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006078:	8526                	mv	a0,s1
    8000607a:	ffffb097          	auipc	ra,0xffffb
    8000607e:	7f2080e7          	jalr	2034(ra) # 8000186c <wakeup>
    
    WriteReg(THR, c);
    80006082:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006086:	6098                	ld	a4,0(s1)
    80006088:	0009b783          	ld	a5,0(s3)
    8000608c:	fce798e3          	bne	a5,a4,8000605c <uartstart+0x42>
  }
}
    80006090:	70e2                	ld	ra,56(sp)
    80006092:	7442                	ld	s0,48(sp)
    80006094:	74a2                	ld	s1,40(sp)
    80006096:	7902                	ld	s2,32(sp)
    80006098:	69e2                	ld	s3,24(sp)
    8000609a:	6a42                	ld	s4,16(sp)
    8000609c:	6aa2                	ld	s5,8(sp)
    8000609e:	6121                	addi	sp,sp,64
    800060a0:	8082                	ret
    800060a2:	8082                	ret

00000000800060a4 <uartputc>:
{
    800060a4:	7179                	addi	sp,sp,-48
    800060a6:	f406                	sd	ra,40(sp)
    800060a8:	f022                	sd	s0,32(sp)
    800060aa:	ec26                	sd	s1,24(sp)
    800060ac:	e84a                	sd	s2,16(sp)
    800060ae:	e44e                	sd	s3,8(sp)
    800060b0:	e052                	sd	s4,0(sp)
    800060b2:	1800                	addi	s0,sp,48
    800060b4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060b6:	00020517          	auipc	a0,0x20
    800060ba:	15250513          	addi	a0,a0,338 # 80026208 <uart_tx_lock>
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	1a4080e7          	jalr	420(ra) # 80006262 <acquire>
  if(panicked){
    800060c6:	00003797          	auipc	a5,0x3
    800060ca:	f567a783          	lw	a5,-170(a5) # 8000901c <panicked>
    800060ce:	c391                	beqz	a5,800060d2 <uartputc+0x2e>
    for(;;)
    800060d0:	a001                	j	800060d0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060d2:	00003797          	auipc	a5,0x3
    800060d6:	f567b783          	ld	a5,-170(a5) # 80009028 <uart_tx_w>
    800060da:	00003717          	auipc	a4,0x3
    800060de:	f4673703          	ld	a4,-186(a4) # 80009020 <uart_tx_r>
    800060e2:	02070713          	addi	a4,a4,32
    800060e6:	02f71b63          	bne	a4,a5,8000611c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060ea:	00020a17          	auipc	s4,0x20
    800060ee:	11ea0a13          	addi	s4,s4,286 # 80026208 <uart_tx_lock>
    800060f2:	00003497          	auipc	s1,0x3
    800060f6:	f2e48493          	addi	s1,s1,-210 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060fa:	00003917          	auipc	s2,0x3
    800060fe:	f2e90913          	addi	s2,s2,-210 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006102:	85d2                	mv	a1,s4
    80006104:	8526                	mv	a0,s1
    80006106:	ffffb097          	auipc	ra,0xffffb
    8000610a:	5da080e7          	jalr	1498(ra) # 800016e0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000610e:	00093783          	ld	a5,0(s2)
    80006112:	6098                	ld	a4,0(s1)
    80006114:	02070713          	addi	a4,a4,32
    80006118:	fef705e3          	beq	a4,a5,80006102 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000611c:	00020497          	auipc	s1,0x20
    80006120:	0ec48493          	addi	s1,s1,236 # 80026208 <uart_tx_lock>
    80006124:	01f7f713          	andi	a4,a5,31
    80006128:	9726                	add	a4,a4,s1
    8000612a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000612e:	0785                	addi	a5,a5,1
    80006130:	00003717          	auipc	a4,0x3
    80006134:	eef73c23          	sd	a5,-264(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	ee2080e7          	jalr	-286(ra) # 8000601a <uartstart>
      release(&uart_tx_lock);
    80006140:	8526                	mv	a0,s1
    80006142:	00000097          	auipc	ra,0x0
    80006146:	1d4080e7          	jalr	468(ra) # 80006316 <release>
}
    8000614a:	70a2                	ld	ra,40(sp)
    8000614c:	7402                	ld	s0,32(sp)
    8000614e:	64e2                	ld	s1,24(sp)
    80006150:	6942                	ld	s2,16(sp)
    80006152:	69a2                	ld	s3,8(sp)
    80006154:	6a02                	ld	s4,0(sp)
    80006156:	6145                	addi	sp,sp,48
    80006158:	8082                	ret

000000008000615a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000615a:	1141                	addi	sp,sp,-16
    8000615c:	e422                	sd	s0,8(sp)
    8000615e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006160:	100007b7          	lui	a5,0x10000
    80006164:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006168:	8b85                	andi	a5,a5,1
    8000616a:	cb91                	beqz	a5,8000617e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000616c:	100007b7          	lui	a5,0x10000
    80006170:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006174:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006178:	6422                	ld	s0,8(sp)
    8000617a:	0141                	addi	sp,sp,16
    8000617c:	8082                	ret
    return -1;
    8000617e:	557d                	li	a0,-1
    80006180:	bfe5                	j	80006178 <uartgetc+0x1e>

0000000080006182 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006182:	1101                	addi	sp,sp,-32
    80006184:	ec06                	sd	ra,24(sp)
    80006186:	e822                	sd	s0,16(sp)
    80006188:	e426                	sd	s1,8(sp)
    8000618a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000618c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000618e:	00000097          	auipc	ra,0x0
    80006192:	fcc080e7          	jalr	-52(ra) # 8000615a <uartgetc>
    if(c == -1)
    80006196:	00950763          	beq	a0,s1,800061a4 <uartintr+0x22>
      break;
    consoleintr(c);
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	8fe080e7          	jalr	-1794(ra) # 80005a98 <consoleintr>
  while(1){
    800061a2:	b7f5                	j	8000618e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061a4:	00020497          	auipc	s1,0x20
    800061a8:	06448493          	addi	s1,s1,100 # 80026208 <uart_tx_lock>
    800061ac:	8526                	mv	a0,s1
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	0b4080e7          	jalr	180(ra) # 80006262 <acquire>
  uartstart();
    800061b6:	00000097          	auipc	ra,0x0
    800061ba:	e64080e7          	jalr	-412(ra) # 8000601a <uartstart>
  release(&uart_tx_lock);
    800061be:	8526                	mv	a0,s1
    800061c0:	00000097          	auipc	ra,0x0
    800061c4:	156080e7          	jalr	342(ra) # 80006316 <release>
}
    800061c8:	60e2                	ld	ra,24(sp)
    800061ca:	6442                	ld	s0,16(sp)
    800061cc:	64a2                	ld	s1,8(sp)
    800061ce:	6105                	addi	sp,sp,32
    800061d0:	8082                	ret

00000000800061d2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061d2:	1141                	addi	sp,sp,-16
    800061d4:	e422                	sd	s0,8(sp)
    800061d6:	0800                	addi	s0,sp,16
  lk->name = name;
    800061d8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061da:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061de:	00053823          	sd	zero,16(a0)
}
    800061e2:	6422                	ld	s0,8(sp)
    800061e4:	0141                	addi	sp,sp,16
    800061e6:	8082                	ret

00000000800061e8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061e8:	411c                	lw	a5,0(a0)
    800061ea:	e399                	bnez	a5,800061f0 <holding+0x8>
    800061ec:	4501                	li	a0,0
  return r;
}
    800061ee:	8082                	ret
{
    800061f0:	1101                	addi	sp,sp,-32
    800061f2:	ec06                	sd	ra,24(sp)
    800061f4:	e822                	sd	s0,16(sp)
    800061f6:	e426                	sd	s1,8(sp)
    800061f8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061fa:	6904                	ld	s1,16(a0)
    800061fc:	ffffb097          	auipc	ra,0xffffb
    80006200:	d5c080e7          	jalr	-676(ra) # 80000f58 <mycpu>
    80006204:	40a48533          	sub	a0,s1,a0
    80006208:	00153513          	seqz	a0,a0
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret

0000000080006216 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006216:	1101                	addi	sp,sp,-32
    80006218:	ec06                	sd	ra,24(sp)
    8000621a:	e822                	sd	s0,16(sp)
    8000621c:	e426                	sd	s1,8(sp)
    8000621e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006220:	100024f3          	csrr	s1,sstatus
    80006224:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006228:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000622a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	d2a080e7          	jalr	-726(ra) # 80000f58 <mycpu>
    80006236:	5d3c                	lw	a5,120(a0)
    80006238:	cf89                	beqz	a5,80006252 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000623a:	ffffb097          	auipc	ra,0xffffb
    8000623e:	d1e080e7          	jalr	-738(ra) # 80000f58 <mycpu>
    80006242:	5d3c                	lw	a5,120(a0)
    80006244:	2785                	addiw	a5,a5,1
    80006246:	dd3c                	sw	a5,120(a0)
}
    80006248:	60e2                	ld	ra,24(sp)
    8000624a:	6442                	ld	s0,16(sp)
    8000624c:	64a2                	ld	s1,8(sp)
    8000624e:	6105                	addi	sp,sp,32
    80006250:	8082                	ret
    mycpu()->intena = old;
    80006252:	ffffb097          	auipc	ra,0xffffb
    80006256:	d06080e7          	jalr	-762(ra) # 80000f58 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000625a:	8085                	srli	s1,s1,0x1
    8000625c:	8885                	andi	s1,s1,1
    8000625e:	dd64                	sw	s1,124(a0)
    80006260:	bfe9                	j	8000623a <push_off+0x24>

0000000080006262 <acquire>:
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
    8000626c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	fa8080e7          	jalr	-88(ra) # 80006216 <push_off>
  if(holding(lk))
    80006276:	8526                	mv	a0,s1
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	f70080e7          	jalr	-144(ra) # 800061e8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006280:	4705                	li	a4,1
  if(holding(lk))
    80006282:	e115                	bnez	a0,800062a6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006284:	87ba                	mv	a5,a4
    80006286:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000628a:	2781                	sext.w	a5,a5
    8000628c:	ffe5                	bnez	a5,80006284 <acquire+0x22>
  __sync_synchronize();
    8000628e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	cc6080e7          	jalr	-826(ra) # 80000f58 <mycpu>
    8000629a:	e888                	sd	a0,16(s1)
}
    8000629c:	60e2                	ld	ra,24(sp)
    8000629e:	6442                	ld	s0,16(sp)
    800062a0:	64a2                	ld	s1,8(sp)
    800062a2:	6105                	addi	sp,sp,32
    800062a4:	8082                	ret
    panic("acquire");
    800062a6:	00002517          	auipc	a0,0x2
    800062aa:	5e250513          	addi	a0,a0,1506 # 80008888 <digits+0x20>
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	a6a080e7          	jalr	-1430(ra) # 80005d18 <panic>

00000000800062b6 <pop_off>:

void
pop_off(void)
{
    800062b6:	1141                	addi	sp,sp,-16
    800062b8:	e406                	sd	ra,8(sp)
    800062ba:	e022                	sd	s0,0(sp)
    800062bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	c9a080e7          	jalr	-870(ra) # 80000f58 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062cc:	e78d                	bnez	a5,800062f6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062ce:	5d3c                	lw	a5,120(a0)
    800062d0:	02f05b63          	blez	a5,80006306 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062d4:	37fd                	addiw	a5,a5,-1
    800062d6:	0007871b          	sext.w	a4,a5
    800062da:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062dc:	eb09                	bnez	a4,800062ee <pop_off+0x38>
    800062de:	5d7c                	lw	a5,124(a0)
    800062e0:	c799                	beqz	a5,800062ee <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062e6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ea:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062ee:	60a2                	ld	ra,8(sp)
    800062f0:	6402                	ld	s0,0(sp)
    800062f2:	0141                	addi	sp,sp,16
    800062f4:	8082                	ret
    panic("pop_off - interruptible");
    800062f6:	00002517          	auipc	a0,0x2
    800062fa:	59a50513          	addi	a0,a0,1434 # 80008890 <digits+0x28>
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	a1a080e7          	jalr	-1510(ra) # 80005d18 <panic>
    panic("pop_off");
    80006306:	00002517          	auipc	a0,0x2
    8000630a:	5a250513          	addi	a0,a0,1442 # 800088a8 <digits+0x40>
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	a0a080e7          	jalr	-1526(ra) # 80005d18 <panic>

0000000080006316 <release>:
{
    80006316:	1101                	addi	sp,sp,-32
    80006318:	ec06                	sd	ra,24(sp)
    8000631a:	e822                	sd	s0,16(sp)
    8000631c:	e426                	sd	s1,8(sp)
    8000631e:	1000                	addi	s0,sp,32
    80006320:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006322:	00000097          	auipc	ra,0x0
    80006326:	ec6080e7          	jalr	-314(ra) # 800061e8 <holding>
    8000632a:	c115                	beqz	a0,8000634e <release+0x38>
  lk->cpu = 0;
    8000632c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006330:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006334:	0f50000f          	fence	iorw,ow
    80006338:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	f7a080e7          	jalr	-134(ra) # 800062b6 <pop_off>
}
    80006344:	60e2                	ld	ra,24(sp)
    80006346:	6442                	ld	s0,16(sp)
    80006348:	64a2                	ld	s1,8(sp)
    8000634a:	6105                	addi	sp,sp,32
    8000634c:	8082                	ret
    panic("release");
    8000634e:	00002517          	auipc	a0,0x2
    80006352:	56250513          	addi	a0,a0,1378 # 800088b0 <digits+0x48>
    80006356:	00000097          	auipc	ra,0x0
    8000635a:	9c2080e7          	jalr	-1598(ra) # 80005d18 <panic>
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
