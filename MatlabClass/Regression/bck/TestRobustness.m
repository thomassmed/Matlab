%% Import data
filename='../KKM_kregr.xls';
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
ett=ones(size(w));
%% 
A1=[ett q];
P1=A1\kef
%% 
A2=[ett w];
P2=A2\(kef-A1*P1)
%% 1st order
Ptot=[P1(1)+P2(1) P1(2) P2(2)]'
%% 2nd order
A22=[A2 w.^2];
P22=A22\(kef-A1*P1)
P2tot=[P1(1)+P22(1) P1(2) P22(2) P22(3)]'
%% 3rd order
A23=[A22 w.^3];
P23=A23\(kef-A1*P1)
P3tot=[P1(1)+P23(1);P1(2);P23(2:4)]
%% Now plot this with surf
[qq,ww]=meshgrid(.1:.1:1.1,.1:.1:1.1);
[nr,nc]=size(qq);
Ett=ones(numel(ww),1);
AA=[Ett qq(:) ww(:) ww(:).^2 ww(:).^3];
keffest3=AA*P3tot;
Keffest3=reshape(keffest3,nr,nc);
surf(qq,ww,Keffest3)
xlabel('Power')
ylabel('Flow')
%% Now plot this with surf 2nd order
AA2=[Ett qq(:) ww(:) ww(:).^2];
keffest2=AA2*P2tot;
Keffest2=reshape(keffest2,nr,nc);
surf(qq,ww,Keffest2)
xlabel('Power')
ylabel('Flow')
%% Now plot this with surf 1st order
AA1=[Ett qq(:) ww(:)];
keffest1=AA1*Ptot;
Keffest1=reshape(keffest1,nr,nc);
surf(qq,ww,Keffest1)
xlabel('Power')
ylabel('Flow')
%% And with the simpler one
p=[1
   0.006426572199720
   0.004413037157153];
keffests=AA1*p;
Keffests=reshape(keffests,nr,nc);
surf(qq,ww,Keffests)
xlabel('Power')
ylabel('Flow')