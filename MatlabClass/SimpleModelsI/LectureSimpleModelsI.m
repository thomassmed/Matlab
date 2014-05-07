%% Define a matrix
A=[1    3
   4   2]/4
%% Define the unity vector along the x-axis, or e1
e1=[1;0]
%% What happens when we multiply with e1?
A*e1
%% Define the unity vector along the y-axis, or e2
e2=[0;1]
%% And with e2?
A*e2
%% How to solve Ax=b?
b=[1;1]
x=A\b
%% Check it out:
A*x 
%% This is the same as
inv(A)*b
% This is just for learning. NEVER use inv in a serious application! Use \ or lu-decomposition
%% lu:
[l,u]=lu(A)
%% And solve
u\(l\b)
%% Now turn to eigenvalues
eig(A)
%%
[v,d]=eig(A)
%%
A*v(:,1)
%% Compare with
-0.5*v(:,1)
%% So what do you think about:
A*v(:,2)
%% Now consider
A*v
%% and
v*d
%% run eigsvddemo
%% Present MassSpring.pptx
%% ExSimpleModelsI
%% Present inverse iteration with shift
%% ExInverseIter



