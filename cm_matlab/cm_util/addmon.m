%@(#)   addmon.m 1.2	 94/02/08     12:31:05
%
% add n months (n may be<0) too the datin
%function datut=addmon(datin,n)
function datut=addmon(datin,n)
datut=datin;
datut(2)=datin(2)+n;
while datut(2)>12,
   datut(1)=datut(1)+1;
   datut(2)=datut(2)-12;
end
while datut(2)<1,
   datut(1)=datut(1)-1;
   datut(2)=datut(2)+12;
end
end
