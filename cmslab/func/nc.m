function nc(fil)
% nc(fil)
% �ppnar matlabfil i nedit

if nargin>0
  tmp=which(fil);
  if ~isempty(tmp)
    fil=tmp;
  end
  unix(['nc ' fil]);
  
else
  unix('nc');
end
