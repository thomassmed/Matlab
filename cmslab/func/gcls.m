function l=gcl
% l=gcl
% Finds the lines in current axse
kids = get(gca,'Children');
j=0;
for i = 1:max(size(kids))
  if strcmp(get(kids(i),'Type'),'line')
    j=j+1;
    l(j,1)=kids(i);
  end
end
