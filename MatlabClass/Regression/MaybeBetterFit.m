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
ee=(E-3000)/10000;
qq=(Q-100)/100;
ww=(W-95)/100;
ettt=ones(size(Q));
keffest=[ettt ee ee.^2 qq ww]*pe;
rms(keff(isel)-keffest(isel))*1e5
%% Try the coefficients fopr sevaral intervals with transients:
I1=212:222;
hold off
plot(t(I1),keff(I1));
hold on
plot(t(I1),keffest(I1)+keff(I1(1))-keffest(I1(1)),'r');
axx=axis;
xpos=.3*axx(1)+.7*axx(2);
ypos=.9*axx(3)+.1*axx(4);
keffdif=keffest(I1)-keff(I1)+keff(I1(1))-keffest(I1(1));
text(xpos,ypos,sprintf('std = %i pcm',...
    round(1e5*std(keffdif))));
datetick
figure(gcf)
%%
I2=356:376;
hold off
plot(t(I2),keff(I2));
hold on
plot(t(I2),keffest(I2)+keff(I2(1))-keffest(I2(1)),'r');
axx=axis;
xpos=.25*axx(1)+.75*axx(2);
ypos=.9*axx(3)+.1*axx(4);
keffdif=keffest(I2)-keff(I2)+keff(I2(1))-keffest(I2(1));
text(xpos,ypos,sprintf('std = %i pcm',...
    round(1e5*std(keffdif))));
datetick
figure(gcf)
%%
I3=543:561;
hold off
plot(t(I3),keff(I3));
hold on
plot(t(I3),keffest(I3)+keff(I3(1))-keffest(I3(1)),'r');
axx=axis;
xpos=.1*axx(1)+.9*axx(2);
ypos=.9*axx(3)+.1*axx(4);
keffdif=keffest(I3)-keff(I3)+keff(I3(1))-keffest(I3(1));
text(xpos,ypos,sprintf('std = %i pcm',...
    round(1e5*std(keffdif))));
datetick
figure(gcf)
%%
I4=650:667;
hold off
plot(t(I4),keff(I4));
hold on
plot(t(I4),keffest(I4)+keff(I4(1))-keffest(I4(1)),'r');
axx=axis;
xpos=.25*axx(1)+.75*axx(2);
ypos=.9*axx(3)+.1*axx(4);
keffdif=keffest(I4)-keff(I4)+keff(I4(1))-keffest(I4(1));
text(xpos,ypos,sprintf('std = %i pcm',...
    round(1e5*std(keffdif))));
datetick
figure(gcf)
%%
I5=967:972;
hold off
plot(t(I5),keff(I5));
hold on
plot(t(I5),keffest(I5)+keff(I5(1))-keffest(I5(1)),'r');
axx=axis;
xpos=.1*axx(1)+.9*axx(2);
ypos=.9*axx(3)+.1*axx(4);
keffdif=keffest(I5)-keff(I5)+keff(I5(1))-keffest(I5(1));
text(xpos,ypos,sprintf('std = %i pcm',...
    round(1e5*std(keffdif))));
datetick
figure(gcf)
%%
I6=1533:1544;
hold off
plot(t(I6),keff(I6));
hold on
plot(t(I6),keffest(I6)+keff(I6(1))-keffest(I6(1)),'r');
axx=axis;
xpos=.1*axx(1)+.9*axx(2);
ypos=.9*axx(3)+.1*axx(4);
keffdif=keffest(I6)-keff(I6)+keff(I6(1))-keffest(I6(1));
text(xpos,ypos,sprintf('std = %i pcm',...
    round(1e5*std(keffdif))));
datetick
figure(gcf)
