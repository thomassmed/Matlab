%function cyc=year2cyc(block,year)
%
% ex. c=year2cyc('f2','1996');
function cyc=year2cyc(block,year)
opfil=['/cm/' lower(block) '/fil/op-year.txt'];
script=['awk ''substr($2,5,2) == "' year(3:4) '" {print $3}'' ' opfil];
[status,cyc]=unix(script);
dcyc=[10 double(cyc)];
i=find(dcyc==10);
cyc=[];
for j=2:length(i)
  str=char(dcyc(i(j-1)+1:i(j)-1));
  cyc=str2mat(cyc,str);
end
cyc=cyc(2:size(cyc,1),:);
cyc=lower(cyc);
