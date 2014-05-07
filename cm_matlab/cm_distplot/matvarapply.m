%@(#)   matvarapply.m 1.3	 98/01/19     08:13:25
%
function matvarapply
hMATL=gcf;
hand=get(hMATL,'userdata');
hmat=hand(1);
curf=hand(2);
h1=hand(4);
hfil=hand(5);
varst=get(hmat,'string');
hM=get(h1,'userdata');
set(hM,'label',varst);
varstring=['MATLAB:',varst];...
delete(hMATL);
figure(curf);
setprop(4,varstring);
setprop(9,'auto');
