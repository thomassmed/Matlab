%@(#)   plotallchains.m 1.1	 05/07/13     10:29:35
%
%
function [Hpil,Hring,gonu]=plotallchains(curfile,bocfile,OK)
%function [Hpil,Hring]=plotallchains(kedja,mminj)
%function [Hpil,Hring,gonu]=plotallchains(curfile,bocfile,OK)
if ~isstr(curfile),
  kedja=curfile;
  mminj=bocfile;
  kkan=sum(length(mminj)+2-2*mminj);
  Hpil=zeros(kkan,1);Hring=Hpil;
else
  [buid,mminj]=readdist7(curfile,'asyid');
  buidboc=readdist7(bocfile,'asyid');
  if nargin<3, OK=ones(1,size(buid,1));end
  Hpil=zeros(length(OK),1);Hring=Hpil;
  [from,to,ready,fuel]=initvec(buid,buidboc,OK);
  [kedja,gonu]=findchain(to,from,ready,fuel);
end
farger=[0 0 0
        0.3 0.3 0.3
        0.3 0 0
        0.8 0 0
        0 0.3 0
        0 0.5  0
        0 0  0.3
        0 0   0.8];
ifa=size(farger,1);
[mk,nk]=size(kedja);
for i=1:mk,
  nfa=i-fix(i/ifa)*ifa;if nfa==0,nfa=ifa;end
  ked=kedja(i,:);ked=ked(find(ked>0));
  lk=length(ked);ked=ked(lk:-1:1);
  [hpil,hring]=plotkedja(ked,mminj,farger(nfa,:));
  Hpil(ked(1:lk-1))=hpil; Hring(ked(1:lk-1))=hring;
end
