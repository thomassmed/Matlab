%@(#)   right_adjust.m 1.1	 06/02/02     13:32:14
%
%function new_name=right_adjust(old_name);
%
% Right adjusts old_name so that trailing blanks
% becomes leading blanks
function new_name=right_adjust(old_name);
[l,w]=size(old_name);
new_name=char(32*ones(l,w));
for i=1:l,
  temp_name=remblank(old_name(i,:));
  new_name(i,w-length(temp_name)+1:w)=temp_name;
end
