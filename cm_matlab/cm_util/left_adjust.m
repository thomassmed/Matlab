%@(#)   left_adjust.m 1.1	 06/02/02     12:30:58
%
%function new_name=right_adjust(old_name);
%
% left adjusts old_name so that leading blanks
% becomes trailing blanks
function new_name=left_adjust(old_name);
[l,w]=size(old_name);
new_name=char(32*ones(l,w));
for i=1:l,
  temp_name=remblank(old_name(i,:));
  new_name(i,1:length(temp_name))=temp_name;
end
