%@(#)   karta.m 1.2	 08/04/23     07:59:14
%
%function [map, vec] = karta(vec, mminj)
%
%Kan även användas för styrstavskartor med crmminj
%Returnerar även vec utan onödigt många blanksteg

function [map, vec] = karta(vec, mminj)

if ~ischar(vec)
  vec = left_adjust(num2str(vec));
else
  for i = size(vec, 2):-1:1
    tom = find(vec(:,i) ~= ' ');
    if ~isempty(tom)
      break
    end
  end
  vec = vec(:,1:i);
end

map = [];
knum = 1;

for i = 1:length(mminj)
  n = 1;
  for j = 1:mminj(i) - 1
    for k = 1:size(vec,2)+1
      map(i, n) = abs(' ');
      n = n + 1;
    end
  end
  
  m = (mminj(i) - 1) * (size(vec,2) +1) + 1;
  
  for j = 1:length(mminj) - 2*(mminj(i) - 1)
    if m == (mminj(i) - 1) * (size(vec,2) +1) + 1
      map(i,m:m+size(vec,2)-1) = abs(vec(knum,:));
      m = m + size(vec,2);
    else
      map(i,m:m+size(vec,2)) = abs([' ' vec(knum,:)]);
      m = m + size(vec,2) + 1;
    end
    knum  = knum + 1;
  end

  n = m;
  for j = m:(size(vec,2) + 1) * length(mminj) - 1 
      map(i,n) = abs(' ');
      n = n + 1;
  end
  
  
  
end
    
map = char(map);
