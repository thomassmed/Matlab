function data=PickUpFull(TEXT,card,idim,jdim,stpt)
if nargin<4, jdim=idim;end
if isnumeric(card),
    ifind=card;
else
    ifind=find(~cellfun(@isempty,regexp(TEXT,['^',card])));
end
N=length(ifind);
if nargin<5,
    stpt=1:N;
else
    N=length(stpt);
end
data=cell(1,N);
coun=0;
for n=stpt,
    coun=coun+1;
    data{coun}=nan(idim,jdim);
    if length(ifind)<n,
        data{coun}=[];
    else
        for i=1:idim,
            data{coun}(i,:)=sscanf(TEXT{ifind(n)+i},'%g')';
        end
    end
end
if N==1, data=data{1};end