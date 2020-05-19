%set up and run machine language program to compute
%   P = A * B

mem=zeros(2^13,16);

%instruction codes:
%creates a vector of 3 binary numbers each
LOAD  = bin(0,3);
STORE = bin(1,3);
ADD   = bin(2,3);
BNZ   = bin(3,3);
AND   = bin(4,3);
OR    = bin(5,3);
XOR   = bin(6,3);
NOT   = bin(7,3);
SUB   = bin(8,3);


%Line numbers in mem at which constants and variables will be stored:
%Note that these are the *line numbers*, not the values.
%Values will be assigned later.
%Line numbers chosen big enough to be out of the way.
%pick values for the constants' addresses that are large enough so that 
%they aren't conflicting with the other memory for the program
DECR = 101;

D = 102; %used to be A, desired number
O = 103; %used to be B, operand
R = 104; %used to be P, result
X = 105; %used for multiplying and dividing
%Names for some line numbers in the program:
ZERO = 0;   %ZERO is both a line number and a constant (see below)
BACK = 3;
CONT = 7;

disp('use operators ADD, AND, OR, XOR, NOT with any operand <= 2^16 - 1')
disp('in order to get to the desired number from the starting number')


desired_Number = randi(65535)
starting_Number = floor(desired_Number * rand() / 10)
result = starting_Number;
%Write the program:
while (result ~= desired_Number)
    OPERATOR=input('operator=', 's');
    if (strcmp(OPERATOR, "MUL"))
        mem(1+ZERO,:)=zeros(1,16);         %branch here to stop 
        mem(1+1,:)=[LOAD,bin(ZERO,13)];    %program starts here
        mem(1+2,:)=[STORE,bin(R,13)];      %initialize R
        mem(1+BACK,:)=[LOAD,bin(O,13)];    %put C in register
        mem(1+4,:)=[BNZ,bin(CONT,13)];     %if C is not zero, goto CONT
        mem(1+5,:)=[LOAD,bin(DECR,13)];    %put something nonzero in register 
        mem(1+6,:)=[BNZ,bin(ZERO,13)];     %stop (since C is now zero)
        mem(1+CONT,:)=[ADD,bin(DECR,13)];  %decrement C by 1
        mem(1+8,:)=[STORE,bin(O,13)];
        mem(1+9,:)=[LOAD,bin(R,13)];
        mem(1+10,:)=[ADD,bin(X,13)];       %add O to R 
        mem(1+11,:)=[STORE,bin(R,13)];
        mem(1+12,:)=[LOAD,bin(DECR,13)];   %put something nonzero in register
        mem(1+13,:)=[BNZ,bin(BACK,13)];    %goto BACK
    elseif (strcmp(OPERATOR, "DIV"))
        mem(1+ZERO,:)=zeros(1,16);         %branch here to stop 
        mem(1+1,:)=[LOAD,bin(ZERO,13)];    %program starts here
        mem(1+2,:)=[STORE,bin(R,13)];      %initialize R
        mem(1+BACK,:)=[LOAD,bin(O,13)];    %put C in register
        mem(1+4,:)=[BNZ,bin(CONT,13)];     %if C is not zero, goto CONT
        mem(1+5,:)=[LOAD,bin(DECR,13)];    %put something nonzero in register 
        mem(1+6,:)=[BNZ,bin(ZERO,13)];     %stop (since C is now zero)
        mem(1+CONT,:)=[ADD,bin(DECR,13)];  %decrement C by 1
        mem(1+8,:)=[STORE,bin(O,13)];
        mem(1+9,:)=[LOAD,bin(R,13)];
        mem(1+10,:)=[SUB,bin(X,13)];       %sub O from R 
        mem(1+11,:)=[STORE,bin(R,13)];
        mem(1+12,:)=[LOAD,bin(DECR,13)];   %put something nonzero in register
        mem(1+13,:)=[BNZ,bin(BACK,13)];    %goto BACK
    else
        mem(1+1,:)=[LOAD,bin(R,13)];
        mem(1+2,:)=[OPERATOR,bin(O,13)];       %operator using O onto R
        mem(1+3,:)=[STORE,bin(R,13)];
    end
    
    %Assign values to the constant for DECR
    mem(1+DECR,:)=ones(1,16);
    %ZERO is both a line number and a constant.
    %The value 0 was already assigned when the program was written.
    
    %Assign values to the variables
    operand=input('operand=');
    %mem(1+D,:)=bin(desired_Number,16);
    mem(1+O,:)=bin(operand,16);
    mem(1+R,:)=bin(result,16);
    mem(1+X,:)=bin(result,16);
    switch OPERATOR
        case 'ADD'
            OPERATOR = ADD;
        case 'AND'
            OPERATOR = AND;
        case 'OR'
            OPERATOR = OR;
        case 'XOR'
            OPERATOR = XOR;
        case 'NOT'
            OPERATOR = NOT;
        case 'SUB'
            OPERATOR = SUB;
    end
    
    %run the program:
    cpu_program
    %output the result:
    result = num(mem(1+R,:),16)
end

disp('good job, your result matches the desired number')


