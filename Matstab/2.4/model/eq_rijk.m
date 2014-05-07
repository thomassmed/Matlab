function rijk=eq_rijk(rho,NEIG,rver,bes)
% rijk=eq_rijk(rho,NEIG,rver,bes)
% 
% rijk of equation 6.2.67 is calculated

NTOT=size(NEIG,1);

rijk=zeros(NTOT,1);
rho=rho(:);
rho(NTOT+1)=bes;
empty=NTOT+1;
for i=1:6,
  if i<5, R=1.0;RN=NEIG(:,i); else RN=NEIG(:,i);it=find(RN==empty);RN(it)=it;R=rver;end
  rijk=rijk+rho(1:NTOT)./rho(RN)*R;
end
rho(NTOT+1)=[];
%@(#)   eq_rijk.m 1.2   97/09/22     10:36:28
