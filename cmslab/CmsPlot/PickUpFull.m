function data=PickUpFull(TEXT,card,idim,jdim,stpts)
if nargin<4, jdim=idim;end
ifind=find(~cellfun(@isempty,regexp(TEXT,['^',card])));

if nargin == 5 && length(ifind)>1
    N = length(stpts);
    ifind = ifind(stpts);
else
    N=length(ifind);
end
data=cell(1,N);
for n=1:N,
    data{n}=nan(idim,jdim);
    for i=1:idim,
        data{n}(i,:)=sscanf(TEXT{ifind(n)+i},'%g')';
    end
end
if length(data) == 1
    data = data{1};
end