%% Define a variable
x=3
%% Check your workspace
who
%% with more info
whos
%%
y=sin(x)
z=x*y
%% define a vector
t=[1 2 3 4 5]
whos
%% functions operate on vectors
y=sin(t)
whos
%%
plot(t,y)
%% Equally spaced vectors can be entered with by using colon 
t=1:5
%% If other than default(=1) is wanted:
%t=1:.01:5
t=1:0.01:5; %Suppress output with;
whos
%% Now reassign y:
y=sin(t);
whos
%% And plot
plot(t,y)
shg
%% Calculate z
z=y+t;
%% And plot on the same
hold on
plot(t,z,'r')
shg

%% Most functions accepts vectors (and complex variables) as input:
hold off
lam=-0.2+2i*pi
plot(t,exp(lam*t))
shg
%% 
t(1:5)
t(391:end)
%% 
t(end-10:end)
%% Matrices
A=[1 2 3
4 5 6
7 8 9]
%% Some indexing details
A=[1 2 3;4 5 6;7 8 9]
A(3,:)
%% Kommit hit!
A(3,:)=0
A=[1 2 3;4 5 6;7 8 9]
A(2:3,2:3)
A
%% Also Matrices can be indexed with a single index 
A(6)
A(8)
%% Logical indexing
A>4
find(A>4)
A
A(find(A>4))=0
%%
save myfile
%%
clear
%%
load myfile
%% 
save myfile A t
%%
clear
%%
load myfile
%% Character Arrays
myName='Thomas Smed';
Kenneth='Kenneth Lek';
%% 
We=[myName;Kenneth]
%%
We(2,:)
%%
We(:,1)
%%
We(:,end)
%%
Sara='Sara Lundgren';
%%
We3=[We;Sara]
%% Save to file
save myfile