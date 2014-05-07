%@(#)   chaninfo.m 1.5	 05/12/08     10:46:54
%
function chaninfo
handles=get(gcf,'userdata');
hpl=handles(2);
distfile=setprop(5);
cminstr=setprop(7);
cmaxstr=setprop(8);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
epsi=1.0d-4*(cmax-cmin);
cmax=cmax+epsi;
cmin=cmin-epsi;
fprintf('\n%s\n\n','Left mouse button to select, right to quit');
%hinstr=text('String','left button to select','Position',[0.7 0.952],'color','black','units','normalized');
%hinstr1=text('String','right to quit','Position',[0.7 0.9765],'color','black','units','normalized');
button=1;
plmat=get(handles(3),'cdata');
fprintf('\n')
[burnup,mminj,d1,d2,d3,mz,d5,buntyp]=readdist7(distfile,'burnup');
vhist=readdist7(distfile,'dnshis');
sshist=readdist7(distfile,'crhis');
buidnt=readdist7(distfile,'asyid');
if size(buidnt,1)>1,buflag=1;else,buflag=0;buid='      ';end
if min(size(buidnt))==1, buidnt=zeros(mz(14),6);buidnt(1,:)='      ';end
if min(size(buntyp))==1, buntyp=zeros(mz(14),4);buntyp(1,:)='    ';end
ncol=get(handles(26),'userdata');
if cmin<=0,
  i=find(plmat==-1);
end
plmat=(cmax-cmin)/ncol*(plmat-2)+cmin;
if cmin<=0,
  plmat(i)=zeros(size(i));
end
i=0;
fprintf('%s','Asyid    Asytyp Burnup Dnshis Crhis   Pos.  Channel Ch(half) Plotvalue')
fprintf('\n')
while button==1
 [xx,yy,button]=ginput(1);
  if button==1
    i=i+1;
    if i>20,
      fprintf('\n')
      fprintf('%s','Asyid    Asytyp Burnup Dnshis Crhis   Pos.  Channel Ch(half) Plotvalue')
      fprintf('\n')
      i=0;
    end
    nx=fix(xx);
    ny=fix(yy);
    co=plmat(ny,nx);
    if abs(co)<epsi/2, co=0;end
    knum=cpos2knum(ny,nx,mminj);
    if knum==0
      fprintf('%s%2i%s%2i%s','(',ny,',',nx,') is outside core')
      fprintf('\n')
    else
      khalf=full2half(knum,mminj);
      bur=round(mean(burnup(:,knum)));
      vhi=mean(vhist(:,knum));
      shi=mean(sshist(:,knum));
      if buflag==1,
        buid=buidnt(knum,1:8);
      end
      bunt=buntyp(knum,:);      
      fprintf('%8s%6s%7i%8.2f%7.2f%s%2i%s%2i%s%5i%8i%10.4g',buid,bunt,bur,vhi,shi,'  (',ny,',',nx,')',knum,khalf,co);
      fprintf('\n')
    end
  end
end
disp(sprintf('\n'));
%delete(hinstr);
%delete(hinstr1);
