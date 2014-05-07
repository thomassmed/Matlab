function powut=caxinterp1(xpo,powin,xi,method)

if nargin<4, method='linear';end

dims=size(powin);
N=dims(3);
ptemp=nan(N,dims(1),dims(2));

for i=1:N
    ptemp(i,:,:)=powin(:,:,i);
end

ptemp1=interp1(xpo,ptemp,xi,method);
powut=nan(dims(1),dims(2),length(xi));

for i=1:length(xi)
    powut(:,:,i)=ptemp1(i,:,:);
end


end