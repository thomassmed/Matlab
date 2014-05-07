function rows=split_rows(NameList,n)
if nargin<2, n=10;end
NameList=cellstr(NameList);

for i0=1:length(NameList),
    row=NameList{i0};
    row=char(row);
    spacerow=char(ones(1,n)*32);
    row(row==0)=[];
    restrow=row;
    max_i=0;
    for i=1:10,
        restrow=strtrim(restrow);
        if isempty(restrow), break;end
        if length(restrow)>(n+1)
            imax=min(n+1,length(restrow));
            ispace=findstr(restrow,' ');
            istop=ispace(max(find(ispace<(n+1))));
            if isempty(istop), istop=imax;end
            rowi=restrow(1:istop);
            restrow(1:istop)=[];
        else
            rowi=restrow;
            restrow=[];
        end
        rows{i,i0}=pad(rowi,spacerow);
        max_i=max(max_i,i);
        if isempty(restrow), break;end
    end
end
%% Fill in with space where it is empty
for i1=1:size(rows,1)
    for i2=1:size(rows,2)
        if isempty(rows{i1,i2})
            rows{i1,i2}=pad(' ',spacerow);
        end
    end
end

function row=pad(row,spacerow)
Temp{1}=row;
Temp{2}=spacerow;
TEMP=char(Temp);
row=TEMP(1,:);





