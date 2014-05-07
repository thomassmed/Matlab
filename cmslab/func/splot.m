function splot(s,th,text)
  
% splot(s,th,text)

if nargin<3,
  text=' ';
end
zpplot(th2zp(th),1);
xlabel(['Dr=' num2str(s(5)) '+-' num2str(s(13)) ' , fd=' num2str(s(9))]);
ylabel(text);
