%@(#)   stege.m 1.3	 98/01/07     12:17:11
%
function stege(antal,restsek,specburn,garburn,buntot,staton);
if nargin<6, staton=' ';end
ia=length(antal);
it=length(find(antal>0));
nfig=1;
nr=0;
pos=[0 220 500 660];
m0=min(3,it);
p=m0;
for i=1:ia,
  if antal(i)>0,
    if antal(i)<3,
      disp(['Since there are only ',sprintf('%i',antal(i)),' bundles from ',remblank(buntot(i,:)),' no plot is included.']);
    else
      nr=nr+1;
      if p==m0,
        figure('position',pos);
        set(gcf,'papertype','A4');
        set(gcf,'paperposition',[0.25 .5 7.75 11]);
        pos(1)=pos(1)+300;
        p=0;
        tittel(staton);
      end
      p=p+1;
      subplot(m0,1,p);
      stairs([specburn(i,1:antal(i)),specburn(i,antal(i))]);
      hold on;
      ms=mean(specburn(i,1:antal(i)));
      plot([0 antal(i)],[ms ms],'--');
      plot([0 antal(i)],[garburn(i) garburn(i)]*1000,':');
      a=axis;
      dy=a(4)-a(3);
      text(.1*antal(i),ms+.02*dy*m0,'Medelutbr.');
      text(.6*antal(i),.02*dy*m0+garburn(i)*1000,'Garant. utbr.');
      xlabel('Antal patroner < utbr');
      ylabel('Medelutbr. (MWd/tU)');
%   Make sure only integers appear on x-axis
      xt=get(gca,'Xtick');
      xt=xt(find(xt-floor(xt)==0));
      set(gca,'xtick',xt);
      title([num2str(antal(i)),' st ',buntot(i,:),'    Restvarde: ',sprintf('%4.1f',restsek(i)),' MSEK']);
    end  % if antal(i)>3
  end  % if antal(i)>0
end
