function [t1,e,el,V1,c,st]=searchax(z,t,g,lim,V,na,nb,nc,nk,ni)
%SEARCHAX searches for lower values of the prediction error criterion.
%
%	[T1,E,EL,V1,C,ST] = searchax(Z,T,G,LIM,V,NA,NB,NC,NK)
%
%	The routine searches for a lower value of the prediction erro cri-
%	terion for the armax model, starting at T, loking in the
%	G-direction. T1 is returned as the parameters that give a lower value V1
%	If no lower value is found, ST=1, C is the C-polynomial associated 
%	with T1, and E, EL are the filtered data sequences.
%	The routine is to be used as a subroutine to ARMAX. See
%	ARMAX for an explanation of the other arguments.

%	L. Ljung 10-1-86,1-25-92
%	Copyright (c) 1986-92 by the MathWorks, Inc.
%	All Rights Reserved.

l=0;,k=1;V1=V+1; n=na+nb+nc; st=0;
[mmz,nnz]=size(z(:,1));
ll=ones(mmz,nnz)*lim;
while [V1 > V l<10],
t1=t+k*g; if l==9,t1=t;end
c=fstab([1 t1(na+nb+1:n).']); t1(na+nb+1:n)=c(2:nc+1).';

     a=[1 t1(1:na).']; 
     b=[zeros(1,nk) t1(na+1:na+nb).'];
     e=pefilt(a,c,z(:,1)); if nb>0, e=e-pefilt(b,c,z(:,2),e(1:ni));end
     if lim==0,el=e;else la=abs(e)+eps*ll;el=e.*(min(la,ll)./la);end

     V1=e'*el/(length(e)-ni);

k=k/2;
l=l+1; if l==10,st=1;end
end

