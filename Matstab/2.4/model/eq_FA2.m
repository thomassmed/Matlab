function FA2=eq_FA2(X2nm,Y2nm,NEIG,x,sig2,sig21);
% FA2=eq_FA2(X2nm,Y2nm,NEIG,x,sig2,sig21) from eq 28

NTOT=size(NEIG,1);

  sumX2=zeros(NTOT,1);
  FA2=zeros(NTOT,1);
  for i=1:6,
    sumX2=sumX2-X2nm(:,i);
    NI=find(NEIG(:,i)~=NTOT+1);
    FA2(NI)=FA2(NI)+x(NEIG(NI,i)).*Y2nm(NI,i);
  end
  sumX2=sumX2+sig21;
  FA2=(FA2+sumX2.*x)./sig2;
%@(#)   eq_FA2.m 1.1   98/03/06     13:18:30
