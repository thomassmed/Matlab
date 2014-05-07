function e=confid(y,p,phi,phi_x)
%e=confid(y,p,phi)
%Ber�knar confidensen (en sigma) f�r
%regressorn phi utsignalen y och parametervektorn p
%y=phi'*p +- e 
%phi_x �r information om f�r vilka punkter felet e skall ber�knas
[r,k]=size(phi);
if r<k,phi=phi';end
e=zeros(length(phi),1);
R=inv(phi'*phi);

for n=1:length(phi_x),
  e(n)=sqrt(phi_x(n,:)*R*phi_x(n,:)');
end
