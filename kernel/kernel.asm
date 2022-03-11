
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	90013103          	ld	sp,-1792(sp) # 80008900 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	153050ef          	jal	ra,80005968 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <increfcount>:
  } 
}

void 
increfcount(uint64 pa)
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
   //acquire(&kmem.lock);
  refcount[(PA2INX(pa))]++;
    80000022:	800007b7          	lui	a5,0x80000
    80000026:	953e                	add	a0,a0,a5
    80000028:	8131                	srli	a0,a0,0xc
    8000002a:	050a                	slli	a0,a0,0x2
    8000002c:	00009797          	auipc	a5,0x9
    80000030:	02478793          	addi	a5,a5,36 # 80009050 <refcount>
    80000034:	953e                	add	a0,a0,a5
    80000036:	411c                	lw	a5,0(a0)
    80000038:	2785                	addiw	a5,a5,1
    8000003a:	c11c                	sw	a5,0(a0)
  //release(&kmem.lock);
}
    8000003c:	6422                	ld	s0,8(sp)
    8000003e:	0141                	addi	sp,sp,16
    80000040:	8082                	ret

0000000080000042 <getrefcount>:
uint  
getrefcount(uint64 pa)
{
    80000042:	1141                	addi	sp,sp,-16
    80000044:	e422                	sd	s0,8(sp)
    80000046:	0800                	addi	s0,sp,16
  uint count;
 // acquire(&kmem.lock);
  count = refcount[(PA2INX(pa))];
    80000048:	800007b7          	lui	a5,0x80000
    8000004c:	953e                	add	a0,a0,a5
    8000004e:	8131                	srli	a0,a0,0xc
    80000050:	050a                	slli	a0,a0,0x2
    80000052:	00009797          	auipc	a5,0x9
    80000056:	ffe78793          	addi	a5,a5,-2 # 80009050 <refcount>
    8000005a:	953e                	add	a0,a0,a5
  //release(&kmem.lock);
  return count;
}
    8000005c:	4108                	lw	a0,0(a0)
    8000005e:	6422                	ld	s0,8(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000064:	1101                	addi	sp,sp,-32
    80000066:	ec06                	sd	ra,24(sp)
    80000068:	e822                	sd	s0,16(sp)
    8000006a:	e426                	sd	s1,8(sp)
    8000006c:	e04a                	sd	s2,0(sp)
    8000006e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000070:	03451793          	slli	a5,a0,0x34
    80000074:	ebd9                	bnez	a5,8000010a <kfree+0xa6>
    80000076:	84aa                	mv	s1,a0
    80000078:	00046797          	auipc	a5,0x46
    8000007c:	1c878793          	addi	a5,a5,456 # 80046240 <end>
    80000080:	08f56563          	bltu	a0,a5,8000010a <kfree+0xa6>
    80000084:	47c5                	li	a5,17
    80000086:	07ee                	slli	a5,a5,0x1b
    80000088:	08f57163          	bgeu	a0,a5,8000010a <kfree+0xa6>
  // Fill with junk to catch dangling refs.
 // memset(pa, 1, PGSIZE);
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000008c:	00009517          	auipc	a0,0x9
    80000090:	fa450513          	addi	a0,a0,-92 # 80009030 <kmem>
    80000094:	00006097          	auipc	ra,0x6
    80000098:	33a080e7          	jalr	826(ra) # 800063ce <acquire>
  refcount[(PA2INX((uint64)pa))]-=1;
    8000009c:	800007b7          	lui	a5,0x80000
    800000a0:	97a6                	add	a5,a5,s1
    800000a2:	83b1                	srli	a5,a5,0xc
    800000a4:	078a                	slli	a5,a5,0x2
    800000a6:	00009717          	auipc	a4,0x9
    800000aa:	faa70713          	addi	a4,a4,-86 # 80009050 <refcount>
    800000ae:	97ba                	add	a5,a5,a4
    800000b0:	4398                	lw	a4,0(a5)
    800000b2:	377d                	addiw	a4,a4,-1
    800000b4:	0007069b          	sext.w	a3,a4
    800000b8:	c398                	sw	a4,0(a5)
  if(refcount[(PA2INX((uint64)pa))]>1)
    800000ba:	4785                	li	a5,1
    800000bc:	04d7ef63          	bltu	a5,a3,8000011a <kfree+0xb6>
  {
  release(&kmem.lock);  
  return ;
  }
  release(&kmem.lock);
    800000c0:	00009917          	auipc	s2,0x9
    800000c4:	f7090913          	addi	s2,s2,-144 # 80009030 <kmem>
    800000c8:	854a                	mv	a0,s2
    800000ca:	00006097          	auipc	ra,0x6
    800000ce:	3b8080e7          	jalr	952(ra) # 80006482 <release>

  memset(pa, 1, PGSIZE);
    800000d2:	6605                	lui	a2,0x1
    800000d4:	4585                	li	a1,1
    800000d6:	8526                	mv	a0,s1
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	152080e7          	jalr	338(ra) # 8000022a <memset>

  acquire(&kmem.lock);
    800000e0:	854a                	mv	a0,s2
    800000e2:	00006097          	auipc	ra,0x6
    800000e6:	2ec080e7          	jalr	748(ra) # 800063ce <acquire>
  r->next = kmem.freelist;
    800000ea:	01893783          	ld	a5,24(s2)
    800000ee:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000f0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000f4:	854a                	mv	a0,s2
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	38c080e7          	jalr	908(ra) # 80006482 <release>
  // {
  //   refcount[(PA2INX((uint64)pa))]-=1;
  //   release(&kmem.lock);
  // }
  
}
    800000fe:	60e2                	ld	ra,24(sp)
    80000100:	6442                	ld	s0,16(sp)
    80000102:	64a2                	ld	s1,8(sp)
    80000104:	6902                	ld	s2,0(sp)
    80000106:	6105                	addi	sp,sp,32
    80000108:	8082                	ret
    panic("kfree");
    8000010a:	00008517          	auipc	a0,0x8
    8000010e:	f0650513          	addi	a0,a0,-250 # 80008010 <etext+0x10>
    80000112:	00006097          	auipc	ra,0x6
    80000116:	d06080e7          	jalr	-762(ra) # 80005e18 <panic>
  release(&kmem.lock);  
    8000011a:	00009517          	auipc	a0,0x9
    8000011e:	f1650513          	addi	a0,a0,-234 # 80009030 <kmem>
    80000122:	00006097          	auipc	ra,0x6
    80000126:	360080e7          	jalr	864(ra) # 80006482 <release>
  return ;
    8000012a:	bfd1                	j	800000fe <kfree+0x9a>

000000008000012c <freerange>:
{
    8000012c:	7179                	addi	sp,sp,-48
    8000012e:	f406                	sd	ra,40(sp)
    80000130:	f022                	sd	s0,32(sp)
    80000132:	ec26                	sd	s1,24(sp)
    80000134:	e84a                	sd	s2,16(sp)
    80000136:	e44e                	sd	s3,8(sp)
    80000138:	e052                	sd	s4,0(sp)
    8000013a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000013c:	6785                	lui	a5,0x1
    8000013e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000142:	94aa                	add	s1,s1,a0
    80000144:	757d                	lui	a0,0xfffff
    80000146:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000148:	94be                	add	s1,s1,a5
    8000014a:	0095ee63          	bltu	a1,s1,80000166 <freerange+0x3a>
    8000014e:	892e                	mv	s2,a1
    kfree(p);
    80000150:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000152:	6985                	lui	s3,0x1
    kfree(p);
    80000154:	01448533          	add	a0,s1,s4
    80000158:	00000097          	auipc	ra,0x0
    8000015c:	f0c080e7          	jalr	-244(ra) # 80000064 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000160:	94ce                	add	s1,s1,s3
    80000162:	fe9979e3          	bgeu	s2,s1,80000154 <freerange+0x28>
}
    80000166:	70a2                	ld	ra,40(sp)
    80000168:	7402                	ld	s0,32(sp)
    8000016a:	64e2                	ld	s1,24(sp)
    8000016c:	6942                	ld	s2,16(sp)
    8000016e:	69a2                	ld	s3,8(sp)
    80000170:	6a02                	ld	s4,0(sp)
    80000172:	6145                	addi	sp,sp,48
    80000174:	8082                	ret

0000000080000176 <kinit>:
{
    80000176:	1141                	addi	sp,sp,-16
    80000178:	e406                	sd	ra,8(sp)
    8000017a:	e022                	sd	s0,0(sp)
    8000017c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000017e:	00008597          	auipc	a1,0x8
    80000182:	e9a58593          	addi	a1,a1,-358 # 80008018 <etext+0x18>
    80000186:	00009517          	auipc	a0,0x9
    8000018a:	eaa50513          	addi	a0,a0,-342 # 80009030 <kmem>
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	1b0080e7          	jalr	432(ra) # 8000633e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000196:	45c5                	li	a1,17
    80000198:	05ee                	slli	a1,a1,0x1b
    8000019a:	00046517          	auipc	a0,0x46
    8000019e:	0a650513          	addi	a0,a0,166 # 80046240 <end>
    800001a2:	00000097          	auipc	ra,0x0
    800001a6:	f8a080e7          	jalr	-118(ra) # 8000012c <freerange>
}
    800001aa:	60a2                	ld	ra,8(sp)
    800001ac:	6402                	ld	s0,0(sp)
    800001ae:	0141                	addi	sp,sp,16
    800001b0:	8082                	ret

00000000800001b2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001b2:	1101                	addi	sp,sp,-32
    800001b4:	ec06                	sd	ra,24(sp)
    800001b6:	e822                	sd	s0,16(sp)
    800001b8:	e426                	sd	s1,8(sp)
    800001ba:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001bc:	00009497          	auipc	s1,0x9
    800001c0:	e7448493          	addi	s1,s1,-396 # 80009030 <kmem>
    800001c4:	8526                	mv	a0,s1
    800001c6:	00006097          	auipc	ra,0x6
    800001ca:	208080e7          	jalr	520(ra) # 800063ce <acquire>
 
  r = kmem.freelist;
    800001ce:	6c84                	ld	s1,24(s1)
  // refcount[(PA2INX(r))] = 0;
  if(r)
    800001d0:	c4a1                	beqz	s1,80000218 <kalloc+0x66>
  {
    kmem.freelist = r->next;
    800001d2:	609c                	ld	a5,0(s1)
    800001d4:	00009517          	auipc	a0,0x9
    800001d8:	e5c50513          	addi	a0,a0,-420 # 80009030 <kmem>
    800001dc:	ed1c                	sd	a5,24(a0)
    refcount[(PA2INX((uint64)r))]=1;
    800001de:	800007b7          	lui	a5,0x80000
    800001e2:	97a6                	add	a5,a5,s1
    800001e4:	83b1                	srli	a5,a5,0xc
    800001e6:	078a                	slli	a5,a5,0x2
    800001e8:	00009717          	auipc	a4,0x9
    800001ec:	e6870713          	addi	a4,a4,-408 # 80009050 <refcount>
    800001f0:	97ba                	add	a5,a5,a4
    800001f2:	4705                	li	a4,1
    800001f4:	c398                	sw	a4,0(a5)
  } 
  release(&kmem.lock);
    800001f6:	00006097          	auipc	ra,0x6
    800001fa:	28c080e7          	jalr	652(ra) # 80006482 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001fe:	6605                	lui	a2,0x1
    80000200:	4595                	li	a1,5
    80000202:	8526                	mv	a0,s1
    80000204:	00000097          	auipc	ra,0x0
    80000208:	026080e7          	jalr	38(ra) # 8000022a <memset>
  return (void*)r;
}
    8000020c:	8526                	mv	a0,s1
    8000020e:	60e2                	ld	ra,24(sp)
    80000210:	6442                	ld	s0,16(sp)
    80000212:	64a2                	ld	s1,8(sp)
    80000214:	6105                	addi	sp,sp,32
    80000216:	8082                	ret
  release(&kmem.lock);
    80000218:	00009517          	auipc	a0,0x9
    8000021c:	e1850513          	addi	a0,a0,-488 # 80009030 <kmem>
    80000220:	00006097          	auipc	ra,0x6
    80000224:	262080e7          	jalr	610(ra) # 80006482 <release>
  if(r)
    80000228:	b7d5                	j	8000020c <kalloc+0x5a>

000000008000022a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000022a:	1141                	addi	sp,sp,-16
    8000022c:	e422                	sd	s0,8(sp)
    8000022e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000230:	ce09                	beqz	a2,8000024a <memset+0x20>
    80000232:	87aa                	mv	a5,a0
    80000234:	fff6071b          	addiw	a4,a2,-1
    80000238:	1702                	slli	a4,a4,0x20
    8000023a:	9301                	srli	a4,a4,0x20
    8000023c:	0705                	addi	a4,a4,1
    8000023e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000240:	00b78023          	sb	a1,0(a5) # ffffffff80000000 <end+0xfffffffefffb9dc0>
  for(i = 0; i < n; i++){
    80000244:	0785                	addi	a5,a5,1
    80000246:	fee79de3          	bne	a5,a4,80000240 <memset+0x16>
  }
  return dst;
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000256:	ca05                	beqz	a2,80000286 <memcmp+0x36>
    80000258:	fff6069b          	addiw	a3,a2,-1
    8000025c:	1682                	slli	a3,a3,0x20
    8000025e:	9281                	srli	a3,a3,0x20
    80000260:	0685                	addi	a3,a3,1
    80000262:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000264:	00054783          	lbu	a5,0(a0)
    80000268:	0005c703          	lbu	a4,0(a1)
    8000026c:	00e79863          	bne	a5,a4,8000027c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000270:	0505                	addi	a0,a0,1
    80000272:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000274:	fed518e3          	bne	a0,a3,80000264 <memcmp+0x14>
  }

  return 0;
    80000278:	4501                	li	a0,0
    8000027a:	a019                	j	80000280 <memcmp+0x30>
      return *s1 - *s2;
    8000027c:	40e7853b          	subw	a0,a5,a4
}
    80000280:	6422                	ld	s0,8(sp)
    80000282:	0141                	addi	sp,sp,16
    80000284:	8082                	ret
  return 0;
    80000286:	4501                	li	a0,0
    80000288:	bfe5                	j	80000280 <memcmp+0x30>

000000008000028a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e422                	sd	s0,8(sp)
    8000028e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000290:	ca0d                	beqz	a2,800002c2 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000292:	00a5f963          	bgeu	a1,a0,800002a4 <memmove+0x1a>
    80000296:	02061693          	slli	a3,a2,0x20
    8000029a:	9281                	srli	a3,a3,0x20
    8000029c:	00d58733          	add	a4,a1,a3
    800002a0:	02e56463          	bltu	a0,a4,800002c8 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002a4:	fff6079b          	addiw	a5,a2,-1
    800002a8:	1782                	slli	a5,a5,0x20
    800002aa:	9381                	srli	a5,a5,0x20
    800002ac:	0785                	addi	a5,a5,1
    800002ae:	97ae                	add	a5,a5,a1
    800002b0:	872a                	mv	a4,a0
      *d++ = *s++;
    800002b2:	0585                	addi	a1,a1,1
    800002b4:	0705                	addi	a4,a4,1
    800002b6:	fff5c683          	lbu	a3,-1(a1)
    800002ba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002be:	fef59ae3          	bne	a1,a5,800002b2 <memmove+0x28>

  return dst;
}
    800002c2:	6422                	ld	s0,8(sp)
    800002c4:	0141                	addi	sp,sp,16
    800002c6:	8082                	ret
    d += n;
    800002c8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002ca:	fff6079b          	addiw	a5,a2,-1
    800002ce:	1782                	slli	a5,a5,0x20
    800002d0:	9381                	srli	a5,a5,0x20
    800002d2:	fff7c793          	not	a5,a5
    800002d6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002d8:	177d                	addi	a4,a4,-1
    800002da:	16fd                	addi	a3,a3,-1
    800002dc:	00074603          	lbu	a2,0(a4)
    800002e0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002e4:	fef71ae3          	bne	a4,a5,800002d8 <memmove+0x4e>
    800002e8:	bfe9                	j	800002c2 <memmove+0x38>

00000000800002ea <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800002ea:	1141                	addi	sp,sp,-16
    800002ec:	e406                	sd	ra,8(sp)
    800002ee:	e022                	sd	s0,0(sp)
    800002f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002f2:	00000097          	auipc	ra,0x0
    800002f6:	f98080e7          	jalr	-104(ra) # 8000028a <memmove>
}
    800002fa:	60a2                	ld	ra,8(sp)
    800002fc:	6402                	ld	s0,0(sp)
    800002fe:	0141                	addi	sp,sp,16
    80000300:	8082                	ret

0000000080000302 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000302:	1141                	addi	sp,sp,-16
    80000304:	e422                	sd	s0,8(sp)
    80000306:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000308:	ce11                	beqz	a2,80000324 <strncmp+0x22>
    8000030a:	00054783          	lbu	a5,0(a0)
    8000030e:	cf89                	beqz	a5,80000328 <strncmp+0x26>
    80000310:	0005c703          	lbu	a4,0(a1)
    80000314:	00f71a63          	bne	a4,a5,80000328 <strncmp+0x26>
    n--, p++, q++;
    80000318:	367d                	addiw	a2,a2,-1
    8000031a:	0505                	addi	a0,a0,1
    8000031c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000031e:	f675                	bnez	a2,8000030a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000320:	4501                	li	a0,0
    80000322:	a809                	j	80000334 <strncmp+0x32>
    80000324:	4501                	li	a0,0
    80000326:	a039                	j	80000334 <strncmp+0x32>
  if(n == 0)
    80000328:	ca09                	beqz	a2,8000033a <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000032a:	00054503          	lbu	a0,0(a0)
    8000032e:	0005c783          	lbu	a5,0(a1)
    80000332:	9d1d                	subw	a0,a0,a5
}
    80000334:	6422                	ld	s0,8(sp)
    80000336:	0141                	addi	sp,sp,16
    80000338:	8082                	ret
    return 0;
    8000033a:	4501                	li	a0,0
    8000033c:	bfe5                	j	80000334 <strncmp+0x32>

000000008000033e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000033e:	1141                	addi	sp,sp,-16
    80000340:	e422                	sd	s0,8(sp)
    80000342:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000344:	872a                	mv	a4,a0
    80000346:	8832                	mv	a6,a2
    80000348:	367d                	addiw	a2,a2,-1
    8000034a:	01005963          	blez	a6,8000035c <strncpy+0x1e>
    8000034e:	0705                	addi	a4,a4,1
    80000350:	0005c783          	lbu	a5,0(a1)
    80000354:	fef70fa3          	sb	a5,-1(a4)
    80000358:	0585                	addi	a1,a1,1
    8000035a:	f7f5                	bnez	a5,80000346 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000035c:	00c05d63          	blez	a2,80000376 <strncpy+0x38>
    80000360:	86ba                	mv	a3,a4
    *s++ = 0;
    80000362:	0685                	addi	a3,a3,1
    80000364:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000368:	fff6c793          	not	a5,a3
    8000036c:	9fb9                	addw	a5,a5,a4
    8000036e:	010787bb          	addw	a5,a5,a6
    80000372:	fef048e3          	bgtz	a5,80000362 <strncpy+0x24>
  return os;
}
    80000376:	6422                	ld	s0,8(sp)
    80000378:	0141                	addi	sp,sp,16
    8000037a:	8082                	ret

000000008000037c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000037c:	1141                	addi	sp,sp,-16
    8000037e:	e422                	sd	s0,8(sp)
    80000380:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000382:	02c05363          	blez	a2,800003a8 <safestrcpy+0x2c>
    80000386:	fff6069b          	addiw	a3,a2,-1
    8000038a:	1682                	slli	a3,a3,0x20
    8000038c:	9281                	srli	a3,a3,0x20
    8000038e:	96ae                	add	a3,a3,a1
    80000390:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000392:	00d58963          	beq	a1,a3,800003a4 <safestrcpy+0x28>
    80000396:	0585                	addi	a1,a1,1
    80000398:	0785                	addi	a5,a5,1
    8000039a:	fff5c703          	lbu	a4,-1(a1)
    8000039e:	fee78fa3          	sb	a4,-1(a5)
    800003a2:	fb65                	bnez	a4,80000392 <safestrcpy+0x16>
    ;
  *s = 0;
    800003a4:	00078023          	sb	zero,0(a5)
  return os;
}
    800003a8:	6422                	ld	s0,8(sp)
    800003aa:	0141                	addi	sp,sp,16
    800003ac:	8082                	ret

00000000800003ae <strlen>:

int
strlen(const char *s)
{
    800003ae:	1141                	addi	sp,sp,-16
    800003b0:	e422                	sd	s0,8(sp)
    800003b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003b4:	00054783          	lbu	a5,0(a0)
    800003b8:	cf91                	beqz	a5,800003d4 <strlen+0x26>
    800003ba:	0505                	addi	a0,a0,1
    800003bc:	87aa                	mv	a5,a0
    800003be:	4685                	li	a3,1
    800003c0:	9e89                	subw	a3,a3,a0
    800003c2:	00f6853b          	addw	a0,a3,a5
    800003c6:	0785                	addi	a5,a5,1
    800003c8:	fff7c703          	lbu	a4,-1(a5)
    800003cc:	fb7d                	bnez	a4,800003c2 <strlen+0x14>
    ;
  return n;
}
    800003ce:	6422                	ld	s0,8(sp)
    800003d0:	0141                	addi	sp,sp,16
    800003d2:	8082                	ret
  for(n = 0; s[n]; n++)
    800003d4:	4501                	li	a0,0
    800003d6:	bfe5                	j	800003ce <strlen+0x20>

00000000800003d8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003d8:	1141                	addi	sp,sp,-16
    800003da:	e406                	sd	ra,8(sp)
    800003dc:	e022                	sd	s0,0(sp)
    800003de:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800003e0:	00001097          	auipc	ra,0x1
    800003e4:	c06080e7          	jalr	-1018(ra) # 80000fe6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800003e8:	00009717          	auipc	a4,0x9
    800003ec:	c1870713          	addi	a4,a4,-1000 # 80009000 <started>
  if(cpuid() == 0){
    800003f0:	c139                	beqz	a0,80000436 <main+0x5e>
    while(started == 0)
    800003f2:	431c                	lw	a5,0(a4)
    800003f4:	2781                	sext.w	a5,a5
    800003f6:	dff5                	beqz	a5,800003f2 <main+0x1a>
      ;
    __sync_synchronize();
    800003f8:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800003fc:	00001097          	auipc	ra,0x1
    80000400:	bea080e7          	jalr	-1046(ra) # 80000fe6 <cpuid>
    80000404:	85aa                	mv	a1,a0
    80000406:	00008517          	auipc	a0,0x8
    8000040a:	c3250513          	addi	a0,a0,-974 # 80008038 <etext+0x38>
    8000040e:	00006097          	auipc	ra,0x6
    80000412:	a54080e7          	jalr	-1452(ra) # 80005e62 <printf>
    kvminithart();    // turn on paging
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	0d8080e7          	jalr	216(ra) # 800004ee <kvminithart>
    trapinithart();   // install kernel trap vector
    8000041e:	00002097          	auipc	ra,0x2
    80000422:	840080e7          	jalr	-1984(ra) # 80001c5e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000426:	00005097          	auipc	ra,0x5
    8000042a:	eca080e7          	jalr	-310(ra) # 800052f0 <plicinithart>
  }

  scheduler();        
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	0ee080e7          	jalr	238(ra) # 8000151c <scheduler>
    consoleinit();
    80000436:	00006097          	auipc	ra,0x6
    8000043a:	8f4080e7          	jalr	-1804(ra) # 80005d2a <consoleinit>
    printfinit();
    8000043e:	00006097          	auipc	ra,0x6
    80000442:	c0a080e7          	jalr	-1014(ra) # 80006048 <printfinit>
    printf("\n");
    80000446:	00008517          	auipc	a0,0x8
    8000044a:	c0250513          	addi	a0,a0,-1022 # 80008048 <etext+0x48>
    8000044e:	00006097          	auipc	ra,0x6
    80000452:	a14080e7          	jalr	-1516(ra) # 80005e62 <printf>
    printf("xv6 kernel is booting\n");
    80000456:	00008517          	auipc	a0,0x8
    8000045a:	bca50513          	addi	a0,a0,-1078 # 80008020 <etext+0x20>
    8000045e:	00006097          	auipc	ra,0x6
    80000462:	a04080e7          	jalr	-1532(ra) # 80005e62 <printf>
    printf("\n");
    80000466:	00008517          	auipc	a0,0x8
    8000046a:	be250513          	addi	a0,a0,-1054 # 80008048 <etext+0x48>
    8000046e:	00006097          	auipc	ra,0x6
    80000472:	9f4080e7          	jalr	-1548(ra) # 80005e62 <printf>
    kinit();         // physical page allocator
    80000476:	00000097          	auipc	ra,0x0
    8000047a:	d00080e7          	jalr	-768(ra) # 80000176 <kinit>
    kvminit();       // create kernel page table
    8000047e:	00000097          	auipc	ra,0x0
    80000482:	322080e7          	jalr	802(ra) # 800007a0 <kvminit>
    kvminithart();   // turn on paging
    80000486:	00000097          	auipc	ra,0x0
    8000048a:	068080e7          	jalr	104(ra) # 800004ee <kvminithart>
    procinit();      // process table
    8000048e:	00001097          	auipc	ra,0x1
    80000492:	aa8080e7          	jalr	-1368(ra) # 80000f36 <procinit>
    trapinit();      // trap vectors
    80000496:	00001097          	auipc	ra,0x1
    8000049a:	7a0080e7          	jalr	1952(ra) # 80001c36 <trapinit>
    trapinithart();  // install kernel trap vector
    8000049e:	00001097          	auipc	ra,0x1
    800004a2:	7c0080e7          	jalr	1984(ra) # 80001c5e <trapinithart>
    plicinit();      // set up interrupt controller
    800004a6:	00005097          	auipc	ra,0x5
    800004aa:	e34080e7          	jalr	-460(ra) # 800052da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004ae:	00005097          	auipc	ra,0x5
    800004b2:	e42080e7          	jalr	-446(ra) # 800052f0 <plicinithart>
    binit();         // buffer cache
    800004b6:	00002097          	auipc	ra,0x2
    800004ba:	01a080e7          	jalr	26(ra) # 800024d0 <binit>
    iinit();         // inode table
    800004be:	00002097          	auipc	ra,0x2
    800004c2:	6aa080e7          	jalr	1706(ra) # 80002b68 <iinit>
    fileinit();      // file table
    800004c6:	00003097          	auipc	ra,0x3
    800004ca:	654080e7          	jalr	1620(ra) # 80003b1a <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004ce:	00005097          	auipc	ra,0x5
    800004d2:	f44080e7          	jalr	-188(ra) # 80005412 <virtio_disk_init>
    userinit();      // first user process
    800004d6:	00001097          	auipc	ra,0x1
    800004da:	e14080e7          	jalr	-492(ra) # 800012ea <userinit>
    __sync_synchronize();
    800004de:	0ff0000f          	fence
    started = 1;
    800004e2:	4785                	li	a5,1
    800004e4:	00009717          	auipc	a4,0x9
    800004e8:	b0f72e23          	sw	a5,-1252(a4) # 80009000 <started>
    800004ec:	b789                	j	8000042e <main+0x56>

00000000800004ee <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800004ee:	1141                	addi	sp,sp,-16
    800004f0:	e422                	sd	s0,8(sp)
    800004f2:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800004f4:	00009797          	auipc	a5,0x9
    800004f8:	b147b783          	ld	a5,-1260(a5) # 80009008 <kernel_pagetable>
    800004fc:	83b1                	srli	a5,a5,0xc
    800004fe:	577d                	li	a4,-1
    80000500:	177e                	slli	a4,a4,0x3f
    80000502:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000504:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000508:	12000073          	sfence.vma
  sfence_vma();
}
    8000050c:	6422                	ld	s0,8(sp)
    8000050e:	0141                	addi	sp,sp,16
    80000510:	8082                	ret

0000000080000512 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000512:	7139                	addi	sp,sp,-64
    80000514:	fc06                	sd	ra,56(sp)
    80000516:	f822                	sd	s0,48(sp)
    80000518:	f426                	sd	s1,40(sp)
    8000051a:	f04a                	sd	s2,32(sp)
    8000051c:	ec4e                	sd	s3,24(sp)
    8000051e:	e852                	sd	s4,16(sp)
    80000520:	e456                	sd	s5,8(sp)
    80000522:	e05a                	sd	s6,0(sp)
    80000524:	0080                	addi	s0,sp,64
    80000526:	84aa                	mv	s1,a0
    80000528:	89ae                	mv	s3,a1
    8000052a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000052c:	57fd                	li	a5,-1
    8000052e:	83e9                	srli	a5,a5,0x1a
    80000530:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000532:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000534:	04b7f263          	bgeu	a5,a1,80000578 <walk+0x66>
    panic("walk");
    80000538:	00008517          	auipc	a0,0x8
    8000053c:	b1850513          	addi	a0,a0,-1256 # 80008050 <etext+0x50>
    80000540:	00006097          	auipc	ra,0x6
    80000544:	8d8080e7          	jalr	-1832(ra) # 80005e18 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000548:	060a8663          	beqz	s5,800005b4 <walk+0xa2>
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	c66080e7          	jalr	-922(ra) # 800001b2 <kalloc>
    80000554:	84aa                	mv	s1,a0
    80000556:	c529                	beqz	a0,800005a0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000558:	6605                	lui	a2,0x1
    8000055a:	4581                	li	a1,0
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	cce080e7          	jalr	-818(ra) # 8000022a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000564:	00c4d793          	srli	a5,s1,0xc
    80000568:	07aa                	slli	a5,a5,0xa
    8000056a:	0017e793          	ori	a5,a5,1
    8000056e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000572:	3a5d                	addiw	s4,s4,-9
    80000574:	036a0063          	beq	s4,s6,80000594 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000578:	0149d933          	srl	s2,s3,s4
    8000057c:	1ff97913          	andi	s2,s2,511
    80000580:	090e                	slli	s2,s2,0x3
    80000582:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000584:	00093483          	ld	s1,0(s2)
    80000588:	0014f793          	andi	a5,s1,1
    8000058c:	dfd5                	beqz	a5,80000548 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000058e:	80a9                	srli	s1,s1,0xa
    80000590:	04b2                	slli	s1,s1,0xc
    80000592:	b7c5                	j	80000572 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000594:	00c9d513          	srli	a0,s3,0xc
    80000598:	1ff57513          	andi	a0,a0,511
    8000059c:	050e                	slli	a0,a0,0x3
    8000059e:	9526                	add	a0,a0,s1
}
    800005a0:	70e2                	ld	ra,56(sp)
    800005a2:	7442                	ld	s0,48(sp)
    800005a4:	74a2                	ld	s1,40(sp)
    800005a6:	7902                	ld	s2,32(sp)
    800005a8:	69e2                	ld	s3,24(sp)
    800005aa:	6a42                	ld	s4,16(sp)
    800005ac:	6aa2                	ld	s5,8(sp)
    800005ae:	6b02                	ld	s6,0(sp)
    800005b0:	6121                	addi	sp,sp,64
    800005b2:	8082                	ret
        return 0;
    800005b4:	4501                	li	a0,0
    800005b6:	b7ed                	j	800005a0 <walk+0x8e>

00000000800005b8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005b8:	57fd                	li	a5,-1
    800005ba:	83e9                	srli	a5,a5,0x1a
    800005bc:	00b7f463          	bgeu	a5,a1,800005c4 <walkaddr+0xc>
    return 0;
    800005c0:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005c2:	8082                	ret
{
    800005c4:	1141                	addi	sp,sp,-16
    800005c6:	e406                	sd	ra,8(sp)
    800005c8:	e022                	sd	s0,0(sp)
    800005ca:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005cc:	4601                	li	a2,0
    800005ce:	00000097          	auipc	ra,0x0
    800005d2:	f44080e7          	jalr	-188(ra) # 80000512 <walk>
  if(pte == 0)
    800005d6:	c105                	beqz	a0,800005f6 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800005d8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800005da:	0117f693          	andi	a3,a5,17
    800005de:	4745                	li	a4,17
    return 0;
    800005e0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800005e2:	00e68663          	beq	a3,a4,800005ee <walkaddr+0x36>
}
    800005e6:	60a2                	ld	ra,8(sp)
    800005e8:	6402                	ld	s0,0(sp)
    800005ea:	0141                	addi	sp,sp,16
    800005ec:	8082                	ret
  pa = PTE2PA(*pte);
    800005ee:	00a7d513          	srli	a0,a5,0xa
    800005f2:	0532                	slli	a0,a0,0xc
  return pa;
    800005f4:	bfcd                	j	800005e6 <walkaddr+0x2e>
    return 0;
    800005f6:	4501                	li	a0,0
    800005f8:	b7fd                	j	800005e6 <walkaddr+0x2e>

00000000800005fa <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005fa:	715d                	addi	sp,sp,-80
    800005fc:	e486                	sd	ra,72(sp)
    800005fe:	e0a2                	sd	s0,64(sp)
    80000600:	fc26                	sd	s1,56(sp)
    80000602:	f84a                	sd	s2,48(sp)
    80000604:	f44e                	sd	s3,40(sp)
    80000606:	f052                	sd	s4,32(sp)
    80000608:	ec56                	sd	s5,24(sp)
    8000060a:	e85a                	sd	s6,16(sp)
    8000060c:	e45e                	sd	s7,8(sp)
    8000060e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000610:	c205                	beqz	a2,80000630 <mappages+0x36>
    80000612:	8aaa                	mv	s5,a0
    80000614:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000616:	77fd                	lui	a5,0xfffff
    80000618:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000061c:	15fd                	addi	a1,a1,-1
    8000061e:	00c589b3          	add	s3,a1,a2
    80000622:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000626:	8952                	mv	s2,s4
    80000628:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000062c:	6b85                	lui	s7,0x1
    8000062e:	a015                	j	80000652 <mappages+0x58>
    panic("mappages: size");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a2850513          	addi	a0,a0,-1496 # 80008058 <etext+0x58>
    80000638:	00005097          	auipc	ra,0x5
    8000063c:	7e0080e7          	jalr	2016(ra) # 80005e18 <panic>
      panic("mappages: remap");
    80000640:	00008517          	auipc	a0,0x8
    80000644:	a2850513          	addi	a0,a0,-1496 # 80008068 <etext+0x68>
    80000648:	00005097          	auipc	ra,0x5
    8000064c:	7d0080e7          	jalr	2000(ra) # 80005e18 <panic>
    a += PGSIZE;
    80000650:	995e                	add	s2,s2,s7
  for(;;){
    80000652:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000656:	4605                	li	a2,1
    80000658:	85ca                	mv	a1,s2
    8000065a:	8556                	mv	a0,s5
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	eb6080e7          	jalr	-330(ra) # 80000512 <walk>
    80000664:	cd19                	beqz	a0,80000682 <mappages+0x88>
    if(*pte & PTE_V)
    80000666:	611c                	ld	a5,0(a0)
    80000668:	8b85                	andi	a5,a5,1
    8000066a:	fbf9                	bnez	a5,80000640 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000066c:	80b1                	srli	s1,s1,0xc
    8000066e:	04aa                	slli	s1,s1,0xa
    80000670:	0164e4b3          	or	s1,s1,s6
    80000674:	0014e493          	ori	s1,s1,1
    80000678:	e104                	sd	s1,0(a0)
    if(a == last)
    8000067a:	fd391be3          	bne	s2,s3,80000650 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    8000067e:	4501                	li	a0,0
    80000680:	a011                	j	80000684 <mappages+0x8a>
      return -1;
    80000682:	557d                	li	a0,-1
}
    80000684:	60a6                	ld	ra,72(sp)
    80000686:	6406                	ld	s0,64(sp)
    80000688:	74e2                	ld	s1,56(sp)
    8000068a:	7942                	ld	s2,48(sp)
    8000068c:	79a2                	ld	s3,40(sp)
    8000068e:	7a02                	ld	s4,32(sp)
    80000690:	6ae2                	ld	s5,24(sp)
    80000692:	6b42                	ld	s6,16(sp)
    80000694:	6ba2                	ld	s7,8(sp)
    80000696:	6161                	addi	sp,sp,80
    80000698:	8082                	ret

000000008000069a <kvmmap>:
{
    8000069a:	1141                	addi	sp,sp,-16
    8000069c:	e406                	sd	ra,8(sp)
    8000069e:	e022                	sd	s0,0(sp)
    800006a0:	0800                	addi	s0,sp,16
    800006a2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006a4:	86b2                	mv	a3,a2
    800006a6:	863e                	mv	a2,a5
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f52080e7          	jalr	-174(ra) # 800005fa <mappages>
    800006b0:	e509                	bnez	a0,800006ba <kvmmap+0x20>
}
    800006b2:	60a2                	ld	ra,8(sp)
    800006b4:	6402                	ld	s0,0(sp)
    800006b6:	0141                	addi	sp,sp,16
    800006b8:	8082                	ret
    panic("kvmmap");
    800006ba:	00008517          	auipc	a0,0x8
    800006be:	9be50513          	addi	a0,a0,-1602 # 80008078 <etext+0x78>
    800006c2:	00005097          	auipc	ra,0x5
    800006c6:	756080e7          	jalr	1878(ra) # 80005e18 <panic>

00000000800006ca <kvmmake>:
{
    800006ca:	1101                	addi	sp,sp,-32
    800006cc:	ec06                	sd	ra,24(sp)
    800006ce:	e822                	sd	s0,16(sp)
    800006d0:	e426                	sd	s1,8(sp)
    800006d2:	e04a                	sd	s2,0(sp)
    800006d4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	adc080e7          	jalr	-1316(ra) # 800001b2 <kalloc>
    800006de:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006e0:	6605                	lui	a2,0x1
    800006e2:	4581                	li	a1,0
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	b46080e7          	jalr	-1210(ra) # 8000022a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006ec:	4719                	li	a4,6
    800006ee:	6685                	lui	a3,0x1
    800006f0:	10000637          	lui	a2,0x10000
    800006f4:	100005b7          	lui	a1,0x10000
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	fa0080e7          	jalr	-96(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000702:	4719                	li	a4,6
    80000704:	6685                	lui	a3,0x1
    80000706:	10001637          	lui	a2,0x10001
    8000070a:	100015b7          	lui	a1,0x10001
    8000070e:	8526                	mv	a0,s1
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f8a080e7          	jalr	-118(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000718:	4719                	li	a4,6
    8000071a:	004006b7          	lui	a3,0x400
    8000071e:	0c000637          	lui	a2,0xc000
    80000722:	0c0005b7          	lui	a1,0xc000
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	f72080e7          	jalr	-142(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000730:	00008917          	auipc	s2,0x8
    80000734:	8d090913          	addi	s2,s2,-1840 # 80008000 <etext>
    80000738:	4729                	li	a4,10
    8000073a:	80008697          	auipc	a3,0x80008
    8000073e:	8c668693          	addi	a3,a3,-1850 # 8000 <_entry-0x7fff8000>
    80000742:	4605                	li	a2,1
    80000744:	067e                	slli	a2,a2,0x1f
    80000746:	85b2                	mv	a1,a2
    80000748:	8526                	mv	a0,s1
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	f50080e7          	jalr	-176(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000752:	4719                	li	a4,6
    80000754:	46c5                	li	a3,17
    80000756:	06ee                	slli	a3,a3,0x1b
    80000758:	412686b3          	sub	a3,a3,s2
    8000075c:	864a                	mv	a2,s2
    8000075e:	85ca                	mv	a1,s2
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	f38080e7          	jalr	-200(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000076a:	4729                	li	a4,10
    8000076c:	6685                	lui	a3,0x1
    8000076e:	00007617          	auipc	a2,0x7
    80000772:	89260613          	addi	a2,a2,-1902 # 80007000 <_trampoline>
    80000776:	040005b7          	lui	a1,0x4000
    8000077a:	15fd                	addi	a1,a1,-1
    8000077c:	05b2                	slli	a1,a1,0xc
    8000077e:	8526                	mv	a0,s1
    80000780:	00000097          	auipc	ra,0x0
    80000784:	f1a080e7          	jalr	-230(ra) # 8000069a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000788:	8526                	mv	a0,s1
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	716080e7          	jalr	1814(ra) # 80000ea0 <proc_mapstacks>
}
    80000792:	8526                	mv	a0,s1
    80000794:	60e2                	ld	ra,24(sp)
    80000796:	6442                	ld	s0,16(sp)
    80000798:	64a2                	ld	s1,8(sp)
    8000079a:	6902                	ld	s2,0(sp)
    8000079c:	6105                	addi	sp,sp,32
    8000079e:	8082                	ret

00000000800007a0 <kvminit>:
{
    800007a0:	1141                	addi	sp,sp,-16
    800007a2:	e406                	sd	ra,8(sp)
    800007a4:	e022                	sd	s0,0(sp)
    800007a6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	f22080e7          	jalr	-222(ra) # 800006ca <kvmmake>
    800007b0:	00009797          	auipc	a5,0x9
    800007b4:	84a7bc23          	sd	a0,-1960(a5) # 80009008 <kernel_pagetable>
}
    800007b8:	60a2                	ld	ra,8(sp)
    800007ba:	6402                	ld	s0,0(sp)
    800007bc:	0141                	addi	sp,sp,16
    800007be:	8082                	ret

00000000800007c0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007c0:	715d                	addi	sp,sp,-80
    800007c2:	e486                	sd	ra,72(sp)
    800007c4:	e0a2                	sd	s0,64(sp)
    800007c6:	fc26                	sd	s1,56(sp)
    800007c8:	f84a                	sd	s2,48(sp)
    800007ca:	f44e                	sd	s3,40(sp)
    800007cc:	f052                	sd	s4,32(sp)
    800007ce:	ec56                	sd	s5,24(sp)
    800007d0:	e85a                	sd	s6,16(sp)
    800007d2:	e45e                	sd	s7,8(sp)
    800007d4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800007d6:	03459793          	slli	a5,a1,0x34
    800007da:	e795                	bnez	a5,80000806 <uvmunmap+0x46>
    800007dc:	8a2a                	mv	s4,a0
    800007de:	892e                	mv	s2,a1
    800007e0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007e2:	0632                	slli	a2,a2,0xc
    800007e4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800007e8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ea:	6b05                	lui	s6,0x1
    800007ec:	0735e863          	bltu	a1,s3,8000085c <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800007f0:	60a6                	ld	ra,72(sp)
    800007f2:	6406                	ld	s0,64(sp)
    800007f4:	74e2                	ld	s1,56(sp)
    800007f6:	7942                	ld	s2,48(sp)
    800007f8:	79a2                	ld	s3,40(sp)
    800007fa:	7a02                	ld	s4,32(sp)
    800007fc:	6ae2                	ld	s5,24(sp)
    800007fe:	6b42                	ld	s6,16(sp)
    80000800:	6ba2                	ld	s7,8(sp)
    80000802:	6161                	addi	sp,sp,80
    80000804:	8082                	ret
    panic("uvmunmap: not aligned");
    80000806:	00008517          	auipc	a0,0x8
    8000080a:	87a50513          	addi	a0,a0,-1926 # 80008080 <etext+0x80>
    8000080e:	00005097          	auipc	ra,0x5
    80000812:	60a080e7          	jalr	1546(ra) # 80005e18 <panic>
      panic("uvmunmap: walk");
    80000816:	00008517          	auipc	a0,0x8
    8000081a:	88250513          	addi	a0,a0,-1918 # 80008098 <etext+0x98>
    8000081e:	00005097          	auipc	ra,0x5
    80000822:	5fa080e7          	jalr	1530(ra) # 80005e18 <panic>
      panic("uvmunmap: not mapped");
    80000826:	00008517          	auipc	a0,0x8
    8000082a:	88250513          	addi	a0,a0,-1918 # 800080a8 <etext+0xa8>
    8000082e:	00005097          	auipc	ra,0x5
    80000832:	5ea080e7          	jalr	1514(ra) # 80005e18 <panic>
      panic("uvmunmap: not a leaf");
    80000836:	00008517          	auipc	a0,0x8
    8000083a:	88a50513          	addi	a0,a0,-1910 # 800080c0 <etext+0xc0>
    8000083e:	00005097          	auipc	ra,0x5
    80000842:	5da080e7          	jalr	1498(ra) # 80005e18 <panic>
      uint64 pa = PTE2PA(*pte);
    80000846:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000848:	0532                	slli	a0,a0,0xc
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	81a080e7          	jalr	-2022(ra) # 80000064 <kfree>
    *pte = 0;
    80000852:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000856:	995a                	add	s2,s2,s6
    80000858:	f9397ce3          	bgeu	s2,s3,800007f0 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000085c:	4601                	li	a2,0
    8000085e:	85ca                	mv	a1,s2
    80000860:	8552                	mv	a0,s4
    80000862:	00000097          	auipc	ra,0x0
    80000866:	cb0080e7          	jalr	-848(ra) # 80000512 <walk>
    8000086a:	84aa                	mv	s1,a0
    8000086c:	d54d                	beqz	a0,80000816 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000086e:	6108                	ld	a0,0(a0)
    80000870:	00157793          	andi	a5,a0,1
    80000874:	dbcd                	beqz	a5,80000826 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000876:	3ff57793          	andi	a5,a0,1023
    8000087a:	fb778ee3          	beq	a5,s7,80000836 <uvmunmap+0x76>
    if(do_free){
    8000087e:	fc0a8ae3          	beqz	s5,80000852 <uvmunmap+0x92>
    80000882:	b7d1                	j	80000846 <uvmunmap+0x86>

0000000080000884 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000884:	1101                	addi	sp,sp,-32
    80000886:	ec06                	sd	ra,24(sp)
    80000888:	e822                	sd	s0,16(sp)
    8000088a:	e426                	sd	s1,8(sp)
    8000088c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	924080e7          	jalr	-1756(ra) # 800001b2 <kalloc>
    80000896:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000898:	c519                	beqz	a0,800008a6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000089a:	6605                	lui	a2,0x1
    8000089c:	4581                	li	a1,0
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	98c080e7          	jalr	-1652(ra) # 8000022a <memset>
  return pagetable;
}
    800008a6:	8526                	mv	a0,s1
    800008a8:	60e2                	ld	ra,24(sp)
    800008aa:	6442                	ld	s0,16(sp)
    800008ac:	64a2                	ld	s1,8(sp)
    800008ae:	6105                	addi	sp,sp,32
    800008b0:	8082                	ret

00000000800008b2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008b2:	7179                	addi	sp,sp,-48
    800008b4:	f406                	sd	ra,40(sp)
    800008b6:	f022                	sd	s0,32(sp)
    800008b8:	ec26                	sd	s1,24(sp)
    800008ba:	e84a                	sd	s2,16(sp)
    800008bc:	e44e                	sd	s3,8(sp)
    800008be:	e052                	sd	s4,0(sp)
    800008c0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800008c2:	6785                	lui	a5,0x1
    800008c4:	04f67863          	bgeu	a2,a5,80000914 <uvminit+0x62>
    800008c8:	8a2a                	mv	s4,a0
    800008ca:	89ae                	mv	s3,a1
    800008cc:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	8e4080e7          	jalr	-1820(ra) # 800001b2 <kalloc>
    800008d6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008d8:	6605                	lui	a2,0x1
    800008da:	4581                	li	a1,0
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	94e080e7          	jalr	-1714(ra) # 8000022a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008e4:	4779                	li	a4,30
    800008e6:	86ca                	mv	a3,s2
    800008e8:	6605                	lui	a2,0x1
    800008ea:	4581                	li	a1,0
    800008ec:	8552                	mv	a0,s4
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	d0c080e7          	jalr	-756(ra) # 800005fa <mappages>
  memmove(mem, src, sz);
    800008f6:	8626                	mv	a2,s1
    800008f8:	85ce                	mv	a1,s3
    800008fa:	854a                	mv	a0,s2
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	98e080e7          	jalr	-1650(ra) # 8000028a <memmove>
}
    80000904:	70a2                	ld	ra,40(sp)
    80000906:	7402                	ld	s0,32(sp)
    80000908:	64e2                	ld	s1,24(sp)
    8000090a:	6942                	ld	s2,16(sp)
    8000090c:	69a2                	ld	s3,8(sp)
    8000090e:	6a02                	ld	s4,0(sp)
    80000910:	6145                	addi	sp,sp,48
    80000912:	8082                	ret
    panic("inituvm: more than a page");
    80000914:	00007517          	auipc	a0,0x7
    80000918:	7c450513          	addi	a0,a0,1988 # 800080d8 <etext+0xd8>
    8000091c:	00005097          	auipc	ra,0x5
    80000920:	4fc080e7          	jalr	1276(ra) # 80005e18 <panic>

0000000080000924 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000924:	1101                	addi	sp,sp,-32
    80000926:	ec06                	sd	ra,24(sp)
    80000928:	e822                	sd	s0,16(sp)
    8000092a:	e426                	sd	s1,8(sp)
    8000092c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000092e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000930:	00b67d63          	bgeu	a2,a1,8000094a <uvmdealloc+0x26>
    80000934:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000936:	6785                	lui	a5,0x1
    80000938:	17fd                	addi	a5,a5,-1
    8000093a:	00f60733          	add	a4,a2,a5
    8000093e:	767d                	lui	a2,0xfffff
    80000940:	8f71                	and	a4,a4,a2
    80000942:	97ae                	add	a5,a5,a1
    80000944:	8ff1                	and	a5,a5,a2
    80000946:	00f76863          	bltu	a4,a5,80000956 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000094a:	8526                	mv	a0,s1
    8000094c:	60e2                	ld	ra,24(sp)
    8000094e:	6442                	ld	s0,16(sp)
    80000950:	64a2                	ld	s1,8(sp)
    80000952:	6105                	addi	sp,sp,32
    80000954:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000956:	8f99                	sub	a5,a5,a4
    80000958:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000095a:	4685                	li	a3,1
    8000095c:	0007861b          	sext.w	a2,a5
    80000960:	85ba                	mv	a1,a4
    80000962:	00000097          	auipc	ra,0x0
    80000966:	e5e080e7          	jalr	-418(ra) # 800007c0 <uvmunmap>
    8000096a:	b7c5                	j	8000094a <uvmdealloc+0x26>

000000008000096c <uvmalloc>:
  if(newsz < oldsz)
    8000096c:	0ab66163          	bltu	a2,a1,80000a0e <uvmalloc+0xa2>
{
    80000970:	7139                	addi	sp,sp,-64
    80000972:	fc06                	sd	ra,56(sp)
    80000974:	f822                	sd	s0,48(sp)
    80000976:	f426                	sd	s1,40(sp)
    80000978:	f04a                	sd	s2,32(sp)
    8000097a:	ec4e                	sd	s3,24(sp)
    8000097c:	e852                	sd	s4,16(sp)
    8000097e:	e456                	sd	s5,8(sp)
    80000980:	0080                	addi	s0,sp,64
    80000982:	8aaa                	mv	s5,a0
    80000984:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000986:	6985                	lui	s3,0x1
    80000988:	19fd                	addi	s3,s3,-1
    8000098a:	95ce                	add	a1,a1,s3
    8000098c:	79fd                	lui	s3,0xfffff
    8000098e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000992:	08c9f063          	bgeu	s3,a2,80000a12 <uvmalloc+0xa6>
    80000996:	894e                	mv	s2,s3
    mem = kalloc();
    80000998:	00000097          	auipc	ra,0x0
    8000099c:	81a080e7          	jalr	-2022(ra) # 800001b2 <kalloc>
    800009a0:	84aa                	mv	s1,a0
    if(mem == 0){
    800009a2:	c51d                	beqz	a0,800009d0 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009a4:	6605                	lui	a2,0x1
    800009a6:	4581                	li	a1,0
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	882080e7          	jalr	-1918(ra) # 8000022a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009b0:	4779                	li	a4,30
    800009b2:	86a6                	mv	a3,s1
    800009b4:	6605                	lui	a2,0x1
    800009b6:	85ca                	mv	a1,s2
    800009b8:	8556                	mv	a0,s5
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	c40080e7          	jalr	-960(ra) # 800005fa <mappages>
    800009c2:	e905                	bnez	a0,800009f2 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009c4:	6785                	lui	a5,0x1
    800009c6:	993e                	add	s2,s2,a5
    800009c8:	fd4968e3          	bltu	s2,s4,80000998 <uvmalloc+0x2c>
  return newsz;
    800009cc:	8552                	mv	a0,s4
    800009ce:	a809                	j	800009e0 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800009d0:	864e                	mv	a2,s3
    800009d2:	85ca                	mv	a1,s2
    800009d4:	8556                	mv	a0,s5
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	f4e080e7          	jalr	-178(ra) # 80000924 <uvmdealloc>
      return 0;
    800009de:	4501                	li	a0,0
}
    800009e0:	70e2                	ld	ra,56(sp)
    800009e2:	7442                	ld	s0,48(sp)
    800009e4:	74a2                	ld	s1,40(sp)
    800009e6:	7902                	ld	s2,32(sp)
    800009e8:	69e2                	ld	s3,24(sp)
    800009ea:	6a42                	ld	s4,16(sp)
    800009ec:	6aa2                	ld	s5,8(sp)
    800009ee:	6121                	addi	sp,sp,64
    800009f0:	8082                	ret
      kfree(mem);
    800009f2:	8526                	mv	a0,s1
    800009f4:	fffff097          	auipc	ra,0xfffff
    800009f8:	670080e7          	jalr	1648(ra) # 80000064 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009fc:	864e                	mv	a2,s3
    800009fe:	85ca                	mv	a1,s2
    80000a00:	8556                	mv	a0,s5
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	f22080e7          	jalr	-222(ra) # 80000924 <uvmdealloc>
      return 0;
    80000a0a:	4501                	li	a0,0
    80000a0c:	bfd1                	j	800009e0 <uvmalloc+0x74>
    return oldsz;
    80000a0e:	852e                	mv	a0,a1
}
    80000a10:	8082                	ret
  return newsz;
    80000a12:	8532                	mv	a0,a2
    80000a14:	b7f1                	j	800009e0 <uvmalloc+0x74>

0000000080000a16 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a16:	7179                	addi	sp,sp,-48
    80000a18:	f406                	sd	ra,40(sp)
    80000a1a:	f022                	sd	s0,32(sp)
    80000a1c:	ec26                	sd	s1,24(sp)
    80000a1e:	e84a                	sd	s2,16(sp)
    80000a20:	e44e                	sd	s3,8(sp)
    80000a22:	e052                	sd	s4,0(sp)
    80000a24:	1800                	addi	s0,sp,48
    80000a26:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a28:	84aa                	mv	s1,a0
    80000a2a:	6905                	lui	s2,0x1
    80000a2c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a2e:	4985                	li	s3,1
    80000a30:	a821                	j	80000a48 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a32:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a34:	0532                	slli	a0,a0,0xc
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	fe0080e7          	jalr	-32(ra) # 80000a16 <freewalk>
      pagetable[i] = 0;
    80000a3e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a42:	04a1                	addi	s1,s1,8
    80000a44:	03248163          	beq	s1,s2,80000a66 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a48:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a4a:	00f57793          	andi	a5,a0,15
    80000a4e:	ff3782e3          	beq	a5,s3,80000a32 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a52:	8905                	andi	a0,a0,1
    80000a54:	d57d                	beqz	a0,80000a42 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a56:	00007517          	auipc	a0,0x7
    80000a5a:	6a250513          	addi	a0,a0,1698 # 800080f8 <etext+0xf8>
    80000a5e:	00005097          	auipc	ra,0x5
    80000a62:	3ba080e7          	jalr	954(ra) # 80005e18 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a66:	8552                	mv	a0,s4
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	5fc080e7          	jalr	1532(ra) # 80000064 <kfree>
}
    80000a70:	70a2                	ld	ra,40(sp)
    80000a72:	7402                	ld	s0,32(sp)
    80000a74:	64e2                	ld	s1,24(sp)
    80000a76:	6942                	ld	s2,16(sp)
    80000a78:	69a2                	ld	s3,8(sp)
    80000a7a:	6a02                	ld	s4,0(sp)
    80000a7c:	6145                	addi	sp,sp,48
    80000a7e:	8082                	ret

0000000080000a80 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a80:	1101                	addi	sp,sp,-32
    80000a82:	ec06                	sd	ra,24(sp)
    80000a84:	e822                	sd	s0,16(sp)
    80000a86:	e426                	sd	s1,8(sp)
    80000a88:	1000                	addi	s0,sp,32
    80000a8a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a8c:	e999                	bnez	a1,80000aa2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a8e:	8526                	mv	a0,s1
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	f86080e7          	jalr	-122(ra) # 80000a16 <freewalk>
}
    80000a98:	60e2                	ld	ra,24(sp)
    80000a9a:	6442                	ld	s0,16(sp)
    80000a9c:	64a2                	ld	s1,8(sp)
    80000a9e:	6105                	addi	sp,sp,32
    80000aa0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000aa2:	6605                	lui	a2,0x1
    80000aa4:	167d                	addi	a2,a2,-1
    80000aa6:	962e                	add	a2,a2,a1
    80000aa8:	4685                	li	a3,1
    80000aaa:	8231                	srli	a2,a2,0xc
    80000aac:	4581                	li	a1,0
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	d12080e7          	jalr	-750(ra) # 800007c0 <uvmunmap>
    80000ab6:	bfe1                	j	80000a8e <uvmfree+0xe>

0000000080000ab8 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000ab8:	ca5d                	beqz	a2,80000b6e <uvmcopy+0xb6>
{
    80000aba:	7139                	addi	sp,sp,-64
    80000abc:	fc06                	sd	ra,56(sp)
    80000abe:	f822                	sd	s0,48(sp)
    80000ac0:	f426                	sd	s1,40(sp)
    80000ac2:	f04a                	sd	s2,32(sp)
    80000ac4:	ec4e                	sd	s3,24(sp)
    80000ac6:	e852                	sd	s4,16(sp)
    80000ac8:	e456                	sd	s5,8(sp)
    80000aca:	e05a                	sd	s6,0(sp)
    80000acc:	0080                	addi	s0,sp,64
    80000ace:	8b2a                	mv	s6,a0
    80000ad0:	8aae                	mv	s5,a1
    80000ad2:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000ad4:	4901                	li	s2,0
    if((pte = walk(old, i, 0)) == 0)
    80000ad6:	4601                	li	a2,0
    80000ad8:	85ca                	mv	a1,s2
    80000ada:	855a                	mv	a0,s6
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	a36080e7          	jalr	-1482(ra) # 80000512 <walk>
    80000ae4:	c129                	beqz	a0,80000b26 <uvmcopy+0x6e>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000ae6:	611c                	ld	a5,0(a0)
    80000ae8:	0017f713          	andi	a4,a5,1
    80000aec:	c729                	beqz	a4,80000b36 <uvmcopy+0x7e>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aee:	00a7d993          	srli	s3,a5,0xa
    80000af2:	09b2                	slli	s3,s3,0xc
    // update parent's flags to clear PTE_W and set PTE_COW
    *pte &= (~ PTE_W);
    80000af4:	9bed                	andi	a5,a5,-5
    *pte |= PTE_COW;
    80000af6:	2007e493          	ori	s1,a5,512
    80000afa:	e104                	sd	s1,0(a0)
    flags = PTE_FLAGS(*pte);  // child's flags
    
    increfcount(pa);
    80000afc:	854e                	mv	a0,s3
    80000afe:	fffff097          	auipc	ra,0xfffff
    80000b02:	51e080e7          	jalr	1310(ra) # 8000001c <increfcount>
    // refcount[PA2INX(pa)]+=1;
    if(mappages(new, i, PGSIZE, pa, flags) != 0){ // mapping to same physical memory as parent
    80000b06:	3fb4f713          	andi	a4,s1,1019
    80000b0a:	86ce                	mv	a3,s3
    80000b0c:	6605                	lui	a2,0x1
    80000b0e:	85ca                	mv	a1,s2
    80000b10:	8556                	mv	a0,s5
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	ae8080e7          	jalr	-1304(ra) # 800005fa <mappages>
    80000b1a:	e515                	bnez	a0,80000b46 <uvmcopy+0x8e>
  for(i = 0; i < sz; i += PGSIZE){
    80000b1c:	6785                	lui	a5,0x1
    80000b1e:	993e                	add	s2,s2,a5
    80000b20:	fb496be3          	bltu	s2,s4,80000ad6 <uvmcopy+0x1e>
    80000b24:	a81d                	j	80000b5a <uvmcopy+0xa2>
      panic("uvmcopy: pte should exist");
    80000b26:	00007517          	auipc	a0,0x7
    80000b2a:	5e250513          	addi	a0,a0,1506 # 80008108 <etext+0x108>
    80000b2e:	00005097          	auipc	ra,0x5
    80000b32:	2ea080e7          	jalr	746(ra) # 80005e18 <panic>
      panic("uvmcopy: page not present");
    80000b36:	00007517          	auipc	a0,0x7
    80000b3a:	5f250513          	addi	a0,a0,1522 # 80008128 <etext+0x128>
    80000b3e:	00005097          	auipc	ra,0x5
    80000b42:	2da080e7          	jalr	730(ra) # 80005e18 <panic>
      uvmunmap(new, 0, i / PGSIZE, 1);
    80000b46:	4685                	li	a3,1
    80000b48:	00c95613          	srli	a2,s2,0xc
    80000b4c:	4581                	li	a1,0
    80000b4e:	8556                	mv	a0,s5
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	c70080e7          	jalr	-912(ra) # 800007c0 <uvmunmap>
      return -1;
    80000b58:	557d                	li	a0,-1
    }
   }
 return 0;
}
    80000b5a:	70e2                	ld	ra,56(sp)
    80000b5c:	7442                	ld	s0,48(sp)
    80000b5e:	74a2                	ld	s1,40(sp)
    80000b60:	7902                	ld	s2,32(sp)
    80000b62:	69e2                	ld	s3,24(sp)
    80000b64:	6a42                	ld	s4,16(sp)
    80000b66:	6aa2                	ld	s5,8(sp)
    80000b68:	6b02                	ld	s6,0(sp)
    80000b6a:	6121                	addi	sp,sp,64
    80000b6c:	8082                	ret
 return 0;
    80000b6e:	4501                	li	a0,0
}
    80000b70:	8082                	ret

0000000080000b72 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b72:	1141                	addi	sp,sp,-16
    80000b74:	e406                	sd	ra,8(sp)
    80000b76:	e022                	sd	s0,0(sp)
    80000b78:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b7a:	4601                	li	a2,0
    80000b7c:	00000097          	auipc	ra,0x0
    80000b80:	996080e7          	jalr	-1642(ra) # 80000512 <walk>
  if(pte == 0)
    80000b84:	c901                	beqz	a0,80000b94 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b86:	611c                	ld	a5,0(a0)
    80000b88:	9bbd                	andi	a5,a5,-17
    80000b8a:	e11c                	sd	a5,0(a0)
}
    80000b8c:	60a2                	ld	ra,8(sp)
    80000b8e:	6402                	ld	s0,0(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret
    panic("uvmclear");
    80000b94:	00007517          	auipc	a0,0x7
    80000b98:	5b450513          	addi	a0,a0,1460 # 80008148 <etext+0x148>
    80000b9c:	00005097          	auipc	ra,0x5
    80000ba0:	27c080e7          	jalr	636(ra) # 80005e18 <panic>

0000000080000ba4 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
 
  while(len > 0){
    80000ba4:	c6bd                	beqz	a3,80000c12 <copyout+0x6e>
{
    80000ba6:	715d                	addi	sp,sp,-80
    80000ba8:	e486                	sd	ra,72(sp)
    80000baa:	e0a2                	sd	s0,64(sp)
    80000bac:	fc26                	sd	s1,56(sp)
    80000bae:	f84a                	sd	s2,48(sp)
    80000bb0:	f44e                	sd	s3,40(sp)
    80000bb2:	f052                	sd	s4,32(sp)
    80000bb4:	ec56                	sd	s5,24(sp)
    80000bb6:	e85a                	sd	s6,16(sp)
    80000bb8:	e45e                	sd	s7,8(sp)
    80000bba:	e062                	sd	s8,0(sp)
    80000bbc:	0880                	addi	s0,sp,80
    80000bbe:	8b2a                	mv	s6,a0
    80000bc0:	8c2e                	mv	s8,a1
    80000bc2:	8a32                	mv	s4,a2
    80000bc4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000bc6:	7bfd                	lui	s7,0xfffff
     //if(pagefaulthandler(pagetable,va0)<0) return -1; //check if COW page if it then allocate a differnt physical page
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a015                	j	80000bee <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bcc:	9562                	add	a0,a0,s8
    80000bce:	0004861b          	sext.w	a2,s1
    80000bd2:	85d2                	mv	a1,s4
    80000bd4:	41250533          	sub	a0,a0,s2
    80000bd8:	fffff097          	auipc	ra,0xfffff
    80000bdc:	6b2080e7          	jalr	1714(ra) # 8000028a <memmove>

    len -= n;
    80000be0:	409989b3          	sub	s3,s3,s1
    src += n;
    80000be4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000be6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bea:	02098263          	beqz	s3,80000c0e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bee:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf2:	85ca                	mv	a1,s2
    80000bf4:	855a                	mv	a0,s6
    80000bf6:	00000097          	auipc	ra,0x0
    80000bfa:	9c2080e7          	jalr	-1598(ra) # 800005b8 <walkaddr>
    if(pa0 == 0)
    80000bfe:	cd01                	beqz	a0,80000c16 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c00:	418904b3          	sub	s1,s2,s8
    80000c04:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c06:	fc99f3e3          	bgeu	s3,s1,80000bcc <copyout+0x28>
    80000c0a:	84ce                	mv	s1,s3
    80000c0c:	b7c1                	j	80000bcc <copyout+0x28>
  }
  return 0;
    80000c0e:	4501                	li	a0,0
    80000c10:	a021                	j	80000c18 <copyout+0x74>
    80000c12:	4501                	li	a0,0
}
    80000c14:	8082                	ret
      return -1;
    80000c16:	557d                	li	a0,-1
}
    80000c18:	60a6                	ld	ra,72(sp)
    80000c1a:	6406                	ld	s0,64(sp)
    80000c1c:	74e2                	ld	s1,56(sp)
    80000c1e:	7942                	ld	s2,48(sp)
    80000c20:	79a2                	ld	s3,40(sp)
    80000c22:	7a02                	ld	s4,32(sp)
    80000c24:	6ae2                	ld	s5,24(sp)
    80000c26:	6b42                	ld	s6,16(sp)
    80000c28:	6ba2                	ld	s7,8(sp)
    80000c2a:	6c02                	ld	s8,0(sp)
    80000c2c:	6161                	addi	sp,sp,80
    80000c2e:	8082                	ret

0000000080000c30 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c30:	c6bd                	beqz	a3,80000c9e <copyin+0x6e>
{
    80000c32:	715d                	addi	sp,sp,-80
    80000c34:	e486                	sd	ra,72(sp)
    80000c36:	e0a2                	sd	s0,64(sp)
    80000c38:	fc26                	sd	s1,56(sp)
    80000c3a:	f84a                	sd	s2,48(sp)
    80000c3c:	f44e                	sd	s3,40(sp)
    80000c3e:	f052                	sd	s4,32(sp)
    80000c40:	ec56                	sd	s5,24(sp)
    80000c42:	e85a                	sd	s6,16(sp)
    80000c44:	e45e                	sd	s7,8(sp)
    80000c46:	e062                	sd	s8,0(sp)
    80000c48:	0880                	addi	s0,sp,80
    80000c4a:	8b2a                	mv	s6,a0
    80000c4c:	8a2e                	mv	s4,a1
    80000c4e:	8c32                	mv	s8,a2
    80000c50:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c52:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c54:	6a85                	lui	s5,0x1
    80000c56:	a015                	j	80000c7a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c58:	9562                	add	a0,a0,s8
    80000c5a:	0004861b          	sext.w	a2,s1
    80000c5e:	412505b3          	sub	a1,a0,s2
    80000c62:	8552                	mv	a0,s4
    80000c64:	fffff097          	auipc	ra,0xfffff
    80000c68:	626080e7          	jalr	1574(ra) # 8000028a <memmove>

    len -= n;
    80000c6c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c70:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c72:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c76:	02098263          	beqz	s3,80000c9a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c7a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c7e:	85ca                	mv	a1,s2
    80000c80:	855a                	mv	a0,s6
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	936080e7          	jalr	-1738(ra) # 800005b8 <walkaddr>
    if(pa0 == 0)
    80000c8a:	cd01                	beqz	a0,80000ca2 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c8c:	418904b3          	sub	s1,s2,s8
    80000c90:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c92:	fc99f3e3          	bgeu	s3,s1,80000c58 <copyin+0x28>
    80000c96:	84ce                	mv	s1,s3
    80000c98:	b7c1                	j	80000c58 <copyin+0x28>
  }
  return 0;
    80000c9a:	4501                	li	a0,0
    80000c9c:	a021                	j	80000ca4 <copyin+0x74>
    80000c9e:	4501                	li	a0,0
}
    80000ca0:	8082                	ret
      return -1;
    80000ca2:	557d                	li	a0,-1
}
    80000ca4:	60a6                	ld	ra,72(sp)
    80000ca6:	6406                	ld	s0,64(sp)
    80000ca8:	74e2                	ld	s1,56(sp)
    80000caa:	7942                	ld	s2,48(sp)
    80000cac:	79a2                	ld	s3,40(sp)
    80000cae:	7a02                	ld	s4,32(sp)
    80000cb0:	6ae2                	ld	s5,24(sp)
    80000cb2:	6b42                	ld	s6,16(sp)
    80000cb4:	6ba2                	ld	s7,8(sp)
    80000cb6:	6c02                	ld	s8,0(sp)
    80000cb8:	6161                	addi	sp,sp,80
    80000cba:	8082                	ret

0000000080000cbc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cbc:	c6c5                	beqz	a3,80000d64 <copyinstr+0xa8>
{
    80000cbe:	715d                	addi	sp,sp,-80
    80000cc0:	e486                	sd	ra,72(sp)
    80000cc2:	e0a2                	sd	s0,64(sp)
    80000cc4:	fc26                	sd	s1,56(sp)
    80000cc6:	f84a                	sd	s2,48(sp)
    80000cc8:	f44e                	sd	s3,40(sp)
    80000cca:	f052                	sd	s4,32(sp)
    80000ccc:	ec56                	sd	s5,24(sp)
    80000cce:	e85a                	sd	s6,16(sp)
    80000cd0:	e45e                	sd	s7,8(sp)
    80000cd2:	0880                	addi	s0,sp,80
    80000cd4:	8a2a                	mv	s4,a0
    80000cd6:	8b2e                	mv	s6,a1
    80000cd8:	8bb2                	mv	s7,a2
    80000cda:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000cdc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cde:	6985                	lui	s3,0x1
    80000ce0:	a035                	j	80000d0c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ce2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ce8:	0017b793          	seqz	a5,a5
    80000cec:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cf0:	60a6                	ld	ra,72(sp)
    80000cf2:	6406                	ld	s0,64(sp)
    80000cf4:	74e2                	ld	s1,56(sp)
    80000cf6:	7942                	ld	s2,48(sp)
    80000cf8:	79a2                	ld	s3,40(sp)
    80000cfa:	7a02                	ld	s4,32(sp)
    80000cfc:	6ae2                	ld	s5,24(sp)
    80000cfe:	6b42                	ld	s6,16(sp)
    80000d00:	6ba2                	ld	s7,8(sp)
    80000d02:	6161                	addi	sp,sp,80
    80000d04:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d06:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d0a:	c8a9                	beqz	s1,80000d5c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d0c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d10:	85ca                	mv	a1,s2
    80000d12:	8552                	mv	a0,s4
    80000d14:	00000097          	auipc	ra,0x0
    80000d18:	8a4080e7          	jalr	-1884(ra) # 800005b8 <walkaddr>
    if(pa0 == 0)
    80000d1c:	c131                	beqz	a0,80000d60 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d1e:	41790833          	sub	a6,s2,s7
    80000d22:	984e                	add	a6,a6,s3
    if(n > max)
    80000d24:	0104f363          	bgeu	s1,a6,80000d2a <copyinstr+0x6e>
    80000d28:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d2a:	955e                	add	a0,a0,s7
    80000d2c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d30:	fc080be3          	beqz	a6,80000d06 <copyinstr+0x4a>
    80000d34:	985a                	add	a6,a6,s6
    80000d36:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d38:	41650633          	sub	a2,a0,s6
    80000d3c:	14fd                	addi	s1,s1,-1
    80000d3e:	9b26                	add	s6,s6,s1
    80000d40:	00f60733          	add	a4,a2,a5
    80000d44:	00074703          	lbu	a4,0(a4)
    80000d48:	df49                	beqz	a4,80000ce2 <copyinstr+0x26>
        *dst = *p;
    80000d4a:	00e78023          	sb	a4,0(a5)
      --max;
    80000d4e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d52:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d54:	ff0796e3          	bne	a5,a6,80000d40 <copyinstr+0x84>
      dst++;
    80000d58:	8b42                	mv	s6,a6
    80000d5a:	b775                	j	80000d06 <copyinstr+0x4a>
    80000d5c:	4781                	li	a5,0
    80000d5e:	b769                	j	80000ce8 <copyinstr+0x2c>
      return -1;
    80000d60:	557d                	li	a0,-1
    80000d62:	b779                	j	80000cf0 <copyinstr+0x34>
  int got_null = 0;
    80000d64:	4781                	li	a5,0
  if(got_null){
    80000d66:	0017b793          	seqz	a5,a5
    80000d6a:	40f00533          	neg	a0,a5
}
    80000d6e:	8082                	ret

0000000080000d70 <vmprintwalk>:


void vmprintwalk(pagetable_t pagetable, int level)
{
    80000d70:	711d                	addi	sp,sp,-96
    80000d72:	ec86                	sd	ra,88(sp)
    80000d74:	e8a2                	sd	s0,80(sp)
    80000d76:	e4a6                	sd	s1,72(sp)
    80000d78:	e0ca                	sd	s2,64(sp)
    80000d7a:	fc4e                	sd	s3,56(sp)
    80000d7c:	f852                	sd	s4,48(sp)
    80000d7e:	f456                	sd	s5,40(sp)
    80000d80:	f05a                	sd	s6,32(sp)
    80000d82:	ec5e                	sd	s7,24(sp)
    80000d84:	e862                	sd	s8,16(sp)
    80000d86:	e466                	sd	s9,8(sp)
    80000d88:	1080                	addi	s0,sp,96
    80000d8a:	89ae                	mv	s3,a1
  for(int i=0; i<512; i++)
    80000d8c:	892a                	mv	s2,a0
    80000d8e:	4481                	li	s1,0
  {
   pte_t pte = pagetable[i];
  
   if(level==1)
    80000d90:	4a05                	li	s4,1
       printf(".. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
       uint64 child = PTE2PA(pte);
       vmprintwalk((pagetable_t)child, level+1);
     }
    }
   if(level==2)
    80000d92:	4b09                	li	s6,2
   {
     if(pte & PTE_V) 
     printf(".. .. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000d94:	00007b97          	auipc	s7,0x7
    80000d98:	3dcb8b93          	addi	s7,s7,988 # 80008170 <etext+0x170>
       printf(".. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000d9c:	00007c17          	auipc	s8,0x7
    80000da0:	3bcc0c13          	addi	s8,s8,956 # 80008158 <etext+0x158>
  for(int i=0; i<512; i++)
    80000da4:	20000a93          	li	s5,512
    80000da8:	a809                	j	80000dba <vmprintwalk+0x4a>
     if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000daa:	00f67793          	andi	a5,a2,15
    80000dae:	03478963          	beq	a5,s4,80000de0 <vmprintwalk+0x70>
  for(int i=0; i<512; i++)
    80000db2:	2485                	addiw	s1,s1,1
    80000db4:	0921                	addi	s2,s2,8
    80000db6:	05548663          	beq	s1,s5,80000e02 <vmprintwalk+0x92>
   pte_t pte = pagetable[i];
    80000dba:	00093603          	ld	a2,0(s2) # 1000 <_entry-0x7ffff000>
   if(level==1)
    80000dbe:	ff4986e3          	beq	s3,s4,80000daa <vmprintwalk+0x3a>
   if(level==2)
    80000dc2:	ff6998e3          	bne	s3,s6,80000db2 <vmprintwalk+0x42>
     if(pte & PTE_V) 
    80000dc6:	00167793          	andi	a5,a2,1
    80000dca:	d7e5                	beqz	a5,80000db2 <vmprintwalk+0x42>
     printf(".. .. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000dcc:	00a65693          	srli	a3,a2,0xa
    80000dd0:	06b2                	slli	a3,a3,0xc
    80000dd2:	85a6                	mv	a1,s1
    80000dd4:	855e                	mv	a0,s7
    80000dd6:	00005097          	auipc	ra,0x5
    80000dda:	08c080e7          	jalr	140(ra) # 80005e62 <printf>
    80000dde:	bfd1                	j	80000db2 <vmprintwalk+0x42>
       printf(".. ..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000de0:	00a65c93          	srli	s9,a2,0xa
    80000de4:	0cb2                	slli	s9,s9,0xc
    80000de6:	86e6                	mv	a3,s9
    80000de8:	85a6                	mv	a1,s1
    80000dea:	8562                	mv	a0,s8
    80000dec:	00005097          	auipc	ra,0x5
    80000df0:	076080e7          	jalr	118(ra) # 80005e62 <printf>
       vmprintwalk((pagetable_t)child, level+1);
    80000df4:	85da                	mv	a1,s6
    80000df6:	8566                	mv	a0,s9
    80000df8:	00000097          	auipc	ra,0x0
    80000dfc:	f78080e7          	jalr	-136(ra) # 80000d70 <vmprintwalk>
    80000e00:	bf4d                	j	80000db2 <vmprintwalk+0x42>
  //   uint64 child = PTE2PA(pte);
  //   if (level != 2) vmprintwalk((pagetable_t)child, level + 1);
  // }
  
 
}
    80000e02:	60e6                	ld	ra,88(sp)
    80000e04:	6446                	ld	s0,80(sp)
    80000e06:	64a6                	ld	s1,72(sp)
    80000e08:	6906                	ld	s2,64(sp)
    80000e0a:	79e2                	ld	s3,56(sp)
    80000e0c:	7a42                	ld	s4,48(sp)
    80000e0e:	7aa2                	ld	s5,40(sp)
    80000e10:	7b02                	ld	s6,32(sp)
    80000e12:	6be2                	ld	s7,24(sp)
    80000e14:	6c42                	ld	s8,16(sp)
    80000e16:	6ca2                	ld	s9,8(sp)
    80000e18:	6125                	addi	sp,sp,96
    80000e1a:	8082                	ret

0000000080000e1c <vmprint>:


// this function is added to print out the page table info.

void vmprint(pagetable_t pagetable)
{
    80000e1c:	7139                	addi	sp,sp,-64
    80000e1e:	fc06                	sd	ra,56(sp)
    80000e20:	f822                	sd	s0,48(sp)
    80000e22:	f426                	sd	s1,40(sp)
    80000e24:	f04a                	sd	s2,32(sp)
    80000e26:	ec4e                	sd	s3,24(sp)
    80000e28:	e852                	sd	s4,16(sp)
    80000e2a:	e456                	sd	s5,8(sp)
    80000e2c:	e05a                	sd	s6,0(sp)
    80000e2e:	0080                	addi	s0,sp,64
    80000e30:	892a                	mv	s2,a0
  printf("page table %p\n", pagetable);
    80000e32:	85aa                	mv	a1,a0
    80000e34:	00007517          	auipc	a0,0x7
    80000e38:	35c50513          	addi	a0,a0,860 # 80008190 <etext+0x190>
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	026080e7          	jalr	38(ra) # 80005e62 <printf>
  //vmprintwalk(pagetable,0);
  for(int i = 0; i < 512; i++){
    80000e44:	4481                	li	s1,0
    pte_t pte = pagetable[i];
    
 
   if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000e46:	4985                	li	s3,1
   {
     printf("..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000e48:	00007b17          	auipc	s6,0x7
    80000e4c:	358b0b13          	addi	s6,s6,856 # 800081a0 <etext+0x1a0>
  for(int i = 0; i < 512; i++){
    80000e50:	20000a13          	li	s4,512
    80000e54:	a02d                	j	80000e7e <vmprint+0x62>
     printf("..%d: pte %p pa %p\n",i, pte, PTE2PA(pte));
    80000e56:	00a65a93          	srli	s5,a2,0xa
    80000e5a:	0ab2                	slli	s5,s5,0xc
    80000e5c:	86d6                	mv	a3,s5
    80000e5e:	85a6                	mv	a1,s1
    80000e60:	855a                	mv	a0,s6
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	000080e7          	jalr	ra # 80005e62 <printf>
     uint64 child = PTE2PA(pte);
     vmprintwalk((pagetable_t)child, 1);
    80000e6a:	85ce                	mv	a1,s3
    80000e6c:	8556                	mv	a0,s5
    80000e6e:	00000097          	auipc	ra,0x0
    80000e72:	f02080e7          	jalr	-254(ra) # 80000d70 <vmprintwalk>
  for(int i = 0; i < 512; i++){
    80000e76:	2485                	addiw	s1,s1,1
    80000e78:	0921                	addi	s2,s2,8
    80000e7a:	01448963          	beq	s1,s4,80000e8c <vmprint+0x70>
    pte_t pte = pagetable[i];
    80000e7e:	00093603          	ld	a2,0(s2)
   if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000e82:	00f67793          	andi	a5,a2,15
    80000e86:	ff3798e3          	bne	a5,s3,80000e76 <vmprint+0x5a>
    80000e8a:	b7f1                	j	80000e56 <vmprint+0x3a>
   }
  }
    80000e8c:	70e2                	ld	ra,56(sp)
    80000e8e:	7442                	ld	s0,48(sp)
    80000e90:	74a2                	ld	s1,40(sp)
    80000e92:	7902                	ld	s2,32(sp)
    80000e94:	69e2                	ld	s3,24(sp)
    80000e96:	6a42                	ld	s4,16(sp)
    80000e98:	6aa2                	ld	s5,8(sp)
    80000e9a:	6b02                	ld	s6,0(sp)
    80000e9c:	6121                	addi	sp,sp,64
    80000e9e:	8082                	ret

0000000080000ea0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000ea0:	7139                	addi	sp,sp,-64
    80000ea2:	fc06                	sd	ra,56(sp)
    80000ea4:	f822                	sd	s0,48(sp)
    80000ea6:	f426                	sd	s1,40(sp)
    80000ea8:	f04a                	sd	s2,32(sp)
    80000eaa:	ec4e                	sd	s3,24(sp)
    80000eac:	e852                	sd	s4,16(sp)
    80000eae:	e456                	sd	s5,8(sp)
    80000eb0:	e05a                	sd	s6,0(sp)
    80000eb2:	0080                	addi	s0,sp,64
    80000eb4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb6:	00028497          	auipc	s1,0x28
    80000eba:	5ca48493          	addi	s1,s1,1482 # 80029480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ebe:	8b26                	mv	s6,s1
    80000ec0:	00007a97          	auipc	s5,0x7
    80000ec4:	140a8a93          	addi	s5,s5,320 # 80008000 <etext>
    80000ec8:	04000937          	lui	s2,0x4000
    80000ecc:	197d                	addi	s2,s2,-1
    80000ece:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed0:	0002ea17          	auipc	s4,0x2e
    80000ed4:	1b0a0a13          	addi	s4,s4,432 # 8002f080 <tickslock>
    char *pa = kalloc();
    80000ed8:	fffff097          	auipc	ra,0xfffff
    80000edc:	2da080e7          	jalr	730(ra) # 800001b2 <kalloc>
    80000ee0:	862a                	mv	a2,a0
    if(pa == 0)
    80000ee2:	c131                	beqz	a0,80000f26 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ee4:	416485b3          	sub	a1,s1,s6
    80000ee8:	8591                	srai	a1,a1,0x4
    80000eea:	000ab783          	ld	a5,0(s5)
    80000eee:	02f585b3          	mul	a1,a1,a5
    80000ef2:	2585                	addiw	a1,a1,1
    80000ef4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ef8:	4719                	li	a4,6
    80000efa:	6685                	lui	a3,0x1
    80000efc:	40b905b3          	sub	a1,s2,a1
    80000f00:	854e                	mv	a0,s3
    80000f02:	fffff097          	auipc	ra,0xfffff
    80000f06:	798080e7          	jalr	1944(ra) # 8000069a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0a:	17048493          	addi	s1,s1,368
    80000f0e:	fd4495e3          	bne	s1,s4,80000ed8 <proc_mapstacks+0x38>
  }
}
    80000f12:	70e2                	ld	ra,56(sp)
    80000f14:	7442                	ld	s0,48(sp)
    80000f16:	74a2                	ld	s1,40(sp)
    80000f18:	7902                	ld	s2,32(sp)
    80000f1a:	69e2                	ld	s3,24(sp)
    80000f1c:	6a42                	ld	s4,16(sp)
    80000f1e:	6aa2                	ld	s5,8(sp)
    80000f20:	6b02                	ld	s6,0(sp)
    80000f22:	6121                	addi	sp,sp,64
    80000f24:	8082                	ret
      panic("kalloc");
    80000f26:	00007517          	auipc	a0,0x7
    80000f2a:	29250513          	addi	a0,a0,658 # 800081b8 <etext+0x1b8>
    80000f2e:	00005097          	auipc	ra,0x5
    80000f32:	eea080e7          	jalr	-278(ra) # 80005e18 <panic>

0000000080000f36 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f36:	7139                	addi	sp,sp,-64
    80000f38:	fc06                	sd	ra,56(sp)
    80000f3a:	f822                	sd	s0,48(sp)
    80000f3c:	f426                	sd	s1,40(sp)
    80000f3e:	f04a                	sd	s2,32(sp)
    80000f40:	ec4e                	sd	s3,24(sp)
    80000f42:	e852                	sd	s4,16(sp)
    80000f44:	e456                	sd	s5,8(sp)
    80000f46:	e05a                	sd	s6,0(sp)
    80000f48:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f4a:	00007597          	auipc	a1,0x7
    80000f4e:	27658593          	addi	a1,a1,630 # 800081c0 <etext+0x1c0>
    80000f52:	00028517          	auipc	a0,0x28
    80000f56:	0fe50513          	addi	a0,a0,254 # 80029050 <pid_lock>
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	3e4080e7          	jalr	996(ra) # 8000633e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f62:	00007597          	auipc	a1,0x7
    80000f66:	26658593          	addi	a1,a1,614 # 800081c8 <etext+0x1c8>
    80000f6a:	00028517          	auipc	a0,0x28
    80000f6e:	0fe50513          	addi	a0,a0,254 # 80029068 <wait_lock>
    80000f72:	00005097          	auipc	ra,0x5
    80000f76:	3cc080e7          	jalr	972(ra) # 8000633e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7a:	00028497          	auipc	s1,0x28
    80000f7e:	50648493          	addi	s1,s1,1286 # 80029480 <proc>
      initlock(&p->lock, "proc");
    80000f82:	00007b17          	auipc	s6,0x7
    80000f86:	256b0b13          	addi	s6,s6,598 # 800081d8 <etext+0x1d8>
      p->kstack = KSTACK((int) (p - proc));
    80000f8a:	8aa6                	mv	s5,s1
    80000f8c:	00007a17          	auipc	s4,0x7
    80000f90:	074a0a13          	addi	s4,s4,116 # 80008000 <etext>
    80000f94:	04000937          	lui	s2,0x4000
    80000f98:	197d                	addi	s2,s2,-1
    80000f9a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f9c:	0002e997          	auipc	s3,0x2e
    80000fa0:	0e498993          	addi	s3,s3,228 # 8002f080 <tickslock>
      initlock(&p->lock, "proc");
    80000fa4:	85da                	mv	a1,s6
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	396080e7          	jalr	918(ra) # 8000633e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000fb0:	415487b3          	sub	a5,s1,s5
    80000fb4:	8791                	srai	a5,a5,0x4
    80000fb6:	000a3703          	ld	a4,0(s4)
    80000fba:	02e787b3          	mul	a5,a5,a4
    80000fbe:	2785                	addiw	a5,a5,1
    80000fc0:	00d7979b          	slliw	a5,a5,0xd
    80000fc4:	40f907b3          	sub	a5,s2,a5
    80000fc8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fca:	17048493          	addi	s1,s1,368
    80000fce:	fd349be3          	bne	s1,s3,80000fa4 <procinit+0x6e>
  }
}
    80000fd2:	70e2                	ld	ra,56(sp)
    80000fd4:	7442                	ld	s0,48(sp)
    80000fd6:	74a2                	ld	s1,40(sp)
    80000fd8:	7902                	ld	s2,32(sp)
    80000fda:	69e2                	ld	s3,24(sp)
    80000fdc:	6a42                	ld	s4,16(sp)
    80000fde:	6aa2                	ld	s5,8(sp)
    80000fe0:	6b02                	ld	s6,0(sp)
    80000fe2:	6121                	addi	sp,sp,64
    80000fe4:	8082                	ret

0000000080000fe6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fe6:	1141                	addi	sp,sp,-16
    80000fe8:	e422                	sd	s0,8(sp)
    80000fea:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fec:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fee:	2501                	sext.w	a0,a0
    80000ff0:	6422                	ld	s0,8(sp)
    80000ff2:	0141                	addi	sp,sp,16
    80000ff4:	8082                	ret

0000000080000ff6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000ff6:	1141                	addi	sp,sp,-16
    80000ff8:	e422                	sd	s0,8(sp)
    80000ffa:	0800                	addi	s0,sp,16
    80000ffc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ffe:	2781                	sext.w	a5,a5
    80001000:	079e                	slli	a5,a5,0x7
  return c;
}
    80001002:	00028517          	auipc	a0,0x28
    80001006:	07e50513          	addi	a0,a0,126 # 80029080 <cpus>
    8000100a:	953e                	add	a0,a0,a5
    8000100c:	6422                	ld	s0,8(sp)
    8000100e:	0141                	addi	sp,sp,16
    80001010:	8082                	ret

0000000080001012 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001012:	1101                	addi	sp,sp,-32
    80001014:	ec06                	sd	ra,24(sp)
    80001016:	e822                	sd	s0,16(sp)
    80001018:	e426                	sd	s1,8(sp)
    8000101a:	1000                	addi	s0,sp,32
  push_off();
    8000101c:	00005097          	auipc	ra,0x5
    80001020:	366080e7          	jalr	870(ra) # 80006382 <push_off>
    80001024:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001026:	2781                	sext.w	a5,a5
    80001028:	079e                	slli	a5,a5,0x7
    8000102a:	00028717          	auipc	a4,0x28
    8000102e:	02670713          	addi	a4,a4,38 # 80029050 <pid_lock>
    80001032:	97ba                	add	a5,a5,a4
    80001034:	7b84                	ld	s1,48(a5)
  pop_off();
    80001036:	00005097          	auipc	ra,0x5
    8000103a:	3ec080e7          	jalr	1004(ra) # 80006422 <pop_off>
  return p;
}
    8000103e:	8526                	mv	a0,s1
    80001040:	60e2                	ld	ra,24(sp)
    80001042:	6442                	ld	s0,16(sp)
    80001044:	64a2                	ld	s1,8(sp)
    80001046:	6105                	addi	sp,sp,32
    80001048:	8082                	ret

000000008000104a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000104a:	1141                	addi	sp,sp,-16
    8000104c:	e406                	sd	ra,8(sp)
    8000104e:	e022                	sd	s0,0(sp)
    80001050:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001052:	00000097          	auipc	ra,0x0
    80001056:	fc0080e7          	jalr	-64(ra) # 80001012 <myproc>
    8000105a:	00005097          	auipc	ra,0x5
    8000105e:	428080e7          	jalr	1064(ra) # 80006482 <release>

  if (first) {
    80001062:	00008797          	auipc	a5,0x8
    80001066:	84e7a783          	lw	a5,-1970(a5) # 800088b0 <first.1685>
    8000106a:	eb89                	bnez	a5,8000107c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000106c:	00001097          	auipc	ra,0x1
    80001070:	d00080e7          	jalr	-768(ra) # 80001d6c <usertrapret>
}
    80001074:	60a2                	ld	ra,8(sp)
    80001076:	6402                	ld	s0,0(sp)
    80001078:	0141                	addi	sp,sp,16
    8000107a:	8082                	ret
    first = 0;
    8000107c:	00008797          	auipc	a5,0x8
    80001080:	8207aa23          	sw	zero,-1996(a5) # 800088b0 <first.1685>
    fsinit(ROOTDEV);
    80001084:	4505                	li	a0,1
    80001086:	00002097          	auipc	ra,0x2
    8000108a:	a62080e7          	jalr	-1438(ra) # 80002ae8 <fsinit>
    8000108e:	bff9                	j	8000106c <forkret+0x22>

0000000080001090 <allocpid>:
allocpid() {
    80001090:	1101                	addi	sp,sp,-32
    80001092:	ec06                	sd	ra,24(sp)
    80001094:	e822                	sd	s0,16(sp)
    80001096:	e426                	sd	s1,8(sp)
    80001098:	e04a                	sd	s2,0(sp)
    8000109a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000109c:	00028917          	auipc	s2,0x28
    800010a0:	fb490913          	addi	s2,s2,-76 # 80029050 <pid_lock>
    800010a4:	854a                	mv	a0,s2
    800010a6:	00005097          	auipc	ra,0x5
    800010aa:	328080e7          	jalr	808(ra) # 800063ce <acquire>
  pid = nextpid;
    800010ae:	00008797          	auipc	a5,0x8
    800010b2:	80678793          	addi	a5,a5,-2042 # 800088b4 <nextpid>
    800010b6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010b8:	0014871b          	addiw	a4,s1,1
    800010bc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010be:	854a                	mv	a0,s2
    800010c0:	00005097          	auipc	ra,0x5
    800010c4:	3c2080e7          	jalr	962(ra) # 80006482 <release>
}
    800010c8:	8526                	mv	a0,s1
    800010ca:	60e2                	ld	ra,24(sp)
    800010cc:	6442                	ld	s0,16(sp)
    800010ce:	64a2                	ld	s1,8(sp)
    800010d0:	6902                	ld	s2,0(sp)
    800010d2:	6105                	addi	sp,sp,32
    800010d4:	8082                	ret

00000000800010d6 <proc_pagetable>:
{
    800010d6:	1101                	addi	sp,sp,-32
    800010d8:	ec06                	sd	ra,24(sp)
    800010da:	e822                	sd	s0,16(sp)
    800010dc:	e426                	sd	s1,8(sp)
    800010de:	e04a                	sd	s2,0(sp)
    800010e0:	1000                	addi	s0,sp,32
    800010e2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	7a0080e7          	jalr	1952(ra) # 80000884 <uvmcreate>
    800010ec:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010ee:	c121                	beqz	a0,8000112e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010f0:	4729                	li	a4,10
    800010f2:	00006697          	auipc	a3,0x6
    800010f6:	f0e68693          	addi	a3,a3,-242 # 80007000 <_trampoline>
    800010fa:	6605                	lui	a2,0x1
    800010fc:	040005b7          	lui	a1,0x4000
    80001100:	15fd                	addi	a1,a1,-1
    80001102:	05b2                	slli	a1,a1,0xc
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	4f6080e7          	jalr	1270(ra) # 800005fa <mappages>
    8000110c:	02054863          	bltz	a0,8000113c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001110:	4719                	li	a4,6
    80001112:	06093683          	ld	a3,96(s2)
    80001116:	6605                	lui	a2,0x1
    80001118:	020005b7          	lui	a1,0x2000
    8000111c:	15fd                	addi	a1,a1,-1
    8000111e:	05b6                	slli	a1,a1,0xd
    80001120:	8526                	mv	a0,s1
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	4d8080e7          	jalr	1240(ra) # 800005fa <mappages>
    8000112a:	02054163          	bltz	a0,8000114c <proc_pagetable+0x76>
}
    8000112e:	8526                	mv	a0,s1
    80001130:	60e2                	ld	ra,24(sp)
    80001132:	6442                	ld	s0,16(sp)
    80001134:	64a2                	ld	s1,8(sp)
    80001136:	6902                	ld	s2,0(sp)
    80001138:	6105                	addi	sp,sp,32
    8000113a:	8082                	ret
    uvmfree(pagetable, 0);
    8000113c:	4581                	li	a1,0
    8000113e:	8526                	mv	a0,s1
    80001140:	00000097          	auipc	ra,0x0
    80001144:	940080e7          	jalr	-1728(ra) # 80000a80 <uvmfree>
    return 0;
    80001148:	4481                	li	s1,0
    8000114a:	b7d5                	j	8000112e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000114c:	4681                	li	a3,0
    8000114e:	4605                	li	a2,1
    80001150:	040005b7          	lui	a1,0x4000
    80001154:	15fd                	addi	a1,a1,-1
    80001156:	05b2                	slli	a1,a1,0xc
    80001158:	8526                	mv	a0,s1
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	666080e7          	jalr	1638(ra) # 800007c0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001162:	4581                	li	a1,0
    80001164:	8526                	mv	a0,s1
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	91a080e7          	jalr	-1766(ra) # 80000a80 <uvmfree>
    return 0;
    8000116e:	4481                	li	s1,0
    80001170:	bf7d                	j	8000112e <proc_pagetable+0x58>

0000000080001172 <proc_freepagetable>:
{
    80001172:	1101                	addi	sp,sp,-32
    80001174:	ec06                	sd	ra,24(sp)
    80001176:	e822                	sd	s0,16(sp)
    80001178:	e426                	sd	s1,8(sp)
    8000117a:	e04a                	sd	s2,0(sp)
    8000117c:	1000                	addi	s0,sp,32
    8000117e:	84aa                	mv	s1,a0
    80001180:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001182:	4681                	li	a3,0
    80001184:	4605                	li	a2,1
    80001186:	040005b7          	lui	a1,0x4000
    8000118a:	15fd                	addi	a1,a1,-1
    8000118c:	05b2                	slli	a1,a1,0xc
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	632080e7          	jalr	1586(ra) # 800007c0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001196:	4681                	li	a3,0
    80001198:	4605                	li	a2,1
    8000119a:	020005b7          	lui	a1,0x2000
    8000119e:	15fd                	addi	a1,a1,-1
    800011a0:	05b6                	slli	a1,a1,0xd
    800011a2:	8526                	mv	a0,s1
    800011a4:	fffff097          	auipc	ra,0xfffff
    800011a8:	61c080e7          	jalr	1564(ra) # 800007c0 <uvmunmap>
  uvmfree(pagetable, sz);
    800011ac:	85ca                	mv	a1,s2
    800011ae:	8526                	mv	a0,s1
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	8d0080e7          	jalr	-1840(ra) # 80000a80 <uvmfree>
}
    800011b8:	60e2                	ld	ra,24(sp)
    800011ba:	6442                	ld	s0,16(sp)
    800011bc:	64a2                	ld	s1,8(sp)
    800011be:	6902                	ld	s2,0(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <freeproc>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	1000                	addi	s0,sp,32
    800011ce:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011d0:	7128                	ld	a0,96(a0)
    800011d2:	c509                	beqz	a0,800011dc <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	e90080e7          	jalr	-368(ra) # 80000064 <kfree>
  p->trapframe = 0;
    800011dc:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011e0:	68a8                	ld	a0,80(s1)
    800011e2:	c511                	beqz	a0,800011ee <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011e4:	64ac                	ld	a1,72(s1)
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	f8c080e7          	jalr	-116(ra) # 80001172 <proc_freepagetable>
  p->pagetable = 0;
    800011ee:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011f2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011f6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011fa:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011fe:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001202:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001206:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000120a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000120e:	0004ac23          	sw	zero,24(s1)
}
    80001212:	60e2                	ld	ra,24(sp)
    80001214:	6442                	ld	s0,16(sp)
    80001216:	64a2                	ld	s1,8(sp)
    80001218:	6105                	addi	sp,sp,32
    8000121a:	8082                	ret

000000008000121c <allocproc>:
{
    8000121c:	1101                	addi	sp,sp,-32
    8000121e:	ec06                	sd	ra,24(sp)
    80001220:	e822                	sd	s0,16(sp)
    80001222:	e426                	sd	s1,8(sp)
    80001224:	e04a                	sd	s2,0(sp)
    80001226:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001228:	00028497          	auipc	s1,0x28
    8000122c:	25848493          	addi	s1,s1,600 # 80029480 <proc>
    80001230:	0002e917          	auipc	s2,0x2e
    80001234:	e5090913          	addi	s2,s2,-432 # 8002f080 <tickslock>
    acquire(&p->lock);
    80001238:	8526                	mv	a0,s1
    8000123a:	00005097          	auipc	ra,0x5
    8000123e:	194080e7          	jalr	404(ra) # 800063ce <acquire>
    if(p->state == UNUSED) {
    80001242:	4c9c                	lw	a5,24(s1)
    80001244:	cf81                	beqz	a5,8000125c <allocproc+0x40>
      release(&p->lock);
    80001246:	8526                	mv	a0,s1
    80001248:	00005097          	auipc	ra,0x5
    8000124c:	23a080e7          	jalr	570(ra) # 80006482 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001250:	17048493          	addi	s1,s1,368
    80001254:	ff2492e3          	bne	s1,s2,80001238 <allocproc+0x1c>
  return 0;
    80001258:	4481                	li	s1,0
    8000125a:	a889                	j	800012ac <allocproc+0x90>
  p->pid = allocpid();
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	e34080e7          	jalr	-460(ra) # 80001090 <allocpid>
    80001264:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001266:	4785                	li	a5,1
    80001268:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000126a:	fffff097          	auipc	ra,0xfffff
    8000126e:	f48080e7          	jalr	-184(ra) # 800001b2 <kalloc>
    80001272:	892a                	mv	s2,a0
    80001274:	f0a8                	sd	a0,96(s1)
    80001276:	c131                	beqz	a0,800012ba <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001278:	8526                	mv	a0,s1
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e5c080e7          	jalr	-420(ra) # 800010d6 <proc_pagetable>
    80001282:	892a                	mv	s2,a0
    80001284:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001286:	c531                	beqz	a0,800012d2 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001288:	07000613          	li	a2,112
    8000128c:	4581                	li	a1,0
    8000128e:	06848513          	addi	a0,s1,104
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	f98080e7          	jalr	-104(ra) # 8000022a <memset>
  p->context.ra = (uint64)forkret;
    8000129a:	00000797          	auipc	a5,0x0
    8000129e:	db078793          	addi	a5,a5,-592 # 8000104a <forkret>
    800012a2:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012a4:	60bc                	ld	a5,64(s1)
    800012a6:	6705                	lui	a4,0x1
    800012a8:	97ba                	add	a5,a5,a4
    800012aa:	f8bc                	sd	a5,112(s1)
}
    800012ac:	8526                	mv	a0,s1
    800012ae:	60e2                	ld	ra,24(sp)
    800012b0:	6442                	ld	s0,16(sp)
    800012b2:	64a2                	ld	s1,8(sp)
    800012b4:	6902                	ld	s2,0(sp)
    800012b6:	6105                	addi	sp,sp,32
    800012b8:	8082                	ret
    freeproc(p);
    800012ba:	8526                	mv	a0,s1
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	f08080e7          	jalr	-248(ra) # 800011c4 <freeproc>
    release(&p->lock);
    800012c4:	8526                	mv	a0,s1
    800012c6:	00005097          	auipc	ra,0x5
    800012ca:	1bc080e7          	jalr	444(ra) # 80006482 <release>
    return 0;
    800012ce:	84ca                	mv	s1,s2
    800012d0:	bff1                	j	800012ac <allocproc+0x90>
    freeproc(p);
    800012d2:	8526                	mv	a0,s1
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	ef0080e7          	jalr	-272(ra) # 800011c4 <freeproc>
    release(&p->lock);
    800012dc:	8526                	mv	a0,s1
    800012de:	00005097          	auipc	ra,0x5
    800012e2:	1a4080e7          	jalr	420(ra) # 80006482 <release>
    return 0;
    800012e6:	84ca                	mv	s1,s2
    800012e8:	b7d1                	j	800012ac <allocproc+0x90>

00000000800012ea <userinit>:
{
    800012ea:	1101                	addi	sp,sp,-32
    800012ec:	ec06                	sd	ra,24(sp)
    800012ee:	e822                	sd	s0,16(sp)
    800012f0:	e426                	sd	s1,8(sp)
    800012f2:	1000                	addi	s0,sp,32
  p = allocproc();
    800012f4:	00000097          	auipc	ra,0x0
    800012f8:	f28080e7          	jalr	-216(ra) # 8000121c <allocproc>
    800012fc:	84aa                	mv	s1,a0
  initproc = p;
    800012fe:	00008797          	auipc	a5,0x8
    80001302:	d0a7b923          	sd	a0,-750(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001306:	03400613          	li	a2,52
    8000130a:	00007597          	auipc	a1,0x7
    8000130e:	5b658593          	addi	a1,a1,1462 # 800088c0 <initcode>
    80001312:	6928                	ld	a0,80(a0)
    80001314:	fffff097          	auipc	ra,0xfffff
    80001318:	59e080e7          	jalr	1438(ra) # 800008b2 <uvminit>
  p->sz = PGSIZE;
    8000131c:	6785                	lui	a5,0x1
    8000131e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001320:	70b8                	ld	a4,96(s1)
    80001322:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001326:	70b8                	ld	a4,96(s1)
    80001328:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000132a:	4641                	li	a2,16
    8000132c:	00007597          	auipc	a1,0x7
    80001330:	eb458593          	addi	a1,a1,-332 # 800081e0 <etext+0x1e0>
    80001334:	16048513          	addi	a0,s1,352
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	044080e7          	jalr	68(ra) # 8000037c <safestrcpy>
  p->cwd = namei("/");
    80001340:	00007517          	auipc	a0,0x7
    80001344:	eb050513          	addi	a0,a0,-336 # 800081f0 <etext+0x1f0>
    80001348:	00002097          	auipc	ra,0x2
    8000134c:	1ce080e7          	jalr	462(ra) # 80003516 <namei>
    80001350:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001354:	478d                	li	a5,3
    80001356:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001358:	8526                	mv	a0,s1
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	128080e7          	jalr	296(ra) # 80006482 <release>
}
    80001362:	60e2                	ld	ra,24(sp)
    80001364:	6442                	ld	s0,16(sp)
    80001366:	64a2                	ld	s1,8(sp)
    80001368:	6105                	addi	sp,sp,32
    8000136a:	8082                	ret

000000008000136c <growproc>:
{
    8000136c:	1101                	addi	sp,sp,-32
    8000136e:	ec06                	sd	ra,24(sp)
    80001370:	e822                	sd	s0,16(sp)
    80001372:	e426                	sd	s1,8(sp)
    80001374:	e04a                	sd	s2,0(sp)
    80001376:	1000                	addi	s0,sp,32
    80001378:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000137a:	00000097          	auipc	ra,0x0
    8000137e:	c98080e7          	jalr	-872(ra) # 80001012 <myproc>
    80001382:	892a                	mv	s2,a0
  sz = p->sz;
    80001384:	652c                	ld	a1,72(a0)
    80001386:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000138a:	00904f63          	bgtz	s1,800013a8 <growproc+0x3c>
  } else if(n < 0){
    8000138e:	0204cc63          	bltz	s1,800013c6 <growproc+0x5a>
  p->sz = sz;
    80001392:	1602                	slli	a2,a2,0x20
    80001394:	9201                	srli	a2,a2,0x20
    80001396:	04c93423          	sd	a2,72(s2)
  return 0;
    8000139a:	4501                	li	a0,0
}
    8000139c:	60e2                	ld	ra,24(sp)
    8000139e:	6442                	ld	s0,16(sp)
    800013a0:	64a2                	ld	s1,8(sp)
    800013a2:	6902                	ld	s2,0(sp)
    800013a4:	6105                	addi	sp,sp,32
    800013a6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013a8:	9e25                	addw	a2,a2,s1
    800013aa:	1602                	slli	a2,a2,0x20
    800013ac:	9201                	srli	a2,a2,0x20
    800013ae:	1582                	slli	a1,a1,0x20
    800013b0:	9181                	srli	a1,a1,0x20
    800013b2:	6928                	ld	a0,80(a0)
    800013b4:	fffff097          	auipc	ra,0xfffff
    800013b8:	5b8080e7          	jalr	1464(ra) # 8000096c <uvmalloc>
    800013bc:	0005061b          	sext.w	a2,a0
    800013c0:	fa69                	bnez	a2,80001392 <growproc+0x26>
      return -1;
    800013c2:	557d                	li	a0,-1
    800013c4:	bfe1                	j	8000139c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013c6:	9e25                	addw	a2,a2,s1
    800013c8:	1602                	slli	a2,a2,0x20
    800013ca:	9201                	srli	a2,a2,0x20
    800013cc:	1582                	slli	a1,a1,0x20
    800013ce:	9181                	srli	a1,a1,0x20
    800013d0:	6928                	ld	a0,80(a0)
    800013d2:	fffff097          	auipc	ra,0xfffff
    800013d6:	552080e7          	jalr	1362(ra) # 80000924 <uvmdealloc>
    800013da:	0005061b          	sext.w	a2,a0
    800013de:	bf55                	j	80001392 <growproc+0x26>

00000000800013e0 <fork>:
{
    800013e0:	7179                	addi	sp,sp,-48
    800013e2:	f406                	sd	ra,40(sp)
    800013e4:	f022                	sd	s0,32(sp)
    800013e6:	ec26                	sd	s1,24(sp)
    800013e8:	e84a                	sd	s2,16(sp)
    800013ea:	e44e                	sd	s3,8(sp)
    800013ec:	e052                	sd	s4,0(sp)
    800013ee:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	c22080e7          	jalr	-990(ra) # 80001012 <myproc>
    800013f8:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013fa:	00000097          	auipc	ra,0x0
    800013fe:	e22080e7          	jalr	-478(ra) # 8000121c <allocproc>
    80001402:	10050b63          	beqz	a0,80001518 <fork+0x138>
    80001406:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001408:	04893603          	ld	a2,72(s2)
    8000140c:	692c                	ld	a1,80(a0)
    8000140e:	05093503          	ld	a0,80(s2)
    80001412:	fffff097          	auipc	ra,0xfffff
    80001416:	6a6080e7          	jalr	1702(ra) # 80000ab8 <uvmcopy>
    8000141a:	04054663          	bltz	a0,80001466 <fork+0x86>
  np->sz = p->sz;
    8000141e:	04893783          	ld	a5,72(s2)
    80001422:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001426:	06093683          	ld	a3,96(s2)
    8000142a:	87b6                	mv	a5,a3
    8000142c:	0609b703          	ld	a4,96(s3)
    80001430:	12068693          	addi	a3,a3,288
    80001434:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001438:	6788                	ld	a0,8(a5)
    8000143a:	6b8c                	ld	a1,16(a5)
    8000143c:	6f90                	ld	a2,24(a5)
    8000143e:	01073023          	sd	a6,0(a4)
    80001442:	e708                	sd	a0,8(a4)
    80001444:	eb0c                	sd	a1,16(a4)
    80001446:	ef10                	sd	a2,24(a4)
    80001448:	02078793          	addi	a5,a5,32
    8000144c:	02070713          	addi	a4,a4,32
    80001450:	fed792e3          	bne	a5,a3,80001434 <fork+0x54>
  np->trapframe->a0 = 0;
    80001454:	0609b783          	ld	a5,96(s3)
    80001458:	0607b823          	sd	zero,112(a5)
    8000145c:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001460:	15800a13          	li	s4,344
    80001464:	a03d                	j	80001492 <fork+0xb2>
    freeproc(np);
    80001466:	854e                	mv	a0,s3
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	d5c080e7          	jalr	-676(ra) # 800011c4 <freeproc>
    release(&np->lock);
    80001470:	854e                	mv	a0,s3
    80001472:	00005097          	auipc	ra,0x5
    80001476:	010080e7          	jalr	16(ra) # 80006482 <release>
    return -1;
    8000147a:	5a7d                	li	s4,-1
    8000147c:	a069                	j	80001506 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000147e:	00002097          	auipc	ra,0x2
    80001482:	72e080e7          	jalr	1838(ra) # 80003bac <filedup>
    80001486:	009987b3          	add	a5,s3,s1
    8000148a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000148c:	04a1                	addi	s1,s1,8
    8000148e:	01448763          	beq	s1,s4,8000149c <fork+0xbc>
    if(p->ofile[i])
    80001492:	009907b3          	add	a5,s2,s1
    80001496:	6388                	ld	a0,0(a5)
    80001498:	f17d                	bnez	a0,8000147e <fork+0x9e>
    8000149a:	bfcd                	j	8000148c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000149c:	15893503          	ld	a0,344(s2)
    800014a0:	00002097          	auipc	ra,0x2
    800014a4:	882080e7          	jalr	-1918(ra) # 80002d22 <idup>
    800014a8:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014ac:	4641                	li	a2,16
    800014ae:	16090593          	addi	a1,s2,352
    800014b2:	16098513          	addi	a0,s3,352
    800014b6:	fffff097          	auipc	ra,0xfffff
    800014ba:	ec6080e7          	jalr	-314(ra) # 8000037c <safestrcpy>
  pid = np->pid;
    800014be:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014c2:	854e                	mv	a0,s3
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	fbe080e7          	jalr	-66(ra) # 80006482 <release>
  acquire(&wait_lock);
    800014cc:	00028497          	auipc	s1,0x28
    800014d0:	b9c48493          	addi	s1,s1,-1124 # 80029068 <wait_lock>
    800014d4:	8526                	mv	a0,s1
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	ef8080e7          	jalr	-264(ra) # 800063ce <acquire>
  np->parent = p;
    800014de:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014e2:	8526                	mv	a0,s1
    800014e4:	00005097          	auipc	ra,0x5
    800014e8:	f9e080e7          	jalr	-98(ra) # 80006482 <release>
  acquire(&np->lock);
    800014ec:	854e                	mv	a0,s3
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	ee0080e7          	jalr	-288(ra) # 800063ce <acquire>
  np->state = RUNNABLE;
    800014f6:	478d                	li	a5,3
    800014f8:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014fc:	854e                	mv	a0,s3
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	f84080e7          	jalr	-124(ra) # 80006482 <release>
}
    80001506:	8552                	mv	a0,s4
    80001508:	70a2                	ld	ra,40(sp)
    8000150a:	7402                	ld	s0,32(sp)
    8000150c:	64e2                	ld	s1,24(sp)
    8000150e:	6942                	ld	s2,16(sp)
    80001510:	69a2                	ld	s3,8(sp)
    80001512:	6a02                	ld	s4,0(sp)
    80001514:	6145                	addi	sp,sp,48
    80001516:	8082                	ret
    return -1;
    80001518:	5a7d                	li	s4,-1
    8000151a:	b7f5                	j	80001506 <fork+0x126>

000000008000151c <scheduler>:
{
    8000151c:	7139                	addi	sp,sp,-64
    8000151e:	fc06                	sd	ra,56(sp)
    80001520:	f822                	sd	s0,48(sp)
    80001522:	f426                	sd	s1,40(sp)
    80001524:	f04a                	sd	s2,32(sp)
    80001526:	ec4e                	sd	s3,24(sp)
    80001528:	e852                	sd	s4,16(sp)
    8000152a:	e456                	sd	s5,8(sp)
    8000152c:	e05a                	sd	s6,0(sp)
    8000152e:	0080                	addi	s0,sp,64
    80001530:	8792                	mv	a5,tp
  int id = r_tp();
    80001532:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001534:	00779a93          	slli	s5,a5,0x7
    80001538:	00028717          	auipc	a4,0x28
    8000153c:	b1870713          	addi	a4,a4,-1256 # 80029050 <pid_lock>
    80001540:	9756                	add	a4,a4,s5
    80001542:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001546:	00028717          	auipc	a4,0x28
    8000154a:	b4270713          	addi	a4,a4,-1214 # 80029088 <cpus+0x8>
    8000154e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001550:	498d                	li	s3,3
        p->state = RUNNING;
    80001552:	4b11                	li	s6,4
        c->proc = p;
    80001554:	079e                	slli	a5,a5,0x7
    80001556:	00028a17          	auipc	s4,0x28
    8000155a:	afaa0a13          	addi	s4,s4,-1286 # 80029050 <pid_lock>
    8000155e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001560:	0002e917          	auipc	s2,0x2e
    80001564:	b2090913          	addi	s2,s2,-1248 # 8002f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001568:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000156c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001570:	10079073          	csrw	sstatus,a5
    80001574:	00028497          	auipc	s1,0x28
    80001578:	f0c48493          	addi	s1,s1,-244 # 80029480 <proc>
    8000157c:	a03d                	j	800015aa <scheduler+0x8e>
        p->state = RUNNING;
    8000157e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001582:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001586:	06848593          	addi	a1,s1,104
    8000158a:	8556                	mv	a0,s5
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	640080e7          	jalr	1600(ra) # 80001bcc <swtch>
        c->proc = 0;
    80001594:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	ee8080e7          	jalr	-280(ra) # 80006482 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015a2:	17048493          	addi	s1,s1,368
    800015a6:	fd2481e3          	beq	s1,s2,80001568 <scheduler+0x4c>
      acquire(&p->lock);
    800015aa:	8526                	mv	a0,s1
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	e22080e7          	jalr	-478(ra) # 800063ce <acquire>
      if(p->state == RUNNABLE) {
    800015b4:	4c9c                	lw	a5,24(s1)
    800015b6:	ff3791e3          	bne	a5,s3,80001598 <scheduler+0x7c>
    800015ba:	b7d1                	j	8000157e <scheduler+0x62>

00000000800015bc <sched>:
{
    800015bc:	7179                	addi	sp,sp,-48
    800015be:	f406                	sd	ra,40(sp)
    800015c0:	f022                	sd	s0,32(sp)
    800015c2:	ec26                	sd	s1,24(sp)
    800015c4:	e84a                	sd	s2,16(sp)
    800015c6:	e44e                	sd	s3,8(sp)
    800015c8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	a48080e7          	jalr	-1464(ra) # 80001012 <myproc>
    800015d2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015d4:	00005097          	auipc	ra,0x5
    800015d8:	d80080e7          	jalr	-640(ra) # 80006354 <holding>
    800015dc:	c93d                	beqz	a0,80001652 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015de:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015e0:	2781                	sext.w	a5,a5
    800015e2:	079e                	slli	a5,a5,0x7
    800015e4:	00028717          	auipc	a4,0x28
    800015e8:	a6c70713          	addi	a4,a4,-1428 # 80029050 <pid_lock>
    800015ec:	97ba                	add	a5,a5,a4
    800015ee:	0a87a703          	lw	a4,168(a5)
    800015f2:	4785                	li	a5,1
    800015f4:	06f71763          	bne	a4,a5,80001662 <sched+0xa6>
  if(p->state == RUNNING)
    800015f8:	4c98                	lw	a4,24(s1)
    800015fa:	4791                	li	a5,4
    800015fc:	06f70b63          	beq	a4,a5,80001672 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001600:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001604:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001606:	efb5                	bnez	a5,80001682 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001608:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000160a:	00028917          	auipc	s2,0x28
    8000160e:	a4690913          	addi	s2,s2,-1466 # 80029050 <pid_lock>
    80001612:	2781                	sext.w	a5,a5
    80001614:	079e                	slli	a5,a5,0x7
    80001616:	97ca                	add	a5,a5,s2
    80001618:	0ac7a983          	lw	s3,172(a5)
    8000161c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000161e:	2781                	sext.w	a5,a5
    80001620:	079e                	slli	a5,a5,0x7
    80001622:	00028597          	auipc	a1,0x28
    80001626:	a6658593          	addi	a1,a1,-1434 # 80029088 <cpus+0x8>
    8000162a:	95be                	add	a1,a1,a5
    8000162c:	06848513          	addi	a0,s1,104
    80001630:	00000097          	auipc	ra,0x0
    80001634:	59c080e7          	jalr	1436(ra) # 80001bcc <swtch>
    80001638:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000163a:	2781                	sext.w	a5,a5
    8000163c:	079e                	slli	a5,a5,0x7
    8000163e:	97ca                	add	a5,a5,s2
    80001640:	0b37a623          	sw	s3,172(a5)
}
    80001644:	70a2                	ld	ra,40(sp)
    80001646:	7402                	ld	s0,32(sp)
    80001648:	64e2                	ld	s1,24(sp)
    8000164a:	6942                	ld	s2,16(sp)
    8000164c:	69a2                	ld	s3,8(sp)
    8000164e:	6145                	addi	sp,sp,48
    80001650:	8082                	ret
    panic("sched p->lock");
    80001652:	00007517          	auipc	a0,0x7
    80001656:	ba650513          	addi	a0,a0,-1114 # 800081f8 <etext+0x1f8>
    8000165a:	00004097          	auipc	ra,0x4
    8000165e:	7be080e7          	jalr	1982(ra) # 80005e18 <panic>
    panic("sched locks");
    80001662:	00007517          	auipc	a0,0x7
    80001666:	ba650513          	addi	a0,a0,-1114 # 80008208 <etext+0x208>
    8000166a:	00004097          	auipc	ra,0x4
    8000166e:	7ae080e7          	jalr	1966(ra) # 80005e18 <panic>
    panic("sched running");
    80001672:	00007517          	auipc	a0,0x7
    80001676:	ba650513          	addi	a0,a0,-1114 # 80008218 <etext+0x218>
    8000167a:	00004097          	auipc	ra,0x4
    8000167e:	79e080e7          	jalr	1950(ra) # 80005e18 <panic>
    panic("sched interruptible");
    80001682:	00007517          	auipc	a0,0x7
    80001686:	ba650513          	addi	a0,a0,-1114 # 80008228 <etext+0x228>
    8000168a:	00004097          	auipc	ra,0x4
    8000168e:	78e080e7          	jalr	1934(ra) # 80005e18 <panic>

0000000080001692 <yield>:
{
    80001692:	1101                	addi	sp,sp,-32
    80001694:	ec06                	sd	ra,24(sp)
    80001696:	e822                	sd	s0,16(sp)
    80001698:	e426                	sd	s1,8(sp)
    8000169a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000169c:	00000097          	auipc	ra,0x0
    800016a0:	976080e7          	jalr	-1674(ra) # 80001012 <myproc>
    800016a4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	d28080e7          	jalr	-728(ra) # 800063ce <acquire>
  p->state = RUNNABLE;
    800016ae:	478d                	li	a5,3
    800016b0:	cc9c                	sw	a5,24(s1)
  sched();
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	f0a080e7          	jalr	-246(ra) # 800015bc <sched>
  release(&p->lock);
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	dc6080e7          	jalr	-570(ra) # 80006482 <release>
}
    800016c4:	60e2                	ld	ra,24(sp)
    800016c6:	6442                	ld	s0,16(sp)
    800016c8:	64a2                	ld	s1,8(sp)
    800016ca:	6105                	addi	sp,sp,32
    800016cc:	8082                	ret

00000000800016ce <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016ce:	7179                	addi	sp,sp,-48
    800016d0:	f406                	sd	ra,40(sp)
    800016d2:	f022                	sd	s0,32(sp)
    800016d4:	ec26                	sd	s1,24(sp)
    800016d6:	e84a                	sd	s2,16(sp)
    800016d8:	e44e                	sd	s3,8(sp)
    800016da:	1800                	addi	s0,sp,48
    800016dc:	89aa                	mv	s3,a0
    800016de:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016e0:	00000097          	auipc	ra,0x0
    800016e4:	932080e7          	jalr	-1742(ra) # 80001012 <myproc>
    800016e8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	ce4080e7          	jalr	-796(ra) # 800063ce <acquire>
  release(lk);
    800016f2:	854a                	mv	a0,s2
    800016f4:	00005097          	auipc	ra,0x5
    800016f8:	d8e080e7          	jalr	-626(ra) # 80006482 <release>

  // Go to sleep.
  p->chan = chan;
    800016fc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001700:	4789                	li	a5,2
    80001702:	cc9c                	sw	a5,24(s1)

  sched();
    80001704:	00000097          	auipc	ra,0x0
    80001708:	eb8080e7          	jalr	-328(ra) # 800015bc <sched>

  // Tidy up.
  p->chan = 0;
    8000170c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	d70080e7          	jalr	-656(ra) # 80006482 <release>
  acquire(lk);
    8000171a:	854a                	mv	a0,s2
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	cb2080e7          	jalr	-846(ra) # 800063ce <acquire>
}
    80001724:	70a2                	ld	ra,40(sp)
    80001726:	7402                	ld	s0,32(sp)
    80001728:	64e2                	ld	s1,24(sp)
    8000172a:	6942                	ld	s2,16(sp)
    8000172c:	69a2                	ld	s3,8(sp)
    8000172e:	6145                	addi	sp,sp,48
    80001730:	8082                	ret

0000000080001732 <wait>:
{
    80001732:	715d                	addi	sp,sp,-80
    80001734:	e486                	sd	ra,72(sp)
    80001736:	e0a2                	sd	s0,64(sp)
    80001738:	fc26                	sd	s1,56(sp)
    8000173a:	f84a                	sd	s2,48(sp)
    8000173c:	f44e                	sd	s3,40(sp)
    8000173e:	f052                	sd	s4,32(sp)
    80001740:	ec56                	sd	s5,24(sp)
    80001742:	e85a                	sd	s6,16(sp)
    80001744:	e45e                	sd	s7,8(sp)
    80001746:	e062                	sd	s8,0(sp)
    80001748:	0880                	addi	s0,sp,80
    8000174a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	8c6080e7          	jalr	-1850(ra) # 80001012 <myproc>
    80001754:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001756:	00028517          	auipc	a0,0x28
    8000175a:	91250513          	addi	a0,a0,-1774 # 80029068 <wait_lock>
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	c70080e7          	jalr	-912(ra) # 800063ce <acquire>
    havekids = 0;
    80001766:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001768:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000176a:	0002e997          	auipc	s3,0x2e
    8000176e:	91698993          	addi	s3,s3,-1770 # 8002f080 <tickslock>
        havekids = 1;
    80001772:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001774:	00028c17          	auipc	s8,0x28
    80001778:	8f4c0c13          	addi	s8,s8,-1804 # 80029068 <wait_lock>
    havekids = 0;
    8000177c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000177e:	00028497          	auipc	s1,0x28
    80001782:	d0248493          	addi	s1,s1,-766 # 80029480 <proc>
    80001786:	a0bd                	j	800017f4 <wait+0xc2>
          pid = np->pid;
    80001788:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000178c:	000b0e63          	beqz	s6,800017a8 <wait+0x76>
    80001790:	4691                	li	a3,4
    80001792:	02c48613          	addi	a2,s1,44
    80001796:	85da                	mv	a1,s6
    80001798:	05093503          	ld	a0,80(s2)
    8000179c:	fffff097          	auipc	ra,0xfffff
    800017a0:	408080e7          	jalr	1032(ra) # 80000ba4 <copyout>
    800017a4:	02054563          	bltz	a0,800017ce <wait+0x9c>
          freeproc(np);
    800017a8:	8526                	mv	a0,s1
    800017aa:	00000097          	auipc	ra,0x0
    800017ae:	a1a080e7          	jalr	-1510(ra) # 800011c4 <freeproc>
          release(&np->lock);
    800017b2:	8526                	mv	a0,s1
    800017b4:	00005097          	auipc	ra,0x5
    800017b8:	cce080e7          	jalr	-818(ra) # 80006482 <release>
          release(&wait_lock);
    800017bc:	00028517          	auipc	a0,0x28
    800017c0:	8ac50513          	addi	a0,a0,-1876 # 80029068 <wait_lock>
    800017c4:	00005097          	auipc	ra,0x5
    800017c8:	cbe080e7          	jalr	-834(ra) # 80006482 <release>
          return pid;
    800017cc:	a09d                	j	80001832 <wait+0x100>
            release(&np->lock);
    800017ce:	8526                	mv	a0,s1
    800017d0:	00005097          	auipc	ra,0x5
    800017d4:	cb2080e7          	jalr	-846(ra) # 80006482 <release>
            release(&wait_lock);
    800017d8:	00028517          	auipc	a0,0x28
    800017dc:	89050513          	addi	a0,a0,-1904 # 80029068 <wait_lock>
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	ca2080e7          	jalr	-862(ra) # 80006482 <release>
            return -1;
    800017e8:	59fd                	li	s3,-1
    800017ea:	a0a1                	j	80001832 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017ec:	17048493          	addi	s1,s1,368
    800017f0:	03348463          	beq	s1,s3,80001818 <wait+0xe6>
      if(np->parent == p){
    800017f4:	7c9c                	ld	a5,56(s1)
    800017f6:	ff279be3          	bne	a5,s2,800017ec <wait+0xba>
        acquire(&np->lock);
    800017fa:	8526                	mv	a0,s1
    800017fc:	00005097          	auipc	ra,0x5
    80001800:	bd2080e7          	jalr	-1070(ra) # 800063ce <acquire>
        if(np->state == ZOMBIE){
    80001804:	4c9c                	lw	a5,24(s1)
    80001806:	f94781e3          	beq	a5,s4,80001788 <wait+0x56>
        release(&np->lock);
    8000180a:	8526                	mv	a0,s1
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	c76080e7          	jalr	-906(ra) # 80006482 <release>
        havekids = 1;
    80001814:	8756                	mv	a4,s5
    80001816:	bfd9                	j	800017ec <wait+0xba>
    if(!havekids || p->killed){
    80001818:	c701                	beqz	a4,80001820 <wait+0xee>
    8000181a:	02892783          	lw	a5,40(s2)
    8000181e:	c79d                	beqz	a5,8000184c <wait+0x11a>
      release(&wait_lock);
    80001820:	00028517          	auipc	a0,0x28
    80001824:	84850513          	addi	a0,a0,-1976 # 80029068 <wait_lock>
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	c5a080e7          	jalr	-934(ra) # 80006482 <release>
      return -1;
    80001830:	59fd                	li	s3,-1
}
    80001832:	854e                	mv	a0,s3
    80001834:	60a6                	ld	ra,72(sp)
    80001836:	6406                	ld	s0,64(sp)
    80001838:	74e2                	ld	s1,56(sp)
    8000183a:	7942                	ld	s2,48(sp)
    8000183c:	79a2                	ld	s3,40(sp)
    8000183e:	7a02                	ld	s4,32(sp)
    80001840:	6ae2                	ld	s5,24(sp)
    80001842:	6b42                	ld	s6,16(sp)
    80001844:	6ba2                	ld	s7,8(sp)
    80001846:	6c02                	ld	s8,0(sp)
    80001848:	6161                	addi	sp,sp,80
    8000184a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000184c:	85e2                	mv	a1,s8
    8000184e:	854a                	mv	a0,s2
    80001850:	00000097          	auipc	ra,0x0
    80001854:	e7e080e7          	jalr	-386(ra) # 800016ce <sleep>
    havekids = 0;
    80001858:	b715                	j	8000177c <wait+0x4a>

000000008000185a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000185a:	7139                	addi	sp,sp,-64
    8000185c:	fc06                	sd	ra,56(sp)
    8000185e:	f822                	sd	s0,48(sp)
    80001860:	f426                	sd	s1,40(sp)
    80001862:	f04a                	sd	s2,32(sp)
    80001864:	ec4e                	sd	s3,24(sp)
    80001866:	e852                	sd	s4,16(sp)
    80001868:	e456                	sd	s5,8(sp)
    8000186a:	0080                	addi	s0,sp,64
    8000186c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000186e:	00028497          	auipc	s1,0x28
    80001872:	c1248493          	addi	s1,s1,-1006 # 80029480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001876:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001878:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187a:	0002e917          	auipc	s2,0x2e
    8000187e:	80690913          	addi	s2,s2,-2042 # 8002f080 <tickslock>
    80001882:	a821                	j	8000189a <wakeup+0x40>
        p->state = RUNNABLE;
    80001884:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001888:	8526                	mv	a0,s1
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	bf8080e7          	jalr	-1032(ra) # 80006482 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001892:	17048493          	addi	s1,s1,368
    80001896:	03248463          	beq	s1,s2,800018be <wakeup+0x64>
    if(p != myproc()){
    8000189a:	fffff097          	auipc	ra,0xfffff
    8000189e:	778080e7          	jalr	1912(ra) # 80001012 <myproc>
    800018a2:	fea488e3          	beq	s1,a0,80001892 <wakeup+0x38>
      acquire(&p->lock);
    800018a6:	8526                	mv	a0,s1
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	b26080e7          	jalr	-1242(ra) # 800063ce <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018b0:	4c9c                	lw	a5,24(s1)
    800018b2:	fd379be3          	bne	a5,s3,80001888 <wakeup+0x2e>
    800018b6:	709c                	ld	a5,32(s1)
    800018b8:	fd4798e3          	bne	a5,s4,80001888 <wakeup+0x2e>
    800018bc:	b7e1                	j	80001884 <wakeup+0x2a>
    }
  }
}
    800018be:	70e2                	ld	ra,56(sp)
    800018c0:	7442                	ld	s0,48(sp)
    800018c2:	74a2                	ld	s1,40(sp)
    800018c4:	7902                	ld	s2,32(sp)
    800018c6:	69e2                	ld	s3,24(sp)
    800018c8:	6a42                	ld	s4,16(sp)
    800018ca:	6aa2                	ld	s5,8(sp)
    800018cc:	6121                	addi	sp,sp,64
    800018ce:	8082                	ret

00000000800018d0 <reparent>:
{
    800018d0:	7179                	addi	sp,sp,-48
    800018d2:	f406                	sd	ra,40(sp)
    800018d4:	f022                	sd	s0,32(sp)
    800018d6:	ec26                	sd	s1,24(sp)
    800018d8:	e84a                	sd	s2,16(sp)
    800018da:	e44e                	sd	s3,8(sp)
    800018dc:	e052                	sd	s4,0(sp)
    800018de:	1800                	addi	s0,sp,48
    800018e0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e2:	00028497          	auipc	s1,0x28
    800018e6:	b9e48493          	addi	s1,s1,-1122 # 80029480 <proc>
      pp->parent = initproc;
    800018ea:	00007a17          	auipc	s4,0x7
    800018ee:	726a0a13          	addi	s4,s4,1830 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f2:	0002d997          	auipc	s3,0x2d
    800018f6:	78e98993          	addi	s3,s3,1934 # 8002f080 <tickslock>
    800018fa:	a029                	j	80001904 <reparent+0x34>
    800018fc:	17048493          	addi	s1,s1,368
    80001900:	01348d63          	beq	s1,s3,8000191a <reparent+0x4a>
    if(pp->parent == p){
    80001904:	7c9c                	ld	a5,56(s1)
    80001906:	ff279be3          	bne	a5,s2,800018fc <reparent+0x2c>
      pp->parent = initproc;
    8000190a:	000a3503          	ld	a0,0(s4)
    8000190e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001910:	00000097          	auipc	ra,0x0
    80001914:	f4a080e7          	jalr	-182(ra) # 8000185a <wakeup>
    80001918:	b7d5                	j	800018fc <reparent+0x2c>
}
    8000191a:	70a2                	ld	ra,40(sp)
    8000191c:	7402                	ld	s0,32(sp)
    8000191e:	64e2                	ld	s1,24(sp)
    80001920:	6942                	ld	s2,16(sp)
    80001922:	69a2                	ld	s3,8(sp)
    80001924:	6a02                	ld	s4,0(sp)
    80001926:	6145                	addi	sp,sp,48
    80001928:	8082                	ret

000000008000192a <exit>:
{
    8000192a:	7179                	addi	sp,sp,-48
    8000192c:	f406                	sd	ra,40(sp)
    8000192e:	f022                	sd	s0,32(sp)
    80001930:	ec26                	sd	s1,24(sp)
    80001932:	e84a                	sd	s2,16(sp)
    80001934:	e44e                	sd	s3,8(sp)
    80001936:	e052                	sd	s4,0(sp)
    80001938:	1800                	addi	s0,sp,48
    8000193a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	6d6080e7          	jalr	1750(ra) # 80001012 <myproc>
    80001944:	89aa                	mv	s3,a0
  if(p == initproc)
    80001946:	00007797          	auipc	a5,0x7
    8000194a:	6ca7b783          	ld	a5,1738(a5) # 80009010 <initproc>
    8000194e:	0d850493          	addi	s1,a0,216
    80001952:	15850913          	addi	s2,a0,344
    80001956:	02a79363          	bne	a5,a0,8000197c <exit+0x52>
    panic("init exiting");
    8000195a:	00007517          	auipc	a0,0x7
    8000195e:	8e650513          	addi	a0,a0,-1818 # 80008240 <etext+0x240>
    80001962:	00004097          	auipc	ra,0x4
    80001966:	4b6080e7          	jalr	1206(ra) # 80005e18 <panic>
      fileclose(f);
    8000196a:	00002097          	auipc	ra,0x2
    8000196e:	294080e7          	jalr	660(ra) # 80003bfe <fileclose>
      p->ofile[fd] = 0;
    80001972:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001976:	04a1                	addi	s1,s1,8
    80001978:	01248563          	beq	s1,s2,80001982 <exit+0x58>
    if(p->ofile[fd]){
    8000197c:	6088                	ld	a0,0(s1)
    8000197e:	f575                	bnez	a0,8000196a <exit+0x40>
    80001980:	bfdd                	j	80001976 <exit+0x4c>
  begin_op();
    80001982:	00002097          	auipc	ra,0x2
    80001986:	db0080e7          	jalr	-592(ra) # 80003732 <begin_op>
  iput(p->cwd);
    8000198a:	1589b503          	ld	a0,344(s3)
    8000198e:	00001097          	auipc	ra,0x1
    80001992:	58c080e7          	jalr	1420(ra) # 80002f1a <iput>
  end_op();
    80001996:	00002097          	auipc	ra,0x2
    8000199a:	e1c080e7          	jalr	-484(ra) # 800037b2 <end_op>
  p->cwd = 0;
    8000199e:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019a2:	00027497          	auipc	s1,0x27
    800019a6:	6c648493          	addi	s1,s1,1734 # 80029068 <wait_lock>
    800019aa:	8526                	mv	a0,s1
    800019ac:	00005097          	auipc	ra,0x5
    800019b0:	a22080e7          	jalr	-1502(ra) # 800063ce <acquire>
  reparent(p);
    800019b4:	854e                	mv	a0,s3
    800019b6:	00000097          	auipc	ra,0x0
    800019ba:	f1a080e7          	jalr	-230(ra) # 800018d0 <reparent>
  wakeup(p->parent);
    800019be:	0389b503          	ld	a0,56(s3)
    800019c2:	00000097          	auipc	ra,0x0
    800019c6:	e98080e7          	jalr	-360(ra) # 8000185a <wakeup>
  acquire(&p->lock);
    800019ca:	854e                	mv	a0,s3
    800019cc:	00005097          	auipc	ra,0x5
    800019d0:	a02080e7          	jalr	-1534(ra) # 800063ce <acquire>
  p->xstate = status;
    800019d4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019d8:	4795                	li	a5,5
    800019da:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019de:	8526                	mv	a0,s1
    800019e0:	00005097          	auipc	ra,0x5
    800019e4:	aa2080e7          	jalr	-1374(ra) # 80006482 <release>
  sched();
    800019e8:	00000097          	auipc	ra,0x0
    800019ec:	bd4080e7          	jalr	-1068(ra) # 800015bc <sched>
  panic("zombie exit");
    800019f0:	00007517          	auipc	a0,0x7
    800019f4:	86050513          	addi	a0,a0,-1952 # 80008250 <etext+0x250>
    800019f8:	00004097          	auipc	ra,0x4
    800019fc:	420080e7          	jalr	1056(ra) # 80005e18 <panic>

0000000080001a00 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a00:	7179                	addi	sp,sp,-48
    80001a02:	f406                	sd	ra,40(sp)
    80001a04:	f022                	sd	s0,32(sp)
    80001a06:	ec26                	sd	s1,24(sp)
    80001a08:	e84a                	sd	s2,16(sp)
    80001a0a:	e44e                	sd	s3,8(sp)
    80001a0c:	1800                	addi	s0,sp,48
    80001a0e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a10:	00028497          	auipc	s1,0x28
    80001a14:	a7048493          	addi	s1,s1,-1424 # 80029480 <proc>
    80001a18:	0002d997          	auipc	s3,0x2d
    80001a1c:	66898993          	addi	s3,s3,1640 # 8002f080 <tickslock>
    acquire(&p->lock);
    80001a20:	8526                	mv	a0,s1
    80001a22:	00005097          	auipc	ra,0x5
    80001a26:	9ac080e7          	jalr	-1620(ra) # 800063ce <acquire>
    if(p->pid == pid){
    80001a2a:	589c                	lw	a5,48(s1)
    80001a2c:	01278d63          	beq	a5,s2,80001a46 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a30:	8526                	mv	a0,s1
    80001a32:	00005097          	auipc	ra,0x5
    80001a36:	a50080e7          	jalr	-1456(ra) # 80006482 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a3a:	17048493          	addi	s1,s1,368
    80001a3e:	ff3491e3          	bne	s1,s3,80001a20 <kill+0x20>
  }
  return -1;
    80001a42:	557d                	li	a0,-1
    80001a44:	a829                	j	80001a5e <kill+0x5e>
      p->killed = 1;
    80001a46:	4785                	li	a5,1
    80001a48:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a4a:	4c98                	lw	a4,24(s1)
    80001a4c:	4789                	li	a5,2
    80001a4e:	00f70f63          	beq	a4,a5,80001a6c <kill+0x6c>
      release(&p->lock);
    80001a52:	8526                	mv	a0,s1
    80001a54:	00005097          	auipc	ra,0x5
    80001a58:	a2e080e7          	jalr	-1490(ra) # 80006482 <release>
      return 0;
    80001a5c:	4501                	li	a0,0
}
    80001a5e:	70a2                	ld	ra,40(sp)
    80001a60:	7402                	ld	s0,32(sp)
    80001a62:	64e2                	ld	s1,24(sp)
    80001a64:	6942                	ld	s2,16(sp)
    80001a66:	69a2                	ld	s3,8(sp)
    80001a68:	6145                	addi	sp,sp,48
    80001a6a:	8082                	ret
        p->state = RUNNABLE;
    80001a6c:	478d                	li	a5,3
    80001a6e:	cc9c                	sw	a5,24(s1)
    80001a70:	b7cd                	j	80001a52 <kill+0x52>

0000000080001a72 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a72:	7179                	addi	sp,sp,-48
    80001a74:	f406                	sd	ra,40(sp)
    80001a76:	f022                	sd	s0,32(sp)
    80001a78:	ec26                	sd	s1,24(sp)
    80001a7a:	e84a                	sd	s2,16(sp)
    80001a7c:	e44e                	sd	s3,8(sp)
    80001a7e:	e052                	sd	s4,0(sp)
    80001a80:	1800                	addi	s0,sp,48
    80001a82:	84aa                	mv	s1,a0
    80001a84:	892e                	mv	s2,a1
    80001a86:	89b2                	mv	s3,a2
    80001a88:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a8a:	fffff097          	auipc	ra,0xfffff
    80001a8e:	588080e7          	jalr	1416(ra) # 80001012 <myproc>
  if(user_dst){
    80001a92:	c08d                	beqz	s1,80001ab4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a94:	86d2                	mv	a3,s4
    80001a96:	864e                	mv	a2,s3
    80001a98:	85ca                	mv	a1,s2
    80001a9a:	6928                	ld	a0,80(a0)
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	108080e7          	jalr	264(ra) # 80000ba4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aa4:	70a2                	ld	ra,40(sp)
    80001aa6:	7402                	ld	s0,32(sp)
    80001aa8:	64e2                	ld	s1,24(sp)
    80001aaa:	6942                	ld	s2,16(sp)
    80001aac:	69a2                	ld	s3,8(sp)
    80001aae:	6a02                	ld	s4,0(sp)
    80001ab0:	6145                	addi	sp,sp,48
    80001ab2:	8082                	ret
    memmove((char *)dst, src, len);
    80001ab4:	000a061b          	sext.w	a2,s4
    80001ab8:	85ce                	mv	a1,s3
    80001aba:	854a                	mv	a0,s2
    80001abc:	ffffe097          	auipc	ra,0xffffe
    80001ac0:	7ce080e7          	jalr	1998(ra) # 8000028a <memmove>
    return 0;
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	bff9                	j	80001aa4 <either_copyout+0x32>

0000000080001ac8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ac8:	7179                	addi	sp,sp,-48
    80001aca:	f406                	sd	ra,40(sp)
    80001acc:	f022                	sd	s0,32(sp)
    80001ace:	ec26                	sd	s1,24(sp)
    80001ad0:	e84a                	sd	s2,16(sp)
    80001ad2:	e44e                	sd	s3,8(sp)
    80001ad4:	e052                	sd	s4,0(sp)
    80001ad6:	1800                	addi	s0,sp,48
    80001ad8:	892a                	mv	s2,a0
    80001ada:	84ae                	mv	s1,a1
    80001adc:	89b2                	mv	s3,a2
    80001ade:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae0:	fffff097          	auipc	ra,0xfffff
    80001ae4:	532080e7          	jalr	1330(ra) # 80001012 <myproc>
  if(user_src){
    80001ae8:	c08d                	beqz	s1,80001b0a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aea:	86d2                	mv	a3,s4
    80001aec:	864e                	mv	a2,s3
    80001aee:	85ca                	mv	a1,s2
    80001af0:	6928                	ld	a0,80(a0)
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	13e080e7          	jalr	318(ra) # 80000c30 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001afa:	70a2                	ld	ra,40(sp)
    80001afc:	7402                	ld	s0,32(sp)
    80001afe:	64e2                	ld	s1,24(sp)
    80001b00:	6942                	ld	s2,16(sp)
    80001b02:	69a2                	ld	s3,8(sp)
    80001b04:	6a02                	ld	s4,0(sp)
    80001b06:	6145                	addi	sp,sp,48
    80001b08:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b0a:	000a061b          	sext.w	a2,s4
    80001b0e:	85ce                	mv	a1,s3
    80001b10:	854a                	mv	a0,s2
    80001b12:	ffffe097          	auipc	ra,0xffffe
    80001b16:	778080e7          	jalr	1912(ra) # 8000028a <memmove>
    return 0;
    80001b1a:	8526                	mv	a0,s1
    80001b1c:	bff9                	j	80001afa <either_copyin+0x32>

0000000080001b1e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b1e:	715d                	addi	sp,sp,-80
    80001b20:	e486                	sd	ra,72(sp)
    80001b22:	e0a2                	sd	s0,64(sp)
    80001b24:	fc26                	sd	s1,56(sp)
    80001b26:	f84a                	sd	s2,48(sp)
    80001b28:	f44e                	sd	s3,40(sp)
    80001b2a:	f052                	sd	s4,32(sp)
    80001b2c:	ec56                	sd	s5,24(sp)
    80001b2e:	e85a                	sd	s6,16(sp)
    80001b30:	e45e                	sd	s7,8(sp)
    80001b32:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b34:	00006517          	auipc	a0,0x6
    80001b38:	51450513          	addi	a0,a0,1300 # 80008048 <etext+0x48>
    80001b3c:	00004097          	auipc	ra,0x4
    80001b40:	326080e7          	jalr	806(ra) # 80005e62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b44:	00028497          	auipc	s1,0x28
    80001b48:	a9c48493          	addi	s1,s1,-1380 # 800295e0 <proc+0x160>
    80001b4c:	0002d917          	auipc	s2,0x2d
    80001b50:	69490913          	addi	s2,s2,1684 # 8002f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b54:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b56:	00006997          	auipc	s3,0x6
    80001b5a:	70a98993          	addi	s3,s3,1802 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80001b5e:	00006a97          	auipc	s5,0x6
    80001b62:	70aa8a93          	addi	s5,s5,1802 # 80008268 <etext+0x268>
    printf("\n");
    80001b66:	00006a17          	auipc	s4,0x6
    80001b6a:	4e2a0a13          	addi	s4,s4,1250 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b6e:	00006b97          	auipc	s7,0x6
    80001b72:	732b8b93          	addi	s7,s7,1842 # 800082a0 <states.1722>
    80001b76:	a00d                	j	80001b98 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b78:	ed06a583          	lw	a1,-304(a3)
    80001b7c:	8556                	mv	a0,s5
    80001b7e:	00004097          	auipc	ra,0x4
    80001b82:	2e4080e7          	jalr	740(ra) # 80005e62 <printf>
    printf("\n");
    80001b86:	8552                	mv	a0,s4
    80001b88:	00004097          	auipc	ra,0x4
    80001b8c:	2da080e7          	jalr	730(ra) # 80005e62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b90:	17048493          	addi	s1,s1,368
    80001b94:	03248163          	beq	s1,s2,80001bb6 <procdump+0x98>
    if(p->state == UNUSED)
    80001b98:	86a6                	mv	a3,s1
    80001b9a:	eb84a783          	lw	a5,-328(s1)
    80001b9e:	dbed                	beqz	a5,80001b90 <procdump+0x72>
      state = "???";
    80001ba0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba2:	fcfb6be3          	bltu	s6,a5,80001b78 <procdump+0x5a>
    80001ba6:	1782                	slli	a5,a5,0x20
    80001ba8:	9381                	srli	a5,a5,0x20
    80001baa:	078e                	slli	a5,a5,0x3
    80001bac:	97de                	add	a5,a5,s7
    80001bae:	6390                	ld	a2,0(a5)
    80001bb0:	f661                	bnez	a2,80001b78 <procdump+0x5a>
      state = "???";
    80001bb2:	864e                	mv	a2,s3
    80001bb4:	b7d1                	j	80001b78 <procdump+0x5a>
  }
}
    80001bb6:	60a6                	ld	ra,72(sp)
    80001bb8:	6406                	ld	s0,64(sp)
    80001bba:	74e2                	ld	s1,56(sp)
    80001bbc:	7942                	ld	s2,48(sp)
    80001bbe:	79a2                	ld	s3,40(sp)
    80001bc0:	7a02                	ld	s4,32(sp)
    80001bc2:	6ae2                	ld	s5,24(sp)
    80001bc4:	6b42                	ld	s6,16(sp)
    80001bc6:	6ba2                	ld	s7,8(sp)
    80001bc8:	6161                	addi	sp,sp,80
    80001bca:	8082                	ret

0000000080001bcc <swtch>:
    80001bcc:	00153023          	sd	ra,0(a0)
    80001bd0:	00253423          	sd	sp,8(a0)
    80001bd4:	e900                	sd	s0,16(a0)
    80001bd6:	ed04                	sd	s1,24(a0)
    80001bd8:	03253023          	sd	s2,32(a0)
    80001bdc:	03353423          	sd	s3,40(a0)
    80001be0:	03453823          	sd	s4,48(a0)
    80001be4:	03553c23          	sd	s5,56(a0)
    80001be8:	05653023          	sd	s6,64(a0)
    80001bec:	05753423          	sd	s7,72(a0)
    80001bf0:	05853823          	sd	s8,80(a0)
    80001bf4:	05953c23          	sd	s9,88(a0)
    80001bf8:	07a53023          	sd	s10,96(a0)
    80001bfc:	07b53423          	sd	s11,104(a0)
    80001c00:	0005b083          	ld	ra,0(a1)
    80001c04:	0085b103          	ld	sp,8(a1)
    80001c08:	6980                	ld	s0,16(a1)
    80001c0a:	6d84                	ld	s1,24(a1)
    80001c0c:	0205b903          	ld	s2,32(a1)
    80001c10:	0285b983          	ld	s3,40(a1)
    80001c14:	0305ba03          	ld	s4,48(a1)
    80001c18:	0385ba83          	ld	s5,56(a1)
    80001c1c:	0405bb03          	ld	s6,64(a1)
    80001c20:	0485bb83          	ld	s7,72(a1)
    80001c24:	0505bc03          	ld	s8,80(a1)
    80001c28:	0585bc83          	ld	s9,88(a1)
    80001c2c:	0605bd03          	ld	s10,96(a1)
    80001c30:	0685bd83          	ld	s11,104(a1)
    80001c34:	8082                	ret

0000000080001c36 <trapinit>:

extern int devintr();
extern uint getrefcount(uint64 pa);
void
trapinit(void)
{
    80001c36:	1141                	addi	sp,sp,-16
    80001c38:	e406                	sd	ra,8(sp)
    80001c3a:	e022                	sd	s0,0(sp)
    80001c3c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c3e:	00006597          	auipc	a1,0x6
    80001c42:	69258593          	addi	a1,a1,1682 # 800082d0 <states.1722+0x30>
    80001c46:	0002d517          	auipc	a0,0x2d
    80001c4a:	43a50513          	addi	a0,a0,1082 # 8002f080 <tickslock>
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	6f0080e7          	jalr	1776(ra) # 8000633e <initlock>
}
    80001c56:	60a2                	ld	ra,8(sp)
    80001c58:	6402                	ld	s0,0(sp)
    80001c5a:	0141                	addi	sp,sp,16
    80001c5c:	8082                	ret

0000000080001c5e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c5e:	1141                	addi	sp,sp,-16
    80001c60:	e422                	sd	s0,8(sp)
    80001c62:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c64:	00003797          	auipc	a5,0x3
    80001c68:	5bc78793          	addi	a5,a5,1468 # 80005220 <kernelvec>
    80001c6c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c70:	6422                	ld	s0,8(sp)
    80001c72:	0141                	addi	sp,sp,16
    80001c74:	8082                	ret

0000000080001c76 <cowpagefaulthandler>:
cowpagefaulthandler(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;
  uint flags;
  va= PGROUNDDOWN(va);  // starting of pagetable
    80001c76:	77fd                	lui	a5,0xfffff
    80001c78:	8dfd                	and	a1,a1,a5
  if(va>=MAXVA)
    80001c7a:	57fd                	li	a5,-1
    80001c7c:	83e9                	srli	a5,a5,0x1a
    80001c7e:	0eb7e363          	bltu	a5,a1,80001d64 <cowpagefaulthandler+0xee>
{
    80001c82:	7179                	addi	sp,sp,-48
    80001c84:	f406                	sd	ra,40(sp)
    80001c86:	f022                	sd	s0,32(sp)
    80001c88:	ec26                	sd	s1,24(sp)
    80001c8a:	e84a                	sd	s2,16(sp)
    80001c8c:	e44e                	sd	s3,8(sp)
    80001c8e:	e052                	sd	s4,0(sp)
    80001c90:	1800                	addi	s0,sp,48
  {
    return -1;
  }
  if((pte = walk(pagetable,va,0))==0)
    80001c92:	4601                	li	a2,0
    80001c94:	fffff097          	auipc	ra,0xfffff
    80001c98:	87e080e7          	jalr	-1922(ra) # 80000512 <walk>
    80001c9c:	84aa                	mv	s1,a0
    80001c9e:	c105                	beqz	a0,80001cbe <cowpagefaulthandler+0x48>
  {
     panic("usertrap: pte should exist");
  }
  pa=PTE2PA(*pte);
    80001ca0:	611c                	ld	a5,0(a0)
  flags = PTE_FLAGS(*pte);
    80001ca2:	0007899b          	sext.w	s3,a5
  if(flags & PTE_COW)
    80001ca6:	2009f713          	andi	a4,s3,512
      *pte &= (~PTE_COW);
      *pte |= PTE_W;
    }     
  }  
 
  return 0;
    80001caa:	4501                	li	a0,0
  if(flags & PTE_COW)
    80001cac:	e30d                	bnez	a4,80001cce <cowpagefaulthandler+0x58>
}
    80001cae:	70a2                	ld	ra,40(sp)
    80001cb0:	7402                	ld	s0,32(sp)
    80001cb2:	64e2                	ld	s1,24(sp)
    80001cb4:	6942                	ld	s2,16(sp)
    80001cb6:	69a2                	ld	s3,8(sp)
    80001cb8:	6a02                	ld	s4,0(sp)
    80001cba:	6145                	addi	sp,sp,48
    80001cbc:	8082                	ret
     panic("usertrap: pte should exist");
    80001cbe:	00006517          	auipc	a0,0x6
    80001cc2:	61a50513          	addi	a0,a0,1562 # 800082d8 <states.1722+0x38>
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	152080e7          	jalr	338(ra) # 80005e18 <panic>
  pa=PTE2PA(*pte);
    80001cce:	83a9                	srli	a5,a5,0xa
    80001cd0:	00c79913          	slli	s2,a5,0xc
    printf("%d\n",getrefcount(pa));
    80001cd4:	854a                	mv	a0,s2
    80001cd6:	ffffe097          	auipc	ra,0xffffe
    80001cda:	36c080e7          	jalr	876(ra) # 80000042 <getrefcount>
    80001cde:	0005059b          	sext.w	a1,a0
    80001ce2:	00006517          	auipc	a0,0x6
    80001ce6:	75650513          	addi	a0,a0,1878 # 80008438 <states.1722+0x198>
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	178080e7          	jalr	376(ra) # 80005e62 <printf>
    if(getrefcount(pa)>1)
    80001cf2:	854a                	mv	a0,s2
    80001cf4:	ffffe097          	auipc	ra,0xffffe
    80001cf8:	34e080e7          	jalr	846(ra) # 80000042 <getrefcount>
    80001cfc:	2501                	sext.w	a0,a0
    80001cfe:	4785                	li	a5,1
    80001d00:	04a7f063          	bgeu	a5,a0,80001d40 <cowpagefaulthandler+0xca>
    char *mem = kalloc();
    80001d04:	ffffe097          	auipc	ra,0xffffe
    80001d08:	4ae080e7          	jalr	1198(ra) # 800001b2 <kalloc>
    80001d0c:	8a2a                	mv	s4,a0
    if(mem==0) return -1;
    80001d0e:	cd29                	beqz	a0,80001d68 <cowpagefaulthandler+0xf2>
    memmove(mem,(char*)pa, PGSIZE);
    80001d10:	6605                	lui	a2,0x1
    80001d12:	85ca                	mv	a1,s2
    80001d14:	ffffe097          	auipc	ra,0xffffe
    80001d18:	576080e7          	jalr	1398(ra) # 8000028a <memmove>
    kfree((void*)pa);
    80001d1c:	854a                	mv	a0,s2
    80001d1e:	ffffe097          	auipc	ra,0xffffe
    80001d22:	346080e7          	jalr	838(ra) # 80000064 <kfree>
    flags =(flags & ~PTE_COW) | PTE_W;
    80001d26:	1fb9f993          	andi	s3,s3,507
    *pte = PA2PTE((uint64)mem) | flags;
    80001d2a:	00ca5a13          	srli	s4,s4,0xc
    80001d2e:	0a2a                	slli	s4,s4,0xa
    80001d30:	0049e993          	ori	s3,s3,4
    80001d34:	013a69b3          	or	s3,s4,s3
    80001d38:	0134b023          	sd	s3,0(s1)
  return 0;
    80001d3c:	4501                	li	a0,0
    80001d3e:	bf85                	j	80001cae <cowpagefaulthandler+0x38>
    else if(getrefcount(pa)==1)
    80001d40:	854a                	mv	a0,s2
    80001d42:	ffffe097          	auipc	ra,0xffffe
    80001d46:	300080e7          	jalr	768(ra) # 80000042 <getrefcount>
    80001d4a:	0005079b          	sext.w	a5,a0
    80001d4e:	4705                	li	a4,1
  return 0;
    80001d50:	4501                	li	a0,0
    else if(getrefcount(pa)==1)
    80001d52:	f4e79ee3          	bne	a5,a4,80001cae <cowpagefaulthandler+0x38>
      *pte &= (~PTE_COW);
    80001d56:	609c                	ld	a5,0(s1)
    80001d58:	dff7f793          	andi	a5,a5,-513
      *pte |= PTE_W;
    80001d5c:	0047e793          	ori	a5,a5,4
    80001d60:	e09c                	sd	a5,0(s1)
    80001d62:	b7b1                	j	80001cae <cowpagefaulthandler+0x38>
    return -1;
    80001d64:	557d                	li	a0,-1
}
    80001d66:	8082                	ret
    if(mem==0) return -1;
    80001d68:	557d                	li	a0,-1
    80001d6a:	b791                	j	80001cae <cowpagefaulthandler+0x38>

0000000080001d6c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d6c:	1141                	addi	sp,sp,-16
    80001d6e:	e406                	sd	ra,8(sp)
    80001d70:	e022                	sd	s0,0(sp)
    80001d72:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	29e080e7          	jalr	670(ra) # 80001012 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d80:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d82:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d86:	00005617          	auipc	a2,0x5
    80001d8a:	27a60613          	addi	a2,a2,634 # 80007000 <_trampoline>
    80001d8e:	00005697          	auipc	a3,0x5
    80001d92:	27268693          	addi	a3,a3,626 # 80007000 <_trampoline>
    80001d96:	8e91                	sub	a3,a3,a2
    80001d98:	040007b7          	lui	a5,0x4000
    80001d9c:	17fd                	addi	a5,a5,-1
    80001d9e:	07b2                	slli	a5,a5,0xc
    80001da0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001da2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001da6:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001da8:	180026f3          	csrr	a3,satp
    80001dac:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001dae:	7138                	ld	a4,96(a0)
    80001db0:	6134                	ld	a3,64(a0)
    80001db2:	6585                	lui	a1,0x1
    80001db4:	96ae                	add	a3,a3,a1
    80001db6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001db8:	7138                	ld	a4,96(a0)
    80001dba:	00000697          	auipc	a3,0x0
    80001dbe:	13868693          	addi	a3,a3,312 # 80001ef2 <usertrap>
    80001dc2:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001dc4:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dc6:	8692                	mv	a3,tp
    80001dc8:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dca:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001dce:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001dd2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001dda:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ddc:	6f18                	ld	a4,24(a4)
    80001dde:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001de2:	692c                	ld	a1,80(a0)
    80001de4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001de6:	00005717          	auipc	a4,0x5
    80001dea:	2aa70713          	addi	a4,a4,682 # 80007090 <userret>
    80001dee:	8f11                	sub	a4,a4,a2
    80001df0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001df2:	577d                	li	a4,-1
    80001df4:	177e                	slli	a4,a4,0x3f
    80001df6:	8dd9                	or	a1,a1,a4
    80001df8:	02000537          	lui	a0,0x2000
    80001dfc:	157d                	addi	a0,a0,-1
    80001dfe:	0536                	slli	a0,a0,0xd
    80001e00:	9782                	jalr	a5
}
    80001e02:	60a2                	ld	ra,8(sp)
    80001e04:	6402                	ld	s0,0(sp)
    80001e06:	0141                	addi	sp,sp,16
    80001e08:	8082                	ret

0000000080001e0a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001e0a:	1101                	addi	sp,sp,-32
    80001e0c:	ec06                	sd	ra,24(sp)
    80001e0e:	e822                	sd	s0,16(sp)
    80001e10:	e426                	sd	s1,8(sp)
    80001e12:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e14:	0002d497          	auipc	s1,0x2d
    80001e18:	26c48493          	addi	s1,s1,620 # 8002f080 <tickslock>
    80001e1c:	8526                	mv	a0,s1
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	5b0080e7          	jalr	1456(ra) # 800063ce <acquire>
  ticks++;
    80001e26:	00007517          	auipc	a0,0x7
    80001e2a:	1f250513          	addi	a0,a0,498 # 80009018 <ticks>
    80001e2e:	411c                	lw	a5,0(a0)
    80001e30:	2785                	addiw	a5,a5,1
    80001e32:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e34:	00000097          	auipc	ra,0x0
    80001e38:	a26080e7          	jalr	-1498(ra) # 8000185a <wakeup>
  release(&tickslock);
    80001e3c:	8526                	mv	a0,s1
    80001e3e:	00004097          	auipc	ra,0x4
    80001e42:	644080e7          	jalr	1604(ra) # 80006482 <release>
}
    80001e46:	60e2                	ld	ra,24(sp)
    80001e48:	6442                	ld	s0,16(sp)
    80001e4a:	64a2                	ld	s1,8(sp)
    80001e4c:	6105                	addi	sp,sp,32
    80001e4e:	8082                	ret

0000000080001e50 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001e50:	1101                	addi	sp,sp,-32
    80001e52:	ec06                	sd	ra,24(sp)
    80001e54:	e822                	sd	s0,16(sp)
    80001e56:	e426                	sd	s1,8(sp)
    80001e58:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001e5e:	00074d63          	bltz	a4,80001e78 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001e62:	57fd                	li	a5,-1
    80001e64:	17fe                	slli	a5,a5,0x3f
    80001e66:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e68:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e6a:	06f70363          	beq	a4,a5,80001ed0 <devintr+0x80>
  }
}
    80001e6e:	60e2                	ld	ra,24(sp)
    80001e70:	6442                	ld	s0,16(sp)
    80001e72:	64a2                	ld	s1,8(sp)
    80001e74:	6105                	addi	sp,sp,32
    80001e76:	8082                	ret
     (scause & 0xff) == 9){
    80001e78:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e7c:	46a5                	li	a3,9
    80001e7e:	fed792e3          	bne	a5,a3,80001e62 <devintr+0x12>
    int irq = plic_claim();
    80001e82:	00003097          	auipc	ra,0x3
    80001e86:	4a6080e7          	jalr	1190(ra) # 80005328 <plic_claim>
    80001e8a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e8c:	47a9                	li	a5,10
    80001e8e:	02f50763          	beq	a0,a5,80001ebc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e92:	4785                	li	a5,1
    80001e94:	02f50963          	beq	a0,a5,80001ec6 <devintr+0x76>
    return 1;
    80001e98:	4505                	li	a0,1
    } else if(irq){
    80001e9a:	d8f1                	beqz	s1,80001e6e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e9c:	85a6                	mv	a1,s1
    80001e9e:	00006517          	auipc	a0,0x6
    80001ea2:	45a50513          	addi	a0,a0,1114 # 800082f8 <states.1722+0x58>
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	fbc080e7          	jalr	-68(ra) # 80005e62 <printf>
      plic_complete(irq);
    80001eae:	8526                	mv	a0,s1
    80001eb0:	00003097          	auipc	ra,0x3
    80001eb4:	49c080e7          	jalr	1180(ra) # 8000534c <plic_complete>
    return 1;
    80001eb8:	4505                	li	a0,1
    80001eba:	bf55                	j	80001e6e <devintr+0x1e>
      uartintr();
    80001ebc:	00004097          	auipc	ra,0x4
    80001ec0:	432080e7          	jalr	1074(ra) # 800062ee <uartintr>
    80001ec4:	b7ed                	j	80001eae <devintr+0x5e>
      virtio_disk_intr();
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	966080e7          	jalr	-1690(ra) # 8000582c <virtio_disk_intr>
    80001ece:	b7c5                	j	80001eae <devintr+0x5e>
    if(cpuid() == 0){
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	116080e7          	jalr	278(ra) # 80000fe6 <cpuid>
    80001ed8:	c901                	beqz	a0,80001ee8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001eda:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ede:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ee0:	14479073          	csrw	sip,a5
    return 2;
    80001ee4:	4509                	li	a0,2
    80001ee6:	b761                	j	80001e6e <devintr+0x1e>
      clockintr();
    80001ee8:	00000097          	auipc	ra,0x0
    80001eec:	f22080e7          	jalr	-222(ra) # 80001e0a <clockintr>
    80001ef0:	b7ed                	j	80001eda <devintr+0x8a>

0000000080001ef2 <usertrap>:
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	e04a                	sd	s2,0(sp)
    80001efc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001f02:	1007f793          	andi	a5,a5,256
    80001f06:	e3ad                	bnez	a5,80001f68 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f08:	00003797          	auipc	a5,0x3
    80001f0c:	31878793          	addi	a5,a5,792 # 80005220 <kernelvec>
    80001f10:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	0fe080e7          	jalr	254(ra) # 80001012 <myproc>
    80001f1c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f1e:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f20:	14102773          	csrr	a4,sepc
    80001f24:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f26:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f2a:	47a1                	li	a5,8
    80001f2c:	04f71c63          	bne	a4,a5,80001f84 <usertrap+0x92>
    if(p->killed)
    80001f30:	551c                	lw	a5,40(a0)
    80001f32:	e3b9                	bnez	a5,80001f78 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001f34:	70b8                	ld	a4,96(s1)
    80001f36:	6f1c                	ld	a5,24(a4)
    80001f38:	0791                	addi	a5,a5,4
    80001f3a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f40:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f44:	10079073          	csrw	sstatus,a5
    syscall();
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	312080e7          	jalr	786(ra) # 8000225a <syscall>
if(p->killed)
    80001f50:	549c                	lw	a5,40(s1)
    80001f52:	e3e9                	bnez	a5,80002014 <usertrap+0x122>
  usertrapret();
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	e18080e7          	jalr	-488(ra) # 80001d6c <usertrapret>
}
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6902                	ld	s2,0(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret
    panic("usertrap: not from user mode");
    80001f68:	00006517          	auipc	a0,0x6
    80001f6c:	3b050513          	addi	a0,a0,944 # 80008318 <states.1722+0x78>
    80001f70:	00004097          	auipc	ra,0x4
    80001f74:	ea8080e7          	jalr	-344(ra) # 80005e18 <panic>
      exit(-1);
    80001f78:	557d                	li	a0,-1
    80001f7a:	00000097          	auipc	ra,0x0
    80001f7e:	9b0080e7          	jalr	-1616(ra) # 8000192a <exit>
    80001f82:	bf4d                	j	80001f34 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001f84:	00000097          	auipc	ra,0x0
    80001f88:	ecc080e7          	jalr	-308(ra) # 80001e50 <devintr>
    80001f8c:	892a                	mv	s2,a0
    80001f8e:	e141                	bnez	a0,8000200e <usertrap+0x11c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f90:	14202773          	csrr	a4,scause
   else if(r_scause()==15)
    80001f94:	47bd                	li	a5,15
    80001f96:	04f70863          	beq	a4,a5,80001fe6 <usertrap+0xf4>
    80001f9a:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f9e:	5890                	lw	a2,48(s1)
    80001fa0:	00006517          	auipc	a0,0x6
    80001fa4:	3a850513          	addi	a0,a0,936 # 80008348 <states.1722+0xa8>
    80001fa8:	00004097          	auipc	ra,0x4
    80001fac:	eba080e7          	jalr	-326(ra) # 80005e62 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fb0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fb4:	14302673          	csrr	a2,stval
      printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fb8:	00006517          	auipc	a0,0x6
    80001fbc:	3c050513          	addi	a0,a0,960 # 80008378 <states.1722+0xd8>
    80001fc0:	00004097          	auipc	ra,0x4
    80001fc4:	ea2080e7          	jalr	-350(ra) # 80005e62 <printf>
      p->killed = 1;
    80001fc8:	4785                	li	a5,1
    80001fca:	d49c                	sw	a5,40(s1)
  exit(-1);
    80001fcc:	557d                	li	a0,-1
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	95c080e7          	jalr	-1700(ra) # 8000192a <exit>
if(which_dev == 2)
    80001fd6:	4789                	li	a5,2
    80001fd8:	f6f91ee3          	bne	s2,a5,80001f54 <usertrap+0x62>
    yield();
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	6b6080e7          	jalr	1718(ra) # 80001692 <yield>
    80001fe4:	bf85                	j	80001f54 <usertrap+0x62>
      printf("cow_pagefault\n"); 
    80001fe6:	00006517          	auipc	a0,0x6
    80001fea:	35250513          	addi	a0,a0,850 # 80008338 <states.1722+0x98>
    80001fee:	00004097          	auipc	ra,0x4
    80001ff2:	e74080e7          	jalr	-396(ra) # 80005e62 <printf>
    80001ff6:	143025f3          	csrr	a1,stval
      if((cowpagefaulthandler(p->pagetable,va))<0)
    80001ffa:	68a8                	ld	a0,80(s1)
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	c7a080e7          	jalr	-902(ra) # 80001c76 <cowpagefaulthandler>
    80002004:	f40556e3          	bgez	a0,80001f50 <usertrap+0x5e>
       p->killed=1; 
    80002008:	4785                	li	a5,1
    8000200a:	d49c                	sw	a5,40(s1)
    8000200c:	b7c1                	j	80001fcc <usertrap+0xda>
if(p->killed)
    8000200e:	549c                	lw	a5,40(s1)
    80002010:	d3f9                	beqz	a5,80001fd6 <usertrap+0xe4>
    80002012:	bf6d                	j	80001fcc <usertrap+0xda>
    80002014:	4901                	li	s2,0
    80002016:	bf5d                	j	80001fcc <usertrap+0xda>

0000000080002018 <kerneltrap>:
{
    80002018:	7179                	addi	sp,sp,-48
    8000201a:	f406                	sd	ra,40(sp)
    8000201c:	f022                	sd	s0,32(sp)
    8000201e:	ec26                	sd	s1,24(sp)
    80002020:	e84a                	sd	s2,16(sp)
    80002022:	e44e                	sd	s3,8(sp)
    80002024:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002026:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000202a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000202e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002032:	1004f793          	andi	a5,s1,256
    80002036:	cb85                	beqz	a5,80002066 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002038:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000203c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000203e:	ef85                	bnez	a5,80002076 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002040:	00000097          	auipc	ra,0x0
    80002044:	e10080e7          	jalr	-496(ra) # 80001e50 <devintr>
    80002048:	cd1d                	beqz	a0,80002086 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000204a:	4789                	li	a5,2
    8000204c:	06f50a63          	beq	a0,a5,800020c0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002050:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002054:	10049073          	csrw	sstatus,s1
}
    80002058:	70a2                	ld	ra,40(sp)
    8000205a:	7402                	ld	s0,32(sp)
    8000205c:	64e2                	ld	s1,24(sp)
    8000205e:	6942                	ld	s2,16(sp)
    80002060:	69a2                	ld	s3,8(sp)
    80002062:	6145                	addi	sp,sp,48
    80002064:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002066:	00006517          	auipc	a0,0x6
    8000206a:	33250513          	addi	a0,a0,818 # 80008398 <states.1722+0xf8>
    8000206e:	00004097          	auipc	ra,0x4
    80002072:	daa080e7          	jalr	-598(ra) # 80005e18 <panic>
    panic("kerneltrap: interrupts enabled");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	34a50513          	addi	a0,a0,842 # 800083c0 <states.1722+0x120>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	d9a080e7          	jalr	-614(ra) # 80005e18 <panic>
    printf("scause %p\n", scause);
    80002086:	85ce                	mv	a1,s3
    80002088:	00006517          	auipc	a0,0x6
    8000208c:	35850513          	addi	a0,a0,856 # 800083e0 <states.1722+0x140>
    80002090:	00004097          	auipc	ra,0x4
    80002094:	dd2080e7          	jalr	-558(ra) # 80005e62 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002098:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000209c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020a0:	00006517          	auipc	a0,0x6
    800020a4:	35050513          	addi	a0,a0,848 # 800083f0 <states.1722+0x150>
    800020a8:	00004097          	auipc	ra,0x4
    800020ac:	dba080e7          	jalr	-582(ra) # 80005e62 <printf>
    panic("kerneltrap");
    800020b0:	00006517          	auipc	a0,0x6
    800020b4:	35850513          	addi	a0,a0,856 # 80008408 <states.1722+0x168>
    800020b8:	00004097          	auipc	ra,0x4
    800020bc:	d60080e7          	jalr	-672(ra) # 80005e18 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	f52080e7          	jalr	-174(ra) # 80001012 <myproc>
    800020c8:	d541                	beqz	a0,80002050 <kerneltrap+0x38>
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	f48080e7          	jalr	-184(ra) # 80001012 <myproc>
    800020d2:	4d18                	lw	a4,24(a0)
    800020d4:	4791                	li	a5,4
    800020d6:	f6f71de3          	bne	a4,a5,80002050 <kerneltrap+0x38>
    yield();
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	5b8080e7          	jalr	1464(ra) # 80001692 <yield>
    800020e2:	b7bd                	j	80002050 <kerneltrap+0x38>

00000000800020e4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020e4:	1101                	addi	sp,sp,-32
    800020e6:	ec06                	sd	ra,24(sp)
    800020e8:	e822                	sd	s0,16(sp)
    800020ea:	e426                	sd	s1,8(sp)
    800020ec:	1000                	addi	s0,sp,32
    800020ee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	f22080e7          	jalr	-222(ra) # 80001012 <myproc>
  switch (n) {
    800020f8:	4795                	li	a5,5
    800020fa:	0497e163          	bltu	a5,s1,8000213c <argraw+0x58>
    800020fe:	048a                	slli	s1,s1,0x2
    80002100:	00006717          	auipc	a4,0x6
    80002104:	34070713          	addi	a4,a4,832 # 80008440 <states.1722+0x1a0>
    80002108:	94ba                	add	s1,s1,a4
    8000210a:	409c                	lw	a5,0(s1)
    8000210c:	97ba                	add	a5,a5,a4
    8000210e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002110:	713c                	ld	a5,96(a0)
    80002112:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002114:	60e2                	ld	ra,24(sp)
    80002116:	6442                	ld	s0,16(sp)
    80002118:	64a2                	ld	s1,8(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret
    return p->trapframe->a1;
    8000211e:	713c                	ld	a5,96(a0)
    80002120:	7fa8                	ld	a0,120(a5)
    80002122:	bfcd                	j	80002114 <argraw+0x30>
    return p->trapframe->a2;
    80002124:	713c                	ld	a5,96(a0)
    80002126:	63c8                	ld	a0,128(a5)
    80002128:	b7f5                	j	80002114 <argraw+0x30>
    return p->trapframe->a3;
    8000212a:	713c                	ld	a5,96(a0)
    8000212c:	67c8                	ld	a0,136(a5)
    8000212e:	b7dd                	j	80002114 <argraw+0x30>
    return p->trapframe->a4;
    80002130:	713c                	ld	a5,96(a0)
    80002132:	6bc8                	ld	a0,144(a5)
    80002134:	b7c5                	j	80002114 <argraw+0x30>
    return p->trapframe->a5;
    80002136:	713c                	ld	a5,96(a0)
    80002138:	6fc8                	ld	a0,152(a5)
    8000213a:	bfe9                	j	80002114 <argraw+0x30>
  panic("argraw");
    8000213c:	00006517          	auipc	a0,0x6
    80002140:	2dc50513          	addi	a0,a0,732 # 80008418 <states.1722+0x178>
    80002144:	00004097          	auipc	ra,0x4
    80002148:	cd4080e7          	jalr	-812(ra) # 80005e18 <panic>

000000008000214c <fetchaddr>:
{
    8000214c:	1101                	addi	sp,sp,-32
    8000214e:	ec06                	sd	ra,24(sp)
    80002150:	e822                	sd	s0,16(sp)
    80002152:	e426                	sd	s1,8(sp)
    80002154:	e04a                	sd	s2,0(sp)
    80002156:	1000                	addi	s0,sp,32
    80002158:	84aa                	mv	s1,a0
    8000215a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	eb6080e7          	jalr	-330(ra) # 80001012 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002164:	653c                	ld	a5,72(a0)
    80002166:	02f4f863          	bgeu	s1,a5,80002196 <fetchaddr+0x4a>
    8000216a:	00848713          	addi	a4,s1,8
    8000216e:	02e7e663          	bltu	a5,a4,8000219a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002172:	46a1                	li	a3,8
    80002174:	8626                	mv	a2,s1
    80002176:	85ca                	mv	a1,s2
    80002178:	6928                	ld	a0,80(a0)
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	ab6080e7          	jalr	-1354(ra) # 80000c30 <copyin>
    80002182:	00a03533          	snez	a0,a0
    80002186:	40a00533          	neg	a0,a0
}
    8000218a:	60e2                	ld	ra,24(sp)
    8000218c:	6442                	ld	s0,16(sp)
    8000218e:	64a2                	ld	s1,8(sp)
    80002190:	6902                	ld	s2,0(sp)
    80002192:	6105                	addi	sp,sp,32
    80002194:	8082                	ret
    return -1;
    80002196:	557d                	li	a0,-1
    80002198:	bfcd                	j	8000218a <fetchaddr+0x3e>
    8000219a:	557d                	li	a0,-1
    8000219c:	b7fd                	j	8000218a <fetchaddr+0x3e>

000000008000219e <fetchstr>:
{
    8000219e:	7179                	addi	sp,sp,-48
    800021a0:	f406                	sd	ra,40(sp)
    800021a2:	f022                	sd	s0,32(sp)
    800021a4:	ec26                	sd	s1,24(sp)
    800021a6:	e84a                	sd	s2,16(sp)
    800021a8:	e44e                	sd	s3,8(sp)
    800021aa:	1800                	addi	s0,sp,48
    800021ac:	892a                	mv	s2,a0
    800021ae:	84ae                	mv	s1,a1
    800021b0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	e60080e7          	jalr	-416(ra) # 80001012 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800021ba:	86ce                	mv	a3,s3
    800021bc:	864a                	mv	a2,s2
    800021be:	85a6                	mv	a1,s1
    800021c0:	6928                	ld	a0,80(a0)
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	afa080e7          	jalr	-1286(ra) # 80000cbc <copyinstr>
  if(err < 0)
    800021ca:	00054763          	bltz	a0,800021d8 <fetchstr+0x3a>
  return strlen(buf);
    800021ce:	8526                	mv	a0,s1
    800021d0:	ffffe097          	auipc	ra,0xffffe
    800021d4:	1de080e7          	jalr	478(ra) # 800003ae <strlen>
}
    800021d8:	70a2                	ld	ra,40(sp)
    800021da:	7402                	ld	s0,32(sp)
    800021dc:	64e2                	ld	s1,24(sp)
    800021de:	6942                	ld	s2,16(sp)
    800021e0:	69a2                	ld	s3,8(sp)
    800021e2:	6145                	addi	sp,sp,48
    800021e4:	8082                	ret

00000000800021e6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800021e6:	1101                	addi	sp,sp,-32
    800021e8:	ec06                	sd	ra,24(sp)
    800021ea:	e822                	sd	s0,16(sp)
    800021ec:	e426                	sd	s1,8(sp)
    800021ee:	1000                	addi	s0,sp,32
    800021f0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021f2:	00000097          	auipc	ra,0x0
    800021f6:	ef2080e7          	jalr	-270(ra) # 800020e4 <argraw>
    800021fa:	c088                	sw	a0,0(s1)
  return 0;
}
    800021fc:	4501                	li	a0,0
    800021fe:	60e2                	ld	ra,24(sp)
    80002200:	6442                	ld	s0,16(sp)
    80002202:	64a2                	ld	s1,8(sp)
    80002204:	6105                	addi	sp,sp,32
    80002206:	8082                	ret

0000000080002208 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002208:	1101                	addi	sp,sp,-32
    8000220a:	ec06                	sd	ra,24(sp)
    8000220c:	e822                	sd	s0,16(sp)
    8000220e:	e426                	sd	s1,8(sp)
    80002210:	1000                	addi	s0,sp,32
    80002212:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002214:	00000097          	auipc	ra,0x0
    80002218:	ed0080e7          	jalr	-304(ra) # 800020e4 <argraw>
    8000221c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000221e:	4501                	li	a0,0
    80002220:	60e2                	ld	ra,24(sp)
    80002222:	6442                	ld	s0,16(sp)
    80002224:	64a2                	ld	s1,8(sp)
    80002226:	6105                	addi	sp,sp,32
    80002228:	8082                	ret

000000008000222a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000222a:	1101                	addi	sp,sp,-32
    8000222c:	ec06                	sd	ra,24(sp)
    8000222e:	e822                	sd	s0,16(sp)
    80002230:	e426                	sd	s1,8(sp)
    80002232:	e04a                	sd	s2,0(sp)
    80002234:	1000                	addi	s0,sp,32
    80002236:	84ae                	mv	s1,a1
    80002238:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	eaa080e7          	jalr	-342(ra) # 800020e4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002242:	864a                	mv	a2,s2
    80002244:	85a6                	mv	a1,s1
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	f58080e7          	jalr	-168(ra) # 8000219e <fetchstr>
}
    8000224e:	60e2                	ld	ra,24(sp)
    80002250:	6442                	ld	s0,16(sp)
    80002252:	64a2                	ld	s1,8(sp)
    80002254:	6902                	ld	s2,0(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	e04a                	sd	s2,0(sp)
    80002264:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	dac080e7          	jalr	-596(ra) # 80001012 <myproc>
    8000226e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002270:	06053903          	ld	s2,96(a0)
    80002274:	0a893783          	ld	a5,168(s2)
    80002278:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000227c:	37fd                	addiw	a5,a5,-1
    8000227e:	4751                	li	a4,20
    80002280:	00f76f63          	bltu	a4,a5,8000229e <syscall+0x44>
    80002284:	00369713          	slli	a4,a3,0x3
    80002288:	00006797          	auipc	a5,0x6
    8000228c:	1d078793          	addi	a5,a5,464 # 80008458 <syscalls>
    80002290:	97ba                	add	a5,a5,a4
    80002292:	639c                	ld	a5,0(a5)
    80002294:	c789                	beqz	a5,8000229e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002296:	9782                	jalr	a5
    80002298:	06a93823          	sd	a0,112(s2)
    8000229c:	a839                	j	800022ba <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000229e:	16048613          	addi	a2,s1,352
    800022a2:	588c                	lw	a1,48(s1)
    800022a4:	00006517          	auipc	a0,0x6
    800022a8:	17c50513          	addi	a0,a0,380 # 80008420 <states.1722+0x180>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	bb6080e7          	jalr	-1098(ra) # 80005e62 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022b4:	70bc                	ld	a5,96(s1)
    800022b6:	577d                	li	a4,-1
    800022b8:	fbb8                	sd	a4,112(a5)
  }
}
    800022ba:	60e2                	ld	ra,24(sp)
    800022bc:	6442                	ld	s0,16(sp)
    800022be:	64a2                	ld	s1,8(sp)
    800022c0:	6902                	ld	s2,0(sp)
    800022c2:	6105                	addi	sp,sp,32
    800022c4:	8082                	ret

00000000800022c6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800022c6:	1101                	addi	sp,sp,-32
    800022c8:	ec06                	sd	ra,24(sp)
    800022ca:	e822                	sd	s0,16(sp)
    800022cc:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800022ce:	fec40593          	addi	a1,s0,-20
    800022d2:	4501                	li	a0,0
    800022d4:	00000097          	auipc	ra,0x0
    800022d8:	f12080e7          	jalr	-238(ra) # 800021e6 <argint>
    return -1;
    800022dc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022de:	00054963          	bltz	a0,800022f0 <sys_exit+0x2a>
  exit(n);
    800022e2:	fec42503          	lw	a0,-20(s0)
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	644080e7          	jalr	1604(ra) # 8000192a <exit>
  return 0;  // not reached
    800022ee:	4781                	li	a5,0
}
    800022f0:	853e                	mv	a0,a5
    800022f2:	60e2                	ld	ra,24(sp)
    800022f4:	6442                	ld	s0,16(sp)
    800022f6:	6105                	addi	sp,sp,32
    800022f8:	8082                	ret

00000000800022fa <sys_getpid>:

uint64
sys_getpid(void)
{
    800022fa:	1141                	addi	sp,sp,-16
    800022fc:	e406                	sd	ra,8(sp)
    800022fe:	e022                	sd	s0,0(sp)
    80002300:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	d10080e7          	jalr	-752(ra) # 80001012 <myproc>
}
    8000230a:	5908                	lw	a0,48(a0)
    8000230c:	60a2                	ld	ra,8(sp)
    8000230e:	6402                	ld	s0,0(sp)
    80002310:	0141                	addi	sp,sp,16
    80002312:	8082                	ret

0000000080002314 <sys_fork>:

uint64
sys_fork(void)
{
    80002314:	1141                	addi	sp,sp,-16
    80002316:	e406                	sd	ra,8(sp)
    80002318:	e022                	sd	s0,0(sp)
    8000231a:	0800                	addi	s0,sp,16
  return fork();
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	0c4080e7          	jalr	196(ra) # 800013e0 <fork>
}
    80002324:	60a2                	ld	ra,8(sp)
    80002326:	6402                	ld	s0,0(sp)
    80002328:	0141                	addi	sp,sp,16
    8000232a:	8082                	ret

000000008000232c <sys_wait>:

uint64
sys_wait(void)
{
    8000232c:	1101                	addi	sp,sp,-32
    8000232e:	ec06                	sd	ra,24(sp)
    80002330:	e822                	sd	s0,16(sp)
    80002332:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002334:	fe840593          	addi	a1,s0,-24
    80002338:	4501                	li	a0,0
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	ece080e7          	jalr	-306(ra) # 80002208 <argaddr>
    80002342:	87aa                	mv	a5,a0
    return -1;
    80002344:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002346:	0007c863          	bltz	a5,80002356 <sys_wait+0x2a>
  return wait(p);
    8000234a:	fe843503          	ld	a0,-24(s0)
    8000234e:	fffff097          	auipc	ra,0xfffff
    80002352:	3e4080e7          	jalr	996(ra) # 80001732 <wait>
}
    80002356:	60e2                	ld	ra,24(sp)
    80002358:	6442                	ld	s0,16(sp)
    8000235a:	6105                	addi	sp,sp,32
    8000235c:	8082                	ret

000000008000235e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000235e:	7179                	addi	sp,sp,-48
    80002360:	f406                	sd	ra,40(sp)
    80002362:	f022                	sd	s0,32(sp)
    80002364:	ec26                	sd	s1,24(sp)
    80002366:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002368:	fdc40593          	addi	a1,s0,-36
    8000236c:	4501                	li	a0,0
    8000236e:	00000097          	auipc	ra,0x0
    80002372:	e78080e7          	jalr	-392(ra) # 800021e6 <argint>
    80002376:	87aa                	mv	a5,a0
    return -1;
    80002378:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000237a:	0207c063          	bltz	a5,8000239a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	c94080e7          	jalr	-876(ra) # 80001012 <myproc>
    80002386:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002388:	fdc42503          	lw	a0,-36(s0)
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	fe0080e7          	jalr	-32(ra) # 8000136c <growproc>
    80002394:	00054863          	bltz	a0,800023a4 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002398:	8526                	mv	a0,s1
}
    8000239a:	70a2                	ld	ra,40(sp)
    8000239c:	7402                	ld	s0,32(sp)
    8000239e:	64e2                	ld	s1,24(sp)
    800023a0:	6145                	addi	sp,sp,48
    800023a2:	8082                	ret
    return -1;
    800023a4:	557d                	li	a0,-1
    800023a6:	bfd5                	j	8000239a <sys_sbrk+0x3c>

00000000800023a8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800023a8:	7139                	addi	sp,sp,-64
    800023aa:	fc06                	sd	ra,56(sp)
    800023ac:	f822                	sd	s0,48(sp)
    800023ae:	f426                	sd	s1,40(sp)
    800023b0:	f04a                	sd	s2,32(sp)
    800023b2:	ec4e                	sd	s3,24(sp)
    800023b4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023b6:	fcc40593          	addi	a1,s0,-52
    800023ba:	4501                	li	a0,0
    800023bc:	00000097          	auipc	ra,0x0
    800023c0:	e2a080e7          	jalr	-470(ra) # 800021e6 <argint>
    return -1;
    800023c4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800023c6:	06054963          	bltz	a0,80002438 <sys_sleep+0x90>
  acquire(&tickslock);
    800023ca:	0002d517          	auipc	a0,0x2d
    800023ce:	cb650513          	addi	a0,a0,-842 # 8002f080 <tickslock>
    800023d2:	00004097          	auipc	ra,0x4
    800023d6:	ffc080e7          	jalr	-4(ra) # 800063ce <acquire>
  ticks0 = ticks;
    800023da:	00007917          	auipc	s2,0x7
    800023de:	c3e92903          	lw	s2,-962(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800023e2:	fcc42783          	lw	a5,-52(s0)
    800023e6:	cf85                	beqz	a5,8000241e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023e8:	0002d997          	auipc	s3,0x2d
    800023ec:	c9898993          	addi	s3,s3,-872 # 8002f080 <tickslock>
    800023f0:	00007497          	auipc	s1,0x7
    800023f4:	c2848493          	addi	s1,s1,-984 # 80009018 <ticks>
    if(myproc()->killed){
    800023f8:	fffff097          	auipc	ra,0xfffff
    800023fc:	c1a080e7          	jalr	-998(ra) # 80001012 <myproc>
    80002400:	551c                	lw	a5,40(a0)
    80002402:	e3b9                	bnez	a5,80002448 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002404:	85ce                	mv	a1,s3
    80002406:	8526                	mv	a0,s1
    80002408:	fffff097          	auipc	ra,0xfffff
    8000240c:	2c6080e7          	jalr	710(ra) # 800016ce <sleep>
  while(ticks - ticks0 < n){
    80002410:	409c                	lw	a5,0(s1)
    80002412:	412787bb          	subw	a5,a5,s2
    80002416:	fcc42703          	lw	a4,-52(s0)
    8000241a:	fce7efe3          	bltu	a5,a4,800023f8 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000241e:	0002d517          	auipc	a0,0x2d
    80002422:	c6250513          	addi	a0,a0,-926 # 8002f080 <tickslock>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	05c080e7          	jalr	92(ra) # 80006482 <release>
  backtrace();
    8000242e:	00004097          	auipc	ra,0x4
    80002432:	c4c080e7          	jalr	-948(ra) # 8000607a <backtrace>
  return 0;
    80002436:	4781                	li	a5,0
}
    80002438:	853e                	mv	a0,a5
    8000243a:	70e2                	ld	ra,56(sp)
    8000243c:	7442                	ld	s0,48(sp)
    8000243e:	74a2                	ld	s1,40(sp)
    80002440:	7902                	ld	s2,32(sp)
    80002442:	69e2                	ld	s3,24(sp)
    80002444:	6121                	addi	sp,sp,64
    80002446:	8082                	ret
      release(&tickslock);
    80002448:	0002d517          	auipc	a0,0x2d
    8000244c:	c3850513          	addi	a0,a0,-968 # 8002f080 <tickslock>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	032080e7          	jalr	50(ra) # 80006482 <release>
      return -1;
    80002458:	57fd                	li	a5,-1
    8000245a:	bff9                	j	80002438 <sys_sleep+0x90>

000000008000245c <sys_kill>:

uint64
sys_kill(void)
{
    8000245c:	1101                	addi	sp,sp,-32
    8000245e:	ec06                	sd	ra,24(sp)
    80002460:	e822                	sd	s0,16(sp)
    80002462:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002464:	fec40593          	addi	a1,s0,-20
    80002468:	4501                	li	a0,0
    8000246a:	00000097          	auipc	ra,0x0
    8000246e:	d7c080e7          	jalr	-644(ra) # 800021e6 <argint>
    80002472:	87aa                	mv	a5,a0
    return -1;
    80002474:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002476:	0007c863          	bltz	a5,80002486 <sys_kill+0x2a>
  return kill(pid);
    8000247a:	fec42503          	lw	a0,-20(s0)
    8000247e:	fffff097          	auipc	ra,0xfffff
    80002482:	582080e7          	jalr	1410(ra) # 80001a00 <kill>
}
    80002486:	60e2                	ld	ra,24(sp)
    80002488:	6442                	ld	s0,16(sp)
    8000248a:	6105                	addi	sp,sp,32
    8000248c:	8082                	ret

000000008000248e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000248e:	1101                	addi	sp,sp,-32
    80002490:	ec06                	sd	ra,24(sp)
    80002492:	e822                	sd	s0,16(sp)
    80002494:	e426                	sd	s1,8(sp)
    80002496:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002498:	0002d517          	auipc	a0,0x2d
    8000249c:	be850513          	addi	a0,a0,-1048 # 8002f080 <tickslock>
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	f2e080e7          	jalr	-210(ra) # 800063ce <acquire>
  xticks = ticks;
    800024a8:	00007497          	auipc	s1,0x7
    800024ac:	b704a483          	lw	s1,-1168(s1) # 80009018 <ticks>
  release(&tickslock);
    800024b0:	0002d517          	auipc	a0,0x2d
    800024b4:	bd050513          	addi	a0,a0,-1072 # 8002f080 <tickslock>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	fca080e7          	jalr	-54(ra) # 80006482 <release>
  return xticks;
}
    800024c0:	02049513          	slli	a0,s1,0x20
    800024c4:	9101                	srli	a0,a0,0x20
    800024c6:	60e2                	ld	ra,24(sp)
    800024c8:	6442                	ld	s0,16(sp)
    800024ca:	64a2                	ld	s1,8(sp)
    800024cc:	6105                	addi	sp,sp,32
    800024ce:	8082                	ret

00000000800024d0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	e84a                	sd	s2,16(sp)
    800024da:	e44e                	sd	s3,8(sp)
    800024dc:	e052                	sd	s4,0(sp)
    800024de:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024e0:	00006597          	auipc	a1,0x6
    800024e4:	02858593          	addi	a1,a1,40 # 80008508 <syscalls+0xb0>
    800024e8:	0002d517          	auipc	a0,0x2d
    800024ec:	bb050513          	addi	a0,a0,-1104 # 8002f098 <bcache>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	e4e080e7          	jalr	-434(ra) # 8000633e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024f8:	00035797          	auipc	a5,0x35
    800024fc:	ba078793          	addi	a5,a5,-1120 # 80037098 <bcache+0x8000>
    80002500:	00035717          	auipc	a4,0x35
    80002504:	e0070713          	addi	a4,a4,-512 # 80037300 <bcache+0x8268>
    80002508:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000250c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002510:	0002d497          	auipc	s1,0x2d
    80002514:	ba048493          	addi	s1,s1,-1120 # 8002f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002518:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000251a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000251c:	00006a17          	auipc	s4,0x6
    80002520:	ff4a0a13          	addi	s4,s4,-12 # 80008510 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002524:	2b893783          	ld	a5,696(s2)
    80002528:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000252a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000252e:	85d2                	mv	a1,s4
    80002530:	01048513          	addi	a0,s1,16
    80002534:	00001097          	auipc	ra,0x1
    80002538:	4bc080e7          	jalr	1212(ra) # 800039f0 <initsleeplock>
    bcache.head.next->prev = b;
    8000253c:	2b893783          	ld	a5,696(s2)
    80002540:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002542:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002546:	45848493          	addi	s1,s1,1112
    8000254a:	fd349de3          	bne	s1,s3,80002524 <binit+0x54>
  }
}
    8000254e:	70a2                	ld	ra,40(sp)
    80002550:	7402                	ld	s0,32(sp)
    80002552:	64e2                	ld	s1,24(sp)
    80002554:	6942                	ld	s2,16(sp)
    80002556:	69a2                	ld	s3,8(sp)
    80002558:	6a02                	ld	s4,0(sp)
    8000255a:	6145                	addi	sp,sp,48
    8000255c:	8082                	ret

000000008000255e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000255e:	7179                	addi	sp,sp,-48
    80002560:	f406                	sd	ra,40(sp)
    80002562:	f022                	sd	s0,32(sp)
    80002564:	ec26                	sd	s1,24(sp)
    80002566:	e84a                	sd	s2,16(sp)
    80002568:	e44e                	sd	s3,8(sp)
    8000256a:	1800                	addi	s0,sp,48
    8000256c:	89aa                	mv	s3,a0
    8000256e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002570:	0002d517          	auipc	a0,0x2d
    80002574:	b2850513          	addi	a0,a0,-1240 # 8002f098 <bcache>
    80002578:	00004097          	auipc	ra,0x4
    8000257c:	e56080e7          	jalr	-426(ra) # 800063ce <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002580:	00035497          	auipc	s1,0x35
    80002584:	dd04b483          	ld	s1,-560(s1) # 80037350 <bcache+0x82b8>
    80002588:	00035797          	auipc	a5,0x35
    8000258c:	d7878793          	addi	a5,a5,-648 # 80037300 <bcache+0x8268>
    80002590:	02f48f63          	beq	s1,a5,800025ce <bread+0x70>
    80002594:	873e                	mv	a4,a5
    80002596:	a021                	j	8000259e <bread+0x40>
    80002598:	68a4                	ld	s1,80(s1)
    8000259a:	02e48a63          	beq	s1,a4,800025ce <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000259e:	449c                	lw	a5,8(s1)
    800025a0:	ff379ce3          	bne	a5,s3,80002598 <bread+0x3a>
    800025a4:	44dc                	lw	a5,12(s1)
    800025a6:	ff2799e3          	bne	a5,s2,80002598 <bread+0x3a>
      b->refcnt++;
    800025aa:	40bc                	lw	a5,64(s1)
    800025ac:	2785                	addiw	a5,a5,1
    800025ae:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025b0:	0002d517          	auipc	a0,0x2d
    800025b4:	ae850513          	addi	a0,a0,-1304 # 8002f098 <bcache>
    800025b8:	00004097          	auipc	ra,0x4
    800025bc:	eca080e7          	jalr	-310(ra) # 80006482 <release>
      acquiresleep(&b->lock);
    800025c0:	01048513          	addi	a0,s1,16
    800025c4:	00001097          	auipc	ra,0x1
    800025c8:	466080e7          	jalr	1126(ra) # 80003a2a <acquiresleep>
      return b;
    800025cc:	a8b9                	j	8000262a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025ce:	00035497          	auipc	s1,0x35
    800025d2:	d7a4b483          	ld	s1,-646(s1) # 80037348 <bcache+0x82b0>
    800025d6:	00035797          	auipc	a5,0x35
    800025da:	d2a78793          	addi	a5,a5,-726 # 80037300 <bcache+0x8268>
    800025de:	00f48863          	beq	s1,a5,800025ee <bread+0x90>
    800025e2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025e4:	40bc                	lw	a5,64(s1)
    800025e6:	cf81                	beqz	a5,800025fe <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025e8:	64a4                	ld	s1,72(s1)
    800025ea:	fee49de3          	bne	s1,a4,800025e4 <bread+0x86>
  panic("bget: no buffers");
    800025ee:	00006517          	auipc	a0,0x6
    800025f2:	f2a50513          	addi	a0,a0,-214 # 80008518 <syscalls+0xc0>
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	822080e7          	jalr	-2014(ra) # 80005e18 <panic>
      b->dev = dev;
    800025fe:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002602:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002606:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000260a:	4785                	li	a5,1
    8000260c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000260e:	0002d517          	auipc	a0,0x2d
    80002612:	a8a50513          	addi	a0,a0,-1398 # 8002f098 <bcache>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	e6c080e7          	jalr	-404(ra) # 80006482 <release>
      acquiresleep(&b->lock);
    8000261e:	01048513          	addi	a0,s1,16
    80002622:	00001097          	auipc	ra,0x1
    80002626:	408080e7          	jalr	1032(ra) # 80003a2a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000262a:	409c                	lw	a5,0(s1)
    8000262c:	cb89                	beqz	a5,8000263e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000262e:	8526                	mv	a0,s1
    80002630:	70a2                	ld	ra,40(sp)
    80002632:	7402                	ld	s0,32(sp)
    80002634:	64e2                	ld	s1,24(sp)
    80002636:	6942                	ld	s2,16(sp)
    80002638:	69a2                	ld	s3,8(sp)
    8000263a:	6145                	addi	sp,sp,48
    8000263c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000263e:	4581                	li	a1,0
    80002640:	8526                	mv	a0,s1
    80002642:	00003097          	auipc	ra,0x3
    80002646:	f14080e7          	jalr	-236(ra) # 80005556 <virtio_disk_rw>
    b->valid = 1;
    8000264a:	4785                	li	a5,1
    8000264c:	c09c                	sw	a5,0(s1)
  return b;
    8000264e:	b7c5                	j	8000262e <bread+0xd0>

0000000080002650 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002650:	1101                	addi	sp,sp,-32
    80002652:	ec06                	sd	ra,24(sp)
    80002654:	e822                	sd	s0,16(sp)
    80002656:	e426                	sd	s1,8(sp)
    80002658:	1000                	addi	s0,sp,32
    8000265a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000265c:	0541                	addi	a0,a0,16
    8000265e:	00001097          	auipc	ra,0x1
    80002662:	466080e7          	jalr	1126(ra) # 80003ac4 <holdingsleep>
    80002666:	cd01                	beqz	a0,8000267e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002668:	4585                	li	a1,1
    8000266a:	8526                	mv	a0,s1
    8000266c:	00003097          	auipc	ra,0x3
    80002670:	eea080e7          	jalr	-278(ra) # 80005556 <virtio_disk_rw>
}
    80002674:	60e2                	ld	ra,24(sp)
    80002676:	6442                	ld	s0,16(sp)
    80002678:	64a2                	ld	s1,8(sp)
    8000267a:	6105                	addi	sp,sp,32
    8000267c:	8082                	ret
    panic("bwrite");
    8000267e:	00006517          	auipc	a0,0x6
    80002682:	eb250513          	addi	a0,a0,-334 # 80008530 <syscalls+0xd8>
    80002686:	00003097          	auipc	ra,0x3
    8000268a:	792080e7          	jalr	1938(ra) # 80005e18 <panic>

000000008000268e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000268e:	1101                	addi	sp,sp,-32
    80002690:	ec06                	sd	ra,24(sp)
    80002692:	e822                	sd	s0,16(sp)
    80002694:	e426                	sd	s1,8(sp)
    80002696:	e04a                	sd	s2,0(sp)
    80002698:	1000                	addi	s0,sp,32
    8000269a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000269c:	01050913          	addi	s2,a0,16
    800026a0:	854a                	mv	a0,s2
    800026a2:	00001097          	auipc	ra,0x1
    800026a6:	422080e7          	jalr	1058(ra) # 80003ac4 <holdingsleep>
    800026aa:	c92d                	beqz	a0,8000271c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026ac:	854a                	mv	a0,s2
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	3d2080e7          	jalr	978(ra) # 80003a80 <releasesleep>

  acquire(&bcache.lock);
    800026b6:	0002d517          	auipc	a0,0x2d
    800026ba:	9e250513          	addi	a0,a0,-1566 # 8002f098 <bcache>
    800026be:	00004097          	auipc	ra,0x4
    800026c2:	d10080e7          	jalr	-752(ra) # 800063ce <acquire>
  b->refcnt--;
    800026c6:	40bc                	lw	a5,64(s1)
    800026c8:	37fd                	addiw	a5,a5,-1
    800026ca:	0007871b          	sext.w	a4,a5
    800026ce:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026d0:	eb05                	bnez	a4,80002700 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026d2:	68bc                	ld	a5,80(s1)
    800026d4:	64b8                	ld	a4,72(s1)
    800026d6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026d8:	64bc                	ld	a5,72(s1)
    800026da:	68b8                	ld	a4,80(s1)
    800026dc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026de:	00035797          	auipc	a5,0x35
    800026e2:	9ba78793          	addi	a5,a5,-1606 # 80037098 <bcache+0x8000>
    800026e6:	2b87b703          	ld	a4,696(a5)
    800026ea:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026ec:	00035717          	auipc	a4,0x35
    800026f0:	c1470713          	addi	a4,a4,-1004 # 80037300 <bcache+0x8268>
    800026f4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026f6:	2b87b703          	ld	a4,696(a5)
    800026fa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026fc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002700:	0002d517          	auipc	a0,0x2d
    80002704:	99850513          	addi	a0,a0,-1640 # 8002f098 <bcache>
    80002708:	00004097          	auipc	ra,0x4
    8000270c:	d7a080e7          	jalr	-646(ra) # 80006482 <release>
}
    80002710:	60e2                	ld	ra,24(sp)
    80002712:	6442                	ld	s0,16(sp)
    80002714:	64a2                	ld	s1,8(sp)
    80002716:	6902                	ld	s2,0(sp)
    80002718:	6105                	addi	sp,sp,32
    8000271a:	8082                	ret
    panic("brelse");
    8000271c:	00006517          	auipc	a0,0x6
    80002720:	e1c50513          	addi	a0,a0,-484 # 80008538 <syscalls+0xe0>
    80002724:	00003097          	auipc	ra,0x3
    80002728:	6f4080e7          	jalr	1780(ra) # 80005e18 <panic>

000000008000272c <bpin>:

void
bpin(struct buf *b) {
    8000272c:	1101                	addi	sp,sp,-32
    8000272e:	ec06                	sd	ra,24(sp)
    80002730:	e822                	sd	s0,16(sp)
    80002732:	e426                	sd	s1,8(sp)
    80002734:	1000                	addi	s0,sp,32
    80002736:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002738:	0002d517          	auipc	a0,0x2d
    8000273c:	96050513          	addi	a0,a0,-1696 # 8002f098 <bcache>
    80002740:	00004097          	auipc	ra,0x4
    80002744:	c8e080e7          	jalr	-882(ra) # 800063ce <acquire>
  b->refcnt++;
    80002748:	40bc                	lw	a5,64(s1)
    8000274a:	2785                	addiw	a5,a5,1
    8000274c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000274e:	0002d517          	auipc	a0,0x2d
    80002752:	94a50513          	addi	a0,a0,-1718 # 8002f098 <bcache>
    80002756:	00004097          	auipc	ra,0x4
    8000275a:	d2c080e7          	jalr	-724(ra) # 80006482 <release>
}
    8000275e:	60e2                	ld	ra,24(sp)
    80002760:	6442                	ld	s0,16(sp)
    80002762:	64a2                	ld	s1,8(sp)
    80002764:	6105                	addi	sp,sp,32
    80002766:	8082                	ret

0000000080002768 <bunpin>:

void
bunpin(struct buf *b) {
    80002768:	1101                	addi	sp,sp,-32
    8000276a:	ec06                	sd	ra,24(sp)
    8000276c:	e822                	sd	s0,16(sp)
    8000276e:	e426                	sd	s1,8(sp)
    80002770:	1000                	addi	s0,sp,32
    80002772:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002774:	0002d517          	auipc	a0,0x2d
    80002778:	92450513          	addi	a0,a0,-1756 # 8002f098 <bcache>
    8000277c:	00004097          	auipc	ra,0x4
    80002780:	c52080e7          	jalr	-942(ra) # 800063ce <acquire>
  b->refcnt--;
    80002784:	40bc                	lw	a5,64(s1)
    80002786:	37fd                	addiw	a5,a5,-1
    80002788:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000278a:	0002d517          	auipc	a0,0x2d
    8000278e:	90e50513          	addi	a0,a0,-1778 # 8002f098 <bcache>
    80002792:	00004097          	auipc	ra,0x4
    80002796:	cf0080e7          	jalr	-784(ra) # 80006482 <release>
}
    8000279a:	60e2                	ld	ra,24(sp)
    8000279c:	6442                	ld	s0,16(sp)
    8000279e:	64a2                	ld	s1,8(sp)
    800027a0:	6105                	addi	sp,sp,32
    800027a2:	8082                	ret

00000000800027a4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027a4:	1101                	addi	sp,sp,-32
    800027a6:	ec06                	sd	ra,24(sp)
    800027a8:	e822                	sd	s0,16(sp)
    800027aa:	e426                	sd	s1,8(sp)
    800027ac:	e04a                	sd	s2,0(sp)
    800027ae:	1000                	addi	s0,sp,32
    800027b0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027b2:	00d5d59b          	srliw	a1,a1,0xd
    800027b6:	00035797          	auipc	a5,0x35
    800027ba:	fbe7a783          	lw	a5,-66(a5) # 80037774 <sb+0x1c>
    800027be:	9dbd                	addw	a1,a1,a5
    800027c0:	00000097          	auipc	ra,0x0
    800027c4:	d9e080e7          	jalr	-610(ra) # 8000255e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027c8:	0074f713          	andi	a4,s1,7
    800027cc:	4785                	li	a5,1
    800027ce:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027d2:	14ce                	slli	s1,s1,0x33
    800027d4:	90d9                	srli	s1,s1,0x36
    800027d6:	00950733          	add	a4,a0,s1
    800027da:	05874703          	lbu	a4,88(a4)
    800027de:	00e7f6b3          	and	a3,a5,a4
    800027e2:	c69d                	beqz	a3,80002810 <bfree+0x6c>
    800027e4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027e6:	94aa                	add	s1,s1,a0
    800027e8:	fff7c793          	not	a5,a5
    800027ec:	8ff9                	and	a5,a5,a4
    800027ee:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027f2:	00001097          	auipc	ra,0x1
    800027f6:	118080e7          	jalr	280(ra) # 8000390a <log_write>
  brelse(bp);
    800027fa:	854a                	mv	a0,s2
    800027fc:	00000097          	auipc	ra,0x0
    80002800:	e92080e7          	jalr	-366(ra) # 8000268e <brelse>
}
    80002804:	60e2                	ld	ra,24(sp)
    80002806:	6442                	ld	s0,16(sp)
    80002808:	64a2                	ld	s1,8(sp)
    8000280a:	6902                	ld	s2,0(sp)
    8000280c:	6105                	addi	sp,sp,32
    8000280e:	8082                	ret
    panic("freeing free block");
    80002810:	00006517          	auipc	a0,0x6
    80002814:	d3050513          	addi	a0,a0,-720 # 80008540 <syscalls+0xe8>
    80002818:	00003097          	auipc	ra,0x3
    8000281c:	600080e7          	jalr	1536(ra) # 80005e18 <panic>

0000000080002820 <balloc>:
{
    80002820:	711d                	addi	sp,sp,-96
    80002822:	ec86                	sd	ra,88(sp)
    80002824:	e8a2                	sd	s0,80(sp)
    80002826:	e4a6                	sd	s1,72(sp)
    80002828:	e0ca                	sd	s2,64(sp)
    8000282a:	fc4e                	sd	s3,56(sp)
    8000282c:	f852                	sd	s4,48(sp)
    8000282e:	f456                	sd	s5,40(sp)
    80002830:	f05a                	sd	s6,32(sp)
    80002832:	ec5e                	sd	s7,24(sp)
    80002834:	e862                	sd	s8,16(sp)
    80002836:	e466                	sd	s9,8(sp)
    80002838:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000283a:	00035797          	auipc	a5,0x35
    8000283e:	f227a783          	lw	a5,-222(a5) # 8003775c <sb+0x4>
    80002842:	cbd1                	beqz	a5,800028d6 <balloc+0xb6>
    80002844:	8baa                	mv	s7,a0
    80002846:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002848:	00035b17          	auipc	s6,0x35
    8000284c:	f10b0b13          	addi	s6,s6,-240 # 80037758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002850:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002852:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002854:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002856:	6c89                	lui	s9,0x2
    80002858:	a831                	j	80002874 <balloc+0x54>
    brelse(bp);
    8000285a:	854a                	mv	a0,s2
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	e32080e7          	jalr	-462(ra) # 8000268e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002864:	015c87bb          	addw	a5,s9,s5
    80002868:	00078a9b          	sext.w	s5,a5
    8000286c:	004b2703          	lw	a4,4(s6)
    80002870:	06eaf363          	bgeu	s5,a4,800028d6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002874:	41fad79b          	sraiw	a5,s5,0x1f
    80002878:	0137d79b          	srliw	a5,a5,0x13
    8000287c:	015787bb          	addw	a5,a5,s5
    80002880:	40d7d79b          	sraiw	a5,a5,0xd
    80002884:	01cb2583          	lw	a1,28(s6)
    80002888:	9dbd                	addw	a1,a1,a5
    8000288a:	855e                	mv	a0,s7
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	cd2080e7          	jalr	-814(ra) # 8000255e <bread>
    80002894:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002896:	004b2503          	lw	a0,4(s6)
    8000289a:	000a849b          	sext.w	s1,s5
    8000289e:	8662                	mv	a2,s8
    800028a0:	faa4fde3          	bgeu	s1,a0,8000285a <balloc+0x3a>
      m = 1 << (bi % 8);
    800028a4:	41f6579b          	sraiw	a5,a2,0x1f
    800028a8:	01d7d69b          	srliw	a3,a5,0x1d
    800028ac:	00c6873b          	addw	a4,a3,a2
    800028b0:	00777793          	andi	a5,a4,7
    800028b4:	9f95                	subw	a5,a5,a3
    800028b6:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028ba:	4037571b          	sraiw	a4,a4,0x3
    800028be:	00e906b3          	add	a3,s2,a4
    800028c2:	0586c683          	lbu	a3,88(a3)
    800028c6:	00d7f5b3          	and	a1,a5,a3
    800028ca:	cd91                	beqz	a1,800028e6 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028cc:	2605                	addiw	a2,a2,1
    800028ce:	2485                	addiw	s1,s1,1
    800028d0:	fd4618e3          	bne	a2,s4,800028a0 <balloc+0x80>
    800028d4:	b759                	j	8000285a <balloc+0x3a>
  panic("balloc: out of blocks");
    800028d6:	00006517          	auipc	a0,0x6
    800028da:	c8250513          	addi	a0,a0,-894 # 80008558 <syscalls+0x100>
    800028de:	00003097          	auipc	ra,0x3
    800028e2:	53a080e7          	jalr	1338(ra) # 80005e18 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028e6:	974a                	add	a4,a4,s2
    800028e8:	8fd5                	or	a5,a5,a3
    800028ea:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800028ee:	854a                	mv	a0,s2
    800028f0:	00001097          	auipc	ra,0x1
    800028f4:	01a080e7          	jalr	26(ra) # 8000390a <log_write>
        brelse(bp);
    800028f8:	854a                	mv	a0,s2
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	d94080e7          	jalr	-620(ra) # 8000268e <brelse>
  bp = bread(dev, bno);
    80002902:	85a6                	mv	a1,s1
    80002904:	855e                	mv	a0,s7
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	c58080e7          	jalr	-936(ra) # 8000255e <bread>
    8000290e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002910:	40000613          	li	a2,1024
    80002914:	4581                	li	a1,0
    80002916:	05850513          	addi	a0,a0,88
    8000291a:	ffffe097          	auipc	ra,0xffffe
    8000291e:	910080e7          	jalr	-1776(ra) # 8000022a <memset>
  log_write(bp);
    80002922:	854a                	mv	a0,s2
    80002924:	00001097          	auipc	ra,0x1
    80002928:	fe6080e7          	jalr	-26(ra) # 8000390a <log_write>
  brelse(bp);
    8000292c:	854a                	mv	a0,s2
    8000292e:	00000097          	auipc	ra,0x0
    80002932:	d60080e7          	jalr	-672(ra) # 8000268e <brelse>
}
    80002936:	8526                	mv	a0,s1
    80002938:	60e6                	ld	ra,88(sp)
    8000293a:	6446                	ld	s0,80(sp)
    8000293c:	64a6                	ld	s1,72(sp)
    8000293e:	6906                	ld	s2,64(sp)
    80002940:	79e2                	ld	s3,56(sp)
    80002942:	7a42                	ld	s4,48(sp)
    80002944:	7aa2                	ld	s5,40(sp)
    80002946:	7b02                	ld	s6,32(sp)
    80002948:	6be2                	ld	s7,24(sp)
    8000294a:	6c42                	ld	s8,16(sp)
    8000294c:	6ca2                	ld	s9,8(sp)
    8000294e:	6125                	addi	sp,sp,96
    80002950:	8082                	ret

0000000080002952 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002952:	7179                	addi	sp,sp,-48
    80002954:	f406                	sd	ra,40(sp)
    80002956:	f022                	sd	s0,32(sp)
    80002958:	ec26                	sd	s1,24(sp)
    8000295a:	e84a                	sd	s2,16(sp)
    8000295c:	e44e                	sd	s3,8(sp)
    8000295e:	e052                	sd	s4,0(sp)
    80002960:	1800                	addi	s0,sp,48
    80002962:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002964:	47ad                	li	a5,11
    80002966:	04b7fe63          	bgeu	a5,a1,800029c2 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000296a:	ff45849b          	addiw	s1,a1,-12
    8000296e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002972:	0ff00793          	li	a5,255
    80002976:	0ae7e363          	bltu	a5,a4,80002a1c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000297a:	08052583          	lw	a1,128(a0)
    8000297e:	c5ad                	beqz	a1,800029e8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002980:	00092503          	lw	a0,0(s2)
    80002984:	00000097          	auipc	ra,0x0
    80002988:	bda080e7          	jalr	-1062(ra) # 8000255e <bread>
    8000298c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000298e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002992:	02049593          	slli	a1,s1,0x20
    80002996:	9181                	srli	a1,a1,0x20
    80002998:	058a                	slli	a1,a1,0x2
    8000299a:	00b784b3          	add	s1,a5,a1
    8000299e:	0004a983          	lw	s3,0(s1)
    800029a2:	04098d63          	beqz	s3,800029fc <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029a6:	8552                	mv	a0,s4
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	ce6080e7          	jalr	-794(ra) # 8000268e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029b0:	854e                	mv	a0,s3
    800029b2:	70a2                	ld	ra,40(sp)
    800029b4:	7402                	ld	s0,32(sp)
    800029b6:	64e2                	ld	s1,24(sp)
    800029b8:	6942                	ld	s2,16(sp)
    800029ba:	69a2                	ld	s3,8(sp)
    800029bc:	6a02                	ld	s4,0(sp)
    800029be:	6145                	addi	sp,sp,48
    800029c0:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029c2:	02059493          	slli	s1,a1,0x20
    800029c6:	9081                	srli	s1,s1,0x20
    800029c8:	048a                	slli	s1,s1,0x2
    800029ca:	94aa                	add	s1,s1,a0
    800029cc:	0504a983          	lw	s3,80(s1)
    800029d0:	fe0990e3          	bnez	s3,800029b0 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029d4:	4108                	lw	a0,0(a0)
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	e4a080e7          	jalr	-438(ra) # 80002820 <balloc>
    800029de:	0005099b          	sext.w	s3,a0
    800029e2:	0534a823          	sw	s3,80(s1)
    800029e6:	b7e9                	j	800029b0 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029e8:	4108                	lw	a0,0(a0)
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	e36080e7          	jalr	-458(ra) # 80002820 <balloc>
    800029f2:	0005059b          	sext.w	a1,a0
    800029f6:	08b92023          	sw	a1,128(s2)
    800029fa:	b759                	j	80002980 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029fc:	00092503          	lw	a0,0(s2)
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	e20080e7          	jalr	-480(ra) # 80002820 <balloc>
    80002a08:	0005099b          	sext.w	s3,a0
    80002a0c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a10:	8552                	mv	a0,s4
    80002a12:	00001097          	auipc	ra,0x1
    80002a16:	ef8080e7          	jalr	-264(ra) # 8000390a <log_write>
    80002a1a:	b771                	j	800029a6 <bmap+0x54>
  panic("bmap: out of range");
    80002a1c:	00006517          	auipc	a0,0x6
    80002a20:	b5450513          	addi	a0,a0,-1196 # 80008570 <syscalls+0x118>
    80002a24:	00003097          	auipc	ra,0x3
    80002a28:	3f4080e7          	jalr	1012(ra) # 80005e18 <panic>

0000000080002a2c <iget>:
{
    80002a2c:	7179                	addi	sp,sp,-48
    80002a2e:	f406                	sd	ra,40(sp)
    80002a30:	f022                	sd	s0,32(sp)
    80002a32:	ec26                	sd	s1,24(sp)
    80002a34:	e84a                	sd	s2,16(sp)
    80002a36:	e44e                	sd	s3,8(sp)
    80002a38:	e052                	sd	s4,0(sp)
    80002a3a:	1800                	addi	s0,sp,48
    80002a3c:	89aa                	mv	s3,a0
    80002a3e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a40:	00035517          	auipc	a0,0x35
    80002a44:	d3850513          	addi	a0,a0,-712 # 80037778 <itable>
    80002a48:	00004097          	auipc	ra,0x4
    80002a4c:	986080e7          	jalr	-1658(ra) # 800063ce <acquire>
  empty = 0;
    80002a50:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a52:	00035497          	auipc	s1,0x35
    80002a56:	d3e48493          	addi	s1,s1,-706 # 80037790 <itable+0x18>
    80002a5a:	00036697          	auipc	a3,0x36
    80002a5e:	7c668693          	addi	a3,a3,1990 # 80039220 <log>
    80002a62:	a039                	j	80002a70 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a64:	02090b63          	beqz	s2,80002a9a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a68:	08848493          	addi	s1,s1,136
    80002a6c:	02d48a63          	beq	s1,a3,80002aa0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a70:	449c                	lw	a5,8(s1)
    80002a72:	fef059e3          	blez	a5,80002a64 <iget+0x38>
    80002a76:	4098                	lw	a4,0(s1)
    80002a78:	ff3716e3          	bne	a4,s3,80002a64 <iget+0x38>
    80002a7c:	40d8                	lw	a4,4(s1)
    80002a7e:	ff4713e3          	bne	a4,s4,80002a64 <iget+0x38>
      ip->ref++;
    80002a82:	2785                	addiw	a5,a5,1
    80002a84:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a86:	00035517          	auipc	a0,0x35
    80002a8a:	cf250513          	addi	a0,a0,-782 # 80037778 <itable>
    80002a8e:	00004097          	auipc	ra,0x4
    80002a92:	9f4080e7          	jalr	-1548(ra) # 80006482 <release>
      return ip;
    80002a96:	8926                	mv	s2,s1
    80002a98:	a03d                	j	80002ac6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a9a:	f7f9                	bnez	a5,80002a68 <iget+0x3c>
    80002a9c:	8926                	mv	s2,s1
    80002a9e:	b7e9                	j	80002a68 <iget+0x3c>
  if(empty == 0)
    80002aa0:	02090c63          	beqz	s2,80002ad8 <iget+0xac>
  ip->dev = dev;
    80002aa4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002aa8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aac:	4785                	li	a5,1
    80002aae:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ab2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ab6:	00035517          	auipc	a0,0x35
    80002aba:	cc250513          	addi	a0,a0,-830 # 80037778 <itable>
    80002abe:	00004097          	auipc	ra,0x4
    80002ac2:	9c4080e7          	jalr	-1596(ra) # 80006482 <release>
}
    80002ac6:	854a                	mv	a0,s2
    80002ac8:	70a2                	ld	ra,40(sp)
    80002aca:	7402                	ld	s0,32(sp)
    80002acc:	64e2                	ld	s1,24(sp)
    80002ace:	6942                	ld	s2,16(sp)
    80002ad0:	69a2                	ld	s3,8(sp)
    80002ad2:	6a02                	ld	s4,0(sp)
    80002ad4:	6145                	addi	sp,sp,48
    80002ad6:	8082                	ret
    panic("iget: no inodes");
    80002ad8:	00006517          	auipc	a0,0x6
    80002adc:	ab050513          	addi	a0,a0,-1360 # 80008588 <syscalls+0x130>
    80002ae0:	00003097          	auipc	ra,0x3
    80002ae4:	338080e7          	jalr	824(ra) # 80005e18 <panic>

0000000080002ae8 <fsinit>:
fsinit(int dev) {
    80002ae8:	7179                	addi	sp,sp,-48
    80002aea:	f406                	sd	ra,40(sp)
    80002aec:	f022                	sd	s0,32(sp)
    80002aee:	ec26                	sd	s1,24(sp)
    80002af0:	e84a                	sd	s2,16(sp)
    80002af2:	e44e                	sd	s3,8(sp)
    80002af4:	1800                	addi	s0,sp,48
    80002af6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002af8:	4585                	li	a1,1
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	a64080e7          	jalr	-1436(ra) # 8000255e <bread>
    80002b02:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b04:	00035997          	auipc	s3,0x35
    80002b08:	c5498993          	addi	s3,s3,-940 # 80037758 <sb>
    80002b0c:	02000613          	li	a2,32
    80002b10:	05850593          	addi	a1,a0,88
    80002b14:	854e                	mv	a0,s3
    80002b16:	ffffd097          	auipc	ra,0xffffd
    80002b1a:	774080e7          	jalr	1908(ra) # 8000028a <memmove>
  brelse(bp);
    80002b1e:	8526                	mv	a0,s1
    80002b20:	00000097          	auipc	ra,0x0
    80002b24:	b6e080e7          	jalr	-1170(ra) # 8000268e <brelse>
  if(sb.magic != FSMAGIC)
    80002b28:	0009a703          	lw	a4,0(s3)
    80002b2c:	102037b7          	lui	a5,0x10203
    80002b30:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b34:	02f71263          	bne	a4,a5,80002b58 <fsinit+0x70>
  initlog(dev, &sb);
    80002b38:	00035597          	auipc	a1,0x35
    80002b3c:	c2058593          	addi	a1,a1,-992 # 80037758 <sb>
    80002b40:	854a                	mv	a0,s2
    80002b42:	00001097          	auipc	ra,0x1
    80002b46:	b4c080e7          	jalr	-1204(ra) # 8000368e <initlog>
}
    80002b4a:	70a2                	ld	ra,40(sp)
    80002b4c:	7402                	ld	s0,32(sp)
    80002b4e:	64e2                	ld	s1,24(sp)
    80002b50:	6942                	ld	s2,16(sp)
    80002b52:	69a2                	ld	s3,8(sp)
    80002b54:	6145                	addi	sp,sp,48
    80002b56:	8082                	ret
    panic("invalid file system");
    80002b58:	00006517          	auipc	a0,0x6
    80002b5c:	a4050513          	addi	a0,a0,-1472 # 80008598 <syscalls+0x140>
    80002b60:	00003097          	auipc	ra,0x3
    80002b64:	2b8080e7          	jalr	696(ra) # 80005e18 <panic>

0000000080002b68 <iinit>:
{
    80002b68:	7179                	addi	sp,sp,-48
    80002b6a:	f406                	sd	ra,40(sp)
    80002b6c:	f022                	sd	s0,32(sp)
    80002b6e:	ec26                	sd	s1,24(sp)
    80002b70:	e84a                	sd	s2,16(sp)
    80002b72:	e44e                	sd	s3,8(sp)
    80002b74:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b76:	00006597          	auipc	a1,0x6
    80002b7a:	a3a58593          	addi	a1,a1,-1478 # 800085b0 <syscalls+0x158>
    80002b7e:	00035517          	auipc	a0,0x35
    80002b82:	bfa50513          	addi	a0,a0,-1030 # 80037778 <itable>
    80002b86:	00003097          	auipc	ra,0x3
    80002b8a:	7b8080e7          	jalr	1976(ra) # 8000633e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b8e:	00035497          	auipc	s1,0x35
    80002b92:	c1248493          	addi	s1,s1,-1006 # 800377a0 <itable+0x28>
    80002b96:	00036997          	auipc	s3,0x36
    80002b9a:	69a98993          	addi	s3,s3,1690 # 80039230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b9e:	00006917          	auipc	s2,0x6
    80002ba2:	a1a90913          	addi	s2,s2,-1510 # 800085b8 <syscalls+0x160>
    80002ba6:	85ca                	mv	a1,s2
    80002ba8:	8526                	mv	a0,s1
    80002baa:	00001097          	auipc	ra,0x1
    80002bae:	e46080e7          	jalr	-442(ra) # 800039f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bb2:	08848493          	addi	s1,s1,136
    80002bb6:	ff3498e3          	bne	s1,s3,80002ba6 <iinit+0x3e>
}
    80002bba:	70a2                	ld	ra,40(sp)
    80002bbc:	7402                	ld	s0,32(sp)
    80002bbe:	64e2                	ld	s1,24(sp)
    80002bc0:	6942                	ld	s2,16(sp)
    80002bc2:	69a2                	ld	s3,8(sp)
    80002bc4:	6145                	addi	sp,sp,48
    80002bc6:	8082                	ret

0000000080002bc8 <ialloc>:
{
    80002bc8:	715d                	addi	sp,sp,-80
    80002bca:	e486                	sd	ra,72(sp)
    80002bcc:	e0a2                	sd	s0,64(sp)
    80002bce:	fc26                	sd	s1,56(sp)
    80002bd0:	f84a                	sd	s2,48(sp)
    80002bd2:	f44e                	sd	s3,40(sp)
    80002bd4:	f052                	sd	s4,32(sp)
    80002bd6:	ec56                	sd	s5,24(sp)
    80002bd8:	e85a                	sd	s6,16(sp)
    80002bda:	e45e                	sd	s7,8(sp)
    80002bdc:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bde:	00035717          	auipc	a4,0x35
    80002be2:	b8672703          	lw	a4,-1146(a4) # 80037764 <sb+0xc>
    80002be6:	4785                	li	a5,1
    80002be8:	04e7fa63          	bgeu	a5,a4,80002c3c <ialloc+0x74>
    80002bec:	8aaa                	mv	s5,a0
    80002bee:	8bae                	mv	s7,a1
    80002bf0:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bf2:	00035a17          	auipc	s4,0x35
    80002bf6:	b66a0a13          	addi	s4,s4,-1178 # 80037758 <sb>
    80002bfa:	00048b1b          	sext.w	s6,s1
    80002bfe:	0044d593          	srli	a1,s1,0x4
    80002c02:	018a2783          	lw	a5,24(s4)
    80002c06:	9dbd                	addw	a1,a1,a5
    80002c08:	8556                	mv	a0,s5
    80002c0a:	00000097          	auipc	ra,0x0
    80002c0e:	954080e7          	jalr	-1708(ra) # 8000255e <bread>
    80002c12:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c14:	05850993          	addi	s3,a0,88
    80002c18:	00f4f793          	andi	a5,s1,15
    80002c1c:	079a                	slli	a5,a5,0x6
    80002c1e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c20:	00099783          	lh	a5,0(s3)
    80002c24:	c785                	beqz	a5,80002c4c <ialloc+0x84>
    brelse(bp);
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	a68080e7          	jalr	-1432(ra) # 8000268e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c2e:	0485                	addi	s1,s1,1
    80002c30:	00ca2703          	lw	a4,12(s4)
    80002c34:	0004879b          	sext.w	a5,s1
    80002c38:	fce7e1e3          	bltu	a5,a4,80002bfa <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c3c:	00006517          	auipc	a0,0x6
    80002c40:	98450513          	addi	a0,a0,-1660 # 800085c0 <syscalls+0x168>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	1d4080e7          	jalr	468(ra) # 80005e18 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c4c:	04000613          	li	a2,64
    80002c50:	4581                	li	a1,0
    80002c52:	854e                	mv	a0,s3
    80002c54:	ffffd097          	auipc	ra,0xffffd
    80002c58:	5d6080e7          	jalr	1494(ra) # 8000022a <memset>
      dip->type = type;
    80002c5c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c60:	854a                	mv	a0,s2
    80002c62:	00001097          	auipc	ra,0x1
    80002c66:	ca8080e7          	jalr	-856(ra) # 8000390a <log_write>
      brelse(bp);
    80002c6a:	854a                	mv	a0,s2
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	a22080e7          	jalr	-1502(ra) # 8000268e <brelse>
      return iget(dev, inum);
    80002c74:	85da                	mv	a1,s6
    80002c76:	8556                	mv	a0,s5
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	db4080e7          	jalr	-588(ra) # 80002a2c <iget>
}
    80002c80:	60a6                	ld	ra,72(sp)
    80002c82:	6406                	ld	s0,64(sp)
    80002c84:	74e2                	ld	s1,56(sp)
    80002c86:	7942                	ld	s2,48(sp)
    80002c88:	79a2                	ld	s3,40(sp)
    80002c8a:	7a02                	ld	s4,32(sp)
    80002c8c:	6ae2                	ld	s5,24(sp)
    80002c8e:	6b42                	ld	s6,16(sp)
    80002c90:	6ba2                	ld	s7,8(sp)
    80002c92:	6161                	addi	sp,sp,80
    80002c94:	8082                	ret

0000000080002c96 <iupdate>:
{
    80002c96:	1101                	addi	sp,sp,-32
    80002c98:	ec06                	sd	ra,24(sp)
    80002c9a:	e822                	sd	s0,16(sp)
    80002c9c:	e426                	sd	s1,8(sp)
    80002c9e:	e04a                	sd	s2,0(sp)
    80002ca0:	1000                	addi	s0,sp,32
    80002ca2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ca4:	415c                	lw	a5,4(a0)
    80002ca6:	0047d79b          	srliw	a5,a5,0x4
    80002caa:	00035597          	auipc	a1,0x35
    80002cae:	ac65a583          	lw	a1,-1338(a1) # 80037770 <sb+0x18>
    80002cb2:	9dbd                	addw	a1,a1,a5
    80002cb4:	4108                	lw	a0,0(a0)
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	8a8080e7          	jalr	-1880(ra) # 8000255e <bread>
    80002cbe:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc0:	05850793          	addi	a5,a0,88
    80002cc4:	40c8                	lw	a0,4(s1)
    80002cc6:	893d                	andi	a0,a0,15
    80002cc8:	051a                	slli	a0,a0,0x6
    80002cca:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002ccc:	04449703          	lh	a4,68(s1)
    80002cd0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002cd4:	04649703          	lh	a4,70(s1)
    80002cd8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cdc:	04849703          	lh	a4,72(s1)
    80002ce0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ce4:	04a49703          	lh	a4,74(s1)
    80002ce8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002cec:	44f8                	lw	a4,76(s1)
    80002cee:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cf0:	03400613          	li	a2,52
    80002cf4:	05048593          	addi	a1,s1,80
    80002cf8:	0531                	addi	a0,a0,12
    80002cfa:	ffffd097          	auipc	ra,0xffffd
    80002cfe:	590080e7          	jalr	1424(ra) # 8000028a <memmove>
  log_write(bp);
    80002d02:	854a                	mv	a0,s2
    80002d04:	00001097          	auipc	ra,0x1
    80002d08:	c06080e7          	jalr	-1018(ra) # 8000390a <log_write>
  brelse(bp);
    80002d0c:	854a                	mv	a0,s2
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	980080e7          	jalr	-1664(ra) # 8000268e <brelse>
}
    80002d16:	60e2                	ld	ra,24(sp)
    80002d18:	6442                	ld	s0,16(sp)
    80002d1a:	64a2                	ld	s1,8(sp)
    80002d1c:	6902                	ld	s2,0(sp)
    80002d1e:	6105                	addi	sp,sp,32
    80002d20:	8082                	ret

0000000080002d22 <idup>:
{
    80002d22:	1101                	addi	sp,sp,-32
    80002d24:	ec06                	sd	ra,24(sp)
    80002d26:	e822                	sd	s0,16(sp)
    80002d28:	e426                	sd	s1,8(sp)
    80002d2a:	1000                	addi	s0,sp,32
    80002d2c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d2e:	00035517          	auipc	a0,0x35
    80002d32:	a4a50513          	addi	a0,a0,-1462 # 80037778 <itable>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	698080e7          	jalr	1688(ra) # 800063ce <acquire>
  ip->ref++;
    80002d3e:	449c                	lw	a5,8(s1)
    80002d40:	2785                	addiw	a5,a5,1
    80002d42:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d44:	00035517          	auipc	a0,0x35
    80002d48:	a3450513          	addi	a0,a0,-1484 # 80037778 <itable>
    80002d4c:	00003097          	auipc	ra,0x3
    80002d50:	736080e7          	jalr	1846(ra) # 80006482 <release>
}
    80002d54:	8526                	mv	a0,s1
    80002d56:	60e2                	ld	ra,24(sp)
    80002d58:	6442                	ld	s0,16(sp)
    80002d5a:	64a2                	ld	s1,8(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret

0000000080002d60 <ilock>:
{
    80002d60:	1101                	addi	sp,sp,-32
    80002d62:	ec06                	sd	ra,24(sp)
    80002d64:	e822                	sd	s0,16(sp)
    80002d66:	e426                	sd	s1,8(sp)
    80002d68:	e04a                	sd	s2,0(sp)
    80002d6a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d6c:	c115                	beqz	a0,80002d90 <ilock+0x30>
    80002d6e:	84aa                	mv	s1,a0
    80002d70:	451c                	lw	a5,8(a0)
    80002d72:	00f05f63          	blez	a5,80002d90 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d76:	0541                	addi	a0,a0,16
    80002d78:	00001097          	auipc	ra,0x1
    80002d7c:	cb2080e7          	jalr	-846(ra) # 80003a2a <acquiresleep>
  if(ip->valid == 0){
    80002d80:	40bc                	lw	a5,64(s1)
    80002d82:	cf99                	beqz	a5,80002da0 <ilock+0x40>
}
    80002d84:	60e2                	ld	ra,24(sp)
    80002d86:	6442                	ld	s0,16(sp)
    80002d88:	64a2                	ld	s1,8(sp)
    80002d8a:	6902                	ld	s2,0(sp)
    80002d8c:	6105                	addi	sp,sp,32
    80002d8e:	8082                	ret
    panic("ilock");
    80002d90:	00006517          	auipc	a0,0x6
    80002d94:	84850513          	addi	a0,a0,-1976 # 800085d8 <syscalls+0x180>
    80002d98:	00003097          	auipc	ra,0x3
    80002d9c:	080080e7          	jalr	128(ra) # 80005e18 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002da0:	40dc                	lw	a5,4(s1)
    80002da2:	0047d79b          	srliw	a5,a5,0x4
    80002da6:	00035597          	auipc	a1,0x35
    80002daa:	9ca5a583          	lw	a1,-1590(a1) # 80037770 <sb+0x18>
    80002dae:	9dbd                	addw	a1,a1,a5
    80002db0:	4088                	lw	a0,0(s1)
    80002db2:	fffff097          	auipc	ra,0xfffff
    80002db6:	7ac080e7          	jalr	1964(ra) # 8000255e <bread>
    80002dba:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dbc:	05850593          	addi	a1,a0,88
    80002dc0:	40dc                	lw	a5,4(s1)
    80002dc2:	8bbd                	andi	a5,a5,15
    80002dc4:	079a                	slli	a5,a5,0x6
    80002dc6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dc8:	00059783          	lh	a5,0(a1)
    80002dcc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dd0:	00259783          	lh	a5,2(a1)
    80002dd4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002dd8:	00459783          	lh	a5,4(a1)
    80002ddc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002de0:	00659783          	lh	a5,6(a1)
    80002de4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002de8:	459c                	lw	a5,8(a1)
    80002dea:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002dec:	03400613          	li	a2,52
    80002df0:	05b1                	addi	a1,a1,12
    80002df2:	05048513          	addi	a0,s1,80
    80002df6:	ffffd097          	auipc	ra,0xffffd
    80002dfa:	494080e7          	jalr	1172(ra) # 8000028a <memmove>
    brelse(bp);
    80002dfe:	854a                	mv	a0,s2
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	88e080e7          	jalr	-1906(ra) # 8000268e <brelse>
    ip->valid = 1;
    80002e08:	4785                	li	a5,1
    80002e0a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e0c:	04449783          	lh	a5,68(s1)
    80002e10:	fbb5                	bnez	a5,80002d84 <ilock+0x24>
      panic("ilock: no type");
    80002e12:	00005517          	auipc	a0,0x5
    80002e16:	7ce50513          	addi	a0,a0,1998 # 800085e0 <syscalls+0x188>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	ffe080e7          	jalr	-2(ra) # 80005e18 <panic>

0000000080002e22 <iunlock>:
{
    80002e22:	1101                	addi	sp,sp,-32
    80002e24:	ec06                	sd	ra,24(sp)
    80002e26:	e822                	sd	s0,16(sp)
    80002e28:	e426                	sd	s1,8(sp)
    80002e2a:	e04a                	sd	s2,0(sp)
    80002e2c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e2e:	c905                	beqz	a0,80002e5e <iunlock+0x3c>
    80002e30:	84aa                	mv	s1,a0
    80002e32:	01050913          	addi	s2,a0,16
    80002e36:	854a                	mv	a0,s2
    80002e38:	00001097          	auipc	ra,0x1
    80002e3c:	c8c080e7          	jalr	-884(ra) # 80003ac4 <holdingsleep>
    80002e40:	cd19                	beqz	a0,80002e5e <iunlock+0x3c>
    80002e42:	449c                	lw	a5,8(s1)
    80002e44:	00f05d63          	blez	a5,80002e5e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	00001097          	auipc	ra,0x1
    80002e4e:	c36080e7          	jalr	-970(ra) # 80003a80 <releasesleep>
}
    80002e52:	60e2                	ld	ra,24(sp)
    80002e54:	6442                	ld	s0,16(sp)
    80002e56:	64a2                	ld	s1,8(sp)
    80002e58:	6902                	ld	s2,0(sp)
    80002e5a:	6105                	addi	sp,sp,32
    80002e5c:	8082                	ret
    panic("iunlock");
    80002e5e:	00005517          	auipc	a0,0x5
    80002e62:	79250513          	addi	a0,a0,1938 # 800085f0 <syscalls+0x198>
    80002e66:	00003097          	auipc	ra,0x3
    80002e6a:	fb2080e7          	jalr	-78(ra) # 80005e18 <panic>

0000000080002e6e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e6e:	7179                	addi	sp,sp,-48
    80002e70:	f406                	sd	ra,40(sp)
    80002e72:	f022                	sd	s0,32(sp)
    80002e74:	ec26                	sd	s1,24(sp)
    80002e76:	e84a                	sd	s2,16(sp)
    80002e78:	e44e                	sd	s3,8(sp)
    80002e7a:	e052                	sd	s4,0(sp)
    80002e7c:	1800                	addi	s0,sp,48
    80002e7e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e80:	05050493          	addi	s1,a0,80
    80002e84:	08050913          	addi	s2,a0,128
    80002e88:	a021                	j	80002e90 <itrunc+0x22>
    80002e8a:	0491                	addi	s1,s1,4
    80002e8c:	01248d63          	beq	s1,s2,80002ea6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e90:	408c                	lw	a1,0(s1)
    80002e92:	dde5                	beqz	a1,80002e8a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e94:	0009a503          	lw	a0,0(s3)
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	90c080e7          	jalr	-1780(ra) # 800027a4 <bfree>
      ip->addrs[i] = 0;
    80002ea0:	0004a023          	sw	zero,0(s1)
    80002ea4:	b7dd                	j	80002e8a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ea6:	0809a583          	lw	a1,128(s3)
    80002eaa:	e185                	bnez	a1,80002eca <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eac:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002eb0:	854e                	mv	a0,s3
    80002eb2:	00000097          	auipc	ra,0x0
    80002eb6:	de4080e7          	jalr	-540(ra) # 80002c96 <iupdate>
}
    80002eba:	70a2                	ld	ra,40(sp)
    80002ebc:	7402                	ld	s0,32(sp)
    80002ebe:	64e2                	ld	s1,24(sp)
    80002ec0:	6942                	ld	s2,16(sp)
    80002ec2:	69a2                	ld	s3,8(sp)
    80002ec4:	6a02                	ld	s4,0(sp)
    80002ec6:	6145                	addi	sp,sp,48
    80002ec8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002eca:	0009a503          	lw	a0,0(s3)
    80002ece:	fffff097          	auipc	ra,0xfffff
    80002ed2:	690080e7          	jalr	1680(ra) # 8000255e <bread>
    80002ed6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ed8:	05850493          	addi	s1,a0,88
    80002edc:	45850913          	addi	s2,a0,1112
    80002ee0:	a811                	j	80002ef4 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ee2:	0009a503          	lw	a0,0(s3)
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	8be080e7          	jalr	-1858(ra) # 800027a4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002eee:	0491                	addi	s1,s1,4
    80002ef0:	01248563          	beq	s1,s2,80002efa <itrunc+0x8c>
      if(a[j])
    80002ef4:	408c                	lw	a1,0(s1)
    80002ef6:	dde5                	beqz	a1,80002eee <itrunc+0x80>
    80002ef8:	b7ed                	j	80002ee2 <itrunc+0x74>
    brelse(bp);
    80002efa:	8552                	mv	a0,s4
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	792080e7          	jalr	1938(ra) # 8000268e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f04:	0809a583          	lw	a1,128(s3)
    80002f08:	0009a503          	lw	a0,0(s3)
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	898080e7          	jalr	-1896(ra) # 800027a4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f14:	0809a023          	sw	zero,128(s3)
    80002f18:	bf51                	j	80002eac <itrunc+0x3e>

0000000080002f1a <iput>:
{
    80002f1a:	1101                	addi	sp,sp,-32
    80002f1c:	ec06                	sd	ra,24(sp)
    80002f1e:	e822                	sd	s0,16(sp)
    80002f20:	e426                	sd	s1,8(sp)
    80002f22:	e04a                	sd	s2,0(sp)
    80002f24:	1000                	addi	s0,sp,32
    80002f26:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f28:	00035517          	auipc	a0,0x35
    80002f2c:	85050513          	addi	a0,a0,-1968 # 80037778 <itable>
    80002f30:	00003097          	auipc	ra,0x3
    80002f34:	49e080e7          	jalr	1182(ra) # 800063ce <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f38:	4498                	lw	a4,8(s1)
    80002f3a:	4785                	li	a5,1
    80002f3c:	02f70363          	beq	a4,a5,80002f62 <iput+0x48>
  ip->ref--;
    80002f40:	449c                	lw	a5,8(s1)
    80002f42:	37fd                	addiw	a5,a5,-1
    80002f44:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f46:	00035517          	auipc	a0,0x35
    80002f4a:	83250513          	addi	a0,a0,-1998 # 80037778 <itable>
    80002f4e:	00003097          	auipc	ra,0x3
    80002f52:	534080e7          	jalr	1332(ra) # 80006482 <release>
}
    80002f56:	60e2                	ld	ra,24(sp)
    80002f58:	6442                	ld	s0,16(sp)
    80002f5a:	64a2                	ld	s1,8(sp)
    80002f5c:	6902                	ld	s2,0(sp)
    80002f5e:	6105                	addi	sp,sp,32
    80002f60:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f62:	40bc                	lw	a5,64(s1)
    80002f64:	dff1                	beqz	a5,80002f40 <iput+0x26>
    80002f66:	04a49783          	lh	a5,74(s1)
    80002f6a:	fbf9                	bnez	a5,80002f40 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f6c:	01048913          	addi	s2,s1,16
    80002f70:	854a                	mv	a0,s2
    80002f72:	00001097          	auipc	ra,0x1
    80002f76:	ab8080e7          	jalr	-1352(ra) # 80003a2a <acquiresleep>
    release(&itable.lock);
    80002f7a:	00034517          	auipc	a0,0x34
    80002f7e:	7fe50513          	addi	a0,a0,2046 # 80037778 <itable>
    80002f82:	00003097          	auipc	ra,0x3
    80002f86:	500080e7          	jalr	1280(ra) # 80006482 <release>
    itrunc(ip);
    80002f8a:	8526                	mv	a0,s1
    80002f8c:	00000097          	auipc	ra,0x0
    80002f90:	ee2080e7          	jalr	-286(ra) # 80002e6e <itrunc>
    ip->type = 0;
    80002f94:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f98:	8526                	mv	a0,s1
    80002f9a:	00000097          	auipc	ra,0x0
    80002f9e:	cfc080e7          	jalr	-772(ra) # 80002c96 <iupdate>
    ip->valid = 0;
    80002fa2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fa6:	854a                	mv	a0,s2
    80002fa8:	00001097          	auipc	ra,0x1
    80002fac:	ad8080e7          	jalr	-1320(ra) # 80003a80 <releasesleep>
    acquire(&itable.lock);
    80002fb0:	00034517          	auipc	a0,0x34
    80002fb4:	7c850513          	addi	a0,a0,1992 # 80037778 <itable>
    80002fb8:	00003097          	auipc	ra,0x3
    80002fbc:	416080e7          	jalr	1046(ra) # 800063ce <acquire>
    80002fc0:	b741                	j	80002f40 <iput+0x26>

0000000080002fc2 <iunlockput>:
{
    80002fc2:	1101                	addi	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	e426                	sd	s1,8(sp)
    80002fca:	1000                	addi	s0,sp,32
    80002fcc:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fce:	00000097          	auipc	ra,0x0
    80002fd2:	e54080e7          	jalr	-428(ra) # 80002e22 <iunlock>
  iput(ip);
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	f42080e7          	jalr	-190(ra) # 80002f1a <iput>
}
    80002fe0:	60e2                	ld	ra,24(sp)
    80002fe2:	6442                	ld	s0,16(sp)
    80002fe4:	64a2                	ld	s1,8(sp)
    80002fe6:	6105                	addi	sp,sp,32
    80002fe8:	8082                	ret

0000000080002fea <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fea:	1141                	addi	sp,sp,-16
    80002fec:	e422                	sd	s0,8(sp)
    80002fee:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ff0:	411c                	lw	a5,0(a0)
    80002ff2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ff4:	415c                	lw	a5,4(a0)
    80002ff6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ff8:	04451783          	lh	a5,68(a0)
    80002ffc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003000:	04a51783          	lh	a5,74(a0)
    80003004:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003008:	04c56783          	lwu	a5,76(a0)
    8000300c:	e99c                	sd	a5,16(a1)
}
    8000300e:	6422                	ld	s0,8(sp)
    80003010:	0141                	addi	sp,sp,16
    80003012:	8082                	ret

0000000080003014 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003014:	457c                	lw	a5,76(a0)
    80003016:	0ed7e963          	bltu	a5,a3,80003108 <readi+0xf4>
{
    8000301a:	7159                	addi	sp,sp,-112
    8000301c:	f486                	sd	ra,104(sp)
    8000301e:	f0a2                	sd	s0,96(sp)
    80003020:	eca6                	sd	s1,88(sp)
    80003022:	e8ca                	sd	s2,80(sp)
    80003024:	e4ce                	sd	s3,72(sp)
    80003026:	e0d2                	sd	s4,64(sp)
    80003028:	fc56                	sd	s5,56(sp)
    8000302a:	f85a                	sd	s6,48(sp)
    8000302c:	f45e                	sd	s7,40(sp)
    8000302e:	f062                	sd	s8,32(sp)
    80003030:	ec66                	sd	s9,24(sp)
    80003032:	e86a                	sd	s10,16(sp)
    80003034:	e46e                	sd	s11,8(sp)
    80003036:	1880                	addi	s0,sp,112
    80003038:	8baa                	mv	s7,a0
    8000303a:	8c2e                	mv	s8,a1
    8000303c:	8ab2                	mv	s5,a2
    8000303e:	84b6                	mv	s1,a3
    80003040:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003042:	9f35                	addw	a4,a4,a3
    return 0;
    80003044:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003046:	0ad76063          	bltu	a4,a3,800030e6 <readi+0xd2>
  if(off + n > ip->size)
    8000304a:	00e7f463          	bgeu	a5,a4,80003052 <readi+0x3e>
    n = ip->size - off;
    8000304e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003052:	0a0b0963          	beqz	s6,80003104 <readi+0xf0>
    80003056:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003058:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000305c:	5cfd                	li	s9,-1
    8000305e:	a82d                	j	80003098 <readi+0x84>
    80003060:	020a1d93          	slli	s11,s4,0x20
    80003064:	020ddd93          	srli	s11,s11,0x20
    80003068:	05890613          	addi	a2,s2,88
    8000306c:	86ee                	mv	a3,s11
    8000306e:	963a                	add	a2,a2,a4
    80003070:	85d6                	mv	a1,s5
    80003072:	8562                	mv	a0,s8
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	9fe080e7          	jalr	-1538(ra) # 80001a72 <either_copyout>
    8000307c:	05950d63          	beq	a0,s9,800030d6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003080:	854a                	mv	a0,s2
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	60c080e7          	jalr	1548(ra) # 8000268e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000308a:	013a09bb          	addw	s3,s4,s3
    8000308e:	009a04bb          	addw	s1,s4,s1
    80003092:	9aee                	add	s5,s5,s11
    80003094:	0569f763          	bgeu	s3,s6,800030e2 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003098:	000ba903          	lw	s2,0(s7)
    8000309c:	00a4d59b          	srliw	a1,s1,0xa
    800030a0:	855e                	mv	a0,s7
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	8b0080e7          	jalr	-1872(ra) # 80002952 <bmap>
    800030aa:	0005059b          	sext.w	a1,a0
    800030ae:	854a                	mv	a0,s2
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	4ae080e7          	jalr	1198(ra) # 8000255e <bread>
    800030b8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ba:	3ff4f713          	andi	a4,s1,1023
    800030be:	40ed07bb          	subw	a5,s10,a4
    800030c2:	413b06bb          	subw	a3,s6,s3
    800030c6:	8a3e                	mv	s4,a5
    800030c8:	2781                	sext.w	a5,a5
    800030ca:	0006861b          	sext.w	a2,a3
    800030ce:	f8f679e3          	bgeu	a2,a5,80003060 <readi+0x4c>
    800030d2:	8a36                	mv	s4,a3
    800030d4:	b771                	j	80003060 <readi+0x4c>
      brelse(bp);
    800030d6:	854a                	mv	a0,s2
    800030d8:	fffff097          	auipc	ra,0xfffff
    800030dc:	5b6080e7          	jalr	1462(ra) # 8000268e <brelse>
      tot = -1;
    800030e0:	59fd                	li	s3,-1
  }
  return tot;
    800030e2:	0009851b          	sext.w	a0,s3
}
    800030e6:	70a6                	ld	ra,104(sp)
    800030e8:	7406                	ld	s0,96(sp)
    800030ea:	64e6                	ld	s1,88(sp)
    800030ec:	6946                	ld	s2,80(sp)
    800030ee:	69a6                	ld	s3,72(sp)
    800030f0:	6a06                	ld	s4,64(sp)
    800030f2:	7ae2                	ld	s5,56(sp)
    800030f4:	7b42                	ld	s6,48(sp)
    800030f6:	7ba2                	ld	s7,40(sp)
    800030f8:	7c02                	ld	s8,32(sp)
    800030fa:	6ce2                	ld	s9,24(sp)
    800030fc:	6d42                	ld	s10,16(sp)
    800030fe:	6da2                	ld	s11,8(sp)
    80003100:	6165                	addi	sp,sp,112
    80003102:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003104:	89da                	mv	s3,s6
    80003106:	bff1                	j	800030e2 <readi+0xce>
    return 0;
    80003108:	4501                	li	a0,0
}
    8000310a:	8082                	ret

000000008000310c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000310c:	457c                	lw	a5,76(a0)
    8000310e:	10d7e863          	bltu	a5,a3,8000321e <writei+0x112>
{
    80003112:	7159                	addi	sp,sp,-112
    80003114:	f486                	sd	ra,104(sp)
    80003116:	f0a2                	sd	s0,96(sp)
    80003118:	eca6                	sd	s1,88(sp)
    8000311a:	e8ca                	sd	s2,80(sp)
    8000311c:	e4ce                	sd	s3,72(sp)
    8000311e:	e0d2                	sd	s4,64(sp)
    80003120:	fc56                	sd	s5,56(sp)
    80003122:	f85a                	sd	s6,48(sp)
    80003124:	f45e                	sd	s7,40(sp)
    80003126:	f062                	sd	s8,32(sp)
    80003128:	ec66                	sd	s9,24(sp)
    8000312a:	e86a                	sd	s10,16(sp)
    8000312c:	e46e                	sd	s11,8(sp)
    8000312e:	1880                	addi	s0,sp,112
    80003130:	8b2a                	mv	s6,a0
    80003132:	8c2e                	mv	s8,a1
    80003134:	8ab2                	mv	s5,a2
    80003136:	8936                	mv	s2,a3
    80003138:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000313a:	00e687bb          	addw	a5,a3,a4
    8000313e:	0ed7e263          	bltu	a5,a3,80003222 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003142:	00043737          	lui	a4,0x43
    80003146:	0ef76063          	bltu	a4,a5,80003226 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000314a:	0c0b8863          	beqz	s7,8000321a <writei+0x10e>
    8000314e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003150:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003154:	5cfd                	li	s9,-1
    80003156:	a091                	j	8000319a <writei+0x8e>
    80003158:	02099d93          	slli	s11,s3,0x20
    8000315c:	020ddd93          	srli	s11,s11,0x20
    80003160:	05848513          	addi	a0,s1,88
    80003164:	86ee                	mv	a3,s11
    80003166:	8656                	mv	a2,s5
    80003168:	85e2                	mv	a1,s8
    8000316a:	953a                	add	a0,a0,a4
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	95c080e7          	jalr	-1700(ra) # 80001ac8 <either_copyin>
    80003174:	07950263          	beq	a0,s9,800031d8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003178:	8526                	mv	a0,s1
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	790080e7          	jalr	1936(ra) # 8000390a <log_write>
    brelse(bp);
    80003182:	8526                	mv	a0,s1
    80003184:	fffff097          	auipc	ra,0xfffff
    80003188:	50a080e7          	jalr	1290(ra) # 8000268e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318c:	01498a3b          	addw	s4,s3,s4
    80003190:	0129893b          	addw	s2,s3,s2
    80003194:	9aee                	add	s5,s5,s11
    80003196:	057a7663          	bgeu	s4,s7,800031e2 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000319a:	000b2483          	lw	s1,0(s6)
    8000319e:	00a9559b          	srliw	a1,s2,0xa
    800031a2:	855a                	mv	a0,s6
    800031a4:	fffff097          	auipc	ra,0xfffff
    800031a8:	7ae080e7          	jalr	1966(ra) # 80002952 <bmap>
    800031ac:	0005059b          	sext.w	a1,a0
    800031b0:	8526                	mv	a0,s1
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	3ac080e7          	jalr	940(ra) # 8000255e <bread>
    800031ba:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031bc:	3ff97713          	andi	a4,s2,1023
    800031c0:	40ed07bb          	subw	a5,s10,a4
    800031c4:	414b86bb          	subw	a3,s7,s4
    800031c8:	89be                	mv	s3,a5
    800031ca:	2781                	sext.w	a5,a5
    800031cc:	0006861b          	sext.w	a2,a3
    800031d0:	f8f674e3          	bgeu	a2,a5,80003158 <writei+0x4c>
    800031d4:	89b6                	mv	s3,a3
    800031d6:	b749                	j	80003158 <writei+0x4c>
      brelse(bp);
    800031d8:	8526                	mv	a0,s1
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	4b4080e7          	jalr	1204(ra) # 8000268e <brelse>
  }

  if(off > ip->size)
    800031e2:	04cb2783          	lw	a5,76(s6)
    800031e6:	0127f463          	bgeu	a5,s2,800031ee <writei+0xe2>
    ip->size = off;
    800031ea:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ee:	855a                	mv	a0,s6
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	aa6080e7          	jalr	-1370(ra) # 80002c96 <iupdate>

  return tot;
    800031f8:	000a051b          	sext.w	a0,s4
}
    800031fc:	70a6                	ld	ra,104(sp)
    800031fe:	7406                	ld	s0,96(sp)
    80003200:	64e6                	ld	s1,88(sp)
    80003202:	6946                	ld	s2,80(sp)
    80003204:	69a6                	ld	s3,72(sp)
    80003206:	6a06                	ld	s4,64(sp)
    80003208:	7ae2                	ld	s5,56(sp)
    8000320a:	7b42                	ld	s6,48(sp)
    8000320c:	7ba2                	ld	s7,40(sp)
    8000320e:	7c02                	ld	s8,32(sp)
    80003210:	6ce2                	ld	s9,24(sp)
    80003212:	6d42                	ld	s10,16(sp)
    80003214:	6da2                	ld	s11,8(sp)
    80003216:	6165                	addi	sp,sp,112
    80003218:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000321a:	8a5e                	mv	s4,s7
    8000321c:	bfc9                	j	800031ee <writei+0xe2>
    return -1;
    8000321e:	557d                	li	a0,-1
}
    80003220:	8082                	ret
    return -1;
    80003222:	557d                	li	a0,-1
    80003224:	bfe1                	j	800031fc <writei+0xf0>
    return -1;
    80003226:	557d                	li	a0,-1
    80003228:	bfd1                	j	800031fc <writei+0xf0>

000000008000322a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000322a:	1141                	addi	sp,sp,-16
    8000322c:	e406                	sd	ra,8(sp)
    8000322e:	e022                	sd	s0,0(sp)
    80003230:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003232:	4639                	li	a2,14
    80003234:	ffffd097          	auipc	ra,0xffffd
    80003238:	0ce080e7          	jalr	206(ra) # 80000302 <strncmp>
}
    8000323c:	60a2                	ld	ra,8(sp)
    8000323e:	6402                	ld	s0,0(sp)
    80003240:	0141                	addi	sp,sp,16
    80003242:	8082                	ret

0000000080003244 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003244:	7139                	addi	sp,sp,-64
    80003246:	fc06                	sd	ra,56(sp)
    80003248:	f822                	sd	s0,48(sp)
    8000324a:	f426                	sd	s1,40(sp)
    8000324c:	f04a                	sd	s2,32(sp)
    8000324e:	ec4e                	sd	s3,24(sp)
    80003250:	e852                	sd	s4,16(sp)
    80003252:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003254:	04451703          	lh	a4,68(a0)
    80003258:	4785                	li	a5,1
    8000325a:	00f71a63          	bne	a4,a5,8000326e <dirlookup+0x2a>
    8000325e:	892a                	mv	s2,a0
    80003260:	89ae                	mv	s3,a1
    80003262:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003264:	457c                	lw	a5,76(a0)
    80003266:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003268:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000326a:	e79d                	bnez	a5,80003298 <dirlookup+0x54>
    8000326c:	a8a5                	j	800032e4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000326e:	00005517          	auipc	a0,0x5
    80003272:	38a50513          	addi	a0,a0,906 # 800085f8 <syscalls+0x1a0>
    80003276:	00003097          	auipc	ra,0x3
    8000327a:	ba2080e7          	jalr	-1118(ra) # 80005e18 <panic>
      panic("dirlookup read");
    8000327e:	00005517          	auipc	a0,0x5
    80003282:	39250513          	addi	a0,a0,914 # 80008610 <syscalls+0x1b8>
    80003286:	00003097          	auipc	ra,0x3
    8000328a:	b92080e7          	jalr	-1134(ra) # 80005e18 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000328e:	24c1                	addiw	s1,s1,16
    80003290:	04c92783          	lw	a5,76(s2)
    80003294:	04f4f763          	bgeu	s1,a5,800032e2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003298:	4741                	li	a4,16
    8000329a:	86a6                	mv	a3,s1
    8000329c:	fc040613          	addi	a2,s0,-64
    800032a0:	4581                	li	a1,0
    800032a2:	854a                	mv	a0,s2
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	d70080e7          	jalr	-656(ra) # 80003014 <readi>
    800032ac:	47c1                	li	a5,16
    800032ae:	fcf518e3          	bne	a0,a5,8000327e <dirlookup+0x3a>
    if(de.inum == 0)
    800032b2:	fc045783          	lhu	a5,-64(s0)
    800032b6:	dfe1                	beqz	a5,8000328e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032b8:	fc240593          	addi	a1,s0,-62
    800032bc:	854e                	mv	a0,s3
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	f6c080e7          	jalr	-148(ra) # 8000322a <namecmp>
    800032c6:	f561                	bnez	a0,8000328e <dirlookup+0x4a>
      if(poff)
    800032c8:	000a0463          	beqz	s4,800032d0 <dirlookup+0x8c>
        *poff = off;
    800032cc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032d0:	fc045583          	lhu	a1,-64(s0)
    800032d4:	00092503          	lw	a0,0(s2)
    800032d8:	fffff097          	auipc	ra,0xfffff
    800032dc:	754080e7          	jalr	1876(ra) # 80002a2c <iget>
    800032e0:	a011                	j	800032e4 <dirlookup+0xa0>
  return 0;
    800032e2:	4501                	li	a0,0
}
    800032e4:	70e2                	ld	ra,56(sp)
    800032e6:	7442                	ld	s0,48(sp)
    800032e8:	74a2                	ld	s1,40(sp)
    800032ea:	7902                	ld	s2,32(sp)
    800032ec:	69e2                	ld	s3,24(sp)
    800032ee:	6a42                	ld	s4,16(sp)
    800032f0:	6121                	addi	sp,sp,64
    800032f2:	8082                	ret

00000000800032f4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032f4:	711d                	addi	sp,sp,-96
    800032f6:	ec86                	sd	ra,88(sp)
    800032f8:	e8a2                	sd	s0,80(sp)
    800032fa:	e4a6                	sd	s1,72(sp)
    800032fc:	e0ca                	sd	s2,64(sp)
    800032fe:	fc4e                	sd	s3,56(sp)
    80003300:	f852                	sd	s4,48(sp)
    80003302:	f456                	sd	s5,40(sp)
    80003304:	f05a                	sd	s6,32(sp)
    80003306:	ec5e                	sd	s7,24(sp)
    80003308:	e862                	sd	s8,16(sp)
    8000330a:	e466                	sd	s9,8(sp)
    8000330c:	1080                	addi	s0,sp,96
    8000330e:	84aa                	mv	s1,a0
    80003310:	8b2e                	mv	s6,a1
    80003312:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003314:	00054703          	lbu	a4,0(a0)
    80003318:	02f00793          	li	a5,47
    8000331c:	02f70363          	beq	a4,a5,80003342 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003320:	ffffe097          	auipc	ra,0xffffe
    80003324:	cf2080e7          	jalr	-782(ra) # 80001012 <myproc>
    80003328:	15853503          	ld	a0,344(a0)
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	9f6080e7          	jalr	-1546(ra) # 80002d22 <idup>
    80003334:	89aa                	mv	s3,a0
  while(*path == '/')
    80003336:	02f00913          	li	s2,47
  len = path - s;
    8000333a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000333c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000333e:	4c05                	li	s8,1
    80003340:	a865                	j	800033f8 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003342:	4585                	li	a1,1
    80003344:	4505                	li	a0,1
    80003346:	fffff097          	auipc	ra,0xfffff
    8000334a:	6e6080e7          	jalr	1766(ra) # 80002a2c <iget>
    8000334e:	89aa                	mv	s3,a0
    80003350:	b7dd                	j	80003336 <namex+0x42>
      iunlockput(ip);
    80003352:	854e                	mv	a0,s3
    80003354:	00000097          	auipc	ra,0x0
    80003358:	c6e080e7          	jalr	-914(ra) # 80002fc2 <iunlockput>
      return 0;
    8000335c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000335e:	854e                	mv	a0,s3
    80003360:	60e6                	ld	ra,88(sp)
    80003362:	6446                	ld	s0,80(sp)
    80003364:	64a6                	ld	s1,72(sp)
    80003366:	6906                	ld	s2,64(sp)
    80003368:	79e2                	ld	s3,56(sp)
    8000336a:	7a42                	ld	s4,48(sp)
    8000336c:	7aa2                	ld	s5,40(sp)
    8000336e:	7b02                	ld	s6,32(sp)
    80003370:	6be2                	ld	s7,24(sp)
    80003372:	6c42                	ld	s8,16(sp)
    80003374:	6ca2                	ld	s9,8(sp)
    80003376:	6125                	addi	sp,sp,96
    80003378:	8082                	ret
      iunlock(ip);
    8000337a:	854e                	mv	a0,s3
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	aa6080e7          	jalr	-1370(ra) # 80002e22 <iunlock>
      return ip;
    80003384:	bfe9                	j	8000335e <namex+0x6a>
      iunlockput(ip);
    80003386:	854e                	mv	a0,s3
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	c3a080e7          	jalr	-966(ra) # 80002fc2 <iunlockput>
      return 0;
    80003390:	89d2                	mv	s3,s4
    80003392:	b7f1                	j	8000335e <namex+0x6a>
  len = path - s;
    80003394:	40b48633          	sub	a2,s1,a1
    80003398:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000339c:	094cd463          	bge	s9,s4,80003424 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033a0:	4639                	li	a2,14
    800033a2:	8556                	mv	a0,s5
    800033a4:	ffffd097          	auipc	ra,0xffffd
    800033a8:	ee6080e7          	jalr	-282(ra) # 8000028a <memmove>
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	01279763          	bne	a5,s2,800033be <namex+0xca>
    path++;
    800033b4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	ff278de3          	beq	a5,s2,800033b4 <namex+0xc0>
    ilock(ip);
    800033be:	854e                	mv	a0,s3
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	9a0080e7          	jalr	-1632(ra) # 80002d60 <ilock>
    if(ip->type != T_DIR){
    800033c8:	04499783          	lh	a5,68(s3)
    800033cc:	f98793e3          	bne	a5,s8,80003352 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033d0:	000b0563          	beqz	s6,800033da <namex+0xe6>
    800033d4:	0004c783          	lbu	a5,0(s1)
    800033d8:	d3cd                	beqz	a5,8000337a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033da:	865e                	mv	a2,s7
    800033dc:	85d6                	mv	a1,s5
    800033de:	854e                	mv	a0,s3
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	e64080e7          	jalr	-412(ra) # 80003244 <dirlookup>
    800033e8:	8a2a                	mv	s4,a0
    800033ea:	dd51                	beqz	a0,80003386 <namex+0x92>
    iunlockput(ip);
    800033ec:	854e                	mv	a0,s3
    800033ee:	00000097          	auipc	ra,0x0
    800033f2:	bd4080e7          	jalr	-1068(ra) # 80002fc2 <iunlockput>
    ip = next;
    800033f6:	89d2                	mv	s3,s4
  while(*path == '/')
    800033f8:	0004c783          	lbu	a5,0(s1)
    800033fc:	05279763          	bne	a5,s2,8000344a <namex+0x156>
    path++;
    80003400:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003402:	0004c783          	lbu	a5,0(s1)
    80003406:	ff278de3          	beq	a5,s2,80003400 <namex+0x10c>
  if(*path == 0)
    8000340a:	c79d                	beqz	a5,80003438 <namex+0x144>
    path++;
    8000340c:	85a6                	mv	a1,s1
  len = path - s;
    8000340e:	8a5e                	mv	s4,s7
    80003410:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003412:	01278963          	beq	a5,s2,80003424 <namex+0x130>
    80003416:	dfbd                	beqz	a5,80003394 <namex+0xa0>
    path++;
    80003418:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000341a:	0004c783          	lbu	a5,0(s1)
    8000341e:	ff279ce3          	bne	a5,s2,80003416 <namex+0x122>
    80003422:	bf8d                	j	80003394 <namex+0xa0>
    memmove(name, s, len);
    80003424:	2601                	sext.w	a2,a2
    80003426:	8556                	mv	a0,s5
    80003428:	ffffd097          	auipc	ra,0xffffd
    8000342c:	e62080e7          	jalr	-414(ra) # 8000028a <memmove>
    name[len] = 0;
    80003430:	9a56                	add	s4,s4,s5
    80003432:	000a0023          	sb	zero,0(s4)
    80003436:	bf9d                	j	800033ac <namex+0xb8>
  if(nameiparent){
    80003438:	f20b03e3          	beqz	s6,8000335e <namex+0x6a>
    iput(ip);
    8000343c:	854e                	mv	a0,s3
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	adc080e7          	jalr	-1316(ra) # 80002f1a <iput>
    return 0;
    80003446:	4981                	li	s3,0
    80003448:	bf19                	j	8000335e <namex+0x6a>
  if(*path == 0)
    8000344a:	d7fd                	beqz	a5,80003438 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000344c:	0004c783          	lbu	a5,0(s1)
    80003450:	85a6                	mv	a1,s1
    80003452:	b7d1                	j	80003416 <namex+0x122>

0000000080003454 <dirlink>:
{
    80003454:	7139                	addi	sp,sp,-64
    80003456:	fc06                	sd	ra,56(sp)
    80003458:	f822                	sd	s0,48(sp)
    8000345a:	f426                	sd	s1,40(sp)
    8000345c:	f04a                	sd	s2,32(sp)
    8000345e:	ec4e                	sd	s3,24(sp)
    80003460:	e852                	sd	s4,16(sp)
    80003462:	0080                	addi	s0,sp,64
    80003464:	892a                	mv	s2,a0
    80003466:	8a2e                	mv	s4,a1
    80003468:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000346a:	4601                	li	a2,0
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	dd8080e7          	jalr	-552(ra) # 80003244 <dirlookup>
    80003474:	e93d                	bnez	a0,800034ea <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003476:	04c92483          	lw	s1,76(s2)
    8000347a:	c49d                	beqz	s1,800034a8 <dirlink+0x54>
    8000347c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000347e:	4741                	li	a4,16
    80003480:	86a6                	mv	a3,s1
    80003482:	fc040613          	addi	a2,s0,-64
    80003486:	4581                	li	a1,0
    80003488:	854a                	mv	a0,s2
    8000348a:	00000097          	auipc	ra,0x0
    8000348e:	b8a080e7          	jalr	-1142(ra) # 80003014 <readi>
    80003492:	47c1                	li	a5,16
    80003494:	06f51163          	bne	a0,a5,800034f6 <dirlink+0xa2>
    if(de.inum == 0)
    80003498:	fc045783          	lhu	a5,-64(s0)
    8000349c:	c791                	beqz	a5,800034a8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000349e:	24c1                	addiw	s1,s1,16
    800034a0:	04c92783          	lw	a5,76(s2)
    800034a4:	fcf4ede3          	bltu	s1,a5,8000347e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034a8:	4639                	li	a2,14
    800034aa:	85d2                	mv	a1,s4
    800034ac:	fc240513          	addi	a0,s0,-62
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	e8e080e7          	jalr	-370(ra) # 8000033e <strncpy>
  de.inum = inum;
    800034b8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034bc:	4741                	li	a4,16
    800034be:	86a6                	mv	a3,s1
    800034c0:	fc040613          	addi	a2,s0,-64
    800034c4:	4581                	li	a1,0
    800034c6:	854a                	mv	a0,s2
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	c44080e7          	jalr	-956(ra) # 8000310c <writei>
    800034d0:	872a                	mv	a4,a0
    800034d2:	47c1                	li	a5,16
  return 0;
    800034d4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034d6:	02f71863          	bne	a4,a5,80003506 <dirlink+0xb2>
}
    800034da:	70e2                	ld	ra,56(sp)
    800034dc:	7442                	ld	s0,48(sp)
    800034de:	74a2                	ld	s1,40(sp)
    800034e0:	7902                	ld	s2,32(sp)
    800034e2:	69e2                	ld	s3,24(sp)
    800034e4:	6a42                	ld	s4,16(sp)
    800034e6:	6121                	addi	sp,sp,64
    800034e8:	8082                	ret
    iput(ip);
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	a30080e7          	jalr	-1488(ra) # 80002f1a <iput>
    return -1;
    800034f2:	557d                	li	a0,-1
    800034f4:	b7dd                	j	800034da <dirlink+0x86>
      panic("dirlink read");
    800034f6:	00005517          	auipc	a0,0x5
    800034fa:	12a50513          	addi	a0,a0,298 # 80008620 <syscalls+0x1c8>
    800034fe:	00003097          	auipc	ra,0x3
    80003502:	91a080e7          	jalr	-1766(ra) # 80005e18 <panic>
    panic("dirlink");
    80003506:	00005517          	auipc	a0,0x5
    8000350a:	22a50513          	addi	a0,a0,554 # 80008730 <syscalls+0x2d8>
    8000350e:	00003097          	auipc	ra,0x3
    80003512:	90a080e7          	jalr	-1782(ra) # 80005e18 <panic>

0000000080003516 <namei>:

struct inode*
namei(char *path)
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000351e:	fe040613          	addi	a2,s0,-32
    80003522:	4581                	li	a1,0
    80003524:	00000097          	auipc	ra,0x0
    80003528:	dd0080e7          	jalr	-560(ra) # 800032f4 <namex>
}
    8000352c:	60e2                	ld	ra,24(sp)
    8000352e:	6442                	ld	s0,16(sp)
    80003530:	6105                	addi	sp,sp,32
    80003532:	8082                	ret

0000000080003534 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003534:	1141                	addi	sp,sp,-16
    80003536:	e406                	sd	ra,8(sp)
    80003538:	e022                	sd	s0,0(sp)
    8000353a:	0800                	addi	s0,sp,16
    8000353c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000353e:	4585                	li	a1,1
    80003540:	00000097          	auipc	ra,0x0
    80003544:	db4080e7          	jalr	-588(ra) # 800032f4 <namex>
}
    80003548:	60a2                	ld	ra,8(sp)
    8000354a:	6402                	ld	s0,0(sp)
    8000354c:	0141                	addi	sp,sp,16
    8000354e:	8082                	ret

0000000080003550 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003550:	1101                	addi	sp,sp,-32
    80003552:	ec06                	sd	ra,24(sp)
    80003554:	e822                	sd	s0,16(sp)
    80003556:	e426                	sd	s1,8(sp)
    80003558:	e04a                	sd	s2,0(sp)
    8000355a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000355c:	00036917          	auipc	s2,0x36
    80003560:	cc490913          	addi	s2,s2,-828 # 80039220 <log>
    80003564:	01892583          	lw	a1,24(s2)
    80003568:	02892503          	lw	a0,40(s2)
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	ff2080e7          	jalr	-14(ra) # 8000255e <bread>
    80003574:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003576:	02c92683          	lw	a3,44(s2)
    8000357a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000357c:	02d05763          	blez	a3,800035aa <write_head+0x5a>
    80003580:	00036797          	auipc	a5,0x36
    80003584:	cd078793          	addi	a5,a5,-816 # 80039250 <log+0x30>
    80003588:	05c50713          	addi	a4,a0,92
    8000358c:	36fd                	addiw	a3,a3,-1
    8000358e:	1682                	slli	a3,a3,0x20
    80003590:	9281                	srli	a3,a3,0x20
    80003592:	068a                	slli	a3,a3,0x2
    80003594:	00036617          	auipc	a2,0x36
    80003598:	cc060613          	addi	a2,a2,-832 # 80039254 <log+0x34>
    8000359c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000359e:	4390                	lw	a2,0(a5)
    800035a0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035a2:	0791                	addi	a5,a5,4
    800035a4:	0711                	addi	a4,a4,4
    800035a6:	fed79ce3          	bne	a5,a3,8000359e <write_head+0x4e>
  }
  bwrite(buf);
    800035aa:	8526                	mv	a0,s1
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	0a4080e7          	jalr	164(ra) # 80002650 <bwrite>
  brelse(buf);
    800035b4:	8526                	mv	a0,s1
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	0d8080e7          	jalr	216(ra) # 8000268e <brelse>
}
    800035be:	60e2                	ld	ra,24(sp)
    800035c0:	6442                	ld	s0,16(sp)
    800035c2:	64a2                	ld	s1,8(sp)
    800035c4:	6902                	ld	s2,0(sp)
    800035c6:	6105                	addi	sp,sp,32
    800035c8:	8082                	ret

00000000800035ca <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ca:	00036797          	auipc	a5,0x36
    800035ce:	c827a783          	lw	a5,-894(a5) # 8003924c <log+0x2c>
    800035d2:	0af05d63          	blez	a5,8000368c <install_trans+0xc2>
{
    800035d6:	7139                	addi	sp,sp,-64
    800035d8:	fc06                	sd	ra,56(sp)
    800035da:	f822                	sd	s0,48(sp)
    800035dc:	f426                	sd	s1,40(sp)
    800035de:	f04a                	sd	s2,32(sp)
    800035e0:	ec4e                	sd	s3,24(sp)
    800035e2:	e852                	sd	s4,16(sp)
    800035e4:	e456                	sd	s5,8(sp)
    800035e6:	e05a                	sd	s6,0(sp)
    800035e8:	0080                	addi	s0,sp,64
    800035ea:	8b2a                	mv	s6,a0
    800035ec:	00036a97          	auipc	s5,0x36
    800035f0:	c64a8a93          	addi	s5,s5,-924 # 80039250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f6:	00036997          	auipc	s3,0x36
    800035fa:	c2a98993          	addi	s3,s3,-982 # 80039220 <log>
    800035fe:	a035                	j	8000362a <install_trans+0x60>
      bunpin(dbuf);
    80003600:	8526                	mv	a0,s1
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	166080e7          	jalr	358(ra) # 80002768 <bunpin>
    brelse(lbuf);
    8000360a:	854a                	mv	a0,s2
    8000360c:	fffff097          	auipc	ra,0xfffff
    80003610:	082080e7          	jalr	130(ra) # 8000268e <brelse>
    brelse(dbuf);
    80003614:	8526                	mv	a0,s1
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	078080e7          	jalr	120(ra) # 8000268e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000361e:	2a05                	addiw	s4,s4,1
    80003620:	0a91                	addi	s5,s5,4
    80003622:	02c9a783          	lw	a5,44(s3)
    80003626:	04fa5963          	bge	s4,a5,80003678 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000362a:	0189a583          	lw	a1,24(s3)
    8000362e:	014585bb          	addw	a1,a1,s4
    80003632:	2585                	addiw	a1,a1,1
    80003634:	0289a503          	lw	a0,40(s3)
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	f26080e7          	jalr	-218(ra) # 8000255e <bread>
    80003640:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003642:	000aa583          	lw	a1,0(s5)
    80003646:	0289a503          	lw	a0,40(s3)
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	f14080e7          	jalr	-236(ra) # 8000255e <bread>
    80003652:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003654:	40000613          	li	a2,1024
    80003658:	05890593          	addi	a1,s2,88
    8000365c:	05850513          	addi	a0,a0,88
    80003660:	ffffd097          	auipc	ra,0xffffd
    80003664:	c2a080e7          	jalr	-982(ra) # 8000028a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003668:	8526                	mv	a0,s1
    8000366a:	fffff097          	auipc	ra,0xfffff
    8000366e:	fe6080e7          	jalr	-26(ra) # 80002650 <bwrite>
    if(recovering == 0)
    80003672:	f80b1ce3          	bnez	s6,8000360a <install_trans+0x40>
    80003676:	b769                	j	80003600 <install_trans+0x36>
}
    80003678:	70e2                	ld	ra,56(sp)
    8000367a:	7442                	ld	s0,48(sp)
    8000367c:	74a2                	ld	s1,40(sp)
    8000367e:	7902                	ld	s2,32(sp)
    80003680:	69e2                	ld	s3,24(sp)
    80003682:	6a42                	ld	s4,16(sp)
    80003684:	6aa2                	ld	s5,8(sp)
    80003686:	6b02                	ld	s6,0(sp)
    80003688:	6121                	addi	sp,sp,64
    8000368a:	8082                	ret
    8000368c:	8082                	ret

000000008000368e <initlog>:
{
    8000368e:	7179                	addi	sp,sp,-48
    80003690:	f406                	sd	ra,40(sp)
    80003692:	f022                	sd	s0,32(sp)
    80003694:	ec26                	sd	s1,24(sp)
    80003696:	e84a                	sd	s2,16(sp)
    80003698:	e44e                	sd	s3,8(sp)
    8000369a:	1800                	addi	s0,sp,48
    8000369c:	892a                	mv	s2,a0
    8000369e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036a0:	00036497          	auipc	s1,0x36
    800036a4:	b8048493          	addi	s1,s1,-1152 # 80039220 <log>
    800036a8:	00005597          	auipc	a1,0x5
    800036ac:	f8858593          	addi	a1,a1,-120 # 80008630 <syscalls+0x1d8>
    800036b0:	8526                	mv	a0,s1
    800036b2:	00003097          	auipc	ra,0x3
    800036b6:	c8c080e7          	jalr	-884(ra) # 8000633e <initlock>
  log.start = sb->logstart;
    800036ba:	0149a583          	lw	a1,20(s3)
    800036be:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036c0:	0109a783          	lw	a5,16(s3)
    800036c4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036c6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036ca:	854a                	mv	a0,s2
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	e92080e7          	jalr	-366(ra) # 8000255e <bread>
  log.lh.n = lh->n;
    800036d4:	4d3c                	lw	a5,88(a0)
    800036d6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036d8:	02f05563          	blez	a5,80003702 <initlog+0x74>
    800036dc:	05c50713          	addi	a4,a0,92
    800036e0:	00036697          	auipc	a3,0x36
    800036e4:	b7068693          	addi	a3,a3,-1168 # 80039250 <log+0x30>
    800036e8:	37fd                	addiw	a5,a5,-1
    800036ea:	1782                	slli	a5,a5,0x20
    800036ec:	9381                	srli	a5,a5,0x20
    800036ee:	078a                	slli	a5,a5,0x2
    800036f0:	06050613          	addi	a2,a0,96
    800036f4:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036f6:	4310                	lw	a2,0(a4)
    800036f8:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036fa:	0711                	addi	a4,a4,4
    800036fc:	0691                	addi	a3,a3,4
    800036fe:	fef71ce3          	bne	a4,a5,800036f6 <initlog+0x68>
  brelse(buf);
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	f8c080e7          	jalr	-116(ra) # 8000268e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000370a:	4505                	li	a0,1
    8000370c:	00000097          	auipc	ra,0x0
    80003710:	ebe080e7          	jalr	-322(ra) # 800035ca <install_trans>
  log.lh.n = 0;
    80003714:	00036797          	auipc	a5,0x36
    80003718:	b207ac23          	sw	zero,-1224(a5) # 8003924c <log+0x2c>
  write_head(); // clear the log
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	e34080e7          	jalr	-460(ra) # 80003550 <write_head>
}
    80003724:	70a2                	ld	ra,40(sp)
    80003726:	7402                	ld	s0,32(sp)
    80003728:	64e2                	ld	s1,24(sp)
    8000372a:	6942                	ld	s2,16(sp)
    8000372c:	69a2                	ld	s3,8(sp)
    8000372e:	6145                	addi	sp,sp,48
    80003730:	8082                	ret

0000000080003732 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003732:	1101                	addi	sp,sp,-32
    80003734:	ec06                	sd	ra,24(sp)
    80003736:	e822                	sd	s0,16(sp)
    80003738:	e426                	sd	s1,8(sp)
    8000373a:	e04a                	sd	s2,0(sp)
    8000373c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000373e:	00036517          	auipc	a0,0x36
    80003742:	ae250513          	addi	a0,a0,-1310 # 80039220 <log>
    80003746:	00003097          	auipc	ra,0x3
    8000374a:	c88080e7          	jalr	-888(ra) # 800063ce <acquire>
  while(1){
    if(log.committing){
    8000374e:	00036497          	auipc	s1,0x36
    80003752:	ad248493          	addi	s1,s1,-1326 # 80039220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003756:	4979                	li	s2,30
    80003758:	a039                	j	80003766 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000375a:	85a6                	mv	a1,s1
    8000375c:	8526                	mv	a0,s1
    8000375e:	ffffe097          	auipc	ra,0xffffe
    80003762:	f70080e7          	jalr	-144(ra) # 800016ce <sleep>
    if(log.committing){
    80003766:	50dc                	lw	a5,36(s1)
    80003768:	fbed                	bnez	a5,8000375a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000376a:	509c                	lw	a5,32(s1)
    8000376c:	0017871b          	addiw	a4,a5,1
    80003770:	0007069b          	sext.w	a3,a4
    80003774:	0027179b          	slliw	a5,a4,0x2
    80003778:	9fb9                	addw	a5,a5,a4
    8000377a:	0017979b          	slliw	a5,a5,0x1
    8000377e:	54d8                	lw	a4,44(s1)
    80003780:	9fb9                	addw	a5,a5,a4
    80003782:	00f95963          	bge	s2,a5,80003794 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003786:	85a6                	mv	a1,s1
    80003788:	8526                	mv	a0,s1
    8000378a:	ffffe097          	auipc	ra,0xffffe
    8000378e:	f44080e7          	jalr	-188(ra) # 800016ce <sleep>
    80003792:	bfd1                	j	80003766 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003794:	00036517          	auipc	a0,0x36
    80003798:	a8c50513          	addi	a0,a0,-1396 # 80039220 <log>
    8000379c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000379e:	00003097          	auipc	ra,0x3
    800037a2:	ce4080e7          	jalr	-796(ra) # 80006482 <release>
      break;
    }
  }
}
    800037a6:	60e2                	ld	ra,24(sp)
    800037a8:	6442                	ld	s0,16(sp)
    800037aa:	64a2                	ld	s1,8(sp)
    800037ac:	6902                	ld	s2,0(sp)
    800037ae:	6105                	addi	sp,sp,32
    800037b0:	8082                	ret

00000000800037b2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037b2:	7139                	addi	sp,sp,-64
    800037b4:	fc06                	sd	ra,56(sp)
    800037b6:	f822                	sd	s0,48(sp)
    800037b8:	f426                	sd	s1,40(sp)
    800037ba:	f04a                	sd	s2,32(sp)
    800037bc:	ec4e                	sd	s3,24(sp)
    800037be:	e852                	sd	s4,16(sp)
    800037c0:	e456                	sd	s5,8(sp)
    800037c2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037c4:	00036497          	auipc	s1,0x36
    800037c8:	a5c48493          	addi	s1,s1,-1444 # 80039220 <log>
    800037cc:	8526                	mv	a0,s1
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	c00080e7          	jalr	-1024(ra) # 800063ce <acquire>
  log.outstanding -= 1;
    800037d6:	509c                	lw	a5,32(s1)
    800037d8:	37fd                	addiw	a5,a5,-1
    800037da:	0007891b          	sext.w	s2,a5
    800037de:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037e0:	50dc                	lw	a5,36(s1)
    800037e2:	efb9                	bnez	a5,80003840 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037e4:	06091663          	bnez	s2,80003850 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037e8:	00036497          	auipc	s1,0x36
    800037ec:	a3848493          	addi	s1,s1,-1480 # 80039220 <log>
    800037f0:	4785                	li	a5,1
    800037f2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037f4:	8526                	mv	a0,s1
    800037f6:	00003097          	auipc	ra,0x3
    800037fa:	c8c080e7          	jalr	-884(ra) # 80006482 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037fe:	54dc                	lw	a5,44(s1)
    80003800:	06f04763          	bgtz	a5,8000386e <end_op+0xbc>
    acquire(&log.lock);
    80003804:	00036497          	auipc	s1,0x36
    80003808:	a1c48493          	addi	s1,s1,-1508 # 80039220 <log>
    8000380c:	8526                	mv	a0,s1
    8000380e:	00003097          	auipc	ra,0x3
    80003812:	bc0080e7          	jalr	-1088(ra) # 800063ce <acquire>
    log.committing = 0;
    80003816:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	03e080e7          	jalr	62(ra) # 8000185a <wakeup>
    release(&log.lock);
    80003824:	8526                	mv	a0,s1
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	c5c080e7          	jalr	-932(ra) # 80006482 <release>
}
    8000382e:	70e2                	ld	ra,56(sp)
    80003830:	7442                	ld	s0,48(sp)
    80003832:	74a2                	ld	s1,40(sp)
    80003834:	7902                	ld	s2,32(sp)
    80003836:	69e2                	ld	s3,24(sp)
    80003838:	6a42                	ld	s4,16(sp)
    8000383a:	6aa2                	ld	s5,8(sp)
    8000383c:	6121                	addi	sp,sp,64
    8000383e:	8082                	ret
    panic("log.committing");
    80003840:	00005517          	auipc	a0,0x5
    80003844:	df850513          	addi	a0,a0,-520 # 80008638 <syscalls+0x1e0>
    80003848:	00002097          	auipc	ra,0x2
    8000384c:	5d0080e7          	jalr	1488(ra) # 80005e18 <panic>
    wakeup(&log);
    80003850:	00036497          	auipc	s1,0x36
    80003854:	9d048493          	addi	s1,s1,-1584 # 80039220 <log>
    80003858:	8526                	mv	a0,s1
    8000385a:	ffffe097          	auipc	ra,0xffffe
    8000385e:	000080e7          	jalr	ra # 8000185a <wakeup>
  release(&log.lock);
    80003862:	8526                	mv	a0,s1
    80003864:	00003097          	auipc	ra,0x3
    80003868:	c1e080e7          	jalr	-994(ra) # 80006482 <release>
  if(do_commit){
    8000386c:	b7c9                	j	8000382e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000386e:	00036a97          	auipc	s5,0x36
    80003872:	9e2a8a93          	addi	s5,s5,-1566 # 80039250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003876:	00036a17          	auipc	s4,0x36
    8000387a:	9aaa0a13          	addi	s4,s4,-1622 # 80039220 <log>
    8000387e:	018a2583          	lw	a1,24(s4)
    80003882:	012585bb          	addw	a1,a1,s2
    80003886:	2585                	addiw	a1,a1,1
    80003888:	028a2503          	lw	a0,40(s4)
    8000388c:	fffff097          	auipc	ra,0xfffff
    80003890:	cd2080e7          	jalr	-814(ra) # 8000255e <bread>
    80003894:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003896:	000aa583          	lw	a1,0(s5)
    8000389a:	028a2503          	lw	a0,40(s4)
    8000389e:	fffff097          	auipc	ra,0xfffff
    800038a2:	cc0080e7          	jalr	-832(ra) # 8000255e <bread>
    800038a6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038a8:	40000613          	li	a2,1024
    800038ac:	05850593          	addi	a1,a0,88
    800038b0:	05848513          	addi	a0,s1,88
    800038b4:	ffffd097          	auipc	ra,0xffffd
    800038b8:	9d6080e7          	jalr	-1578(ra) # 8000028a <memmove>
    bwrite(to);  // write the log
    800038bc:	8526                	mv	a0,s1
    800038be:	fffff097          	auipc	ra,0xfffff
    800038c2:	d92080e7          	jalr	-622(ra) # 80002650 <bwrite>
    brelse(from);
    800038c6:	854e                	mv	a0,s3
    800038c8:	fffff097          	auipc	ra,0xfffff
    800038cc:	dc6080e7          	jalr	-570(ra) # 8000268e <brelse>
    brelse(to);
    800038d0:	8526                	mv	a0,s1
    800038d2:	fffff097          	auipc	ra,0xfffff
    800038d6:	dbc080e7          	jalr	-580(ra) # 8000268e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038da:	2905                	addiw	s2,s2,1
    800038dc:	0a91                	addi	s5,s5,4
    800038de:	02ca2783          	lw	a5,44(s4)
    800038e2:	f8f94ee3          	blt	s2,a5,8000387e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	c6a080e7          	jalr	-918(ra) # 80003550 <write_head>
    install_trans(0); // Now install writes to home locations
    800038ee:	4501                	li	a0,0
    800038f0:	00000097          	auipc	ra,0x0
    800038f4:	cda080e7          	jalr	-806(ra) # 800035ca <install_trans>
    log.lh.n = 0;
    800038f8:	00036797          	auipc	a5,0x36
    800038fc:	9407aa23          	sw	zero,-1708(a5) # 8003924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003900:	00000097          	auipc	ra,0x0
    80003904:	c50080e7          	jalr	-944(ra) # 80003550 <write_head>
    80003908:	bdf5                	j	80003804 <end_op+0x52>

000000008000390a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000390a:	1101                	addi	sp,sp,-32
    8000390c:	ec06                	sd	ra,24(sp)
    8000390e:	e822                	sd	s0,16(sp)
    80003910:	e426                	sd	s1,8(sp)
    80003912:	e04a                	sd	s2,0(sp)
    80003914:	1000                	addi	s0,sp,32
    80003916:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003918:	00036917          	auipc	s2,0x36
    8000391c:	90890913          	addi	s2,s2,-1784 # 80039220 <log>
    80003920:	854a                	mv	a0,s2
    80003922:	00003097          	auipc	ra,0x3
    80003926:	aac080e7          	jalr	-1364(ra) # 800063ce <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000392a:	02c92603          	lw	a2,44(s2)
    8000392e:	47f5                	li	a5,29
    80003930:	06c7c563          	blt	a5,a2,8000399a <log_write+0x90>
    80003934:	00036797          	auipc	a5,0x36
    80003938:	9087a783          	lw	a5,-1784(a5) # 8003923c <log+0x1c>
    8000393c:	37fd                	addiw	a5,a5,-1
    8000393e:	04f65e63          	bge	a2,a5,8000399a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003942:	00036797          	auipc	a5,0x36
    80003946:	8fe7a783          	lw	a5,-1794(a5) # 80039240 <log+0x20>
    8000394a:	06f05063          	blez	a5,800039aa <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000394e:	4781                	li	a5,0
    80003950:	06c05563          	blez	a2,800039ba <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003954:	44cc                	lw	a1,12(s1)
    80003956:	00036717          	auipc	a4,0x36
    8000395a:	8fa70713          	addi	a4,a4,-1798 # 80039250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000395e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003960:	4314                	lw	a3,0(a4)
    80003962:	04b68c63          	beq	a3,a1,800039ba <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003966:	2785                	addiw	a5,a5,1
    80003968:	0711                	addi	a4,a4,4
    8000396a:	fef61be3          	bne	a2,a5,80003960 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000396e:	0621                	addi	a2,a2,8
    80003970:	060a                	slli	a2,a2,0x2
    80003972:	00036797          	auipc	a5,0x36
    80003976:	8ae78793          	addi	a5,a5,-1874 # 80039220 <log>
    8000397a:	963e                	add	a2,a2,a5
    8000397c:	44dc                	lw	a5,12(s1)
    8000397e:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003980:	8526                	mv	a0,s1
    80003982:	fffff097          	auipc	ra,0xfffff
    80003986:	daa080e7          	jalr	-598(ra) # 8000272c <bpin>
    log.lh.n++;
    8000398a:	00036717          	auipc	a4,0x36
    8000398e:	89670713          	addi	a4,a4,-1898 # 80039220 <log>
    80003992:	575c                	lw	a5,44(a4)
    80003994:	2785                	addiw	a5,a5,1
    80003996:	d75c                	sw	a5,44(a4)
    80003998:	a835                	j	800039d4 <log_write+0xca>
    panic("too big a transaction");
    8000399a:	00005517          	auipc	a0,0x5
    8000399e:	cae50513          	addi	a0,a0,-850 # 80008648 <syscalls+0x1f0>
    800039a2:	00002097          	auipc	ra,0x2
    800039a6:	476080e7          	jalr	1142(ra) # 80005e18 <panic>
    panic("log_write outside of trans");
    800039aa:	00005517          	auipc	a0,0x5
    800039ae:	cb650513          	addi	a0,a0,-842 # 80008660 <syscalls+0x208>
    800039b2:	00002097          	auipc	ra,0x2
    800039b6:	466080e7          	jalr	1126(ra) # 80005e18 <panic>
  log.lh.block[i] = b->blockno;
    800039ba:	00878713          	addi	a4,a5,8
    800039be:	00271693          	slli	a3,a4,0x2
    800039c2:	00036717          	auipc	a4,0x36
    800039c6:	85e70713          	addi	a4,a4,-1954 # 80039220 <log>
    800039ca:	9736                	add	a4,a4,a3
    800039cc:	44d4                	lw	a3,12(s1)
    800039ce:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039d0:	faf608e3          	beq	a2,a5,80003980 <log_write+0x76>
  }
  release(&log.lock);
    800039d4:	00036517          	auipc	a0,0x36
    800039d8:	84c50513          	addi	a0,a0,-1972 # 80039220 <log>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	aa6080e7          	jalr	-1370(ra) # 80006482 <release>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	e04a                	sd	s2,0(sp)
    800039fa:	1000                	addi	s0,sp,32
    800039fc:	84aa                	mv	s1,a0
    800039fe:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a00:	00005597          	auipc	a1,0x5
    80003a04:	c8058593          	addi	a1,a1,-896 # 80008680 <syscalls+0x228>
    80003a08:	0521                	addi	a0,a0,8
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	934080e7          	jalr	-1740(ra) # 8000633e <initlock>
  lk->name = name;
    80003a12:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a16:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a1a:	0204a423          	sw	zero,40(s1)
}
    80003a1e:	60e2                	ld	ra,24(sp)
    80003a20:	6442                	ld	s0,16(sp)
    80003a22:	64a2                	ld	s1,8(sp)
    80003a24:	6902                	ld	s2,0(sp)
    80003a26:	6105                	addi	sp,sp,32
    80003a28:	8082                	ret

0000000080003a2a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a2a:	1101                	addi	sp,sp,-32
    80003a2c:	ec06                	sd	ra,24(sp)
    80003a2e:	e822                	sd	s0,16(sp)
    80003a30:	e426                	sd	s1,8(sp)
    80003a32:	e04a                	sd	s2,0(sp)
    80003a34:	1000                	addi	s0,sp,32
    80003a36:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a38:	00850913          	addi	s2,a0,8
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	990080e7          	jalr	-1648(ra) # 800063ce <acquire>
  while (lk->locked) {
    80003a46:	409c                	lw	a5,0(s1)
    80003a48:	cb89                	beqz	a5,80003a5a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a4a:	85ca                	mv	a1,s2
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	ffffe097          	auipc	ra,0xffffe
    80003a52:	c80080e7          	jalr	-896(ra) # 800016ce <sleep>
  while (lk->locked) {
    80003a56:	409c                	lw	a5,0(s1)
    80003a58:	fbed                	bnez	a5,80003a4a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a5a:	4785                	li	a5,1
    80003a5c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a5e:	ffffd097          	auipc	ra,0xffffd
    80003a62:	5b4080e7          	jalr	1460(ra) # 80001012 <myproc>
    80003a66:	591c                	lw	a5,48(a0)
    80003a68:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a6a:	854a                	mv	a0,s2
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	a16080e7          	jalr	-1514(ra) # 80006482 <release>
}
    80003a74:	60e2                	ld	ra,24(sp)
    80003a76:	6442                	ld	s0,16(sp)
    80003a78:	64a2                	ld	s1,8(sp)
    80003a7a:	6902                	ld	s2,0(sp)
    80003a7c:	6105                	addi	sp,sp,32
    80003a7e:	8082                	ret

0000000080003a80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a80:	1101                	addi	sp,sp,-32
    80003a82:	ec06                	sd	ra,24(sp)
    80003a84:	e822                	sd	s0,16(sp)
    80003a86:	e426                	sd	s1,8(sp)
    80003a88:	e04a                	sd	s2,0(sp)
    80003a8a:	1000                	addi	s0,sp,32
    80003a8c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a8e:	00850913          	addi	s2,a0,8
    80003a92:	854a                	mv	a0,s2
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	93a080e7          	jalr	-1734(ra) # 800063ce <acquire>
  lk->locked = 0;
    80003a9c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	ffffe097          	auipc	ra,0xffffe
    80003aaa:	db4080e7          	jalr	-588(ra) # 8000185a <wakeup>
  release(&lk->lk);
    80003aae:	854a                	mv	a0,s2
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	9d2080e7          	jalr	-1582(ra) # 80006482 <release>
}
    80003ab8:	60e2                	ld	ra,24(sp)
    80003aba:	6442                	ld	s0,16(sp)
    80003abc:	64a2                	ld	s1,8(sp)
    80003abe:	6902                	ld	s2,0(sp)
    80003ac0:	6105                	addi	sp,sp,32
    80003ac2:	8082                	ret

0000000080003ac4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ac4:	7179                	addi	sp,sp,-48
    80003ac6:	f406                	sd	ra,40(sp)
    80003ac8:	f022                	sd	s0,32(sp)
    80003aca:	ec26                	sd	s1,24(sp)
    80003acc:	e84a                	sd	s2,16(sp)
    80003ace:	e44e                	sd	s3,8(sp)
    80003ad0:	1800                	addi	s0,sp,48
    80003ad2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ad4:	00850913          	addi	s2,a0,8
    80003ad8:	854a                	mv	a0,s2
    80003ada:	00003097          	auipc	ra,0x3
    80003ade:	8f4080e7          	jalr	-1804(ra) # 800063ce <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae2:	409c                	lw	a5,0(s1)
    80003ae4:	ef99                	bnez	a5,80003b02 <holdingsleep+0x3e>
    80003ae6:	4481                	li	s1,0
  release(&lk->lk);
    80003ae8:	854a                	mv	a0,s2
    80003aea:	00003097          	auipc	ra,0x3
    80003aee:	998080e7          	jalr	-1640(ra) # 80006482 <release>
  return r;
}
    80003af2:	8526                	mv	a0,s1
    80003af4:	70a2                	ld	ra,40(sp)
    80003af6:	7402                	ld	s0,32(sp)
    80003af8:	64e2                	ld	s1,24(sp)
    80003afa:	6942                	ld	s2,16(sp)
    80003afc:	69a2                	ld	s3,8(sp)
    80003afe:	6145                	addi	sp,sp,48
    80003b00:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b02:	0284a983          	lw	s3,40(s1)
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	50c080e7          	jalr	1292(ra) # 80001012 <myproc>
    80003b0e:	5904                	lw	s1,48(a0)
    80003b10:	413484b3          	sub	s1,s1,s3
    80003b14:	0014b493          	seqz	s1,s1
    80003b18:	bfc1                	j	80003ae8 <holdingsleep+0x24>

0000000080003b1a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b1a:	1141                	addi	sp,sp,-16
    80003b1c:	e406                	sd	ra,8(sp)
    80003b1e:	e022                	sd	s0,0(sp)
    80003b20:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b22:	00005597          	auipc	a1,0x5
    80003b26:	b6e58593          	addi	a1,a1,-1170 # 80008690 <syscalls+0x238>
    80003b2a:	00036517          	auipc	a0,0x36
    80003b2e:	83e50513          	addi	a0,a0,-1986 # 80039368 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	80c080e7          	jalr	-2036(ra) # 8000633e <initlock>
}
    80003b3a:	60a2                	ld	ra,8(sp)
    80003b3c:	6402                	ld	s0,0(sp)
    80003b3e:	0141                	addi	sp,sp,16
    80003b40:	8082                	ret

0000000080003b42 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b42:	1101                	addi	sp,sp,-32
    80003b44:	ec06                	sd	ra,24(sp)
    80003b46:	e822                	sd	s0,16(sp)
    80003b48:	e426                	sd	s1,8(sp)
    80003b4a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b4c:	00036517          	auipc	a0,0x36
    80003b50:	81c50513          	addi	a0,a0,-2020 # 80039368 <ftable>
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	87a080e7          	jalr	-1926(ra) # 800063ce <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b5c:	00036497          	auipc	s1,0x36
    80003b60:	82448493          	addi	s1,s1,-2012 # 80039380 <ftable+0x18>
    80003b64:	00036717          	auipc	a4,0x36
    80003b68:	7bc70713          	addi	a4,a4,1980 # 8003a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b6c:	40dc                	lw	a5,4(s1)
    80003b6e:	cf99                	beqz	a5,80003b8c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b70:	02848493          	addi	s1,s1,40
    80003b74:	fee49ce3          	bne	s1,a4,80003b6c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b78:	00035517          	auipc	a0,0x35
    80003b7c:	7f050513          	addi	a0,a0,2032 # 80039368 <ftable>
    80003b80:	00003097          	auipc	ra,0x3
    80003b84:	902080e7          	jalr	-1790(ra) # 80006482 <release>
  return 0;
    80003b88:	4481                	li	s1,0
    80003b8a:	a819                	j	80003ba0 <filealloc+0x5e>
      f->ref = 1;
    80003b8c:	4785                	li	a5,1
    80003b8e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b90:	00035517          	auipc	a0,0x35
    80003b94:	7d850513          	addi	a0,a0,2008 # 80039368 <ftable>
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	8ea080e7          	jalr	-1814(ra) # 80006482 <release>
}
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	60e2                	ld	ra,24(sp)
    80003ba4:	6442                	ld	s0,16(sp)
    80003ba6:	64a2                	ld	s1,8(sp)
    80003ba8:	6105                	addi	sp,sp,32
    80003baa:	8082                	ret

0000000080003bac <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bac:	1101                	addi	sp,sp,-32
    80003bae:	ec06                	sd	ra,24(sp)
    80003bb0:	e822                	sd	s0,16(sp)
    80003bb2:	e426                	sd	s1,8(sp)
    80003bb4:	1000                	addi	s0,sp,32
    80003bb6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bb8:	00035517          	auipc	a0,0x35
    80003bbc:	7b050513          	addi	a0,a0,1968 # 80039368 <ftable>
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	80e080e7          	jalr	-2034(ra) # 800063ce <acquire>
  if(f->ref < 1)
    80003bc8:	40dc                	lw	a5,4(s1)
    80003bca:	02f05263          	blez	a5,80003bee <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bce:	2785                	addiw	a5,a5,1
    80003bd0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bd2:	00035517          	auipc	a0,0x35
    80003bd6:	79650513          	addi	a0,a0,1942 # 80039368 <ftable>
    80003bda:	00003097          	auipc	ra,0x3
    80003bde:	8a8080e7          	jalr	-1880(ra) # 80006482 <release>
  return f;
}
    80003be2:	8526                	mv	a0,s1
    80003be4:	60e2                	ld	ra,24(sp)
    80003be6:	6442                	ld	s0,16(sp)
    80003be8:	64a2                	ld	s1,8(sp)
    80003bea:	6105                	addi	sp,sp,32
    80003bec:	8082                	ret
    panic("filedup");
    80003bee:	00005517          	auipc	a0,0x5
    80003bf2:	aaa50513          	addi	a0,a0,-1366 # 80008698 <syscalls+0x240>
    80003bf6:	00002097          	auipc	ra,0x2
    80003bfa:	222080e7          	jalr	546(ra) # 80005e18 <panic>

0000000080003bfe <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bfe:	7139                	addi	sp,sp,-64
    80003c00:	fc06                	sd	ra,56(sp)
    80003c02:	f822                	sd	s0,48(sp)
    80003c04:	f426                	sd	s1,40(sp)
    80003c06:	f04a                	sd	s2,32(sp)
    80003c08:	ec4e                	sd	s3,24(sp)
    80003c0a:	e852                	sd	s4,16(sp)
    80003c0c:	e456                	sd	s5,8(sp)
    80003c0e:	0080                	addi	s0,sp,64
    80003c10:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c12:	00035517          	auipc	a0,0x35
    80003c16:	75650513          	addi	a0,a0,1878 # 80039368 <ftable>
    80003c1a:	00002097          	auipc	ra,0x2
    80003c1e:	7b4080e7          	jalr	1972(ra) # 800063ce <acquire>
  if(f->ref < 1)
    80003c22:	40dc                	lw	a5,4(s1)
    80003c24:	06f05163          	blez	a5,80003c86 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c28:	37fd                	addiw	a5,a5,-1
    80003c2a:	0007871b          	sext.w	a4,a5
    80003c2e:	c0dc                	sw	a5,4(s1)
    80003c30:	06e04363          	bgtz	a4,80003c96 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c34:	0004a903          	lw	s2,0(s1)
    80003c38:	0094ca83          	lbu	s5,9(s1)
    80003c3c:	0104ba03          	ld	s4,16(s1)
    80003c40:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c44:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c48:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c4c:	00035517          	auipc	a0,0x35
    80003c50:	71c50513          	addi	a0,a0,1820 # 80039368 <ftable>
    80003c54:	00003097          	auipc	ra,0x3
    80003c58:	82e080e7          	jalr	-2002(ra) # 80006482 <release>

  if(ff.type == FD_PIPE){
    80003c5c:	4785                	li	a5,1
    80003c5e:	04f90d63          	beq	s2,a5,80003cb8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c62:	3979                	addiw	s2,s2,-2
    80003c64:	4785                	li	a5,1
    80003c66:	0527e063          	bltu	a5,s2,80003ca6 <fileclose+0xa8>
    begin_op();
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	ac8080e7          	jalr	-1336(ra) # 80003732 <begin_op>
    iput(ff.ip);
    80003c72:	854e                	mv	a0,s3
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	2a6080e7          	jalr	678(ra) # 80002f1a <iput>
    end_op();
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	b36080e7          	jalr	-1226(ra) # 800037b2 <end_op>
    80003c84:	a00d                	j	80003ca6 <fileclose+0xa8>
    panic("fileclose");
    80003c86:	00005517          	auipc	a0,0x5
    80003c8a:	a1a50513          	addi	a0,a0,-1510 # 800086a0 <syscalls+0x248>
    80003c8e:	00002097          	auipc	ra,0x2
    80003c92:	18a080e7          	jalr	394(ra) # 80005e18 <panic>
    release(&ftable.lock);
    80003c96:	00035517          	auipc	a0,0x35
    80003c9a:	6d250513          	addi	a0,a0,1746 # 80039368 <ftable>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	7e4080e7          	jalr	2020(ra) # 80006482 <release>
  }
}
    80003ca6:	70e2                	ld	ra,56(sp)
    80003ca8:	7442                	ld	s0,48(sp)
    80003caa:	74a2                	ld	s1,40(sp)
    80003cac:	7902                	ld	s2,32(sp)
    80003cae:	69e2                	ld	s3,24(sp)
    80003cb0:	6a42                	ld	s4,16(sp)
    80003cb2:	6aa2                	ld	s5,8(sp)
    80003cb4:	6121                	addi	sp,sp,64
    80003cb6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cb8:	85d6                	mv	a1,s5
    80003cba:	8552                	mv	a0,s4
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	34c080e7          	jalr	844(ra) # 80004008 <pipeclose>
    80003cc4:	b7cd                	j	80003ca6 <fileclose+0xa8>

0000000080003cc6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cc6:	715d                	addi	sp,sp,-80
    80003cc8:	e486                	sd	ra,72(sp)
    80003cca:	e0a2                	sd	s0,64(sp)
    80003ccc:	fc26                	sd	s1,56(sp)
    80003cce:	f84a                	sd	s2,48(sp)
    80003cd0:	f44e                	sd	s3,40(sp)
    80003cd2:	0880                	addi	s0,sp,80
    80003cd4:	84aa                	mv	s1,a0
    80003cd6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cd8:	ffffd097          	auipc	ra,0xffffd
    80003cdc:	33a080e7          	jalr	826(ra) # 80001012 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ce0:	409c                	lw	a5,0(s1)
    80003ce2:	37f9                	addiw	a5,a5,-2
    80003ce4:	4705                	li	a4,1
    80003ce6:	04f76763          	bltu	a4,a5,80003d34 <filestat+0x6e>
    80003cea:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cec:	6c88                	ld	a0,24(s1)
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	072080e7          	jalr	114(ra) # 80002d60 <ilock>
    stati(f->ip, &st);
    80003cf6:	fb840593          	addi	a1,s0,-72
    80003cfa:	6c88                	ld	a0,24(s1)
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	2ee080e7          	jalr	750(ra) # 80002fea <stati>
    iunlock(f->ip);
    80003d04:	6c88                	ld	a0,24(s1)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	11c080e7          	jalr	284(ra) # 80002e22 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d0e:	46e1                	li	a3,24
    80003d10:	fb840613          	addi	a2,s0,-72
    80003d14:	85ce                	mv	a1,s3
    80003d16:	05093503          	ld	a0,80(s2)
    80003d1a:	ffffd097          	auipc	ra,0xffffd
    80003d1e:	e8a080e7          	jalr	-374(ra) # 80000ba4 <copyout>
    80003d22:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d26:	60a6                	ld	ra,72(sp)
    80003d28:	6406                	ld	s0,64(sp)
    80003d2a:	74e2                	ld	s1,56(sp)
    80003d2c:	7942                	ld	s2,48(sp)
    80003d2e:	79a2                	ld	s3,40(sp)
    80003d30:	6161                	addi	sp,sp,80
    80003d32:	8082                	ret
  return -1;
    80003d34:	557d                	li	a0,-1
    80003d36:	bfc5                	j	80003d26 <filestat+0x60>

0000000080003d38 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d38:	7179                	addi	sp,sp,-48
    80003d3a:	f406                	sd	ra,40(sp)
    80003d3c:	f022                	sd	s0,32(sp)
    80003d3e:	ec26                	sd	s1,24(sp)
    80003d40:	e84a                	sd	s2,16(sp)
    80003d42:	e44e                	sd	s3,8(sp)
    80003d44:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d46:	00854783          	lbu	a5,8(a0)
    80003d4a:	c3d5                	beqz	a5,80003dee <fileread+0xb6>
    80003d4c:	84aa                	mv	s1,a0
    80003d4e:	89ae                	mv	s3,a1
    80003d50:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d52:	411c                	lw	a5,0(a0)
    80003d54:	4705                	li	a4,1
    80003d56:	04e78963          	beq	a5,a4,80003da8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d5a:	470d                	li	a4,3
    80003d5c:	04e78d63          	beq	a5,a4,80003db6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d60:	4709                	li	a4,2
    80003d62:	06e79e63          	bne	a5,a4,80003dde <fileread+0xa6>
    ilock(f->ip);
    80003d66:	6d08                	ld	a0,24(a0)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	ff8080e7          	jalr	-8(ra) # 80002d60 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d70:	874a                	mv	a4,s2
    80003d72:	5094                	lw	a3,32(s1)
    80003d74:	864e                	mv	a2,s3
    80003d76:	4585                	li	a1,1
    80003d78:	6c88                	ld	a0,24(s1)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	29a080e7          	jalr	666(ra) # 80003014 <readi>
    80003d82:	892a                	mv	s2,a0
    80003d84:	00a05563          	blez	a0,80003d8e <fileread+0x56>
      f->off += r;
    80003d88:	509c                	lw	a5,32(s1)
    80003d8a:	9fa9                	addw	a5,a5,a0
    80003d8c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d8e:	6c88                	ld	a0,24(s1)
    80003d90:	fffff097          	auipc	ra,0xfffff
    80003d94:	092080e7          	jalr	146(ra) # 80002e22 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d98:	854a                	mv	a0,s2
    80003d9a:	70a2                	ld	ra,40(sp)
    80003d9c:	7402                	ld	s0,32(sp)
    80003d9e:	64e2                	ld	s1,24(sp)
    80003da0:	6942                	ld	s2,16(sp)
    80003da2:	69a2                	ld	s3,8(sp)
    80003da4:	6145                	addi	sp,sp,48
    80003da6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003da8:	6908                	ld	a0,16(a0)
    80003daa:	00000097          	auipc	ra,0x0
    80003dae:	3c8080e7          	jalr	968(ra) # 80004172 <piperead>
    80003db2:	892a                	mv	s2,a0
    80003db4:	b7d5                	j	80003d98 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003db6:	02451783          	lh	a5,36(a0)
    80003dba:	03079693          	slli	a3,a5,0x30
    80003dbe:	92c1                	srli	a3,a3,0x30
    80003dc0:	4725                	li	a4,9
    80003dc2:	02d76863          	bltu	a4,a3,80003df2 <fileread+0xba>
    80003dc6:	0792                	slli	a5,a5,0x4
    80003dc8:	00035717          	auipc	a4,0x35
    80003dcc:	50070713          	addi	a4,a4,1280 # 800392c8 <devsw>
    80003dd0:	97ba                	add	a5,a5,a4
    80003dd2:	639c                	ld	a5,0(a5)
    80003dd4:	c38d                	beqz	a5,80003df6 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dd6:	4505                	li	a0,1
    80003dd8:	9782                	jalr	a5
    80003dda:	892a                	mv	s2,a0
    80003ddc:	bf75                	j	80003d98 <fileread+0x60>
    panic("fileread");
    80003dde:	00005517          	auipc	a0,0x5
    80003de2:	8d250513          	addi	a0,a0,-1838 # 800086b0 <syscalls+0x258>
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	032080e7          	jalr	50(ra) # 80005e18 <panic>
    return -1;
    80003dee:	597d                	li	s2,-1
    80003df0:	b765                	j	80003d98 <fileread+0x60>
      return -1;
    80003df2:	597d                	li	s2,-1
    80003df4:	b755                	j	80003d98 <fileread+0x60>
    80003df6:	597d                	li	s2,-1
    80003df8:	b745                	j	80003d98 <fileread+0x60>

0000000080003dfa <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dfa:	715d                	addi	sp,sp,-80
    80003dfc:	e486                	sd	ra,72(sp)
    80003dfe:	e0a2                	sd	s0,64(sp)
    80003e00:	fc26                	sd	s1,56(sp)
    80003e02:	f84a                	sd	s2,48(sp)
    80003e04:	f44e                	sd	s3,40(sp)
    80003e06:	f052                	sd	s4,32(sp)
    80003e08:	ec56                	sd	s5,24(sp)
    80003e0a:	e85a                	sd	s6,16(sp)
    80003e0c:	e45e                	sd	s7,8(sp)
    80003e0e:	e062                	sd	s8,0(sp)
    80003e10:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e12:	00954783          	lbu	a5,9(a0)
    80003e16:	10078663          	beqz	a5,80003f22 <filewrite+0x128>
    80003e1a:	892a                	mv	s2,a0
    80003e1c:	8aae                	mv	s5,a1
    80003e1e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e20:	411c                	lw	a5,0(a0)
    80003e22:	4705                	li	a4,1
    80003e24:	02e78263          	beq	a5,a4,80003e48 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e28:	470d                	li	a4,3
    80003e2a:	02e78663          	beq	a5,a4,80003e56 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e2e:	4709                	li	a4,2
    80003e30:	0ee79163          	bne	a5,a4,80003f12 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e34:	0ac05d63          	blez	a2,80003eee <filewrite+0xf4>
    int i = 0;
    80003e38:	4981                	li	s3,0
    80003e3a:	6b05                	lui	s6,0x1
    80003e3c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e40:	6b85                	lui	s7,0x1
    80003e42:	c00b8b9b          	addiw	s7,s7,-1024
    80003e46:	a861                	j	80003ede <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e48:	6908                	ld	a0,16(a0)
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	22e080e7          	jalr	558(ra) # 80004078 <pipewrite>
    80003e52:	8a2a                	mv	s4,a0
    80003e54:	a045                	j	80003ef4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e56:	02451783          	lh	a5,36(a0)
    80003e5a:	03079693          	slli	a3,a5,0x30
    80003e5e:	92c1                	srli	a3,a3,0x30
    80003e60:	4725                	li	a4,9
    80003e62:	0cd76263          	bltu	a4,a3,80003f26 <filewrite+0x12c>
    80003e66:	0792                	slli	a5,a5,0x4
    80003e68:	00035717          	auipc	a4,0x35
    80003e6c:	46070713          	addi	a4,a4,1120 # 800392c8 <devsw>
    80003e70:	97ba                	add	a5,a5,a4
    80003e72:	679c                	ld	a5,8(a5)
    80003e74:	cbdd                	beqz	a5,80003f2a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e76:	4505                	li	a0,1
    80003e78:	9782                	jalr	a5
    80003e7a:	8a2a                	mv	s4,a0
    80003e7c:	a8a5                	j	80003ef4 <filewrite+0xfa>
    80003e7e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	8b0080e7          	jalr	-1872(ra) # 80003732 <begin_op>
      ilock(f->ip);
    80003e8a:	01893503          	ld	a0,24(s2)
    80003e8e:	fffff097          	auipc	ra,0xfffff
    80003e92:	ed2080e7          	jalr	-302(ra) # 80002d60 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e96:	8762                	mv	a4,s8
    80003e98:	02092683          	lw	a3,32(s2)
    80003e9c:	01598633          	add	a2,s3,s5
    80003ea0:	4585                	li	a1,1
    80003ea2:	01893503          	ld	a0,24(s2)
    80003ea6:	fffff097          	auipc	ra,0xfffff
    80003eaa:	266080e7          	jalr	614(ra) # 8000310c <writei>
    80003eae:	84aa                	mv	s1,a0
    80003eb0:	00a05763          	blez	a0,80003ebe <filewrite+0xc4>
        f->off += r;
    80003eb4:	02092783          	lw	a5,32(s2)
    80003eb8:	9fa9                	addw	a5,a5,a0
    80003eba:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ebe:	01893503          	ld	a0,24(s2)
    80003ec2:	fffff097          	auipc	ra,0xfffff
    80003ec6:	f60080e7          	jalr	-160(ra) # 80002e22 <iunlock>
      end_op();
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	8e8080e7          	jalr	-1816(ra) # 800037b2 <end_op>

      if(r != n1){
    80003ed2:	009c1f63          	bne	s8,s1,80003ef0 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ed6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003eda:	0149db63          	bge	s3,s4,80003ef0 <filewrite+0xf6>
      int n1 = n - i;
    80003ede:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ee2:	84be                	mv	s1,a5
    80003ee4:	2781                	sext.w	a5,a5
    80003ee6:	f8fb5ce3          	bge	s6,a5,80003e7e <filewrite+0x84>
    80003eea:	84de                	mv	s1,s7
    80003eec:	bf49                	j	80003e7e <filewrite+0x84>
    int i = 0;
    80003eee:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ef0:	013a1f63          	bne	s4,s3,80003f0e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ef4:	8552                	mv	a0,s4
    80003ef6:	60a6                	ld	ra,72(sp)
    80003ef8:	6406                	ld	s0,64(sp)
    80003efa:	74e2                	ld	s1,56(sp)
    80003efc:	7942                	ld	s2,48(sp)
    80003efe:	79a2                	ld	s3,40(sp)
    80003f00:	7a02                	ld	s4,32(sp)
    80003f02:	6ae2                	ld	s5,24(sp)
    80003f04:	6b42                	ld	s6,16(sp)
    80003f06:	6ba2                	ld	s7,8(sp)
    80003f08:	6c02                	ld	s8,0(sp)
    80003f0a:	6161                	addi	sp,sp,80
    80003f0c:	8082                	ret
    ret = (i == n ? n : -1);
    80003f0e:	5a7d                	li	s4,-1
    80003f10:	b7d5                	j	80003ef4 <filewrite+0xfa>
    panic("filewrite");
    80003f12:	00004517          	auipc	a0,0x4
    80003f16:	7ae50513          	addi	a0,a0,1966 # 800086c0 <syscalls+0x268>
    80003f1a:	00002097          	auipc	ra,0x2
    80003f1e:	efe080e7          	jalr	-258(ra) # 80005e18 <panic>
    return -1;
    80003f22:	5a7d                	li	s4,-1
    80003f24:	bfc1                	j	80003ef4 <filewrite+0xfa>
      return -1;
    80003f26:	5a7d                	li	s4,-1
    80003f28:	b7f1                	j	80003ef4 <filewrite+0xfa>
    80003f2a:	5a7d                	li	s4,-1
    80003f2c:	b7e1                	j	80003ef4 <filewrite+0xfa>

0000000080003f2e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f2e:	7179                	addi	sp,sp,-48
    80003f30:	f406                	sd	ra,40(sp)
    80003f32:	f022                	sd	s0,32(sp)
    80003f34:	ec26                	sd	s1,24(sp)
    80003f36:	e84a                	sd	s2,16(sp)
    80003f38:	e44e                	sd	s3,8(sp)
    80003f3a:	e052                	sd	s4,0(sp)
    80003f3c:	1800                	addi	s0,sp,48
    80003f3e:	84aa                	mv	s1,a0
    80003f40:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f42:	0005b023          	sd	zero,0(a1)
    80003f46:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f4a:	00000097          	auipc	ra,0x0
    80003f4e:	bf8080e7          	jalr	-1032(ra) # 80003b42 <filealloc>
    80003f52:	e088                	sd	a0,0(s1)
    80003f54:	c551                	beqz	a0,80003fe0 <pipealloc+0xb2>
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	bec080e7          	jalr	-1044(ra) # 80003b42 <filealloc>
    80003f5e:	00aa3023          	sd	a0,0(s4)
    80003f62:	c92d                	beqz	a0,80003fd4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f64:	ffffc097          	auipc	ra,0xffffc
    80003f68:	24e080e7          	jalr	590(ra) # 800001b2 <kalloc>
    80003f6c:	892a                	mv	s2,a0
    80003f6e:	c125                	beqz	a0,80003fce <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f70:	4985                	li	s3,1
    80003f72:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f76:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f7a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f7e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f82:	00004597          	auipc	a1,0x4
    80003f86:	74e58593          	addi	a1,a1,1870 # 800086d0 <syscalls+0x278>
    80003f8a:	00002097          	auipc	ra,0x2
    80003f8e:	3b4080e7          	jalr	948(ra) # 8000633e <initlock>
  (*f0)->type = FD_PIPE;
    80003f92:	609c                	ld	a5,0(s1)
    80003f94:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f98:	609c                	ld	a5,0(s1)
    80003f9a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f9e:	609c                	ld	a5,0(s1)
    80003fa0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fa4:	609c                	ld	a5,0(s1)
    80003fa6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003faa:	000a3783          	ld	a5,0(s4)
    80003fae:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fb2:	000a3783          	ld	a5,0(s4)
    80003fb6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fba:	000a3783          	ld	a5,0(s4)
    80003fbe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fc2:	000a3783          	ld	a5,0(s4)
    80003fc6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fca:	4501                	li	a0,0
    80003fcc:	a025                	j	80003ff4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fce:	6088                	ld	a0,0(s1)
    80003fd0:	e501                	bnez	a0,80003fd8 <pipealloc+0xaa>
    80003fd2:	a039                	j	80003fe0 <pipealloc+0xb2>
    80003fd4:	6088                	ld	a0,0(s1)
    80003fd6:	c51d                	beqz	a0,80004004 <pipealloc+0xd6>
    fileclose(*f0);
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	c26080e7          	jalr	-986(ra) # 80003bfe <fileclose>
  if(*f1)
    80003fe0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fe4:	557d                	li	a0,-1
  if(*f1)
    80003fe6:	c799                	beqz	a5,80003ff4 <pipealloc+0xc6>
    fileclose(*f1);
    80003fe8:	853e                	mv	a0,a5
    80003fea:	00000097          	auipc	ra,0x0
    80003fee:	c14080e7          	jalr	-1004(ra) # 80003bfe <fileclose>
  return -1;
    80003ff2:	557d                	li	a0,-1
}
    80003ff4:	70a2                	ld	ra,40(sp)
    80003ff6:	7402                	ld	s0,32(sp)
    80003ff8:	64e2                	ld	s1,24(sp)
    80003ffa:	6942                	ld	s2,16(sp)
    80003ffc:	69a2                	ld	s3,8(sp)
    80003ffe:	6a02                	ld	s4,0(sp)
    80004000:	6145                	addi	sp,sp,48
    80004002:	8082                	ret
  return -1;
    80004004:	557d                	li	a0,-1
    80004006:	b7fd                	j	80003ff4 <pipealloc+0xc6>

0000000080004008 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004008:	1101                	addi	sp,sp,-32
    8000400a:	ec06                	sd	ra,24(sp)
    8000400c:	e822                	sd	s0,16(sp)
    8000400e:	e426                	sd	s1,8(sp)
    80004010:	e04a                	sd	s2,0(sp)
    80004012:	1000                	addi	s0,sp,32
    80004014:	84aa                	mv	s1,a0
    80004016:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004018:	00002097          	auipc	ra,0x2
    8000401c:	3b6080e7          	jalr	950(ra) # 800063ce <acquire>
  if(writable){
    80004020:	02090d63          	beqz	s2,8000405a <pipeclose+0x52>
    pi->writeopen = 0;
    80004024:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004028:	21848513          	addi	a0,s1,536
    8000402c:	ffffe097          	auipc	ra,0xffffe
    80004030:	82e080e7          	jalr	-2002(ra) # 8000185a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004034:	2204b783          	ld	a5,544(s1)
    80004038:	eb95                	bnez	a5,8000406c <pipeclose+0x64>
    release(&pi->lock);
    8000403a:	8526                	mv	a0,s1
    8000403c:	00002097          	auipc	ra,0x2
    80004040:	446080e7          	jalr	1094(ra) # 80006482 <release>
    kfree((char*)pi);
    80004044:	8526                	mv	a0,s1
    80004046:	ffffc097          	auipc	ra,0xffffc
    8000404a:	01e080e7          	jalr	30(ra) # 80000064 <kfree>
  } else
    release(&pi->lock);
}
    8000404e:	60e2                	ld	ra,24(sp)
    80004050:	6442                	ld	s0,16(sp)
    80004052:	64a2                	ld	s1,8(sp)
    80004054:	6902                	ld	s2,0(sp)
    80004056:	6105                	addi	sp,sp,32
    80004058:	8082                	ret
    pi->readopen = 0;
    8000405a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000405e:	21c48513          	addi	a0,s1,540
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	7f8080e7          	jalr	2040(ra) # 8000185a <wakeup>
    8000406a:	b7e9                	j	80004034 <pipeclose+0x2c>
    release(&pi->lock);
    8000406c:	8526                	mv	a0,s1
    8000406e:	00002097          	auipc	ra,0x2
    80004072:	414080e7          	jalr	1044(ra) # 80006482 <release>
}
    80004076:	bfe1                	j	8000404e <pipeclose+0x46>

0000000080004078 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004078:	7159                	addi	sp,sp,-112
    8000407a:	f486                	sd	ra,104(sp)
    8000407c:	f0a2                	sd	s0,96(sp)
    8000407e:	eca6                	sd	s1,88(sp)
    80004080:	e8ca                	sd	s2,80(sp)
    80004082:	e4ce                	sd	s3,72(sp)
    80004084:	e0d2                	sd	s4,64(sp)
    80004086:	fc56                	sd	s5,56(sp)
    80004088:	f85a                	sd	s6,48(sp)
    8000408a:	f45e                	sd	s7,40(sp)
    8000408c:	f062                	sd	s8,32(sp)
    8000408e:	ec66                	sd	s9,24(sp)
    80004090:	1880                	addi	s0,sp,112
    80004092:	84aa                	mv	s1,a0
    80004094:	8aae                	mv	s5,a1
    80004096:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	f7a080e7          	jalr	-134(ra) # 80001012 <myproc>
    800040a0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	32a080e7          	jalr	810(ra) # 800063ce <acquire>
  while(i < n){
    800040ac:	0d405163          	blez	s4,8000416e <pipewrite+0xf6>
    800040b0:	8ba6                	mv	s7,s1
  int i = 0;
    800040b2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040b4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040b6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040ba:	21c48c13          	addi	s8,s1,540
    800040be:	a08d                	j	80004120 <pipewrite+0xa8>
      release(&pi->lock);
    800040c0:	8526                	mv	a0,s1
    800040c2:	00002097          	auipc	ra,0x2
    800040c6:	3c0080e7          	jalr	960(ra) # 80006482 <release>
      return -1;
    800040ca:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040cc:	854a                	mv	a0,s2
    800040ce:	70a6                	ld	ra,104(sp)
    800040d0:	7406                	ld	s0,96(sp)
    800040d2:	64e6                	ld	s1,88(sp)
    800040d4:	6946                	ld	s2,80(sp)
    800040d6:	69a6                	ld	s3,72(sp)
    800040d8:	6a06                	ld	s4,64(sp)
    800040da:	7ae2                	ld	s5,56(sp)
    800040dc:	7b42                	ld	s6,48(sp)
    800040de:	7ba2                	ld	s7,40(sp)
    800040e0:	7c02                	ld	s8,32(sp)
    800040e2:	6ce2                	ld	s9,24(sp)
    800040e4:	6165                	addi	sp,sp,112
    800040e6:	8082                	ret
      wakeup(&pi->nread);
    800040e8:	8566                	mv	a0,s9
    800040ea:	ffffd097          	auipc	ra,0xffffd
    800040ee:	770080e7          	jalr	1904(ra) # 8000185a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040f2:	85de                	mv	a1,s7
    800040f4:	8562                	mv	a0,s8
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	5d8080e7          	jalr	1496(ra) # 800016ce <sleep>
    800040fe:	a839                	j	8000411c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004100:	21c4a783          	lw	a5,540(s1)
    80004104:	0017871b          	addiw	a4,a5,1
    80004108:	20e4ae23          	sw	a4,540(s1)
    8000410c:	1ff7f793          	andi	a5,a5,511
    80004110:	97a6                	add	a5,a5,s1
    80004112:	f9f44703          	lbu	a4,-97(s0)
    80004116:	00e78c23          	sb	a4,24(a5)
      i++;
    8000411a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000411c:	03495d63          	bge	s2,s4,80004156 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004120:	2204a783          	lw	a5,544(s1)
    80004124:	dfd1                	beqz	a5,800040c0 <pipewrite+0x48>
    80004126:	0289a783          	lw	a5,40(s3)
    8000412a:	fbd9                	bnez	a5,800040c0 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000412c:	2184a783          	lw	a5,536(s1)
    80004130:	21c4a703          	lw	a4,540(s1)
    80004134:	2007879b          	addiw	a5,a5,512
    80004138:	faf708e3          	beq	a4,a5,800040e8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000413c:	4685                	li	a3,1
    8000413e:	01590633          	add	a2,s2,s5
    80004142:	f9f40593          	addi	a1,s0,-97
    80004146:	0509b503          	ld	a0,80(s3)
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	ae6080e7          	jalr	-1306(ra) # 80000c30 <copyin>
    80004152:	fb6517e3          	bne	a0,s6,80004100 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004156:	21848513          	addi	a0,s1,536
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	700080e7          	jalr	1792(ra) # 8000185a <wakeup>
  release(&pi->lock);
    80004162:	8526                	mv	a0,s1
    80004164:	00002097          	auipc	ra,0x2
    80004168:	31e080e7          	jalr	798(ra) # 80006482 <release>
  return i;
    8000416c:	b785                	j	800040cc <pipewrite+0x54>
  int i = 0;
    8000416e:	4901                	li	s2,0
    80004170:	b7dd                	j	80004156 <pipewrite+0xde>

0000000080004172 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004172:	715d                	addi	sp,sp,-80
    80004174:	e486                	sd	ra,72(sp)
    80004176:	e0a2                	sd	s0,64(sp)
    80004178:	fc26                	sd	s1,56(sp)
    8000417a:	f84a                	sd	s2,48(sp)
    8000417c:	f44e                	sd	s3,40(sp)
    8000417e:	f052                	sd	s4,32(sp)
    80004180:	ec56                	sd	s5,24(sp)
    80004182:	e85a                	sd	s6,16(sp)
    80004184:	0880                	addi	s0,sp,80
    80004186:	84aa                	mv	s1,a0
    80004188:	892e                	mv	s2,a1
    8000418a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	e86080e7          	jalr	-378(ra) # 80001012 <myproc>
    80004194:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004196:	8b26                	mv	s6,s1
    80004198:	8526                	mv	a0,s1
    8000419a:	00002097          	auipc	ra,0x2
    8000419e:	234080e7          	jalr	564(ra) # 800063ce <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a2:	2184a703          	lw	a4,536(s1)
    800041a6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041aa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ae:	02f71463          	bne	a4,a5,800041d6 <piperead+0x64>
    800041b2:	2244a783          	lw	a5,548(s1)
    800041b6:	c385                	beqz	a5,800041d6 <piperead+0x64>
    if(pr->killed){
    800041b8:	028a2783          	lw	a5,40(s4)
    800041bc:	ebc1                	bnez	a5,8000424c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041be:	85da                	mv	a1,s6
    800041c0:	854e                	mv	a0,s3
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	50c080e7          	jalr	1292(ra) # 800016ce <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ca:	2184a703          	lw	a4,536(s1)
    800041ce:	21c4a783          	lw	a5,540(s1)
    800041d2:	fef700e3          	beq	a4,a5,800041b2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041d6:	09505263          	blez	s5,8000425a <piperead+0xe8>
    800041da:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041dc:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041de:	2184a783          	lw	a5,536(s1)
    800041e2:	21c4a703          	lw	a4,540(s1)
    800041e6:	02f70d63          	beq	a4,a5,80004220 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041ea:	0017871b          	addiw	a4,a5,1
    800041ee:	20e4ac23          	sw	a4,536(s1)
    800041f2:	1ff7f793          	andi	a5,a5,511
    800041f6:	97a6                	add	a5,a5,s1
    800041f8:	0187c783          	lbu	a5,24(a5)
    800041fc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004200:	4685                	li	a3,1
    80004202:	fbf40613          	addi	a2,s0,-65
    80004206:	85ca                	mv	a1,s2
    80004208:	050a3503          	ld	a0,80(s4)
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	998080e7          	jalr	-1640(ra) # 80000ba4 <copyout>
    80004214:	01650663          	beq	a0,s6,80004220 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004218:	2985                	addiw	s3,s3,1
    8000421a:	0905                	addi	s2,s2,1
    8000421c:	fd3a91e3          	bne	s5,s3,800041de <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004220:	21c48513          	addi	a0,s1,540
    80004224:	ffffd097          	auipc	ra,0xffffd
    80004228:	636080e7          	jalr	1590(ra) # 8000185a <wakeup>
  release(&pi->lock);
    8000422c:	8526                	mv	a0,s1
    8000422e:	00002097          	auipc	ra,0x2
    80004232:	254080e7          	jalr	596(ra) # 80006482 <release>
  return i;
}
    80004236:	854e                	mv	a0,s3
    80004238:	60a6                	ld	ra,72(sp)
    8000423a:	6406                	ld	s0,64(sp)
    8000423c:	74e2                	ld	s1,56(sp)
    8000423e:	7942                	ld	s2,48(sp)
    80004240:	79a2                	ld	s3,40(sp)
    80004242:	7a02                	ld	s4,32(sp)
    80004244:	6ae2                	ld	s5,24(sp)
    80004246:	6b42                	ld	s6,16(sp)
    80004248:	6161                	addi	sp,sp,80
    8000424a:	8082                	ret
      release(&pi->lock);
    8000424c:	8526                	mv	a0,s1
    8000424e:	00002097          	auipc	ra,0x2
    80004252:	234080e7          	jalr	564(ra) # 80006482 <release>
      return -1;
    80004256:	59fd                	li	s3,-1
    80004258:	bff9                	j	80004236 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000425a:	4981                	li	s3,0
    8000425c:	b7d1                	j	80004220 <piperead+0xae>

000000008000425e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000425e:	df010113          	addi	sp,sp,-528
    80004262:	20113423          	sd	ra,520(sp)
    80004266:	20813023          	sd	s0,512(sp)
    8000426a:	ffa6                	sd	s1,504(sp)
    8000426c:	fbca                	sd	s2,496(sp)
    8000426e:	f7ce                	sd	s3,488(sp)
    80004270:	f3d2                	sd	s4,480(sp)
    80004272:	efd6                	sd	s5,472(sp)
    80004274:	ebda                	sd	s6,464(sp)
    80004276:	e7de                	sd	s7,456(sp)
    80004278:	e3e2                	sd	s8,448(sp)
    8000427a:	ff66                	sd	s9,440(sp)
    8000427c:	fb6a                	sd	s10,432(sp)
    8000427e:	f76e                	sd	s11,424(sp)
    80004280:	0c00                	addi	s0,sp,528
    80004282:	84aa                	mv	s1,a0
    80004284:	dea43c23          	sd	a0,-520(s0)
    80004288:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	d86080e7          	jalr	-634(ra) # 80001012 <myproc>
    80004294:	892a                	mv	s2,a0

  begin_op();
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	49c080e7          	jalr	1180(ra) # 80003732 <begin_op>

  if((ip = namei(path)) == 0){
    8000429e:	8526                	mv	a0,s1
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	276080e7          	jalr	630(ra) # 80003516 <namei>
    800042a8:	c92d                	beqz	a0,8000431a <exec+0xbc>
    800042aa:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	ab4080e7          	jalr	-1356(ra) # 80002d60 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042b4:	04000713          	li	a4,64
    800042b8:	4681                	li	a3,0
    800042ba:	e5040613          	addi	a2,s0,-432
    800042be:	4581                	li	a1,0
    800042c0:	8526                	mv	a0,s1
    800042c2:	fffff097          	auipc	ra,0xfffff
    800042c6:	d52080e7          	jalr	-686(ra) # 80003014 <readi>
    800042ca:	04000793          	li	a5,64
    800042ce:	00f51a63          	bne	a0,a5,800042e2 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042d2:	e5042703          	lw	a4,-432(s0)
    800042d6:	464c47b7          	lui	a5,0x464c4
    800042da:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042de:	04f70463          	beq	a4,a5,80004326 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042e2:	8526                	mv	a0,s1
    800042e4:	fffff097          	auipc	ra,0xfffff
    800042e8:	cde080e7          	jalr	-802(ra) # 80002fc2 <iunlockput>
    end_op();
    800042ec:	fffff097          	auipc	ra,0xfffff
    800042f0:	4c6080e7          	jalr	1222(ra) # 800037b2 <end_op>
  }
  return -1;
    800042f4:	557d                	li	a0,-1
}
    800042f6:	20813083          	ld	ra,520(sp)
    800042fa:	20013403          	ld	s0,512(sp)
    800042fe:	74fe                	ld	s1,504(sp)
    80004300:	795e                	ld	s2,496(sp)
    80004302:	79be                	ld	s3,488(sp)
    80004304:	7a1e                	ld	s4,480(sp)
    80004306:	6afe                	ld	s5,472(sp)
    80004308:	6b5e                	ld	s6,464(sp)
    8000430a:	6bbe                	ld	s7,456(sp)
    8000430c:	6c1e                	ld	s8,448(sp)
    8000430e:	7cfa                	ld	s9,440(sp)
    80004310:	7d5a                	ld	s10,432(sp)
    80004312:	7dba                	ld	s11,424(sp)
    80004314:	21010113          	addi	sp,sp,528
    80004318:	8082                	ret
    end_op();
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	498080e7          	jalr	1176(ra) # 800037b2 <end_op>
    return -1;
    80004322:	557d                	li	a0,-1
    80004324:	bfc9                	j	800042f6 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004326:	854a                	mv	a0,s2
    80004328:	ffffd097          	auipc	ra,0xffffd
    8000432c:	dae080e7          	jalr	-594(ra) # 800010d6 <proc_pagetable>
    80004330:	8baa                	mv	s7,a0
    80004332:	d945                	beqz	a0,800042e2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004334:	e7042983          	lw	s3,-400(s0)
    80004338:	e8845783          	lhu	a5,-376(s0)
    8000433c:	c7ad                	beqz	a5,800043a6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000433e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004340:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004342:	6c85                	lui	s9,0x1
    80004344:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004348:	def43823          	sd	a5,-528(s0)
    8000434c:	a42d                	j	80004576 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000434e:	00004517          	auipc	a0,0x4
    80004352:	38a50513          	addi	a0,a0,906 # 800086d8 <syscalls+0x280>
    80004356:	00002097          	auipc	ra,0x2
    8000435a:	ac2080e7          	jalr	-1342(ra) # 80005e18 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000435e:	8756                	mv	a4,s5
    80004360:	012d86bb          	addw	a3,s11,s2
    80004364:	4581                	li	a1,0
    80004366:	8526                	mv	a0,s1
    80004368:	fffff097          	auipc	ra,0xfffff
    8000436c:	cac080e7          	jalr	-852(ra) # 80003014 <readi>
    80004370:	2501                	sext.w	a0,a0
    80004372:	1aaa9963          	bne	s5,a0,80004524 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004376:	6785                	lui	a5,0x1
    80004378:	0127893b          	addw	s2,a5,s2
    8000437c:	77fd                	lui	a5,0xfffff
    8000437e:	01478a3b          	addw	s4,a5,s4
    80004382:	1f897163          	bgeu	s2,s8,80004564 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004386:	02091593          	slli	a1,s2,0x20
    8000438a:	9181                	srli	a1,a1,0x20
    8000438c:	95ea                	add	a1,a1,s10
    8000438e:	855e                	mv	a0,s7
    80004390:	ffffc097          	auipc	ra,0xffffc
    80004394:	228080e7          	jalr	552(ra) # 800005b8 <walkaddr>
    80004398:	862a                	mv	a2,a0
    if(pa == 0)
    8000439a:	d955                	beqz	a0,8000434e <exec+0xf0>
      n = PGSIZE;
    8000439c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000439e:	fd9a70e3          	bgeu	s4,s9,8000435e <exec+0x100>
      n = sz - i;
    800043a2:	8ad2                	mv	s5,s4
    800043a4:	bf6d                	j	8000435e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043a6:	4901                	li	s2,0
  iunlockput(ip);
    800043a8:	8526                	mv	a0,s1
    800043aa:	fffff097          	auipc	ra,0xfffff
    800043ae:	c18080e7          	jalr	-1000(ra) # 80002fc2 <iunlockput>
  end_op();
    800043b2:	fffff097          	auipc	ra,0xfffff
    800043b6:	400080e7          	jalr	1024(ra) # 800037b2 <end_op>
  p = myproc();
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	c58080e7          	jalr	-936(ra) # 80001012 <myproc>
    800043c2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043c4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043c8:	6785                	lui	a5,0x1
    800043ca:	17fd                	addi	a5,a5,-1
    800043cc:	993e                	add	s2,s2,a5
    800043ce:	757d                	lui	a0,0xfffff
    800043d0:	00a977b3          	and	a5,s2,a0
    800043d4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043d8:	6609                	lui	a2,0x2
    800043da:	963e                	add	a2,a2,a5
    800043dc:	85be                	mv	a1,a5
    800043de:	855e                	mv	a0,s7
    800043e0:	ffffc097          	auipc	ra,0xffffc
    800043e4:	58c080e7          	jalr	1420(ra) # 8000096c <uvmalloc>
    800043e8:	8b2a                	mv	s6,a0
  ip = 0;
    800043ea:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043ec:	12050c63          	beqz	a0,80004524 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043f0:	75f9                	lui	a1,0xffffe
    800043f2:	95aa                	add	a1,a1,a0
    800043f4:	855e                	mv	a0,s7
    800043f6:	ffffc097          	auipc	ra,0xffffc
    800043fa:	77c080e7          	jalr	1916(ra) # 80000b72 <uvmclear>
  stackbase = sp - PGSIZE;
    800043fe:	7c7d                	lui	s8,0xfffff
    80004400:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004402:	e0043783          	ld	a5,-512(s0)
    80004406:	6388                	ld	a0,0(a5)
    80004408:	c535                	beqz	a0,80004474 <exec+0x216>
    8000440a:	e9040993          	addi	s3,s0,-368
    8000440e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004412:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004414:	ffffc097          	auipc	ra,0xffffc
    80004418:	f9a080e7          	jalr	-102(ra) # 800003ae <strlen>
    8000441c:	2505                	addiw	a0,a0,1
    8000441e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004422:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004426:	13896363          	bltu	s2,s8,8000454c <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000442a:	e0043d83          	ld	s11,-512(s0)
    8000442e:	000dba03          	ld	s4,0(s11)
    80004432:	8552                	mv	a0,s4
    80004434:	ffffc097          	auipc	ra,0xffffc
    80004438:	f7a080e7          	jalr	-134(ra) # 800003ae <strlen>
    8000443c:	0015069b          	addiw	a3,a0,1
    80004440:	8652                	mv	a2,s4
    80004442:	85ca                	mv	a1,s2
    80004444:	855e                	mv	a0,s7
    80004446:	ffffc097          	auipc	ra,0xffffc
    8000444a:	75e080e7          	jalr	1886(ra) # 80000ba4 <copyout>
    8000444e:	10054363          	bltz	a0,80004554 <exec+0x2f6>
    ustack[argc] = sp;
    80004452:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004456:	0485                	addi	s1,s1,1
    80004458:	008d8793          	addi	a5,s11,8
    8000445c:	e0f43023          	sd	a5,-512(s0)
    80004460:	008db503          	ld	a0,8(s11)
    80004464:	c911                	beqz	a0,80004478 <exec+0x21a>
    if(argc >= MAXARG)
    80004466:	09a1                	addi	s3,s3,8
    80004468:	fb3c96e3          	bne	s9,s3,80004414 <exec+0x1b6>
  sz = sz1;
    8000446c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004470:	4481                	li	s1,0
    80004472:	a84d                	j	80004524 <exec+0x2c6>
  sp = sz;
    80004474:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004476:	4481                	li	s1,0
  ustack[argc] = 0;
    80004478:	00349793          	slli	a5,s1,0x3
    8000447c:	f9040713          	addi	a4,s0,-112
    80004480:	97ba                	add	a5,a5,a4
    80004482:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004486:	00148693          	addi	a3,s1,1
    8000448a:	068e                	slli	a3,a3,0x3
    8000448c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004490:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004494:	01897663          	bgeu	s2,s8,800044a0 <exec+0x242>
  sz = sz1;
    80004498:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000449c:	4481                	li	s1,0
    8000449e:	a059                	j	80004524 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044a0:	e9040613          	addi	a2,s0,-368
    800044a4:	85ca                	mv	a1,s2
    800044a6:	855e                	mv	a0,s7
    800044a8:	ffffc097          	auipc	ra,0xffffc
    800044ac:	6fc080e7          	jalr	1788(ra) # 80000ba4 <copyout>
    800044b0:	0a054663          	bltz	a0,8000455c <exec+0x2fe>
  p->trapframe->a1 = sp;
    800044b4:	060ab783          	ld	a5,96(s5)
    800044b8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044bc:	df843783          	ld	a5,-520(s0)
    800044c0:	0007c703          	lbu	a4,0(a5)
    800044c4:	cf11                	beqz	a4,800044e0 <exec+0x282>
    800044c6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044c8:	02f00693          	li	a3,47
    800044cc:	a039                	j	800044da <exec+0x27c>
      last = s+1;
    800044ce:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044d2:	0785                	addi	a5,a5,1
    800044d4:	fff7c703          	lbu	a4,-1(a5)
    800044d8:	c701                	beqz	a4,800044e0 <exec+0x282>
    if(*s == '/')
    800044da:	fed71ce3          	bne	a4,a3,800044d2 <exec+0x274>
    800044de:	bfc5                	j	800044ce <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800044e0:	4641                	li	a2,16
    800044e2:	df843583          	ld	a1,-520(s0)
    800044e6:	160a8513          	addi	a0,s5,352
    800044ea:	ffffc097          	auipc	ra,0xffffc
    800044ee:	e92080e7          	jalr	-366(ra) # 8000037c <safestrcpy>
  oldpagetable = p->pagetable;
    800044f2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044f6:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800044fa:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044fe:	060ab783          	ld	a5,96(s5)
    80004502:	e6843703          	ld	a4,-408(s0)
    80004506:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004508:	060ab783          	ld	a5,96(s5)
    8000450c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004510:	85ea                	mv	a1,s10
    80004512:	ffffd097          	auipc	ra,0xffffd
    80004516:	c60080e7          	jalr	-928(ra) # 80001172 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000451a:	0004851b          	sext.w	a0,s1
    8000451e:	bbe1                	j	800042f6 <exec+0x98>
    80004520:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004524:	e0843583          	ld	a1,-504(s0)
    80004528:	855e                	mv	a0,s7
    8000452a:	ffffd097          	auipc	ra,0xffffd
    8000452e:	c48080e7          	jalr	-952(ra) # 80001172 <proc_freepagetable>
  if(ip){
    80004532:	da0498e3          	bnez	s1,800042e2 <exec+0x84>
  return -1;
    80004536:	557d                	li	a0,-1
    80004538:	bb7d                	j	800042f6 <exec+0x98>
    8000453a:	e1243423          	sd	s2,-504(s0)
    8000453e:	b7dd                	j	80004524 <exec+0x2c6>
    80004540:	e1243423          	sd	s2,-504(s0)
    80004544:	b7c5                	j	80004524 <exec+0x2c6>
    80004546:	e1243423          	sd	s2,-504(s0)
    8000454a:	bfe9                	j	80004524 <exec+0x2c6>
  sz = sz1;
    8000454c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004550:	4481                	li	s1,0
    80004552:	bfc9                	j	80004524 <exec+0x2c6>
  sz = sz1;
    80004554:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004558:	4481                	li	s1,0
    8000455a:	b7e9                	j	80004524 <exec+0x2c6>
  sz = sz1;
    8000455c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004560:	4481                	li	s1,0
    80004562:	b7c9                	j	80004524 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004564:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004568:	2b05                	addiw	s6,s6,1
    8000456a:	0389899b          	addiw	s3,s3,56
    8000456e:	e8845783          	lhu	a5,-376(s0)
    80004572:	e2fb5be3          	bge	s6,a5,800043a8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004576:	2981                	sext.w	s3,s3
    80004578:	03800713          	li	a4,56
    8000457c:	86ce                	mv	a3,s3
    8000457e:	e1840613          	addi	a2,s0,-488
    80004582:	4581                	li	a1,0
    80004584:	8526                	mv	a0,s1
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	a8e080e7          	jalr	-1394(ra) # 80003014 <readi>
    8000458e:	03800793          	li	a5,56
    80004592:	f8f517e3          	bne	a0,a5,80004520 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004596:	e1842783          	lw	a5,-488(s0)
    8000459a:	4705                	li	a4,1
    8000459c:	fce796e3          	bne	a5,a4,80004568 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800045a0:	e4043603          	ld	a2,-448(s0)
    800045a4:	e3843783          	ld	a5,-456(s0)
    800045a8:	f8f669e3          	bltu	a2,a5,8000453a <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045ac:	e2843783          	ld	a5,-472(s0)
    800045b0:	963e                	add	a2,a2,a5
    800045b2:	f8f667e3          	bltu	a2,a5,80004540 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045b6:	85ca                	mv	a1,s2
    800045b8:	855e                	mv	a0,s7
    800045ba:	ffffc097          	auipc	ra,0xffffc
    800045be:	3b2080e7          	jalr	946(ra) # 8000096c <uvmalloc>
    800045c2:	e0a43423          	sd	a0,-504(s0)
    800045c6:	d141                	beqz	a0,80004546 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800045c8:	e2843d03          	ld	s10,-472(s0)
    800045cc:	df043783          	ld	a5,-528(s0)
    800045d0:	00fd77b3          	and	a5,s10,a5
    800045d4:	fba1                	bnez	a5,80004524 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045d6:	e2042d83          	lw	s11,-480(s0)
    800045da:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045de:	f80c03e3          	beqz	s8,80004564 <exec+0x306>
    800045e2:	8a62                	mv	s4,s8
    800045e4:	4901                	li	s2,0
    800045e6:	b345                	j	80004386 <exec+0x128>

00000000800045e8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045e8:	7179                	addi	sp,sp,-48
    800045ea:	f406                	sd	ra,40(sp)
    800045ec:	f022                	sd	s0,32(sp)
    800045ee:	ec26                	sd	s1,24(sp)
    800045f0:	e84a                	sd	s2,16(sp)
    800045f2:	1800                	addi	s0,sp,48
    800045f4:	892e                	mv	s2,a1
    800045f6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045f8:	fdc40593          	addi	a1,s0,-36
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	bea080e7          	jalr	-1046(ra) # 800021e6 <argint>
    80004604:	04054063          	bltz	a0,80004644 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004608:	fdc42703          	lw	a4,-36(s0)
    8000460c:	47bd                	li	a5,15
    8000460e:	02e7ed63          	bltu	a5,a4,80004648 <argfd+0x60>
    80004612:	ffffd097          	auipc	ra,0xffffd
    80004616:	a00080e7          	jalr	-1536(ra) # 80001012 <myproc>
    8000461a:	fdc42703          	lw	a4,-36(s0)
    8000461e:	01a70793          	addi	a5,a4,26
    80004622:	078e                	slli	a5,a5,0x3
    80004624:	953e                	add	a0,a0,a5
    80004626:	651c                	ld	a5,8(a0)
    80004628:	c395                	beqz	a5,8000464c <argfd+0x64>
    return -1;
  if(pfd)
    8000462a:	00090463          	beqz	s2,80004632 <argfd+0x4a>
    *pfd = fd;
    8000462e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004632:	4501                	li	a0,0
  if(pf)
    80004634:	c091                	beqz	s1,80004638 <argfd+0x50>
    *pf = f;
    80004636:	e09c                	sd	a5,0(s1)
}
    80004638:	70a2                	ld	ra,40(sp)
    8000463a:	7402                	ld	s0,32(sp)
    8000463c:	64e2                	ld	s1,24(sp)
    8000463e:	6942                	ld	s2,16(sp)
    80004640:	6145                	addi	sp,sp,48
    80004642:	8082                	ret
    return -1;
    80004644:	557d                	li	a0,-1
    80004646:	bfcd                	j	80004638 <argfd+0x50>
    return -1;
    80004648:	557d                	li	a0,-1
    8000464a:	b7fd                	j	80004638 <argfd+0x50>
    8000464c:	557d                	li	a0,-1
    8000464e:	b7ed                	j	80004638 <argfd+0x50>

0000000080004650 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004650:	1101                	addi	sp,sp,-32
    80004652:	ec06                	sd	ra,24(sp)
    80004654:	e822                	sd	s0,16(sp)
    80004656:	e426                	sd	s1,8(sp)
    80004658:	1000                	addi	s0,sp,32
    8000465a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000465c:	ffffd097          	auipc	ra,0xffffd
    80004660:	9b6080e7          	jalr	-1610(ra) # 80001012 <myproc>
    80004664:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004666:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffb8e98>
    8000466a:	4501                	li	a0,0
    8000466c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000466e:	6398                	ld	a4,0(a5)
    80004670:	cb19                	beqz	a4,80004686 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004672:	2505                	addiw	a0,a0,1
    80004674:	07a1                	addi	a5,a5,8
    80004676:	fed51ce3          	bne	a0,a3,8000466e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000467a:	557d                	li	a0,-1
}
    8000467c:	60e2                	ld	ra,24(sp)
    8000467e:	6442                	ld	s0,16(sp)
    80004680:	64a2                	ld	s1,8(sp)
    80004682:	6105                	addi	sp,sp,32
    80004684:	8082                	ret
      p->ofile[fd] = f;
    80004686:	01a50793          	addi	a5,a0,26
    8000468a:	078e                	slli	a5,a5,0x3
    8000468c:	963e                	add	a2,a2,a5
    8000468e:	e604                	sd	s1,8(a2)
      return fd;
    80004690:	b7f5                	j	8000467c <fdalloc+0x2c>

0000000080004692 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004692:	715d                	addi	sp,sp,-80
    80004694:	e486                	sd	ra,72(sp)
    80004696:	e0a2                	sd	s0,64(sp)
    80004698:	fc26                	sd	s1,56(sp)
    8000469a:	f84a                	sd	s2,48(sp)
    8000469c:	f44e                	sd	s3,40(sp)
    8000469e:	f052                	sd	s4,32(sp)
    800046a0:	ec56                	sd	s5,24(sp)
    800046a2:	0880                	addi	s0,sp,80
    800046a4:	89ae                	mv	s3,a1
    800046a6:	8ab2                	mv	s5,a2
    800046a8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046aa:	fb040593          	addi	a1,s0,-80
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	e86080e7          	jalr	-378(ra) # 80003534 <nameiparent>
    800046b6:	892a                	mv	s2,a0
    800046b8:	12050f63          	beqz	a0,800047f6 <create+0x164>
    return 0;

  ilock(dp);
    800046bc:	ffffe097          	auipc	ra,0xffffe
    800046c0:	6a4080e7          	jalr	1700(ra) # 80002d60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046c4:	4601                	li	a2,0
    800046c6:	fb040593          	addi	a1,s0,-80
    800046ca:	854a                	mv	a0,s2
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	b78080e7          	jalr	-1160(ra) # 80003244 <dirlookup>
    800046d4:	84aa                	mv	s1,a0
    800046d6:	c921                	beqz	a0,80004726 <create+0x94>
    iunlockput(dp);
    800046d8:	854a                	mv	a0,s2
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	8e8080e7          	jalr	-1816(ra) # 80002fc2 <iunlockput>
    ilock(ip);
    800046e2:	8526                	mv	a0,s1
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	67c080e7          	jalr	1660(ra) # 80002d60 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046ec:	2981                	sext.w	s3,s3
    800046ee:	4789                	li	a5,2
    800046f0:	02f99463          	bne	s3,a5,80004718 <create+0x86>
    800046f4:	0444d783          	lhu	a5,68(s1)
    800046f8:	37f9                	addiw	a5,a5,-2
    800046fa:	17c2                	slli	a5,a5,0x30
    800046fc:	93c1                	srli	a5,a5,0x30
    800046fe:	4705                	li	a4,1
    80004700:	00f76c63          	bltu	a4,a5,80004718 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004704:	8526                	mv	a0,s1
    80004706:	60a6                	ld	ra,72(sp)
    80004708:	6406                	ld	s0,64(sp)
    8000470a:	74e2                	ld	s1,56(sp)
    8000470c:	7942                	ld	s2,48(sp)
    8000470e:	79a2                	ld	s3,40(sp)
    80004710:	7a02                	ld	s4,32(sp)
    80004712:	6ae2                	ld	s5,24(sp)
    80004714:	6161                	addi	sp,sp,80
    80004716:	8082                	ret
    iunlockput(ip);
    80004718:	8526                	mv	a0,s1
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	8a8080e7          	jalr	-1880(ra) # 80002fc2 <iunlockput>
    return 0;
    80004722:	4481                	li	s1,0
    80004724:	b7c5                	j	80004704 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004726:	85ce                	mv	a1,s3
    80004728:	00092503          	lw	a0,0(s2)
    8000472c:	ffffe097          	auipc	ra,0xffffe
    80004730:	49c080e7          	jalr	1180(ra) # 80002bc8 <ialloc>
    80004734:	84aa                	mv	s1,a0
    80004736:	c529                	beqz	a0,80004780 <create+0xee>
  ilock(ip);
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	628080e7          	jalr	1576(ra) # 80002d60 <ilock>
  ip->major = major;
    80004740:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004744:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004748:	4785                	li	a5,1
    8000474a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000474e:	8526                	mv	a0,s1
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	546080e7          	jalr	1350(ra) # 80002c96 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004758:	2981                	sext.w	s3,s3
    8000475a:	4785                	li	a5,1
    8000475c:	02f98a63          	beq	s3,a5,80004790 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004760:	40d0                	lw	a2,4(s1)
    80004762:	fb040593          	addi	a1,s0,-80
    80004766:	854a                	mv	a0,s2
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	cec080e7          	jalr	-788(ra) # 80003454 <dirlink>
    80004770:	06054b63          	bltz	a0,800047e6 <create+0x154>
  iunlockput(dp);
    80004774:	854a                	mv	a0,s2
    80004776:	fffff097          	auipc	ra,0xfffff
    8000477a:	84c080e7          	jalr	-1972(ra) # 80002fc2 <iunlockput>
  return ip;
    8000477e:	b759                	j	80004704 <create+0x72>
    panic("create: ialloc");
    80004780:	00004517          	auipc	a0,0x4
    80004784:	f7850513          	addi	a0,a0,-136 # 800086f8 <syscalls+0x2a0>
    80004788:	00001097          	auipc	ra,0x1
    8000478c:	690080e7          	jalr	1680(ra) # 80005e18 <panic>
    dp->nlink++;  // for ".."
    80004790:	04a95783          	lhu	a5,74(s2)
    80004794:	2785                	addiw	a5,a5,1
    80004796:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000479a:	854a                	mv	a0,s2
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	4fa080e7          	jalr	1274(ra) # 80002c96 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047a4:	40d0                	lw	a2,4(s1)
    800047a6:	00004597          	auipc	a1,0x4
    800047aa:	f6258593          	addi	a1,a1,-158 # 80008708 <syscalls+0x2b0>
    800047ae:	8526                	mv	a0,s1
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	ca4080e7          	jalr	-860(ra) # 80003454 <dirlink>
    800047b8:	00054f63          	bltz	a0,800047d6 <create+0x144>
    800047bc:	00492603          	lw	a2,4(s2)
    800047c0:	00004597          	auipc	a1,0x4
    800047c4:	f5058593          	addi	a1,a1,-176 # 80008710 <syscalls+0x2b8>
    800047c8:	8526                	mv	a0,s1
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	c8a080e7          	jalr	-886(ra) # 80003454 <dirlink>
    800047d2:	f80557e3          	bgez	a0,80004760 <create+0xce>
      panic("create dots");
    800047d6:	00004517          	auipc	a0,0x4
    800047da:	f4250513          	addi	a0,a0,-190 # 80008718 <syscalls+0x2c0>
    800047de:	00001097          	auipc	ra,0x1
    800047e2:	63a080e7          	jalr	1594(ra) # 80005e18 <panic>
    panic("create: dirlink");
    800047e6:	00004517          	auipc	a0,0x4
    800047ea:	f4250513          	addi	a0,a0,-190 # 80008728 <syscalls+0x2d0>
    800047ee:	00001097          	auipc	ra,0x1
    800047f2:	62a080e7          	jalr	1578(ra) # 80005e18 <panic>
    return 0;
    800047f6:	84aa                	mv	s1,a0
    800047f8:	b731                	j	80004704 <create+0x72>

00000000800047fa <sys_dup>:
{
    800047fa:	7179                	addi	sp,sp,-48
    800047fc:	f406                	sd	ra,40(sp)
    800047fe:	f022                	sd	s0,32(sp)
    80004800:	ec26                	sd	s1,24(sp)
    80004802:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004804:	fd840613          	addi	a2,s0,-40
    80004808:	4581                	li	a1,0
    8000480a:	4501                	li	a0,0
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	ddc080e7          	jalr	-548(ra) # 800045e8 <argfd>
    return -1;
    80004814:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004816:	02054363          	bltz	a0,8000483c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000481a:	fd843503          	ld	a0,-40(s0)
    8000481e:	00000097          	auipc	ra,0x0
    80004822:	e32080e7          	jalr	-462(ra) # 80004650 <fdalloc>
    80004826:	84aa                	mv	s1,a0
    return -1;
    80004828:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000482a:	00054963          	bltz	a0,8000483c <sys_dup+0x42>
  filedup(f);
    8000482e:	fd843503          	ld	a0,-40(s0)
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	37a080e7          	jalr	890(ra) # 80003bac <filedup>
  return fd;
    8000483a:	87a6                	mv	a5,s1
}
    8000483c:	853e                	mv	a0,a5
    8000483e:	70a2                	ld	ra,40(sp)
    80004840:	7402                	ld	s0,32(sp)
    80004842:	64e2                	ld	s1,24(sp)
    80004844:	6145                	addi	sp,sp,48
    80004846:	8082                	ret

0000000080004848 <sys_read>:
{
    80004848:	7179                	addi	sp,sp,-48
    8000484a:	f406                	sd	ra,40(sp)
    8000484c:	f022                	sd	s0,32(sp)
    8000484e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004850:	fe840613          	addi	a2,s0,-24
    80004854:	4581                	li	a1,0
    80004856:	4501                	li	a0,0
    80004858:	00000097          	auipc	ra,0x0
    8000485c:	d90080e7          	jalr	-624(ra) # 800045e8 <argfd>
    return -1;
    80004860:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004862:	04054163          	bltz	a0,800048a4 <sys_read+0x5c>
    80004866:	fe440593          	addi	a1,s0,-28
    8000486a:	4509                	li	a0,2
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	97a080e7          	jalr	-1670(ra) # 800021e6 <argint>
    return -1;
    80004874:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004876:	02054763          	bltz	a0,800048a4 <sys_read+0x5c>
    8000487a:	fd840593          	addi	a1,s0,-40
    8000487e:	4505                	li	a0,1
    80004880:	ffffe097          	auipc	ra,0xffffe
    80004884:	988080e7          	jalr	-1656(ra) # 80002208 <argaddr>
    return -1;
    80004888:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000488a:	00054d63          	bltz	a0,800048a4 <sys_read+0x5c>
  return fileread(f, p, n);
    8000488e:	fe442603          	lw	a2,-28(s0)
    80004892:	fd843583          	ld	a1,-40(s0)
    80004896:	fe843503          	ld	a0,-24(s0)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	49e080e7          	jalr	1182(ra) # 80003d38 <fileread>
    800048a2:	87aa                	mv	a5,a0
}
    800048a4:	853e                	mv	a0,a5
    800048a6:	70a2                	ld	ra,40(sp)
    800048a8:	7402                	ld	s0,32(sp)
    800048aa:	6145                	addi	sp,sp,48
    800048ac:	8082                	ret

00000000800048ae <sys_write>:
{
    800048ae:	7179                	addi	sp,sp,-48
    800048b0:	f406                	sd	ra,40(sp)
    800048b2:	f022                	sd	s0,32(sp)
    800048b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b6:	fe840613          	addi	a2,s0,-24
    800048ba:	4581                	li	a1,0
    800048bc:	4501                	li	a0,0
    800048be:	00000097          	auipc	ra,0x0
    800048c2:	d2a080e7          	jalr	-726(ra) # 800045e8 <argfd>
    return -1;
    800048c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c8:	04054163          	bltz	a0,8000490a <sys_write+0x5c>
    800048cc:	fe440593          	addi	a1,s0,-28
    800048d0:	4509                	li	a0,2
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	914080e7          	jalr	-1772(ra) # 800021e6 <argint>
    return -1;
    800048da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048dc:	02054763          	bltz	a0,8000490a <sys_write+0x5c>
    800048e0:	fd840593          	addi	a1,s0,-40
    800048e4:	4505                	li	a0,1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	922080e7          	jalr	-1758(ra) # 80002208 <argaddr>
    return -1;
    800048ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f0:	00054d63          	bltz	a0,8000490a <sys_write+0x5c>
  return filewrite(f, p, n);
    800048f4:	fe442603          	lw	a2,-28(s0)
    800048f8:	fd843583          	ld	a1,-40(s0)
    800048fc:	fe843503          	ld	a0,-24(s0)
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	4fa080e7          	jalr	1274(ra) # 80003dfa <filewrite>
    80004908:	87aa                	mv	a5,a0
}
    8000490a:	853e                	mv	a0,a5
    8000490c:	70a2                	ld	ra,40(sp)
    8000490e:	7402                	ld	s0,32(sp)
    80004910:	6145                	addi	sp,sp,48
    80004912:	8082                	ret

0000000080004914 <sys_close>:
{
    80004914:	1101                	addi	sp,sp,-32
    80004916:	ec06                	sd	ra,24(sp)
    80004918:	e822                	sd	s0,16(sp)
    8000491a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000491c:	fe040613          	addi	a2,s0,-32
    80004920:	fec40593          	addi	a1,s0,-20
    80004924:	4501                	li	a0,0
    80004926:	00000097          	auipc	ra,0x0
    8000492a:	cc2080e7          	jalr	-830(ra) # 800045e8 <argfd>
    return -1;
    8000492e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004930:	02054463          	bltz	a0,80004958 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004934:	ffffc097          	auipc	ra,0xffffc
    80004938:	6de080e7          	jalr	1758(ra) # 80001012 <myproc>
    8000493c:	fec42783          	lw	a5,-20(s0)
    80004940:	07e9                	addi	a5,a5,26
    80004942:	078e                	slli	a5,a5,0x3
    80004944:	97aa                	add	a5,a5,a0
    80004946:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000494a:	fe043503          	ld	a0,-32(s0)
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	2b0080e7          	jalr	688(ra) # 80003bfe <fileclose>
  return 0;
    80004956:	4781                	li	a5,0
}
    80004958:	853e                	mv	a0,a5
    8000495a:	60e2                	ld	ra,24(sp)
    8000495c:	6442                	ld	s0,16(sp)
    8000495e:	6105                	addi	sp,sp,32
    80004960:	8082                	ret

0000000080004962 <sys_fstat>:
{
    80004962:	1101                	addi	sp,sp,-32
    80004964:	ec06                	sd	ra,24(sp)
    80004966:	e822                	sd	s0,16(sp)
    80004968:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000496a:	fe840613          	addi	a2,s0,-24
    8000496e:	4581                	li	a1,0
    80004970:	4501                	li	a0,0
    80004972:	00000097          	auipc	ra,0x0
    80004976:	c76080e7          	jalr	-906(ra) # 800045e8 <argfd>
    return -1;
    8000497a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000497c:	02054563          	bltz	a0,800049a6 <sys_fstat+0x44>
    80004980:	fe040593          	addi	a1,s0,-32
    80004984:	4505                	li	a0,1
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	882080e7          	jalr	-1918(ra) # 80002208 <argaddr>
    return -1;
    8000498e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004990:	00054b63          	bltz	a0,800049a6 <sys_fstat+0x44>
  return filestat(f, st);
    80004994:	fe043583          	ld	a1,-32(s0)
    80004998:	fe843503          	ld	a0,-24(s0)
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	32a080e7          	jalr	810(ra) # 80003cc6 <filestat>
    800049a4:	87aa                	mv	a5,a0
}
    800049a6:	853e                	mv	a0,a5
    800049a8:	60e2                	ld	ra,24(sp)
    800049aa:	6442                	ld	s0,16(sp)
    800049ac:	6105                	addi	sp,sp,32
    800049ae:	8082                	ret

00000000800049b0 <sys_link>:
{
    800049b0:	7169                	addi	sp,sp,-304
    800049b2:	f606                	sd	ra,296(sp)
    800049b4:	f222                	sd	s0,288(sp)
    800049b6:	ee26                	sd	s1,280(sp)
    800049b8:	ea4a                	sd	s2,272(sp)
    800049ba:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049bc:	08000613          	li	a2,128
    800049c0:	ed040593          	addi	a1,s0,-304
    800049c4:	4501                	li	a0,0
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	864080e7          	jalr	-1948(ra) # 8000222a <argstr>
    return -1;
    800049ce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d0:	10054e63          	bltz	a0,80004aec <sys_link+0x13c>
    800049d4:	08000613          	li	a2,128
    800049d8:	f5040593          	addi	a1,s0,-176
    800049dc:	4505                	li	a0,1
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	84c080e7          	jalr	-1972(ra) # 8000222a <argstr>
    return -1;
    800049e6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049e8:	10054263          	bltz	a0,80004aec <sys_link+0x13c>
  begin_op();
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	d46080e7          	jalr	-698(ra) # 80003732 <begin_op>
  if((ip = namei(old)) == 0){
    800049f4:	ed040513          	addi	a0,s0,-304
    800049f8:	fffff097          	auipc	ra,0xfffff
    800049fc:	b1e080e7          	jalr	-1250(ra) # 80003516 <namei>
    80004a00:	84aa                	mv	s1,a0
    80004a02:	c551                	beqz	a0,80004a8e <sys_link+0xde>
  ilock(ip);
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	35c080e7          	jalr	860(ra) # 80002d60 <ilock>
  if(ip->type == T_DIR){
    80004a0c:	04449703          	lh	a4,68(s1)
    80004a10:	4785                	li	a5,1
    80004a12:	08f70463          	beq	a4,a5,80004a9a <sys_link+0xea>
  ip->nlink++;
    80004a16:	04a4d783          	lhu	a5,74(s1)
    80004a1a:	2785                	addiw	a5,a5,1
    80004a1c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	274080e7          	jalr	628(ra) # 80002c96 <iupdate>
  iunlock(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	3f6080e7          	jalr	1014(ra) # 80002e22 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a34:	fd040593          	addi	a1,s0,-48
    80004a38:	f5040513          	addi	a0,s0,-176
    80004a3c:	fffff097          	auipc	ra,0xfffff
    80004a40:	af8080e7          	jalr	-1288(ra) # 80003534 <nameiparent>
    80004a44:	892a                	mv	s2,a0
    80004a46:	c935                	beqz	a0,80004aba <sys_link+0x10a>
  ilock(dp);
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	318080e7          	jalr	792(ra) # 80002d60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a50:	00092703          	lw	a4,0(s2)
    80004a54:	409c                	lw	a5,0(s1)
    80004a56:	04f71d63          	bne	a4,a5,80004ab0 <sys_link+0x100>
    80004a5a:	40d0                	lw	a2,4(s1)
    80004a5c:	fd040593          	addi	a1,s0,-48
    80004a60:	854a                	mv	a0,s2
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	9f2080e7          	jalr	-1550(ra) # 80003454 <dirlink>
    80004a6a:	04054363          	bltz	a0,80004ab0 <sys_link+0x100>
  iunlockput(dp);
    80004a6e:	854a                	mv	a0,s2
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	552080e7          	jalr	1362(ra) # 80002fc2 <iunlockput>
  iput(ip);
    80004a78:	8526                	mv	a0,s1
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	4a0080e7          	jalr	1184(ra) # 80002f1a <iput>
  end_op();
    80004a82:	fffff097          	auipc	ra,0xfffff
    80004a86:	d30080e7          	jalr	-720(ra) # 800037b2 <end_op>
  return 0;
    80004a8a:	4781                	li	a5,0
    80004a8c:	a085                	j	80004aec <sys_link+0x13c>
    end_op();
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	d24080e7          	jalr	-732(ra) # 800037b2 <end_op>
    return -1;
    80004a96:	57fd                	li	a5,-1
    80004a98:	a891                	j	80004aec <sys_link+0x13c>
    iunlockput(ip);
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	526080e7          	jalr	1318(ra) # 80002fc2 <iunlockput>
    end_op();
    80004aa4:	fffff097          	auipc	ra,0xfffff
    80004aa8:	d0e080e7          	jalr	-754(ra) # 800037b2 <end_op>
    return -1;
    80004aac:	57fd                	li	a5,-1
    80004aae:	a83d                	j	80004aec <sys_link+0x13c>
    iunlockput(dp);
    80004ab0:	854a                	mv	a0,s2
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	510080e7          	jalr	1296(ra) # 80002fc2 <iunlockput>
  ilock(ip);
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	2a4080e7          	jalr	676(ra) # 80002d60 <ilock>
  ip->nlink--;
    80004ac4:	04a4d783          	lhu	a5,74(s1)
    80004ac8:	37fd                	addiw	a5,a5,-1
    80004aca:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	1c6080e7          	jalr	454(ra) # 80002c96 <iupdate>
  iunlockput(ip);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	4e8080e7          	jalr	1256(ra) # 80002fc2 <iunlockput>
  end_op();
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	cd0080e7          	jalr	-816(ra) # 800037b2 <end_op>
  return -1;
    80004aea:	57fd                	li	a5,-1
}
    80004aec:	853e                	mv	a0,a5
    80004aee:	70b2                	ld	ra,296(sp)
    80004af0:	7412                	ld	s0,288(sp)
    80004af2:	64f2                	ld	s1,280(sp)
    80004af4:	6952                	ld	s2,272(sp)
    80004af6:	6155                	addi	sp,sp,304
    80004af8:	8082                	ret

0000000080004afa <sys_unlink>:
{
    80004afa:	7151                	addi	sp,sp,-240
    80004afc:	f586                	sd	ra,232(sp)
    80004afe:	f1a2                	sd	s0,224(sp)
    80004b00:	eda6                	sd	s1,216(sp)
    80004b02:	e9ca                	sd	s2,208(sp)
    80004b04:	e5ce                	sd	s3,200(sp)
    80004b06:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b08:	08000613          	li	a2,128
    80004b0c:	f3040593          	addi	a1,s0,-208
    80004b10:	4501                	li	a0,0
    80004b12:	ffffd097          	auipc	ra,0xffffd
    80004b16:	718080e7          	jalr	1816(ra) # 8000222a <argstr>
    80004b1a:	18054163          	bltz	a0,80004c9c <sys_unlink+0x1a2>
  begin_op();
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	c14080e7          	jalr	-1004(ra) # 80003732 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b26:	fb040593          	addi	a1,s0,-80
    80004b2a:	f3040513          	addi	a0,s0,-208
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	a06080e7          	jalr	-1530(ra) # 80003534 <nameiparent>
    80004b36:	84aa                	mv	s1,a0
    80004b38:	c979                	beqz	a0,80004c0e <sys_unlink+0x114>
  ilock(dp);
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	226080e7          	jalr	550(ra) # 80002d60 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b42:	00004597          	auipc	a1,0x4
    80004b46:	bc658593          	addi	a1,a1,-1082 # 80008708 <syscalls+0x2b0>
    80004b4a:	fb040513          	addi	a0,s0,-80
    80004b4e:	ffffe097          	auipc	ra,0xffffe
    80004b52:	6dc080e7          	jalr	1756(ra) # 8000322a <namecmp>
    80004b56:	14050a63          	beqz	a0,80004caa <sys_unlink+0x1b0>
    80004b5a:	00004597          	auipc	a1,0x4
    80004b5e:	bb658593          	addi	a1,a1,-1098 # 80008710 <syscalls+0x2b8>
    80004b62:	fb040513          	addi	a0,s0,-80
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	6c4080e7          	jalr	1732(ra) # 8000322a <namecmp>
    80004b6e:	12050e63          	beqz	a0,80004caa <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b72:	f2c40613          	addi	a2,s0,-212
    80004b76:	fb040593          	addi	a1,s0,-80
    80004b7a:	8526                	mv	a0,s1
    80004b7c:	ffffe097          	auipc	ra,0xffffe
    80004b80:	6c8080e7          	jalr	1736(ra) # 80003244 <dirlookup>
    80004b84:	892a                	mv	s2,a0
    80004b86:	12050263          	beqz	a0,80004caa <sys_unlink+0x1b0>
  ilock(ip);
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	1d6080e7          	jalr	470(ra) # 80002d60 <ilock>
  if(ip->nlink < 1)
    80004b92:	04a91783          	lh	a5,74(s2)
    80004b96:	08f05263          	blez	a5,80004c1a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b9a:	04491703          	lh	a4,68(s2)
    80004b9e:	4785                	li	a5,1
    80004ba0:	08f70563          	beq	a4,a5,80004c2a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ba4:	4641                	li	a2,16
    80004ba6:	4581                	li	a1,0
    80004ba8:	fc040513          	addi	a0,s0,-64
    80004bac:	ffffb097          	auipc	ra,0xffffb
    80004bb0:	67e080e7          	jalr	1662(ra) # 8000022a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bb4:	4741                	li	a4,16
    80004bb6:	f2c42683          	lw	a3,-212(s0)
    80004bba:	fc040613          	addi	a2,s0,-64
    80004bbe:	4581                	li	a1,0
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	54a080e7          	jalr	1354(ra) # 8000310c <writei>
    80004bca:	47c1                	li	a5,16
    80004bcc:	0af51563          	bne	a0,a5,80004c76 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bd0:	04491703          	lh	a4,68(s2)
    80004bd4:	4785                	li	a5,1
    80004bd6:	0af70863          	beq	a4,a5,80004c86 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bda:	8526                	mv	a0,s1
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	3e6080e7          	jalr	998(ra) # 80002fc2 <iunlockput>
  ip->nlink--;
    80004be4:	04a95783          	lhu	a5,74(s2)
    80004be8:	37fd                	addiw	a5,a5,-1
    80004bea:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bee:	854a                	mv	a0,s2
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	0a6080e7          	jalr	166(ra) # 80002c96 <iupdate>
  iunlockput(ip);
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	3c8080e7          	jalr	968(ra) # 80002fc2 <iunlockput>
  end_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	bb0080e7          	jalr	-1104(ra) # 800037b2 <end_op>
  return 0;
    80004c0a:	4501                	li	a0,0
    80004c0c:	a84d                	j	80004cbe <sys_unlink+0x1c4>
    end_op();
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	ba4080e7          	jalr	-1116(ra) # 800037b2 <end_op>
    return -1;
    80004c16:	557d                	li	a0,-1
    80004c18:	a05d                	j	80004cbe <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c1a:	00004517          	auipc	a0,0x4
    80004c1e:	b1e50513          	addi	a0,a0,-1250 # 80008738 <syscalls+0x2e0>
    80004c22:	00001097          	auipc	ra,0x1
    80004c26:	1f6080e7          	jalr	502(ra) # 80005e18 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c2a:	04c92703          	lw	a4,76(s2)
    80004c2e:	02000793          	li	a5,32
    80004c32:	f6e7f9e3          	bgeu	a5,a4,80004ba4 <sys_unlink+0xaa>
    80004c36:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c3a:	4741                	li	a4,16
    80004c3c:	86ce                	mv	a3,s3
    80004c3e:	f1840613          	addi	a2,s0,-232
    80004c42:	4581                	li	a1,0
    80004c44:	854a                	mv	a0,s2
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	3ce080e7          	jalr	974(ra) # 80003014 <readi>
    80004c4e:	47c1                	li	a5,16
    80004c50:	00f51b63          	bne	a0,a5,80004c66 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c54:	f1845783          	lhu	a5,-232(s0)
    80004c58:	e7a1                	bnez	a5,80004ca0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c5a:	29c1                	addiw	s3,s3,16
    80004c5c:	04c92783          	lw	a5,76(s2)
    80004c60:	fcf9ede3          	bltu	s3,a5,80004c3a <sys_unlink+0x140>
    80004c64:	b781                	j	80004ba4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c66:	00004517          	auipc	a0,0x4
    80004c6a:	aea50513          	addi	a0,a0,-1302 # 80008750 <syscalls+0x2f8>
    80004c6e:	00001097          	auipc	ra,0x1
    80004c72:	1aa080e7          	jalr	426(ra) # 80005e18 <panic>
    panic("unlink: writei");
    80004c76:	00004517          	auipc	a0,0x4
    80004c7a:	af250513          	addi	a0,a0,-1294 # 80008768 <syscalls+0x310>
    80004c7e:	00001097          	auipc	ra,0x1
    80004c82:	19a080e7          	jalr	410(ra) # 80005e18 <panic>
    dp->nlink--;
    80004c86:	04a4d783          	lhu	a5,74(s1)
    80004c8a:	37fd                	addiw	a5,a5,-1
    80004c8c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c90:	8526                	mv	a0,s1
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	004080e7          	jalr	4(ra) # 80002c96 <iupdate>
    80004c9a:	b781                	j	80004bda <sys_unlink+0xe0>
    return -1;
    80004c9c:	557d                	li	a0,-1
    80004c9e:	a005                	j	80004cbe <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ca0:	854a                	mv	a0,s2
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	320080e7          	jalr	800(ra) # 80002fc2 <iunlockput>
  iunlockput(dp);
    80004caa:	8526                	mv	a0,s1
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	316080e7          	jalr	790(ra) # 80002fc2 <iunlockput>
  end_op();
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	afe080e7          	jalr	-1282(ra) # 800037b2 <end_op>
  return -1;
    80004cbc:	557d                	li	a0,-1
}
    80004cbe:	70ae                	ld	ra,232(sp)
    80004cc0:	740e                	ld	s0,224(sp)
    80004cc2:	64ee                	ld	s1,216(sp)
    80004cc4:	694e                	ld	s2,208(sp)
    80004cc6:	69ae                	ld	s3,200(sp)
    80004cc8:	616d                	addi	sp,sp,240
    80004cca:	8082                	ret

0000000080004ccc <sys_open>:

uint64
sys_open(void)
{
    80004ccc:	7131                	addi	sp,sp,-192
    80004cce:	fd06                	sd	ra,184(sp)
    80004cd0:	f922                	sd	s0,176(sp)
    80004cd2:	f526                	sd	s1,168(sp)
    80004cd4:	f14a                	sd	s2,160(sp)
    80004cd6:	ed4e                	sd	s3,152(sp)
    80004cd8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cda:	08000613          	li	a2,128
    80004cde:	f5040593          	addi	a1,s0,-176
    80004ce2:	4501                	li	a0,0
    80004ce4:	ffffd097          	auipc	ra,0xffffd
    80004ce8:	546080e7          	jalr	1350(ra) # 8000222a <argstr>
    return -1;
    80004cec:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cee:	0c054163          	bltz	a0,80004db0 <sys_open+0xe4>
    80004cf2:	f4c40593          	addi	a1,s0,-180
    80004cf6:	4505                	li	a0,1
    80004cf8:	ffffd097          	auipc	ra,0xffffd
    80004cfc:	4ee080e7          	jalr	1262(ra) # 800021e6 <argint>
    80004d00:	0a054863          	bltz	a0,80004db0 <sys_open+0xe4>

  begin_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	a2e080e7          	jalr	-1490(ra) # 80003732 <begin_op>

  if(omode & O_CREATE){
    80004d0c:	f4c42783          	lw	a5,-180(s0)
    80004d10:	2007f793          	andi	a5,a5,512
    80004d14:	cbdd                	beqz	a5,80004dca <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d16:	4681                	li	a3,0
    80004d18:	4601                	li	a2,0
    80004d1a:	4589                	li	a1,2
    80004d1c:	f5040513          	addi	a0,s0,-176
    80004d20:	00000097          	auipc	ra,0x0
    80004d24:	972080e7          	jalr	-1678(ra) # 80004692 <create>
    80004d28:	892a                	mv	s2,a0
    if(ip == 0){
    80004d2a:	c959                	beqz	a0,80004dc0 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d2c:	04491703          	lh	a4,68(s2)
    80004d30:	478d                	li	a5,3
    80004d32:	00f71763          	bne	a4,a5,80004d40 <sys_open+0x74>
    80004d36:	04695703          	lhu	a4,70(s2)
    80004d3a:	47a5                	li	a5,9
    80004d3c:	0ce7ec63          	bltu	a5,a4,80004e14 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	e02080e7          	jalr	-510(ra) # 80003b42 <filealloc>
    80004d48:	89aa                	mv	s3,a0
    80004d4a:	10050263          	beqz	a0,80004e4e <sys_open+0x182>
    80004d4e:	00000097          	auipc	ra,0x0
    80004d52:	902080e7          	jalr	-1790(ra) # 80004650 <fdalloc>
    80004d56:	84aa                	mv	s1,a0
    80004d58:	0e054663          	bltz	a0,80004e44 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d5c:	04491703          	lh	a4,68(s2)
    80004d60:	478d                	li	a5,3
    80004d62:	0cf70463          	beq	a4,a5,80004e2a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d66:	4789                	li	a5,2
    80004d68:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d6c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d70:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d74:	f4c42783          	lw	a5,-180(s0)
    80004d78:	0017c713          	xori	a4,a5,1
    80004d7c:	8b05                	andi	a4,a4,1
    80004d7e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d82:	0037f713          	andi	a4,a5,3
    80004d86:	00e03733          	snez	a4,a4
    80004d8a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d8e:	4007f793          	andi	a5,a5,1024
    80004d92:	c791                	beqz	a5,80004d9e <sys_open+0xd2>
    80004d94:	04491703          	lh	a4,68(s2)
    80004d98:	4789                	li	a5,2
    80004d9a:	08f70f63          	beq	a4,a5,80004e38 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d9e:	854a                	mv	a0,s2
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	082080e7          	jalr	130(ra) # 80002e22 <iunlock>
  end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	a0a080e7          	jalr	-1526(ra) # 800037b2 <end_op>

  return fd;
}
    80004db0:	8526                	mv	a0,s1
    80004db2:	70ea                	ld	ra,184(sp)
    80004db4:	744a                	ld	s0,176(sp)
    80004db6:	74aa                	ld	s1,168(sp)
    80004db8:	790a                	ld	s2,160(sp)
    80004dba:	69ea                	ld	s3,152(sp)
    80004dbc:	6129                	addi	sp,sp,192
    80004dbe:	8082                	ret
      end_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	9f2080e7          	jalr	-1550(ra) # 800037b2 <end_op>
      return -1;
    80004dc8:	b7e5                	j	80004db0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dca:	f5040513          	addi	a0,s0,-176
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	748080e7          	jalr	1864(ra) # 80003516 <namei>
    80004dd6:	892a                	mv	s2,a0
    80004dd8:	c905                	beqz	a0,80004e08 <sys_open+0x13c>
    ilock(ip);
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	f86080e7          	jalr	-122(ra) # 80002d60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004de2:	04491703          	lh	a4,68(s2)
    80004de6:	4785                	li	a5,1
    80004de8:	f4f712e3          	bne	a4,a5,80004d2c <sys_open+0x60>
    80004dec:	f4c42783          	lw	a5,-180(s0)
    80004df0:	dba1                	beqz	a5,80004d40 <sys_open+0x74>
      iunlockput(ip);
    80004df2:	854a                	mv	a0,s2
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	1ce080e7          	jalr	462(ra) # 80002fc2 <iunlockput>
      end_op();
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	9b6080e7          	jalr	-1610(ra) # 800037b2 <end_op>
      return -1;
    80004e04:	54fd                	li	s1,-1
    80004e06:	b76d                	j	80004db0 <sys_open+0xe4>
      end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	9aa080e7          	jalr	-1622(ra) # 800037b2 <end_op>
      return -1;
    80004e10:	54fd                	li	s1,-1
    80004e12:	bf79                	j	80004db0 <sys_open+0xe4>
    iunlockput(ip);
    80004e14:	854a                	mv	a0,s2
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	1ac080e7          	jalr	428(ra) # 80002fc2 <iunlockput>
    end_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	994080e7          	jalr	-1644(ra) # 800037b2 <end_op>
    return -1;
    80004e26:	54fd                	li	s1,-1
    80004e28:	b761                	j	80004db0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e2a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e2e:	04691783          	lh	a5,70(s2)
    80004e32:	02f99223          	sh	a5,36(s3)
    80004e36:	bf2d                	j	80004d70 <sys_open+0xa4>
    itrunc(ip);
    80004e38:	854a                	mv	a0,s2
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	034080e7          	jalr	52(ra) # 80002e6e <itrunc>
    80004e42:	bfb1                	j	80004d9e <sys_open+0xd2>
      fileclose(f);
    80004e44:	854e                	mv	a0,s3
    80004e46:	fffff097          	auipc	ra,0xfffff
    80004e4a:	db8080e7          	jalr	-584(ra) # 80003bfe <fileclose>
    iunlockput(ip);
    80004e4e:	854a                	mv	a0,s2
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	172080e7          	jalr	370(ra) # 80002fc2 <iunlockput>
    end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	95a080e7          	jalr	-1702(ra) # 800037b2 <end_op>
    return -1;
    80004e60:	54fd                	li	s1,-1
    80004e62:	b7b9                	j	80004db0 <sys_open+0xe4>

0000000080004e64 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e64:	7175                	addi	sp,sp,-144
    80004e66:	e506                	sd	ra,136(sp)
    80004e68:	e122                	sd	s0,128(sp)
    80004e6a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	8c6080e7          	jalr	-1850(ra) # 80003732 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e74:	08000613          	li	a2,128
    80004e78:	f7040593          	addi	a1,s0,-144
    80004e7c:	4501                	li	a0,0
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	3ac080e7          	jalr	940(ra) # 8000222a <argstr>
    80004e86:	02054963          	bltz	a0,80004eb8 <sys_mkdir+0x54>
    80004e8a:	4681                	li	a3,0
    80004e8c:	4601                	li	a2,0
    80004e8e:	4585                	li	a1,1
    80004e90:	f7040513          	addi	a0,s0,-144
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	7fe080e7          	jalr	2046(ra) # 80004692 <create>
    80004e9c:	cd11                	beqz	a0,80004eb8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	124080e7          	jalr	292(ra) # 80002fc2 <iunlockput>
  end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	90c080e7          	jalr	-1780(ra) # 800037b2 <end_op>
  return 0;
    80004eae:	4501                	li	a0,0
}
    80004eb0:	60aa                	ld	ra,136(sp)
    80004eb2:	640a                	ld	s0,128(sp)
    80004eb4:	6149                	addi	sp,sp,144
    80004eb6:	8082                	ret
    end_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	8fa080e7          	jalr	-1798(ra) # 800037b2 <end_op>
    return -1;
    80004ec0:	557d                	li	a0,-1
    80004ec2:	b7fd                	j	80004eb0 <sys_mkdir+0x4c>

0000000080004ec4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ec4:	7135                	addi	sp,sp,-160
    80004ec6:	ed06                	sd	ra,152(sp)
    80004ec8:	e922                	sd	s0,144(sp)
    80004eca:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ecc:	fffff097          	auipc	ra,0xfffff
    80004ed0:	866080e7          	jalr	-1946(ra) # 80003732 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ed4:	08000613          	li	a2,128
    80004ed8:	f7040593          	addi	a1,s0,-144
    80004edc:	4501                	li	a0,0
    80004ede:	ffffd097          	auipc	ra,0xffffd
    80004ee2:	34c080e7          	jalr	844(ra) # 8000222a <argstr>
    80004ee6:	04054a63          	bltz	a0,80004f3a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004eea:	f6c40593          	addi	a1,s0,-148
    80004eee:	4505                	li	a0,1
    80004ef0:	ffffd097          	auipc	ra,0xffffd
    80004ef4:	2f6080e7          	jalr	758(ra) # 800021e6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ef8:	04054163          	bltz	a0,80004f3a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004efc:	f6840593          	addi	a1,s0,-152
    80004f00:	4509                	li	a0,2
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	2e4080e7          	jalr	740(ra) # 800021e6 <argint>
     argint(1, &major) < 0 ||
    80004f0a:	02054863          	bltz	a0,80004f3a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f0e:	f6841683          	lh	a3,-152(s0)
    80004f12:	f6c41603          	lh	a2,-148(s0)
    80004f16:	458d                	li	a1,3
    80004f18:	f7040513          	addi	a0,s0,-144
    80004f1c:	fffff097          	auipc	ra,0xfffff
    80004f20:	776080e7          	jalr	1910(ra) # 80004692 <create>
     argint(2, &minor) < 0 ||
    80004f24:	c919                	beqz	a0,80004f3a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f26:	ffffe097          	auipc	ra,0xffffe
    80004f2a:	09c080e7          	jalr	156(ra) # 80002fc2 <iunlockput>
  end_op();
    80004f2e:	fffff097          	auipc	ra,0xfffff
    80004f32:	884080e7          	jalr	-1916(ra) # 800037b2 <end_op>
  return 0;
    80004f36:	4501                	li	a0,0
    80004f38:	a031                	j	80004f44 <sys_mknod+0x80>
    end_op();
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	878080e7          	jalr	-1928(ra) # 800037b2 <end_op>
    return -1;
    80004f42:	557d                	li	a0,-1
}
    80004f44:	60ea                	ld	ra,152(sp)
    80004f46:	644a                	ld	s0,144(sp)
    80004f48:	610d                	addi	sp,sp,160
    80004f4a:	8082                	ret

0000000080004f4c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f4c:	7135                	addi	sp,sp,-160
    80004f4e:	ed06                	sd	ra,152(sp)
    80004f50:	e922                	sd	s0,144(sp)
    80004f52:	e526                	sd	s1,136(sp)
    80004f54:	e14a                	sd	s2,128(sp)
    80004f56:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f58:	ffffc097          	auipc	ra,0xffffc
    80004f5c:	0ba080e7          	jalr	186(ra) # 80001012 <myproc>
    80004f60:	892a                	mv	s2,a0
  
  begin_op();
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	7d0080e7          	jalr	2000(ra) # 80003732 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f6a:	08000613          	li	a2,128
    80004f6e:	f6040593          	addi	a1,s0,-160
    80004f72:	4501                	li	a0,0
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	2b6080e7          	jalr	694(ra) # 8000222a <argstr>
    80004f7c:	04054b63          	bltz	a0,80004fd2 <sys_chdir+0x86>
    80004f80:	f6040513          	addi	a0,s0,-160
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	592080e7          	jalr	1426(ra) # 80003516 <namei>
    80004f8c:	84aa                	mv	s1,a0
    80004f8e:	c131                	beqz	a0,80004fd2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	dd0080e7          	jalr	-560(ra) # 80002d60 <ilock>
  if(ip->type != T_DIR){
    80004f98:	04449703          	lh	a4,68(s1)
    80004f9c:	4785                	li	a5,1
    80004f9e:	04f71063          	bne	a4,a5,80004fde <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fa2:	8526                	mv	a0,s1
    80004fa4:	ffffe097          	auipc	ra,0xffffe
    80004fa8:	e7e080e7          	jalr	-386(ra) # 80002e22 <iunlock>
  iput(p->cwd);
    80004fac:	15893503          	ld	a0,344(s2)
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	f6a080e7          	jalr	-150(ra) # 80002f1a <iput>
  end_op();
    80004fb8:	ffffe097          	auipc	ra,0xffffe
    80004fbc:	7fa080e7          	jalr	2042(ra) # 800037b2 <end_op>
  p->cwd = ip;
    80004fc0:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fc4:	4501                	li	a0,0
}
    80004fc6:	60ea                	ld	ra,152(sp)
    80004fc8:	644a                	ld	s0,144(sp)
    80004fca:	64aa                	ld	s1,136(sp)
    80004fcc:	690a                	ld	s2,128(sp)
    80004fce:	610d                	addi	sp,sp,160
    80004fd0:	8082                	ret
    end_op();
    80004fd2:	ffffe097          	auipc	ra,0xffffe
    80004fd6:	7e0080e7          	jalr	2016(ra) # 800037b2 <end_op>
    return -1;
    80004fda:	557d                	li	a0,-1
    80004fdc:	b7ed                	j	80004fc6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fde:	8526                	mv	a0,s1
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	fe2080e7          	jalr	-30(ra) # 80002fc2 <iunlockput>
    end_op();
    80004fe8:	ffffe097          	auipc	ra,0xffffe
    80004fec:	7ca080e7          	jalr	1994(ra) # 800037b2 <end_op>
    return -1;
    80004ff0:	557d                	li	a0,-1
    80004ff2:	bfd1                	j	80004fc6 <sys_chdir+0x7a>

0000000080004ff4 <sys_exec>:

uint64
sys_exec(void)
{
    80004ff4:	7145                	addi	sp,sp,-464
    80004ff6:	e786                	sd	ra,456(sp)
    80004ff8:	e3a2                	sd	s0,448(sp)
    80004ffa:	ff26                	sd	s1,440(sp)
    80004ffc:	fb4a                	sd	s2,432(sp)
    80004ffe:	f74e                	sd	s3,424(sp)
    80005000:	f352                	sd	s4,416(sp)
    80005002:	ef56                	sd	s5,408(sp)
    80005004:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005006:	08000613          	li	a2,128
    8000500a:	f4040593          	addi	a1,s0,-192
    8000500e:	4501                	li	a0,0
    80005010:	ffffd097          	auipc	ra,0xffffd
    80005014:	21a080e7          	jalr	538(ra) # 8000222a <argstr>
    return -1;
    80005018:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000501a:	0c054a63          	bltz	a0,800050ee <sys_exec+0xfa>
    8000501e:	e3840593          	addi	a1,s0,-456
    80005022:	4505                	li	a0,1
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	1e4080e7          	jalr	484(ra) # 80002208 <argaddr>
    8000502c:	0c054163          	bltz	a0,800050ee <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005030:	10000613          	li	a2,256
    80005034:	4581                	li	a1,0
    80005036:	e4040513          	addi	a0,s0,-448
    8000503a:	ffffb097          	auipc	ra,0xffffb
    8000503e:	1f0080e7          	jalr	496(ra) # 8000022a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005042:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005046:	89a6                	mv	s3,s1
    80005048:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000504a:	02000a13          	li	s4,32
    8000504e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005052:	00391513          	slli	a0,s2,0x3
    80005056:	e3040593          	addi	a1,s0,-464
    8000505a:	e3843783          	ld	a5,-456(s0)
    8000505e:	953e                	add	a0,a0,a5
    80005060:	ffffd097          	auipc	ra,0xffffd
    80005064:	0ec080e7          	jalr	236(ra) # 8000214c <fetchaddr>
    80005068:	02054a63          	bltz	a0,8000509c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000506c:	e3043783          	ld	a5,-464(s0)
    80005070:	c3b9                	beqz	a5,800050b6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005072:	ffffb097          	auipc	ra,0xffffb
    80005076:	140080e7          	jalr	320(ra) # 800001b2 <kalloc>
    8000507a:	85aa                	mv	a1,a0
    8000507c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005080:	cd11                	beqz	a0,8000509c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005082:	6605                	lui	a2,0x1
    80005084:	e3043503          	ld	a0,-464(s0)
    80005088:	ffffd097          	auipc	ra,0xffffd
    8000508c:	116080e7          	jalr	278(ra) # 8000219e <fetchstr>
    80005090:	00054663          	bltz	a0,8000509c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005094:	0905                	addi	s2,s2,1
    80005096:	09a1                	addi	s3,s3,8
    80005098:	fb491be3          	bne	s2,s4,8000504e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509c:	10048913          	addi	s2,s1,256
    800050a0:	6088                	ld	a0,0(s1)
    800050a2:	c529                	beqz	a0,800050ec <sys_exec+0xf8>
    kfree(argv[i]);
    800050a4:	ffffb097          	auipc	ra,0xffffb
    800050a8:	fc0080e7          	jalr	-64(ra) # 80000064 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ac:	04a1                	addi	s1,s1,8
    800050ae:	ff2499e3          	bne	s1,s2,800050a0 <sys_exec+0xac>
  return -1;
    800050b2:	597d                	li	s2,-1
    800050b4:	a82d                	j	800050ee <sys_exec+0xfa>
      argv[i] = 0;
    800050b6:	0a8e                	slli	s5,s5,0x3
    800050b8:	fc040793          	addi	a5,s0,-64
    800050bc:	9abe                	add	s5,s5,a5
    800050be:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050c2:	e4040593          	addi	a1,s0,-448
    800050c6:	f4040513          	addi	a0,s0,-192
    800050ca:	fffff097          	auipc	ra,0xfffff
    800050ce:	194080e7          	jalr	404(ra) # 8000425e <exec>
    800050d2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050d4:	10048993          	addi	s3,s1,256
    800050d8:	6088                	ld	a0,0(s1)
    800050da:	c911                	beqz	a0,800050ee <sys_exec+0xfa>
    kfree(argv[i]);
    800050dc:	ffffb097          	auipc	ra,0xffffb
    800050e0:	f88080e7          	jalr	-120(ra) # 80000064 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e4:	04a1                	addi	s1,s1,8
    800050e6:	ff3499e3          	bne	s1,s3,800050d8 <sys_exec+0xe4>
    800050ea:	a011                	j	800050ee <sys_exec+0xfa>
  return -1;
    800050ec:	597d                	li	s2,-1
}
    800050ee:	854a                	mv	a0,s2
    800050f0:	60be                	ld	ra,456(sp)
    800050f2:	641e                	ld	s0,448(sp)
    800050f4:	74fa                	ld	s1,440(sp)
    800050f6:	795a                	ld	s2,432(sp)
    800050f8:	79ba                	ld	s3,424(sp)
    800050fa:	7a1a                	ld	s4,416(sp)
    800050fc:	6afa                	ld	s5,408(sp)
    800050fe:	6179                	addi	sp,sp,464
    80005100:	8082                	ret

0000000080005102 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005102:	7139                	addi	sp,sp,-64
    80005104:	fc06                	sd	ra,56(sp)
    80005106:	f822                	sd	s0,48(sp)
    80005108:	f426                	sd	s1,40(sp)
    8000510a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	f06080e7          	jalr	-250(ra) # 80001012 <myproc>
    80005114:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005116:	fd840593          	addi	a1,s0,-40
    8000511a:	4501                	li	a0,0
    8000511c:	ffffd097          	auipc	ra,0xffffd
    80005120:	0ec080e7          	jalr	236(ra) # 80002208 <argaddr>
    return -1;
    80005124:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005126:	0e054063          	bltz	a0,80005206 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000512a:	fc840593          	addi	a1,s0,-56
    8000512e:	fd040513          	addi	a0,s0,-48
    80005132:	fffff097          	auipc	ra,0xfffff
    80005136:	dfc080e7          	jalr	-516(ra) # 80003f2e <pipealloc>
    return -1;
    8000513a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000513c:	0c054563          	bltz	a0,80005206 <sys_pipe+0x104>
  fd0 = -1;
    80005140:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005144:	fd043503          	ld	a0,-48(s0)
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	508080e7          	jalr	1288(ra) # 80004650 <fdalloc>
    80005150:	fca42223          	sw	a0,-60(s0)
    80005154:	08054c63          	bltz	a0,800051ec <sys_pipe+0xea>
    80005158:	fc843503          	ld	a0,-56(s0)
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	4f4080e7          	jalr	1268(ra) # 80004650 <fdalloc>
    80005164:	fca42023          	sw	a0,-64(s0)
    80005168:	06054863          	bltz	a0,800051d8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000516c:	4691                	li	a3,4
    8000516e:	fc440613          	addi	a2,s0,-60
    80005172:	fd843583          	ld	a1,-40(s0)
    80005176:	68a8                	ld	a0,80(s1)
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	a2c080e7          	jalr	-1492(ra) # 80000ba4 <copyout>
    80005180:	02054063          	bltz	a0,800051a0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005184:	4691                	li	a3,4
    80005186:	fc040613          	addi	a2,s0,-64
    8000518a:	fd843583          	ld	a1,-40(s0)
    8000518e:	0591                	addi	a1,a1,4
    80005190:	68a8                	ld	a0,80(s1)
    80005192:	ffffc097          	auipc	ra,0xffffc
    80005196:	a12080e7          	jalr	-1518(ra) # 80000ba4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000519a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000519c:	06055563          	bgez	a0,80005206 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051a0:	fc442783          	lw	a5,-60(s0)
    800051a4:	07e9                	addi	a5,a5,26
    800051a6:	078e                	slli	a5,a5,0x3
    800051a8:	97a6                	add	a5,a5,s1
    800051aa:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051ae:	fc042503          	lw	a0,-64(s0)
    800051b2:	0569                	addi	a0,a0,26
    800051b4:	050e                	slli	a0,a0,0x3
    800051b6:	9526                	add	a0,a0,s1
    800051b8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051bc:	fd043503          	ld	a0,-48(s0)
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	a3e080e7          	jalr	-1474(ra) # 80003bfe <fileclose>
    fileclose(wf);
    800051c8:	fc843503          	ld	a0,-56(s0)
    800051cc:	fffff097          	auipc	ra,0xfffff
    800051d0:	a32080e7          	jalr	-1486(ra) # 80003bfe <fileclose>
    return -1;
    800051d4:	57fd                	li	a5,-1
    800051d6:	a805                	j	80005206 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051d8:	fc442783          	lw	a5,-60(s0)
    800051dc:	0007c863          	bltz	a5,800051ec <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051e0:	01a78513          	addi	a0,a5,26
    800051e4:	050e                	slli	a0,a0,0x3
    800051e6:	9526                	add	a0,a0,s1
    800051e8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051ec:	fd043503          	ld	a0,-48(s0)
    800051f0:	fffff097          	auipc	ra,0xfffff
    800051f4:	a0e080e7          	jalr	-1522(ra) # 80003bfe <fileclose>
    fileclose(wf);
    800051f8:	fc843503          	ld	a0,-56(s0)
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	a02080e7          	jalr	-1534(ra) # 80003bfe <fileclose>
    return -1;
    80005204:	57fd                	li	a5,-1
}
    80005206:	853e                	mv	a0,a5
    80005208:	70e2                	ld	ra,56(sp)
    8000520a:	7442                	ld	s0,48(sp)
    8000520c:	74a2                	ld	s1,40(sp)
    8000520e:	6121                	addi	sp,sp,64
    80005210:	8082                	ret
	...

0000000080005220 <kernelvec>:
    80005220:	7111                	addi	sp,sp,-256
    80005222:	e006                	sd	ra,0(sp)
    80005224:	e40a                	sd	sp,8(sp)
    80005226:	e80e                	sd	gp,16(sp)
    80005228:	ec12                	sd	tp,24(sp)
    8000522a:	f016                	sd	t0,32(sp)
    8000522c:	f41a                	sd	t1,40(sp)
    8000522e:	f81e                	sd	t2,48(sp)
    80005230:	fc22                	sd	s0,56(sp)
    80005232:	e0a6                	sd	s1,64(sp)
    80005234:	e4aa                	sd	a0,72(sp)
    80005236:	e8ae                	sd	a1,80(sp)
    80005238:	ecb2                	sd	a2,88(sp)
    8000523a:	f0b6                	sd	a3,96(sp)
    8000523c:	f4ba                	sd	a4,104(sp)
    8000523e:	f8be                	sd	a5,112(sp)
    80005240:	fcc2                	sd	a6,120(sp)
    80005242:	e146                	sd	a7,128(sp)
    80005244:	e54a                	sd	s2,136(sp)
    80005246:	e94e                	sd	s3,144(sp)
    80005248:	ed52                	sd	s4,152(sp)
    8000524a:	f156                	sd	s5,160(sp)
    8000524c:	f55a                	sd	s6,168(sp)
    8000524e:	f95e                	sd	s7,176(sp)
    80005250:	fd62                	sd	s8,184(sp)
    80005252:	e1e6                	sd	s9,192(sp)
    80005254:	e5ea                	sd	s10,200(sp)
    80005256:	e9ee                	sd	s11,208(sp)
    80005258:	edf2                	sd	t3,216(sp)
    8000525a:	f1f6                	sd	t4,224(sp)
    8000525c:	f5fa                	sd	t5,232(sp)
    8000525e:	f9fe                	sd	t6,240(sp)
    80005260:	db9fc0ef          	jal	ra,80002018 <kerneltrap>
    80005264:	6082                	ld	ra,0(sp)
    80005266:	6122                	ld	sp,8(sp)
    80005268:	61c2                	ld	gp,16(sp)
    8000526a:	7282                	ld	t0,32(sp)
    8000526c:	7322                	ld	t1,40(sp)
    8000526e:	73c2                	ld	t2,48(sp)
    80005270:	7462                	ld	s0,56(sp)
    80005272:	6486                	ld	s1,64(sp)
    80005274:	6526                	ld	a0,72(sp)
    80005276:	65c6                	ld	a1,80(sp)
    80005278:	6666                	ld	a2,88(sp)
    8000527a:	7686                	ld	a3,96(sp)
    8000527c:	7726                	ld	a4,104(sp)
    8000527e:	77c6                	ld	a5,112(sp)
    80005280:	7866                	ld	a6,120(sp)
    80005282:	688a                	ld	a7,128(sp)
    80005284:	692a                	ld	s2,136(sp)
    80005286:	69ca                	ld	s3,144(sp)
    80005288:	6a6a                	ld	s4,152(sp)
    8000528a:	7a8a                	ld	s5,160(sp)
    8000528c:	7b2a                	ld	s6,168(sp)
    8000528e:	7bca                	ld	s7,176(sp)
    80005290:	7c6a                	ld	s8,184(sp)
    80005292:	6c8e                	ld	s9,192(sp)
    80005294:	6d2e                	ld	s10,200(sp)
    80005296:	6dce                	ld	s11,208(sp)
    80005298:	6e6e                	ld	t3,216(sp)
    8000529a:	7e8e                	ld	t4,224(sp)
    8000529c:	7f2e                	ld	t5,232(sp)
    8000529e:	7fce                	ld	t6,240(sp)
    800052a0:	6111                	addi	sp,sp,256
    800052a2:	10200073          	sret
    800052a6:	00000013          	nop
    800052aa:	00000013          	nop
    800052ae:	0001                	nop

00000000800052b0 <timervec>:
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	e10c                	sd	a1,0(a0)
    800052b6:	e510                	sd	a2,8(a0)
    800052b8:	e914                	sd	a3,16(a0)
    800052ba:	6d0c                	ld	a1,24(a0)
    800052bc:	7110                	ld	a2,32(a0)
    800052be:	6194                	ld	a3,0(a1)
    800052c0:	96b2                	add	a3,a3,a2
    800052c2:	e194                	sd	a3,0(a1)
    800052c4:	4589                	li	a1,2
    800052c6:	14459073          	csrw	sip,a1
    800052ca:	6914                	ld	a3,16(a0)
    800052cc:	6510                	ld	a2,8(a0)
    800052ce:	610c                	ld	a1,0(a0)
    800052d0:	34051573          	csrrw	a0,mscratch,a0
    800052d4:	30200073          	mret
	...

00000000800052da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052da:	1141                	addi	sp,sp,-16
    800052dc:	e422                	sd	s0,8(sp)
    800052de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052e0:	0c0007b7          	lui	a5,0xc000
    800052e4:	4705                	li	a4,1
    800052e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052e8:	c3d8                	sw	a4,4(a5)
}
    800052ea:	6422                	ld	s0,8(sp)
    800052ec:	0141                	addi	sp,sp,16
    800052ee:	8082                	ret

00000000800052f0 <plicinithart>:

void
plicinithart(void)
{
    800052f0:	1141                	addi	sp,sp,-16
    800052f2:	e406                	sd	ra,8(sp)
    800052f4:	e022                	sd	s0,0(sp)
    800052f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	cee080e7          	jalr	-786(ra) # 80000fe6 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005300:	0085171b          	slliw	a4,a0,0x8
    80005304:	0c0027b7          	lui	a5,0xc002
    80005308:	97ba                	add	a5,a5,a4
    8000530a:	40200713          	li	a4,1026
    8000530e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005312:	00d5151b          	slliw	a0,a0,0xd
    80005316:	0c2017b7          	lui	a5,0xc201
    8000531a:	953e                	add	a0,a0,a5
    8000531c:	00052023          	sw	zero,0(a0)
}
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret

0000000080005328 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005328:	1141                	addi	sp,sp,-16
    8000532a:	e406                	sd	ra,8(sp)
    8000532c:	e022                	sd	s0,0(sp)
    8000532e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	cb6080e7          	jalr	-842(ra) # 80000fe6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005338:	00d5179b          	slliw	a5,a0,0xd
    8000533c:	0c201537          	lui	a0,0xc201
    80005340:	953e                	add	a0,a0,a5
  return irq;
}
    80005342:	4148                	lw	a0,4(a0)
    80005344:	60a2                	ld	ra,8(sp)
    80005346:	6402                	ld	s0,0(sp)
    80005348:	0141                	addi	sp,sp,16
    8000534a:	8082                	ret

000000008000534c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000534c:	1101                	addi	sp,sp,-32
    8000534e:	ec06                	sd	ra,24(sp)
    80005350:	e822                	sd	s0,16(sp)
    80005352:	e426                	sd	s1,8(sp)
    80005354:	1000                	addi	s0,sp,32
    80005356:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	c8e080e7          	jalr	-882(ra) # 80000fe6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005360:	00d5151b          	slliw	a0,a0,0xd
    80005364:	0c2017b7          	lui	a5,0xc201
    80005368:	97aa                	add	a5,a5,a0
    8000536a:	c3c4                	sw	s1,4(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret

0000000080005376 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005376:	1141                	addi	sp,sp,-16
    80005378:	e406                	sd	ra,8(sp)
    8000537a:	e022                	sd	s0,0(sp)
    8000537c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000537e:	479d                	li	a5,7
    80005380:	06a7c963          	blt	a5,a0,800053f2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005384:	00036797          	auipc	a5,0x36
    80005388:	c7c78793          	addi	a5,a5,-900 # 8003b000 <disk>
    8000538c:	00a78733          	add	a4,a5,a0
    80005390:	6789                	lui	a5,0x2
    80005392:	97ba                	add	a5,a5,a4
    80005394:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005398:	e7ad                	bnez	a5,80005402 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000539a:	00451793          	slli	a5,a0,0x4
    8000539e:	00038717          	auipc	a4,0x38
    800053a2:	c6270713          	addi	a4,a4,-926 # 8003d000 <disk+0x2000>
    800053a6:	6314                	ld	a3,0(a4)
    800053a8:	96be                	add	a3,a3,a5
    800053aa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053ae:	6314                	ld	a3,0(a4)
    800053b0:	96be                	add	a3,a3,a5
    800053b2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053b6:	6314                	ld	a3,0(a4)
    800053b8:	96be                	add	a3,a3,a5
    800053ba:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053be:	6318                	ld	a4,0(a4)
    800053c0:	97ba                	add	a5,a5,a4
    800053c2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053c6:	00036797          	auipc	a5,0x36
    800053ca:	c3a78793          	addi	a5,a5,-966 # 8003b000 <disk>
    800053ce:	97aa                	add	a5,a5,a0
    800053d0:	6509                	lui	a0,0x2
    800053d2:	953e                	add	a0,a0,a5
    800053d4:	4785                	li	a5,1
    800053d6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053da:	00038517          	auipc	a0,0x38
    800053de:	c3e50513          	addi	a0,a0,-962 # 8003d018 <disk+0x2018>
    800053e2:	ffffc097          	auipc	ra,0xffffc
    800053e6:	478080e7          	jalr	1144(ra) # 8000185a <wakeup>
}
    800053ea:	60a2                	ld	ra,8(sp)
    800053ec:	6402                	ld	s0,0(sp)
    800053ee:	0141                	addi	sp,sp,16
    800053f0:	8082                	ret
    panic("free_desc 1");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	38650513          	addi	a0,a0,902 # 80008778 <syscalls+0x320>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	a1e080e7          	jalr	-1506(ra) # 80005e18 <panic>
    panic("free_desc 2");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	38650513          	addi	a0,a0,902 # 80008788 <syscalls+0x330>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	a0e080e7          	jalr	-1522(ra) # 80005e18 <panic>

0000000080005412 <virtio_disk_init>:
{
    80005412:	1101                	addi	sp,sp,-32
    80005414:	ec06                	sd	ra,24(sp)
    80005416:	e822                	sd	s0,16(sp)
    80005418:	e426                	sd	s1,8(sp)
    8000541a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000541c:	00003597          	auipc	a1,0x3
    80005420:	37c58593          	addi	a1,a1,892 # 80008798 <syscalls+0x340>
    80005424:	00038517          	auipc	a0,0x38
    80005428:	d0450513          	addi	a0,a0,-764 # 8003d128 <disk+0x2128>
    8000542c:	00001097          	auipc	ra,0x1
    80005430:	f12080e7          	jalr	-238(ra) # 8000633e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005434:	100017b7          	lui	a5,0x10001
    80005438:	4398                	lw	a4,0(a5)
    8000543a:	2701                	sext.w	a4,a4
    8000543c:	747277b7          	lui	a5,0x74727
    80005440:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005444:	0ef71163          	bne	a4,a5,80005526 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005448:	100017b7          	lui	a5,0x10001
    8000544c:	43dc                	lw	a5,4(a5)
    8000544e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005450:	4705                	li	a4,1
    80005452:	0ce79a63          	bne	a5,a4,80005526 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005456:	100017b7          	lui	a5,0x10001
    8000545a:	479c                	lw	a5,8(a5)
    8000545c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000545e:	4709                	li	a4,2
    80005460:	0ce79363          	bne	a5,a4,80005526 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005464:	100017b7          	lui	a5,0x10001
    80005468:	47d8                	lw	a4,12(a5)
    8000546a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546c:	554d47b7          	lui	a5,0x554d4
    80005470:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005474:	0af71963          	bne	a4,a5,80005526 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005478:	100017b7          	lui	a5,0x10001
    8000547c:	4705                	li	a4,1
    8000547e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005480:	470d                	li	a4,3
    80005482:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005484:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005486:	c7ffe737          	lui	a4,0xc7ffe
    8000548a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb851f>
    8000548e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005490:	2701                	sext.w	a4,a4
    80005492:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005494:	472d                	li	a4,11
    80005496:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005498:	473d                	li	a4,15
    8000549a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000549c:	6705                	lui	a4,0x1
    8000549e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054a4:	5bdc                	lw	a5,52(a5)
    800054a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054a8:	c7d9                	beqz	a5,80005536 <virtio_disk_init+0x124>
  if(max < NUM)
    800054aa:	471d                	li	a4,7
    800054ac:	08f77d63          	bgeu	a4,a5,80005546 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054b0:	100014b7          	lui	s1,0x10001
    800054b4:	47a1                	li	a5,8
    800054b6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054b8:	6609                	lui	a2,0x2
    800054ba:	4581                	li	a1,0
    800054bc:	00036517          	auipc	a0,0x36
    800054c0:	b4450513          	addi	a0,a0,-1212 # 8003b000 <disk>
    800054c4:	ffffb097          	auipc	ra,0xffffb
    800054c8:	d66080e7          	jalr	-666(ra) # 8000022a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054cc:	00036717          	auipc	a4,0x36
    800054d0:	b3470713          	addi	a4,a4,-1228 # 8003b000 <disk>
    800054d4:	00c75793          	srli	a5,a4,0xc
    800054d8:	2781                	sext.w	a5,a5
    800054da:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054dc:	00038797          	auipc	a5,0x38
    800054e0:	b2478793          	addi	a5,a5,-1244 # 8003d000 <disk+0x2000>
    800054e4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054e6:	00036717          	auipc	a4,0x36
    800054ea:	b9a70713          	addi	a4,a4,-1126 # 8003b080 <disk+0x80>
    800054ee:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054f0:	00037717          	auipc	a4,0x37
    800054f4:	b1070713          	addi	a4,a4,-1264 # 8003c000 <disk+0x1000>
    800054f8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054fa:	4705                	li	a4,1
    800054fc:	00e78c23          	sb	a4,24(a5)
    80005500:	00e78ca3          	sb	a4,25(a5)
    80005504:	00e78d23          	sb	a4,26(a5)
    80005508:	00e78da3          	sb	a4,27(a5)
    8000550c:	00e78e23          	sb	a4,28(a5)
    80005510:	00e78ea3          	sb	a4,29(a5)
    80005514:	00e78f23          	sb	a4,30(a5)
    80005518:	00e78fa3          	sb	a4,31(a5)
}
    8000551c:	60e2                	ld	ra,24(sp)
    8000551e:	6442                	ld	s0,16(sp)
    80005520:	64a2                	ld	s1,8(sp)
    80005522:	6105                	addi	sp,sp,32
    80005524:	8082                	ret
    panic("could not find virtio disk");
    80005526:	00003517          	auipc	a0,0x3
    8000552a:	28250513          	addi	a0,a0,642 # 800087a8 <syscalls+0x350>
    8000552e:	00001097          	auipc	ra,0x1
    80005532:	8ea080e7          	jalr	-1814(ra) # 80005e18 <panic>
    panic("virtio disk has no queue 0");
    80005536:	00003517          	auipc	a0,0x3
    8000553a:	29250513          	addi	a0,a0,658 # 800087c8 <syscalls+0x370>
    8000553e:	00001097          	auipc	ra,0x1
    80005542:	8da080e7          	jalr	-1830(ra) # 80005e18 <panic>
    panic("virtio disk max queue too short");
    80005546:	00003517          	auipc	a0,0x3
    8000554a:	2a250513          	addi	a0,a0,674 # 800087e8 <syscalls+0x390>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	8ca080e7          	jalr	-1846(ra) # 80005e18 <panic>

0000000080005556 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005556:	7159                	addi	sp,sp,-112
    80005558:	f486                	sd	ra,104(sp)
    8000555a:	f0a2                	sd	s0,96(sp)
    8000555c:	eca6                	sd	s1,88(sp)
    8000555e:	e8ca                	sd	s2,80(sp)
    80005560:	e4ce                	sd	s3,72(sp)
    80005562:	e0d2                	sd	s4,64(sp)
    80005564:	fc56                	sd	s5,56(sp)
    80005566:	f85a                	sd	s6,48(sp)
    80005568:	f45e                	sd	s7,40(sp)
    8000556a:	f062                	sd	s8,32(sp)
    8000556c:	ec66                	sd	s9,24(sp)
    8000556e:	e86a                	sd	s10,16(sp)
    80005570:	1880                	addi	s0,sp,112
    80005572:	892a                	mv	s2,a0
    80005574:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005576:	00c52c83          	lw	s9,12(a0)
    8000557a:	001c9c9b          	slliw	s9,s9,0x1
    8000557e:	1c82                	slli	s9,s9,0x20
    80005580:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005584:	00038517          	auipc	a0,0x38
    80005588:	ba450513          	addi	a0,a0,-1116 # 8003d128 <disk+0x2128>
    8000558c:	00001097          	auipc	ra,0x1
    80005590:	e42080e7          	jalr	-446(ra) # 800063ce <acquire>
  for(int i = 0; i < 3; i++){
    80005594:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005596:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005598:	00036b97          	auipc	s7,0x36
    8000559c:	a68b8b93          	addi	s7,s7,-1432 # 8003b000 <disk>
    800055a0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800055a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800055a4:	8a4e                	mv	s4,s3
    800055a6:	a051                	j	8000562a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800055a8:	00fb86b3          	add	a3,s7,a5
    800055ac:	96da                	add	a3,a3,s6
    800055ae:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800055b2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800055b4:	0207c563          	bltz	a5,800055de <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055b8:	2485                	addiw	s1,s1,1
    800055ba:	0711                	addi	a4,a4,4
    800055bc:	25548063          	beq	s1,s5,800057fc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800055c0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055c2:	00038697          	auipc	a3,0x38
    800055c6:	a5668693          	addi	a3,a3,-1450 # 8003d018 <disk+0x2018>
    800055ca:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055cc:	0006c583          	lbu	a1,0(a3)
    800055d0:	fde1                	bnez	a1,800055a8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055d2:	2785                	addiw	a5,a5,1
    800055d4:	0685                	addi	a3,a3,1
    800055d6:	ff879be3          	bne	a5,s8,800055cc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055da:	57fd                	li	a5,-1
    800055dc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055de:	02905a63          	blez	s1,80005612 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055e2:	f9042503          	lw	a0,-112(s0)
    800055e6:	00000097          	auipc	ra,0x0
    800055ea:	d90080e7          	jalr	-624(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    800055ee:	4785                	li	a5,1
    800055f0:	0297d163          	bge	a5,s1,80005612 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055f4:	f9442503          	lw	a0,-108(s0)
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	d7e080e7          	jalr	-642(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    80005600:	4789                	li	a5,2
    80005602:	0097d863          	bge	a5,s1,80005612 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005606:	f9842503          	lw	a0,-104(s0)
    8000560a:	00000097          	auipc	ra,0x0
    8000560e:	d6c080e7          	jalr	-660(ra) # 80005376 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005612:	00038597          	auipc	a1,0x38
    80005616:	b1658593          	addi	a1,a1,-1258 # 8003d128 <disk+0x2128>
    8000561a:	00038517          	auipc	a0,0x38
    8000561e:	9fe50513          	addi	a0,a0,-1538 # 8003d018 <disk+0x2018>
    80005622:	ffffc097          	auipc	ra,0xffffc
    80005626:	0ac080e7          	jalr	172(ra) # 800016ce <sleep>
  for(int i = 0; i < 3; i++){
    8000562a:	f9040713          	addi	a4,s0,-112
    8000562e:	84ce                	mv	s1,s3
    80005630:	bf41                	j	800055c0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005632:	20058713          	addi	a4,a1,512
    80005636:	00471693          	slli	a3,a4,0x4
    8000563a:	00036717          	auipc	a4,0x36
    8000563e:	9c670713          	addi	a4,a4,-1594 # 8003b000 <disk>
    80005642:	9736                	add	a4,a4,a3
    80005644:	4685                	li	a3,1
    80005646:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000564a:	20058713          	addi	a4,a1,512
    8000564e:	00471693          	slli	a3,a4,0x4
    80005652:	00036717          	auipc	a4,0x36
    80005656:	9ae70713          	addi	a4,a4,-1618 # 8003b000 <disk>
    8000565a:	9736                	add	a4,a4,a3
    8000565c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005660:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005664:	7679                	lui	a2,0xffffe
    80005666:	963e                	add	a2,a2,a5
    80005668:	00038697          	auipc	a3,0x38
    8000566c:	99868693          	addi	a3,a3,-1640 # 8003d000 <disk+0x2000>
    80005670:	6298                	ld	a4,0(a3)
    80005672:	9732                	add	a4,a4,a2
    80005674:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005676:	6298                	ld	a4,0(a3)
    80005678:	9732                	add	a4,a4,a2
    8000567a:	4541                	li	a0,16
    8000567c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000567e:	6298                	ld	a4,0(a3)
    80005680:	9732                	add	a4,a4,a2
    80005682:	4505                	li	a0,1
    80005684:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005688:	f9442703          	lw	a4,-108(s0)
    8000568c:	6288                	ld	a0,0(a3)
    8000568e:	962a                	add	a2,a2,a0
    80005690:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005694:	0712                	slli	a4,a4,0x4
    80005696:	6290                	ld	a2,0(a3)
    80005698:	963a                	add	a2,a2,a4
    8000569a:	05890513          	addi	a0,s2,88
    8000569e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800056a0:	6294                	ld	a3,0(a3)
    800056a2:	96ba                	add	a3,a3,a4
    800056a4:	40000613          	li	a2,1024
    800056a8:	c690                	sw	a2,8(a3)
  if(write)
    800056aa:	140d0063          	beqz	s10,800057ea <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056ae:	00038697          	auipc	a3,0x38
    800056b2:	9526b683          	ld	a3,-1710(a3) # 8003d000 <disk+0x2000>
    800056b6:	96ba                	add	a3,a3,a4
    800056b8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056bc:	00036817          	auipc	a6,0x36
    800056c0:	94480813          	addi	a6,a6,-1724 # 8003b000 <disk>
    800056c4:	00038517          	auipc	a0,0x38
    800056c8:	93c50513          	addi	a0,a0,-1732 # 8003d000 <disk+0x2000>
    800056cc:	6114                	ld	a3,0(a0)
    800056ce:	96ba                	add	a3,a3,a4
    800056d0:	00c6d603          	lhu	a2,12(a3)
    800056d4:	00166613          	ori	a2,a2,1
    800056d8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056dc:	f9842683          	lw	a3,-104(s0)
    800056e0:	6110                	ld	a2,0(a0)
    800056e2:	9732                	add	a4,a4,a2
    800056e4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056e8:	20058613          	addi	a2,a1,512
    800056ec:	0612                	slli	a2,a2,0x4
    800056ee:	9642                	add	a2,a2,a6
    800056f0:	577d                	li	a4,-1
    800056f2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056f6:	00469713          	slli	a4,a3,0x4
    800056fa:	6114                	ld	a3,0(a0)
    800056fc:	96ba                	add	a3,a3,a4
    800056fe:	03078793          	addi	a5,a5,48
    80005702:	97c2                	add	a5,a5,a6
    80005704:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005706:	611c                	ld	a5,0(a0)
    80005708:	97ba                	add	a5,a5,a4
    8000570a:	4685                	li	a3,1
    8000570c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000570e:	611c                	ld	a5,0(a0)
    80005710:	97ba                	add	a5,a5,a4
    80005712:	4809                	li	a6,2
    80005714:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005718:	611c                	ld	a5,0(a0)
    8000571a:	973e                	add	a4,a4,a5
    8000571c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005720:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005724:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005728:	6518                	ld	a4,8(a0)
    8000572a:	00275783          	lhu	a5,2(a4)
    8000572e:	8b9d                	andi	a5,a5,7
    80005730:	0786                	slli	a5,a5,0x1
    80005732:	97ba                	add	a5,a5,a4
    80005734:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005738:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000573c:	6518                	ld	a4,8(a0)
    8000573e:	00275783          	lhu	a5,2(a4)
    80005742:	2785                	addiw	a5,a5,1
    80005744:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005748:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000574c:	100017b7          	lui	a5,0x10001
    80005750:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005754:	00492703          	lw	a4,4(s2)
    80005758:	4785                	li	a5,1
    8000575a:	02f71163          	bne	a4,a5,8000577c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000575e:	00038997          	auipc	s3,0x38
    80005762:	9ca98993          	addi	s3,s3,-1590 # 8003d128 <disk+0x2128>
  while(b->disk == 1) {
    80005766:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005768:	85ce                	mv	a1,s3
    8000576a:	854a                	mv	a0,s2
    8000576c:	ffffc097          	auipc	ra,0xffffc
    80005770:	f62080e7          	jalr	-158(ra) # 800016ce <sleep>
  while(b->disk == 1) {
    80005774:	00492783          	lw	a5,4(s2)
    80005778:	fe9788e3          	beq	a5,s1,80005768 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000577c:	f9042903          	lw	s2,-112(s0)
    80005780:	20090793          	addi	a5,s2,512
    80005784:	00479713          	slli	a4,a5,0x4
    80005788:	00036797          	auipc	a5,0x36
    8000578c:	87878793          	addi	a5,a5,-1928 # 8003b000 <disk>
    80005790:	97ba                	add	a5,a5,a4
    80005792:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005796:	00038997          	auipc	s3,0x38
    8000579a:	86a98993          	addi	s3,s3,-1942 # 8003d000 <disk+0x2000>
    8000579e:	00491713          	slli	a4,s2,0x4
    800057a2:	0009b783          	ld	a5,0(s3)
    800057a6:	97ba                	add	a5,a5,a4
    800057a8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057ac:	854a                	mv	a0,s2
    800057ae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057b2:	00000097          	auipc	ra,0x0
    800057b6:	bc4080e7          	jalr	-1084(ra) # 80005376 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057ba:	8885                	andi	s1,s1,1
    800057bc:	f0ed                	bnez	s1,8000579e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057be:	00038517          	auipc	a0,0x38
    800057c2:	96a50513          	addi	a0,a0,-1686 # 8003d128 <disk+0x2128>
    800057c6:	00001097          	auipc	ra,0x1
    800057ca:	cbc080e7          	jalr	-836(ra) # 80006482 <release>
}
    800057ce:	70a6                	ld	ra,104(sp)
    800057d0:	7406                	ld	s0,96(sp)
    800057d2:	64e6                	ld	s1,88(sp)
    800057d4:	6946                	ld	s2,80(sp)
    800057d6:	69a6                	ld	s3,72(sp)
    800057d8:	6a06                	ld	s4,64(sp)
    800057da:	7ae2                	ld	s5,56(sp)
    800057dc:	7b42                	ld	s6,48(sp)
    800057de:	7ba2                	ld	s7,40(sp)
    800057e0:	7c02                	ld	s8,32(sp)
    800057e2:	6ce2                	ld	s9,24(sp)
    800057e4:	6d42                	ld	s10,16(sp)
    800057e6:	6165                	addi	sp,sp,112
    800057e8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057ea:	00038697          	auipc	a3,0x38
    800057ee:	8166b683          	ld	a3,-2026(a3) # 8003d000 <disk+0x2000>
    800057f2:	96ba                	add	a3,a3,a4
    800057f4:	4609                	li	a2,2
    800057f6:	00c69623          	sh	a2,12(a3)
    800057fa:	b5c9                	j	800056bc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057fc:	f9042583          	lw	a1,-112(s0)
    80005800:	20058793          	addi	a5,a1,512
    80005804:	0792                	slli	a5,a5,0x4
    80005806:	00036517          	auipc	a0,0x36
    8000580a:	8a250513          	addi	a0,a0,-1886 # 8003b0a8 <disk+0xa8>
    8000580e:	953e                	add	a0,a0,a5
  if(write)
    80005810:	e20d11e3          	bnez	s10,80005632 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005814:	20058713          	addi	a4,a1,512
    80005818:	00471693          	slli	a3,a4,0x4
    8000581c:	00035717          	auipc	a4,0x35
    80005820:	7e470713          	addi	a4,a4,2020 # 8003b000 <disk>
    80005824:	9736                	add	a4,a4,a3
    80005826:	0a072423          	sw	zero,168(a4)
    8000582a:	b505                	j	8000564a <virtio_disk_rw+0xf4>

000000008000582c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000582c:	1101                	addi	sp,sp,-32
    8000582e:	ec06                	sd	ra,24(sp)
    80005830:	e822                	sd	s0,16(sp)
    80005832:	e426                	sd	s1,8(sp)
    80005834:	e04a                	sd	s2,0(sp)
    80005836:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005838:	00038517          	auipc	a0,0x38
    8000583c:	8f050513          	addi	a0,a0,-1808 # 8003d128 <disk+0x2128>
    80005840:	00001097          	auipc	ra,0x1
    80005844:	b8e080e7          	jalr	-1138(ra) # 800063ce <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005848:	10001737          	lui	a4,0x10001
    8000584c:	533c                	lw	a5,96(a4)
    8000584e:	8b8d                	andi	a5,a5,3
    80005850:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005852:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005856:	00037797          	auipc	a5,0x37
    8000585a:	7aa78793          	addi	a5,a5,1962 # 8003d000 <disk+0x2000>
    8000585e:	6b94                	ld	a3,16(a5)
    80005860:	0207d703          	lhu	a4,32(a5)
    80005864:	0026d783          	lhu	a5,2(a3)
    80005868:	06f70163          	beq	a4,a5,800058ca <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000586c:	00035917          	auipc	s2,0x35
    80005870:	79490913          	addi	s2,s2,1940 # 8003b000 <disk>
    80005874:	00037497          	auipc	s1,0x37
    80005878:	78c48493          	addi	s1,s1,1932 # 8003d000 <disk+0x2000>
    __sync_synchronize();
    8000587c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005880:	6898                	ld	a4,16(s1)
    80005882:	0204d783          	lhu	a5,32(s1)
    80005886:	8b9d                	andi	a5,a5,7
    80005888:	078e                	slli	a5,a5,0x3
    8000588a:	97ba                	add	a5,a5,a4
    8000588c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000588e:	20078713          	addi	a4,a5,512
    80005892:	0712                	slli	a4,a4,0x4
    80005894:	974a                	add	a4,a4,s2
    80005896:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000589a:	e731                	bnez	a4,800058e6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000589c:	20078793          	addi	a5,a5,512
    800058a0:	0792                	slli	a5,a5,0x4
    800058a2:	97ca                	add	a5,a5,s2
    800058a4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058a6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058aa:	ffffc097          	auipc	ra,0xffffc
    800058ae:	fb0080e7          	jalr	-80(ra) # 8000185a <wakeup>

    disk.used_idx += 1;
    800058b2:	0204d783          	lhu	a5,32(s1)
    800058b6:	2785                	addiw	a5,a5,1
    800058b8:	17c2                	slli	a5,a5,0x30
    800058ba:	93c1                	srli	a5,a5,0x30
    800058bc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058c0:	6898                	ld	a4,16(s1)
    800058c2:	00275703          	lhu	a4,2(a4)
    800058c6:	faf71be3          	bne	a4,a5,8000587c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058ca:	00038517          	auipc	a0,0x38
    800058ce:	85e50513          	addi	a0,a0,-1954 # 8003d128 <disk+0x2128>
    800058d2:	00001097          	auipc	ra,0x1
    800058d6:	bb0080e7          	jalr	-1104(ra) # 80006482 <release>
}
    800058da:	60e2                	ld	ra,24(sp)
    800058dc:	6442                	ld	s0,16(sp)
    800058de:	64a2                	ld	s1,8(sp)
    800058e0:	6902                	ld	s2,0(sp)
    800058e2:	6105                	addi	sp,sp,32
    800058e4:	8082                	ret
      panic("virtio_disk_intr status");
    800058e6:	00003517          	auipc	a0,0x3
    800058ea:	f2250513          	addi	a0,a0,-222 # 80008808 <syscalls+0x3b0>
    800058ee:	00000097          	auipc	ra,0x0
    800058f2:	52a080e7          	jalr	1322(ra) # 80005e18 <panic>

00000000800058f6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058f6:	1141                	addi	sp,sp,-16
    800058f8:	e422                	sd	s0,8(sp)
    800058fa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058fc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005900:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005904:	0037979b          	slliw	a5,a5,0x3
    80005908:	02004737          	lui	a4,0x2004
    8000590c:	97ba                	add	a5,a5,a4
    8000590e:	0200c737          	lui	a4,0x200c
    80005912:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005916:	000f4637          	lui	a2,0xf4
    8000591a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000591e:	95b2                	add	a1,a1,a2
    80005920:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005922:	00269713          	slli	a4,a3,0x2
    80005926:	9736                	add	a4,a4,a3
    80005928:	00371693          	slli	a3,a4,0x3
    8000592c:	00038717          	auipc	a4,0x38
    80005930:	6d470713          	addi	a4,a4,1748 # 8003e000 <timer_scratch>
    80005934:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005936:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005938:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000593a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000593e:	00000797          	auipc	a5,0x0
    80005942:	97278793          	addi	a5,a5,-1678 # 800052b0 <timervec>
    80005946:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000594a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000594e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005952:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005956:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000595a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000595e:	30479073          	csrw	mie,a5
}
    80005962:	6422                	ld	s0,8(sp)
    80005964:	0141                	addi	sp,sp,16
    80005966:	8082                	ret

0000000080005968 <start>:
{
    80005968:	1141                	addi	sp,sp,-16
    8000596a:	e406                	sd	ra,8(sp)
    8000596c:	e022                	sd	s0,0(sp)
    8000596e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005970:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005974:	7779                	lui	a4,0xffffe
    80005976:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb85bf>
    8000597a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000597c:	6705                	lui	a4,0x1
    8000597e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005982:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005984:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005988:	ffffb797          	auipc	a5,0xffffb
    8000598c:	a5078793          	addi	a5,a5,-1456 # 800003d8 <main>
    80005990:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005994:	4781                	li	a5,0
    80005996:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000599a:	67c1                	lui	a5,0x10
    8000599c:	17fd                	addi	a5,a5,-1
    8000599e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059a2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059a6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059aa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059ae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059b2:	57fd                	li	a5,-1
    800059b4:	83a9                	srli	a5,a5,0xa
    800059b6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059ba:	47bd                	li	a5,15
    800059bc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059c0:	00000097          	auipc	ra,0x0
    800059c4:	f36080e7          	jalr	-202(ra) # 800058f6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059c8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059cc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059ce:	823e                	mv	tp,a5
  asm volatile("mret");
    800059d0:	30200073          	mret
}
    800059d4:	60a2                	ld	ra,8(sp)
    800059d6:	6402                	ld	s0,0(sp)
    800059d8:	0141                	addi	sp,sp,16
    800059da:	8082                	ret

00000000800059dc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059dc:	715d                	addi	sp,sp,-80
    800059de:	e486                	sd	ra,72(sp)
    800059e0:	e0a2                	sd	s0,64(sp)
    800059e2:	fc26                	sd	s1,56(sp)
    800059e4:	f84a                	sd	s2,48(sp)
    800059e6:	f44e                	sd	s3,40(sp)
    800059e8:	f052                	sd	s4,32(sp)
    800059ea:	ec56                	sd	s5,24(sp)
    800059ec:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059ee:	04c05663          	blez	a2,80005a3a <consolewrite+0x5e>
    800059f2:	8a2a                	mv	s4,a0
    800059f4:	84ae                	mv	s1,a1
    800059f6:	89b2                	mv	s3,a2
    800059f8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059fa:	5afd                	li	s5,-1
    800059fc:	4685                	li	a3,1
    800059fe:	8626                	mv	a2,s1
    80005a00:	85d2                	mv	a1,s4
    80005a02:	fbf40513          	addi	a0,s0,-65
    80005a06:	ffffc097          	auipc	ra,0xffffc
    80005a0a:	0c2080e7          	jalr	194(ra) # 80001ac8 <either_copyin>
    80005a0e:	01550c63          	beq	a0,s5,80005a26 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a12:	fbf44503          	lbu	a0,-65(s0)
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	7fa080e7          	jalr	2042(ra) # 80006210 <uartputc>
  for(i = 0; i < n; i++){
    80005a1e:	2905                	addiw	s2,s2,1
    80005a20:	0485                	addi	s1,s1,1
    80005a22:	fd299de3          	bne	s3,s2,800059fc <consolewrite+0x20>
  }

  return i;
}
    80005a26:	854a                	mv	a0,s2
    80005a28:	60a6                	ld	ra,72(sp)
    80005a2a:	6406                	ld	s0,64(sp)
    80005a2c:	74e2                	ld	s1,56(sp)
    80005a2e:	7942                	ld	s2,48(sp)
    80005a30:	79a2                	ld	s3,40(sp)
    80005a32:	7a02                	ld	s4,32(sp)
    80005a34:	6ae2                	ld	s5,24(sp)
    80005a36:	6161                	addi	sp,sp,80
    80005a38:	8082                	ret
  for(i = 0; i < n; i++){
    80005a3a:	4901                	li	s2,0
    80005a3c:	b7ed                	j	80005a26 <consolewrite+0x4a>

0000000080005a3e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a3e:	7119                	addi	sp,sp,-128
    80005a40:	fc86                	sd	ra,120(sp)
    80005a42:	f8a2                	sd	s0,112(sp)
    80005a44:	f4a6                	sd	s1,104(sp)
    80005a46:	f0ca                	sd	s2,96(sp)
    80005a48:	ecce                	sd	s3,88(sp)
    80005a4a:	e8d2                	sd	s4,80(sp)
    80005a4c:	e4d6                	sd	s5,72(sp)
    80005a4e:	e0da                	sd	s6,64(sp)
    80005a50:	fc5e                	sd	s7,56(sp)
    80005a52:	f862                	sd	s8,48(sp)
    80005a54:	f466                	sd	s9,40(sp)
    80005a56:	f06a                	sd	s10,32(sp)
    80005a58:	ec6e                	sd	s11,24(sp)
    80005a5a:	0100                	addi	s0,sp,128
    80005a5c:	8b2a                	mv	s6,a0
    80005a5e:	8aae                	mv	s5,a1
    80005a60:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a62:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a66:	00040517          	auipc	a0,0x40
    80005a6a:	6da50513          	addi	a0,a0,1754 # 80046140 <cons>
    80005a6e:	00001097          	auipc	ra,0x1
    80005a72:	960080e7          	jalr	-1696(ra) # 800063ce <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a76:	00040497          	auipc	s1,0x40
    80005a7a:	6ca48493          	addi	s1,s1,1738 # 80046140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a7e:	89a6                	mv	s3,s1
    80005a80:	00040917          	auipc	s2,0x40
    80005a84:	75890913          	addi	s2,s2,1880 # 800461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a88:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a8a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a8c:	4da9                	li	s11,10
  while(n > 0){
    80005a8e:	07405863          	blez	s4,80005afe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a92:	0984a783          	lw	a5,152(s1)
    80005a96:	09c4a703          	lw	a4,156(s1)
    80005a9a:	02f71463          	bne	a4,a5,80005ac2 <consoleread+0x84>
      if(myproc()->killed){
    80005a9e:	ffffb097          	auipc	ra,0xffffb
    80005aa2:	574080e7          	jalr	1396(ra) # 80001012 <myproc>
    80005aa6:	551c                	lw	a5,40(a0)
    80005aa8:	e7b5                	bnez	a5,80005b14 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005aaa:	85ce                	mv	a1,s3
    80005aac:	854a                	mv	a0,s2
    80005aae:	ffffc097          	auipc	ra,0xffffc
    80005ab2:	c20080e7          	jalr	-992(ra) # 800016ce <sleep>
    while(cons.r == cons.w){
    80005ab6:	0984a783          	lw	a5,152(s1)
    80005aba:	09c4a703          	lw	a4,156(s1)
    80005abe:	fef700e3          	beq	a4,a5,80005a9e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005ac2:	0017871b          	addiw	a4,a5,1
    80005ac6:	08e4ac23          	sw	a4,152(s1)
    80005aca:	07f7f713          	andi	a4,a5,127
    80005ace:	9726                	add	a4,a4,s1
    80005ad0:	01874703          	lbu	a4,24(a4)
    80005ad4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ad8:	079c0663          	beq	s8,s9,80005b44 <consoleread+0x106>
    cbuf = c;
    80005adc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ae0:	4685                	li	a3,1
    80005ae2:	f8f40613          	addi	a2,s0,-113
    80005ae6:	85d6                	mv	a1,s5
    80005ae8:	855a                	mv	a0,s6
    80005aea:	ffffc097          	auipc	ra,0xffffc
    80005aee:	f88080e7          	jalr	-120(ra) # 80001a72 <either_copyout>
    80005af2:	01a50663          	beq	a0,s10,80005afe <consoleread+0xc0>
    dst++;
    80005af6:	0a85                	addi	s5,s5,1
    --n;
    80005af8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005afa:	f9bc1ae3          	bne	s8,s11,80005a8e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005afe:	00040517          	auipc	a0,0x40
    80005b02:	64250513          	addi	a0,a0,1602 # 80046140 <cons>
    80005b06:	00001097          	auipc	ra,0x1
    80005b0a:	97c080e7          	jalr	-1668(ra) # 80006482 <release>

  return target - n;
    80005b0e:	414b853b          	subw	a0,s7,s4
    80005b12:	a811                	j	80005b26 <consoleread+0xe8>
        release(&cons.lock);
    80005b14:	00040517          	auipc	a0,0x40
    80005b18:	62c50513          	addi	a0,a0,1580 # 80046140 <cons>
    80005b1c:	00001097          	auipc	ra,0x1
    80005b20:	966080e7          	jalr	-1690(ra) # 80006482 <release>
        return -1;
    80005b24:	557d                	li	a0,-1
}
    80005b26:	70e6                	ld	ra,120(sp)
    80005b28:	7446                	ld	s0,112(sp)
    80005b2a:	74a6                	ld	s1,104(sp)
    80005b2c:	7906                	ld	s2,96(sp)
    80005b2e:	69e6                	ld	s3,88(sp)
    80005b30:	6a46                	ld	s4,80(sp)
    80005b32:	6aa6                	ld	s5,72(sp)
    80005b34:	6b06                	ld	s6,64(sp)
    80005b36:	7be2                	ld	s7,56(sp)
    80005b38:	7c42                	ld	s8,48(sp)
    80005b3a:	7ca2                	ld	s9,40(sp)
    80005b3c:	7d02                	ld	s10,32(sp)
    80005b3e:	6de2                	ld	s11,24(sp)
    80005b40:	6109                	addi	sp,sp,128
    80005b42:	8082                	ret
      if(n < target){
    80005b44:	000a071b          	sext.w	a4,s4
    80005b48:	fb777be3          	bgeu	a4,s7,80005afe <consoleread+0xc0>
        cons.r--;
    80005b4c:	00040717          	auipc	a4,0x40
    80005b50:	68f72623          	sw	a5,1676(a4) # 800461d8 <cons+0x98>
    80005b54:	b76d                	j	80005afe <consoleread+0xc0>

0000000080005b56 <consputc>:
{
    80005b56:	1141                	addi	sp,sp,-16
    80005b58:	e406                	sd	ra,8(sp)
    80005b5a:	e022                	sd	s0,0(sp)
    80005b5c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b5e:	10000793          	li	a5,256
    80005b62:	00f50a63          	beq	a0,a5,80005b76 <consputc+0x20>
    uartputc_sync(c);
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	5d0080e7          	jalr	1488(ra) # 80006136 <uartputc_sync>
}
    80005b6e:	60a2                	ld	ra,8(sp)
    80005b70:	6402                	ld	s0,0(sp)
    80005b72:	0141                	addi	sp,sp,16
    80005b74:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b76:	4521                	li	a0,8
    80005b78:	00000097          	auipc	ra,0x0
    80005b7c:	5be080e7          	jalr	1470(ra) # 80006136 <uartputc_sync>
    80005b80:	02000513          	li	a0,32
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	5b2080e7          	jalr	1458(ra) # 80006136 <uartputc_sync>
    80005b8c:	4521                	li	a0,8
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	5a8080e7          	jalr	1448(ra) # 80006136 <uartputc_sync>
    80005b96:	bfe1                	j	80005b6e <consputc+0x18>

0000000080005b98 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b98:	1101                	addi	sp,sp,-32
    80005b9a:	ec06                	sd	ra,24(sp)
    80005b9c:	e822                	sd	s0,16(sp)
    80005b9e:	e426                	sd	s1,8(sp)
    80005ba0:	e04a                	sd	s2,0(sp)
    80005ba2:	1000                	addi	s0,sp,32
    80005ba4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ba6:	00040517          	auipc	a0,0x40
    80005baa:	59a50513          	addi	a0,a0,1434 # 80046140 <cons>
    80005bae:	00001097          	auipc	ra,0x1
    80005bb2:	820080e7          	jalr	-2016(ra) # 800063ce <acquire>

  switch(c){
    80005bb6:	47d5                	li	a5,21
    80005bb8:	0af48663          	beq	s1,a5,80005c64 <consoleintr+0xcc>
    80005bbc:	0297ca63          	blt	a5,s1,80005bf0 <consoleintr+0x58>
    80005bc0:	47a1                	li	a5,8
    80005bc2:	0ef48763          	beq	s1,a5,80005cb0 <consoleintr+0x118>
    80005bc6:	47c1                	li	a5,16
    80005bc8:	10f49a63          	bne	s1,a5,80005cdc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bcc:	ffffc097          	auipc	ra,0xffffc
    80005bd0:	f52080e7          	jalr	-174(ra) # 80001b1e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bd4:	00040517          	auipc	a0,0x40
    80005bd8:	56c50513          	addi	a0,a0,1388 # 80046140 <cons>
    80005bdc:	00001097          	auipc	ra,0x1
    80005be0:	8a6080e7          	jalr	-1882(ra) # 80006482 <release>
}
    80005be4:	60e2                	ld	ra,24(sp)
    80005be6:	6442                	ld	s0,16(sp)
    80005be8:	64a2                	ld	s1,8(sp)
    80005bea:	6902                	ld	s2,0(sp)
    80005bec:	6105                	addi	sp,sp,32
    80005bee:	8082                	ret
  switch(c){
    80005bf0:	07f00793          	li	a5,127
    80005bf4:	0af48e63          	beq	s1,a5,80005cb0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bf8:	00040717          	auipc	a4,0x40
    80005bfc:	54870713          	addi	a4,a4,1352 # 80046140 <cons>
    80005c00:	0a072783          	lw	a5,160(a4)
    80005c04:	09872703          	lw	a4,152(a4)
    80005c08:	9f99                	subw	a5,a5,a4
    80005c0a:	07f00713          	li	a4,127
    80005c0e:	fcf763e3          	bltu	a4,a5,80005bd4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c12:	47b5                	li	a5,13
    80005c14:	0cf48763          	beq	s1,a5,80005ce2 <consoleintr+0x14a>
      consputc(c);
    80005c18:	8526                	mv	a0,s1
    80005c1a:	00000097          	auipc	ra,0x0
    80005c1e:	f3c080e7          	jalr	-196(ra) # 80005b56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c22:	00040797          	auipc	a5,0x40
    80005c26:	51e78793          	addi	a5,a5,1310 # 80046140 <cons>
    80005c2a:	0a07a703          	lw	a4,160(a5)
    80005c2e:	0017069b          	addiw	a3,a4,1
    80005c32:	0006861b          	sext.w	a2,a3
    80005c36:	0ad7a023          	sw	a3,160(a5)
    80005c3a:	07f77713          	andi	a4,a4,127
    80005c3e:	97ba                	add	a5,a5,a4
    80005c40:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c44:	47a9                	li	a5,10
    80005c46:	0cf48563          	beq	s1,a5,80005d10 <consoleintr+0x178>
    80005c4a:	4791                	li	a5,4
    80005c4c:	0cf48263          	beq	s1,a5,80005d10 <consoleintr+0x178>
    80005c50:	00040797          	auipc	a5,0x40
    80005c54:	5887a783          	lw	a5,1416(a5) # 800461d8 <cons+0x98>
    80005c58:	0807879b          	addiw	a5,a5,128
    80005c5c:	f6f61ce3          	bne	a2,a5,80005bd4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c60:	863e                	mv	a2,a5
    80005c62:	a07d                	j	80005d10 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c64:	00040717          	auipc	a4,0x40
    80005c68:	4dc70713          	addi	a4,a4,1244 # 80046140 <cons>
    80005c6c:	0a072783          	lw	a5,160(a4)
    80005c70:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c74:	00040497          	auipc	s1,0x40
    80005c78:	4cc48493          	addi	s1,s1,1228 # 80046140 <cons>
    while(cons.e != cons.w &&
    80005c7c:	4929                	li	s2,10
    80005c7e:	f4f70be3          	beq	a4,a5,80005bd4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c82:	37fd                	addiw	a5,a5,-1
    80005c84:	07f7f713          	andi	a4,a5,127
    80005c88:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c8a:	01874703          	lbu	a4,24(a4)
    80005c8e:	f52703e3          	beq	a4,s2,80005bd4 <consoleintr+0x3c>
      cons.e--;
    80005c92:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c96:	10000513          	li	a0,256
    80005c9a:	00000097          	auipc	ra,0x0
    80005c9e:	ebc080e7          	jalr	-324(ra) # 80005b56 <consputc>
    while(cons.e != cons.w &&
    80005ca2:	0a04a783          	lw	a5,160(s1)
    80005ca6:	09c4a703          	lw	a4,156(s1)
    80005caa:	fcf71ce3          	bne	a4,a5,80005c82 <consoleintr+0xea>
    80005cae:	b71d                	j	80005bd4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005cb0:	00040717          	auipc	a4,0x40
    80005cb4:	49070713          	addi	a4,a4,1168 # 80046140 <cons>
    80005cb8:	0a072783          	lw	a5,160(a4)
    80005cbc:	09c72703          	lw	a4,156(a4)
    80005cc0:	f0f70ae3          	beq	a4,a5,80005bd4 <consoleintr+0x3c>
      cons.e--;
    80005cc4:	37fd                	addiw	a5,a5,-1
    80005cc6:	00040717          	auipc	a4,0x40
    80005cca:	50f72d23          	sw	a5,1306(a4) # 800461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cce:	10000513          	li	a0,256
    80005cd2:	00000097          	auipc	ra,0x0
    80005cd6:	e84080e7          	jalr	-380(ra) # 80005b56 <consputc>
    80005cda:	bded                	j	80005bd4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cdc:	ee048ce3          	beqz	s1,80005bd4 <consoleintr+0x3c>
    80005ce0:	bf21                	j	80005bf8 <consoleintr+0x60>
      consputc(c);
    80005ce2:	4529                	li	a0,10
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	e72080e7          	jalr	-398(ra) # 80005b56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005cec:	00040797          	auipc	a5,0x40
    80005cf0:	45478793          	addi	a5,a5,1108 # 80046140 <cons>
    80005cf4:	0a07a703          	lw	a4,160(a5)
    80005cf8:	0017069b          	addiw	a3,a4,1
    80005cfc:	0006861b          	sext.w	a2,a3
    80005d00:	0ad7a023          	sw	a3,160(a5)
    80005d04:	07f77713          	andi	a4,a4,127
    80005d08:	97ba                	add	a5,a5,a4
    80005d0a:	4729                	li	a4,10
    80005d0c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d10:	00040797          	auipc	a5,0x40
    80005d14:	4cc7a623          	sw	a2,1228(a5) # 800461dc <cons+0x9c>
        wakeup(&cons.r);
    80005d18:	00040517          	auipc	a0,0x40
    80005d1c:	4c050513          	addi	a0,a0,1216 # 800461d8 <cons+0x98>
    80005d20:	ffffc097          	auipc	ra,0xffffc
    80005d24:	b3a080e7          	jalr	-1222(ra) # 8000185a <wakeup>
    80005d28:	b575                	j	80005bd4 <consoleintr+0x3c>

0000000080005d2a <consoleinit>:

void
consoleinit(void)
{
    80005d2a:	1141                	addi	sp,sp,-16
    80005d2c:	e406                	sd	ra,8(sp)
    80005d2e:	e022                	sd	s0,0(sp)
    80005d30:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d32:	00003597          	auipc	a1,0x3
    80005d36:	aee58593          	addi	a1,a1,-1298 # 80008820 <syscalls+0x3c8>
    80005d3a:	00040517          	auipc	a0,0x40
    80005d3e:	40650513          	addi	a0,a0,1030 # 80046140 <cons>
    80005d42:	00000097          	auipc	ra,0x0
    80005d46:	5fc080e7          	jalr	1532(ra) # 8000633e <initlock>

  uartinit();
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	39c080e7          	jalr	924(ra) # 800060e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d52:	00033797          	auipc	a5,0x33
    80005d56:	57678793          	addi	a5,a5,1398 # 800392c8 <devsw>
    80005d5a:	00000717          	auipc	a4,0x0
    80005d5e:	ce470713          	addi	a4,a4,-796 # 80005a3e <consoleread>
    80005d62:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d64:	00000717          	auipc	a4,0x0
    80005d68:	c7870713          	addi	a4,a4,-904 # 800059dc <consolewrite>
    80005d6c:	ef98                	sd	a4,24(a5)
}
    80005d6e:	60a2                	ld	ra,8(sp)
    80005d70:	6402                	ld	s0,0(sp)
    80005d72:	0141                	addi	sp,sp,16
    80005d74:	8082                	ret

0000000080005d76 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d76:	7179                	addi	sp,sp,-48
    80005d78:	f406                	sd	ra,40(sp)
    80005d7a:	f022                	sd	s0,32(sp)
    80005d7c:	ec26                	sd	s1,24(sp)
    80005d7e:	e84a                	sd	s2,16(sp)
    80005d80:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d82:	c219                	beqz	a2,80005d88 <printint+0x12>
    80005d84:	08054663          	bltz	a0,80005e10 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d88:	2501                	sext.w	a0,a0
    80005d8a:	4881                	li	a7,0
    80005d8c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d90:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d92:	2581                	sext.w	a1,a1
    80005d94:	00003617          	auipc	a2,0x3
    80005d98:	acc60613          	addi	a2,a2,-1332 # 80008860 <digits>
    80005d9c:	883a                	mv	a6,a4
    80005d9e:	2705                	addiw	a4,a4,1
    80005da0:	02b577bb          	remuw	a5,a0,a1
    80005da4:	1782                	slli	a5,a5,0x20
    80005da6:	9381                	srli	a5,a5,0x20
    80005da8:	97b2                	add	a5,a5,a2
    80005daa:	0007c783          	lbu	a5,0(a5)
    80005dae:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005db2:	0005079b          	sext.w	a5,a0
    80005db6:	02b5553b          	divuw	a0,a0,a1
    80005dba:	0685                	addi	a3,a3,1
    80005dbc:	feb7f0e3          	bgeu	a5,a1,80005d9c <printint+0x26>

  if(sign)
    80005dc0:	00088b63          	beqz	a7,80005dd6 <printint+0x60>
    buf[i++] = '-';
    80005dc4:	fe040793          	addi	a5,s0,-32
    80005dc8:	973e                	add	a4,a4,a5
    80005dca:	02d00793          	li	a5,45
    80005dce:	fef70823          	sb	a5,-16(a4)
    80005dd2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005dd6:	02e05763          	blez	a4,80005e04 <printint+0x8e>
    80005dda:	fd040793          	addi	a5,s0,-48
    80005dde:	00e784b3          	add	s1,a5,a4
    80005de2:	fff78913          	addi	s2,a5,-1
    80005de6:	993a                	add	s2,s2,a4
    80005de8:	377d                	addiw	a4,a4,-1
    80005dea:	1702                	slli	a4,a4,0x20
    80005dec:	9301                	srli	a4,a4,0x20
    80005dee:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005df2:	fff4c503          	lbu	a0,-1(s1)
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	d60080e7          	jalr	-672(ra) # 80005b56 <consputc>
  while(--i >= 0)
    80005dfe:	14fd                	addi	s1,s1,-1
    80005e00:	ff2499e3          	bne	s1,s2,80005df2 <printint+0x7c>
}
    80005e04:	70a2                	ld	ra,40(sp)
    80005e06:	7402                	ld	s0,32(sp)
    80005e08:	64e2                	ld	s1,24(sp)
    80005e0a:	6942                	ld	s2,16(sp)
    80005e0c:	6145                	addi	sp,sp,48
    80005e0e:	8082                	ret
    x = -xx;
    80005e10:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e14:	4885                	li	a7,1
    x = -xx;
    80005e16:	bf9d                	j	80005d8c <printint+0x16>

0000000080005e18 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e18:	1101                	addi	sp,sp,-32
    80005e1a:	ec06                	sd	ra,24(sp)
    80005e1c:	e822                	sd	s0,16(sp)
    80005e1e:	e426                	sd	s1,8(sp)
    80005e20:	1000                	addi	s0,sp,32
    80005e22:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e24:	00040797          	auipc	a5,0x40
    80005e28:	3c07ae23          	sw	zero,988(a5) # 80046200 <pr+0x18>
  printf("panic: ");
    80005e2c:	00003517          	auipc	a0,0x3
    80005e30:	9fc50513          	addi	a0,a0,-1540 # 80008828 <syscalls+0x3d0>
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	02e080e7          	jalr	46(ra) # 80005e62 <printf>
  printf(s);
    80005e3c:	8526                	mv	a0,s1
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	024080e7          	jalr	36(ra) # 80005e62 <printf>
  printf("\n");
    80005e46:	00002517          	auipc	a0,0x2
    80005e4a:	20250513          	addi	a0,a0,514 # 80008048 <etext+0x48>
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	014080e7          	jalr	20(ra) # 80005e62 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e56:	4785                	li	a5,1
    80005e58:	00003717          	auipc	a4,0x3
    80005e5c:	1cf72223          	sw	a5,452(a4) # 8000901c <panicked>
  for(;;)
    80005e60:	a001                	j	80005e60 <panic+0x48>

0000000080005e62 <printf>:
{
    80005e62:	7131                	addi	sp,sp,-192
    80005e64:	fc86                	sd	ra,120(sp)
    80005e66:	f8a2                	sd	s0,112(sp)
    80005e68:	f4a6                	sd	s1,104(sp)
    80005e6a:	f0ca                	sd	s2,96(sp)
    80005e6c:	ecce                	sd	s3,88(sp)
    80005e6e:	e8d2                	sd	s4,80(sp)
    80005e70:	e4d6                	sd	s5,72(sp)
    80005e72:	e0da                	sd	s6,64(sp)
    80005e74:	fc5e                	sd	s7,56(sp)
    80005e76:	f862                	sd	s8,48(sp)
    80005e78:	f466                	sd	s9,40(sp)
    80005e7a:	f06a                	sd	s10,32(sp)
    80005e7c:	ec6e                	sd	s11,24(sp)
    80005e7e:	0100                	addi	s0,sp,128
    80005e80:	8a2a                	mv	s4,a0
    80005e82:	e40c                	sd	a1,8(s0)
    80005e84:	e810                	sd	a2,16(s0)
    80005e86:	ec14                	sd	a3,24(s0)
    80005e88:	f018                	sd	a4,32(s0)
    80005e8a:	f41c                	sd	a5,40(s0)
    80005e8c:	03043823          	sd	a6,48(s0)
    80005e90:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e94:	00040d97          	auipc	s11,0x40
    80005e98:	36cdad83          	lw	s11,876(s11) # 80046200 <pr+0x18>
  if(locking)
    80005e9c:	020d9b63          	bnez	s11,80005ed2 <printf+0x70>
  if (fmt == 0)
    80005ea0:	040a0263          	beqz	s4,80005ee4 <printf+0x82>
  va_start(ap, fmt);
    80005ea4:	00840793          	addi	a5,s0,8
    80005ea8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eac:	000a4503          	lbu	a0,0(s4)
    80005eb0:	16050263          	beqz	a0,80006014 <printf+0x1b2>
    80005eb4:	4481                	li	s1,0
    if(c != '%'){
    80005eb6:	02500a93          	li	s5,37
    switch(c){
    80005eba:	07000b13          	li	s6,112
  consputc('x');
    80005ebe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ec0:	00003b97          	auipc	s7,0x3
    80005ec4:	9a0b8b93          	addi	s7,s7,-1632 # 80008860 <digits>
    switch(c){
    80005ec8:	07300c93          	li	s9,115
    80005ecc:	06400c13          	li	s8,100
    80005ed0:	a82d                	j	80005f0a <printf+0xa8>
    acquire(&pr.lock);
    80005ed2:	00040517          	auipc	a0,0x40
    80005ed6:	31650513          	addi	a0,a0,790 # 800461e8 <pr>
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	4f4080e7          	jalr	1268(ra) # 800063ce <acquire>
    80005ee2:	bf7d                	j	80005ea0 <printf+0x3e>
    panic("null fmt");
    80005ee4:	00003517          	auipc	a0,0x3
    80005ee8:	95450513          	addi	a0,a0,-1708 # 80008838 <syscalls+0x3e0>
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	f2c080e7          	jalr	-212(ra) # 80005e18 <panic>
      consputc(c);
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	c62080e7          	jalr	-926(ra) # 80005b56 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005efc:	2485                	addiw	s1,s1,1
    80005efe:	009a07b3          	add	a5,s4,s1
    80005f02:	0007c503          	lbu	a0,0(a5)
    80005f06:	10050763          	beqz	a0,80006014 <printf+0x1b2>
    if(c != '%'){
    80005f0a:	ff5515e3          	bne	a0,s5,80005ef4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f0e:	2485                	addiw	s1,s1,1
    80005f10:	009a07b3          	add	a5,s4,s1
    80005f14:	0007c783          	lbu	a5,0(a5)
    80005f18:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f1c:	cfe5                	beqz	a5,80006014 <printf+0x1b2>
    switch(c){
    80005f1e:	05678a63          	beq	a5,s6,80005f72 <printf+0x110>
    80005f22:	02fb7663          	bgeu	s6,a5,80005f4e <printf+0xec>
    80005f26:	09978963          	beq	a5,s9,80005fb8 <printf+0x156>
    80005f2a:	07800713          	li	a4,120
    80005f2e:	0ce79863          	bne	a5,a4,80005ffe <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f32:	f8843783          	ld	a5,-120(s0)
    80005f36:	00878713          	addi	a4,a5,8
    80005f3a:	f8e43423          	sd	a4,-120(s0)
    80005f3e:	4605                	li	a2,1
    80005f40:	85ea                	mv	a1,s10
    80005f42:	4388                	lw	a0,0(a5)
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	e32080e7          	jalr	-462(ra) # 80005d76 <printint>
      break;
    80005f4c:	bf45                	j	80005efc <printf+0x9a>
    switch(c){
    80005f4e:	0b578263          	beq	a5,s5,80005ff2 <printf+0x190>
    80005f52:	0b879663          	bne	a5,s8,80005ffe <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f56:	f8843783          	ld	a5,-120(s0)
    80005f5a:	00878713          	addi	a4,a5,8
    80005f5e:	f8e43423          	sd	a4,-120(s0)
    80005f62:	4605                	li	a2,1
    80005f64:	45a9                	li	a1,10
    80005f66:	4388                	lw	a0,0(a5)
    80005f68:	00000097          	auipc	ra,0x0
    80005f6c:	e0e080e7          	jalr	-498(ra) # 80005d76 <printint>
      break;
    80005f70:	b771                	j	80005efc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f72:	f8843783          	ld	a5,-120(s0)
    80005f76:	00878713          	addi	a4,a5,8
    80005f7a:	f8e43423          	sd	a4,-120(s0)
    80005f7e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f82:	03000513          	li	a0,48
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	bd0080e7          	jalr	-1072(ra) # 80005b56 <consputc>
  consputc('x');
    80005f8e:	07800513          	li	a0,120
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	bc4080e7          	jalr	-1084(ra) # 80005b56 <consputc>
    80005f9a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f9c:	03c9d793          	srli	a5,s3,0x3c
    80005fa0:	97de                	add	a5,a5,s7
    80005fa2:	0007c503          	lbu	a0,0(a5)
    80005fa6:	00000097          	auipc	ra,0x0
    80005faa:	bb0080e7          	jalr	-1104(ra) # 80005b56 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fae:	0992                	slli	s3,s3,0x4
    80005fb0:	397d                	addiw	s2,s2,-1
    80005fb2:	fe0915e3          	bnez	s2,80005f9c <printf+0x13a>
    80005fb6:	b799                	j	80005efc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fb8:	f8843783          	ld	a5,-120(s0)
    80005fbc:	00878713          	addi	a4,a5,8
    80005fc0:	f8e43423          	sd	a4,-120(s0)
    80005fc4:	0007b903          	ld	s2,0(a5)
    80005fc8:	00090e63          	beqz	s2,80005fe4 <printf+0x182>
      for(; *s; s++)
    80005fcc:	00094503          	lbu	a0,0(s2)
    80005fd0:	d515                	beqz	a0,80005efc <printf+0x9a>
        consputc(*s);
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	b84080e7          	jalr	-1148(ra) # 80005b56 <consputc>
      for(; *s; s++)
    80005fda:	0905                	addi	s2,s2,1
    80005fdc:	00094503          	lbu	a0,0(s2)
    80005fe0:	f96d                	bnez	a0,80005fd2 <printf+0x170>
    80005fe2:	bf29                	j	80005efc <printf+0x9a>
        s = "(null)";
    80005fe4:	00003917          	auipc	s2,0x3
    80005fe8:	84c90913          	addi	s2,s2,-1972 # 80008830 <syscalls+0x3d8>
      for(; *s; s++)
    80005fec:	02800513          	li	a0,40
    80005ff0:	b7cd                	j	80005fd2 <printf+0x170>
      consputc('%');
    80005ff2:	8556                	mv	a0,s5
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	b62080e7          	jalr	-1182(ra) # 80005b56 <consputc>
      break;
    80005ffc:	b701                	j	80005efc <printf+0x9a>
      consputc('%');
    80005ffe:	8556                	mv	a0,s5
    80006000:	00000097          	auipc	ra,0x0
    80006004:	b56080e7          	jalr	-1194(ra) # 80005b56 <consputc>
      consputc(c);
    80006008:	854a                	mv	a0,s2
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	b4c080e7          	jalr	-1204(ra) # 80005b56 <consputc>
      break;
    80006012:	b5ed                	j	80005efc <printf+0x9a>
  if(locking)
    80006014:	020d9163          	bnez	s11,80006036 <printf+0x1d4>
}
    80006018:	70e6                	ld	ra,120(sp)
    8000601a:	7446                	ld	s0,112(sp)
    8000601c:	74a6                	ld	s1,104(sp)
    8000601e:	7906                	ld	s2,96(sp)
    80006020:	69e6                	ld	s3,88(sp)
    80006022:	6a46                	ld	s4,80(sp)
    80006024:	6aa6                	ld	s5,72(sp)
    80006026:	6b06                	ld	s6,64(sp)
    80006028:	7be2                	ld	s7,56(sp)
    8000602a:	7c42                	ld	s8,48(sp)
    8000602c:	7ca2                	ld	s9,40(sp)
    8000602e:	7d02                	ld	s10,32(sp)
    80006030:	6de2                	ld	s11,24(sp)
    80006032:	6129                	addi	sp,sp,192
    80006034:	8082                	ret
    release(&pr.lock);
    80006036:	00040517          	auipc	a0,0x40
    8000603a:	1b250513          	addi	a0,a0,434 # 800461e8 <pr>
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	444080e7          	jalr	1092(ra) # 80006482 <release>
}
    80006046:	bfc9                	j	80006018 <printf+0x1b6>

0000000080006048 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006048:	1101                	addi	sp,sp,-32
    8000604a:	ec06                	sd	ra,24(sp)
    8000604c:	e822                	sd	s0,16(sp)
    8000604e:	e426                	sd	s1,8(sp)
    80006050:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006052:	00040497          	auipc	s1,0x40
    80006056:	19648493          	addi	s1,s1,406 # 800461e8 <pr>
    8000605a:	00002597          	auipc	a1,0x2
    8000605e:	7ee58593          	addi	a1,a1,2030 # 80008848 <syscalls+0x3f0>
    80006062:	8526                	mv	a0,s1
    80006064:	00000097          	auipc	ra,0x0
    80006068:	2da080e7          	jalr	730(ra) # 8000633e <initlock>
  pr.locking = 1;
    8000606c:	4785                	li	a5,1
    8000606e:	cc9c                	sw	a5,24(s1)
}
    80006070:	60e2                	ld	ra,24(sp)
    80006072:	6442                	ld	s0,16(sp)
    80006074:	64a2                	ld	s1,8(sp)
    80006076:	6105                	addi	sp,sp,32
    80006078:	8082                	ret

000000008000607a <backtrace>:

//** prints a list of function calls on the stack above the point at which current frame pointer is pointing
void 
backtrace(void)
{
    8000607a:	7179                	addi	sp,sp,-48
    8000607c:	f406                	sd	ra,40(sp)
    8000607e:	f022                	sd	s0,32(sp)
    80006080:	ec26                	sd	s1,24(sp)
    80006082:	e84a                	sd	s2,16(sp)
    80006084:	e44e                	sd	s3,8(sp)
    80006086:	e052                	sd	s4,0(sp)
    80006088:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    8000608a:	00002517          	auipc	a0,0x2
    8000608e:	7c650513          	addi	a0,a0,1990 # 80008850 <syscalls+0x3f8>
    80006092:	00000097          	auipc	ra,0x0
    80006096:	dd0080e7          	jalr	-560(ra) # 80005e62 <printf>
//** returns current frame pointer
static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    8000609a:	84a2                	mv	s1,s0
  uint64 cfp;
  cfp=r_fp();  //current frame pointer
  uint64 upperlimit = PGROUNDUP(cfp);   // top address of stack page
    8000609c:	6905                	lui	s2,0x1
    8000609e:	197d                	addi	s2,s2,-1
    800060a0:	9926                	add	s2,s2,s1
    800060a2:	79fd                	lui	s3,0xfffff
    800060a4:	01397933          	and	s2,s2,s3
  uint64 lowerlimit = PGROUNDDOWN(cfp); // bottom address of stack page
    800060a8:	0134f9b3          	and	s3,s1,s3
  while((cfp > lowerlimit) && (cfp < upperlimit))
    800060ac:	0299f563          	bgeu	s3,s1,800060d6 <backtrace+0x5c>
    800060b0:	0324f363          	bgeu	s1,s2,800060d6 <backtrace+0x5c>
  {
    printf("%p\n",*((uint64*)(cfp-8))); // prints the return address
    800060b4:	00002a17          	auipc	s4,0x2
    800060b8:	0fca0a13          	addi	s4,s4,252 # 800081b0 <etext+0x1b0>
    800060bc:	ff84b583          	ld	a1,-8(s1)
    800060c0:	8552                	mv	a0,s4
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	da0080e7          	jalr	-608(ra) # 80005e62 <printf>
    cfp = *((uint64*)(cfp-16));         // update current fp with previous function call fp
    800060ca:	ff04b483          	ld	s1,-16(s1)
  while((cfp > lowerlimit) && (cfp < upperlimit))
    800060ce:	0099f463          	bgeu	s3,s1,800060d6 <backtrace+0x5c>
    800060d2:	ff24e5e3          	bltu	s1,s2,800060bc <backtrace+0x42>
  }
    800060d6:	70a2                	ld	ra,40(sp)
    800060d8:	7402                	ld	s0,32(sp)
    800060da:	64e2                	ld	s1,24(sp)
    800060dc:	6942                	ld	s2,16(sp)
    800060de:	69a2                	ld	s3,8(sp)
    800060e0:	6a02                	ld	s4,0(sp)
    800060e2:	6145                	addi	sp,sp,48
    800060e4:	8082                	ret

00000000800060e6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060e6:	1141                	addi	sp,sp,-16
    800060e8:	e406                	sd	ra,8(sp)
    800060ea:	e022                	sd	s0,0(sp)
    800060ec:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060ee:	100007b7          	lui	a5,0x10000
    800060f2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060f6:	f8000713          	li	a4,-128
    800060fa:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060fe:	470d                	li	a4,3
    80006100:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006104:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006108:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000610c:	469d                	li	a3,7
    8000610e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006112:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006116:	00002597          	auipc	a1,0x2
    8000611a:	76258593          	addi	a1,a1,1890 # 80008878 <digits+0x18>
    8000611e:	00040517          	auipc	a0,0x40
    80006122:	0ea50513          	addi	a0,a0,234 # 80046208 <uart_tx_lock>
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	218080e7          	jalr	536(ra) # 8000633e <initlock>
}
    8000612e:	60a2                	ld	ra,8(sp)
    80006130:	6402                	ld	s0,0(sp)
    80006132:	0141                	addi	sp,sp,16
    80006134:	8082                	ret

0000000080006136 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006136:	1101                	addi	sp,sp,-32
    80006138:	ec06                	sd	ra,24(sp)
    8000613a:	e822                	sd	s0,16(sp)
    8000613c:	e426                	sd	s1,8(sp)
    8000613e:	1000                	addi	s0,sp,32
    80006140:	84aa                	mv	s1,a0
  push_off();
    80006142:	00000097          	auipc	ra,0x0
    80006146:	240080e7          	jalr	576(ra) # 80006382 <push_off>

  if(panicked){
    8000614a:	00003797          	auipc	a5,0x3
    8000614e:	ed27a783          	lw	a5,-302(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006152:	10000737          	lui	a4,0x10000
  if(panicked){
    80006156:	c391                	beqz	a5,8000615a <uartputc_sync+0x24>
    for(;;)
    80006158:	a001                	j	80006158 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000615a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000615e:	0ff7f793          	andi	a5,a5,255
    80006162:	0207f793          	andi	a5,a5,32
    80006166:	dbf5                	beqz	a5,8000615a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006168:	0ff4f793          	andi	a5,s1,255
    8000616c:	10000737          	lui	a4,0x10000
    80006170:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006174:	00000097          	auipc	ra,0x0
    80006178:	2ae080e7          	jalr	686(ra) # 80006422 <pop_off>
}
    8000617c:	60e2                	ld	ra,24(sp)
    8000617e:	6442                	ld	s0,16(sp)
    80006180:	64a2                	ld	s1,8(sp)
    80006182:	6105                	addi	sp,sp,32
    80006184:	8082                	ret

0000000080006186 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006186:	00003717          	auipc	a4,0x3
    8000618a:	e9a73703          	ld	a4,-358(a4) # 80009020 <uart_tx_r>
    8000618e:	00003797          	auipc	a5,0x3
    80006192:	e9a7b783          	ld	a5,-358(a5) # 80009028 <uart_tx_w>
    80006196:	06e78c63          	beq	a5,a4,8000620e <uartstart+0x88>
{
    8000619a:	7139                	addi	sp,sp,-64
    8000619c:	fc06                	sd	ra,56(sp)
    8000619e:	f822                	sd	s0,48(sp)
    800061a0:	f426                	sd	s1,40(sp)
    800061a2:	f04a                	sd	s2,32(sp)
    800061a4:	ec4e                	sd	s3,24(sp)
    800061a6:	e852                	sd	s4,16(sp)
    800061a8:	e456                	sd	s5,8(sp)
    800061aa:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061ac:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061b0:	00040a17          	auipc	s4,0x40
    800061b4:	058a0a13          	addi	s4,s4,88 # 80046208 <uart_tx_lock>
    uart_tx_r += 1;
    800061b8:	00003497          	auipc	s1,0x3
    800061bc:	e6848493          	addi	s1,s1,-408 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061c0:	00003997          	auipc	s3,0x3
    800061c4:	e6898993          	addi	s3,s3,-408 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061c8:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061cc:	0ff7f793          	andi	a5,a5,255
    800061d0:	0207f793          	andi	a5,a5,32
    800061d4:	c785                	beqz	a5,800061fc <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061d6:	01f77793          	andi	a5,a4,31
    800061da:	97d2                	add	a5,a5,s4
    800061dc:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061e0:	0705                	addi	a4,a4,1
    800061e2:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061e4:	8526                	mv	a0,s1
    800061e6:	ffffb097          	auipc	ra,0xffffb
    800061ea:	674080e7          	jalr	1652(ra) # 8000185a <wakeup>
    
    WriteReg(THR, c);
    800061ee:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061f2:	6098                	ld	a4,0(s1)
    800061f4:	0009b783          	ld	a5,0(s3)
    800061f8:	fce798e3          	bne	a5,a4,800061c8 <uartstart+0x42>
  }
}
    800061fc:	70e2                	ld	ra,56(sp)
    800061fe:	7442                	ld	s0,48(sp)
    80006200:	74a2                	ld	s1,40(sp)
    80006202:	7902                	ld	s2,32(sp)
    80006204:	69e2                	ld	s3,24(sp)
    80006206:	6a42                	ld	s4,16(sp)
    80006208:	6aa2                	ld	s5,8(sp)
    8000620a:	6121                	addi	sp,sp,64
    8000620c:	8082                	ret
    8000620e:	8082                	ret

0000000080006210 <uartputc>:
{
    80006210:	7179                	addi	sp,sp,-48
    80006212:	f406                	sd	ra,40(sp)
    80006214:	f022                	sd	s0,32(sp)
    80006216:	ec26                	sd	s1,24(sp)
    80006218:	e84a                	sd	s2,16(sp)
    8000621a:	e44e                	sd	s3,8(sp)
    8000621c:	e052                	sd	s4,0(sp)
    8000621e:	1800                	addi	s0,sp,48
    80006220:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006222:	00040517          	auipc	a0,0x40
    80006226:	fe650513          	addi	a0,a0,-26 # 80046208 <uart_tx_lock>
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	1a4080e7          	jalr	420(ra) # 800063ce <acquire>
  if(panicked){
    80006232:	00003797          	auipc	a5,0x3
    80006236:	dea7a783          	lw	a5,-534(a5) # 8000901c <panicked>
    8000623a:	c391                	beqz	a5,8000623e <uartputc+0x2e>
    for(;;)
    8000623c:	a001                	j	8000623c <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000623e:	00003797          	auipc	a5,0x3
    80006242:	dea7b783          	ld	a5,-534(a5) # 80009028 <uart_tx_w>
    80006246:	00003717          	auipc	a4,0x3
    8000624a:	dda73703          	ld	a4,-550(a4) # 80009020 <uart_tx_r>
    8000624e:	02070713          	addi	a4,a4,32
    80006252:	02f71b63          	bne	a4,a5,80006288 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006256:	00040a17          	auipc	s4,0x40
    8000625a:	fb2a0a13          	addi	s4,s4,-78 # 80046208 <uart_tx_lock>
    8000625e:	00003497          	auipc	s1,0x3
    80006262:	dc248493          	addi	s1,s1,-574 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006266:	00003917          	auipc	s2,0x3
    8000626a:	dc290913          	addi	s2,s2,-574 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000626e:	85d2                	mv	a1,s4
    80006270:	8526                	mv	a0,s1
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	45c080e7          	jalr	1116(ra) # 800016ce <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000627a:	00093783          	ld	a5,0(s2)
    8000627e:	6098                	ld	a4,0(s1)
    80006280:	02070713          	addi	a4,a4,32
    80006284:	fef705e3          	beq	a4,a5,8000626e <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006288:	00040497          	auipc	s1,0x40
    8000628c:	f8048493          	addi	s1,s1,-128 # 80046208 <uart_tx_lock>
    80006290:	01f7f713          	andi	a4,a5,31
    80006294:	9726                	add	a4,a4,s1
    80006296:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000629a:	0785                	addi	a5,a5,1
    8000629c:	00003717          	auipc	a4,0x3
    800062a0:	d8f73623          	sd	a5,-628(a4) # 80009028 <uart_tx_w>
      uartstart();
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	ee2080e7          	jalr	-286(ra) # 80006186 <uartstart>
      release(&uart_tx_lock);
    800062ac:	8526                	mv	a0,s1
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	1d4080e7          	jalr	468(ra) # 80006482 <release>
}
    800062b6:	70a2                	ld	ra,40(sp)
    800062b8:	7402                	ld	s0,32(sp)
    800062ba:	64e2                	ld	s1,24(sp)
    800062bc:	6942                	ld	s2,16(sp)
    800062be:	69a2                	ld	s3,8(sp)
    800062c0:	6a02                	ld	s4,0(sp)
    800062c2:	6145                	addi	sp,sp,48
    800062c4:	8082                	ret

00000000800062c6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062c6:	1141                	addi	sp,sp,-16
    800062c8:	e422                	sd	s0,8(sp)
    800062ca:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062cc:	100007b7          	lui	a5,0x10000
    800062d0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062d4:	8b85                	andi	a5,a5,1
    800062d6:	cb91                	beqz	a5,800062ea <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062d8:	100007b7          	lui	a5,0x10000
    800062dc:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062e0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062e4:	6422                	ld	s0,8(sp)
    800062e6:	0141                	addi	sp,sp,16
    800062e8:	8082                	ret
    return -1;
    800062ea:	557d                	li	a0,-1
    800062ec:	bfe5                	j	800062e4 <uartgetc+0x1e>

00000000800062ee <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800062ee:	1101                	addi	sp,sp,-32
    800062f0:	ec06                	sd	ra,24(sp)
    800062f2:	e822                	sd	s0,16(sp)
    800062f4:	e426                	sd	s1,8(sp)
    800062f6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062f8:	54fd                	li	s1,-1
    int c = uartgetc();
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	fcc080e7          	jalr	-52(ra) # 800062c6 <uartgetc>
    if(c == -1)
    80006302:	00950763          	beq	a0,s1,80006310 <uartintr+0x22>
      break;
    consoleintr(c);
    80006306:	00000097          	auipc	ra,0x0
    8000630a:	892080e7          	jalr	-1902(ra) # 80005b98 <consoleintr>
  while(1){
    8000630e:	b7f5                	j	800062fa <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006310:	00040497          	auipc	s1,0x40
    80006314:	ef848493          	addi	s1,s1,-264 # 80046208 <uart_tx_lock>
    80006318:	8526                	mv	a0,s1
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	0b4080e7          	jalr	180(ra) # 800063ce <acquire>
  uartstart();
    80006322:	00000097          	auipc	ra,0x0
    80006326:	e64080e7          	jalr	-412(ra) # 80006186 <uartstart>
  release(&uart_tx_lock);
    8000632a:	8526                	mv	a0,s1
    8000632c:	00000097          	auipc	ra,0x0
    80006330:	156080e7          	jalr	342(ra) # 80006482 <release>
}
    80006334:	60e2                	ld	ra,24(sp)
    80006336:	6442                	ld	s0,16(sp)
    80006338:	64a2                	ld	s1,8(sp)
    8000633a:	6105                	addi	sp,sp,32
    8000633c:	8082                	ret

000000008000633e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000633e:	1141                	addi	sp,sp,-16
    80006340:	e422                	sd	s0,8(sp)
    80006342:	0800                	addi	s0,sp,16
  lk->name = name;
    80006344:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006346:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000634a:	00053823          	sd	zero,16(a0)
}
    8000634e:	6422                	ld	s0,8(sp)
    80006350:	0141                	addi	sp,sp,16
    80006352:	8082                	ret

0000000080006354 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006354:	411c                	lw	a5,0(a0)
    80006356:	e399                	bnez	a5,8000635c <holding+0x8>
    80006358:	4501                	li	a0,0
  return r;
}
    8000635a:	8082                	ret
{
    8000635c:	1101                	addi	sp,sp,-32
    8000635e:	ec06                	sd	ra,24(sp)
    80006360:	e822                	sd	s0,16(sp)
    80006362:	e426                	sd	s1,8(sp)
    80006364:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006366:	6904                	ld	s1,16(a0)
    80006368:	ffffb097          	auipc	ra,0xffffb
    8000636c:	c8e080e7          	jalr	-882(ra) # 80000ff6 <mycpu>
    80006370:	40a48533          	sub	a0,s1,a0
    80006374:	00153513          	seqz	a0,a0
}
    80006378:	60e2                	ld	ra,24(sp)
    8000637a:	6442                	ld	s0,16(sp)
    8000637c:	64a2                	ld	s1,8(sp)
    8000637e:	6105                	addi	sp,sp,32
    80006380:	8082                	ret

0000000080006382 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006382:	1101                	addi	sp,sp,-32
    80006384:	ec06                	sd	ra,24(sp)
    80006386:	e822                	sd	s0,16(sp)
    80006388:	e426                	sd	s1,8(sp)
    8000638a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000638c:	100024f3          	csrr	s1,sstatus
    80006390:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006394:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006396:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000639a:	ffffb097          	auipc	ra,0xffffb
    8000639e:	c5c080e7          	jalr	-932(ra) # 80000ff6 <mycpu>
    800063a2:	5d3c                	lw	a5,120(a0)
    800063a4:	cf89                	beqz	a5,800063be <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063a6:	ffffb097          	auipc	ra,0xffffb
    800063aa:	c50080e7          	jalr	-944(ra) # 80000ff6 <mycpu>
    800063ae:	5d3c                	lw	a5,120(a0)
    800063b0:	2785                	addiw	a5,a5,1
    800063b2:	dd3c                	sw	a5,120(a0)
}
    800063b4:	60e2                	ld	ra,24(sp)
    800063b6:	6442                	ld	s0,16(sp)
    800063b8:	64a2                	ld	s1,8(sp)
    800063ba:	6105                	addi	sp,sp,32
    800063bc:	8082                	ret
    mycpu()->intena = old;
    800063be:	ffffb097          	auipc	ra,0xffffb
    800063c2:	c38080e7          	jalr	-968(ra) # 80000ff6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063c6:	8085                	srli	s1,s1,0x1
    800063c8:	8885                	andi	s1,s1,1
    800063ca:	dd64                	sw	s1,124(a0)
    800063cc:	bfe9                	j	800063a6 <push_off+0x24>

00000000800063ce <acquire>:
{
    800063ce:	1101                	addi	sp,sp,-32
    800063d0:	ec06                	sd	ra,24(sp)
    800063d2:	e822                	sd	s0,16(sp)
    800063d4:	e426                	sd	s1,8(sp)
    800063d6:	1000                	addi	s0,sp,32
    800063d8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063da:	00000097          	auipc	ra,0x0
    800063de:	fa8080e7          	jalr	-88(ra) # 80006382 <push_off>
  if(holding(lk))
    800063e2:	8526                	mv	a0,s1
    800063e4:	00000097          	auipc	ra,0x0
    800063e8:	f70080e7          	jalr	-144(ra) # 80006354 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ec:	4705                	li	a4,1
  if(holding(lk))
    800063ee:	e115                	bnez	a0,80006412 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063f0:	87ba                	mv	a5,a4
    800063f2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063f6:	2781                	sext.w	a5,a5
    800063f8:	ffe5                	bnez	a5,800063f0 <acquire+0x22>
  __sync_synchronize();
    800063fa:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063fe:	ffffb097          	auipc	ra,0xffffb
    80006402:	bf8080e7          	jalr	-1032(ra) # 80000ff6 <mycpu>
    80006406:	e888                	sd	a0,16(s1)
}
    80006408:	60e2                	ld	ra,24(sp)
    8000640a:	6442                	ld	s0,16(sp)
    8000640c:	64a2                	ld	s1,8(sp)
    8000640e:	6105                	addi	sp,sp,32
    80006410:	8082                	ret
    panic("acquire");
    80006412:	00002517          	auipc	a0,0x2
    80006416:	46e50513          	addi	a0,a0,1134 # 80008880 <digits+0x20>
    8000641a:	00000097          	auipc	ra,0x0
    8000641e:	9fe080e7          	jalr	-1538(ra) # 80005e18 <panic>

0000000080006422 <pop_off>:

void
pop_off(void)
{
    80006422:	1141                	addi	sp,sp,-16
    80006424:	e406                	sd	ra,8(sp)
    80006426:	e022                	sd	s0,0(sp)
    80006428:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000642a:	ffffb097          	auipc	ra,0xffffb
    8000642e:	bcc080e7          	jalr	-1076(ra) # 80000ff6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006432:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006436:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006438:	e78d                	bnez	a5,80006462 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000643a:	5d3c                	lw	a5,120(a0)
    8000643c:	02f05b63          	blez	a5,80006472 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006440:	37fd                	addiw	a5,a5,-1
    80006442:	0007871b          	sext.w	a4,a5
    80006446:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006448:	eb09                	bnez	a4,8000645a <pop_off+0x38>
    8000644a:	5d7c                	lw	a5,124(a0)
    8000644c:	c799                	beqz	a5,8000645a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000644e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006452:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006456:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000645a:	60a2                	ld	ra,8(sp)
    8000645c:	6402                	ld	s0,0(sp)
    8000645e:	0141                	addi	sp,sp,16
    80006460:	8082                	ret
    panic("pop_off - interruptible");
    80006462:	00002517          	auipc	a0,0x2
    80006466:	42650513          	addi	a0,a0,1062 # 80008888 <digits+0x28>
    8000646a:	00000097          	auipc	ra,0x0
    8000646e:	9ae080e7          	jalr	-1618(ra) # 80005e18 <panic>
    panic("pop_off");
    80006472:	00002517          	auipc	a0,0x2
    80006476:	42e50513          	addi	a0,a0,1070 # 800088a0 <digits+0x40>
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	99e080e7          	jalr	-1634(ra) # 80005e18 <panic>

0000000080006482 <release>:
{
    80006482:	1101                	addi	sp,sp,-32
    80006484:	ec06                	sd	ra,24(sp)
    80006486:	e822                	sd	s0,16(sp)
    80006488:	e426                	sd	s1,8(sp)
    8000648a:	1000                	addi	s0,sp,32
    8000648c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000648e:	00000097          	auipc	ra,0x0
    80006492:	ec6080e7          	jalr	-314(ra) # 80006354 <holding>
    80006496:	c115                	beqz	a0,800064ba <release+0x38>
  lk->cpu = 0;
    80006498:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000649c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064a0:	0f50000f          	fence	iorw,ow
    800064a4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064a8:	00000097          	auipc	ra,0x0
    800064ac:	f7a080e7          	jalr	-134(ra) # 80006422 <pop_off>
}
    800064b0:	60e2                	ld	ra,24(sp)
    800064b2:	6442                	ld	s0,16(sp)
    800064b4:	64a2                	ld	s1,8(sp)
    800064b6:	6105                	addi	sp,sp,32
    800064b8:	8082                	ret
    panic("release");
    800064ba:	00002517          	auipc	a0,0x2
    800064be:	3ee50513          	addi	a0,a0,1006 # 800088a8 <digits+0x48>
    800064c2:	00000097          	auipc	ra,0x0
    800064c6:	956080e7          	jalr	-1706(ra) # 80005e18 <panic>
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
