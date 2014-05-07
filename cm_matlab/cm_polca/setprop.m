%@(#)   setprop.m 1.2	 94/08/12     12:11:03
%
%function  ud=setprop(np,property)
% sets property np to property, property must be a string
% a setprop with no input arguments returns ud
% a setprop with one input argument returns that property
% a setprop; with no input AND no output arguments prints the setup for the current figure WITH NUMBER
%       Note the semicolon above
function  ud=setprop(np,property)
if nargin==0,
  handles=get(gcf,'userdata');
  hpl=handles(2); if gca~=hpl, axes(hpl);end
  ud=get(hpl,'userdata');
  if nargout==0,
    [iu,ju]=size(ud);
    for i=1:iu, nr(i,:)=[sprintf('%2i',i),': '];end
    dud=[nr ud];
    disp(['Current figure is Figure No.',num2str(gcf)]);
    disp(dud);
    ud=[];
  end
else
  handles=get(gcf,'userdata');
  hpl=handles(2); if gca~=hpl, axes(hpl);end
  ud=get(hpl,'userdata');
  if nargin>1,
    if ~isstr(property)
      disp('property must be a string');
    else
      [iu,ju]=size(ud);
      lp=length(property);
      if np==1,
        ud=str2mat(property,ud(np+1:iu,:));
      elseif np==iu
        ud=str2mat(ud(1:np-1,:),property);
      else
        ud=str2mat(ud(1:np-1,:),property,ud(np+1:iu,:));
      end
      set(hpl,'Userdata',ud);
      if np==5, set(handles(1),'string',property);end
    end
  else
    ud=ud(np,:);
    i=find(ud==' ');ud(i)='';
  end
end
