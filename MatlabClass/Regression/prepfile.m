%% Import data
filename='KKM_kregr.xls';
[num,txt]=xlsread(filename);
%% Put the data into variables
t=datenum(txt(3:end,2))+num(:,3);
keff=num(:,7);
Q=num(:,5);
W=num(:,6);
E=num(:,4);
Case=num(:,1);
%% Check the operating history
plot(t,Q)
datetick
figure(gcf)
%% check the keff over the cycle
plot(E,1e5*(keff-1))
figure(gcf)
%% Zoom in a bit
axis([0 6000 200 600])
figure(gcf)
%% prepare variables for ls-fit
i0=352;
i1=381;
w=W(i0:i1)/100;
q=Q(i0:i1)/100;
kef=keff(i0:i1);
%% 
plot(100*q,1e5*(kef-1),'x')
xlabel('Relative Power (%)');
ylabel('k_e_f_f-1 (pcm)')
figure(gcf)
%%
plot(100*w,1e5*(kef-1),'x')
xlabel('Relative Flow (%)');
ylabel('k_e_f_f-1 (pcm)')
figure(gcf)
%% 1st order in flow
ett=ones(size(q));
A1=[ett q w];
p1=A1\keff(i0:i1)
%% Plot and compare
figure
plot(t(i0:i1),keff(i0:i1))
datetick
hold on
keff1=A1*p1;
plot(t(i0:i1),keff1,'m')
figure(gcf)
[u1,s1,v1]=svd(A1,0);
diag(s1)
%% Second order in flow
A2=[ett q w w.*w];
p2=A2\keff(i0:i1)
keff2=A2*p2;
plot(t(i0:i1),keff2,'g')
figure(gcf)
[u2,s2,v2]=svd(A2);
diag(s2)
%% Make ls-fit, 3 order i w
A3=[ett q w w.*w w.^3];
%%
p3=A3\keff(i0:i1)
keff3=A3*p3;
hold off
plot(t(i0:i1),keff(i0:i1));
hold on
plot(t(i0:i1),keff3,'r');
datetick
grid
figure(gcf)
[u3,s3,v3]=svd(A3);
diag(s3)
%% Plot residuals