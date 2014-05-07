%@(#)   charmatch.m 1.1	 08/03/26     16:08:12
%
function varargout = charmatch(str1,str2);

% index = charmatch(str1,str2);
%
% index innehåller vilka rader i den större sträng indatat som är 
% lika som i den mindre
%
% [ind1 ind2] = charmatch(str1,str2);
%
% Elementen ind1 innehåller raden i str2 som är samma som raden i str1
%
% 

svar1 = zeros(size(str1,1),1);
svar2 = zeros(size(str2,1),1);

langst1 = length(svar1) > length(svar2);


if langst1
  for ind = 1:length(svar2)
    temp = strmatch(str2(ind,:),str1);
    if temp
      if length(temp) > 1
        error(sprintf(['Strängen på rad %d i inargument 2 förekommer flera ' ...
                       'gånger i inargument 1'],ind));
      end
      svar2(ind) = temp;
      svar1(temp) = ind;
    end
  end
else
  for ind = 1:length(svar1)
    temp = strmatch(str1(ind,:),str2);
    if temp
      if length(temp) > 1
        error(sprintf(['Strängen på rad %d i inargument 1 förekommer flera ' ...
                       'gånger i inargument 2'],ind));
      end
      svar1(ind) = temp;
      svar2(temp) = ind;
    end
  end
end

if nargout == 0
  if langst1
    svar = svar2
  else
    svar = svar1
  end
  return
elseif nargout == 1
  if langst1
    varargout{1} = svar2;
  else
    varargout{1} = svar1;
  end
  return
elseif nargout == 2
  varargout{1} = svar1;
  varargout{2} = svar2;
  return;
else
  error('För många svarsargument.')
end


