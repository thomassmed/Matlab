%@(#)   setsparse.m 1.3	 97/11/05     12:24:35
%
%function A=setsparse(Ain,i,j,x)
function A=setsparse(Ain,i,j,x)
[ia,ja]=size(Ain);
if max(i)>ia, Ain=[Ain;zeros(max(i)-ia,ja)];[ia,ja]=size(Ain);end
if max(j)>ja, Ain=[Ain zeros(ia,max(j)-ja)];end
A=setspars(Ain,i,j,x);
