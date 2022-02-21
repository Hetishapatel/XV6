
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8d013103          	ld	sp,-1840(sp) # 800088d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	782050ef          	jal	ra,80005798 <start>

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
    8000005e:	1a4080e7          	jalr	420(ra) # 800061fe <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	244080e7          	jalr	580(ra) # 800062b2 <release>
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
    8000008e:	bbe080e7          	jalr	-1090(ra) # 80005c48 <panic>

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
    800000f8:	07a080e7          	jalr	122(ra) # 8000616e <initlock>
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
    80000130:	0d2080e7          	jalr	210(ra) # 800061fe <acquire>
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
    80000148:	16e080e7          	jalr	366(ra) # 800062b2 <release>

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
    80000172:	144080e7          	jalr	324(ra) # 800062b2 <release>
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
    80000332:	c1e080e7          	jalr	-994(ra) # 80000f4c <cpuid>
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
    8000034e:	c02080e7          	jalr	-1022(ra) # 80000f4c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	936080e7          	jalr	-1738(ra) # 80005c92 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	858080e7          	jalr	-1960(ra) # 80001bc4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	dac080e7          	jalr	-596(ra) # 80005120 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	106080e7          	jalr	262(ra) # 80001482 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	7d6080e7          	jalr	2006(ra) # 80005b5a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	aec080e7          	jalr	-1300(ra) # 80005e78 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	8f6080e7          	jalr	-1802(ra) # 80005c92 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	8e6080e7          	jalr	-1818(ra) # 80005c92 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	8d6080e7          	jalr	-1834(ra) # 80005c92 <printf>
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
    800003e0:	ac0080e7          	jalr	-1344(ra) # 80000e9c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	7b8080e7          	jalr	1976(ra) # 80001b9c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	7d8080e7          	jalr	2008(ra) # 80001bc4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d16080e7          	jalr	-746(ra) # 8000510a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d24080e7          	jalr	-732(ra) # 80005120 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f0a080e7          	jalr	-246(ra) # 8000230e <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	59a080e7          	jalr	1434(ra) # 800029a6 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	544080e7          	jalr	1348(ra) # 80003958 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e26080e7          	jalr	-474(ra) # 80005242 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	e2c080e7          	jalr	-468(ra) # 80001250 <userinit>
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
    8000048e:	00005097          	auipc	ra,0x5
    80000492:	7ba080e7          	jalr	1978(ra) # 80005c48 <panic>
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
    8000058a:	6c2080e7          	jalr	1730(ra) # 80005c48 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	6b2080e7          	jalr	1714(ra) # 80005c48 <panic>
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
    80000614:	638080e7          	jalr	1592(ra) # 80005c48 <panic>

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
    80000760:	4ec080e7          	jalr	1260(ra) # 80005c48 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	4dc080e7          	jalr	1244(ra) # 80005c48 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	4cc080e7          	jalr	1228(ra) # 80005c48 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	4bc080e7          	jalr	1212(ra) # 80005c48 <panic>
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
    8000086e:	3de080e7          	jalr	990(ra) # 80005c48 <panic>

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
    800009b0:	29c080e7          	jalr	668(ra) # 80005c48 <panic>
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
    80000a8c:	1c0080e7          	jalr	448(ra) # 80005c48 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	1b0080e7          	jalr	432(ra) # 80005c48 <panic>
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
    80000b06:	146080e7          	jalr	326(ra) # 80005c48 <panic>

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
    80000d40:	f56080e7          	jalr	-170(ra) # 80005c92 <printf>
    80000d44:	bfd1                	j	80000d18 <vmprintwalk+0x42>
       printf(".. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000d46:	00a65c93          	srli	s9,a2,0xa
    80000d4a:	0cb2                	slli	s9,s9,0xc
    80000d4c:	86e6                	mv	a3,s9
    80000d4e:	85a6                	mv	a1,s1
    80000d50:	8562                	mv	a0,s8
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	f40080e7          	jalr	-192(ra) # 80005c92 <printf>
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
    80000da6:	ef0080e7          	jalr	-272(ra) # 80005c92 <printf>
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
    80000dcc:	eca080e7          	jalr	-310(ra) # 80005c92 <printf>
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
    80000e2e:	04000937          	lui	s2,0x4000
    80000e32:	197d                	addi	s2,s2,-1
    80000e34:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	0000ea17          	auipc	s4,0xe
    80000e3a:	24aa0a13          	addi	s4,s4,586 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e3e:	fffff097          	auipc	ra,0xfffff
    80000e42:	2da080e7          	jalr	730(ra) # 80000118 <kalloc>
    80000e46:	862a                	mv	a2,a0
    if(pa == 0)
    80000e48:	c131                	beqz	a0,80000e8c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e4a:	416485b3          	sub	a1,s1,s6
    80000e4e:	8591                	srai	a1,a1,0x4
    80000e50:	000ab783          	ld	a5,0(s5)
    80000e54:	02f585b3          	mul	a1,a1,a5
    80000e58:	2585                	addiw	a1,a1,1
    80000e5a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e5e:	4719                	li	a4,6
    80000e60:	6685                	lui	a3,0x1
    80000e62:	40b905b3          	sub	a1,s2,a1
    80000e66:	854e                	mv	a0,s3
    80000e68:	fffff097          	auipc	ra,0xfffff
    80000e6c:	780080e7          	jalr	1920(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e70:	17048493          	addi	s1,s1,368
    80000e74:	fd4495e3          	bne	s1,s4,80000e3e <proc_mapstacks+0x38>
  }
}
    80000e78:	70e2                	ld	ra,56(sp)
    80000e7a:	7442                	ld	s0,48(sp)
    80000e7c:	74a2                	ld	s1,40(sp)
    80000e7e:	7902                	ld	s2,32(sp)
    80000e80:	69e2                	ld	s3,24(sp)
    80000e82:	6a42                	ld	s4,16(sp)
    80000e84:	6aa2                	ld	s5,8(sp)
    80000e86:	6b02                	ld	s6,0(sp)
    80000e88:	6121                	addi	sp,sp,64
    80000e8a:	8082                	ret
      panic("kalloc");
    80000e8c:	00007517          	auipc	a0,0x7
    80000e90:	32c50513          	addi	a0,a0,812 # 800081b8 <etext+0x1b8>
    80000e94:	00005097          	auipc	ra,0x5
    80000e98:	db4080e7          	jalr	-588(ra) # 80005c48 <panic>

0000000080000e9c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e9c:	7139                	addi	sp,sp,-64
    80000e9e:	fc06                	sd	ra,56(sp)
    80000ea0:	f822                	sd	s0,48(sp)
    80000ea2:	f426                	sd	s1,40(sp)
    80000ea4:	f04a                	sd	s2,32(sp)
    80000ea6:	ec4e                	sd	s3,24(sp)
    80000ea8:	e852                	sd	s4,16(sp)
    80000eaa:	e456                	sd	s5,8(sp)
    80000eac:	e05a                	sd	s6,0(sp)
    80000eae:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000eb0:	00007597          	auipc	a1,0x7
    80000eb4:	31058593          	addi	a1,a1,784 # 800081c0 <etext+0x1c0>
    80000eb8:	00008517          	auipc	a0,0x8
    80000ebc:	19850513          	addi	a0,a0,408 # 80009050 <pid_lock>
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	2ae080e7          	jalr	686(ra) # 8000616e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ec8:	00007597          	auipc	a1,0x7
    80000ecc:	30058593          	addi	a1,a1,768 # 800081c8 <etext+0x1c8>
    80000ed0:	00008517          	auipc	a0,0x8
    80000ed4:	19850513          	addi	a0,a0,408 # 80009068 <wait_lock>
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	296080e7          	jalr	662(ra) # 8000616e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee0:	00008497          	auipc	s1,0x8
    80000ee4:	5a048493          	addi	s1,s1,1440 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ee8:	00007b17          	auipc	s6,0x7
    80000eec:	2f0b0b13          	addi	s6,s6,752 # 800081d8 <etext+0x1d8>
      p->kstack = KSTACK((int) (p - proc));
    80000ef0:	8aa6                	mv	s5,s1
    80000ef2:	00007a17          	auipc	s4,0x7
    80000ef6:	10ea0a13          	addi	s4,s4,270 # 80008000 <etext>
    80000efa:	04000937          	lui	s2,0x4000
    80000efe:	197d                	addi	s2,s2,-1
    80000f00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f02:	0000e997          	auipc	s3,0xe
    80000f06:	17e98993          	addi	s3,s3,382 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000f0a:	85da                	mv	a1,s6
    80000f0c:	8526                	mv	a0,s1
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	260080e7          	jalr	608(ra) # 8000616e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f16:	415487b3          	sub	a5,s1,s5
    80000f1a:	8791                	srai	a5,a5,0x4
    80000f1c:	000a3703          	ld	a4,0(s4)
    80000f20:	02e787b3          	mul	a5,a5,a4
    80000f24:	2785                	addiw	a5,a5,1
    80000f26:	00d7979b          	slliw	a5,a5,0xd
    80000f2a:	40f907b3          	sub	a5,s2,a5
    80000f2e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f30:	17048493          	addi	s1,s1,368
    80000f34:	fd349be3          	bne	s1,s3,80000f0a <procinit+0x6e>
  }
}
    80000f38:	70e2                	ld	ra,56(sp)
    80000f3a:	7442                	ld	s0,48(sp)
    80000f3c:	74a2                	ld	s1,40(sp)
    80000f3e:	7902                	ld	s2,32(sp)
    80000f40:	69e2                	ld	s3,24(sp)
    80000f42:	6a42                	ld	s4,16(sp)
    80000f44:	6aa2                	ld	s5,8(sp)
    80000f46:	6b02                	ld	s6,0(sp)
    80000f48:	6121                	addi	sp,sp,64
    80000f4a:	8082                	ret

0000000080000f4c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f4c:	1141                	addi	sp,sp,-16
    80000f4e:	e422                	sd	s0,8(sp)
    80000f50:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f52:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f54:	2501                	sext.w	a0,a0
    80000f56:	6422                	ld	s0,8(sp)
    80000f58:	0141                	addi	sp,sp,16
    80000f5a:	8082                	ret

0000000080000f5c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f5c:	1141                	addi	sp,sp,-16
    80000f5e:	e422                	sd	s0,8(sp)
    80000f60:	0800                	addi	s0,sp,16
    80000f62:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f64:	2781                	sext.w	a5,a5
    80000f66:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f68:	00008517          	auipc	a0,0x8
    80000f6c:	11850513          	addi	a0,a0,280 # 80009080 <cpus>
    80000f70:	953e                	add	a0,a0,a5
    80000f72:	6422                	ld	s0,8(sp)
    80000f74:	0141                	addi	sp,sp,16
    80000f76:	8082                	ret

0000000080000f78 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f78:	1101                	addi	sp,sp,-32
    80000f7a:	ec06                	sd	ra,24(sp)
    80000f7c:	e822                	sd	s0,16(sp)
    80000f7e:	e426                	sd	s1,8(sp)
    80000f80:	1000                	addi	s0,sp,32
  push_off();
    80000f82:	00005097          	auipc	ra,0x5
    80000f86:	230080e7          	jalr	560(ra) # 800061b2 <push_off>
    80000f8a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f8c:	2781                	sext.w	a5,a5
    80000f8e:	079e                	slli	a5,a5,0x7
    80000f90:	00008717          	auipc	a4,0x8
    80000f94:	0c070713          	addi	a4,a4,192 # 80009050 <pid_lock>
    80000f98:	97ba                	add	a5,a5,a4
    80000f9a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f9c:	00005097          	auipc	ra,0x5
    80000fa0:	2b6080e7          	jalr	694(ra) # 80006252 <pop_off>
  return p;
}
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	60e2                	ld	ra,24(sp)
    80000fa8:	6442                	ld	s0,16(sp)
    80000faa:	64a2                	ld	s1,8(sp)
    80000fac:	6105                	addi	sp,sp,32
    80000fae:	8082                	ret

0000000080000fb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fb0:	1141                	addi	sp,sp,-16
    80000fb2:	e406                	sd	ra,8(sp)
    80000fb4:	e022                	sd	s0,0(sp)
    80000fb6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fb8:	00000097          	auipc	ra,0x0
    80000fbc:	fc0080e7          	jalr	-64(ra) # 80000f78 <myproc>
    80000fc0:	00005097          	auipc	ra,0x5
    80000fc4:	2f2080e7          	jalr	754(ra) # 800062b2 <release>

  if (first) {
    80000fc8:	00008797          	auipc	a5,0x8
    80000fcc:	8b87a783          	lw	a5,-1864(a5) # 80008880 <first.1685>
    80000fd0:	eb89                	bnez	a5,80000fe2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fd2:	00001097          	auipc	ra,0x1
    80000fd6:	c0a080e7          	jalr	-1014(ra) # 80001bdc <usertrapret>
}
    80000fda:	60a2                	ld	ra,8(sp)
    80000fdc:	6402                	ld	s0,0(sp)
    80000fde:	0141                	addi	sp,sp,16
    80000fe0:	8082                	ret
    first = 0;
    80000fe2:	00008797          	auipc	a5,0x8
    80000fe6:	8807af23          	sw	zero,-1890(a5) # 80008880 <first.1685>
    fsinit(ROOTDEV);
    80000fea:	4505                	li	a0,1
    80000fec:	00002097          	auipc	ra,0x2
    80000ff0:	93a080e7          	jalr	-1734(ra) # 80002926 <fsinit>
    80000ff4:	bff9                	j	80000fd2 <forkret+0x22>

0000000080000ff6 <allocpid>:
allocpid() {
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	e04a                	sd	s2,0(sp)
    80001000:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001002:	00008917          	auipc	s2,0x8
    80001006:	04e90913          	addi	s2,s2,78 # 80009050 <pid_lock>
    8000100a:	854a                	mv	a0,s2
    8000100c:	00005097          	auipc	ra,0x5
    80001010:	1f2080e7          	jalr	498(ra) # 800061fe <acquire>
  pid = nextpid;
    80001014:	00008797          	auipc	a5,0x8
    80001018:	87078793          	addi	a5,a5,-1936 # 80008884 <nextpid>
    8000101c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000101e:	0014871b          	addiw	a4,s1,1
    80001022:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001024:	854a                	mv	a0,s2
    80001026:	00005097          	auipc	ra,0x5
    8000102a:	28c080e7          	jalr	652(ra) # 800062b2 <release>
}
    8000102e:	8526                	mv	a0,s1
    80001030:	60e2                	ld	ra,24(sp)
    80001032:	6442                	ld	s0,16(sp)
    80001034:	64a2                	ld	s1,8(sp)
    80001036:	6902                	ld	s2,0(sp)
    80001038:	6105                	addi	sp,sp,32
    8000103a:	8082                	ret

000000008000103c <proc_pagetable>:
{
    8000103c:	1101                	addi	sp,sp,-32
    8000103e:	ec06                	sd	ra,24(sp)
    80001040:	e822                	sd	s0,16(sp)
    80001042:	e426                	sd	s1,8(sp)
    80001044:	e04a                	sd	s2,0(sp)
    80001046:	1000                	addi	s0,sp,32
    80001048:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000104a:	fffff097          	auipc	ra,0xfffff
    8000104e:	788080e7          	jalr	1928(ra) # 800007d2 <uvmcreate>
    80001052:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001054:	c121                	beqz	a0,80001094 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001056:	4729                	li	a4,10
    80001058:	00006697          	auipc	a3,0x6
    8000105c:	fa868693          	addi	a3,a3,-88 # 80007000 <_trampoline>
    80001060:	6605                	lui	a2,0x1
    80001062:	040005b7          	lui	a1,0x4000
    80001066:	15fd                	addi	a1,a1,-1
    80001068:	05b2                	slli	a1,a1,0xc
    8000106a:	fffff097          	auipc	ra,0xfffff
    8000106e:	4de080e7          	jalr	1246(ra) # 80000548 <mappages>
    80001072:	02054863          	bltz	a0,800010a2 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001076:	4719                	li	a4,6
    80001078:	06093683          	ld	a3,96(s2)
    8000107c:	6605                	lui	a2,0x1
    8000107e:	020005b7          	lui	a1,0x2000
    80001082:	15fd                	addi	a1,a1,-1
    80001084:	05b6                	slli	a1,a1,0xd
    80001086:	8526                	mv	a0,s1
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	4c0080e7          	jalr	1216(ra) # 80000548 <mappages>
    80001090:	02054163          	bltz	a0,800010b2 <proc_pagetable+0x76>
}
    80001094:	8526                	mv	a0,s1
    80001096:	60e2                	ld	ra,24(sp)
    80001098:	6442                	ld	s0,16(sp)
    8000109a:	64a2                	ld	s1,8(sp)
    8000109c:	6902                	ld	s2,0(sp)
    8000109e:	6105                	addi	sp,sp,32
    800010a0:	8082                	ret
    uvmfree(pagetable, 0);
    800010a2:	4581                	li	a1,0
    800010a4:	8526                	mv	a0,s1
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	928080e7          	jalr	-1752(ra) # 800009ce <uvmfree>
    return 0;
    800010ae:	4481                	li	s1,0
    800010b0:	b7d5                	j	80001094 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b2:	4681                	li	a3,0
    800010b4:	4605                	li	a2,1
    800010b6:	040005b7          	lui	a1,0x4000
    800010ba:	15fd                	addi	a1,a1,-1
    800010bc:	05b2                	slli	a1,a1,0xc
    800010be:	8526                	mv	a0,s1
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	64e080e7          	jalr	1614(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    800010c8:	4581                	li	a1,0
    800010ca:	8526                	mv	a0,s1
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	902080e7          	jalr	-1790(ra) # 800009ce <uvmfree>
    return 0;
    800010d4:	4481                	li	s1,0
    800010d6:	bf7d                	j	80001094 <proc_pagetable+0x58>

00000000800010d8 <proc_freepagetable>:
{
    800010d8:	1101                	addi	sp,sp,-32
    800010da:	ec06                	sd	ra,24(sp)
    800010dc:	e822                	sd	s0,16(sp)
    800010de:	e426                	sd	s1,8(sp)
    800010e0:	e04a                	sd	s2,0(sp)
    800010e2:	1000                	addi	s0,sp,32
    800010e4:	84aa                	mv	s1,a0
    800010e6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010e8:	4681                	li	a3,0
    800010ea:	4605                	li	a2,1
    800010ec:	040005b7          	lui	a1,0x4000
    800010f0:	15fd                	addi	a1,a1,-1
    800010f2:	05b2                	slli	a1,a1,0xc
    800010f4:	fffff097          	auipc	ra,0xfffff
    800010f8:	61a080e7          	jalr	1562(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010fc:	4681                	li	a3,0
    800010fe:	4605                	li	a2,1
    80001100:	020005b7          	lui	a1,0x2000
    80001104:	15fd                	addi	a1,a1,-1
    80001106:	05b6                	slli	a1,a1,0xd
    80001108:	8526                	mv	a0,s1
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	604080e7          	jalr	1540(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80001112:	85ca                	mv	a1,s2
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	8b8080e7          	jalr	-1864(ra) # 800009ce <uvmfree>
}
    8000111e:	60e2                	ld	ra,24(sp)
    80001120:	6442                	ld	s0,16(sp)
    80001122:	64a2                	ld	s1,8(sp)
    80001124:	6902                	ld	s2,0(sp)
    80001126:	6105                	addi	sp,sp,32
    80001128:	8082                	ret

000000008000112a <freeproc>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
    80001134:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001136:	7128                	ld	a0,96(a0)
    80001138:	c509                	beqz	a0,80001142 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	ee2080e7          	jalr	-286(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001142:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001146:	68a8                	ld	a0,80(s1)
    80001148:	c511                	beqz	a0,80001154 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000114a:	64ac                	ld	a1,72(s1)
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f8c080e7          	jalr	-116(ra) # 800010d8 <proc_freepagetable>
  p->pagetable = 0;
    80001154:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001158:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000115c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001160:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001164:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001168:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000116c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001170:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001174:	0004ac23          	sw	zero,24(s1)
}
    80001178:	60e2                	ld	ra,24(sp)
    8000117a:	6442                	ld	s0,16(sp)
    8000117c:	64a2                	ld	s1,8(sp)
    8000117e:	6105                	addi	sp,sp,32
    80001180:	8082                	ret

0000000080001182 <allocproc>:
{
    80001182:	1101                	addi	sp,sp,-32
    80001184:	ec06                	sd	ra,24(sp)
    80001186:	e822                	sd	s0,16(sp)
    80001188:	e426                	sd	s1,8(sp)
    8000118a:	e04a                	sd	s2,0(sp)
    8000118c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000118e:	00008497          	auipc	s1,0x8
    80001192:	2f248493          	addi	s1,s1,754 # 80009480 <proc>
    80001196:	0000e917          	auipc	s2,0xe
    8000119a:	eea90913          	addi	s2,s2,-278 # 8000f080 <tickslock>
    acquire(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00005097          	auipc	ra,0x5
    800011a4:	05e080e7          	jalr	94(ra) # 800061fe <acquire>
    if(p->state == UNUSED) {
    800011a8:	4c9c                	lw	a5,24(s1)
    800011aa:	cf81                	beqz	a5,800011c2 <allocproc+0x40>
      release(&p->lock);
    800011ac:	8526                	mv	a0,s1
    800011ae:	00005097          	auipc	ra,0x5
    800011b2:	104080e7          	jalr	260(ra) # 800062b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011b6:	17048493          	addi	s1,s1,368
    800011ba:	ff2492e3          	bne	s1,s2,8000119e <allocproc+0x1c>
  return 0;
    800011be:	4481                	li	s1,0
    800011c0:	a889                	j	80001212 <allocproc+0x90>
  p->pid = allocpid();
    800011c2:	00000097          	auipc	ra,0x0
    800011c6:	e34080e7          	jalr	-460(ra) # 80000ff6 <allocpid>
    800011ca:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011cc:	4785                	li	a5,1
    800011ce:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011d0:	fffff097          	auipc	ra,0xfffff
    800011d4:	f48080e7          	jalr	-184(ra) # 80000118 <kalloc>
    800011d8:	892a                	mv	s2,a0
    800011da:	f0a8                	sd	a0,96(s1)
    800011dc:	c131                	beqz	a0,80001220 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011de:	8526                	mv	a0,s1
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	e5c080e7          	jalr	-420(ra) # 8000103c <proc_pagetable>
    800011e8:	892a                	mv	s2,a0
    800011ea:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800011ec:	c531                	beqz	a0,80001238 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011ee:	07000613          	li	a2,112
    800011f2:	4581                	li	a1,0
    800011f4:	06848513          	addi	a0,s1,104
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	f80080e7          	jalr	-128(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001200:	00000797          	auipc	a5,0x0
    80001204:	db078793          	addi	a5,a5,-592 # 80000fb0 <forkret>
    80001208:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000120a:	60bc                	ld	a5,64(s1)
    8000120c:	6705                	lui	a4,0x1
    8000120e:	97ba                	add	a5,a5,a4
    80001210:	f8bc                	sd	a5,112(s1)
}
    80001212:	8526                	mv	a0,s1
    80001214:	60e2                	ld	ra,24(sp)
    80001216:	6442                	ld	s0,16(sp)
    80001218:	64a2                	ld	s1,8(sp)
    8000121a:	6902                	ld	s2,0(sp)
    8000121c:	6105                	addi	sp,sp,32
    8000121e:	8082                	ret
    freeproc(p);
    80001220:	8526                	mv	a0,s1
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f08080e7          	jalr	-248(ra) # 8000112a <freeproc>
    release(&p->lock);
    8000122a:	8526                	mv	a0,s1
    8000122c:	00005097          	auipc	ra,0x5
    80001230:	086080e7          	jalr	134(ra) # 800062b2 <release>
    return 0;
    80001234:	84ca                	mv	s1,s2
    80001236:	bff1                	j	80001212 <allocproc+0x90>
    freeproc(p);
    80001238:	8526                	mv	a0,s1
    8000123a:	00000097          	auipc	ra,0x0
    8000123e:	ef0080e7          	jalr	-272(ra) # 8000112a <freeproc>
    release(&p->lock);
    80001242:	8526                	mv	a0,s1
    80001244:	00005097          	auipc	ra,0x5
    80001248:	06e080e7          	jalr	110(ra) # 800062b2 <release>
    return 0;
    8000124c:	84ca                	mv	s1,s2
    8000124e:	b7d1                	j	80001212 <allocproc+0x90>

0000000080001250 <userinit>:
{
    80001250:	1101                	addi	sp,sp,-32
    80001252:	ec06                	sd	ra,24(sp)
    80001254:	e822                	sd	s0,16(sp)
    80001256:	e426                	sd	s1,8(sp)
    80001258:	1000                	addi	s0,sp,32
  p = allocproc();
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	f28080e7          	jalr	-216(ra) # 80001182 <allocproc>
    80001262:	84aa                	mv	s1,a0
  initproc = p;
    80001264:	00008797          	auipc	a5,0x8
    80001268:	daa7b623          	sd	a0,-596(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000126c:	03400613          	li	a2,52
    80001270:	00007597          	auipc	a1,0x7
    80001274:	62058593          	addi	a1,a1,1568 # 80008890 <initcode>
    80001278:	6928                	ld	a0,80(a0)
    8000127a:	fffff097          	auipc	ra,0xfffff
    8000127e:	586080e7          	jalr	1414(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001282:	6785                	lui	a5,0x1
    80001284:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001286:	70b8                	ld	a4,96(s1)
    80001288:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000128c:	70b8                	ld	a4,96(s1)
    8000128e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001290:	4641                	li	a2,16
    80001292:	00007597          	auipc	a1,0x7
    80001296:	f4e58593          	addi	a1,a1,-178 # 800081e0 <etext+0x1e0>
    8000129a:	16048513          	addi	a0,s1,352
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	02c080e7          	jalr	44(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800012a6:	00007517          	auipc	a0,0x7
    800012aa:	f4a50513          	addi	a0,a0,-182 # 800081f0 <etext+0x1f0>
    800012ae:	00002097          	auipc	ra,0x2
    800012b2:	0a6080e7          	jalr	166(ra) # 80003354 <namei>
    800012b6:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012ba:	478d                	li	a5,3
    800012bc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012be:	8526                	mv	a0,s1
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	ff2080e7          	jalr	-14(ra) # 800062b2 <release>
}
    800012c8:	60e2                	ld	ra,24(sp)
    800012ca:	6442                	ld	s0,16(sp)
    800012cc:	64a2                	ld	s1,8(sp)
    800012ce:	6105                	addi	sp,sp,32
    800012d0:	8082                	ret

00000000800012d2 <growproc>:
{
    800012d2:	1101                	addi	sp,sp,-32
    800012d4:	ec06                	sd	ra,24(sp)
    800012d6:	e822                	sd	s0,16(sp)
    800012d8:	e426                	sd	s1,8(sp)
    800012da:	e04a                	sd	s2,0(sp)
    800012dc:	1000                	addi	s0,sp,32
    800012de:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	c98080e7          	jalr	-872(ra) # 80000f78 <myproc>
    800012e8:	892a                	mv	s2,a0
  sz = p->sz;
    800012ea:	652c                	ld	a1,72(a0)
    800012ec:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800012f0:	00904f63          	bgtz	s1,8000130e <growproc+0x3c>
  } else if(n < 0){
    800012f4:	0204cc63          	bltz	s1,8000132c <growproc+0x5a>
  p->sz = sz;
    800012f8:	1602                	slli	a2,a2,0x20
    800012fa:	9201                	srli	a2,a2,0x20
    800012fc:	04c93423          	sd	a2,72(s2)
  return 0;
    80001300:	4501                	li	a0,0
}
    80001302:	60e2                	ld	ra,24(sp)
    80001304:	6442                	ld	s0,16(sp)
    80001306:	64a2                	ld	s1,8(sp)
    80001308:	6902                	ld	s2,0(sp)
    8000130a:	6105                	addi	sp,sp,32
    8000130c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000130e:	9e25                	addw	a2,a2,s1
    80001310:	1602                	slli	a2,a2,0x20
    80001312:	9201                	srli	a2,a2,0x20
    80001314:	1582                	slli	a1,a1,0x20
    80001316:	9181                	srli	a1,a1,0x20
    80001318:	6928                	ld	a0,80(a0)
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	5a0080e7          	jalr	1440(ra) # 800008ba <uvmalloc>
    80001322:	0005061b          	sext.w	a2,a0
    80001326:	fa69                	bnez	a2,800012f8 <growproc+0x26>
      return -1;
    80001328:	557d                	li	a0,-1
    8000132a:	bfe1                	j	80001302 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000132c:	9e25                	addw	a2,a2,s1
    8000132e:	1602                	slli	a2,a2,0x20
    80001330:	9201                	srli	a2,a2,0x20
    80001332:	1582                	slli	a1,a1,0x20
    80001334:	9181                	srli	a1,a1,0x20
    80001336:	6928                	ld	a0,80(a0)
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	53a080e7          	jalr	1338(ra) # 80000872 <uvmdealloc>
    80001340:	0005061b          	sext.w	a2,a0
    80001344:	bf55                	j	800012f8 <growproc+0x26>

0000000080001346 <fork>:
{
    80001346:	7179                	addi	sp,sp,-48
    80001348:	f406                	sd	ra,40(sp)
    8000134a:	f022                	sd	s0,32(sp)
    8000134c:	ec26                	sd	s1,24(sp)
    8000134e:	e84a                	sd	s2,16(sp)
    80001350:	e44e                	sd	s3,8(sp)
    80001352:	e052                	sd	s4,0(sp)
    80001354:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001356:	00000097          	auipc	ra,0x0
    8000135a:	c22080e7          	jalr	-990(ra) # 80000f78 <myproc>
    8000135e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001360:	00000097          	auipc	ra,0x0
    80001364:	e22080e7          	jalr	-478(ra) # 80001182 <allocproc>
    80001368:	10050b63          	beqz	a0,8000147e <fork+0x138>
    8000136c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000136e:	04893603          	ld	a2,72(s2)
    80001372:	692c                	ld	a1,80(a0)
    80001374:	05093503          	ld	a0,80(s2)
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	68e080e7          	jalr	1678(ra) # 80000a06 <uvmcopy>
    80001380:	04054663          	bltz	a0,800013cc <fork+0x86>
  np->sz = p->sz;
    80001384:	04893783          	ld	a5,72(s2)
    80001388:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000138c:	06093683          	ld	a3,96(s2)
    80001390:	87b6                	mv	a5,a3
    80001392:	0609b703          	ld	a4,96(s3)
    80001396:	12068693          	addi	a3,a3,288
    8000139a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000139e:	6788                	ld	a0,8(a5)
    800013a0:	6b8c                	ld	a1,16(a5)
    800013a2:	6f90                	ld	a2,24(a5)
    800013a4:	01073023          	sd	a6,0(a4)
    800013a8:	e708                	sd	a0,8(a4)
    800013aa:	eb0c                	sd	a1,16(a4)
    800013ac:	ef10                	sd	a2,24(a4)
    800013ae:	02078793          	addi	a5,a5,32
    800013b2:	02070713          	addi	a4,a4,32
    800013b6:	fed792e3          	bne	a5,a3,8000139a <fork+0x54>
  np->trapframe->a0 = 0;
    800013ba:	0609b783          	ld	a5,96(s3)
    800013be:	0607b823          	sd	zero,112(a5)
    800013c2:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    800013c6:	15800a13          	li	s4,344
    800013ca:	a03d                	j	800013f8 <fork+0xb2>
    freeproc(np);
    800013cc:	854e                	mv	a0,s3
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	d5c080e7          	jalr	-676(ra) # 8000112a <freeproc>
    release(&np->lock);
    800013d6:	854e                	mv	a0,s3
    800013d8:	00005097          	auipc	ra,0x5
    800013dc:	eda080e7          	jalr	-294(ra) # 800062b2 <release>
    return -1;
    800013e0:	5a7d                	li	s4,-1
    800013e2:	a069                	j	8000146c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800013e4:	00002097          	auipc	ra,0x2
    800013e8:	606080e7          	jalr	1542(ra) # 800039ea <filedup>
    800013ec:	009987b3          	add	a5,s3,s1
    800013f0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800013f2:	04a1                	addi	s1,s1,8
    800013f4:	01448763          	beq	s1,s4,80001402 <fork+0xbc>
    if(p->ofile[i])
    800013f8:	009907b3          	add	a5,s2,s1
    800013fc:	6388                	ld	a0,0(a5)
    800013fe:	f17d                	bnez	a0,800013e4 <fork+0x9e>
    80001400:	bfcd                	j	800013f2 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001402:	15893503          	ld	a0,344(s2)
    80001406:	00001097          	auipc	ra,0x1
    8000140a:	75a080e7          	jalr	1882(ra) # 80002b60 <idup>
    8000140e:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001412:	4641                	li	a2,16
    80001414:	16090593          	addi	a1,s2,352
    80001418:	16098513          	addi	a0,s3,352
    8000141c:	fffff097          	auipc	ra,0xfffff
    80001420:	eae080e7          	jalr	-338(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001424:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001428:	854e                	mv	a0,s3
    8000142a:	00005097          	auipc	ra,0x5
    8000142e:	e88080e7          	jalr	-376(ra) # 800062b2 <release>
  acquire(&wait_lock);
    80001432:	00008497          	auipc	s1,0x8
    80001436:	c3648493          	addi	s1,s1,-970 # 80009068 <wait_lock>
    8000143a:	8526                	mv	a0,s1
    8000143c:	00005097          	auipc	ra,0x5
    80001440:	dc2080e7          	jalr	-574(ra) # 800061fe <acquire>
  np->parent = p;
    80001444:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001448:	8526                	mv	a0,s1
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	e68080e7          	jalr	-408(ra) # 800062b2 <release>
  acquire(&np->lock);
    80001452:	854e                	mv	a0,s3
    80001454:	00005097          	auipc	ra,0x5
    80001458:	daa080e7          	jalr	-598(ra) # 800061fe <acquire>
  np->state = RUNNABLE;
    8000145c:	478d                	li	a5,3
    8000145e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001462:	854e                	mv	a0,s3
    80001464:	00005097          	auipc	ra,0x5
    80001468:	e4e080e7          	jalr	-434(ra) # 800062b2 <release>
}
    8000146c:	8552                	mv	a0,s4
    8000146e:	70a2                	ld	ra,40(sp)
    80001470:	7402                	ld	s0,32(sp)
    80001472:	64e2                	ld	s1,24(sp)
    80001474:	6942                	ld	s2,16(sp)
    80001476:	69a2                	ld	s3,8(sp)
    80001478:	6a02                	ld	s4,0(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret
    return -1;
    8000147e:	5a7d                	li	s4,-1
    80001480:	b7f5                	j	8000146c <fork+0x126>

0000000080001482 <scheduler>:
{
    80001482:	7139                	addi	sp,sp,-64
    80001484:	fc06                	sd	ra,56(sp)
    80001486:	f822                	sd	s0,48(sp)
    80001488:	f426                	sd	s1,40(sp)
    8000148a:	f04a                	sd	s2,32(sp)
    8000148c:	ec4e                	sd	s3,24(sp)
    8000148e:	e852                	sd	s4,16(sp)
    80001490:	e456                	sd	s5,8(sp)
    80001492:	e05a                	sd	s6,0(sp)
    80001494:	0080                	addi	s0,sp,64
    80001496:	8792                	mv	a5,tp
  int id = r_tp();
    80001498:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000149a:	00779a93          	slli	s5,a5,0x7
    8000149e:	00008717          	auipc	a4,0x8
    800014a2:	bb270713          	addi	a4,a4,-1102 # 80009050 <pid_lock>
    800014a6:	9756                	add	a4,a4,s5
    800014a8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014ac:	00008717          	auipc	a4,0x8
    800014b0:	bdc70713          	addi	a4,a4,-1060 # 80009088 <cpus+0x8>
    800014b4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014b6:	498d                	li	s3,3
        p->state = RUNNING;
    800014b8:	4b11                	li	s6,4
        c->proc = p;
    800014ba:	079e                	slli	a5,a5,0x7
    800014bc:	00008a17          	auipc	s4,0x8
    800014c0:	b94a0a13          	addi	s4,s4,-1132 # 80009050 <pid_lock>
    800014c4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014c6:	0000e917          	auipc	s2,0xe
    800014ca:	bba90913          	addi	s2,s2,-1094 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014d2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014d6:	10079073          	csrw	sstatus,a5
    800014da:	00008497          	auipc	s1,0x8
    800014de:	fa648493          	addi	s1,s1,-90 # 80009480 <proc>
    800014e2:	a03d                	j	80001510 <scheduler+0x8e>
        p->state = RUNNING;
    800014e4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800014e8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014ec:	06848593          	addi	a1,s1,104
    800014f0:	8556                	mv	a0,s5
    800014f2:	00000097          	auipc	ra,0x0
    800014f6:	640080e7          	jalr	1600(ra) # 80001b32 <swtch>
        c->proc = 0;
    800014fa:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	00005097          	auipc	ra,0x5
    80001504:	db2080e7          	jalr	-590(ra) # 800062b2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001508:	17048493          	addi	s1,s1,368
    8000150c:	fd2481e3          	beq	s1,s2,800014ce <scheduler+0x4c>
      acquire(&p->lock);
    80001510:	8526                	mv	a0,s1
    80001512:	00005097          	auipc	ra,0x5
    80001516:	cec080e7          	jalr	-788(ra) # 800061fe <acquire>
      if(p->state == RUNNABLE) {
    8000151a:	4c9c                	lw	a5,24(s1)
    8000151c:	ff3791e3          	bne	a5,s3,800014fe <scheduler+0x7c>
    80001520:	b7d1                	j	800014e4 <scheduler+0x62>

0000000080001522 <sched>:
{
    80001522:	7179                	addi	sp,sp,-48
    80001524:	f406                	sd	ra,40(sp)
    80001526:	f022                	sd	s0,32(sp)
    80001528:	ec26                	sd	s1,24(sp)
    8000152a:	e84a                	sd	s2,16(sp)
    8000152c:	e44e                	sd	s3,8(sp)
    8000152e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	a48080e7          	jalr	-1464(ra) # 80000f78 <myproc>
    80001538:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	c4a080e7          	jalr	-950(ra) # 80006184 <holding>
    80001542:	c93d                	beqz	a0,800015b8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001544:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001546:	2781                	sext.w	a5,a5
    80001548:	079e                	slli	a5,a5,0x7
    8000154a:	00008717          	auipc	a4,0x8
    8000154e:	b0670713          	addi	a4,a4,-1274 # 80009050 <pid_lock>
    80001552:	97ba                	add	a5,a5,a4
    80001554:	0a87a703          	lw	a4,168(a5)
    80001558:	4785                	li	a5,1
    8000155a:	06f71763          	bne	a4,a5,800015c8 <sched+0xa6>
  if(p->state == RUNNING)
    8000155e:	4c98                	lw	a4,24(s1)
    80001560:	4791                	li	a5,4
    80001562:	06f70b63          	beq	a4,a5,800015d8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001566:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000156a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000156c:	efb5                	bnez	a5,800015e8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000156e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001570:	00008917          	auipc	s2,0x8
    80001574:	ae090913          	addi	s2,s2,-1312 # 80009050 <pid_lock>
    80001578:	2781                	sext.w	a5,a5
    8000157a:	079e                	slli	a5,a5,0x7
    8000157c:	97ca                	add	a5,a5,s2
    8000157e:	0ac7a983          	lw	s3,172(a5)
    80001582:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001584:	2781                	sext.w	a5,a5
    80001586:	079e                	slli	a5,a5,0x7
    80001588:	00008597          	auipc	a1,0x8
    8000158c:	b0058593          	addi	a1,a1,-1280 # 80009088 <cpus+0x8>
    80001590:	95be                	add	a1,a1,a5
    80001592:	06848513          	addi	a0,s1,104
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	59c080e7          	jalr	1436(ra) # 80001b32 <swtch>
    8000159e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015a0:	2781                	sext.w	a5,a5
    800015a2:	079e                	slli	a5,a5,0x7
    800015a4:	97ca                	add	a5,a5,s2
    800015a6:	0b37a623          	sw	s3,172(a5)
}
    800015aa:	70a2                	ld	ra,40(sp)
    800015ac:	7402                	ld	s0,32(sp)
    800015ae:	64e2                	ld	s1,24(sp)
    800015b0:	6942                	ld	s2,16(sp)
    800015b2:	69a2                	ld	s3,8(sp)
    800015b4:	6145                	addi	sp,sp,48
    800015b6:	8082                	ret
    panic("sched p->lock");
    800015b8:	00007517          	auipc	a0,0x7
    800015bc:	c4050513          	addi	a0,a0,-960 # 800081f8 <etext+0x1f8>
    800015c0:	00004097          	auipc	ra,0x4
    800015c4:	688080e7          	jalr	1672(ra) # 80005c48 <panic>
    panic("sched locks");
    800015c8:	00007517          	auipc	a0,0x7
    800015cc:	c4050513          	addi	a0,a0,-960 # 80008208 <etext+0x208>
    800015d0:	00004097          	auipc	ra,0x4
    800015d4:	678080e7          	jalr	1656(ra) # 80005c48 <panic>
    panic("sched running");
    800015d8:	00007517          	auipc	a0,0x7
    800015dc:	c4050513          	addi	a0,a0,-960 # 80008218 <etext+0x218>
    800015e0:	00004097          	auipc	ra,0x4
    800015e4:	668080e7          	jalr	1640(ra) # 80005c48 <panic>
    panic("sched interruptible");
    800015e8:	00007517          	auipc	a0,0x7
    800015ec:	c4050513          	addi	a0,a0,-960 # 80008228 <etext+0x228>
    800015f0:	00004097          	auipc	ra,0x4
    800015f4:	658080e7          	jalr	1624(ra) # 80005c48 <panic>

00000000800015f8 <yield>:
{
    800015f8:	1101                	addi	sp,sp,-32
    800015fa:	ec06                	sd	ra,24(sp)
    800015fc:	e822                	sd	s0,16(sp)
    800015fe:	e426                	sd	s1,8(sp)
    80001600:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001602:	00000097          	auipc	ra,0x0
    80001606:	976080e7          	jalr	-1674(ra) # 80000f78 <myproc>
    8000160a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000160c:	00005097          	auipc	ra,0x5
    80001610:	bf2080e7          	jalr	-1038(ra) # 800061fe <acquire>
  p->state = RUNNABLE;
    80001614:	478d                	li	a5,3
    80001616:	cc9c                	sw	a5,24(s1)
  sched();
    80001618:	00000097          	auipc	ra,0x0
    8000161c:	f0a080e7          	jalr	-246(ra) # 80001522 <sched>
  release(&p->lock);
    80001620:	8526                	mv	a0,s1
    80001622:	00005097          	auipc	ra,0x5
    80001626:	c90080e7          	jalr	-880(ra) # 800062b2 <release>
}
    8000162a:	60e2                	ld	ra,24(sp)
    8000162c:	6442                	ld	s0,16(sp)
    8000162e:	64a2                	ld	s1,8(sp)
    80001630:	6105                	addi	sp,sp,32
    80001632:	8082                	ret

0000000080001634 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001634:	7179                	addi	sp,sp,-48
    80001636:	f406                	sd	ra,40(sp)
    80001638:	f022                	sd	s0,32(sp)
    8000163a:	ec26                	sd	s1,24(sp)
    8000163c:	e84a                	sd	s2,16(sp)
    8000163e:	e44e                	sd	s3,8(sp)
    80001640:	1800                	addi	s0,sp,48
    80001642:	89aa                	mv	s3,a0
    80001644:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001646:	00000097          	auipc	ra,0x0
    8000164a:	932080e7          	jalr	-1742(ra) # 80000f78 <myproc>
    8000164e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001650:	00005097          	auipc	ra,0x5
    80001654:	bae080e7          	jalr	-1106(ra) # 800061fe <acquire>
  release(lk);
    80001658:	854a                	mv	a0,s2
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	c58080e7          	jalr	-936(ra) # 800062b2 <release>

  // Go to sleep.
  p->chan = chan;
    80001662:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001666:	4789                	li	a5,2
    80001668:	cc9c                	sw	a5,24(s1)

  sched();
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	eb8080e7          	jalr	-328(ra) # 80001522 <sched>

  // Tidy up.
  p->chan = 0;
    80001672:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	c3a080e7          	jalr	-966(ra) # 800062b2 <release>
  acquire(lk);
    80001680:	854a                	mv	a0,s2
    80001682:	00005097          	auipc	ra,0x5
    80001686:	b7c080e7          	jalr	-1156(ra) # 800061fe <acquire>
}
    8000168a:	70a2                	ld	ra,40(sp)
    8000168c:	7402                	ld	s0,32(sp)
    8000168e:	64e2                	ld	s1,24(sp)
    80001690:	6942                	ld	s2,16(sp)
    80001692:	69a2                	ld	s3,8(sp)
    80001694:	6145                	addi	sp,sp,48
    80001696:	8082                	ret

0000000080001698 <wait>:
{
    80001698:	715d                	addi	sp,sp,-80
    8000169a:	e486                	sd	ra,72(sp)
    8000169c:	e0a2                	sd	s0,64(sp)
    8000169e:	fc26                	sd	s1,56(sp)
    800016a0:	f84a                	sd	s2,48(sp)
    800016a2:	f44e                	sd	s3,40(sp)
    800016a4:	f052                	sd	s4,32(sp)
    800016a6:	ec56                	sd	s5,24(sp)
    800016a8:	e85a                	sd	s6,16(sp)
    800016aa:	e45e                	sd	s7,8(sp)
    800016ac:	e062                	sd	s8,0(sp)
    800016ae:	0880                	addi	s0,sp,80
    800016b0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	8c6080e7          	jalr	-1850(ra) # 80000f78 <myproc>
    800016ba:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016bc:	00008517          	auipc	a0,0x8
    800016c0:	9ac50513          	addi	a0,a0,-1620 # 80009068 <wait_lock>
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	b3a080e7          	jalr	-1222(ra) # 800061fe <acquire>
    havekids = 0;
    800016cc:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016ce:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800016d0:	0000e997          	auipc	s3,0xe
    800016d4:	9b098993          	addi	s3,s3,-1616 # 8000f080 <tickslock>
        havekids = 1;
    800016d8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016da:	00008c17          	auipc	s8,0x8
    800016de:	98ec0c13          	addi	s8,s8,-1650 # 80009068 <wait_lock>
    havekids = 0;
    800016e2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016e4:	00008497          	auipc	s1,0x8
    800016e8:	d9c48493          	addi	s1,s1,-612 # 80009480 <proc>
    800016ec:	a0bd                	j	8000175a <wait+0xc2>
          pid = np->pid;
    800016ee:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800016f2:	000b0e63          	beqz	s6,8000170e <wait+0x76>
    800016f6:	4691                	li	a3,4
    800016f8:	02c48613          	addi	a2,s1,44
    800016fc:	85da                	mv	a1,s6
    800016fe:	05093503          	ld	a0,80(s2)
    80001702:	fffff097          	auipc	ra,0xfffff
    80001706:	408080e7          	jalr	1032(ra) # 80000b0a <copyout>
    8000170a:	02054563          	bltz	a0,80001734 <wait+0x9c>
          freeproc(np);
    8000170e:	8526                	mv	a0,s1
    80001710:	00000097          	auipc	ra,0x0
    80001714:	a1a080e7          	jalr	-1510(ra) # 8000112a <freeproc>
          release(&np->lock);
    80001718:	8526                	mv	a0,s1
    8000171a:	00005097          	auipc	ra,0x5
    8000171e:	b98080e7          	jalr	-1128(ra) # 800062b2 <release>
          release(&wait_lock);
    80001722:	00008517          	auipc	a0,0x8
    80001726:	94650513          	addi	a0,a0,-1722 # 80009068 <wait_lock>
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	b88080e7          	jalr	-1144(ra) # 800062b2 <release>
          return pid;
    80001732:	a09d                	j	80001798 <wait+0x100>
            release(&np->lock);
    80001734:	8526                	mv	a0,s1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	b7c080e7          	jalr	-1156(ra) # 800062b2 <release>
            release(&wait_lock);
    8000173e:	00008517          	auipc	a0,0x8
    80001742:	92a50513          	addi	a0,a0,-1750 # 80009068 <wait_lock>
    80001746:	00005097          	auipc	ra,0x5
    8000174a:	b6c080e7          	jalr	-1172(ra) # 800062b2 <release>
            return -1;
    8000174e:	59fd                	li	s3,-1
    80001750:	a0a1                	j	80001798 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001752:	17048493          	addi	s1,s1,368
    80001756:	03348463          	beq	s1,s3,8000177e <wait+0xe6>
      if(np->parent == p){
    8000175a:	7c9c                	ld	a5,56(s1)
    8000175c:	ff279be3          	bne	a5,s2,80001752 <wait+0xba>
        acquire(&np->lock);
    80001760:	8526                	mv	a0,s1
    80001762:	00005097          	auipc	ra,0x5
    80001766:	a9c080e7          	jalr	-1380(ra) # 800061fe <acquire>
        if(np->state == ZOMBIE){
    8000176a:	4c9c                	lw	a5,24(s1)
    8000176c:	f94781e3          	beq	a5,s4,800016ee <wait+0x56>
        release(&np->lock);
    80001770:	8526                	mv	a0,s1
    80001772:	00005097          	auipc	ra,0x5
    80001776:	b40080e7          	jalr	-1216(ra) # 800062b2 <release>
        havekids = 1;
    8000177a:	8756                	mv	a4,s5
    8000177c:	bfd9                	j	80001752 <wait+0xba>
    if(!havekids || p->killed){
    8000177e:	c701                	beqz	a4,80001786 <wait+0xee>
    80001780:	02892783          	lw	a5,40(s2)
    80001784:	c79d                	beqz	a5,800017b2 <wait+0x11a>
      release(&wait_lock);
    80001786:	00008517          	auipc	a0,0x8
    8000178a:	8e250513          	addi	a0,a0,-1822 # 80009068 <wait_lock>
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	b24080e7          	jalr	-1244(ra) # 800062b2 <release>
      return -1;
    80001796:	59fd                	li	s3,-1
}
    80001798:	854e                	mv	a0,s3
    8000179a:	60a6                	ld	ra,72(sp)
    8000179c:	6406                	ld	s0,64(sp)
    8000179e:	74e2                	ld	s1,56(sp)
    800017a0:	7942                	ld	s2,48(sp)
    800017a2:	79a2                	ld	s3,40(sp)
    800017a4:	7a02                	ld	s4,32(sp)
    800017a6:	6ae2                	ld	s5,24(sp)
    800017a8:	6b42                	ld	s6,16(sp)
    800017aa:	6ba2                	ld	s7,8(sp)
    800017ac:	6c02                	ld	s8,0(sp)
    800017ae:	6161                	addi	sp,sp,80
    800017b0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017b2:	85e2                	mv	a1,s8
    800017b4:	854a                	mv	a0,s2
    800017b6:	00000097          	auipc	ra,0x0
    800017ba:	e7e080e7          	jalr	-386(ra) # 80001634 <sleep>
    havekids = 0;
    800017be:	b715                	j	800016e2 <wait+0x4a>

00000000800017c0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017c0:	7139                	addi	sp,sp,-64
    800017c2:	fc06                	sd	ra,56(sp)
    800017c4:	f822                	sd	s0,48(sp)
    800017c6:	f426                	sd	s1,40(sp)
    800017c8:	f04a                	sd	s2,32(sp)
    800017ca:	ec4e                	sd	s3,24(sp)
    800017cc:	e852                	sd	s4,16(sp)
    800017ce:	e456                	sd	s5,8(sp)
    800017d0:	0080                	addi	s0,sp,64
    800017d2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017d4:	00008497          	auipc	s1,0x8
    800017d8:	cac48493          	addi	s1,s1,-852 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017dc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017de:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e0:	0000e917          	auipc	s2,0xe
    800017e4:	8a090913          	addi	s2,s2,-1888 # 8000f080 <tickslock>
    800017e8:	a821                	j	80001800 <wakeup+0x40>
        p->state = RUNNABLE;
    800017ea:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	ac2080e7          	jalr	-1342(ra) # 800062b2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f8:	17048493          	addi	s1,s1,368
    800017fc:	03248463          	beq	s1,s2,80001824 <wakeup+0x64>
    if(p != myproc()){
    80001800:	fffff097          	auipc	ra,0xfffff
    80001804:	778080e7          	jalr	1912(ra) # 80000f78 <myproc>
    80001808:	fea488e3          	beq	s1,a0,800017f8 <wakeup+0x38>
      acquire(&p->lock);
    8000180c:	8526                	mv	a0,s1
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	9f0080e7          	jalr	-1552(ra) # 800061fe <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001816:	4c9c                	lw	a5,24(s1)
    80001818:	fd379be3          	bne	a5,s3,800017ee <wakeup+0x2e>
    8000181c:	709c                	ld	a5,32(s1)
    8000181e:	fd4798e3          	bne	a5,s4,800017ee <wakeup+0x2e>
    80001822:	b7e1                	j	800017ea <wakeup+0x2a>
    }
  }
}
    80001824:	70e2                	ld	ra,56(sp)
    80001826:	7442                	ld	s0,48(sp)
    80001828:	74a2                	ld	s1,40(sp)
    8000182a:	7902                	ld	s2,32(sp)
    8000182c:	69e2                	ld	s3,24(sp)
    8000182e:	6a42                	ld	s4,16(sp)
    80001830:	6aa2                	ld	s5,8(sp)
    80001832:	6121                	addi	sp,sp,64
    80001834:	8082                	ret

0000000080001836 <reparent>:
{
    80001836:	7179                	addi	sp,sp,-48
    80001838:	f406                	sd	ra,40(sp)
    8000183a:	f022                	sd	s0,32(sp)
    8000183c:	ec26                	sd	s1,24(sp)
    8000183e:	e84a                	sd	s2,16(sp)
    80001840:	e44e                	sd	s3,8(sp)
    80001842:	e052                	sd	s4,0(sp)
    80001844:	1800                	addi	s0,sp,48
    80001846:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001848:	00008497          	auipc	s1,0x8
    8000184c:	c3848493          	addi	s1,s1,-968 # 80009480 <proc>
      pp->parent = initproc;
    80001850:	00007a17          	auipc	s4,0x7
    80001854:	7c0a0a13          	addi	s4,s4,1984 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001858:	0000e997          	auipc	s3,0xe
    8000185c:	82898993          	addi	s3,s3,-2008 # 8000f080 <tickslock>
    80001860:	a029                	j	8000186a <reparent+0x34>
    80001862:	17048493          	addi	s1,s1,368
    80001866:	01348d63          	beq	s1,s3,80001880 <reparent+0x4a>
    if(pp->parent == p){
    8000186a:	7c9c                	ld	a5,56(s1)
    8000186c:	ff279be3          	bne	a5,s2,80001862 <reparent+0x2c>
      pp->parent = initproc;
    80001870:	000a3503          	ld	a0,0(s4)
    80001874:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001876:	00000097          	auipc	ra,0x0
    8000187a:	f4a080e7          	jalr	-182(ra) # 800017c0 <wakeup>
    8000187e:	b7d5                	j	80001862 <reparent+0x2c>
}
    80001880:	70a2                	ld	ra,40(sp)
    80001882:	7402                	ld	s0,32(sp)
    80001884:	64e2                	ld	s1,24(sp)
    80001886:	6942                	ld	s2,16(sp)
    80001888:	69a2                	ld	s3,8(sp)
    8000188a:	6a02                	ld	s4,0(sp)
    8000188c:	6145                	addi	sp,sp,48
    8000188e:	8082                	ret

0000000080001890 <exit>:
{
    80001890:	7179                	addi	sp,sp,-48
    80001892:	f406                	sd	ra,40(sp)
    80001894:	f022                	sd	s0,32(sp)
    80001896:	ec26                	sd	s1,24(sp)
    80001898:	e84a                	sd	s2,16(sp)
    8000189a:	e44e                	sd	s3,8(sp)
    8000189c:	e052                	sd	s4,0(sp)
    8000189e:	1800                	addi	s0,sp,48
    800018a0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018a2:	fffff097          	auipc	ra,0xfffff
    800018a6:	6d6080e7          	jalr	1750(ra) # 80000f78 <myproc>
    800018aa:	89aa                	mv	s3,a0
  if(p == initproc)
    800018ac:	00007797          	auipc	a5,0x7
    800018b0:	7647b783          	ld	a5,1892(a5) # 80009010 <initproc>
    800018b4:	0d850493          	addi	s1,a0,216
    800018b8:	15850913          	addi	s2,a0,344
    800018bc:	02a79363          	bne	a5,a0,800018e2 <exit+0x52>
    panic("init exiting");
    800018c0:	00007517          	auipc	a0,0x7
    800018c4:	98050513          	addi	a0,a0,-1664 # 80008240 <etext+0x240>
    800018c8:	00004097          	auipc	ra,0x4
    800018cc:	380080e7          	jalr	896(ra) # 80005c48 <panic>
      fileclose(f);
    800018d0:	00002097          	auipc	ra,0x2
    800018d4:	16c080e7          	jalr	364(ra) # 80003a3c <fileclose>
      p->ofile[fd] = 0;
    800018d8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018dc:	04a1                	addi	s1,s1,8
    800018de:	01248563          	beq	s1,s2,800018e8 <exit+0x58>
    if(p->ofile[fd]){
    800018e2:	6088                	ld	a0,0(s1)
    800018e4:	f575                	bnez	a0,800018d0 <exit+0x40>
    800018e6:	bfdd                	j	800018dc <exit+0x4c>
  begin_op();
    800018e8:	00002097          	auipc	ra,0x2
    800018ec:	c88080e7          	jalr	-888(ra) # 80003570 <begin_op>
  iput(p->cwd);
    800018f0:	1589b503          	ld	a0,344(s3)
    800018f4:	00001097          	auipc	ra,0x1
    800018f8:	464080e7          	jalr	1124(ra) # 80002d58 <iput>
  end_op();
    800018fc:	00002097          	auipc	ra,0x2
    80001900:	cf4080e7          	jalr	-780(ra) # 800035f0 <end_op>
  p->cwd = 0;
    80001904:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001908:	00007497          	auipc	s1,0x7
    8000190c:	76048493          	addi	s1,s1,1888 # 80009068 <wait_lock>
    80001910:	8526                	mv	a0,s1
    80001912:	00005097          	auipc	ra,0x5
    80001916:	8ec080e7          	jalr	-1812(ra) # 800061fe <acquire>
  reparent(p);
    8000191a:	854e                	mv	a0,s3
    8000191c:	00000097          	auipc	ra,0x0
    80001920:	f1a080e7          	jalr	-230(ra) # 80001836 <reparent>
  wakeup(p->parent);
    80001924:	0389b503          	ld	a0,56(s3)
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	e98080e7          	jalr	-360(ra) # 800017c0 <wakeup>
  acquire(&p->lock);
    80001930:	854e                	mv	a0,s3
    80001932:	00005097          	auipc	ra,0x5
    80001936:	8cc080e7          	jalr	-1844(ra) # 800061fe <acquire>
  p->xstate = status;
    8000193a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000193e:	4795                	li	a5,5
    80001940:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001944:	8526                	mv	a0,s1
    80001946:	00005097          	auipc	ra,0x5
    8000194a:	96c080e7          	jalr	-1684(ra) # 800062b2 <release>
  sched();
    8000194e:	00000097          	auipc	ra,0x0
    80001952:	bd4080e7          	jalr	-1068(ra) # 80001522 <sched>
  panic("zombie exit");
    80001956:	00007517          	auipc	a0,0x7
    8000195a:	8fa50513          	addi	a0,a0,-1798 # 80008250 <etext+0x250>
    8000195e:	00004097          	auipc	ra,0x4
    80001962:	2ea080e7          	jalr	746(ra) # 80005c48 <panic>

0000000080001966 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001966:	7179                	addi	sp,sp,-48
    80001968:	f406                	sd	ra,40(sp)
    8000196a:	f022                	sd	s0,32(sp)
    8000196c:	ec26                	sd	s1,24(sp)
    8000196e:	e84a                	sd	s2,16(sp)
    80001970:	e44e                	sd	s3,8(sp)
    80001972:	1800                	addi	s0,sp,48
    80001974:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001976:	00008497          	auipc	s1,0x8
    8000197a:	b0a48493          	addi	s1,s1,-1270 # 80009480 <proc>
    8000197e:	0000d997          	auipc	s3,0xd
    80001982:	70298993          	addi	s3,s3,1794 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001986:	8526                	mv	a0,s1
    80001988:	00005097          	auipc	ra,0x5
    8000198c:	876080e7          	jalr	-1930(ra) # 800061fe <acquire>
    if(p->pid == pid){
    80001990:	589c                	lw	a5,48(s1)
    80001992:	01278d63          	beq	a5,s2,800019ac <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001996:	8526                	mv	a0,s1
    80001998:	00005097          	auipc	ra,0x5
    8000199c:	91a080e7          	jalr	-1766(ra) # 800062b2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019a0:	17048493          	addi	s1,s1,368
    800019a4:	ff3491e3          	bne	s1,s3,80001986 <kill+0x20>
  }
  return -1;
    800019a8:	557d                	li	a0,-1
    800019aa:	a829                	j	800019c4 <kill+0x5e>
      p->killed = 1;
    800019ac:	4785                	li	a5,1
    800019ae:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019b0:	4c98                	lw	a4,24(s1)
    800019b2:	4789                	li	a5,2
    800019b4:	00f70f63          	beq	a4,a5,800019d2 <kill+0x6c>
      release(&p->lock);
    800019b8:	8526                	mv	a0,s1
    800019ba:	00005097          	auipc	ra,0x5
    800019be:	8f8080e7          	jalr	-1800(ra) # 800062b2 <release>
      return 0;
    800019c2:	4501                	li	a0,0
}
    800019c4:	70a2                	ld	ra,40(sp)
    800019c6:	7402                	ld	s0,32(sp)
    800019c8:	64e2                	ld	s1,24(sp)
    800019ca:	6942                	ld	s2,16(sp)
    800019cc:	69a2                	ld	s3,8(sp)
    800019ce:	6145                	addi	sp,sp,48
    800019d0:	8082                	ret
        p->state = RUNNABLE;
    800019d2:	478d                	li	a5,3
    800019d4:	cc9c                	sw	a5,24(s1)
    800019d6:	b7cd                	j	800019b8 <kill+0x52>

00000000800019d8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019d8:	7179                	addi	sp,sp,-48
    800019da:	f406                	sd	ra,40(sp)
    800019dc:	f022                	sd	s0,32(sp)
    800019de:	ec26                	sd	s1,24(sp)
    800019e0:	e84a                	sd	s2,16(sp)
    800019e2:	e44e                	sd	s3,8(sp)
    800019e4:	e052                	sd	s4,0(sp)
    800019e6:	1800                	addi	s0,sp,48
    800019e8:	84aa                	mv	s1,a0
    800019ea:	892e                	mv	s2,a1
    800019ec:	89b2                	mv	s3,a2
    800019ee:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	588080e7          	jalr	1416(ra) # 80000f78 <myproc>
  if(user_dst){
    800019f8:	c08d                	beqz	s1,80001a1a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019fa:	86d2                	mv	a3,s4
    800019fc:	864e                	mv	a2,s3
    800019fe:	85ca                	mv	a1,s2
    80001a00:	6928                	ld	a0,80(a0)
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	108080e7          	jalr	264(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a0a:	70a2                	ld	ra,40(sp)
    80001a0c:	7402                	ld	s0,32(sp)
    80001a0e:	64e2                	ld	s1,24(sp)
    80001a10:	6942                	ld	s2,16(sp)
    80001a12:	69a2                	ld	s3,8(sp)
    80001a14:	6a02                	ld	s4,0(sp)
    80001a16:	6145                	addi	sp,sp,48
    80001a18:	8082                	ret
    memmove((char *)dst, src, len);
    80001a1a:	000a061b          	sext.w	a2,s4
    80001a1e:	85ce                	mv	a1,s3
    80001a20:	854a                	mv	a0,s2
    80001a22:	ffffe097          	auipc	ra,0xffffe
    80001a26:	7b6080e7          	jalr	1974(ra) # 800001d8 <memmove>
    return 0;
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	bff9                	j	80001a0a <either_copyout+0x32>

0000000080001a2e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a2e:	7179                	addi	sp,sp,-48
    80001a30:	f406                	sd	ra,40(sp)
    80001a32:	f022                	sd	s0,32(sp)
    80001a34:	ec26                	sd	s1,24(sp)
    80001a36:	e84a                	sd	s2,16(sp)
    80001a38:	e44e                	sd	s3,8(sp)
    80001a3a:	e052                	sd	s4,0(sp)
    80001a3c:	1800                	addi	s0,sp,48
    80001a3e:	892a                	mv	s2,a0
    80001a40:	84ae                	mv	s1,a1
    80001a42:	89b2                	mv	s3,a2
    80001a44:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a46:	fffff097          	auipc	ra,0xfffff
    80001a4a:	532080e7          	jalr	1330(ra) # 80000f78 <myproc>
  if(user_src){
    80001a4e:	c08d                	beqz	s1,80001a70 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a50:	86d2                	mv	a3,s4
    80001a52:	864e                	mv	a2,s3
    80001a54:	85ca                	mv	a1,s2
    80001a56:	6928                	ld	a0,80(a0)
    80001a58:	fffff097          	auipc	ra,0xfffff
    80001a5c:	13e080e7          	jalr	318(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a60:	70a2                	ld	ra,40(sp)
    80001a62:	7402                	ld	s0,32(sp)
    80001a64:	64e2                	ld	s1,24(sp)
    80001a66:	6942                	ld	s2,16(sp)
    80001a68:	69a2                	ld	s3,8(sp)
    80001a6a:	6a02                	ld	s4,0(sp)
    80001a6c:	6145                	addi	sp,sp,48
    80001a6e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a70:	000a061b          	sext.w	a2,s4
    80001a74:	85ce                	mv	a1,s3
    80001a76:	854a                	mv	a0,s2
    80001a78:	ffffe097          	auipc	ra,0xffffe
    80001a7c:	760080e7          	jalr	1888(ra) # 800001d8 <memmove>
    return 0;
    80001a80:	8526                	mv	a0,s1
    80001a82:	bff9                	j	80001a60 <either_copyin+0x32>

0000000080001a84 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a84:	715d                	addi	sp,sp,-80
    80001a86:	e486                	sd	ra,72(sp)
    80001a88:	e0a2                	sd	s0,64(sp)
    80001a8a:	fc26                	sd	s1,56(sp)
    80001a8c:	f84a                	sd	s2,48(sp)
    80001a8e:	f44e                	sd	s3,40(sp)
    80001a90:	f052                	sd	s4,32(sp)
    80001a92:	ec56                	sd	s5,24(sp)
    80001a94:	e85a                	sd	s6,16(sp)
    80001a96:	e45e                	sd	s7,8(sp)
    80001a98:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a9a:	00006517          	auipc	a0,0x6
    80001a9e:	5ae50513          	addi	a0,a0,1454 # 80008048 <etext+0x48>
    80001aa2:	00004097          	auipc	ra,0x4
    80001aa6:	1f0080e7          	jalr	496(ra) # 80005c92 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aaa:	00008497          	auipc	s1,0x8
    80001aae:	b3648493          	addi	s1,s1,-1226 # 800095e0 <proc+0x160>
    80001ab2:	0000d917          	auipc	s2,0xd
    80001ab6:	72e90913          	addi	s2,s2,1838 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aba:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001abc:	00006997          	auipc	s3,0x6
    80001ac0:	7a498993          	addi	s3,s3,1956 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac4:	00006a97          	auipc	s5,0x6
    80001ac8:	7a4a8a93          	addi	s5,s5,1956 # 80008268 <etext+0x268>
    printf("\n");
    80001acc:	00006a17          	auipc	s4,0x6
    80001ad0:	57ca0a13          	addi	s4,s4,1404 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ad4:	00006b97          	auipc	s7,0x6
    80001ad8:	7ccb8b93          	addi	s7,s7,1996 # 800082a0 <states.1722>
    80001adc:	a00d                	j	80001afe <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ade:	ed06a583          	lw	a1,-304(a3)
    80001ae2:	8556                	mv	a0,s5
    80001ae4:	00004097          	auipc	ra,0x4
    80001ae8:	1ae080e7          	jalr	430(ra) # 80005c92 <printf>
    printf("\n");
    80001aec:	8552                	mv	a0,s4
    80001aee:	00004097          	auipc	ra,0x4
    80001af2:	1a4080e7          	jalr	420(ra) # 80005c92 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001af6:	17048493          	addi	s1,s1,368
    80001afa:	03248163          	beq	s1,s2,80001b1c <procdump+0x98>
    if(p->state == UNUSED)
    80001afe:	86a6                	mv	a3,s1
    80001b00:	eb84a783          	lw	a5,-328(s1)
    80001b04:	dbed                	beqz	a5,80001af6 <procdump+0x72>
      state = "???";
    80001b06:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b08:	fcfb6be3          	bltu	s6,a5,80001ade <procdump+0x5a>
    80001b0c:	1782                	slli	a5,a5,0x20
    80001b0e:	9381                	srli	a5,a5,0x20
    80001b10:	078e                	slli	a5,a5,0x3
    80001b12:	97de                	add	a5,a5,s7
    80001b14:	6390                	ld	a2,0(a5)
    80001b16:	f661                	bnez	a2,80001ade <procdump+0x5a>
      state = "???";
    80001b18:	864e                	mv	a2,s3
    80001b1a:	b7d1                	j	80001ade <procdump+0x5a>
  }
}
    80001b1c:	60a6                	ld	ra,72(sp)
    80001b1e:	6406                	ld	s0,64(sp)
    80001b20:	74e2                	ld	s1,56(sp)
    80001b22:	7942                	ld	s2,48(sp)
    80001b24:	79a2                	ld	s3,40(sp)
    80001b26:	7a02                	ld	s4,32(sp)
    80001b28:	6ae2                	ld	s5,24(sp)
    80001b2a:	6b42                	ld	s6,16(sp)
    80001b2c:	6ba2                	ld	s7,8(sp)
    80001b2e:	6161                	addi	sp,sp,80
    80001b30:	8082                	ret

0000000080001b32 <swtch>:
    80001b32:	00153023          	sd	ra,0(a0)
    80001b36:	00253423          	sd	sp,8(a0)
    80001b3a:	e900                	sd	s0,16(a0)
    80001b3c:	ed04                	sd	s1,24(a0)
    80001b3e:	03253023          	sd	s2,32(a0)
    80001b42:	03353423          	sd	s3,40(a0)
    80001b46:	03453823          	sd	s4,48(a0)
    80001b4a:	03553c23          	sd	s5,56(a0)
    80001b4e:	05653023          	sd	s6,64(a0)
    80001b52:	05753423          	sd	s7,72(a0)
    80001b56:	05853823          	sd	s8,80(a0)
    80001b5a:	05953c23          	sd	s9,88(a0)
    80001b5e:	07a53023          	sd	s10,96(a0)
    80001b62:	07b53423          	sd	s11,104(a0)
    80001b66:	0005b083          	ld	ra,0(a1)
    80001b6a:	0085b103          	ld	sp,8(a1)
    80001b6e:	6980                	ld	s0,16(a1)
    80001b70:	6d84                	ld	s1,24(a1)
    80001b72:	0205b903          	ld	s2,32(a1)
    80001b76:	0285b983          	ld	s3,40(a1)
    80001b7a:	0305ba03          	ld	s4,48(a1)
    80001b7e:	0385ba83          	ld	s5,56(a1)
    80001b82:	0405bb03          	ld	s6,64(a1)
    80001b86:	0485bb83          	ld	s7,72(a1)
    80001b8a:	0505bc03          	ld	s8,80(a1)
    80001b8e:	0585bc83          	ld	s9,88(a1)
    80001b92:	0605bd03          	ld	s10,96(a1)
    80001b96:	0685bd83          	ld	s11,104(a1)
    80001b9a:	8082                	ret

0000000080001b9c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b9c:	1141                	addi	sp,sp,-16
    80001b9e:	e406                	sd	ra,8(sp)
    80001ba0:	e022                	sd	s0,0(sp)
    80001ba2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ba4:	00006597          	auipc	a1,0x6
    80001ba8:	72c58593          	addi	a1,a1,1836 # 800082d0 <states.1722+0x30>
    80001bac:	0000d517          	auipc	a0,0xd
    80001bb0:	4d450513          	addi	a0,a0,1236 # 8000f080 <tickslock>
    80001bb4:	00004097          	auipc	ra,0x4
    80001bb8:	5ba080e7          	jalr	1466(ra) # 8000616e <initlock>
}
    80001bbc:	60a2                	ld	ra,8(sp)
    80001bbe:	6402                	ld	s0,0(sp)
    80001bc0:	0141                	addi	sp,sp,16
    80001bc2:	8082                	ret

0000000080001bc4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bc4:	1141                	addi	sp,sp,-16
    80001bc6:	e422                	sd	s0,8(sp)
    80001bc8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bca:	00003797          	auipc	a5,0x3
    80001bce:	48678793          	addi	a5,a5,1158 # 80005050 <kernelvec>
    80001bd2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bd6:	6422                	ld	s0,8(sp)
    80001bd8:	0141                	addi	sp,sp,16
    80001bda:	8082                	ret

0000000080001bdc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bdc:	1141                	addi	sp,sp,-16
    80001bde:	e406                	sd	ra,8(sp)
    80001be0:	e022                	sd	s0,0(sp)
    80001be2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001be4:	fffff097          	auipc	ra,0xfffff
    80001be8:	394080e7          	jalr	916(ra) # 80000f78 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bf0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bf2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bf6:	00005617          	auipc	a2,0x5
    80001bfa:	40a60613          	addi	a2,a2,1034 # 80007000 <_trampoline>
    80001bfe:	00005697          	auipc	a3,0x5
    80001c02:	40268693          	addi	a3,a3,1026 # 80007000 <_trampoline>
    80001c06:	8e91                	sub	a3,a3,a2
    80001c08:	040007b7          	lui	a5,0x4000
    80001c0c:	17fd                	addi	a5,a5,-1
    80001c0e:	07b2                	slli	a5,a5,0xc
    80001c10:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c12:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c16:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c18:	180026f3          	csrr	a3,satp
    80001c1c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c1e:	7138                	ld	a4,96(a0)
    80001c20:	6134                	ld	a3,64(a0)
    80001c22:	6585                	lui	a1,0x1
    80001c24:	96ae                	add	a3,a3,a1
    80001c26:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c28:	7138                	ld	a4,96(a0)
    80001c2a:	00000697          	auipc	a3,0x0
    80001c2e:	13868693          	addi	a3,a3,312 # 80001d62 <usertrap>
    80001c32:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c34:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c36:	8692                	mv	a3,tp
    80001c38:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c3e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c42:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c46:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c4a:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c4c:	6f18                	ld	a4,24(a4)
    80001c4e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c52:	692c                	ld	a1,80(a0)
    80001c54:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c56:	00005717          	auipc	a4,0x5
    80001c5a:	43a70713          	addi	a4,a4,1082 # 80007090 <userret>
    80001c5e:	8f11                	sub	a4,a4,a2
    80001c60:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c62:	577d                	li	a4,-1
    80001c64:	177e                	slli	a4,a4,0x3f
    80001c66:	8dd9                	or	a1,a1,a4
    80001c68:	02000537          	lui	a0,0x2000
    80001c6c:	157d                	addi	a0,a0,-1
    80001c6e:	0536                	slli	a0,a0,0xd
    80001c70:	9782                	jalr	a5
}
    80001c72:	60a2                	ld	ra,8(sp)
    80001c74:	6402                	ld	s0,0(sp)
    80001c76:	0141                	addi	sp,sp,16
    80001c78:	8082                	ret

0000000080001c7a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c7a:	1101                	addi	sp,sp,-32
    80001c7c:	ec06                	sd	ra,24(sp)
    80001c7e:	e822                	sd	s0,16(sp)
    80001c80:	e426                	sd	s1,8(sp)
    80001c82:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c84:	0000d497          	auipc	s1,0xd
    80001c88:	3fc48493          	addi	s1,s1,1020 # 8000f080 <tickslock>
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00004097          	auipc	ra,0x4
    80001c92:	570080e7          	jalr	1392(ra) # 800061fe <acquire>
  ticks++;
    80001c96:	00007517          	auipc	a0,0x7
    80001c9a:	38250513          	addi	a0,a0,898 # 80009018 <ticks>
    80001c9e:	411c                	lw	a5,0(a0)
    80001ca0:	2785                	addiw	a5,a5,1
    80001ca2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	b1c080e7          	jalr	-1252(ra) # 800017c0 <wakeup>
  release(&tickslock);
    80001cac:	8526                	mv	a0,s1
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	604080e7          	jalr	1540(ra) # 800062b2 <release>
}
    80001cb6:	60e2                	ld	ra,24(sp)
    80001cb8:	6442                	ld	s0,16(sp)
    80001cba:	64a2                	ld	s1,8(sp)
    80001cbc:	6105                	addi	sp,sp,32
    80001cbe:	8082                	ret

0000000080001cc0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cc0:	1101                	addi	sp,sp,-32
    80001cc2:	ec06                	sd	ra,24(sp)
    80001cc4:	e822                	sd	s0,16(sp)
    80001cc6:	e426                	sd	s1,8(sp)
    80001cc8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cca:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cce:	00074d63          	bltz	a4,80001ce8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cd2:	57fd                	li	a5,-1
    80001cd4:	17fe                	slli	a5,a5,0x3f
    80001cd6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cd8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cda:	06f70363          	beq	a4,a5,80001d40 <devintr+0x80>
  }
}
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret
     (scause & 0xff) == 9){
    80001ce8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cec:	46a5                	li	a3,9
    80001cee:	fed792e3          	bne	a5,a3,80001cd2 <devintr+0x12>
    int irq = plic_claim();
    80001cf2:	00003097          	auipc	ra,0x3
    80001cf6:	466080e7          	jalr	1126(ra) # 80005158 <plic_claim>
    80001cfa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cfc:	47a9                	li	a5,10
    80001cfe:	02f50763          	beq	a0,a5,80001d2c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d02:	4785                	li	a5,1
    80001d04:	02f50963          	beq	a0,a5,80001d36 <devintr+0x76>
    return 1;
    80001d08:	4505                	li	a0,1
    } else if(irq){
    80001d0a:	d8f1                	beqz	s1,80001cde <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d0c:	85a6                	mv	a1,s1
    80001d0e:	00006517          	auipc	a0,0x6
    80001d12:	5ca50513          	addi	a0,a0,1482 # 800082d8 <states.1722+0x38>
    80001d16:	00004097          	auipc	ra,0x4
    80001d1a:	f7c080e7          	jalr	-132(ra) # 80005c92 <printf>
      plic_complete(irq);
    80001d1e:	8526                	mv	a0,s1
    80001d20:	00003097          	auipc	ra,0x3
    80001d24:	45c080e7          	jalr	1116(ra) # 8000517c <plic_complete>
    return 1;
    80001d28:	4505                	li	a0,1
    80001d2a:	bf55                	j	80001cde <devintr+0x1e>
      uartintr();
    80001d2c:	00004097          	auipc	ra,0x4
    80001d30:	3f2080e7          	jalr	1010(ra) # 8000611e <uartintr>
    80001d34:	b7ed                	j	80001d1e <devintr+0x5e>
      virtio_disk_intr();
    80001d36:	00004097          	auipc	ra,0x4
    80001d3a:	926080e7          	jalr	-1754(ra) # 8000565c <virtio_disk_intr>
    80001d3e:	b7c5                	j	80001d1e <devintr+0x5e>
    if(cpuid() == 0){
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	20c080e7          	jalr	524(ra) # 80000f4c <cpuid>
    80001d48:	c901                	beqz	a0,80001d58 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d4a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d4e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d50:	14479073          	csrw	sip,a5
    return 2;
    80001d54:	4509                	li	a0,2
    80001d56:	b761                	j	80001cde <devintr+0x1e>
      clockintr();
    80001d58:	00000097          	auipc	ra,0x0
    80001d5c:	f22080e7          	jalr	-222(ra) # 80001c7a <clockintr>
    80001d60:	b7ed                	j	80001d4a <devintr+0x8a>

0000000080001d62 <usertrap>:
{
    80001d62:	1101                	addi	sp,sp,-32
    80001d64:	ec06                	sd	ra,24(sp)
    80001d66:	e822                	sd	s0,16(sp)
    80001d68:	e426                	sd	s1,8(sp)
    80001d6a:	e04a                	sd	s2,0(sp)
    80001d6c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d72:	1007f793          	andi	a5,a5,256
    80001d76:	e3ad                	bnez	a5,80001dd8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d78:	00003797          	auipc	a5,0x3
    80001d7c:	2d878793          	addi	a5,a5,728 # 80005050 <kernelvec>
    80001d80:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	1f4080e7          	jalr	500(ra) # 80000f78 <myproc>
    80001d8c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d8e:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d90:	14102773          	csrr	a4,sepc
    80001d94:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d96:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d9a:	47a1                	li	a5,8
    80001d9c:	04f71c63          	bne	a4,a5,80001df4 <usertrap+0x92>
    if(p->killed)
    80001da0:	551c                	lw	a5,40(a0)
    80001da2:	e3b9                	bnez	a5,80001de8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001da4:	70b8                	ld	a4,96(s1)
    80001da6:	6f1c                	ld	a5,24(a4)
    80001da8:	0791                	addi	a5,a5,4
    80001daa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001db0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db4:	10079073          	csrw	sstatus,a5
    syscall();
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	2e0080e7          	jalr	736(ra) # 80002098 <syscall>
  if(p->killed)
    80001dc0:	549c                	lw	a5,40(s1)
    80001dc2:	ebc1                	bnez	a5,80001e52 <usertrap+0xf0>
  usertrapret();
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	e18080e7          	jalr	-488(ra) # 80001bdc <usertrapret>
}
    80001dcc:	60e2                	ld	ra,24(sp)
    80001dce:	6442                	ld	s0,16(sp)
    80001dd0:	64a2                	ld	s1,8(sp)
    80001dd2:	6902                	ld	s2,0(sp)
    80001dd4:	6105                	addi	sp,sp,32
    80001dd6:	8082                	ret
    panic("usertrap: not from user mode");
    80001dd8:	00006517          	auipc	a0,0x6
    80001ddc:	52050513          	addi	a0,a0,1312 # 800082f8 <states.1722+0x58>
    80001de0:	00004097          	auipc	ra,0x4
    80001de4:	e68080e7          	jalr	-408(ra) # 80005c48 <panic>
      exit(-1);
    80001de8:	557d                	li	a0,-1
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	aa6080e7          	jalr	-1370(ra) # 80001890 <exit>
    80001df2:	bf4d                	j	80001da4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	ecc080e7          	jalr	-308(ra) # 80001cc0 <devintr>
    80001dfc:	892a                	mv	s2,a0
    80001dfe:	c501                	beqz	a0,80001e06 <usertrap+0xa4>
  if(p->killed)
    80001e00:	549c                	lw	a5,40(s1)
    80001e02:	c3a1                	beqz	a5,80001e42 <usertrap+0xe0>
    80001e04:	a815                	j	80001e38 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e06:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e0a:	5890                	lw	a2,48(s1)
    80001e0c:	00006517          	auipc	a0,0x6
    80001e10:	50c50513          	addi	a0,a0,1292 # 80008318 <states.1722+0x78>
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	e7e080e7          	jalr	-386(ra) # 80005c92 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e20:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	52450513          	addi	a0,a0,1316 # 80008348 <states.1722+0xa8>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	e66080e7          	jalr	-410(ra) # 80005c92 <printf>
    p->killed = 1;
    80001e34:	4785                	li	a5,1
    80001e36:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e38:	557d                	li	a0,-1
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	a56080e7          	jalr	-1450(ra) # 80001890 <exit>
  if(which_dev == 2)
    80001e42:	4789                	li	a5,2
    80001e44:	f8f910e3          	bne	s2,a5,80001dc4 <usertrap+0x62>
    yield();
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	7b0080e7          	jalr	1968(ra) # 800015f8 <yield>
    80001e50:	bf95                	j	80001dc4 <usertrap+0x62>
  int which_dev = 0;
    80001e52:	4901                	li	s2,0
    80001e54:	b7d5                	j	80001e38 <usertrap+0xd6>

0000000080001e56 <kerneltrap>:
{
    80001e56:	7179                	addi	sp,sp,-48
    80001e58:	f406                	sd	ra,40(sp)
    80001e5a:	f022                	sd	s0,32(sp)
    80001e5c:	ec26                	sd	s1,24(sp)
    80001e5e:	e84a                	sd	s2,16(sp)
    80001e60:	e44e                	sd	s3,8(sp)
    80001e62:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e64:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e68:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e70:	1004f793          	andi	a5,s1,256
    80001e74:	cb85                	beqz	a5,80001ea4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e76:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e7a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e7c:	ef85                	bnez	a5,80001eb4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e7e:	00000097          	auipc	ra,0x0
    80001e82:	e42080e7          	jalr	-446(ra) # 80001cc0 <devintr>
    80001e86:	cd1d                	beqz	a0,80001ec4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e88:	4789                	li	a5,2
    80001e8a:	06f50a63          	beq	a0,a5,80001efe <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e8e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e92:	10049073          	csrw	sstatus,s1
}
    80001e96:	70a2                	ld	ra,40(sp)
    80001e98:	7402                	ld	s0,32(sp)
    80001e9a:	64e2                	ld	s1,24(sp)
    80001e9c:	6942                	ld	s2,16(sp)
    80001e9e:	69a2                	ld	s3,8(sp)
    80001ea0:	6145                	addi	sp,sp,48
    80001ea2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ea4:	00006517          	auipc	a0,0x6
    80001ea8:	4c450513          	addi	a0,a0,1220 # 80008368 <states.1722+0xc8>
    80001eac:	00004097          	auipc	ra,0x4
    80001eb0:	d9c080e7          	jalr	-612(ra) # 80005c48 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eb4:	00006517          	auipc	a0,0x6
    80001eb8:	4dc50513          	addi	a0,a0,1244 # 80008390 <states.1722+0xf0>
    80001ebc:	00004097          	auipc	ra,0x4
    80001ec0:	d8c080e7          	jalr	-628(ra) # 80005c48 <panic>
    printf("scause %p\n", scause);
    80001ec4:	85ce                	mv	a1,s3
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	4ea50513          	addi	a0,a0,1258 # 800083b0 <states.1722+0x110>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	dc4080e7          	jalr	-572(ra) # 80005c92 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eda:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ede:	00006517          	auipc	a0,0x6
    80001ee2:	4e250513          	addi	a0,a0,1250 # 800083c0 <states.1722+0x120>
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	dac080e7          	jalr	-596(ra) # 80005c92 <printf>
    panic("kerneltrap");
    80001eee:	00006517          	auipc	a0,0x6
    80001ef2:	4ea50513          	addi	a0,a0,1258 # 800083d8 <states.1722+0x138>
    80001ef6:	00004097          	auipc	ra,0x4
    80001efa:	d52080e7          	jalr	-686(ra) # 80005c48 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	07a080e7          	jalr	122(ra) # 80000f78 <myproc>
    80001f06:	d541                	beqz	a0,80001e8e <kerneltrap+0x38>
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	070080e7          	jalr	112(ra) # 80000f78 <myproc>
    80001f10:	4d18                	lw	a4,24(a0)
    80001f12:	4791                	li	a5,4
    80001f14:	f6f71de3          	bne	a4,a5,80001e8e <kerneltrap+0x38>
    yield();
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	6e0080e7          	jalr	1760(ra) # 800015f8 <yield>
    80001f20:	b7bd                	j	80001e8e <kerneltrap+0x38>

0000000080001f22 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f22:	1101                	addi	sp,sp,-32
    80001f24:	ec06                	sd	ra,24(sp)
    80001f26:	e822                	sd	s0,16(sp)
    80001f28:	e426                	sd	s1,8(sp)
    80001f2a:	1000                	addi	s0,sp,32
    80001f2c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	04a080e7          	jalr	74(ra) # 80000f78 <myproc>
  switch (n) {
    80001f36:	4795                	li	a5,5
    80001f38:	0497e163          	bltu	a5,s1,80001f7a <argraw+0x58>
    80001f3c:	048a                	slli	s1,s1,0x2
    80001f3e:	00006717          	auipc	a4,0x6
    80001f42:	4d270713          	addi	a4,a4,1234 # 80008410 <states.1722+0x170>
    80001f46:	94ba                	add	s1,s1,a4
    80001f48:	409c                	lw	a5,0(s1)
    80001f4a:	97ba                	add	a5,a5,a4
    80001f4c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f4e:	713c                	ld	a5,96(a0)
    80001f50:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f52:	60e2                	ld	ra,24(sp)
    80001f54:	6442                	ld	s0,16(sp)
    80001f56:	64a2                	ld	s1,8(sp)
    80001f58:	6105                	addi	sp,sp,32
    80001f5a:	8082                	ret
    return p->trapframe->a1;
    80001f5c:	713c                	ld	a5,96(a0)
    80001f5e:	7fa8                	ld	a0,120(a5)
    80001f60:	bfcd                	j	80001f52 <argraw+0x30>
    return p->trapframe->a2;
    80001f62:	713c                	ld	a5,96(a0)
    80001f64:	63c8                	ld	a0,128(a5)
    80001f66:	b7f5                	j	80001f52 <argraw+0x30>
    return p->trapframe->a3;
    80001f68:	713c                	ld	a5,96(a0)
    80001f6a:	67c8                	ld	a0,136(a5)
    80001f6c:	b7dd                	j	80001f52 <argraw+0x30>
    return p->trapframe->a4;
    80001f6e:	713c                	ld	a5,96(a0)
    80001f70:	6bc8                	ld	a0,144(a5)
    80001f72:	b7c5                	j	80001f52 <argraw+0x30>
    return p->trapframe->a5;
    80001f74:	713c                	ld	a5,96(a0)
    80001f76:	6fc8                	ld	a0,152(a5)
    80001f78:	bfe9                	j	80001f52 <argraw+0x30>
  panic("argraw");
    80001f7a:	00006517          	auipc	a0,0x6
    80001f7e:	46e50513          	addi	a0,a0,1134 # 800083e8 <states.1722+0x148>
    80001f82:	00004097          	auipc	ra,0x4
    80001f86:	cc6080e7          	jalr	-826(ra) # 80005c48 <panic>

0000000080001f8a <fetchaddr>:
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	e426                	sd	s1,8(sp)
    80001f92:	e04a                	sd	s2,0(sp)
    80001f94:	1000                	addi	s0,sp,32
    80001f96:	84aa                	mv	s1,a0
    80001f98:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	fde080e7          	jalr	-34(ra) # 80000f78 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fa2:	653c                	ld	a5,72(a0)
    80001fa4:	02f4f863          	bgeu	s1,a5,80001fd4 <fetchaddr+0x4a>
    80001fa8:	00848713          	addi	a4,s1,8
    80001fac:	02e7e663          	bltu	a5,a4,80001fd8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fb0:	46a1                	li	a3,8
    80001fb2:	8626                	mv	a2,s1
    80001fb4:	85ca                	mv	a1,s2
    80001fb6:	6928                	ld	a0,80(a0)
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	bde080e7          	jalr	-1058(ra) # 80000b96 <copyin>
    80001fc0:	00a03533          	snez	a0,a0
    80001fc4:	40a00533          	neg	a0,a0
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret
    return -1;
    80001fd4:	557d                	li	a0,-1
    80001fd6:	bfcd                	j	80001fc8 <fetchaddr+0x3e>
    80001fd8:	557d                	li	a0,-1
    80001fda:	b7fd                	j	80001fc8 <fetchaddr+0x3e>

0000000080001fdc <fetchstr>:
{
    80001fdc:	7179                	addi	sp,sp,-48
    80001fde:	f406                	sd	ra,40(sp)
    80001fe0:	f022                	sd	s0,32(sp)
    80001fe2:	ec26                	sd	s1,24(sp)
    80001fe4:	e84a                	sd	s2,16(sp)
    80001fe6:	e44e                	sd	s3,8(sp)
    80001fe8:	1800                	addi	s0,sp,48
    80001fea:	892a                	mv	s2,a0
    80001fec:	84ae                	mv	s1,a1
    80001fee:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	f88080e7          	jalr	-120(ra) # 80000f78 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ff8:	86ce                	mv	a3,s3
    80001ffa:	864a                	mv	a2,s2
    80001ffc:	85a6                	mv	a1,s1
    80001ffe:	6928                	ld	a0,80(a0)
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	c22080e7          	jalr	-990(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002008:	00054763          	bltz	a0,80002016 <fetchstr+0x3a>
  return strlen(buf);
    8000200c:	8526                	mv	a0,s1
    8000200e:	ffffe097          	auipc	ra,0xffffe
    80002012:	2ee080e7          	jalr	750(ra) # 800002fc <strlen>
}
    80002016:	70a2                	ld	ra,40(sp)
    80002018:	7402                	ld	s0,32(sp)
    8000201a:	64e2                	ld	s1,24(sp)
    8000201c:	6942                	ld	s2,16(sp)
    8000201e:	69a2                	ld	s3,8(sp)
    80002020:	6145                	addi	sp,sp,48
    80002022:	8082                	ret

0000000080002024 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002024:	1101                	addi	sp,sp,-32
    80002026:	ec06                	sd	ra,24(sp)
    80002028:	e822                	sd	s0,16(sp)
    8000202a:	e426                	sd	s1,8(sp)
    8000202c:	1000                	addi	s0,sp,32
    8000202e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002030:	00000097          	auipc	ra,0x0
    80002034:	ef2080e7          	jalr	-270(ra) # 80001f22 <argraw>
    80002038:	c088                	sw	a0,0(s1)
  return 0;
}
    8000203a:	4501                	li	a0,0
    8000203c:	60e2                	ld	ra,24(sp)
    8000203e:	6442                	ld	s0,16(sp)
    80002040:	64a2                	ld	s1,8(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret

0000000080002046 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002046:	1101                	addi	sp,sp,-32
    80002048:	ec06                	sd	ra,24(sp)
    8000204a:	e822                	sd	s0,16(sp)
    8000204c:	e426                	sd	s1,8(sp)
    8000204e:	1000                	addi	s0,sp,32
    80002050:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002052:	00000097          	auipc	ra,0x0
    80002056:	ed0080e7          	jalr	-304(ra) # 80001f22 <argraw>
    8000205a:	e088                	sd	a0,0(s1)
  return 0;
}
    8000205c:	4501                	li	a0,0
    8000205e:	60e2                	ld	ra,24(sp)
    80002060:	6442                	ld	s0,16(sp)
    80002062:	64a2                	ld	s1,8(sp)
    80002064:	6105                	addi	sp,sp,32
    80002066:	8082                	ret

0000000080002068 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	e04a                	sd	s2,0(sp)
    80002072:	1000                	addi	s0,sp,32
    80002074:	84ae                	mv	s1,a1
    80002076:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002078:	00000097          	auipc	ra,0x0
    8000207c:	eaa080e7          	jalr	-342(ra) # 80001f22 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002080:	864a                	mv	a2,s2
    80002082:	85a6                	mv	a1,s1
    80002084:	00000097          	auipc	ra,0x0
    80002088:	f58080e7          	jalr	-168(ra) # 80001fdc <fetchstr>
}
    8000208c:	60e2                	ld	ra,24(sp)
    8000208e:	6442                	ld	s0,16(sp)
    80002090:	64a2                	ld	s1,8(sp)
    80002092:	6902                	ld	s2,0(sp)
    80002094:	6105                	addi	sp,sp,32
    80002096:	8082                	ret

0000000080002098 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002098:	1101                	addi	sp,sp,-32
    8000209a:	ec06                	sd	ra,24(sp)
    8000209c:	e822                	sd	s0,16(sp)
    8000209e:	e426                	sd	s1,8(sp)
    800020a0:	e04a                	sd	s2,0(sp)
    800020a2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	ed4080e7          	jalr	-300(ra) # 80000f78 <myproc>
    800020ac:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020ae:	06053903          	ld	s2,96(a0)
    800020b2:	0a893783          	ld	a5,168(s2)
    800020b6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020ba:	37fd                	addiw	a5,a5,-1
    800020bc:	4751                	li	a4,20
    800020be:	00f76f63          	bltu	a4,a5,800020dc <syscall+0x44>
    800020c2:	00369713          	slli	a4,a3,0x3
    800020c6:	00006797          	auipc	a5,0x6
    800020ca:	36278793          	addi	a5,a5,866 # 80008428 <syscalls>
    800020ce:	97ba                	add	a5,a5,a4
    800020d0:	639c                	ld	a5,0(a5)
    800020d2:	c789                	beqz	a5,800020dc <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020d4:	9782                	jalr	a5
    800020d6:	06a93823          	sd	a0,112(s2)
    800020da:	a839                	j	800020f8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020dc:	16048613          	addi	a2,s1,352
    800020e0:	588c                	lw	a1,48(s1)
    800020e2:	00006517          	auipc	a0,0x6
    800020e6:	30e50513          	addi	a0,a0,782 # 800083f0 <states.1722+0x150>
    800020ea:	00004097          	auipc	ra,0x4
    800020ee:	ba8080e7          	jalr	-1112(ra) # 80005c92 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020f2:	70bc                	ld	a5,96(s1)
    800020f4:	577d                	li	a4,-1
    800020f6:	fbb8                	sd	a4,112(a5)
  }
}
    800020f8:	60e2                	ld	ra,24(sp)
    800020fa:	6442                	ld	s0,16(sp)
    800020fc:	64a2                	ld	s1,8(sp)
    800020fe:	6902                	ld	s2,0(sp)
    80002100:	6105                	addi	sp,sp,32
    80002102:	8082                	ret

0000000080002104 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002104:	1101                	addi	sp,sp,-32
    80002106:	ec06                	sd	ra,24(sp)
    80002108:	e822                	sd	s0,16(sp)
    8000210a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000210c:	fec40593          	addi	a1,s0,-20
    80002110:	4501                	li	a0,0
    80002112:	00000097          	auipc	ra,0x0
    80002116:	f12080e7          	jalr	-238(ra) # 80002024 <argint>
    return -1;
    8000211a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000211c:	00054963          	bltz	a0,8000212e <sys_exit+0x2a>
  exit(n);
    80002120:	fec42503          	lw	a0,-20(s0)
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	76c080e7          	jalr	1900(ra) # 80001890 <exit>
  return 0;  // not reached
    8000212c:	4781                	li	a5,0
}
    8000212e:	853e                	mv	a0,a5
    80002130:	60e2                	ld	ra,24(sp)
    80002132:	6442                	ld	s0,16(sp)
    80002134:	6105                	addi	sp,sp,32
    80002136:	8082                	ret

0000000080002138 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002138:	1141                	addi	sp,sp,-16
    8000213a:	e406                	sd	ra,8(sp)
    8000213c:	e022                	sd	s0,0(sp)
    8000213e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	e38080e7          	jalr	-456(ra) # 80000f78 <myproc>
}
    80002148:	5908                	lw	a0,48(a0)
    8000214a:	60a2                	ld	ra,8(sp)
    8000214c:	6402                	ld	s0,0(sp)
    8000214e:	0141                	addi	sp,sp,16
    80002150:	8082                	ret

0000000080002152 <sys_fork>:

uint64
sys_fork(void)
{
    80002152:	1141                	addi	sp,sp,-16
    80002154:	e406                	sd	ra,8(sp)
    80002156:	e022                	sd	s0,0(sp)
    80002158:	0800                	addi	s0,sp,16
  return fork();
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	1ec080e7          	jalr	492(ra) # 80001346 <fork>
}
    80002162:	60a2                	ld	ra,8(sp)
    80002164:	6402                	ld	s0,0(sp)
    80002166:	0141                	addi	sp,sp,16
    80002168:	8082                	ret

000000008000216a <sys_wait>:

uint64
sys_wait(void)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002172:	fe840593          	addi	a1,s0,-24
    80002176:	4501                	li	a0,0
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	ece080e7          	jalr	-306(ra) # 80002046 <argaddr>
    80002180:	87aa                	mv	a5,a0
    return -1;
    80002182:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002184:	0007c863          	bltz	a5,80002194 <sys_wait+0x2a>
  return wait(p);
    80002188:	fe843503          	ld	a0,-24(s0)
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	50c080e7          	jalr	1292(ra) # 80001698 <wait>
}
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	6105                	addi	sp,sp,32
    8000219a:	8082                	ret

000000008000219c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000219c:	7179                	addi	sp,sp,-48
    8000219e:	f406                	sd	ra,40(sp)
    800021a0:	f022                	sd	s0,32(sp)
    800021a2:	ec26                	sd	s1,24(sp)
    800021a4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021a6:	fdc40593          	addi	a1,s0,-36
    800021aa:	4501                	li	a0,0
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	e78080e7          	jalr	-392(ra) # 80002024 <argint>
    800021b4:	87aa                	mv	a5,a0
    return -1;
    800021b6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021b8:	0207c063          	bltz	a5,800021d8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	dbc080e7          	jalr	-580(ra) # 80000f78 <myproc>
    800021c4:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800021c6:	fdc42503          	lw	a0,-36(s0)
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	108080e7          	jalr	264(ra) # 800012d2 <growproc>
    800021d2:	00054863          	bltz	a0,800021e2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800021d6:	8526                	mv	a0,s1
}
    800021d8:	70a2                	ld	ra,40(sp)
    800021da:	7402                	ld	s0,32(sp)
    800021dc:	64e2                	ld	s1,24(sp)
    800021de:	6145                	addi	sp,sp,48
    800021e0:	8082                	ret
    return -1;
    800021e2:	557d                	li	a0,-1
    800021e4:	bfd5                	j	800021d8 <sys_sbrk+0x3c>

00000000800021e6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021e6:	7139                	addi	sp,sp,-64
    800021e8:	fc06                	sd	ra,56(sp)
    800021ea:	f822                	sd	s0,48(sp)
    800021ec:	f426                	sd	s1,40(sp)
    800021ee:	f04a                	sd	s2,32(sp)
    800021f0:	ec4e                	sd	s3,24(sp)
    800021f2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021f4:	fcc40593          	addi	a1,s0,-52
    800021f8:	4501                	li	a0,0
    800021fa:	00000097          	auipc	ra,0x0
    800021fe:	e2a080e7          	jalr	-470(ra) # 80002024 <argint>
    return -1;
    80002202:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002204:	06054963          	bltz	a0,80002276 <sys_sleep+0x90>
  acquire(&tickslock);
    80002208:	0000d517          	auipc	a0,0xd
    8000220c:	e7850513          	addi	a0,a0,-392 # 8000f080 <tickslock>
    80002210:	00004097          	auipc	ra,0x4
    80002214:	fee080e7          	jalr	-18(ra) # 800061fe <acquire>
  ticks0 = ticks;
    80002218:	00007917          	auipc	s2,0x7
    8000221c:	e0092903          	lw	s2,-512(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002220:	fcc42783          	lw	a5,-52(s0)
    80002224:	cf85                	beqz	a5,8000225c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002226:	0000d997          	auipc	s3,0xd
    8000222a:	e5a98993          	addi	s3,s3,-422 # 8000f080 <tickslock>
    8000222e:	00007497          	auipc	s1,0x7
    80002232:	dea48493          	addi	s1,s1,-534 # 80009018 <ticks>
    if(myproc()->killed){
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	d42080e7          	jalr	-702(ra) # 80000f78 <myproc>
    8000223e:	551c                	lw	a5,40(a0)
    80002240:	e3b9                	bnez	a5,80002286 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002242:	85ce                	mv	a1,s3
    80002244:	8526                	mv	a0,s1
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	3ee080e7          	jalr	1006(ra) # 80001634 <sleep>
  while(ticks - ticks0 < n){
    8000224e:	409c                	lw	a5,0(s1)
    80002250:	412787bb          	subw	a5,a5,s2
    80002254:	fcc42703          	lw	a4,-52(s0)
    80002258:	fce7efe3          	bltu	a5,a4,80002236 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000225c:	0000d517          	auipc	a0,0xd
    80002260:	e2450513          	addi	a0,a0,-476 # 8000f080 <tickslock>
    80002264:	00004097          	auipc	ra,0x4
    80002268:	04e080e7          	jalr	78(ra) # 800062b2 <release>
  backtrace();
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	c3e080e7          	jalr	-962(ra) # 80005eaa <backtrace>
  return 0;
    80002274:	4781                	li	a5,0
}
    80002276:	853e                	mv	a0,a5
    80002278:	70e2                	ld	ra,56(sp)
    8000227a:	7442                	ld	s0,48(sp)
    8000227c:	74a2                	ld	s1,40(sp)
    8000227e:	7902                	ld	s2,32(sp)
    80002280:	69e2                	ld	s3,24(sp)
    80002282:	6121                	addi	sp,sp,64
    80002284:	8082                	ret
      release(&tickslock);
    80002286:	0000d517          	auipc	a0,0xd
    8000228a:	dfa50513          	addi	a0,a0,-518 # 8000f080 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	024080e7          	jalr	36(ra) # 800062b2 <release>
      return -1;
    80002296:	57fd                	li	a5,-1
    80002298:	bff9                	j	80002276 <sys_sleep+0x90>

000000008000229a <sys_kill>:

uint64
sys_kill(void)
{
    8000229a:	1101                	addi	sp,sp,-32
    8000229c:	ec06                	sd	ra,24(sp)
    8000229e:	e822                	sd	s0,16(sp)
    800022a0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022a2:	fec40593          	addi	a1,s0,-20
    800022a6:	4501                	li	a0,0
    800022a8:	00000097          	auipc	ra,0x0
    800022ac:	d7c080e7          	jalr	-644(ra) # 80002024 <argint>
    800022b0:	87aa                	mv	a5,a0
    return -1;
    800022b2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022b4:	0007c863          	bltz	a5,800022c4 <sys_kill+0x2a>
  return kill(pid);
    800022b8:	fec42503          	lw	a0,-20(s0)
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	6aa080e7          	jalr	1706(ra) # 80001966 <kill>
}
    800022c4:	60e2                	ld	ra,24(sp)
    800022c6:	6442                	ld	s0,16(sp)
    800022c8:	6105                	addi	sp,sp,32
    800022ca:	8082                	ret

00000000800022cc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022cc:	1101                	addi	sp,sp,-32
    800022ce:	ec06                	sd	ra,24(sp)
    800022d0:	e822                	sd	s0,16(sp)
    800022d2:	e426                	sd	s1,8(sp)
    800022d4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022d6:	0000d517          	auipc	a0,0xd
    800022da:	daa50513          	addi	a0,a0,-598 # 8000f080 <tickslock>
    800022de:	00004097          	auipc	ra,0x4
    800022e2:	f20080e7          	jalr	-224(ra) # 800061fe <acquire>
  xticks = ticks;
    800022e6:	00007497          	auipc	s1,0x7
    800022ea:	d324a483          	lw	s1,-718(s1) # 80009018 <ticks>
  release(&tickslock);
    800022ee:	0000d517          	auipc	a0,0xd
    800022f2:	d9250513          	addi	a0,a0,-622 # 8000f080 <tickslock>
    800022f6:	00004097          	auipc	ra,0x4
    800022fa:	fbc080e7          	jalr	-68(ra) # 800062b2 <release>
  return xticks;
}
    800022fe:	02049513          	slli	a0,s1,0x20
    80002302:	9101                	srli	a0,a0,0x20
    80002304:	60e2                	ld	ra,24(sp)
    80002306:	6442                	ld	s0,16(sp)
    80002308:	64a2                	ld	s1,8(sp)
    8000230a:	6105                	addi	sp,sp,32
    8000230c:	8082                	ret

000000008000230e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000230e:	7179                	addi	sp,sp,-48
    80002310:	f406                	sd	ra,40(sp)
    80002312:	f022                	sd	s0,32(sp)
    80002314:	ec26                	sd	s1,24(sp)
    80002316:	e84a                	sd	s2,16(sp)
    80002318:	e44e                	sd	s3,8(sp)
    8000231a:	e052                	sd	s4,0(sp)
    8000231c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000231e:	00006597          	auipc	a1,0x6
    80002322:	1ba58593          	addi	a1,a1,442 # 800084d8 <syscalls+0xb0>
    80002326:	0000d517          	auipc	a0,0xd
    8000232a:	d7250513          	addi	a0,a0,-654 # 8000f098 <bcache>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	e40080e7          	jalr	-448(ra) # 8000616e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002336:	00015797          	auipc	a5,0x15
    8000233a:	d6278793          	addi	a5,a5,-670 # 80017098 <bcache+0x8000>
    8000233e:	00015717          	auipc	a4,0x15
    80002342:	fc270713          	addi	a4,a4,-62 # 80017300 <bcache+0x8268>
    80002346:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000234a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000234e:	0000d497          	auipc	s1,0xd
    80002352:	d6248493          	addi	s1,s1,-670 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002356:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002358:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000235a:	00006a17          	auipc	s4,0x6
    8000235e:	186a0a13          	addi	s4,s4,390 # 800084e0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002362:	2b893783          	ld	a5,696(s2)
    80002366:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002368:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000236c:	85d2                	mv	a1,s4
    8000236e:	01048513          	addi	a0,s1,16
    80002372:	00001097          	auipc	ra,0x1
    80002376:	4bc080e7          	jalr	1212(ra) # 8000382e <initsleeplock>
    bcache.head.next->prev = b;
    8000237a:	2b893783          	ld	a5,696(s2)
    8000237e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002380:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002384:	45848493          	addi	s1,s1,1112
    80002388:	fd349de3          	bne	s1,s3,80002362 <binit+0x54>
  }
}
    8000238c:	70a2                	ld	ra,40(sp)
    8000238e:	7402                	ld	s0,32(sp)
    80002390:	64e2                	ld	s1,24(sp)
    80002392:	6942                	ld	s2,16(sp)
    80002394:	69a2                	ld	s3,8(sp)
    80002396:	6a02                	ld	s4,0(sp)
    80002398:	6145                	addi	sp,sp,48
    8000239a:	8082                	ret

000000008000239c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000239c:	7179                	addi	sp,sp,-48
    8000239e:	f406                	sd	ra,40(sp)
    800023a0:	f022                	sd	s0,32(sp)
    800023a2:	ec26                	sd	s1,24(sp)
    800023a4:	e84a                	sd	s2,16(sp)
    800023a6:	e44e                	sd	s3,8(sp)
    800023a8:	1800                	addi	s0,sp,48
    800023aa:	89aa                	mv	s3,a0
    800023ac:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023ae:	0000d517          	auipc	a0,0xd
    800023b2:	cea50513          	addi	a0,a0,-790 # 8000f098 <bcache>
    800023b6:	00004097          	auipc	ra,0x4
    800023ba:	e48080e7          	jalr	-440(ra) # 800061fe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023be:	00015497          	auipc	s1,0x15
    800023c2:	f924b483          	ld	s1,-110(s1) # 80017350 <bcache+0x82b8>
    800023c6:	00015797          	auipc	a5,0x15
    800023ca:	f3a78793          	addi	a5,a5,-198 # 80017300 <bcache+0x8268>
    800023ce:	02f48f63          	beq	s1,a5,8000240c <bread+0x70>
    800023d2:	873e                	mv	a4,a5
    800023d4:	a021                	j	800023dc <bread+0x40>
    800023d6:	68a4                	ld	s1,80(s1)
    800023d8:	02e48a63          	beq	s1,a4,8000240c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023dc:	449c                	lw	a5,8(s1)
    800023de:	ff379ce3          	bne	a5,s3,800023d6 <bread+0x3a>
    800023e2:	44dc                	lw	a5,12(s1)
    800023e4:	ff2799e3          	bne	a5,s2,800023d6 <bread+0x3a>
      b->refcnt++;
    800023e8:	40bc                	lw	a5,64(s1)
    800023ea:	2785                	addiw	a5,a5,1
    800023ec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023ee:	0000d517          	auipc	a0,0xd
    800023f2:	caa50513          	addi	a0,a0,-854 # 8000f098 <bcache>
    800023f6:	00004097          	auipc	ra,0x4
    800023fa:	ebc080e7          	jalr	-324(ra) # 800062b2 <release>
      acquiresleep(&b->lock);
    800023fe:	01048513          	addi	a0,s1,16
    80002402:	00001097          	auipc	ra,0x1
    80002406:	466080e7          	jalr	1126(ra) # 80003868 <acquiresleep>
      return b;
    8000240a:	a8b9                	j	80002468 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000240c:	00015497          	auipc	s1,0x15
    80002410:	f3c4b483          	ld	s1,-196(s1) # 80017348 <bcache+0x82b0>
    80002414:	00015797          	auipc	a5,0x15
    80002418:	eec78793          	addi	a5,a5,-276 # 80017300 <bcache+0x8268>
    8000241c:	00f48863          	beq	s1,a5,8000242c <bread+0x90>
    80002420:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002422:	40bc                	lw	a5,64(s1)
    80002424:	cf81                	beqz	a5,8000243c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002426:	64a4                	ld	s1,72(s1)
    80002428:	fee49de3          	bne	s1,a4,80002422 <bread+0x86>
  panic("bget: no buffers");
    8000242c:	00006517          	auipc	a0,0x6
    80002430:	0bc50513          	addi	a0,a0,188 # 800084e8 <syscalls+0xc0>
    80002434:	00004097          	auipc	ra,0x4
    80002438:	814080e7          	jalr	-2028(ra) # 80005c48 <panic>
      b->dev = dev;
    8000243c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002440:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002444:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002448:	4785                	li	a5,1
    8000244a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000244c:	0000d517          	auipc	a0,0xd
    80002450:	c4c50513          	addi	a0,a0,-948 # 8000f098 <bcache>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	e5e080e7          	jalr	-418(ra) # 800062b2 <release>
      acquiresleep(&b->lock);
    8000245c:	01048513          	addi	a0,s1,16
    80002460:	00001097          	auipc	ra,0x1
    80002464:	408080e7          	jalr	1032(ra) # 80003868 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002468:	409c                	lw	a5,0(s1)
    8000246a:	cb89                	beqz	a5,8000247c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000246c:	8526                	mv	a0,s1
    8000246e:	70a2                	ld	ra,40(sp)
    80002470:	7402                	ld	s0,32(sp)
    80002472:	64e2                	ld	s1,24(sp)
    80002474:	6942                	ld	s2,16(sp)
    80002476:	69a2                	ld	s3,8(sp)
    80002478:	6145                	addi	sp,sp,48
    8000247a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000247c:	4581                	li	a1,0
    8000247e:	8526                	mv	a0,s1
    80002480:	00003097          	auipc	ra,0x3
    80002484:	f06080e7          	jalr	-250(ra) # 80005386 <virtio_disk_rw>
    b->valid = 1;
    80002488:	4785                	li	a5,1
    8000248a:	c09c                	sw	a5,0(s1)
  return b;
    8000248c:	b7c5                	j	8000246c <bread+0xd0>

000000008000248e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000248e:	1101                	addi	sp,sp,-32
    80002490:	ec06                	sd	ra,24(sp)
    80002492:	e822                	sd	s0,16(sp)
    80002494:	e426                	sd	s1,8(sp)
    80002496:	1000                	addi	s0,sp,32
    80002498:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000249a:	0541                	addi	a0,a0,16
    8000249c:	00001097          	auipc	ra,0x1
    800024a0:	466080e7          	jalr	1126(ra) # 80003902 <holdingsleep>
    800024a4:	cd01                	beqz	a0,800024bc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024a6:	4585                	li	a1,1
    800024a8:	8526                	mv	a0,s1
    800024aa:	00003097          	auipc	ra,0x3
    800024ae:	edc080e7          	jalr	-292(ra) # 80005386 <virtio_disk_rw>
}
    800024b2:	60e2                	ld	ra,24(sp)
    800024b4:	6442                	ld	s0,16(sp)
    800024b6:	64a2                	ld	s1,8(sp)
    800024b8:	6105                	addi	sp,sp,32
    800024ba:	8082                	ret
    panic("bwrite");
    800024bc:	00006517          	auipc	a0,0x6
    800024c0:	04450513          	addi	a0,a0,68 # 80008500 <syscalls+0xd8>
    800024c4:	00003097          	auipc	ra,0x3
    800024c8:	784080e7          	jalr	1924(ra) # 80005c48 <panic>

00000000800024cc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024cc:	1101                	addi	sp,sp,-32
    800024ce:	ec06                	sd	ra,24(sp)
    800024d0:	e822                	sd	s0,16(sp)
    800024d2:	e426                	sd	s1,8(sp)
    800024d4:	e04a                	sd	s2,0(sp)
    800024d6:	1000                	addi	s0,sp,32
    800024d8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024da:	01050913          	addi	s2,a0,16
    800024de:	854a                	mv	a0,s2
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	422080e7          	jalr	1058(ra) # 80003902 <holdingsleep>
    800024e8:	c92d                	beqz	a0,8000255a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024ea:	854a                	mv	a0,s2
    800024ec:	00001097          	auipc	ra,0x1
    800024f0:	3d2080e7          	jalr	978(ra) # 800038be <releasesleep>

  acquire(&bcache.lock);
    800024f4:	0000d517          	auipc	a0,0xd
    800024f8:	ba450513          	addi	a0,a0,-1116 # 8000f098 <bcache>
    800024fc:	00004097          	auipc	ra,0x4
    80002500:	d02080e7          	jalr	-766(ra) # 800061fe <acquire>
  b->refcnt--;
    80002504:	40bc                	lw	a5,64(s1)
    80002506:	37fd                	addiw	a5,a5,-1
    80002508:	0007871b          	sext.w	a4,a5
    8000250c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000250e:	eb05                	bnez	a4,8000253e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002510:	68bc                	ld	a5,80(s1)
    80002512:	64b8                	ld	a4,72(s1)
    80002514:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002516:	64bc                	ld	a5,72(s1)
    80002518:	68b8                	ld	a4,80(s1)
    8000251a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000251c:	00015797          	auipc	a5,0x15
    80002520:	b7c78793          	addi	a5,a5,-1156 # 80017098 <bcache+0x8000>
    80002524:	2b87b703          	ld	a4,696(a5)
    80002528:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000252a:	00015717          	auipc	a4,0x15
    8000252e:	dd670713          	addi	a4,a4,-554 # 80017300 <bcache+0x8268>
    80002532:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002534:	2b87b703          	ld	a4,696(a5)
    80002538:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000253a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000253e:	0000d517          	auipc	a0,0xd
    80002542:	b5a50513          	addi	a0,a0,-1190 # 8000f098 <bcache>
    80002546:	00004097          	auipc	ra,0x4
    8000254a:	d6c080e7          	jalr	-660(ra) # 800062b2 <release>
}
    8000254e:	60e2                	ld	ra,24(sp)
    80002550:	6442                	ld	s0,16(sp)
    80002552:	64a2                	ld	s1,8(sp)
    80002554:	6902                	ld	s2,0(sp)
    80002556:	6105                	addi	sp,sp,32
    80002558:	8082                	ret
    panic("brelse");
    8000255a:	00006517          	auipc	a0,0x6
    8000255e:	fae50513          	addi	a0,a0,-82 # 80008508 <syscalls+0xe0>
    80002562:	00003097          	auipc	ra,0x3
    80002566:	6e6080e7          	jalr	1766(ra) # 80005c48 <panic>

000000008000256a <bpin>:

void
bpin(struct buf *b) {
    8000256a:	1101                	addi	sp,sp,-32
    8000256c:	ec06                	sd	ra,24(sp)
    8000256e:	e822                	sd	s0,16(sp)
    80002570:	e426                	sd	s1,8(sp)
    80002572:	1000                	addi	s0,sp,32
    80002574:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002576:	0000d517          	auipc	a0,0xd
    8000257a:	b2250513          	addi	a0,a0,-1246 # 8000f098 <bcache>
    8000257e:	00004097          	auipc	ra,0x4
    80002582:	c80080e7          	jalr	-896(ra) # 800061fe <acquire>
  b->refcnt++;
    80002586:	40bc                	lw	a5,64(s1)
    80002588:	2785                	addiw	a5,a5,1
    8000258a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000258c:	0000d517          	auipc	a0,0xd
    80002590:	b0c50513          	addi	a0,a0,-1268 # 8000f098 <bcache>
    80002594:	00004097          	auipc	ra,0x4
    80002598:	d1e080e7          	jalr	-738(ra) # 800062b2 <release>
}
    8000259c:	60e2                	ld	ra,24(sp)
    8000259e:	6442                	ld	s0,16(sp)
    800025a0:	64a2                	ld	s1,8(sp)
    800025a2:	6105                	addi	sp,sp,32
    800025a4:	8082                	ret

00000000800025a6 <bunpin>:

void
bunpin(struct buf *b) {
    800025a6:	1101                	addi	sp,sp,-32
    800025a8:	ec06                	sd	ra,24(sp)
    800025aa:	e822                	sd	s0,16(sp)
    800025ac:	e426                	sd	s1,8(sp)
    800025ae:	1000                	addi	s0,sp,32
    800025b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b2:	0000d517          	auipc	a0,0xd
    800025b6:	ae650513          	addi	a0,a0,-1306 # 8000f098 <bcache>
    800025ba:	00004097          	auipc	ra,0x4
    800025be:	c44080e7          	jalr	-956(ra) # 800061fe <acquire>
  b->refcnt--;
    800025c2:	40bc                	lw	a5,64(s1)
    800025c4:	37fd                	addiw	a5,a5,-1
    800025c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025c8:	0000d517          	auipc	a0,0xd
    800025cc:	ad050513          	addi	a0,a0,-1328 # 8000f098 <bcache>
    800025d0:	00004097          	auipc	ra,0x4
    800025d4:	ce2080e7          	jalr	-798(ra) # 800062b2 <release>
}
    800025d8:	60e2                	ld	ra,24(sp)
    800025da:	6442                	ld	s0,16(sp)
    800025dc:	64a2                	ld	s1,8(sp)
    800025de:	6105                	addi	sp,sp,32
    800025e0:	8082                	ret

00000000800025e2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025e2:	1101                	addi	sp,sp,-32
    800025e4:	ec06                	sd	ra,24(sp)
    800025e6:	e822                	sd	s0,16(sp)
    800025e8:	e426                	sd	s1,8(sp)
    800025ea:	e04a                	sd	s2,0(sp)
    800025ec:	1000                	addi	s0,sp,32
    800025ee:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025f0:	00d5d59b          	srliw	a1,a1,0xd
    800025f4:	00015797          	auipc	a5,0x15
    800025f8:	1807a783          	lw	a5,384(a5) # 80017774 <sb+0x1c>
    800025fc:	9dbd                	addw	a1,a1,a5
    800025fe:	00000097          	auipc	ra,0x0
    80002602:	d9e080e7          	jalr	-610(ra) # 8000239c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002606:	0074f713          	andi	a4,s1,7
    8000260a:	4785                	li	a5,1
    8000260c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002610:	14ce                	slli	s1,s1,0x33
    80002612:	90d9                	srli	s1,s1,0x36
    80002614:	00950733          	add	a4,a0,s1
    80002618:	05874703          	lbu	a4,88(a4)
    8000261c:	00e7f6b3          	and	a3,a5,a4
    80002620:	c69d                	beqz	a3,8000264e <bfree+0x6c>
    80002622:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002624:	94aa                	add	s1,s1,a0
    80002626:	fff7c793          	not	a5,a5
    8000262a:	8ff9                	and	a5,a5,a4
    8000262c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002630:	00001097          	auipc	ra,0x1
    80002634:	118080e7          	jalr	280(ra) # 80003748 <log_write>
  brelse(bp);
    80002638:	854a                	mv	a0,s2
    8000263a:	00000097          	auipc	ra,0x0
    8000263e:	e92080e7          	jalr	-366(ra) # 800024cc <brelse>
}
    80002642:	60e2                	ld	ra,24(sp)
    80002644:	6442                	ld	s0,16(sp)
    80002646:	64a2                	ld	s1,8(sp)
    80002648:	6902                	ld	s2,0(sp)
    8000264a:	6105                	addi	sp,sp,32
    8000264c:	8082                	ret
    panic("freeing free block");
    8000264e:	00006517          	auipc	a0,0x6
    80002652:	ec250513          	addi	a0,a0,-318 # 80008510 <syscalls+0xe8>
    80002656:	00003097          	auipc	ra,0x3
    8000265a:	5f2080e7          	jalr	1522(ra) # 80005c48 <panic>

000000008000265e <balloc>:
{
    8000265e:	711d                	addi	sp,sp,-96
    80002660:	ec86                	sd	ra,88(sp)
    80002662:	e8a2                	sd	s0,80(sp)
    80002664:	e4a6                	sd	s1,72(sp)
    80002666:	e0ca                	sd	s2,64(sp)
    80002668:	fc4e                	sd	s3,56(sp)
    8000266a:	f852                	sd	s4,48(sp)
    8000266c:	f456                	sd	s5,40(sp)
    8000266e:	f05a                	sd	s6,32(sp)
    80002670:	ec5e                	sd	s7,24(sp)
    80002672:	e862                	sd	s8,16(sp)
    80002674:	e466                	sd	s9,8(sp)
    80002676:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002678:	00015797          	auipc	a5,0x15
    8000267c:	0e47a783          	lw	a5,228(a5) # 8001775c <sb+0x4>
    80002680:	cbd1                	beqz	a5,80002714 <balloc+0xb6>
    80002682:	8baa                	mv	s7,a0
    80002684:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002686:	00015b17          	auipc	s6,0x15
    8000268a:	0d2b0b13          	addi	s6,s6,210 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000268e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002690:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002692:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002694:	6c89                	lui	s9,0x2
    80002696:	a831                	j	800026b2 <balloc+0x54>
    brelse(bp);
    80002698:	854a                	mv	a0,s2
    8000269a:	00000097          	auipc	ra,0x0
    8000269e:	e32080e7          	jalr	-462(ra) # 800024cc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026a2:	015c87bb          	addw	a5,s9,s5
    800026a6:	00078a9b          	sext.w	s5,a5
    800026aa:	004b2703          	lw	a4,4(s6)
    800026ae:	06eaf363          	bgeu	s5,a4,80002714 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026b2:	41fad79b          	sraiw	a5,s5,0x1f
    800026b6:	0137d79b          	srliw	a5,a5,0x13
    800026ba:	015787bb          	addw	a5,a5,s5
    800026be:	40d7d79b          	sraiw	a5,a5,0xd
    800026c2:	01cb2583          	lw	a1,28(s6)
    800026c6:	9dbd                	addw	a1,a1,a5
    800026c8:	855e                	mv	a0,s7
    800026ca:	00000097          	auipc	ra,0x0
    800026ce:	cd2080e7          	jalr	-814(ra) # 8000239c <bread>
    800026d2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d4:	004b2503          	lw	a0,4(s6)
    800026d8:	000a849b          	sext.w	s1,s5
    800026dc:	8662                	mv	a2,s8
    800026de:	faa4fde3          	bgeu	s1,a0,80002698 <balloc+0x3a>
      m = 1 << (bi % 8);
    800026e2:	41f6579b          	sraiw	a5,a2,0x1f
    800026e6:	01d7d69b          	srliw	a3,a5,0x1d
    800026ea:	00c6873b          	addw	a4,a3,a2
    800026ee:	00777793          	andi	a5,a4,7
    800026f2:	9f95                	subw	a5,a5,a3
    800026f4:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026f8:	4037571b          	sraiw	a4,a4,0x3
    800026fc:	00e906b3          	add	a3,s2,a4
    80002700:	0586c683          	lbu	a3,88(a3)
    80002704:	00d7f5b3          	and	a1,a5,a3
    80002708:	cd91                	beqz	a1,80002724 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270a:	2605                	addiw	a2,a2,1
    8000270c:	2485                	addiw	s1,s1,1
    8000270e:	fd4618e3          	bne	a2,s4,800026de <balloc+0x80>
    80002712:	b759                	j	80002698 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002714:	00006517          	auipc	a0,0x6
    80002718:	e1450513          	addi	a0,a0,-492 # 80008528 <syscalls+0x100>
    8000271c:	00003097          	auipc	ra,0x3
    80002720:	52c080e7          	jalr	1324(ra) # 80005c48 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002724:	974a                	add	a4,a4,s2
    80002726:	8fd5                	or	a5,a5,a3
    80002728:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000272c:	854a                	mv	a0,s2
    8000272e:	00001097          	auipc	ra,0x1
    80002732:	01a080e7          	jalr	26(ra) # 80003748 <log_write>
        brelse(bp);
    80002736:	854a                	mv	a0,s2
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	d94080e7          	jalr	-620(ra) # 800024cc <brelse>
  bp = bread(dev, bno);
    80002740:	85a6                	mv	a1,s1
    80002742:	855e                	mv	a0,s7
    80002744:	00000097          	auipc	ra,0x0
    80002748:	c58080e7          	jalr	-936(ra) # 8000239c <bread>
    8000274c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000274e:	40000613          	li	a2,1024
    80002752:	4581                	li	a1,0
    80002754:	05850513          	addi	a0,a0,88
    80002758:	ffffe097          	auipc	ra,0xffffe
    8000275c:	a20080e7          	jalr	-1504(ra) # 80000178 <memset>
  log_write(bp);
    80002760:	854a                	mv	a0,s2
    80002762:	00001097          	auipc	ra,0x1
    80002766:	fe6080e7          	jalr	-26(ra) # 80003748 <log_write>
  brelse(bp);
    8000276a:	854a                	mv	a0,s2
    8000276c:	00000097          	auipc	ra,0x0
    80002770:	d60080e7          	jalr	-672(ra) # 800024cc <brelse>
}
    80002774:	8526                	mv	a0,s1
    80002776:	60e6                	ld	ra,88(sp)
    80002778:	6446                	ld	s0,80(sp)
    8000277a:	64a6                	ld	s1,72(sp)
    8000277c:	6906                	ld	s2,64(sp)
    8000277e:	79e2                	ld	s3,56(sp)
    80002780:	7a42                	ld	s4,48(sp)
    80002782:	7aa2                	ld	s5,40(sp)
    80002784:	7b02                	ld	s6,32(sp)
    80002786:	6be2                	ld	s7,24(sp)
    80002788:	6c42                	ld	s8,16(sp)
    8000278a:	6ca2                	ld	s9,8(sp)
    8000278c:	6125                	addi	sp,sp,96
    8000278e:	8082                	ret

0000000080002790 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002790:	7179                	addi	sp,sp,-48
    80002792:	f406                	sd	ra,40(sp)
    80002794:	f022                	sd	s0,32(sp)
    80002796:	ec26                	sd	s1,24(sp)
    80002798:	e84a                	sd	s2,16(sp)
    8000279a:	e44e                	sd	s3,8(sp)
    8000279c:	e052                	sd	s4,0(sp)
    8000279e:	1800                	addi	s0,sp,48
    800027a0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027a2:	47ad                	li	a5,11
    800027a4:	04b7fe63          	bgeu	a5,a1,80002800 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027a8:	ff45849b          	addiw	s1,a1,-12
    800027ac:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027b0:	0ff00793          	li	a5,255
    800027b4:	0ae7e363          	bltu	a5,a4,8000285a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027b8:	08052583          	lw	a1,128(a0)
    800027bc:	c5ad                	beqz	a1,80002826 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027be:	00092503          	lw	a0,0(s2)
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	bda080e7          	jalr	-1062(ra) # 8000239c <bread>
    800027ca:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027cc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027d0:	02049593          	slli	a1,s1,0x20
    800027d4:	9181                	srli	a1,a1,0x20
    800027d6:	058a                	slli	a1,a1,0x2
    800027d8:	00b784b3          	add	s1,a5,a1
    800027dc:	0004a983          	lw	s3,0(s1)
    800027e0:	04098d63          	beqz	s3,8000283a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027e4:	8552                	mv	a0,s4
    800027e6:	00000097          	auipc	ra,0x0
    800027ea:	ce6080e7          	jalr	-794(ra) # 800024cc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027ee:	854e                	mv	a0,s3
    800027f0:	70a2                	ld	ra,40(sp)
    800027f2:	7402                	ld	s0,32(sp)
    800027f4:	64e2                	ld	s1,24(sp)
    800027f6:	6942                	ld	s2,16(sp)
    800027f8:	69a2                	ld	s3,8(sp)
    800027fa:	6a02                	ld	s4,0(sp)
    800027fc:	6145                	addi	sp,sp,48
    800027fe:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002800:	02059493          	slli	s1,a1,0x20
    80002804:	9081                	srli	s1,s1,0x20
    80002806:	048a                	slli	s1,s1,0x2
    80002808:	94aa                	add	s1,s1,a0
    8000280a:	0504a983          	lw	s3,80(s1)
    8000280e:	fe0990e3          	bnez	s3,800027ee <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002812:	4108                	lw	a0,0(a0)
    80002814:	00000097          	auipc	ra,0x0
    80002818:	e4a080e7          	jalr	-438(ra) # 8000265e <balloc>
    8000281c:	0005099b          	sext.w	s3,a0
    80002820:	0534a823          	sw	s3,80(s1)
    80002824:	b7e9                	j	800027ee <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002826:	4108                	lw	a0,0(a0)
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e36080e7          	jalr	-458(ra) # 8000265e <balloc>
    80002830:	0005059b          	sext.w	a1,a0
    80002834:	08b92023          	sw	a1,128(s2)
    80002838:	b759                	j	800027be <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000283a:	00092503          	lw	a0,0(s2)
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	e20080e7          	jalr	-480(ra) # 8000265e <balloc>
    80002846:	0005099b          	sext.w	s3,a0
    8000284a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000284e:	8552                	mv	a0,s4
    80002850:	00001097          	auipc	ra,0x1
    80002854:	ef8080e7          	jalr	-264(ra) # 80003748 <log_write>
    80002858:	b771                	j	800027e4 <bmap+0x54>
  panic("bmap: out of range");
    8000285a:	00006517          	auipc	a0,0x6
    8000285e:	ce650513          	addi	a0,a0,-794 # 80008540 <syscalls+0x118>
    80002862:	00003097          	auipc	ra,0x3
    80002866:	3e6080e7          	jalr	998(ra) # 80005c48 <panic>

000000008000286a <iget>:
{
    8000286a:	7179                	addi	sp,sp,-48
    8000286c:	f406                	sd	ra,40(sp)
    8000286e:	f022                	sd	s0,32(sp)
    80002870:	ec26                	sd	s1,24(sp)
    80002872:	e84a                	sd	s2,16(sp)
    80002874:	e44e                	sd	s3,8(sp)
    80002876:	e052                	sd	s4,0(sp)
    80002878:	1800                	addi	s0,sp,48
    8000287a:	89aa                	mv	s3,a0
    8000287c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000287e:	00015517          	auipc	a0,0x15
    80002882:	efa50513          	addi	a0,a0,-262 # 80017778 <itable>
    80002886:	00004097          	auipc	ra,0x4
    8000288a:	978080e7          	jalr	-1672(ra) # 800061fe <acquire>
  empty = 0;
    8000288e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002890:	00015497          	auipc	s1,0x15
    80002894:	f0048493          	addi	s1,s1,-256 # 80017790 <itable+0x18>
    80002898:	00017697          	auipc	a3,0x17
    8000289c:	98868693          	addi	a3,a3,-1656 # 80019220 <log>
    800028a0:	a039                	j	800028ae <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028a2:	02090b63          	beqz	s2,800028d8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028a6:	08848493          	addi	s1,s1,136
    800028aa:	02d48a63          	beq	s1,a3,800028de <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028ae:	449c                	lw	a5,8(s1)
    800028b0:	fef059e3          	blez	a5,800028a2 <iget+0x38>
    800028b4:	4098                	lw	a4,0(s1)
    800028b6:	ff3716e3          	bne	a4,s3,800028a2 <iget+0x38>
    800028ba:	40d8                	lw	a4,4(s1)
    800028bc:	ff4713e3          	bne	a4,s4,800028a2 <iget+0x38>
      ip->ref++;
    800028c0:	2785                	addiw	a5,a5,1
    800028c2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028c4:	00015517          	auipc	a0,0x15
    800028c8:	eb450513          	addi	a0,a0,-332 # 80017778 <itable>
    800028cc:	00004097          	auipc	ra,0x4
    800028d0:	9e6080e7          	jalr	-1562(ra) # 800062b2 <release>
      return ip;
    800028d4:	8926                	mv	s2,s1
    800028d6:	a03d                	j	80002904 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028d8:	f7f9                	bnez	a5,800028a6 <iget+0x3c>
    800028da:	8926                	mv	s2,s1
    800028dc:	b7e9                	j	800028a6 <iget+0x3c>
  if(empty == 0)
    800028de:	02090c63          	beqz	s2,80002916 <iget+0xac>
  ip->dev = dev;
    800028e2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028e6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028ea:	4785                	li	a5,1
    800028ec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028f0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028f4:	00015517          	auipc	a0,0x15
    800028f8:	e8450513          	addi	a0,a0,-380 # 80017778 <itable>
    800028fc:	00004097          	auipc	ra,0x4
    80002900:	9b6080e7          	jalr	-1610(ra) # 800062b2 <release>
}
    80002904:	854a                	mv	a0,s2
    80002906:	70a2                	ld	ra,40(sp)
    80002908:	7402                	ld	s0,32(sp)
    8000290a:	64e2                	ld	s1,24(sp)
    8000290c:	6942                	ld	s2,16(sp)
    8000290e:	69a2                	ld	s3,8(sp)
    80002910:	6a02                	ld	s4,0(sp)
    80002912:	6145                	addi	sp,sp,48
    80002914:	8082                	ret
    panic("iget: no inodes");
    80002916:	00006517          	auipc	a0,0x6
    8000291a:	c4250513          	addi	a0,a0,-958 # 80008558 <syscalls+0x130>
    8000291e:	00003097          	auipc	ra,0x3
    80002922:	32a080e7          	jalr	810(ra) # 80005c48 <panic>

0000000080002926 <fsinit>:
fsinit(int dev) {
    80002926:	7179                	addi	sp,sp,-48
    80002928:	f406                	sd	ra,40(sp)
    8000292a:	f022                	sd	s0,32(sp)
    8000292c:	ec26                	sd	s1,24(sp)
    8000292e:	e84a                	sd	s2,16(sp)
    80002930:	e44e                	sd	s3,8(sp)
    80002932:	1800                	addi	s0,sp,48
    80002934:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002936:	4585                	li	a1,1
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	a64080e7          	jalr	-1436(ra) # 8000239c <bread>
    80002940:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002942:	00015997          	auipc	s3,0x15
    80002946:	e1698993          	addi	s3,s3,-490 # 80017758 <sb>
    8000294a:	02000613          	li	a2,32
    8000294e:	05850593          	addi	a1,a0,88
    80002952:	854e                	mv	a0,s3
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	884080e7          	jalr	-1916(ra) # 800001d8 <memmove>
  brelse(bp);
    8000295c:	8526                	mv	a0,s1
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	b6e080e7          	jalr	-1170(ra) # 800024cc <brelse>
  if(sb.magic != FSMAGIC)
    80002966:	0009a703          	lw	a4,0(s3)
    8000296a:	102037b7          	lui	a5,0x10203
    8000296e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002972:	02f71263          	bne	a4,a5,80002996 <fsinit+0x70>
  initlog(dev, &sb);
    80002976:	00015597          	auipc	a1,0x15
    8000297a:	de258593          	addi	a1,a1,-542 # 80017758 <sb>
    8000297e:	854a                	mv	a0,s2
    80002980:	00001097          	auipc	ra,0x1
    80002984:	b4c080e7          	jalr	-1204(ra) # 800034cc <initlog>
}
    80002988:	70a2                	ld	ra,40(sp)
    8000298a:	7402                	ld	s0,32(sp)
    8000298c:	64e2                	ld	s1,24(sp)
    8000298e:	6942                	ld	s2,16(sp)
    80002990:	69a2                	ld	s3,8(sp)
    80002992:	6145                	addi	sp,sp,48
    80002994:	8082                	ret
    panic("invalid file system");
    80002996:	00006517          	auipc	a0,0x6
    8000299a:	bd250513          	addi	a0,a0,-1070 # 80008568 <syscalls+0x140>
    8000299e:	00003097          	auipc	ra,0x3
    800029a2:	2aa080e7          	jalr	682(ra) # 80005c48 <panic>

00000000800029a6 <iinit>:
{
    800029a6:	7179                	addi	sp,sp,-48
    800029a8:	f406                	sd	ra,40(sp)
    800029aa:	f022                	sd	s0,32(sp)
    800029ac:	ec26                	sd	s1,24(sp)
    800029ae:	e84a                	sd	s2,16(sp)
    800029b0:	e44e                	sd	s3,8(sp)
    800029b2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029b4:	00006597          	auipc	a1,0x6
    800029b8:	bcc58593          	addi	a1,a1,-1076 # 80008580 <syscalls+0x158>
    800029bc:	00015517          	auipc	a0,0x15
    800029c0:	dbc50513          	addi	a0,a0,-580 # 80017778 <itable>
    800029c4:	00003097          	auipc	ra,0x3
    800029c8:	7aa080e7          	jalr	1962(ra) # 8000616e <initlock>
  for(i = 0; i < NINODE; i++) {
    800029cc:	00015497          	auipc	s1,0x15
    800029d0:	dd448493          	addi	s1,s1,-556 # 800177a0 <itable+0x28>
    800029d4:	00017997          	auipc	s3,0x17
    800029d8:	85c98993          	addi	s3,s3,-1956 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029dc:	00006917          	auipc	s2,0x6
    800029e0:	bac90913          	addi	s2,s2,-1108 # 80008588 <syscalls+0x160>
    800029e4:	85ca                	mv	a1,s2
    800029e6:	8526                	mv	a0,s1
    800029e8:	00001097          	auipc	ra,0x1
    800029ec:	e46080e7          	jalr	-442(ra) # 8000382e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029f0:	08848493          	addi	s1,s1,136
    800029f4:	ff3498e3          	bne	s1,s3,800029e4 <iinit+0x3e>
}
    800029f8:	70a2                	ld	ra,40(sp)
    800029fa:	7402                	ld	s0,32(sp)
    800029fc:	64e2                	ld	s1,24(sp)
    800029fe:	6942                	ld	s2,16(sp)
    80002a00:	69a2                	ld	s3,8(sp)
    80002a02:	6145                	addi	sp,sp,48
    80002a04:	8082                	ret

0000000080002a06 <ialloc>:
{
    80002a06:	715d                	addi	sp,sp,-80
    80002a08:	e486                	sd	ra,72(sp)
    80002a0a:	e0a2                	sd	s0,64(sp)
    80002a0c:	fc26                	sd	s1,56(sp)
    80002a0e:	f84a                	sd	s2,48(sp)
    80002a10:	f44e                	sd	s3,40(sp)
    80002a12:	f052                	sd	s4,32(sp)
    80002a14:	ec56                	sd	s5,24(sp)
    80002a16:	e85a                	sd	s6,16(sp)
    80002a18:	e45e                	sd	s7,8(sp)
    80002a1a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a1c:	00015717          	auipc	a4,0x15
    80002a20:	d4872703          	lw	a4,-696(a4) # 80017764 <sb+0xc>
    80002a24:	4785                	li	a5,1
    80002a26:	04e7fa63          	bgeu	a5,a4,80002a7a <ialloc+0x74>
    80002a2a:	8aaa                	mv	s5,a0
    80002a2c:	8bae                	mv	s7,a1
    80002a2e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a30:	00015a17          	auipc	s4,0x15
    80002a34:	d28a0a13          	addi	s4,s4,-728 # 80017758 <sb>
    80002a38:	00048b1b          	sext.w	s6,s1
    80002a3c:	0044d593          	srli	a1,s1,0x4
    80002a40:	018a2783          	lw	a5,24(s4)
    80002a44:	9dbd                	addw	a1,a1,a5
    80002a46:	8556                	mv	a0,s5
    80002a48:	00000097          	auipc	ra,0x0
    80002a4c:	954080e7          	jalr	-1708(ra) # 8000239c <bread>
    80002a50:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a52:	05850993          	addi	s3,a0,88
    80002a56:	00f4f793          	andi	a5,s1,15
    80002a5a:	079a                	slli	a5,a5,0x6
    80002a5c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a5e:	00099783          	lh	a5,0(s3)
    80002a62:	c785                	beqz	a5,80002a8a <ialloc+0x84>
    brelse(bp);
    80002a64:	00000097          	auipc	ra,0x0
    80002a68:	a68080e7          	jalr	-1432(ra) # 800024cc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a6c:	0485                	addi	s1,s1,1
    80002a6e:	00ca2703          	lw	a4,12(s4)
    80002a72:	0004879b          	sext.w	a5,s1
    80002a76:	fce7e1e3          	bltu	a5,a4,80002a38 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a7a:	00006517          	auipc	a0,0x6
    80002a7e:	b1650513          	addi	a0,a0,-1258 # 80008590 <syscalls+0x168>
    80002a82:	00003097          	auipc	ra,0x3
    80002a86:	1c6080e7          	jalr	454(ra) # 80005c48 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a8a:	04000613          	li	a2,64
    80002a8e:	4581                	li	a1,0
    80002a90:	854e                	mv	a0,s3
    80002a92:	ffffd097          	auipc	ra,0xffffd
    80002a96:	6e6080e7          	jalr	1766(ra) # 80000178 <memset>
      dip->type = type;
    80002a9a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a9e:	854a                	mv	a0,s2
    80002aa0:	00001097          	auipc	ra,0x1
    80002aa4:	ca8080e7          	jalr	-856(ra) # 80003748 <log_write>
      brelse(bp);
    80002aa8:	854a                	mv	a0,s2
    80002aaa:	00000097          	auipc	ra,0x0
    80002aae:	a22080e7          	jalr	-1502(ra) # 800024cc <brelse>
      return iget(dev, inum);
    80002ab2:	85da                	mv	a1,s6
    80002ab4:	8556                	mv	a0,s5
    80002ab6:	00000097          	auipc	ra,0x0
    80002aba:	db4080e7          	jalr	-588(ra) # 8000286a <iget>
}
    80002abe:	60a6                	ld	ra,72(sp)
    80002ac0:	6406                	ld	s0,64(sp)
    80002ac2:	74e2                	ld	s1,56(sp)
    80002ac4:	7942                	ld	s2,48(sp)
    80002ac6:	79a2                	ld	s3,40(sp)
    80002ac8:	7a02                	ld	s4,32(sp)
    80002aca:	6ae2                	ld	s5,24(sp)
    80002acc:	6b42                	ld	s6,16(sp)
    80002ace:	6ba2                	ld	s7,8(sp)
    80002ad0:	6161                	addi	sp,sp,80
    80002ad2:	8082                	ret

0000000080002ad4 <iupdate>:
{
    80002ad4:	1101                	addi	sp,sp,-32
    80002ad6:	ec06                	sd	ra,24(sp)
    80002ad8:	e822                	sd	s0,16(sp)
    80002ada:	e426                	sd	s1,8(sp)
    80002adc:	e04a                	sd	s2,0(sp)
    80002ade:	1000                	addi	s0,sp,32
    80002ae0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ae2:	415c                	lw	a5,4(a0)
    80002ae4:	0047d79b          	srliw	a5,a5,0x4
    80002ae8:	00015597          	auipc	a1,0x15
    80002aec:	c885a583          	lw	a1,-888(a1) # 80017770 <sb+0x18>
    80002af0:	9dbd                	addw	a1,a1,a5
    80002af2:	4108                	lw	a0,0(a0)
    80002af4:	00000097          	auipc	ra,0x0
    80002af8:	8a8080e7          	jalr	-1880(ra) # 8000239c <bread>
    80002afc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002afe:	05850793          	addi	a5,a0,88
    80002b02:	40c8                	lw	a0,4(s1)
    80002b04:	893d                	andi	a0,a0,15
    80002b06:	051a                	slli	a0,a0,0x6
    80002b08:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b0a:	04449703          	lh	a4,68(s1)
    80002b0e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b12:	04649703          	lh	a4,70(s1)
    80002b16:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b1a:	04849703          	lh	a4,72(s1)
    80002b1e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b22:	04a49703          	lh	a4,74(s1)
    80002b26:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b2a:	44f8                	lw	a4,76(s1)
    80002b2c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b2e:	03400613          	li	a2,52
    80002b32:	05048593          	addi	a1,s1,80
    80002b36:	0531                	addi	a0,a0,12
    80002b38:	ffffd097          	auipc	ra,0xffffd
    80002b3c:	6a0080e7          	jalr	1696(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b40:	854a                	mv	a0,s2
    80002b42:	00001097          	auipc	ra,0x1
    80002b46:	c06080e7          	jalr	-1018(ra) # 80003748 <log_write>
  brelse(bp);
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	980080e7          	jalr	-1664(ra) # 800024cc <brelse>
}
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6902                	ld	s2,0(sp)
    80002b5c:	6105                	addi	sp,sp,32
    80002b5e:	8082                	ret

0000000080002b60 <idup>:
{
    80002b60:	1101                	addi	sp,sp,-32
    80002b62:	ec06                	sd	ra,24(sp)
    80002b64:	e822                	sd	s0,16(sp)
    80002b66:	e426                	sd	s1,8(sp)
    80002b68:	1000                	addi	s0,sp,32
    80002b6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b6c:	00015517          	auipc	a0,0x15
    80002b70:	c0c50513          	addi	a0,a0,-1012 # 80017778 <itable>
    80002b74:	00003097          	auipc	ra,0x3
    80002b78:	68a080e7          	jalr	1674(ra) # 800061fe <acquire>
  ip->ref++;
    80002b7c:	449c                	lw	a5,8(s1)
    80002b7e:	2785                	addiw	a5,a5,1
    80002b80:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b82:	00015517          	auipc	a0,0x15
    80002b86:	bf650513          	addi	a0,a0,-1034 # 80017778 <itable>
    80002b8a:	00003097          	auipc	ra,0x3
    80002b8e:	728080e7          	jalr	1832(ra) # 800062b2 <release>
}
    80002b92:	8526                	mv	a0,s1
    80002b94:	60e2                	ld	ra,24(sp)
    80002b96:	6442                	ld	s0,16(sp)
    80002b98:	64a2                	ld	s1,8(sp)
    80002b9a:	6105                	addi	sp,sp,32
    80002b9c:	8082                	ret

0000000080002b9e <ilock>:
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002baa:	c115                	beqz	a0,80002bce <ilock+0x30>
    80002bac:	84aa                	mv	s1,a0
    80002bae:	451c                	lw	a5,8(a0)
    80002bb0:	00f05f63          	blez	a5,80002bce <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bb4:	0541                	addi	a0,a0,16
    80002bb6:	00001097          	auipc	ra,0x1
    80002bba:	cb2080e7          	jalr	-846(ra) # 80003868 <acquiresleep>
  if(ip->valid == 0){
    80002bbe:	40bc                	lw	a5,64(s1)
    80002bc0:	cf99                	beqz	a5,80002bde <ilock+0x40>
}
    80002bc2:	60e2                	ld	ra,24(sp)
    80002bc4:	6442                	ld	s0,16(sp)
    80002bc6:	64a2                	ld	s1,8(sp)
    80002bc8:	6902                	ld	s2,0(sp)
    80002bca:	6105                	addi	sp,sp,32
    80002bcc:	8082                	ret
    panic("ilock");
    80002bce:	00006517          	auipc	a0,0x6
    80002bd2:	9da50513          	addi	a0,a0,-1574 # 800085a8 <syscalls+0x180>
    80002bd6:	00003097          	auipc	ra,0x3
    80002bda:	072080e7          	jalr	114(ra) # 80005c48 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bde:	40dc                	lw	a5,4(s1)
    80002be0:	0047d79b          	srliw	a5,a5,0x4
    80002be4:	00015597          	auipc	a1,0x15
    80002be8:	b8c5a583          	lw	a1,-1140(a1) # 80017770 <sb+0x18>
    80002bec:	9dbd                	addw	a1,a1,a5
    80002bee:	4088                	lw	a0,0(s1)
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	7ac080e7          	jalr	1964(ra) # 8000239c <bread>
    80002bf8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bfa:	05850593          	addi	a1,a0,88
    80002bfe:	40dc                	lw	a5,4(s1)
    80002c00:	8bbd                	andi	a5,a5,15
    80002c02:	079a                	slli	a5,a5,0x6
    80002c04:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c06:	00059783          	lh	a5,0(a1)
    80002c0a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c0e:	00259783          	lh	a5,2(a1)
    80002c12:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c16:	00459783          	lh	a5,4(a1)
    80002c1a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c1e:	00659783          	lh	a5,6(a1)
    80002c22:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c26:	459c                	lw	a5,8(a1)
    80002c28:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c2a:	03400613          	li	a2,52
    80002c2e:	05b1                	addi	a1,a1,12
    80002c30:	05048513          	addi	a0,s1,80
    80002c34:	ffffd097          	auipc	ra,0xffffd
    80002c38:	5a4080e7          	jalr	1444(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	00000097          	auipc	ra,0x0
    80002c42:	88e080e7          	jalr	-1906(ra) # 800024cc <brelse>
    ip->valid = 1;
    80002c46:	4785                	li	a5,1
    80002c48:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c4a:	04449783          	lh	a5,68(s1)
    80002c4e:	fbb5                	bnez	a5,80002bc2 <ilock+0x24>
      panic("ilock: no type");
    80002c50:	00006517          	auipc	a0,0x6
    80002c54:	96050513          	addi	a0,a0,-1696 # 800085b0 <syscalls+0x188>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	ff0080e7          	jalr	-16(ra) # 80005c48 <panic>

0000000080002c60 <iunlock>:
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	e04a                	sd	s2,0(sp)
    80002c6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c6c:	c905                	beqz	a0,80002c9c <iunlock+0x3c>
    80002c6e:	84aa                	mv	s1,a0
    80002c70:	01050913          	addi	s2,a0,16
    80002c74:	854a                	mv	a0,s2
    80002c76:	00001097          	auipc	ra,0x1
    80002c7a:	c8c080e7          	jalr	-884(ra) # 80003902 <holdingsleep>
    80002c7e:	cd19                	beqz	a0,80002c9c <iunlock+0x3c>
    80002c80:	449c                	lw	a5,8(s1)
    80002c82:	00f05d63          	blez	a5,80002c9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c86:	854a                	mv	a0,s2
    80002c88:	00001097          	auipc	ra,0x1
    80002c8c:	c36080e7          	jalr	-970(ra) # 800038be <releasesleep>
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6902                	ld	s2,0(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret
    panic("iunlock");
    80002c9c:	00006517          	auipc	a0,0x6
    80002ca0:	92450513          	addi	a0,a0,-1756 # 800085c0 <syscalls+0x198>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	fa4080e7          	jalr	-92(ra) # 80005c48 <panic>

0000000080002cac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cac:	7179                	addi	sp,sp,-48
    80002cae:	f406                	sd	ra,40(sp)
    80002cb0:	f022                	sd	s0,32(sp)
    80002cb2:	ec26                	sd	s1,24(sp)
    80002cb4:	e84a                	sd	s2,16(sp)
    80002cb6:	e44e                	sd	s3,8(sp)
    80002cb8:	e052                	sd	s4,0(sp)
    80002cba:	1800                	addi	s0,sp,48
    80002cbc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cbe:	05050493          	addi	s1,a0,80
    80002cc2:	08050913          	addi	s2,a0,128
    80002cc6:	a021                	j	80002cce <itrunc+0x22>
    80002cc8:	0491                	addi	s1,s1,4
    80002cca:	01248d63          	beq	s1,s2,80002ce4 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cce:	408c                	lw	a1,0(s1)
    80002cd0:	dde5                	beqz	a1,80002cc8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cd2:	0009a503          	lw	a0,0(s3)
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	90c080e7          	jalr	-1780(ra) # 800025e2 <bfree>
      ip->addrs[i] = 0;
    80002cde:	0004a023          	sw	zero,0(s1)
    80002ce2:	b7dd                	j	80002cc8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ce4:	0809a583          	lw	a1,128(s3)
    80002ce8:	e185                	bnez	a1,80002d08 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cee:	854e                	mv	a0,s3
    80002cf0:	00000097          	auipc	ra,0x0
    80002cf4:	de4080e7          	jalr	-540(ra) # 80002ad4 <iupdate>
}
    80002cf8:	70a2                	ld	ra,40(sp)
    80002cfa:	7402                	ld	s0,32(sp)
    80002cfc:	64e2                	ld	s1,24(sp)
    80002cfe:	6942                	ld	s2,16(sp)
    80002d00:	69a2                	ld	s3,8(sp)
    80002d02:	6a02                	ld	s4,0(sp)
    80002d04:	6145                	addi	sp,sp,48
    80002d06:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d08:	0009a503          	lw	a0,0(s3)
    80002d0c:	fffff097          	auipc	ra,0xfffff
    80002d10:	690080e7          	jalr	1680(ra) # 8000239c <bread>
    80002d14:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d16:	05850493          	addi	s1,a0,88
    80002d1a:	45850913          	addi	s2,a0,1112
    80002d1e:	a811                	j	80002d32 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d20:	0009a503          	lw	a0,0(s3)
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	8be080e7          	jalr	-1858(ra) # 800025e2 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d2c:	0491                	addi	s1,s1,4
    80002d2e:	01248563          	beq	s1,s2,80002d38 <itrunc+0x8c>
      if(a[j])
    80002d32:	408c                	lw	a1,0(s1)
    80002d34:	dde5                	beqz	a1,80002d2c <itrunc+0x80>
    80002d36:	b7ed                	j	80002d20 <itrunc+0x74>
    brelse(bp);
    80002d38:	8552                	mv	a0,s4
    80002d3a:	fffff097          	auipc	ra,0xfffff
    80002d3e:	792080e7          	jalr	1938(ra) # 800024cc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d42:	0809a583          	lw	a1,128(s3)
    80002d46:	0009a503          	lw	a0,0(s3)
    80002d4a:	00000097          	auipc	ra,0x0
    80002d4e:	898080e7          	jalr	-1896(ra) # 800025e2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d52:	0809a023          	sw	zero,128(s3)
    80002d56:	bf51                	j	80002cea <itrunc+0x3e>

0000000080002d58 <iput>:
{
    80002d58:	1101                	addi	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	e426                	sd	s1,8(sp)
    80002d60:	e04a                	sd	s2,0(sp)
    80002d62:	1000                	addi	s0,sp,32
    80002d64:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d66:	00015517          	auipc	a0,0x15
    80002d6a:	a1250513          	addi	a0,a0,-1518 # 80017778 <itable>
    80002d6e:	00003097          	auipc	ra,0x3
    80002d72:	490080e7          	jalr	1168(ra) # 800061fe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d76:	4498                	lw	a4,8(s1)
    80002d78:	4785                	li	a5,1
    80002d7a:	02f70363          	beq	a4,a5,80002da0 <iput+0x48>
  ip->ref--;
    80002d7e:	449c                	lw	a5,8(s1)
    80002d80:	37fd                	addiw	a5,a5,-1
    80002d82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d84:	00015517          	auipc	a0,0x15
    80002d88:	9f450513          	addi	a0,a0,-1548 # 80017778 <itable>
    80002d8c:	00003097          	auipc	ra,0x3
    80002d90:	526080e7          	jalr	1318(ra) # 800062b2 <release>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da0:	40bc                	lw	a5,64(s1)
    80002da2:	dff1                	beqz	a5,80002d7e <iput+0x26>
    80002da4:	04a49783          	lh	a5,74(s1)
    80002da8:	fbf9                	bnez	a5,80002d7e <iput+0x26>
    acquiresleep(&ip->lock);
    80002daa:	01048913          	addi	s2,s1,16
    80002dae:	854a                	mv	a0,s2
    80002db0:	00001097          	auipc	ra,0x1
    80002db4:	ab8080e7          	jalr	-1352(ra) # 80003868 <acquiresleep>
    release(&itable.lock);
    80002db8:	00015517          	auipc	a0,0x15
    80002dbc:	9c050513          	addi	a0,a0,-1600 # 80017778 <itable>
    80002dc0:	00003097          	auipc	ra,0x3
    80002dc4:	4f2080e7          	jalr	1266(ra) # 800062b2 <release>
    itrunc(ip);
    80002dc8:	8526                	mv	a0,s1
    80002dca:	00000097          	auipc	ra,0x0
    80002dce:	ee2080e7          	jalr	-286(ra) # 80002cac <itrunc>
    ip->type = 0;
    80002dd2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dd6:	8526                	mv	a0,s1
    80002dd8:	00000097          	auipc	ra,0x0
    80002ddc:	cfc080e7          	jalr	-772(ra) # 80002ad4 <iupdate>
    ip->valid = 0;
    80002de0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002de4:	854a                	mv	a0,s2
    80002de6:	00001097          	auipc	ra,0x1
    80002dea:	ad8080e7          	jalr	-1320(ra) # 800038be <releasesleep>
    acquire(&itable.lock);
    80002dee:	00015517          	auipc	a0,0x15
    80002df2:	98a50513          	addi	a0,a0,-1654 # 80017778 <itable>
    80002df6:	00003097          	auipc	ra,0x3
    80002dfa:	408080e7          	jalr	1032(ra) # 800061fe <acquire>
    80002dfe:	b741                	j	80002d7e <iput+0x26>

0000000080002e00 <iunlockput>:
{
    80002e00:	1101                	addi	sp,sp,-32
    80002e02:	ec06                	sd	ra,24(sp)
    80002e04:	e822                	sd	s0,16(sp)
    80002e06:	e426                	sd	s1,8(sp)
    80002e08:	1000                	addi	s0,sp,32
    80002e0a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	e54080e7          	jalr	-428(ra) # 80002c60 <iunlock>
  iput(ip);
    80002e14:	8526                	mv	a0,s1
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	f42080e7          	jalr	-190(ra) # 80002d58 <iput>
}
    80002e1e:	60e2                	ld	ra,24(sp)
    80002e20:	6442                	ld	s0,16(sp)
    80002e22:	64a2                	ld	s1,8(sp)
    80002e24:	6105                	addi	sp,sp,32
    80002e26:	8082                	ret

0000000080002e28 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e28:	1141                	addi	sp,sp,-16
    80002e2a:	e422                	sd	s0,8(sp)
    80002e2c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e2e:	411c                	lw	a5,0(a0)
    80002e30:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e32:	415c                	lw	a5,4(a0)
    80002e34:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e36:	04451783          	lh	a5,68(a0)
    80002e3a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e3e:	04a51783          	lh	a5,74(a0)
    80002e42:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e46:	04c56783          	lwu	a5,76(a0)
    80002e4a:	e99c                	sd	a5,16(a1)
}
    80002e4c:	6422                	ld	s0,8(sp)
    80002e4e:	0141                	addi	sp,sp,16
    80002e50:	8082                	ret

0000000080002e52 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e52:	457c                	lw	a5,76(a0)
    80002e54:	0ed7e963          	bltu	a5,a3,80002f46 <readi+0xf4>
{
    80002e58:	7159                	addi	sp,sp,-112
    80002e5a:	f486                	sd	ra,104(sp)
    80002e5c:	f0a2                	sd	s0,96(sp)
    80002e5e:	eca6                	sd	s1,88(sp)
    80002e60:	e8ca                	sd	s2,80(sp)
    80002e62:	e4ce                	sd	s3,72(sp)
    80002e64:	e0d2                	sd	s4,64(sp)
    80002e66:	fc56                	sd	s5,56(sp)
    80002e68:	f85a                	sd	s6,48(sp)
    80002e6a:	f45e                	sd	s7,40(sp)
    80002e6c:	f062                	sd	s8,32(sp)
    80002e6e:	ec66                	sd	s9,24(sp)
    80002e70:	e86a                	sd	s10,16(sp)
    80002e72:	e46e                	sd	s11,8(sp)
    80002e74:	1880                	addi	s0,sp,112
    80002e76:	8baa                	mv	s7,a0
    80002e78:	8c2e                	mv	s8,a1
    80002e7a:	8ab2                	mv	s5,a2
    80002e7c:	84b6                	mv	s1,a3
    80002e7e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e80:	9f35                	addw	a4,a4,a3
    return 0;
    80002e82:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e84:	0ad76063          	bltu	a4,a3,80002f24 <readi+0xd2>
  if(off + n > ip->size)
    80002e88:	00e7f463          	bgeu	a5,a4,80002e90 <readi+0x3e>
    n = ip->size - off;
    80002e8c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e90:	0a0b0963          	beqz	s6,80002f42 <readi+0xf0>
    80002e94:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e96:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e9a:	5cfd                	li	s9,-1
    80002e9c:	a82d                	j	80002ed6 <readi+0x84>
    80002e9e:	020a1d93          	slli	s11,s4,0x20
    80002ea2:	020ddd93          	srli	s11,s11,0x20
    80002ea6:	05890613          	addi	a2,s2,88
    80002eaa:	86ee                	mv	a3,s11
    80002eac:	963a                	add	a2,a2,a4
    80002eae:	85d6                	mv	a1,s5
    80002eb0:	8562                	mv	a0,s8
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	b26080e7          	jalr	-1242(ra) # 800019d8 <either_copyout>
    80002eba:	05950d63          	beq	a0,s9,80002f14 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ebe:	854a                	mv	a0,s2
    80002ec0:	fffff097          	auipc	ra,0xfffff
    80002ec4:	60c080e7          	jalr	1548(ra) # 800024cc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec8:	013a09bb          	addw	s3,s4,s3
    80002ecc:	009a04bb          	addw	s1,s4,s1
    80002ed0:	9aee                	add	s5,s5,s11
    80002ed2:	0569f763          	bgeu	s3,s6,80002f20 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ed6:	000ba903          	lw	s2,0(s7)
    80002eda:	00a4d59b          	srliw	a1,s1,0xa
    80002ede:	855e                	mv	a0,s7
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	8b0080e7          	jalr	-1872(ra) # 80002790 <bmap>
    80002ee8:	0005059b          	sext.w	a1,a0
    80002eec:	854a                	mv	a0,s2
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	4ae080e7          	jalr	1198(ra) # 8000239c <bread>
    80002ef6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef8:	3ff4f713          	andi	a4,s1,1023
    80002efc:	40ed07bb          	subw	a5,s10,a4
    80002f00:	413b06bb          	subw	a3,s6,s3
    80002f04:	8a3e                	mv	s4,a5
    80002f06:	2781                	sext.w	a5,a5
    80002f08:	0006861b          	sext.w	a2,a3
    80002f0c:	f8f679e3          	bgeu	a2,a5,80002e9e <readi+0x4c>
    80002f10:	8a36                	mv	s4,a3
    80002f12:	b771                	j	80002e9e <readi+0x4c>
      brelse(bp);
    80002f14:	854a                	mv	a0,s2
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	5b6080e7          	jalr	1462(ra) # 800024cc <brelse>
      tot = -1;
    80002f1e:	59fd                	li	s3,-1
  }
  return tot;
    80002f20:	0009851b          	sext.w	a0,s3
}
    80002f24:	70a6                	ld	ra,104(sp)
    80002f26:	7406                	ld	s0,96(sp)
    80002f28:	64e6                	ld	s1,88(sp)
    80002f2a:	6946                	ld	s2,80(sp)
    80002f2c:	69a6                	ld	s3,72(sp)
    80002f2e:	6a06                	ld	s4,64(sp)
    80002f30:	7ae2                	ld	s5,56(sp)
    80002f32:	7b42                	ld	s6,48(sp)
    80002f34:	7ba2                	ld	s7,40(sp)
    80002f36:	7c02                	ld	s8,32(sp)
    80002f38:	6ce2                	ld	s9,24(sp)
    80002f3a:	6d42                	ld	s10,16(sp)
    80002f3c:	6da2                	ld	s11,8(sp)
    80002f3e:	6165                	addi	sp,sp,112
    80002f40:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f42:	89da                	mv	s3,s6
    80002f44:	bff1                	j	80002f20 <readi+0xce>
    return 0;
    80002f46:	4501                	li	a0,0
}
    80002f48:	8082                	ret

0000000080002f4a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f4a:	457c                	lw	a5,76(a0)
    80002f4c:	10d7e863          	bltu	a5,a3,8000305c <writei+0x112>
{
    80002f50:	7159                	addi	sp,sp,-112
    80002f52:	f486                	sd	ra,104(sp)
    80002f54:	f0a2                	sd	s0,96(sp)
    80002f56:	eca6                	sd	s1,88(sp)
    80002f58:	e8ca                	sd	s2,80(sp)
    80002f5a:	e4ce                	sd	s3,72(sp)
    80002f5c:	e0d2                	sd	s4,64(sp)
    80002f5e:	fc56                	sd	s5,56(sp)
    80002f60:	f85a                	sd	s6,48(sp)
    80002f62:	f45e                	sd	s7,40(sp)
    80002f64:	f062                	sd	s8,32(sp)
    80002f66:	ec66                	sd	s9,24(sp)
    80002f68:	e86a                	sd	s10,16(sp)
    80002f6a:	e46e                	sd	s11,8(sp)
    80002f6c:	1880                	addi	s0,sp,112
    80002f6e:	8b2a                	mv	s6,a0
    80002f70:	8c2e                	mv	s8,a1
    80002f72:	8ab2                	mv	s5,a2
    80002f74:	8936                	mv	s2,a3
    80002f76:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f78:	00e687bb          	addw	a5,a3,a4
    80002f7c:	0ed7e263          	bltu	a5,a3,80003060 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f80:	00043737          	lui	a4,0x43
    80002f84:	0ef76063          	bltu	a4,a5,80003064 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f88:	0c0b8863          	beqz	s7,80003058 <writei+0x10e>
    80002f8c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f92:	5cfd                	li	s9,-1
    80002f94:	a091                	j	80002fd8 <writei+0x8e>
    80002f96:	02099d93          	slli	s11,s3,0x20
    80002f9a:	020ddd93          	srli	s11,s11,0x20
    80002f9e:	05848513          	addi	a0,s1,88
    80002fa2:	86ee                	mv	a3,s11
    80002fa4:	8656                	mv	a2,s5
    80002fa6:	85e2                	mv	a1,s8
    80002fa8:	953a                	add	a0,a0,a4
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	a84080e7          	jalr	-1404(ra) # 80001a2e <either_copyin>
    80002fb2:	07950263          	beq	a0,s9,80003016 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fb6:	8526                	mv	a0,s1
    80002fb8:	00000097          	auipc	ra,0x0
    80002fbc:	790080e7          	jalr	1936(ra) # 80003748 <log_write>
    brelse(bp);
    80002fc0:	8526                	mv	a0,s1
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	50a080e7          	jalr	1290(ra) # 800024cc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fca:	01498a3b          	addw	s4,s3,s4
    80002fce:	0129893b          	addw	s2,s3,s2
    80002fd2:	9aee                	add	s5,s5,s11
    80002fd4:	057a7663          	bgeu	s4,s7,80003020 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fd8:	000b2483          	lw	s1,0(s6)
    80002fdc:	00a9559b          	srliw	a1,s2,0xa
    80002fe0:	855a                	mv	a0,s6
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	7ae080e7          	jalr	1966(ra) # 80002790 <bmap>
    80002fea:	0005059b          	sext.w	a1,a0
    80002fee:	8526                	mv	a0,s1
    80002ff0:	fffff097          	auipc	ra,0xfffff
    80002ff4:	3ac080e7          	jalr	940(ra) # 8000239c <bread>
    80002ff8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ffa:	3ff97713          	andi	a4,s2,1023
    80002ffe:	40ed07bb          	subw	a5,s10,a4
    80003002:	414b86bb          	subw	a3,s7,s4
    80003006:	89be                	mv	s3,a5
    80003008:	2781                	sext.w	a5,a5
    8000300a:	0006861b          	sext.w	a2,a3
    8000300e:	f8f674e3          	bgeu	a2,a5,80002f96 <writei+0x4c>
    80003012:	89b6                	mv	s3,a3
    80003014:	b749                	j	80002f96 <writei+0x4c>
      brelse(bp);
    80003016:	8526                	mv	a0,s1
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	4b4080e7          	jalr	1204(ra) # 800024cc <brelse>
  }

  if(off > ip->size)
    80003020:	04cb2783          	lw	a5,76(s6)
    80003024:	0127f463          	bgeu	a5,s2,8000302c <writei+0xe2>
    ip->size = off;
    80003028:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000302c:	855a                	mv	a0,s6
    8000302e:	00000097          	auipc	ra,0x0
    80003032:	aa6080e7          	jalr	-1370(ra) # 80002ad4 <iupdate>

  return tot;
    80003036:	000a051b          	sext.w	a0,s4
}
    8000303a:	70a6                	ld	ra,104(sp)
    8000303c:	7406                	ld	s0,96(sp)
    8000303e:	64e6                	ld	s1,88(sp)
    80003040:	6946                	ld	s2,80(sp)
    80003042:	69a6                	ld	s3,72(sp)
    80003044:	6a06                	ld	s4,64(sp)
    80003046:	7ae2                	ld	s5,56(sp)
    80003048:	7b42                	ld	s6,48(sp)
    8000304a:	7ba2                	ld	s7,40(sp)
    8000304c:	7c02                	ld	s8,32(sp)
    8000304e:	6ce2                	ld	s9,24(sp)
    80003050:	6d42                	ld	s10,16(sp)
    80003052:	6da2                	ld	s11,8(sp)
    80003054:	6165                	addi	sp,sp,112
    80003056:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003058:	8a5e                	mv	s4,s7
    8000305a:	bfc9                	j	8000302c <writei+0xe2>
    return -1;
    8000305c:	557d                	li	a0,-1
}
    8000305e:	8082                	ret
    return -1;
    80003060:	557d                	li	a0,-1
    80003062:	bfe1                	j	8000303a <writei+0xf0>
    return -1;
    80003064:	557d                	li	a0,-1
    80003066:	bfd1                	j	8000303a <writei+0xf0>

0000000080003068 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003068:	1141                	addi	sp,sp,-16
    8000306a:	e406                	sd	ra,8(sp)
    8000306c:	e022                	sd	s0,0(sp)
    8000306e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003070:	4639                	li	a2,14
    80003072:	ffffd097          	auipc	ra,0xffffd
    80003076:	1de080e7          	jalr	478(ra) # 80000250 <strncmp>
}
    8000307a:	60a2                	ld	ra,8(sp)
    8000307c:	6402                	ld	s0,0(sp)
    8000307e:	0141                	addi	sp,sp,16
    80003080:	8082                	ret

0000000080003082 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003082:	7139                	addi	sp,sp,-64
    80003084:	fc06                	sd	ra,56(sp)
    80003086:	f822                	sd	s0,48(sp)
    80003088:	f426                	sd	s1,40(sp)
    8000308a:	f04a                	sd	s2,32(sp)
    8000308c:	ec4e                	sd	s3,24(sp)
    8000308e:	e852                	sd	s4,16(sp)
    80003090:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003092:	04451703          	lh	a4,68(a0)
    80003096:	4785                	li	a5,1
    80003098:	00f71a63          	bne	a4,a5,800030ac <dirlookup+0x2a>
    8000309c:	892a                	mv	s2,a0
    8000309e:	89ae                	mv	s3,a1
    800030a0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a2:	457c                	lw	a5,76(a0)
    800030a4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030a6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a8:	e79d                	bnez	a5,800030d6 <dirlookup+0x54>
    800030aa:	a8a5                	j	80003122 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030ac:	00005517          	auipc	a0,0x5
    800030b0:	51c50513          	addi	a0,a0,1308 # 800085c8 <syscalls+0x1a0>
    800030b4:	00003097          	auipc	ra,0x3
    800030b8:	b94080e7          	jalr	-1132(ra) # 80005c48 <panic>
      panic("dirlookup read");
    800030bc:	00005517          	auipc	a0,0x5
    800030c0:	52450513          	addi	a0,a0,1316 # 800085e0 <syscalls+0x1b8>
    800030c4:	00003097          	auipc	ra,0x3
    800030c8:	b84080e7          	jalr	-1148(ra) # 80005c48 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030cc:	24c1                	addiw	s1,s1,16
    800030ce:	04c92783          	lw	a5,76(s2)
    800030d2:	04f4f763          	bgeu	s1,a5,80003120 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030d6:	4741                	li	a4,16
    800030d8:	86a6                	mv	a3,s1
    800030da:	fc040613          	addi	a2,s0,-64
    800030de:	4581                	li	a1,0
    800030e0:	854a                	mv	a0,s2
    800030e2:	00000097          	auipc	ra,0x0
    800030e6:	d70080e7          	jalr	-656(ra) # 80002e52 <readi>
    800030ea:	47c1                	li	a5,16
    800030ec:	fcf518e3          	bne	a0,a5,800030bc <dirlookup+0x3a>
    if(de.inum == 0)
    800030f0:	fc045783          	lhu	a5,-64(s0)
    800030f4:	dfe1                	beqz	a5,800030cc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030f6:	fc240593          	addi	a1,s0,-62
    800030fa:	854e                	mv	a0,s3
    800030fc:	00000097          	auipc	ra,0x0
    80003100:	f6c080e7          	jalr	-148(ra) # 80003068 <namecmp>
    80003104:	f561                	bnez	a0,800030cc <dirlookup+0x4a>
      if(poff)
    80003106:	000a0463          	beqz	s4,8000310e <dirlookup+0x8c>
        *poff = off;
    8000310a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000310e:	fc045583          	lhu	a1,-64(s0)
    80003112:	00092503          	lw	a0,0(s2)
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	754080e7          	jalr	1876(ra) # 8000286a <iget>
    8000311e:	a011                	j	80003122 <dirlookup+0xa0>
  return 0;
    80003120:	4501                	li	a0,0
}
    80003122:	70e2                	ld	ra,56(sp)
    80003124:	7442                	ld	s0,48(sp)
    80003126:	74a2                	ld	s1,40(sp)
    80003128:	7902                	ld	s2,32(sp)
    8000312a:	69e2                	ld	s3,24(sp)
    8000312c:	6a42                	ld	s4,16(sp)
    8000312e:	6121                	addi	sp,sp,64
    80003130:	8082                	ret

0000000080003132 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003132:	711d                	addi	sp,sp,-96
    80003134:	ec86                	sd	ra,88(sp)
    80003136:	e8a2                	sd	s0,80(sp)
    80003138:	e4a6                	sd	s1,72(sp)
    8000313a:	e0ca                	sd	s2,64(sp)
    8000313c:	fc4e                	sd	s3,56(sp)
    8000313e:	f852                	sd	s4,48(sp)
    80003140:	f456                	sd	s5,40(sp)
    80003142:	f05a                	sd	s6,32(sp)
    80003144:	ec5e                	sd	s7,24(sp)
    80003146:	e862                	sd	s8,16(sp)
    80003148:	e466                	sd	s9,8(sp)
    8000314a:	1080                	addi	s0,sp,96
    8000314c:	84aa                	mv	s1,a0
    8000314e:	8b2e                	mv	s6,a1
    80003150:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003152:	00054703          	lbu	a4,0(a0)
    80003156:	02f00793          	li	a5,47
    8000315a:	02f70363          	beq	a4,a5,80003180 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000315e:	ffffe097          	auipc	ra,0xffffe
    80003162:	e1a080e7          	jalr	-486(ra) # 80000f78 <myproc>
    80003166:	15853503          	ld	a0,344(a0)
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	9f6080e7          	jalr	-1546(ra) # 80002b60 <idup>
    80003172:	89aa                	mv	s3,a0
  while(*path == '/')
    80003174:	02f00913          	li	s2,47
  len = path - s;
    80003178:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000317a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000317c:	4c05                	li	s8,1
    8000317e:	a865                	j	80003236 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003180:	4585                	li	a1,1
    80003182:	4505                	li	a0,1
    80003184:	fffff097          	auipc	ra,0xfffff
    80003188:	6e6080e7          	jalr	1766(ra) # 8000286a <iget>
    8000318c:	89aa                	mv	s3,a0
    8000318e:	b7dd                	j	80003174 <namex+0x42>
      iunlockput(ip);
    80003190:	854e                	mv	a0,s3
    80003192:	00000097          	auipc	ra,0x0
    80003196:	c6e080e7          	jalr	-914(ra) # 80002e00 <iunlockput>
      return 0;
    8000319a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000319c:	854e                	mv	a0,s3
    8000319e:	60e6                	ld	ra,88(sp)
    800031a0:	6446                	ld	s0,80(sp)
    800031a2:	64a6                	ld	s1,72(sp)
    800031a4:	6906                	ld	s2,64(sp)
    800031a6:	79e2                	ld	s3,56(sp)
    800031a8:	7a42                	ld	s4,48(sp)
    800031aa:	7aa2                	ld	s5,40(sp)
    800031ac:	7b02                	ld	s6,32(sp)
    800031ae:	6be2                	ld	s7,24(sp)
    800031b0:	6c42                	ld	s8,16(sp)
    800031b2:	6ca2                	ld	s9,8(sp)
    800031b4:	6125                	addi	sp,sp,96
    800031b6:	8082                	ret
      iunlock(ip);
    800031b8:	854e                	mv	a0,s3
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	aa6080e7          	jalr	-1370(ra) # 80002c60 <iunlock>
      return ip;
    800031c2:	bfe9                	j	8000319c <namex+0x6a>
      iunlockput(ip);
    800031c4:	854e                	mv	a0,s3
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	c3a080e7          	jalr	-966(ra) # 80002e00 <iunlockput>
      return 0;
    800031ce:	89d2                	mv	s3,s4
    800031d0:	b7f1                	j	8000319c <namex+0x6a>
  len = path - s;
    800031d2:	40b48633          	sub	a2,s1,a1
    800031d6:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031da:	094cd463          	bge	s9,s4,80003262 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031de:	4639                	li	a2,14
    800031e0:	8556                	mv	a0,s5
    800031e2:	ffffd097          	auipc	ra,0xffffd
    800031e6:	ff6080e7          	jalr	-10(ra) # 800001d8 <memmove>
  while(*path == '/')
    800031ea:	0004c783          	lbu	a5,0(s1)
    800031ee:	01279763          	bne	a5,s2,800031fc <namex+0xca>
    path++;
    800031f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031f4:	0004c783          	lbu	a5,0(s1)
    800031f8:	ff278de3          	beq	a5,s2,800031f2 <namex+0xc0>
    ilock(ip);
    800031fc:	854e                	mv	a0,s3
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	9a0080e7          	jalr	-1632(ra) # 80002b9e <ilock>
    if(ip->type != T_DIR){
    80003206:	04499783          	lh	a5,68(s3)
    8000320a:	f98793e3          	bne	a5,s8,80003190 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000320e:	000b0563          	beqz	s6,80003218 <namex+0xe6>
    80003212:	0004c783          	lbu	a5,0(s1)
    80003216:	d3cd                	beqz	a5,800031b8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003218:	865e                	mv	a2,s7
    8000321a:	85d6                	mv	a1,s5
    8000321c:	854e                	mv	a0,s3
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	e64080e7          	jalr	-412(ra) # 80003082 <dirlookup>
    80003226:	8a2a                	mv	s4,a0
    80003228:	dd51                	beqz	a0,800031c4 <namex+0x92>
    iunlockput(ip);
    8000322a:	854e                	mv	a0,s3
    8000322c:	00000097          	auipc	ra,0x0
    80003230:	bd4080e7          	jalr	-1068(ra) # 80002e00 <iunlockput>
    ip = next;
    80003234:	89d2                	mv	s3,s4
  while(*path == '/')
    80003236:	0004c783          	lbu	a5,0(s1)
    8000323a:	05279763          	bne	a5,s2,80003288 <namex+0x156>
    path++;
    8000323e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003240:	0004c783          	lbu	a5,0(s1)
    80003244:	ff278de3          	beq	a5,s2,8000323e <namex+0x10c>
  if(*path == 0)
    80003248:	c79d                	beqz	a5,80003276 <namex+0x144>
    path++;
    8000324a:	85a6                	mv	a1,s1
  len = path - s;
    8000324c:	8a5e                	mv	s4,s7
    8000324e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003250:	01278963          	beq	a5,s2,80003262 <namex+0x130>
    80003254:	dfbd                	beqz	a5,800031d2 <namex+0xa0>
    path++;
    80003256:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003258:	0004c783          	lbu	a5,0(s1)
    8000325c:	ff279ce3          	bne	a5,s2,80003254 <namex+0x122>
    80003260:	bf8d                	j	800031d2 <namex+0xa0>
    memmove(name, s, len);
    80003262:	2601                	sext.w	a2,a2
    80003264:	8556                	mv	a0,s5
    80003266:	ffffd097          	auipc	ra,0xffffd
    8000326a:	f72080e7          	jalr	-142(ra) # 800001d8 <memmove>
    name[len] = 0;
    8000326e:	9a56                	add	s4,s4,s5
    80003270:	000a0023          	sb	zero,0(s4)
    80003274:	bf9d                	j	800031ea <namex+0xb8>
  if(nameiparent){
    80003276:	f20b03e3          	beqz	s6,8000319c <namex+0x6a>
    iput(ip);
    8000327a:	854e                	mv	a0,s3
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	adc080e7          	jalr	-1316(ra) # 80002d58 <iput>
    return 0;
    80003284:	4981                	li	s3,0
    80003286:	bf19                	j	8000319c <namex+0x6a>
  if(*path == 0)
    80003288:	d7fd                	beqz	a5,80003276 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	85a6                	mv	a1,s1
    80003290:	b7d1                	j	80003254 <namex+0x122>

0000000080003292 <dirlink>:
{
    80003292:	7139                	addi	sp,sp,-64
    80003294:	fc06                	sd	ra,56(sp)
    80003296:	f822                	sd	s0,48(sp)
    80003298:	f426                	sd	s1,40(sp)
    8000329a:	f04a                	sd	s2,32(sp)
    8000329c:	ec4e                	sd	s3,24(sp)
    8000329e:	e852                	sd	s4,16(sp)
    800032a0:	0080                	addi	s0,sp,64
    800032a2:	892a                	mv	s2,a0
    800032a4:	8a2e                	mv	s4,a1
    800032a6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032a8:	4601                	li	a2,0
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	dd8080e7          	jalr	-552(ra) # 80003082 <dirlookup>
    800032b2:	e93d                	bnez	a0,80003328 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032b4:	04c92483          	lw	s1,76(s2)
    800032b8:	c49d                	beqz	s1,800032e6 <dirlink+0x54>
    800032ba:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032bc:	4741                	li	a4,16
    800032be:	86a6                	mv	a3,s1
    800032c0:	fc040613          	addi	a2,s0,-64
    800032c4:	4581                	li	a1,0
    800032c6:	854a                	mv	a0,s2
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	b8a080e7          	jalr	-1142(ra) # 80002e52 <readi>
    800032d0:	47c1                	li	a5,16
    800032d2:	06f51163          	bne	a0,a5,80003334 <dirlink+0xa2>
    if(de.inum == 0)
    800032d6:	fc045783          	lhu	a5,-64(s0)
    800032da:	c791                	beqz	a5,800032e6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032dc:	24c1                	addiw	s1,s1,16
    800032de:	04c92783          	lw	a5,76(s2)
    800032e2:	fcf4ede3          	bltu	s1,a5,800032bc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032e6:	4639                	li	a2,14
    800032e8:	85d2                	mv	a1,s4
    800032ea:	fc240513          	addi	a0,s0,-62
    800032ee:	ffffd097          	auipc	ra,0xffffd
    800032f2:	f9e080e7          	jalr	-98(ra) # 8000028c <strncpy>
  de.inum = inum;
    800032f6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032fa:	4741                	li	a4,16
    800032fc:	86a6                	mv	a3,s1
    800032fe:	fc040613          	addi	a2,s0,-64
    80003302:	4581                	li	a1,0
    80003304:	854a                	mv	a0,s2
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	c44080e7          	jalr	-956(ra) # 80002f4a <writei>
    8000330e:	872a                	mv	a4,a0
    80003310:	47c1                	li	a5,16
  return 0;
    80003312:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003314:	02f71863          	bne	a4,a5,80003344 <dirlink+0xb2>
}
    80003318:	70e2                	ld	ra,56(sp)
    8000331a:	7442                	ld	s0,48(sp)
    8000331c:	74a2                	ld	s1,40(sp)
    8000331e:	7902                	ld	s2,32(sp)
    80003320:	69e2                	ld	s3,24(sp)
    80003322:	6a42                	ld	s4,16(sp)
    80003324:	6121                	addi	sp,sp,64
    80003326:	8082                	ret
    iput(ip);
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	a30080e7          	jalr	-1488(ra) # 80002d58 <iput>
    return -1;
    80003330:	557d                	li	a0,-1
    80003332:	b7dd                	j	80003318 <dirlink+0x86>
      panic("dirlink read");
    80003334:	00005517          	auipc	a0,0x5
    80003338:	2bc50513          	addi	a0,a0,700 # 800085f0 <syscalls+0x1c8>
    8000333c:	00003097          	auipc	ra,0x3
    80003340:	90c080e7          	jalr	-1780(ra) # 80005c48 <panic>
    panic("dirlink");
    80003344:	00005517          	auipc	a0,0x5
    80003348:	3bc50513          	addi	a0,a0,956 # 80008700 <syscalls+0x2d8>
    8000334c:	00003097          	auipc	ra,0x3
    80003350:	8fc080e7          	jalr	-1796(ra) # 80005c48 <panic>

0000000080003354 <namei>:

struct inode*
namei(char *path)
{
    80003354:	1101                	addi	sp,sp,-32
    80003356:	ec06                	sd	ra,24(sp)
    80003358:	e822                	sd	s0,16(sp)
    8000335a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000335c:	fe040613          	addi	a2,s0,-32
    80003360:	4581                	li	a1,0
    80003362:	00000097          	auipc	ra,0x0
    80003366:	dd0080e7          	jalr	-560(ra) # 80003132 <namex>
}
    8000336a:	60e2                	ld	ra,24(sp)
    8000336c:	6442                	ld	s0,16(sp)
    8000336e:	6105                	addi	sp,sp,32
    80003370:	8082                	ret

0000000080003372 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003372:	1141                	addi	sp,sp,-16
    80003374:	e406                	sd	ra,8(sp)
    80003376:	e022                	sd	s0,0(sp)
    80003378:	0800                	addi	s0,sp,16
    8000337a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000337c:	4585                	li	a1,1
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	db4080e7          	jalr	-588(ra) # 80003132 <namex>
}
    80003386:	60a2                	ld	ra,8(sp)
    80003388:	6402                	ld	s0,0(sp)
    8000338a:	0141                	addi	sp,sp,16
    8000338c:	8082                	ret

000000008000338e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000338e:	1101                	addi	sp,sp,-32
    80003390:	ec06                	sd	ra,24(sp)
    80003392:	e822                	sd	s0,16(sp)
    80003394:	e426                	sd	s1,8(sp)
    80003396:	e04a                	sd	s2,0(sp)
    80003398:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000339a:	00016917          	auipc	s2,0x16
    8000339e:	e8690913          	addi	s2,s2,-378 # 80019220 <log>
    800033a2:	01892583          	lw	a1,24(s2)
    800033a6:	02892503          	lw	a0,40(s2)
    800033aa:	fffff097          	auipc	ra,0xfffff
    800033ae:	ff2080e7          	jalr	-14(ra) # 8000239c <bread>
    800033b2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033b4:	02c92683          	lw	a3,44(s2)
    800033b8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033ba:	02d05763          	blez	a3,800033e8 <write_head+0x5a>
    800033be:	00016797          	auipc	a5,0x16
    800033c2:	e9278793          	addi	a5,a5,-366 # 80019250 <log+0x30>
    800033c6:	05c50713          	addi	a4,a0,92
    800033ca:	36fd                	addiw	a3,a3,-1
    800033cc:	1682                	slli	a3,a3,0x20
    800033ce:	9281                	srli	a3,a3,0x20
    800033d0:	068a                	slli	a3,a3,0x2
    800033d2:	00016617          	auipc	a2,0x16
    800033d6:	e8260613          	addi	a2,a2,-382 # 80019254 <log+0x34>
    800033da:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033dc:	4390                	lw	a2,0(a5)
    800033de:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033e0:	0791                	addi	a5,a5,4
    800033e2:	0711                	addi	a4,a4,4
    800033e4:	fed79ce3          	bne	a5,a3,800033dc <write_head+0x4e>
  }
  bwrite(buf);
    800033e8:	8526                	mv	a0,s1
    800033ea:	fffff097          	auipc	ra,0xfffff
    800033ee:	0a4080e7          	jalr	164(ra) # 8000248e <bwrite>
  brelse(buf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	0d8080e7          	jalr	216(ra) # 800024cc <brelse>
}
    800033fc:	60e2                	ld	ra,24(sp)
    800033fe:	6442                	ld	s0,16(sp)
    80003400:	64a2                	ld	s1,8(sp)
    80003402:	6902                	ld	s2,0(sp)
    80003404:	6105                	addi	sp,sp,32
    80003406:	8082                	ret

0000000080003408 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003408:	00016797          	auipc	a5,0x16
    8000340c:	e447a783          	lw	a5,-444(a5) # 8001924c <log+0x2c>
    80003410:	0af05d63          	blez	a5,800034ca <install_trans+0xc2>
{
    80003414:	7139                	addi	sp,sp,-64
    80003416:	fc06                	sd	ra,56(sp)
    80003418:	f822                	sd	s0,48(sp)
    8000341a:	f426                	sd	s1,40(sp)
    8000341c:	f04a                	sd	s2,32(sp)
    8000341e:	ec4e                	sd	s3,24(sp)
    80003420:	e852                	sd	s4,16(sp)
    80003422:	e456                	sd	s5,8(sp)
    80003424:	e05a                	sd	s6,0(sp)
    80003426:	0080                	addi	s0,sp,64
    80003428:	8b2a                	mv	s6,a0
    8000342a:	00016a97          	auipc	s5,0x16
    8000342e:	e26a8a93          	addi	s5,s5,-474 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003432:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003434:	00016997          	auipc	s3,0x16
    80003438:	dec98993          	addi	s3,s3,-532 # 80019220 <log>
    8000343c:	a035                	j	80003468 <install_trans+0x60>
      bunpin(dbuf);
    8000343e:	8526                	mv	a0,s1
    80003440:	fffff097          	auipc	ra,0xfffff
    80003444:	166080e7          	jalr	358(ra) # 800025a6 <bunpin>
    brelse(lbuf);
    80003448:	854a                	mv	a0,s2
    8000344a:	fffff097          	auipc	ra,0xfffff
    8000344e:	082080e7          	jalr	130(ra) # 800024cc <brelse>
    brelse(dbuf);
    80003452:	8526                	mv	a0,s1
    80003454:	fffff097          	auipc	ra,0xfffff
    80003458:	078080e7          	jalr	120(ra) # 800024cc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345c:	2a05                	addiw	s4,s4,1
    8000345e:	0a91                	addi	s5,s5,4
    80003460:	02c9a783          	lw	a5,44(s3)
    80003464:	04fa5963          	bge	s4,a5,800034b6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003468:	0189a583          	lw	a1,24(s3)
    8000346c:	014585bb          	addw	a1,a1,s4
    80003470:	2585                	addiw	a1,a1,1
    80003472:	0289a503          	lw	a0,40(s3)
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	f26080e7          	jalr	-218(ra) # 8000239c <bread>
    8000347e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003480:	000aa583          	lw	a1,0(s5)
    80003484:	0289a503          	lw	a0,40(s3)
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	f14080e7          	jalr	-236(ra) # 8000239c <bread>
    80003490:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003492:	40000613          	li	a2,1024
    80003496:	05890593          	addi	a1,s2,88
    8000349a:	05850513          	addi	a0,a0,88
    8000349e:	ffffd097          	auipc	ra,0xffffd
    800034a2:	d3a080e7          	jalr	-710(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034a6:	8526                	mv	a0,s1
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	fe6080e7          	jalr	-26(ra) # 8000248e <bwrite>
    if(recovering == 0)
    800034b0:	f80b1ce3          	bnez	s6,80003448 <install_trans+0x40>
    800034b4:	b769                	j	8000343e <install_trans+0x36>
}
    800034b6:	70e2                	ld	ra,56(sp)
    800034b8:	7442                	ld	s0,48(sp)
    800034ba:	74a2                	ld	s1,40(sp)
    800034bc:	7902                	ld	s2,32(sp)
    800034be:	69e2                	ld	s3,24(sp)
    800034c0:	6a42                	ld	s4,16(sp)
    800034c2:	6aa2                	ld	s5,8(sp)
    800034c4:	6b02                	ld	s6,0(sp)
    800034c6:	6121                	addi	sp,sp,64
    800034c8:	8082                	ret
    800034ca:	8082                	ret

00000000800034cc <initlog>:
{
    800034cc:	7179                	addi	sp,sp,-48
    800034ce:	f406                	sd	ra,40(sp)
    800034d0:	f022                	sd	s0,32(sp)
    800034d2:	ec26                	sd	s1,24(sp)
    800034d4:	e84a                	sd	s2,16(sp)
    800034d6:	e44e                	sd	s3,8(sp)
    800034d8:	1800                	addi	s0,sp,48
    800034da:	892a                	mv	s2,a0
    800034dc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034de:	00016497          	auipc	s1,0x16
    800034e2:	d4248493          	addi	s1,s1,-702 # 80019220 <log>
    800034e6:	00005597          	auipc	a1,0x5
    800034ea:	11a58593          	addi	a1,a1,282 # 80008600 <syscalls+0x1d8>
    800034ee:	8526                	mv	a0,s1
    800034f0:	00003097          	auipc	ra,0x3
    800034f4:	c7e080e7          	jalr	-898(ra) # 8000616e <initlock>
  log.start = sb->logstart;
    800034f8:	0149a583          	lw	a1,20(s3)
    800034fc:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034fe:	0109a783          	lw	a5,16(s3)
    80003502:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003504:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003508:	854a                	mv	a0,s2
    8000350a:	fffff097          	auipc	ra,0xfffff
    8000350e:	e92080e7          	jalr	-366(ra) # 8000239c <bread>
  log.lh.n = lh->n;
    80003512:	4d3c                	lw	a5,88(a0)
    80003514:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003516:	02f05563          	blez	a5,80003540 <initlog+0x74>
    8000351a:	05c50713          	addi	a4,a0,92
    8000351e:	00016697          	auipc	a3,0x16
    80003522:	d3268693          	addi	a3,a3,-718 # 80019250 <log+0x30>
    80003526:	37fd                	addiw	a5,a5,-1
    80003528:	1782                	slli	a5,a5,0x20
    8000352a:	9381                	srli	a5,a5,0x20
    8000352c:	078a                	slli	a5,a5,0x2
    8000352e:	06050613          	addi	a2,a0,96
    80003532:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003534:	4310                	lw	a2,0(a4)
    80003536:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003538:	0711                	addi	a4,a4,4
    8000353a:	0691                	addi	a3,a3,4
    8000353c:	fef71ce3          	bne	a4,a5,80003534 <initlog+0x68>
  brelse(buf);
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	f8c080e7          	jalr	-116(ra) # 800024cc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003548:	4505                	li	a0,1
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	ebe080e7          	jalr	-322(ra) # 80003408 <install_trans>
  log.lh.n = 0;
    80003552:	00016797          	auipc	a5,0x16
    80003556:	ce07ad23          	sw	zero,-774(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	e34080e7          	jalr	-460(ra) # 8000338e <write_head>
}
    80003562:	70a2                	ld	ra,40(sp)
    80003564:	7402                	ld	s0,32(sp)
    80003566:	64e2                	ld	s1,24(sp)
    80003568:	6942                	ld	s2,16(sp)
    8000356a:	69a2                	ld	s3,8(sp)
    8000356c:	6145                	addi	sp,sp,48
    8000356e:	8082                	ret

0000000080003570 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003570:	1101                	addi	sp,sp,-32
    80003572:	ec06                	sd	ra,24(sp)
    80003574:	e822                	sd	s0,16(sp)
    80003576:	e426                	sd	s1,8(sp)
    80003578:	e04a                	sd	s2,0(sp)
    8000357a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000357c:	00016517          	auipc	a0,0x16
    80003580:	ca450513          	addi	a0,a0,-860 # 80019220 <log>
    80003584:	00003097          	auipc	ra,0x3
    80003588:	c7a080e7          	jalr	-902(ra) # 800061fe <acquire>
  while(1){
    if(log.committing){
    8000358c:	00016497          	auipc	s1,0x16
    80003590:	c9448493          	addi	s1,s1,-876 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003594:	4979                	li	s2,30
    80003596:	a039                	j	800035a4 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003598:	85a6                	mv	a1,s1
    8000359a:	8526                	mv	a0,s1
    8000359c:	ffffe097          	auipc	ra,0xffffe
    800035a0:	098080e7          	jalr	152(ra) # 80001634 <sleep>
    if(log.committing){
    800035a4:	50dc                	lw	a5,36(s1)
    800035a6:	fbed                	bnez	a5,80003598 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035a8:	509c                	lw	a5,32(s1)
    800035aa:	0017871b          	addiw	a4,a5,1
    800035ae:	0007069b          	sext.w	a3,a4
    800035b2:	0027179b          	slliw	a5,a4,0x2
    800035b6:	9fb9                	addw	a5,a5,a4
    800035b8:	0017979b          	slliw	a5,a5,0x1
    800035bc:	54d8                	lw	a4,44(s1)
    800035be:	9fb9                	addw	a5,a5,a4
    800035c0:	00f95963          	bge	s2,a5,800035d2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035c4:	85a6                	mv	a1,s1
    800035c6:	8526                	mv	a0,s1
    800035c8:	ffffe097          	auipc	ra,0xffffe
    800035cc:	06c080e7          	jalr	108(ra) # 80001634 <sleep>
    800035d0:	bfd1                	j	800035a4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035d2:	00016517          	auipc	a0,0x16
    800035d6:	c4e50513          	addi	a0,a0,-946 # 80019220 <log>
    800035da:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035dc:	00003097          	auipc	ra,0x3
    800035e0:	cd6080e7          	jalr	-810(ra) # 800062b2 <release>
      break;
    }
  }
}
    800035e4:	60e2                	ld	ra,24(sp)
    800035e6:	6442                	ld	s0,16(sp)
    800035e8:	64a2                	ld	s1,8(sp)
    800035ea:	6902                	ld	s2,0(sp)
    800035ec:	6105                	addi	sp,sp,32
    800035ee:	8082                	ret

00000000800035f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035f0:	7139                	addi	sp,sp,-64
    800035f2:	fc06                	sd	ra,56(sp)
    800035f4:	f822                	sd	s0,48(sp)
    800035f6:	f426                	sd	s1,40(sp)
    800035f8:	f04a                	sd	s2,32(sp)
    800035fa:	ec4e                	sd	s3,24(sp)
    800035fc:	e852                	sd	s4,16(sp)
    800035fe:	e456                	sd	s5,8(sp)
    80003600:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003602:	00016497          	auipc	s1,0x16
    80003606:	c1e48493          	addi	s1,s1,-994 # 80019220 <log>
    8000360a:	8526                	mv	a0,s1
    8000360c:	00003097          	auipc	ra,0x3
    80003610:	bf2080e7          	jalr	-1038(ra) # 800061fe <acquire>
  log.outstanding -= 1;
    80003614:	509c                	lw	a5,32(s1)
    80003616:	37fd                	addiw	a5,a5,-1
    80003618:	0007891b          	sext.w	s2,a5
    8000361c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000361e:	50dc                	lw	a5,36(s1)
    80003620:	efb9                	bnez	a5,8000367e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003622:	06091663          	bnez	s2,8000368e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003626:	00016497          	auipc	s1,0x16
    8000362a:	bfa48493          	addi	s1,s1,-1030 # 80019220 <log>
    8000362e:	4785                	li	a5,1
    80003630:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003632:	8526                	mv	a0,s1
    80003634:	00003097          	auipc	ra,0x3
    80003638:	c7e080e7          	jalr	-898(ra) # 800062b2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000363c:	54dc                	lw	a5,44(s1)
    8000363e:	06f04763          	bgtz	a5,800036ac <end_op+0xbc>
    acquire(&log.lock);
    80003642:	00016497          	auipc	s1,0x16
    80003646:	bde48493          	addi	s1,s1,-1058 # 80019220 <log>
    8000364a:	8526                	mv	a0,s1
    8000364c:	00003097          	auipc	ra,0x3
    80003650:	bb2080e7          	jalr	-1102(ra) # 800061fe <acquire>
    log.committing = 0;
    80003654:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003658:	8526                	mv	a0,s1
    8000365a:	ffffe097          	auipc	ra,0xffffe
    8000365e:	166080e7          	jalr	358(ra) # 800017c0 <wakeup>
    release(&log.lock);
    80003662:	8526                	mv	a0,s1
    80003664:	00003097          	auipc	ra,0x3
    80003668:	c4e080e7          	jalr	-946(ra) # 800062b2 <release>
}
    8000366c:	70e2                	ld	ra,56(sp)
    8000366e:	7442                	ld	s0,48(sp)
    80003670:	74a2                	ld	s1,40(sp)
    80003672:	7902                	ld	s2,32(sp)
    80003674:	69e2                	ld	s3,24(sp)
    80003676:	6a42                	ld	s4,16(sp)
    80003678:	6aa2                	ld	s5,8(sp)
    8000367a:	6121                	addi	sp,sp,64
    8000367c:	8082                	ret
    panic("log.committing");
    8000367e:	00005517          	auipc	a0,0x5
    80003682:	f8a50513          	addi	a0,a0,-118 # 80008608 <syscalls+0x1e0>
    80003686:	00002097          	auipc	ra,0x2
    8000368a:	5c2080e7          	jalr	1474(ra) # 80005c48 <panic>
    wakeup(&log);
    8000368e:	00016497          	auipc	s1,0x16
    80003692:	b9248493          	addi	s1,s1,-1134 # 80019220 <log>
    80003696:	8526                	mv	a0,s1
    80003698:	ffffe097          	auipc	ra,0xffffe
    8000369c:	128080e7          	jalr	296(ra) # 800017c0 <wakeup>
  release(&log.lock);
    800036a0:	8526                	mv	a0,s1
    800036a2:	00003097          	auipc	ra,0x3
    800036a6:	c10080e7          	jalr	-1008(ra) # 800062b2 <release>
  if(do_commit){
    800036aa:	b7c9                	j	8000366c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ac:	00016a97          	auipc	s5,0x16
    800036b0:	ba4a8a93          	addi	s5,s5,-1116 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036b4:	00016a17          	auipc	s4,0x16
    800036b8:	b6ca0a13          	addi	s4,s4,-1172 # 80019220 <log>
    800036bc:	018a2583          	lw	a1,24(s4)
    800036c0:	012585bb          	addw	a1,a1,s2
    800036c4:	2585                	addiw	a1,a1,1
    800036c6:	028a2503          	lw	a0,40(s4)
    800036ca:	fffff097          	auipc	ra,0xfffff
    800036ce:	cd2080e7          	jalr	-814(ra) # 8000239c <bread>
    800036d2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036d4:	000aa583          	lw	a1,0(s5)
    800036d8:	028a2503          	lw	a0,40(s4)
    800036dc:	fffff097          	auipc	ra,0xfffff
    800036e0:	cc0080e7          	jalr	-832(ra) # 8000239c <bread>
    800036e4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036e6:	40000613          	li	a2,1024
    800036ea:	05850593          	addi	a1,a0,88
    800036ee:	05848513          	addi	a0,s1,88
    800036f2:	ffffd097          	auipc	ra,0xffffd
    800036f6:	ae6080e7          	jalr	-1306(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036fa:	8526                	mv	a0,s1
    800036fc:	fffff097          	auipc	ra,0xfffff
    80003700:	d92080e7          	jalr	-622(ra) # 8000248e <bwrite>
    brelse(from);
    80003704:	854e                	mv	a0,s3
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	dc6080e7          	jalr	-570(ra) # 800024cc <brelse>
    brelse(to);
    8000370e:	8526                	mv	a0,s1
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	dbc080e7          	jalr	-580(ra) # 800024cc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003718:	2905                	addiw	s2,s2,1
    8000371a:	0a91                	addi	s5,s5,4
    8000371c:	02ca2783          	lw	a5,44(s4)
    80003720:	f8f94ee3          	blt	s2,a5,800036bc <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003724:	00000097          	auipc	ra,0x0
    80003728:	c6a080e7          	jalr	-918(ra) # 8000338e <write_head>
    install_trans(0); // Now install writes to home locations
    8000372c:	4501                	li	a0,0
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	cda080e7          	jalr	-806(ra) # 80003408 <install_trans>
    log.lh.n = 0;
    80003736:	00016797          	auipc	a5,0x16
    8000373a:	b007ab23          	sw	zero,-1258(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000373e:	00000097          	auipc	ra,0x0
    80003742:	c50080e7          	jalr	-944(ra) # 8000338e <write_head>
    80003746:	bdf5                	j	80003642 <end_op+0x52>

0000000080003748 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003748:	1101                	addi	sp,sp,-32
    8000374a:	ec06                	sd	ra,24(sp)
    8000374c:	e822                	sd	s0,16(sp)
    8000374e:	e426                	sd	s1,8(sp)
    80003750:	e04a                	sd	s2,0(sp)
    80003752:	1000                	addi	s0,sp,32
    80003754:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003756:	00016917          	auipc	s2,0x16
    8000375a:	aca90913          	addi	s2,s2,-1334 # 80019220 <log>
    8000375e:	854a                	mv	a0,s2
    80003760:	00003097          	auipc	ra,0x3
    80003764:	a9e080e7          	jalr	-1378(ra) # 800061fe <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003768:	02c92603          	lw	a2,44(s2)
    8000376c:	47f5                	li	a5,29
    8000376e:	06c7c563          	blt	a5,a2,800037d8 <log_write+0x90>
    80003772:	00016797          	auipc	a5,0x16
    80003776:	aca7a783          	lw	a5,-1334(a5) # 8001923c <log+0x1c>
    8000377a:	37fd                	addiw	a5,a5,-1
    8000377c:	04f65e63          	bge	a2,a5,800037d8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003780:	00016797          	auipc	a5,0x16
    80003784:	ac07a783          	lw	a5,-1344(a5) # 80019240 <log+0x20>
    80003788:	06f05063          	blez	a5,800037e8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000378c:	4781                	li	a5,0
    8000378e:	06c05563          	blez	a2,800037f8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003792:	44cc                	lw	a1,12(s1)
    80003794:	00016717          	auipc	a4,0x16
    80003798:	abc70713          	addi	a4,a4,-1348 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000379c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000379e:	4314                	lw	a3,0(a4)
    800037a0:	04b68c63          	beq	a3,a1,800037f8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037a4:	2785                	addiw	a5,a5,1
    800037a6:	0711                	addi	a4,a4,4
    800037a8:	fef61be3          	bne	a2,a5,8000379e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037ac:	0621                	addi	a2,a2,8
    800037ae:	060a                	slli	a2,a2,0x2
    800037b0:	00016797          	auipc	a5,0x16
    800037b4:	a7078793          	addi	a5,a5,-1424 # 80019220 <log>
    800037b8:	963e                	add	a2,a2,a5
    800037ba:	44dc                	lw	a5,12(s1)
    800037bc:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037be:	8526                	mv	a0,s1
    800037c0:	fffff097          	auipc	ra,0xfffff
    800037c4:	daa080e7          	jalr	-598(ra) # 8000256a <bpin>
    log.lh.n++;
    800037c8:	00016717          	auipc	a4,0x16
    800037cc:	a5870713          	addi	a4,a4,-1448 # 80019220 <log>
    800037d0:	575c                	lw	a5,44(a4)
    800037d2:	2785                	addiw	a5,a5,1
    800037d4:	d75c                	sw	a5,44(a4)
    800037d6:	a835                	j	80003812 <log_write+0xca>
    panic("too big a transaction");
    800037d8:	00005517          	auipc	a0,0x5
    800037dc:	e4050513          	addi	a0,a0,-448 # 80008618 <syscalls+0x1f0>
    800037e0:	00002097          	auipc	ra,0x2
    800037e4:	468080e7          	jalr	1128(ra) # 80005c48 <panic>
    panic("log_write outside of trans");
    800037e8:	00005517          	auipc	a0,0x5
    800037ec:	e4850513          	addi	a0,a0,-440 # 80008630 <syscalls+0x208>
    800037f0:	00002097          	auipc	ra,0x2
    800037f4:	458080e7          	jalr	1112(ra) # 80005c48 <panic>
  log.lh.block[i] = b->blockno;
    800037f8:	00878713          	addi	a4,a5,8
    800037fc:	00271693          	slli	a3,a4,0x2
    80003800:	00016717          	auipc	a4,0x16
    80003804:	a2070713          	addi	a4,a4,-1504 # 80019220 <log>
    80003808:	9736                	add	a4,a4,a3
    8000380a:	44d4                	lw	a3,12(s1)
    8000380c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000380e:	faf608e3          	beq	a2,a5,800037be <log_write+0x76>
  }
  release(&log.lock);
    80003812:	00016517          	auipc	a0,0x16
    80003816:	a0e50513          	addi	a0,a0,-1522 # 80019220 <log>
    8000381a:	00003097          	auipc	ra,0x3
    8000381e:	a98080e7          	jalr	-1384(ra) # 800062b2 <release>
}
    80003822:	60e2                	ld	ra,24(sp)
    80003824:	6442                	ld	s0,16(sp)
    80003826:	64a2                	ld	s1,8(sp)
    80003828:	6902                	ld	s2,0(sp)
    8000382a:	6105                	addi	sp,sp,32
    8000382c:	8082                	ret

000000008000382e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000382e:	1101                	addi	sp,sp,-32
    80003830:	ec06                	sd	ra,24(sp)
    80003832:	e822                	sd	s0,16(sp)
    80003834:	e426                	sd	s1,8(sp)
    80003836:	e04a                	sd	s2,0(sp)
    80003838:	1000                	addi	s0,sp,32
    8000383a:	84aa                	mv	s1,a0
    8000383c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000383e:	00005597          	auipc	a1,0x5
    80003842:	e1258593          	addi	a1,a1,-494 # 80008650 <syscalls+0x228>
    80003846:	0521                	addi	a0,a0,8
    80003848:	00003097          	auipc	ra,0x3
    8000384c:	926080e7          	jalr	-1754(ra) # 8000616e <initlock>
  lk->name = name;
    80003850:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003854:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003858:	0204a423          	sw	zero,40(s1)
}
    8000385c:	60e2                	ld	ra,24(sp)
    8000385e:	6442                	ld	s0,16(sp)
    80003860:	64a2                	ld	s1,8(sp)
    80003862:	6902                	ld	s2,0(sp)
    80003864:	6105                	addi	sp,sp,32
    80003866:	8082                	ret

0000000080003868 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003868:	1101                	addi	sp,sp,-32
    8000386a:	ec06                	sd	ra,24(sp)
    8000386c:	e822                	sd	s0,16(sp)
    8000386e:	e426                	sd	s1,8(sp)
    80003870:	e04a                	sd	s2,0(sp)
    80003872:	1000                	addi	s0,sp,32
    80003874:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003876:	00850913          	addi	s2,a0,8
    8000387a:	854a                	mv	a0,s2
    8000387c:	00003097          	auipc	ra,0x3
    80003880:	982080e7          	jalr	-1662(ra) # 800061fe <acquire>
  while (lk->locked) {
    80003884:	409c                	lw	a5,0(s1)
    80003886:	cb89                	beqz	a5,80003898 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003888:	85ca                	mv	a1,s2
    8000388a:	8526                	mv	a0,s1
    8000388c:	ffffe097          	auipc	ra,0xffffe
    80003890:	da8080e7          	jalr	-600(ra) # 80001634 <sleep>
  while (lk->locked) {
    80003894:	409c                	lw	a5,0(s1)
    80003896:	fbed                	bnez	a5,80003888 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003898:	4785                	li	a5,1
    8000389a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000389c:	ffffd097          	auipc	ra,0xffffd
    800038a0:	6dc080e7          	jalr	1756(ra) # 80000f78 <myproc>
    800038a4:	591c                	lw	a5,48(a0)
    800038a6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038a8:	854a                	mv	a0,s2
    800038aa:	00003097          	auipc	ra,0x3
    800038ae:	a08080e7          	jalr	-1528(ra) # 800062b2 <release>
}
    800038b2:	60e2                	ld	ra,24(sp)
    800038b4:	6442                	ld	s0,16(sp)
    800038b6:	64a2                	ld	s1,8(sp)
    800038b8:	6902                	ld	s2,0(sp)
    800038ba:	6105                	addi	sp,sp,32
    800038bc:	8082                	ret

00000000800038be <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038be:	1101                	addi	sp,sp,-32
    800038c0:	ec06                	sd	ra,24(sp)
    800038c2:	e822                	sd	s0,16(sp)
    800038c4:	e426                	sd	s1,8(sp)
    800038c6:	e04a                	sd	s2,0(sp)
    800038c8:	1000                	addi	s0,sp,32
    800038ca:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038cc:	00850913          	addi	s2,a0,8
    800038d0:	854a                	mv	a0,s2
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	92c080e7          	jalr	-1748(ra) # 800061fe <acquire>
  lk->locked = 0;
    800038da:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038de:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038e2:	8526                	mv	a0,s1
    800038e4:	ffffe097          	auipc	ra,0xffffe
    800038e8:	edc080e7          	jalr	-292(ra) # 800017c0 <wakeup>
  release(&lk->lk);
    800038ec:	854a                	mv	a0,s2
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	9c4080e7          	jalr	-1596(ra) # 800062b2 <release>
}
    800038f6:	60e2                	ld	ra,24(sp)
    800038f8:	6442                	ld	s0,16(sp)
    800038fa:	64a2                	ld	s1,8(sp)
    800038fc:	6902                	ld	s2,0(sp)
    800038fe:	6105                	addi	sp,sp,32
    80003900:	8082                	ret

0000000080003902 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003902:	7179                	addi	sp,sp,-48
    80003904:	f406                	sd	ra,40(sp)
    80003906:	f022                	sd	s0,32(sp)
    80003908:	ec26                	sd	s1,24(sp)
    8000390a:	e84a                	sd	s2,16(sp)
    8000390c:	e44e                	sd	s3,8(sp)
    8000390e:	1800                	addi	s0,sp,48
    80003910:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003912:	00850913          	addi	s2,a0,8
    80003916:	854a                	mv	a0,s2
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	8e6080e7          	jalr	-1818(ra) # 800061fe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003920:	409c                	lw	a5,0(s1)
    80003922:	ef99                	bnez	a5,80003940 <holdingsleep+0x3e>
    80003924:	4481                	li	s1,0
  release(&lk->lk);
    80003926:	854a                	mv	a0,s2
    80003928:	00003097          	auipc	ra,0x3
    8000392c:	98a080e7          	jalr	-1654(ra) # 800062b2 <release>
  return r;
}
    80003930:	8526                	mv	a0,s1
    80003932:	70a2                	ld	ra,40(sp)
    80003934:	7402                	ld	s0,32(sp)
    80003936:	64e2                	ld	s1,24(sp)
    80003938:	6942                	ld	s2,16(sp)
    8000393a:	69a2                	ld	s3,8(sp)
    8000393c:	6145                	addi	sp,sp,48
    8000393e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003940:	0284a983          	lw	s3,40(s1)
    80003944:	ffffd097          	auipc	ra,0xffffd
    80003948:	634080e7          	jalr	1588(ra) # 80000f78 <myproc>
    8000394c:	5904                	lw	s1,48(a0)
    8000394e:	413484b3          	sub	s1,s1,s3
    80003952:	0014b493          	seqz	s1,s1
    80003956:	bfc1                	j	80003926 <holdingsleep+0x24>

0000000080003958 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003958:	1141                	addi	sp,sp,-16
    8000395a:	e406                	sd	ra,8(sp)
    8000395c:	e022                	sd	s0,0(sp)
    8000395e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003960:	00005597          	auipc	a1,0x5
    80003964:	d0058593          	addi	a1,a1,-768 # 80008660 <syscalls+0x238>
    80003968:	00016517          	auipc	a0,0x16
    8000396c:	a0050513          	addi	a0,a0,-1536 # 80019368 <ftable>
    80003970:	00002097          	auipc	ra,0x2
    80003974:	7fe080e7          	jalr	2046(ra) # 8000616e <initlock>
}
    80003978:	60a2                	ld	ra,8(sp)
    8000397a:	6402                	ld	s0,0(sp)
    8000397c:	0141                	addi	sp,sp,16
    8000397e:	8082                	ret

0000000080003980 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003980:	1101                	addi	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000398a:	00016517          	auipc	a0,0x16
    8000398e:	9de50513          	addi	a0,a0,-1570 # 80019368 <ftable>
    80003992:	00003097          	auipc	ra,0x3
    80003996:	86c080e7          	jalr	-1940(ra) # 800061fe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000399a:	00016497          	auipc	s1,0x16
    8000399e:	9e648493          	addi	s1,s1,-1562 # 80019380 <ftable+0x18>
    800039a2:	00017717          	auipc	a4,0x17
    800039a6:	97e70713          	addi	a4,a4,-1666 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039aa:	40dc                	lw	a5,4(s1)
    800039ac:	cf99                	beqz	a5,800039ca <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039ae:	02848493          	addi	s1,s1,40
    800039b2:	fee49ce3          	bne	s1,a4,800039aa <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039b6:	00016517          	auipc	a0,0x16
    800039ba:	9b250513          	addi	a0,a0,-1614 # 80019368 <ftable>
    800039be:	00003097          	auipc	ra,0x3
    800039c2:	8f4080e7          	jalr	-1804(ra) # 800062b2 <release>
  return 0;
    800039c6:	4481                	li	s1,0
    800039c8:	a819                	j	800039de <filealloc+0x5e>
      f->ref = 1;
    800039ca:	4785                	li	a5,1
    800039cc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039ce:	00016517          	auipc	a0,0x16
    800039d2:	99a50513          	addi	a0,a0,-1638 # 80019368 <ftable>
    800039d6:	00003097          	auipc	ra,0x3
    800039da:	8dc080e7          	jalr	-1828(ra) # 800062b2 <release>
}
    800039de:	8526                	mv	a0,s1
    800039e0:	60e2                	ld	ra,24(sp)
    800039e2:	6442                	ld	s0,16(sp)
    800039e4:	64a2                	ld	s1,8(sp)
    800039e6:	6105                	addi	sp,sp,32
    800039e8:	8082                	ret

00000000800039ea <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039ea:	1101                	addi	sp,sp,-32
    800039ec:	ec06                	sd	ra,24(sp)
    800039ee:	e822                	sd	s0,16(sp)
    800039f0:	e426                	sd	s1,8(sp)
    800039f2:	1000                	addi	s0,sp,32
    800039f4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039f6:	00016517          	auipc	a0,0x16
    800039fa:	97250513          	addi	a0,a0,-1678 # 80019368 <ftable>
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	800080e7          	jalr	-2048(ra) # 800061fe <acquire>
  if(f->ref < 1)
    80003a06:	40dc                	lw	a5,4(s1)
    80003a08:	02f05263          	blez	a5,80003a2c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a0c:	2785                	addiw	a5,a5,1
    80003a0e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a10:	00016517          	auipc	a0,0x16
    80003a14:	95850513          	addi	a0,a0,-1704 # 80019368 <ftable>
    80003a18:	00003097          	auipc	ra,0x3
    80003a1c:	89a080e7          	jalr	-1894(ra) # 800062b2 <release>
  return f;
}
    80003a20:	8526                	mv	a0,s1
    80003a22:	60e2                	ld	ra,24(sp)
    80003a24:	6442                	ld	s0,16(sp)
    80003a26:	64a2                	ld	s1,8(sp)
    80003a28:	6105                	addi	sp,sp,32
    80003a2a:	8082                	ret
    panic("filedup");
    80003a2c:	00005517          	auipc	a0,0x5
    80003a30:	c3c50513          	addi	a0,a0,-964 # 80008668 <syscalls+0x240>
    80003a34:	00002097          	auipc	ra,0x2
    80003a38:	214080e7          	jalr	532(ra) # 80005c48 <panic>

0000000080003a3c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a3c:	7139                	addi	sp,sp,-64
    80003a3e:	fc06                	sd	ra,56(sp)
    80003a40:	f822                	sd	s0,48(sp)
    80003a42:	f426                	sd	s1,40(sp)
    80003a44:	f04a                	sd	s2,32(sp)
    80003a46:	ec4e                	sd	s3,24(sp)
    80003a48:	e852                	sd	s4,16(sp)
    80003a4a:	e456                	sd	s5,8(sp)
    80003a4c:	0080                	addi	s0,sp,64
    80003a4e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a50:	00016517          	auipc	a0,0x16
    80003a54:	91850513          	addi	a0,a0,-1768 # 80019368 <ftable>
    80003a58:	00002097          	auipc	ra,0x2
    80003a5c:	7a6080e7          	jalr	1958(ra) # 800061fe <acquire>
  if(f->ref < 1)
    80003a60:	40dc                	lw	a5,4(s1)
    80003a62:	06f05163          	blez	a5,80003ac4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a66:	37fd                	addiw	a5,a5,-1
    80003a68:	0007871b          	sext.w	a4,a5
    80003a6c:	c0dc                	sw	a5,4(s1)
    80003a6e:	06e04363          	bgtz	a4,80003ad4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a72:	0004a903          	lw	s2,0(s1)
    80003a76:	0094ca83          	lbu	s5,9(s1)
    80003a7a:	0104ba03          	ld	s4,16(s1)
    80003a7e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a82:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a86:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a8a:	00016517          	auipc	a0,0x16
    80003a8e:	8de50513          	addi	a0,a0,-1826 # 80019368 <ftable>
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	820080e7          	jalr	-2016(ra) # 800062b2 <release>

  if(ff.type == FD_PIPE){
    80003a9a:	4785                	li	a5,1
    80003a9c:	04f90d63          	beq	s2,a5,80003af6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aa0:	3979                	addiw	s2,s2,-2
    80003aa2:	4785                	li	a5,1
    80003aa4:	0527e063          	bltu	a5,s2,80003ae4 <fileclose+0xa8>
    begin_op();
    80003aa8:	00000097          	auipc	ra,0x0
    80003aac:	ac8080e7          	jalr	-1336(ra) # 80003570 <begin_op>
    iput(ff.ip);
    80003ab0:	854e                	mv	a0,s3
    80003ab2:	fffff097          	auipc	ra,0xfffff
    80003ab6:	2a6080e7          	jalr	678(ra) # 80002d58 <iput>
    end_op();
    80003aba:	00000097          	auipc	ra,0x0
    80003abe:	b36080e7          	jalr	-1226(ra) # 800035f0 <end_op>
    80003ac2:	a00d                	j	80003ae4 <fileclose+0xa8>
    panic("fileclose");
    80003ac4:	00005517          	auipc	a0,0x5
    80003ac8:	bac50513          	addi	a0,a0,-1108 # 80008670 <syscalls+0x248>
    80003acc:	00002097          	auipc	ra,0x2
    80003ad0:	17c080e7          	jalr	380(ra) # 80005c48 <panic>
    release(&ftable.lock);
    80003ad4:	00016517          	auipc	a0,0x16
    80003ad8:	89450513          	addi	a0,a0,-1900 # 80019368 <ftable>
    80003adc:	00002097          	auipc	ra,0x2
    80003ae0:	7d6080e7          	jalr	2006(ra) # 800062b2 <release>
  }
}
    80003ae4:	70e2                	ld	ra,56(sp)
    80003ae6:	7442                	ld	s0,48(sp)
    80003ae8:	74a2                	ld	s1,40(sp)
    80003aea:	7902                	ld	s2,32(sp)
    80003aec:	69e2                	ld	s3,24(sp)
    80003aee:	6a42                	ld	s4,16(sp)
    80003af0:	6aa2                	ld	s5,8(sp)
    80003af2:	6121                	addi	sp,sp,64
    80003af4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003af6:	85d6                	mv	a1,s5
    80003af8:	8552                	mv	a0,s4
    80003afa:	00000097          	auipc	ra,0x0
    80003afe:	34c080e7          	jalr	844(ra) # 80003e46 <pipeclose>
    80003b02:	b7cd                	j	80003ae4 <fileclose+0xa8>

0000000080003b04 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b04:	715d                	addi	sp,sp,-80
    80003b06:	e486                	sd	ra,72(sp)
    80003b08:	e0a2                	sd	s0,64(sp)
    80003b0a:	fc26                	sd	s1,56(sp)
    80003b0c:	f84a                	sd	s2,48(sp)
    80003b0e:	f44e                	sd	s3,40(sp)
    80003b10:	0880                	addi	s0,sp,80
    80003b12:	84aa                	mv	s1,a0
    80003b14:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b16:	ffffd097          	auipc	ra,0xffffd
    80003b1a:	462080e7          	jalr	1122(ra) # 80000f78 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b1e:	409c                	lw	a5,0(s1)
    80003b20:	37f9                	addiw	a5,a5,-2
    80003b22:	4705                	li	a4,1
    80003b24:	04f76763          	bltu	a4,a5,80003b72 <filestat+0x6e>
    80003b28:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b2a:	6c88                	ld	a0,24(s1)
    80003b2c:	fffff097          	auipc	ra,0xfffff
    80003b30:	072080e7          	jalr	114(ra) # 80002b9e <ilock>
    stati(f->ip, &st);
    80003b34:	fb840593          	addi	a1,s0,-72
    80003b38:	6c88                	ld	a0,24(s1)
    80003b3a:	fffff097          	auipc	ra,0xfffff
    80003b3e:	2ee080e7          	jalr	750(ra) # 80002e28 <stati>
    iunlock(f->ip);
    80003b42:	6c88                	ld	a0,24(s1)
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	11c080e7          	jalr	284(ra) # 80002c60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b4c:	46e1                	li	a3,24
    80003b4e:	fb840613          	addi	a2,s0,-72
    80003b52:	85ce                	mv	a1,s3
    80003b54:	05093503          	ld	a0,80(s2)
    80003b58:	ffffd097          	auipc	ra,0xffffd
    80003b5c:	fb2080e7          	jalr	-78(ra) # 80000b0a <copyout>
    80003b60:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b64:	60a6                	ld	ra,72(sp)
    80003b66:	6406                	ld	s0,64(sp)
    80003b68:	74e2                	ld	s1,56(sp)
    80003b6a:	7942                	ld	s2,48(sp)
    80003b6c:	79a2                	ld	s3,40(sp)
    80003b6e:	6161                	addi	sp,sp,80
    80003b70:	8082                	ret
  return -1;
    80003b72:	557d                	li	a0,-1
    80003b74:	bfc5                	j	80003b64 <filestat+0x60>

0000000080003b76 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b76:	7179                	addi	sp,sp,-48
    80003b78:	f406                	sd	ra,40(sp)
    80003b7a:	f022                	sd	s0,32(sp)
    80003b7c:	ec26                	sd	s1,24(sp)
    80003b7e:	e84a                	sd	s2,16(sp)
    80003b80:	e44e                	sd	s3,8(sp)
    80003b82:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b84:	00854783          	lbu	a5,8(a0)
    80003b88:	c3d5                	beqz	a5,80003c2c <fileread+0xb6>
    80003b8a:	84aa                	mv	s1,a0
    80003b8c:	89ae                	mv	s3,a1
    80003b8e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b90:	411c                	lw	a5,0(a0)
    80003b92:	4705                	li	a4,1
    80003b94:	04e78963          	beq	a5,a4,80003be6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b98:	470d                	li	a4,3
    80003b9a:	04e78d63          	beq	a5,a4,80003bf4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b9e:	4709                	li	a4,2
    80003ba0:	06e79e63          	bne	a5,a4,80003c1c <fileread+0xa6>
    ilock(f->ip);
    80003ba4:	6d08                	ld	a0,24(a0)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	ff8080e7          	jalr	-8(ra) # 80002b9e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bae:	874a                	mv	a4,s2
    80003bb0:	5094                	lw	a3,32(s1)
    80003bb2:	864e                	mv	a2,s3
    80003bb4:	4585                	li	a1,1
    80003bb6:	6c88                	ld	a0,24(s1)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	29a080e7          	jalr	666(ra) # 80002e52 <readi>
    80003bc0:	892a                	mv	s2,a0
    80003bc2:	00a05563          	blez	a0,80003bcc <fileread+0x56>
      f->off += r;
    80003bc6:	509c                	lw	a5,32(s1)
    80003bc8:	9fa9                	addw	a5,a5,a0
    80003bca:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bcc:	6c88                	ld	a0,24(s1)
    80003bce:	fffff097          	auipc	ra,0xfffff
    80003bd2:	092080e7          	jalr	146(ra) # 80002c60 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bd6:	854a                	mv	a0,s2
    80003bd8:	70a2                	ld	ra,40(sp)
    80003bda:	7402                	ld	s0,32(sp)
    80003bdc:	64e2                	ld	s1,24(sp)
    80003bde:	6942                	ld	s2,16(sp)
    80003be0:	69a2                	ld	s3,8(sp)
    80003be2:	6145                	addi	sp,sp,48
    80003be4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003be6:	6908                	ld	a0,16(a0)
    80003be8:	00000097          	auipc	ra,0x0
    80003bec:	3c8080e7          	jalr	968(ra) # 80003fb0 <piperead>
    80003bf0:	892a                	mv	s2,a0
    80003bf2:	b7d5                	j	80003bd6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bf4:	02451783          	lh	a5,36(a0)
    80003bf8:	03079693          	slli	a3,a5,0x30
    80003bfc:	92c1                	srli	a3,a3,0x30
    80003bfe:	4725                	li	a4,9
    80003c00:	02d76863          	bltu	a4,a3,80003c30 <fileread+0xba>
    80003c04:	0792                	slli	a5,a5,0x4
    80003c06:	00015717          	auipc	a4,0x15
    80003c0a:	6c270713          	addi	a4,a4,1730 # 800192c8 <devsw>
    80003c0e:	97ba                	add	a5,a5,a4
    80003c10:	639c                	ld	a5,0(a5)
    80003c12:	c38d                	beqz	a5,80003c34 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c14:	4505                	li	a0,1
    80003c16:	9782                	jalr	a5
    80003c18:	892a                	mv	s2,a0
    80003c1a:	bf75                	j	80003bd6 <fileread+0x60>
    panic("fileread");
    80003c1c:	00005517          	auipc	a0,0x5
    80003c20:	a6450513          	addi	a0,a0,-1436 # 80008680 <syscalls+0x258>
    80003c24:	00002097          	auipc	ra,0x2
    80003c28:	024080e7          	jalr	36(ra) # 80005c48 <panic>
    return -1;
    80003c2c:	597d                	li	s2,-1
    80003c2e:	b765                	j	80003bd6 <fileread+0x60>
      return -1;
    80003c30:	597d                	li	s2,-1
    80003c32:	b755                	j	80003bd6 <fileread+0x60>
    80003c34:	597d                	li	s2,-1
    80003c36:	b745                	j	80003bd6 <fileread+0x60>

0000000080003c38 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c38:	715d                	addi	sp,sp,-80
    80003c3a:	e486                	sd	ra,72(sp)
    80003c3c:	e0a2                	sd	s0,64(sp)
    80003c3e:	fc26                	sd	s1,56(sp)
    80003c40:	f84a                	sd	s2,48(sp)
    80003c42:	f44e                	sd	s3,40(sp)
    80003c44:	f052                	sd	s4,32(sp)
    80003c46:	ec56                	sd	s5,24(sp)
    80003c48:	e85a                	sd	s6,16(sp)
    80003c4a:	e45e                	sd	s7,8(sp)
    80003c4c:	e062                	sd	s8,0(sp)
    80003c4e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c50:	00954783          	lbu	a5,9(a0)
    80003c54:	10078663          	beqz	a5,80003d60 <filewrite+0x128>
    80003c58:	892a                	mv	s2,a0
    80003c5a:	8aae                	mv	s5,a1
    80003c5c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c5e:	411c                	lw	a5,0(a0)
    80003c60:	4705                	li	a4,1
    80003c62:	02e78263          	beq	a5,a4,80003c86 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c66:	470d                	li	a4,3
    80003c68:	02e78663          	beq	a5,a4,80003c94 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c6c:	4709                	li	a4,2
    80003c6e:	0ee79163          	bne	a5,a4,80003d50 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c72:	0ac05d63          	blez	a2,80003d2c <filewrite+0xf4>
    int i = 0;
    80003c76:	4981                	li	s3,0
    80003c78:	6b05                	lui	s6,0x1
    80003c7a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c7e:	6b85                	lui	s7,0x1
    80003c80:	c00b8b9b          	addiw	s7,s7,-1024
    80003c84:	a861                	j	80003d1c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c86:	6908                	ld	a0,16(a0)
    80003c88:	00000097          	auipc	ra,0x0
    80003c8c:	22e080e7          	jalr	558(ra) # 80003eb6 <pipewrite>
    80003c90:	8a2a                	mv	s4,a0
    80003c92:	a045                	j	80003d32 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c94:	02451783          	lh	a5,36(a0)
    80003c98:	03079693          	slli	a3,a5,0x30
    80003c9c:	92c1                	srli	a3,a3,0x30
    80003c9e:	4725                	li	a4,9
    80003ca0:	0cd76263          	bltu	a4,a3,80003d64 <filewrite+0x12c>
    80003ca4:	0792                	slli	a5,a5,0x4
    80003ca6:	00015717          	auipc	a4,0x15
    80003caa:	62270713          	addi	a4,a4,1570 # 800192c8 <devsw>
    80003cae:	97ba                	add	a5,a5,a4
    80003cb0:	679c                	ld	a5,8(a5)
    80003cb2:	cbdd                	beqz	a5,80003d68 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cb4:	4505                	li	a0,1
    80003cb6:	9782                	jalr	a5
    80003cb8:	8a2a                	mv	s4,a0
    80003cba:	a8a5                	j	80003d32 <filewrite+0xfa>
    80003cbc:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cc0:	00000097          	auipc	ra,0x0
    80003cc4:	8b0080e7          	jalr	-1872(ra) # 80003570 <begin_op>
      ilock(f->ip);
    80003cc8:	01893503          	ld	a0,24(s2)
    80003ccc:	fffff097          	auipc	ra,0xfffff
    80003cd0:	ed2080e7          	jalr	-302(ra) # 80002b9e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cd4:	8762                	mv	a4,s8
    80003cd6:	02092683          	lw	a3,32(s2)
    80003cda:	01598633          	add	a2,s3,s5
    80003cde:	4585                	li	a1,1
    80003ce0:	01893503          	ld	a0,24(s2)
    80003ce4:	fffff097          	auipc	ra,0xfffff
    80003ce8:	266080e7          	jalr	614(ra) # 80002f4a <writei>
    80003cec:	84aa                	mv	s1,a0
    80003cee:	00a05763          	blez	a0,80003cfc <filewrite+0xc4>
        f->off += r;
    80003cf2:	02092783          	lw	a5,32(s2)
    80003cf6:	9fa9                	addw	a5,a5,a0
    80003cf8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cfc:	01893503          	ld	a0,24(s2)
    80003d00:	fffff097          	auipc	ra,0xfffff
    80003d04:	f60080e7          	jalr	-160(ra) # 80002c60 <iunlock>
      end_op();
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	8e8080e7          	jalr	-1816(ra) # 800035f0 <end_op>

      if(r != n1){
    80003d10:	009c1f63          	bne	s8,s1,80003d2e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d14:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d18:	0149db63          	bge	s3,s4,80003d2e <filewrite+0xf6>
      int n1 = n - i;
    80003d1c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d20:	84be                	mv	s1,a5
    80003d22:	2781                	sext.w	a5,a5
    80003d24:	f8fb5ce3          	bge	s6,a5,80003cbc <filewrite+0x84>
    80003d28:	84de                	mv	s1,s7
    80003d2a:	bf49                	j	80003cbc <filewrite+0x84>
    int i = 0;
    80003d2c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d2e:	013a1f63          	bne	s4,s3,80003d4c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d32:	8552                	mv	a0,s4
    80003d34:	60a6                	ld	ra,72(sp)
    80003d36:	6406                	ld	s0,64(sp)
    80003d38:	74e2                	ld	s1,56(sp)
    80003d3a:	7942                	ld	s2,48(sp)
    80003d3c:	79a2                	ld	s3,40(sp)
    80003d3e:	7a02                	ld	s4,32(sp)
    80003d40:	6ae2                	ld	s5,24(sp)
    80003d42:	6b42                	ld	s6,16(sp)
    80003d44:	6ba2                	ld	s7,8(sp)
    80003d46:	6c02                	ld	s8,0(sp)
    80003d48:	6161                	addi	sp,sp,80
    80003d4a:	8082                	ret
    ret = (i == n ? n : -1);
    80003d4c:	5a7d                	li	s4,-1
    80003d4e:	b7d5                	j	80003d32 <filewrite+0xfa>
    panic("filewrite");
    80003d50:	00005517          	auipc	a0,0x5
    80003d54:	94050513          	addi	a0,a0,-1728 # 80008690 <syscalls+0x268>
    80003d58:	00002097          	auipc	ra,0x2
    80003d5c:	ef0080e7          	jalr	-272(ra) # 80005c48 <panic>
    return -1;
    80003d60:	5a7d                	li	s4,-1
    80003d62:	bfc1                	j	80003d32 <filewrite+0xfa>
      return -1;
    80003d64:	5a7d                	li	s4,-1
    80003d66:	b7f1                	j	80003d32 <filewrite+0xfa>
    80003d68:	5a7d                	li	s4,-1
    80003d6a:	b7e1                	j	80003d32 <filewrite+0xfa>

0000000080003d6c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d6c:	7179                	addi	sp,sp,-48
    80003d6e:	f406                	sd	ra,40(sp)
    80003d70:	f022                	sd	s0,32(sp)
    80003d72:	ec26                	sd	s1,24(sp)
    80003d74:	e84a                	sd	s2,16(sp)
    80003d76:	e44e                	sd	s3,8(sp)
    80003d78:	e052                	sd	s4,0(sp)
    80003d7a:	1800                	addi	s0,sp,48
    80003d7c:	84aa                	mv	s1,a0
    80003d7e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d80:	0005b023          	sd	zero,0(a1)
    80003d84:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	bf8080e7          	jalr	-1032(ra) # 80003980 <filealloc>
    80003d90:	e088                	sd	a0,0(s1)
    80003d92:	c551                	beqz	a0,80003e1e <pipealloc+0xb2>
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	bec080e7          	jalr	-1044(ra) # 80003980 <filealloc>
    80003d9c:	00aa3023          	sd	a0,0(s4)
    80003da0:	c92d                	beqz	a0,80003e12 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003da2:	ffffc097          	auipc	ra,0xffffc
    80003da6:	376080e7          	jalr	886(ra) # 80000118 <kalloc>
    80003daa:	892a                	mv	s2,a0
    80003dac:	c125                	beqz	a0,80003e0c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dae:	4985                	li	s3,1
    80003db0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003db4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003db8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dbc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dc0:	00005597          	auipc	a1,0x5
    80003dc4:	8e058593          	addi	a1,a1,-1824 # 800086a0 <syscalls+0x278>
    80003dc8:	00002097          	auipc	ra,0x2
    80003dcc:	3a6080e7          	jalr	934(ra) # 8000616e <initlock>
  (*f0)->type = FD_PIPE;
    80003dd0:	609c                	ld	a5,0(s1)
    80003dd2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dd6:	609c                	ld	a5,0(s1)
    80003dd8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ddc:	609c                	ld	a5,0(s1)
    80003dde:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003de2:	609c                	ld	a5,0(s1)
    80003de4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003de8:	000a3783          	ld	a5,0(s4)
    80003dec:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003df0:	000a3783          	ld	a5,0(s4)
    80003df4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003df8:	000a3783          	ld	a5,0(s4)
    80003dfc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e00:	000a3783          	ld	a5,0(s4)
    80003e04:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e08:	4501                	li	a0,0
    80003e0a:	a025                	j	80003e32 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e0c:	6088                	ld	a0,0(s1)
    80003e0e:	e501                	bnez	a0,80003e16 <pipealloc+0xaa>
    80003e10:	a039                	j	80003e1e <pipealloc+0xb2>
    80003e12:	6088                	ld	a0,0(s1)
    80003e14:	c51d                	beqz	a0,80003e42 <pipealloc+0xd6>
    fileclose(*f0);
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	c26080e7          	jalr	-986(ra) # 80003a3c <fileclose>
  if(*f1)
    80003e1e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e22:	557d                	li	a0,-1
  if(*f1)
    80003e24:	c799                	beqz	a5,80003e32 <pipealloc+0xc6>
    fileclose(*f1);
    80003e26:	853e                	mv	a0,a5
    80003e28:	00000097          	auipc	ra,0x0
    80003e2c:	c14080e7          	jalr	-1004(ra) # 80003a3c <fileclose>
  return -1;
    80003e30:	557d                	li	a0,-1
}
    80003e32:	70a2                	ld	ra,40(sp)
    80003e34:	7402                	ld	s0,32(sp)
    80003e36:	64e2                	ld	s1,24(sp)
    80003e38:	6942                	ld	s2,16(sp)
    80003e3a:	69a2                	ld	s3,8(sp)
    80003e3c:	6a02                	ld	s4,0(sp)
    80003e3e:	6145                	addi	sp,sp,48
    80003e40:	8082                	ret
  return -1;
    80003e42:	557d                	li	a0,-1
    80003e44:	b7fd                	j	80003e32 <pipealloc+0xc6>

0000000080003e46 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e46:	1101                	addi	sp,sp,-32
    80003e48:	ec06                	sd	ra,24(sp)
    80003e4a:	e822                	sd	s0,16(sp)
    80003e4c:	e426                	sd	s1,8(sp)
    80003e4e:	e04a                	sd	s2,0(sp)
    80003e50:	1000                	addi	s0,sp,32
    80003e52:	84aa                	mv	s1,a0
    80003e54:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e56:	00002097          	auipc	ra,0x2
    80003e5a:	3a8080e7          	jalr	936(ra) # 800061fe <acquire>
  if(writable){
    80003e5e:	02090d63          	beqz	s2,80003e98 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e62:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e66:	21848513          	addi	a0,s1,536
    80003e6a:	ffffe097          	auipc	ra,0xffffe
    80003e6e:	956080e7          	jalr	-1706(ra) # 800017c0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e72:	2204b783          	ld	a5,544(s1)
    80003e76:	eb95                	bnez	a5,80003eaa <pipeclose+0x64>
    release(&pi->lock);
    80003e78:	8526                	mv	a0,s1
    80003e7a:	00002097          	auipc	ra,0x2
    80003e7e:	438080e7          	jalr	1080(ra) # 800062b2 <release>
    kfree((char*)pi);
    80003e82:	8526                	mv	a0,s1
    80003e84:	ffffc097          	auipc	ra,0xffffc
    80003e88:	198080e7          	jalr	408(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e8c:	60e2                	ld	ra,24(sp)
    80003e8e:	6442                	ld	s0,16(sp)
    80003e90:	64a2                	ld	s1,8(sp)
    80003e92:	6902                	ld	s2,0(sp)
    80003e94:	6105                	addi	sp,sp,32
    80003e96:	8082                	ret
    pi->readopen = 0;
    80003e98:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e9c:	21c48513          	addi	a0,s1,540
    80003ea0:	ffffe097          	auipc	ra,0xffffe
    80003ea4:	920080e7          	jalr	-1760(ra) # 800017c0 <wakeup>
    80003ea8:	b7e9                	j	80003e72 <pipeclose+0x2c>
    release(&pi->lock);
    80003eaa:	8526                	mv	a0,s1
    80003eac:	00002097          	auipc	ra,0x2
    80003eb0:	406080e7          	jalr	1030(ra) # 800062b2 <release>
}
    80003eb4:	bfe1                	j	80003e8c <pipeclose+0x46>

0000000080003eb6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eb6:	7159                	addi	sp,sp,-112
    80003eb8:	f486                	sd	ra,104(sp)
    80003eba:	f0a2                	sd	s0,96(sp)
    80003ebc:	eca6                	sd	s1,88(sp)
    80003ebe:	e8ca                	sd	s2,80(sp)
    80003ec0:	e4ce                	sd	s3,72(sp)
    80003ec2:	e0d2                	sd	s4,64(sp)
    80003ec4:	fc56                	sd	s5,56(sp)
    80003ec6:	f85a                	sd	s6,48(sp)
    80003ec8:	f45e                	sd	s7,40(sp)
    80003eca:	f062                	sd	s8,32(sp)
    80003ecc:	ec66                	sd	s9,24(sp)
    80003ece:	1880                	addi	s0,sp,112
    80003ed0:	84aa                	mv	s1,a0
    80003ed2:	8aae                	mv	s5,a1
    80003ed4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ed6:	ffffd097          	auipc	ra,0xffffd
    80003eda:	0a2080e7          	jalr	162(ra) # 80000f78 <myproc>
    80003ede:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	31c080e7          	jalr	796(ra) # 800061fe <acquire>
  while(i < n){
    80003eea:	0d405163          	blez	s4,80003fac <pipewrite+0xf6>
    80003eee:	8ba6                	mv	s7,s1
  int i = 0;
    80003ef0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ef2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ef4:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ef8:	21c48c13          	addi	s8,s1,540
    80003efc:	a08d                	j	80003f5e <pipewrite+0xa8>
      release(&pi->lock);
    80003efe:	8526                	mv	a0,s1
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	3b2080e7          	jalr	946(ra) # 800062b2 <release>
      return -1;
    80003f08:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f0a:	854a                	mv	a0,s2
    80003f0c:	70a6                	ld	ra,104(sp)
    80003f0e:	7406                	ld	s0,96(sp)
    80003f10:	64e6                	ld	s1,88(sp)
    80003f12:	6946                	ld	s2,80(sp)
    80003f14:	69a6                	ld	s3,72(sp)
    80003f16:	6a06                	ld	s4,64(sp)
    80003f18:	7ae2                	ld	s5,56(sp)
    80003f1a:	7b42                	ld	s6,48(sp)
    80003f1c:	7ba2                	ld	s7,40(sp)
    80003f1e:	7c02                	ld	s8,32(sp)
    80003f20:	6ce2                	ld	s9,24(sp)
    80003f22:	6165                	addi	sp,sp,112
    80003f24:	8082                	ret
      wakeup(&pi->nread);
    80003f26:	8566                	mv	a0,s9
    80003f28:	ffffe097          	auipc	ra,0xffffe
    80003f2c:	898080e7          	jalr	-1896(ra) # 800017c0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f30:	85de                	mv	a1,s7
    80003f32:	8562                	mv	a0,s8
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	700080e7          	jalr	1792(ra) # 80001634 <sleep>
    80003f3c:	a839                	j	80003f5a <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f3e:	21c4a783          	lw	a5,540(s1)
    80003f42:	0017871b          	addiw	a4,a5,1
    80003f46:	20e4ae23          	sw	a4,540(s1)
    80003f4a:	1ff7f793          	andi	a5,a5,511
    80003f4e:	97a6                	add	a5,a5,s1
    80003f50:	f9f44703          	lbu	a4,-97(s0)
    80003f54:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f58:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f5a:	03495d63          	bge	s2,s4,80003f94 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f5e:	2204a783          	lw	a5,544(s1)
    80003f62:	dfd1                	beqz	a5,80003efe <pipewrite+0x48>
    80003f64:	0289a783          	lw	a5,40(s3)
    80003f68:	fbd9                	bnez	a5,80003efe <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f6a:	2184a783          	lw	a5,536(s1)
    80003f6e:	21c4a703          	lw	a4,540(s1)
    80003f72:	2007879b          	addiw	a5,a5,512
    80003f76:	faf708e3          	beq	a4,a5,80003f26 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f7a:	4685                	li	a3,1
    80003f7c:	01590633          	add	a2,s2,s5
    80003f80:	f9f40593          	addi	a1,s0,-97
    80003f84:	0509b503          	ld	a0,80(s3)
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	c0e080e7          	jalr	-1010(ra) # 80000b96 <copyin>
    80003f90:	fb6517e3          	bne	a0,s6,80003f3e <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f94:	21848513          	addi	a0,s1,536
    80003f98:	ffffe097          	auipc	ra,0xffffe
    80003f9c:	828080e7          	jalr	-2008(ra) # 800017c0 <wakeup>
  release(&pi->lock);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	00002097          	auipc	ra,0x2
    80003fa6:	310080e7          	jalr	784(ra) # 800062b2 <release>
  return i;
    80003faa:	b785                	j	80003f0a <pipewrite+0x54>
  int i = 0;
    80003fac:	4901                	li	s2,0
    80003fae:	b7dd                	j	80003f94 <pipewrite+0xde>

0000000080003fb0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fb0:	715d                	addi	sp,sp,-80
    80003fb2:	e486                	sd	ra,72(sp)
    80003fb4:	e0a2                	sd	s0,64(sp)
    80003fb6:	fc26                	sd	s1,56(sp)
    80003fb8:	f84a                	sd	s2,48(sp)
    80003fba:	f44e                	sd	s3,40(sp)
    80003fbc:	f052                	sd	s4,32(sp)
    80003fbe:	ec56                	sd	s5,24(sp)
    80003fc0:	e85a                	sd	s6,16(sp)
    80003fc2:	0880                	addi	s0,sp,80
    80003fc4:	84aa                	mv	s1,a0
    80003fc6:	892e                	mv	s2,a1
    80003fc8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fca:	ffffd097          	auipc	ra,0xffffd
    80003fce:	fae080e7          	jalr	-82(ra) # 80000f78 <myproc>
    80003fd2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fd4:	8b26                	mv	s6,s1
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	00002097          	auipc	ra,0x2
    80003fdc:	226080e7          	jalr	550(ra) # 800061fe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe0:	2184a703          	lw	a4,536(s1)
    80003fe4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fe8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fec:	02f71463          	bne	a4,a5,80004014 <piperead+0x64>
    80003ff0:	2244a783          	lw	a5,548(s1)
    80003ff4:	c385                	beqz	a5,80004014 <piperead+0x64>
    if(pr->killed){
    80003ff6:	028a2783          	lw	a5,40(s4)
    80003ffa:	ebc1                	bnez	a5,8000408a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ffc:	85da                	mv	a1,s6
    80003ffe:	854e                	mv	a0,s3
    80004000:	ffffd097          	auipc	ra,0xffffd
    80004004:	634080e7          	jalr	1588(ra) # 80001634 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004008:	2184a703          	lw	a4,536(s1)
    8000400c:	21c4a783          	lw	a5,540(s1)
    80004010:	fef700e3          	beq	a4,a5,80003ff0 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004014:	09505263          	blez	s5,80004098 <piperead+0xe8>
    80004018:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000401a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000401c:	2184a783          	lw	a5,536(s1)
    80004020:	21c4a703          	lw	a4,540(s1)
    80004024:	02f70d63          	beq	a4,a5,8000405e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004028:	0017871b          	addiw	a4,a5,1
    8000402c:	20e4ac23          	sw	a4,536(s1)
    80004030:	1ff7f793          	andi	a5,a5,511
    80004034:	97a6                	add	a5,a5,s1
    80004036:	0187c783          	lbu	a5,24(a5)
    8000403a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000403e:	4685                	li	a3,1
    80004040:	fbf40613          	addi	a2,s0,-65
    80004044:	85ca                	mv	a1,s2
    80004046:	050a3503          	ld	a0,80(s4)
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	ac0080e7          	jalr	-1344(ra) # 80000b0a <copyout>
    80004052:	01650663          	beq	a0,s6,8000405e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004056:	2985                	addiw	s3,s3,1
    80004058:	0905                	addi	s2,s2,1
    8000405a:	fd3a91e3          	bne	s5,s3,8000401c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000405e:	21c48513          	addi	a0,s1,540
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	75e080e7          	jalr	1886(ra) # 800017c0 <wakeup>
  release(&pi->lock);
    8000406a:	8526                	mv	a0,s1
    8000406c:	00002097          	auipc	ra,0x2
    80004070:	246080e7          	jalr	582(ra) # 800062b2 <release>
  return i;
}
    80004074:	854e                	mv	a0,s3
    80004076:	60a6                	ld	ra,72(sp)
    80004078:	6406                	ld	s0,64(sp)
    8000407a:	74e2                	ld	s1,56(sp)
    8000407c:	7942                	ld	s2,48(sp)
    8000407e:	79a2                	ld	s3,40(sp)
    80004080:	7a02                	ld	s4,32(sp)
    80004082:	6ae2                	ld	s5,24(sp)
    80004084:	6b42                	ld	s6,16(sp)
    80004086:	6161                	addi	sp,sp,80
    80004088:	8082                	ret
      release(&pi->lock);
    8000408a:	8526                	mv	a0,s1
    8000408c:	00002097          	auipc	ra,0x2
    80004090:	226080e7          	jalr	550(ra) # 800062b2 <release>
      return -1;
    80004094:	59fd                	li	s3,-1
    80004096:	bff9                	j	80004074 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004098:	4981                	li	s3,0
    8000409a:	b7d1                	j	8000405e <piperead+0xae>

000000008000409c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000409c:	df010113          	addi	sp,sp,-528
    800040a0:	20113423          	sd	ra,520(sp)
    800040a4:	20813023          	sd	s0,512(sp)
    800040a8:	ffa6                	sd	s1,504(sp)
    800040aa:	fbca                	sd	s2,496(sp)
    800040ac:	f7ce                	sd	s3,488(sp)
    800040ae:	f3d2                	sd	s4,480(sp)
    800040b0:	efd6                	sd	s5,472(sp)
    800040b2:	ebda                	sd	s6,464(sp)
    800040b4:	e7de                	sd	s7,456(sp)
    800040b6:	e3e2                	sd	s8,448(sp)
    800040b8:	ff66                	sd	s9,440(sp)
    800040ba:	fb6a                	sd	s10,432(sp)
    800040bc:	f76e                	sd	s11,424(sp)
    800040be:	0c00                	addi	s0,sp,528
    800040c0:	84aa                	mv	s1,a0
    800040c2:	dea43c23          	sd	a0,-520(s0)
    800040c6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	eae080e7          	jalr	-338(ra) # 80000f78 <myproc>
    800040d2:	892a                	mv	s2,a0

  begin_op();
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	49c080e7          	jalr	1180(ra) # 80003570 <begin_op>

  if((ip = namei(path)) == 0){
    800040dc:	8526                	mv	a0,s1
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	276080e7          	jalr	630(ra) # 80003354 <namei>
    800040e6:	c92d                	beqz	a0,80004158 <exec+0xbc>
    800040e8:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	ab4080e7          	jalr	-1356(ra) # 80002b9e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040f2:	04000713          	li	a4,64
    800040f6:	4681                	li	a3,0
    800040f8:	e5040613          	addi	a2,s0,-432
    800040fc:	4581                	li	a1,0
    800040fe:	8526                	mv	a0,s1
    80004100:	fffff097          	auipc	ra,0xfffff
    80004104:	d52080e7          	jalr	-686(ra) # 80002e52 <readi>
    80004108:	04000793          	li	a5,64
    8000410c:	00f51a63          	bne	a0,a5,80004120 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004110:	e5042703          	lw	a4,-432(s0)
    80004114:	464c47b7          	lui	a5,0x464c4
    80004118:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000411c:	04f70463          	beq	a4,a5,80004164 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004120:	8526                	mv	a0,s1
    80004122:	fffff097          	auipc	ra,0xfffff
    80004126:	cde080e7          	jalr	-802(ra) # 80002e00 <iunlockput>
    end_op();
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	4c6080e7          	jalr	1222(ra) # 800035f0 <end_op>
  }
  return -1;
    80004132:	557d                	li	a0,-1
}
    80004134:	20813083          	ld	ra,520(sp)
    80004138:	20013403          	ld	s0,512(sp)
    8000413c:	74fe                	ld	s1,504(sp)
    8000413e:	795e                	ld	s2,496(sp)
    80004140:	79be                	ld	s3,488(sp)
    80004142:	7a1e                	ld	s4,480(sp)
    80004144:	6afe                	ld	s5,472(sp)
    80004146:	6b5e                	ld	s6,464(sp)
    80004148:	6bbe                	ld	s7,456(sp)
    8000414a:	6c1e                	ld	s8,448(sp)
    8000414c:	7cfa                	ld	s9,440(sp)
    8000414e:	7d5a                	ld	s10,432(sp)
    80004150:	7dba                	ld	s11,424(sp)
    80004152:	21010113          	addi	sp,sp,528
    80004156:	8082                	ret
    end_op();
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	498080e7          	jalr	1176(ra) # 800035f0 <end_op>
    return -1;
    80004160:	557d                	li	a0,-1
    80004162:	bfc9                	j	80004134 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004164:	854a                	mv	a0,s2
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	ed6080e7          	jalr	-298(ra) # 8000103c <proc_pagetable>
    8000416e:	8baa                	mv	s7,a0
    80004170:	d945                	beqz	a0,80004120 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004172:	e7042983          	lw	s3,-400(s0)
    80004176:	e8845783          	lhu	a5,-376(s0)
    8000417a:	c7ad                	beqz	a5,800041e4 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000417c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000417e:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004180:	6c85                	lui	s9,0x1
    80004182:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004186:	def43823          	sd	a5,-528(s0)
    8000418a:	a42d                	j	800043b4 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000418c:	00004517          	auipc	a0,0x4
    80004190:	51c50513          	addi	a0,a0,1308 # 800086a8 <syscalls+0x280>
    80004194:	00002097          	auipc	ra,0x2
    80004198:	ab4080e7          	jalr	-1356(ra) # 80005c48 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000419c:	8756                	mv	a4,s5
    8000419e:	012d86bb          	addw	a3,s11,s2
    800041a2:	4581                	li	a1,0
    800041a4:	8526                	mv	a0,s1
    800041a6:	fffff097          	auipc	ra,0xfffff
    800041aa:	cac080e7          	jalr	-852(ra) # 80002e52 <readi>
    800041ae:	2501                	sext.w	a0,a0
    800041b0:	1aaa9963          	bne	s5,a0,80004362 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041b4:	6785                	lui	a5,0x1
    800041b6:	0127893b          	addw	s2,a5,s2
    800041ba:	77fd                	lui	a5,0xfffff
    800041bc:	01478a3b          	addw	s4,a5,s4
    800041c0:	1f897163          	bgeu	s2,s8,800043a2 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041c4:	02091593          	slli	a1,s2,0x20
    800041c8:	9181                	srli	a1,a1,0x20
    800041ca:	95ea                	add	a1,a1,s10
    800041cc:	855e                	mv	a0,s7
    800041ce:	ffffc097          	auipc	ra,0xffffc
    800041d2:	338080e7          	jalr	824(ra) # 80000506 <walkaddr>
    800041d6:	862a                	mv	a2,a0
    if(pa == 0)
    800041d8:	d955                	beqz	a0,8000418c <exec+0xf0>
      n = PGSIZE;
    800041da:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041dc:	fd9a70e3          	bgeu	s4,s9,8000419c <exec+0x100>
      n = sz - i;
    800041e0:	8ad2                	mv	s5,s4
    800041e2:	bf6d                	j	8000419c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041e4:	4901                	li	s2,0
  iunlockput(ip);
    800041e6:	8526                	mv	a0,s1
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	c18080e7          	jalr	-1000(ra) # 80002e00 <iunlockput>
  end_op();
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	400080e7          	jalr	1024(ra) # 800035f0 <end_op>
  p = myproc();
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	d80080e7          	jalr	-640(ra) # 80000f78 <myproc>
    80004200:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004202:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004206:	6785                	lui	a5,0x1
    80004208:	17fd                	addi	a5,a5,-1
    8000420a:	993e                	add	s2,s2,a5
    8000420c:	757d                	lui	a0,0xfffff
    8000420e:	00a977b3          	and	a5,s2,a0
    80004212:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004216:	6609                	lui	a2,0x2
    80004218:	963e                	add	a2,a2,a5
    8000421a:	85be                	mv	a1,a5
    8000421c:	855e                	mv	a0,s7
    8000421e:	ffffc097          	auipc	ra,0xffffc
    80004222:	69c080e7          	jalr	1692(ra) # 800008ba <uvmalloc>
    80004226:	8b2a                	mv	s6,a0
  ip = 0;
    80004228:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000422a:	12050c63          	beqz	a0,80004362 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000422e:	75f9                	lui	a1,0xffffe
    80004230:	95aa                	add	a1,a1,a0
    80004232:	855e                	mv	a0,s7
    80004234:	ffffd097          	auipc	ra,0xffffd
    80004238:	8a4080e7          	jalr	-1884(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000423c:	7c7d                	lui	s8,0xfffff
    8000423e:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004240:	e0043783          	ld	a5,-512(s0)
    80004244:	6388                	ld	a0,0(a5)
    80004246:	c535                	beqz	a0,800042b2 <exec+0x216>
    80004248:	e9040993          	addi	s3,s0,-368
    8000424c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004250:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004252:	ffffc097          	auipc	ra,0xffffc
    80004256:	0aa080e7          	jalr	170(ra) # 800002fc <strlen>
    8000425a:	2505                	addiw	a0,a0,1
    8000425c:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004260:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004264:	13896363          	bltu	s2,s8,8000438a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004268:	e0043d83          	ld	s11,-512(s0)
    8000426c:	000dba03          	ld	s4,0(s11)
    80004270:	8552                	mv	a0,s4
    80004272:	ffffc097          	auipc	ra,0xffffc
    80004276:	08a080e7          	jalr	138(ra) # 800002fc <strlen>
    8000427a:	0015069b          	addiw	a3,a0,1
    8000427e:	8652                	mv	a2,s4
    80004280:	85ca                	mv	a1,s2
    80004282:	855e                	mv	a0,s7
    80004284:	ffffd097          	auipc	ra,0xffffd
    80004288:	886080e7          	jalr	-1914(ra) # 80000b0a <copyout>
    8000428c:	10054363          	bltz	a0,80004392 <exec+0x2f6>
    ustack[argc] = sp;
    80004290:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004294:	0485                	addi	s1,s1,1
    80004296:	008d8793          	addi	a5,s11,8
    8000429a:	e0f43023          	sd	a5,-512(s0)
    8000429e:	008db503          	ld	a0,8(s11)
    800042a2:	c911                	beqz	a0,800042b6 <exec+0x21a>
    if(argc >= MAXARG)
    800042a4:	09a1                	addi	s3,s3,8
    800042a6:	fb3c96e3          	bne	s9,s3,80004252 <exec+0x1b6>
  sz = sz1;
    800042aa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042ae:	4481                	li	s1,0
    800042b0:	a84d                	j	80004362 <exec+0x2c6>
  sp = sz;
    800042b2:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042b4:	4481                	li	s1,0
  ustack[argc] = 0;
    800042b6:	00349793          	slli	a5,s1,0x3
    800042ba:	f9040713          	addi	a4,s0,-112
    800042be:	97ba                	add	a5,a5,a4
    800042c0:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042c4:	00148693          	addi	a3,s1,1
    800042c8:	068e                	slli	a3,a3,0x3
    800042ca:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042ce:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042d2:	01897663          	bgeu	s2,s8,800042de <exec+0x242>
  sz = sz1;
    800042d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042da:	4481                	li	s1,0
    800042dc:	a059                	j	80004362 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042de:	e9040613          	addi	a2,s0,-368
    800042e2:	85ca                	mv	a1,s2
    800042e4:	855e                	mv	a0,s7
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	824080e7          	jalr	-2012(ra) # 80000b0a <copyout>
    800042ee:	0a054663          	bltz	a0,8000439a <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042f2:	060ab783          	ld	a5,96(s5)
    800042f6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042fa:	df843783          	ld	a5,-520(s0)
    800042fe:	0007c703          	lbu	a4,0(a5)
    80004302:	cf11                	beqz	a4,8000431e <exec+0x282>
    80004304:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004306:	02f00693          	li	a3,47
    8000430a:	a039                	j	80004318 <exec+0x27c>
      last = s+1;
    8000430c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004310:	0785                	addi	a5,a5,1
    80004312:	fff7c703          	lbu	a4,-1(a5)
    80004316:	c701                	beqz	a4,8000431e <exec+0x282>
    if(*s == '/')
    80004318:	fed71ce3          	bne	a4,a3,80004310 <exec+0x274>
    8000431c:	bfc5                	j	8000430c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000431e:	4641                	li	a2,16
    80004320:	df843583          	ld	a1,-520(s0)
    80004324:	160a8513          	addi	a0,s5,352
    80004328:	ffffc097          	auipc	ra,0xffffc
    8000432c:	fa2080e7          	jalr	-94(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004330:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004334:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004338:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000433c:	060ab783          	ld	a5,96(s5)
    80004340:	e6843703          	ld	a4,-408(s0)
    80004344:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004346:	060ab783          	ld	a5,96(s5)
    8000434a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000434e:	85ea                	mv	a1,s10
    80004350:	ffffd097          	auipc	ra,0xffffd
    80004354:	d88080e7          	jalr	-632(ra) # 800010d8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004358:	0004851b          	sext.w	a0,s1
    8000435c:	bbe1                	j	80004134 <exec+0x98>
    8000435e:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004362:	e0843583          	ld	a1,-504(s0)
    80004366:	855e                	mv	a0,s7
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	d70080e7          	jalr	-656(ra) # 800010d8 <proc_freepagetable>
  if(ip){
    80004370:	da0498e3          	bnez	s1,80004120 <exec+0x84>
  return -1;
    80004374:	557d                	li	a0,-1
    80004376:	bb7d                	j	80004134 <exec+0x98>
    80004378:	e1243423          	sd	s2,-504(s0)
    8000437c:	b7dd                	j	80004362 <exec+0x2c6>
    8000437e:	e1243423          	sd	s2,-504(s0)
    80004382:	b7c5                	j	80004362 <exec+0x2c6>
    80004384:	e1243423          	sd	s2,-504(s0)
    80004388:	bfe9                	j	80004362 <exec+0x2c6>
  sz = sz1;
    8000438a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000438e:	4481                	li	s1,0
    80004390:	bfc9                	j	80004362 <exec+0x2c6>
  sz = sz1;
    80004392:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004396:	4481                	li	s1,0
    80004398:	b7e9                	j	80004362 <exec+0x2c6>
  sz = sz1;
    8000439a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000439e:	4481                	li	s1,0
    800043a0:	b7c9                	j	80004362 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043a2:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043a6:	2b05                	addiw	s6,s6,1
    800043a8:	0389899b          	addiw	s3,s3,56
    800043ac:	e8845783          	lhu	a5,-376(s0)
    800043b0:	e2fb5be3          	bge	s6,a5,800041e6 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043b4:	2981                	sext.w	s3,s3
    800043b6:	03800713          	li	a4,56
    800043ba:	86ce                	mv	a3,s3
    800043bc:	e1840613          	addi	a2,s0,-488
    800043c0:	4581                	li	a1,0
    800043c2:	8526                	mv	a0,s1
    800043c4:	fffff097          	auipc	ra,0xfffff
    800043c8:	a8e080e7          	jalr	-1394(ra) # 80002e52 <readi>
    800043cc:	03800793          	li	a5,56
    800043d0:	f8f517e3          	bne	a0,a5,8000435e <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043d4:	e1842783          	lw	a5,-488(s0)
    800043d8:	4705                	li	a4,1
    800043da:	fce796e3          	bne	a5,a4,800043a6 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043de:	e4043603          	ld	a2,-448(s0)
    800043e2:	e3843783          	ld	a5,-456(s0)
    800043e6:	f8f669e3          	bltu	a2,a5,80004378 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043ea:	e2843783          	ld	a5,-472(s0)
    800043ee:	963e                	add	a2,a2,a5
    800043f0:	f8f667e3          	bltu	a2,a5,8000437e <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043f4:	85ca                	mv	a1,s2
    800043f6:	855e                	mv	a0,s7
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	4c2080e7          	jalr	1218(ra) # 800008ba <uvmalloc>
    80004400:	e0a43423          	sd	a0,-504(s0)
    80004404:	d141                	beqz	a0,80004384 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004406:	e2843d03          	ld	s10,-472(s0)
    8000440a:	df043783          	ld	a5,-528(s0)
    8000440e:	00fd77b3          	and	a5,s10,a5
    80004412:	fba1                	bnez	a5,80004362 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004414:	e2042d83          	lw	s11,-480(s0)
    80004418:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000441c:	f80c03e3          	beqz	s8,800043a2 <exec+0x306>
    80004420:	8a62                	mv	s4,s8
    80004422:	4901                	li	s2,0
    80004424:	b345                	j	800041c4 <exec+0x128>

0000000080004426 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004426:	7179                	addi	sp,sp,-48
    80004428:	f406                	sd	ra,40(sp)
    8000442a:	f022                	sd	s0,32(sp)
    8000442c:	ec26                	sd	s1,24(sp)
    8000442e:	e84a                	sd	s2,16(sp)
    80004430:	1800                	addi	s0,sp,48
    80004432:	892e                	mv	s2,a1
    80004434:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004436:	fdc40593          	addi	a1,s0,-36
    8000443a:	ffffe097          	auipc	ra,0xffffe
    8000443e:	bea080e7          	jalr	-1046(ra) # 80002024 <argint>
    80004442:	04054063          	bltz	a0,80004482 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004446:	fdc42703          	lw	a4,-36(s0)
    8000444a:	47bd                	li	a5,15
    8000444c:	02e7ed63          	bltu	a5,a4,80004486 <argfd+0x60>
    80004450:	ffffd097          	auipc	ra,0xffffd
    80004454:	b28080e7          	jalr	-1240(ra) # 80000f78 <myproc>
    80004458:	fdc42703          	lw	a4,-36(s0)
    8000445c:	01a70793          	addi	a5,a4,26
    80004460:	078e                	slli	a5,a5,0x3
    80004462:	953e                	add	a0,a0,a5
    80004464:	651c                	ld	a5,8(a0)
    80004466:	c395                	beqz	a5,8000448a <argfd+0x64>
    return -1;
  if(pfd)
    80004468:	00090463          	beqz	s2,80004470 <argfd+0x4a>
    *pfd = fd;
    8000446c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004470:	4501                	li	a0,0
  if(pf)
    80004472:	c091                	beqz	s1,80004476 <argfd+0x50>
    *pf = f;
    80004474:	e09c                	sd	a5,0(s1)
}
    80004476:	70a2                	ld	ra,40(sp)
    80004478:	7402                	ld	s0,32(sp)
    8000447a:	64e2                	ld	s1,24(sp)
    8000447c:	6942                	ld	s2,16(sp)
    8000447e:	6145                	addi	sp,sp,48
    80004480:	8082                	ret
    return -1;
    80004482:	557d                	li	a0,-1
    80004484:	bfcd                	j	80004476 <argfd+0x50>
    return -1;
    80004486:	557d                	li	a0,-1
    80004488:	b7fd                	j	80004476 <argfd+0x50>
    8000448a:	557d                	li	a0,-1
    8000448c:	b7ed                	j	80004476 <argfd+0x50>

000000008000448e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000448e:	1101                	addi	sp,sp,-32
    80004490:	ec06                	sd	ra,24(sp)
    80004492:	e822                	sd	s0,16(sp)
    80004494:	e426                	sd	s1,8(sp)
    80004496:	1000                	addi	s0,sp,32
    80004498:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000449a:	ffffd097          	auipc	ra,0xffffd
    8000449e:	ade080e7          	jalr	-1314(ra) # 80000f78 <myproc>
    800044a2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044a4:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    800044a8:	4501                	li	a0,0
    800044aa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044ac:	6398                	ld	a4,0(a5)
    800044ae:	cb19                	beqz	a4,800044c4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044b0:	2505                	addiw	a0,a0,1
    800044b2:	07a1                	addi	a5,a5,8
    800044b4:	fed51ce3          	bne	a0,a3,800044ac <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044b8:	557d                	li	a0,-1
}
    800044ba:	60e2                	ld	ra,24(sp)
    800044bc:	6442                	ld	s0,16(sp)
    800044be:	64a2                	ld	s1,8(sp)
    800044c0:	6105                	addi	sp,sp,32
    800044c2:	8082                	ret
      p->ofile[fd] = f;
    800044c4:	01a50793          	addi	a5,a0,26
    800044c8:	078e                	slli	a5,a5,0x3
    800044ca:	963e                	add	a2,a2,a5
    800044cc:	e604                	sd	s1,8(a2)
      return fd;
    800044ce:	b7f5                	j	800044ba <fdalloc+0x2c>

00000000800044d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044d0:	715d                	addi	sp,sp,-80
    800044d2:	e486                	sd	ra,72(sp)
    800044d4:	e0a2                	sd	s0,64(sp)
    800044d6:	fc26                	sd	s1,56(sp)
    800044d8:	f84a                	sd	s2,48(sp)
    800044da:	f44e                	sd	s3,40(sp)
    800044dc:	f052                	sd	s4,32(sp)
    800044de:	ec56                	sd	s5,24(sp)
    800044e0:	0880                	addi	s0,sp,80
    800044e2:	89ae                	mv	s3,a1
    800044e4:	8ab2                	mv	s5,a2
    800044e6:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044e8:	fb040593          	addi	a1,s0,-80
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	e86080e7          	jalr	-378(ra) # 80003372 <nameiparent>
    800044f4:	892a                	mv	s2,a0
    800044f6:	12050f63          	beqz	a0,80004634 <create+0x164>
    return 0;

  ilock(dp);
    800044fa:	ffffe097          	auipc	ra,0xffffe
    800044fe:	6a4080e7          	jalr	1700(ra) # 80002b9e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004502:	4601                	li	a2,0
    80004504:	fb040593          	addi	a1,s0,-80
    80004508:	854a                	mv	a0,s2
    8000450a:	fffff097          	auipc	ra,0xfffff
    8000450e:	b78080e7          	jalr	-1160(ra) # 80003082 <dirlookup>
    80004512:	84aa                	mv	s1,a0
    80004514:	c921                	beqz	a0,80004564 <create+0x94>
    iunlockput(dp);
    80004516:	854a                	mv	a0,s2
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	8e8080e7          	jalr	-1816(ra) # 80002e00 <iunlockput>
    ilock(ip);
    80004520:	8526                	mv	a0,s1
    80004522:	ffffe097          	auipc	ra,0xffffe
    80004526:	67c080e7          	jalr	1660(ra) # 80002b9e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000452a:	2981                	sext.w	s3,s3
    8000452c:	4789                	li	a5,2
    8000452e:	02f99463          	bne	s3,a5,80004556 <create+0x86>
    80004532:	0444d783          	lhu	a5,68(s1)
    80004536:	37f9                	addiw	a5,a5,-2
    80004538:	17c2                	slli	a5,a5,0x30
    8000453a:	93c1                	srli	a5,a5,0x30
    8000453c:	4705                	li	a4,1
    8000453e:	00f76c63          	bltu	a4,a5,80004556 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004542:	8526                	mv	a0,s1
    80004544:	60a6                	ld	ra,72(sp)
    80004546:	6406                	ld	s0,64(sp)
    80004548:	74e2                	ld	s1,56(sp)
    8000454a:	7942                	ld	s2,48(sp)
    8000454c:	79a2                	ld	s3,40(sp)
    8000454e:	7a02                	ld	s4,32(sp)
    80004550:	6ae2                	ld	s5,24(sp)
    80004552:	6161                	addi	sp,sp,80
    80004554:	8082                	ret
    iunlockput(ip);
    80004556:	8526                	mv	a0,s1
    80004558:	fffff097          	auipc	ra,0xfffff
    8000455c:	8a8080e7          	jalr	-1880(ra) # 80002e00 <iunlockput>
    return 0;
    80004560:	4481                	li	s1,0
    80004562:	b7c5                	j	80004542 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004564:	85ce                	mv	a1,s3
    80004566:	00092503          	lw	a0,0(s2)
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	49c080e7          	jalr	1180(ra) # 80002a06 <ialloc>
    80004572:	84aa                	mv	s1,a0
    80004574:	c529                	beqz	a0,800045be <create+0xee>
  ilock(ip);
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	628080e7          	jalr	1576(ra) # 80002b9e <ilock>
  ip->major = major;
    8000457e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004582:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004586:	4785                	li	a5,1
    80004588:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000458c:	8526                	mv	a0,s1
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	546080e7          	jalr	1350(ra) # 80002ad4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004596:	2981                	sext.w	s3,s3
    80004598:	4785                	li	a5,1
    8000459a:	02f98a63          	beq	s3,a5,800045ce <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000459e:	40d0                	lw	a2,4(s1)
    800045a0:	fb040593          	addi	a1,s0,-80
    800045a4:	854a                	mv	a0,s2
    800045a6:	fffff097          	auipc	ra,0xfffff
    800045aa:	cec080e7          	jalr	-788(ra) # 80003292 <dirlink>
    800045ae:	06054b63          	bltz	a0,80004624 <create+0x154>
  iunlockput(dp);
    800045b2:	854a                	mv	a0,s2
    800045b4:	fffff097          	auipc	ra,0xfffff
    800045b8:	84c080e7          	jalr	-1972(ra) # 80002e00 <iunlockput>
  return ip;
    800045bc:	b759                	j	80004542 <create+0x72>
    panic("create: ialloc");
    800045be:	00004517          	auipc	a0,0x4
    800045c2:	10a50513          	addi	a0,a0,266 # 800086c8 <syscalls+0x2a0>
    800045c6:	00001097          	auipc	ra,0x1
    800045ca:	682080e7          	jalr	1666(ra) # 80005c48 <panic>
    dp->nlink++;  // for ".."
    800045ce:	04a95783          	lhu	a5,74(s2)
    800045d2:	2785                	addiw	a5,a5,1
    800045d4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045d8:	854a                	mv	a0,s2
    800045da:	ffffe097          	auipc	ra,0xffffe
    800045de:	4fa080e7          	jalr	1274(ra) # 80002ad4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045e2:	40d0                	lw	a2,4(s1)
    800045e4:	00004597          	auipc	a1,0x4
    800045e8:	0f458593          	addi	a1,a1,244 # 800086d8 <syscalls+0x2b0>
    800045ec:	8526                	mv	a0,s1
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	ca4080e7          	jalr	-860(ra) # 80003292 <dirlink>
    800045f6:	00054f63          	bltz	a0,80004614 <create+0x144>
    800045fa:	00492603          	lw	a2,4(s2)
    800045fe:	00004597          	auipc	a1,0x4
    80004602:	0e258593          	addi	a1,a1,226 # 800086e0 <syscalls+0x2b8>
    80004606:	8526                	mv	a0,s1
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	c8a080e7          	jalr	-886(ra) # 80003292 <dirlink>
    80004610:	f80557e3          	bgez	a0,8000459e <create+0xce>
      panic("create dots");
    80004614:	00004517          	auipc	a0,0x4
    80004618:	0d450513          	addi	a0,a0,212 # 800086e8 <syscalls+0x2c0>
    8000461c:	00001097          	auipc	ra,0x1
    80004620:	62c080e7          	jalr	1580(ra) # 80005c48 <panic>
    panic("create: dirlink");
    80004624:	00004517          	auipc	a0,0x4
    80004628:	0d450513          	addi	a0,a0,212 # 800086f8 <syscalls+0x2d0>
    8000462c:	00001097          	auipc	ra,0x1
    80004630:	61c080e7          	jalr	1564(ra) # 80005c48 <panic>
    return 0;
    80004634:	84aa                	mv	s1,a0
    80004636:	b731                	j	80004542 <create+0x72>

0000000080004638 <sys_dup>:
{
    80004638:	7179                	addi	sp,sp,-48
    8000463a:	f406                	sd	ra,40(sp)
    8000463c:	f022                	sd	s0,32(sp)
    8000463e:	ec26                	sd	s1,24(sp)
    80004640:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004642:	fd840613          	addi	a2,s0,-40
    80004646:	4581                	li	a1,0
    80004648:	4501                	li	a0,0
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	ddc080e7          	jalr	-548(ra) # 80004426 <argfd>
    return -1;
    80004652:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004654:	02054363          	bltz	a0,8000467a <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004658:	fd843503          	ld	a0,-40(s0)
    8000465c:	00000097          	auipc	ra,0x0
    80004660:	e32080e7          	jalr	-462(ra) # 8000448e <fdalloc>
    80004664:	84aa                	mv	s1,a0
    return -1;
    80004666:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004668:	00054963          	bltz	a0,8000467a <sys_dup+0x42>
  filedup(f);
    8000466c:	fd843503          	ld	a0,-40(s0)
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	37a080e7          	jalr	890(ra) # 800039ea <filedup>
  return fd;
    80004678:	87a6                	mv	a5,s1
}
    8000467a:	853e                	mv	a0,a5
    8000467c:	70a2                	ld	ra,40(sp)
    8000467e:	7402                	ld	s0,32(sp)
    80004680:	64e2                	ld	s1,24(sp)
    80004682:	6145                	addi	sp,sp,48
    80004684:	8082                	ret

0000000080004686 <sys_read>:
{
    80004686:	7179                	addi	sp,sp,-48
    80004688:	f406                	sd	ra,40(sp)
    8000468a:	f022                	sd	s0,32(sp)
    8000468c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000468e:	fe840613          	addi	a2,s0,-24
    80004692:	4581                	li	a1,0
    80004694:	4501                	li	a0,0
    80004696:	00000097          	auipc	ra,0x0
    8000469a:	d90080e7          	jalr	-624(ra) # 80004426 <argfd>
    return -1;
    8000469e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a0:	04054163          	bltz	a0,800046e2 <sys_read+0x5c>
    800046a4:	fe440593          	addi	a1,s0,-28
    800046a8:	4509                	li	a0,2
    800046aa:	ffffe097          	auipc	ra,0xffffe
    800046ae:	97a080e7          	jalr	-1670(ra) # 80002024 <argint>
    return -1;
    800046b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b4:	02054763          	bltz	a0,800046e2 <sys_read+0x5c>
    800046b8:	fd840593          	addi	a1,s0,-40
    800046bc:	4505                	li	a0,1
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	988080e7          	jalr	-1656(ra) # 80002046 <argaddr>
    return -1;
    800046c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c8:	00054d63          	bltz	a0,800046e2 <sys_read+0x5c>
  return fileread(f, p, n);
    800046cc:	fe442603          	lw	a2,-28(s0)
    800046d0:	fd843583          	ld	a1,-40(s0)
    800046d4:	fe843503          	ld	a0,-24(s0)
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	49e080e7          	jalr	1182(ra) # 80003b76 <fileread>
    800046e0:	87aa                	mv	a5,a0
}
    800046e2:	853e                	mv	a0,a5
    800046e4:	70a2                	ld	ra,40(sp)
    800046e6:	7402                	ld	s0,32(sp)
    800046e8:	6145                	addi	sp,sp,48
    800046ea:	8082                	ret

00000000800046ec <sys_write>:
{
    800046ec:	7179                	addi	sp,sp,-48
    800046ee:	f406                	sd	ra,40(sp)
    800046f0:	f022                	sd	s0,32(sp)
    800046f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f4:	fe840613          	addi	a2,s0,-24
    800046f8:	4581                	li	a1,0
    800046fa:	4501                	li	a0,0
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	d2a080e7          	jalr	-726(ra) # 80004426 <argfd>
    return -1;
    80004704:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004706:	04054163          	bltz	a0,80004748 <sys_write+0x5c>
    8000470a:	fe440593          	addi	a1,s0,-28
    8000470e:	4509                	li	a0,2
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	914080e7          	jalr	-1772(ra) # 80002024 <argint>
    return -1;
    80004718:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471a:	02054763          	bltz	a0,80004748 <sys_write+0x5c>
    8000471e:	fd840593          	addi	a1,s0,-40
    80004722:	4505                	li	a0,1
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	922080e7          	jalr	-1758(ra) # 80002046 <argaddr>
    return -1;
    8000472c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472e:	00054d63          	bltz	a0,80004748 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004732:	fe442603          	lw	a2,-28(s0)
    80004736:	fd843583          	ld	a1,-40(s0)
    8000473a:	fe843503          	ld	a0,-24(s0)
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	4fa080e7          	jalr	1274(ra) # 80003c38 <filewrite>
    80004746:	87aa                	mv	a5,a0
}
    80004748:	853e                	mv	a0,a5
    8000474a:	70a2                	ld	ra,40(sp)
    8000474c:	7402                	ld	s0,32(sp)
    8000474e:	6145                	addi	sp,sp,48
    80004750:	8082                	ret

0000000080004752 <sys_close>:
{
    80004752:	1101                	addi	sp,sp,-32
    80004754:	ec06                	sd	ra,24(sp)
    80004756:	e822                	sd	s0,16(sp)
    80004758:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000475a:	fe040613          	addi	a2,s0,-32
    8000475e:	fec40593          	addi	a1,s0,-20
    80004762:	4501                	li	a0,0
    80004764:	00000097          	auipc	ra,0x0
    80004768:	cc2080e7          	jalr	-830(ra) # 80004426 <argfd>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000476e:	02054463          	bltz	a0,80004796 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004772:	ffffd097          	auipc	ra,0xffffd
    80004776:	806080e7          	jalr	-2042(ra) # 80000f78 <myproc>
    8000477a:	fec42783          	lw	a5,-20(s0)
    8000477e:	07e9                	addi	a5,a5,26
    80004780:	078e                	slli	a5,a5,0x3
    80004782:	97aa                	add	a5,a5,a0
    80004784:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80004788:	fe043503          	ld	a0,-32(s0)
    8000478c:	fffff097          	auipc	ra,0xfffff
    80004790:	2b0080e7          	jalr	688(ra) # 80003a3c <fileclose>
  return 0;
    80004794:	4781                	li	a5,0
}
    80004796:	853e                	mv	a0,a5
    80004798:	60e2                	ld	ra,24(sp)
    8000479a:	6442                	ld	s0,16(sp)
    8000479c:	6105                	addi	sp,sp,32
    8000479e:	8082                	ret

00000000800047a0 <sys_fstat>:
{
    800047a0:	1101                	addi	sp,sp,-32
    800047a2:	ec06                	sd	ra,24(sp)
    800047a4:	e822                	sd	s0,16(sp)
    800047a6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047a8:	fe840613          	addi	a2,s0,-24
    800047ac:	4581                	li	a1,0
    800047ae:	4501                	li	a0,0
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	c76080e7          	jalr	-906(ra) # 80004426 <argfd>
    return -1;
    800047b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ba:	02054563          	bltz	a0,800047e4 <sys_fstat+0x44>
    800047be:	fe040593          	addi	a1,s0,-32
    800047c2:	4505                	li	a0,1
    800047c4:	ffffe097          	auipc	ra,0xffffe
    800047c8:	882080e7          	jalr	-1918(ra) # 80002046 <argaddr>
    return -1;
    800047cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ce:	00054b63          	bltz	a0,800047e4 <sys_fstat+0x44>
  return filestat(f, st);
    800047d2:	fe043583          	ld	a1,-32(s0)
    800047d6:	fe843503          	ld	a0,-24(s0)
    800047da:	fffff097          	auipc	ra,0xfffff
    800047de:	32a080e7          	jalr	810(ra) # 80003b04 <filestat>
    800047e2:	87aa                	mv	a5,a0
}
    800047e4:	853e                	mv	a0,a5
    800047e6:	60e2                	ld	ra,24(sp)
    800047e8:	6442                	ld	s0,16(sp)
    800047ea:	6105                	addi	sp,sp,32
    800047ec:	8082                	ret

00000000800047ee <sys_link>:
{
    800047ee:	7169                	addi	sp,sp,-304
    800047f0:	f606                	sd	ra,296(sp)
    800047f2:	f222                	sd	s0,288(sp)
    800047f4:	ee26                	sd	s1,280(sp)
    800047f6:	ea4a                	sd	s2,272(sp)
    800047f8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047fa:	08000613          	li	a2,128
    800047fe:	ed040593          	addi	a1,s0,-304
    80004802:	4501                	li	a0,0
    80004804:	ffffe097          	auipc	ra,0xffffe
    80004808:	864080e7          	jalr	-1948(ra) # 80002068 <argstr>
    return -1;
    8000480c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000480e:	10054e63          	bltz	a0,8000492a <sys_link+0x13c>
    80004812:	08000613          	li	a2,128
    80004816:	f5040593          	addi	a1,s0,-176
    8000481a:	4505                	li	a0,1
    8000481c:	ffffe097          	auipc	ra,0xffffe
    80004820:	84c080e7          	jalr	-1972(ra) # 80002068 <argstr>
    return -1;
    80004824:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004826:	10054263          	bltz	a0,8000492a <sys_link+0x13c>
  begin_op();
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	d46080e7          	jalr	-698(ra) # 80003570 <begin_op>
  if((ip = namei(old)) == 0){
    80004832:	ed040513          	addi	a0,s0,-304
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	b1e080e7          	jalr	-1250(ra) # 80003354 <namei>
    8000483e:	84aa                	mv	s1,a0
    80004840:	c551                	beqz	a0,800048cc <sys_link+0xde>
  ilock(ip);
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	35c080e7          	jalr	860(ra) # 80002b9e <ilock>
  if(ip->type == T_DIR){
    8000484a:	04449703          	lh	a4,68(s1)
    8000484e:	4785                	li	a5,1
    80004850:	08f70463          	beq	a4,a5,800048d8 <sys_link+0xea>
  ip->nlink++;
    80004854:	04a4d783          	lhu	a5,74(s1)
    80004858:	2785                	addiw	a5,a5,1
    8000485a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000485e:	8526                	mv	a0,s1
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	274080e7          	jalr	628(ra) # 80002ad4 <iupdate>
  iunlock(ip);
    80004868:	8526                	mv	a0,s1
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	3f6080e7          	jalr	1014(ra) # 80002c60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004872:	fd040593          	addi	a1,s0,-48
    80004876:	f5040513          	addi	a0,s0,-176
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	af8080e7          	jalr	-1288(ra) # 80003372 <nameiparent>
    80004882:	892a                	mv	s2,a0
    80004884:	c935                	beqz	a0,800048f8 <sys_link+0x10a>
  ilock(dp);
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	318080e7          	jalr	792(ra) # 80002b9e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000488e:	00092703          	lw	a4,0(s2)
    80004892:	409c                	lw	a5,0(s1)
    80004894:	04f71d63          	bne	a4,a5,800048ee <sys_link+0x100>
    80004898:	40d0                	lw	a2,4(s1)
    8000489a:	fd040593          	addi	a1,s0,-48
    8000489e:	854a                	mv	a0,s2
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	9f2080e7          	jalr	-1550(ra) # 80003292 <dirlink>
    800048a8:	04054363          	bltz	a0,800048ee <sys_link+0x100>
  iunlockput(dp);
    800048ac:	854a                	mv	a0,s2
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	552080e7          	jalr	1362(ra) # 80002e00 <iunlockput>
  iput(ip);
    800048b6:	8526                	mv	a0,s1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	4a0080e7          	jalr	1184(ra) # 80002d58 <iput>
  end_op();
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	d30080e7          	jalr	-720(ra) # 800035f0 <end_op>
  return 0;
    800048c8:	4781                	li	a5,0
    800048ca:	a085                	j	8000492a <sys_link+0x13c>
    end_op();
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	d24080e7          	jalr	-732(ra) # 800035f0 <end_op>
    return -1;
    800048d4:	57fd                	li	a5,-1
    800048d6:	a891                	j	8000492a <sys_link+0x13c>
    iunlockput(ip);
    800048d8:	8526                	mv	a0,s1
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	526080e7          	jalr	1318(ra) # 80002e00 <iunlockput>
    end_op();
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	d0e080e7          	jalr	-754(ra) # 800035f0 <end_op>
    return -1;
    800048ea:	57fd                	li	a5,-1
    800048ec:	a83d                	j	8000492a <sys_link+0x13c>
    iunlockput(dp);
    800048ee:	854a                	mv	a0,s2
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	510080e7          	jalr	1296(ra) # 80002e00 <iunlockput>
  ilock(ip);
    800048f8:	8526                	mv	a0,s1
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	2a4080e7          	jalr	676(ra) # 80002b9e <ilock>
  ip->nlink--;
    80004902:	04a4d783          	lhu	a5,74(s1)
    80004906:	37fd                	addiw	a5,a5,-1
    80004908:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000490c:	8526                	mv	a0,s1
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	1c6080e7          	jalr	454(ra) # 80002ad4 <iupdate>
  iunlockput(ip);
    80004916:	8526                	mv	a0,s1
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	4e8080e7          	jalr	1256(ra) # 80002e00 <iunlockput>
  end_op();
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	cd0080e7          	jalr	-816(ra) # 800035f0 <end_op>
  return -1;
    80004928:	57fd                	li	a5,-1
}
    8000492a:	853e                	mv	a0,a5
    8000492c:	70b2                	ld	ra,296(sp)
    8000492e:	7412                	ld	s0,288(sp)
    80004930:	64f2                	ld	s1,280(sp)
    80004932:	6952                	ld	s2,272(sp)
    80004934:	6155                	addi	sp,sp,304
    80004936:	8082                	ret

0000000080004938 <sys_unlink>:
{
    80004938:	7151                	addi	sp,sp,-240
    8000493a:	f586                	sd	ra,232(sp)
    8000493c:	f1a2                	sd	s0,224(sp)
    8000493e:	eda6                	sd	s1,216(sp)
    80004940:	e9ca                	sd	s2,208(sp)
    80004942:	e5ce                	sd	s3,200(sp)
    80004944:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004946:	08000613          	li	a2,128
    8000494a:	f3040593          	addi	a1,s0,-208
    8000494e:	4501                	li	a0,0
    80004950:	ffffd097          	auipc	ra,0xffffd
    80004954:	718080e7          	jalr	1816(ra) # 80002068 <argstr>
    80004958:	18054163          	bltz	a0,80004ada <sys_unlink+0x1a2>
  begin_op();
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	c14080e7          	jalr	-1004(ra) # 80003570 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004964:	fb040593          	addi	a1,s0,-80
    80004968:	f3040513          	addi	a0,s0,-208
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	a06080e7          	jalr	-1530(ra) # 80003372 <nameiparent>
    80004974:	84aa                	mv	s1,a0
    80004976:	c979                	beqz	a0,80004a4c <sys_unlink+0x114>
  ilock(dp);
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	226080e7          	jalr	550(ra) # 80002b9e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004980:	00004597          	auipc	a1,0x4
    80004984:	d5858593          	addi	a1,a1,-680 # 800086d8 <syscalls+0x2b0>
    80004988:	fb040513          	addi	a0,s0,-80
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	6dc080e7          	jalr	1756(ra) # 80003068 <namecmp>
    80004994:	14050a63          	beqz	a0,80004ae8 <sys_unlink+0x1b0>
    80004998:	00004597          	auipc	a1,0x4
    8000499c:	d4858593          	addi	a1,a1,-696 # 800086e0 <syscalls+0x2b8>
    800049a0:	fb040513          	addi	a0,s0,-80
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	6c4080e7          	jalr	1732(ra) # 80003068 <namecmp>
    800049ac:	12050e63          	beqz	a0,80004ae8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049b0:	f2c40613          	addi	a2,s0,-212
    800049b4:	fb040593          	addi	a1,s0,-80
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	6c8080e7          	jalr	1736(ra) # 80003082 <dirlookup>
    800049c2:	892a                	mv	s2,a0
    800049c4:	12050263          	beqz	a0,80004ae8 <sys_unlink+0x1b0>
  ilock(ip);
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	1d6080e7          	jalr	470(ra) # 80002b9e <ilock>
  if(ip->nlink < 1)
    800049d0:	04a91783          	lh	a5,74(s2)
    800049d4:	08f05263          	blez	a5,80004a58 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049d8:	04491703          	lh	a4,68(s2)
    800049dc:	4785                	li	a5,1
    800049de:	08f70563          	beq	a4,a5,80004a68 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049e2:	4641                	li	a2,16
    800049e4:	4581                	li	a1,0
    800049e6:	fc040513          	addi	a0,s0,-64
    800049ea:	ffffb097          	auipc	ra,0xffffb
    800049ee:	78e080e7          	jalr	1934(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f2:	4741                	li	a4,16
    800049f4:	f2c42683          	lw	a3,-212(s0)
    800049f8:	fc040613          	addi	a2,s0,-64
    800049fc:	4581                	li	a1,0
    800049fe:	8526                	mv	a0,s1
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	54a080e7          	jalr	1354(ra) # 80002f4a <writei>
    80004a08:	47c1                	li	a5,16
    80004a0a:	0af51563          	bne	a0,a5,80004ab4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a0e:	04491703          	lh	a4,68(s2)
    80004a12:	4785                	li	a5,1
    80004a14:	0af70863          	beq	a4,a5,80004ac4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	3e6080e7          	jalr	998(ra) # 80002e00 <iunlockput>
  ip->nlink--;
    80004a22:	04a95783          	lhu	a5,74(s2)
    80004a26:	37fd                	addiw	a5,a5,-1
    80004a28:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a2c:	854a                	mv	a0,s2
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	0a6080e7          	jalr	166(ra) # 80002ad4 <iupdate>
  iunlockput(ip);
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	3c8080e7          	jalr	968(ra) # 80002e00 <iunlockput>
  end_op();
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	bb0080e7          	jalr	-1104(ra) # 800035f0 <end_op>
  return 0;
    80004a48:	4501                	li	a0,0
    80004a4a:	a84d                	j	80004afc <sys_unlink+0x1c4>
    end_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	ba4080e7          	jalr	-1116(ra) # 800035f0 <end_op>
    return -1;
    80004a54:	557d                	li	a0,-1
    80004a56:	a05d                	j	80004afc <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a58:	00004517          	auipc	a0,0x4
    80004a5c:	cb050513          	addi	a0,a0,-848 # 80008708 <syscalls+0x2e0>
    80004a60:	00001097          	auipc	ra,0x1
    80004a64:	1e8080e7          	jalr	488(ra) # 80005c48 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a68:	04c92703          	lw	a4,76(s2)
    80004a6c:	02000793          	li	a5,32
    80004a70:	f6e7f9e3          	bgeu	a5,a4,800049e2 <sys_unlink+0xaa>
    80004a74:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a78:	4741                	li	a4,16
    80004a7a:	86ce                	mv	a3,s3
    80004a7c:	f1840613          	addi	a2,s0,-232
    80004a80:	4581                	li	a1,0
    80004a82:	854a                	mv	a0,s2
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	3ce080e7          	jalr	974(ra) # 80002e52 <readi>
    80004a8c:	47c1                	li	a5,16
    80004a8e:	00f51b63          	bne	a0,a5,80004aa4 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a92:	f1845783          	lhu	a5,-232(s0)
    80004a96:	e7a1                	bnez	a5,80004ade <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a98:	29c1                	addiw	s3,s3,16
    80004a9a:	04c92783          	lw	a5,76(s2)
    80004a9e:	fcf9ede3          	bltu	s3,a5,80004a78 <sys_unlink+0x140>
    80004aa2:	b781                	j	800049e2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aa4:	00004517          	auipc	a0,0x4
    80004aa8:	c7c50513          	addi	a0,a0,-900 # 80008720 <syscalls+0x2f8>
    80004aac:	00001097          	auipc	ra,0x1
    80004ab0:	19c080e7          	jalr	412(ra) # 80005c48 <panic>
    panic("unlink: writei");
    80004ab4:	00004517          	auipc	a0,0x4
    80004ab8:	c8450513          	addi	a0,a0,-892 # 80008738 <syscalls+0x310>
    80004abc:	00001097          	auipc	ra,0x1
    80004ac0:	18c080e7          	jalr	396(ra) # 80005c48 <panic>
    dp->nlink--;
    80004ac4:	04a4d783          	lhu	a5,74(s1)
    80004ac8:	37fd                	addiw	a5,a5,-1
    80004aca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	004080e7          	jalr	4(ra) # 80002ad4 <iupdate>
    80004ad8:	b781                	j	80004a18 <sys_unlink+0xe0>
    return -1;
    80004ada:	557d                	li	a0,-1
    80004adc:	a005                	j	80004afc <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ade:	854a                	mv	a0,s2
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	320080e7          	jalr	800(ra) # 80002e00 <iunlockput>
  iunlockput(dp);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	316080e7          	jalr	790(ra) # 80002e00 <iunlockput>
  end_op();
    80004af2:	fffff097          	auipc	ra,0xfffff
    80004af6:	afe080e7          	jalr	-1282(ra) # 800035f0 <end_op>
  return -1;
    80004afa:	557d                	li	a0,-1
}
    80004afc:	70ae                	ld	ra,232(sp)
    80004afe:	740e                	ld	s0,224(sp)
    80004b00:	64ee                	ld	s1,216(sp)
    80004b02:	694e                	ld	s2,208(sp)
    80004b04:	69ae                	ld	s3,200(sp)
    80004b06:	616d                	addi	sp,sp,240
    80004b08:	8082                	ret

0000000080004b0a <sys_open>:

uint64
sys_open(void)
{
    80004b0a:	7131                	addi	sp,sp,-192
    80004b0c:	fd06                	sd	ra,184(sp)
    80004b0e:	f922                	sd	s0,176(sp)
    80004b10:	f526                	sd	s1,168(sp)
    80004b12:	f14a                	sd	s2,160(sp)
    80004b14:	ed4e                	sd	s3,152(sp)
    80004b16:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b18:	08000613          	li	a2,128
    80004b1c:	f5040593          	addi	a1,s0,-176
    80004b20:	4501                	li	a0,0
    80004b22:	ffffd097          	auipc	ra,0xffffd
    80004b26:	546080e7          	jalr	1350(ra) # 80002068 <argstr>
    return -1;
    80004b2a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b2c:	0c054163          	bltz	a0,80004bee <sys_open+0xe4>
    80004b30:	f4c40593          	addi	a1,s0,-180
    80004b34:	4505                	li	a0,1
    80004b36:	ffffd097          	auipc	ra,0xffffd
    80004b3a:	4ee080e7          	jalr	1262(ra) # 80002024 <argint>
    80004b3e:	0a054863          	bltz	a0,80004bee <sys_open+0xe4>

  begin_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	a2e080e7          	jalr	-1490(ra) # 80003570 <begin_op>

  if(omode & O_CREATE){
    80004b4a:	f4c42783          	lw	a5,-180(s0)
    80004b4e:	2007f793          	andi	a5,a5,512
    80004b52:	cbdd                	beqz	a5,80004c08 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b54:	4681                	li	a3,0
    80004b56:	4601                	li	a2,0
    80004b58:	4589                	li	a1,2
    80004b5a:	f5040513          	addi	a0,s0,-176
    80004b5e:	00000097          	auipc	ra,0x0
    80004b62:	972080e7          	jalr	-1678(ra) # 800044d0 <create>
    80004b66:	892a                	mv	s2,a0
    if(ip == 0){
    80004b68:	c959                	beqz	a0,80004bfe <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b6a:	04491703          	lh	a4,68(s2)
    80004b6e:	478d                	li	a5,3
    80004b70:	00f71763          	bne	a4,a5,80004b7e <sys_open+0x74>
    80004b74:	04695703          	lhu	a4,70(s2)
    80004b78:	47a5                	li	a5,9
    80004b7a:	0ce7ec63          	bltu	a5,a4,80004c52 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	e02080e7          	jalr	-510(ra) # 80003980 <filealloc>
    80004b86:	89aa                	mv	s3,a0
    80004b88:	10050263          	beqz	a0,80004c8c <sys_open+0x182>
    80004b8c:	00000097          	auipc	ra,0x0
    80004b90:	902080e7          	jalr	-1790(ra) # 8000448e <fdalloc>
    80004b94:	84aa                	mv	s1,a0
    80004b96:	0e054663          	bltz	a0,80004c82 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b9a:	04491703          	lh	a4,68(s2)
    80004b9e:	478d                	li	a5,3
    80004ba0:	0cf70463          	beq	a4,a5,80004c68 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ba4:	4789                	li	a5,2
    80004ba6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004baa:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bae:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bb2:	f4c42783          	lw	a5,-180(s0)
    80004bb6:	0017c713          	xori	a4,a5,1
    80004bba:	8b05                	andi	a4,a4,1
    80004bbc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bc0:	0037f713          	andi	a4,a5,3
    80004bc4:	00e03733          	snez	a4,a4
    80004bc8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bcc:	4007f793          	andi	a5,a5,1024
    80004bd0:	c791                	beqz	a5,80004bdc <sys_open+0xd2>
    80004bd2:	04491703          	lh	a4,68(s2)
    80004bd6:	4789                	li	a5,2
    80004bd8:	08f70f63          	beq	a4,a5,80004c76 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bdc:	854a                	mv	a0,s2
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	082080e7          	jalr	130(ra) # 80002c60 <iunlock>
  end_op();
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	a0a080e7          	jalr	-1526(ra) # 800035f0 <end_op>

  return fd;
}
    80004bee:	8526                	mv	a0,s1
    80004bf0:	70ea                	ld	ra,184(sp)
    80004bf2:	744a                	ld	s0,176(sp)
    80004bf4:	74aa                	ld	s1,168(sp)
    80004bf6:	790a                	ld	s2,160(sp)
    80004bf8:	69ea                	ld	s3,152(sp)
    80004bfa:	6129                	addi	sp,sp,192
    80004bfc:	8082                	ret
      end_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	9f2080e7          	jalr	-1550(ra) # 800035f0 <end_op>
      return -1;
    80004c06:	b7e5                	j	80004bee <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c08:	f5040513          	addi	a0,s0,-176
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	748080e7          	jalr	1864(ra) # 80003354 <namei>
    80004c14:	892a                	mv	s2,a0
    80004c16:	c905                	beqz	a0,80004c46 <sys_open+0x13c>
    ilock(ip);
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	f86080e7          	jalr	-122(ra) # 80002b9e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c20:	04491703          	lh	a4,68(s2)
    80004c24:	4785                	li	a5,1
    80004c26:	f4f712e3          	bne	a4,a5,80004b6a <sys_open+0x60>
    80004c2a:	f4c42783          	lw	a5,-180(s0)
    80004c2e:	dba1                	beqz	a5,80004b7e <sys_open+0x74>
      iunlockput(ip);
    80004c30:	854a                	mv	a0,s2
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	1ce080e7          	jalr	462(ra) # 80002e00 <iunlockput>
      end_op();
    80004c3a:	fffff097          	auipc	ra,0xfffff
    80004c3e:	9b6080e7          	jalr	-1610(ra) # 800035f0 <end_op>
      return -1;
    80004c42:	54fd                	li	s1,-1
    80004c44:	b76d                	j	80004bee <sys_open+0xe4>
      end_op();
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	9aa080e7          	jalr	-1622(ra) # 800035f0 <end_op>
      return -1;
    80004c4e:	54fd                	li	s1,-1
    80004c50:	bf79                	j	80004bee <sys_open+0xe4>
    iunlockput(ip);
    80004c52:	854a                	mv	a0,s2
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	1ac080e7          	jalr	428(ra) # 80002e00 <iunlockput>
    end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	994080e7          	jalr	-1644(ra) # 800035f0 <end_op>
    return -1;
    80004c64:	54fd                	li	s1,-1
    80004c66:	b761                	j	80004bee <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c68:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c6c:	04691783          	lh	a5,70(s2)
    80004c70:	02f99223          	sh	a5,36(s3)
    80004c74:	bf2d                	j	80004bae <sys_open+0xa4>
    itrunc(ip);
    80004c76:	854a                	mv	a0,s2
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	034080e7          	jalr	52(ra) # 80002cac <itrunc>
    80004c80:	bfb1                	j	80004bdc <sys_open+0xd2>
      fileclose(f);
    80004c82:	854e                	mv	a0,s3
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	db8080e7          	jalr	-584(ra) # 80003a3c <fileclose>
    iunlockput(ip);
    80004c8c:	854a                	mv	a0,s2
    80004c8e:	ffffe097          	auipc	ra,0xffffe
    80004c92:	172080e7          	jalr	370(ra) # 80002e00 <iunlockput>
    end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	95a080e7          	jalr	-1702(ra) # 800035f0 <end_op>
    return -1;
    80004c9e:	54fd                	li	s1,-1
    80004ca0:	b7b9                	j	80004bee <sys_open+0xe4>

0000000080004ca2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ca2:	7175                	addi	sp,sp,-144
    80004ca4:	e506                	sd	ra,136(sp)
    80004ca6:	e122                	sd	s0,128(sp)
    80004ca8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	8c6080e7          	jalr	-1850(ra) # 80003570 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cb2:	08000613          	li	a2,128
    80004cb6:	f7040593          	addi	a1,s0,-144
    80004cba:	4501                	li	a0,0
    80004cbc:	ffffd097          	auipc	ra,0xffffd
    80004cc0:	3ac080e7          	jalr	940(ra) # 80002068 <argstr>
    80004cc4:	02054963          	bltz	a0,80004cf6 <sys_mkdir+0x54>
    80004cc8:	4681                	li	a3,0
    80004cca:	4601                	li	a2,0
    80004ccc:	4585                	li	a1,1
    80004cce:	f7040513          	addi	a0,s0,-144
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	7fe080e7          	jalr	2046(ra) # 800044d0 <create>
    80004cda:	cd11                	beqz	a0,80004cf6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	124080e7          	jalr	292(ra) # 80002e00 <iunlockput>
  end_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	90c080e7          	jalr	-1780(ra) # 800035f0 <end_op>
  return 0;
    80004cec:	4501                	li	a0,0
}
    80004cee:	60aa                	ld	ra,136(sp)
    80004cf0:	640a                	ld	s0,128(sp)
    80004cf2:	6149                	addi	sp,sp,144
    80004cf4:	8082                	ret
    end_op();
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	8fa080e7          	jalr	-1798(ra) # 800035f0 <end_op>
    return -1;
    80004cfe:	557d                	li	a0,-1
    80004d00:	b7fd                	j	80004cee <sys_mkdir+0x4c>

0000000080004d02 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d02:	7135                	addi	sp,sp,-160
    80004d04:	ed06                	sd	ra,152(sp)
    80004d06:	e922                	sd	s0,144(sp)
    80004d08:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	866080e7          	jalr	-1946(ra) # 80003570 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d12:	08000613          	li	a2,128
    80004d16:	f7040593          	addi	a1,s0,-144
    80004d1a:	4501                	li	a0,0
    80004d1c:	ffffd097          	auipc	ra,0xffffd
    80004d20:	34c080e7          	jalr	844(ra) # 80002068 <argstr>
    80004d24:	04054a63          	bltz	a0,80004d78 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d28:	f6c40593          	addi	a1,s0,-148
    80004d2c:	4505                	li	a0,1
    80004d2e:	ffffd097          	auipc	ra,0xffffd
    80004d32:	2f6080e7          	jalr	758(ra) # 80002024 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d36:	04054163          	bltz	a0,80004d78 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d3a:	f6840593          	addi	a1,s0,-152
    80004d3e:	4509                	li	a0,2
    80004d40:	ffffd097          	auipc	ra,0xffffd
    80004d44:	2e4080e7          	jalr	740(ra) # 80002024 <argint>
     argint(1, &major) < 0 ||
    80004d48:	02054863          	bltz	a0,80004d78 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d4c:	f6841683          	lh	a3,-152(s0)
    80004d50:	f6c41603          	lh	a2,-148(s0)
    80004d54:	458d                	li	a1,3
    80004d56:	f7040513          	addi	a0,s0,-144
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	776080e7          	jalr	1910(ra) # 800044d0 <create>
     argint(2, &minor) < 0 ||
    80004d62:	c919                	beqz	a0,80004d78 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	09c080e7          	jalr	156(ra) # 80002e00 <iunlockput>
  end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	884080e7          	jalr	-1916(ra) # 800035f0 <end_op>
  return 0;
    80004d74:	4501                	li	a0,0
    80004d76:	a031                	j	80004d82 <sys_mknod+0x80>
    end_op();
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	878080e7          	jalr	-1928(ra) # 800035f0 <end_op>
    return -1;
    80004d80:	557d                	li	a0,-1
}
    80004d82:	60ea                	ld	ra,152(sp)
    80004d84:	644a                	ld	s0,144(sp)
    80004d86:	610d                	addi	sp,sp,160
    80004d88:	8082                	ret

0000000080004d8a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d8a:	7135                	addi	sp,sp,-160
    80004d8c:	ed06                	sd	ra,152(sp)
    80004d8e:	e922                	sd	s0,144(sp)
    80004d90:	e526                	sd	s1,136(sp)
    80004d92:	e14a                	sd	s2,128(sp)
    80004d94:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d96:	ffffc097          	auipc	ra,0xffffc
    80004d9a:	1e2080e7          	jalr	482(ra) # 80000f78 <myproc>
    80004d9e:	892a                	mv	s2,a0
  
  begin_op();
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	7d0080e7          	jalr	2000(ra) # 80003570 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004da8:	08000613          	li	a2,128
    80004dac:	f6040593          	addi	a1,s0,-160
    80004db0:	4501                	li	a0,0
    80004db2:	ffffd097          	auipc	ra,0xffffd
    80004db6:	2b6080e7          	jalr	694(ra) # 80002068 <argstr>
    80004dba:	04054b63          	bltz	a0,80004e10 <sys_chdir+0x86>
    80004dbe:	f6040513          	addi	a0,s0,-160
    80004dc2:	ffffe097          	auipc	ra,0xffffe
    80004dc6:	592080e7          	jalr	1426(ra) # 80003354 <namei>
    80004dca:	84aa                	mv	s1,a0
    80004dcc:	c131                	beqz	a0,80004e10 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	dd0080e7          	jalr	-560(ra) # 80002b9e <ilock>
  if(ip->type != T_DIR){
    80004dd6:	04449703          	lh	a4,68(s1)
    80004dda:	4785                	li	a5,1
    80004ddc:	04f71063          	bne	a4,a5,80004e1c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004de0:	8526                	mv	a0,s1
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	e7e080e7          	jalr	-386(ra) # 80002c60 <iunlock>
  iput(p->cwd);
    80004dea:	15893503          	ld	a0,344(s2)
    80004dee:	ffffe097          	auipc	ra,0xffffe
    80004df2:	f6a080e7          	jalr	-150(ra) # 80002d58 <iput>
  end_op();
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	7fa080e7          	jalr	2042(ra) # 800035f0 <end_op>
  p->cwd = ip;
    80004dfe:	14993c23          	sd	s1,344(s2)
  return 0;
    80004e02:	4501                	li	a0,0
}
    80004e04:	60ea                	ld	ra,152(sp)
    80004e06:	644a                	ld	s0,144(sp)
    80004e08:	64aa                	ld	s1,136(sp)
    80004e0a:	690a                	ld	s2,128(sp)
    80004e0c:	610d                	addi	sp,sp,160
    80004e0e:	8082                	ret
    end_op();
    80004e10:	ffffe097          	auipc	ra,0xffffe
    80004e14:	7e0080e7          	jalr	2016(ra) # 800035f0 <end_op>
    return -1;
    80004e18:	557d                	li	a0,-1
    80004e1a:	b7ed                	j	80004e04 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e1c:	8526                	mv	a0,s1
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	fe2080e7          	jalr	-30(ra) # 80002e00 <iunlockput>
    end_op();
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	7ca080e7          	jalr	1994(ra) # 800035f0 <end_op>
    return -1;
    80004e2e:	557d                	li	a0,-1
    80004e30:	bfd1                	j	80004e04 <sys_chdir+0x7a>

0000000080004e32 <sys_exec>:

uint64
sys_exec(void)
{
    80004e32:	7145                	addi	sp,sp,-464
    80004e34:	e786                	sd	ra,456(sp)
    80004e36:	e3a2                	sd	s0,448(sp)
    80004e38:	ff26                	sd	s1,440(sp)
    80004e3a:	fb4a                	sd	s2,432(sp)
    80004e3c:	f74e                	sd	s3,424(sp)
    80004e3e:	f352                	sd	s4,416(sp)
    80004e40:	ef56                	sd	s5,408(sp)
    80004e42:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e44:	08000613          	li	a2,128
    80004e48:	f4040593          	addi	a1,s0,-192
    80004e4c:	4501                	li	a0,0
    80004e4e:	ffffd097          	auipc	ra,0xffffd
    80004e52:	21a080e7          	jalr	538(ra) # 80002068 <argstr>
    return -1;
    80004e56:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e58:	0c054a63          	bltz	a0,80004f2c <sys_exec+0xfa>
    80004e5c:	e3840593          	addi	a1,s0,-456
    80004e60:	4505                	li	a0,1
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	1e4080e7          	jalr	484(ra) # 80002046 <argaddr>
    80004e6a:	0c054163          	bltz	a0,80004f2c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e6e:	10000613          	li	a2,256
    80004e72:	4581                	li	a1,0
    80004e74:	e4040513          	addi	a0,s0,-448
    80004e78:	ffffb097          	auipc	ra,0xffffb
    80004e7c:	300080e7          	jalr	768(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e80:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e84:	89a6                	mv	s3,s1
    80004e86:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e88:	02000a13          	li	s4,32
    80004e8c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e90:	00391513          	slli	a0,s2,0x3
    80004e94:	e3040593          	addi	a1,s0,-464
    80004e98:	e3843783          	ld	a5,-456(s0)
    80004e9c:	953e                	add	a0,a0,a5
    80004e9e:	ffffd097          	auipc	ra,0xffffd
    80004ea2:	0ec080e7          	jalr	236(ra) # 80001f8a <fetchaddr>
    80004ea6:	02054a63          	bltz	a0,80004eda <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004eaa:	e3043783          	ld	a5,-464(s0)
    80004eae:	c3b9                	beqz	a5,80004ef4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eb0:	ffffb097          	auipc	ra,0xffffb
    80004eb4:	268080e7          	jalr	616(ra) # 80000118 <kalloc>
    80004eb8:	85aa                	mv	a1,a0
    80004eba:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ebe:	cd11                	beqz	a0,80004eda <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ec0:	6605                	lui	a2,0x1
    80004ec2:	e3043503          	ld	a0,-464(s0)
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	116080e7          	jalr	278(ra) # 80001fdc <fetchstr>
    80004ece:	00054663          	bltz	a0,80004eda <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ed2:	0905                	addi	s2,s2,1
    80004ed4:	09a1                	addi	s3,s3,8
    80004ed6:	fb491be3          	bne	s2,s4,80004e8c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eda:	10048913          	addi	s2,s1,256
    80004ede:	6088                	ld	a0,0(s1)
    80004ee0:	c529                	beqz	a0,80004f2a <sys_exec+0xf8>
    kfree(argv[i]);
    80004ee2:	ffffb097          	auipc	ra,0xffffb
    80004ee6:	13a080e7          	jalr	314(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eea:	04a1                	addi	s1,s1,8
    80004eec:	ff2499e3          	bne	s1,s2,80004ede <sys_exec+0xac>
  return -1;
    80004ef0:	597d                	li	s2,-1
    80004ef2:	a82d                	j	80004f2c <sys_exec+0xfa>
      argv[i] = 0;
    80004ef4:	0a8e                	slli	s5,s5,0x3
    80004ef6:	fc040793          	addi	a5,s0,-64
    80004efa:	9abe                	add	s5,s5,a5
    80004efc:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f00:	e4040593          	addi	a1,s0,-448
    80004f04:	f4040513          	addi	a0,s0,-192
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	194080e7          	jalr	404(ra) # 8000409c <exec>
    80004f10:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f12:	10048993          	addi	s3,s1,256
    80004f16:	6088                	ld	a0,0(s1)
    80004f18:	c911                	beqz	a0,80004f2c <sys_exec+0xfa>
    kfree(argv[i]);
    80004f1a:	ffffb097          	auipc	ra,0xffffb
    80004f1e:	102080e7          	jalr	258(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f22:	04a1                	addi	s1,s1,8
    80004f24:	ff3499e3          	bne	s1,s3,80004f16 <sys_exec+0xe4>
    80004f28:	a011                	j	80004f2c <sys_exec+0xfa>
  return -1;
    80004f2a:	597d                	li	s2,-1
}
    80004f2c:	854a                	mv	a0,s2
    80004f2e:	60be                	ld	ra,456(sp)
    80004f30:	641e                	ld	s0,448(sp)
    80004f32:	74fa                	ld	s1,440(sp)
    80004f34:	795a                	ld	s2,432(sp)
    80004f36:	79ba                	ld	s3,424(sp)
    80004f38:	7a1a                	ld	s4,416(sp)
    80004f3a:	6afa                	ld	s5,408(sp)
    80004f3c:	6179                	addi	sp,sp,464
    80004f3e:	8082                	ret

0000000080004f40 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f40:	7139                	addi	sp,sp,-64
    80004f42:	fc06                	sd	ra,56(sp)
    80004f44:	f822                	sd	s0,48(sp)
    80004f46:	f426                	sd	s1,40(sp)
    80004f48:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f4a:	ffffc097          	auipc	ra,0xffffc
    80004f4e:	02e080e7          	jalr	46(ra) # 80000f78 <myproc>
    80004f52:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f54:	fd840593          	addi	a1,s0,-40
    80004f58:	4501                	li	a0,0
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	0ec080e7          	jalr	236(ra) # 80002046 <argaddr>
    return -1;
    80004f62:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f64:	0e054063          	bltz	a0,80005044 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f68:	fc840593          	addi	a1,s0,-56
    80004f6c:	fd040513          	addi	a0,s0,-48
    80004f70:	fffff097          	auipc	ra,0xfffff
    80004f74:	dfc080e7          	jalr	-516(ra) # 80003d6c <pipealloc>
    return -1;
    80004f78:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f7a:	0c054563          	bltz	a0,80005044 <sys_pipe+0x104>
  fd0 = -1;
    80004f7e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f82:	fd043503          	ld	a0,-48(s0)
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	508080e7          	jalr	1288(ra) # 8000448e <fdalloc>
    80004f8e:	fca42223          	sw	a0,-60(s0)
    80004f92:	08054c63          	bltz	a0,8000502a <sys_pipe+0xea>
    80004f96:	fc843503          	ld	a0,-56(s0)
    80004f9a:	fffff097          	auipc	ra,0xfffff
    80004f9e:	4f4080e7          	jalr	1268(ra) # 8000448e <fdalloc>
    80004fa2:	fca42023          	sw	a0,-64(s0)
    80004fa6:	06054863          	bltz	a0,80005016 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004faa:	4691                	li	a3,4
    80004fac:	fc440613          	addi	a2,s0,-60
    80004fb0:	fd843583          	ld	a1,-40(s0)
    80004fb4:	68a8                	ld	a0,80(s1)
    80004fb6:	ffffc097          	auipc	ra,0xffffc
    80004fba:	b54080e7          	jalr	-1196(ra) # 80000b0a <copyout>
    80004fbe:	02054063          	bltz	a0,80004fde <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fc2:	4691                	li	a3,4
    80004fc4:	fc040613          	addi	a2,s0,-64
    80004fc8:	fd843583          	ld	a1,-40(s0)
    80004fcc:	0591                	addi	a1,a1,4
    80004fce:	68a8                	ld	a0,80(s1)
    80004fd0:	ffffc097          	auipc	ra,0xffffc
    80004fd4:	b3a080e7          	jalr	-1222(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fd8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fda:	06055563          	bgez	a0,80005044 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fde:	fc442783          	lw	a5,-60(s0)
    80004fe2:	07e9                	addi	a5,a5,26
    80004fe4:	078e                	slli	a5,a5,0x3
    80004fe6:	97a6                	add	a5,a5,s1
    80004fe8:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004fec:	fc042503          	lw	a0,-64(s0)
    80004ff0:	0569                	addi	a0,a0,26
    80004ff2:	050e                	slli	a0,a0,0x3
    80004ff4:	9526                	add	a0,a0,s1
    80004ff6:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80004ffa:	fd043503          	ld	a0,-48(s0)
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	a3e080e7          	jalr	-1474(ra) # 80003a3c <fileclose>
    fileclose(wf);
    80005006:	fc843503          	ld	a0,-56(s0)
    8000500a:	fffff097          	auipc	ra,0xfffff
    8000500e:	a32080e7          	jalr	-1486(ra) # 80003a3c <fileclose>
    return -1;
    80005012:	57fd                	li	a5,-1
    80005014:	a805                	j	80005044 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005016:	fc442783          	lw	a5,-60(s0)
    8000501a:	0007c863          	bltz	a5,8000502a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000501e:	01a78513          	addi	a0,a5,26
    80005022:	050e                	slli	a0,a0,0x3
    80005024:	9526                	add	a0,a0,s1
    80005026:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000502a:	fd043503          	ld	a0,-48(s0)
    8000502e:	fffff097          	auipc	ra,0xfffff
    80005032:	a0e080e7          	jalr	-1522(ra) # 80003a3c <fileclose>
    fileclose(wf);
    80005036:	fc843503          	ld	a0,-56(s0)
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	a02080e7          	jalr	-1534(ra) # 80003a3c <fileclose>
    return -1;
    80005042:	57fd                	li	a5,-1
}
    80005044:	853e                	mv	a0,a5
    80005046:	70e2                	ld	ra,56(sp)
    80005048:	7442                	ld	s0,48(sp)
    8000504a:	74a2                	ld	s1,40(sp)
    8000504c:	6121                	addi	sp,sp,64
    8000504e:	8082                	ret

0000000080005050 <kernelvec>:
    80005050:	7111                	addi	sp,sp,-256
    80005052:	e006                	sd	ra,0(sp)
    80005054:	e40a                	sd	sp,8(sp)
    80005056:	e80e                	sd	gp,16(sp)
    80005058:	ec12                	sd	tp,24(sp)
    8000505a:	f016                	sd	t0,32(sp)
    8000505c:	f41a                	sd	t1,40(sp)
    8000505e:	f81e                	sd	t2,48(sp)
    80005060:	fc22                	sd	s0,56(sp)
    80005062:	e0a6                	sd	s1,64(sp)
    80005064:	e4aa                	sd	a0,72(sp)
    80005066:	e8ae                	sd	a1,80(sp)
    80005068:	ecb2                	sd	a2,88(sp)
    8000506a:	f0b6                	sd	a3,96(sp)
    8000506c:	f4ba                	sd	a4,104(sp)
    8000506e:	f8be                	sd	a5,112(sp)
    80005070:	fcc2                	sd	a6,120(sp)
    80005072:	e146                	sd	a7,128(sp)
    80005074:	e54a                	sd	s2,136(sp)
    80005076:	e94e                	sd	s3,144(sp)
    80005078:	ed52                	sd	s4,152(sp)
    8000507a:	f156                	sd	s5,160(sp)
    8000507c:	f55a                	sd	s6,168(sp)
    8000507e:	f95e                	sd	s7,176(sp)
    80005080:	fd62                	sd	s8,184(sp)
    80005082:	e1e6                	sd	s9,192(sp)
    80005084:	e5ea                	sd	s10,200(sp)
    80005086:	e9ee                	sd	s11,208(sp)
    80005088:	edf2                	sd	t3,216(sp)
    8000508a:	f1f6                	sd	t4,224(sp)
    8000508c:	f5fa                	sd	t5,232(sp)
    8000508e:	f9fe                	sd	t6,240(sp)
    80005090:	dc7fc0ef          	jal	ra,80001e56 <kerneltrap>
    80005094:	6082                	ld	ra,0(sp)
    80005096:	6122                	ld	sp,8(sp)
    80005098:	61c2                	ld	gp,16(sp)
    8000509a:	7282                	ld	t0,32(sp)
    8000509c:	7322                	ld	t1,40(sp)
    8000509e:	73c2                	ld	t2,48(sp)
    800050a0:	7462                	ld	s0,56(sp)
    800050a2:	6486                	ld	s1,64(sp)
    800050a4:	6526                	ld	a0,72(sp)
    800050a6:	65c6                	ld	a1,80(sp)
    800050a8:	6666                	ld	a2,88(sp)
    800050aa:	7686                	ld	a3,96(sp)
    800050ac:	7726                	ld	a4,104(sp)
    800050ae:	77c6                	ld	a5,112(sp)
    800050b0:	7866                	ld	a6,120(sp)
    800050b2:	688a                	ld	a7,128(sp)
    800050b4:	692a                	ld	s2,136(sp)
    800050b6:	69ca                	ld	s3,144(sp)
    800050b8:	6a6a                	ld	s4,152(sp)
    800050ba:	7a8a                	ld	s5,160(sp)
    800050bc:	7b2a                	ld	s6,168(sp)
    800050be:	7bca                	ld	s7,176(sp)
    800050c0:	7c6a                	ld	s8,184(sp)
    800050c2:	6c8e                	ld	s9,192(sp)
    800050c4:	6d2e                	ld	s10,200(sp)
    800050c6:	6dce                	ld	s11,208(sp)
    800050c8:	6e6e                	ld	t3,216(sp)
    800050ca:	7e8e                	ld	t4,224(sp)
    800050cc:	7f2e                	ld	t5,232(sp)
    800050ce:	7fce                	ld	t6,240(sp)
    800050d0:	6111                	addi	sp,sp,256
    800050d2:	10200073          	sret
    800050d6:	00000013          	nop
    800050da:	00000013          	nop
    800050de:	0001                	nop

00000000800050e0 <timervec>:
    800050e0:	34051573          	csrrw	a0,mscratch,a0
    800050e4:	e10c                	sd	a1,0(a0)
    800050e6:	e510                	sd	a2,8(a0)
    800050e8:	e914                	sd	a3,16(a0)
    800050ea:	6d0c                	ld	a1,24(a0)
    800050ec:	7110                	ld	a2,32(a0)
    800050ee:	6194                	ld	a3,0(a1)
    800050f0:	96b2                	add	a3,a3,a2
    800050f2:	e194                	sd	a3,0(a1)
    800050f4:	4589                	li	a1,2
    800050f6:	14459073          	csrw	sip,a1
    800050fa:	6914                	ld	a3,16(a0)
    800050fc:	6510                	ld	a2,8(a0)
    800050fe:	610c                	ld	a1,0(a0)
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	30200073          	mret
	...

000000008000510a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000510a:	1141                	addi	sp,sp,-16
    8000510c:	e422                	sd	s0,8(sp)
    8000510e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005110:	0c0007b7          	lui	a5,0xc000
    80005114:	4705                	li	a4,1
    80005116:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005118:	c3d8                	sw	a4,4(a5)
}
    8000511a:	6422                	ld	s0,8(sp)
    8000511c:	0141                	addi	sp,sp,16
    8000511e:	8082                	ret

0000000080005120 <plicinithart>:

void
plicinithart(void)
{
    80005120:	1141                	addi	sp,sp,-16
    80005122:	e406                	sd	ra,8(sp)
    80005124:	e022                	sd	s0,0(sp)
    80005126:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	e24080e7          	jalr	-476(ra) # 80000f4c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005130:	0085171b          	slliw	a4,a0,0x8
    80005134:	0c0027b7          	lui	a5,0xc002
    80005138:	97ba                	add	a5,a5,a4
    8000513a:	40200713          	li	a4,1026
    8000513e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005142:	00d5151b          	slliw	a0,a0,0xd
    80005146:	0c2017b7          	lui	a5,0xc201
    8000514a:	953e                	add	a0,a0,a5
    8000514c:	00052023          	sw	zero,0(a0)
}
    80005150:	60a2                	ld	ra,8(sp)
    80005152:	6402                	ld	s0,0(sp)
    80005154:	0141                	addi	sp,sp,16
    80005156:	8082                	ret

0000000080005158 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005158:	1141                	addi	sp,sp,-16
    8000515a:	e406                	sd	ra,8(sp)
    8000515c:	e022                	sd	s0,0(sp)
    8000515e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005160:	ffffc097          	auipc	ra,0xffffc
    80005164:	dec080e7          	jalr	-532(ra) # 80000f4c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005168:	00d5179b          	slliw	a5,a0,0xd
    8000516c:	0c201537          	lui	a0,0xc201
    80005170:	953e                	add	a0,a0,a5
  return irq;
}
    80005172:	4148                	lw	a0,4(a0)
    80005174:	60a2                	ld	ra,8(sp)
    80005176:	6402                	ld	s0,0(sp)
    80005178:	0141                	addi	sp,sp,16
    8000517a:	8082                	ret

000000008000517c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000517c:	1101                	addi	sp,sp,-32
    8000517e:	ec06                	sd	ra,24(sp)
    80005180:	e822                	sd	s0,16(sp)
    80005182:	e426                	sd	s1,8(sp)
    80005184:	1000                	addi	s0,sp,32
    80005186:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	dc4080e7          	jalr	-572(ra) # 80000f4c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005190:	00d5151b          	slliw	a0,a0,0xd
    80005194:	0c2017b7          	lui	a5,0xc201
    80005198:	97aa                	add	a5,a5,a0
    8000519a:	c3c4                	sw	s1,4(a5)
}
    8000519c:	60e2                	ld	ra,24(sp)
    8000519e:	6442                	ld	s0,16(sp)
    800051a0:	64a2                	ld	s1,8(sp)
    800051a2:	6105                	addi	sp,sp,32
    800051a4:	8082                	ret

00000000800051a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051a6:	1141                	addi	sp,sp,-16
    800051a8:	e406                	sd	ra,8(sp)
    800051aa:	e022                	sd	s0,0(sp)
    800051ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ae:	479d                	li	a5,7
    800051b0:	06a7c963          	blt	a5,a0,80005222 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051b4:	00016797          	auipc	a5,0x16
    800051b8:	e4c78793          	addi	a5,a5,-436 # 8001b000 <disk>
    800051bc:	00a78733          	add	a4,a5,a0
    800051c0:	6789                	lui	a5,0x2
    800051c2:	97ba                	add	a5,a5,a4
    800051c4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051c8:	e7ad                	bnez	a5,80005232 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ca:	00451793          	slli	a5,a0,0x4
    800051ce:	00018717          	auipc	a4,0x18
    800051d2:	e3270713          	addi	a4,a4,-462 # 8001d000 <disk+0x2000>
    800051d6:	6314                	ld	a3,0(a4)
    800051d8:	96be                	add	a3,a3,a5
    800051da:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051de:	6314                	ld	a3,0(a4)
    800051e0:	96be                	add	a3,a3,a5
    800051e2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051e6:	6314                	ld	a3,0(a4)
    800051e8:	96be                	add	a3,a3,a5
    800051ea:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051ee:	6318                	ld	a4,0(a4)
    800051f0:	97ba                	add	a5,a5,a4
    800051f2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051f6:	00016797          	auipc	a5,0x16
    800051fa:	e0a78793          	addi	a5,a5,-502 # 8001b000 <disk>
    800051fe:	97aa                	add	a5,a5,a0
    80005200:	6509                	lui	a0,0x2
    80005202:	953e                	add	a0,a0,a5
    80005204:	4785                	li	a5,1
    80005206:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000520a:	00018517          	auipc	a0,0x18
    8000520e:	e0e50513          	addi	a0,a0,-498 # 8001d018 <disk+0x2018>
    80005212:	ffffc097          	auipc	ra,0xffffc
    80005216:	5ae080e7          	jalr	1454(ra) # 800017c0 <wakeup>
}
    8000521a:	60a2                	ld	ra,8(sp)
    8000521c:	6402                	ld	s0,0(sp)
    8000521e:	0141                	addi	sp,sp,16
    80005220:	8082                	ret
    panic("free_desc 1");
    80005222:	00003517          	auipc	a0,0x3
    80005226:	52650513          	addi	a0,a0,1318 # 80008748 <syscalls+0x320>
    8000522a:	00001097          	auipc	ra,0x1
    8000522e:	a1e080e7          	jalr	-1506(ra) # 80005c48 <panic>
    panic("free_desc 2");
    80005232:	00003517          	auipc	a0,0x3
    80005236:	52650513          	addi	a0,a0,1318 # 80008758 <syscalls+0x330>
    8000523a:	00001097          	auipc	ra,0x1
    8000523e:	a0e080e7          	jalr	-1522(ra) # 80005c48 <panic>

0000000080005242 <virtio_disk_init>:
{
    80005242:	1101                	addi	sp,sp,-32
    80005244:	ec06                	sd	ra,24(sp)
    80005246:	e822                	sd	s0,16(sp)
    80005248:	e426                	sd	s1,8(sp)
    8000524a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000524c:	00003597          	auipc	a1,0x3
    80005250:	51c58593          	addi	a1,a1,1308 # 80008768 <syscalls+0x340>
    80005254:	00018517          	auipc	a0,0x18
    80005258:	ed450513          	addi	a0,a0,-300 # 8001d128 <disk+0x2128>
    8000525c:	00001097          	auipc	ra,0x1
    80005260:	f12080e7          	jalr	-238(ra) # 8000616e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005264:	100017b7          	lui	a5,0x10001
    80005268:	4398                	lw	a4,0(a5)
    8000526a:	2701                	sext.w	a4,a4
    8000526c:	747277b7          	lui	a5,0x74727
    80005270:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005274:	0ef71163          	bne	a4,a5,80005356 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005278:	100017b7          	lui	a5,0x10001
    8000527c:	43dc                	lw	a5,4(a5)
    8000527e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005280:	4705                	li	a4,1
    80005282:	0ce79a63          	bne	a5,a4,80005356 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005286:	100017b7          	lui	a5,0x10001
    8000528a:	479c                	lw	a5,8(a5)
    8000528c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000528e:	4709                	li	a4,2
    80005290:	0ce79363          	bne	a5,a4,80005356 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005294:	100017b7          	lui	a5,0x10001
    80005298:	47d8                	lw	a4,12(a5)
    8000529a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000529c:	554d47b7          	lui	a5,0x554d4
    800052a0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052a4:	0af71963          	bne	a4,a5,80005356 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052a8:	100017b7          	lui	a5,0x10001
    800052ac:	4705                	li	a4,1
    800052ae:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b0:	470d                	li	a4,3
    800052b2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052b4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052b6:	c7ffe737          	lui	a4,0xc7ffe
    800052ba:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052be:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052c0:	2701                	sext.w	a4,a4
    800052c2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c4:	472d                	li	a4,11
    800052c6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c8:	473d                	li	a4,15
    800052ca:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052cc:	6705                	lui	a4,0x1
    800052ce:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052d4:	5bdc                	lw	a5,52(a5)
    800052d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052d8:	c7d9                	beqz	a5,80005366 <virtio_disk_init+0x124>
  if(max < NUM)
    800052da:	471d                	li	a4,7
    800052dc:	08f77d63          	bgeu	a4,a5,80005376 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052e0:	100014b7          	lui	s1,0x10001
    800052e4:	47a1                	li	a5,8
    800052e6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052e8:	6609                	lui	a2,0x2
    800052ea:	4581                	li	a1,0
    800052ec:	00016517          	auipc	a0,0x16
    800052f0:	d1450513          	addi	a0,a0,-748 # 8001b000 <disk>
    800052f4:	ffffb097          	auipc	ra,0xffffb
    800052f8:	e84080e7          	jalr	-380(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052fc:	00016717          	auipc	a4,0x16
    80005300:	d0470713          	addi	a4,a4,-764 # 8001b000 <disk>
    80005304:	00c75793          	srli	a5,a4,0xc
    80005308:	2781                	sext.w	a5,a5
    8000530a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000530c:	00018797          	auipc	a5,0x18
    80005310:	cf478793          	addi	a5,a5,-780 # 8001d000 <disk+0x2000>
    80005314:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005316:	00016717          	auipc	a4,0x16
    8000531a:	d6a70713          	addi	a4,a4,-662 # 8001b080 <disk+0x80>
    8000531e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005320:	00017717          	auipc	a4,0x17
    80005324:	ce070713          	addi	a4,a4,-800 # 8001c000 <disk+0x1000>
    80005328:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000532a:	4705                	li	a4,1
    8000532c:	00e78c23          	sb	a4,24(a5)
    80005330:	00e78ca3          	sb	a4,25(a5)
    80005334:	00e78d23          	sb	a4,26(a5)
    80005338:	00e78da3          	sb	a4,27(a5)
    8000533c:	00e78e23          	sb	a4,28(a5)
    80005340:	00e78ea3          	sb	a4,29(a5)
    80005344:	00e78f23          	sb	a4,30(a5)
    80005348:	00e78fa3          	sb	a4,31(a5)
}
    8000534c:	60e2                	ld	ra,24(sp)
    8000534e:	6442                	ld	s0,16(sp)
    80005350:	64a2                	ld	s1,8(sp)
    80005352:	6105                	addi	sp,sp,32
    80005354:	8082                	ret
    panic("could not find virtio disk");
    80005356:	00003517          	auipc	a0,0x3
    8000535a:	42250513          	addi	a0,a0,1058 # 80008778 <syscalls+0x350>
    8000535e:	00001097          	auipc	ra,0x1
    80005362:	8ea080e7          	jalr	-1814(ra) # 80005c48 <panic>
    panic("virtio disk has no queue 0");
    80005366:	00003517          	auipc	a0,0x3
    8000536a:	43250513          	addi	a0,a0,1074 # 80008798 <syscalls+0x370>
    8000536e:	00001097          	auipc	ra,0x1
    80005372:	8da080e7          	jalr	-1830(ra) # 80005c48 <panic>
    panic("virtio disk max queue too short");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	44250513          	addi	a0,a0,1090 # 800087b8 <syscalls+0x390>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	8ca080e7          	jalr	-1846(ra) # 80005c48 <panic>

0000000080005386 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005386:	7159                	addi	sp,sp,-112
    80005388:	f486                	sd	ra,104(sp)
    8000538a:	f0a2                	sd	s0,96(sp)
    8000538c:	eca6                	sd	s1,88(sp)
    8000538e:	e8ca                	sd	s2,80(sp)
    80005390:	e4ce                	sd	s3,72(sp)
    80005392:	e0d2                	sd	s4,64(sp)
    80005394:	fc56                	sd	s5,56(sp)
    80005396:	f85a                	sd	s6,48(sp)
    80005398:	f45e                	sd	s7,40(sp)
    8000539a:	f062                	sd	s8,32(sp)
    8000539c:	ec66                	sd	s9,24(sp)
    8000539e:	e86a                	sd	s10,16(sp)
    800053a0:	1880                	addi	s0,sp,112
    800053a2:	892a                	mv	s2,a0
    800053a4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053a6:	00c52c83          	lw	s9,12(a0)
    800053aa:	001c9c9b          	slliw	s9,s9,0x1
    800053ae:	1c82                	slli	s9,s9,0x20
    800053b0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053b4:	00018517          	auipc	a0,0x18
    800053b8:	d7450513          	addi	a0,a0,-652 # 8001d128 <disk+0x2128>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	e42080e7          	jalr	-446(ra) # 800061fe <acquire>
  for(int i = 0; i < 3; i++){
    800053c4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053c6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053c8:	00016b97          	auipc	s7,0x16
    800053cc:	c38b8b93          	addi	s7,s7,-968 # 8001b000 <disk>
    800053d0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053d2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053d4:	8a4e                	mv	s4,s3
    800053d6:	a051                	j	8000545a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053d8:	00fb86b3          	add	a3,s7,a5
    800053dc:	96da                	add	a3,a3,s6
    800053de:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053e2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053e4:	0207c563          	bltz	a5,8000540e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053e8:	2485                	addiw	s1,s1,1
    800053ea:	0711                	addi	a4,a4,4
    800053ec:	25548063          	beq	s1,s5,8000562c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800053f0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800053f2:	00018697          	auipc	a3,0x18
    800053f6:	c2668693          	addi	a3,a3,-986 # 8001d018 <disk+0x2018>
    800053fa:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800053fc:	0006c583          	lbu	a1,0(a3)
    80005400:	fde1                	bnez	a1,800053d8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005402:	2785                	addiw	a5,a5,1
    80005404:	0685                	addi	a3,a3,1
    80005406:	ff879be3          	bne	a5,s8,800053fc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000540a:	57fd                	li	a5,-1
    8000540c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000540e:	02905a63          	blez	s1,80005442 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005412:	f9042503          	lw	a0,-112(s0)
    80005416:	00000097          	auipc	ra,0x0
    8000541a:	d90080e7          	jalr	-624(ra) # 800051a6 <free_desc>
      for(int j = 0; j < i; j++)
    8000541e:	4785                	li	a5,1
    80005420:	0297d163          	bge	a5,s1,80005442 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005424:	f9442503          	lw	a0,-108(s0)
    80005428:	00000097          	auipc	ra,0x0
    8000542c:	d7e080e7          	jalr	-642(ra) # 800051a6 <free_desc>
      for(int j = 0; j < i; j++)
    80005430:	4789                	li	a5,2
    80005432:	0097d863          	bge	a5,s1,80005442 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005436:	f9842503          	lw	a0,-104(s0)
    8000543a:	00000097          	auipc	ra,0x0
    8000543e:	d6c080e7          	jalr	-660(ra) # 800051a6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005442:	00018597          	auipc	a1,0x18
    80005446:	ce658593          	addi	a1,a1,-794 # 8001d128 <disk+0x2128>
    8000544a:	00018517          	auipc	a0,0x18
    8000544e:	bce50513          	addi	a0,a0,-1074 # 8001d018 <disk+0x2018>
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	1e2080e7          	jalr	482(ra) # 80001634 <sleep>
  for(int i = 0; i < 3; i++){
    8000545a:	f9040713          	addi	a4,s0,-112
    8000545e:	84ce                	mv	s1,s3
    80005460:	bf41                	j	800053f0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005462:	20058713          	addi	a4,a1,512
    80005466:	00471693          	slli	a3,a4,0x4
    8000546a:	00016717          	auipc	a4,0x16
    8000546e:	b9670713          	addi	a4,a4,-1130 # 8001b000 <disk>
    80005472:	9736                	add	a4,a4,a3
    80005474:	4685                	li	a3,1
    80005476:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000547a:	20058713          	addi	a4,a1,512
    8000547e:	00471693          	slli	a3,a4,0x4
    80005482:	00016717          	auipc	a4,0x16
    80005486:	b7e70713          	addi	a4,a4,-1154 # 8001b000 <disk>
    8000548a:	9736                	add	a4,a4,a3
    8000548c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005490:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005494:	7679                	lui	a2,0xffffe
    80005496:	963e                	add	a2,a2,a5
    80005498:	00018697          	auipc	a3,0x18
    8000549c:	b6868693          	addi	a3,a3,-1176 # 8001d000 <disk+0x2000>
    800054a0:	6298                	ld	a4,0(a3)
    800054a2:	9732                	add	a4,a4,a2
    800054a4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054a6:	6298                	ld	a4,0(a3)
    800054a8:	9732                	add	a4,a4,a2
    800054aa:	4541                	li	a0,16
    800054ac:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054ae:	6298                	ld	a4,0(a3)
    800054b0:	9732                	add	a4,a4,a2
    800054b2:	4505                	li	a0,1
    800054b4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054b8:	f9442703          	lw	a4,-108(s0)
    800054bc:	6288                	ld	a0,0(a3)
    800054be:	962a                	add	a2,a2,a0
    800054c0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054c4:	0712                	slli	a4,a4,0x4
    800054c6:	6290                	ld	a2,0(a3)
    800054c8:	963a                	add	a2,a2,a4
    800054ca:	05890513          	addi	a0,s2,88
    800054ce:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054d0:	6294                	ld	a3,0(a3)
    800054d2:	96ba                	add	a3,a3,a4
    800054d4:	40000613          	li	a2,1024
    800054d8:	c690                	sw	a2,8(a3)
  if(write)
    800054da:	140d0063          	beqz	s10,8000561a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054de:	00018697          	auipc	a3,0x18
    800054e2:	b226b683          	ld	a3,-1246(a3) # 8001d000 <disk+0x2000>
    800054e6:	96ba                	add	a3,a3,a4
    800054e8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054ec:	00016817          	auipc	a6,0x16
    800054f0:	b1480813          	addi	a6,a6,-1260 # 8001b000 <disk>
    800054f4:	00018517          	auipc	a0,0x18
    800054f8:	b0c50513          	addi	a0,a0,-1268 # 8001d000 <disk+0x2000>
    800054fc:	6114                	ld	a3,0(a0)
    800054fe:	96ba                	add	a3,a3,a4
    80005500:	00c6d603          	lhu	a2,12(a3)
    80005504:	00166613          	ori	a2,a2,1
    80005508:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000550c:	f9842683          	lw	a3,-104(s0)
    80005510:	6110                	ld	a2,0(a0)
    80005512:	9732                	add	a4,a4,a2
    80005514:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005518:	20058613          	addi	a2,a1,512
    8000551c:	0612                	slli	a2,a2,0x4
    8000551e:	9642                	add	a2,a2,a6
    80005520:	577d                	li	a4,-1
    80005522:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005526:	00469713          	slli	a4,a3,0x4
    8000552a:	6114                	ld	a3,0(a0)
    8000552c:	96ba                	add	a3,a3,a4
    8000552e:	03078793          	addi	a5,a5,48
    80005532:	97c2                	add	a5,a5,a6
    80005534:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005536:	611c                	ld	a5,0(a0)
    80005538:	97ba                	add	a5,a5,a4
    8000553a:	4685                	li	a3,1
    8000553c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000553e:	611c                	ld	a5,0(a0)
    80005540:	97ba                	add	a5,a5,a4
    80005542:	4809                	li	a6,2
    80005544:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005548:	611c                	ld	a5,0(a0)
    8000554a:	973e                	add	a4,a4,a5
    8000554c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005550:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005554:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005558:	6518                	ld	a4,8(a0)
    8000555a:	00275783          	lhu	a5,2(a4)
    8000555e:	8b9d                	andi	a5,a5,7
    80005560:	0786                	slli	a5,a5,0x1
    80005562:	97ba                	add	a5,a5,a4
    80005564:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005568:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000556c:	6518                	ld	a4,8(a0)
    8000556e:	00275783          	lhu	a5,2(a4)
    80005572:	2785                	addiw	a5,a5,1
    80005574:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005578:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005584:	00492703          	lw	a4,4(s2)
    80005588:	4785                	li	a5,1
    8000558a:	02f71163          	bne	a4,a5,800055ac <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000558e:	00018997          	auipc	s3,0x18
    80005592:	b9a98993          	addi	s3,s3,-1126 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005596:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005598:	85ce                	mv	a1,s3
    8000559a:	854a                	mv	a0,s2
    8000559c:	ffffc097          	auipc	ra,0xffffc
    800055a0:	098080e7          	jalr	152(ra) # 80001634 <sleep>
  while(b->disk == 1) {
    800055a4:	00492783          	lw	a5,4(s2)
    800055a8:	fe9788e3          	beq	a5,s1,80005598 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055ac:	f9042903          	lw	s2,-112(s0)
    800055b0:	20090793          	addi	a5,s2,512
    800055b4:	00479713          	slli	a4,a5,0x4
    800055b8:	00016797          	auipc	a5,0x16
    800055bc:	a4878793          	addi	a5,a5,-1464 # 8001b000 <disk>
    800055c0:	97ba                	add	a5,a5,a4
    800055c2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055c6:	00018997          	auipc	s3,0x18
    800055ca:	a3a98993          	addi	s3,s3,-1478 # 8001d000 <disk+0x2000>
    800055ce:	00491713          	slli	a4,s2,0x4
    800055d2:	0009b783          	ld	a5,0(s3)
    800055d6:	97ba                	add	a5,a5,a4
    800055d8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055dc:	854a                	mv	a0,s2
    800055de:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055e2:	00000097          	auipc	ra,0x0
    800055e6:	bc4080e7          	jalr	-1084(ra) # 800051a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055ea:	8885                	andi	s1,s1,1
    800055ec:	f0ed                	bnez	s1,800055ce <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ee:	00018517          	auipc	a0,0x18
    800055f2:	b3a50513          	addi	a0,a0,-1222 # 8001d128 <disk+0x2128>
    800055f6:	00001097          	auipc	ra,0x1
    800055fa:	cbc080e7          	jalr	-836(ra) # 800062b2 <release>
}
    800055fe:	70a6                	ld	ra,104(sp)
    80005600:	7406                	ld	s0,96(sp)
    80005602:	64e6                	ld	s1,88(sp)
    80005604:	6946                	ld	s2,80(sp)
    80005606:	69a6                	ld	s3,72(sp)
    80005608:	6a06                	ld	s4,64(sp)
    8000560a:	7ae2                	ld	s5,56(sp)
    8000560c:	7b42                	ld	s6,48(sp)
    8000560e:	7ba2                	ld	s7,40(sp)
    80005610:	7c02                	ld	s8,32(sp)
    80005612:	6ce2                	ld	s9,24(sp)
    80005614:	6d42                	ld	s10,16(sp)
    80005616:	6165                	addi	sp,sp,112
    80005618:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000561a:	00018697          	auipc	a3,0x18
    8000561e:	9e66b683          	ld	a3,-1562(a3) # 8001d000 <disk+0x2000>
    80005622:	96ba                	add	a3,a3,a4
    80005624:	4609                	li	a2,2
    80005626:	00c69623          	sh	a2,12(a3)
    8000562a:	b5c9                	j	800054ec <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000562c:	f9042583          	lw	a1,-112(s0)
    80005630:	20058793          	addi	a5,a1,512
    80005634:	0792                	slli	a5,a5,0x4
    80005636:	00016517          	auipc	a0,0x16
    8000563a:	a7250513          	addi	a0,a0,-1422 # 8001b0a8 <disk+0xa8>
    8000563e:	953e                	add	a0,a0,a5
  if(write)
    80005640:	e20d11e3          	bnez	s10,80005462 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005644:	20058713          	addi	a4,a1,512
    80005648:	00471693          	slli	a3,a4,0x4
    8000564c:	00016717          	auipc	a4,0x16
    80005650:	9b470713          	addi	a4,a4,-1612 # 8001b000 <disk>
    80005654:	9736                	add	a4,a4,a3
    80005656:	0a072423          	sw	zero,168(a4)
    8000565a:	b505                	j	8000547a <virtio_disk_rw+0xf4>

000000008000565c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000565c:	1101                	addi	sp,sp,-32
    8000565e:	ec06                	sd	ra,24(sp)
    80005660:	e822                	sd	s0,16(sp)
    80005662:	e426                	sd	s1,8(sp)
    80005664:	e04a                	sd	s2,0(sp)
    80005666:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005668:	00018517          	auipc	a0,0x18
    8000566c:	ac050513          	addi	a0,a0,-1344 # 8001d128 <disk+0x2128>
    80005670:	00001097          	auipc	ra,0x1
    80005674:	b8e080e7          	jalr	-1138(ra) # 800061fe <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005678:	10001737          	lui	a4,0x10001
    8000567c:	533c                	lw	a5,96(a4)
    8000567e:	8b8d                	andi	a5,a5,3
    80005680:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005682:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005686:	00018797          	auipc	a5,0x18
    8000568a:	97a78793          	addi	a5,a5,-1670 # 8001d000 <disk+0x2000>
    8000568e:	6b94                	ld	a3,16(a5)
    80005690:	0207d703          	lhu	a4,32(a5)
    80005694:	0026d783          	lhu	a5,2(a3)
    80005698:	06f70163          	beq	a4,a5,800056fa <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000569c:	00016917          	auipc	s2,0x16
    800056a0:	96490913          	addi	s2,s2,-1692 # 8001b000 <disk>
    800056a4:	00018497          	auipc	s1,0x18
    800056a8:	95c48493          	addi	s1,s1,-1700 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056ac:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056b0:	6898                	ld	a4,16(s1)
    800056b2:	0204d783          	lhu	a5,32(s1)
    800056b6:	8b9d                	andi	a5,a5,7
    800056b8:	078e                	slli	a5,a5,0x3
    800056ba:	97ba                	add	a5,a5,a4
    800056bc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056be:	20078713          	addi	a4,a5,512
    800056c2:	0712                	slli	a4,a4,0x4
    800056c4:	974a                	add	a4,a4,s2
    800056c6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056ca:	e731                	bnez	a4,80005716 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056cc:	20078793          	addi	a5,a5,512
    800056d0:	0792                	slli	a5,a5,0x4
    800056d2:	97ca                	add	a5,a5,s2
    800056d4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056d6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056da:	ffffc097          	auipc	ra,0xffffc
    800056de:	0e6080e7          	jalr	230(ra) # 800017c0 <wakeup>

    disk.used_idx += 1;
    800056e2:	0204d783          	lhu	a5,32(s1)
    800056e6:	2785                	addiw	a5,a5,1
    800056e8:	17c2                	slli	a5,a5,0x30
    800056ea:	93c1                	srli	a5,a5,0x30
    800056ec:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056f0:	6898                	ld	a4,16(s1)
    800056f2:	00275703          	lhu	a4,2(a4)
    800056f6:	faf71be3          	bne	a4,a5,800056ac <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056fa:	00018517          	auipc	a0,0x18
    800056fe:	a2e50513          	addi	a0,a0,-1490 # 8001d128 <disk+0x2128>
    80005702:	00001097          	auipc	ra,0x1
    80005706:	bb0080e7          	jalr	-1104(ra) # 800062b2 <release>
}
    8000570a:	60e2                	ld	ra,24(sp)
    8000570c:	6442                	ld	s0,16(sp)
    8000570e:	64a2                	ld	s1,8(sp)
    80005710:	6902                	ld	s2,0(sp)
    80005712:	6105                	addi	sp,sp,32
    80005714:	8082                	ret
      panic("virtio_disk_intr status");
    80005716:	00003517          	auipc	a0,0x3
    8000571a:	0c250513          	addi	a0,a0,194 # 800087d8 <syscalls+0x3b0>
    8000571e:	00000097          	auipc	ra,0x0
    80005722:	52a080e7          	jalr	1322(ra) # 80005c48 <panic>

0000000080005726 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005726:	1141                	addi	sp,sp,-16
    80005728:	e422                	sd	s0,8(sp)
    8000572a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000572c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005730:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005734:	0037979b          	slliw	a5,a5,0x3
    80005738:	02004737          	lui	a4,0x2004
    8000573c:	97ba                	add	a5,a5,a4
    8000573e:	0200c737          	lui	a4,0x200c
    80005742:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005746:	000f4637          	lui	a2,0xf4
    8000574a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000574e:	95b2                	add	a1,a1,a2
    80005750:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005752:	00269713          	slli	a4,a3,0x2
    80005756:	9736                	add	a4,a4,a3
    80005758:	00371693          	slli	a3,a4,0x3
    8000575c:	00019717          	auipc	a4,0x19
    80005760:	8a470713          	addi	a4,a4,-1884 # 8001e000 <timer_scratch>
    80005764:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005766:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005768:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000576a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000576e:	00000797          	auipc	a5,0x0
    80005772:	97278793          	addi	a5,a5,-1678 # 800050e0 <timervec>
    80005776:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000577a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000577e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005782:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005786:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000578a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000578e:	30479073          	csrw	mie,a5
}
    80005792:	6422                	ld	s0,8(sp)
    80005794:	0141                	addi	sp,sp,16
    80005796:	8082                	ret

0000000080005798 <start>:
{
    80005798:	1141                	addi	sp,sp,-16
    8000579a:	e406                	sd	ra,8(sp)
    8000579c:	e022                	sd	s0,0(sp)
    8000579e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057a0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057a4:	7779                	lui	a4,0xffffe
    800057a6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057aa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ac:	6705                	lui	a4,0x1
    800057ae:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057b4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057b8:	ffffb797          	auipc	a5,0xffffb
    800057bc:	b6e78793          	addi	a5,a5,-1170 # 80000326 <main>
    800057c0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057c4:	4781                	li	a5,0
    800057c6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057ca:	67c1                	lui	a5,0x10
    800057cc:	17fd                	addi	a5,a5,-1
    800057ce:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057d2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057d6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057da:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057de:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057e2:	57fd                	li	a5,-1
    800057e4:	83a9                	srli	a5,a5,0xa
    800057e6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057ea:	47bd                	li	a5,15
    800057ec:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057f0:	00000097          	auipc	ra,0x0
    800057f4:	f36080e7          	jalr	-202(ra) # 80005726 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057f8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057fc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057fe:	823e                	mv	tp,a5
  asm volatile("mret");
    80005800:	30200073          	mret
}
    80005804:	60a2                	ld	ra,8(sp)
    80005806:	6402                	ld	s0,0(sp)
    80005808:	0141                	addi	sp,sp,16
    8000580a:	8082                	ret

000000008000580c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000580c:	715d                	addi	sp,sp,-80
    8000580e:	e486                	sd	ra,72(sp)
    80005810:	e0a2                	sd	s0,64(sp)
    80005812:	fc26                	sd	s1,56(sp)
    80005814:	f84a                	sd	s2,48(sp)
    80005816:	f44e                	sd	s3,40(sp)
    80005818:	f052                	sd	s4,32(sp)
    8000581a:	ec56                	sd	s5,24(sp)
    8000581c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000581e:	04c05663          	blez	a2,8000586a <consolewrite+0x5e>
    80005822:	8a2a                	mv	s4,a0
    80005824:	84ae                	mv	s1,a1
    80005826:	89b2                	mv	s3,a2
    80005828:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000582a:	5afd                	li	s5,-1
    8000582c:	4685                	li	a3,1
    8000582e:	8626                	mv	a2,s1
    80005830:	85d2                	mv	a1,s4
    80005832:	fbf40513          	addi	a0,s0,-65
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	1f8080e7          	jalr	504(ra) # 80001a2e <either_copyin>
    8000583e:	01550c63          	beq	a0,s5,80005856 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005842:	fbf44503          	lbu	a0,-65(s0)
    80005846:	00000097          	auipc	ra,0x0
    8000584a:	7fa080e7          	jalr	2042(ra) # 80006040 <uartputc>
  for(i = 0; i < n; i++){
    8000584e:	2905                	addiw	s2,s2,1
    80005850:	0485                	addi	s1,s1,1
    80005852:	fd299de3          	bne	s3,s2,8000582c <consolewrite+0x20>
  }

  return i;
}
    80005856:	854a                	mv	a0,s2
    80005858:	60a6                	ld	ra,72(sp)
    8000585a:	6406                	ld	s0,64(sp)
    8000585c:	74e2                	ld	s1,56(sp)
    8000585e:	7942                	ld	s2,48(sp)
    80005860:	79a2                	ld	s3,40(sp)
    80005862:	7a02                	ld	s4,32(sp)
    80005864:	6ae2                	ld	s5,24(sp)
    80005866:	6161                	addi	sp,sp,80
    80005868:	8082                	ret
  for(i = 0; i < n; i++){
    8000586a:	4901                	li	s2,0
    8000586c:	b7ed                	j	80005856 <consolewrite+0x4a>

000000008000586e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000586e:	7119                	addi	sp,sp,-128
    80005870:	fc86                	sd	ra,120(sp)
    80005872:	f8a2                	sd	s0,112(sp)
    80005874:	f4a6                	sd	s1,104(sp)
    80005876:	f0ca                	sd	s2,96(sp)
    80005878:	ecce                	sd	s3,88(sp)
    8000587a:	e8d2                	sd	s4,80(sp)
    8000587c:	e4d6                	sd	s5,72(sp)
    8000587e:	e0da                	sd	s6,64(sp)
    80005880:	fc5e                	sd	s7,56(sp)
    80005882:	f862                	sd	s8,48(sp)
    80005884:	f466                	sd	s9,40(sp)
    80005886:	f06a                	sd	s10,32(sp)
    80005888:	ec6e                	sd	s11,24(sp)
    8000588a:	0100                	addi	s0,sp,128
    8000588c:	8b2a                	mv	s6,a0
    8000588e:	8aae                	mv	s5,a1
    80005890:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005892:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005896:	00021517          	auipc	a0,0x21
    8000589a:	8aa50513          	addi	a0,a0,-1878 # 80026140 <cons>
    8000589e:	00001097          	auipc	ra,0x1
    800058a2:	960080e7          	jalr	-1696(ra) # 800061fe <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058a6:	00021497          	auipc	s1,0x21
    800058aa:	89a48493          	addi	s1,s1,-1894 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058ae:	89a6                	mv	s3,s1
    800058b0:	00021917          	auipc	s2,0x21
    800058b4:	92890913          	addi	s2,s2,-1752 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058b8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058bc:	4da9                	li	s11,10
  while(n > 0){
    800058be:	07405863          	blez	s4,8000592e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058c2:	0984a783          	lw	a5,152(s1)
    800058c6:	09c4a703          	lw	a4,156(s1)
    800058ca:	02f71463          	bne	a4,a5,800058f2 <consoleread+0x84>
      if(myproc()->killed){
    800058ce:	ffffb097          	auipc	ra,0xffffb
    800058d2:	6aa080e7          	jalr	1706(ra) # 80000f78 <myproc>
    800058d6:	551c                	lw	a5,40(a0)
    800058d8:	e7b5                	bnez	a5,80005944 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058da:	85ce                	mv	a1,s3
    800058dc:	854a                	mv	a0,s2
    800058de:	ffffc097          	auipc	ra,0xffffc
    800058e2:	d56080e7          	jalr	-682(ra) # 80001634 <sleep>
    while(cons.r == cons.w){
    800058e6:	0984a783          	lw	a5,152(s1)
    800058ea:	09c4a703          	lw	a4,156(s1)
    800058ee:	fef700e3          	beq	a4,a5,800058ce <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058f2:	0017871b          	addiw	a4,a5,1
    800058f6:	08e4ac23          	sw	a4,152(s1)
    800058fa:	07f7f713          	andi	a4,a5,127
    800058fe:	9726                	add	a4,a4,s1
    80005900:	01874703          	lbu	a4,24(a4)
    80005904:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005908:	079c0663          	beq	s8,s9,80005974 <consoleread+0x106>
    cbuf = c;
    8000590c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005910:	4685                	li	a3,1
    80005912:	f8f40613          	addi	a2,s0,-113
    80005916:	85d6                	mv	a1,s5
    80005918:	855a                	mv	a0,s6
    8000591a:	ffffc097          	auipc	ra,0xffffc
    8000591e:	0be080e7          	jalr	190(ra) # 800019d8 <either_copyout>
    80005922:	01a50663          	beq	a0,s10,8000592e <consoleread+0xc0>
    dst++;
    80005926:	0a85                	addi	s5,s5,1
    --n;
    80005928:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000592a:	f9bc1ae3          	bne	s8,s11,800058be <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000592e:	00021517          	auipc	a0,0x21
    80005932:	81250513          	addi	a0,a0,-2030 # 80026140 <cons>
    80005936:	00001097          	auipc	ra,0x1
    8000593a:	97c080e7          	jalr	-1668(ra) # 800062b2 <release>

  return target - n;
    8000593e:	414b853b          	subw	a0,s7,s4
    80005942:	a811                	j	80005956 <consoleread+0xe8>
        release(&cons.lock);
    80005944:	00020517          	auipc	a0,0x20
    80005948:	7fc50513          	addi	a0,a0,2044 # 80026140 <cons>
    8000594c:	00001097          	auipc	ra,0x1
    80005950:	966080e7          	jalr	-1690(ra) # 800062b2 <release>
        return -1;
    80005954:	557d                	li	a0,-1
}
    80005956:	70e6                	ld	ra,120(sp)
    80005958:	7446                	ld	s0,112(sp)
    8000595a:	74a6                	ld	s1,104(sp)
    8000595c:	7906                	ld	s2,96(sp)
    8000595e:	69e6                	ld	s3,88(sp)
    80005960:	6a46                	ld	s4,80(sp)
    80005962:	6aa6                	ld	s5,72(sp)
    80005964:	6b06                	ld	s6,64(sp)
    80005966:	7be2                	ld	s7,56(sp)
    80005968:	7c42                	ld	s8,48(sp)
    8000596a:	7ca2                	ld	s9,40(sp)
    8000596c:	7d02                	ld	s10,32(sp)
    8000596e:	6de2                	ld	s11,24(sp)
    80005970:	6109                	addi	sp,sp,128
    80005972:	8082                	ret
      if(n < target){
    80005974:	000a071b          	sext.w	a4,s4
    80005978:	fb777be3          	bgeu	a4,s7,8000592e <consoleread+0xc0>
        cons.r--;
    8000597c:	00021717          	auipc	a4,0x21
    80005980:	84f72e23          	sw	a5,-1956(a4) # 800261d8 <cons+0x98>
    80005984:	b76d                	j	8000592e <consoleread+0xc0>

0000000080005986 <consputc>:
{
    80005986:	1141                	addi	sp,sp,-16
    80005988:	e406                	sd	ra,8(sp)
    8000598a:	e022                	sd	s0,0(sp)
    8000598c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000598e:	10000793          	li	a5,256
    80005992:	00f50a63          	beq	a0,a5,800059a6 <consputc+0x20>
    uartputc_sync(c);
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	5d0080e7          	jalr	1488(ra) # 80005f66 <uartputc_sync>
}
    8000599e:	60a2                	ld	ra,8(sp)
    800059a0:	6402                	ld	s0,0(sp)
    800059a2:	0141                	addi	sp,sp,16
    800059a4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059a6:	4521                	li	a0,8
    800059a8:	00000097          	auipc	ra,0x0
    800059ac:	5be080e7          	jalr	1470(ra) # 80005f66 <uartputc_sync>
    800059b0:	02000513          	li	a0,32
    800059b4:	00000097          	auipc	ra,0x0
    800059b8:	5b2080e7          	jalr	1458(ra) # 80005f66 <uartputc_sync>
    800059bc:	4521                	li	a0,8
    800059be:	00000097          	auipc	ra,0x0
    800059c2:	5a8080e7          	jalr	1448(ra) # 80005f66 <uartputc_sync>
    800059c6:	bfe1                	j	8000599e <consputc+0x18>

00000000800059c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059c8:	1101                	addi	sp,sp,-32
    800059ca:	ec06                	sd	ra,24(sp)
    800059cc:	e822                	sd	s0,16(sp)
    800059ce:	e426                	sd	s1,8(sp)
    800059d0:	e04a                	sd	s2,0(sp)
    800059d2:	1000                	addi	s0,sp,32
    800059d4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059d6:	00020517          	auipc	a0,0x20
    800059da:	76a50513          	addi	a0,a0,1898 # 80026140 <cons>
    800059de:	00001097          	auipc	ra,0x1
    800059e2:	820080e7          	jalr	-2016(ra) # 800061fe <acquire>

  switch(c){
    800059e6:	47d5                	li	a5,21
    800059e8:	0af48663          	beq	s1,a5,80005a94 <consoleintr+0xcc>
    800059ec:	0297ca63          	blt	a5,s1,80005a20 <consoleintr+0x58>
    800059f0:	47a1                	li	a5,8
    800059f2:	0ef48763          	beq	s1,a5,80005ae0 <consoleintr+0x118>
    800059f6:	47c1                	li	a5,16
    800059f8:	10f49a63          	bne	s1,a5,80005b0c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059fc:	ffffc097          	auipc	ra,0xffffc
    80005a00:	088080e7          	jalr	136(ra) # 80001a84 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a04:	00020517          	auipc	a0,0x20
    80005a08:	73c50513          	addi	a0,a0,1852 # 80026140 <cons>
    80005a0c:	00001097          	auipc	ra,0x1
    80005a10:	8a6080e7          	jalr	-1882(ra) # 800062b2 <release>
}
    80005a14:	60e2                	ld	ra,24(sp)
    80005a16:	6442                	ld	s0,16(sp)
    80005a18:	64a2                	ld	s1,8(sp)
    80005a1a:	6902                	ld	s2,0(sp)
    80005a1c:	6105                	addi	sp,sp,32
    80005a1e:	8082                	ret
  switch(c){
    80005a20:	07f00793          	li	a5,127
    80005a24:	0af48e63          	beq	s1,a5,80005ae0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a28:	00020717          	auipc	a4,0x20
    80005a2c:	71870713          	addi	a4,a4,1816 # 80026140 <cons>
    80005a30:	0a072783          	lw	a5,160(a4)
    80005a34:	09872703          	lw	a4,152(a4)
    80005a38:	9f99                	subw	a5,a5,a4
    80005a3a:	07f00713          	li	a4,127
    80005a3e:	fcf763e3          	bltu	a4,a5,80005a04 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a42:	47b5                	li	a5,13
    80005a44:	0cf48763          	beq	s1,a5,80005b12 <consoleintr+0x14a>
      consputc(c);
    80005a48:	8526                	mv	a0,s1
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	f3c080e7          	jalr	-196(ra) # 80005986 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a52:	00020797          	auipc	a5,0x20
    80005a56:	6ee78793          	addi	a5,a5,1774 # 80026140 <cons>
    80005a5a:	0a07a703          	lw	a4,160(a5)
    80005a5e:	0017069b          	addiw	a3,a4,1
    80005a62:	0006861b          	sext.w	a2,a3
    80005a66:	0ad7a023          	sw	a3,160(a5)
    80005a6a:	07f77713          	andi	a4,a4,127
    80005a6e:	97ba                	add	a5,a5,a4
    80005a70:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a74:	47a9                	li	a5,10
    80005a76:	0cf48563          	beq	s1,a5,80005b40 <consoleintr+0x178>
    80005a7a:	4791                	li	a5,4
    80005a7c:	0cf48263          	beq	s1,a5,80005b40 <consoleintr+0x178>
    80005a80:	00020797          	auipc	a5,0x20
    80005a84:	7587a783          	lw	a5,1880(a5) # 800261d8 <cons+0x98>
    80005a88:	0807879b          	addiw	a5,a5,128
    80005a8c:	f6f61ce3          	bne	a2,a5,80005a04 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a90:	863e                	mv	a2,a5
    80005a92:	a07d                	j	80005b40 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a94:	00020717          	auipc	a4,0x20
    80005a98:	6ac70713          	addi	a4,a4,1708 # 80026140 <cons>
    80005a9c:	0a072783          	lw	a5,160(a4)
    80005aa0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aa4:	00020497          	auipc	s1,0x20
    80005aa8:	69c48493          	addi	s1,s1,1692 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005aac:	4929                	li	s2,10
    80005aae:	f4f70be3          	beq	a4,a5,80005a04 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ab2:	37fd                	addiw	a5,a5,-1
    80005ab4:	07f7f713          	andi	a4,a5,127
    80005ab8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aba:	01874703          	lbu	a4,24(a4)
    80005abe:	f52703e3          	beq	a4,s2,80005a04 <consoleintr+0x3c>
      cons.e--;
    80005ac2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ac6:	10000513          	li	a0,256
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	ebc080e7          	jalr	-324(ra) # 80005986 <consputc>
    while(cons.e != cons.w &&
    80005ad2:	0a04a783          	lw	a5,160(s1)
    80005ad6:	09c4a703          	lw	a4,156(s1)
    80005ada:	fcf71ce3          	bne	a4,a5,80005ab2 <consoleintr+0xea>
    80005ade:	b71d                	j	80005a04 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ae0:	00020717          	auipc	a4,0x20
    80005ae4:	66070713          	addi	a4,a4,1632 # 80026140 <cons>
    80005ae8:	0a072783          	lw	a5,160(a4)
    80005aec:	09c72703          	lw	a4,156(a4)
    80005af0:	f0f70ae3          	beq	a4,a5,80005a04 <consoleintr+0x3c>
      cons.e--;
    80005af4:	37fd                	addiw	a5,a5,-1
    80005af6:	00020717          	auipc	a4,0x20
    80005afa:	6ef72523          	sw	a5,1770(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005afe:	10000513          	li	a0,256
    80005b02:	00000097          	auipc	ra,0x0
    80005b06:	e84080e7          	jalr	-380(ra) # 80005986 <consputc>
    80005b0a:	bded                	j	80005a04 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b0c:	ee048ce3          	beqz	s1,80005a04 <consoleintr+0x3c>
    80005b10:	bf21                	j	80005a28 <consoleintr+0x60>
      consputc(c);
    80005b12:	4529                	li	a0,10
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	e72080e7          	jalr	-398(ra) # 80005986 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b1c:	00020797          	auipc	a5,0x20
    80005b20:	62478793          	addi	a5,a5,1572 # 80026140 <cons>
    80005b24:	0a07a703          	lw	a4,160(a5)
    80005b28:	0017069b          	addiw	a3,a4,1
    80005b2c:	0006861b          	sext.w	a2,a3
    80005b30:	0ad7a023          	sw	a3,160(a5)
    80005b34:	07f77713          	andi	a4,a4,127
    80005b38:	97ba                	add	a5,a5,a4
    80005b3a:	4729                	li	a4,10
    80005b3c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b40:	00020797          	auipc	a5,0x20
    80005b44:	68c7ae23          	sw	a2,1692(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b48:	00020517          	auipc	a0,0x20
    80005b4c:	69050513          	addi	a0,a0,1680 # 800261d8 <cons+0x98>
    80005b50:	ffffc097          	auipc	ra,0xffffc
    80005b54:	c70080e7          	jalr	-912(ra) # 800017c0 <wakeup>
    80005b58:	b575                	j	80005a04 <consoleintr+0x3c>

0000000080005b5a <consoleinit>:

void
consoleinit(void)
{
    80005b5a:	1141                	addi	sp,sp,-16
    80005b5c:	e406                	sd	ra,8(sp)
    80005b5e:	e022                	sd	s0,0(sp)
    80005b60:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b62:	00003597          	auipc	a1,0x3
    80005b66:	c8e58593          	addi	a1,a1,-882 # 800087f0 <syscalls+0x3c8>
    80005b6a:	00020517          	auipc	a0,0x20
    80005b6e:	5d650513          	addi	a0,a0,1494 # 80026140 <cons>
    80005b72:	00000097          	auipc	ra,0x0
    80005b76:	5fc080e7          	jalr	1532(ra) # 8000616e <initlock>

  uartinit();
    80005b7a:	00000097          	auipc	ra,0x0
    80005b7e:	39c080e7          	jalr	924(ra) # 80005f16 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b82:	00013797          	auipc	a5,0x13
    80005b86:	74678793          	addi	a5,a5,1862 # 800192c8 <devsw>
    80005b8a:	00000717          	auipc	a4,0x0
    80005b8e:	ce470713          	addi	a4,a4,-796 # 8000586e <consoleread>
    80005b92:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b94:	00000717          	auipc	a4,0x0
    80005b98:	c7870713          	addi	a4,a4,-904 # 8000580c <consolewrite>
    80005b9c:	ef98                	sd	a4,24(a5)
}
    80005b9e:	60a2                	ld	ra,8(sp)
    80005ba0:	6402                	ld	s0,0(sp)
    80005ba2:	0141                	addi	sp,sp,16
    80005ba4:	8082                	ret

0000000080005ba6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ba6:	7179                	addi	sp,sp,-48
    80005ba8:	f406                	sd	ra,40(sp)
    80005baa:	f022                	sd	s0,32(sp)
    80005bac:	ec26                	sd	s1,24(sp)
    80005bae:	e84a                	sd	s2,16(sp)
    80005bb0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bb2:	c219                	beqz	a2,80005bb8 <printint+0x12>
    80005bb4:	08054663          	bltz	a0,80005c40 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bb8:	2501                	sext.w	a0,a0
    80005bba:	4881                	li	a7,0
    80005bbc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bc0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bc2:	2581                	sext.w	a1,a1
    80005bc4:	00003617          	auipc	a2,0x3
    80005bc8:	c6c60613          	addi	a2,a2,-916 # 80008830 <digits>
    80005bcc:	883a                	mv	a6,a4
    80005bce:	2705                	addiw	a4,a4,1
    80005bd0:	02b577bb          	remuw	a5,a0,a1
    80005bd4:	1782                	slli	a5,a5,0x20
    80005bd6:	9381                	srli	a5,a5,0x20
    80005bd8:	97b2                	add	a5,a5,a2
    80005bda:	0007c783          	lbu	a5,0(a5)
    80005bde:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005be2:	0005079b          	sext.w	a5,a0
    80005be6:	02b5553b          	divuw	a0,a0,a1
    80005bea:	0685                	addi	a3,a3,1
    80005bec:	feb7f0e3          	bgeu	a5,a1,80005bcc <printint+0x26>

  if(sign)
    80005bf0:	00088b63          	beqz	a7,80005c06 <printint+0x60>
    buf[i++] = '-';
    80005bf4:	fe040793          	addi	a5,s0,-32
    80005bf8:	973e                	add	a4,a4,a5
    80005bfa:	02d00793          	li	a5,45
    80005bfe:	fef70823          	sb	a5,-16(a4)
    80005c02:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c06:	02e05763          	blez	a4,80005c34 <printint+0x8e>
    80005c0a:	fd040793          	addi	a5,s0,-48
    80005c0e:	00e784b3          	add	s1,a5,a4
    80005c12:	fff78913          	addi	s2,a5,-1
    80005c16:	993a                	add	s2,s2,a4
    80005c18:	377d                	addiw	a4,a4,-1
    80005c1a:	1702                	slli	a4,a4,0x20
    80005c1c:	9301                	srli	a4,a4,0x20
    80005c1e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c22:	fff4c503          	lbu	a0,-1(s1)
    80005c26:	00000097          	auipc	ra,0x0
    80005c2a:	d60080e7          	jalr	-672(ra) # 80005986 <consputc>
  while(--i >= 0)
    80005c2e:	14fd                	addi	s1,s1,-1
    80005c30:	ff2499e3          	bne	s1,s2,80005c22 <printint+0x7c>
}
    80005c34:	70a2                	ld	ra,40(sp)
    80005c36:	7402                	ld	s0,32(sp)
    80005c38:	64e2                	ld	s1,24(sp)
    80005c3a:	6942                	ld	s2,16(sp)
    80005c3c:	6145                	addi	sp,sp,48
    80005c3e:	8082                	ret
    x = -xx;
    80005c40:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c44:	4885                	li	a7,1
    x = -xx;
    80005c46:	bf9d                	j	80005bbc <printint+0x16>

0000000080005c48 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c48:	1101                	addi	sp,sp,-32
    80005c4a:	ec06                	sd	ra,24(sp)
    80005c4c:	e822                	sd	s0,16(sp)
    80005c4e:	e426                	sd	s1,8(sp)
    80005c50:	1000                	addi	s0,sp,32
    80005c52:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c54:	00020797          	auipc	a5,0x20
    80005c58:	5a07a623          	sw	zero,1452(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c5c:	00003517          	auipc	a0,0x3
    80005c60:	b9c50513          	addi	a0,a0,-1124 # 800087f8 <syscalls+0x3d0>
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	02e080e7          	jalr	46(ra) # 80005c92 <printf>
  printf(s);
    80005c6c:	8526                	mv	a0,s1
    80005c6e:	00000097          	auipc	ra,0x0
    80005c72:	024080e7          	jalr	36(ra) # 80005c92 <printf>
  printf("\n");
    80005c76:	00002517          	auipc	a0,0x2
    80005c7a:	3d250513          	addi	a0,a0,978 # 80008048 <etext+0x48>
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	014080e7          	jalr	20(ra) # 80005c92 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c86:	4785                	li	a5,1
    80005c88:	00003717          	auipc	a4,0x3
    80005c8c:	38f72a23          	sw	a5,916(a4) # 8000901c <panicked>
  for(;;)
    80005c90:	a001                	j	80005c90 <panic+0x48>

0000000080005c92 <printf>:
{
    80005c92:	7131                	addi	sp,sp,-192
    80005c94:	fc86                	sd	ra,120(sp)
    80005c96:	f8a2                	sd	s0,112(sp)
    80005c98:	f4a6                	sd	s1,104(sp)
    80005c9a:	f0ca                	sd	s2,96(sp)
    80005c9c:	ecce                	sd	s3,88(sp)
    80005c9e:	e8d2                	sd	s4,80(sp)
    80005ca0:	e4d6                	sd	s5,72(sp)
    80005ca2:	e0da                	sd	s6,64(sp)
    80005ca4:	fc5e                	sd	s7,56(sp)
    80005ca6:	f862                	sd	s8,48(sp)
    80005ca8:	f466                	sd	s9,40(sp)
    80005caa:	f06a                	sd	s10,32(sp)
    80005cac:	ec6e                	sd	s11,24(sp)
    80005cae:	0100                	addi	s0,sp,128
    80005cb0:	8a2a                	mv	s4,a0
    80005cb2:	e40c                	sd	a1,8(s0)
    80005cb4:	e810                	sd	a2,16(s0)
    80005cb6:	ec14                	sd	a3,24(s0)
    80005cb8:	f018                	sd	a4,32(s0)
    80005cba:	f41c                	sd	a5,40(s0)
    80005cbc:	03043823          	sd	a6,48(s0)
    80005cc0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cc4:	00020d97          	auipc	s11,0x20
    80005cc8:	53cdad83          	lw	s11,1340(s11) # 80026200 <pr+0x18>
  if(locking)
    80005ccc:	020d9b63          	bnez	s11,80005d02 <printf+0x70>
  if (fmt == 0)
    80005cd0:	040a0263          	beqz	s4,80005d14 <printf+0x82>
  va_start(ap, fmt);
    80005cd4:	00840793          	addi	a5,s0,8
    80005cd8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cdc:	000a4503          	lbu	a0,0(s4)
    80005ce0:	16050263          	beqz	a0,80005e44 <printf+0x1b2>
    80005ce4:	4481                	li	s1,0
    if(c != '%'){
    80005ce6:	02500a93          	li	s5,37
    switch(c){
    80005cea:	07000b13          	li	s6,112
  consputc('x');
    80005cee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cf0:	00003b97          	auipc	s7,0x3
    80005cf4:	b40b8b93          	addi	s7,s7,-1216 # 80008830 <digits>
    switch(c){
    80005cf8:	07300c93          	li	s9,115
    80005cfc:	06400c13          	li	s8,100
    80005d00:	a82d                	j	80005d3a <printf+0xa8>
    acquire(&pr.lock);
    80005d02:	00020517          	auipc	a0,0x20
    80005d06:	4e650513          	addi	a0,a0,1254 # 800261e8 <pr>
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	4f4080e7          	jalr	1268(ra) # 800061fe <acquire>
    80005d12:	bf7d                	j	80005cd0 <printf+0x3e>
    panic("null fmt");
    80005d14:	00003517          	auipc	a0,0x3
    80005d18:	af450513          	addi	a0,a0,-1292 # 80008808 <syscalls+0x3e0>
    80005d1c:	00000097          	auipc	ra,0x0
    80005d20:	f2c080e7          	jalr	-212(ra) # 80005c48 <panic>
      consputc(c);
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	c62080e7          	jalr	-926(ra) # 80005986 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d2c:	2485                	addiw	s1,s1,1
    80005d2e:	009a07b3          	add	a5,s4,s1
    80005d32:	0007c503          	lbu	a0,0(a5)
    80005d36:	10050763          	beqz	a0,80005e44 <printf+0x1b2>
    if(c != '%'){
    80005d3a:	ff5515e3          	bne	a0,s5,80005d24 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d3e:	2485                	addiw	s1,s1,1
    80005d40:	009a07b3          	add	a5,s4,s1
    80005d44:	0007c783          	lbu	a5,0(a5)
    80005d48:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d4c:	cfe5                	beqz	a5,80005e44 <printf+0x1b2>
    switch(c){
    80005d4e:	05678a63          	beq	a5,s6,80005da2 <printf+0x110>
    80005d52:	02fb7663          	bgeu	s6,a5,80005d7e <printf+0xec>
    80005d56:	09978963          	beq	a5,s9,80005de8 <printf+0x156>
    80005d5a:	07800713          	li	a4,120
    80005d5e:	0ce79863          	bne	a5,a4,80005e2e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d62:	f8843783          	ld	a5,-120(s0)
    80005d66:	00878713          	addi	a4,a5,8
    80005d6a:	f8e43423          	sd	a4,-120(s0)
    80005d6e:	4605                	li	a2,1
    80005d70:	85ea                	mv	a1,s10
    80005d72:	4388                	lw	a0,0(a5)
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	e32080e7          	jalr	-462(ra) # 80005ba6 <printint>
      break;
    80005d7c:	bf45                	j	80005d2c <printf+0x9a>
    switch(c){
    80005d7e:	0b578263          	beq	a5,s5,80005e22 <printf+0x190>
    80005d82:	0b879663          	bne	a5,s8,80005e2e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d86:	f8843783          	ld	a5,-120(s0)
    80005d8a:	00878713          	addi	a4,a5,8
    80005d8e:	f8e43423          	sd	a4,-120(s0)
    80005d92:	4605                	li	a2,1
    80005d94:	45a9                	li	a1,10
    80005d96:	4388                	lw	a0,0(a5)
    80005d98:	00000097          	auipc	ra,0x0
    80005d9c:	e0e080e7          	jalr	-498(ra) # 80005ba6 <printint>
      break;
    80005da0:	b771                	j	80005d2c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005da2:	f8843783          	ld	a5,-120(s0)
    80005da6:	00878713          	addi	a4,a5,8
    80005daa:	f8e43423          	sd	a4,-120(s0)
    80005dae:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005db2:	03000513          	li	a0,48
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	bd0080e7          	jalr	-1072(ra) # 80005986 <consputc>
  consputc('x');
    80005dbe:	07800513          	li	a0,120
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	bc4080e7          	jalr	-1084(ra) # 80005986 <consputc>
    80005dca:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dcc:	03c9d793          	srli	a5,s3,0x3c
    80005dd0:	97de                	add	a5,a5,s7
    80005dd2:	0007c503          	lbu	a0,0(a5)
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	bb0080e7          	jalr	-1104(ra) # 80005986 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dde:	0992                	slli	s3,s3,0x4
    80005de0:	397d                	addiw	s2,s2,-1
    80005de2:	fe0915e3          	bnez	s2,80005dcc <printf+0x13a>
    80005de6:	b799                	j	80005d2c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005de8:	f8843783          	ld	a5,-120(s0)
    80005dec:	00878713          	addi	a4,a5,8
    80005df0:	f8e43423          	sd	a4,-120(s0)
    80005df4:	0007b903          	ld	s2,0(a5)
    80005df8:	00090e63          	beqz	s2,80005e14 <printf+0x182>
      for(; *s; s++)
    80005dfc:	00094503          	lbu	a0,0(s2)
    80005e00:	d515                	beqz	a0,80005d2c <printf+0x9a>
        consputc(*s);
    80005e02:	00000097          	auipc	ra,0x0
    80005e06:	b84080e7          	jalr	-1148(ra) # 80005986 <consputc>
      for(; *s; s++)
    80005e0a:	0905                	addi	s2,s2,1
    80005e0c:	00094503          	lbu	a0,0(s2)
    80005e10:	f96d                	bnez	a0,80005e02 <printf+0x170>
    80005e12:	bf29                	j	80005d2c <printf+0x9a>
        s = "(null)";
    80005e14:	00003917          	auipc	s2,0x3
    80005e18:	9ec90913          	addi	s2,s2,-1556 # 80008800 <syscalls+0x3d8>
      for(; *s; s++)
    80005e1c:	02800513          	li	a0,40
    80005e20:	b7cd                	j	80005e02 <printf+0x170>
      consputc('%');
    80005e22:	8556                	mv	a0,s5
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	b62080e7          	jalr	-1182(ra) # 80005986 <consputc>
      break;
    80005e2c:	b701                	j	80005d2c <printf+0x9a>
      consputc('%');
    80005e2e:	8556                	mv	a0,s5
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	b56080e7          	jalr	-1194(ra) # 80005986 <consputc>
      consputc(c);
    80005e38:	854a                	mv	a0,s2
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	b4c080e7          	jalr	-1204(ra) # 80005986 <consputc>
      break;
    80005e42:	b5ed                	j	80005d2c <printf+0x9a>
  if(locking)
    80005e44:	020d9163          	bnez	s11,80005e66 <printf+0x1d4>
}
    80005e48:	70e6                	ld	ra,120(sp)
    80005e4a:	7446                	ld	s0,112(sp)
    80005e4c:	74a6                	ld	s1,104(sp)
    80005e4e:	7906                	ld	s2,96(sp)
    80005e50:	69e6                	ld	s3,88(sp)
    80005e52:	6a46                	ld	s4,80(sp)
    80005e54:	6aa6                	ld	s5,72(sp)
    80005e56:	6b06                	ld	s6,64(sp)
    80005e58:	7be2                	ld	s7,56(sp)
    80005e5a:	7c42                	ld	s8,48(sp)
    80005e5c:	7ca2                	ld	s9,40(sp)
    80005e5e:	7d02                	ld	s10,32(sp)
    80005e60:	6de2                	ld	s11,24(sp)
    80005e62:	6129                	addi	sp,sp,192
    80005e64:	8082                	ret
    release(&pr.lock);
    80005e66:	00020517          	auipc	a0,0x20
    80005e6a:	38250513          	addi	a0,a0,898 # 800261e8 <pr>
    80005e6e:	00000097          	auipc	ra,0x0
    80005e72:	444080e7          	jalr	1092(ra) # 800062b2 <release>
}
    80005e76:	bfc9                	j	80005e48 <printf+0x1b6>

0000000080005e78 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e78:	1101                	addi	sp,sp,-32
    80005e7a:	ec06                	sd	ra,24(sp)
    80005e7c:	e822                	sd	s0,16(sp)
    80005e7e:	e426                	sd	s1,8(sp)
    80005e80:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e82:	00020497          	auipc	s1,0x20
    80005e86:	36648493          	addi	s1,s1,870 # 800261e8 <pr>
    80005e8a:	00003597          	auipc	a1,0x3
    80005e8e:	98e58593          	addi	a1,a1,-1650 # 80008818 <syscalls+0x3f0>
    80005e92:	8526                	mv	a0,s1
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	2da080e7          	jalr	730(ra) # 8000616e <initlock>
  pr.locking = 1;
    80005e9c:	4785                	li	a5,1
    80005e9e:	cc9c                	sw	a5,24(s1)
}
    80005ea0:	60e2                	ld	ra,24(sp)
    80005ea2:	6442                	ld	s0,16(sp)
    80005ea4:	64a2                	ld	s1,8(sp)
    80005ea6:	6105                	addi	sp,sp,32
    80005ea8:	8082                	ret

0000000080005eaa <backtrace>:

//** prints a list of function calls on the stack above the point at which current frame pointer is pointing
void 
backtrace(void)
{
    80005eaa:	7179                	addi	sp,sp,-48
    80005eac:	f406                	sd	ra,40(sp)
    80005eae:	f022                	sd	s0,32(sp)
    80005eb0:	ec26                	sd	s1,24(sp)
    80005eb2:	e84a                	sd	s2,16(sp)
    80005eb4:	e44e                	sd	s3,8(sp)
    80005eb6:	e052                	sd	s4,0(sp)
    80005eb8:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    80005eba:	00003517          	auipc	a0,0x3
    80005ebe:	96650513          	addi	a0,a0,-1690 # 80008820 <syscalls+0x3f8>
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	dd0080e7          	jalr	-560(ra) # 80005c92 <printf>
//** returns current frame pointer
static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005eca:	84a2                	mv	s1,s0
  uint64 cfp;
  cfp=r_fp();  //current frame pointer
  uint64 upperlimit = PGROUNDUP(cfp);   // top address of stack page
    80005ecc:	6905                	lui	s2,0x1
    80005ece:	197d                	addi	s2,s2,-1
    80005ed0:	9926                	add	s2,s2,s1
    80005ed2:	79fd                	lui	s3,0xfffff
    80005ed4:	01397933          	and	s2,s2,s3
  uint64 lowerlimit = PGROUNDDOWN(cfp); // bottom address of stack page
    80005ed8:	0134f9b3          	and	s3,s1,s3
  while((cfp > lowerlimit) && (cfp < upperlimit))
    80005edc:	0299f563          	bgeu	s3,s1,80005f06 <backtrace+0x5c>
    80005ee0:	0324f363          	bgeu	s1,s2,80005f06 <backtrace+0x5c>
  {
    printf("%p\n",*((uint64*)(cfp-8))); // prints the retuen value
    80005ee4:	00002a17          	auipc	s4,0x2
    80005ee8:	2cca0a13          	addi	s4,s4,716 # 800081b0 <etext+0x1b0>
    80005eec:	ff84b583          	ld	a1,-8(s1)
    80005ef0:	8552                	mv	a0,s4
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	da0080e7          	jalr	-608(ra) # 80005c92 <printf>
    cfp = *((uint64*)(cfp-16));         // update current fp with previous function call fp
    80005efa:	ff04b483          	ld	s1,-16(s1)
  while((cfp > lowerlimit) && (cfp < upperlimit))
    80005efe:	0099f463          	bgeu	s3,s1,80005f06 <backtrace+0x5c>
    80005f02:	ff24e5e3          	bltu	s1,s2,80005eec <backtrace+0x42>
  }
    80005f06:	70a2                	ld	ra,40(sp)
    80005f08:	7402                	ld	s0,32(sp)
    80005f0a:	64e2                	ld	s1,24(sp)
    80005f0c:	6942                	ld	s2,16(sp)
    80005f0e:	69a2                	ld	s3,8(sp)
    80005f10:	6a02                	ld	s4,0(sp)
    80005f12:	6145                	addi	sp,sp,48
    80005f14:	8082                	ret

0000000080005f16 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f16:	1141                	addi	sp,sp,-16
    80005f18:	e406                	sd	ra,8(sp)
    80005f1a:	e022                	sd	s0,0(sp)
    80005f1c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f1e:	100007b7          	lui	a5,0x10000
    80005f22:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f26:	f8000713          	li	a4,-128
    80005f2a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f2e:	470d                	li	a4,3
    80005f30:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f34:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f38:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f3c:	469d                	li	a3,7
    80005f3e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f42:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f46:	00003597          	auipc	a1,0x3
    80005f4a:	90258593          	addi	a1,a1,-1790 # 80008848 <digits+0x18>
    80005f4e:	00020517          	auipc	a0,0x20
    80005f52:	2ba50513          	addi	a0,a0,698 # 80026208 <uart_tx_lock>
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	218080e7          	jalr	536(ra) # 8000616e <initlock>
}
    80005f5e:	60a2                	ld	ra,8(sp)
    80005f60:	6402                	ld	s0,0(sp)
    80005f62:	0141                	addi	sp,sp,16
    80005f64:	8082                	ret

0000000080005f66 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f66:	1101                	addi	sp,sp,-32
    80005f68:	ec06                	sd	ra,24(sp)
    80005f6a:	e822                	sd	s0,16(sp)
    80005f6c:	e426                	sd	s1,8(sp)
    80005f6e:	1000                	addi	s0,sp,32
    80005f70:	84aa                	mv	s1,a0
  push_off();
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	240080e7          	jalr	576(ra) # 800061b2 <push_off>

  if(panicked){
    80005f7a:	00003797          	auipc	a5,0x3
    80005f7e:	0a27a783          	lw	a5,162(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f82:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f86:	c391                	beqz	a5,80005f8a <uartputc_sync+0x24>
    for(;;)
    80005f88:	a001                	j	80005f88 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f8a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f8e:	0ff7f793          	andi	a5,a5,255
    80005f92:	0207f793          	andi	a5,a5,32
    80005f96:	dbf5                	beqz	a5,80005f8a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f98:	0ff4f793          	andi	a5,s1,255
    80005f9c:	10000737          	lui	a4,0x10000
    80005fa0:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	2ae080e7          	jalr	686(ra) # 80006252 <pop_off>
}
    80005fac:	60e2                	ld	ra,24(sp)
    80005fae:	6442                	ld	s0,16(sp)
    80005fb0:	64a2                	ld	s1,8(sp)
    80005fb2:	6105                	addi	sp,sp,32
    80005fb4:	8082                	ret

0000000080005fb6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fb6:	00003717          	auipc	a4,0x3
    80005fba:	06a73703          	ld	a4,106(a4) # 80009020 <uart_tx_r>
    80005fbe:	00003797          	auipc	a5,0x3
    80005fc2:	06a7b783          	ld	a5,106(a5) # 80009028 <uart_tx_w>
    80005fc6:	06e78c63          	beq	a5,a4,8000603e <uartstart+0x88>
{
    80005fca:	7139                	addi	sp,sp,-64
    80005fcc:	fc06                	sd	ra,56(sp)
    80005fce:	f822                	sd	s0,48(sp)
    80005fd0:	f426                	sd	s1,40(sp)
    80005fd2:	f04a                	sd	s2,32(sp)
    80005fd4:	ec4e                	sd	s3,24(sp)
    80005fd6:	e852                	sd	s4,16(sp)
    80005fd8:	e456                	sd	s5,8(sp)
    80005fda:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fdc:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fe0:	00020a17          	auipc	s4,0x20
    80005fe4:	228a0a13          	addi	s4,s4,552 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fe8:	00003497          	auipc	s1,0x3
    80005fec:	03848493          	addi	s1,s1,56 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ff0:	00003997          	auipc	s3,0x3
    80005ff4:	03898993          	addi	s3,s3,56 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ff8:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ffc:	0ff7f793          	andi	a5,a5,255
    80006000:	0207f793          	andi	a5,a5,32
    80006004:	c785                	beqz	a5,8000602c <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006006:	01f77793          	andi	a5,a4,31
    8000600a:	97d2                	add	a5,a5,s4
    8000600c:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006010:	0705                	addi	a4,a4,1
    80006012:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006014:	8526                	mv	a0,s1
    80006016:	ffffb097          	auipc	ra,0xffffb
    8000601a:	7aa080e7          	jalr	1962(ra) # 800017c0 <wakeup>
    
    WriteReg(THR, c);
    8000601e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006022:	6098                	ld	a4,0(s1)
    80006024:	0009b783          	ld	a5,0(s3)
    80006028:	fce798e3          	bne	a5,a4,80005ff8 <uartstart+0x42>
  }
}
    8000602c:	70e2                	ld	ra,56(sp)
    8000602e:	7442                	ld	s0,48(sp)
    80006030:	74a2                	ld	s1,40(sp)
    80006032:	7902                	ld	s2,32(sp)
    80006034:	69e2                	ld	s3,24(sp)
    80006036:	6a42                	ld	s4,16(sp)
    80006038:	6aa2                	ld	s5,8(sp)
    8000603a:	6121                	addi	sp,sp,64
    8000603c:	8082                	ret
    8000603e:	8082                	ret

0000000080006040 <uartputc>:
{
    80006040:	7179                	addi	sp,sp,-48
    80006042:	f406                	sd	ra,40(sp)
    80006044:	f022                	sd	s0,32(sp)
    80006046:	ec26                	sd	s1,24(sp)
    80006048:	e84a                	sd	s2,16(sp)
    8000604a:	e44e                	sd	s3,8(sp)
    8000604c:	e052                	sd	s4,0(sp)
    8000604e:	1800                	addi	s0,sp,48
    80006050:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006052:	00020517          	auipc	a0,0x20
    80006056:	1b650513          	addi	a0,a0,438 # 80026208 <uart_tx_lock>
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	1a4080e7          	jalr	420(ra) # 800061fe <acquire>
  if(panicked){
    80006062:	00003797          	auipc	a5,0x3
    80006066:	fba7a783          	lw	a5,-70(a5) # 8000901c <panicked>
    8000606a:	c391                	beqz	a5,8000606e <uartputc+0x2e>
    for(;;)
    8000606c:	a001                	j	8000606c <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000606e:	00003797          	auipc	a5,0x3
    80006072:	fba7b783          	ld	a5,-70(a5) # 80009028 <uart_tx_w>
    80006076:	00003717          	auipc	a4,0x3
    8000607a:	faa73703          	ld	a4,-86(a4) # 80009020 <uart_tx_r>
    8000607e:	02070713          	addi	a4,a4,32
    80006082:	02f71b63          	bne	a4,a5,800060b8 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006086:	00020a17          	auipc	s4,0x20
    8000608a:	182a0a13          	addi	s4,s4,386 # 80026208 <uart_tx_lock>
    8000608e:	00003497          	auipc	s1,0x3
    80006092:	f9248493          	addi	s1,s1,-110 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006096:	00003917          	auipc	s2,0x3
    8000609a:	f9290913          	addi	s2,s2,-110 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000609e:	85d2                	mv	a1,s4
    800060a0:	8526                	mv	a0,s1
    800060a2:	ffffb097          	auipc	ra,0xffffb
    800060a6:	592080e7          	jalr	1426(ra) # 80001634 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060aa:	00093783          	ld	a5,0(s2)
    800060ae:	6098                	ld	a4,0(s1)
    800060b0:	02070713          	addi	a4,a4,32
    800060b4:	fef705e3          	beq	a4,a5,8000609e <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060b8:	00020497          	auipc	s1,0x20
    800060bc:	15048493          	addi	s1,s1,336 # 80026208 <uart_tx_lock>
    800060c0:	01f7f713          	andi	a4,a5,31
    800060c4:	9726                	add	a4,a4,s1
    800060c6:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060ca:	0785                	addi	a5,a5,1
    800060cc:	00003717          	auipc	a4,0x3
    800060d0:	f4f73e23          	sd	a5,-164(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	ee2080e7          	jalr	-286(ra) # 80005fb6 <uartstart>
      release(&uart_tx_lock);
    800060dc:	8526                	mv	a0,s1
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	1d4080e7          	jalr	468(ra) # 800062b2 <release>
}
    800060e6:	70a2                	ld	ra,40(sp)
    800060e8:	7402                	ld	s0,32(sp)
    800060ea:	64e2                	ld	s1,24(sp)
    800060ec:	6942                	ld	s2,16(sp)
    800060ee:	69a2                	ld	s3,8(sp)
    800060f0:	6a02                	ld	s4,0(sp)
    800060f2:	6145                	addi	sp,sp,48
    800060f4:	8082                	ret

00000000800060f6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060f6:	1141                	addi	sp,sp,-16
    800060f8:	e422                	sd	s0,8(sp)
    800060fa:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060fc:	100007b7          	lui	a5,0x10000
    80006100:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006104:	8b85                	andi	a5,a5,1
    80006106:	cb91                	beqz	a5,8000611a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006108:	100007b7          	lui	a5,0x10000
    8000610c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006110:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006114:	6422                	ld	s0,8(sp)
    80006116:	0141                	addi	sp,sp,16
    80006118:	8082                	ret
    return -1;
    8000611a:	557d                	li	a0,-1
    8000611c:	bfe5                	j	80006114 <uartgetc+0x1e>

000000008000611e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000611e:	1101                	addi	sp,sp,-32
    80006120:	ec06                	sd	ra,24(sp)
    80006122:	e822                	sd	s0,16(sp)
    80006124:	e426                	sd	s1,8(sp)
    80006126:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006128:	54fd                	li	s1,-1
    int c = uartgetc();
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	fcc080e7          	jalr	-52(ra) # 800060f6 <uartgetc>
    if(c == -1)
    80006132:	00950763          	beq	a0,s1,80006140 <uartintr+0x22>
      break;
    consoleintr(c);
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	892080e7          	jalr	-1902(ra) # 800059c8 <consoleintr>
  while(1){
    8000613e:	b7f5                	j	8000612a <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006140:	00020497          	auipc	s1,0x20
    80006144:	0c848493          	addi	s1,s1,200 # 80026208 <uart_tx_lock>
    80006148:	8526                	mv	a0,s1
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	0b4080e7          	jalr	180(ra) # 800061fe <acquire>
  uartstart();
    80006152:	00000097          	auipc	ra,0x0
    80006156:	e64080e7          	jalr	-412(ra) # 80005fb6 <uartstart>
  release(&uart_tx_lock);
    8000615a:	8526                	mv	a0,s1
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	156080e7          	jalr	342(ra) # 800062b2 <release>
}
    80006164:	60e2                	ld	ra,24(sp)
    80006166:	6442                	ld	s0,16(sp)
    80006168:	64a2                	ld	s1,8(sp)
    8000616a:	6105                	addi	sp,sp,32
    8000616c:	8082                	ret

000000008000616e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000616e:	1141                	addi	sp,sp,-16
    80006170:	e422                	sd	s0,8(sp)
    80006172:	0800                	addi	s0,sp,16
  lk->name = name;
    80006174:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006176:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000617a:	00053823          	sd	zero,16(a0)
}
    8000617e:	6422                	ld	s0,8(sp)
    80006180:	0141                	addi	sp,sp,16
    80006182:	8082                	ret

0000000080006184 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006184:	411c                	lw	a5,0(a0)
    80006186:	e399                	bnez	a5,8000618c <holding+0x8>
    80006188:	4501                	li	a0,0
  return r;
}
    8000618a:	8082                	ret
{
    8000618c:	1101                	addi	sp,sp,-32
    8000618e:	ec06                	sd	ra,24(sp)
    80006190:	e822                	sd	s0,16(sp)
    80006192:	e426                	sd	s1,8(sp)
    80006194:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006196:	6904                	ld	s1,16(a0)
    80006198:	ffffb097          	auipc	ra,0xffffb
    8000619c:	dc4080e7          	jalr	-572(ra) # 80000f5c <mycpu>
    800061a0:	40a48533          	sub	a0,s1,a0
    800061a4:	00153513          	seqz	a0,a0
}
    800061a8:	60e2                	ld	ra,24(sp)
    800061aa:	6442                	ld	s0,16(sp)
    800061ac:	64a2                	ld	s1,8(sp)
    800061ae:	6105                	addi	sp,sp,32
    800061b0:	8082                	ret

00000000800061b2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061bc:	100024f3          	csrr	s1,sstatus
    800061c0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061c4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061c6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	d92080e7          	jalr	-622(ra) # 80000f5c <mycpu>
    800061d2:	5d3c                	lw	a5,120(a0)
    800061d4:	cf89                	beqz	a5,800061ee <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061d6:	ffffb097          	auipc	ra,0xffffb
    800061da:	d86080e7          	jalr	-634(ra) # 80000f5c <mycpu>
    800061de:	5d3c                	lw	a5,120(a0)
    800061e0:	2785                	addiw	a5,a5,1
    800061e2:	dd3c                	sw	a5,120(a0)
}
    800061e4:	60e2                	ld	ra,24(sp)
    800061e6:	6442                	ld	s0,16(sp)
    800061e8:	64a2                	ld	s1,8(sp)
    800061ea:	6105                	addi	sp,sp,32
    800061ec:	8082                	ret
    mycpu()->intena = old;
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	d6e080e7          	jalr	-658(ra) # 80000f5c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061f6:	8085                	srli	s1,s1,0x1
    800061f8:	8885                	andi	s1,s1,1
    800061fa:	dd64                	sw	s1,124(a0)
    800061fc:	bfe9                	j	800061d6 <push_off+0x24>

00000000800061fe <acquire>:
{
    800061fe:	1101                	addi	sp,sp,-32
    80006200:	ec06                	sd	ra,24(sp)
    80006202:	e822                	sd	s0,16(sp)
    80006204:	e426                	sd	s1,8(sp)
    80006206:	1000                	addi	s0,sp,32
    80006208:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	fa8080e7          	jalr	-88(ra) # 800061b2 <push_off>
  if(holding(lk))
    80006212:	8526                	mv	a0,s1
    80006214:	00000097          	auipc	ra,0x0
    80006218:	f70080e7          	jalr	-144(ra) # 80006184 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000621c:	4705                	li	a4,1
  if(holding(lk))
    8000621e:	e115                	bnez	a0,80006242 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006220:	87ba                	mv	a5,a4
    80006222:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006226:	2781                	sext.w	a5,a5
    80006228:	ffe5                	bnez	a5,80006220 <acquire+0x22>
  __sync_synchronize();
    8000622a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	d2e080e7          	jalr	-722(ra) # 80000f5c <mycpu>
    80006236:	e888                	sd	a0,16(s1)
}
    80006238:	60e2                	ld	ra,24(sp)
    8000623a:	6442                	ld	s0,16(sp)
    8000623c:	64a2                	ld	s1,8(sp)
    8000623e:	6105                	addi	sp,sp,32
    80006240:	8082                	ret
    panic("acquire");
    80006242:	00002517          	auipc	a0,0x2
    80006246:	60e50513          	addi	a0,a0,1550 # 80008850 <digits+0x20>
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	9fe080e7          	jalr	-1538(ra) # 80005c48 <panic>

0000000080006252 <pop_off>:

void
pop_off(void)
{
    80006252:	1141                	addi	sp,sp,-16
    80006254:	e406                	sd	ra,8(sp)
    80006256:	e022                	sd	s0,0(sp)
    80006258:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000625a:	ffffb097          	auipc	ra,0xffffb
    8000625e:	d02080e7          	jalr	-766(ra) # 80000f5c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006262:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006266:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006268:	e78d                	bnez	a5,80006292 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000626a:	5d3c                	lw	a5,120(a0)
    8000626c:	02f05b63          	blez	a5,800062a2 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006270:	37fd                	addiw	a5,a5,-1
    80006272:	0007871b          	sext.w	a4,a5
    80006276:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006278:	eb09                	bnez	a4,8000628a <pop_off+0x38>
    8000627a:	5d7c                	lw	a5,124(a0)
    8000627c:	c799                	beqz	a5,8000628a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000627e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006282:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006286:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000628a:	60a2                	ld	ra,8(sp)
    8000628c:	6402                	ld	s0,0(sp)
    8000628e:	0141                	addi	sp,sp,16
    80006290:	8082                	ret
    panic("pop_off - interruptible");
    80006292:	00002517          	auipc	a0,0x2
    80006296:	5c650513          	addi	a0,a0,1478 # 80008858 <digits+0x28>
    8000629a:	00000097          	auipc	ra,0x0
    8000629e:	9ae080e7          	jalr	-1618(ra) # 80005c48 <panic>
    panic("pop_off");
    800062a2:	00002517          	auipc	a0,0x2
    800062a6:	5ce50513          	addi	a0,a0,1486 # 80008870 <digits+0x40>
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	99e080e7          	jalr	-1634(ra) # 80005c48 <panic>

00000000800062b2 <release>:
{
    800062b2:	1101                	addi	sp,sp,-32
    800062b4:	ec06                	sd	ra,24(sp)
    800062b6:	e822                	sd	s0,16(sp)
    800062b8:	e426                	sd	s1,8(sp)
    800062ba:	1000                	addi	s0,sp,32
    800062bc:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	ec6080e7          	jalr	-314(ra) # 80006184 <holding>
    800062c6:	c115                	beqz	a0,800062ea <release+0x38>
  lk->cpu = 0;
    800062c8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062cc:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062d0:	0f50000f          	fence	iorw,ow
    800062d4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	f7a080e7          	jalr	-134(ra) # 80006252 <pop_off>
}
    800062e0:	60e2                	ld	ra,24(sp)
    800062e2:	6442                	ld	s0,16(sp)
    800062e4:	64a2                	ld	s1,8(sp)
    800062e6:	6105                	addi	sp,sp,32
    800062e8:	8082                	ret
    panic("release");
    800062ea:	00002517          	auipc	a0,0x2
    800062ee:	58e50513          	addi	a0,a0,1422 # 80008878 <digits+0x48>
    800062f2:	00000097          	auipc	ra,0x0
    800062f6:	956080e7          	jalr	-1706(ra) # 80005c48 <panic>
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
