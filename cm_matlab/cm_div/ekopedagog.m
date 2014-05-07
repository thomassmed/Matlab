%@(#)   ekopedagog.m 1.2	 94/02/08     12:31:25
%
subplot(211)
x1=[0 1 1.01 2:6]';
y1=[2.50 2.50 2.45 2.45 2.45 2.45 2.50 2.53]';
x2=[7:9 9.01 10 11 12]';
y2=1.04*[2.45 2.45 2.45 2.5 2.5 2.50 2.50];
delta=.1;
hold off
plot(x1,y1);
hold on
plot(x1,y1-delta,'--');
plot(x2,y2);
plot(x2,y2-delta,'--');
axis([0 12 2 3]);
text(.2,2.6,'E5 slututbr.');
text(4,2.6,'Coast Down');
text(2,2.1,'Streckad linje markerar korrigerad kostnad');
text(8,2.65,'Clab-transport');
title('Gammal modell, Total kostnad 200 MSEK');
subplot(212)
x1=(0:6)';
y1=[2.45 2.45 2.45 2.45 2.45 2.43 2.39]';
x2=[7:9 9.01 10 11 12]';
y2=1.04*[2.50 2.50 2.50 2.5 2.5 2.50 2.50];
hold off
plot(x1,y1);
hold on
plot(x2,y2);
text(4,2.5,'Coast Down');
axis([0 12 2 3]);
title('Ny modell, Total kostnad 200 MSEK');
set(gcf,'papertype','A4');
set(gcf,'paperpos',[0.25 .5 7.75 11]);
