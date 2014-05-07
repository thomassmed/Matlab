%@(#)   refundo7.m 1.5	 05/12/08     14:34:19
%
function refundo7
h=get(gcf,'userdata');
hpar=h(length(h));
set(h(13),'userdata',[])
set(h(14),'userdata',[])
set(h(15),'userdata',[])
set(h(16),'userdata',[])
figure(hpar)
eocfile=remblank(get(h(4),'string'));
[bocburn,mminj]=readdist7(setprop(5),'burnup');
eocbuid=readdist7(eocfile,'asyid');
bocbuid=readdist7(setprop(5),'asyid');
ccplot;
je=mbucatch(bocbuid,eocbuid);
jb=1:size(bocbuid,1);
j=find(je==jb');
if ~isempty(j),crosspos=knum2cpos(j,mminj);
  hcross=setcross(crosspos,[.5 .5 .5]);
end
pixpos=knum2cpos(find(max(bocburn)==0),mminj);
%if ~isempty(pixpos),setpix(pixpos,[.5 .5 .5]);end
if ~isempty(pixpos)
  for i=1:length(pixpos)
    p=pixpos(i,:);
    X=[p(2)+.4 p(2)+.6 p(2)+.6 p(2)+.4];
    Y=[p(1)+.4 p(1)+.4 p(1)+.6 p(1)+.6];
    patch(X,Y,'gre');
  end
end

optionfile=get(h(3),'string');
if ~isempty(optionfile)
  lostr=sprintf('%s%s','load ',optionfile);
  eval(lostr)
  if flag1~=[],setflag(knum2cpos(flag1,mminj),[1 1 1]);end
  if flag2~=[],setflag(knum2cpos(flag2,mminj),[0 0 0]);end
end
