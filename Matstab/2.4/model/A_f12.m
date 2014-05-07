function Af12=A_f12(X2nm,Y2nm,NEIG,sig2,sig21);

NTOT=size(NEIG,1);
I=(1:NTOT)'; I6=[I;I;I;I;I;I];

sumX2=(sig21-sum(X2nm')')./sig2;
for i=1:6,
  Y2nm(:,i)=Y2nm(:,i)./sig2;
end
i=I6;j=NEIG(:);y=Y2nm(:);
rbound=find(j==(NTOT+1));
i(rbound)=[];
j(rbound)=[];
y(rbound)=[];

Af12=spdiags(sumX2,0,NTOT,NTOT)+sparse(i,j,y);
%
