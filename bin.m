function b=bin(n,nbits)
%n is a non-negative integer
%b = vector of length nbits with entries 0 or 1 such that 
%b is the binary representation of the n mod 2^nbits

%This is a recursive program -- it calls itself!

if nbits==1
  b=mod(n,2);
else
  nn=floor(n/2);
  b=[bin(nn,nbits-1),n-2*nn];
end
