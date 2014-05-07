%% MATLAB Functions
[x,t] = whalecall_fun(4,165,1,0.8,1);
%%
x = whalecall_fun(4,165,1,0.7,1.5);
%%
[~,t] = whalecall_fun(5,220,1,0.8,.7);

%% Workspaces
a = 42;
%% Set breakpoint on line 9 of foo.m
b = foo(a);

%% Precedence
which pi -all
%%
pi = 2;
which pi -all
%%
sin = pi;
sin(1);
%%
i = 1:5;
z = 1+2*i;
abs(z)
clear i
z = 1+2*i;
abs(z)

%% MATLAB Path
pathtool
%%
which max -all