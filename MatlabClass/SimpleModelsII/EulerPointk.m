%% Parameters
al=log(2)/8;
beta=0.00600;
L=1.6825e-05;
% beta = [2.030000e-04;1.273000e-03;1.115400e-03;2.487000e-03;9.130000e-04;2.210000e-04];
% al =  [1.277900e-02;3.165000e-02;1.217490e-01;3.228930e-01;1.404693e+00;3.881428e+00];

%% Initialize
if length(beta)==6,
    use_pointkin=1;
else
    use_pointkin=0;
end
if use_pointkin
    y0=[1;beta./al]; % for pointkin (OBS, annan skalning map L!)
else
    y0=[1;beta/L/al]; % for pointk
end
%% Euler forward:
tic
if use_pointkin
    fpoint=@pointkin;
else
    fpoint=@pointk;
end
dt=0.0001; % Change here;
t=0:dt:60;
N=length(t);
y=nan(length(y0),N);
y(:,1)=y0;
for i=2:N
    y(:,i)=y(:,i-1)+dt*fpoint(t(i),y(:,i-1));
end
toc
%%
plot(t,y(1,:));shg
