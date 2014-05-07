function files=getfiles(filespec)
%
temp=dir(filespec);
files={temp(:).name};
