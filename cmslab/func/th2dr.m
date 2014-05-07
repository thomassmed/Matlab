function [drpoles,fdpoles,drzeros,fdzeros]=th2dr(th)
%
%
%function [drpoles,fdpoles,drzeros,fdzeros]=th2dr(th)
%	
%Ber�knar d�mpkvoten och frekvensen f�r th

T=gett(th);
zepo=th2zp(th);
[nz,mz]=size(zepo);
p=zepo(2:nz,1:4);
[drpoles,fdpoles]=p2drfd(p(:,3),T);
[drzeros,fdzeros]=p2drfd(p(:,1),T);
