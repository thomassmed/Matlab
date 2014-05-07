%@(#)   findtestdir.m 1.2	 06/03/22     09:31:56
%
%For test directories with one extra level, cf. findreakdir
%(No P4 functionality)
%
%function testdir=findtestdir
%Extracts '/cm/yourdir/yoursubdir' from cwd
%
% Or testdir=findtestdir(unit)
%
function testdir=findtestdir(unit)

direc=pwd;

if nargin>0,
  if strcmp('cm',direc(2:3))
     testdir=['/cm/',lower(unit),'/'];
  else
     testdir=['/cm/',lower(unit),'/'];
     sprintf('You are not in a cm-tree, testdir= %s',testdir)
  end

else
  if strcmp('cm',direc(2:3))
     i=findstr(direc,'/cm');
     direc=direc(i:length(direc));
     ii=find(direc=='/');
     if length(ii)==3,
       i=find(abs(direc)==10);direc(i)='';
       testdir=[remblank(direc),'/'];
     elseif length(ii)>3
       testdir=direc(1:ii(4));
     else
       sprintf('You are not in a standard test-tree, dir= %s',direc)
     end
  else
     sprintf('You are not in a cm-tree, dir= %s',direc)
  end

end
