%@(#)   getdisfil.m 1.3	 99/11/22     15:35:43
%
%function getdisfil
function getdisfil
[fil,pathname]=uigetfile('*.dat');
if isstr(fil)
  file=[pathname fil];
  h=get(gcf,'userdata');
  set(h(1),'string',file);
  opfile;
end
