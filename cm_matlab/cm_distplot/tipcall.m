%@(#)   tipcall.m 1.2	 94/01/25     12:43:35
%
function tipcall
tipfig=gcf;
hvec=get(gcf,'userdata');
valfil=get(hvec(length(hvec)),'userdata');
nfiles=size(valfil,1);
hfil=hvec(length(hvec)-nfiles+1:length(hvec));
hfig=hvec(length(hvec)-nfiles);
hand=get(hfig,'userdata');
ll=length(hvec)-nfiles-1;
use=get(hand(51),'userdata');
val=zeros(ll,1);
use4=use(4,:);iu=find(abs(use4)==32);use4(iu)='';
iu=find(abs(use4)==0);use4(iu)='';
iv=str2num(use4);
val(iv)=1;
for j=1:ll
  nr=hvec(j);
  if val(j)==1,val(j)=0;set(nr,'value',0),end
  v=get(nr,'value');
  if v==1
    use=str2mat(use(1:3,:),num2str(j),use(5:size(use,1),:));
    nam=get(nr,'string');
    use(5,1:6)=nam;
    set(nr,'value',1)
  else
    set(nr,'value',0)
  end
end
set(hand(51),'userdata',use);
figure(hfig);
dname=remblank(use(5,:));
oldd=setprop(4);
setprop(4,dname);
if ~strcmp(oldd(1:3),dname(1:3)), setprop(9,'auto');end
ccplot;
figure(tipfig);
