%@(#)   stavplot.m 1.1	 06/09/26     14:49:35
function stavplot(distfil,patron,nod,stavdist)
%stavplot('dist.dat','patron',nod,'pinpow')	
      
[a,mminj]=readdist7(distfil,stavdist);
patroner=readdist7(distfil,'asyid');
kannr=strmatch(patron,patroner);

%alla stavar i utvald nod
b(1,:)=a(nod,1:100);
for i = 1:length(patroner);
  b(i,:)=a(nod,(i-1)*100+1:i*100);
end
 
c=reshape(b(kannr,:),10,10);

disp(stavdist)
     disp(c)
 
mini = min(min(c(find(c))));
cnorm = 64*((c-mini)./max(c(:)-mini));
mycmap = colormap;
rad = linspace(min(c(:)),max(c(:))+eps,size(mycmap,1));

clf

       
image(cnorm)     
cb = colorbar;
max(c(:));
lab = (max(c(:))-mini)	*(0:8)/8 + mini;
str = '';
for ind = 1:length(lab)
  str = strvcat(str,sprintf('%1.3e',lab(ind)));
end

set(cb,'ytick',[1 8:8:64],'yticklabel',str)
for ind = 1:10
    for ind2 = 1:10
      r = rectangle('position',[ind-0.5 ind2-0.5 1 1]);
      if c(ind2,ind) <= 0
      set(r,'facecolor','white');
      else
      set(r,'facecolor','none');
      end
    end
end
% Koll styrstavshörn
[pkordpatron]=knum2cpos(kannr,mminj);% tar fram polcakoordinaten för aktuell patron
[pkordss]=cpos2crpos([pkordpatron],mminj);% tar fram polcakoordinaten för styrstaven vid patronen
if ~isempty(pkordss);
[pkordpatroner]=crpos2knum([pkordss],mminj);% tar fram vilka kanalnummer som finns vid styrstaven.

pos=find(kannr == pkordpatroner); % 1=nerth 2=nertv 3=uppth 4=upptv

axis([0 11 0 11])
set(gca,'xtick',1:10,'ytick',1:10)
hold on
switch pos
	case 1
        lin = plot([2 10.75 10.75],[10.75 10.75 2]);%nerth
        case 2
        lin = plot([0.25 0.25 8],[2 10.75 10.75]);%nertv
        case 3
        lin = plot([2 10.75 10.75],[0.25 0.25 8]);%uppth
        case 4
        lin = plot([0.25 0.25 8],[8 0.25 0.25]);%upptv
       end
set(lin,'linewidth',5,'color',[1 0.4 0.8])        
end        
