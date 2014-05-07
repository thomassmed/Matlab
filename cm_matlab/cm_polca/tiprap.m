%@(#)   tiprap.m 1.1	 94/09/02     12:45:44
%
%function tiprap(filename); Plot status of tip
function tiprap(filename);
nfig=1;
nr=0;
if nargin<1
  filename=setprop(5);
end
%[tipinfo1 tipinfo2]=readtipinfo;
%[tipnr,tipmat,inter]=readtipinfo('/cm/f2/fil/tip-info.txt');
[tipnr,tipmat,inter]=readtipinfo;
[tipgam,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist(filename,'tipgam');
tipmea=readdist(filename,'tipmea');

tipgam=100*tipgam/mean(mean(tipgam));
tipmea=100*tipmea/mean(mean(tipmea));
%                                             BERÄKNAT PÅ NOD 1:23
%tipgam=tipgam(1:23,:);
%tipmea=tipmea(1:23,:);


tipdiff1=tipgam-tipmea;
sub=['r',
     'm',
     'y',
     'c',
     'g'];
%detsor=max(tipinfo2);
detsor=max(tipnr);
det=1:detsor;
for i=1:detsor
%  a=find(tipinfo2==det(i));
  a=find(tipnr==i);
  tipgamtemp(:,i)=mean(tipgam(:,a)')';
  tipmeatemp(:,i)=mean(tipmea(:,a)')';
end
tipdiff=tipgamtemp-tipmeatemp;
ia=detsor;
pos=[0 220 500 660];
m0=2;
flag=2;

p=m0*2;
for i=1:ia,
    nr=nr+1;
      if p==m0*2,
        figure('position',pos);
        set(gcf,'papertype','A4');
        set(gcf,'paperpos',[0.25 .5 7.75 11]);
        pp=[0 0 50 30];
        uicontrol('style','Pushbutton','position',pp,...
       'callback','printer','string','print');
        pos(1)=pos(1)+300;
        p=0;
hold on
%return
%        tittel(rubrik);
      end
if flag~=1
  flag=1;
  ld=length(detpos);
  p=1;
  h=subplot(m0,2,p);
hold on


%STATISTICS


  dev=stats(tipdiff1);

  n=13;
  infotext=sprintf('%9s','DRIFTDATA');
  ht(99)=text(-0.05,12/n,infotext);
  infotext=sprintf('%6s','Power:');
  ht(1)=text(-0.05,10/n,infotext);
  infovalue=sprintf('%5.1f%2s',bb(1)*100,'%');
  ht(2)=text(0.5,10/n,infovalue);
  infotext=sprintf('%8s','HC-flow:');
  ht(3)=text(-0.05,9/n,infotext);
  infovalue=sprintf('%5i%5s',bb(2),'kg/s');
  ht(4)=text(0.5,9/n,infovalue);
  infotext=sprintf('%11s','Cr-pattern:');
  ht(5)=text(-0.05,8/n,infotext);
  infovalue=sprintf('%5i%2s',bb(65),'%');
  ht(6)=text(0.5,8/n,infovalue);
  infotext=sprintf('%14s','Temp. low. p.:');
  ht(7)=text(-0.05,7/n,infotext);
  infovalue=sprintf('%6.2f%2s',bb(10),'C');
  ht(8)=text(0.5,7/n,infovalue);
  infotext=sprintf('%13s','Aver. burnup:');
  ht(9)=text(-0.05,6/n,infotext);
  infovalue=sprintf('%7.1f%7s',bb(89),'MWd/TU');
  ht(10)=text(0.5,6/n,infovalue);
   infotext=sprintf('%11s','Aver. void:');
  ht(19)=text(-0.05,5/n,infotext);
  infovalue=sprintf('%5.2f%2s',hy(86)*100,'%');
  ht(20)=text(0.5,5/n,infovalue);
  infotext=sprintf('%6s','k-eff:');
  ht(21)=text(-0.05,4/n,infotext);
  infovalue=sprintf('%7.5f',bb(51));
  ht(22)=text(0.5,4/n,infovalue);

  infovalue=sprintf('%s','AVVIKELSER POLCA-UPDAT');
  ht(100)=text(-0.05,0/n,infovalue);
  infovalue=sprintf('%s',['BERAKNAT PA NOD 1:',num2str(size(tipdiff1,1))]);
  ht(100)=text(-0.05,-1/n,infovalue);
  set(ht(100),'fontsize',9);
  infovalue=sprintf('%10s%14s%11s','NOD','RADIELLT','AXIELLT');
  ht(101)=text(0.35,-2.5/n,infovalue);
  infovalue=sprintf('%s','ST.-DEV');
  ht(102)=text(-0.05,-3.25/n,infovalue);
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(1),dev(2),dev(3));
  ht(103)=text(0.4,-3.25/n,infovalue);
  infovalue=sprintf('%s','AV.-DEV');
  ht(104)=text(-0.05,-4/n,infovalue);
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(4),dev(5),dev(6));
  ht(105)=text(0.4,-4/n,infovalue);
  infovalue=sprintf('%s','MAX.-DEV');
  ht(106)=text(-0.05,-4.75/n,infovalue);
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(7),dev(8),dev(9));
  ht(107)=text(0.4,-4.75/n,infovalue);




 infotext=sprintf('%55s','POLCA');
  ht(150)=text(0.05,-8/n,infotext);
 infotext=sprintf('%55s','UPDAT');
  ht(151)=text(0.9,-8/n,infotext);


 infotext=sprintf('%8s','Min CPR:');
 cpr=readdist(filename,'cpr');
 mincpr=min(min(cpr));
 [nodal ch]=find(cpr==mincpr);
 ch=knum2cpos(ch,mminj);


  ht(11)=text(-0.05,-9/n,infotext);
  infovalue=sprintf('%5.3f',mincpr);
  ht(12)=text(0.9,-9/n,infovalue);
  infovalue=sprintf('%4i%4i',ch(1),ch(2));
  ht(35)=text(1.15,-9/n,infovalue);

 cprupd=readdist(filename,'cprupd');
  mincprupd=min(min(cprupd));
 [nodal ch]=find(cprupd==mincprupd);
 ch=knum2cpos(ch,mminj);
  infovalue=sprintf('%5.3f',mincprupd);
  ht(34)=text(1.75,-9/n,infovalue);
  infovalue=sprintf('%4i%4i',ch(1),ch(2));
  ht(36)=text(2.0,-9/n,infovalue);


  infotext=sprintf('%6s','Radiell formfaktor (F-rad):');
 power=readdist(filename,'power');
 [ch]=find(mean(power)==max(mean(power)));
 ch=knum2cpos(ch,mminj);
  ht(13)=text(-0.05,-10/n,infotext);
  infovalue=sprintf('%5.3f',bb(55));
  ht(14)=text(0.9,-10/n,infovalue);
  infovalue=sprintf('%4i%4i',ch(1),ch(2));
  ht(48)=text(1.15,-10/n,infovalue);

 powerupd=readdist(filename,'powupd');
 [ch]=find(mean(powerupd)==max(mean(powerupd)));
 ch=knum2cpos(ch,mminj);
  infovalue=sprintf('%5.3f',bb(55));
  ht(33)=text(1.75,-10/n,infovalue);
  infovalue=sprintf('%4i%4i',ch(1),ch(2));
  ht(49)=text(2.0,-10/n,infovalue);


  infotext=sprintf('%9s','Langdvarmebelastning (LHGR): ');
 lhgr=readdist(filename,'lhgr');
 maxlhgr=max(max(lhgr));
 [nodal ch]=find(lhgr==maxlhgr);
 ch=knum2cpos(ch,mminj);

  ht(15)=text(-0.05,-11/n,infotext);
  infovalue=sprintf('%4.1f',maxlhgr/1e3);
  ht(16)=text(0.9,-11/n,infovalue);
  infovalue=sprintf('%4i%4i%4i',ch(1),ch(2),nodal);
  ht(37)=text(1.15,-11/n,infovalue);

 lhgrupd=readdist(filename,'lhrupd');
  maxlhgrupd=max(max(lhgrupd));
 [nodal ch]=find(lhgrupd==maxlhgrupd);
 ch=knum2cpos(ch,mminj);
 infovalue=sprintf('%4.1f',maxlhgrupd/1e3);
  ht(26)=text(1.75,-11/n,infovalue);
  infovalue=sprintf('%4i%4i%4i%7s',ch(1),ch(2),nodal,' kW/m');
  ht(38)=text(2.0,-11/n,infovalue);


 infotext=sprintf('%9s','Loca-langdvarme (MAPLHGR): ');
 aplhgr=readdist(filename,'aplhgr');
 maxaplhgr=max(aplhgr);
 [ch]=find(aplhgr==maxaplhgr);
 ch=knum2cpos(ch,mminj);

  ht(28)=text(-0.05,-12/n,infotext);
  infovalue=sprintf('%4.1f',maxaplhgr/1e3);
  ht(29)=text(0.9,-12/n,infovalue);
  infovalue=sprintf('%4i%4i',ch(1),ch(2));
  ht(39)=text(1.15,-12/n,infovalue);

 aplhgrupd=readdist(filename,'alhupd');
 maxaplhgrupd=max(aplhgrupd);
 [ch]=find(aplhgrupd==maxaplhgrupd);
 ch=knum2cpos(ch,mminj);
 infovalue=sprintf('%4.1f',maxaplhgrupd/1e3);
  ht(30)=text(1.75,-12/n,infovalue);
  infovalue=sprintf('%4i%4i%10s',ch(1),ch(2),'        kW/m');
  ht(40)=text(2.0,-12/n,infovalue);



  infotext=sprintf('%10s','Ytvarmeflode (SHF) :');
 shf=readdist(filename,'shf');
 maxshf=max(max(shf));
 [nodal ch]=find(shf==maxshf);
 ch=knum2cpos(ch,mminj);

  ht(23)=text(-0.05,-13/n,infotext);
  infovalue=sprintf('%4.1f',maxshf/1e4);
  ht(24)=text(0.9,-13/n,infovalue);
  infovalue=sprintf('%4i%4i%4i',ch(1),ch(2),nodal);
  ht(41)=text(1.15,-13/n,infovalue);
 shfupd=readdist(filename,'shfupd');
 maxshfupd=max(max(shfupd));
 [nodal ch]=find(shfupd==maxshfupd);
 ch=knum2cpos(ch,mminj);

 infovalue=sprintf('%4.1f',maxshfupd/1e4);
  ht(25)=text(1.75,-13/n,infovalue);
  infovalue=sprintf('%4i%4i%4i%8s',ch(1),ch(2),nodal,'W/cm2');
  ht(42)=text(2.0,-13/n,infovalue);



  infotext=sprintf('%4s','Nodformfaktor (PPF) :');
 ppf=max(max(power));
 [nodal ch]=find(power==ppf);
 ch=knum2cpos(ch,mminj);

  ht(31)=text(-0.05,-14/n,infotext);
  infovalue=sprintf('%5.3f',ppf);
  ht(32)=text(0.9,-14/n,infovalue);

  infovalue=sprintf('%4i%4i%4i',ch(1),ch(2),nodal);
  ht(43)=text(1.15,-14/n,infovalue);
  ppfupd=max(max(powerupd));
[nodal ch]=find(powerupd==ppfupd);
 ch=knum2cpos(ch,mminj);
  infovalue=sprintf('%5.3f',ppfupd);
  ht(27)=text(1.75,-14/n,infovalue);
  infovalue=sprintf('%4i%4i%4i',ch(1),ch(2),nodal);
  ht(44)=text(2.0,-14/n,infovalue);


  marg=find(hy==hy(98));
 if hy(marg(1))==hy(95),sor='SHF';,end
 if hy(marg(1))==hy(96),sor='APLHGR';,end
 if hy(marg(1))==hy(97),sor='CPR';,end
  infotext=sprintf('%4s','Min marginal (%) :');
  ht(17)=text(-0.05,-15/n,infotext);
 margin=readdist(filename,'margin');
 minmargin=min(min(margin));
 [nodal ch]=find(margin==minmargin);
 ch=knum2cpos(ch,mminj);
  infovalue=sprintf('%5.3f',minmargin);
  ht(18)=text(0.9,-15/n,infovalue);

  infovalue=sprintf('%4i%4i%10s',ch(1),ch(2),sor);
  ht(45)=text(1.15,-15/n,infovalue);

  marg=find(fu==fu(46));
 marupd=readdist(filename,'marupd');
  minmarupd=min(min(marupd));
 [nodal ch]=find(marupd==minmarupd);
 ch=knum2cpos(ch,mminj);

 if fu(marg(1))==fu(43),sor='SHF';,end
 if fu(marg(1))==fu(44),sor='APLHGR';,end
 if fu(marg(1))==fu(45),sor='CPR';,end
  infovalue=sprintf('%5.3f',minmarupd);
  ht(46)=text(1.75,-15/n,infovalue);

  infovalue=sprintf('%4i%4i%10s',ch(1),ch(2),sor);
  ht(47)=text(2.0,-15/n,infovalue);

 % infovalue=sprintf('%5.3f',bb(56));
 % ht(27)=text(0.5,-15/n,infovalue);
 for ix=1:49
  set(ht(ix),'fontsize',8);
 end

 for ix=101:107
  set(ht(ix),'fontsize',6);
 end









  set(gca,'position',[0.11 0.72 0.3 0.2],'visible','off')
  p=2;
  h=subplot(m0,2,p);

% infotext=sprintf('%5s','TIP 2');
% ht(152)=text(1,2,infotext);

% infotext=sprintf('%5s','TIP 1');
% ht(153)=text(28,28,infotext);

% for ix=150:153
%  set(ht(ix),'fontsize',10);
% end

 [hsc ,hcont]=plotcont(h,mminj);
%   set(hsc,'linestyle',':');
  set(hsc,'visible','off');
  cpos=knum2cpos(detpos,mminj);
  aa=mminj(1); 
  aa2=mz(21)+2-aa;
  aa3=mz(21)+1;   
  x=[1 aa3 aa aa
     1 aa3 aa2 aa2];
  y=[aa aa aa3 1
     aa2 aa2 aa3 1];
  line(x,y,'color','white','Erasemode','none');
  axis([0 aa3 0 aa3]);
  axis('ij');
  %cc=[3 7 7 14 14 11 11]; 
  %dd=[22 22 18 18 14 14 18];
  %line(cc,dd);
  %cc=[29 27 27 14];
  %dd=[11 11 14 14];
  %line(cc,dd);

  set(gca,'position',[0.46 0.62 0.47 0.34],'visible','off')
  for ii=1:ld
    ht=text(cpos(ii,2)+0.5,cpos(ii,1)-0.5,num2str(ii));
    set(ht,'fontname','helvetica-narrow-oblique');
    set(ht,'fontsize',7);
    temp(ii)=length(num2str(round(mean(tipdiff1(:,ii)))));
    if temp(ii)==2
      diffnum(ii,:)=num2str(round(mean(tipdiff1(:,ii))));
    elseif size(num2str(round(mean(tipdiff1(:,ii)))),2)==1
      diffnum(ii,:)=[' ',num2str(round(mean(tipdiff1(:,ii))))];
    end
  end

  htip(:)=text(cpos(:,2),cpos(:,1)+1,diffnum);
  set(htip,'fontsize',10);
  for ii=1:size(htip)
%    set(htip(ii),'color',sub(tipinfo2(ii)));
    set(htip(ii),'color',sub(tipnr(ii)));
%    ht(:)=text(cpos(ii,2),cpos(ii,1)-1,num2str(ii));
%    set(ht,'fontsize',8);
  end
  p=p+1;
  subplot(m0,2,p);
  hold on
  meangam=(mean(tipgam')');
  meantip=(mean(tipmea')');
eva=['yval=1:',num2str(size(meangam,1)),';'];
eval(eva);
  plot(meangam,yval,'--');
  plot(meantip,yval);

  axis([0 200 1 25]);
  set(gca,'position',[0.11 0.11 0.35 0.3]);
      inf=['filename: ',filename];
      ht=text('string',inf,'position',[0.05 -0.33],'units','normalized');
    set(ht,'fontsize',9);

        text('string','--- POLCA','position',[0.05 -0.2],'units','normalized');
        text('string','____','position',[0.7 -0.16],'units','normalized');
        text('string',' TIP','position',[0.9 -0.2],'units','normalized');
        text('string','POLCA - TIP','position',...
[1.4 -0.2],'units','normalized');


  infotext=sprintf('%4s','TOP');
  ht(48)=text(1.1,1,infotext,'units','normalized');
  infotext=sprintf('%4s','BOTTEN');
  ht(49)=text(1.1,0,infotext,'units','normalized');
  infotext=sprintf('%4s','NOD');
  ht(50)=text(1.15,0.4,infotext,'rotation',90,'units','normalized');

 for ix=48:50
  set(ht(ix),'fontsize',8);
 end
  grid;
  xt=0:50:200;
  set(gca,'xtick',xt);
  p=p+1;
  subplot(m0,2,p);
hold on
  meandiff=(mean(tipdiff1')');
  plot(meandiff,yval);
  grid;
  axis([-15 15 1 25]);
  xt=-15:5:15;
  set(gca,'position',[0.58 0.11 0.35 0.3])

  set(gca,'xtick',xt);
  line([0 0],[1 25]);


% NY SIDA

        figure('position',pos);
        set(gcf,'papertype','A4');
        set(gcf,'paperpos',[0.25 .5 7.75 11]);
        pp=[0 0 50 30];
        uicontrol('style','Pushbutton','position',pp,...
       'callback','printer','string','print');
        pos(1)=pos(1)+300;
        p=0;
end   % end flag~=1

  if nargin==2
      p=p+1;
      subplot(m0,2,p);
      hold on

      plot(tipgamtemp(:,i),yval,'--');
      plot(tipmeatemp(:,i),yval);
      axis([0 200 1 25]);
      grid;
      xt=0:50:200;
      set(gca,'xtick',xt);
      p=p+1;
      subplot(m0,2,p);
      plot(tipdiff(:,i),yval);
      axis([-15 15 1 25]);
      xt=-15:5:15;
      line([0 0],[1 25]);
      grid;
%      xlabel(' ');
%      ylabel('  ');
%      xt=get(gca,'Xtick');
%      xt=xt(find(xt-floor(xt)==0));
      set(gca,'xtick',xt);
      title(['TIP ',num2str(nr)]);
      set(gca,'fontsize',8)
%tx=text('string',rubrik,'position',[0.9,0.05],'color','white','units','normalized',...
%'fontsize',8); 
 else
  p=2;
  h=subplot(m0,2,p);

 [hsc ,hcont]=plotcont(h,mminj);

  set(hcont,'linestyle',':');
  set(hsc,'visible','off');
  cpos=knum2cpos(detpos,mminj);
  aa=mminj(1); 
  aa2=mz(21)+2-aa;
  aa3=mz(21)+1;   
  x=[1 aa3 aa aa
     1 aa3 aa2 aa2];
  y=[aa aa aa3 1
     aa2 aa2 aa3 1];
  hc=line(x,y,'color','white','Erasemode','none');
  set(hc,'linestyle',':');
  axis([0 aa3 0 aa3]);
  axis('ij');
%  cc=[3 7 7 14 14 11 11]; 
%  dd=[22 22 18 18 14 14 18];
%  hc=line(cc,dd);
%  set(hc,'linestyle',':');
%  cc=[29 27 27 14];
%  dd=[10 10 14 14];
%  hc=line(cc,dd);
%  set(hc,'linestyle',':');
set(gca,'position',[0.15 0.5 0.7 0.49],'visible','off','clipping','off')

%  set(gca,'position',[0.2 0.3 0.65 0.47],'visible','off')
dist=tipdiff1;
if size(dist,2)==mz(5)
  ddtest=zeros(size(dist,1),mz(22));
  ddtest(:,detpos)=dist;
  dist=ddtest;
end
[ikan]=detpos24(detpos,mminj);
for ind=1:length(detpos), mdist(:,ind)=sum(dist(:,ikan(ind,:))')';end
pmax=54;
%  a=find(tipinfo2==det(i));
  a=find(tipnr==det(i));
  dev1=stats((tipgam(yval,a)-tipmea(yval,a)));
  stadist=(tipdiff1(yval,:));
  mastd=(sqrt(sum(abs(tipdiff1.*tipdiff1))/size(tipdiff1,1)));
  maxstd=find(mastd==max(mastd));
  maxmean=find(abs(mean(stadist))==max(abs(mean(stadist))));
  maxnod=find(max(abs(stadist))==max(max(abs(stadist))));

  k=knum2cpos(detpos(maxstd),mminj);
  xx=k(2)-0.7;yy=k(1)+1.25;
  xf=[xx xx xx+0.7];
  yf=[yy yy-0.7 yy];
  patch(xf,yf,'m');
  k=knum2cpos(detpos(maxmean),mminj);

  xx=k(2)-0.7;yy=k(1)-0.25;
  xf=[xx xx xx+0.7];
  yf=[yy yy-0.85 yy-0.85];
  patch(xf,yf,'b');

  k=knum2cpos(detpos(maxnod),mminj);
  xx=k(2)+1.55;yy=k(1)-0.25;
  xf=[xx xx-0.7 xx];
  yf=[yy yy-0.85 yy-0.85];
  patch(xf,yf,'r');

%*******************
%  a=find(tipinfo2==det(i+1));
  a=find(tipnr==det(i+1));
  [dev2 pos]=stats((tipgam(yval,a)-tipmea(yval,a)));

detpos4=detpos24(detpos,mminj);
ikan=filtcr(konrod,mminj,0,100);

for ind=1:length(detpos)
  k=knum2cpos(detpos(ind),mminj);
  xx=k(2);yy=k(1)+1;

  y=(yy+0.25:-2.05/(size(tipdiff1,1)-1):yy-1.8);
%  y=(yy+0.25:-2.25/25-1):yy-2);
  ht=text(xx,yy-2.5,sprintf('%2i',ind));
  set(ht,'fontsize',8);
  hh=[xx-0.7 xx-0.7 xx+1.55 xx+1.55 xx-0.7];
  vv=[y(1),yy-2.1,yy-2.1,y(1),y(1)];
%  vv=[y(1),y(size(y,2)),y(size(y,2)),y(1),y(1)];
  h(ind)=line(xx+0.3+mdist(:,ind)/pmax*2,y,'color','white');
  hr(ind)=line(hh,vv,'color','white');
  xd=[xx xx];
  yd=[yy+0.15 yy+0.35];
  line(xd+0.425,yd);
  yd=[yy-1.85 yy-2.15];
  line(xd+0.425,yd);
%***********cr***********
      crindex=zeros(1,4);
      nnr=0;
%      sca=axis;
      for tt=1:4
        [crindex(tt) jind]=find(ikan==detpos4(ind,tt));
        if size(crindex,2)>=tt,
          if crindex(tt)>0,
           if konrod(crindex(tt))<1000,
             nnr=nnr+1;
             ett=ones(size(nnr,1));
             crxx=xx+1.55-nnr*0.20;
%             crxx=crxx.*sca(2)/200;
             crxx=[crxx; crxx];
             cryy=y(1);
             cryy=[cryy; y(1)-(1-konrod(crindex(tt))/1000)'*2.35];
             crll=line(crxx,cryy);
             set(crll,'linewidth',0.5);
           end
          end
        end
      end
%****end cr*******
end

  ht=text(xx-12.5,yy+3,'-15');
  set(ht,'fontsize',6);
  ht=text(xx-16.5,yy+3,'+15');
  set(ht,'fontsize',6);
  inf=['max av.dev LPRM ',sprintf('%2i%s%4.1f',maxmean,' = ',max(abs(mean(stadist))))];
  ht=text(28.2,28.5,inf);
  set(ht,'fontsize',6);
  inf=['max maxdev LPRM ',sprintf('%2i%s%4.1f',maxnod,' = ',max(max(abs(stadist))))];
  ht=text(28.2,26.5,inf);
  set(ht,'fontsize',6);
  inf=['max std.dev LPRM ',sprintf('%2i%s%4.1f',maxstd,' = ',max(std(stadist)))];
  ht=text(28.2,30.5,inf);
  set(ht,'fontsize',6);

  xd=[xx xx];
  yd=[yy-2.2 yy-2.4];
  line(xd+0.3-14,yd);
  yd=[yy+1.95 yy+2.25];
  line(xd+0.3-14,yd);

  xf=[27 28 28];
  yf=[26 27 26];
  patch(xf,yf,'r');
  xf=[27 27 28];
  yf=[29 28 28];
  patch(xf,yf,'b');
  xf=[27 27 28];
  yf=[31 30 31];
  patch(xf,yf,'m');


  hh=[xx-1.7 xx-1.7 xx+2.3 xx+2.3 xx-1.7];
  vv=[y(1)-2.8,y(size(y,2))+3.8,y(size(y,2))+3.8,y(1)-2.8,y(1)-2.8];
  y=(yy+2:-4/(size(tipdiff1,1)-1):yy-2);
h(37)=line(xx+0.3-14+mean(mdist')/pmax*6,y,'color','white');

%h(37)=line(xx+0.3+12+mdist(:,ind)/pmax*2,y,'color','white');
  hr(ind)=line(hh-14,vv,'color','white');
  line([xx-12 xx-12],[y(1) y(1)-1.2]);
  ht=text(5,30.5,'styrstavar');
  set(ht,'fontsize',6);

  for ii=1:size(htip)
%    set(htip(ii),'color',sub(tipinfo2(ii)));
    set(htip(ii),'color',sub(tipnr(ii)));
  end

      p=p+1;
      subplot(m0,2,p);
      hold on

      plot(tipdiff(yval,i),yval);
      axis([-15 15 1 25]);
      xt=-15:5:15;
      line([0 0],[1 25]);
      grid;
      set(gca,'xtick',xt);
      title(['TIP ',num2str(nr)]);
      set(gca,'fontsize',8) 
      inf=['filename: ',filename];
     set(gca,'position',[0.11 0.1 0.35 0.25])
        ht=text('string',inf,'position',[0.05 -0.35],'units','normalized');
       set(ht,'fontsize',9);
        text('string','--- POLCA','position',[0.05 -0.2],'units','normalized');
        text('string','____','position',[0.7 -0.16],'units','normalized');
        text('string',' TIP','position',[0.9 -0.2],'units','normalized');
        text('string','POLCA - TIP','position',...
[1.4 -0.2],'units','normalized');


  infotext=sprintf('%4s','TOP');
  ht(48)=text(1.1,1,infotext,'units','normalized');
  infotext=sprintf('%4s','BOTTEN');
  ht(49)=text(1.1,0,infotext,'units','normalized');
  infotext=sprintf('%4s','NOD');
  ht(50)=text(1.15,0.4,infotext,'rotation',90,'units','normalized');


% a=find(tipinfo2==det(i));
 a=find(tipnr==det(i));
[tipmeax,deltax(i)] =polytest(tipgam(:,a),tipmea(:,a),[yval]',[2:5]);
 title(['TIP ',num2str(i)]);
 n=0.95;
  infovalue=sprintf('%s%s','AVVIKELSER POLCA-UPDAT ',['TIP ',num2str(nr)]);
  ht(100)=text(-0.05,1.40/n,infovalue,'units','normalized');

  infovalue=sprintf('%10s%14s%11s','NOD','RADIELLT','AXIELLT');
  ht(101)=text(0.35,1.34/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','ST.-DEV');
  ht(102)=text(-0.05,1.31/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev1(1),dev1(2),dev1(3));
  ht(103)=text(0.4,1.31/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','AV.-DEV');
  ht(104)=text(-0.05,1.28/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev1(4),dev1(5),dev1(6));
  ht(105)=text(0.4,1.28/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','MAX.-DEV');
  ht(106)=text(-0.05,1.25/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev1(7),dev1(8),dev1(9));
  ht(107)=text(0.4,1.25/n,infovalue,'units','normalized');
  for ix=48:50
   set(ht(ix),'fontsize',8);
  end
  for ix=100:107
    set(ht(ix),'fontsize',6);
  end
  condit=dev1(1);
  dev=stats((tipgam(yval,a)-tipmeax(yval,:)));
if (condit>dev(1))&(abs(deltax(i))>0.065)
  infovalue=sprintf('%s%5.3f%s','Axial misalignment ',deltax(i)*14.72,' cm');
  ht(108)=text(-0.05,1.19/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','ST.-DEV');
  ht(102)=text(-0.05,1.15/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(1),dev(2),dev(3));
  ht(103)=text(0.4,1.15/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','AV.-DEV');
  ht(104)=text(-0.05,1.12/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(4),dev(5),dev(6));
  ht(105)=text(0.4,1.12/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','MAX.-DEV');
  ht(106)=text(-0.05,1.09/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(7),dev(8),dev(9));
  ht(107)=text(0.4,1.09/n,infovalue,'units','normalized');
  for ix=100:108
    set(ht(ix),'fontsize',6);
  end
end


      p=p+1;
      subplot(m0,2,p);
      hold on
      plot(tipdiff(yval,i+1),yval);
      axis([-15 15 1 25]);
      xt=-15:5:15;
      line([0 0],[1 25]);
      grid;
      set(gca,'xtick',xt);
      title(['TIP ',num2str(nr+1)]);
      set(gca,'fontsize',8)
  set(gca,'position',[0.58 0.1 0.35 0.25])

% a=find(tipinfo2==det(i+1));
 a=find(tipnr==det(i+1));
[tipmeax,deltax(i+1)] =polytest(tipgam(yval,a),tipmea(yval,a),[yval]',[2:5]);
 title(['TIP ',num2str(i+1)]);
  infovalue=sprintf('%s%s','AVVIKELSER POLCA-UPDAT ',['TIP ',num2str(i+1)]);
  ht(100)=text(0.05,1.40/n,infovalue,'units','normalized');

  infovalue=sprintf('%10s%14s%11s','NOD','RADIELLT','AXIELLT');
  ht(101)=text(0.35,1.34/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','ST.-DEV');
  ht(102)=text(0.05,1.31/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev2(1),dev2(2),dev2(3));
  ht(103)=text(0.4,1.31/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','AV.-DEV');
  ht(104)=text(0.05,1.28/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev2(4),dev2(5),dev2(6));
  ht(105)=text(0.4,1.28/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','MAX.-DEV');
  ht(106)=text(0.05,1.25/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev2(7),dev2(8),dev2(9));
  ht(107)=text(0.4,1.25/n,infovalue,'units','normalized');
  for ix=100:107
    set(ht(ix),'fontsize',6);
  end

condit=dev2(1);
dev=stats((tipgam(yval,a)-tipmeax(yval,:)));

if (condit>dev(1))&(abs(deltax(i+1))>0.065)
  infovalue=sprintf('%s%5.3f%s','Axial misalignment ',deltax(i+1)*14.72,' cm');
  ht(108)=text(0.05,1.19/n,infovalue,'units','normalized');

  infovalue=sprintf('%s','ST.-DEV');
  ht(102)=text(0.05,1.15/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(1),dev(2),dev(3));
  ht(103)=text(0.4,1.15/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','AV.-DEV');
  ht(104)=text(0.05,1.12/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(4),dev(5),dev(6));
  ht(105)=text(0.4,1.12/n,infovalue,'units','normalized');
  infovalue=sprintf('%s','MAX.-DEV');
  ht(106)=text(0.05,1.09/n,infovalue,'units','normalized');
  infovalue=sprintf('%7.1f%17.1f%17.1f',dev(7),dev(8),dev(9));
  ht(107)=text(0.4,1.09/n,infovalue,'units','normalized');
  for ix=100:108
    set(ht(ix),'fontsize',6);
  end
end


      break 
 end   
end
