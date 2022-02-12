
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9f013103          	ld	sp,-1552(sp) # 800089f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7e2050ef          	jal	ra,800057f8 <start>

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
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	198080e7          	jalr	408(ra) # 800061f2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	238080e7          	jalr	568(ra) # 800062a6 <release>
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
    8000008e:	c1e080e7          	jalr	-994(ra) # 80005ca8 <panic>

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
    800000f8:	06e080e7          	jalr	110(ra) # 80006162 <initlock>
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
    80000130:	0c6080e7          	jalr	198(ra) # 800061f2 <acquire>
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
    80000148:	162080e7          	jalr	354(ra) # 800062a6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
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
    80000172:	138080e7          	jalr	312(ra) # 800062a6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <freememory>:

uint64
freememory(void)      // *modified*
{
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 nm=0;
  acquire(&kmem.lock);
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	066080e7          	jalr	102(ra) # 800061f2 <acquire>
  r = kmem.freelist;
    80000194:	6c9c                	ld	a5,24(s1)
  while(r){
    80000196:	c785                	beqz	a5,800001be <freememory+0x46>
  uint64 nm=0;
    80000198:	4481                	li	s1,0
    nm++;                // number of pages that are free
    8000019a:	0485                	addi	s1,s1,1
    r= r->next;
    8000019c:	639c                	ld	a5,0(a5)
  while(r){
    8000019e:	fff5                	bnez	a5,8000019a <freememory+0x22>
  }
  release(&kmem.lock);
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	e9050513          	addi	a0,a0,-368 # 80009030 <kmem>
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	0fe080e7          	jalr	254(ra) # 800062a6 <release>

  return nm * PGSIZE;     // number of free bytes 

    800001b0:	00c49513          	slli	a0,s1,0xc
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
  uint64 nm=0;
    800001be:	4481                	li	s1,0
    800001c0:	b7c5                	j	800001a0 <freememory+0x28>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ce09                	beqz	a2,800001e2 <memset+0x20>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	fff6071b          	addiw	a4,a2,-1
    800001d0:	1702                	slli	a4,a4,0x20
    800001d2:	9301                	srli	a4,a4,0x20
    800001d4:	0705                	addi	a4,a4,1
    800001d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x16>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	ca0d                	beqz	a2,8000025a <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	00a5f963          	bgeu	a1,a0,8000023c <memmove+0x1a>
    8000022e:	02061693          	slli	a3,a2,0x20
    80000232:	9281                	srli	a3,a3,0x20
    80000234:	00d58733          	add	a4,a1,a3
    80000238:	02e56463          	bltu	a0,a4,80000260 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	0785                	addi	a5,a5,1
    80000246:	97ae                	add	a5,a5,a1
    80000248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024a:	0585                	addi	a1,a1,1
    8000024c:	0705                	addi	a4,a4,1
    8000024e:	fff5c683          	lbu	a3,-1(a1)
    80000252:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000256:	fef59ae3          	bne	a1,a5,8000024a <memmove+0x28>

  return dst;
}
    8000025a:	6422                	ld	s0,8(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fef71ae3          	bne	a4,a5,80000270 <memmove+0x4e>
    80000280:	bfe9                	j	8000025a <memmove+0x38>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f98080e7          	jalr	-104(ra) # 80000222 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	00c05d63          	blez	a2,8000030e <strncpy+0x38>
    800002f8:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	aee080e7          	jalr	-1298(ra) # 80000e66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad2080e7          	jalr	-1326(ra) # 80000e66 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	94c080e7          	jalr	-1716(ra) # 80005cf2 <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	784080e7          	jalr	1924(ra) # 80001b3a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	dc2080e7          	jalr	-574(ra) # 80005180 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fde080e7          	jalr	-34(ra) # 800013a4 <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	7ec080e7          	jalr	2028(ra) # 80005bba <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	b02080e7          	jalr	-1278(ra) # 80005ed8 <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	90c080e7          	jalr	-1780(ra) # 80005cf2 <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	8fc080e7          	jalr	-1796(ra) # 80005cf2 <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	8ec080e7          	jalr	-1812(ra) # 80005cf2 <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	990080e7          	jalr	-1648(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6e4080e7          	jalr	1764(ra) # 80001b12 <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	704080e7          	jalr	1796(ra) # 80001b3a <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d2c080e7          	jalr	-724(ra) # 8000516a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	d3a080e7          	jalr	-710(ra) # 80005180 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	f1e080e7          	jalr	-226(ra) # 8000236c <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	5ae080e7          	jalr	1454(ra) # 80002a04 <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	558080e7          	jalr	1368(ra) # 800039b6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	e3c080e7          	jalr	-452(ra) # 800052a2 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	cfc080e7          	jalr	-772(ra) # 8000116a <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000049c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	7d0080e7          	jalr	2000(ra) # 80005ca8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cce080e7          	jalr	-818(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c205                	beqz	a2,800005c8 <mappages+0x36>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	a015                	j	800005ea <mappages+0x58>
    panic("mappages: size");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9050513          	addi	a0,a0,-1392 # 80008058 <etext+0x58>
    800005d0:	00005097          	auipc	ra,0x5
    800005d4:	6d8080e7          	jalr	1752(ra) # 80005ca8 <panic>
      panic("mappages: remap");
    800005d8:	00008517          	auipc	a0,0x8
    800005dc:	a9050513          	addi	a0,a0,-1392 # 80008068 <etext+0x68>
    800005e0:	00005097          	auipc	ra,0x5
    800005e4:	6c8080e7          	jalr	1736(ra) # 80005ca8 <panic>
    a += PGSIZE;
    800005e8:	995e                	add	s2,s2,s7
  for(;;){
    800005ea:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	4605                	li	a2,1
    800005f0:	85ca                	mv	a1,s2
    800005f2:	8556                	mv	a0,s5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	eb6080e7          	jalr	-330(ra) # 800004aa <walk>
    800005fc:	cd19                	beqz	a0,8000061a <mappages+0x88>
    if(*pte & PTE_V)
    800005fe:	611c                	ld	a5,0(a0)
    80000600:	8b85                	andi	a5,a5,1
    80000602:	fbf9                	bnez	a5,800005d8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000604:	80b1                	srli	s1,s1,0xc
    80000606:	04aa                	slli	s1,s1,0xa
    80000608:	0164e4b3          	or	s1,s1,s6
    8000060c:	0014e493          	ori	s1,s1,1
    80000610:	e104                	sd	s1,0(a0)
    if(a == last)
    80000612:	fd391be3          	bne	s2,s3,800005e8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	a011                	j	8000061c <mappages+0x8a>
      return -1;
    8000061a:	557d                	li	a0,-1
}
    8000061c:	60a6                	ld	ra,72(sp)
    8000061e:	6406                	ld	s0,64(sp)
    80000620:	74e2                	ld	s1,56(sp)
    80000622:	7942                	ld	s2,48(sp)
    80000624:	79a2                	ld	s3,40(sp)
    80000626:	7a02                	ld	s4,32(sp)
    80000628:	6ae2                	ld	s5,24(sp)
    8000062a:	6b42                	ld	s6,16(sp)
    8000062c:	6ba2                	ld	s7,8(sp)
    8000062e:	6161                	addi	sp,sp,80
    80000630:	8082                	ret

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	64e080e7          	jalr	1614(ra) # 80005ca8 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b46080e7          	jalr	-1210(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	5fe080e7          	jalr	1534(ra) # 80000d20 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e863          	bltu	a1,s3,800007f4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	502080e7          	jalr	1282(ra) # 80005ca8 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	4f2080e7          	jalr	1266(ra) # 80005ca8 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	4e2080e7          	jalr	1250(ra) # 80005ca8 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	4d2080e7          	jalr	1234(ra) # 80005ca8 <panic>
      uint64 pa = PTE2PA(*pte);
    800007de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e0:	0532                	slli	a0,a0,0xc
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	83a080e7          	jalr	-1990(ra) # 8000001c <kfree>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f9397ce3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	cb0080e7          	jalr	-848(ra) # 800004aa <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d54d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000806:	6108                	ld	a0,0(a0)
    80000808:	00157793          	andi	a5,a0,1
    8000080c:	dbcd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff57793          	andi	a5,a0,1023
    80000812:	fb778ee3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x92>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	98c080e7          	jalr	-1652(ra) # 800001c2 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	94e080e7          	jalr	-1714(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	3f4080e7          	jalr	1012(ra) # 80005ca8 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	882080e7          	jalr	-1918(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	2b2080e7          	jalr	690(ra) # 80005ca8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	77e080e7          	jalr	1918(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	1d6080e7          	jalr	470(ra) # 80005ca8 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	1c6080e7          	jalr	454(ra) # 80005ca8 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	15c080e7          	jalr	348(ra) # 80005ca8 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69a080e7          	jalr	1690(ra) # 80000222 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	c6bd                	beqz	a3,80000c4e <copyin+0x6e>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a015                	j	80000c2a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	9562                	add	a0,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412505b3          	sub	a1,a0,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60e080e7          	jalr	1550(ra) # 80000222 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	91e080e7          	jalr	-1762(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c42:	fc99f3e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	b7c1                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x74>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c6c5                	beqz	a3,80000d14 <copyinstr+0xa8>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a035                	j	80000cbc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	0017b793          	seqz	a5,a5
    80000c9c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cba:	c8a9                	beqz	s1,80000d0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	88c080e7          	jalr	-1908(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000ccc:	c131                	beqz	a0,80000d10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cce:	41790833          	sub	a6,s2,s7
    80000cd2:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd4:	0104f363          	bgeu	s1,a6,80000cda <copyinstr+0x6e>
    80000cd8:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cda:	955e                	add	a0,a0,s7
    80000cdc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce0:	fc080be3          	beqz	a6,80000cb6 <copyinstr+0x4a>
    80000ce4:	985a                	add	a6,a6,s6
    80000ce6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce8:	41650633          	sub	a2,a0,s6
    80000cec:	14fd                	addi	s1,s1,-1
    80000cee:	9b26                	add	s6,s6,s1
    80000cf0:	00f60733          	add	a4,a2,a5
    80000cf4:	00074703          	lbu	a4,0(a4)
    80000cf8:	df49                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d02:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d04:	ff0796e3          	bne	a5,a6,80000cf0 <copyinstr+0x84>
      dst++;
    80000d08:	8b42                	mv	s6,a6
    80000d0a:	b775                	j	80000cb6 <copyinstr+0x4a>
    80000d0c:	4781                	li	a5,0
    80000d0e:	b769                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d10:	557d                	li	a0,-1
    80000d12:	b779                	j	80000ca0 <copyinstr+0x34>
  int got_null = 0;
    80000d14:	4781                	li	a5,0
  if(got_null){
    80000d16:	0017b793          	seqz	a5,a5
    80000d1a:	40f00533          	neg	a0,a5
}
    80000d1e:	8082                	ret

0000000080000d20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d20:	7139                	addi	sp,sp,-64
    80000d22:	fc06                	sd	ra,56(sp)
    80000d24:	f822                	sd	s0,48(sp)
    80000d26:	f426                	sd	s1,40(sp)
    80000d28:	f04a                	sd	s2,32(sp)
    80000d2a:	ec4e                	sd	s3,24(sp)
    80000d2c:	e852                	sd	s4,16(sp)
    80000d2e:	e456                	sd	s5,8(sp)
    80000d30:	e05a                	sd	s6,0(sp)
    80000d32:	0080                	addi	s0,sp,64
    80000d34:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	74a48493          	addi	s1,s1,1866 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3e:	8b26                	mv	s6,s1
    80000d40:	00007a97          	auipc	s5,0x7
    80000d44:	2c0a8a93          	addi	s5,s5,704 # 80008000 <etext>
    80000d48:	04000937          	lui	s2,0x4000
    80000d4c:	197d                	addi	s2,s2,-1
    80000d4e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000ea17          	auipc	s4,0xe
    80000d54:	130a0a13          	addi	s4,s4,304 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c0080e7          	jalr	960(ra) # 80000118 <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	858d                	srai	a1,a1,0x3
    80000d6a:	000ab783          	ld	a5,0(s5)
    80000d6e:	02f585b3          	mul	a1,a1,a5
    80000d72:	2585                	addiw	a1,a1,1
    80000d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d78:	4719                	li	a4,6
    80000d7a:	6685                	lui	a3,0x1
    80000d7c:	40b905b3          	sub	a1,s2,a1
    80000d80:	854e                	mv	a0,s3
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	8b0080e7          	jalr	-1872(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	16848493          	addi	s1,s1,360
    80000d8e:	fd4495e3          	bne	s1,s4,80000d58 <proc_mapstacks+0x38>
  }
}
    80000d92:	70e2                	ld	ra,56(sp)
    80000d94:	7442                	ld	s0,48(sp)
    80000d96:	74a2                	ld	s1,40(sp)
    80000d98:	7902                	ld	s2,32(sp)
    80000d9a:	69e2                	ld	s3,24(sp)
    80000d9c:	6a42                	ld	s4,16(sp)
    80000d9e:	6aa2                	ld	s5,8(sp)
    80000da0:	6b02                	ld	s6,0(sp)
    80000da2:	6121                	addi	sp,sp,64
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	efa080e7          	jalr	-262(ra) # 80005ca8 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	388080e7          	jalr	904(ra) # 80006162 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	370080e7          	jalr	880(ra) # 80006162 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	00007a17          	auipc	s4,0x7
    80000e10:	1f4a0a13          	addi	s4,s4,500 # 80008000 <etext>
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1
    80000e1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	0000e997          	auipc	s3,0xe
    80000e20:	06498993          	addi	s3,s3,100 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	33a080e7          	jalr	826(ra) # 80006162 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	878d                	srai	a5,a5,0x3
    80000e36:	000a3703          	ld	a4,0(s4)
    80000e3a:	02e787b3          	mul	a5,a5,a4
    80000e3e:	2785                	addiw	a5,a5,1
    80000e40:	00d7979b          	slliw	a5,a5,0xd
    80000e44:	40f907b3          	sub	a5,s2,a5
    80000e48:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4a:	16848493          	addi	s1,s1,360
    80000e4e:	fd349be3          	bne	s1,s3,80000e24 <procinit+0x6e>
  }
}
    80000e52:	70e2                	ld	ra,56(sp)
    80000e54:	7442                	ld	s0,48(sp)
    80000e56:	74a2                	ld	s1,40(sp)
    80000e58:	7902                	ld	s2,32(sp)
    80000e5a:	69e2                	ld	s3,24(sp)
    80000e5c:	6a42                	ld	s4,16(sp)
    80000e5e:	6aa2                	ld	s5,8(sp)
    80000e60:	6b02                	ld	s6,0(sp)
    80000e62:	6121                	addi	sp,sp,64
    80000e64:	8082                	ret

0000000080000e66 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6e:	2501                	sext.w	a0,a0
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
    80000e7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e82:	00008517          	auipc	a0,0x8
    80000e86:	1fe50513          	addi	a0,a0,510 # 80009080 <cpus>
    80000e8a:	953e                	add	a0,a0,a5
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
  push_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	30a080e7          	jalr	778(ra) # 800061a6 <push_off>
    80000ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea6:	2781                	sext.w	a5,a5
    80000ea8:	079e                	slli	a5,a5,0x7
    80000eaa:	00008717          	auipc	a4,0x8
    80000eae:	1a670713          	addi	a4,a4,422 # 80009050 <pid_lock>
    80000eb2:	97ba                	add	a5,a5,a4
    80000eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	390080e7          	jalr	912(ra) # 80006246 <pop_off>
  return p;
}
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eca:	1141                	addi	sp,sp,-16
    80000ecc:	e406                	sd	ra,8(sp)
    80000ece:	e022                	sd	s0,0(sp)
    80000ed0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	fc0080e7          	jalr	-64(ra) # 80000e92 <myproc>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	3cc080e7          	jalr	972(ra) # 800062a6 <release>

  if (first) {
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	abe7a783          	lw	a5,-1346(a5) # 800089a0 <first.1673>
    80000eea:	eb89                	bnez	a5,80000efc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	c66080e7          	jalr	-922(ra) # 80001b52 <usertrapret>
}
    80000ef4:	60a2                	ld	ra,8(sp)
    80000ef6:	6402                	ld	s0,0(sp)
    80000ef8:	0141                	addi	sp,sp,16
    80000efa:	8082                	ret
    first = 0;
    80000efc:	00008797          	auipc	a5,0x8
    80000f00:	aa07a223          	sw	zero,-1372(a5) # 800089a0 <first.1673>
    fsinit(ROOTDEV);
    80000f04:	4505                	li	a0,1
    80000f06:	00002097          	auipc	ra,0x2
    80000f0a:	a7e080e7          	jalr	-1410(ra) # 80002984 <fsinit>
    80000f0e:	bff9                	j	80000eec <forkret+0x22>

0000000080000f10 <allocpid>:
allocpid() {
    80000f10:	1101                	addi	sp,sp,-32
    80000f12:	ec06                	sd	ra,24(sp)
    80000f14:	e822                	sd	s0,16(sp)
    80000f16:	e426                	sd	s1,8(sp)
    80000f18:	e04a                	sd	s2,0(sp)
    80000f1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1c:	00008917          	auipc	s2,0x8
    80000f20:	13490913          	addi	s2,s2,308 # 80009050 <pid_lock>
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	2cc080e7          	jalr	716(ra) # 800061f2 <acquire>
  pid = nextpid;
    80000f2e:	00008797          	auipc	a5,0x8
    80000f32:	a7678793          	addi	a5,a5,-1418 # 800089a4 <nextpid>
    80000f36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f38:	0014871b          	addiw	a4,s1,1
    80000f3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	366080e7          	jalr	870(ra) # 800062a6 <release>
}
    80000f48:	8526                	mv	a0,s1
    80000f4a:	60e2                	ld	ra,24(sp)
    80000f4c:	6442                	ld	s0,16(sp)
    80000f4e:	64a2                	ld	s1,8(sp)
    80000f50:	6902                	ld	s2,0(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <proc_pagetable>:
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
    80000f62:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	8b8080e7          	jalr	-1864(ra) # 8000081c <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6e:	c121                	beqz	a0,80000fae <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	60e080e7          	jalr	1550(ra) # 80000592 <mappages>
    80000f8c:	02054863          	bltz	a0,80000fbc <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f90:	4719                	li	a4,6
    80000f92:	05893683          	ld	a3,88(s2)
    80000f96:	6605                	lui	a2,0x1
    80000f98:	020005b7          	lui	a1,0x2000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b6                	slli	a1,a1,0xd
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5f0080e7          	jalr	1520(ra) # 80000592 <mappages>
    80000faa:	02054163          	bltz	a0,80000fcc <proc_pagetable+0x76>
}
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a58080e7          	jalr	-1448(ra) # 80000a18 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	b7d5                	j	80000fae <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	77e080e7          	jalr	1918(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	a32080e7          	jalr	-1486(ra) # 80000a18 <uvmfree>
    return 0;
    80000fee:	4481                	li	s1,0
    80000ff0:	bf7d                	j	80000fae <proc_pagetable+0x58>

0000000080000ff2 <proc_freepagetable>:
{
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
    80001000:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	040005b7          	lui	a1,0x4000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b2                	slli	a1,a1,0xc
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	74a080e7          	jalr	1866(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	020005b7          	lui	a1,0x2000
    8000101e:	15fd                	addi	a1,a1,-1
    80001020:	05b6                	slli	a1,a1,0xd
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	734080e7          	jalr	1844(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	9e8080e7          	jalr	-1560(ra) # 80000a18 <uvmfree>
}
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <freeproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001050:	6d28                	ld	a0,88(a0)
    80001052:	c509                	beqz	a0,8000105c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	fc8080e7          	jalr	-56(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000105c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001060:	68a8                	ld	a0,80(s1)
    80001062:	c511                	beqz	a0,8000106e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001064:	64ac                	ld	a1,72(s1)
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	f8c080e7          	jalr	-116(ra) # 80000ff2 <proc_freepagetable>
  p->pagetable = 0;
    8000106e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001072:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001076:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001082:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001086:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108e:	0004ac23          	sw	zero,24(s1)
}
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret

000000008000109c <allocproc>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	e04a                	sd	s2,0(sp)
    800010a6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	00008497          	auipc	s1,0x8
    800010ac:	3d848493          	addi	s1,s1,984 # 80009480 <proc>
    800010b0:	0000e917          	auipc	s2,0xe
    800010b4:	dd090913          	addi	s2,s2,-560 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	138080e7          	jalr	312(ra) # 800061f2 <acquire>
    if(p->state == UNUSED) {
    800010c2:	4c9c                	lw	a5,24(s1)
    800010c4:	cf81                	beqz	a5,800010dc <allocproc+0x40>
      release(&p->lock);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00005097          	auipc	ra,0x5
    800010cc:	1de080e7          	jalr	478(ra) # 800062a6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d0:	16848493          	addi	s1,s1,360
    800010d4:	ff2492e3          	bne	s1,s2,800010b8 <allocproc+0x1c>
  return 0;
    800010d8:	4481                	li	s1,0
    800010da:	a889                	j	8000112c <allocproc+0x90>
  p->pid = allocpid();
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e34080e7          	jalr	-460(ra) # 80000f10 <allocpid>
    800010e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e6:	4785                	li	a5,1
    800010e8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	02e080e7          	jalr	46(ra) # 80000118 <kalloc>
    800010f2:	892a                	mv	s2,a0
    800010f4:	eca8                	sd	a0,88(s1)
    800010f6:	c131                	beqz	a0,8000113a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	e5c080e7          	jalr	-420(ra) # 80000f56 <proc_pagetable>
    80001102:	892a                	mv	s2,a0
    80001104:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001106:	c531                	beqz	a0,80001152 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001108:	07000613          	li	a2,112
    8000110c:	4581                	li	a1,0
    8000110e:	06048513          	addi	a0,s1,96
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	0b0080e7          	jalr	176(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    8000111a:	00000797          	auipc	a5,0x0
    8000111e:	db078793          	addi	a5,a5,-592 # 80000eca <forkret>
    80001122:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001124:	60bc                	ld	a5,64(s1)
    80001126:	6705                	lui	a4,0x1
    80001128:	97ba                	add	a5,a5,a4
    8000112a:	f4bc                	sd	a5,104(s1)
}
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6902                	ld	s2,0(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
    freeproc(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f08080e7          	jalr	-248(ra) # 80001044 <freeproc>
    release(&p->lock);
    80001144:	8526                	mv	a0,s1
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	160080e7          	jalr	352(ra) # 800062a6 <release>
    return 0;
    8000114e:	84ca                	mv	s1,s2
    80001150:	bff1                	j	8000112c <allocproc+0x90>
    freeproc(p);
    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	ef0080e7          	jalr	-272(ra) # 80001044 <freeproc>
    release(&p->lock);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	148080e7          	jalr	328(ra) # 800062a6 <release>
    return 0;
    80001166:	84ca                	mv	s1,s2
    80001168:	b7d1                	j	8000112c <allocproc+0x90>

000000008000116a <userinit>:
{
    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	1000                	addi	s0,sp,32
  p = allocproc();
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f28080e7          	jalr	-216(ra) # 8000109c <allocproc>
    8000117c:	84aa                	mv	s1,a0
  initproc = p;
    8000117e:	00008797          	auipc	a5,0x8
    80001182:	e8a7b923          	sd	a0,-366(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001186:	03400613          	li	a2,52
    8000118a:	00008597          	auipc	a1,0x8
    8000118e:	82658593          	addi	a1,a1,-2010 # 800089b0 <initcode>
    80001192:	6928                	ld	a0,80(a0)
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	6b6080e7          	jalr	1718(ra) # 8000084a <uvminit>
  p->sz = PGSIZE;
    8000119c:	6785                	lui	a5,0x1
    8000119e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a0:	6cb8                	ld	a4,88(s1)
    800011a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a6:	6cb8                	ld	a4,88(s1)
    800011a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011aa:	4641                	li	a2,16
    800011ac:	00007597          	auipc	a1,0x7
    800011b0:	fd458593          	addi	a1,a1,-44 # 80008180 <etext+0x180>
    800011b4:	15848513          	addi	a0,s1,344
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	15c080e7          	jalr	348(ra) # 80000314 <safestrcpy>
  p->cwd = namei("/");
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	fd050513          	addi	a0,a0,-48 # 80008190 <etext+0x190>
    800011c8:	00002097          	auipc	ra,0x2
    800011cc:	1ea080e7          	jalr	490(ra) # 800033b2 <namei>
    800011d0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	0cc080e7          	jalr	204(ra) # 800062a6 <release>
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <growproc>:
{
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
    800011f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	c98080e7          	jalr	-872(ra) # 80000e92 <myproc>
    80001202:	892a                	mv	s2,a0
  sz = p->sz;
    80001204:	652c                	ld	a1,72(a0)
    80001206:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000120a:	00904f63          	bgtz	s1,80001228 <growproc+0x3c>
  } else if(n < 0){
    8000120e:	0204cc63          	bltz	s1,80001246 <growproc+0x5a>
  p->sz = sz;
    80001212:	1602                	slli	a2,a2,0x20
    80001214:	9201                	srli	a2,a2,0x20
    80001216:	04c93423          	sd	a2,72(s2)
  return 0;
    8000121a:	4501                	li	a0,0
}
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	addi	sp,sp,32
    80001226:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001228:	9e25                	addw	a2,a2,s1
    8000122a:	1602                	slli	a2,a2,0x20
    8000122c:	9201                	srli	a2,a2,0x20
    8000122e:	1582                	slli	a1,a1,0x20
    80001230:	9181                	srli	a1,a1,0x20
    80001232:	6928                	ld	a0,80(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	6d0080e7          	jalr	1744(ra) # 80000904 <uvmalloc>
    8000123c:	0005061b          	sext.w	a2,a0
    80001240:	fa69                	bnez	a2,80001212 <growproc+0x26>
      return -1;
    80001242:	557d                	li	a0,-1
    80001244:	bfe1                	j	8000121c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001246:	9e25                	addw	a2,a2,s1
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	66a080e7          	jalr	1642(ra) # 800008bc <uvmdealloc>
    8000125a:	0005061b          	sext.w	a2,a0
    8000125e:	bf55                	j	80001212 <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7179                	addi	sp,sp,-48
    80001262:	f406                	sd	ra,40(sp)
    80001264:	f022                	sd	s0,32(sp)
    80001266:	ec26                	sd	s1,24(sp)
    80001268:	e84a                	sd	s2,16(sp)
    8000126a:	e44e                	sd	s3,8(sp)
    8000126c:	e052                	sd	s4,0(sp)
    8000126e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c22080e7          	jalr	-990(ra) # 80000e92 <myproc>
    80001278:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e22080e7          	jalr	-478(ra) # 8000109c <allocproc>
    80001282:	10050f63          	beqz	a0,800013a0 <fork+0x140>
    80001286:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001288:	04893603          	ld	a2,72(s2)
    8000128c:	692c                	ld	a1,80(a0)
    8000128e:	05093503          	ld	a0,80(s2)
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	7be080e7          	jalr	1982(ra) # 80000a50 <uvmcopy>
    8000129a:	04054a63          	bltz	a0,800012ee <fork+0x8e>
  np->sz = p->sz;
    8000129e:	04893783          	ld	a5,72(s2)
    800012a2:	04f9b423          	sd	a5,72(s3)
  np->mask = p->mask;
    800012a6:	03492783          	lw	a5,52(s2)
    800012aa:	02f9aa23          	sw	a5,52(s3)
  *(np->trapframe) = *(p->trapframe);
    800012ae:	05893683          	ld	a3,88(s2)
    800012b2:	87b6                	mv	a5,a3
    800012b4:	0589b703          	ld	a4,88(s3)
    800012b8:	12068693          	addi	a3,a3,288
    800012bc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c0:	6788                	ld	a0,8(a5)
    800012c2:	6b8c                	ld	a1,16(a5)
    800012c4:	6f90                	ld	a2,24(a5)
    800012c6:	01073023          	sd	a6,0(a4)
    800012ca:	e708                	sd	a0,8(a4)
    800012cc:	eb0c                	sd	a1,16(a4)
    800012ce:	ef10                	sd	a2,24(a4)
    800012d0:	02078793          	addi	a5,a5,32
    800012d4:	02070713          	addi	a4,a4,32
    800012d8:	fed792e3          	bne	a5,a3,800012bc <fork+0x5c>
  np->trapframe->a0 = 0;
    800012dc:	0589b783          	ld	a5,88(s3)
    800012e0:	0607b823          	sd	zero,112(a5)
    800012e4:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012e8:	15000a13          	li	s4,336
    800012ec:	a03d                	j	8000131a <fork+0xba>
    freeproc(np);
    800012ee:	854e                	mv	a0,s3
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d54080e7          	jalr	-684(ra) # 80001044 <freeproc>
    release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	fac080e7          	jalr	-84(ra) # 800062a6 <release>
    return -1;
    80001302:	5a7d                	li	s4,-1
    80001304:	a069                	j	8000138e <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	742080e7          	jalr	1858(ra) # 80003a48 <filedup>
    8000130e:	009987b3          	add	a5,s3,s1
    80001312:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001314:	04a1                	addi	s1,s1,8
    80001316:	01448763          	beq	s1,s4,80001324 <fork+0xc4>
    if(p->ofile[i])
    8000131a:	009907b3          	add	a5,s2,s1
    8000131e:	6388                	ld	a0,0(a5)
    80001320:	f17d                	bnez	a0,80001306 <fork+0xa6>
    80001322:	bfcd                	j	80001314 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001324:	15093503          	ld	a0,336(s2)
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	896080e7          	jalr	-1898(ra) # 80002bbe <idup>
    80001330:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001334:	4641                	li	a2,16
    80001336:	15890593          	addi	a1,s2,344
    8000133a:	15898513          	addi	a0,s3,344
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	fd6080e7          	jalr	-42(ra) # 80000314 <safestrcpy>
  pid = np->pid;
    80001346:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000134a:	854e                	mv	a0,s3
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	f5a080e7          	jalr	-166(ra) # 800062a6 <release>
  acquire(&wait_lock);
    80001354:	00008497          	auipc	s1,0x8
    80001358:	d1448493          	addi	s1,s1,-748 # 80009068 <wait_lock>
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	e94080e7          	jalr	-364(ra) # 800061f2 <acquire>
  np->parent = p;
    80001366:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	f3a080e7          	jalr	-198(ra) # 800062a6 <release>
  acquire(&np->lock);
    80001374:	854e                	mv	a0,s3
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	e7c080e7          	jalr	-388(ra) # 800061f2 <acquire>
  np->state = RUNNABLE;
    8000137e:	478d                	li	a5,3
    80001380:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001384:	854e                	mv	a0,s3
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	f20080e7          	jalr	-224(ra) # 800062a6 <release>
}
    8000138e:	8552                	mv	a0,s4
    80001390:	70a2                	ld	ra,40(sp)
    80001392:	7402                	ld	s0,32(sp)
    80001394:	64e2                	ld	s1,24(sp)
    80001396:	6942                	ld	s2,16(sp)
    80001398:	69a2                	ld	s3,8(sp)
    8000139a:	6a02                	ld	s4,0(sp)
    8000139c:	6145                	addi	sp,sp,48
    8000139e:	8082                	ret
    return -1;
    800013a0:	5a7d                	li	s4,-1
    800013a2:	b7f5                	j	8000138e <fork+0x12e>

00000000800013a4 <scheduler>:
{
    800013a4:	7139                	addi	sp,sp,-64
    800013a6:	fc06                	sd	ra,56(sp)
    800013a8:	f822                	sd	s0,48(sp)
    800013aa:	f426                	sd	s1,40(sp)
    800013ac:	f04a                	sd	s2,32(sp)
    800013ae:	ec4e                	sd	s3,24(sp)
    800013b0:	e852                	sd	s4,16(sp)
    800013b2:	e456                	sd	s5,8(sp)
    800013b4:	e05a                	sd	s6,0(sp)
    800013b6:	0080                	addi	s0,sp,64
    800013b8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ba:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013bc:	00779a93          	slli	s5,a5,0x7
    800013c0:	00008717          	auipc	a4,0x8
    800013c4:	c9070713          	addi	a4,a4,-880 # 80009050 <pid_lock>
    800013c8:	9756                	add	a4,a4,s5
    800013ca:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ce:	00008717          	auipc	a4,0x8
    800013d2:	cba70713          	addi	a4,a4,-838 # 80009088 <cpus+0x8>
    800013d6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d8:	498d                	li	s3,3
        p->state = RUNNING;
    800013da:	4b11                	li	s6,4
        c->proc = p;
    800013dc:	079e                	slli	a5,a5,0x7
    800013de:	00008a17          	auipc	s4,0x8
    800013e2:	c72a0a13          	addi	s4,s4,-910 # 80009050 <pid_lock>
    800013e6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	0000e917          	auipc	s2,0xe
    800013ec:	a9890913          	addi	s2,s2,-1384 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f8:	10079073          	csrw	sstatus,a5
    800013fc:	00008497          	auipc	s1,0x8
    80001400:	08448493          	addi	s1,s1,132 # 80009480 <proc>
    80001404:	a03d                	j	80001432 <scheduler+0x8e>
        p->state = RUNNING;
    80001406:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000140a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000140e:	06048593          	addi	a1,s1,96
    80001412:	8556                	mv	a0,s5
    80001414:	00000097          	auipc	ra,0x0
    80001418:	694080e7          	jalr	1684(ra) # 80001aa8 <swtch>
        c->proc = 0;
    8000141c:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	e84080e7          	jalr	-380(ra) # 800062a6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	16848493          	addi	s1,s1,360
    8000142e:	fd2481e3          	beq	s1,s2,800013f0 <scheduler+0x4c>
      acquire(&p->lock);
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	dbe080e7          	jalr	-578(ra) # 800061f2 <acquire>
      if(p->state == RUNNABLE) {
    8000143c:	4c9c                	lw	a5,24(s1)
    8000143e:	ff3791e3          	bne	a5,s3,80001420 <scheduler+0x7c>
    80001442:	b7d1                	j	80001406 <scheduler+0x62>

0000000080001444 <sched>:
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001452:	00000097          	auipc	ra,0x0
    80001456:	a40080e7          	jalr	-1472(ra) # 80000e92 <myproc>
    8000145a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	d1c080e7          	jalr	-740(ra) # 80006178 <holding>
    80001464:	c93d                	beqz	a0,800014da <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	00008717          	auipc	a4,0x8
    80001470:	be470713          	addi	a4,a4,-1052 # 80009050 <pid_lock>
    80001474:	97ba                	add	a5,a5,a4
    80001476:	0a87a703          	lw	a4,168(a5)
    8000147a:	4785                	li	a5,1
    8000147c:	06f71763          	bne	a4,a5,800014ea <sched+0xa6>
  if(p->state == RUNNING)
    80001480:	4c98                	lw	a4,24(s1)
    80001482:	4791                	li	a5,4
    80001484:	06f70b63          	beq	a4,a5,800014fa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001488:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148e:	efb5                	bnez	a5,8000150a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001490:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001492:	00008917          	auipc	s2,0x8
    80001496:	bbe90913          	addi	s2,s2,-1090 # 80009050 <pid_lock>
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	97ca                	add	a5,a5,s2
    800014a0:	0ac7a983          	lw	s3,172(a5)
    800014a4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00008597          	auipc	a1,0x8
    800014ae:	bde58593          	addi	a1,a1,-1058 # 80009088 <cpus+0x8>
    800014b2:	95be                	add	a1,a1,a5
    800014b4:	06048513          	addi	a0,s1,96
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	5f0080e7          	jalr	1520(ra) # 80001aa8 <swtch>
    800014c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c2:	2781                	sext.w	a5,a5
    800014c4:	079e                	slli	a5,a5,0x7
    800014c6:	97ca                	add	a5,a5,s2
    800014c8:	0b37a623          	sw	s3,172(a5)
}
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret
    panic("sched p->lock");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cbe50513          	addi	a0,a0,-834 # 80008198 <etext+0x198>
    800014e2:	00004097          	auipc	ra,0x4
    800014e6:	7c6080e7          	jalr	1990(ra) # 80005ca8 <panic>
    panic("sched locks");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cbe50513          	addi	a0,a0,-834 # 800081a8 <etext+0x1a8>
    800014f2:	00004097          	auipc	ra,0x4
    800014f6:	7b6080e7          	jalr	1974(ra) # 80005ca8 <panic>
    panic("sched running");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cbe50513          	addi	a0,a0,-834 # 800081b8 <etext+0x1b8>
    80001502:	00004097          	auipc	ra,0x4
    80001506:	7a6080e7          	jalr	1958(ra) # 80005ca8 <panic>
    panic("sched interruptible");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cbe50513          	addi	a0,a0,-834 # 800081c8 <etext+0x1c8>
    80001512:	00004097          	auipc	ra,0x4
    80001516:	796080e7          	jalr	1942(ra) # 80005ca8 <panic>

000000008000151a <yield>:
{
    8000151a:	1101                	addi	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	96e080e7          	jalr	-1682(ra) # 80000e92 <myproc>
    8000152c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	cc4080e7          	jalr	-828(ra) # 800061f2 <acquire>
  p->state = RUNNABLE;
    80001536:	478d                	li	a5,3
    80001538:	cc9c                	sw	a5,24(s1)
  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f0a080e7          	jalr	-246(ra) # 80001444 <sched>
  release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	d62080e7          	jalr	-670(ra) # 800062a6 <release>
}
    8000154c:	60e2                	ld	ra,24(sp)
    8000154e:	6442                	ld	s0,16(sp)
    80001550:	64a2                	ld	s1,8(sp)
    80001552:	6105                	addi	sp,sp,32
    80001554:	8082                	ret

0000000080001556 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	addi	s0,sp,48
    80001564:	89aa                	mv	s3,a0
    80001566:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	92a080e7          	jalr	-1750(ra) # 80000e92 <myproc>
    80001570:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	c80080e7          	jalr	-896(ra) # 800061f2 <acquire>
  release(lk);
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	d2a080e7          	jalr	-726(ra) # 800062a6 <release>

  // Go to sleep.
  p->chan = chan;
    80001584:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001588:	4789                	li	a5,2
    8000158a:	cc9c                	sw	a5,24(s1)

  sched();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	eb8080e7          	jalr	-328(ra) # 80001444 <sched>

  // Tidy up.
  p->chan = 0;
    80001594:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	d0c080e7          	jalr	-756(ra) # 800062a6 <release>
  acquire(lk);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c4e080e7          	jalr	-946(ra) # 800061f2 <acquire>
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret

00000000800015ba <wait>:
{
    800015ba:	715d                	addi	sp,sp,-80
    800015bc:	e486                	sd	ra,72(sp)
    800015be:	e0a2                	sd	s0,64(sp)
    800015c0:	fc26                	sd	s1,56(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f44e                	sd	s3,40(sp)
    800015c6:	f052                	sd	s4,32(sp)
    800015c8:	ec56                	sd	s5,24(sp)
    800015ca:	e85a                	sd	s6,16(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	e062                	sd	s8,0(sp)
    800015d0:	0880                	addi	s0,sp,80
    800015d2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	8be080e7          	jalr	-1858(ra) # 80000e92 <myproc>
    800015dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015de:	00008517          	auipc	a0,0x8
    800015e2:	a8a50513          	addi	a0,a0,-1398 # 80009068 <wait_lock>
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	c0c080e7          	jalr	-1012(ra) # 800061f2 <acquire>
    havekids = 0;
    800015ee:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f0:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015f2:	0000e997          	auipc	s3,0xe
    800015f6:	88e98993          	addi	s3,s3,-1906 # 8000ee80 <tickslock>
        havekids = 1;
    800015fa:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fc:	00008c17          	auipc	s8,0x8
    80001600:	a6cc0c13          	addi	s8,s8,-1428 # 80009068 <wait_lock>
    havekids = 0;
    80001604:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001606:	00008497          	auipc	s1,0x8
    8000160a:	e7a48493          	addi	s1,s1,-390 # 80009480 <proc>
    8000160e:	a0bd                	j	8000167c <wait+0xc2>
          pid = np->pid;
    80001610:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001614:	000b0e63          	beqz	s6,80001630 <wait+0x76>
    80001618:	4691                	li	a3,4
    8000161a:	02c48613          	addi	a2,s1,44
    8000161e:	85da                	mv	a1,s6
    80001620:	05093503          	ld	a0,80(s2)
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	530080e7          	jalr	1328(ra) # 80000b54 <copyout>
    8000162c:	02054563          	bltz	a0,80001656 <wait+0x9c>
          freeproc(np);
    80001630:	8526                	mv	a0,s1
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a12080e7          	jalr	-1518(ra) # 80001044 <freeproc>
          release(&np->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	c6a080e7          	jalr	-918(ra) # 800062a6 <release>
          release(&wait_lock);
    80001644:	00008517          	auipc	a0,0x8
    80001648:	a2450513          	addi	a0,a0,-1500 # 80009068 <wait_lock>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	c5a080e7          	jalr	-934(ra) # 800062a6 <release>
          return pid;
    80001654:	a09d                	j	800016ba <wait+0x100>
            release(&np->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	c4e080e7          	jalr	-946(ra) # 800062a6 <release>
            release(&wait_lock);
    80001660:	00008517          	auipc	a0,0x8
    80001664:	a0850513          	addi	a0,a0,-1528 # 80009068 <wait_lock>
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	c3e080e7          	jalr	-962(ra) # 800062a6 <release>
            return -1;
    80001670:	59fd                	li	s3,-1
    80001672:	a0a1                	j	800016ba <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001674:	16848493          	addi	s1,s1,360
    80001678:	03348463          	beq	s1,s3,800016a0 <wait+0xe6>
      if(np->parent == p){
    8000167c:	7c9c                	ld	a5,56(s1)
    8000167e:	ff279be3          	bne	a5,s2,80001674 <wait+0xba>
        acquire(&np->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	00005097          	auipc	ra,0x5
    80001688:	b6e080e7          	jalr	-1170(ra) # 800061f2 <acquire>
        if(np->state == ZOMBIE){
    8000168c:	4c9c                	lw	a5,24(s1)
    8000168e:	f94781e3          	beq	a5,s4,80001610 <wait+0x56>
        release(&np->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	c12080e7          	jalr	-1006(ra) # 800062a6 <release>
        havekids = 1;
    8000169c:	8756                	mv	a4,s5
    8000169e:	bfd9                	j	80001674 <wait+0xba>
    if(!havekids || p->killed){
    800016a0:	c701                	beqz	a4,800016a8 <wait+0xee>
    800016a2:	02892783          	lw	a5,40(s2)
    800016a6:	c79d                	beqz	a5,800016d4 <wait+0x11a>
      release(&wait_lock);
    800016a8:	00008517          	auipc	a0,0x8
    800016ac:	9c050513          	addi	a0,a0,-1600 # 80009068 <wait_lock>
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	bf6080e7          	jalr	-1034(ra) # 800062a6 <release>
      return -1;
    800016b8:	59fd                	li	s3,-1
}
    800016ba:	854e                	mv	a0,s3
    800016bc:	60a6                	ld	ra,72(sp)
    800016be:	6406                	ld	s0,64(sp)
    800016c0:	74e2                	ld	s1,56(sp)
    800016c2:	7942                	ld	s2,48(sp)
    800016c4:	79a2                	ld	s3,40(sp)
    800016c6:	7a02                	ld	s4,32(sp)
    800016c8:	6ae2                	ld	s5,24(sp)
    800016ca:	6b42                	ld	s6,16(sp)
    800016cc:	6ba2                	ld	s7,8(sp)
    800016ce:	6c02                	ld	s8,0(sp)
    800016d0:	6161                	addi	sp,sp,80
    800016d2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d4:	85e2                	mv	a1,s8
    800016d6:	854a                	mv	a0,s2
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	e7e080e7          	jalr	-386(ra) # 80001556 <sleep>
    havekids = 0;
    800016e0:	b715                	j	80001604 <wait+0x4a>

00000000800016e2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e2:	7139                	addi	sp,sp,-64
    800016e4:	fc06                	sd	ra,56(sp)
    800016e6:	f822                	sd	s0,48(sp)
    800016e8:	f426                	sd	s1,40(sp)
    800016ea:	f04a                	sd	s2,32(sp)
    800016ec:	ec4e                	sd	s3,24(sp)
    800016ee:	e852                	sd	s4,16(sp)
    800016f0:	e456                	sd	s5,8(sp)
    800016f2:	0080                	addi	s0,sp,64
    800016f4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f6:	00008497          	auipc	s1,0x8
    800016fa:	d8a48493          	addi	s1,s1,-630 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016fe:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001700:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	0000d917          	auipc	s2,0xd
    80001706:	77e90913          	addi	s2,s2,1918 # 8000ee80 <tickslock>
    8000170a:	a821                	j	80001722 <wakeup+0x40>
        p->state = RUNNABLE;
    8000170c:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b94080e7          	jalr	-1132(ra) # 800062a6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	16848493          	addi	s1,s1,360
    8000171e:	03248463          	beq	s1,s2,80001746 <wakeup+0x64>
    if(p != myproc()){
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	770080e7          	jalr	1904(ra) # 80000e92 <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x38>
      acquire(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	ac2080e7          	jalr	-1342(ra) # 800061f2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2e>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2e>
    80001744:	b7e1                	j	8000170c <wakeup+0x2a>
    }
  }
}
    80001746:	70e2                	ld	ra,56(sp)
    80001748:	7442                	ld	s0,48(sp)
    8000174a:	74a2                	ld	s1,40(sp)
    8000174c:	7902                	ld	s2,32(sp)
    8000174e:	69e2                	ld	s3,24(sp)
    80001750:	6a42                	ld	s4,16(sp)
    80001752:	6aa2                	ld	s5,8(sp)
    80001754:	6121                	addi	sp,sp,64
    80001756:	8082                	ret

0000000080001758 <reparent>:
{
    80001758:	7179                	addi	sp,sp,-48
    8000175a:	f406                	sd	ra,40(sp)
    8000175c:	f022                	sd	s0,32(sp)
    8000175e:	ec26                	sd	s1,24(sp)
    80001760:	e84a                	sd	s2,16(sp)
    80001762:	e44e                	sd	s3,8(sp)
    80001764:	e052                	sd	s4,0(sp)
    80001766:	1800                	addi	s0,sp,48
    80001768:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176a:	00008497          	auipc	s1,0x8
    8000176e:	d1648493          	addi	s1,s1,-746 # 80009480 <proc>
      pp->parent = initproc;
    80001772:	00008a17          	auipc	s4,0x8
    80001776:	89ea0a13          	addi	s4,s4,-1890 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177a:	0000d997          	auipc	s3,0xd
    8000177e:	70698993          	addi	s3,s3,1798 # 8000ee80 <tickslock>
    80001782:	a029                	j	8000178c <reparent+0x34>
    80001784:	16848493          	addi	s1,s1,360
    80001788:	01348d63          	beq	s1,s3,800017a2 <reparent+0x4a>
    if(pp->parent == p){
    8000178c:	7c9c                	ld	a5,56(s1)
    8000178e:	ff279be3          	bne	a5,s2,80001784 <reparent+0x2c>
      pp->parent = initproc;
    80001792:	000a3503          	ld	a0,0(s4)
    80001796:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	f4a080e7          	jalr	-182(ra) # 800016e2 <wakeup>
    800017a0:	b7d5                	j	80001784 <reparent+0x2c>
}
    800017a2:	70a2                	ld	ra,40(sp)
    800017a4:	7402                	ld	s0,32(sp)
    800017a6:	64e2                	ld	s1,24(sp)
    800017a8:	6942                	ld	s2,16(sp)
    800017aa:	69a2                	ld	s3,8(sp)
    800017ac:	6a02                	ld	s4,0(sp)
    800017ae:	6145                	addi	sp,sp,48
    800017b0:	8082                	ret

00000000800017b2 <exit>:
{
    800017b2:	7179                	addi	sp,sp,-48
    800017b4:	f406                	sd	ra,40(sp)
    800017b6:	f022                	sd	s0,32(sp)
    800017b8:	ec26                	sd	s1,24(sp)
    800017ba:	e84a                	sd	s2,16(sp)
    800017bc:	e44e                	sd	s3,8(sp)
    800017be:	e052                	sd	s4,0(sp)
    800017c0:	1800                	addi	s0,sp,48
    800017c2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	6ce080e7          	jalr	1742(ra) # 80000e92 <myproc>
    800017cc:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ce:	00008797          	auipc	a5,0x8
    800017d2:	8427b783          	ld	a5,-1982(a5) # 80009010 <initproc>
    800017d6:	0d050493          	addi	s1,a0,208
    800017da:	15050913          	addi	s2,a0,336
    800017de:	02a79363          	bne	a5,a0,80001804 <exit+0x52>
    panic("init exiting");
    800017e2:	00007517          	auipc	a0,0x7
    800017e6:	9fe50513          	addi	a0,a0,-1538 # 800081e0 <etext+0x1e0>
    800017ea:	00004097          	auipc	ra,0x4
    800017ee:	4be080e7          	jalr	1214(ra) # 80005ca8 <panic>
      fileclose(f);
    800017f2:	00002097          	auipc	ra,0x2
    800017f6:	2a8080e7          	jalr	680(ra) # 80003a9a <fileclose>
      p->ofile[fd] = 0;
    800017fa:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	01248563          	beq	s1,s2,8000180a <exit+0x58>
    if(p->ofile[fd]){
    80001804:	6088                	ld	a0,0(s1)
    80001806:	f575                	bnez	a0,800017f2 <exit+0x40>
    80001808:	bfdd                	j	800017fe <exit+0x4c>
  begin_op();
    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	dc4080e7          	jalr	-572(ra) # 800035ce <begin_op>
  iput(p->cwd);
    80001812:	1509b503          	ld	a0,336(s3)
    80001816:	00001097          	auipc	ra,0x1
    8000181a:	5a0080e7          	jalr	1440(ra) # 80002db6 <iput>
  end_op();
    8000181e:	00002097          	auipc	ra,0x2
    80001822:	e30080e7          	jalr	-464(ra) # 8000364e <end_op>
  p->cwd = 0;
    80001826:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182a:	00008497          	auipc	s1,0x8
    8000182e:	83e48493          	addi	s1,s1,-1986 # 80009068 <wait_lock>
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	9be080e7          	jalr	-1602(ra) # 800061f2 <acquire>
  reparent(p);
    8000183c:	854e                	mv	a0,s3
    8000183e:	00000097          	auipc	ra,0x0
    80001842:	f1a080e7          	jalr	-230(ra) # 80001758 <reparent>
  wakeup(p->parent);
    80001846:	0389b503          	ld	a0,56(s3)
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	e98080e7          	jalr	-360(ra) # 800016e2 <wakeup>
  acquire(&p->lock);
    80001852:	854e                	mv	a0,s3
    80001854:	00005097          	auipc	ra,0x5
    80001858:	99e080e7          	jalr	-1634(ra) # 800061f2 <acquire>
  p->xstate = status;
    8000185c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001860:	4795                	li	a5,5
    80001862:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	a3e080e7          	jalr	-1474(ra) # 800062a6 <release>
  sched();
    80001870:	00000097          	auipc	ra,0x0
    80001874:	bd4080e7          	jalr	-1068(ra) # 80001444 <sched>
  panic("zombie exit");
    80001878:	00007517          	auipc	a0,0x7
    8000187c:	97850513          	addi	a0,a0,-1672 # 800081f0 <etext+0x1f0>
    80001880:	00004097          	auipc	ra,0x4
    80001884:	428080e7          	jalr	1064(ra) # 80005ca8 <panic>

0000000080001888 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001888:	7179                	addi	sp,sp,-48
    8000188a:	f406                	sd	ra,40(sp)
    8000188c:	f022                	sd	s0,32(sp)
    8000188e:	ec26                	sd	s1,24(sp)
    80001890:	e84a                	sd	s2,16(sp)
    80001892:	e44e                	sd	s3,8(sp)
    80001894:	1800                	addi	s0,sp,48
    80001896:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001898:	00008497          	auipc	s1,0x8
    8000189c:	be848493          	addi	s1,s1,-1048 # 80009480 <proc>
    800018a0:	0000d997          	auipc	s3,0xd
    800018a4:	5e098993          	addi	s3,s3,1504 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	948080e7          	jalr	-1720(ra) # 800061f2 <acquire>
    if(p->pid == pid){
    800018b2:	589c                	lw	a5,48(s1)
    800018b4:	01278d63          	beq	a5,s2,800018ce <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	9ec080e7          	jalr	-1556(ra) # 800062a6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c2:	16848493          	addi	s1,s1,360
    800018c6:	ff3491e3          	bne	s1,s3,800018a8 <kill+0x20>
  }
  return -1;
    800018ca:	557d                	li	a0,-1
    800018cc:	a829                	j	800018e6 <kill+0x5e>
      p->killed = 1;
    800018ce:	4785                	li	a5,1
    800018d0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d2:	4c98                	lw	a4,24(s1)
    800018d4:	4789                	li	a5,2
    800018d6:	00f70f63          	beq	a4,a5,800018f4 <kill+0x6c>
      release(&p->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	9ca080e7          	jalr	-1590(ra) # 800062a6 <release>
      return 0;
    800018e4:	4501                	li	a0,0
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6145                	addi	sp,sp,48
    800018f2:	8082                	ret
        p->state = RUNNABLE;
    800018f4:	478d                	li	a5,3
    800018f6:	cc9c                	sw	a5,24(s1)
    800018f8:	b7cd                	j	800018da <kill+0x52>

00000000800018fa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fa:	7179                	addi	sp,sp,-48
    800018fc:	f406                	sd	ra,40(sp)
    800018fe:	f022                	sd	s0,32(sp)
    80001900:	ec26                	sd	s1,24(sp)
    80001902:	e84a                	sd	s2,16(sp)
    80001904:	e44e                	sd	s3,8(sp)
    80001906:	e052                	sd	s4,0(sp)
    80001908:	1800                	addi	s0,sp,48
    8000190a:	84aa                	mv	s1,a0
    8000190c:	892e                	mv	s2,a1
    8000190e:	89b2                	mv	s3,a2
    80001910:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	580080e7          	jalr	1408(ra) # 80000e92 <myproc>
  if(user_dst){
    8000191a:	c08d                	beqz	s1,8000193c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191c:	86d2                	mv	a3,s4
    8000191e:	864e                	mv	a2,s3
    80001920:	85ca                	mv	a1,s2
    80001922:	6928                	ld	a0,80(a0)
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	230080e7          	jalr	560(ra) # 80000b54 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret
    memmove((char *)dst, src, len);
    8000193c:	000a061b          	sext.w	a2,s4
    80001940:	85ce                	mv	a1,s3
    80001942:	854a                	mv	a0,s2
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	8de080e7          	jalr	-1826(ra) # 80000222 <memmove>
    return 0;
    8000194c:	8526                	mv	a0,s1
    8000194e:	bff9                	j	8000192c <either_copyout+0x32>

0000000080001950 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001950:	7179                	addi	sp,sp,-48
    80001952:	f406                	sd	ra,40(sp)
    80001954:	f022                	sd	s0,32(sp)
    80001956:	ec26                	sd	s1,24(sp)
    80001958:	e84a                	sd	s2,16(sp)
    8000195a:	e44e                	sd	s3,8(sp)
    8000195c:	e052                	sd	s4,0(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	892a                	mv	s2,a0
    80001962:	84ae                	mv	s1,a1
    80001964:	89b2                	mv	s3,a2
    80001966:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	52a080e7          	jalr	1322(ra) # 80000e92 <myproc>
  if(user_src){
    80001970:	c08d                	beqz	s1,80001992 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001972:	86d2                	mv	a3,s4
    80001974:	864e                	mv	a2,s3
    80001976:	85ca                	mv	a1,s2
    80001978:	6928                	ld	a0,80(a0)
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	266080e7          	jalr	614(ra) # 80000be0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6a02                	ld	s4,0(sp)
    8000198e:	6145                	addi	sp,sp,48
    80001990:	8082                	ret
    memmove(dst, (char*)src, len);
    80001992:	000a061b          	sext.w	a2,s4
    80001996:	85ce                	mv	a1,s3
    80001998:	854a                	mv	a0,s2
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	888080e7          	jalr	-1912(ra) # 80000222 <memmove>
    return 0;
    800019a2:	8526                	mv	a0,s1
    800019a4:	bff9                	j	80001982 <either_copyin+0x32>

00000000800019a6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a6:	715d                	addi	sp,sp,-80
    800019a8:	e486                	sd	ra,72(sp)
    800019aa:	e0a2                	sd	s0,64(sp)
    800019ac:	fc26                	sd	s1,56(sp)
    800019ae:	f84a                	sd	s2,48(sp)
    800019b0:	f44e                	sd	s3,40(sp)
    800019b2:	f052                	sd	s4,32(sp)
    800019b4:	ec56                	sd	s5,24(sp)
    800019b6:	e85a                	sd	s6,16(sp)
    800019b8:	e45e                	sd	s7,8(sp)
    800019ba:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019bc:	00006517          	auipc	a0,0x6
    800019c0:	68c50513          	addi	a0,a0,1676 # 80008048 <etext+0x48>
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	32e080e7          	jalr	814(ra) # 80005cf2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019cc:	00008497          	auipc	s1,0x8
    800019d0:	c0c48493          	addi	s1,s1,-1012 # 800095d8 <proc+0x158>
    800019d4:	0000d917          	auipc	s2,0xd
    800019d8:	60490913          	addi	s2,s2,1540 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019de:	00007997          	auipc	s3,0x7
    800019e2:	82298993          	addi	s3,s3,-2014 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e6:	00007a97          	auipc	s5,0x7
    800019ea:	822a8a93          	addi	s5,s5,-2014 # 80008208 <etext+0x208>
    printf("\n");
    800019ee:	00006a17          	auipc	s4,0x6
    800019f2:	65aa0a13          	addi	s4,s4,1626 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f6:	00007b97          	auipc	s7,0x7
    800019fa:	84ab8b93          	addi	s7,s7,-1974 # 80008240 <states.1710>
    800019fe:	a00d                	j	80001a20 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a00:	ed86a583          	lw	a1,-296(a3)
    80001a04:	8556                	mv	a0,s5
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	2ec080e7          	jalr	748(ra) # 80005cf2 <printf>
    printf("\n");
    80001a0e:	8552                	mv	a0,s4
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	2e2080e7          	jalr	738(ra) # 80005cf2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a18:	16848493          	addi	s1,s1,360
    80001a1c:	03248163          	beq	s1,s2,80001a3e <procdump+0x98>
    if(p->state == UNUSED)
    80001a20:	86a6                	mv	a3,s1
    80001a22:	ec04a783          	lw	a5,-320(s1)
    80001a26:	dbed                	beqz	a5,80001a18 <procdump+0x72>
      state = "???";
    80001a28:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2a:	fcfb6be3          	bltu	s6,a5,80001a00 <procdump+0x5a>
    80001a2e:	1782                	slli	a5,a5,0x20
    80001a30:	9381                	srli	a5,a5,0x20
    80001a32:	078e                	slli	a5,a5,0x3
    80001a34:	97de                	add	a5,a5,s7
    80001a36:	6390                	ld	a2,0(a5)
    80001a38:	f661                	bnez	a2,80001a00 <procdump+0x5a>
      state = "???";
    80001a3a:	864e                	mv	a2,s3
    80001a3c:	b7d1                	j	80001a00 <procdump+0x5a>
  }
}
    80001a3e:	60a6                	ld	ra,72(sp)
    80001a40:	6406                	ld	s0,64(sp)
    80001a42:	74e2                	ld	s1,56(sp)
    80001a44:	7942                	ld	s2,48(sp)
    80001a46:	79a2                	ld	s3,40(sp)
    80001a48:	7a02                	ld	s4,32(sp)
    80001a4a:	6ae2                	ld	s5,24(sp)
    80001a4c:	6b42                	ld	s6,16(sp)
    80001a4e:	6ba2                	ld	s7,8(sp)
    80001a50:	6161                	addi	sp,sp,80
    80001a52:	8082                	ret

0000000080001a54 <npproc>:

// returns number of processes with state other than UNUSED 
// if no such process is found it returns 0
uint64
npproc(void)  // *modified*         
{
    80001a54:	7179                	addi	sp,sp,-48
    80001a56:	f406                	sd	ra,40(sp)
    80001a58:	f022                	sd	s0,32(sp)
    80001a5a:	ec26                	sd	s1,24(sp)
    80001a5c:	e84a                	sd	s2,16(sp)
    80001a5e:	e44e                	sd	s3,8(sp)
    80001a60:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 np=0;
    80001a62:	4901                	li	s2,0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a64:	00008497          	auipc	s1,0x8
    80001a68:	a1c48493          	addi	s1,s1,-1508 # 80009480 <proc>
    80001a6c:	0000d997          	auipc	s3,0xd
    80001a70:	41498993          	addi	s3,s3,1044 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001a74:	8526                	mv	a0,s1
    80001a76:	00004097          	auipc	ra,0x4
    80001a7a:	77c080e7          	jalr	1916(ra) # 800061f2 <acquire>
    if(p->state != UNUSED) {
    80001a7e:	4c9c                	lw	a5,24(s1)
       np++;                               // number of processes with state  other than UNUSED
    80001a80:	00f037b3          	snez	a5,a5
    80001a84:	993e                	add	s2,s2,a5
    }
    release(&p->lock);
    80001a86:	8526                	mv	a0,s1
    80001a88:	00005097          	auipc	ra,0x5
    80001a8c:	81e080e7          	jalr	-2018(ra) # 800062a6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a90:	16848493          	addi	s1,s1,360
    80001a94:	ff3490e3          	bne	s1,s3,80001a74 <npproc+0x20>
  }

  return np;
    80001a98:	854a                	mv	a0,s2
    80001a9a:	70a2                	ld	ra,40(sp)
    80001a9c:	7402                	ld	s0,32(sp)
    80001a9e:	64e2                	ld	s1,24(sp)
    80001aa0:	6942                	ld	s2,16(sp)
    80001aa2:	69a2                	ld	s3,8(sp)
    80001aa4:	6145                	addi	sp,sp,48
    80001aa6:	8082                	ret

0000000080001aa8 <swtch>:
    80001aa8:	00153023          	sd	ra,0(a0)
    80001aac:	00253423          	sd	sp,8(a0)
    80001ab0:	e900                	sd	s0,16(a0)
    80001ab2:	ed04                	sd	s1,24(a0)
    80001ab4:	03253023          	sd	s2,32(a0)
    80001ab8:	03353423          	sd	s3,40(a0)
    80001abc:	03453823          	sd	s4,48(a0)
    80001ac0:	03553c23          	sd	s5,56(a0)
    80001ac4:	05653023          	sd	s6,64(a0)
    80001ac8:	05753423          	sd	s7,72(a0)
    80001acc:	05853823          	sd	s8,80(a0)
    80001ad0:	05953c23          	sd	s9,88(a0)
    80001ad4:	07a53023          	sd	s10,96(a0)
    80001ad8:	07b53423          	sd	s11,104(a0)
    80001adc:	0005b083          	ld	ra,0(a1)
    80001ae0:	0085b103          	ld	sp,8(a1)
    80001ae4:	6980                	ld	s0,16(a1)
    80001ae6:	6d84                	ld	s1,24(a1)
    80001ae8:	0205b903          	ld	s2,32(a1)
    80001aec:	0285b983          	ld	s3,40(a1)
    80001af0:	0305ba03          	ld	s4,48(a1)
    80001af4:	0385ba83          	ld	s5,56(a1)
    80001af8:	0405bb03          	ld	s6,64(a1)
    80001afc:	0485bb83          	ld	s7,72(a1)
    80001b00:	0505bc03          	ld	s8,80(a1)
    80001b04:	0585bc83          	ld	s9,88(a1)
    80001b08:	0605bd03          	ld	s10,96(a1)
    80001b0c:	0685bd83          	ld	s11,104(a1)
    80001b10:	8082                	ret

0000000080001b12 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b1a:	00006597          	auipc	a1,0x6
    80001b1e:	75658593          	addi	a1,a1,1878 # 80008270 <states.1710+0x30>
    80001b22:	0000d517          	auipc	a0,0xd
    80001b26:	35e50513          	addi	a0,a0,862 # 8000ee80 <tickslock>
    80001b2a:	00004097          	auipc	ra,0x4
    80001b2e:	638080e7          	jalr	1592(ra) # 80006162 <initlock>
}
    80001b32:	60a2                	ld	ra,8(sp)
    80001b34:	6402                	ld	s0,0(sp)
    80001b36:	0141                	addi	sp,sp,16
    80001b38:	8082                	ret

0000000080001b3a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e422                	sd	s0,8(sp)
    80001b3e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b40:	00003797          	auipc	a5,0x3
    80001b44:	57078793          	addi	a5,a5,1392 # 800050b0 <kernelvec>
    80001b48:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b4c:	6422                	ld	s0,8(sp)
    80001b4e:	0141                	addi	sp,sp,16
    80001b50:	8082                	ret

0000000080001b52 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b52:	1141                	addi	sp,sp,-16
    80001b54:	e406                	sd	ra,8(sp)
    80001b56:	e022                	sd	s0,0(sp)
    80001b58:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	338080e7          	jalr	824(ra) # 80000e92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b68:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b6c:	00005617          	auipc	a2,0x5
    80001b70:	49460613          	addi	a2,a2,1172 # 80007000 <_trampoline>
    80001b74:	00005697          	auipc	a3,0x5
    80001b78:	48c68693          	addi	a3,a3,1164 # 80007000 <_trampoline>
    80001b7c:	8e91                	sub	a3,a3,a2
    80001b7e:	040007b7          	lui	a5,0x4000
    80001b82:	17fd                	addi	a5,a5,-1
    80001b84:	07b2                	slli	a5,a5,0xc
    80001b86:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b88:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b8c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b8e:	180026f3          	csrr	a3,satp
    80001b92:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b94:	6d38                	ld	a4,88(a0)
    80001b96:	6134                	ld	a3,64(a0)
    80001b98:	6585                	lui	a1,0x1
    80001b9a:	96ae                	add	a3,a3,a1
    80001b9c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b9e:	6d38                	ld	a4,88(a0)
    80001ba0:	00000697          	auipc	a3,0x0
    80001ba4:	13868693          	addi	a3,a3,312 # 80001cd8 <usertrap>
    80001ba8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001baa:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bac:	8692                	mv	a3,tp
    80001bae:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bb8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bbc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bc0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc2:	6f18                	ld	a4,24(a4)
    80001bc4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bc8:	692c                	ld	a1,80(a0)
    80001bca:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bcc:	00005717          	auipc	a4,0x5
    80001bd0:	4c470713          	addi	a4,a4,1220 # 80007090 <userret>
    80001bd4:	8f11                	sub	a4,a4,a2
    80001bd6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bd8:	577d                	li	a4,-1
    80001bda:	177e                	slli	a4,a4,0x3f
    80001bdc:	8dd9                	or	a1,a1,a4
    80001bde:	02000537          	lui	a0,0x2000
    80001be2:	157d                	addi	a0,a0,-1
    80001be4:	0536                	slli	a0,a0,0xd
    80001be6:	9782                	jalr	a5
}
    80001be8:	60a2                	ld	ra,8(sp)
    80001bea:	6402                	ld	s0,0(sp)
    80001bec:	0141                	addi	sp,sp,16
    80001bee:	8082                	ret

0000000080001bf0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bfa:	0000d497          	auipc	s1,0xd
    80001bfe:	28648493          	addi	s1,s1,646 # 8000ee80 <tickslock>
    80001c02:	8526                	mv	a0,s1
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	5ee080e7          	jalr	1518(ra) # 800061f2 <acquire>
  ticks++;
    80001c0c:	00007517          	auipc	a0,0x7
    80001c10:	40c50513          	addi	a0,a0,1036 # 80009018 <ticks>
    80001c14:	411c                	lw	a5,0(a0)
    80001c16:	2785                	addiw	a5,a5,1
    80001c18:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c1a:	00000097          	auipc	ra,0x0
    80001c1e:	ac8080e7          	jalr	-1336(ra) # 800016e2 <wakeup>
  release(&tickslock);
    80001c22:	8526                	mv	a0,s1
    80001c24:	00004097          	auipc	ra,0x4
    80001c28:	682080e7          	jalr	1666(ra) # 800062a6 <release>
}
    80001c2c:	60e2                	ld	ra,24(sp)
    80001c2e:	6442                	ld	s0,16(sp)
    80001c30:	64a2                	ld	s1,8(sp)
    80001c32:	6105                	addi	sp,sp,32
    80001c34:	8082                	ret

0000000080001c36 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c36:	1101                	addi	sp,sp,-32
    80001c38:	ec06                	sd	ra,24(sp)
    80001c3a:	e822                	sd	s0,16(sp)
    80001c3c:	e426                	sd	s1,8(sp)
    80001c3e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c40:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c44:	00074d63          	bltz	a4,80001c5e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c48:	57fd                	li	a5,-1
    80001c4a:	17fe                	slli	a5,a5,0x3f
    80001c4c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c4e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c50:	06f70363          	beq	a4,a5,80001cb6 <devintr+0x80>
  }
}
    80001c54:	60e2                	ld	ra,24(sp)
    80001c56:	6442                	ld	s0,16(sp)
    80001c58:	64a2                	ld	s1,8(sp)
    80001c5a:	6105                	addi	sp,sp,32
    80001c5c:	8082                	ret
     (scause & 0xff) == 9){
    80001c5e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c62:	46a5                	li	a3,9
    80001c64:	fed792e3          	bne	a5,a3,80001c48 <devintr+0x12>
    int irq = plic_claim();
    80001c68:	00003097          	auipc	ra,0x3
    80001c6c:	550080e7          	jalr	1360(ra) # 800051b8 <plic_claim>
    80001c70:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c72:	47a9                	li	a5,10
    80001c74:	02f50763          	beq	a0,a5,80001ca2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c78:	4785                	li	a5,1
    80001c7a:	02f50963          	beq	a0,a5,80001cac <devintr+0x76>
    return 1;
    80001c7e:	4505                	li	a0,1
    } else if(irq){
    80001c80:	d8f1                	beqz	s1,80001c54 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c82:	85a6                	mv	a1,s1
    80001c84:	00006517          	auipc	a0,0x6
    80001c88:	5f450513          	addi	a0,a0,1524 # 80008278 <states.1710+0x38>
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	066080e7          	jalr	102(ra) # 80005cf2 <printf>
      plic_complete(irq);
    80001c94:	8526                	mv	a0,s1
    80001c96:	00003097          	auipc	ra,0x3
    80001c9a:	546080e7          	jalr	1350(ra) # 800051dc <plic_complete>
    return 1;
    80001c9e:	4505                	li	a0,1
    80001ca0:	bf55                	j	80001c54 <devintr+0x1e>
      uartintr();
    80001ca2:	00004097          	auipc	ra,0x4
    80001ca6:	470080e7          	jalr	1136(ra) # 80006112 <uartintr>
    80001caa:	b7ed                	j	80001c94 <devintr+0x5e>
      virtio_disk_intr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	a10080e7          	jalr	-1520(ra) # 800056bc <virtio_disk_intr>
    80001cb4:	b7c5                	j	80001c94 <devintr+0x5e>
    if(cpuid() == 0){
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	1b0080e7          	jalr	432(ra) # 80000e66 <cpuid>
    80001cbe:	c901                	beqz	a0,80001cce <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cc4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cc6:	14479073          	csrw	sip,a5
    return 2;
    80001cca:	4509                	li	a0,2
    80001ccc:	b761                	j	80001c54 <devintr+0x1e>
      clockintr();
    80001cce:	00000097          	auipc	ra,0x0
    80001cd2:	f22080e7          	jalr	-222(ra) # 80001bf0 <clockintr>
    80001cd6:	b7ed                	j	80001cc0 <devintr+0x8a>

0000000080001cd8 <usertrap>:
{
    80001cd8:	1101                	addi	sp,sp,-32
    80001cda:	ec06                	sd	ra,24(sp)
    80001cdc:	e822                	sd	s0,16(sp)
    80001cde:	e426                	sd	s1,8(sp)
    80001ce0:	e04a                	sd	s2,0(sp)
    80001ce2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ce8:	1007f793          	andi	a5,a5,256
    80001cec:	e3ad                	bnez	a5,80001d4e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cee:	00003797          	auipc	a5,0x3
    80001cf2:	3c278793          	addi	a5,a5,962 # 800050b0 <kernelvec>
    80001cf6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	198080e7          	jalr	408(ra) # 80000e92 <myproc>
    80001d02:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d04:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d06:	14102773          	csrr	a4,sepc
    80001d0a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d0c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d10:	47a1                	li	a5,8
    80001d12:	04f71c63          	bne	a4,a5,80001d6a <usertrap+0x92>
    if(p->killed)
    80001d16:	551c                	lw	a5,40(a0)
    80001d18:	e3b9                	bnez	a5,80001d5e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d1a:	6cb8                	ld	a4,88(s1)
    80001d1c:	6f1c                	ld	a5,24(a4)
    80001d1e:	0791                	addi	a5,a5,4
    80001d20:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d26:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2a:	10079073          	csrw	sstatus,a5
    syscall();
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	2e0080e7          	jalr	736(ra) # 8000200e <syscall>
  if(p->killed)
    80001d36:	549c                	lw	a5,40(s1)
    80001d38:	ebc1                	bnez	a5,80001dc8 <usertrap+0xf0>
  usertrapret();
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	e18080e7          	jalr	-488(ra) # 80001b52 <usertrapret>
}
    80001d42:	60e2                	ld	ra,24(sp)
    80001d44:	6442                	ld	s0,16(sp)
    80001d46:	64a2                	ld	s1,8(sp)
    80001d48:	6902                	ld	s2,0(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret
    panic("usertrap: not from user mode");
    80001d4e:	00006517          	auipc	a0,0x6
    80001d52:	54a50513          	addi	a0,a0,1354 # 80008298 <states.1710+0x58>
    80001d56:	00004097          	auipc	ra,0x4
    80001d5a:	f52080e7          	jalr	-174(ra) # 80005ca8 <panic>
      exit(-1);
    80001d5e:	557d                	li	a0,-1
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	a52080e7          	jalr	-1454(ra) # 800017b2 <exit>
    80001d68:	bf4d                	j	80001d1a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	ecc080e7          	jalr	-308(ra) # 80001c36 <devintr>
    80001d72:	892a                	mv	s2,a0
    80001d74:	c501                	beqz	a0,80001d7c <usertrap+0xa4>
  if(p->killed)
    80001d76:	549c                	lw	a5,40(s1)
    80001d78:	c3a1                	beqz	a5,80001db8 <usertrap+0xe0>
    80001d7a:	a815                	j	80001dae <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d80:	5890                	lw	a2,48(s1)
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	53650513          	addi	a0,a0,1334 # 800082b8 <states.1710+0x78>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	f68080e7          	jalr	-152(ra) # 80005cf2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d92:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d96:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d9a:	00006517          	auipc	a0,0x6
    80001d9e:	54e50513          	addi	a0,a0,1358 # 800082e8 <states.1710+0xa8>
    80001da2:	00004097          	auipc	ra,0x4
    80001da6:	f50080e7          	jalr	-176(ra) # 80005cf2 <printf>
    p->killed = 1;
    80001daa:	4785                	li	a5,1
    80001dac:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dae:	557d                	li	a0,-1
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	a02080e7          	jalr	-1534(ra) # 800017b2 <exit>
  if(which_dev == 2)
    80001db8:	4789                	li	a5,2
    80001dba:	f8f910e3          	bne	s2,a5,80001d3a <usertrap+0x62>
    yield();
    80001dbe:	fffff097          	auipc	ra,0xfffff
    80001dc2:	75c080e7          	jalr	1884(ra) # 8000151a <yield>
    80001dc6:	bf95                	j	80001d3a <usertrap+0x62>
  int which_dev = 0;
    80001dc8:	4901                	li	s2,0
    80001dca:	b7d5                	j	80001dae <usertrap+0xd6>

0000000080001dcc <kerneltrap>:
{
    80001dcc:	7179                	addi	sp,sp,-48
    80001dce:	f406                	sd	ra,40(sp)
    80001dd0:	f022                	sd	s0,32(sp)
    80001dd2:	ec26                	sd	s1,24(sp)
    80001dd4:	e84a                	sd	s2,16(sp)
    80001dd6:	e44e                	sd	s3,8(sp)
    80001dd8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dda:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dde:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001de6:	1004f793          	andi	a5,s1,256
    80001dea:	cb85                	beqz	a5,80001e1a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001df0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001df2:	ef85                	bnez	a5,80001e2a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	e42080e7          	jalr	-446(ra) # 80001c36 <devintr>
    80001dfc:	cd1d                	beqz	a0,80001e3a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dfe:	4789                	li	a5,2
    80001e00:	06f50a63          	beq	a0,a5,80001e74 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e04:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e08:	10049073          	csrw	sstatus,s1
}
    80001e0c:	70a2                	ld	ra,40(sp)
    80001e0e:	7402                	ld	s0,32(sp)
    80001e10:	64e2                	ld	s1,24(sp)
    80001e12:	6942                	ld	s2,16(sp)
    80001e14:	69a2                	ld	s3,8(sp)
    80001e16:	6145                	addi	sp,sp,48
    80001e18:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	4ee50513          	addi	a0,a0,1262 # 80008308 <states.1710+0xc8>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	e86080e7          	jalr	-378(ra) # 80005ca8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	50650513          	addi	a0,a0,1286 # 80008330 <states.1710+0xf0>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	e76080e7          	jalr	-394(ra) # 80005ca8 <panic>
    printf("scause %p\n", scause);
    80001e3a:	85ce                	mv	a1,s3
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	51450513          	addi	a0,a0,1300 # 80008350 <states.1710+0x110>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	eae080e7          	jalr	-338(ra) # 80005cf2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e50:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	50c50513          	addi	a0,a0,1292 # 80008360 <states.1710+0x120>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	e96080e7          	jalr	-362(ra) # 80005cf2 <printf>
    panic("kerneltrap");
    80001e64:	00006517          	auipc	a0,0x6
    80001e68:	51450513          	addi	a0,a0,1300 # 80008378 <states.1710+0x138>
    80001e6c:	00004097          	auipc	ra,0x4
    80001e70:	e3c080e7          	jalr	-452(ra) # 80005ca8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	01e080e7          	jalr	30(ra) # 80000e92 <myproc>
    80001e7c:	d541                	beqz	a0,80001e04 <kerneltrap+0x38>
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	014080e7          	jalr	20(ra) # 80000e92 <myproc>
    80001e86:	4d18                	lw	a4,24(a0)
    80001e88:	4791                	li	a5,4
    80001e8a:	f6f71de3          	bne	a4,a5,80001e04 <kerneltrap+0x38>
    yield();
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	68c080e7          	jalr	1676(ra) # 8000151a <yield>
    80001e96:	b7bd                	j	80001e04 <kerneltrap+0x38>

0000000080001e98 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e98:	1101                	addi	sp,sp,-32
    80001e9a:	ec06                	sd	ra,24(sp)
    80001e9c:	e822                	sd	s0,16(sp)
    80001e9e:	e426                	sd	s1,8(sp)
    80001ea0:	1000                	addi	s0,sp,32
    80001ea2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	fee080e7          	jalr	-18(ra) # 80000e92 <myproc>
  switch (n) {
    80001eac:	4795                	li	a5,5
    80001eae:	0497e163          	bltu	a5,s1,80001ef0 <argraw+0x58>
    80001eb2:	048a                	slli	s1,s1,0x2
    80001eb4:	00006717          	auipc	a4,0x6
    80001eb8:	5c470713          	addi	a4,a4,1476 # 80008478 <states.1710+0x238>
    80001ebc:	94ba                	add	s1,s1,a4
    80001ebe:	409c                	lw	a5,0(s1)
    80001ec0:	97ba                	add	a5,a5,a4
    80001ec2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ec4:	6d3c                	ld	a5,88(a0)
    80001ec6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6105                	addi	sp,sp,32
    80001ed0:	8082                	ret
    return p->trapframe->a1;
    80001ed2:	6d3c                	ld	a5,88(a0)
    80001ed4:	7fa8                	ld	a0,120(a5)
    80001ed6:	bfcd                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a2;
    80001ed8:	6d3c                	ld	a5,88(a0)
    80001eda:	63c8                	ld	a0,128(a5)
    80001edc:	b7f5                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a3;
    80001ede:	6d3c                	ld	a5,88(a0)
    80001ee0:	67c8                	ld	a0,136(a5)
    80001ee2:	b7dd                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a4;
    80001ee4:	6d3c                	ld	a5,88(a0)
    80001ee6:	6bc8                	ld	a0,144(a5)
    80001ee8:	b7c5                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a5;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	6fc8                	ld	a0,152(a5)
    80001eee:	bfe9                	j	80001ec8 <argraw+0x30>
  panic("argraw");
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	49850513          	addi	a0,a0,1176 # 80008388 <states.1710+0x148>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	db0080e7          	jalr	-592(ra) # 80005ca8 <panic>

0000000080001f00 <fetchaddr>:
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	e04a                	sd	s2,0(sp)
    80001f0a:	1000                	addi	s0,sp,32
    80001f0c:	84aa                	mv	s1,a0
    80001f0e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	f82080e7          	jalr	-126(ra) # 80000e92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f18:	653c                	ld	a5,72(a0)
    80001f1a:	02f4f863          	bgeu	s1,a5,80001f4a <fetchaddr+0x4a>
    80001f1e:	00848713          	addi	a4,s1,8
    80001f22:	02e7e663          	bltu	a5,a4,80001f4e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f26:	46a1                	li	a3,8
    80001f28:	8626                	mv	a2,s1
    80001f2a:	85ca                	mv	a1,s2
    80001f2c:	6928                	ld	a0,80(a0)
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	cb2080e7          	jalr	-846(ra) # 80000be0 <copyin>
    80001f36:	00a03533          	snez	a0,a0
    80001f3a:	40a00533          	neg	a0,a0
}
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6902                	ld	s2,0(sp)
    80001f46:	6105                	addi	sp,sp,32
    80001f48:	8082                	ret
    return -1;
    80001f4a:	557d                	li	a0,-1
    80001f4c:	bfcd                	j	80001f3e <fetchaddr+0x3e>
    80001f4e:	557d                	li	a0,-1
    80001f50:	b7fd                	j	80001f3e <fetchaddr+0x3e>

0000000080001f52 <fetchstr>:
{
    80001f52:	7179                	addi	sp,sp,-48
    80001f54:	f406                	sd	ra,40(sp)
    80001f56:	f022                	sd	s0,32(sp)
    80001f58:	ec26                	sd	s1,24(sp)
    80001f5a:	e84a                	sd	s2,16(sp)
    80001f5c:	e44e                	sd	s3,8(sp)
    80001f5e:	1800                	addi	s0,sp,48
    80001f60:	892a                	mv	s2,a0
    80001f62:	84ae                	mv	s1,a1
    80001f64:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	f2c080e7          	jalr	-212(ra) # 80000e92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f6e:	86ce                	mv	a3,s3
    80001f70:	864a                	mv	a2,s2
    80001f72:	85a6                	mv	a1,s1
    80001f74:	6928                	ld	a0,80(a0)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	cf6080e7          	jalr	-778(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f7e:	00054763          	bltz	a0,80001f8c <fetchstr+0x3a>
  return strlen(buf);
    80001f82:	8526                	mv	a0,s1
    80001f84:	ffffe097          	auipc	ra,0xffffe
    80001f88:	3c2080e7          	jalr	962(ra) # 80000346 <strlen>
}
    80001f8c:	70a2                	ld	ra,40(sp)
    80001f8e:	7402                	ld	s0,32(sp)
    80001f90:	64e2                	ld	s1,24(sp)
    80001f92:	6942                	ld	s2,16(sp)
    80001f94:	69a2                	ld	s3,8(sp)
    80001f96:	6145                	addi	sp,sp,48
    80001f98:	8082                	ret

0000000080001f9a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	1000                	addi	s0,sp,32
    80001fa4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa6:	00000097          	auipc	ra,0x0
    80001faa:	ef2080e7          	jalr	-270(ra) # 80001e98 <argraw>
    80001fae:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fb0:	4501                	li	a0,0
    80001fb2:	60e2                	ld	ra,24(sp)
    80001fb4:	6442                	ld	s0,16(sp)
    80001fb6:	64a2                	ld	s1,8(sp)
    80001fb8:	6105                	addi	sp,sp,32
    80001fba:	8082                	ret

0000000080001fbc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fbc:	1101                	addi	sp,sp,-32
    80001fbe:	ec06                	sd	ra,24(sp)
    80001fc0:	e822                	sd	s0,16(sp)
    80001fc2:	e426                	sd	s1,8(sp)
    80001fc4:	1000                	addi	s0,sp,32
    80001fc6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	ed0080e7          	jalr	-304(ra) # 80001e98 <argraw>
    80001fd0:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fd2:	4501                	li	a0,0
    80001fd4:	60e2                	ld	ra,24(sp)
    80001fd6:	6442                	ld	s0,16(sp)
    80001fd8:	64a2                	ld	s1,8(sp)
    80001fda:	6105                	addi	sp,sp,32
    80001fdc:	8082                	ret

0000000080001fde <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
    80001fea:	84ae                	mv	s1,a1
    80001fec:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	eaa080e7          	jalr	-342(ra) # 80001e98 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001ff6:	864a                	mv	a2,s2
    80001ff8:	85a6                	mv	a1,s1
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	f58080e7          	jalr	-168(ra) # 80001f52 <fetchstr>
}
    80002002:	60e2                	ld	ra,24(sp)
    80002004:	6442                	ld	s0,16(sp)
    80002006:	64a2                	ld	s1,8(sp)
    80002008:	6902                	ld	s2,0(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret

000000008000200e <syscall>:
  "fstat", "chdir", "dup",    "getpid", "sbrk",  "sleep", "uptime", "open",
  "write", "mknod", "unlink", "link",   "mkdir", "close", "trace"
};
void
syscall(void)
{
    8000200e:	7179                	addi	sp,sp,-48
    80002010:	f406                	sd	ra,40(sp)
    80002012:	f022                	sd	s0,32(sp)
    80002014:	ec26                	sd	s1,24(sp)
    80002016:	e84a                	sd	s2,16(sp)
    80002018:	e44e                	sd	s3,8(sp)
    8000201a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	e76080e7          	jalr	-394(ra) # 80000e92 <myproc>
    80002024:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80002026:	05853903          	ld	s2,88(a0)
    8000202a:	0a893783          	ld	a5,168(s2)
    8000202e:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002032:	37fd                	addiw	a5,a5,-1
    80002034:	4759                	li	a4,22
    80002036:	04f76763          	bltu	a4,a5,80002084 <syscall+0x76>
    8000203a:	00399713          	slli	a4,s3,0x3
    8000203e:	00006797          	auipc	a5,0x6
    80002042:	45278793          	addi	a5,a5,1106 # 80008490 <syscalls>
    80002046:	97ba                	add	a5,a5,a4
    80002048:	639c                	ld	a5,0(a5)
    8000204a:	cf8d                	beqz	a5,80002084 <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();
    8000204c:	9782                	jalr	a5
    8000204e:	06a93823          	sd	a0,112(s2)
    if(p->mask & (1 << num)){          // *modified* mask matches the 1 << SYS_<syscall name>
    80002052:	58dc                	lw	a5,52(s1)
    80002054:	4137d7bb          	sraw	a5,a5,s3
    80002058:	8b85                	andi	a5,a5,1
    8000205a:	c7a1                	beqz	a5,800020a2 <syscall+0x94>
      printf("%d: syscall %s -> %d\n",  p->pid, syscall_name[num],p->trapframe->a0);
    8000205c:	6cb8                	ld	a4,88(s1)
    8000205e:	098e                	slli	s3,s3,0x3
    80002060:	00006797          	auipc	a5,0x6
    80002064:	43078793          	addi	a5,a5,1072 # 80008490 <syscalls>
    80002068:	99be                	add	s3,s3,a5
    8000206a:	7b34                	ld	a3,112(a4)
    8000206c:	0c09b603          	ld	a2,192(s3)
    80002070:	588c                	lw	a1,48(s1)
    80002072:	00006517          	auipc	a0,0x6
    80002076:	31e50513          	addi	a0,a0,798 # 80008390 <states.1710+0x150>
    8000207a:	00004097          	auipc	ra,0x4
    8000207e:	c78080e7          	jalr	-904(ra) # 80005cf2 <printf>
    80002082:	a005                	j	800020a2 <syscall+0x94>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002084:	86ce                	mv	a3,s3
    80002086:	15848613          	addi	a2,s1,344
    8000208a:	588c                	lw	a1,48(s1)
    8000208c:	00006517          	auipc	a0,0x6
    80002090:	31c50513          	addi	a0,a0,796 # 800083a8 <states.1710+0x168>
    80002094:	00004097          	auipc	ra,0x4
    80002098:	c5e080e7          	jalr	-930(ra) # 80005cf2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000209c:	6cbc                	ld	a5,88(s1)
    8000209e:	577d                	li	a4,-1
    800020a0:	fbb8                	sd	a4,112(a5)
  }
}
    800020a2:	70a2                	ld	ra,40(sp)
    800020a4:	7402                	ld	s0,32(sp)
    800020a6:	64e2                	ld	s1,24(sp)
    800020a8:	6942                	ld	s2,16(sp)
    800020aa:	69a2                	ld	s3,8(sp)
    800020ac:	6145                	addi	sp,sp,48
    800020ae:	8082                	ret

00000000800020b0 <sys_exit>:
npproc(void);
uint64
freememory(void);
uint64
sys_exit(void)
{
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020b8:	fec40593          	addi	a1,s0,-20
    800020bc:	4501                	li	a0,0
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	edc080e7          	jalr	-292(ra) # 80001f9a <argint>
    return -1;
    800020c6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020c8:	00054963          	bltz	a0,800020da <sys_exit+0x2a>
  exit(n);
    800020cc:	fec42503          	lw	a0,-20(s0)
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	6e2080e7          	jalr	1762(ra) # 800017b2 <exit>
  return 0;  // not reached
    800020d8:	4781                	li	a5,0
}
    800020da:	853e                	mv	a0,a5
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret

00000000800020e4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e4:	1141                	addi	sp,sp,-16
    800020e6:	e406                	sd	ra,8(sp)
    800020e8:	e022                	sd	s0,0(sp)
    800020ea:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	da6080e7          	jalr	-602(ra) # 80000e92 <myproc>
}
    800020f4:	5908                	lw	a0,48(a0)
    800020f6:	60a2                	ld	ra,8(sp)
    800020f8:	6402                	ld	s0,0(sp)
    800020fa:	0141                	addi	sp,sp,16
    800020fc:	8082                	ret

00000000800020fe <sys_fork>:

uint64
sys_fork(void)
{
    800020fe:	1141                	addi	sp,sp,-16
    80002100:	e406                	sd	ra,8(sp)
    80002102:	e022                	sd	s0,0(sp)
    80002104:	0800                	addi	s0,sp,16
  return fork();
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	15a080e7          	jalr	346(ra) # 80001260 <fork>
}
    8000210e:	60a2                	ld	ra,8(sp)
    80002110:	6402                	ld	s0,0(sp)
    80002112:	0141                	addi	sp,sp,16
    80002114:	8082                	ret

0000000080002116 <sys_wait>:

uint64
sys_wait(void)
{
    80002116:	1101                	addi	sp,sp,-32
    80002118:	ec06                	sd	ra,24(sp)
    8000211a:	e822                	sd	s0,16(sp)
    8000211c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000211e:	fe840593          	addi	a1,s0,-24
    80002122:	4501                	li	a0,0
    80002124:	00000097          	auipc	ra,0x0
    80002128:	e98080e7          	jalr	-360(ra) # 80001fbc <argaddr>
    8000212c:	87aa                	mv	a5,a0
    return -1;
    8000212e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002130:	0007c863          	bltz	a5,80002140 <sys_wait+0x2a>
  return wait(p);
    80002134:	fe843503          	ld	a0,-24(s0)
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	482080e7          	jalr	1154(ra) # 800015ba <wait>
}
    80002140:	60e2                	ld	ra,24(sp)
    80002142:	6442                	ld	s0,16(sp)
    80002144:	6105                	addi	sp,sp,32
    80002146:	8082                	ret

0000000080002148 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002148:	7179                	addi	sp,sp,-48
    8000214a:	f406                	sd	ra,40(sp)
    8000214c:	f022                	sd	s0,32(sp)
    8000214e:	ec26                	sd	s1,24(sp)
    80002150:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002152:	fdc40593          	addi	a1,s0,-36
    80002156:	4501                	li	a0,0
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	e42080e7          	jalr	-446(ra) # 80001f9a <argint>
    80002160:	87aa                	mv	a5,a0
    return -1;
    80002162:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002164:	0207c063          	bltz	a5,80002184 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	d2a080e7          	jalr	-726(ra) # 80000e92 <myproc>
    80002170:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002172:	fdc42503          	lw	a0,-36(s0)
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	076080e7          	jalr	118(ra) # 800011ec <growproc>
    8000217e:	00054863          	bltz	a0,8000218e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002182:	8526                	mv	a0,s1
}
    80002184:	70a2                	ld	ra,40(sp)
    80002186:	7402                	ld	s0,32(sp)
    80002188:	64e2                	ld	s1,24(sp)
    8000218a:	6145                	addi	sp,sp,48
    8000218c:	8082                	ret
    return -1;
    8000218e:	557d                	li	a0,-1
    80002190:	bfd5                	j	80002184 <sys_sbrk+0x3c>

0000000080002192 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002192:	7139                	addi	sp,sp,-64
    80002194:	fc06                	sd	ra,56(sp)
    80002196:	f822                	sd	s0,48(sp)
    80002198:	f426                	sd	s1,40(sp)
    8000219a:	f04a                	sd	s2,32(sp)
    8000219c:	ec4e                	sd	s3,24(sp)
    8000219e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021a0:	fcc40593          	addi	a1,s0,-52
    800021a4:	4501                	li	a0,0
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	df4080e7          	jalr	-524(ra) # 80001f9a <argint>
    return -1;
    800021ae:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021b0:	06054563          	bltz	a0,8000221a <sys_sleep+0x88>
  acquire(&tickslock);
    800021b4:	0000d517          	auipc	a0,0xd
    800021b8:	ccc50513          	addi	a0,a0,-820 # 8000ee80 <tickslock>
    800021bc:	00004097          	auipc	ra,0x4
    800021c0:	036080e7          	jalr	54(ra) # 800061f2 <acquire>
  ticks0 = ticks;
    800021c4:	00007917          	auipc	s2,0x7
    800021c8:	e5492903          	lw	s2,-428(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021cc:	fcc42783          	lw	a5,-52(s0)
    800021d0:	cf85                	beqz	a5,80002208 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d2:	0000d997          	auipc	s3,0xd
    800021d6:	cae98993          	addi	s3,s3,-850 # 8000ee80 <tickslock>
    800021da:	00007497          	auipc	s1,0x7
    800021de:	e3e48493          	addi	s1,s1,-450 # 80009018 <ticks>
    if(myproc()->killed){
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	cb0080e7          	jalr	-848(ra) # 80000e92 <myproc>
    800021ea:	551c                	lw	a5,40(a0)
    800021ec:	ef9d                	bnez	a5,8000222a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021ee:	85ce                	mv	a1,s3
    800021f0:	8526                	mv	a0,s1
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	364080e7          	jalr	868(ra) # 80001556 <sleep>
  while(ticks - ticks0 < n){
    800021fa:	409c                	lw	a5,0(s1)
    800021fc:	412787bb          	subw	a5,a5,s2
    80002200:	fcc42703          	lw	a4,-52(s0)
    80002204:	fce7efe3          	bltu	a5,a4,800021e2 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002208:	0000d517          	auipc	a0,0xd
    8000220c:	c7850513          	addi	a0,a0,-904 # 8000ee80 <tickslock>
    80002210:	00004097          	auipc	ra,0x4
    80002214:	096080e7          	jalr	150(ra) # 800062a6 <release>
  return 0;
    80002218:	4781                	li	a5,0
}
    8000221a:	853e                	mv	a0,a5
    8000221c:	70e2                	ld	ra,56(sp)
    8000221e:	7442                	ld	s0,48(sp)
    80002220:	74a2                	ld	s1,40(sp)
    80002222:	7902                	ld	s2,32(sp)
    80002224:	69e2                	ld	s3,24(sp)
    80002226:	6121                	addi	sp,sp,64
    80002228:	8082                	ret
      release(&tickslock);
    8000222a:	0000d517          	auipc	a0,0xd
    8000222e:	c5650513          	addi	a0,a0,-938 # 8000ee80 <tickslock>
    80002232:	00004097          	auipc	ra,0x4
    80002236:	074080e7          	jalr	116(ra) # 800062a6 <release>
      return -1;
    8000223a:	57fd                	li	a5,-1
    8000223c:	bff9                	j	8000221a <sys_sleep+0x88>

000000008000223e <sys_kill>:

uint64
sys_kill(void)
{
    8000223e:	1101                	addi	sp,sp,-32
    80002240:	ec06                	sd	ra,24(sp)
    80002242:	e822                	sd	s0,16(sp)
    80002244:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002246:	fec40593          	addi	a1,s0,-20
    8000224a:	4501                	li	a0,0
    8000224c:	00000097          	auipc	ra,0x0
    80002250:	d4e080e7          	jalr	-690(ra) # 80001f9a <argint>
    80002254:	87aa                	mv	a5,a0
    return -1;
    80002256:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002258:	0007c863          	bltz	a5,80002268 <sys_kill+0x2a>
  return kill(pid);
    8000225c:	fec42503          	lw	a0,-20(s0)
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	628080e7          	jalr	1576(ra) # 80001888 <kill>
}
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	6105                	addi	sp,sp,32
    8000226e:	8082                	ret

0000000080002270 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002270:	1101                	addi	sp,sp,-32
    80002272:	ec06                	sd	ra,24(sp)
    80002274:	e822                	sd	s0,16(sp)
    80002276:	e426                	sd	s1,8(sp)
    80002278:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000227a:	0000d517          	auipc	a0,0xd
    8000227e:	c0650513          	addi	a0,a0,-1018 # 8000ee80 <tickslock>
    80002282:	00004097          	auipc	ra,0x4
    80002286:	f70080e7          	jalr	-144(ra) # 800061f2 <acquire>
  xticks = ticks;
    8000228a:	00007497          	auipc	s1,0x7
    8000228e:	d8e4a483          	lw	s1,-626(s1) # 80009018 <ticks>
  release(&tickslock);
    80002292:	0000d517          	auipc	a0,0xd
    80002296:	bee50513          	addi	a0,a0,-1042 # 8000ee80 <tickslock>
    8000229a:	00004097          	auipc	ra,0x4
    8000229e:	00c080e7          	jalr	12(ra) # 800062a6 <release>
  return xticks;
}
    800022a2:	02049513          	slli	a0,s1,0x20
    800022a6:	9101                	srli	a0,a0,0x20
    800022a8:	60e2                	ld	ra,24(sp)
    800022aa:	6442                	ld	s0,16(sp)
    800022ac:	64a2                	ld	s1,8(sp)
    800022ae:	6105                	addi	sp,sp,32
    800022b0:	8082                	ret

00000000800022b2 <sys_trace>:

uint64
sys_trace(void)    // *modified* 
{
    800022b2:	1101                	addi	sp,sp,-32
    800022b4:	ec06                	sd	ra,24(sp)
    800022b6:	e822                	sd	s0,16(sp)
    800022b8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n)<0)  // read mask from user space
    800022ba:	fec40593          	addi	a1,s0,-20
    800022be:	4501                	li	a0,0
    800022c0:	00000097          	auipc	ra,0x0
    800022c4:	cda080e7          	jalr	-806(ra) # 80001f9a <argint>
    return -1;
    800022c8:	57fd                	li	a5,-1
  if(argint(0, &n)<0)  // read mask from user space
    800022ca:	02054a63          	bltz	a0,800022fe <sys_trace+0x4c>
  acquire(&tickslock);
    800022ce:	0000d517          	auipc	a0,0xd
    800022d2:	bb250513          	addi	a0,a0,-1102 # 8000ee80 <tickslock>
    800022d6:	00004097          	auipc	ra,0x4
    800022da:	f1c080e7          	jalr	-228(ra) # 800061f2 <acquire>
  myproc()->mask = n;  // update variable mask in proc structure to user value n 
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	bb4080e7          	jalr	-1100(ra) # 80000e92 <myproc>
    800022e6:	fec42783          	lw	a5,-20(s0)
    800022ea:	d95c                	sw	a5,52(a0)
  release(&tickslock);
    800022ec:	0000d517          	auipc	a0,0xd
    800022f0:	b9450513          	addi	a0,a0,-1132 # 8000ee80 <tickslock>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	fb2080e7          	jalr	-78(ra) # 800062a6 <release>

  return 0;
    800022fc:	4781                	li	a5,0
}
    800022fe:	853e                	mv	a0,a5
    80002300:	60e2                	ld	ra,24(sp)
    80002302:	6442                	ld	s0,16(sp)
    80002304:	6105                	addi	sp,sp,32
    80002306:	8082                	ret

0000000080002308 <sys_sysinfo>:

uint64
sys_sysinfo(void)    // *modified*
{
    80002308:	7139                	addi	sp,sp,-64
    8000230a:	fc06                	sd	ra,56(sp)
    8000230c:	f822                	sd	s0,48(sp)
    8000230e:	f426                	sd	s1,40(sp)
    80002310:	0080                	addi	s0,sp,64
  struct sysinfo info;
  struct proc *p = myproc();
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	b80080e7          	jalr	-1152(ra) # 80000e92 <myproc>
    8000231a:	84aa                	mv	s1,a0
  uint64 addr;   // user virtual address pointing to a struct sysinfo.

  if (argaddr(0, &addr) < 0)     // read user virtual address 
    8000231c:	fc840593          	addi	a1,s0,-56
    80002320:	4501                	li	a0,0
    80002322:	00000097          	auipc	ra,0x0
    80002326:	c9a080e7          	jalr	-870(ra) # 80001fbc <argaddr>
    return -1;
    8000232a:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0)     // read user virtual address 
    8000232c:	02054a63          	bltz	a0,80002360 <sys_sysinfo+0x58>

  info.freemem = freememory();  
    80002330:	ffffe097          	auipc	ra,0xffffe
    80002334:	e48080e7          	jalr	-440(ra) # 80000178 <freememory>
    80002338:	fca43823          	sd	a0,-48(s0)
  info.nproc = npproc();
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	718080e7          	jalr	1816(ra) # 80001a54 <npproc>
    80002344:	fca43c23          	sd	a0,-40(s0)

  if (copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)  // copy to user space
    80002348:	46c1                	li	a3,16
    8000234a:	fd040613          	addi	a2,s0,-48
    8000234e:	fc843583          	ld	a1,-56(s0)
    80002352:	68a8                	ld	a0,80(s1)
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	800080e7          	jalr	-2048(ra) # 80000b54 <copyout>
    8000235c:	43f55793          	srai	a5,a0,0x3f
    return -1;

  return 0;
    80002360:	853e                	mv	a0,a5
    80002362:	70e2                	ld	ra,56(sp)
    80002364:	7442                	ld	s0,48(sp)
    80002366:	74a2                	ld	s1,40(sp)
    80002368:	6121                	addi	sp,sp,64
    8000236a:	8082                	ret

000000008000236c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000236c:	7179                	addi	sp,sp,-48
    8000236e:	f406                	sd	ra,40(sp)
    80002370:	f022                	sd	s0,32(sp)
    80002372:	ec26                	sd	s1,24(sp)
    80002374:	e84a                	sd	s2,16(sp)
    80002376:	e44e                	sd	s3,8(sp)
    80002378:	e052                	sd	s4,0(sp)
    8000237a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000237c:	00006597          	auipc	a1,0x6
    80002380:	28c58593          	addi	a1,a1,652 # 80008608 <syscall_name+0xb8>
    80002384:	0000d517          	auipc	a0,0xd
    80002388:	b1450513          	addi	a0,a0,-1260 # 8000ee98 <bcache>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	dd6080e7          	jalr	-554(ra) # 80006162 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002394:	00015797          	auipc	a5,0x15
    80002398:	b0478793          	addi	a5,a5,-1276 # 80016e98 <bcache+0x8000>
    8000239c:	00015717          	auipc	a4,0x15
    800023a0:	d6470713          	addi	a4,a4,-668 # 80017100 <bcache+0x8268>
    800023a4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023a8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ac:	0000d497          	auipc	s1,0xd
    800023b0:	b0448493          	addi	s1,s1,-1276 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800023b4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023b6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023b8:	00006a17          	auipc	s4,0x6
    800023bc:	258a0a13          	addi	s4,s4,600 # 80008610 <syscall_name+0xc0>
    b->next = bcache.head.next;
    800023c0:	2b893783          	ld	a5,696(s2)
    800023c4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023c6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ca:	85d2                	mv	a1,s4
    800023cc:	01048513          	addi	a0,s1,16
    800023d0:	00001097          	auipc	ra,0x1
    800023d4:	4bc080e7          	jalr	1212(ra) # 8000388c <initsleeplock>
    bcache.head.next->prev = b;
    800023d8:	2b893783          	ld	a5,696(s2)
    800023dc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023de:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e2:	45848493          	addi	s1,s1,1112
    800023e6:	fd349de3          	bne	s1,s3,800023c0 <binit+0x54>
  }
}
    800023ea:	70a2                	ld	ra,40(sp)
    800023ec:	7402                	ld	s0,32(sp)
    800023ee:	64e2                	ld	s1,24(sp)
    800023f0:	6942                	ld	s2,16(sp)
    800023f2:	69a2                	ld	s3,8(sp)
    800023f4:	6a02                	ld	s4,0(sp)
    800023f6:	6145                	addi	sp,sp,48
    800023f8:	8082                	ret

00000000800023fa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023fa:	7179                	addi	sp,sp,-48
    800023fc:	f406                	sd	ra,40(sp)
    800023fe:	f022                	sd	s0,32(sp)
    80002400:	ec26                	sd	s1,24(sp)
    80002402:	e84a                	sd	s2,16(sp)
    80002404:	e44e                	sd	s3,8(sp)
    80002406:	1800                	addi	s0,sp,48
    80002408:	89aa                	mv	s3,a0
    8000240a:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000240c:	0000d517          	auipc	a0,0xd
    80002410:	a8c50513          	addi	a0,a0,-1396 # 8000ee98 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	dde080e7          	jalr	-546(ra) # 800061f2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000241c:	00015497          	auipc	s1,0x15
    80002420:	d344b483          	ld	s1,-716(s1) # 80017150 <bcache+0x82b8>
    80002424:	00015797          	auipc	a5,0x15
    80002428:	cdc78793          	addi	a5,a5,-804 # 80017100 <bcache+0x8268>
    8000242c:	02f48f63          	beq	s1,a5,8000246a <bread+0x70>
    80002430:	873e                	mv	a4,a5
    80002432:	a021                	j	8000243a <bread+0x40>
    80002434:	68a4                	ld	s1,80(s1)
    80002436:	02e48a63          	beq	s1,a4,8000246a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000243a:	449c                	lw	a5,8(s1)
    8000243c:	ff379ce3          	bne	a5,s3,80002434 <bread+0x3a>
    80002440:	44dc                	lw	a5,12(s1)
    80002442:	ff2799e3          	bne	a5,s2,80002434 <bread+0x3a>
      b->refcnt++;
    80002446:	40bc                	lw	a5,64(s1)
    80002448:	2785                	addiw	a5,a5,1
    8000244a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000244c:	0000d517          	auipc	a0,0xd
    80002450:	a4c50513          	addi	a0,a0,-1460 # 8000ee98 <bcache>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	e52080e7          	jalr	-430(ra) # 800062a6 <release>
      acquiresleep(&b->lock);
    8000245c:	01048513          	addi	a0,s1,16
    80002460:	00001097          	auipc	ra,0x1
    80002464:	466080e7          	jalr	1126(ra) # 800038c6 <acquiresleep>
      return b;
    80002468:	a8b9                	j	800024c6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246a:	00015497          	auipc	s1,0x15
    8000246e:	cde4b483          	ld	s1,-802(s1) # 80017148 <bcache+0x82b0>
    80002472:	00015797          	auipc	a5,0x15
    80002476:	c8e78793          	addi	a5,a5,-882 # 80017100 <bcache+0x8268>
    8000247a:	00f48863          	beq	s1,a5,8000248a <bread+0x90>
    8000247e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002480:	40bc                	lw	a5,64(s1)
    80002482:	cf81                	beqz	a5,8000249a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002484:	64a4                	ld	s1,72(s1)
    80002486:	fee49de3          	bne	s1,a4,80002480 <bread+0x86>
  panic("bget: no buffers");
    8000248a:	00006517          	auipc	a0,0x6
    8000248e:	18e50513          	addi	a0,a0,398 # 80008618 <syscall_name+0xc8>
    80002492:	00004097          	auipc	ra,0x4
    80002496:	816080e7          	jalr	-2026(ra) # 80005ca8 <panic>
      b->dev = dev;
    8000249a:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000249e:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024a2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024a6:	4785                	li	a5,1
    800024a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024aa:	0000d517          	auipc	a0,0xd
    800024ae:	9ee50513          	addi	a0,a0,-1554 # 8000ee98 <bcache>
    800024b2:	00004097          	auipc	ra,0x4
    800024b6:	df4080e7          	jalr	-524(ra) # 800062a6 <release>
      acquiresleep(&b->lock);
    800024ba:	01048513          	addi	a0,s1,16
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	408080e7          	jalr	1032(ra) # 800038c6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024c6:	409c                	lw	a5,0(s1)
    800024c8:	cb89                	beqz	a5,800024da <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ca:	8526                	mv	a0,s1
    800024cc:	70a2                	ld	ra,40(sp)
    800024ce:	7402                	ld	s0,32(sp)
    800024d0:	64e2                	ld	s1,24(sp)
    800024d2:	6942                	ld	s2,16(sp)
    800024d4:	69a2                	ld	s3,8(sp)
    800024d6:	6145                	addi	sp,sp,48
    800024d8:	8082                	ret
    virtio_disk_rw(b, 0);
    800024da:	4581                	li	a1,0
    800024dc:	8526                	mv	a0,s1
    800024de:	00003097          	auipc	ra,0x3
    800024e2:	f08080e7          	jalr	-248(ra) # 800053e6 <virtio_disk_rw>
    b->valid = 1;
    800024e6:	4785                	li	a5,1
    800024e8:	c09c                	sw	a5,0(s1)
  return b;
    800024ea:	b7c5                	j	800024ca <bread+0xd0>

00000000800024ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ec:	1101                	addi	sp,sp,-32
    800024ee:	ec06                	sd	ra,24(sp)
    800024f0:	e822                	sd	s0,16(sp)
    800024f2:	e426                	sd	s1,8(sp)
    800024f4:	1000                	addi	s0,sp,32
    800024f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f8:	0541                	addi	a0,a0,16
    800024fa:	00001097          	auipc	ra,0x1
    800024fe:	466080e7          	jalr	1126(ra) # 80003960 <holdingsleep>
    80002502:	cd01                	beqz	a0,8000251a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002504:	4585                	li	a1,1
    80002506:	8526                	mv	a0,s1
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	ede080e7          	jalr	-290(ra) # 800053e6 <virtio_disk_rw>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret
    panic("bwrite");
    8000251a:	00006517          	auipc	a0,0x6
    8000251e:	11650513          	addi	a0,a0,278 # 80008630 <syscall_name+0xe0>
    80002522:	00003097          	auipc	ra,0x3
    80002526:	786080e7          	jalr	1926(ra) # 80005ca8 <panic>

000000008000252a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000252a:	1101                	addi	sp,sp,-32
    8000252c:	ec06                	sd	ra,24(sp)
    8000252e:	e822                	sd	s0,16(sp)
    80002530:	e426                	sd	s1,8(sp)
    80002532:	e04a                	sd	s2,0(sp)
    80002534:	1000                	addi	s0,sp,32
    80002536:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002538:	01050913          	addi	s2,a0,16
    8000253c:	854a                	mv	a0,s2
    8000253e:	00001097          	auipc	ra,0x1
    80002542:	422080e7          	jalr	1058(ra) # 80003960 <holdingsleep>
    80002546:	c92d                	beqz	a0,800025b8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002548:	854a                	mv	a0,s2
    8000254a:	00001097          	auipc	ra,0x1
    8000254e:	3d2080e7          	jalr	978(ra) # 8000391c <releasesleep>

  acquire(&bcache.lock);
    80002552:	0000d517          	auipc	a0,0xd
    80002556:	94650513          	addi	a0,a0,-1722 # 8000ee98 <bcache>
    8000255a:	00004097          	auipc	ra,0x4
    8000255e:	c98080e7          	jalr	-872(ra) # 800061f2 <acquire>
  b->refcnt--;
    80002562:	40bc                	lw	a5,64(s1)
    80002564:	37fd                	addiw	a5,a5,-1
    80002566:	0007871b          	sext.w	a4,a5
    8000256a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000256c:	eb05                	bnez	a4,8000259c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000256e:	68bc                	ld	a5,80(s1)
    80002570:	64b8                	ld	a4,72(s1)
    80002572:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002574:	64bc                	ld	a5,72(s1)
    80002576:	68b8                	ld	a4,80(s1)
    80002578:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000257a:	00015797          	auipc	a5,0x15
    8000257e:	91e78793          	addi	a5,a5,-1762 # 80016e98 <bcache+0x8000>
    80002582:	2b87b703          	ld	a4,696(a5)
    80002586:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002588:	00015717          	auipc	a4,0x15
    8000258c:	b7870713          	addi	a4,a4,-1160 # 80017100 <bcache+0x8268>
    80002590:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002592:	2b87b703          	ld	a4,696(a5)
    80002596:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002598:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000259c:	0000d517          	auipc	a0,0xd
    800025a0:	8fc50513          	addi	a0,a0,-1796 # 8000ee98 <bcache>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	d02080e7          	jalr	-766(ra) # 800062a6 <release>
}
    800025ac:	60e2                	ld	ra,24(sp)
    800025ae:	6442                	ld	s0,16(sp)
    800025b0:	64a2                	ld	s1,8(sp)
    800025b2:	6902                	ld	s2,0(sp)
    800025b4:	6105                	addi	sp,sp,32
    800025b6:	8082                	ret
    panic("brelse");
    800025b8:	00006517          	auipc	a0,0x6
    800025bc:	08050513          	addi	a0,a0,128 # 80008638 <syscall_name+0xe8>
    800025c0:	00003097          	auipc	ra,0x3
    800025c4:	6e8080e7          	jalr	1768(ra) # 80005ca8 <panic>

00000000800025c8 <bpin>:

void
bpin(struct buf *b) {
    800025c8:	1101                	addi	sp,sp,-32
    800025ca:	ec06                	sd	ra,24(sp)
    800025cc:	e822                	sd	s0,16(sp)
    800025ce:	e426                	sd	s1,8(sp)
    800025d0:	1000                	addi	s0,sp,32
    800025d2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d4:	0000d517          	auipc	a0,0xd
    800025d8:	8c450513          	addi	a0,a0,-1852 # 8000ee98 <bcache>
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	c16080e7          	jalr	-1002(ra) # 800061f2 <acquire>
  b->refcnt++;
    800025e4:	40bc                	lw	a5,64(s1)
    800025e6:	2785                	addiw	a5,a5,1
    800025e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ea:	0000d517          	auipc	a0,0xd
    800025ee:	8ae50513          	addi	a0,a0,-1874 # 8000ee98 <bcache>
    800025f2:	00004097          	auipc	ra,0x4
    800025f6:	cb4080e7          	jalr	-844(ra) # 800062a6 <release>
}
    800025fa:	60e2                	ld	ra,24(sp)
    800025fc:	6442                	ld	s0,16(sp)
    800025fe:	64a2                	ld	s1,8(sp)
    80002600:	6105                	addi	sp,sp,32
    80002602:	8082                	ret

0000000080002604 <bunpin>:

void
bunpin(struct buf *b) {
    80002604:	1101                	addi	sp,sp,-32
    80002606:	ec06                	sd	ra,24(sp)
    80002608:	e822                	sd	s0,16(sp)
    8000260a:	e426                	sd	s1,8(sp)
    8000260c:	1000                	addi	s0,sp,32
    8000260e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002610:	0000d517          	auipc	a0,0xd
    80002614:	88850513          	addi	a0,a0,-1912 # 8000ee98 <bcache>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	bda080e7          	jalr	-1062(ra) # 800061f2 <acquire>
  b->refcnt--;
    80002620:	40bc                	lw	a5,64(s1)
    80002622:	37fd                	addiw	a5,a5,-1
    80002624:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002626:	0000d517          	auipc	a0,0xd
    8000262a:	87250513          	addi	a0,a0,-1934 # 8000ee98 <bcache>
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	c78080e7          	jalr	-904(ra) # 800062a6 <release>
}
    80002636:	60e2                	ld	ra,24(sp)
    80002638:	6442                	ld	s0,16(sp)
    8000263a:	64a2                	ld	s1,8(sp)
    8000263c:	6105                	addi	sp,sp,32
    8000263e:	8082                	ret

0000000080002640 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002640:	1101                	addi	sp,sp,-32
    80002642:	ec06                	sd	ra,24(sp)
    80002644:	e822                	sd	s0,16(sp)
    80002646:	e426                	sd	s1,8(sp)
    80002648:	e04a                	sd	s2,0(sp)
    8000264a:	1000                	addi	s0,sp,32
    8000264c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000264e:	00d5d59b          	srliw	a1,a1,0xd
    80002652:	00015797          	auipc	a5,0x15
    80002656:	f227a783          	lw	a5,-222(a5) # 80017574 <sb+0x1c>
    8000265a:	9dbd                	addw	a1,a1,a5
    8000265c:	00000097          	auipc	ra,0x0
    80002660:	d9e080e7          	jalr	-610(ra) # 800023fa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002664:	0074f713          	andi	a4,s1,7
    80002668:	4785                	li	a5,1
    8000266a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000266e:	14ce                	slli	s1,s1,0x33
    80002670:	90d9                	srli	s1,s1,0x36
    80002672:	00950733          	add	a4,a0,s1
    80002676:	05874703          	lbu	a4,88(a4)
    8000267a:	00e7f6b3          	and	a3,a5,a4
    8000267e:	c69d                	beqz	a3,800026ac <bfree+0x6c>
    80002680:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002682:	94aa                	add	s1,s1,a0
    80002684:	fff7c793          	not	a5,a5
    80002688:	8ff9                	and	a5,a5,a4
    8000268a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000268e:	00001097          	auipc	ra,0x1
    80002692:	118080e7          	jalr	280(ra) # 800037a6 <log_write>
  brelse(bp);
    80002696:	854a                	mv	a0,s2
    80002698:	00000097          	auipc	ra,0x0
    8000269c:	e92080e7          	jalr	-366(ra) # 8000252a <brelse>
}
    800026a0:	60e2                	ld	ra,24(sp)
    800026a2:	6442                	ld	s0,16(sp)
    800026a4:	64a2                	ld	s1,8(sp)
    800026a6:	6902                	ld	s2,0(sp)
    800026a8:	6105                	addi	sp,sp,32
    800026aa:	8082                	ret
    panic("freeing free block");
    800026ac:	00006517          	auipc	a0,0x6
    800026b0:	f9450513          	addi	a0,a0,-108 # 80008640 <syscall_name+0xf0>
    800026b4:	00003097          	auipc	ra,0x3
    800026b8:	5f4080e7          	jalr	1524(ra) # 80005ca8 <panic>

00000000800026bc <balloc>:
{
    800026bc:	711d                	addi	sp,sp,-96
    800026be:	ec86                	sd	ra,88(sp)
    800026c0:	e8a2                	sd	s0,80(sp)
    800026c2:	e4a6                	sd	s1,72(sp)
    800026c4:	e0ca                	sd	s2,64(sp)
    800026c6:	fc4e                	sd	s3,56(sp)
    800026c8:	f852                	sd	s4,48(sp)
    800026ca:	f456                	sd	s5,40(sp)
    800026cc:	f05a                	sd	s6,32(sp)
    800026ce:	ec5e                	sd	s7,24(sp)
    800026d0:	e862                	sd	s8,16(sp)
    800026d2:	e466                	sd	s9,8(sp)
    800026d4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026d6:	00015797          	auipc	a5,0x15
    800026da:	e867a783          	lw	a5,-378(a5) # 8001755c <sb+0x4>
    800026de:	cbd1                	beqz	a5,80002772 <balloc+0xb6>
    800026e0:	8baa                	mv	s7,a0
    800026e2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026e4:	00015b17          	auipc	s6,0x15
    800026e8:	e74b0b13          	addi	s6,s6,-396 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ec:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026ee:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026f2:	6c89                	lui	s9,0x2
    800026f4:	a831                	j	80002710 <balloc+0x54>
    brelse(bp);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	e32080e7          	jalr	-462(ra) # 8000252a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002700:	015c87bb          	addw	a5,s9,s5
    80002704:	00078a9b          	sext.w	s5,a5
    80002708:	004b2703          	lw	a4,4(s6)
    8000270c:	06eaf363          	bgeu	s5,a4,80002772 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002710:	41fad79b          	sraiw	a5,s5,0x1f
    80002714:	0137d79b          	srliw	a5,a5,0x13
    80002718:	015787bb          	addw	a5,a5,s5
    8000271c:	40d7d79b          	sraiw	a5,a5,0xd
    80002720:	01cb2583          	lw	a1,28(s6)
    80002724:	9dbd                	addw	a1,a1,a5
    80002726:	855e                	mv	a0,s7
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	cd2080e7          	jalr	-814(ra) # 800023fa <bread>
    80002730:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002732:	004b2503          	lw	a0,4(s6)
    80002736:	000a849b          	sext.w	s1,s5
    8000273a:	8662                	mv	a2,s8
    8000273c:	faa4fde3          	bgeu	s1,a0,800026f6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002740:	41f6579b          	sraiw	a5,a2,0x1f
    80002744:	01d7d69b          	srliw	a3,a5,0x1d
    80002748:	00c6873b          	addw	a4,a3,a2
    8000274c:	00777793          	andi	a5,a4,7
    80002750:	9f95                	subw	a5,a5,a3
    80002752:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002756:	4037571b          	sraiw	a4,a4,0x3
    8000275a:	00e906b3          	add	a3,s2,a4
    8000275e:	0586c683          	lbu	a3,88(a3)
    80002762:	00d7f5b3          	and	a1,a5,a3
    80002766:	cd91                	beqz	a1,80002782 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002768:	2605                	addiw	a2,a2,1
    8000276a:	2485                	addiw	s1,s1,1
    8000276c:	fd4618e3          	bne	a2,s4,8000273c <balloc+0x80>
    80002770:	b759                	j	800026f6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002772:	00006517          	auipc	a0,0x6
    80002776:	ee650513          	addi	a0,a0,-282 # 80008658 <syscall_name+0x108>
    8000277a:	00003097          	auipc	ra,0x3
    8000277e:	52e080e7          	jalr	1326(ra) # 80005ca8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002782:	974a                	add	a4,a4,s2
    80002784:	8fd5                	or	a5,a5,a3
    80002786:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000278a:	854a                	mv	a0,s2
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	01a080e7          	jalr	26(ra) # 800037a6 <log_write>
        brelse(bp);
    80002794:	854a                	mv	a0,s2
    80002796:	00000097          	auipc	ra,0x0
    8000279a:	d94080e7          	jalr	-620(ra) # 8000252a <brelse>
  bp = bread(dev, bno);
    8000279e:	85a6                	mv	a1,s1
    800027a0:	855e                	mv	a0,s7
    800027a2:	00000097          	auipc	ra,0x0
    800027a6:	c58080e7          	jalr	-936(ra) # 800023fa <bread>
    800027aa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027ac:	40000613          	li	a2,1024
    800027b0:	4581                	li	a1,0
    800027b2:	05850513          	addi	a0,a0,88
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	a0c080e7          	jalr	-1524(ra) # 800001c2 <memset>
  log_write(bp);
    800027be:	854a                	mv	a0,s2
    800027c0:	00001097          	auipc	ra,0x1
    800027c4:	fe6080e7          	jalr	-26(ra) # 800037a6 <log_write>
  brelse(bp);
    800027c8:	854a                	mv	a0,s2
    800027ca:	00000097          	auipc	ra,0x0
    800027ce:	d60080e7          	jalr	-672(ra) # 8000252a <brelse>
}
    800027d2:	8526                	mv	a0,s1
    800027d4:	60e6                	ld	ra,88(sp)
    800027d6:	6446                	ld	s0,80(sp)
    800027d8:	64a6                	ld	s1,72(sp)
    800027da:	6906                	ld	s2,64(sp)
    800027dc:	79e2                	ld	s3,56(sp)
    800027de:	7a42                	ld	s4,48(sp)
    800027e0:	7aa2                	ld	s5,40(sp)
    800027e2:	7b02                	ld	s6,32(sp)
    800027e4:	6be2                	ld	s7,24(sp)
    800027e6:	6c42                	ld	s8,16(sp)
    800027e8:	6ca2                	ld	s9,8(sp)
    800027ea:	6125                	addi	sp,sp,96
    800027ec:	8082                	ret

00000000800027ee <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ee:	7179                	addi	sp,sp,-48
    800027f0:	f406                	sd	ra,40(sp)
    800027f2:	f022                	sd	s0,32(sp)
    800027f4:	ec26                	sd	s1,24(sp)
    800027f6:	e84a                	sd	s2,16(sp)
    800027f8:	e44e                	sd	s3,8(sp)
    800027fa:	e052                	sd	s4,0(sp)
    800027fc:	1800                	addi	s0,sp,48
    800027fe:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002800:	47ad                	li	a5,11
    80002802:	04b7fe63          	bgeu	a5,a1,8000285e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002806:	ff45849b          	addiw	s1,a1,-12
    8000280a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000280e:	0ff00793          	li	a5,255
    80002812:	0ae7e363          	bltu	a5,a4,800028b8 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002816:	08052583          	lw	a1,128(a0)
    8000281a:	c5ad                	beqz	a1,80002884 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000281c:	00092503          	lw	a0,0(s2)
    80002820:	00000097          	auipc	ra,0x0
    80002824:	bda080e7          	jalr	-1062(ra) # 800023fa <bread>
    80002828:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000282a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000282e:	02049593          	slli	a1,s1,0x20
    80002832:	9181                	srli	a1,a1,0x20
    80002834:	058a                	slli	a1,a1,0x2
    80002836:	00b784b3          	add	s1,a5,a1
    8000283a:	0004a983          	lw	s3,0(s1)
    8000283e:	04098d63          	beqz	s3,80002898 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002842:	8552                	mv	a0,s4
    80002844:	00000097          	auipc	ra,0x0
    80002848:	ce6080e7          	jalr	-794(ra) # 8000252a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000284c:	854e                	mv	a0,s3
    8000284e:	70a2                	ld	ra,40(sp)
    80002850:	7402                	ld	s0,32(sp)
    80002852:	64e2                	ld	s1,24(sp)
    80002854:	6942                	ld	s2,16(sp)
    80002856:	69a2                	ld	s3,8(sp)
    80002858:	6a02                	ld	s4,0(sp)
    8000285a:	6145                	addi	sp,sp,48
    8000285c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000285e:	02059493          	slli	s1,a1,0x20
    80002862:	9081                	srli	s1,s1,0x20
    80002864:	048a                	slli	s1,s1,0x2
    80002866:	94aa                	add	s1,s1,a0
    80002868:	0504a983          	lw	s3,80(s1)
    8000286c:	fe0990e3          	bnez	s3,8000284c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002870:	4108                	lw	a0,0(a0)
    80002872:	00000097          	auipc	ra,0x0
    80002876:	e4a080e7          	jalr	-438(ra) # 800026bc <balloc>
    8000287a:	0005099b          	sext.w	s3,a0
    8000287e:	0534a823          	sw	s3,80(s1)
    80002882:	b7e9                	j	8000284c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002884:	4108                	lw	a0,0(a0)
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	e36080e7          	jalr	-458(ra) # 800026bc <balloc>
    8000288e:	0005059b          	sext.w	a1,a0
    80002892:	08b92023          	sw	a1,128(s2)
    80002896:	b759                	j	8000281c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002898:	00092503          	lw	a0,0(s2)
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	e20080e7          	jalr	-480(ra) # 800026bc <balloc>
    800028a4:	0005099b          	sext.w	s3,a0
    800028a8:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028ac:	8552                	mv	a0,s4
    800028ae:	00001097          	auipc	ra,0x1
    800028b2:	ef8080e7          	jalr	-264(ra) # 800037a6 <log_write>
    800028b6:	b771                	j	80002842 <bmap+0x54>
  panic("bmap: out of range");
    800028b8:	00006517          	auipc	a0,0x6
    800028bc:	db850513          	addi	a0,a0,-584 # 80008670 <syscall_name+0x120>
    800028c0:	00003097          	auipc	ra,0x3
    800028c4:	3e8080e7          	jalr	1000(ra) # 80005ca8 <panic>

00000000800028c8 <iget>:
{
    800028c8:	7179                	addi	sp,sp,-48
    800028ca:	f406                	sd	ra,40(sp)
    800028cc:	f022                	sd	s0,32(sp)
    800028ce:	ec26                	sd	s1,24(sp)
    800028d0:	e84a                	sd	s2,16(sp)
    800028d2:	e44e                	sd	s3,8(sp)
    800028d4:	e052                	sd	s4,0(sp)
    800028d6:	1800                	addi	s0,sp,48
    800028d8:	89aa                	mv	s3,a0
    800028da:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028dc:	00015517          	auipc	a0,0x15
    800028e0:	c9c50513          	addi	a0,a0,-868 # 80017578 <itable>
    800028e4:	00004097          	auipc	ra,0x4
    800028e8:	90e080e7          	jalr	-1778(ra) # 800061f2 <acquire>
  empty = 0;
    800028ec:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ee:	00015497          	auipc	s1,0x15
    800028f2:	ca248493          	addi	s1,s1,-862 # 80017590 <itable+0x18>
    800028f6:	00016697          	auipc	a3,0x16
    800028fa:	72a68693          	addi	a3,a3,1834 # 80019020 <log>
    800028fe:	a039                	j	8000290c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002900:	02090b63          	beqz	s2,80002936 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002904:	08848493          	addi	s1,s1,136
    80002908:	02d48a63          	beq	s1,a3,8000293c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000290c:	449c                	lw	a5,8(s1)
    8000290e:	fef059e3          	blez	a5,80002900 <iget+0x38>
    80002912:	4098                	lw	a4,0(s1)
    80002914:	ff3716e3          	bne	a4,s3,80002900 <iget+0x38>
    80002918:	40d8                	lw	a4,4(s1)
    8000291a:	ff4713e3          	bne	a4,s4,80002900 <iget+0x38>
      ip->ref++;
    8000291e:	2785                	addiw	a5,a5,1
    80002920:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002922:	00015517          	auipc	a0,0x15
    80002926:	c5650513          	addi	a0,a0,-938 # 80017578 <itable>
    8000292a:	00004097          	auipc	ra,0x4
    8000292e:	97c080e7          	jalr	-1668(ra) # 800062a6 <release>
      return ip;
    80002932:	8926                	mv	s2,s1
    80002934:	a03d                	j	80002962 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002936:	f7f9                	bnez	a5,80002904 <iget+0x3c>
    80002938:	8926                	mv	s2,s1
    8000293a:	b7e9                	j	80002904 <iget+0x3c>
  if(empty == 0)
    8000293c:	02090c63          	beqz	s2,80002974 <iget+0xac>
  ip->dev = dev;
    80002940:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002944:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002948:	4785                	li	a5,1
    8000294a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000294e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002952:	00015517          	auipc	a0,0x15
    80002956:	c2650513          	addi	a0,a0,-986 # 80017578 <itable>
    8000295a:	00004097          	auipc	ra,0x4
    8000295e:	94c080e7          	jalr	-1716(ra) # 800062a6 <release>
}
    80002962:	854a                	mv	a0,s2
    80002964:	70a2                	ld	ra,40(sp)
    80002966:	7402                	ld	s0,32(sp)
    80002968:	64e2                	ld	s1,24(sp)
    8000296a:	6942                	ld	s2,16(sp)
    8000296c:	69a2                	ld	s3,8(sp)
    8000296e:	6a02                	ld	s4,0(sp)
    80002970:	6145                	addi	sp,sp,48
    80002972:	8082                	ret
    panic("iget: no inodes");
    80002974:	00006517          	auipc	a0,0x6
    80002978:	d1450513          	addi	a0,a0,-748 # 80008688 <syscall_name+0x138>
    8000297c:	00003097          	auipc	ra,0x3
    80002980:	32c080e7          	jalr	812(ra) # 80005ca8 <panic>

0000000080002984 <fsinit>:
fsinit(int dev) {
    80002984:	7179                	addi	sp,sp,-48
    80002986:	f406                	sd	ra,40(sp)
    80002988:	f022                	sd	s0,32(sp)
    8000298a:	ec26                	sd	s1,24(sp)
    8000298c:	e84a                	sd	s2,16(sp)
    8000298e:	e44e                	sd	s3,8(sp)
    80002990:	1800                	addi	s0,sp,48
    80002992:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002994:	4585                	li	a1,1
    80002996:	00000097          	auipc	ra,0x0
    8000299a:	a64080e7          	jalr	-1436(ra) # 800023fa <bread>
    8000299e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029a0:	00015997          	auipc	s3,0x15
    800029a4:	bb898993          	addi	s3,s3,-1096 # 80017558 <sb>
    800029a8:	02000613          	li	a2,32
    800029ac:	05850593          	addi	a1,a0,88
    800029b0:	854e                	mv	a0,s3
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	870080e7          	jalr	-1936(ra) # 80000222 <memmove>
  brelse(bp);
    800029ba:	8526                	mv	a0,s1
    800029bc:	00000097          	auipc	ra,0x0
    800029c0:	b6e080e7          	jalr	-1170(ra) # 8000252a <brelse>
  if(sb.magic != FSMAGIC)
    800029c4:	0009a703          	lw	a4,0(s3)
    800029c8:	102037b7          	lui	a5,0x10203
    800029cc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029d0:	02f71263          	bne	a4,a5,800029f4 <fsinit+0x70>
  initlog(dev, &sb);
    800029d4:	00015597          	auipc	a1,0x15
    800029d8:	b8458593          	addi	a1,a1,-1148 # 80017558 <sb>
    800029dc:	854a                	mv	a0,s2
    800029de:	00001097          	auipc	ra,0x1
    800029e2:	b4c080e7          	jalr	-1204(ra) # 8000352a <initlog>
}
    800029e6:	70a2                	ld	ra,40(sp)
    800029e8:	7402                	ld	s0,32(sp)
    800029ea:	64e2                	ld	s1,24(sp)
    800029ec:	6942                	ld	s2,16(sp)
    800029ee:	69a2                	ld	s3,8(sp)
    800029f0:	6145                	addi	sp,sp,48
    800029f2:	8082                	ret
    panic("invalid file system");
    800029f4:	00006517          	auipc	a0,0x6
    800029f8:	ca450513          	addi	a0,a0,-860 # 80008698 <syscall_name+0x148>
    800029fc:	00003097          	auipc	ra,0x3
    80002a00:	2ac080e7          	jalr	684(ra) # 80005ca8 <panic>

0000000080002a04 <iinit>:
{
    80002a04:	7179                	addi	sp,sp,-48
    80002a06:	f406                	sd	ra,40(sp)
    80002a08:	f022                	sd	s0,32(sp)
    80002a0a:	ec26                	sd	s1,24(sp)
    80002a0c:	e84a                	sd	s2,16(sp)
    80002a0e:	e44e                	sd	s3,8(sp)
    80002a10:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a12:	00006597          	auipc	a1,0x6
    80002a16:	c9e58593          	addi	a1,a1,-866 # 800086b0 <syscall_name+0x160>
    80002a1a:	00015517          	auipc	a0,0x15
    80002a1e:	b5e50513          	addi	a0,a0,-1186 # 80017578 <itable>
    80002a22:	00003097          	auipc	ra,0x3
    80002a26:	740080e7          	jalr	1856(ra) # 80006162 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a2a:	00015497          	auipc	s1,0x15
    80002a2e:	b7648493          	addi	s1,s1,-1162 # 800175a0 <itable+0x28>
    80002a32:	00016997          	auipc	s3,0x16
    80002a36:	5fe98993          	addi	s3,s3,1534 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a3a:	00006917          	auipc	s2,0x6
    80002a3e:	c7e90913          	addi	s2,s2,-898 # 800086b8 <syscall_name+0x168>
    80002a42:	85ca                	mv	a1,s2
    80002a44:	8526                	mv	a0,s1
    80002a46:	00001097          	auipc	ra,0x1
    80002a4a:	e46080e7          	jalr	-442(ra) # 8000388c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a4e:	08848493          	addi	s1,s1,136
    80002a52:	ff3498e3          	bne	s1,s3,80002a42 <iinit+0x3e>
}
    80002a56:	70a2                	ld	ra,40(sp)
    80002a58:	7402                	ld	s0,32(sp)
    80002a5a:	64e2                	ld	s1,24(sp)
    80002a5c:	6942                	ld	s2,16(sp)
    80002a5e:	69a2                	ld	s3,8(sp)
    80002a60:	6145                	addi	sp,sp,48
    80002a62:	8082                	ret

0000000080002a64 <ialloc>:
{
    80002a64:	715d                	addi	sp,sp,-80
    80002a66:	e486                	sd	ra,72(sp)
    80002a68:	e0a2                	sd	s0,64(sp)
    80002a6a:	fc26                	sd	s1,56(sp)
    80002a6c:	f84a                	sd	s2,48(sp)
    80002a6e:	f44e                	sd	s3,40(sp)
    80002a70:	f052                	sd	s4,32(sp)
    80002a72:	ec56                	sd	s5,24(sp)
    80002a74:	e85a                	sd	s6,16(sp)
    80002a76:	e45e                	sd	s7,8(sp)
    80002a78:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a7a:	00015717          	auipc	a4,0x15
    80002a7e:	aea72703          	lw	a4,-1302(a4) # 80017564 <sb+0xc>
    80002a82:	4785                	li	a5,1
    80002a84:	04e7fa63          	bgeu	a5,a4,80002ad8 <ialloc+0x74>
    80002a88:	8aaa                	mv	s5,a0
    80002a8a:	8bae                	mv	s7,a1
    80002a8c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a8e:	00015a17          	auipc	s4,0x15
    80002a92:	acaa0a13          	addi	s4,s4,-1334 # 80017558 <sb>
    80002a96:	00048b1b          	sext.w	s6,s1
    80002a9a:	0044d593          	srli	a1,s1,0x4
    80002a9e:	018a2783          	lw	a5,24(s4)
    80002aa2:	9dbd                	addw	a1,a1,a5
    80002aa4:	8556                	mv	a0,s5
    80002aa6:	00000097          	auipc	ra,0x0
    80002aaa:	954080e7          	jalr	-1708(ra) # 800023fa <bread>
    80002aae:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ab0:	05850993          	addi	s3,a0,88
    80002ab4:	00f4f793          	andi	a5,s1,15
    80002ab8:	079a                	slli	a5,a5,0x6
    80002aba:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002abc:	00099783          	lh	a5,0(s3)
    80002ac0:	c785                	beqz	a5,80002ae8 <ialloc+0x84>
    brelse(bp);
    80002ac2:	00000097          	auipc	ra,0x0
    80002ac6:	a68080e7          	jalr	-1432(ra) # 8000252a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aca:	0485                	addi	s1,s1,1
    80002acc:	00ca2703          	lw	a4,12(s4)
    80002ad0:	0004879b          	sext.w	a5,s1
    80002ad4:	fce7e1e3          	bltu	a5,a4,80002a96 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ad8:	00006517          	auipc	a0,0x6
    80002adc:	be850513          	addi	a0,a0,-1048 # 800086c0 <syscall_name+0x170>
    80002ae0:	00003097          	auipc	ra,0x3
    80002ae4:	1c8080e7          	jalr	456(ra) # 80005ca8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ae8:	04000613          	li	a2,64
    80002aec:	4581                	li	a1,0
    80002aee:	854e                	mv	a0,s3
    80002af0:	ffffd097          	auipc	ra,0xffffd
    80002af4:	6d2080e7          	jalr	1746(ra) # 800001c2 <memset>
      dip->type = type;
    80002af8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002afc:	854a                	mv	a0,s2
    80002afe:	00001097          	auipc	ra,0x1
    80002b02:	ca8080e7          	jalr	-856(ra) # 800037a6 <log_write>
      brelse(bp);
    80002b06:	854a                	mv	a0,s2
    80002b08:	00000097          	auipc	ra,0x0
    80002b0c:	a22080e7          	jalr	-1502(ra) # 8000252a <brelse>
      return iget(dev, inum);
    80002b10:	85da                	mv	a1,s6
    80002b12:	8556                	mv	a0,s5
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	db4080e7          	jalr	-588(ra) # 800028c8 <iget>
}
    80002b1c:	60a6                	ld	ra,72(sp)
    80002b1e:	6406                	ld	s0,64(sp)
    80002b20:	74e2                	ld	s1,56(sp)
    80002b22:	7942                	ld	s2,48(sp)
    80002b24:	79a2                	ld	s3,40(sp)
    80002b26:	7a02                	ld	s4,32(sp)
    80002b28:	6ae2                	ld	s5,24(sp)
    80002b2a:	6b42                	ld	s6,16(sp)
    80002b2c:	6ba2                	ld	s7,8(sp)
    80002b2e:	6161                	addi	sp,sp,80
    80002b30:	8082                	ret

0000000080002b32 <iupdate>:
{
    80002b32:	1101                	addi	sp,sp,-32
    80002b34:	ec06                	sd	ra,24(sp)
    80002b36:	e822                	sd	s0,16(sp)
    80002b38:	e426                	sd	s1,8(sp)
    80002b3a:	e04a                	sd	s2,0(sp)
    80002b3c:	1000                	addi	s0,sp,32
    80002b3e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b40:	415c                	lw	a5,4(a0)
    80002b42:	0047d79b          	srliw	a5,a5,0x4
    80002b46:	00015597          	auipc	a1,0x15
    80002b4a:	a2a5a583          	lw	a1,-1494(a1) # 80017570 <sb+0x18>
    80002b4e:	9dbd                	addw	a1,a1,a5
    80002b50:	4108                	lw	a0,0(a0)
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	8a8080e7          	jalr	-1880(ra) # 800023fa <bread>
    80002b5a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b5c:	05850793          	addi	a5,a0,88
    80002b60:	40c8                	lw	a0,4(s1)
    80002b62:	893d                	andi	a0,a0,15
    80002b64:	051a                	slli	a0,a0,0x6
    80002b66:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b68:	04449703          	lh	a4,68(s1)
    80002b6c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b70:	04649703          	lh	a4,70(s1)
    80002b74:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b78:	04849703          	lh	a4,72(s1)
    80002b7c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b80:	04a49703          	lh	a4,74(s1)
    80002b84:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b88:	44f8                	lw	a4,76(s1)
    80002b8a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b8c:	03400613          	li	a2,52
    80002b90:	05048593          	addi	a1,s1,80
    80002b94:	0531                	addi	a0,a0,12
    80002b96:	ffffd097          	auipc	ra,0xffffd
    80002b9a:	68c080e7          	jalr	1676(ra) # 80000222 <memmove>
  log_write(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	00001097          	auipc	ra,0x1
    80002ba4:	c06080e7          	jalr	-1018(ra) # 800037a6 <log_write>
  brelse(bp);
    80002ba8:	854a                	mv	a0,s2
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	980080e7          	jalr	-1664(ra) # 8000252a <brelse>
}
    80002bb2:	60e2                	ld	ra,24(sp)
    80002bb4:	6442                	ld	s0,16(sp)
    80002bb6:	64a2                	ld	s1,8(sp)
    80002bb8:	6902                	ld	s2,0(sp)
    80002bba:	6105                	addi	sp,sp,32
    80002bbc:	8082                	ret

0000000080002bbe <idup>:
{
    80002bbe:	1101                	addi	sp,sp,-32
    80002bc0:	ec06                	sd	ra,24(sp)
    80002bc2:	e822                	sd	s0,16(sp)
    80002bc4:	e426                	sd	s1,8(sp)
    80002bc6:	1000                	addi	s0,sp,32
    80002bc8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bca:	00015517          	auipc	a0,0x15
    80002bce:	9ae50513          	addi	a0,a0,-1618 # 80017578 <itable>
    80002bd2:	00003097          	auipc	ra,0x3
    80002bd6:	620080e7          	jalr	1568(ra) # 800061f2 <acquire>
  ip->ref++;
    80002bda:	449c                	lw	a5,8(s1)
    80002bdc:	2785                	addiw	a5,a5,1
    80002bde:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002be0:	00015517          	auipc	a0,0x15
    80002be4:	99850513          	addi	a0,a0,-1640 # 80017578 <itable>
    80002be8:	00003097          	auipc	ra,0x3
    80002bec:	6be080e7          	jalr	1726(ra) # 800062a6 <release>
}
    80002bf0:	8526                	mv	a0,s1
    80002bf2:	60e2                	ld	ra,24(sp)
    80002bf4:	6442                	ld	s0,16(sp)
    80002bf6:	64a2                	ld	s1,8(sp)
    80002bf8:	6105                	addi	sp,sp,32
    80002bfa:	8082                	ret

0000000080002bfc <ilock>:
{
    80002bfc:	1101                	addi	sp,sp,-32
    80002bfe:	ec06                	sd	ra,24(sp)
    80002c00:	e822                	sd	s0,16(sp)
    80002c02:	e426                	sd	s1,8(sp)
    80002c04:	e04a                	sd	s2,0(sp)
    80002c06:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c08:	c115                	beqz	a0,80002c2c <ilock+0x30>
    80002c0a:	84aa                	mv	s1,a0
    80002c0c:	451c                	lw	a5,8(a0)
    80002c0e:	00f05f63          	blez	a5,80002c2c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c12:	0541                	addi	a0,a0,16
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	cb2080e7          	jalr	-846(ra) # 800038c6 <acquiresleep>
  if(ip->valid == 0){
    80002c1c:	40bc                	lw	a5,64(s1)
    80002c1e:	cf99                	beqz	a5,80002c3c <ilock+0x40>
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6902                	ld	s2,0(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret
    panic("ilock");
    80002c2c:	00006517          	auipc	a0,0x6
    80002c30:	aac50513          	addi	a0,a0,-1364 # 800086d8 <syscall_name+0x188>
    80002c34:	00003097          	auipc	ra,0x3
    80002c38:	074080e7          	jalr	116(ra) # 80005ca8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c3c:	40dc                	lw	a5,4(s1)
    80002c3e:	0047d79b          	srliw	a5,a5,0x4
    80002c42:	00015597          	auipc	a1,0x15
    80002c46:	92e5a583          	lw	a1,-1746(a1) # 80017570 <sb+0x18>
    80002c4a:	9dbd                	addw	a1,a1,a5
    80002c4c:	4088                	lw	a0,0(s1)
    80002c4e:	fffff097          	auipc	ra,0xfffff
    80002c52:	7ac080e7          	jalr	1964(ra) # 800023fa <bread>
    80002c56:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c58:	05850593          	addi	a1,a0,88
    80002c5c:	40dc                	lw	a5,4(s1)
    80002c5e:	8bbd                	andi	a5,a5,15
    80002c60:	079a                	slli	a5,a5,0x6
    80002c62:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c64:	00059783          	lh	a5,0(a1)
    80002c68:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c6c:	00259783          	lh	a5,2(a1)
    80002c70:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c74:	00459783          	lh	a5,4(a1)
    80002c78:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c7c:	00659783          	lh	a5,6(a1)
    80002c80:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c84:	459c                	lw	a5,8(a1)
    80002c86:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c88:	03400613          	li	a2,52
    80002c8c:	05b1                	addi	a1,a1,12
    80002c8e:	05048513          	addi	a0,s1,80
    80002c92:	ffffd097          	auipc	ra,0xffffd
    80002c96:	590080e7          	jalr	1424(ra) # 80000222 <memmove>
    brelse(bp);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	88e080e7          	jalr	-1906(ra) # 8000252a <brelse>
    ip->valid = 1;
    80002ca4:	4785                	li	a5,1
    80002ca6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ca8:	04449783          	lh	a5,68(s1)
    80002cac:	fbb5                	bnez	a5,80002c20 <ilock+0x24>
      panic("ilock: no type");
    80002cae:	00006517          	auipc	a0,0x6
    80002cb2:	a3250513          	addi	a0,a0,-1486 # 800086e0 <syscall_name+0x190>
    80002cb6:	00003097          	auipc	ra,0x3
    80002cba:	ff2080e7          	jalr	-14(ra) # 80005ca8 <panic>

0000000080002cbe <iunlock>:
{
    80002cbe:	1101                	addi	sp,sp,-32
    80002cc0:	ec06                	sd	ra,24(sp)
    80002cc2:	e822                	sd	s0,16(sp)
    80002cc4:	e426                	sd	s1,8(sp)
    80002cc6:	e04a                	sd	s2,0(sp)
    80002cc8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cca:	c905                	beqz	a0,80002cfa <iunlock+0x3c>
    80002ccc:	84aa                	mv	s1,a0
    80002cce:	01050913          	addi	s2,a0,16
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	c8c080e7          	jalr	-884(ra) # 80003960 <holdingsleep>
    80002cdc:	cd19                	beqz	a0,80002cfa <iunlock+0x3c>
    80002cde:	449c                	lw	a5,8(s1)
    80002ce0:	00f05d63          	blez	a5,80002cfa <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ce4:	854a                	mv	a0,s2
    80002ce6:	00001097          	auipc	ra,0x1
    80002cea:	c36080e7          	jalr	-970(ra) # 8000391c <releasesleep>
}
    80002cee:	60e2                	ld	ra,24(sp)
    80002cf0:	6442                	ld	s0,16(sp)
    80002cf2:	64a2                	ld	s1,8(sp)
    80002cf4:	6902                	ld	s2,0(sp)
    80002cf6:	6105                	addi	sp,sp,32
    80002cf8:	8082                	ret
    panic("iunlock");
    80002cfa:	00006517          	auipc	a0,0x6
    80002cfe:	9f650513          	addi	a0,a0,-1546 # 800086f0 <syscall_name+0x1a0>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	fa6080e7          	jalr	-90(ra) # 80005ca8 <panic>

0000000080002d0a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d0a:	7179                	addi	sp,sp,-48
    80002d0c:	f406                	sd	ra,40(sp)
    80002d0e:	f022                	sd	s0,32(sp)
    80002d10:	ec26                	sd	s1,24(sp)
    80002d12:	e84a                	sd	s2,16(sp)
    80002d14:	e44e                	sd	s3,8(sp)
    80002d16:	e052                	sd	s4,0(sp)
    80002d18:	1800                	addi	s0,sp,48
    80002d1a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d1c:	05050493          	addi	s1,a0,80
    80002d20:	08050913          	addi	s2,a0,128
    80002d24:	a021                	j	80002d2c <itrunc+0x22>
    80002d26:	0491                	addi	s1,s1,4
    80002d28:	01248d63          	beq	s1,s2,80002d42 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d2c:	408c                	lw	a1,0(s1)
    80002d2e:	dde5                	beqz	a1,80002d26 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d30:	0009a503          	lw	a0,0(s3)
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	90c080e7          	jalr	-1780(ra) # 80002640 <bfree>
      ip->addrs[i] = 0;
    80002d3c:	0004a023          	sw	zero,0(s1)
    80002d40:	b7dd                	j	80002d26 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d42:	0809a583          	lw	a1,128(s3)
    80002d46:	e185                	bnez	a1,80002d66 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d48:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d4c:	854e                	mv	a0,s3
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	de4080e7          	jalr	-540(ra) # 80002b32 <iupdate>
}
    80002d56:	70a2                	ld	ra,40(sp)
    80002d58:	7402                	ld	s0,32(sp)
    80002d5a:	64e2                	ld	s1,24(sp)
    80002d5c:	6942                	ld	s2,16(sp)
    80002d5e:	69a2                	ld	s3,8(sp)
    80002d60:	6a02                	ld	s4,0(sp)
    80002d62:	6145                	addi	sp,sp,48
    80002d64:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	fffff097          	auipc	ra,0xfffff
    80002d6e:	690080e7          	jalr	1680(ra) # 800023fa <bread>
    80002d72:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d74:	05850493          	addi	s1,a0,88
    80002d78:	45850913          	addi	s2,a0,1112
    80002d7c:	a811                	j	80002d90 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d7e:	0009a503          	lw	a0,0(s3)
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	8be080e7          	jalr	-1858(ra) # 80002640 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d8a:	0491                	addi	s1,s1,4
    80002d8c:	01248563          	beq	s1,s2,80002d96 <itrunc+0x8c>
      if(a[j])
    80002d90:	408c                	lw	a1,0(s1)
    80002d92:	dde5                	beqz	a1,80002d8a <itrunc+0x80>
    80002d94:	b7ed                	j	80002d7e <itrunc+0x74>
    brelse(bp);
    80002d96:	8552                	mv	a0,s4
    80002d98:	fffff097          	auipc	ra,0xfffff
    80002d9c:	792080e7          	jalr	1938(ra) # 8000252a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002da0:	0809a583          	lw	a1,128(s3)
    80002da4:	0009a503          	lw	a0,0(s3)
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	898080e7          	jalr	-1896(ra) # 80002640 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002db0:	0809a023          	sw	zero,128(s3)
    80002db4:	bf51                	j	80002d48 <itrunc+0x3e>

0000000080002db6 <iput>:
{
    80002db6:	1101                	addi	sp,sp,-32
    80002db8:	ec06                	sd	ra,24(sp)
    80002dba:	e822                	sd	s0,16(sp)
    80002dbc:	e426                	sd	s1,8(sp)
    80002dbe:	e04a                	sd	s2,0(sp)
    80002dc0:	1000                	addi	s0,sp,32
    80002dc2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dc4:	00014517          	auipc	a0,0x14
    80002dc8:	7b450513          	addi	a0,a0,1972 # 80017578 <itable>
    80002dcc:	00003097          	auipc	ra,0x3
    80002dd0:	426080e7          	jalr	1062(ra) # 800061f2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd4:	4498                	lw	a4,8(s1)
    80002dd6:	4785                	li	a5,1
    80002dd8:	02f70363          	beq	a4,a5,80002dfe <iput+0x48>
  ip->ref--;
    80002ddc:	449c                	lw	a5,8(s1)
    80002dde:	37fd                	addiw	a5,a5,-1
    80002de0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002de2:	00014517          	auipc	a0,0x14
    80002de6:	79650513          	addi	a0,a0,1942 # 80017578 <itable>
    80002dea:	00003097          	auipc	ra,0x3
    80002dee:	4bc080e7          	jalr	1212(ra) # 800062a6 <release>
}
    80002df2:	60e2                	ld	ra,24(sp)
    80002df4:	6442                	ld	s0,16(sp)
    80002df6:	64a2                	ld	s1,8(sp)
    80002df8:	6902                	ld	s2,0(sp)
    80002dfa:	6105                	addi	sp,sp,32
    80002dfc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfe:	40bc                	lw	a5,64(s1)
    80002e00:	dff1                	beqz	a5,80002ddc <iput+0x26>
    80002e02:	04a49783          	lh	a5,74(s1)
    80002e06:	fbf9                	bnez	a5,80002ddc <iput+0x26>
    acquiresleep(&ip->lock);
    80002e08:	01048913          	addi	s2,s1,16
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	00001097          	auipc	ra,0x1
    80002e12:	ab8080e7          	jalr	-1352(ra) # 800038c6 <acquiresleep>
    release(&itable.lock);
    80002e16:	00014517          	auipc	a0,0x14
    80002e1a:	76250513          	addi	a0,a0,1890 # 80017578 <itable>
    80002e1e:	00003097          	auipc	ra,0x3
    80002e22:	488080e7          	jalr	1160(ra) # 800062a6 <release>
    itrunc(ip);
    80002e26:	8526                	mv	a0,s1
    80002e28:	00000097          	auipc	ra,0x0
    80002e2c:	ee2080e7          	jalr	-286(ra) # 80002d0a <itrunc>
    ip->type = 0;
    80002e30:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e34:	8526                	mv	a0,s1
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	cfc080e7          	jalr	-772(ra) # 80002b32 <iupdate>
    ip->valid = 0;
    80002e3e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e42:	854a                	mv	a0,s2
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	ad8080e7          	jalr	-1320(ra) # 8000391c <releasesleep>
    acquire(&itable.lock);
    80002e4c:	00014517          	auipc	a0,0x14
    80002e50:	72c50513          	addi	a0,a0,1836 # 80017578 <itable>
    80002e54:	00003097          	auipc	ra,0x3
    80002e58:	39e080e7          	jalr	926(ra) # 800061f2 <acquire>
    80002e5c:	b741                	j	80002ddc <iput+0x26>

0000000080002e5e <iunlockput>:
{
    80002e5e:	1101                	addi	sp,sp,-32
    80002e60:	ec06                	sd	ra,24(sp)
    80002e62:	e822                	sd	s0,16(sp)
    80002e64:	e426                	sd	s1,8(sp)
    80002e66:	1000                	addi	s0,sp,32
    80002e68:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	e54080e7          	jalr	-428(ra) # 80002cbe <iunlock>
  iput(ip);
    80002e72:	8526                	mv	a0,s1
    80002e74:	00000097          	auipc	ra,0x0
    80002e78:	f42080e7          	jalr	-190(ra) # 80002db6 <iput>
}
    80002e7c:	60e2                	ld	ra,24(sp)
    80002e7e:	6442                	ld	s0,16(sp)
    80002e80:	64a2                	ld	s1,8(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret

0000000080002e86 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e86:	1141                	addi	sp,sp,-16
    80002e88:	e422                	sd	s0,8(sp)
    80002e8a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e8c:	411c                	lw	a5,0(a0)
    80002e8e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e90:	415c                	lw	a5,4(a0)
    80002e92:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e94:	04451783          	lh	a5,68(a0)
    80002e98:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e9c:	04a51783          	lh	a5,74(a0)
    80002ea0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ea4:	04c56783          	lwu	a5,76(a0)
    80002ea8:	e99c                	sd	a5,16(a1)
}
    80002eaa:	6422                	ld	s0,8(sp)
    80002eac:	0141                	addi	sp,sp,16
    80002eae:	8082                	ret

0000000080002eb0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eb0:	457c                	lw	a5,76(a0)
    80002eb2:	0ed7e963          	bltu	a5,a3,80002fa4 <readi+0xf4>
{
    80002eb6:	7159                	addi	sp,sp,-112
    80002eb8:	f486                	sd	ra,104(sp)
    80002eba:	f0a2                	sd	s0,96(sp)
    80002ebc:	eca6                	sd	s1,88(sp)
    80002ebe:	e8ca                	sd	s2,80(sp)
    80002ec0:	e4ce                	sd	s3,72(sp)
    80002ec2:	e0d2                	sd	s4,64(sp)
    80002ec4:	fc56                	sd	s5,56(sp)
    80002ec6:	f85a                	sd	s6,48(sp)
    80002ec8:	f45e                	sd	s7,40(sp)
    80002eca:	f062                	sd	s8,32(sp)
    80002ecc:	ec66                	sd	s9,24(sp)
    80002ece:	e86a                	sd	s10,16(sp)
    80002ed0:	e46e                	sd	s11,8(sp)
    80002ed2:	1880                	addi	s0,sp,112
    80002ed4:	8baa                	mv	s7,a0
    80002ed6:	8c2e                	mv	s8,a1
    80002ed8:	8ab2                	mv	s5,a2
    80002eda:	84b6                	mv	s1,a3
    80002edc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ede:	9f35                	addw	a4,a4,a3
    return 0;
    80002ee0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ee2:	0ad76063          	bltu	a4,a3,80002f82 <readi+0xd2>
  if(off + n > ip->size)
    80002ee6:	00e7f463          	bgeu	a5,a4,80002eee <readi+0x3e>
    n = ip->size - off;
    80002eea:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eee:	0a0b0963          	beqz	s6,80002fa0 <readi+0xf0>
    80002ef2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ef8:	5cfd                	li	s9,-1
    80002efa:	a82d                	j	80002f34 <readi+0x84>
    80002efc:	020a1d93          	slli	s11,s4,0x20
    80002f00:	020ddd93          	srli	s11,s11,0x20
    80002f04:	05890613          	addi	a2,s2,88
    80002f08:	86ee                	mv	a3,s11
    80002f0a:	963a                	add	a2,a2,a4
    80002f0c:	85d6                	mv	a1,s5
    80002f0e:	8562                	mv	a0,s8
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	9ea080e7          	jalr	-1558(ra) # 800018fa <either_copyout>
    80002f18:	05950d63          	beq	a0,s9,80002f72 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	fffff097          	auipc	ra,0xfffff
    80002f22:	60c080e7          	jalr	1548(ra) # 8000252a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f26:	013a09bb          	addw	s3,s4,s3
    80002f2a:	009a04bb          	addw	s1,s4,s1
    80002f2e:	9aee                	add	s5,s5,s11
    80002f30:	0569f763          	bgeu	s3,s6,80002f7e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f34:	000ba903          	lw	s2,0(s7)
    80002f38:	00a4d59b          	srliw	a1,s1,0xa
    80002f3c:	855e                	mv	a0,s7
    80002f3e:	00000097          	auipc	ra,0x0
    80002f42:	8b0080e7          	jalr	-1872(ra) # 800027ee <bmap>
    80002f46:	0005059b          	sext.w	a1,a0
    80002f4a:	854a                	mv	a0,s2
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	4ae080e7          	jalr	1198(ra) # 800023fa <bread>
    80002f54:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f56:	3ff4f713          	andi	a4,s1,1023
    80002f5a:	40ed07bb          	subw	a5,s10,a4
    80002f5e:	413b06bb          	subw	a3,s6,s3
    80002f62:	8a3e                	mv	s4,a5
    80002f64:	2781                	sext.w	a5,a5
    80002f66:	0006861b          	sext.w	a2,a3
    80002f6a:	f8f679e3          	bgeu	a2,a5,80002efc <readi+0x4c>
    80002f6e:	8a36                	mv	s4,a3
    80002f70:	b771                	j	80002efc <readi+0x4c>
      brelse(bp);
    80002f72:	854a                	mv	a0,s2
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	5b6080e7          	jalr	1462(ra) # 8000252a <brelse>
      tot = -1;
    80002f7c:	59fd                	li	s3,-1
  }
  return tot;
    80002f7e:	0009851b          	sext.w	a0,s3
}
    80002f82:	70a6                	ld	ra,104(sp)
    80002f84:	7406                	ld	s0,96(sp)
    80002f86:	64e6                	ld	s1,88(sp)
    80002f88:	6946                	ld	s2,80(sp)
    80002f8a:	69a6                	ld	s3,72(sp)
    80002f8c:	6a06                	ld	s4,64(sp)
    80002f8e:	7ae2                	ld	s5,56(sp)
    80002f90:	7b42                	ld	s6,48(sp)
    80002f92:	7ba2                	ld	s7,40(sp)
    80002f94:	7c02                	ld	s8,32(sp)
    80002f96:	6ce2                	ld	s9,24(sp)
    80002f98:	6d42                	ld	s10,16(sp)
    80002f9a:	6da2                	ld	s11,8(sp)
    80002f9c:	6165                	addi	sp,sp,112
    80002f9e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fa0:	89da                	mv	s3,s6
    80002fa2:	bff1                	j	80002f7e <readi+0xce>
    return 0;
    80002fa4:	4501                	li	a0,0
}
    80002fa6:	8082                	ret

0000000080002fa8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa8:	457c                	lw	a5,76(a0)
    80002faa:	10d7e863          	bltu	a5,a3,800030ba <writei+0x112>
{
    80002fae:	7159                	addi	sp,sp,-112
    80002fb0:	f486                	sd	ra,104(sp)
    80002fb2:	f0a2                	sd	s0,96(sp)
    80002fb4:	eca6                	sd	s1,88(sp)
    80002fb6:	e8ca                	sd	s2,80(sp)
    80002fb8:	e4ce                	sd	s3,72(sp)
    80002fba:	e0d2                	sd	s4,64(sp)
    80002fbc:	fc56                	sd	s5,56(sp)
    80002fbe:	f85a                	sd	s6,48(sp)
    80002fc0:	f45e                	sd	s7,40(sp)
    80002fc2:	f062                	sd	s8,32(sp)
    80002fc4:	ec66                	sd	s9,24(sp)
    80002fc6:	e86a                	sd	s10,16(sp)
    80002fc8:	e46e                	sd	s11,8(sp)
    80002fca:	1880                	addi	s0,sp,112
    80002fcc:	8b2a                	mv	s6,a0
    80002fce:	8c2e                	mv	s8,a1
    80002fd0:	8ab2                	mv	s5,a2
    80002fd2:	8936                	mv	s2,a3
    80002fd4:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fd6:	00e687bb          	addw	a5,a3,a4
    80002fda:	0ed7e263          	bltu	a5,a3,800030be <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fde:	00043737          	lui	a4,0x43
    80002fe2:	0ef76063          	bltu	a4,a5,800030c2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe6:	0c0b8863          	beqz	s7,800030b6 <writei+0x10e>
    80002fea:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fec:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ff0:	5cfd                	li	s9,-1
    80002ff2:	a091                	j	80003036 <writei+0x8e>
    80002ff4:	02099d93          	slli	s11,s3,0x20
    80002ff8:	020ddd93          	srli	s11,s11,0x20
    80002ffc:	05848513          	addi	a0,s1,88
    80003000:	86ee                	mv	a3,s11
    80003002:	8656                	mv	a2,s5
    80003004:	85e2                	mv	a1,s8
    80003006:	953a                	add	a0,a0,a4
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	948080e7          	jalr	-1720(ra) # 80001950 <either_copyin>
    80003010:	07950263          	beq	a0,s9,80003074 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003014:	8526                	mv	a0,s1
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	790080e7          	jalr	1936(ra) # 800037a6 <log_write>
    brelse(bp);
    8000301e:	8526                	mv	a0,s1
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	50a080e7          	jalr	1290(ra) # 8000252a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003028:	01498a3b          	addw	s4,s3,s4
    8000302c:	0129893b          	addw	s2,s3,s2
    80003030:	9aee                	add	s5,s5,s11
    80003032:	057a7663          	bgeu	s4,s7,8000307e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003036:	000b2483          	lw	s1,0(s6)
    8000303a:	00a9559b          	srliw	a1,s2,0xa
    8000303e:	855a                	mv	a0,s6
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	7ae080e7          	jalr	1966(ra) # 800027ee <bmap>
    80003048:	0005059b          	sext.w	a1,a0
    8000304c:	8526                	mv	a0,s1
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	3ac080e7          	jalr	940(ra) # 800023fa <bread>
    80003056:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003058:	3ff97713          	andi	a4,s2,1023
    8000305c:	40ed07bb          	subw	a5,s10,a4
    80003060:	414b86bb          	subw	a3,s7,s4
    80003064:	89be                	mv	s3,a5
    80003066:	2781                	sext.w	a5,a5
    80003068:	0006861b          	sext.w	a2,a3
    8000306c:	f8f674e3          	bgeu	a2,a5,80002ff4 <writei+0x4c>
    80003070:	89b6                	mv	s3,a3
    80003072:	b749                	j	80002ff4 <writei+0x4c>
      brelse(bp);
    80003074:	8526                	mv	a0,s1
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	4b4080e7          	jalr	1204(ra) # 8000252a <brelse>
  }

  if(off > ip->size)
    8000307e:	04cb2783          	lw	a5,76(s6)
    80003082:	0127f463          	bgeu	a5,s2,8000308a <writei+0xe2>
    ip->size = off;
    80003086:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000308a:	855a                	mv	a0,s6
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	aa6080e7          	jalr	-1370(ra) # 80002b32 <iupdate>

  return tot;
    80003094:	000a051b          	sext.w	a0,s4
}
    80003098:	70a6                	ld	ra,104(sp)
    8000309a:	7406                	ld	s0,96(sp)
    8000309c:	64e6                	ld	s1,88(sp)
    8000309e:	6946                	ld	s2,80(sp)
    800030a0:	69a6                	ld	s3,72(sp)
    800030a2:	6a06                	ld	s4,64(sp)
    800030a4:	7ae2                	ld	s5,56(sp)
    800030a6:	7b42                	ld	s6,48(sp)
    800030a8:	7ba2                	ld	s7,40(sp)
    800030aa:	7c02                	ld	s8,32(sp)
    800030ac:	6ce2                	ld	s9,24(sp)
    800030ae:	6d42                	ld	s10,16(sp)
    800030b0:	6da2                	ld	s11,8(sp)
    800030b2:	6165                	addi	sp,sp,112
    800030b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b6:	8a5e                	mv	s4,s7
    800030b8:	bfc9                	j	8000308a <writei+0xe2>
    return -1;
    800030ba:	557d                	li	a0,-1
}
    800030bc:	8082                	ret
    return -1;
    800030be:	557d                	li	a0,-1
    800030c0:	bfe1                	j	80003098 <writei+0xf0>
    return -1;
    800030c2:	557d                	li	a0,-1
    800030c4:	bfd1                	j	80003098 <writei+0xf0>

00000000800030c6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030c6:	1141                	addi	sp,sp,-16
    800030c8:	e406                	sd	ra,8(sp)
    800030ca:	e022                	sd	s0,0(sp)
    800030cc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030ce:	4639                	li	a2,14
    800030d0:	ffffd097          	auipc	ra,0xffffd
    800030d4:	1ca080e7          	jalr	458(ra) # 8000029a <strncmp>
}
    800030d8:	60a2                	ld	ra,8(sp)
    800030da:	6402                	ld	s0,0(sp)
    800030dc:	0141                	addi	sp,sp,16
    800030de:	8082                	ret

00000000800030e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030e0:	7139                	addi	sp,sp,-64
    800030e2:	fc06                	sd	ra,56(sp)
    800030e4:	f822                	sd	s0,48(sp)
    800030e6:	f426                	sd	s1,40(sp)
    800030e8:	f04a                	sd	s2,32(sp)
    800030ea:	ec4e                	sd	s3,24(sp)
    800030ec:	e852                	sd	s4,16(sp)
    800030ee:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030f0:	04451703          	lh	a4,68(a0)
    800030f4:	4785                	li	a5,1
    800030f6:	00f71a63          	bne	a4,a5,8000310a <dirlookup+0x2a>
    800030fa:	892a                	mv	s2,a0
    800030fc:	89ae                	mv	s3,a1
    800030fe:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003100:	457c                	lw	a5,76(a0)
    80003102:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003104:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003106:	e79d                	bnez	a5,80003134 <dirlookup+0x54>
    80003108:	a8a5                	j	80003180 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000310a:	00005517          	auipc	a0,0x5
    8000310e:	5ee50513          	addi	a0,a0,1518 # 800086f8 <syscall_name+0x1a8>
    80003112:	00003097          	auipc	ra,0x3
    80003116:	b96080e7          	jalr	-1130(ra) # 80005ca8 <panic>
      panic("dirlookup read");
    8000311a:	00005517          	auipc	a0,0x5
    8000311e:	5f650513          	addi	a0,a0,1526 # 80008710 <syscall_name+0x1c0>
    80003122:	00003097          	auipc	ra,0x3
    80003126:	b86080e7          	jalr	-1146(ra) # 80005ca8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000312a:	24c1                	addiw	s1,s1,16
    8000312c:	04c92783          	lw	a5,76(s2)
    80003130:	04f4f763          	bgeu	s1,a5,8000317e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003134:	4741                	li	a4,16
    80003136:	86a6                	mv	a3,s1
    80003138:	fc040613          	addi	a2,s0,-64
    8000313c:	4581                	li	a1,0
    8000313e:	854a                	mv	a0,s2
    80003140:	00000097          	auipc	ra,0x0
    80003144:	d70080e7          	jalr	-656(ra) # 80002eb0 <readi>
    80003148:	47c1                	li	a5,16
    8000314a:	fcf518e3          	bne	a0,a5,8000311a <dirlookup+0x3a>
    if(de.inum == 0)
    8000314e:	fc045783          	lhu	a5,-64(s0)
    80003152:	dfe1                	beqz	a5,8000312a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003154:	fc240593          	addi	a1,s0,-62
    80003158:	854e                	mv	a0,s3
    8000315a:	00000097          	auipc	ra,0x0
    8000315e:	f6c080e7          	jalr	-148(ra) # 800030c6 <namecmp>
    80003162:	f561                	bnez	a0,8000312a <dirlookup+0x4a>
      if(poff)
    80003164:	000a0463          	beqz	s4,8000316c <dirlookup+0x8c>
        *poff = off;
    80003168:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000316c:	fc045583          	lhu	a1,-64(s0)
    80003170:	00092503          	lw	a0,0(s2)
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	754080e7          	jalr	1876(ra) # 800028c8 <iget>
    8000317c:	a011                	j	80003180 <dirlookup+0xa0>
  return 0;
    8000317e:	4501                	li	a0,0
}
    80003180:	70e2                	ld	ra,56(sp)
    80003182:	7442                	ld	s0,48(sp)
    80003184:	74a2                	ld	s1,40(sp)
    80003186:	7902                	ld	s2,32(sp)
    80003188:	69e2                	ld	s3,24(sp)
    8000318a:	6a42                	ld	s4,16(sp)
    8000318c:	6121                	addi	sp,sp,64
    8000318e:	8082                	ret

0000000080003190 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003190:	711d                	addi	sp,sp,-96
    80003192:	ec86                	sd	ra,88(sp)
    80003194:	e8a2                	sd	s0,80(sp)
    80003196:	e4a6                	sd	s1,72(sp)
    80003198:	e0ca                	sd	s2,64(sp)
    8000319a:	fc4e                	sd	s3,56(sp)
    8000319c:	f852                	sd	s4,48(sp)
    8000319e:	f456                	sd	s5,40(sp)
    800031a0:	f05a                	sd	s6,32(sp)
    800031a2:	ec5e                	sd	s7,24(sp)
    800031a4:	e862                	sd	s8,16(sp)
    800031a6:	e466                	sd	s9,8(sp)
    800031a8:	1080                	addi	s0,sp,96
    800031aa:	84aa                	mv	s1,a0
    800031ac:	8b2e                	mv	s6,a1
    800031ae:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031b0:	00054703          	lbu	a4,0(a0)
    800031b4:	02f00793          	li	a5,47
    800031b8:	02f70363          	beq	a4,a5,800031de <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031bc:	ffffe097          	auipc	ra,0xffffe
    800031c0:	cd6080e7          	jalr	-810(ra) # 80000e92 <myproc>
    800031c4:	15053503          	ld	a0,336(a0)
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	9f6080e7          	jalr	-1546(ra) # 80002bbe <idup>
    800031d0:	89aa                	mv	s3,a0
  while(*path == '/')
    800031d2:	02f00913          	li	s2,47
  len = path - s;
    800031d6:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031d8:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031da:	4c05                	li	s8,1
    800031dc:	a865                	j	80003294 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031de:	4585                	li	a1,1
    800031e0:	4505                	li	a0,1
    800031e2:	fffff097          	auipc	ra,0xfffff
    800031e6:	6e6080e7          	jalr	1766(ra) # 800028c8 <iget>
    800031ea:	89aa                	mv	s3,a0
    800031ec:	b7dd                	j	800031d2 <namex+0x42>
      iunlockput(ip);
    800031ee:	854e                	mv	a0,s3
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	c6e080e7          	jalr	-914(ra) # 80002e5e <iunlockput>
      return 0;
    800031f8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031fa:	854e                	mv	a0,s3
    800031fc:	60e6                	ld	ra,88(sp)
    800031fe:	6446                	ld	s0,80(sp)
    80003200:	64a6                	ld	s1,72(sp)
    80003202:	6906                	ld	s2,64(sp)
    80003204:	79e2                	ld	s3,56(sp)
    80003206:	7a42                	ld	s4,48(sp)
    80003208:	7aa2                	ld	s5,40(sp)
    8000320a:	7b02                	ld	s6,32(sp)
    8000320c:	6be2                	ld	s7,24(sp)
    8000320e:	6c42                	ld	s8,16(sp)
    80003210:	6ca2                	ld	s9,8(sp)
    80003212:	6125                	addi	sp,sp,96
    80003214:	8082                	ret
      iunlock(ip);
    80003216:	854e                	mv	a0,s3
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	aa6080e7          	jalr	-1370(ra) # 80002cbe <iunlock>
      return ip;
    80003220:	bfe9                	j	800031fa <namex+0x6a>
      iunlockput(ip);
    80003222:	854e                	mv	a0,s3
    80003224:	00000097          	auipc	ra,0x0
    80003228:	c3a080e7          	jalr	-966(ra) # 80002e5e <iunlockput>
      return 0;
    8000322c:	89d2                	mv	s3,s4
    8000322e:	b7f1                	j	800031fa <namex+0x6a>
  len = path - s;
    80003230:	40b48633          	sub	a2,s1,a1
    80003234:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003238:	094cd463          	bge	s9,s4,800032c0 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000323c:	4639                	li	a2,14
    8000323e:	8556                	mv	a0,s5
    80003240:	ffffd097          	auipc	ra,0xffffd
    80003244:	fe2080e7          	jalr	-30(ra) # 80000222 <memmove>
  while(*path == '/')
    80003248:	0004c783          	lbu	a5,0(s1)
    8000324c:	01279763          	bne	a5,s2,8000325a <namex+0xca>
    path++;
    80003250:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003252:	0004c783          	lbu	a5,0(s1)
    80003256:	ff278de3          	beq	a5,s2,80003250 <namex+0xc0>
    ilock(ip);
    8000325a:	854e                	mv	a0,s3
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	9a0080e7          	jalr	-1632(ra) # 80002bfc <ilock>
    if(ip->type != T_DIR){
    80003264:	04499783          	lh	a5,68(s3)
    80003268:	f98793e3          	bne	a5,s8,800031ee <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000326c:	000b0563          	beqz	s6,80003276 <namex+0xe6>
    80003270:	0004c783          	lbu	a5,0(s1)
    80003274:	d3cd                	beqz	a5,80003216 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003276:	865e                	mv	a2,s7
    80003278:	85d6                	mv	a1,s5
    8000327a:	854e                	mv	a0,s3
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	e64080e7          	jalr	-412(ra) # 800030e0 <dirlookup>
    80003284:	8a2a                	mv	s4,a0
    80003286:	dd51                	beqz	a0,80003222 <namex+0x92>
    iunlockput(ip);
    80003288:	854e                	mv	a0,s3
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	bd4080e7          	jalr	-1068(ra) # 80002e5e <iunlockput>
    ip = next;
    80003292:	89d2                	mv	s3,s4
  while(*path == '/')
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	05279763          	bne	a5,s2,800032e6 <namex+0x156>
    path++;
    8000329c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	ff278de3          	beq	a5,s2,8000329c <namex+0x10c>
  if(*path == 0)
    800032a6:	c79d                	beqz	a5,800032d4 <namex+0x144>
    path++;
    800032a8:	85a6                	mv	a1,s1
  len = path - s;
    800032aa:	8a5e                	mv	s4,s7
    800032ac:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032ae:	01278963          	beq	a5,s2,800032c0 <namex+0x130>
    800032b2:	dfbd                	beqz	a5,80003230 <namex+0xa0>
    path++;
    800032b4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032b6:	0004c783          	lbu	a5,0(s1)
    800032ba:	ff279ce3          	bne	a5,s2,800032b2 <namex+0x122>
    800032be:	bf8d                	j	80003230 <namex+0xa0>
    memmove(name, s, len);
    800032c0:	2601                	sext.w	a2,a2
    800032c2:	8556                	mv	a0,s5
    800032c4:	ffffd097          	auipc	ra,0xffffd
    800032c8:	f5e080e7          	jalr	-162(ra) # 80000222 <memmove>
    name[len] = 0;
    800032cc:	9a56                	add	s4,s4,s5
    800032ce:	000a0023          	sb	zero,0(s4)
    800032d2:	bf9d                	j	80003248 <namex+0xb8>
  if(nameiparent){
    800032d4:	f20b03e3          	beqz	s6,800031fa <namex+0x6a>
    iput(ip);
    800032d8:	854e                	mv	a0,s3
    800032da:	00000097          	auipc	ra,0x0
    800032de:	adc080e7          	jalr	-1316(ra) # 80002db6 <iput>
    return 0;
    800032e2:	4981                	li	s3,0
    800032e4:	bf19                	j	800031fa <namex+0x6a>
  if(*path == 0)
    800032e6:	d7fd                	beqz	a5,800032d4 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032e8:	0004c783          	lbu	a5,0(s1)
    800032ec:	85a6                	mv	a1,s1
    800032ee:	b7d1                	j	800032b2 <namex+0x122>

00000000800032f0 <dirlink>:
{
    800032f0:	7139                	addi	sp,sp,-64
    800032f2:	fc06                	sd	ra,56(sp)
    800032f4:	f822                	sd	s0,48(sp)
    800032f6:	f426                	sd	s1,40(sp)
    800032f8:	f04a                	sd	s2,32(sp)
    800032fa:	ec4e                	sd	s3,24(sp)
    800032fc:	e852                	sd	s4,16(sp)
    800032fe:	0080                	addi	s0,sp,64
    80003300:	892a                	mv	s2,a0
    80003302:	8a2e                	mv	s4,a1
    80003304:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003306:	4601                	li	a2,0
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	dd8080e7          	jalr	-552(ra) # 800030e0 <dirlookup>
    80003310:	e93d                	bnez	a0,80003386 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003312:	04c92483          	lw	s1,76(s2)
    80003316:	c49d                	beqz	s1,80003344 <dirlink+0x54>
    80003318:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331a:	4741                	li	a4,16
    8000331c:	86a6                	mv	a3,s1
    8000331e:	fc040613          	addi	a2,s0,-64
    80003322:	4581                	li	a1,0
    80003324:	854a                	mv	a0,s2
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	b8a080e7          	jalr	-1142(ra) # 80002eb0 <readi>
    8000332e:	47c1                	li	a5,16
    80003330:	06f51163          	bne	a0,a5,80003392 <dirlink+0xa2>
    if(de.inum == 0)
    80003334:	fc045783          	lhu	a5,-64(s0)
    80003338:	c791                	beqz	a5,80003344 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000333a:	24c1                	addiw	s1,s1,16
    8000333c:	04c92783          	lw	a5,76(s2)
    80003340:	fcf4ede3          	bltu	s1,a5,8000331a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003344:	4639                	li	a2,14
    80003346:	85d2                	mv	a1,s4
    80003348:	fc240513          	addi	a0,s0,-62
    8000334c:	ffffd097          	auipc	ra,0xffffd
    80003350:	f8a080e7          	jalr	-118(ra) # 800002d6 <strncpy>
  de.inum = inum;
    80003354:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003358:	4741                	li	a4,16
    8000335a:	86a6                	mv	a3,s1
    8000335c:	fc040613          	addi	a2,s0,-64
    80003360:	4581                	li	a1,0
    80003362:	854a                	mv	a0,s2
    80003364:	00000097          	auipc	ra,0x0
    80003368:	c44080e7          	jalr	-956(ra) # 80002fa8 <writei>
    8000336c:	872a                	mv	a4,a0
    8000336e:	47c1                	li	a5,16
  return 0;
    80003370:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003372:	02f71863          	bne	a4,a5,800033a2 <dirlink+0xb2>
}
    80003376:	70e2                	ld	ra,56(sp)
    80003378:	7442                	ld	s0,48(sp)
    8000337a:	74a2                	ld	s1,40(sp)
    8000337c:	7902                	ld	s2,32(sp)
    8000337e:	69e2                	ld	s3,24(sp)
    80003380:	6a42                	ld	s4,16(sp)
    80003382:	6121                	addi	sp,sp,64
    80003384:	8082                	ret
    iput(ip);
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	a30080e7          	jalr	-1488(ra) # 80002db6 <iput>
    return -1;
    8000338e:	557d                	li	a0,-1
    80003390:	b7dd                	j	80003376 <dirlink+0x86>
      panic("dirlink read");
    80003392:	00005517          	auipc	a0,0x5
    80003396:	38e50513          	addi	a0,a0,910 # 80008720 <syscall_name+0x1d0>
    8000339a:	00003097          	auipc	ra,0x3
    8000339e:	90e080e7          	jalr	-1778(ra) # 80005ca8 <panic>
    panic("dirlink");
    800033a2:	00005517          	auipc	a0,0x5
    800033a6:	48650513          	addi	a0,a0,1158 # 80008828 <syscall_name+0x2d8>
    800033aa:	00003097          	auipc	ra,0x3
    800033ae:	8fe080e7          	jalr	-1794(ra) # 80005ca8 <panic>

00000000800033b2 <namei>:

struct inode*
namei(char *path)
{
    800033b2:	1101                	addi	sp,sp,-32
    800033b4:	ec06                	sd	ra,24(sp)
    800033b6:	e822                	sd	s0,16(sp)
    800033b8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ba:	fe040613          	addi	a2,s0,-32
    800033be:	4581                	li	a1,0
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	dd0080e7          	jalr	-560(ra) # 80003190 <namex>
}
    800033c8:	60e2                	ld	ra,24(sp)
    800033ca:	6442                	ld	s0,16(sp)
    800033cc:	6105                	addi	sp,sp,32
    800033ce:	8082                	ret

00000000800033d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033d0:	1141                	addi	sp,sp,-16
    800033d2:	e406                	sd	ra,8(sp)
    800033d4:	e022                	sd	s0,0(sp)
    800033d6:	0800                	addi	s0,sp,16
    800033d8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033da:	4585                	li	a1,1
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	db4080e7          	jalr	-588(ra) # 80003190 <namex>
}
    800033e4:	60a2                	ld	ra,8(sp)
    800033e6:	6402                	ld	s0,0(sp)
    800033e8:	0141                	addi	sp,sp,16
    800033ea:	8082                	ret

00000000800033ec <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033ec:	1101                	addi	sp,sp,-32
    800033ee:	ec06                	sd	ra,24(sp)
    800033f0:	e822                	sd	s0,16(sp)
    800033f2:	e426                	sd	s1,8(sp)
    800033f4:	e04a                	sd	s2,0(sp)
    800033f6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033f8:	00016917          	auipc	s2,0x16
    800033fc:	c2890913          	addi	s2,s2,-984 # 80019020 <log>
    80003400:	01892583          	lw	a1,24(s2)
    80003404:	02892503          	lw	a0,40(s2)
    80003408:	fffff097          	auipc	ra,0xfffff
    8000340c:	ff2080e7          	jalr	-14(ra) # 800023fa <bread>
    80003410:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003412:	02c92683          	lw	a3,44(s2)
    80003416:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003418:	02d05763          	blez	a3,80003446 <write_head+0x5a>
    8000341c:	00016797          	auipc	a5,0x16
    80003420:	c3478793          	addi	a5,a5,-972 # 80019050 <log+0x30>
    80003424:	05c50713          	addi	a4,a0,92
    80003428:	36fd                	addiw	a3,a3,-1
    8000342a:	1682                	slli	a3,a3,0x20
    8000342c:	9281                	srli	a3,a3,0x20
    8000342e:	068a                	slli	a3,a3,0x2
    80003430:	00016617          	auipc	a2,0x16
    80003434:	c2460613          	addi	a2,a2,-988 # 80019054 <log+0x34>
    80003438:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000343a:	4390                	lw	a2,0(a5)
    8000343c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000343e:	0791                	addi	a5,a5,4
    80003440:	0711                	addi	a4,a4,4
    80003442:	fed79ce3          	bne	a5,a3,8000343a <write_head+0x4e>
  }
  bwrite(buf);
    80003446:	8526                	mv	a0,s1
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	0a4080e7          	jalr	164(ra) # 800024ec <bwrite>
  brelse(buf);
    80003450:	8526                	mv	a0,s1
    80003452:	fffff097          	auipc	ra,0xfffff
    80003456:	0d8080e7          	jalr	216(ra) # 8000252a <brelse>
}
    8000345a:	60e2                	ld	ra,24(sp)
    8000345c:	6442                	ld	s0,16(sp)
    8000345e:	64a2                	ld	s1,8(sp)
    80003460:	6902                	ld	s2,0(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003466:	00016797          	auipc	a5,0x16
    8000346a:	be67a783          	lw	a5,-1050(a5) # 8001904c <log+0x2c>
    8000346e:	0af05d63          	blez	a5,80003528 <install_trans+0xc2>
{
    80003472:	7139                	addi	sp,sp,-64
    80003474:	fc06                	sd	ra,56(sp)
    80003476:	f822                	sd	s0,48(sp)
    80003478:	f426                	sd	s1,40(sp)
    8000347a:	f04a                	sd	s2,32(sp)
    8000347c:	ec4e                	sd	s3,24(sp)
    8000347e:	e852                	sd	s4,16(sp)
    80003480:	e456                	sd	s5,8(sp)
    80003482:	e05a                	sd	s6,0(sp)
    80003484:	0080                	addi	s0,sp,64
    80003486:	8b2a                	mv	s6,a0
    80003488:	00016a97          	auipc	s5,0x16
    8000348c:	bc8a8a93          	addi	s5,s5,-1080 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003490:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003492:	00016997          	auipc	s3,0x16
    80003496:	b8e98993          	addi	s3,s3,-1138 # 80019020 <log>
    8000349a:	a035                	j	800034c6 <install_trans+0x60>
      bunpin(dbuf);
    8000349c:	8526                	mv	a0,s1
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	166080e7          	jalr	358(ra) # 80002604 <bunpin>
    brelse(lbuf);
    800034a6:	854a                	mv	a0,s2
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	082080e7          	jalr	130(ra) # 8000252a <brelse>
    brelse(dbuf);
    800034b0:	8526                	mv	a0,s1
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	078080e7          	jalr	120(ra) # 8000252a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ba:	2a05                	addiw	s4,s4,1
    800034bc:	0a91                	addi	s5,s5,4
    800034be:	02c9a783          	lw	a5,44(s3)
    800034c2:	04fa5963          	bge	s4,a5,80003514 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c6:	0189a583          	lw	a1,24(s3)
    800034ca:	014585bb          	addw	a1,a1,s4
    800034ce:	2585                	addiw	a1,a1,1
    800034d0:	0289a503          	lw	a0,40(s3)
    800034d4:	fffff097          	auipc	ra,0xfffff
    800034d8:	f26080e7          	jalr	-218(ra) # 800023fa <bread>
    800034dc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034de:	000aa583          	lw	a1,0(s5)
    800034e2:	0289a503          	lw	a0,40(s3)
    800034e6:	fffff097          	auipc	ra,0xfffff
    800034ea:	f14080e7          	jalr	-236(ra) # 800023fa <bread>
    800034ee:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034f0:	40000613          	li	a2,1024
    800034f4:	05890593          	addi	a1,s2,88
    800034f8:	05850513          	addi	a0,a0,88
    800034fc:	ffffd097          	auipc	ra,0xffffd
    80003500:	d26080e7          	jalr	-730(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003504:	8526                	mv	a0,s1
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	fe6080e7          	jalr	-26(ra) # 800024ec <bwrite>
    if(recovering == 0)
    8000350e:	f80b1ce3          	bnez	s6,800034a6 <install_trans+0x40>
    80003512:	b769                	j	8000349c <install_trans+0x36>
}
    80003514:	70e2                	ld	ra,56(sp)
    80003516:	7442                	ld	s0,48(sp)
    80003518:	74a2                	ld	s1,40(sp)
    8000351a:	7902                	ld	s2,32(sp)
    8000351c:	69e2                	ld	s3,24(sp)
    8000351e:	6a42                	ld	s4,16(sp)
    80003520:	6aa2                	ld	s5,8(sp)
    80003522:	6b02                	ld	s6,0(sp)
    80003524:	6121                	addi	sp,sp,64
    80003526:	8082                	ret
    80003528:	8082                	ret

000000008000352a <initlog>:
{
    8000352a:	7179                	addi	sp,sp,-48
    8000352c:	f406                	sd	ra,40(sp)
    8000352e:	f022                	sd	s0,32(sp)
    80003530:	ec26                	sd	s1,24(sp)
    80003532:	e84a                	sd	s2,16(sp)
    80003534:	e44e                	sd	s3,8(sp)
    80003536:	1800                	addi	s0,sp,48
    80003538:	892a                	mv	s2,a0
    8000353a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000353c:	00016497          	auipc	s1,0x16
    80003540:	ae448493          	addi	s1,s1,-1308 # 80019020 <log>
    80003544:	00005597          	auipc	a1,0x5
    80003548:	1ec58593          	addi	a1,a1,492 # 80008730 <syscall_name+0x1e0>
    8000354c:	8526                	mv	a0,s1
    8000354e:	00003097          	auipc	ra,0x3
    80003552:	c14080e7          	jalr	-1004(ra) # 80006162 <initlock>
  log.start = sb->logstart;
    80003556:	0149a583          	lw	a1,20(s3)
    8000355a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000355c:	0109a783          	lw	a5,16(s3)
    80003560:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003562:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003566:	854a                	mv	a0,s2
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	e92080e7          	jalr	-366(ra) # 800023fa <bread>
  log.lh.n = lh->n;
    80003570:	4d3c                	lw	a5,88(a0)
    80003572:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003574:	02f05563          	blez	a5,8000359e <initlog+0x74>
    80003578:	05c50713          	addi	a4,a0,92
    8000357c:	00016697          	auipc	a3,0x16
    80003580:	ad468693          	addi	a3,a3,-1324 # 80019050 <log+0x30>
    80003584:	37fd                	addiw	a5,a5,-1
    80003586:	1782                	slli	a5,a5,0x20
    80003588:	9381                	srli	a5,a5,0x20
    8000358a:	078a                	slli	a5,a5,0x2
    8000358c:	06050613          	addi	a2,a0,96
    80003590:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003592:	4310                	lw	a2,0(a4)
    80003594:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003596:	0711                	addi	a4,a4,4
    80003598:	0691                	addi	a3,a3,4
    8000359a:	fef71ce3          	bne	a4,a5,80003592 <initlog+0x68>
  brelse(buf);
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	f8c080e7          	jalr	-116(ra) # 8000252a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035a6:	4505                	li	a0,1
    800035a8:	00000097          	auipc	ra,0x0
    800035ac:	ebe080e7          	jalr	-322(ra) # 80003466 <install_trans>
  log.lh.n = 0;
    800035b0:	00016797          	auipc	a5,0x16
    800035b4:	a807ae23          	sw	zero,-1380(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    800035b8:	00000097          	auipc	ra,0x0
    800035bc:	e34080e7          	jalr	-460(ra) # 800033ec <write_head>
}
    800035c0:	70a2                	ld	ra,40(sp)
    800035c2:	7402                	ld	s0,32(sp)
    800035c4:	64e2                	ld	s1,24(sp)
    800035c6:	6942                	ld	s2,16(sp)
    800035c8:	69a2                	ld	s3,8(sp)
    800035ca:	6145                	addi	sp,sp,48
    800035cc:	8082                	ret

00000000800035ce <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035ce:	1101                	addi	sp,sp,-32
    800035d0:	ec06                	sd	ra,24(sp)
    800035d2:	e822                	sd	s0,16(sp)
    800035d4:	e426                	sd	s1,8(sp)
    800035d6:	e04a                	sd	s2,0(sp)
    800035d8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035da:	00016517          	auipc	a0,0x16
    800035de:	a4650513          	addi	a0,a0,-1466 # 80019020 <log>
    800035e2:	00003097          	auipc	ra,0x3
    800035e6:	c10080e7          	jalr	-1008(ra) # 800061f2 <acquire>
  while(1){
    if(log.committing){
    800035ea:	00016497          	auipc	s1,0x16
    800035ee:	a3648493          	addi	s1,s1,-1482 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f2:	4979                	li	s2,30
    800035f4:	a039                	j	80003602 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035f6:	85a6                	mv	a1,s1
    800035f8:	8526                	mv	a0,s1
    800035fa:	ffffe097          	auipc	ra,0xffffe
    800035fe:	f5c080e7          	jalr	-164(ra) # 80001556 <sleep>
    if(log.committing){
    80003602:	50dc                	lw	a5,36(s1)
    80003604:	fbed                	bnez	a5,800035f6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003606:	509c                	lw	a5,32(s1)
    80003608:	0017871b          	addiw	a4,a5,1
    8000360c:	0007069b          	sext.w	a3,a4
    80003610:	0027179b          	slliw	a5,a4,0x2
    80003614:	9fb9                	addw	a5,a5,a4
    80003616:	0017979b          	slliw	a5,a5,0x1
    8000361a:	54d8                	lw	a4,44(s1)
    8000361c:	9fb9                	addw	a5,a5,a4
    8000361e:	00f95963          	bge	s2,a5,80003630 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003622:	85a6                	mv	a1,s1
    80003624:	8526                	mv	a0,s1
    80003626:	ffffe097          	auipc	ra,0xffffe
    8000362a:	f30080e7          	jalr	-208(ra) # 80001556 <sleep>
    8000362e:	bfd1                	j	80003602 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003630:	00016517          	auipc	a0,0x16
    80003634:	9f050513          	addi	a0,a0,-1552 # 80019020 <log>
    80003638:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000363a:	00003097          	auipc	ra,0x3
    8000363e:	c6c080e7          	jalr	-916(ra) # 800062a6 <release>
      break;
    }
  }
}
    80003642:	60e2                	ld	ra,24(sp)
    80003644:	6442                	ld	s0,16(sp)
    80003646:	64a2                	ld	s1,8(sp)
    80003648:	6902                	ld	s2,0(sp)
    8000364a:	6105                	addi	sp,sp,32
    8000364c:	8082                	ret

000000008000364e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000364e:	7139                	addi	sp,sp,-64
    80003650:	fc06                	sd	ra,56(sp)
    80003652:	f822                	sd	s0,48(sp)
    80003654:	f426                	sd	s1,40(sp)
    80003656:	f04a                	sd	s2,32(sp)
    80003658:	ec4e                	sd	s3,24(sp)
    8000365a:	e852                	sd	s4,16(sp)
    8000365c:	e456                	sd	s5,8(sp)
    8000365e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003660:	00016497          	auipc	s1,0x16
    80003664:	9c048493          	addi	s1,s1,-1600 # 80019020 <log>
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	b88080e7          	jalr	-1144(ra) # 800061f2 <acquire>
  log.outstanding -= 1;
    80003672:	509c                	lw	a5,32(s1)
    80003674:	37fd                	addiw	a5,a5,-1
    80003676:	0007891b          	sext.w	s2,a5
    8000367a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000367c:	50dc                	lw	a5,36(s1)
    8000367e:	efb9                	bnez	a5,800036dc <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003680:	06091663          	bnez	s2,800036ec <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003684:	00016497          	auipc	s1,0x16
    80003688:	99c48493          	addi	s1,s1,-1636 # 80019020 <log>
    8000368c:	4785                	li	a5,1
    8000368e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	c14080e7          	jalr	-1004(ra) # 800062a6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000369a:	54dc                	lw	a5,44(s1)
    8000369c:	06f04763          	bgtz	a5,8000370a <end_op+0xbc>
    acquire(&log.lock);
    800036a0:	00016497          	auipc	s1,0x16
    800036a4:	98048493          	addi	s1,s1,-1664 # 80019020 <log>
    800036a8:	8526                	mv	a0,s1
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	b48080e7          	jalr	-1208(ra) # 800061f2 <acquire>
    log.committing = 0;
    800036b2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036b6:	8526                	mv	a0,s1
    800036b8:	ffffe097          	auipc	ra,0xffffe
    800036bc:	02a080e7          	jalr	42(ra) # 800016e2 <wakeup>
    release(&log.lock);
    800036c0:	8526                	mv	a0,s1
    800036c2:	00003097          	auipc	ra,0x3
    800036c6:	be4080e7          	jalr	-1052(ra) # 800062a6 <release>
}
    800036ca:	70e2                	ld	ra,56(sp)
    800036cc:	7442                	ld	s0,48(sp)
    800036ce:	74a2                	ld	s1,40(sp)
    800036d0:	7902                	ld	s2,32(sp)
    800036d2:	69e2                	ld	s3,24(sp)
    800036d4:	6a42                	ld	s4,16(sp)
    800036d6:	6aa2                	ld	s5,8(sp)
    800036d8:	6121                	addi	sp,sp,64
    800036da:	8082                	ret
    panic("log.committing");
    800036dc:	00005517          	auipc	a0,0x5
    800036e0:	05c50513          	addi	a0,a0,92 # 80008738 <syscall_name+0x1e8>
    800036e4:	00002097          	auipc	ra,0x2
    800036e8:	5c4080e7          	jalr	1476(ra) # 80005ca8 <panic>
    wakeup(&log);
    800036ec:	00016497          	auipc	s1,0x16
    800036f0:	93448493          	addi	s1,s1,-1740 # 80019020 <log>
    800036f4:	8526                	mv	a0,s1
    800036f6:	ffffe097          	auipc	ra,0xffffe
    800036fa:	fec080e7          	jalr	-20(ra) # 800016e2 <wakeup>
  release(&log.lock);
    800036fe:	8526                	mv	a0,s1
    80003700:	00003097          	auipc	ra,0x3
    80003704:	ba6080e7          	jalr	-1114(ra) # 800062a6 <release>
  if(do_commit){
    80003708:	b7c9                	j	800036ca <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370a:	00016a97          	auipc	s5,0x16
    8000370e:	946a8a93          	addi	s5,s5,-1722 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003712:	00016a17          	auipc	s4,0x16
    80003716:	90ea0a13          	addi	s4,s4,-1778 # 80019020 <log>
    8000371a:	018a2583          	lw	a1,24(s4)
    8000371e:	012585bb          	addw	a1,a1,s2
    80003722:	2585                	addiw	a1,a1,1
    80003724:	028a2503          	lw	a0,40(s4)
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	cd2080e7          	jalr	-814(ra) # 800023fa <bread>
    80003730:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003732:	000aa583          	lw	a1,0(s5)
    80003736:	028a2503          	lw	a0,40(s4)
    8000373a:	fffff097          	auipc	ra,0xfffff
    8000373e:	cc0080e7          	jalr	-832(ra) # 800023fa <bread>
    80003742:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003744:	40000613          	li	a2,1024
    80003748:	05850593          	addi	a1,a0,88
    8000374c:	05848513          	addi	a0,s1,88
    80003750:	ffffd097          	auipc	ra,0xffffd
    80003754:	ad2080e7          	jalr	-1326(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    80003758:	8526                	mv	a0,s1
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	d92080e7          	jalr	-622(ra) # 800024ec <bwrite>
    brelse(from);
    80003762:	854e                	mv	a0,s3
    80003764:	fffff097          	auipc	ra,0xfffff
    80003768:	dc6080e7          	jalr	-570(ra) # 8000252a <brelse>
    brelse(to);
    8000376c:	8526                	mv	a0,s1
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	dbc080e7          	jalr	-580(ra) # 8000252a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003776:	2905                	addiw	s2,s2,1
    80003778:	0a91                	addi	s5,s5,4
    8000377a:	02ca2783          	lw	a5,44(s4)
    8000377e:	f8f94ee3          	blt	s2,a5,8000371a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003782:	00000097          	auipc	ra,0x0
    80003786:	c6a080e7          	jalr	-918(ra) # 800033ec <write_head>
    install_trans(0); // Now install writes to home locations
    8000378a:	4501                	li	a0,0
    8000378c:	00000097          	auipc	ra,0x0
    80003790:	cda080e7          	jalr	-806(ra) # 80003466 <install_trans>
    log.lh.n = 0;
    80003794:	00016797          	auipc	a5,0x16
    80003798:	8a07ac23          	sw	zero,-1864(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	c50080e7          	jalr	-944(ra) # 800033ec <write_head>
    800037a4:	bdf5                	j	800036a0 <end_op+0x52>

00000000800037a6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037a6:	1101                	addi	sp,sp,-32
    800037a8:	ec06                	sd	ra,24(sp)
    800037aa:	e822                	sd	s0,16(sp)
    800037ac:	e426                	sd	s1,8(sp)
    800037ae:	e04a                	sd	s2,0(sp)
    800037b0:	1000                	addi	s0,sp,32
    800037b2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037b4:	00016917          	auipc	s2,0x16
    800037b8:	86c90913          	addi	s2,s2,-1940 # 80019020 <log>
    800037bc:	854a                	mv	a0,s2
    800037be:	00003097          	auipc	ra,0x3
    800037c2:	a34080e7          	jalr	-1484(ra) # 800061f2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037c6:	02c92603          	lw	a2,44(s2)
    800037ca:	47f5                	li	a5,29
    800037cc:	06c7c563          	blt	a5,a2,80003836 <log_write+0x90>
    800037d0:	00016797          	auipc	a5,0x16
    800037d4:	86c7a783          	lw	a5,-1940(a5) # 8001903c <log+0x1c>
    800037d8:	37fd                	addiw	a5,a5,-1
    800037da:	04f65e63          	bge	a2,a5,80003836 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037de:	00016797          	auipc	a5,0x16
    800037e2:	8627a783          	lw	a5,-1950(a5) # 80019040 <log+0x20>
    800037e6:	06f05063          	blez	a5,80003846 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ea:	4781                	li	a5,0
    800037ec:	06c05563          	blez	a2,80003856 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f0:	44cc                	lw	a1,12(s1)
    800037f2:	00016717          	auipc	a4,0x16
    800037f6:	85e70713          	addi	a4,a4,-1954 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037fa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037fc:	4314                	lw	a3,0(a4)
    800037fe:	04b68c63          	beq	a3,a1,80003856 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003802:	2785                	addiw	a5,a5,1
    80003804:	0711                	addi	a4,a4,4
    80003806:	fef61be3          	bne	a2,a5,800037fc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000380a:	0621                	addi	a2,a2,8
    8000380c:	060a                	slli	a2,a2,0x2
    8000380e:	00016797          	auipc	a5,0x16
    80003812:	81278793          	addi	a5,a5,-2030 # 80019020 <log>
    80003816:	963e                	add	a2,a2,a5
    80003818:	44dc                	lw	a5,12(s1)
    8000381a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000381c:	8526                	mv	a0,s1
    8000381e:	fffff097          	auipc	ra,0xfffff
    80003822:	daa080e7          	jalr	-598(ra) # 800025c8 <bpin>
    log.lh.n++;
    80003826:	00015717          	auipc	a4,0x15
    8000382a:	7fa70713          	addi	a4,a4,2042 # 80019020 <log>
    8000382e:	575c                	lw	a5,44(a4)
    80003830:	2785                	addiw	a5,a5,1
    80003832:	d75c                	sw	a5,44(a4)
    80003834:	a835                	j	80003870 <log_write+0xca>
    panic("too big a transaction");
    80003836:	00005517          	auipc	a0,0x5
    8000383a:	f1250513          	addi	a0,a0,-238 # 80008748 <syscall_name+0x1f8>
    8000383e:	00002097          	auipc	ra,0x2
    80003842:	46a080e7          	jalr	1130(ra) # 80005ca8 <panic>
    panic("log_write outside of trans");
    80003846:	00005517          	auipc	a0,0x5
    8000384a:	f1a50513          	addi	a0,a0,-230 # 80008760 <syscall_name+0x210>
    8000384e:	00002097          	auipc	ra,0x2
    80003852:	45a080e7          	jalr	1114(ra) # 80005ca8 <panic>
  log.lh.block[i] = b->blockno;
    80003856:	00878713          	addi	a4,a5,8
    8000385a:	00271693          	slli	a3,a4,0x2
    8000385e:	00015717          	auipc	a4,0x15
    80003862:	7c270713          	addi	a4,a4,1986 # 80019020 <log>
    80003866:	9736                	add	a4,a4,a3
    80003868:	44d4                	lw	a3,12(s1)
    8000386a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000386c:	faf608e3          	beq	a2,a5,8000381c <log_write+0x76>
  }
  release(&log.lock);
    80003870:	00015517          	auipc	a0,0x15
    80003874:	7b050513          	addi	a0,a0,1968 # 80019020 <log>
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	a2e080e7          	jalr	-1490(ra) # 800062a6 <release>
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	e426                	sd	s1,8(sp)
    80003894:	e04a                	sd	s2,0(sp)
    80003896:	1000                	addi	s0,sp,32
    80003898:	84aa                	mv	s1,a0
    8000389a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000389c:	00005597          	auipc	a1,0x5
    800038a0:	ee458593          	addi	a1,a1,-284 # 80008780 <syscall_name+0x230>
    800038a4:	0521                	addi	a0,a0,8
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	8bc080e7          	jalr	-1860(ra) # 80006162 <initlock>
  lk->name = name;
    800038ae:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b6:	0204a423          	sw	zero,40(s1)
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6902                	ld	s2,0(sp)
    800038c2:	6105                	addi	sp,sp,32
    800038c4:	8082                	ret

00000000800038c6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	e04a                	sd	s2,0(sp)
    800038d0:	1000                	addi	s0,sp,32
    800038d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d4:	00850913          	addi	s2,a0,8
    800038d8:	854a                	mv	a0,s2
    800038da:	00003097          	auipc	ra,0x3
    800038de:	918080e7          	jalr	-1768(ra) # 800061f2 <acquire>
  while (lk->locked) {
    800038e2:	409c                	lw	a5,0(s1)
    800038e4:	cb89                	beqz	a5,800038f6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038e6:	85ca                	mv	a1,s2
    800038e8:	8526                	mv	a0,s1
    800038ea:	ffffe097          	auipc	ra,0xffffe
    800038ee:	c6c080e7          	jalr	-916(ra) # 80001556 <sleep>
  while (lk->locked) {
    800038f2:	409c                	lw	a5,0(s1)
    800038f4:	fbed                	bnez	a5,800038e6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038f6:	4785                	li	a5,1
    800038f8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038fa:	ffffd097          	auipc	ra,0xffffd
    800038fe:	598080e7          	jalr	1432(ra) # 80000e92 <myproc>
    80003902:	591c                	lw	a5,48(a0)
    80003904:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	99e080e7          	jalr	-1634(ra) # 800062a6 <release>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6902                	ld	s2,0(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	e04a                	sd	s2,0(sp)
    80003926:	1000                	addi	s0,sp,32
    80003928:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000392a:	00850913          	addi	s2,a0,8
    8000392e:	854a                	mv	a0,s2
    80003930:	00003097          	auipc	ra,0x3
    80003934:	8c2080e7          	jalr	-1854(ra) # 800061f2 <acquire>
  lk->locked = 0;
    80003938:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000393c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003940:	8526                	mv	a0,s1
    80003942:	ffffe097          	auipc	ra,0xffffe
    80003946:	da0080e7          	jalr	-608(ra) # 800016e2 <wakeup>
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	95a080e7          	jalr	-1702(ra) # 800062a6 <release>
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6902                	ld	s2,0(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003960:	7179                	addi	sp,sp,-48
    80003962:	f406                	sd	ra,40(sp)
    80003964:	f022                	sd	s0,32(sp)
    80003966:	ec26                	sd	s1,24(sp)
    80003968:	e84a                	sd	s2,16(sp)
    8000396a:	e44e                	sd	s3,8(sp)
    8000396c:	1800                	addi	s0,sp,48
    8000396e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003970:	00850913          	addi	s2,a0,8
    80003974:	854a                	mv	a0,s2
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	87c080e7          	jalr	-1924(ra) # 800061f2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397e:	409c                	lw	a5,0(s1)
    80003980:	ef99                	bnez	a5,8000399e <holdingsleep+0x3e>
    80003982:	4481                	li	s1,0
  release(&lk->lk);
    80003984:	854a                	mv	a0,s2
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	920080e7          	jalr	-1760(ra) # 800062a6 <release>
  return r;
}
    8000398e:	8526                	mv	a0,s1
    80003990:	70a2                	ld	ra,40(sp)
    80003992:	7402                	ld	s0,32(sp)
    80003994:	64e2                	ld	s1,24(sp)
    80003996:	6942                	ld	s2,16(sp)
    80003998:	69a2                	ld	s3,8(sp)
    8000399a:	6145                	addi	sp,sp,48
    8000399c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399e:	0284a983          	lw	s3,40(s1)
    800039a2:	ffffd097          	auipc	ra,0xffffd
    800039a6:	4f0080e7          	jalr	1264(ra) # 80000e92 <myproc>
    800039aa:	5904                	lw	s1,48(a0)
    800039ac:	413484b3          	sub	s1,s1,s3
    800039b0:	0014b493          	seqz	s1,s1
    800039b4:	bfc1                	j	80003984 <holdingsleep+0x24>

00000000800039b6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039b6:	1141                	addi	sp,sp,-16
    800039b8:	e406                	sd	ra,8(sp)
    800039ba:	e022                	sd	s0,0(sp)
    800039bc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039be:	00005597          	auipc	a1,0x5
    800039c2:	dd258593          	addi	a1,a1,-558 # 80008790 <syscall_name+0x240>
    800039c6:	00015517          	auipc	a0,0x15
    800039ca:	7a250513          	addi	a0,a0,1954 # 80019168 <ftable>
    800039ce:	00002097          	auipc	ra,0x2
    800039d2:	794080e7          	jalr	1940(ra) # 80006162 <initlock>
}
    800039d6:	60a2                	ld	ra,8(sp)
    800039d8:	6402                	ld	s0,0(sp)
    800039da:	0141                	addi	sp,sp,16
    800039dc:	8082                	ret

00000000800039de <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039e8:	00015517          	auipc	a0,0x15
    800039ec:	78050513          	addi	a0,a0,1920 # 80019168 <ftable>
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	802080e7          	jalr	-2046(ra) # 800061f2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f8:	00015497          	auipc	s1,0x15
    800039fc:	78848493          	addi	s1,s1,1928 # 80019180 <ftable+0x18>
    80003a00:	00016717          	auipc	a4,0x16
    80003a04:	72070713          	addi	a4,a4,1824 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a08:	40dc                	lw	a5,4(s1)
    80003a0a:	cf99                	beqz	a5,80003a28 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a0c:	02848493          	addi	s1,s1,40
    80003a10:	fee49ce3          	bne	s1,a4,80003a08 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a14:	00015517          	auipc	a0,0x15
    80003a18:	75450513          	addi	a0,a0,1876 # 80019168 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	88a080e7          	jalr	-1910(ra) # 800062a6 <release>
  return 0;
    80003a24:	4481                	li	s1,0
    80003a26:	a819                	j	80003a3c <filealloc+0x5e>
      f->ref = 1;
    80003a28:	4785                	li	a5,1
    80003a2a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a2c:	00015517          	auipc	a0,0x15
    80003a30:	73c50513          	addi	a0,a0,1852 # 80019168 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	872080e7          	jalr	-1934(ra) # 800062a6 <release>
}
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	1000                	addi	s0,sp,32
    80003a52:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a54:	00015517          	auipc	a0,0x15
    80003a58:	71450513          	addi	a0,a0,1812 # 80019168 <ftable>
    80003a5c:	00002097          	auipc	ra,0x2
    80003a60:	796080e7          	jalr	1942(ra) # 800061f2 <acquire>
  if(f->ref < 1)
    80003a64:	40dc                	lw	a5,4(s1)
    80003a66:	02f05263          	blez	a5,80003a8a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a6a:	2785                	addiw	a5,a5,1
    80003a6c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a6e:	00015517          	auipc	a0,0x15
    80003a72:	6fa50513          	addi	a0,a0,1786 # 80019168 <ftable>
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	830080e7          	jalr	-2000(ra) # 800062a6 <release>
  return f;
}
    80003a7e:	8526                	mv	a0,s1
    80003a80:	60e2                	ld	ra,24(sp)
    80003a82:	6442                	ld	s0,16(sp)
    80003a84:	64a2                	ld	s1,8(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret
    panic("filedup");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	d0e50513          	addi	a0,a0,-754 # 80008798 <syscall_name+0x248>
    80003a92:	00002097          	auipc	ra,0x2
    80003a96:	216080e7          	jalr	534(ra) # 80005ca8 <panic>

0000000080003a9a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a9a:	7139                	addi	sp,sp,-64
    80003a9c:	fc06                	sd	ra,56(sp)
    80003a9e:	f822                	sd	s0,48(sp)
    80003aa0:	f426                	sd	s1,40(sp)
    80003aa2:	f04a                	sd	s2,32(sp)
    80003aa4:	ec4e                	sd	s3,24(sp)
    80003aa6:	e852                	sd	s4,16(sp)
    80003aa8:	e456                	sd	s5,8(sp)
    80003aaa:	0080                	addi	s0,sp,64
    80003aac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aae:	00015517          	auipc	a0,0x15
    80003ab2:	6ba50513          	addi	a0,a0,1722 # 80019168 <ftable>
    80003ab6:	00002097          	auipc	ra,0x2
    80003aba:	73c080e7          	jalr	1852(ra) # 800061f2 <acquire>
  if(f->ref < 1)
    80003abe:	40dc                	lw	a5,4(s1)
    80003ac0:	06f05163          	blez	a5,80003b22 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ac4:	37fd                	addiw	a5,a5,-1
    80003ac6:	0007871b          	sext.w	a4,a5
    80003aca:	c0dc                	sw	a5,4(s1)
    80003acc:	06e04363          	bgtz	a4,80003b32 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ad0:	0004a903          	lw	s2,0(s1)
    80003ad4:	0094ca83          	lbu	s5,9(s1)
    80003ad8:	0104ba03          	ld	s4,16(s1)
    80003adc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ae0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ae4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ae8:	00015517          	auipc	a0,0x15
    80003aec:	68050513          	addi	a0,a0,1664 # 80019168 <ftable>
    80003af0:	00002097          	auipc	ra,0x2
    80003af4:	7b6080e7          	jalr	1974(ra) # 800062a6 <release>

  if(ff.type == FD_PIPE){
    80003af8:	4785                	li	a5,1
    80003afa:	04f90d63          	beq	s2,a5,80003b54 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003afe:	3979                	addiw	s2,s2,-2
    80003b00:	4785                	li	a5,1
    80003b02:	0527e063          	bltu	a5,s2,80003b42 <fileclose+0xa8>
    begin_op();
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	ac8080e7          	jalr	-1336(ra) # 800035ce <begin_op>
    iput(ff.ip);
    80003b0e:	854e                	mv	a0,s3
    80003b10:	fffff097          	auipc	ra,0xfffff
    80003b14:	2a6080e7          	jalr	678(ra) # 80002db6 <iput>
    end_op();
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	b36080e7          	jalr	-1226(ra) # 8000364e <end_op>
    80003b20:	a00d                	j	80003b42 <fileclose+0xa8>
    panic("fileclose");
    80003b22:	00005517          	auipc	a0,0x5
    80003b26:	c7e50513          	addi	a0,a0,-898 # 800087a0 <syscall_name+0x250>
    80003b2a:	00002097          	auipc	ra,0x2
    80003b2e:	17e080e7          	jalr	382(ra) # 80005ca8 <panic>
    release(&ftable.lock);
    80003b32:	00015517          	auipc	a0,0x15
    80003b36:	63650513          	addi	a0,a0,1590 # 80019168 <ftable>
    80003b3a:	00002097          	auipc	ra,0x2
    80003b3e:	76c080e7          	jalr	1900(ra) # 800062a6 <release>
  }
}
    80003b42:	70e2                	ld	ra,56(sp)
    80003b44:	7442                	ld	s0,48(sp)
    80003b46:	74a2                	ld	s1,40(sp)
    80003b48:	7902                	ld	s2,32(sp)
    80003b4a:	69e2                	ld	s3,24(sp)
    80003b4c:	6a42                	ld	s4,16(sp)
    80003b4e:	6aa2                	ld	s5,8(sp)
    80003b50:	6121                	addi	sp,sp,64
    80003b52:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b54:	85d6                	mv	a1,s5
    80003b56:	8552                	mv	a0,s4
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	34c080e7          	jalr	844(ra) # 80003ea4 <pipeclose>
    80003b60:	b7cd                	j	80003b42 <fileclose+0xa8>

0000000080003b62 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b62:	715d                	addi	sp,sp,-80
    80003b64:	e486                	sd	ra,72(sp)
    80003b66:	e0a2                	sd	s0,64(sp)
    80003b68:	fc26                	sd	s1,56(sp)
    80003b6a:	f84a                	sd	s2,48(sp)
    80003b6c:	f44e                	sd	s3,40(sp)
    80003b6e:	0880                	addi	s0,sp,80
    80003b70:	84aa                	mv	s1,a0
    80003b72:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b74:	ffffd097          	auipc	ra,0xffffd
    80003b78:	31e080e7          	jalr	798(ra) # 80000e92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b7c:	409c                	lw	a5,0(s1)
    80003b7e:	37f9                	addiw	a5,a5,-2
    80003b80:	4705                	li	a4,1
    80003b82:	04f76763          	bltu	a4,a5,80003bd0 <filestat+0x6e>
    80003b86:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b88:	6c88                	ld	a0,24(s1)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	072080e7          	jalr	114(ra) # 80002bfc <ilock>
    stati(f->ip, &st);
    80003b92:	fb840593          	addi	a1,s0,-72
    80003b96:	6c88                	ld	a0,24(s1)
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	2ee080e7          	jalr	750(ra) # 80002e86 <stati>
    iunlock(f->ip);
    80003ba0:	6c88                	ld	a0,24(s1)
    80003ba2:	fffff097          	auipc	ra,0xfffff
    80003ba6:	11c080e7          	jalr	284(ra) # 80002cbe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003baa:	46e1                	li	a3,24
    80003bac:	fb840613          	addi	a2,s0,-72
    80003bb0:	85ce                	mv	a1,s3
    80003bb2:	05093503          	ld	a0,80(s2)
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	f9e080e7          	jalr	-98(ra) # 80000b54 <copyout>
    80003bbe:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bc2:	60a6                	ld	ra,72(sp)
    80003bc4:	6406                	ld	s0,64(sp)
    80003bc6:	74e2                	ld	s1,56(sp)
    80003bc8:	7942                	ld	s2,48(sp)
    80003bca:	79a2                	ld	s3,40(sp)
    80003bcc:	6161                	addi	sp,sp,80
    80003bce:	8082                	ret
  return -1;
    80003bd0:	557d                	li	a0,-1
    80003bd2:	bfc5                	j	80003bc2 <filestat+0x60>

0000000080003bd4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bd4:	7179                	addi	sp,sp,-48
    80003bd6:	f406                	sd	ra,40(sp)
    80003bd8:	f022                	sd	s0,32(sp)
    80003bda:	ec26                	sd	s1,24(sp)
    80003bdc:	e84a                	sd	s2,16(sp)
    80003bde:	e44e                	sd	s3,8(sp)
    80003be0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003be2:	00854783          	lbu	a5,8(a0)
    80003be6:	c3d5                	beqz	a5,80003c8a <fileread+0xb6>
    80003be8:	84aa                	mv	s1,a0
    80003bea:	89ae                	mv	s3,a1
    80003bec:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bee:	411c                	lw	a5,0(a0)
    80003bf0:	4705                	li	a4,1
    80003bf2:	04e78963          	beq	a5,a4,80003c44 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf6:	470d                	li	a4,3
    80003bf8:	04e78d63          	beq	a5,a4,80003c52 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bfc:	4709                	li	a4,2
    80003bfe:	06e79e63          	bne	a5,a4,80003c7a <fileread+0xa6>
    ilock(f->ip);
    80003c02:	6d08                	ld	a0,24(a0)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	ff8080e7          	jalr	-8(ra) # 80002bfc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c0c:	874a                	mv	a4,s2
    80003c0e:	5094                	lw	a3,32(s1)
    80003c10:	864e                	mv	a2,s3
    80003c12:	4585                	li	a1,1
    80003c14:	6c88                	ld	a0,24(s1)
    80003c16:	fffff097          	auipc	ra,0xfffff
    80003c1a:	29a080e7          	jalr	666(ra) # 80002eb0 <readi>
    80003c1e:	892a                	mv	s2,a0
    80003c20:	00a05563          	blez	a0,80003c2a <fileread+0x56>
      f->off += r;
    80003c24:	509c                	lw	a5,32(s1)
    80003c26:	9fa9                	addw	a5,a5,a0
    80003c28:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c2a:	6c88                	ld	a0,24(s1)
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	092080e7          	jalr	146(ra) # 80002cbe <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c34:	854a                	mv	a0,s2
    80003c36:	70a2                	ld	ra,40(sp)
    80003c38:	7402                	ld	s0,32(sp)
    80003c3a:	64e2                	ld	s1,24(sp)
    80003c3c:	6942                	ld	s2,16(sp)
    80003c3e:	69a2                	ld	s3,8(sp)
    80003c40:	6145                	addi	sp,sp,48
    80003c42:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c44:	6908                	ld	a0,16(a0)
    80003c46:	00000097          	auipc	ra,0x0
    80003c4a:	3c8080e7          	jalr	968(ra) # 8000400e <piperead>
    80003c4e:	892a                	mv	s2,a0
    80003c50:	b7d5                	j	80003c34 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c52:	02451783          	lh	a5,36(a0)
    80003c56:	03079693          	slli	a3,a5,0x30
    80003c5a:	92c1                	srli	a3,a3,0x30
    80003c5c:	4725                	li	a4,9
    80003c5e:	02d76863          	bltu	a4,a3,80003c8e <fileread+0xba>
    80003c62:	0792                	slli	a5,a5,0x4
    80003c64:	00015717          	auipc	a4,0x15
    80003c68:	46470713          	addi	a4,a4,1124 # 800190c8 <devsw>
    80003c6c:	97ba                	add	a5,a5,a4
    80003c6e:	639c                	ld	a5,0(a5)
    80003c70:	c38d                	beqz	a5,80003c92 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c72:	4505                	li	a0,1
    80003c74:	9782                	jalr	a5
    80003c76:	892a                	mv	s2,a0
    80003c78:	bf75                	j	80003c34 <fileread+0x60>
    panic("fileread");
    80003c7a:	00005517          	auipc	a0,0x5
    80003c7e:	b3650513          	addi	a0,a0,-1226 # 800087b0 <syscall_name+0x260>
    80003c82:	00002097          	auipc	ra,0x2
    80003c86:	026080e7          	jalr	38(ra) # 80005ca8 <panic>
    return -1;
    80003c8a:	597d                	li	s2,-1
    80003c8c:	b765                	j	80003c34 <fileread+0x60>
      return -1;
    80003c8e:	597d                	li	s2,-1
    80003c90:	b755                	j	80003c34 <fileread+0x60>
    80003c92:	597d                	li	s2,-1
    80003c94:	b745                	j	80003c34 <fileread+0x60>

0000000080003c96 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c96:	715d                	addi	sp,sp,-80
    80003c98:	e486                	sd	ra,72(sp)
    80003c9a:	e0a2                	sd	s0,64(sp)
    80003c9c:	fc26                	sd	s1,56(sp)
    80003c9e:	f84a                	sd	s2,48(sp)
    80003ca0:	f44e                	sd	s3,40(sp)
    80003ca2:	f052                	sd	s4,32(sp)
    80003ca4:	ec56                	sd	s5,24(sp)
    80003ca6:	e85a                	sd	s6,16(sp)
    80003ca8:	e45e                	sd	s7,8(sp)
    80003caa:	e062                	sd	s8,0(sp)
    80003cac:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003cae:	00954783          	lbu	a5,9(a0)
    80003cb2:	10078663          	beqz	a5,80003dbe <filewrite+0x128>
    80003cb6:	892a                	mv	s2,a0
    80003cb8:	8aae                	mv	s5,a1
    80003cba:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cbc:	411c                	lw	a5,0(a0)
    80003cbe:	4705                	li	a4,1
    80003cc0:	02e78263          	beq	a5,a4,80003ce4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cc4:	470d                	li	a4,3
    80003cc6:	02e78663          	beq	a5,a4,80003cf2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cca:	4709                	li	a4,2
    80003ccc:	0ee79163          	bne	a5,a4,80003dae <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cd0:	0ac05d63          	blez	a2,80003d8a <filewrite+0xf4>
    int i = 0;
    80003cd4:	4981                	li	s3,0
    80003cd6:	6b05                	lui	s6,0x1
    80003cd8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cdc:	6b85                	lui	s7,0x1
    80003cde:	c00b8b9b          	addiw	s7,s7,-1024
    80003ce2:	a861                	j	80003d7a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ce4:	6908                	ld	a0,16(a0)
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	22e080e7          	jalr	558(ra) # 80003f14 <pipewrite>
    80003cee:	8a2a                	mv	s4,a0
    80003cf0:	a045                	j	80003d90 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cf2:	02451783          	lh	a5,36(a0)
    80003cf6:	03079693          	slli	a3,a5,0x30
    80003cfa:	92c1                	srli	a3,a3,0x30
    80003cfc:	4725                	li	a4,9
    80003cfe:	0cd76263          	bltu	a4,a3,80003dc2 <filewrite+0x12c>
    80003d02:	0792                	slli	a5,a5,0x4
    80003d04:	00015717          	auipc	a4,0x15
    80003d08:	3c470713          	addi	a4,a4,964 # 800190c8 <devsw>
    80003d0c:	97ba                	add	a5,a5,a4
    80003d0e:	679c                	ld	a5,8(a5)
    80003d10:	cbdd                	beqz	a5,80003dc6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d12:	4505                	li	a0,1
    80003d14:	9782                	jalr	a5
    80003d16:	8a2a                	mv	s4,a0
    80003d18:	a8a5                	j	80003d90 <filewrite+0xfa>
    80003d1a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d1e:	00000097          	auipc	ra,0x0
    80003d22:	8b0080e7          	jalr	-1872(ra) # 800035ce <begin_op>
      ilock(f->ip);
    80003d26:	01893503          	ld	a0,24(s2)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	ed2080e7          	jalr	-302(ra) # 80002bfc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d32:	8762                	mv	a4,s8
    80003d34:	02092683          	lw	a3,32(s2)
    80003d38:	01598633          	add	a2,s3,s5
    80003d3c:	4585                	li	a1,1
    80003d3e:	01893503          	ld	a0,24(s2)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	266080e7          	jalr	614(ra) # 80002fa8 <writei>
    80003d4a:	84aa                	mv	s1,a0
    80003d4c:	00a05763          	blez	a0,80003d5a <filewrite+0xc4>
        f->off += r;
    80003d50:	02092783          	lw	a5,32(s2)
    80003d54:	9fa9                	addw	a5,a5,a0
    80003d56:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d5a:	01893503          	ld	a0,24(s2)
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	f60080e7          	jalr	-160(ra) # 80002cbe <iunlock>
      end_op();
    80003d66:	00000097          	auipc	ra,0x0
    80003d6a:	8e8080e7          	jalr	-1816(ra) # 8000364e <end_op>

      if(r != n1){
    80003d6e:	009c1f63          	bne	s8,s1,80003d8c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d72:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d76:	0149db63          	bge	s3,s4,80003d8c <filewrite+0xf6>
      int n1 = n - i;
    80003d7a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d7e:	84be                	mv	s1,a5
    80003d80:	2781                	sext.w	a5,a5
    80003d82:	f8fb5ce3          	bge	s6,a5,80003d1a <filewrite+0x84>
    80003d86:	84de                	mv	s1,s7
    80003d88:	bf49                	j	80003d1a <filewrite+0x84>
    int i = 0;
    80003d8a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d8c:	013a1f63          	bne	s4,s3,80003daa <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d90:	8552                	mv	a0,s4
    80003d92:	60a6                	ld	ra,72(sp)
    80003d94:	6406                	ld	s0,64(sp)
    80003d96:	74e2                	ld	s1,56(sp)
    80003d98:	7942                	ld	s2,48(sp)
    80003d9a:	79a2                	ld	s3,40(sp)
    80003d9c:	7a02                	ld	s4,32(sp)
    80003d9e:	6ae2                	ld	s5,24(sp)
    80003da0:	6b42                	ld	s6,16(sp)
    80003da2:	6ba2                	ld	s7,8(sp)
    80003da4:	6c02                	ld	s8,0(sp)
    80003da6:	6161                	addi	sp,sp,80
    80003da8:	8082                	ret
    ret = (i == n ? n : -1);
    80003daa:	5a7d                	li	s4,-1
    80003dac:	b7d5                	j	80003d90 <filewrite+0xfa>
    panic("filewrite");
    80003dae:	00005517          	auipc	a0,0x5
    80003db2:	a1250513          	addi	a0,a0,-1518 # 800087c0 <syscall_name+0x270>
    80003db6:	00002097          	auipc	ra,0x2
    80003dba:	ef2080e7          	jalr	-270(ra) # 80005ca8 <panic>
    return -1;
    80003dbe:	5a7d                	li	s4,-1
    80003dc0:	bfc1                	j	80003d90 <filewrite+0xfa>
      return -1;
    80003dc2:	5a7d                	li	s4,-1
    80003dc4:	b7f1                	j	80003d90 <filewrite+0xfa>
    80003dc6:	5a7d                	li	s4,-1
    80003dc8:	b7e1                	j	80003d90 <filewrite+0xfa>

0000000080003dca <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dca:	7179                	addi	sp,sp,-48
    80003dcc:	f406                	sd	ra,40(sp)
    80003dce:	f022                	sd	s0,32(sp)
    80003dd0:	ec26                	sd	s1,24(sp)
    80003dd2:	e84a                	sd	s2,16(sp)
    80003dd4:	e44e                	sd	s3,8(sp)
    80003dd6:	e052                	sd	s4,0(sp)
    80003dd8:	1800                	addi	s0,sp,48
    80003dda:	84aa                	mv	s1,a0
    80003ddc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dde:	0005b023          	sd	zero,0(a1)
    80003de2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	bf8080e7          	jalr	-1032(ra) # 800039de <filealloc>
    80003dee:	e088                	sd	a0,0(s1)
    80003df0:	c551                	beqz	a0,80003e7c <pipealloc+0xb2>
    80003df2:	00000097          	auipc	ra,0x0
    80003df6:	bec080e7          	jalr	-1044(ra) # 800039de <filealloc>
    80003dfa:	00aa3023          	sd	a0,0(s4)
    80003dfe:	c92d                	beqz	a0,80003e70 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e00:	ffffc097          	auipc	ra,0xffffc
    80003e04:	318080e7          	jalr	792(ra) # 80000118 <kalloc>
    80003e08:	892a                	mv	s2,a0
    80003e0a:	c125                	beqz	a0,80003e6a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e0c:	4985                	li	s3,1
    80003e0e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e12:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e16:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e1a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e1e:	00004597          	auipc	a1,0x4
    80003e22:	5ca58593          	addi	a1,a1,1482 # 800083e8 <states.1710+0x1a8>
    80003e26:	00002097          	auipc	ra,0x2
    80003e2a:	33c080e7          	jalr	828(ra) # 80006162 <initlock>
  (*f0)->type = FD_PIPE;
    80003e2e:	609c                	ld	a5,0(s1)
    80003e30:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e34:	609c                	ld	a5,0(s1)
    80003e36:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e3a:	609c                	ld	a5,0(s1)
    80003e3c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e40:	609c                	ld	a5,0(s1)
    80003e42:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e4e:	000a3783          	ld	a5,0(s4)
    80003e52:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e56:	000a3783          	ld	a5,0(s4)
    80003e5a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e5e:	000a3783          	ld	a5,0(s4)
    80003e62:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e66:	4501                	li	a0,0
    80003e68:	a025                	j	80003e90 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e6a:	6088                	ld	a0,0(s1)
    80003e6c:	e501                	bnez	a0,80003e74 <pipealloc+0xaa>
    80003e6e:	a039                	j	80003e7c <pipealloc+0xb2>
    80003e70:	6088                	ld	a0,0(s1)
    80003e72:	c51d                	beqz	a0,80003ea0 <pipealloc+0xd6>
    fileclose(*f0);
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	c26080e7          	jalr	-986(ra) # 80003a9a <fileclose>
  if(*f1)
    80003e7c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e80:	557d                	li	a0,-1
  if(*f1)
    80003e82:	c799                	beqz	a5,80003e90 <pipealloc+0xc6>
    fileclose(*f1);
    80003e84:	853e                	mv	a0,a5
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	c14080e7          	jalr	-1004(ra) # 80003a9a <fileclose>
  return -1;
    80003e8e:	557d                	li	a0,-1
}
    80003e90:	70a2                	ld	ra,40(sp)
    80003e92:	7402                	ld	s0,32(sp)
    80003e94:	64e2                	ld	s1,24(sp)
    80003e96:	6942                	ld	s2,16(sp)
    80003e98:	69a2                	ld	s3,8(sp)
    80003e9a:	6a02                	ld	s4,0(sp)
    80003e9c:	6145                	addi	sp,sp,48
    80003e9e:	8082                	ret
  return -1;
    80003ea0:	557d                	li	a0,-1
    80003ea2:	b7fd                	j	80003e90 <pipealloc+0xc6>

0000000080003ea4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ea4:	1101                	addi	sp,sp,-32
    80003ea6:	ec06                	sd	ra,24(sp)
    80003ea8:	e822                	sd	s0,16(sp)
    80003eaa:	e426                	sd	s1,8(sp)
    80003eac:	e04a                	sd	s2,0(sp)
    80003eae:	1000                	addi	s0,sp,32
    80003eb0:	84aa                	mv	s1,a0
    80003eb2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eb4:	00002097          	auipc	ra,0x2
    80003eb8:	33e080e7          	jalr	830(ra) # 800061f2 <acquire>
  if(writable){
    80003ebc:	02090d63          	beqz	s2,80003ef6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ec0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ec4:	21848513          	addi	a0,s1,536
    80003ec8:	ffffe097          	auipc	ra,0xffffe
    80003ecc:	81a080e7          	jalr	-2022(ra) # 800016e2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ed0:	2204b783          	ld	a5,544(s1)
    80003ed4:	eb95                	bnez	a5,80003f08 <pipeclose+0x64>
    release(&pi->lock);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	00002097          	auipc	ra,0x2
    80003edc:	3ce080e7          	jalr	974(ra) # 800062a6 <release>
    kfree((char*)pi);
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	ffffc097          	auipc	ra,0xffffc
    80003ee6:	13a080e7          	jalr	314(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eea:	60e2                	ld	ra,24(sp)
    80003eec:	6442                	ld	s0,16(sp)
    80003eee:	64a2                	ld	s1,8(sp)
    80003ef0:	6902                	ld	s2,0(sp)
    80003ef2:	6105                	addi	sp,sp,32
    80003ef4:	8082                	ret
    pi->readopen = 0;
    80003ef6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003efa:	21c48513          	addi	a0,s1,540
    80003efe:	ffffd097          	auipc	ra,0xffffd
    80003f02:	7e4080e7          	jalr	2020(ra) # 800016e2 <wakeup>
    80003f06:	b7e9                	j	80003ed0 <pipeclose+0x2c>
    release(&pi->lock);
    80003f08:	8526                	mv	a0,s1
    80003f0a:	00002097          	auipc	ra,0x2
    80003f0e:	39c080e7          	jalr	924(ra) # 800062a6 <release>
}
    80003f12:	bfe1                	j	80003eea <pipeclose+0x46>

0000000080003f14 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f14:	7159                	addi	sp,sp,-112
    80003f16:	f486                	sd	ra,104(sp)
    80003f18:	f0a2                	sd	s0,96(sp)
    80003f1a:	eca6                	sd	s1,88(sp)
    80003f1c:	e8ca                	sd	s2,80(sp)
    80003f1e:	e4ce                	sd	s3,72(sp)
    80003f20:	e0d2                	sd	s4,64(sp)
    80003f22:	fc56                	sd	s5,56(sp)
    80003f24:	f85a                	sd	s6,48(sp)
    80003f26:	f45e                	sd	s7,40(sp)
    80003f28:	f062                	sd	s8,32(sp)
    80003f2a:	ec66                	sd	s9,24(sp)
    80003f2c:	1880                	addi	s0,sp,112
    80003f2e:	84aa                	mv	s1,a0
    80003f30:	8aae                	mv	s5,a1
    80003f32:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	f5e080e7          	jalr	-162(ra) # 80000e92 <myproc>
    80003f3c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f3e:	8526                	mv	a0,s1
    80003f40:	00002097          	auipc	ra,0x2
    80003f44:	2b2080e7          	jalr	690(ra) # 800061f2 <acquire>
  while(i < n){
    80003f48:	0d405163          	blez	s4,8000400a <pipewrite+0xf6>
    80003f4c:	8ba6                	mv	s7,s1
  int i = 0;
    80003f4e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f50:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f52:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f56:	21c48c13          	addi	s8,s1,540
    80003f5a:	a08d                	j	80003fbc <pipewrite+0xa8>
      release(&pi->lock);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	00002097          	auipc	ra,0x2
    80003f62:	348080e7          	jalr	840(ra) # 800062a6 <release>
      return -1;
    80003f66:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f68:	854a                	mv	a0,s2
    80003f6a:	70a6                	ld	ra,104(sp)
    80003f6c:	7406                	ld	s0,96(sp)
    80003f6e:	64e6                	ld	s1,88(sp)
    80003f70:	6946                	ld	s2,80(sp)
    80003f72:	69a6                	ld	s3,72(sp)
    80003f74:	6a06                	ld	s4,64(sp)
    80003f76:	7ae2                	ld	s5,56(sp)
    80003f78:	7b42                	ld	s6,48(sp)
    80003f7a:	7ba2                	ld	s7,40(sp)
    80003f7c:	7c02                	ld	s8,32(sp)
    80003f7e:	6ce2                	ld	s9,24(sp)
    80003f80:	6165                	addi	sp,sp,112
    80003f82:	8082                	ret
      wakeup(&pi->nread);
    80003f84:	8566                	mv	a0,s9
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	75c080e7          	jalr	1884(ra) # 800016e2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f8e:	85de                	mv	a1,s7
    80003f90:	8562                	mv	a0,s8
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	5c4080e7          	jalr	1476(ra) # 80001556 <sleep>
    80003f9a:	a839                	j	80003fb8 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f9c:	21c4a783          	lw	a5,540(s1)
    80003fa0:	0017871b          	addiw	a4,a5,1
    80003fa4:	20e4ae23          	sw	a4,540(s1)
    80003fa8:	1ff7f793          	andi	a5,a5,511
    80003fac:	97a6                	add	a5,a5,s1
    80003fae:	f9f44703          	lbu	a4,-97(s0)
    80003fb2:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fb6:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fb8:	03495d63          	bge	s2,s4,80003ff2 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003fbc:	2204a783          	lw	a5,544(s1)
    80003fc0:	dfd1                	beqz	a5,80003f5c <pipewrite+0x48>
    80003fc2:	0289a783          	lw	a5,40(s3)
    80003fc6:	fbd9                	bnez	a5,80003f5c <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fc8:	2184a783          	lw	a5,536(s1)
    80003fcc:	21c4a703          	lw	a4,540(s1)
    80003fd0:	2007879b          	addiw	a5,a5,512
    80003fd4:	faf708e3          	beq	a4,a5,80003f84 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd8:	4685                	li	a3,1
    80003fda:	01590633          	add	a2,s2,s5
    80003fde:	f9f40593          	addi	a1,s0,-97
    80003fe2:	0509b503          	ld	a0,80(s3)
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	bfa080e7          	jalr	-1030(ra) # 80000be0 <copyin>
    80003fee:	fb6517e3          	bne	a0,s6,80003f9c <pipewrite+0x88>
  wakeup(&pi->nread);
    80003ff2:	21848513          	addi	a0,s1,536
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	6ec080e7          	jalr	1772(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    80003ffe:	8526                	mv	a0,s1
    80004000:	00002097          	auipc	ra,0x2
    80004004:	2a6080e7          	jalr	678(ra) # 800062a6 <release>
  return i;
    80004008:	b785                	j	80003f68 <pipewrite+0x54>
  int i = 0;
    8000400a:	4901                	li	s2,0
    8000400c:	b7dd                	j	80003ff2 <pipewrite+0xde>

000000008000400e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000400e:	715d                	addi	sp,sp,-80
    80004010:	e486                	sd	ra,72(sp)
    80004012:	e0a2                	sd	s0,64(sp)
    80004014:	fc26                	sd	s1,56(sp)
    80004016:	f84a                	sd	s2,48(sp)
    80004018:	f44e                	sd	s3,40(sp)
    8000401a:	f052                	sd	s4,32(sp)
    8000401c:	ec56                	sd	s5,24(sp)
    8000401e:	e85a                	sd	s6,16(sp)
    80004020:	0880                	addi	s0,sp,80
    80004022:	84aa                	mv	s1,a0
    80004024:	892e                	mv	s2,a1
    80004026:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004028:	ffffd097          	auipc	ra,0xffffd
    8000402c:	e6a080e7          	jalr	-406(ra) # 80000e92 <myproc>
    80004030:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004032:	8b26                	mv	s6,s1
    80004034:	8526                	mv	a0,s1
    80004036:	00002097          	auipc	ra,0x2
    8000403a:	1bc080e7          	jalr	444(ra) # 800061f2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403e:	2184a703          	lw	a4,536(s1)
    80004042:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004046:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000404a:	02f71463          	bne	a4,a5,80004072 <piperead+0x64>
    8000404e:	2244a783          	lw	a5,548(s1)
    80004052:	c385                	beqz	a5,80004072 <piperead+0x64>
    if(pr->killed){
    80004054:	028a2783          	lw	a5,40(s4)
    80004058:	ebc1                	bnez	a5,800040e8 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000405a:	85da                	mv	a1,s6
    8000405c:	854e                	mv	a0,s3
    8000405e:	ffffd097          	auipc	ra,0xffffd
    80004062:	4f8080e7          	jalr	1272(ra) # 80001556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004066:	2184a703          	lw	a4,536(s1)
    8000406a:	21c4a783          	lw	a5,540(s1)
    8000406e:	fef700e3          	beq	a4,a5,8000404e <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004072:	09505263          	blez	s5,800040f6 <piperead+0xe8>
    80004076:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004078:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000407a:	2184a783          	lw	a5,536(s1)
    8000407e:	21c4a703          	lw	a4,540(s1)
    80004082:	02f70d63          	beq	a4,a5,800040bc <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004086:	0017871b          	addiw	a4,a5,1
    8000408a:	20e4ac23          	sw	a4,536(s1)
    8000408e:	1ff7f793          	andi	a5,a5,511
    80004092:	97a6                	add	a5,a5,s1
    80004094:	0187c783          	lbu	a5,24(a5)
    80004098:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000409c:	4685                	li	a3,1
    8000409e:	fbf40613          	addi	a2,s0,-65
    800040a2:	85ca                	mv	a1,s2
    800040a4:	050a3503          	ld	a0,80(s4)
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	aac080e7          	jalr	-1364(ra) # 80000b54 <copyout>
    800040b0:	01650663          	beq	a0,s6,800040bc <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b4:	2985                	addiw	s3,s3,1
    800040b6:	0905                	addi	s2,s2,1
    800040b8:	fd3a91e3          	bne	s5,s3,8000407a <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040bc:	21c48513          	addi	a0,s1,540
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	622080e7          	jalr	1570(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    800040c8:	8526                	mv	a0,s1
    800040ca:	00002097          	auipc	ra,0x2
    800040ce:	1dc080e7          	jalr	476(ra) # 800062a6 <release>
  return i;
}
    800040d2:	854e                	mv	a0,s3
    800040d4:	60a6                	ld	ra,72(sp)
    800040d6:	6406                	ld	s0,64(sp)
    800040d8:	74e2                	ld	s1,56(sp)
    800040da:	7942                	ld	s2,48(sp)
    800040dc:	79a2                	ld	s3,40(sp)
    800040de:	7a02                	ld	s4,32(sp)
    800040e0:	6ae2                	ld	s5,24(sp)
    800040e2:	6b42                	ld	s6,16(sp)
    800040e4:	6161                	addi	sp,sp,80
    800040e6:	8082                	ret
      release(&pi->lock);
    800040e8:	8526                	mv	a0,s1
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	1bc080e7          	jalr	444(ra) # 800062a6 <release>
      return -1;
    800040f2:	59fd                	li	s3,-1
    800040f4:	bff9                	j	800040d2 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f6:	4981                	li	s3,0
    800040f8:	b7d1                	j	800040bc <piperead+0xae>

00000000800040fa <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040fa:	df010113          	addi	sp,sp,-528
    800040fe:	20113423          	sd	ra,520(sp)
    80004102:	20813023          	sd	s0,512(sp)
    80004106:	ffa6                	sd	s1,504(sp)
    80004108:	fbca                	sd	s2,496(sp)
    8000410a:	f7ce                	sd	s3,488(sp)
    8000410c:	f3d2                	sd	s4,480(sp)
    8000410e:	efd6                	sd	s5,472(sp)
    80004110:	ebda                	sd	s6,464(sp)
    80004112:	e7de                	sd	s7,456(sp)
    80004114:	e3e2                	sd	s8,448(sp)
    80004116:	ff66                	sd	s9,440(sp)
    80004118:	fb6a                	sd	s10,432(sp)
    8000411a:	f76e                	sd	s11,424(sp)
    8000411c:	0c00                	addi	s0,sp,528
    8000411e:	84aa                	mv	s1,a0
    80004120:	dea43c23          	sd	a0,-520(s0)
    80004124:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004128:	ffffd097          	auipc	ra,0xffffd
    8000412c:	d6a080e7          	jalr	-662(ra) # 80000e92 <myproc>
    80004130:	892a                	mv	s2,a0

  begin_op();
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	49c080e7          	jalr	1180(ra) # 800035ce <begin_op>

  if((ip = namei(path)) == 0){
    8000413a:	8526                	mv	a0,s1
    8000413c:	fffff097          	auipc	ra,0xfffff
    80004140:	276080e7          	jalr	630(ra) # 800033b2 <namei>
    80004144:	c92d                	beqz	a0,800041b6 <exec+0xbc>
    80004146:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	ab4080e7          	jalr	-1356(ra) # 80002bfc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004150:	04000713          	li	a4,64
    80004154:	4681                	li	a3,0
    80004156:	e5040613          	addi	a2,s0,-432
    8000415a:	4581                	li	a1,0
    8000415c:	8526                	mv	a0,s1
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	d52080e7          	jalr	-686(ra) # 80002eb0 <readi>
    80004166:	04000793          	li	a5,64
    8000416a:	00f51a63          	bne	a0,a5,8000417e <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000416e:	e5042703          	lw	a4,-432(s0)
    80004172:	464c47b7          	lui	a5,0x464c4
    80004176:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000417a:	04f70463          	beq	a4,a5,800041c2 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000417e:	8526                	mv	a0,s1
    80004180:	fffff097          	auipc	ra,0xfffff
    80004184:	cde080e7          	jalr	-802(ra) # 80002e5e <iunlockput>
    end_op();
    80004188:	fffff097          	auipc	ra,0xfffff
    8000418c:	4c6080e7          	jalr	1222(ra) # 8000364e <end_op>
  }
  return -1;
    80004190:	557d                	li	a0,-1
}
    80004192:	20813083          	ld	ra,520(sp)
    80004196:	20013403          	ld	s0,512(sp)
    8000419a:	74fe                	ld	s1,504(sp)
    8000419c:	795e                	ld	s2,496(sp)
    8000419e:	79be                	ld	s3,488(sp)
    800041a0:	7a1e                	ld	s4,480(sp)
    800041a2:	6afe                	ld	s5,472(sp)
    800041a4:	6b5e                	ld	s6,464(sp)
    800041a6:	6bbe                	ld	s7,456(sp)
    800041a8:	6c1e                	ld	s8,448(sp)
    800041aa:	7cfa                	ld	s9,440(sp)
    800041ac:	7d5a                	ld	s10,432(sp)
    800041ae:	7dba                	ld	s11,424(sp)
    800041b0:	21010113          	addi	sp,sp,528
    800041b4:	8082                	ret
    end_op();
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	498080e7          	jalr	1176(ra) # 8000364e <end_op>
    return -1;
    800041be:	557d                	li	a0,-1
    800041c0:	bfc9                	j	80004192 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041c2:	854a                	mv	a0,s2
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	d92080e7          	jalr	-622(ra) # 80000f56 <proc_pagetable>
    800041cc:	8baa                	mv	s7,a0
    800041ce:	d945                	beqz	a0,8000417e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041d0:	e7042983          	lw	s3,-400(s0)
    800041d4:	e8845783          	lhu	a5,-376(s0)
    800041d8:	c7ad                	beqz	a5,80004242 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041da:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041dc:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041de:	6c85                	lui	s9,0x1
    800041e0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041e4:	def43823          	sd	a5,-528(s0)
    800041e8:	a42d                	j	80004412 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041ea:	00004517          	auipc	a0,0x4
    800041ee:	5e650513          	addi	a0,a0,1510 # 800087d0 <syscall_name+0x280>
    800041f2:	00002097          	auipc	ra,0x2
    800041f6:	ab6080e7          	jalr	-1354(ra) # 80005ca8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041fa:	8756                	mv	a4,s5
    800041fc:	012d86bb          	addw	a3,s11,s2
    80004200:	4581                	li	a1,0
    80004202:	8526                	mv	a0,s1
    80004204:	fffff097          	auipc	ra,0xfffff
    80004208:	cac080e7          	jalr	-852(ra) # 80002eb0 <readi>
    8000420c:	2501                	sext.w	a0,a0
    8000420e:	1aaa9963          	bne	s5,a0,800043c0 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004212:	6785                	lui	a5,0x1
    80004214:	0127893b          	addw	s2,a5,s2
    80004218:	77fd                	lui	a5,0xfffff
    8000421a:	01478a3b          	addw	s4,a5,s4
    8000421e:	1f897163          	bgeu	s2,s8,80004400 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004222:	02091593          	slli	a1,s2,0x20
    80004226:	9181                	srli	a1,a1,0x20
    80004228:	95ea                	add	a1,a1,s10
    8000422a:	855e                	mv	a0,s7
    8000422c:	ffffc097          	auipc	ra,0xffffc
    80004230:	324080e7          	jalr	804(ra) # 80000550 <walkaddr>
    80004234:	862a                	mv	a2,a0
    if(pa == 0)
    80004236:	d955                	beqz	a0,800041ea <exec+0xf0>
      n = PGSIZE;
    80004238:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000423a:	fd9a70e3          	bgeu	s4,s9,800041fa <exec+0x100>
      n = sz - i;
    8000423e:	8ad2                	mv	s5,s4
    80004240:	bf6d                	j	800041fa <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004242:	4901                	li	s2,0
  iunlockput(ip);
    80004244:	8526                	mv	a0,s1
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	c18080e7          	jalr	-1000(ra) # 80002e5e <iunlockput>
  end_op();
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	400080e7          	jalr	1024(ra) # 8000364e <end_op>
  p = myproc();
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	c3c080e7          	jalr	-964(ra) # 80000e92 <myproc>
    8000425e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004260:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004264:	6785                	lui	a5,0x1
    80004266:	17fd                	addi	a5,a5,-1
    80004268:	993e                	add	s2,s2,a5
    8000426a:	757d                	lui	a0,0xfffff
    8000426c:	00a977b3          	and	a5,s2,a0
    80004270:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004274:	6609                	lui	a2,0x2
    80004276:	963e                	add	a2,a2,a5
    80004278:	85be                	mv	a1,a5
    8000427a:	855e                	mv	a0,s7
    8000427c:	ffffc097          	auipc	ra,0xffffc
    80004280:	688080e7          	jalr	1672(ra) # 80000904 <uvmalloc>
    80004284:	8b2a                	mv	s6,a0
  ip = 0;
    80004286:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004288:	12050c63          	beqz	a0,800043c0 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000428c:	75f9                	lui	a1,0xffffe
    8000428e:	95aa                	add	a1,a1,a0
    80004290:	855e                	mv	a0,s7
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	890080e7          	jalr	-1904(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    8000429a:	7c7d                	lui	s8,0xfffff
    8000429c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000429e:	e0043783          	ld	a5,-512(s0)
    800042a2:	6388                	ld	a0,0(a5)
    800042a4:	c535                	beqz	a0,80004310 <exec+0x216>
    800042a6:	e9040993          	addi	s3,s0,-368
    800042aa:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042ae:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042b0:	ffffc097          	auipc	ra,0xffffc
    800042b4:	096080e7          	jalr	150(ra) # 80000346 <strlen>
    800042b8:	2505                	addiw	a0,a0,1
    800042ba:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042be:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042c2:	13896363          	bltu	s2,s8,800043e8 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042c6:	e0043d83          	ld	s11,-512(s0)
    800042ca:	000dba03          	ld	s4,0(s11)
    800042ce:	8552                	mv	a0,s4
    800042d0:	ffffc097          	auipc	ra,0xffffc
    800042d4:	076080e7          	jalr	118(ra) # 80000346 <strlen>
    800042d8:	0015069b          	addiw	a3,a0,1
    800042dc:	8652                	mv	a2,s4
    800042de:	85ca                	mv	a1,s2
    800042e0:	855e                	mv	a0,s7
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	872080e7          	jalr	-1934(ra) # 80000b54 <copyout>
    800042ea:	10054363          	bltz	a0,800043f0 <exec+0x2f6>
    ustack[argc] = sp;
    800042ee:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042f2:	0485                	addi	s1,s1,1
    800042f4:	008d8793          	addi	a5,s11,8
    800042f8:	e0f43023          	sd	a5,-512(s0)
    800042fc:	008db503          	ld	a0,8(s11)
    80004300:	c911                	beqz	a0,80004314 <exec+0x21a>
    if(argc >= MAXARG)
    80004302:	09a1                	addi	s3,s3,8
    80004304:	fb3c96e3          	bne	s9,s3,800042b0 <exec+0x1b6>
  sz = sz1;
    80004308:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000430c:	4481                	li	s1,0
    8000430e:	a84d                	j	800043c0 <exec+0x2c6>
  sp = sz;
    80004310:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004312:	4481                	li	s1,0
  ustack[argc] = 0;
    80004314:	00349793          	slli	a5,s1,0x3
    80004318:	f9040713          	addi	a4,s0,-112
    8000431c:	97ba                	add	a5,a5,a4
    8000431e:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004322:	00148693          	addi	a3,s1,1
    80004326:	068e                	slli	a3,a3,0x3
    80004328:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000432c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004330:	01897663          	bgeu	s2,s8,8000433c <exec+0x242>
  sz = sz1;
    80004334:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004338:	4481                	li	s1,0
    8000433a:	a059                	j	800043c0 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000433c:	e9040613          	addi	a2,s0,-368
    80004340:	85ca                	mv	a1,s2
    80004342:	855e                	mv	a0,s7
    80004344:	ffffd097          	auipc	ra,0xffffd
    80004348:	810080e7          	jalr	-2032(ra) # 80000b54 <copyout>
    8000434c:	0a054663          	bltz	a0,800043f8 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004350:	058ab783          	ld	a5,88(s5)
    80004354:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004358:	df843783          	ld	a5,-520(s0)
    8000435c:	0007c703          	lbu	a4,0(a5)
    80004360:	cf11                	beqz	a4,8000437c <exec+0x282>
    80004362:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004364:	02f00693          	li	a3,47
    80004368:	a039                	j	80004376 <exec+0x27c>
      last = s+1;
    8000436a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000436e:	0785                	addi	a5,a5,1
    80004370:	fff7c703          	lbu	a4,-1(a5)
    80004374:	c701                	beqz	a4,8000437c <exec+0x282>
    if(*s == '/')
    80004376:	fed71ce3          	bne	a4,a3,8000436e <exec+0x274>
    8000437a:	bfc5                	j	8000436a <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000437c:	4641                	li	a2,16
    8000437e:	df843583          	ld	a1,-520(s0)
    80004382:	158a8513          	addi	a0,s5,344
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	f8e080e7          	jalr	-114(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    8000438e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004392:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004396:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000439a:	058ab783          	ld	a5,88(s5)
    8000439e:	e6843703          	ld	a4,-408(s0)
    800043a2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043a4:	058ab783          	ld	a5,88(s5)
    800043a8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043ac:	85ea                	mv	a1,s10
    800043ae:	ffffd097          	auipc	ra,0xffffd
    800043b2:	c44080e7          	jalr	-956(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043b6:	0004851b          	sext.w	a0,s1
    800043ba:	bbe1                	j	80004192 <exec+0x98>
    800043bc:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043c0:	e0843583          	ld	a1,-504(s0)
    800043c4:	855e                	mv	a0,s7
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	c2c080e7          	jalr	-980(ra) # 80000ff2 <proc_freepagetable>
  if(ip){
    800043ce:	da0498e3          	bnez	s1,8000417e <exec+0x84>
  return -1;
    800043d2:	557d                	li	a0,-1
    800043d4:	bb7d                	j	80004192 <exec+0x98>
    800043d6:	e1243423          	sd	s2,-504(s0)
    800043da:	b7dd                	j	800043c0 <exec+0x2c6>
    800043dc:	e1243423          	sd	s2,-504(s0)
    800043e0:	b7c5                	j	800043c0 <exec+0x2c6>
    800043e2:	e1243423          	sd	s2,-504(s0)
    800043e6:	bfe9                	j	800043c0 <exec+0x2c6>
  sz = sz1;
    800043e8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ec:	4481                	li	s1,0
    800043ee:	bfc9                	j	800043c0 <exec+0x2c6>
  sz = sz1;
    800043f0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043f4:	4481                	li	s1,0
    800043f6:	b7e9                	j	800043c0 <exec+0x2c6>
  sz = sz1;
    800043f8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043fc:	4481                	li	s1,0
    800043fe:	b7c9                	j	800043c0 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004400:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004404:	2b05                	addiw	s6,s6,1
    80004406:	0389899b          	addiw	s3,s3,56
    8000440a:	e8845783          	lhu	a5,-376(s0)
    8000440e:	e2fb5be3          	bge	s6,a5,80004244 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004412:	2981                	sext.w	s3,s3
    80004414:	03800713          	li	a4,56
    80004418:	86ce                	mv	a3,s3
    8000441a:	e1840613          	addi	a2,s0,-488
    8000441e:	4581                	li	a1,0
    80004420:	8526                	mv	a0,s1
    80004422:	fffff097          	auipc	ra,0xfffff
    80004426:	a8e080e7          	jalr	-1394(ra) # 80002eb0 <readi>
    8000442a:	03800793          	li	a5,56
    8000442e:	f8f517e3          	bne	a0,a5,800043bc <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004432:	e1842783          	lw	a5,-488(s0)
    80004436:	4705                	li	a4,1
    80004438:	fce796e3          	bne	a5,a4,80004404 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000443c:	e4043603          	ld	a2,-448(s0)
    80004440:	e3843783          	ld	a5,-456(s0)
    80004444:	f8f669e3          	bltu	a2,a5,800043d6 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004448:	e2843783          	ld	a5,-472(s0)
    8000444c:	963e                	add	a2,a2,a5
    8000444e:	f8f667e3          	bltu	a2,a5,800043dc <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004452:	85ca                	mv	a1,s2
    80004454:	855e                	mv	a0,s7
    80004456:	ffffc097          	auipc	ra,0xffffc
    8000445a:	4ae080e7          	jalr	1198(ra) # 80000904 <uvmalloc>
    8000445e:	e0a43423          	sd	a0,-504(s0)
    80004462:	d141                	beqz	a0,800043e2 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004464:	e2843d03          	ld	s10,-472(s0)
    80004468:	df043783          	ld	a5,-528(s0)
    8000446c:	00fd77b3          	and	a5,s10,a5
    80004470:	fba1                	bnez	a5,800043c0 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004472:	e2042d83          	lw	s11,-480(s0)
    80004476:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000447a:	f80c03e3          	beqz	s8,80004400 <exec+0x306>
    8000447e:	8a62                	mv	s4,s8
    80004480:	4901                	li	s2,0
    80004482:	b345                	j	80004222 <exec+0x128>

0000000080004484 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004484:	7179                	addi	sp,sp,-48
    80004486:	f406                	sd	ra,40(sp)
    80004488:	f022                	sd	s0,32(sp)
    8000448a:	ec26                	sd	s1,24(sp)
    8000448c:	e84a                	sd	s2,16(sp)
    8000448e:	1800                	addi	s0,sp,48
    80004490:	892e                	mv	s2,a1
    80004492:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004494:	fdc40593          	addi	a1,s0,-36
    80004498:	ffffe097          	auipc	ra,0xffffe
    8000449c:	b02080e7          	jalr	-1278(ra) # 80001f9a <argint>
    800044a0:	04054063          	bltz	a0,800044e0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044a4:	fdc42703          	lw	a4,-36(s0)
    800044a8:	47bd                	li	a5,15
    800044aa:	02e7ed63          	bltu	a5,a4,800044e4 <argfd+0x60>
    800044ae:	ffffd097          	auipc	ra,0xffffd
    800044b2:	9e4080e7          	jalr	-1564(ra) # 80000e92 <myproc>
    800044b6:	fdc42703          	lw	a4,-36(s0)
    800044ba:	01a70793          	addi	a5,a4,26
    800044be:	078e                	slli	a5,a5,0x3
    800044c0:	953e                	add	a0,a0,a5
    800044c2:	611c                	ld	a5,0(a0)
    800044c4:	c395                	beqz	a5,800044e8 <argfd+0x64>
    return -1;
  if(pfd)
    800044c6:	00090463          	beqz	s2,800044ce <argfd+0x4a>
    *pfd = fd;
    800044ca:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044ce:	4501                	li	a0,0
  if(pf)
    800044d0:	c091                	beqz	s1,800044d4 <argfd+0x50>
    *pf = f;
    800044d2:	e09c                	sd	a5,0(s1)
}
    800044d4:	70a2                	ld	ra,40(sp)
    800044d6:	7402                	ld	s0,32(sp)
    800044d8:	64e2                	ld	s1,24(sp)
    800044da:	6942                	ld	s2,16(sp)
    800044dc:	6145                	addi	sp,sp,48
    800044de:	8082                	ret
    return -1;
    800044e0:	557d                	li	a0,-1
    800044e2:	bfcd                	j	800044d4 <argfd+0x50>
    return -1;
    800044e4:	557d                	li	a0,-1
    800044e6:	b7fd                	j	800044d4 <argfd+0x50>
    800044e8:	557d                	li	a0,-1
    800044ea:	b7ed                	j	800044d4 <argfd+0x50>

00000000800044ec <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044ec:	1101                	addi	sp,sp,-32
    800044ee:	ec06                	sd	ra,24(sp)
    800044f0:	e822                	sd	s0,16(sp)
    800044f2:	e426                	sd	s1,8(sp)
    800044f4:	1000                	addi	s0,sp,32
    800044f6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044f8:	ffffd097          	auipc	ra,0xffffd
    800044fc:	99a080e7          	jalr	-1638(ra) # 80000e92 <myproc>
    80004500:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004502:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    80004506:	4501                	li	a0,0
    80004508:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000450a:	6398                	ld	a4,0(a5)
    8000450c:	cb19                	beqz	a4,80004522 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000450e:	2505                	addiw	a0,a0,1
    80004510:	07a1                	addi	a5,a5,8
    80004512:	fed51ce3          	bne	a0,a3,8000450a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004516:	557d                	li	a0,-1
}
    80004518:	60e2                	ld	ra,24(sp)
    8000451a:	6442                	ld	s0,16(sp)
    8000451c:	64a2                	ld	s1,8(sp)
    8000451e:	6105                	addi	sp,sp,32
    80004520:	8082                	ret
      p->ofile[fd] = f;
    80004522:	01a50793          	addi	a5,a0,26
    80004526:	078e                	slli	a5,a5,0x3
    80004528:	963e                	add	a2,a2,a5
    8000452a:	e204                	sd	s1,0(a2)
      return fd;
    8000452c:	b7f5                	j	80004518 <fdalloc+0x2c>

000000008000452e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000452e:	715d                	addi	sp,sp,-80
    80004530:	e486                	sd	ra,72(sp)
    80004532:	e0a2                	sd	s0,64(sp)
    80004534:	fc26                	sd	s1,56(sp)
    80004536:	f84a                	sd	s2,48(sp)
    80004538:	f44e                	sd	s3,40(sp)
    8000453a:	f052                	sd	s4,32(sp)
    8000453c:	ec56                	sd	s5,24(sp)
    8000453e:	0880                	addi	s0,sp,80
    80004540:	89ae                	mv	s3,a1
    80004542:	8ab2                	mv	s5,a2
    80004544:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004546:	fb040593          	addi	a1,s0,-80
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	e86080e7          	jalr	-378(ra) # 800033d0 <nameiparent>
    80004552:	892a                	mv	s2,a0
    80004554:	12050f63          	beqz	a0,80004692 <create+0x164>
    return 0;

  ilock(dp);
    80004558:	ffffe097          	auipc	ra,0xffffe
    8000455c:	6a4080e7          	jalr	1700(ra) # 80002bfc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004560:	4601                	li	a2,0
    80004562:	fb040593          	addi	a1,s0,-80
    80004566:	854a                	mv	a0,s2
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	b78080e7          	jalr	-1160(ra) # 800030e0 <dirlookup>
    80004570:	84aa                	mv	s1,a0
    80004572:	c921                	beqz	a0,800045c2 <create+0x94>
    iunlockput(dp);
    80004574:	854a                	mv	a0,s2
    80004576:	fffff097          	auipc	ra,0xfffff
    8000457a:	8e8080e7          	jalr	-1816(ra) # 80002e5e <iunlockput>
    ilock(ip);
    8000457e:	8526                	mv	a0,s1
    80004580:	ffffe097          	auipc	ra,0xffffe
    80004584:	67c080e7          	jalr	1660(ra) # 80002bfc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004588:	2981                	sext.w	s3,s3
    8000458a:	4789                	li	a5,2
    8000458c:	02f99463          	bne	s3,a5,800045b4 <create+0x86>
    80004590:	0444d783          	lhu	a5,68(s1)
    80004594:	37f9                	addiw	a5,a5,-2
    80004596:	17c2                	slli	a5,a5,0x30
    80004598:	93c1                	srli	a5,a5,0x30
    8000459a:	4705                	li	a4,1
    8000459c:	00f76c63          	bltu	a4,a5,800045b4 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045a0:	8526                	mv	a0,s1
    800045a2:	60a6                	ld	ra,72(sp)
    800045a4:	6406                	ld	s0,64(sp)
    800045a6:	74e2                	ld	s1,56(sp)
    800045a8:	7942                	ld	s2,48(sp)
    800045aa:	79a2                	ld	s3,40(sp)
    800045ac:	7a02                	ld	s4,32(sp)
    800045ae:	6ae2                	ld	s5,24(sp)
    800045b0:	6161                	addi	sp,sp,80
    800045b2:	8082                	ret
    iunlockput(ip);
    800045b4:	8526                	mv	a0,s1
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	8a8080e7          	jalr	-1880(ra) # 80002e5e <iunlockput>
    return 0;
    800045be:	4481                	li	s1,0
    800045c0:	b7c5                	j	800045a0 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045c2:	85ce                	mv	a1,s3
    800045c4:	00092503          	lw	a0,0(s2)
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	49c080e7          	jalr	1180(ra) # 80002a64 <ialloc>
    800045d0:	84aa                	mv	s1,a0
    800045d2:	c529                	beqz	a0,8000461c <create+0xee>
  ilock(ip);
    800045d4:	ffffe097          	auipc	ra,0xffffe
    800045d8:	628080e7          	jalr	1576(ra) # 80002bfc <ilock>
  ip->major = major;
    800045dc:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045e0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045e4:	4785                	li	a5,1
    800045e6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045ea:	8526                	mv	a0,s1
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	546080e7          	jalr	1350(ra) # 80002b32 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045f4:	2981                	sext.w	s3,s3
    800045f6:	4785                	li	a5,1
    800045f8:	02f98a63          	beq	s3,a5,8000462c <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045fc:	40d0                	lw	a2,4(s1)
    800045fe:	fb040593          	addi	a1,s0,-80
    80004602:	854a                	mv	a0,s2
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	cec080e7          	jalr	-788(ra) # 800032f0 <dirlink>
    8000460c:	06054b63          	bltz	a0,80004682 <create+0x154>
  iunlockput(dp);
    80004610:	854a                	mv	a0,s2
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	84c080e7          	jalr	-1972(ra) # 80002e5e <iunlockput>
  return ip;
    8000461a:	b759                	j	800045a0 <create+0x72>
    panic("create: ialloc");
    8000461c:	00004517          	auipc	a0,0x4
    80004620:	1d450513          	addi	a0,a0,468 # 800087f0 <syscall_name+0x2a0>
    80004624:	00001097          	auipc	ra,0x1
    80004628:	684080e7          	jalr	1668(ra) # 80005ca8 <panic>
    dp->nlink++;  // for ".."
    8000462c:	04a95783          	lhu	a5,74(s2)
    80004630:	2785                	addiw	a5,a5,1
    80004632:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004636:	854a                	mv	a0,s2
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	4fa080e7          	jalr	1274(ra) # 80002b32 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004640:	40d0                	lw	a2,4(s1)
    80004642:	00004597          	auipc	a1,0x4
    80004646:	1be58593          	addi	a1,a1,446 # 80008800 <syscall_name+0x2b0>
    8000464a:	8526                	mv	a0,s1
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	ca4080e7          	jalr	-860(ra) # 800032f0 <dirlink>
    80004654:	00054f63          	bltz	a0,80004672 <create+0x144>
    80004658:	00492603          	lw	a2,4(s2)
    8000465c:	00004597          	auipc	a1,0x4
    80004660:	1ac58593          	addi	a1,a1,428 # 80008808 <syscall_name+0x2b8>
    80004664:	8526                	mv	a0,s1
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	c8a080e7          	jalr	-886(ra) # 800032f0 <dirlink>
    8000466e:	f80557e3          	bgez	a0,800045fc <create+0xce>
      panic("create dots");
    80004672:	00004517          	auipc	a0,0x4
    80004676:	19e50513          	addi	a0,a0,414 # 80008810 <syscall_name+0x2c0>
    8000467a:	00001097          	auipc	ra,0x1
    8000467e:	62e080e7          	jalr	1582(ra) # 80005ca8 <panic>
    panic("create: dirlink");
    80004682:	00004517          	auipc	a0,0x4
    80004686:	19e50513          	addi	a0,a0,414 # 80008820 <syscall_name+0x2d0>
    8000468a:	00001097          	auipc	ra,0x1
    8000468e:	61e080e7          	jalr	1566(ra) # 80005ca8 <panic>
    return 0;
    80004692:	84aa                	mv	s1,a0
    80004694:	b731                	j	800045a0 <create+0x72>

0000000080004696 <sys_dup>:
{
    80004696:	7179                	addi	sp,sp,-48
    80004698:	f406                	sd	ra,40(sp)
    8000469a:	f022                	sd	s0,32(sp)
    8000469c:	ec26                	sd	s1,24(sp)
    8000469e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046a0:	fd840613          	addi	a2,s0,-40
    800046a4:	4581                	li	a1,0
    800046a6:	4501                	li	a0,0
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	ddc080e7          	jalr	-548(ra) # 80004484 <argfd>
    return -1;
    800046b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046b2:	02054363          	bltz	a0,800046d8 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046b6:	fd843503          	ld	a0,-40(s0)
    800046ba:	00000097          	auipc	ra,0x0
    800046be:	e32080e7          	jalr	-462(ra) # 800044ec <fdalloc>
    800046c2:	84aa                	mv	s1,a0
    return -1;
    800046c4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046c6:	00054963          	bltz	a0,800046d8 <sys_dup+0x42>
  filedup(f);
    800046ca:	fd843503          	ld	a0,-40(s0)
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	37a080e7          	jalr	890(ra) # 80003a48 <filedup>
  return fd;
    800046d6:	87a6                	mv	a5,s1
}
    800046d8:	853e                	mv	a0,a5
    800046da:	70a2                	ld	ra,40(sp)
    800046dc:	7402                	ld	s0,32(sp)
    800046de:	64e2                	ld	s1,24(sp)
    800046e0:	6145                	addi	sp,sp,48
    800046e2:	8082                	ret

00000000800046e4 <sys_read>:
{
    800046e4:	7179                	addi	sp,sp,-48
    800046e6:	f406                	sd	ra,40(sp)
    800046e8:	f022                	sd	s0,32(sp)
    800046ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ec:	fe840613          	addi	a2,s0,-24
    800046f0:	4581                	li	a1,0
    800046f2:	4501                	li	a0,0
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	d90080e7          	jalr	-624(ra) # 80004484 <argfd>
    return -1;
    800046fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fe:	04054163          	bltz	a0,80004740 <sys_read+0x5c>
    80004702:	fe440593          	addi	a1,s0,-28
    80004706:	4509                	li	a0,2
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	892080e7          	jalr	-1902(ra) # 80001f9a <argint>
    return -1;
    80004710:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004712:	02054763          	bltz	a0,80004740 <sys_read+0x5c>
    80004716:	fd840593          	addi	a1,s0,-40
    8000471a:	4505                	li	a0,1
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	8a0080e7          	jalr	-1888(ra) # 80001fbc <argaddr>
    return -1;
    80004724:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004726:	00054d63          	bltz	a0,80004740 <sys_read+0x5c>
  return fileread(f, p, n);
    8000472a:	fe442603          	lw	a2,-28(s0)
    8000472e:	fd843583          	ld	a1,-40(s0)
    80004732:	fe843503          	ld	a0,-24(s0)
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	49e080e7          	jalr	1182(ra) # 80003bd4 <fileread>
    8000473e:	87aa                	mv	a5,a0
}
    80004740:	853e                	mv	a0,a5
    80004742:	70a2                	ld	ra,40(sp)
    80004744:	7402                	ld	s0,32(sp)
    80004746:	6145                	addi	sp,sp,48
    80004748:	8082                	ret

000000008000474a <sys_write>:
{
    8000474a:	7179                	addi	sp,sp,-48
    8000474c:	f406                	sd	ra,40(sp)
    8000474e:	f022                	sd	s0,32(sp)
    80004750:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004752:	fe840613          	addi	a2,s0,-24
    80004756:	4581                	li	a1,0
    80004758:	4501                	li	a0,0
    8000475a:	00000097          	auipc	ra,0x0
    8000475e:	d2a080e7          	jalr	-726(ra) # 80004484 <argfd>
    return -1;
    80004762:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004764:	04054163          	bltz	a0,800047a6 <sys_write+0x5c>
    80004768:	fe440593          	addi	a1,s0,-28
    8000476c:	4509                	li	a0,2
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	82c080e7          	jalr	-2004(ra) # 80001f9a <argint>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004778:	02054763          	bltz	a0,800047a6 <sys_write+0x5c>
    8000477c:	fd840593          	addi	a1,s0,-40
    80004780:	4505                	li	a0,1
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	83a080e7          	jalr	-1990(ra) # 80001fbc <argaddr>
    return -1;
    8000478a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000478c:	00054d63          	bltz	a0,800047a6 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004790:	fe442603          	lw	a2,-28(s0)
    80004794:	fd843583          	ld	a1,-40(s0)
    80004798:	fe843503          	ld	a0,-24(s0)
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	4fa080e7          	jalr	1274(ra) # 80003c96 <filewrite>
    800047a4:	87aa                	mv	a5,a0
}
    800047a6:	853e                	mv	a0,a5
    800047a8:	70a2                	ld	ra,40(sp)
    800047aa:	7402                	ld	s0,32(sp)
    800047ac:	6145                	addi	sp,sp,48
    800047ae:	8082                	ret

00000000800047b0 <sys_close>:
{
    800047b0:	1101                	addi	sp,sp,-32
    800047b2:	ec06                	sd	ra,24(sp)
    800047b4:	e822                	sd	s0,16(sp)
    800047b6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047b8:	fe040613          	addi	a2,s0,-32
    800047bc:	fec40593          	addi	a1,s0,-20
    800047c0:	4501                	li	a0,0
    800047c2:	00000097          	auipc	ra,0x0
    800047c6:	cc2080e7          	jalr	-830(ra) # 80004484 <argfd>
    return -1;
    800047ca:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047cc:	02054463          	bltz	a0,800047f4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047d0:	ffffc097          	auipc	ra,0xffffc
    800047d4:	6c2080e7          	jalr	1730(ra) # 80000e92 <myproc>
    800047d8:	fec42783          	lw	a5,-20(s0)
    800047dc:	07e9                	addi	a5,a5,26
    800047de:	078e                	slli	a5,a5,0x3
    800047e0:	97aa                	add	a5,a5,a0
    800047e2:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047e6:	fe043503          	ld	a0,-32(s0)
    800047ea:	fffff097          	auipc	ra,0xfffff
    800047ee:	2b0080e7          	jalr	688(ra) # 80003a9a <fileclose>
  return 0;
    800047f2:	4781                	li	a5,0
}
    800047f4:	853e                	mv	a0,a5
    800047f6:	60e2                	ld	ra,24(sp)
    800047f8:	6442                	ld	s0,16(sp)
    800047fa:	6105                	addi	sp,sp,32
    800047fc:	8082                	ret

00000000800047fe <sys_fstat>:
{
    800047fe:	1101                	addi	sp,sp,-32
    80004800:	ec06                	sd	ra,24(sp)
    80004802:	e822                	sd	s0,16(sp)
    80004804:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004806:	fe840613          	addi	a2,s0,-24
    8000480a:	4581                	li	a1,0
    8000480c:	4501                	li	a0,0
    8000480e:	00000097          	auipc	ra,0x0
    80004812:	c76080e7          	jalr	-906(ra) # 80004484 <argfd>
    return -1;
    80004816:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004818:	02054563          	bltz	a0,80004842 <sys_fstat+0x44>
    8000481c:	fe040593          	addi	a1,s0,-32
    80004820:	4505                	li	a0,1
    80004822:	ffffd097          	auipc	ra,0xffffd
    80004826:	79a080e7          	jalr	1946(ra) # 80001fbc <argaddr>
    return -1;
    8000482a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000482c:	00054b63          	bltz	a0,80004842 <sys_fstat+0x44>
  return filestat(f, st);
    80004830:	fe043583          	ld	a1,-32(s0)
    80004834:	fe843503          	ld	a0,-24(s0)
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	32a080e7          	jalr	810(ra) # 80003b62 <filestat>
    80004840:	87aa                	mv	a5,a0
}
    80004842:	853e                	mv	a0,a5
    80004844:	60e2                	ld	ra,24(sp)
    80004846:	6442                	ld	s0,16(sp)
    80004848:	6105                	addi	sp,sp,32
    8000484a:	8082                	ret

000000008000484c <sys_link>:
{
    8000484c:	7169                	addi	sp,sp,-304
    8000484e:	f606                	sd	ra,296(sp)
    80004850:	f222                	sd	s0,288(sp)
    80004852:	ee26                	sd	s1,280(sp)
    80004854:	ea4a                	sd	s2,272(sp)
    80004856:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004858:	08000613          	li	a2,128
    8000485c:	ed040593          	addi	a1,s0,-304
    80004860:	4501                	li	a0,0
    80004862:	ffffd097          	auipc	ra,0xffffd
    80004866:	77c080e7          	jalr	1916(ra) # 80001fde <argstr>
    return -1;
    8000486a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000486c:	10054e63          	bltz	a0,80004988 <sys_link+0x13c>
    80004870:	08000613          	li	a2,128
    80004874:	f5040593          	addi	a1,s0,-176
    80004878:	4505                	li	a0,1
    8000487a:	ffffd097          	auipc	ra,0xffffd
    8000487e:	764080e7          	jalr	1892(ra) # 80001fde <argstr>
    return -1;
    80004882:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004884:	10054263          	bltz	a0,80004988 <sys_link+0x13c>
  begin_op();
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	d46080e7          	jalr	-698(ra) # 800035ce <begin_op>
  if((ip = namei(old)) == 0){
    80004890:	ed040513          	addi	a0,s0,-304
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	b1e080e7          	jalr	-1250(ra) # 800033b2 <namei>
    8000489c:	84aa                	mv	s1,a0
    8000489e:	c551                	beqz	a0,8000492a <sys_link+0xde>
  ilock(ip);
    800048a0:	ffffe097          	auipc	ra,0xffffe
    800048a4:	35c080e7          	jalr	860(ra) # 80002bfc <ilock>
  if(ip->type == T_DIR){
    800048a8:	04449703          	lh	a4,68(s1)
    800048ac:	4785                	li	a5,1
    800048ae:	08f70463          	beq	a4,a5,80004936 <sys_link+0xea>
  ip->nlink++;
    800048b2:	04a4d783          	lhu	a5,74(s1)
    800048b6:	2785                	addiw	a5,a5,1
    800048b8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	274080e7          	jalr	628(ra) # 80002b32 <iupdate>
  iunlock(ip);
    800048c6:	8526                	mv	a0,s1
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	3f6080e7          	jalr	1014(ra) # 80002cbe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048d0:	fd040593          	addi	a1,s0,-48
    800048d4:	f5040513          	addi	a0,s0,-176
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	af8080e7          	jalr	-1288(ra) # 800033d0 <nameiparent>
    800048e0:	892a                	mv	s2,a0
    800048e2:	c935                	beqz	a0,80004956 <sys_link+0x10a>
  ilock(dp);
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	318080e7          	jalr	792(ra) # 80002bfc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048ec:	00092703          	lw	a4,0(s2)
    800048f0:	409c                	lw	a5,0(s1)
    800048f2:	04f71d63          	bne	a4,a5,8000494c <sys_link+0x100>
    800048f6:	40d0                	lw	a2,4(s1)
    800048f8:	fd040593          	addi	a1,s0,-48
    800048fc:	854a                	mv	a0,s2
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	9f2080e7          	jalr	-1550(ra) # 800032f0 <dirlink>
    80004906:	04054363          	bltz	a0,8000494c <sys_link+0x100>
  iunlockput(dp);
    8000490a:	854a                	mv	a0,s2
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	552080e7          	jalr	1362(ra) # 80002e5e <iunlockput>
  iput(ip);
    80004914:	8526                	mv	a0,s1
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	4a0080e7          	jalr	1184(ra) # 80002db6 <iput>
  end_op();
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	d30080e7          	jalr	-720(ra) # 8000364e <end_op>
  return 0;
    80004926:	4781                	li	a5,0
    80004928:	a085                	j	80004988 <sys_link+0x13c>
    end_op();
    8000492a:	fffff097          	auipc	ra,0xfffff
    8000492e:	d24080e7          	jalr	-732(ra) # 8000364e <end_op>
    return -1;
    80004932:	57fd                	li	a5,-1
    80004934:	a891                	j	80004988 <sys_link+0x13c>
    iunlockput(ip);
    80004936:	8526                	mv	a0,s1
    80004938:	ffffe097          	auipc	ra,0xffffe
    8000493c:	526080e7          	jalr	1318(ra) # 80002e5e <iunlockput>
    end_op();
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	d0e080e7          	jalr	-754(ra) # 8000364e <end_op>
    return -1;
    80004948:	57fd                	li	a5,-1
    8000494a:	a83d                	j	80004988 <sys_link+0x13c>
    iunlockput(dp);
    8000494c:	854a                	mv	a0,s2
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	510080e7          	jalr	1296(ra) # 80002e5e <iunlockput>
  ilock(ip);
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	2a4080e7          	jalr	676(ra) # 80002bfc <ilock>
  ip->nlink--;
    80004960:	04a4d783          	lhu	a5,74(s1)
    80004964:	37fd                	addiw	a5,a5,-1
    80004966:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	1c6080e7          	jalr	454(ra) # 80002b32 <iupdate>
  iunlockput(ip);
    80004974:	8526                	mv	a0,s1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	4e8080e7          	jalr	1256(ra) # 80002e5e <iunlockput>
  end_op();
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	cd0080e7          	jalr	-816(ra) # 8000364e <end_op>
  return -1;
    80004986:	57fd                	li	a5,-1
}
    80004988:	853e                	mv	a0,a5
    8000498a:	70b2                	ld	ra,296(sp)
    8000498c:	7412                	ld	s0,288(sp)
    8000498e:	64f2                	ld	s1,280(sp)
    80004990:	6952                	ld	s2,272(sp)
    80004992:	6155                	addi	sp,sp,304
    80004994:	8082                	ret

0000000080004996 <sys_unlink>:
{
    80004996:	7151                	addi	sp,sp,-240
    80004998:	f586                	sd	ra,232(sp)
    8000499a:	f1a2                	sd	s0,224(sp)
    8000499c:	eda6                	sd	s1,216(sp)
    8000499e:	e9ca                	sd	s2,208(sp)
    800049a0:	e5ce                	sd	s3,200(sp)
    800049a2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049a4:	08000613          	li	a2,128
    800049a8:	f3040593          	addi	a1,s0,-208
    800049ac:	4501                	li	a0,0
    800049ae:	ffffd097          	auipc	ra,0xffffd
    800049b2:	630080e7          	jalr	1584(ra) # 80001fde <argstr>
    800049b6:	18054163          	bltz	a0,80004b38 <sys_unlink+0x1a2>
  begin_op();
    800049ba:	fffff097          	auipc	ra,0xfffff
    800049be:	c14080e7          	jalr	-1004(ra) # 800035ce <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049c2:	fb040593          	addi	a1,s0,-80
    800049c6:	f3040513          	addi	a0,s0,-208
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	a06080e7          	jalr	-1530(ra) # 800033d0 <nameiparent>
    800049d2:	84aa                	mv	s1,a0
    800049d4:	c979                	beqz	a0,80004aaa <sys_unlink+0x114>
  ilock(dp);
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	226080e7          	jalr	550(ra) # 80002bfc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049de:	00004597          	auipc	a1,0x4
    800049e2:	e2258593          	addi	a1,a1,-478 # 80008800 <syscall_name+0x2b0>
    800049e6:	fb040513          	addi	a0,s0,-80
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	6dc080e7          	jalr	1756(ra) # 800030c6 <namecmp>
    800049f2:	14050a63          	beqz	a0,80004b46 <sys_unlink+0x1b0>
    800049f6:	00004597          	auipc	a1,0x4
    800049fa:	e1258593          	addi	a1,a1,-494 # 80008808 <syscall_name+0x2b8>
    800049fe:	fb040513          	addi	a0,s0,-80
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	6c4080e7          	jalr	1732(ra) # 800030c6 <namecmp>
    80004a0a:	12050e63          	beqz	a0,80004b46 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a0e:	f2c40613          	addi	a2,s0,-212
    80004a12:	fb040593          	addi	a1,s0,-80
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	6c8080e7          	jalr	1736(ra) # 800030e0 <dirlookup>
    80004a20:	892a                	mv	s2,a0
    80004a22:	12050263          	beqz	a0,80004b46 <sys_unlink+0x1b0>
  ilock(ip);
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	1d6080e7          	jalr	470(ra) # 80002bfc <ilock>
  if(ip->nlink < 1)
    80004a2e:	04a91783          	lh	a5,74(s2)
    80004a32:	08f05263          	blez	a5,80004ab6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a36:	04491703          	lh	a4,68(s2)
    80004a3a:	4785                	li	a5,1
    80004a3c:	08f70563          	beq	a4,a5,80004ac6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a40:	4641                	li	a2,16
    80004a42:	4581                	li	a1,0
    80004a44:	fc040513          	addi	a0,s0,-64
    80004a48:	ffffb097          	auipc	ra,0xffffb
    80004a4c:	77a080e7          	jalr	1914(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a50:	4741                	li	a4,16
    80004a52:	f2c42683          	lw	a3,-212(s0)
    80004a56:	fc040613          	addi	a2,s0,-64
    80004a5a:	4581                	li	a1,0
    80004a5c:	8526                	mv	a0,s1
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	54a080e7          	jalr	1354(ra) # 80002fa8 <writei>
    80004a66:	47c1                	li	a5,16
    80004a68:	0af51563          	bne	a0,a5,80004b12 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a6c:	04491703          	lh	a4,68(s2)
    80004a70:	4785                	li	a5,1
    80004a72:	0af70863          	beq	a4,a5,80004b22 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a76:	8526                	mv	a0,s1
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	3e6080e7          	jalr	998(ra) # 80002e5e <iunlockput>
  ip->nlink--;
    80004a80:	04a95783          	lhu	a5,74(s2)
    80004a84:	37fd                	addiw	a5,a5,-1
    80004a86:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a8a:	854a                	mv	a0,s2
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	0a6080e7          	jalr	166(ra) # 80002b32 <iupdate>
  iunlockput(ip);
    80004a94:	854a                	mv	a0,s2
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	3c8080e7          	jalr	968(ra) # 80002e5e <iunlockput>
  end_op();
    80004a9e:	fffff097          	auipc	ra,0xfffff
    80004aa2:	bb0080e7          	jalr	-1104(ra) # 8000364e <end_op>
  return 0;
    80004aa6:	4501                	li	a0,0
    80004aa8:	a84d                	j	80004b5a <sys_unlink+0x1c4>
    end_op();
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	ba4080e7          	jalr	-1116(ra) # 8000364e <end_op>
    return -1;
    80004ab2:	557d                	li	a0,-1
    80004ab4:	a05d                	j	80004b5a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ab6:	00004517          	auipc	a0,0x4
    80004aba:	d7a50513          	addi	a0,a0,-646 # 80008830 <syscall_name+0x2e0>
    80004abe:	00001097          	auipc	ra,0x1
    80004ac2:	1ea080e7          	jalr	490(ra) # 80005ca8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ac6:	04c92703          	lw	a4,76(s2)
    80004aca:	02000793          	li	a5,32
    80004ace:	f6e7f9e3          	bgeu	a5,a4,80004a40 <sys_unlink+0xaa>
    80004ad2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ad6:	4741                	li	a4,16
    80004ad8:	86ce                	mv	a3,s3
    80004ada:	f1840613          	addi	a2,s0,-232
    80004ade:	4581                	li	a1,0
    80004ae0:	854a                	mv	a0,s2
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	3ce080e7          	jalr	974(ra) # 80002eb0 <readi>
    80004aea:	47c1                	li	a5,16
    80004aec:	00f51b63          	bne	a0,a5,80004b02 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004af0:	f1845783          	lhu	a5,-232(s0)
    80004af4:	e7a1                	bnez	a5,80004b3c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004af6:	29c1                	addiw	s3,s3,16
    80004af8:	04c92783          	lw	a5,76(s2)
    80004afc:	fcf9ede3          	bltu	s3,a5,80004ad6 <sys_unlink+0x140>
    80004b00:	b781                	j	80004a40 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b02:	00004517          	auipc	a0,0x4
    80004b06:	d4650513          	addi	a0,a0,-698 # 80008848 <syscall_name+0x2f8>
    80004b0a:	00001097          	auipc	ra,0x1
    80004b0e:	19e080e7          	jalr	414(ra) # 80005ca8 <panic>
    panic("unlink: writei");
    80004b12:	00004517          	auipc	a0,0x4
    80004b16:	d4e50513          	addi	a0,a0,-690 # 80008860 <syscall_name+0x310>
    80004b1a:	00001097          	auipc	ra,0x1
    80004b1e:	18e080e7          	jalr	398(ra) # 80005ca8 <panic>
    dp->nlink--;
    80004b22:	04a4d783          	lhu	a5,74(s1)
    80004b26:	37fd                	addiw	a5,a5,-1
    80004b28:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	004080e7          	jalr	4(ra) # 80002b32 <iupdate>
    80004b36:	b781                	j	80004a76 <sys_unlink+0xe0>
    return -1;
    80004b38:	557d                	li	a0,-1
    80004b3a:	a005                	j	80004b5a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b3c:	854a                	mv	a0,s2
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	320080e7          	jalr	800(ra) # 80002e5e <iunlockput>
  iunlockput(dp);
    80004b46:	8526                	mv	a0,s1
    80004b48:	ffffe097          	auipc	ra,0xffffe
    80004b4c:	316080e7          	jalr	790(ra) # 80002e5e <iunlockput>
  end_op();
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	afe080e7          	jalr	-1282(ra) # 8000364e <end_op>
  return -1;
    80004b58:	557d                	li	a0,-1
}
    80004b5a:	70ae                	ld	ra,232(sp)
    80004b5c:	740e                	ld	s0,224(sp)
    80004b5e:	64ee                	ld	s1,216(sp)
    80004b60:	694e                	ld	s2,208(sp)
    80004b62:	69ae                	ld	s3,200(sp)
    80004b64:	616d                	addi	sp,sp,240
    80004b66:	8082                	ret

0000000080004b68 <sys_open>:

uint64
sys_open(void)
{
    80004b68:	7131                	addi	sp,sp,-192
    80004b6a:	fd06                	sd	ra,184(sp)
    80004b6c:	f922                	sd	s0,176(sp)
    80004b6e:	f526                	sd	s1,168(sp)
    80004b70:	f14a                	sd	s2,160(sp)
    80004b72:	ed4e                	sd	s3,152(sp)
    80004b74:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b76:	08000613          	li	a2,128
    80004b7a:	f5040593          	addi	a1,s0,-176
    80004b7e:	4501                	li	a0,0
    80004b80:	ffffd097          	auipc	ra,0xffffd
    80004b84:	45e080e7          	jalr	1118(ra) # 80001fde <argstr>
    return -1;
    80004b88:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b8a:	0c054163          	bltz	a0,80004c4c <sys_open+0xe4>
    80004b8e:	f4c40593          	addi	a1,s0,-180
    80004b92:	4505                	li	a0,1
    80004b94:	ffffd097          	auipc	ra,0xffffd
    80004b98:	406080e7          	jalr	1030(ra) # 80001f9a <argint>
    80004b9c:	0a054863          	bltz	a0,80004c4c <sys_open+0xe4>

  begin_op();
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	a2e080e7          	jalr	-1490(ra) # 800035ce <begin_op>

  if(omode & O_CREATE){
    80004ba8:	f4c42783          	lw	a5,-180(s0)
    80004bac:	2007f793          	andi	a5,a5,512
    80004bb0:	cbdd                	beqz	a5,80004c66 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bb2:	4681                	li	a3,0
    80004bb4:	4601                	li	a2,0
    80004bb6:	4589                	li	a1,2
    80004bb8:	f5040513          	addi	a0,s0,-176
    80004bbc:	00000097          	auipc	ra,0x0
    80004bc0:	972080e7          	jalr	-1678(ra) # 8000452e <create>
    80004bc4:	892a                	mv	s2,a0
    if(ip == 0){
    80004bc6:	c959                	beqz	a0,80004c5c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bc8:	04491703          	lh	a4,68(s2)
    80004bcc:	478d                	li	a5,3
    80004bce:	00f71763          	bne	a4,a5,80004bdc <sys_open+0x74>
    80004bd2:	04695703          	lhu	a4,70(s2)
    80004bd6:	47a5                	li	a5,9
    80004bd8:	0ce7ec63          	bltu	a5,a4,80004cb0 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	e02080e7          	jalr	-510(ra) # 800039de <filealloc>
    80004be4:	89aa                	mv	s3,a0
    80004be6:	10050263          	beqz	a0,80004cea <sys_open+0x182>
    80004bea:	00000097          	auipc	ra,0x0
    80004bee:	902080e7          	jalr	-1790(ra) # 800044ec <fdalloc>
    80004bf2:	84aa                	mv	s1,a0
    80004bf4:	0e054663          	bltz	a0,80004ce0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bf8:	04491703          	lh	a4,68(s2)
    80004bfc:	478d                	li	a5,3
    80004bfe:	0cf70463          	beq	a4,a5,80004cc6 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c02:	4789                	li	a5,2
    80004c04:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c08:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c0c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c10:	f4c42783          	lw	a5,-180(s0)
    80004c14:	0017c713          	xori	a4,a5,1
    80004c18:	8b05                	andi	a4,a4,1
    80004c1a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c1e:	0037f713          	andi	a4,a5,3
    80004c22:	00e03733          	snez	a4,a4
    80004c26:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c2a:	4007f793          	andi	a5,a5,1024
    80004c2e:	c791                	beqz	a5,80004c3a <sys_open+0xd2>
    80004c30:	04491703          	lh	a4,68(s2)
    80004c34:	4789                	li	a5,2
    80004c36:	08f70f63          	beq	a4,a5,80004cd4 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	082080e7          	jalr	130(ra) # 80002cbe <iunlock>
  end_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	a0a080e7          	jalr	-1526(ra) # 8000364e <end_op>

  return fd;
}
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	70ea                	ld	ra,184(sp)
    80004c50:	744a                	ld	s0,176(sp)
    80004c52:	74aa                	ld	s1,168(sp)
    80004c54:	790a                	ld	s2,160(sp)
    80004c56:	69ea                	ld	s3,152(sp)
    80004c58:	6129                	addi	sp,sp,192
    80004c5a:	8082                	ret
      end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	9f2080e7          	jalr	-1550(ra) # 8000364e <end_op>
      return -1;
    80004c64:	b7e5                	j	80004c4c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c66:	f5040513          	addi	a0,s0,-176
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	748080e7          	jalr	1864(ra) # 800033b2 <namei>
    80004c72:	892a                	mv	s2,a0
    80004c74:	c905                	beqz	a0,80004ca4 <sys_open+0x13c>
    ilock(ip);
    80004c76:	ffffe097          	auipc	ra,0xffffe
    80004c7a:	f86080e7          	jalr	-122(ra) # 80002bfc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c7e:	04491703          	lh	a4,68(s2)
    80004c82:	4785                	li	a5,1
    80004c84:	f4f712e3          	bne	a4,a5,80004bc8 <sys_open+0x60>
    80004c88:	f4c42783          	lw	a5,-180(s0)
    80004c8c:	dba1                	beqz	a5,80004bdc <sys_open+0x74>
      iunlockput(ip);
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	1ce080e7          	jalr	462(ra) # 80002e5e <iunlockput>
      end_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	9b6080e7          	jalr	-1610(ra) # 8000364e <end_op>
      return -1;
    80004ca0:	54fd                	li	s1,-1
    80004ca2:	b76d                	j	80004c4c <sys_open+0xe4>
      end_op();
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	9aa080e7          	jalr	-1622(ra) # 8000364e <end_op>
      return -1;
    80004cac:	54fd                	li	s1,-1
    80004cae:	bf79                	j	80004c4c <sys_open+0xe4>
    iunlockput(ip);
    80004cb0:	854a                	mv	a0,s2
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	1ac080e7          	jalr	428(ra) # 80002e5e <iunlockput>
    end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	994080e7          	jalr	-1644(ra) # 8000364e <end_op>
    return -1;
    80004cc2:	54fd                	li	s1,-1
    80004cc4:	b761                	j	80004c4c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cc6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cca:	04691783          	lh	a5,70(s2)
    80004cce:	02f99223          	sh	a5,36(s3)
    80004cd2:	bf2d                	j	80004c0c <sys_open+0xa4>
    itrunc(ip);
    80004cd4:	854a                	mv	a0,s2
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	034080e7          	jalr	52(ra) # 80002d0a <itrunc>
    80004cde:	bfb1                	j	80004c3a <sys_open+0xd2>
      fileclose(f);
    80004ce0:	854e                	mv	a0,s3
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	db8080e7          	jalr	-584(ra) # 80003a9a <fileclose>
    iunlockput(ip);
    80004cea:	854a                	mv	a0,s2
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	172080e7          	jalr	370(ra) # 80002e5e <iunlockput>
    end_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	95a080e7          	jalr	-1702(ra) # 8000364e <end_op>
    return -1;
    80004cfc:	54fd                	li	s1,-1
    80004cfe:	b7b9                	j	80004c4c <sys_open+0xe4>

0000000080004d00 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d00:	7175                	addi	sp,sp,-144
    80004d02:	e506                	sd	ra,136(sp)
    80004d04:	e122                	sd	s0,128(sp)
    80004d06:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	8c6080e7          	jalr	-1850(ra) # 800035ce <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d10:	08000613          	li	a2,128
    80004d14:	f7040593          	addi	a1,s0,-144
    80004d18:	4501                	li	a0,0
    80004d1a:	ffffd097          	auipc	ra,0xffffd
    80004d1e:	2c4080e7          	jalr	708(ra) # 80001fde <argstr>
    80004d22:	02054963          	bltz	a0,80004d54 <sys_mkdir+0x54>
    80004d26:	4681                	li	a3,0
    80004d28:	4601                	li	a2,0
    80004d2a:	4585                	li	a1,1
    80004d2c:	f7040513          	addi	a0,s0,-144
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	7fe080e7          	jalr	2046(ra) # 8000452e <create>
    80004d38:	cd11                	beqz	a0,80004d54 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	124080e7          	jalr	292(ra) # 80002e5e <iunlockput>
  end_op();
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	90c080e7          	jalr	-1780(ra) # 8000364e <end_op>
  return 0;
    80004d4a:	4501                	li	a0,0
}
    80004d4c:	60aa                	ld	ra,136(sp)
    80004d4e:	640a                	ld	s0,128(sp)
    80004d50:	6149                	addi	sp,sp,144
    80004d52:	8082                	ret
    end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	8fa080e7          	jalr	-1798(ra) # 8000364e <end_op>
    return -1;
    80004d5c:	557d                	li	a0,-1
    80004d5e:	b7fd                	j	80004d4c <sys_mkdir+0x4c>

0000000080004d60 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d60:	7135                	addi	sp,sp,-160
    80004d62:	ed06                	sd	ra,152(sp)
    80004d64:	e922                	sd	s0,144(sp)
    80004d66:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	866080e7          	jalr	-1946(ra) # 800035ce <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d70:	08000613          	li	a2,128
    80004d74:	f7040593          	addi	a1,s0,-144
    80004d78:	4501                	li	a0,0
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	264080e7          	jalr	612(ra) # 80001fde <argstr>
    80004d82:	04054a63          	bltz	a0,80004dd6 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d86:	f6c40593          	addi	a1,s0,-148
    80004d8a:	4505                	li	a0,1
    80004d8c:	ffffd097          	auipc	ra,0xffffd
    80004d90:	20e080e7          	jalr	526(ra) # 80001f9a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d94:	04054163          	bltz	a0,80004dd6 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d98:	f6840593          	addi	a1,s0,-152
    80004d9c:	4509                	li	a0,2
    80004d9e:	ffffd097          	auipc	ra,0xffffd
    80004da2:	1fc080e7          	jalr	508(ra) # 80001f9a <argint>
     argint(1, &major) < 0 ||
    80004da6:	02054863          	bltz	a0,80004dd6 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004daa:	f6841683          	lh	a3,-152(s0)
    80004dae:	f6c41603          	lh	a2,-148(s0)
    80004db2:	458d                	li	a1,3
    80004db4:	f7040513          	addi	a0,s0,-144
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	776080e7          	jalr	1910(ra) # 8000452e <create>
     argint(2, &minor) < 0 ||
    80004dc0:	c919                	beqz	a0,80004dd6 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dc2:	ffffe097          	auipc	ra,0xffffe
    80004dc6:	09c080e7          	jalr	156(ra) # 80002e5e <iunlockput>
  end_op();
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	884080e7          	jalr	-1916(ra) # 8000364e <end_op>
  return 0;
    80004dd2:	4501                	li	a0,0
    80004dd4:	a031                	j	80004de0 <sys_mknod+0x80>
    end_op();
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	878080e7          	jalr	-1928(ra) # 8000364e <end_op>
    return -1;
    80004dde:	557d                	li	a0,-1
}
    80004de0:	60ea                	ld	ra,152(sp)
    80004de2:	644a                	ld	s0,144(sp)
    80004de4:	610d                	addi	sp,sp,160
    80004de6:	8082                	ret

0000000080004de8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004de8:	7135                	addi	sp,sp,-160
    80004dea:	ed06                	sd	ra,152(sp)
    80004dec:	e922                	sd	s0,144(sp)
    80004dee:	e526                	sd	s1,136(sp)
    80004df0:	e14a                	sd	s2,128(sp)
    80004df2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004df4:	ffffc097          	auipc	ra,0xffffc
    80004df8:	09e080e7          	jalr	158(ra) # 80000e92 <myproc>
    80004dfc:	892a                	mv	s2,a0
  
  begin_op();
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	7d0080e7          	jalr	2000(ra) # 800035ce <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e06:	08000613          	li	a2,128
    80004e0a:	f6040593          	addi	a1,s0,-160
    80004e0e:	4501                	li	a0,0
    80004e10:	ffffd097          	auipc	ra,0xffffd
    80004e14:	1ce080e7          	jalr	462(ra) # 80001fde <argstr>
    80004e18:	04054b63          	bltz	a0,80004e6e <sys_chdir+0x86>
    80004e1c:	f6040513          	addi	a0,s0,-160
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	592080e7          	jalr	1426(ra) # 800033b2 <namei>
    80004e28:	84aa                	mv	s1,a0
    80004e2a:	c131                	beqz	a0,80004e6e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	dd0080e7          	jalr	-560(ra) # 80002bfc <ilock>
  if(ip->type != T_DIR){
    80004e34:	04449703          	lh	a4,68(s1)
    80004e38:	4785                	li	a5,1
    80004e3a:	04f71063          	bne	a4,a5,80004e7a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e3e:	8526                	mv	a0,s1
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	e7e080e7          	jalr	-386(ra) # 80002cbe <iunlock>
  iput(p->cwd);
    80004e48:	15093503          	ld	a0,336(s2)
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	f6a080e7          	jalr	-150(ra) # 80002db6 <iput>
  end_op();
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	7fa080e7          	jalr	2042(ra) # 8000364e <end_op>
  p->cwd = ip;
    80004e5c:	14993823          	sd	s1,336(s2)
  return 0;
    80004e60:	4501                	li	a0,0
}
    80004e62:	60ea                	ld	ra,152(sp)
    80004e64:	644a                	ld	s0,144(sp)
    80004e66:	64aa                	ld	s1,136(sp)
    80004e68:	690a                	ld	s2,128(sp)
    80004e6a:	610d                	addi	sp,sp,160
    80004e6c:	8082                	ret
    end_op();
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	7e0080e7          	jalr	2016(ra) # 8000364e <end_op>
    return -1;
    80004e76:	557d                	li	a0,-1
    80004e78:	b7ed                	j	80004e62 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e7a:	8526                	mv	a0,s1
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	fe2080e7          	jalr	-30(ra) # 80002e5e <iunlockput>
    end_op();
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	7ca080e7          	jalr	1994(ra) # 8000364e <end_op>
    return -1;
    80004e8c:	557d                	li	a0,-1
    80004e8e:	bfd1                	j	80004e62 <sys_chdir+0x7a>

0000000080004e90 <sys_exec>:

uint64
sys_exec(void)
{
    80004e90:	7145                	addi	sp,sp,-464
    80004e92:	e786                	sd	ra,456(sp)
    80004e94:	e3a2                	sd	s0,448(sp)
    80004e96:	ff26                	sd	s1,440(sp)
    80004e98:	fb4a                	sd	s2,432(sp)
    80004e9a:	f74e                	sd	s3,424(sp)
    80004e9c:	f352                	sd	s4,416(sp)
    80004e9e:	ef56                	sd	s5,408(sp)
    80004ea0:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ea2:	08000613          	li	a2,128
    80004ea6:	f4040593          	addi	a1,s0,-192
    80004eaa:	4501                	li	a0,0
    80004eac:	ffffd097          	auipc	ra,0xffffd
    80004eb0:	132080e7          	jalr	306(ra) # 80001fde <argstr>
    return -1;
    80004eb4:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eb6:	0c054a63          	bltz	a0,80004f8a <sys_exec+0xfa>
    80004eba:	e3840593          	addi	a1,s0,-456
    80004ebe:	4505                	li	a0,1
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	0fc080e7          	jalr	252(ra) # 80001fbc <argaddr>
    80004ec8:	0c054163          	bltz	a0,80004f8a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ecc:	10000613          	li	a2,256
    80004ed0:	4581                	li	a1,0
    80004ed2:	e4040513          	addi	a0,s0,-448
    80004ed6:	ffffb097          	auipc	ra,0xffffb
    80004eda:	2ec080e7          	jalr	748(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ede:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ee2:	89a6                	mv	s3,s1
    80004ee4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ee6:	02000a13          	li	s4,32
    80004eea:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eee:	00391513          	slli	a0,s2,0x3
    80004ef2:	e3040593          	addi	a1,s0,-464
    80004ef6:	e3843783          	ld	a5,-456(s0)
    80004efa:	953e                	add	a0,a0,a5
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	004080e7          	jalr	4(ra) # 80001f00 <fetchaddr>
    80004f04:	02054a63          	bltz	a0,80004f38 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f08:	e3043783          	ld	a5,-464(s0)
    80004f0c:	c3b9                	beqz	a5,80004f52 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f0e:	ffffb097          	auipc	ra,0xffffb
    80004f12:	20a080e7          	jalr	522(ra) # 80000118 <kalloc>
    80004f16:	85aa                	mv	a1,a0
    80004f18:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f1c:	cd11                	beqz	a0,80004f38 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f1e:	6605                	lui	a2,0x1
    80004f20:	e3043503          	ld	a0,-464(s0)
    80004f24:	ffffd097          	auipc	ra,0xffffd
    80004f28:	02e080e7          	jalr	46(ra) # 80001f52 <fetchstr>
    80004f2c:	00054663          	bltz	a0,80004f38 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f30:	0905                	addi	s2,s2,1
    80004f32:	09a1                	addi	s3,s3,8
    80004f34:	fb491be3          	bne	s2,s4,80004eea <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f38:	10048913          	addi	s2,s1,256
    80004f3c:	6088                	ld	a0,0(s1)
    80004f3e:	c529                	beqz	a0,80004f88 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f40:	ffffb097          	auipc	ra,0xffffb
    80004f44:	0dc080e7          	jalr	220(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f48:	04a1                	addi	s1,s1,8
    80004f4a:	ff2499e3          	bne	s1,s2,80004f3c <sys_exec+0xac>
  return -1;
    80004f4e:	597d                	li	s2,-1
    80004f50:	a82d                	j	80004f8a <sys_exec+0xfa>
      argv[i] = 0;
    80004f52:	0a8e                	slli	s5,s5,0x3
    80004f54:	fc040793          	addi	a5,s0,-64
    80004f58:	9abe                	add	s5,s5,a5
    80004f5a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f5e:	e4040593          	addi	a1,s0,-448
    80004f62:	f4040513          	addi	a0,s0,-192
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	194080e7          	jalr	404(ra) # 800040fa <exec>
    80004f6e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f70:	10048993          	addi	s3,s1,256
    80004f74:	6088                	ld	a0,0(s1)
    80004f76:	c911                	beqz	a0,80004f8a <sys_exec+0xfa>
    kfree(argv[i]);
    80004f78:	ffffb097          	auipc	ra,0xffffb
    80004f7c:	0a4080e7          	jalr	164(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f80:	04a1                	addi	s1,s1,8
    80004f82:	ff3499e3          	bne	s1,s3,80004f74 <sys_exec+0xe4>
    80004f86:	a011                	j	80004f8a <sys_exec+0xfa>
  return -1;
    80004f88:	597d                	li	s2,-1
}
    80004f8a:	854a                	mv	a0,s2
    80004f8c:	60be                	ld	ra,456(sp)
    80004f8e:	641e                	ld	s0,448(sp)
    80004f90:	74fa                	ld	s1,440(sp)
    80004f92:	795a                	ld	s2,432(sp)
    80004f94:	79ba                	ld	s3,424(sp)
    80004f96:	7a1a                	ld	s4,416(sp)
    80004f98:	6afa                	ld	s5,408(sp)
    80004f9a:	6179                	addi	sp,sp,464
    80004f9c:	8082                	ret

0000000080004f9e <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f9e:	7139                	addi	sp,sp,-64
    80004fa0:	fc06                	sd	ra,56(sp)
    80004fa2:	f822                	sd	s0,48(sp)
    80004fa4:	f426                	sd	s1,40(sp)
    80004fa6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fa8:	ffffc097          	auipc	ra,0xffffc
    80004fac:	eea080e7          	jalr	-278(ra) # 80000e92 <myproc>
    80004fb0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fb2:	fd840593          	addi	a1,s0,-40
    80004fb6:	4501                	li	a0,0
    80004fb8:	ffffd097          	auipc	ra,0xffffd
    80004fbc:	004080e7          	jalr	4(ra) # 80001fbc <argaddr>
    return -1;
    80004fc0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fc2:	0e054063          	bltz	a0,800050a2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fc6:	fc840593          	addi	a1,s0,-56
    80004fca:	fd040513          	addi	a0,s0,-48
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	dfc080e7          	jalr	-516(ra) # 80003dca <pipealloc>
    return -1;
    80004fd6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fd8:	0c054563          	bltz	a0,800050a2 <sys_pipe+0x104>
  fd0 = -1;
    80004fdc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fe0:	fd043503          	ld	a0,-48(s0)
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	508080e7          	jalr	1288(ra) # 800044ec <fdalloc>
    80004fec:	fca42223          	sw	a0,-60(s0)
    80004ff0:	08054c63          	bltz	a0,80005088 <sys_pipe+0xea>
    80004ff4:	fc843503          	ld	a0,-56(s0)
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	4f4080e7          	jalr	1268(ra) # 800044ec <fdalloc>
    80005000:	fca42023          	sw	a0,-64(s0)
    80005004:	06054863          	bltz	a0,80005074 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005008:	4691                	li	a3,4
    8000500a:	fc440613          	addi	a2,s0,-60
    8000500e:	fd843583          	ld	a1,-40(s0)
    80005012:	68a8                	ld	a0,80(s1)
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	b40080e7          	jalr	-1216(ra) # 80000b54 <copyout>
    8000501c:	02054063          	bltz	a0,8000503c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005020:	4691                	li	a3,4
    80005022:	fc040613          	addi	a2,s0,-64
    80005026:	fd843583          	ld	a1,-40(s0)
    8000502a:	0591                	addi	a1,a1,4
    8000502c:	68a8                	ld	a0,80(s1)
    8000502e:	ffffc097          	auipc	ra,0xffffc
    80005032:	b26080e7          	jalr	-1242(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005036:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005038:	06055563          	bgez	a0,800050a2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000503c:	fc442783          	lw	a5,-60(s0)
    80005040:	07e9                	addi	a5,a5,26
    80005042:	078e                	slli	a5,a5,0x3
    80005044:	97a6                	add	a5,a5,s1
    80005046:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000504a:	fc042503          	lw	a0,-64(s0)
    8000504e:	0569                	addi	a0,a0,26
    80005050:	050e                	slli	a0,a0,0x3
    80005052:	9526                	add	a0,a0,s1
    80005054:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005058:	fd043503          	ld	a0,-48(s0)
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	a3e080e7          	jalr	-1474(ra) # 80003a9a <fileclose>
    fileclose(wf);
    80005064:	fc843503          	ld	a0,-56(s0)
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	a32080e7          	jalr	-1486(ra) # 80003a9a <fileclose>
    return -1;
    80005070:	57fd                	li	a5,-1
    80005072:	a805                	j	800050a2 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005074:	fc442783          	lw	a5,-60(s0)
    80005078:	0007c863          	bltz	a5,80005088 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000507c:	01a78513          	addi	a0,a5,26
    80005080:	050e                	slli	a0,a0,0x3
    80005082:	9526                	add	a0,a0,s1
    80005084:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005088:	fd043503          	ld	a0,-48(s0)
    8000508c:	fffff097          	auipc	ra,0xfffff
    80005090:	a0e080e7          	jalr	-1522(ra) # 80003a9a <fileclose>
    fileclose(wf);
    80005094:	fc843503          	ld	a0,-56(s0)
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	a02080e7          	jalr	-1534(ra) # 80003a9a <fileclose>
    return -1;
    800050a0:	57fd                	li	a5,-1
}
    800050a2:	853e                	mv	a0,a5
    800050a4:	70e2                	ld	ra,56(sp)
    800050a6:	7442                	ld	s0,48(sp)
    800050a8:	74a2                	ld	s1,40(sp)
    800050aa:	6121                	addi	sp,sp,64
    800050ac:	8082                	ret
	...

00000000800050b0 <kernelvec>:
    800050b0:	7111                	addi	sp,sp,-256
    800050b2:	e006                	sd	ra,0(sp)
    800050b4:	e40a                	sd	sp,8(sp)
    800050b6:	e80e                	sd	gp,16(sp)
    800050b8:	ec12                	sd	tp,24(sp)
    800050ba:	f016                	sd	t0,32(sp)
    800050bc:	f41a                	sd	t1,40(sp)
    800050be:	f81e                	sd	t2,48(sp)
    800050c0:	fc22                	sd	s0,56(sp)
    800050c2:	e0a6                	sd	s1,64(sp)
    800050c4:	e4aa                	sd	a0,72(sp)
    800050c6:	e8ae                	sd	a1,80(sp)
    800050c8:	ecb2                	sd	a2,88(sp)
    800050ca:	f0b6                	sd	a3,96(sp)
    800050cc:	f4ba                	sd	a4,104(sp)
    800050ce:	f8be                	sd	a5,112(sp)
    800050d0:	fcc2                	sd	a6,120(sp)
    800050d2:	e146                	sd	a7,128(sp)
    800050d4:	e54a                	sd	s2,136(sp)
    800050d6:	e94e                	sd	s3,144(sp)
    800050d8:	ed52                	sd	s4,152(sp)
    800050da:	f156                	sd	s5,160(sp)
    800050dc:	f55a                	sd	s6,168(sp)
    800050de:	f95e                	sd	s7,176(sp)
    800050e0:	fd62                	sd	s8,184(sp)
    800050e2:	e1e6                	sd	s9,192(sp)
    800050e4:	e5ea                	sd	s10,200(sp)
    800050e6:	e9ee                	sd	s11,208(sp)
    800050e8:	edf2                	sd	t3,216(sp)
    800050ea:	f1f6                	sd	t4,224(sp)
    800050ec:	f5fa                	sd	t5,232(sp)
    800050ee:	f9fe                	sd	t6,240(sp)
    800050f0:	cddfc0ef          	jal	ra,80001dcc <kerneltrap>
    800050f4:	6082                	ld	ra,0(sp)
    800050f6:	6122                	ld	sp,8(sp)
    800050f8:	61c2                	ld	gp,16(sp)
    800050fa:	7282                	ld	t0,32(sp)
    800050fc:	7322                	ld	t1,40(sp)
    800050fe:	73c2                	ld	t2,48(sp)
    80005100:	7462                	ld	s0,56(sp)
    80005102:	6486                	ld	s1,64(sp)
    80005104:	6526                	ld	a0,72(sp)
    80005106:	65c6                	ld	a1,80(sp)
    80005108:	6666                	ld	a2,88(sp)
    8000510a:	7686                	ld	a3,96(sp)
    8000510c:	7726                	ld	a4,104(sp)
    8000510e:	77c6                	ld	a5,112(sp)
    80005110:	7866                	ld	a6,120(sp)
    80005112:	688a                	ld	a7,128(sp)
    80005114:	692a                	ld	s2,136(sp)
    80005116:	69ca                	ld	s3,144(sp)
    80005118:	6a6a                	ld	s4,152(sp)
    8000511a:	7a8a                	ld	s5,160(sp)
    8000511c:	7b2a                	ld	s6,168(sp)
    8000511e:	7bca                	ld	s7,176(sp)
    80005120:	7c6a                	ld	s8,184(sp)
    80005122:	6c8e                	ld	s9,192(sp)
    80005124:	6d2e                	ld	s10,200(sp)
    80005126:	6dce                	ld	s11,208(sp)
    80005128:	6e6e                	ld	t3,216(sp)
    8000512a:	7e8e                	ld	t4,224(sp)
    8000512c:	7f2e                	ld	t5,232(sp)
    8000512e:	7fce                	ld	t6,240(sp)
    80005130:	6111                	addi	sp,sp,256
    80005132:	10200073          	sret
    80005136:	00000013          	nop
    8000513a:	00000013          	nop
    8000513e:	0001                	nop

0000000080005140 <timervec>:
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	e10c                	sd	a1,0(a0)
    80005146:	e510                	sd	a2,8(a0)
    80005148:	e914                	sd	a3,16(a0)
    8000514a:	6d0c                	ld	a1,24(a0)
    8000514c:	7110                	ld	a2,32(a0)
    8000514e:	6194                	ld	a3,0(a1)
    80005150:	96b2                	add	a3,a3,a2
    80005152:	e194                	sd	a3,0(a1)
    80005154:	4589                	li	a1,2
    80005156:	14459073          	csrw	sip,a1
    8000515a:	6914                	ld	a3,16(a0)
    8000515c:	6510                	ld	a2,8(a0)
    8000515e:	610c                	ld	a1,0(a0)
    80005160:	34051573          	csrrw	a0,mscratch,a0
    80005164:	30200073          	mret
	...

000000008000516a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000516a:	1141                	addi	sp,sp,-16
    8000516c:	e422                	sd	s0,8(sp)
    8000516e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005170:	0c0007b7          	lui	a5,0xc000
    80005174:	4705                	li	a4,1
    80005176:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005178:	c3d8                	sw	a4,4(a5)
}
    8000517a:	6422                	ld	s0,8(sp)
    8000517c:	0141                	addi	sp,sp,16
    8000517e:	8082                	ret

0000000080005180 <plicinithart>:

void
plicinithart(void)
{
    80005180:	1141                	addi	sp,sp,-16
    80005182:	e406                	sd	ra,8(sp)
    80005184:	e022                	sd	s0,0(sp)
    80005186:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	cde080e7          	jalr	-802(ra) # 80000e66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005190:	0085171b          	slliw	a4,a0,0x8
    80005194:	0c0027b7          	lui	a5,0xc002
    80005198:	97ba                	add	a5,a5,a4
    8000519a:	40200713          	li	a4,1026
    8000519e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051a2:	00d5151b          	slliw	a0,a0,0xd
    800051a6:	0c2017b7          	lui	a5,0xc201
    800051aa:	953e                	add	a0,a0,a5
    800051ac:	00052023          	sw	zero,0(a0)
}
    800051b0:	60a2                	ld	ra,8(sp)
    800051b2:	6402                	ld	s0,0(sp)
    800051b4:	0141                	addi	sp,sp,16
    800051b6:	8082                	ret

00000000800051b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051b8:	1141                	addi	sp,sp,-16
    800051ba:	e406                	sd	ra,8(sp)
    800051bc:	e022                	sd	s0,0(sp)
    800051be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051c0:	ffffc097          	auipc	ra,0xffffc
    800051c4:	ca6080e7          	jalr	-858(ra) # 80000e66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051c8:	00d5179b          	slliw	a5,a0,0xd
    800051cc:	0c201537          	lui	a0,0xc201
    800051d0:	953e                	add	a0,a0,a5
  return irq;
}
    800051d2:	4148                	lw	a0,4(a0)
    800051d4:	60a2                	ld	ra,8(sp)
    800051d6:	6402                	ld	s0,0(sp)
    800051d8:	0141                	addi	sp,sp,16
    800051da:	8082                	ret

00000000800051dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051dc:	1101                	addi	sp,sp,-32
    800051de:	ec06                	sd	ra,24(sp)
    800051e0:	e822                	sd	s0,16(sp)
    800051e2:	e426                	sd	s1,8(sp)
    800051e4:	1000                	addi	s0,sp,32
    800051e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051e8:	ffffc097          	auipc	ra,0xffffc
    800051ec:	c7e080e7          	jalr	-898(ra) # 80000e66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051f0:	00d5151b          	slliw	a0,a0,0xd
    800051f4:	0c2017b7          	lui	a5,0xc201
    800051f8:	97aa                	add	a5,a5,a0
    800051fa:	c3c4                	sw	s1,4(a5)
}
    800051fc:	60e2                	ld	ra,24(sp)
    800051fe:	6442                	ld	s0,16(sp)
    80005200:	64a2                	ld	s1,8(sp)
    80005202:	6105                	addi	sp,sp,32
    80005204:	8082                	ret

0000000080005206 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005206:	1141                	addi	sp,sp,-16
    80005208:	e406                	sd	ra,8(sp)
    8000520a:	e022                	sd	s0,0(sp)
    8000520c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000520e:	479d                	li	a5,7
    80005210:	06a7c963          	blt	a5,a0,80005282 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005214:	00016797          	auipc	a5,0x16
    80005218:	dec78793          	addi	a5,a5,-532 # 8001b000 <disk>
    8000521c:	00a78733          	add	a4,a5,a0
    80005220:	6789                	lui	a5,0x2
    80005222:	97ba                	add	a5,a5,a4
    80005224:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005228:	e7ad                	bnez	a5,80005292 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000522a:	00451793          	slli	a5,a0,0x4
    8000522e:	00018717          	auipc	a4,0x18
    80005232:	dd270713          	addi	a4,a4,-558 # 8001d000 <disk+0x2000>
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000523e:	6314                	ld	a3,0(a4)
    80005240:	96be                	add	a3,a3,a5
    80005242:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005246:	6314                	ld	a3,0(a4)
    80005248:	96be                	add	a3,a3,a5
    8000524a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000524e:	6318                	ld	a4,0(a4)
    80005250:	97ba                	add	a5,a5,a4
    80005252:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005256:	00016797          	auipc	a5,0x16
    8000525a:	daa78793          	addi	a5,a5,-598 # 8001b000 <disk>
    8000525e:	97aa                	add	a5,a5,a0
    80005260:	6509                	lui	a0,0x2
    80005262:	953e                	add	a0,a0,a5
    80005264:	4785                	li	a5,1
    80005266:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000526a:	00018517          	auipc	a0,0x18
    8000526e:	dae50513          	addi	a0,a0,-594 # 8001d018 <disk+0x2018>
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	470080e7          	jalr	1136(ra) # 800016e2 <wakeup>
}
    8000527a:	60a2                	ld	ra,8(sp)
    8000527c:	6402                	ld	s0,0(sp)
    8000527e:	0141                	addi	sp,sp,16
    80005280:	8082                	ret
    panic("free_desc 1");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	5ee50513          	addi	a0,a0,1518 # 80008870 <syscall_name+0x320>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	a1e080e7          	jalr	-1506(ra) # 80005ca8 <panic>
    panic("free_desc 2");
    80005292:	00003517          	auipc	a0,0x3
    80005296:	5ee50513          	addi	a0,a0,1518 # 80008880 <syscall_name+0x330>
    8000529a:	00001097          	auipc	ra,0x1
    8000529e:	a0e080e7          	jalr	-1522(ra) # 80005ca8 <panic>

00000000800052a2 <virtio_disk_init>:
{
    800052a2:	1101                	addi	sp,sp,-32
    800052a4:	ec06                	sd	ra,24(sp)
    800052a6:	e822                	sd	s0,16(sp)
    800052a8:	e426                	sd	s1,8(sp)
    800052aa:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052ac:	00003597          	auipc	a1,0x3
    800052b0:	5e458593          	addi	a1,a1,1508 # 80008890 <syscall_name+0x340>
    800052b4:	00018517          	auipc	a0,0x18
    800052b8:	e7450513          	addi	a0,a0,-396 # 8001d128 <disk+0x2128>
    800052bc:	00001097          	auipc	ra,0x1
    800052c0:	ea6080e7          	jalr	-346(ra) # 80006162 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052c4:	100017b7          	lui	a5,0x10001
    800052c8:	4398                	lw	a4,0(a5)
    800052ca:	2701                	sext.w	a4,a4
    800052cc:	747277b7          	lui	a5,0x74727
    800052d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052d4:	0ef71163          	bne	a4,a5,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052d8:	100017b7          	lui	a5,0x10001
    800052dc:	43dc                	lw	a5,4(a5)
    800052de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052e0:	4705                	li	a4,1
    800052e2:	0ce79a63          	bne	a5,a4,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052e6:	100017b7          	lui	a5,0x10001
    800052ea:	479c                	lw	a5,8(a5)
    800052ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ee:	4709                	li	a4,2
    800052f0:	0ce79363          	bne	a5,a4,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052f4:	100017b7          	lui	a5,0x10001
    800052f8:	47d8                	lw	a4,12(a5)
    800052fa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052fc:	554d47b7          	lui	a5,0x554d4
    80005300:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005304:	0af71963          	bne	a4,a5,800053b6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	100017b7          	lui	a5,0x10001
    8000530c:	4705                	li	a4,1
    8000530e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005310:	470d                	li	a4,3
    80005312:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005314:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005316:	c7ffe737          	lui	a4,0xc7ffe
    8000531a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000531e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005320:	2701                	sext.w	a4,a4
    80005322:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005324:	472d                	li	a4,11
    80005326:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005328:	473d                	li	a4,15
    8000532a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000532c:	6705                	lui	a4,0x1
    8000532e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005330:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005334:	5bdc                	lw	a5,52(a5)
    80005336:	2781                	sext.w	a5,a5
  if(max == 0)
    80005338:	c7d9                	beqz	a5,800053c6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000533a:	471d                	li	a4,7
    8000533c:	08f77d63          	bgeu	a4,a5,800053d6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005340:	100014b7          	lui	s1,0x10001
    80005344:	47a1                	li	a5,8
    80005346:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005348:	6609                	lui	a2,0x2
    8000534a:	4581                	li	a1,0
    8000534c:	00016517          	auipc	a0,0x16
    80005350:	cb450513          	addi	a0,a0,-844 # 8001b000 <disk>
    80005354:	ffffb097          	auipc	ra,0xffffb
    80005358:	e6e080e7          	jalr	-402(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000535c:	00016717          	auipc	a4,0x16
    80005360:	ca470713          	addi	a4,a4,-860 # 8001b000 <disk>
    80005364:	00c75793          	srli	a5,a4,0xc
    80005368:	2781                	sext.w	a5,a5
    8000536a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000536c:	00018797          	auipc	a5,0x18
    80005370:	c9478793          	addi	a5,a5,-876 # 8001d000 <disk+0x2000>
    80005374:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005376:	00016717          	auipc	a4,0x16
    8000537a:	d0a70713          	addi	a4,a4,-758 # 8001b080 <disk+0x80>
    8000537e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005380:	00017717          	auipc	a4,0x17
    80005384:	c8070713          	addi	a4,a4,-896 # 8001c000 <disk+0x1000>
    80005388:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000538a:	4705                	li	a4,1
    8000538c:	00e78c23          	sb	a4,24(a5)
    80005390:	00e78ca3          	sb	a4,25(a5)
    80005394:	00e78d23          	sb	a4,26(a5)
    80005398:	00e78da3          	sb	a4,27(a5)
    8000539c:	00e78e23          	sb	a4,28(a5)
    800053a0:	00e78ea3          	sb	a4,29(a5)
    800053a4:	00e78f23          	sb	a4,30(a5)
    800053a8:	00e78fa3          	sb	a4,31(a5)
}
    800053ac:	60e2                	ld	ra,24(sp)
    800053ae:	6442                	ld	s0,16(sp)
    800053b0:	64a2                	ld	s1,8(sp)
    800053b2:	6105                	addi	sp,sp,32
    800053b4:	8082                	ret
    panic("could not find virtio disk");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	4ea50513          	addi	a0,a0,1258 # 800088a0 <syscall_name+0x350>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	8ea080e7          	jalr	-1814(ra) # 80005ca8 <panic>
    panic("virtio disk has no queue 0");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	4fa50513          	addi	a0,a0,1274 # 800088c0 <syscall_name+0x370>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	8da080e7          	jalr	-1830(ra) # 80005ca8 <panic>
    panic("virtio disk max queue too short");
    800053d6:	00003517          	auipc	a0,0x3
    800053da:	50a50513          	addi	a0,a0,1290 # 800088e0 <syscall_name+0x390>
    800053de:	00001097          	auipc	ra,0x1
    800053e2:	8ca080e7          	jalr	-1846(ra) # 80005ca8 <panic>

00000000800053e6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053e6:	7159                	addi	sp,sp,-112
    800053e8:	f486                	sd	ra,104(sp)
    800053ea:	f0a2                	sd	s0,96(sp)
    800053ec:	eca6                	sd	s1,88(sp)
    800053ee:	e8ca                	sd	s2,80(sp)
    800053f0:	e4ce                	sd	s3,72(sp)
    800053f2:	e0d2                	sd	s4,64(sp)
    800053f4:	fc56                	sd	s5,56(sp)
    800053f6:	f85a                	sd	s6,48(sp)
    800053f8:	f45e                	sd	s7,40(sp)
    800053fa:	f062                	sd	s8,32(sp)
    800053fc:	ec66                	sd	s9,24(sp)
    800053fe:	e86a                	sd	s10,16(sp)
    80005400:	1880                	addi	s0,sp,112
    80005402:	892a                	mv	s2,a0
    80005404:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005406:	00c52c83          	lw	s9,12(a0)
    8000540a:	001c9c9b          	slliw	s9,s9,0x1
    8000540e:	1c82                	slli	s9,s9,0x20
    80005410:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005414:	00018517          	auipc	a0,0x18
    80005418:	d1450513          	addi	a0,a0,-748 # 8001d128 <disk+0x2128>
    8000541c:	00001097          	auipc	ra,0x1
    80005420:	dd6080e7          	jalr	-554(ra) # 800061f2 <acquire>
  for(int i = 0; i < 3; i++){
    80005424:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005426:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005428:	00016b97          	auipc	s7,0x16
    8000542c:	bd8b8b93          	addi	s7,s7,-1064 # 8001b000 <disk>
    80005430:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005432:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005434:	8a4e                	mv	s4,s3
    80005436:	a051                	j	800054ba <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005438:	00fb86b3          	add	a3,s7,a5
    8000543c:	96da                	add	a3,a3,s6
    8000543e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005442:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005444:	0207c563          	bltz	a5,8000546e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005448:	2485                	addiw	s1,s1,1
    8000544a:	0711                	addi	a4,a4,4
    8000544c:	25548063          	beq	s1,s5,8000568c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005450:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005452:	00018697          	auipc	a3,0x18
    80005456:	bc668693          	addi	a3,a3,-1082 # 8001d018 <disk+0x2018>
    8000545a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000545c:	0006c583          	lbu	a1,0(a3)
    80005460:	fde1                	bnez	a1,80005438 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005462:	2785                	addiw	a5,a5,1
    80005464:	0685                	addi	a3,a3,1
    80005466:	ff879be3          	bne	a5,s8,8000545c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000546a:	57fd                	li	a5,-1
    8000546c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000546e:	02905a63          	blez	s1,800054a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005472:	f9042503          	lw	a0,-112(s0)
    80005476:	00000097          	auipc	ra,0x0
    8000547a:	d90080e7          	jalr	-624(ra) # 80005206 <free_desc>
      for(int j = 0; j < i; j++)
    8000547e:	4785                	li	a5,1
    80005480:	0297d163          	bge	a5,s1,800054a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005484:	f9442503          	lw	a0,-108(s0)
    80005488:	00000097          	auipc	ra,0x0
    8000548c:	d7e080e7          	jalr	-642(ra) # 80005206 <free_desc>
      for(int j = 0; j < i; j++)
    80005490:	4789                	li	a5,2
    80005492:	0097d863          	bge	a5,s1,800054a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005496:	f9842503          	lw	a0,-104(s0)
    8000549a:	00000097          	auipc	ra,0x0
    8000549e:	d6c080e7          	jalr	-660(ra) # 80005206 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a2:	00018597          	auipc	a1,0x18
    800054a6:	c8658593          	addi	a1,a1,-890 # 8001d128 <disk+0x2128>
    800054aa:	00018517          	auipc	a0,0x18
    800054ae:	b6e50513          	addi	a0,a0,-1170 # 8001d018 <disk+0x2018>
    800054b2:	ffffc097          	auipc	ra,0xffffc
    800054b6:	0a4080e7          	jalr	164(ra) # 80001556 <sleep>
  for(int i = 0; i < 3; i++){
    800054ba:	f9040713          	addi	a4,s0,-112
    800054be:	84ce                	mv	s1,s3
    800054c0:	bf41                	j	80005450 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054c2:	20058713          	addi	a4,a1,512
    800054c6:	00471693          	slli	a3,a4,0x4
    800054ca:	00016717          	auipc	a4,0x16
    800054ce:	b3670713          	addi	a4,a4,-1226 # 8001b000 <disk>
    800054d2:	9736                	add	a4,a4,a3
    800054d4:	4685                	li	a3,1
    800054d6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054da:	20058713          	addi	a4,a1,512
    800054de:	00471693          	slli	a3,a4,0x4
    800054e2:	00016717          	auipc	a4,0x16
    800054e6:	b1e70713          	addi	a4,a4,-1250 # 8001b000 <disk>
    800054ea:	9736                	add	a4,a4,a3
    800054ec:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054f0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054f4:	7679                	lui	a2,0xffffe
    800054f6:	963e                	add	a2,a2,a5
    800054f8:	00018697          	auipc	a3,0x18
    800054fc:	b0868693          	addi	a3,a3,-1272 # 8001d000 <disk+0x2000>
    80005500:	6298                	ld	a4,0(a3)
    80005502:	9732                	add	a4,a4,a2
    80005504:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005506:	6298                	ld	a4,0(a3)
    80005508:	9732                	add	a4,a4,a2
    8000550a:	4541                	li	a0,16
    8000550c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000550e:	6298                	ld	a4,0(a3)
    80005510:	9732                	add	a4,a4,a2
    80005512:	4505                	li	a0,1
    80005514:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005518:	f9442703          	lw	a4,-108(s0)
    8000551c:	6288                	ld	a0,0(a3)
    8000551e:	962a                	add	a2,a2,a0
    80005520:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005524:	0712                	slli	a4,a4,0x4
    80005526:	6290                	ld	a2,0(a3)
    80005528:	963a                	add	a2,a2,a4
    8000552a:	05890513          	addi	a0,s2,88
    8000552e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005530:	6294                	ld	a3,0(a3)
    80005532:	96ba                	add	a3,a3,a4
    80005534:	40000613          	li	a2,1024
    80005538:	c690                	sw	a2,8(a3)
  if(write)
    8000553a:	140d0063          	beqz	s10,8000567a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000553e:	00018697          	auipc	a3,0x18
    80005542:	ac26b683          	ld	a3,-1342(a3) # 8001d000 <disk+0x2000>
    80005546:	96ba                	add	a3,a3,a4
    80005548:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000554c:	00016817          	auipc	a6,0x16
    80005550:	ab480813          	addi	a6,a6,-1356 # 8001b000 <disk>
    80005554:	00018517          	auipc	a0,0x18
    80005558:	aac50513          	addi	a0,a0,-1364 # 8001d000 <disk+0x2000>
    8000555c:	6114                	ld	a3,0(a0)
    8000555e:	96ba                	add	a3,a3,a4
    80005560:	00c6d603          	lhu	a2,12(a3)
    80005564:	00166613          	ori	a2,a2,1
    80005568:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000556c:	f9842683          	lw	a3,-104(s0)
    80005570:	6110                	ld	a2,0(a0)
    80005572:	9732                	add	a4,a4,a2
    80005574:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005578:	20058613          	addi	a2,a1,512
    8000557c:	0612                	slli	a2,a2,0x4
    8000557e:	9642                	add	a2,a2,a6
    80005580:	577d                	li	a4,-1
    80005582:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005586:	00469713          	slli	a4,a3,0x4
    8000558a:	6114                	ld	a3,0(a0)
    8000558c:	96ba                	add	a3,a3,a4
    8000558e:	03078793          	addi	a5,a5,48
    80005592:	97c2                	add	a5,a5,a6
    80005594:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005596:	611c                	ld	a5,0(a0)
    80005598:	97ba                	add	a5,a5,a4
    8000559a:	4685                	li	a3,1
    8000559c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000559e:	611c                	ld	a5,0(a0)
    800055a0:	97ba                	add	a5,a5,a4
    800055a2:	4809                	li	a6,2
    800055a4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800055a8:	611c                	ld	a5,0(a0)
    800055aa:	973e                	add	a4,a4,a5
    800055ac:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055b0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800055b4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055b8:	6518                	ld	a4,8(a0)
    800055ba:	00275783          	lhu	a5,2(a4)
    800055be:	8b9d                	andi	a5,a5,7
    800055c0:	0786                	slli	a5,a5,0x1
    800055c2:	97ba                	add	a5,a5,a4
    800055c4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055c8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055cc:	6518                	ld	a4,8(a0)
    800055ce:	00275783          	lhu	a5,2(a4)
    800055d2:	2785                	addiw	a5,a5,1
    800055d4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055d8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055dc:	100017b7          	lui	a5,0x10001
    800055e0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055e4:	00492703          	lw	a4,4(s2)
    800055e8:	4785                	li	a5,1
    800055ea:	02f71163          	bne	a4,a5,8000560c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055ee:	00018997          	auipc	s3,0x18
    800055f2:	b3a98993          	addi	s3,s3,-1222 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055f6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055f8:	85ce                	mv	a1,s3
    800055fa:	854a                	mv	a0,s2
    800055fc:	ffffc097          	auipc	ra,0xffffc
    80005600:	f5a080e7          	jalr	-166(ra) # 80001556 <sleep>
  while(b->disk == 1) {
    80005604:	00492783          	lw	a5,4(s2)
    80005608:	fe9788e3          	beq	a5,s1,800055f8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000560c:	f9042903          	lw	s2,-112(s0)
    80005610:	20090793          	addi	a5,s2,512
    80005614:	00479713          	slli	a4,a5,0x4
    80005618:	00016797          	auipc	a5,0x16
    8000561c:	9e878793          	addi	a5,a5,-1560 # 8001b000 <disk>
    80005620:	97ba                	add	a5,a5,a4
    80005622:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005626:	00018997          	auipc	s3,0x18
    8000562a:	9da98993          	addi	s3,s3,-1574 # 8001d000 <disk+0x2000>
    8000562e:	00491713          	slli	a4,s2,0x4
    80005632:	0009b783          	ld	a5,0(s3)
    80005636:	97ba                	add	a5,a5,a4
    80005638:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000563c:	854a                	mv	a0,s2
    8000563e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005642:	00000097          	auipc	ra,0x0
    80005646:	bc4080e7          	jalr	-1084(ra) # 80005206 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000564a:	8885                	andi	s1,s1,1
    8000564c:	f0ed                	bnez	s1,8000562e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000564e:	00018517          	auipc	a0,0x18
    80005652:	ada50513          	addi	a0,a0,-1318 # 8001d128 <disk+0x2128>
    80005656:	00001097          	auipc	ra,0x1
    8000565a:	c50080e7          	jalr	-944(ra) # 800062a6 <release>
}
    8000565e:	70a6                	ld	ra,104(sp)
    80005660:	7406                	ld	s0,96(sp)
    80005662:	64e6                	ld	s1,88(sp)
    80005664:	6946                	ld	s2,80(sp)
    80005666:	69a6                	ld	s3,72(sp)
    80005668:	6a06                	ld	s4,64(sp)
    8000566a:	7ae2                	ld	s5,56(sp)
    8000566c:	7b42                	ld	s6,48(sp)
    8000566e:	7ba2                	ld	s7,40(sp)
    80005670:	7c02                	ld	s8,32(sp)
    80005672:	6ce2                	ld	s9,24(sp)
    80005674:	6d42                	ld	s10,16(sp)
    80005676:	6165                	addi	sp,sp,112
    80005678:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000567a:	00018697          	auipc	a3,0x18
    8000567e:	9866b683          	ld	a3,-1658(a3) # 8001d000 <disk+0x2000>
    80005682:	96ba                	add	a3,a3,a4
    80005684:	4609                	li	a2,2
    80005686:	00c69623          	sh	a2,12(a3)
    8000568a:	b5c9                	j	8000554c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000568c:	f9042583          	lw	a1,-112(s0)
    80005690:	20058793          	addi	a5,a1,512
    80005694:	0792                	slli	a5,a5,0x4
    80005696:	00016517          	auipc	a0,0x16
    8000569a:	a1250513          	addi	a0,a0,-1518 # 8001b0a8 <disk+0xa8>
    8000569e:	953e                	add	a0,a0,a5
  if(write)
    800056a0:	e20d11e3          	bnez	s10,800054c2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056a4:	20058713          	addi	a4,a1,512
    800056a8:	00471693          	slli	a3,a4,0x4
    800056ac:	00016717          	auipc	a4,0x16
    800056b0:	95470713          	addi	a4,a4,-1708 # 8001b000 <disk>
    800056b4:	9736                	add	a4,a4,a3
    800056b6:	0a072423          	sw	zero,168(a4)
    800056ba:	b505                	j	800054da <virtio_disk_rw+0xf4>

00000000800056bc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056bc:	1101                	addi	sp,sp,-32
    800056be:	ec06                	sd	ra,24(sp)
    800056c0:	e822                	sd	s0,16(sp)
    800056c2:	e426                	sd	s1,8(sp)
    800056c4:	e04a                	sd	s2,0(sp)
    800056c6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056c8:	00018517          	auipc	a0,0x18
    800056cc:	a6050513          	addi	a0,a0,-1440 # 8001d128 <disk+0x2128>
    800056d0:	00001097          	auipc	ra,0x1
    800056d4:	b22080e7          	jalr	-1246(ra) # 800061f2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056d8:	10001737          	lui	a4,0x10001
    800056dc:	533c                	lw	a5,96(a4)
    800056de:	8b8d                	andi	a5,a5,3
    800056e0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056e2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056e6:	00018797          	auipc	a5,0x18
    800056ea:	91a78793          	addi	a5,a5,-1766 # 8001d000 <disk+0x2000>
    800056ee:	6b94                	ld	a3,16(a5)
    800056f0:	0207d703          	lhu	a4,32(a5)
    800056f4:	0026d783          	lhu	a5,2(a3)
    800056f8:	06f70163          	beq	a4,a5,8000575a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056fc:	00016917          	auipc	s2,0x16
    80005700:	90490913          	addi	s2,s2,-1788 # 8001b000 <disk>
    80005704:	00018497          	auipc	s1,0x18
    80005708:	8fc48493          	addi	s1,s1,-1796 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000570c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005710:	6898                	ld	a4,16(s1)
    80005712:	0204d783          	lhu	a5,32(s1)
    80005716:	8b9d                	andi	a5,a5,7
    80005718:	078e                	slli	a5,a5,0x3
    8000571a:	97ba                	add	a5,a5,a4
    8000571c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000571e:	20078713          	addi	a4,a5,512
    80005722:	0712                	slli	a4,a4,0x4
    80005724:	974a                	add	a4,a4,s2
    80005726:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000572a:	e731                	bnez	a4,80005776 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000572c:	20078793          	addi	a5,a5,512
    80005730:	0792                	slli	a5,a5,0x4
    80005732:	97ca                	add	a5,a5,s2
    80005734:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005736:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000573a:	ffffc097          	auipc	ra,0xffffc
    8000573e:	fa8080e7          	jalr	-88(ra) # 800016e2 <wakeup>

    disk.used_idx += 1;
    80005742:	0204d783          	lhu	a5,32(s1)
    80005746:	2785                	addiw	a5,a5,1
    80005748:	17c2                	slli	a5,a5,0x30
    8000574a:	93c1                	srli	a5,a5,0x30
    8000574c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005750:	6898                	ld	a4,16(s1)
    80005752:	00275703          	lhu	a4,2(a4)
    80005756:	faf71be3          	bne	a4,a5,8000570c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000575a:	00018517          	auipc	a0,0x18
    8000575e:	9ce50513          	addi	a0,a0,-1586 # 8001d128 <disk+0x2128>
    80005762:	00001097          	auipc	ra,0x1
    80005766:	b44080e7          	jalr	-1212(ra) # 800062a6 <release>
}
    8000576a:	60e2                	ld	ra,24(sp)
    8000576c:	6442                	ld	s0,16(sp)
    8000576e:	64a2                	ld	s1,8(sp)
    80005770:	6902                	ld	s2,0(sp)
    80005772:	6105                	addi	sp,sp,32
    80005774:	8082                	ret
      panic("virtio_disk_intr status");
    80005776:	00003517          	auipc	a0,0x3
    8000577a:	18a50513          	addi	a0,a0,394 # 80008900 <syscall_name+0x3b0>
    8000577e:	00000097          	auipc	ra,0x0
    80005782:	52a080e7          	jalr	1322(ra) # 80005ca8 <panic>

0000000080005786 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005786:	1141                	addi	sp,sp,-16
    80005788:	e422                	sd	s0,8(sp)
    8000578a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000578c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005790:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005794:	0037979b          	slliw	a5,a5,0x3
    80005798:	02004737          	lui	a4,0x2004
    8000579c:	97ba                	add	a5,a5,a4
    8000579e:	0200c737          	lui	a4,0x200c
    800057a2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057a6:	000f4637          	lui	a2,0xf4
    800057aa:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057ae:	95b2                	add	a1,a1,a2
    800057b0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057b2:	00269713          	slli	a4,a3,0x2
    800057b6:	9736                	add	a4,a4,a3
    800057b8:	00371693          	slli	a3,a4,0x3
    800057bc:	00019717          	auipc	a4,0x19
    800057c0:	84470713          	addi	a4,a4,-1980 # 8001e000 <timer_scratch>
    800057c4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057c6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057c8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ca:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ce:	00000797          	auipc	a5,0x0
    800057d2:	97278793          	addi	a5,a5,-1678 # 80005140 <timervec>
    800057d6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057da:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057de:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057e2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057e6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057ea:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057ee:	30479073          	csrw	mie,a5
}
    800057f2:	6422                	ld	s0,8(sp)
    800057f4:	0141                	addi	sp,sp,16
    800057f6:	8082                	ret

00000000800057f8 <start>:
{
    800057f8:	1141                	addi	sp,sp,-16
    800057fa:	e406                	sd	ra,8(sp)
    800057fc:	e022                	sd	s0,0(sp)
    800057fe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005800:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005804:	7779                	lui	a4,0xffffe
    80005806:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000580a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000580c:	6705                	lui	a4,0x1
    8000580e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005812:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005814:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005818:	ffffb797          	auipc	a5,0xffffb
    8000581c:	b5878793          	addi	a5,a5,-1192 # 80000370 <main>
    80005820:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005824:	4781                	li	a5,0
    80005826:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000582a:	67c1                	lui	a5,0x10
    8000582c:	17fd                	addi	a5,a5,-1
    8000582e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005832:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005836:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000583a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000583e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005842:	57fd                	li	a5,-1
    80005844:	83a9                	srli	a5,a5,0xa
    80005846:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000584a:	47bd                	li	a5,15
    8000584c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005850:	00000097          	auipc	ra,0x0
    80005854:	f36080e7          	jalr	-202(ra) # 80005786 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005858:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000585c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000585e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005860:	30200073          	mret
}
    80005864:	60a2                	ld	ra,8(sp)
    80005866:	6402                	ld	s0,0(sp)
    80005868:	0141                	addi	sp,sp,16
    8000586a:	8082                	ret

000000008000586c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000586c:	715d                	addi	sp,sp,-80
    8000586e:	e486                	sd	ra,72(sp)
    80005870:	e0a2                	sd	s0,64(sp)
    80005872:	fc26                	sd	s1,56(sp)
    80005874:	f84a                	sd	s2,48(sp)
    80005876:	f44e                	sd	s3,40(sp)
    80005878:	f052                	sd	s4,32(sp)
    8000587a:	ec56                	sd	s5,24(sp)
    8000587c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000587e:	04c05663          	blez	a2,800058ca <consolewrite+0x5e>
    80005882:	8a2a                	mv	s4,a0
    80005884:	84ae                	mv	s1,a1
    80005886:	89b2                	mv	s3,a2
    80005888:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000588a:	5afd                	li	s5,-1
    8000588c:	4685                	li	a3,1
    8000588e:	8626                	mv	a2,s1
    80005890:	85d2                	mv	a1,s4
    80005892:	fbf40513          	addi	a0,s0,-65
    80005896:	ffffc097          	auipc	ra,0xffffc
    8000589a:	0ba080e7          	jalr	186(ra) # 80001950 <either_copyin>
    8000589e:	01550c63          	beq	a0,s5,800058b6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800058a2:	fbf44503          	lbu	a0,-65(s0)
    800058a6:	00000097          	auipc	ra,0x0
    800058aa:	78e080e7          	jalr	1934(ra) # 80006034 <uartputc>
  for(i = 0; i < n; i++){
    800058ae:	2905                	addiw	s2,s2,1
    800058b0:	0485                	addi	s1,s1,1
    800058b2:	fd299de3          	bne	s3,s2,8000588c <consolewrite+0x20>
  }

  return i;
}
    800058b6:	854a                	mv	a0,s2
    800058b8:	60a6                	ld	ra,72(sp)
    800058ba:	6406                	ld	s0,64(sp)
    800058bc:	74e2                	ld	s1,56(sp)
    800058be:	7942                	ld	s2,48(sp)
    800058c0:	79a2                	ld	s3,40(sp)
    800058c2:	7a02                	ld	s4,32(sp)
    800058c4:	6ae2                	ld	s5,24(sp)
    800058c6:	6161                	addi	sp,sp,80
    800058c8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ca:	4901                	li	s2,0
    800058cc:	b7ed                	j	800058b6 <consolewrite+0x4a>

00000000800058ce <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058ce:	7119                	addi	sp,sp,-128
    800058d0:	fc86                	sd	ra,120(sp)
    800058d2:	f8a2                	sd	s0,112(sp)
    800058d4:	f4a6                	sd	s1,104(sp)
    800058d6:	f0ca                	sd	s2,96(sp)
    800058d8:	ecce                	sd	s3,88(sp)
    800058da:	e8d2                	sd	s4,80(sp)
    800058dc:	e4d6                	sd	s5,72(sp)
    800058de:	e0da                	sd	s6,64(sp)
    800058e0:	fc5e                	sd	s7,56(sp)
    800058e2:	f862                	sd	s8,48(sp)
    800058e4:	f466                	sd	s9,40(sp)
    800058e6:	f06a                	sd	s10,32(sp)
    800058e8:	ec6e                	sd	s11,24(sp)
    800058ea:	0100                	addi	s0,sp,128
    800058ec:	8b2a                	mv	s6,a0
    800058ee:	8aae                	mv	s5,a1
    800058f0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058f2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058f6:	00021517          	auipc	a0,0x21
    800058fa:	84a50513          	addi	a0,a0,-1974 # 80026140 <cons>
    800058fe:	00001097          	auipc	ra,0x1
    80005902:	8f4080e7          	jalr	-1804(ra) # 800061f2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005906:	00021497          	auipc	s1,0x21
    8000590a:	83a48493          	addi	s1,s1,-1990 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000590e:	89a6                	mv	s3,s1
    80005910:	00021917          	auipc	s2,0x21
    80005914:	8c890913          	addi	s2,s2,-1848 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005918:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000591a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000591c:	4da9                	li	s11,10
  while(n > 0){
    8000591e:	07405863          	blez	s4,8000598e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005922:	0984a783          	lw	a5,152(s1)
    80005926:	09c4a703          	lw	a4,156(s1)
    8000592a:	02f71463          	bne	a4,a5,80005952 <consoleread+0x84>
      if(myproc()->killed){
    8000592e:	ffffb097          	auipc	ra,0xffffb
    80005932:	564080e7          	jalr	1380(ra) # 80000e92 <myproc>
    80005936:	551c                	lw	a5,40(a0)
    80005938:	e7b5                	bnez	a5,800059a4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000593a:	85ce                	mv	a1,s3
    8000593c:	854a                	mv	a0,s2
    8000593e:	ffffc097          	auipc	ra,0xffffc
    80005942:	c18080e7          	jalr	-1000(ra) # 80001556 <sleep>
    while(cons.r == cons.w){
    80005946:	0984a783          	lw	a5,152(s1)
    8000594a:	09c4a703          	lw	a4,156(s1)
    8000594e:	fef700e3          	beq	a4,a5,8000592e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005952:	0017871b          	addiw	a4,a5,1
    80005956:	08e4ac23          	sw	a4,152(s1)
    8000595a:	07f7f713          	andi	a4,a5,127
    8000595e:	9726                	add	a4,a4,s1
    80005960:	01874703          	lbu	a4,24(a4)
    80005964:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005968:	079c0663          	beq	s8,s9,800059d4 <consoleread+0x106>
    cbuf = c;
    8000596c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005970:	4685                	li	a3,1
    80005972:	f8f40613          	addi	a2,s0,-113
    80005976:	85d6                	mv	a1,s5
    80005978:	855a                	mv	a0,s6
    8000597a:	ffffc097          	auipc	ra,0xffffc
    8000597e:	f80080e7          	jalr	-128(ra) # 800018fa <either_copyout>
    80005982:	01a50663          	beq	a0,s10,8000598e <consoleread+0xc0>
    dst++;
    80005986:	0a85                	addi	s5,s5,1
    --n;
    80005988:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000598a:	f9bc1ae3          	bne	s8,s11,8000591e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000598e:	00020517          	auipc	a0,0x20
    80005992:	7b250513          	addi	a0,a0,1970 # 80026140 <cons>
    80005996:	00001097          	auipc	ra,0x1
    8000599a:	910080e7          	jalr	-1776(ra) # 800062a6 <release>

  return target - n;
    8000599e:	414b853b          	subw	a0,s7,s4
    800059a2:	a811                	j	800059b6 <consoleread+0xe8>
        release(&cons.lock);
    800059a4:	00020517          	auipc	a0,0x20
    800059a8:	79c50513          	addi	a0,a0,1948 # 80026140 <cons>
    800059ac:	00001097          	auipc	ra,0x1
    800059b0:	8fa080e7          	jalr	-1798(ra) # 800062a6 <release>
        return -1;
    800059b4:	557d                	li	a0,-1
}
    800059b6:	70e6                	ld	ra,120(sp)
    800059b8:	7446                	ld	s0,112(sp)
    800059ba:	74a6                	ld	s1,104(sp)
    800059bc:	7906                	ld	s2,96(sp)
    800059be:	69e6                	ld	s3,88(sp)
    800059c0:	6a46                	ld	s4,80(sp)
    800059c2:	6aa6                	ld	s5,72(sp)
    800059c4:	6b06                	ld	s6,64(sp)
    800059c6:	7be2                	ld	s7,56(sp)
    800059c8:	7c42                	ld	s8,48(sp)
    800059ca:	7ca2                	ld	s9,40(sp)
    800059cc:	7d02                	ld	s10,32(sp)
    800059ce:	6de2                	ld	s11,24(sp)
    800059d0:	6109                	addi	sp,sp,128
    800059d2:	8082                	ret
      if(n < target){
    800059d4:	000a071b          	sext.w	a4,s4
    800059d8:	fb777be3          	bgeu	a4,s7,8000598e <consoleread+0xc0>
        cons.r--;
    800059dc:	00020717          	auipc	a4,0x20
    800059e0:	7ef72e23          	sw	a5,2044(a4) # 800261d8 <cons+0x98>
    800059e4:	b76d                	j	8000598e <consoleread+0xc0>

00000000800059e6 <consputc>:
{
    800059e6:	1141                	addi	sp,sp,-16
    800059e8:	e406                	sd	ra,8(sp)
    800059ea:	e022                	sd	s0,0(sp)
    800059ec:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ee:	10000793          	li	a5,256
    800059f2:	00f50a63          	beq	a0,a5,80005a06 <consputc+0x20>
    uartputc_sync(c);
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	564080e7          	jalr	1380(ra) # 80005f5a <uartputc_sync>
}
    800059fe:	60a2                	ld	ra,8(sp)
    80005a00:	6402                	ld	s0,0(sp)
    80005a02:	0141                	addi	sp,sp,16
    80005a04:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a06:	4521                	li	a0,8
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	552080e7          	jalr	1362(ra) # 80005f5a <uartputc_sync>
    80005a10:	02000513          	li	a0,32
    80005a14:	00000097          	auipc	ra,0x0
    80005a18:	546080e7          	jalr	1350(ra) # 80005f5a <uartputc_sync>
    80005a1c:	4521                	li	a0,8
    80005a1e:	00000097          	auipc	ra,0x0
    80005a22:	53c080e7          	jalr	1340(ra) # 80005f5a <uartputc_sync>
    80005a26:	bfe1                	j	800059fe <consputc+0x18>

0000000080005a28 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a28:	1101                	addi	sp,sp,-32
    80005a2a:	ec06                	sd	ra,24(sp)
    80005a2c:	e822                	sd	s0,16(sp)
    80005a2e:	e426                	sd	s1,8(sp)
    80005a30:	e04a                	sd	s2,0(sp)
    80005a32:	1000                	addi	s0,sp,32
    80005a34:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a36:	00020517          	auipc	a0,0x20
    80005a3a:	70a50513          	addi	a0,a0,1802 # 80026140 <cons>
    80005a3e:	00000097          	auipc	ra,0x0
    80005a42:	7b4080e7          	jalr	1972(ra) # 800061f2 <acquire>

  switch(c){
    80005a46:	47d5                	li	a5,21
    80005a48:	0af48663          	beq	s1,a5,80005af4 <consoleintr+0xcc>
    80005a4c:	0297ca63          	blt	a5,s1,80005a80 <consoleintr+0x58>
    80005a50:	47a1                	li	a5,8
    80005a52:	0ef48763          	beq	s1,a5,80005b40 <consoleintr+0x118>
    80005a56:	47c1                	li	a5,16
    80005a58:	10f49a63          	bne	s1,a5,80005b6c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a5c:	ffffc097          	auipc	ra,0xffffc
    80005a60:	f4a080e7          	jalr	-182(ra) # 800019a6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a64:	00020517          	auipc	a0,0x20
    80005a68:	6dc50513          	addi	a0,a0,1756 # 80026140 <cons>
    80005a6c:	00001097          	auipc	ra,0x1
    80005a70:	83a080e7          	jalr	-1990(ra) # 800062a6 <release>
}
    80005a74:	60e2                	ld	ra,24(sp)
    80005a76:	6442                	ld	s0,16(sp)
    80005a78:	64a2                	ld	s1,8(sp)
    80005a7a:	6902                	ld	s2,0(sp)
    80005a7c:	6105                	addi	sp,sp,32
    80005a7e:	8082                	ret
  switch(c){
    80005a80:	07f00793          	li	a5,127
    80005a84:	0af48e63          	beq	s1,a5,80005b40 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a88:	00020717          	auipc	a4,0x20
    80005a8c:	6b870713          	addi	a4,a4,1720 # 80026140 <cons>
    80005a90:	0a072783          	lw	a5,160(a4)
    80005a94:	09872703          	lw	a4,152(a4)
    80005a98:	9f99                	subw	a5,a5,a4
    80005a9a:	07f00713          	li	a4,127
    80005a9e:	fcf763e3          	bltu	a4,a5,80005a64 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005aa2:	47b5                	li	a5,13
    80005aa4:	0cf48763          	beq	s1,a5,80005b72 <consoleintr+0x14a>
      consputc(c);
    80005aa8:	8526                	mv	a0,s1
    80005aaa:	00000097          	auipc	ra,0x0
    80005aae:	f3c080e7          	jalr	-196(ra) # 800059e6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ab2:	00020797          	auipc	a5,0x20
    80005ab6:	68e78793          	addi	a5,a5,1678 # 80026140 <cons>
    80005aba:	0a07a703          	lw	a4,160(a5)
    80005abe:	0017069b          	addiw	a3,a4,1
    80005ac2:	0006861b          	sext.w	a2,a3
    80005ac6:	0ad7a023          	sw	a3,160(a5)
    80005aca:	07f77713          	andi	a4,a4,127
    80005ace:	97ba                	add	a5,a5,a4
    80005ad0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ad4:	47a9                	li	a5,10
    80005ad6:	0cf48563          	beq	s1,a5,80005ba0 <consoleintr+0x178>
    80005ada:	4791                	li	a5,4
    80005adc:	0cf48263          	beq	s1,a5,80005ba0 <consoleintr+0x178>
    80005ae0:	00020797          	auipc	a5,0x20
    80005ae4:	6f87a783          	lw	a5,1784(a5) # 800261d8 <cons+0x98>
    80005ae8:	0807879b          	addiw	a5,a5,128
    80005aec:	f6f61ce3          	bne	a2,a5,80005a64 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005af0:	863e                	mv	a2,a5
    80005af2:	a07d                	j	80005ba0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005af4:	00020717          	auipc	a4,0x20
    80005af8:	64c70713          	addi	a4,a4,1612 # 80026140 <cons>
    80005afc:	0a072783          	lw	a5,160(a4)
    80005b00:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b04:	00020497          	auipc	s1,0x20
    80005b08:	63c48493          	addi	s1,s1,1596 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005b0c:	4929                	li	s2,10
    80005b0e:	f4f70be3          	beq	a4,a5,80005a64 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b12:	37fd                	addiw	a5,a5,-1
    80005b14:	07f7f713          	andi	a4,a5,127
    80005b18:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b1a:	01874703          	lbu	a4,24(a4)
    80005b1e:	f52703e3          	beq	a4,s2,80005a64 <consoleintr+0x3c>
      cons.e--;
    80005b22:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b26:	10000513          	li	a0,256
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	ebc080e7          	jalr	-324(ra) # 800059e6 <consputc>
    while(cons.e != cons.w &&
    80005b32:	0a04a783          	lw	a5,160(s1)
    80005b36:	09c4a703          	lw	a4,156(s1)
    80005b3a:	fcf71ce3          	bne	a4,a5,80005b12 <consoleintr+0xea>
    80005b3e:	b71d                	j	80005a64 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b40:	00020717          	auipc	a4,0x20
    80005b44:	60070713          	addi	a4,a4,1536 # 80026140 <cons>
    80005b48:	0a072783          	lw	a5,160(a4)
    80005b4c:	09c72703          	lw	a4,156(a4)
    80005b50:	f0f70ae3          	beq	a4,a5,80005a64 <consoleintr+0x3c>
      cons.e--;
    80005b54:	37fd                	addiw	a5,a5,-1
    80005b56:	00020717          	auipc	a4,0x20
    80005b5a:	68f72523          	sw	a5,1674(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b5e:	10000513          	li	a0,256
    80005b62:	00000097          	auipc	ra,0x0
    80005b66:	e84080e7          	jalr	-380(ra) # 800059e6 <consputc>
    80005b6a:	bded                	j	80005a64 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b6c:	ee048ce3          	beqz	s1,80005a64 <consoleintr+0x3c>
    80005b70:	bf21                	j	80005a88 <consoleintr+0x60>
      consputc(c);
    80005b72:	4529                	li	a0,10
    80005b74:	00000097          	auipc	ra,0x0
    80005b78:	e72080e7          	jalr	-398(ra) # 800059e6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b7c:	00020797          	auipc	a5,0x20
    80005b80:	5c478793          	addi	a5,a5,1476 # 80026140 <cons>
    80005b84:	0a07a703          	lw	a4,160(a5)
    80005b88:	0017069b          	addiw	a3,a4,1
    80005b8c:	0006861b          	sext.w	a2,a3
    80005b90:	0ad7a023          	sw	a3,160(a5)
    80005b94:	07f77713          	andi	a4,a4,127
    80005b98:	97ba                	add	a5,a5,a4
    80005b9a:	4729                	li	a4,10
    80005b9c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ba0:	00020797          	auipc	a5,0x20
    80005ba4:	62c7ae23          	sw	a2,1596(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005ba8:	00020517          	auipc	a0,0x20
    80005bac:	63050513          	addi	a0,a0,1584 # 800261d8 <cons+0x98>
    80005bb0:	ffffc097          	auipc	ra,0xffffc
    80005bb4:	b32080e7          	jalr	-1230(ra) # 800016e2 <wakeup>
    80005bb8:	b575                	j	80005a64 <consoleintr+0x3c>

0000000080005bba <consoleinit>:

void
consoleinit(void)
{
    80005bba:	1141                	addi	sp,sp,-16
    80005bbc:	e406                	sd	ra,8(sp)
    80005bbe:	e022                	sd	s0,0(sp)
    80005bc0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bc2:	00003597          	auipc	a1,0x3
    80005bc6:	d5658593          	addi	a1,a1,-682 # 80008918 <syscall_name+0x3c8>
    80005bca:	00020517          	auipc	a0,0x20
    80005bce:	57650513          	addi	a0,a0,1398 # 80026140 <cons>
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	590080e7          	jalr	1424(ra) # 80006162 <initlock>

  uartinit();
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	330080e7          	jalr	816(ra) # 80005f0a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005be2:	00013797          	auipc	a5,0x13
    80005be6:	4e678793          	addi	a5,a5,1254 # 800190c8 <devsw>
    80005bea:	00000717          	auipc	a4,0x0
    80005bee:	ce470713          	addi	a4,a4,-796 # 800058ce <consoleread>
    80005bf2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bf4:	00000717          	auipc	a4,0x0
    80005bf8:	c7870713          	addi	a4,a4,-904 # 8000586c <consolewrite>
    80005bfc:	ef98                	sd	a4,24(a5)
}
    80005bfe:	60a2                	ld	ra,8(sp)
    80005c00:	6402                	ld	s0,0(sp)
    80005c02:	0141                	addi	sp,sp,16
    80005c04:	8082                	ret

0000000080005c06 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c06:	7179                	addi	sp,sp,-48
    80005c08:	f406                	sd	ra,40(sp)
    80005c0a:	f022                	sd	s0,32(sp)
    80005c0c:	ec26                	sd	s1,24(sp)
    80005c0e:	e84a                	sd	s2,16(sp)
    80005c10:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c12:	c219                	beqz	a2,80005c18 <printint+0x12>
    80005c14:	08054663          	bltz	a0,80005ca0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c18:	2501                	sext.w	a0,a0
    80005c1a:	4881                	li	a7,0
    80005c1c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c20:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c22:	2581                	sext.w	a1,a1
    80005c24:	00003617          	auipc	a2,0x3
    80005c28:	d2460613          	addi	a2,a2,-732 # 80008948 <digits>
    80005c2c:	883a                	mv	a6,a4
    80005c2e:	2705                	addiw	a4,a4,1
    80005c30:	02b577bb          	remuw	a5,a0,a1
    80005c34:	1782                	slli	a5,a5,0x20
    80005c36:	9381                	srli	a5,a5,0x20
    80005c38:	97b2                	add	a5,a5,a2
    80005c3a:	0007c783          	lbu	a5,0(a5)
    80005c3e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c42:	0005079b          	sext.w	a5,a0
    80005c46:	02b5553b          	divuw	a0,a0,a1
    80005c4a:	0685                	addi	a3,a3,1
    80005c4c:	feb7f0e3          	bgeu	a5,a1,80005c2c <printint+0x26>

  if(sign)
    80005c50:	00088b63          	beqz	a7,80005c66 <printint+0x60>
    buf[i++] = '-';
    80005c54:	fe040793          	addi	a5,s0,-32
    80005c58:	973e                	add	a4,a4,a5
    80005c5a:	02d00793          	li	a5,45
    80005c5e:	fef70823          	sb	a5,-16(a4)
    80005c62:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c66:	02e05763          	blez	a4,80005c94 <printint+0x8e>
    80005c6a:	fd040793          	addi	a5,s0,-48
    80005c6e:	00e784b3          	add	s1,a5,a4
    80005c72:	fff78913          	addi	s2,a5,-1
    80005c76:	993a                	add	s2,s2,a4
    80005c78:	377d                	addiw	a4,a4,-1
    80005c7a:	1702                	slli	a4,a4,0x20
    80005c7c:	9301                	srli	a4,a4,0x20
    80005c7e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c82:	fff4c503          	lbu	a0,-1(s1)
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	d60080e7          	jalr	-672(ra) # 800059e6 <consputc>
  while(--i >= 0)
    80005c8e:	14fd                	addi	s1,s1,-1
    80005c90:	ff2499e3          	bne	s1,s2,80005c82 <printint+0x7c>
}
    80005c94:	70a2                	ld	ra,40(sp)
    80005c96:	7402                	ld	s0,32(sp)
    80005c98:	64e2                	ld	s1,24(sp)
    80005c9a:	6942                	ld	s2,16(sp)
    80005c9c:	6145                	addi	sp,sp,48
    80005c9e:	8082                	ret
    x = -xx;
    80005ca0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ca4:	4885                	li	a7,1
    x = -xx;
    80005ca6:	bf9d                	j	80005c1c <printint+0x16>

0000000080005ca8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ca8:	1101                	addi	sp,sp,-32
    80005caa:	ec06                	sd	ra,24(sp)
    80005cac:	e822                	sd	s0,16(sp)
    80005cae:	e426                	sd	s1,8(sp)
    80005cb0:	1000                	addi	s0,sp,32
    80005cb2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cb4:	00020797          	auipc	a5,0x20
    80005cb8:	5407a623          	sw	zero,1356(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cbc:	00003517          	auipc	a0,0x3
    80005cc0:	c6450513          	addi	a0,a0,-924 # 80008920 <syscall_name+0x3d0>
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	02e080e7          	jalr	46(ra) # 80005cf2 <printf>
  printf(s);
    80005ccc:	8526                	mv	a0,s1
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	024080e7          	jalr	36(ra) # 80005cf2 <printf>
  printf("\n");
    80005cd6:	00002517          	auipc	a0,0x2
    80005cda:	37250513          	addi	a0,a0,882 # 80008048 <etext+0x48>
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	014080e7          	jalr	20(ra) # 80005cf2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ce6:	4785                	li	a5,1
    80005ce8:	00003717          	auipc	a4,0x3
    80005cec:	32f72a23          	sw	a5,820(a4) # 8000901c <panicked>
  for(;;)
    80005cf0:	a001                	j	80005cf0 <panic+0x48>

0000000080005cf2 <printf>:
{
    80005cf2:	7131                	addi	sp,sp,-192
    80005cf4:	fc86                	sd	ra,120(sp)
    80005cf6:	f8a2                	sd	s0,112(sp)
    80005cf8:	f4a6                	sd	s1,104(sp)
    80005cfa:	f0ca                	sd	s2,96(sp)
    80005cfc:	ecce                	sd	s3,88(sp)
    80005cfe:	e8d2                	sd	s4,80(sp)
    80005d00:	e4d6                	sd	s5,72(sp)
    80005d02:	e0da                	sd	s6,64(sp)
    80005d04:	fc5e                	sd	s7,56(sp)
    80005d06:	f862                	sd	s8,48(sp)
    80005d08:	f466                	sd	s9,40(sp)
    80005d0a:	f06a                	sd	s10,32(sp)
    80005d0c:	ec6e                	sd	s11,24(sp)
    80005d0e:	0100                	addi	s0,sp,128
    80005d10:	8a2a                	mv	s4,a0
    80005d12:	e40c                	sd	a1,8(s0)
    80005d14:	e810                	sd	a2,16(s0)
    80005d16:	ec14                	sd	a3,24(s0)
    80005d18:	f018                	sd	a4,32(s0)
    80005d1a:	f41c                	sd	a5,40(s0)
    80005d1c:	03043823          	sd	a6,48(s0)
    80005d20:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d24:	00020d97          	auipc	s11,0x20
    80005d28:	4dcdad83          	lw	s11,1244(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d2c:	020d9b63          	bnez	s11,80005d62 <printf+0x70>
  if (fmt == 0)
    80005d30:	040a0263          	beqz	s4,80005d74 <printf+0x82>
  va_start(ap, fmt);
    80005d34:	00840793          	addi	a5,s0,8
    80005d38:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3c:	000a4503          	lbu	a0,0(s4)
    80005d40:	16050263          	beqz	a0,80005ea4 <printf+0x1b2>
    80005d44:	4481                	li	s1,0
    if(c != '%'){
    80005d46:	02500a93          	li	s5,37
    switch(c){
    80005d4a:	07000b13          	li	s6,112
  consputc('x');
    80005d4e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d50:	00003b97          	auipc	s7,0x3
    80005d54:	bf8b8b93          	addi	s7,s7,-1032 # 80008948 <digits>
    switch(c){
    80005d58:	07300c93          	li	s9,115
    80005d5c:	06400c13          	li	s8,100
    80005d60:	a82d                	j	80005d9a <printf+0xa8>
    acquire(&pr.lock);
    80005d62:	00020517          	auipc	a0,0x20
    80005d66:	48650513          	addi	a0,a0,1158 # 800261e8 <pr>
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	488080e7          	jalr	1160(ra) # 800061f2 <acquire>
    80005d72:	bf7d                	j	80005d30 <printf+0x3e>
    panic("null fmt");
    80005d74:	00003517          	auipc	a0,0x3
    80005d78:	bbc50513          	addi	a0,a0,-1092 # 80008930 <syscall_name+0x3e0>
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	f2c080e7          	jalr	-212(ra) # 80005ca8 <panic>
      consputc(c);
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	c62080e7          	jalr	-926(ra) # 800059e6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d8c:	2485                	addiw	s1,s1,1
    80005d8e:	009a07b3          	add	a5,s4,s1
    80005d92:	0007c503          	lbu	a0,0(a5)
    80005d96:	10050763          	beqz	a0,80005ea4 <printf+0x1b2>
    if(c != '%'){
    80005d9a:	ff5515e3          	bne	a0,s5,80005d84 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d9e:	2485                	addiw	s1,s1,1
    80005da0:	009a07b3          	add	a5,s4,s1
    80005da4:	0007c783          	lbu	a5,0(a5)
    80005da8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dac:	cfe5                	beqz	a5,80005ea4 <printf+0x1b2>
    switch(c){
    80005dae:	05678a63          	beq	a5,s6,80005e02 <printf+0x110>
    80005db2:	02fb7663          	bgeu	s6,a5,80005dde <printf+0xec>
    80005db6:	09978963          	beq	a5,s9,80005e48 <printf+0x156>
    80005dba:	07800713          	li	a4,120
    80005dbe:	0ce79863          	bne	a5,a4,80005e8e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005dc2:	f8843783          	ld	a5,-120(s0)
    80005dc6:	00878713          	addi	a4,a5,8
    80005dca:	f8e43423          	sd	a4,-120(s0)
    80005dce:	4605                	li	a2,1
    80005dd0:	85ea                	mv	a1,s10
    80005dd2:	4388                	lw	a0,0(a5)
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	e32080e7          	jalr	-462(ra) # 80005c06 <printint>
      break;
    80005ddc:	bf45                	j	80005d8c <printf+0x9a>
    switch(c){
    80005dde:	0b578263          	beq	a5,s5,80005e82 <printf+0x190>
    80005de2:	0b879663          	bne	a5,s8,80005e8e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005de6:	f8843783          	ld	a5,-120(s0)
    80005dea:	00878713          	addi	a4,a5,8
    80005dee:	f8e43423          	sd	a4,-120(s0)
    80005df2:	4605                	li	a2,1
    80005df4:	45a9                	li	a1,10
    80005df6:	4388                	lw	a0,0(a5)
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	e0e080e7          	jalr	-498(ra) # 80005c06 <printint>
      break;
    80005e00:	b771                	j	80005d8c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e02:	f8843783          	ld	a5,-120(s0)
    80005e06:	00878713          	addi	a4,a5,8
    80005e0a:	f8e43423          	sd	a4,-120(s0)
    80005e0e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e12:	03000513          	li	a0,48
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	bd0080e7          	jalr	-1072(ra) # 800059e6 <consputc>
  consputc('x');
    80005e1e:	07800513          	li	a0,120
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	bc4080e7          	jalr	-1084(ra) # 800059e6 <consputc>
    80005e2a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e2c:	03c9d793          	srli	a5,s3,0x3c
    80005e30:	97de                	add	a5,a5,s7
    80005e32:	0007c503          	lbu	a0,0(a5)
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	bb0080e7          	jalr	-1104(ra) # 800059e6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e3e:	0992                	slli	s3,s3,0x4
    80005e40:	397d                	addiw	s2,s2,-1
    80005e42:	fe0915e3          	bnez	s2,80005e2c <printf+0x13a>
    80005e46:	b799                	j	80005d8c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e48:	f8843783          	ld	a5,-120(s0)
    80005e4c:	00878713          	addi	a4,a5,8
    80005e50:	f8e43423          	sd	a4,-120(s0)
    80005e54:	0007b903          	ld	s2,0(a5)
    80005e58:	00090e63          	beqz	s2,80005e74 <printf+0x182>
      for(; *s; s++)
    80005e5c:	00094503          	lbu	a0,0(s2)
    80005e60:	d515                	beqz	a0,80005d8c <printf+0x9a>
        consputc(*s);
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	b84080e7          	jalr	-1148(ra) # 800059e6 <consputc>
      for(; *s; s++)
    80005e6a:	0905                	addi	s2,s2,1
    80005e6c:	00094503          	lbu	a0,0(s2)
    80005e70:	f96d                	bnez	a0,80005e62 <printf+0x170>
    80005e72:	bf29                	j	80005d8c <printf+0x9a>
        s = "(null)";
    80005e74:	00003917          	auipc	s2,0x3
    80005e78:	ab490913          	addi	s2,s2,-1356 # 80008928 <syscall_name+0x3d8>
      for(; *s; s++)
    80005e7c:	02800513          	li	a0,40
    80005e80:	b7cd                	j	80005e62 <printf+0x170>
      consputc('%');
    80005e82:	8556                	mv	a0,s5
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	b62080e7          	jalr	-1182(ra) # 800059e6 <consputc>
      break;
    80005e8c:	b701                	j	80005d8c <printf+0x9a>
      consputc('%');
    80005e8e:	8556                	mv	a0,s5
    80005e90:	00000097          	auipc	ra,0x0
    80005e94:	b56080e7          	jalr	-1194(ra) # 800059e6 <consputc>
      consputc(c);
    80005e98:	854a                	mv	a0,s2
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	b4c080e7          	jalr	-1204(ra) # 800059e6 <consputc>
      break;
    80005ea2:	b5ed                	j	80005d8c <printf+0x9a>
  if(locking)
    80005ea4:	020d9163          	bnez	s11,80005ec6 <printf+0x1d4>
}
    80005ea8:	70e6                	ld	ra,120(sp)
    80005eaa:	7446                	ld	s0,112(sp)
    80005eac:	74a6                	ld	s1,104(sp)
    80005eae:	7906                	ld	s2,96(sp)
    80005eb0:	69e6                	ld	s3,88(sp)
    80005eb2:	6a46                	ld	s4,80(sp)
    80005eb4:	6aa6                	ld	s5,72(sp)
    80005eb6:	6b06                	ld	s6,64(sp)
    80005eb8:	7be2                	ld	s7,56(sp)
    80005eba:	7c42                	ld	s8,48(sp)
    80005ebc:	7ca2                	ld	s9,40(sp)
    80005ebe:	7d02                	ld	s10,32(sp)
    80005ec0:	6de2                	ld	s11,24(sp)
    80005ec2:	6129                	addi	sp,sp,192
    80005ec4:	8082                	ret
    release(&pr.lock);
    80005ec6:	00020517          	auipc	a0,0x20
    80005eca:	32250513          	addi	a0,a0,802 # 800261e8 <pr>
    80005ece:	00000097          	auipc	ra,0x0
    80005ed2:	3d8080e7          	jalr	984(ra) # 800062a6 <release>
}
    80005ed6:	bfc9                	j	80005ea8 <printf+0x1b6>

0000000080005ed8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ed8:	1101                	addi	sp,sp,-32
    80005eda:	ec06                	sd	ra,24(sp)
    80005edc:	e822                	sd	s0,16(sp)
    80005ede:	e426                	sd	s1,8(sp)
    80005ee0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ee2:	00020497          	auipc	s1,0x20
    80005ee6:	30648493          	addi	s1,s1,774 # 800261e8 <pr>
    80005eea:	00003597          	auipc	a1,0x3
    80005eee:	a5658593          	addi	a1,a1,-1450 # 80008940 <syscall_name+0x3f0>
    80005ef2:	8526                	mv	a0,s1
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	26e080e7          	jalr	622(ra) # 80006162 <initlock>
  pr.locking = 1;
    80005efc:	4785                	li	a5,1
    80005efe:	cc9c                	sw	a5,24(s1)
}
    80005f00:	60e2                	ld	ra,24(sp)
    80005f02:	6442                	ld	s0,16(sp)
    80005f04:	64a2                	ld	s1,8(sp)
    80005f06:	6105                	addi	sp,sp,32
    80005f08:	8082                	ret

0000000080005f0a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f0a:	1141                	addi	sp,sp,-16
    80005f0c:	e406                	sd	ra,8(sp)
    80005f0e:	e022                	sd	s0,0(sp)
    80005f10:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f12:	100007b7          	lui	a5,0x10000
    80005f16:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f1a:	f8000713          	li	a4,-128
    80005f1e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f22:	470d                	li	a4,3
    80005f24:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f28:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f2c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f30:	469d                	li	a3,7
    80005f32:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f36:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f3a:	00003597          	auipc	a1,0x3
    80005f3e:	a2658593          	addi	a1,a1,-1498 # 80008960 <digits+0x18>
    80005f42:	00020517          	auipc	a0,0x20
    80005f46:	2c650513          	addi	a0,a0,710 # 80026208 <uart_tx_lock>
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	218080e7          	jalr	536(ra) # 80006162 <initlock>
}
    80005f52:	60a2                	ld	ra,8(sp)
    80005f54:	6402                	ld	s0,0(sp)
    80005f56:	0141                	addi	sp,sp,16
    80005f58:	8082                	ret

0000000080005f5a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f5a:	1101                	addi	sp,sp,-32
    80005f5c:	ec06                	sd	ra,24(sp)
    80005f5e:	e822                	sd	s0,16(sp)
    80005f60:	e426                	sd	s1,8(sp)
    80005f62:	1000                	addi	s0,sp,32
    80005f64:	84aa                	mv	s1,a0
  push_off();
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	240080e7          	jalr	576(ra) # 800061a6 <push_off>

  if(panicked){
    80005f6e:	00003797          	auipc	a5,0x3
    80005f72:	0ae7a783          	lw	a5,174(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f76:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f7a:	c391                	beqz	a5,80005f7e <uartputc_sync+0x24>
    for(;;)
    80005f7c:	a001                	j	80005f7c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f7e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f82:	0ff7f793          	andi	a5,a5,255
    80005f86:	0207f793          	andi	a5,a5,32
    80005f8a:	dbf5                	beqz	a5,80005f7e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f8c:	0ff4f793          	andi	a5,s1,255
    80005f90:	10000737          	lui	a4,0x10000
    80005f94:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	2ae080e7          	jalr	686(ra) # 80006246 <pop_off>
}
    80005fa0:	60e2                	ld	ra,24(sp)
    80005fa2:	6442                	ld	s0,16(sp)
    80005fa4:	64a2                	ld	s1,8(sp)
    80005fa6:	6105                	addi	sp,sp,32
    80005fa8:	8082                	ret

0000000080005faa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005faa:	00003717          	auipc	a4,0x3
    80005fae:	07673703          	ld	a4,118(a4) # 80009020 <uart_tx_r>
    80005fb2:	00003797          	auipc	a5,0x3
    80005fb6:	0767b783          	ld	a5,118(a5) # 80009028 <uart_tx_w>
    80005fba:	06e78c63          	beq	a5,a4,80006032 <uartstart+0x88>
{
    80005fbe:	7139                	addi	sp,sp,-64
    80005fc0:	fc06                	sd	ra,56(sp)
    80005fc2:	f822                	sd	s0,48(sp)
    80005fc4:	f426                	sd	s1,40(sp)
    80005fc6:	f04a                	sd	s2,32(sp)
    80005fc8:	ec4e                	sd	s3,24(sp)
    80005fca:	e852                	sd	s4,16(sp)
    80005fcc:	e456                	sd	s5,8(sp)
    80005fce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fd0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fd4:	00020a17          	auipc	s4,0x20
    80005fd8:	234a0a13          	addi	s4,s4,564 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fdc:	00003497          	auipc	s1,0x3
    80005fe0:	04448493          	addi	s1,s1,68 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fe4:	00003997          	auipc	s3,0x3
    80005fe8:	04498993          	addi	s3,s3,68 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fec:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ff0:	0ff7f793          	andi	a5,a5,255
    80005ff4:	0207f793          	andi	a5,a5,32
    80005ff8:	c785                	beqz	a5,80006020 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ffa:	01f77793          	andi	a5,a4,31
    80005ffe:	97d2                	add	a5,a5,s4
    80006000:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006004:	0705                	addi	a4,a4,1
    80006006:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006008:	8526                	mv	a0,s1
    8000600a:	ffffb097          	auipc	ra,0xffffb
    8000600e:	6d8080e7          	jalr	1752(ra) # 800016e2 <wakeup>
    
    WriteReg(THR, c);
    80006012:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006016:	6098                	ld	a4,0(s1)
    80006018:	0009b783          	ld	a5,0(s3)
    8000601c:	fce798e3          	bne	a5,a4,80005fec <uartstart+0x42>
  }
}
    80006020:	70e2                	ld	ra,56(sp)
    80006022:	7442                	ld	s0,48(sp)
    80006024:	74a2                	ld	s1,40(sp)
    80006026:	7902                	ld	s2,32(sp)
    80006028:	69e2                	ld	s3,24(sp)
    8000602a:	6a42                	ld	s4,16(sp)
    8000602c:	6aa2                	ld	s5,8(sp)
    8000602e:	6121                	addi	sp,sp,64
    80006030:	8082                	ret
    80006032:	8082                	ret

0000000080006034 <uartputc>:
{
    80006034:	7179                	addi	sp,sp,-48
    80006036:	f406                	sd	ra,40(sp)
    80006038:	f022                	sd	s0,32(sp)
    8000603a:	ec26                	sd	s1,24(sp)
    8000603c:	e84a                	sd	s2,16(sp)
    8000603e:	e44e                	sd	s3,8(sp)
    80006040:	e052                	sd	s4,0(sp)
    80006042:	1800                	addi	s0,sp,48
    80006044:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006046:	00020517          	auipc	a0,0x20
    8000604a:	1c250513          	addi	a0,a0,450 # 80026208 <uart_tx_lock>
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	1a4080e7          	jalr	420(ra) # 800061f2 <acquire>
  if(panicked){
    80006056:	00003797          	auipc	a5,0x3
    8000605a:	fc67a783          	lw	a5,-58(a5) # 8000901c <panicked>
    8000605e:	c391                	beqz	a5,80006062 <uartputc+0x2e>
    for(;;)
    80006060:	a001                	j	80006060 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006062:	00003797          	auipc	a5,0x3
    80006066:	fc67b783          	ld	a5,-58(a5) # 80009028 <uart_tx_w>
    8000606a:	00003717          	auipc	a4,0x3
    8000606e:	fb673703          	ld	a4,-74(a4) # 80009020 <uart_tx_r>
    80006072:	02070713          	addi	a4,a4,32
    80006076:	02f71b63          	bne	a4,a5,800060ac <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000607a:	00020a17          	auipc	s4,0x20
    8000607e:	18ea0a13          	addi	s4,s4,398 # 80026208 <uart_tx_lock>
    80006082:	00003497          	auipc	s1,0x3
    80006086:	f9e48493          	addi	s1,s1,-98 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000608a:	00003917          	auipc	s2,0x3
    8000608e:	f9e90913          	addi	s2,s2,-98 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006092:	85d2                	mv	a1,s4
    80006094:	8526                	mv	a0,s1
    80006096:	ffffb097          	auipc	ra,0xffffb
    8000609a:	4c0080e7          	jalr	1216(ra) # 80001556 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000609e:	00093783          	ld	a5,0(s2)
    800060a2:	6098                	ld	a4,0(s1)
    800060a4:	02070713          	addi	a4,a4,32
    800060a8:	fef705e3          	beq	a4,a5,80006092 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060ac:	00020497          	auipc	s1,0x20
    800060b0:	15c48493          	addi	s1,s1,348 # 80026208 <uart_tx_lock>
    800060b4:	01f7f713          	andi	a4,a5,31
    800060b8:	9726                	add	a4,a4,s1
    800060ba:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060be:	0785                	addi	a5,a5,1
    800060c0:	00003717          	auipc	a4,0x3
    800060c4:	f6f73423          	sd	a5,-152(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	ee2080e7          	jalr	-286(ra) # 80005faa <uartstart>
      release(&uart_tx_lock);
    800060d0:	8526                	mv	a0,s1
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	1d4080e7          	jalr	468(ra) # 800062a6 <release>
}
    800060da:	70a2                	ld	ra,40(sp)
    800060dc:	7402                	ld	s0,32(sp)
    800060de:	64e2                	ld	s1,24(sp)
    800060e0:	6942                	ld	s2,16(sp)
    800060e2:	69a2                	ld	s3,8(sp)
    800060e4:	6a02                	ld	s4,0(sp)
    800060e6:	6145                	addi	sp,sp,48
    800060e8:	8082                	ret

00000000800060ea <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060ea:	1141                	addi	sp,sp,-16
    800060ec:	e422                	sd	s0,8(sp)
    800060ee:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060f0:	100007b7          	lui	a5,0x10000
    800060f4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060f8:	8b85                	andi	a5,a5,1
    800060fa:	cb91                	beqz	a5,8000610e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060fc:	100007b7          	lui	a5,0x10000
    80006100:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006104:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006108:	6422                	ld	s0,8(sp)
    8000610a:	0141                	addi	sp,sp,16
    8000610c:	8082                	ret
    return -1;
    8000610e:	557d                	li	a0,-1
    80006110:	bfe5                	j	80006108 <uartgetc+0x1e>

0000000080006112 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006112:	1101                	addi	sp,sp,-32
    80006114:	ec06                	sd	ra,24(sp)
    80006116:	e822                	sd	s0,16(sp)
    80006118:	e426                	sd	s1,8(sp)
    8000611a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000611c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	fcc080e7          	jalr	-52(ra) # 800060ea <uartgetc>
    if(c == -1)
    80006126:	00950763          	beq	a0,s1,80006134 <uartintr+0x22>
      break;
    consoleintr(c);
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	8fe080e7          	jalr	-1794(ra) # 80005a28 <consoleintr>
  while(1){
    80006132:	b7f5                	j	8000611e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006134:	00020497          	auipc	s1,0x20
    80006138:	0d448493          	addi	s1,s1,212 # 80026208 <uart_tx_lock>
    8000613c:	8526                	mv	a0,s1
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	0b4080e7          	jalr	180(ra) # 800061f2 <acquire>
  uartstart();
    80006146:	00000097          	auipc	ra,0x0
    8000614a:	e64080e7          	jalr	-412(ra) # 80005faa <uartstart>
  release(&uart_tx_lock);
    8000614e:	8526                	mv	a0,s1
    80006150:	00000097          	auipc	ra,0x0
    80006154:	156080e7          	jalr	342(ra) # 800062a6 <release>
}
    80006158:	60e2                	ld	ra,24(sp)
    8000615a:	6442                	ld	s0,16(sp)
    8000615c:	64a2                	ld	s1,8(sp)
    8000615e:	6105                	addi	sp,sp,32
    80006160:	8082                	ret

0000000080006162 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006162:	1141                	addi	sp,sp,-16
    80006164:	e422                	sd	s0,8(sp)
    80006166:	0800                	addi	s0,sp,16
  lk->name = name;
    80006168:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000616a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000616e:	00053823          	sd	zero,16(a0)
}
    80006172:	6422                	ld	s0,8(sp)
    80006174:	0141                	addi	sp,sp,16
    80006176:	8082                	ret

0000000080006178 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006178:	411c                	lw	a5,0(a0)
    8000617a:	e399                	bnez	a5,80006180 <holding+0x8>
    8000617c:	4501                	li	a0,0
  return r;
}
    8000617e:	8082                	ret
{
    80006180:	1101                	addi	sp,sp,-32
    80006182:	ec06                	sd	ra,24(sp)
    80006184:	e822                	sd	s0,16(sp)
    80006186:	e426                	sd	s1,8(sp)
    80006188:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000618a:	6904                	ld	s1,16(a0)
    8000618c:	ffffb097          	auipc	ra,0xffffb
    80006190:	cea080e7          	jalr	-790(ra) # 80000e76 <mycpu>
    80006194:	40a48533          	sub	a0,s1,a0
    80006198:	00153513          	seqz	a0,a0
}
    8000619c:	60e2                	ld	ra,24(sp)
    8000619e:	6442                	ld	s0,16(sp)
    800061a0:	64a2                	ld	s1,8(sp)
    800061a2:	6105                	addi	sp,sp,32
    800061a4:	8082                	ret

00000000800061a6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061a6:	1101                	addi	sp,sp,-32
    800061a8:	ec06                	sd	ra,24(sp)
    800061aa:	e822                	sd	s0,16(sp)
    800061ac:	e426                	sd	s1,8(sp)
    800061ae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061b0:	100024f3          	csrr	s1,sstatus
    800061b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061b8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ba:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	cb8080e7          	jalr	-840(ra) # 80000e76 <mycpu>
    800061c6:	5d3c                	lw	a5,120(a0)
    800061c8:	cf89                	beqz	a5,800061e2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	cac080e7          	jalr	-852(ra) # 80000e76 <mycpu>
    800061d2:	5d3c                	lw	a5,120(a0)
    800061d4:	2785                	addiw	a5,a5,1
    800061d6:	dd3c                	sw	a5,120(a0)
}
    800061d8:	60e2                	ld	ra,24(sp)
    800061da:	6442                	ld	s0,16(sp)
    800061dc:	64a2                	ld	s1,8(sp)
    800061de:	6105                	addi	sp,sp,32
    800061e0:	8082                	ret
    mycpu()->intena = old;
    800061e2:	ffffb097          	auipc	ra,0xffffb
    800061e6:	c94080e7          	jalr	-876(ra) # 80000e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061ea:	8085                	srli	s1,s1,0x1
    800061ec:	8885                	andi	s1,s1,1
    800061ee:	dd64                	sw	s1,124(a0)
    800061f0:	bfe9                	j	800061ca <push_off+0x24>

00000000800061f2 <acquire>:
{
    800061f2:	1101                	addi	sp,sp,-32
    800061f4:	ec06                	sd	ra,24(sp)
    800061f6:	e822                	sd	s0,16(sp)
    800061f8:	e426                	sd	s1,8(sp)
    800061fa:	1000                	addi	s0,sp,32
    800061fc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	fa8080e7          	jalr	-88(ra) # 800061a6 <push_off>
  if(holding(lk))
    80006206:	8526                	mv	a0,s1
    80006208:	00000097          	auipc	ra,0x0
    8000620c:	f70080e7          	jalr	-144(ra) # 80006178 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006210:	4705                	li	a4,1
  if(holding(lk))
    80006212:	e115                	bnez	a0,80006236 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006214:	87ba                	mv	a5,a4
    80006216:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000621a:	2781                	sext.w	a5,a5
    8000621c:	ffe5                	bnez	a5,80006214 <acquire+0x22>
  __sync_synchronize();
    8000621e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006222:	ffffb097          	auipc	ra,0xffffb
    80006226:	c54080e7          	jalr	-940(ra) # 80000e76 <mycpu>
    8000622a:	e888                	sd	a0,16(s1)
}
    8000622c:	60e2                	ld	ra,24(sp)
    8000622e:	6442                	ld	s0,16(sp)
    80006230:	64a2                	ld	s1,8(sp)
    80006232:	6105                	addi	sp,sp,32
    80006234:	8082                	ret
    panic("acquire");
    80006236:	00002517          	auipc	a0,0x2
    8000623a:	73250513          	addi	a0,a0,1842 # 80008968 <digits+0x20>
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	a6a080e7          	jalr	-1430(ra) # 80005ca8 <panic>

0000000080006246 <pop_off>:

void
pop_off(void)
{
    80006246:	1141                	addi	sp,sp,-16
    80006248:	e406                	sd	ra,8(sp)
    8000624a:	e022                	sd	s0,0(sp)
    8000624c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000624e:	ffffb097          	auipc	ra,0xffffb
    80006252:	c28080e7          	jalr	-984(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006256:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000625a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000625c:	e78d                	bnez	a5,80006286 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000625e:	5d3c                	lw	a5,120(a0)
    80006260:	02f05b63          	blez	a5,80006296 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006264:	37fd                	addiw	a5,a5,-1
    80006266:	0007871b          	sext.w	a4,a5
    8000626a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000626c:	eb09                	bnez	a4,8000627e <pop_off+0x38>
    8000626e:	5d7c                	lw	a5,124(a0)
    80006270:	c799                	beqz	a5,8000627e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006272:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006276:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000627a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000627e:	60a2                	ld	ra,8(sp)
    80006280:	6402                	ld	s0,0(sp)
    80006282:	0141                	addi	sp,sp,16
    80006284:	8082                	ret
    panic("pop_off - interruptible");
    80006286:	00002517          	auipc	a0,0x2
    8000628a:	6ea50513          	addi	a0,a0,1770 # 80008970 <digits+0x28>
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	a1a080e7          	jalr	-1510(ra) # 80005ca8 <panic>
    panic("pop_off");
    80006296:	00002517          	auipc	a0,0x2
    8000629a:	6f250513          	addi	a0,a0,1778 # 80008988 <digits+0x40>
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	a0a080e7          	jalr	-1526(ra) # 80005ca8 <panic>

00000000800062a6 <release>:
{
    800062a6:	1101                	addi	sp,sp,-32
    800062a8:	ec06                	sd	ra,24(sp)
    800062aa:	e822                	sd	s0,16(sp)
    800062ac:	e426                	sd	s1,8(sp)
    800062ae:	1000                	addi	s0,sp,32
    800062b0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	ec6080e7          	jalr	-314(ra) # 80006178 <holding>
    800062ba:	c115                	beqz	a0,800062de <release+0x38>
  lk->cpu = 0;
    800062bc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062c0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062c4:	0f50000f          	fence	iorw,ow
    800062c8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062cc:	00000097          	auipc	ra,0x0
    800062d0:	f7a080e7          	jalr	-134(ra) # 80006246 <pop_off>
}
    800062d4:	60e2                	ld	ra,24(sp)
    800062d6:	6442                	ld	s0,16(sp)
    800062d8:	64a2                	ld	s1,8(sp)
    800062da:	6105                	addi	sp,sp,32
    800062dc:	8082                	ret
    panic("release");
    800062de:	00002517          	auipc	a0,0x2
    800062e2:	6b250513          	addi	a0,a0,1714 # 80008990 <digits+0x48>
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	9c2080e7          	jalr	-1598(ra) # 80005ca8 <panic>
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
