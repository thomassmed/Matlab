function y=loadcomtest(filename)

ds=ReadMatdataFil(filename);

if nargout==1,
    y=ds;
else
    fields = fieldnames(ds);
    for i = 1:length(fields);
        assignin('base',fields{i},getfield(ds,fields{i}));
    end
end