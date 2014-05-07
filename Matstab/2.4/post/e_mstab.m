function [e_lp,e_fl]=e_mstab(efi,disfil,lpnr,axpos,eWl,flkpunkt);
% e_lp=e_mstab(efi,disfil,lpnr,axpos,eWl,flkpunkt);


neumodel=polca_version(disfil);
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist(disfil);
if staton(1)=='L' 
  if strcmp(computer,'PCWIN')
     MATLAB_HOME='d:/matlab/';
  else
     [tmp,MATLAB_HOME]=unix('echo $MATLAB_HOME');
  end
  MATLAB_HOME(end)=[];
  masfil=[MATLAB_HOME '/matstab/input/l/master.dat'];
end
axpos=5-axpos;
if strcmp(neumodel,'POLCA4'),
  nod=mast2mlab(masfil,29,'F');
elseif strcmp(neumodel,'POLCA7'),
  nod=[3.5 9.25 15 21]';  %Hardcoded should be with appropriate mast2mlab7-call
end
knw=detpos(lpnr);
ijnw=knum2cpos(knw,mminj);
ijsw=ijnw;ijsw(:,1)=ijnw(:,1)+1;
ksw=cpos2knum(ijsw,mminj);
kn=[knw knw+1 ksw ksw+1];
for i=1:size(kn,1),
   nbot=ceil(nod(axpos(i)));
   wbot=1-(nod(axpos(i))-nbot);
   e_lp(i)=wbot*sum(efi(nbot,kn(i,:)))+(1-wbot)*sum(efi(nbot+1,kn(i,:)));
end

if nargout >1
  if staton(1)=='L'
    staton='l';
    e_fl=diag(eWl(ceil(nod(axpos)),detpos(lpnr))).';
  else
    [chnum,knam]=flopos(staton);
    ii=mbucatch(knam,flkpunkt);
    e_fl(ii)=eWl(1,chnum);
  end
end
%@(#)   e_mstab.m 1.3   03/08/26     08:02:09
