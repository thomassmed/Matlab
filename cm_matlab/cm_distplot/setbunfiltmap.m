%@(#)   setbunfiltmap.m 1.3	 05/12/12     15:54:34
%
function setbunfiltmap(flag)
hand1=get(gcf,'userdata');
handles=get(hand1(2),'userdata');
wud=get(handles(22),'userdata');
ud=get(handles(2),'userdata');
distfile=ud(5,:);
[d,mminj,konrod,bb,hy,mz,ks,buntyp,bunref]=readdist7(distfile);
hbun=wud(2,1:size(bunref,1));
for i=1:length(bunref)
  val(i)=get(hbun(i),'value');
end
i=find(val);
bunref=bunref(i,:);
ff=mbucatch(buntyp,bunref);
ff=ff>0;
if flag==0,ff=1-ff;end
wud(1,:)=ff';
set(handles(22),'userdata',wud)
figure(hand1(2));
if strcmp(ud(4,1:7),'MATLAB:')
  hM=get(handles(6),'userdata');
  matvar=get(hM,'userdata');
  ccplot(matvar);
else
  ccplot;
end
