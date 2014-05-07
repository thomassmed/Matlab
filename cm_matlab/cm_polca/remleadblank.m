%@(#)   remleadblank.m 1.3	 97/08/13     10:24:09
%
function utstr=remleadblank(instr)
utstr=instr;
i=find(abs(utstr)==32);
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
