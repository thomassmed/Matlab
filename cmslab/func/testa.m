function testa(ds)

fields = fieldnames(ds);
for i = 1:length(fields);
    assignin('base',fields{i},getfield(ds,fields{i}));
end