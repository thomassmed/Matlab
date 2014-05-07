%@(#)   bocbyte.m 1.2	 94/08/12     12:14:58
%
%function [burnup,buntyp,ranking,vhist,sshist]=bocbyte(eocfile,bocfile,antal1,bunt1,...
%antal2,bunt2,antal3,bunt3)
function [burnup,buntyp,ranking,vhist,sshist]=bocbyte(eocfile,bocfile,antal1,bunt1,...
antal2,bunt2,antal3,bunt3)
if nargin<5, antal2=0;bunt2='';end
if nargin<7, antal3=0;bunt3='';end
kinf=kinf2mlab(eocfile);
[ks,is]=sort(kinf);
bu=mean(readdist(bocfile,'burnup'));
[bs,ib]=sort(bu);
nfresh=max(find(bs==0));
kinfb=kinf2mlab(bocfile);
kinfb(ib(1:nfresh))=2.0*kinf(ib(1:nfresh));
[kb,ib]=sort(kinfb);
[burnup,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist(eocfile,'burnup');
vhist=readdist(eocfile,'vhist');
sshist=readdist(eocfile,'sshist');
kkan=size(burnup,2);
burnup(:,ib(1:kkan-antal1-antal2-antal3))=burnup(:,is(antal1+antal2+antal3+1:kkan));
sshist(:,ib(1:kkan-antal1-antal2-antal3))=sshist(:,is(antal1+antal2+antal3+1:kkan));
vhist(:,ib(1:kkan-antal1-antal2-antal3))=vhist(:,is(antal1+antal2+antal3+1:kkan));
buntyp(ib(1:kkan-antal1-antal2-antal3),:)=buntyp(is(antal1+antal2+antal3+1:kkan),:);
burnup(:,ib(kkan-antal1-antal2-antal3+1:kkan))=0*burnup(:,is(kkan-antal1-antal2-antal3+1:kkan));
sshist(:,ib(kkan-antal1-antal2-antal3+1:kkan))=0*sshist(:,is(kkan-antal1-antal2-antal3+1:kkan));
vhist(:,ib(kkan-antal1-antal2-antal3+1:kkan))=0*vhist(:,is(kkan-antal1-antal2-antal3+1:kkan));
for i=kkan-antal1-antal2-antal3+1:kkan-antal1-antal2
  buntyp(ib(i),:)=sprintf('%4s',bunt3);
end
for i=kkan-antal1-antal2+1:kkan-antal1
  buntyp(ib(i),:)=sprintf('%4s',bunt2);
end
for i=kkan-antal1+1:kkan
  buntyp(ib(i),:)=sprintf('%4s',bunt1);
end
ranking=ib;
end
