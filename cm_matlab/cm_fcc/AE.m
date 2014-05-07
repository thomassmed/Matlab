%@(#)   ae.m 1.2	 94/08/12     12:14:54
%
function ae(fid)
if nargin==1,
  fprintf(fid,'%c',228);
else
  fprintf('%c',228);
end
