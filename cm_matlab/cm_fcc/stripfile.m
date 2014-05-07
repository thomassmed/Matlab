%@(#)   stripfile.m 1.3	 04/10/01     12:27:34
%
function file=stripfile(distfile)
id =find(distfile=='/');
lid=length(id);
if lid>0,
  file=distfile(id(lid)+1:length(distfile));
else
  file=distfile;
end
