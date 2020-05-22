%set up and run machine language program to compute
%   P = A * B

mem=zeros(2^13,16);

%instruction codes:
%3 bit long instruction codes
LOAD  = bin(0,3);
STORE = bin(1,3);
ADD   = bin(2,3);
BNZ   = bin(3,3);
AND   = bin(4,3);
OR    = bin(5,3);
XOR   = bin(6,3);


%Line numbers in mem at which constants and variables will be stored:
%Note that these are the *line numbers*, not the values.
%Values will be assigned later.
%Line numbers chosen big enough to be out of the way.
%pick values for the constants' addresses that are large enough so that 
%they aren't conflicting with the other memory for the program
DECR = 101;

O = 102; %operand
R = 103; %result
X = 104; %used for multiplying
Y = 105; %used for multiple additions

%Names for some line numbers in the program:
ZERO = 0;   %ZERO is both a line number and a constant (see below)
BACK = 3;
CONT = 7;

disp('use operators ADD (multiple times), AND, OR, XOR with any operand <= 2^16 - 1')
disp('in order to get to the desired number from the starting number')


desired_Number = randi(65535)
starting_Number = floor(desired_Number * rand() / 10)
%desired_Number = 63
%starting_Number = 31
result = starting_Number;
mem(1+R,:)=bin(result,16); %write result to its memory line
%Write the program:
while (result ~= desired_Number)
    OPERATOR=input('operator=', 's');
    %change the desired OPERATOR instruction based on user input
    switch OPERATOR
        case 'ADD'
            OPERATOR = ADD;
        case 'AND'
            OPERATOR = AND;
        case 'OR'
            OPERATOR = OR;
        case 'XOR'
            OPERATOR = XOR;
    end
    %original multiplication code
    if (strcmp(OPERATOR, "MUL"))
        mem(1+ZERO,:)=zeros(1,16);         %stopping point
        mem(1+BACK,:)=[LOAD,bin(O,13)];    %put O in register
        mem(1+4,:)=[BNZ,bin(CONT,13)];     %if O is not zero, goto CONT
        mem(1+5,:)=[LOAD,bin(DECR,13)];    %put something nonzero in register 
        mem(1+6,:)=[BNZ,bin(ZERO,13)];     %stop (since O is now zero)
        mem(1+CONT,:)=[ADD,bin(DECR,13)];  %decrement O by 1
        mem(1+8,:)=[STORE,bin(O,13)];
        mem(1+9,:)=[LOAD,bin(R,13)];
        mem(1+10,:)=[ADD,bin(X,13)];       %add X (original result) to R 
        mem(1+11,:)=[STORE,bin(R,13)];
        mem(1+12,:)=[LOAD,bin(DECR,13)];   %put something nonzero in register
        mem(1+13,:)=[BNZ,bin(BACK,13)];    %goto BACK
    else
        mem(1+ZERO,:)=zeros(1,16);         %branch here to stop 
        mem(1+BACK,:)=[LOAD,bin(Y,13)];    %Y is only used by ADD, otherwise it's zero
        mem(1+4,:)=[BNZ,bin(CONT,13)];     %if Y is not zero, goto CONT
        mem(1+5,:)=[LOAD,bin(DECR,13)];    %put something nonzero in register 
        mem(1+6,:)=[BNZ,bin(ZERO,13)];     %stop (since Y is now zero)
        mem(1+CONT,:)=[ADD,bin(DECR,13)];  %decrement Y by 1
        mem(1+8,:)=[STORE,bin(Y,13)];
        mem(1+9,:)=[LOAD,bin(R,13)];
        mem(1+10,:)=[OPERATOR,bin(O,13)];  %R operated by O
        mem(1+11,:)=[STORE,bin(R,13)];
        mem(1+12,:)=[LOAD,bin(DECR,13)];   %put something nonzero in register
        mem(1+13,:)=[BNZ,bin(BACK,13)];    %goto BACK
    end
    
    %Assign values to the constant for DECR
    mem(1+DECR,:)=ones(1,16);
    %ZERO is both a line number and a constant.
    %The value 0 was already assigned when the program was written.

    %Assign values to the variables
    operand=input('operand=');
    addMultipleTimes = 1;
    %functionality for repeated additions
    if (OPERATOR == ADD)
        addMultipleTimes=input('Add this operand this amount of times=');
    end
    %the addition in multiplication occurs one too many times
    if (strcmp(OPERATOR, "MUL"))
        operand = operand - 1;
    end
    mem(1+R,:)=bin(result,16);
    %a simple copy of result
    mem(1+X,:)=bin(result,16);
    mem(1+O,:)=bin(operand,16);
    mem(1+Y,:)=bin(addMultipleTimes,16);
    
    %run the program:
    cpu_program
    %output the result:
    result = num(mem(1+R,:),16)
end

disp('good job, your result matches the desired number')


