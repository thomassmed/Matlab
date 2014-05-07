function printp(fig,dev)
% printp(fig,dev)
% Följande kombinationer är möjliga
% printp, printp('simulinkfigur'), printp(gcf,'a32laser2')

if nargin<2,dev='a32laser3';end
if nargin<1,fig=gcf;end
tmpstr=[];
if isstr(fig),
  tmpstr = ['-s' fig];
else
  tmpstr = ['-f' num2str(fig)];
end
eval(['print -dps tmp ' tmpstr])
eval(['!lpr -P' dev ' tmp.ps'])
!rm tmp.ps
