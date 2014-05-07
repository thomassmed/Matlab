%@(#)   sme_oe.m 1.2	 04/09/01     12:09:35
%
function sme_oe(fid)
if nargin>0
  fprintf(fid,'%c',246);
else
  fprintf('%c',246);
end
