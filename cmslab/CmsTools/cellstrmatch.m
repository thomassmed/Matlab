function Index=cellstrmatch(str,DistNames,option)
% cellstrmatch - Finds strings in a cell array of strings
%
% Index=cellstrmatch(str,DistNames,option)
%
% Input
%   str - string to find (may be a cell array of strings)
%   DistNames - Cell array of strings (typically cmsinfo.DistNames)
%   option - 'exact' require exact string match, 'find' allows string to be
%            found also inside the string as opposed to starting the string
%
% Examples:
%  cmsinfo=read_cms('s3k-1.cms');
%  index=cellstrmatch('Transient',cmsinfo.DistNames)
%
% See also
%  read_cms, read_cms_dist

if nargin<3, option='all';end
%%
str=cellstr(str);
[id,jd]=size(DistNames);
index=cell(length(str),jd);
for j=1:jd,
    for i1=1:length(str)
        icount=0;
        clear ListNames
        for i=1:id,
            if ~isempty(DistNames{i,j}),
                icount=icount+1;
                ListNames{icount}=DistNames{i,j};
            end
        end
        if strcmpi(option,'exact'),
            index{i1,j}=find(strcmp(str{i1},ListNames));
        elseif strcmpi(option,'find')
            index{i1,j}=find(~cellfun(@isempty,strfind(ListNames,str{i1})));
        else
            index{i1,j}=find(strncmp(str{i1},ListNames,length(str{i1})));
        end
    end
end
[ii,ji]=size(index);
Index=cell(1,jd);
for j=1:ji,
    Index{j}=cat(1,index{:,j});
end
% if min(id,jd)==1,
%     Index=cell2mat(Index);
% end