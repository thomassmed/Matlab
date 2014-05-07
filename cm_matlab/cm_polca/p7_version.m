%@(#)   p7_version.m 1.1	 07/11/09     16:36:29
%
%function [prg,ver,rdate]=p7_version(distfil)
%
%Retreive POLCA version information & run-date
%
% M. Dahlfors 2007/11/09
function [prg,ver,rdate]=p7_version(distfil)
fid=fopen(distfil,'r','b');
a=fread(fid,50,'int');
if a(1)~=1
  fclose(fid);
  fid=fopen(distfil,'r','l');
  a=fread(fid,50,'int32');
end
if length(a)>49,
  if a(50)==12348,
    neumodel='POLCA4'
    return
  elseif a(50)==92348,
    neumodel='POLCA7';
  else
    neumodel='UNKNOWN'
    return
  end
else
  neumodel='UNKNOWN'
  return  
end
distlist=setstr(fread(fid,[8,a(46)]));
distlist=flipud(rot90(distlist));
fseek(fid,4*a(3)-4,-1);
iadr=fread(fid,3*a(46),'int32');
fseek(fid,4*(iadr(1)-1),-1);
fseek(fid,30*4,0);
prg=char(fread(fid,[1 12]));
ver=char(fread(fid,[1 8]));
rdate=char(fread(fid,[1 20]));
fclose(fid);
