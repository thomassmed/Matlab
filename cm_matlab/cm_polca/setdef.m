%@(#)   setdef.m 1.2	 94/08/12     12:10:59
%
%function  defa=setdef(np,property,defa)
% sets property np to property, property must be a string
function  utdef=setdef(np,property,defa)
if nargin<3,
  disp('Number of input arguments must be 3');
else
  if nargin>1,
    if ~isstr(property)
      disp('property must be a string');
    else
      [iu,ju]=size(defa);
      lp=length(property);
      if np==1,
        utdef=str2mat(property,defa(np+1:iu,:));
      elseif np==iu
        utdef=str2mat(defa(1:np-1,:),property);
      else
        utdef=str2mat(defa(1:np-1,:),property,defa(np+1:iu,:));
      end
    end
  else
    defa=defa(np,:);
    i=find(defa==' ');defa(i)='';
    i=find(abs(defa)==0);defa(i)='';
  end
end
