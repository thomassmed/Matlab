%% The Command History
fs = 4000;
f0 = 175;
t = 0:1/fs:1.5;
y1 = sin(2*pi*f0*t);
y2 = sin(2*pi*2*f0*t);
y3 = sin(2*pi*3*f0*t);
y0 = y1+y2+y3;
A = (2*exp(-1.5*t)).*sin(2*pi*0.65*t);
call = A.*y0;
soundsc(call,fs)
plot(t,call)

%% Logical Operations
x = pi > 3
x = pi == 3
x = (pi > 3) & (pi < 4)

%
load gasprices.mat
HighMex = Mexico > 2.2;
any(HighMex)
%
find(HighMex)
find(Mexico > 2.2)
sum(HighMex)
nnz(HighMex)
%
x = [42,pi,0,7];
y = [true,false,false,true];
x(y)