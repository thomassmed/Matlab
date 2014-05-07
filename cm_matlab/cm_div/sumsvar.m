%@(#)   sumsvar.m 1.1   98/11/23     15:56:12
%  plottar data ur sumfilen
function sumsvar(b,x,y,menysvar);
if x>0
 xtext=get(b(x),'label');  
end

if y>0
 ytext=get(b(y+50),'label');  
end
if menysvar==106 & x>6 & isequal(get(b(113),'string'),'auto');
   sumfil=get(b(103),'string');   
   record=get(b(105),'string');
   summ=get(gcf,'userdata');
     if  isempty(summ)
         summ=sum2mlab7(sumfil,str2num(record));
	 set(gcf,'userdata',summ);
     end
   xx=summ(x,:);
   yy=summ(y,:);
   plot(xx,yy);
   grid on
   xlabel(xtext)
   ylabel(ytext)
   menysvar=0;
   set(b(113),'string','auto')
   set(b(114),'string','auto')
end
if menysvar==106 & x<7 & isequal(get(b(113),'string'),'auto');
  sumfil=get(b(103),'string');   
  record=get(b(105),'string');
  summ=get(gcf,'userdata');   
     if isempty(summ)   
        summ=sum2mlab7(sumfil,str2num(record));
	set(gcf,'userdata',summ);
     end
  yy=summ(y,:);
  grid on
  xtext=get(b(6),'label');
  xx=dat2tim(summ(6:-1:2,:)');
  plot(xx,yy);
  dat=tim2dat(get(gca,'xtick')');
  dat(:,1)=dat(:,1)-floor(dat(:,1)/100)*100;
  Dat=dat(:,1)*1e4+dat(:,2)*1e2+dat(:,3);
  set(gca,'xticklabel',Dat);
  xlabel(xtext)
  ylabel(ytext)
  menysvar=0;
  set(b(113),'string','auto')
  set(b(114),'string','auto')
end
if menysvar==106 & x<7 & ~isequal(get(b(113),'string'),'auto');
  sumfil=get(b(103),'string');   
  record=get(b(105),'string');
  summ=get(gcf,'userdata');   
    if isempty(summ)   
        summ=sum2mlab7(sumfil,str2num(record));
	set(gcf,'userdata',summ);
    end	
  xx=summ(6:-1:2,:);
  xx=xx';
  xx=dat2tim(xx);
  yy=summ(y,:);
  plot(xx,yy);
  grid on
  xmin=dat2tim(get(b(113),'string'));
  xmax=dat2tim(get(b(114),'string'));
  set(gca,'xlim',[xmin xmax]);
  dat=tim2dat(get(gca,'xtick')');
  dat(:,1)=dat(:,1)-floor(dat(:,1)/100)*100;
  Dat=dat(:,1)*1e4+dat(:,2)*1e2+dat(:,3);
  set(gca,'xticklabel',Dat);
  xlabel(xtext)
  ylabel(ytext)
  menysvar=0;
  set(b(113),'string','auto')
  set(b(114),'string','auto')
end
if menysvar==106 & x>6 & ~isequal(get(b(113),'string'),'auto');  
   sumfil=get(b(103),'string');   
   record=get(b(105),'string');
   summ=get(gcf,'userdata');   
     if isempty(summ)   
        summ=sum2mlab7(sumfil,str2num(record));
	set(gcf,'userdata',summ);
     end
   xx=summ(x,:);
   yy=summ(y,:);
   plot(xx,yy);
   xmin=str2num(get(b(113),'string'));
   xmax=str2num(get(b(114),'string'));
   set(gca,'xlim',[xmin xmax]);
   grid on
   xlabel(xtext)
   ylabel(ytext)
   menysvar=0;
   set(b(113),'string','auto')
   set(b(114),'string','auto')
end
if ~isequal(get(b(115),'string'),'auto') & ~isequal(get(b(116),'string'),'auto');
   ymin=str2num(get(b(115),'string'));
   ymax=str2num(get(b(116),'string'));
   set(gca,'ylim',[ymin ymax]);
   set(b(115),'string','auto')
   set(b(116),'string','auto')
end
if menysvar==102
   sumfil=get(b(103),'string');   
   record=get(b(105),'string'); 
   sumfil=get(b(103),'string');
   summ=sum2mlab7(sumfil,str2num(record));
   set(gcf,'userdata',summ)
end  
if menysvar==107
  set(gcf,'paperposition',[-0.5 0 25 28.5])
  set(gcf,'paperorientation','landscape')
  print -dps graf
  %!pageview graf.ps
  !lpr -Pa32laser2 graf.ps

end

if menysvar==118
  delete(gcf)
  clear global
end
