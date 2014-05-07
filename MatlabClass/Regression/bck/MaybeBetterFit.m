%% Check the keff
plot(t,keff)
datetick
ylim([.998 1.006])
figure(gcf)
%% Check keff more carefully:
plot(E,1e5*(keff-1))
ylim([0 600])
figure(gcf)
%%
isel=E>300;
e=(E(isel)-3000)/10000;
ett=ones(size(e));
q=(Q(isel)-100)/100;
w=(W(isel)-95)/100;
A=[ett e e.^2 q w];
[u,s,v]=svd(A,0);
s,v
pe=A\keff(isel)
%% Now try to single out flow, first a crude 
figure
plot(W(isel),keff(isel),'x')
figure(gcf)
%% 
plot(E,W)
%% Select a few intervals:
I1=(239:349)';
w1=W(I1)-95;
p1=[ones(size(I1)) w1]\keff(I1);
p1(2)*1e5
% 9.61 pcm/%flow
%% Interval 2
I2=(1000:1506)';
w2=W(I2)-95;
p2=[ones(size(I2)) w2]\keff(I2);
p2(2)*1e5
% 7.46 pcm/%flow
%% Interval 3
I3=(1600:2040)';
w3=W(I3)-95;
p3=[ones(size(I3)) w3]\keff(I3);
p3(2)*1e5
% 8.07 pcm/%flow
%% Interval 2
I22=(1116:1506)';
w22=W(I22)-95;
p22=[ones(size(I22)) w22]\keff(I22);
p22(2)*1e5
% 10.13 pcm/%flow
%% Redo and take the variation of exposure into account
ee=(E-3000)/1000;
%% First check that we do not screw up:
Aee=[ones(size(ee)) ee ee.^2];
hold off
plot(E,keff)
hold on
plot(E,Aee*pe(1:3),'r')
ylim([0.99600 1.00600])
figure(gcf)
%% hmm, we may want to sharpen this first
isel=E>400&abs(Q-100)<5&abs(W-95)<3;
esel=ee(isel);
pee=[ones(size(esel)) esel esel.^2]\keff(isel)
%% Any better?
hold off
plot(E,keff)
hold on
plot(E,Aee*pe(1:3),'r')
plot(E,Aee*pee,'g')
ylim([0.99600 1.00600])
%% maybe, let's move on and reiterate on Interval1 thru 3:
p11=[ones(size(I1)) w1]\(keff(I1)-[ones(size(I1)) ee(I1) ee(I1).^2]*pee);
p11(2)*1e5
%%
p21=[ones(size(I2)) w2]\(keff(I2)-[ones(size(I2)) ee(I2) ee(I2).^2]*pee);
p21(2)*1e5
%%
p31=[ones(size(I3)) w3]\(keff(I3)-[ones(size(I3)) ee(I3) ee(I3).^2]*pee);
p31(2)*1e5
%% OK, we give up for a bit, Let's try a transient and look on the variation
i0=352;
i1=381;
w=(W(i0:i1)-95)/100;
q=(Q(i0:i1)-100)/100;
kef0=1.004134;
pqw=[q w]\(keff(i0:i1)-kef0)
[u,s,v]=svd([q w]);
%% Now, this I trust, Let's do a few things
isel1=E>400;
esel1=ee(isel1);
Ae1=[ones(size(esel1)) esel1 esel1.^2];
rhs=keff(isel1)-pqw(1)*(Q(isel1)-100)/100-pqw(2)*(W(isel1)-95)/100;
pe1=Ae1\rhs
%% 
PE=[pe1;pqw];
Aetot=[Ae1 (Q(isel1)-100)/100 (W(isel1)-95)/100];
figure
plot(esel1,keff(isel1))
hold
plot(esel1,Aetot*PE,'r')
%% Now, when all is said and done, all we'll use is
fprintf('Power dependence is %5.1f pcm/perc Power\nFlow dependence is  %5.1f pcm/perc Flow\n',PE(4)*1e3,PE(5)*1e3)
%% Compare with global result with (allmost) all data points included
fprintf('For the fit for allmost all data points, \n');
fprintf('Power dependence is %5.1f pcm/perc Power\nFlow dependence is  %5.1f pcm/perc Flow\n',pe(4)*1e3,pe(5)*1e3)
