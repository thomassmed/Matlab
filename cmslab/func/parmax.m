function th=armax(z,nn,maxiter,tol,lim,maxsize,Tcap)
%ARMAX  Computes the prediction error estimate of an ARMAX model.
%
%	TH = armax(Z,NN)
%
%	TH: returned as  the estimated parameters of the ARMAX model
%	A(q) y(t) = B(q) u(t-nk) + C(q) e(t)
%	along with estimated covariances and structure information.
%	For the exact format of TH, see HELP THETA.
%
%	Z : The output-input data Z=[y u], with y and u being column vectors.
%	For a time-series, Z=y only. The routine does not work for multi-
%	input systems. Use PEM for that case.
%
%	NN: Initial value and structure information. When no initial parameter
%	estimates are available enter NN as
%	NN=[na nb nc nk], the orders and delay of the above model,or as
%	NN=[na nc] for the time-series case (ARMA-model). With an initial
%	estimate available in THI, a theta matrix of standard format, enter
%	NN=THI. Then the criterion minimization is initialized at THI.
%
%	Some parameters associated with the algorithm are accessed by
%	TH = armax(Z,NN,maxiter,tol,lim,maxsize,T)
%	See HELP AUXVAR for an explanation of these and their default values.

%	L. Ljung 10-1-86,12-09-91
%	Copyright (c) 1986-92 by the MathWorks, Inc.
%	All Rights Reserved.

%
% *** Set up default values ***
[Ncap,nz]=size(z);
[nr,cc]=size(nn);   nu=nz-1;
maxsdef=idmsize(Ncap);

if nargin<7, Tcap=[];end
if nargin<6, maxsize=[];end
if nargin<5, lim=[];end
if nargin<4, tol=[];, end
if nargin<3, maxiter=[]; end
if isempty(Tcap),if nr>1,Tcap=gett(nn);else Tcap=1;end,end
if isempty(maxsize),maxsize=maxsdef;end
if isempty(lim),lim=1.6;end,if isempty(tol),tol=0.01;end
if isempty(maxiter),maxiter=10;end
if Tcap<0,Tcap=1;end, if maxsize<0,maxsize=maxsdef;end, if lim<0,lim=1.6;end
if tol<0,tol=0.01;end,if maxiter<0, maxiter=10;end

% *** Do some consistency tests ***


if nz>Ncap, error('The data should be organized in column vectors')
return,end
if nu>1, error('This routine only works for single-input systems. Use PEM instead!')
return,end
if nr==1 & cc~=2*nu+2, 
       disp('Incorrect number of orders specified:')
       disp('For a time series  nn=[na nc]')
       disp('For a SISO system  nn=[na nb nc nk]')
       error('see above')
return,end

% *** if nn has more than 1 row, it is a theta matrix
%      and we jump directly to the minimization ***
%
if nr>1, nu=nn(1,3);
   if nu>1, error('This routine only works for single input systems. Use PEM instead')
   return,end
   if nu==1,  na=nn(1,4);nb=nn(1,5);nc=nn(1,6);nk=nn(1,9);
   else na=nn(1,4);nb=0;nc=nn(1,5);nk=0;end
         n=na+nb+nc; t=nn(3,1:n).';
         if nc>0, c=[1 t(na+nb+1:n).'];else c=1;,end
         if na>0,a=[1 t(1:na).'];else a=1;,end
         if nb>0,b=[zeros(1,nk) t(na+1:na+nb).'];,else b=0;,end
         ni=max([na nb+nk-1 nc]);
	 e=pefilt(a,c,z(:,1)); if nu==1, e=e-pefilt(b,c,z(:,2),e(1:ni));end
end
if nr==1,
   if nu==0,
          na=nn(1); nc=nn(2); nb=0; nk=0; n=na+nc;
          v=z; narx=na; nd=na;
   end
   if nu==1,
          na=nn(1); nb=nn(2); nc=nn(3); nk=nn(4); n=sum(nn(1:3));
          narx=[na nb nk]; nd=0;
   end
   ni=max([na nb+nk-1 nc]);
   t=arx(z,narx,maxsize,Tcap,0);
   if na>0, a=[1 t(1:na).'];else a=1;end
   if nb>0, b=[zeros(1,nk) t(na+1:na+nb).'];end
   if nc==0  % then we use the arx-estimate for initial condition
       e=pefilt(a,[1],z(:,1));
       if nu==1, e=e-pefilt(b,[1],z(:,2),e(1:ni));end
       c=1;
   end

   if nc>0 %then we compute the IV-estimate in case nu==1
      if nu==1
         a=fstab(a);
         t=iv(z,narx,a,b,maxsize,Tcap,0);
         if na>0,a=[1 t(1:na).'];else a=1;end
         b=[zeros(1,nk) t(na+1:na+nb).'];
         v=filter(a,1,z(:,1))-filter(b,1,z(:,2));v(1:ni)=zeros(ni,1);
      end
%
%  *** Determine the initial C-estimate by first building a
%      high order AR-model of the residuals v and the use the 
%      LS-method with the new residuals as inputs ***
%          
        ord=min(na+nb+4*nc,length(v)/3);
	t1=arx(v,ord,maxsize,Tcap,0);
        e=pefilt([1 t1.'],1,v);
        t2=arx([v e],[nd nc 1],maxsize,Tcap,0);
%
%         ** test the stability of the C-estimate **
%
        c=[1 t2(nd+1:nd+nc).']; c=fstab(c);
        t2(nd+1:nd+nc)=c(2:nc+1).';
   
     if nu==1, t=[t;t2]; else t=t2;end
%
     if nd==0, d=1; else d=[1 t2(1:nd).'];end
     e=pefilt(d,c,v,zeros(1,ni));
  end
end
% *** Display initial estimate ***
%
V=e'*e/(Ncap-ni);
%
% *** start minimizing ***
%
% ** determine limit for robustification **
 if lim~=0, lim=median(abs(e-median(e)))*lim/0.7;end
 if lim==0,el=e;else
 [ne,me]=size(e);
 ll=ones(ne,me)*lim;la=abs(e)+eps*ll;el=e.*(min(la,ll)./la); clear ll,clear la,end
 g=ones(n,1); l=0; st=0; nmax=max([na nb+nk-1 nc]);
%
% ** the minimization loop **
%
while [norm(g)>tol l<maxiter st~=1]
      l=l+1;
%     * compute gradient *
      yf=filter(-1,c,z(:,1)); ef=filter(1,c,e);
      if nu==1, uf=filter(1,c,z(:,2));end
  M=floor(maxsize/n);
  R=zeros(n);F=zeros(n,1);
  for k1=nmax:M:Ncap-1
      jj=(k1+1:min(Ncap,k1+M));
      psi=zeros(length(jj),n);
      for k=1:na, psi(:,k)=yf(jj-k);end
      for k=1:nb, psi(:,na+k)=uf(jj-k-nk+1);end
      for k=1:nc, psi(:,k+nb+na)=ef(jj-k);end
      R=R+psi'*psi; F=F+psi'*el(jj);
  end
   if Ncap>M, g=R\F; else g=psi\el(jj);end,grad=F;
%
%     * search along the g-direction *
%
      [t1,e,el,V1,c,st]=psearchax(z,t,g,lim,V,na,nb,nc,nk,ni);
if st==1,      [t1,e,el,V1,c,st]=psearchax(z,t,grad/trace(R)*length(R),lim,V,na,nb,nc,nk,ni);end

      if st==1,
	end
      t=t1; V=V1;
end
th=zeros(3+n,max([6+3*nu 7 n]));
V=e'*e/(length(e)-ni);
if nu==1
   th(1,1:9)=[V Tcap 1 na nb nc 0 0 nk];
   else th(1,1:6)=[V Tcap 0 na nc 0];end
th(2,1)=V*(1+n/Ncap)/(1-n/Ncap);
ti=fix(clock); ti(1)=ti(1)/100;
th(2,2:6)=ti(1:5);
th(2,7)=7;
th(3,1:n)=t.';
if maxiter==0,return,end
if Ncap>M, PP=inv(R); else PP=inv(psi'*psi);end
th(4:3+n,1:n)=V*PP;

