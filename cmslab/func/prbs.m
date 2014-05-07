function y=prbs(d,n);
%
%y=prbs(d,n)
%
%Genererar en PRBS (Pseudo Random Binary Signal).
%d anger hur mnga samples varje "period" skall ha.
%n r hur mnga samples som skall genereras.

%Pr Lansker 11/9-91

%rand('normal');
%w=rand(round(n/d),1); obsolete syntax /vdb 000407
w=randn(round(n/d),1);
rbs=1/2+sign(w)/2;
onearr=ones(d,1);
y=zeros(length(rbs),1);
for num=1:length(rbs),
  y(d*(num-1)+1:d*num)=rbs(num)*onearr;
end
