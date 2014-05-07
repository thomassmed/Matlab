%function cyed7(par)
function cyed7(par)
cydist=['BURNUP  ';'POWER   ';'THMARG  ';'SDM     ';'SDM3D   ';...
        'LHGR    ';'LHGR_PEL';'APLHGR  ';'SHF     ';...
        'FL_LHGR1';'FL_LHGR2';'FL_LHGR3';'FL_APLHG';...
        'FL_SHF  ';'CPR     ';'FL_CPR  ';...
        'VOID    ';'CHFLOW  ';'FLWORI  ';'EFPH    '];
prevdist=['BURNUP  ';'EFPH    ';'KHOT    ';'SDM     ';'SDM3D   '];
load sim/simfile
hval=get(gcf,'userdata');
hpar=hval(length(hval));
efph=str2num(get(hval(6),'string'));
point=find(efph==blist);
if point==length(blist),point=point-1;end
if (par==6 | par==7 | par==9) & ~isempty(point)
  if par==7
    svalue=get(hval(7),'value');
    if svalue>(point-1)/(length(blist)-2)
      while svalue>(point-1)/(length(blist)-2),point=point+1;end
      svalue=(point-1)/(length(blist)-2);
      set(hval(6),'String',num2str(blist(point)));
      set(hval(7),'value',svalue);
    end
    if svalue<(point-1)/(length(blist)-2)
      while svalue<(point-1)/(length(blist)-2),point=point-1;end
      set(hval(6),'String',num2str(blist(point)));
      set(hval(7),'value',(point-1)/(length(blist)-2));
    end
  end
  v=get(hval(1),'value');
  list=get(hval(1),'string');
  defdist=list(v,:);
  [d,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist]=readdist7(filenames(point,:));
  distlist=[distlist;'SDM     ';'SDM3D   '];
  frad=bb(104);
  keff=bb(96);
  void=100*hy(134);
  if point>1
    [d,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,prevdistlist]=readdist7(filenames(point-1,:));
  else
    [d,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,prevdistlist]=readdist7(bocfile);
  end
  prevdistlist=[prevdistlist;'SDM     ';'SDM3D   '];
  burnup=bb(46);
  i=strmatch(defdist,prevdist);
%  if ~isempty(i),distlist=prevdistlist;end
  i=mbucatch(distlist,cydist);
  i=find(i);
  distlist=ascsort(distlist(i,:));
  set(hval(1),'string',distlist);
  v=strmatch(defdist,distlist);
  if isempty(v),v=1;end
  set(hval(1),'value',v);
  set(hval(2),'String',sprintf('Frad:%10.2f',frad));
  set(hval(3),'String',sprintf('keff:%10.5f',keff));
  set(hval(4),'String',sprintf('Void:%10.2f',void));
  set(hval(5),'String',sprintf('Burnup:%10.2f',burnup));
  set(hval(7),'value',(point-1)/(length(blist)-2));
  figure(hpar);
  if find(strmatch(defdist,prevdist))
    point=point-1;
  end
  if strcmp(defdist,'SDM     ') | strcmp(defdist,'SDM3D   ')
    setprop(5,sdmfiles(point+1,:));
  else
    if point>0,setprop(5,filenames(point,:));end
    if point==0,setprop(5,bocfile);end
  end
  init(defdist);
end
