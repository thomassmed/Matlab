% Removes leading blank and commas in a string
%
%utstr=remleadblank_comma.m(instr)
%
%
function utstr=remleadblank_comma(instr)
utstr=instr;
i=find(abs(utstr)==32|abs(utstr)==44);
if length(i)>0,
  if i(1)==1,
    if length(i)==1,
      utstr(1)='';
    else
      l=min(find(diff(i)>1));
      if length(l)>0,
        utstr(1:l)='';
      else
        utstr(1:length(i))='';
      end
    end
  end
end
