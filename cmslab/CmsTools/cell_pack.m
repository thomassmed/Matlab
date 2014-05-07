function cell_out=cell_pack(cell_in)
% cell_pack - packs a cell array
i_c=[];
for i=1:length(cell_in)
    if ~isempty(cell_in{i}),
        i_c=[i_c i];
    end
end
for i=1:length(i_c),
    cell_out{i}=cell_in{i_c(i)};
end
if isempty(i_c)
    cell_out=[];
end