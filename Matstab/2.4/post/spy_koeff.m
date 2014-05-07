function spy_koeff(Ahyd)
%spy_koeff
%
%spy_koeff(Ahyd)
%Click on a spy plot and get the desired value

%@(#)   spy_koeff.m 1.2   96/08/21     13:57:49

[x,y]=ginput(1);
disp(['x=' num2str(round(x)) ' y=' num2str(round(y)) ' c=' num2str(Ahyd(y,x))])
