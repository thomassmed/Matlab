%@(#)   countsky.m 1.2	 06/06/09     09:58:35
%
%function countsky(bocfile,eocfile)
%
% Input: bocfile - boc-file of new cycle        default='dist/boc.dat'
%        eocfile - eoc-file of preceding cycle  default='dist/eoc.dat'
%
% NB! Only for counting CR operations. The need for this function arose 
% due to a bug in the SKYFFEL module of POLCA7 4.5.0.1. Therefore fuel 
% assembly operation counting is not included in this version.
% If there would be need for such an implementation please contact
% dal@forsmark.vattenfall.se
%
function countsky(bocfile,eocfile)
if nargin<2,
  eocfile=['dist/eoc.dat'];
  disp(['EOC file: ',eocfile])
end
if nargin<1,
  bocfile=['dist/boc.dat'];
  disp(['BOC file: ',bocfile])
end
%set(gcf,'pointer','watch')
%h=get(gcf,'userdata');
%hpar=h(length(h));
%hus=get(hpar,'userdata');
%ud=get(hus(2),'userdata');
%bocfile=remblank(ud(5,:));
%eocfile=remblank(get(h(4),'string'));
%clear h hpar hus ud
%
[eocbuid,mminj,konrod,bb,hy,mz,ks,eocbunt]=readdist7(eocfile,'crid');
eocdepl=readdist7(eocfile,'crdepl');
eocburn=sum(eocdepl)/25;
[bocbuid,mminj,konrod,bb,hy,mz,ks,bocbunt]=readdist7(bocfile,'crid');
bocdepl=readdist7(bocfile,'crdepl');
bocburn=sum(bocdepl)/25;
je=mbucatch(bocbuid,eocbuid);
jb=1:size(bocbuid,1);
numfr=length(find(bocburn==0));
numre=length(find(je==0))-numfr;
nummo=length(find((je==jb')==0))-numfr-numre;
disp(sprintf('\n%s %3i','Fresh:',numfr))
disp(sprintf('%s %3i','Unshuffled:',length(bocburn)-nummo-numfr-numre))
disp(sprintf('%s %3i','Shuffled:',nummo))
disp(sprintf('%s %3i','Reinserted:',numre))
disp(sprintf('%s %3i','Discharged:',numre+numfr))
%j=mbucatch(eocbuid,bocbuid);
%d=find(j==0);
%if length(d)>0,

