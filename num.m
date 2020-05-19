function n=num(b,nbits)
% b = vector of length nbits with entries equal to 0 or 1
% n = integer equivalent of the binary number with bits b(1)...b(nbits)
powers=nbits-(1:nbits);
n=sum(b.*(2.^powers));
