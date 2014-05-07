%@(#)   sdgraf.m 1.7	 04/12/21     07:52:06
%
%function sdgraf
function sdgraf
load sim/simfile
sf=max([size(bocfile,2) size(filenames,2)]);
f=setstr(32*ones(size(filenames,1),sf));
f(1,1:length(bocfile))=bocfile;
f(2:size(filenames,1)+1,1:size(filenames,2))=filenames;
f=f(1:size(f,1)-1,:);
limit=1.5*ones(1,size(f,1));
sdmplot(f,limit)
axis([blist(1) blist(end) 1 3])
