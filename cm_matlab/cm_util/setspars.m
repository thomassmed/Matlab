%function A=setspars(Ain,i,j,x)
function A=setspars(Ain,i,j,x)
A=Ain;
for ii=1:length(x)
  A(i(ii),j(ii))=x(ii);
end
