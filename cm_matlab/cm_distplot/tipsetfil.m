%@(#)   tipsetfil.m 1.2	 94/01/25     12:43:42
%
function tipsetfil
tipfig=gcf;
hvec=get(gcf,'userdata');
val=get(hvec(length(hvec)),'userdata');
nfiles=size(val,1);
hfil=hvec(length(hvec)-nfiles+1:length(hvec));
hfig=hvec(length(hvec)-nfiles);
hand=get(hfig,'userdata');
tipfiles=get(hfil(1),'userdata');
for j=1:nfiles
  nr=hfil(j);
  if val(j)==1,val(j)=0;set(nr,'value',0),end
  v=get(nr,'value');
  if v==1
    filename=get(nr,'string');
    set(nr,'value',1)
    val(j)=1;
  else
    set(nr,'value',0)
  end
end
set(hvec(length(hvec)),'userdata',val);
figure(hfig);
set(hand(1),'string',filename)
setprop(5,filename);
ccplot;
figure(tipfig);
