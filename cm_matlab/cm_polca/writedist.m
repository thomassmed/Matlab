%@(#)   writedist.m 1.2	 94/08/12     12:11:12
%
%function ierr=writedist(distfile,distname,dist)
%
% Write distribution with name distname and value dist to
% distr. file distfile
%
%Example: writedist('dist-1','BURNUP',burn), where burn is a 25 by 700 matrix for F3
% Note: burn MUST NOT be a 700 by 25 matrix in this case
function ierr=writedist(distfile,distname,dist)
distfile=remblank(distfile);
if length(find(distfile=='.'))==0,
  distfile=[distfile,'.dat'];
end
if exist(distfile)~=2,
  disp(['File does not exist: ',distfile]) 
else
  distname=remblank(distname);
  distname=upper(distname);
  if isstr(dist)
     if strcmp(distname,'BUNTYP'),
       dist=[dist(:,1)' dist(:,2)' dist(:,3)' dist(:,4)'];
     else
       dist=[dist(:,1)' dist(:,2)' dist(:,3)' dist(:,4)' dist(:,5)' dist(:,6)'];
     end
  end
  ierr=mat2pol(distfile,distname,dist);
  if ierr==-1
    disp(' ');
    disp('Distribution does not exist in distr. file');
    disp('It is not possible to create new distr. from matlab, use poldis');
  end
end
