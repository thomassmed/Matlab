%@(#)   refumov7.m 1.1	 00/11/23     10:09:05
%
function refumov7(hObject,eventdata,hfig)
ox=[];oy=[];

hpar=get(hfig,'UserData');
figure(hpar)

refufile=get(findobj(hfig,'Tag','RefufileEdit'), 'String');

refu=load(refufile);

[d,mminj]=readdist7(refu.bocfile);
[right,left]=knumhalf(mminj);

sym=refu.symmetry;
oldc=refu.shuffles;

if size(oldc,1)>0
    ox=oldc(1,:);
    oy=oldc(2,:);
end

nr=1;
b=0;
hold on
while b~=3
  xx(1)=0;yy(1)=0;
  [x,y,b]=ginput(1);
  if b==1
    x=fix(x);
    y=fix(y);
    if ~isempty(find(left==cpos2knum(y,x,mminj))) & strcmp(sym,'3')
      yx=knum2cpos(right(find(left==cpos2knum(y,x,mminj))),mminj);
      y=yx(1);x=yx(2);
    end
    nr=nr+1;
    xx(nr)=x;
    yy(nr)=y;
    ht(nr-1)=text(x,y+.5,sprintf('%2i',nr-1),'fontsize',10,'color',[1 1 1],'erasemode','none');
    if sym=='3'
      yx=knum2cpos(left(find(right==cpos2knum(y,x,mminj))),mminj);
      y=yx(1);x=yx(2);
      hs(nr-1)=text(x,y+.5,sprintf('%2i',nr-1),'fontsize',10,'color',[1 1 1],'erasemode','none');
    end
  end
  if b==2
    for i=1:nr-1
      set(ht(i),'erasemode','normal')
      delete(ht(i))
      set(hs(i),'erasemode','normal')
      delete(hs(i))
    end
    xx=[];yy=[];nr=1;
  end
end
if length(xx)==1,xx=[];yy=[];end
hold off

shuffles=[ox xx;oy yy];
save(refufile, '-append', 'shuffles');

update(hfig,[]);
