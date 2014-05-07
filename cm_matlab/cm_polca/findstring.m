%@(#)   findstring.m 1.2	 94/08/12     12:10:20
%
function vec=findstring(string,strvec)
[i,j]=size(strvec);
evstr=['string=sprintf(''%',num2str(j),'s'',string);'];
eval(evstr)
p=((j*2-2):-2:0)';
p=10.^p;
x=abs(string)*p;
x1=abs(strvec)*p;
vec=find(x==x1)';
