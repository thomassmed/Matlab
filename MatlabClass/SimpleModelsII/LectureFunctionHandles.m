%% Define a function handle
fcn=@min;
%% And define a little guinea pig matrix
A=[1 2 3;4 5 6;7 8 9];
%%
fcn(A)
%%
fcn=@max;
%%
fcn(A)
%% 
fcn=@mean;
%%
fcn(A)
%% 
help funfun
%%
integral(@sin,0,pi/2)
%% Play with humps a little
h=@humps;
x=0:.01:2;
y=h(x);
figure
plot(x,y)
grid
figure(gcf)
%%
xz=fzero(h,1)
%%
xmin=fminbnd(h,0.2,1)
%% You can define it as an anonymous function
hh=@(x) 1 ./ ((x-.3).^2 + .01) + 1 ./ ((x-.8).^2 + .04) - 4;
%% Task: plot hh and figure out zero crossings and min
% Then you are ready for Exercise10, task 3

