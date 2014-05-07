% remove blanks from strings
%
% outstr=remblank(instr)
function utfil=remblank(infil)
utfil=infil;
if ~isempty(utfil)
  i=find(abs(utfil)==32);utfil(i)='';
  if ~isempty(utfil),i=find(abs(utfil)==0);utfil(i)='';end
end
