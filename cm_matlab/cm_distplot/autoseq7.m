%@(#)   autoseq7.m 1.3	 07/03/09     10:16:27
%
function autoseq7
load sim/simfile;
hval=get(gcf,'userdata');
s=size(filenames);
set(hval(30),'string',num2str(blist(1)));
for i=1:size(filenames,1)-1
  autok7;
  prestep7('fwd');
%  burstep7('fg');
end
autok7;
