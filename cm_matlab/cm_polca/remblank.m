%@(#)   remblank.m 1.5	 97/12/29     10:48:12
%
function utfil=remblank(infil);
utfil=infil;
if ~isempty(utfil)
  i=find(abs(utfil)==32);utfil(i)='';
  if length(utfil)>0,i=find(abs(utfil)==0);utfil(i)='';end
end
