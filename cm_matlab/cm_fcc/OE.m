%@(#)   OE.m 1.2	 94/08/12     12:14:49
%
function OE(fid)
if nargin>0,
  fprintf(fid,'%c',214);
else
  fprintf('%c',214);
end
