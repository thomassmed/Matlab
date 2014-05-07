%@(#)   plottaspec.m 1.2	 94/08/12     12:15:23
%
%function plottaspec(eladd,buntot,garburn,speccore,specpool,specclab,antorrf,index)
function plottaspec(eladd,buntot,garburn,speccore,specpool,specclab,antorrf,index)
if eladd(index)>9
    estr=['E',sprintf('%2i',eladd(index))];
  else
    estr=[' E',sprintf('%1i',eladd(index))];
end
spectot=[speccore specpool specclab];
spec=spectot(index,:);
i=find(spec==0);spec(i)=[];
i=0;
maxlim=2000*(floor(max(spec)/2000)+1);
for limm=2000:2000:maxlim
  i=i+1;
  ll=length(find(spec>=limm-2000&spec<limm));
  if i==1, ll=ll+antorrf(index);end
  spect(2*i-1:2*i)=[ll ll];
  xax(2*i-1:2*i)=[limm-2000 limm-0.01];
end  
if length(xax)==0, xax=[0 2000];spect=[antorrf(index) antorrf(index)];end
if length(maxlim)==0, maxlim=2000;end
xax=[xax maxlim+0.01]/1000;
spect=[spect 0];
hold off
plot(xax,spect)
hold on
axx=axis;
plot([garburn(index) garburn(index)],axx(3:4),'r');
axx=axis;
title(['Spektrum for ers.laddn ',estr,', buntyp ',remblank(buntot(index,:))]);
grid
d2x=0.02*(axx(2)-axx(1));
d5y=0.05*(axx(4)-axx(3));
text(axx(1)+d2x,axx(4)-d5y,'Antal BP/(2 MWd/kgU)');
text(axx(2)-10*d2x,axx(3)-2*d5y,'Utbr. (MWd/kgU)');
text(garburn(index)+d2x/2,axx(3)+10*d5y,'Gar.');
text(garburn(index)+d2x/2,axx(3)+9*d5y,'Utbr.');
