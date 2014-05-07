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
hold on
%% prepare variables for ls-fit
i0=352;
i1=381;
w=W(i0:i1)/100;
q=Q(i0:i1)/100;
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
[u1,s1,v1]=svd(A1);
diag(s1)
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
%% Second order in flow
A2=[ett q w w.*w];
p2=A2\keff(i0:i1)
keff2=A2*p2
plot(t(i0:i1),keff2,'g')
figure(gcf)
[u2,s2,v2]=svd(A2);
diag(s2)
%% Plot residuals
figure
plot(t(i0:i1),keff3-keff(i0:i1),'r');
hold on
plot(t(i0:i1),keff2-keff(i0:i1),'g');
plot(t(i0:i1),keff1-keff(i0:i1),'m');
grid
figure(gcf)
datetick
fprintf(1,'Std dev 3:rd order: %4i pcm\n',round(std(keff3-keff(i0:i1))*1e5))
fprintf(1,'Std dev 2:nd order: %4i pcm\n',round(std(keff2-keff(i0:i1))*1e5))
fprintf(1,'Std dev 1:st order: %4i pcm\n',round(std(keff1-keff(i0:i1))*1e5))
%% New point
i00=543;
i10=555;
w0=(W(i00:i10)-W(i0))/100;
q0=(Q(i00:i10)-Q(i0))/100;
keff10=[q0 w0]*p1+keff(i00)-[q0(1) w0(1)]*p1;
keff20=[q0 w0 w0.^2]*p2+keff(i00)-[q0(1) w0(1) w0(1).^2]*p2;
keff30=[q0 w0 w0.^2 w0.^3]*p3+keff(i00)-[q0(1) w0(1) w0(1).^2 w0(1)^3]*p3;
figure
plot(t(i00:i10),keff(i00:i10));
hold on
plot(t(i00:i10),keff30,'r')
plot(t(i00:i10),keff20,'g')
plot(t(i00:i10),keff10,'m')
figure(gcf)
%% Plot residuals for new point
figure
plot(t(i00:i10),1e5*(keff30-keff(i00:i10)),'r');
hold on
plot(t(i00:i10),1e5*(keff20-keff(i00:i10)),'g');
plot(t(i00:i10),1e5*(keff10-keff(i00:i10)),'m');
grid
figure(gcf)
datetick
fprintf(1,'Std dev 3:rd order: %4i pcm\n',round(std(keff30-keff(i00:i10))*1e5))
fprintf(1,'Std dev 2:nd order: %4i pcm\n',round(std(keff20-keff(i00:i10))*1e5))
fprintf(1,'Std dev 1:st order: %4i pcm\n',round(std(keff10-keff(i00:i10))*1e5))

%%
i01=[212 222
    356 376
    543 561
    650 667
    967 972
    1533 1544];