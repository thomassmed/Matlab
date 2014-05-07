%@(#)   printutbyt.m 1.1	 05/07/13     10:29:38
%
%
function printutbyt(fid,buid,buidboc,burnboc,utbytvec,vec,mminj,comment)
if nargin<8, comment='';end
if fid==0,
  fprintf('%s\n',comment);
else
  fprintf(fid,'%s\n',comment);
end
[m,n]=size(utbytvec);
[m1,n1]=size(vec);
if m==n1, vec=vec';end
ivec=find(utbytvec.*vec>0);
[b,iordn]=sort(burnboc(ivec));
for i=length(ivec):-1:1
   i1=iordn(i);
   printsfg(fid,ivec(i1),0,buid(ivec(i1),:),mminj);
   printsfg(fid,0,ivec(i1),buidboc(ivec(i1),:),mminj);
end
