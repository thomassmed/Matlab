function [x1,jAfn,xAfn]=A_fnsum(NEIG,rver)
% [iAfn,jAfn,xAfn]=A_fnsum(NEIG,rver);
%
% or Afn=A_fnsum(NEIG,rver);
%
NTOT=size(NEIG,1);

iAfn=zeros(NTOT,6);
xAfn=iAfn;
ivec=(1:NTOT)';
ett=ones(NTOT,1);

for i=1:6,
  if i<5, R=1.0; else R=rver;end  
  iAfn(:,i)=ivec;
  xAfn(:,i)=ett*R;
end  

iAfn=iAfn(:);
jAfn=NEIG(:);
xAfn=xAfn(:);


jempty=find(jAfn==(NTOT+1));
iAfn(jempty)=[];
jAfn(jempty)=[];
xAfn(jempty)=[];

if nargout==1,
  x1=sparse(iAfn,jAfn,xAfn);
else
  x1=iAfn;
end

%@(#)   A_fnsum.m 1.2   97/09/22     10:25:23
