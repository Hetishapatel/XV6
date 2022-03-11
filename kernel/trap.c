#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct spinlock tickslock;
uint ticks;
int cowpagefaulthandler(pagetable_t pagetable, uint64 va);
extern char trampoline[], uservec[], userret[];
extern pte_t * walk(pagetable_t pagetable, uint64 va, int alloc);
//extern uint refcount[(PHYSTOP-KERNBASE)/PGSIZE]; 
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();
extern uint getrefcount(uint64 pa);
void
trapinit(void)
{
  initlock(&tickslock, "time");
}

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
  w_stvec((uint64)kernelvec);
}

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
//**************************************
// handles the cow page fault
// scause = 15 for store or accessing pagefault
// call pagefaulthandler
//**************************************
void
usertrap(void)
{
  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
  
  if(r_scause() == 8){
    // system call

    if(p->killed)
      exit(-1);

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;

    // an interrupt will change sstatus &c registers,
    // so don't enable until done with those registers.
    intr_on();

    syscall();
  } else if((which_dev = devintr()) != 0){
    // ok
  } 
  //else {
    // modify this*****************************
    
   else if(r_scause()==15)
    {
      printf("cow_pagefault\n"); 
      uint64 va = r_stval();
      if((cowpagefaulthandler(p->pagetable,va))<0)
     {
       p->killed=1; 
      }
    }

else 
    {
       
      printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
      printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
      p->killed = 1;
    }
if(p->killed)
  exit(-1);

  // give up the CPU if this is a timer interrupt.
if(which_dev == 2)
    yield();

  usertrapret();
}

//**************************************
// cowpagefaulthandler
// rounddown the va 
// get pte
// extract physical address
// check if the page is cow page
// if refcount is greater than 1
// if it is allocate memory using kalloc
// update the permissions set PTE_W and clear PTE_COW
// copy the page refered by faulting va to the new allocated page
// map the new page 
// accomodate for error
// else 
// just update the permission
//**************************************
int
cowpagefaulthandler(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;
  uint flags;
  va= PGROUNDDOWN(va);  // starting of pagetable
  if(va>=MAXVA)
  {
    return -1;
  }
  if((pte = walk(pagetable,va,0))==0)
  {
     panic("usertrap: pte should exist");
  }
  pa=PTE2PA(*pte);
  flags = PTE_FLAGS(*pte);
  if(flags & PTE_COW)
  {
    printf("%d\n",getrefcount(pa));
    if(getrefcount(pa)>1)
    {
    char *mem = kalloc();
    if(mem==0) return -1;
    memmove(mem,(char*)pa, PGSIZE);
    
    kfree((void*)pa);
    flags =(flags & ~PTE_COW) | PTE_W;
    //flags = flags & ~PTE_V;
    *pte = PA2PTE((uint64)mem) | flags;
  //    if(mappages(pagetable, va, PGSIZE, (uint64) mem, flags) != 0)
  //  {
    
  //   kfree(mem);
  //   return -1;
  //   }   
   }
    else if(getrefcount(pa)==1)
    {
      *pte &= (~PTE_COW);
      *pte |= PTE_W;
    }     
  }  
 
  return 0;
}

//
// return to user space
//
void
usertrapret(void)
{
  struct proc *p = myproc();

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
  x |= SSTATUS_SPIE; // enable interrupts in user mode
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
  int which_dev = 0;
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  uint64 scause = r_scause();
  
  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devintr()) == 0){
    printf("scause %p\n", scause);
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    panic("kerneltrap");
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    yield();

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void
clockintr()
{
  acquire(&tickslock);
  ticks++;
  wakeup(&ticks);
  release(&tickslock);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
     (scause & 0xff) == 9){
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();

    if(irq == UART0_IRQ){
      uartintr();
    } else if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq){
      printf("unexpected interrupt irq=%d\n", irq);
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    // software interrupt from a machine-mode timer interrupt,
    // forwarded by timervec in kernelvec.S.

    if(cpuid() == 0){
      clockintr();
    }
    
    // acknowledge the software interrupt by clearing
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
  }
}

