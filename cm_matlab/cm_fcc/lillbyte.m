%@(#)   lillbyte.m 1.2	 94/08/12     12:15:17
%
%function [burnup,buntyp,ranking]=lillbyte(eocfile,antal1,bunt1,...
%antal2,bunt2,antal3,bunt3)
function [burnup,buntyp,ranking]=lillbyte(eocfile,antal1,bunt1,...
antal2,bunt2,antal3,bunt3)
if nargin<5, antal2=0;bunt2='';end
if nargin<7, antal3=0;bunt3='';end
kinf=kinf2mlab(eocfile);
[ks,is]=sort(kinf);
[burnup,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist(eocfile,'burnup');
kkan=size(burnup,2);
burnup(:,is(1:kkan-antal1-antal2-antal3))=burnup(:,is(antal1+antal2+antal3+1:kkan));
buntyp(is(1:kkan-antal1-antal2-antal3),:)=buntyp(is(antal1+antal2+antal3+1:kkan),:);
burnup(:,is(kkan-antal1-antal2-antal3+1:kkan))=0*burnup(:,is(kkan-antal1-antal2-antal3+1:kkan));
for i=kkan-antal1-antal2-antal3+1:kkan-antal1-antal2
  buntyp(is(i),:)=sprintf('%4s',bunt3);
end
for i=kkan-antal1-antal2+1:kkan-antal1
  buntyp(is(i),:)=sprintf('%4s',bunt2);
end
for i=kkan-antal1+1:kkan
  buntyp(is(i),:)=sprintf('%4s',bunt1);
end
ranking=is;
end
