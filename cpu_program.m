%cpu_program.m
%mem is the central memory, 
%an array of bits with 2^13 rows and 16 columns.
%Conceptually, the rows of mem are numbered 0...((2^13)-1),
%but we have to add 1 in matlab.  This will be written "1+addr".

%When a row of mem is an instruction,
%the first three bits are the operation code,
%and the last 13 bits are the associated address,
%that is, the address on which the instruction operates
%by reading or writing there.

reg=zeros(1,16); pc=1; %initialize register and program counter
while pc > 0           %setting pc to zero will stop the program
  ins= num(mem(1+pc,1:3),3);   %read instruction code
  addr=num(mem(1+pc,4:16),13);  %read address
  pc=mod(pc+1,2^13); %increment program counter to prepare for next step
  switch ins %execute instruction specified by ins
    case 0  %LOAD
      reg=mem(1+addr,:);  %copy mem line addr into register
    case 1  %STORE
      mem(1+addr,:)=reg;  %copy register into mem line addr
    case 2  %ADD mod 2^16
      s1=num(reg,16); %convert bits in register to integer 
      s2=num(mem(1+addr,:),16); %convert bits in mem line addr to integer
      reg=bin(s1+s2,16); %add and store resulting bits in register
    case 3  %BRANCH on NONZERO REG
      if(any(reg)) %if any bit of register is nonzero,
        pc=addr; %set program counter to addr for next step
      end
    %In the following, all results are stored in register;
    %memory is read, but not changed:
    case 4 %AND
      reg = reg & mem(1+addr,:); %bitwise AND of reg with mem line addr
    case 5 %OR
      reg = reg | mem(1+addr,:); %bitwise OR of reg with mem line addr
    case 6 %XOR
      %bitwise exclusive OR of reg with mem line addr:
      reg = xor(reg,mem(1+addr,:));
    case 7 %NOT
      reg = ~reg; %bitwise NOT of register (addr is ignored)
    case 8 %SUB
      s1=num(reg,16); %convert bits in register to integer 
      s2=num(mem(1+addr,:),16); %convert bits in mem line addr to integer
      reg=bin(s1-s2,16); %subtract and store resulting bits in register    
  end
end
