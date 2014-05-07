%@(#)   findreakdir.m 1.10	 99/11/23     13:56:08
%
%function reakdir=findreakdir
%Extracts '/cm/fx/' or '/p4/cm/fx/' from cwd
%
% Or reakdir=findreakdir(unit)
%
function reakdir=findreakdir(unit)

direc=pwd;

if nargin>0,
  if strcmp('p4',direc(2:3))
     reakdir=['/p4/cm/',lower(unit),'/'];
  elseif strcmp('cm',direc(2:3))
     reakdir=['/cm/',lower(unit),'/'];
  else
     reakdir=['/cm/',lower(unit),'/'];
     sprintf('You are not in a cm-tree, reakdir= %s',reakdir)
  end

else
  if strcmp('p4',direc(2:3)),
     i=findstr(direc,'/p4');
     direc=direc(i:length(direc));
     ii=find(direc=='/');
     if length(ii)==3,
       i=find(abs(direc)==10);direc(i)='';
       reakdir=[remblank(direc),'/'];
     else
       reakdir=direc(1:ii(4));
     end
  elseif strcmp('cm',direc(2:3))
     i=findstr(direc,'/cm');
     direc=direc(i:length(direc));
     ii=find(direc=='/');
     if length(ii)==2,
       i=find(abs(direc)==10);direc(i)='';
       reakdir=[remblank(direc),'/'];
     else
       reakdir=direc(1:ii(3));
     end
  else
     sprintf('You are not in a cm-tree, reakdir= ')
  end

end
