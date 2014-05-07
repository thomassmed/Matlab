function NEIG=neighbour(neig,kmax)
%function NEIG=NEIGHBOUR(neig,kmax)
%
%Kom ihag att fixa denna for polca senare
%
%
%
%
%
[in,jn]=size(neig);
if jn==1,  %neig from RAMONA
  empty=length(neig)/4*kmax+1;
  itemp=find(neig==empty);
  neig(itemp)=(empty-1)*kmax*ones(size(itemp));
  neig=flipud(rot90(reshape(neig/kmax+1,4,in/4)));
else  % from POLCA  
  neig=neig(:);  
  itemp=find(neig==0);
  empty=in+1;
  neig(itemp)=empty;
    
end
[in,jn]=size(neig);
empty=kmax*in+1;

for i=1:in,
  kstart=(i-1)*kmax+1;
  for j=1:4,
    if neig(i,j)~=empty,
      NEIG(j,kstart:kstart+kmax-1)=(neig(i,j)-1)*kmax+1:(neig(i,j)-1)*kmax+kmax;
    else
      NEIG(j,kstart:kstart+kmax-1)=empty*ones(1,kmax);
    end
  end
end
NEIG=NEIG';
nod=(1:in*kmax)';
NEIG(:,5)=nod+1;
NEIG(:,6)=nod-1;
top=(kmax:kmax:in*kmax)';
bot=(1:kmax:in*kmax)';
NEIG(top,5)=empty*ones(size(top));
NEIG(bot,6)=empty*ones(size(bot));
%@(#)   NEIGHBOUR.m 1.2   97/09/22     10:24:25
