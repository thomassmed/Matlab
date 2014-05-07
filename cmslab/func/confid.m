function e=confid(y,p,phi,phi_x)
%e=confid(y,p,phi)
%Beräknar confidensen (en sigma) för
%regressorn phi utsignalen y och parametervektorn p
%y=phi'*p +- e 
%phi_x är information om för vilka punkter felet e skall beräknas
[r,k]=size(phi);
if r<k,phi=phi';end
e=zeros(length(phi),1);
R=inv(phi'*phi);

for n=1:length(phi_x),
  e(n)=sqrt(phi_x(n,:)*R*phi_x(n,:)');
end
