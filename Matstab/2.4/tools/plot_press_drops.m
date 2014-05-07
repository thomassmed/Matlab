i=i+1;hold off;
j=get_ch(i);
plot(ploss(j));hold on;plot(pelev(j),'g');
plot(pacc(j),'r');plot(pfric(j),'c');plot(prestr(j),'m');
axis([0 30 -2000 200])
title(['Channel No:',num2str(i)]);
grid


