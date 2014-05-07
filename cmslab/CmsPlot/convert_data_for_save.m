function outdata = convert_data_for_save(data,save_prop,type)


if isfield(save_prop,'plotxlab') && isfield(save_prop,'plotylab') && ~iscell(data)
    outdata = data;
    return
end
if save_prop.res5 == 0
    outdata = data;
    return
else
    if iscell(data)
        unileng = unique(cellfun(@length,data));
        datanum = length(data);
    else
        unileng = length(data);
        datanum = size(data,2);
        % sätta en längd på datan (som inte är antalet noder)..
    end
    if length(unileng) == 1 && unileng == save_prop.kmax 
        outdata = data;
        return
    end
    xdata = cellfun(@cumsum,save_prop.xvar,'uniformoutput',0);
    if strcmpi(type,'nocell') 
        if iscell(data)
            expandata = nan(max(unileng),2*datanum);
            for i = 1:datanum
                expandata(1:length(data{i}),2*i-1) = data{i};
                expandata(1:length(data{i}),2*i) = xdata{i};
            end
            outdata = expandata;
        else
            for i = 1:datanum
                expandata(:,2*i-1) = data(:,i);
                expandata(:,2*i) = xdata{1};
            end
            outdata = expandata;
        end
    else
        outdata = {data xdata};
    end
    
end



end