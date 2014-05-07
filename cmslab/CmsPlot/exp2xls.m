function exp2xls(data,prop,type)
% exp2xls saves the given data to an xls file
%
% exp2xls(data,prop,type)
%
% Input
%   data        - the data wanted saved
%   prop        - property struct given by SavedataGUI
%   type        - if it is rawdata or plotdata
% Output
%   file        - xls file
% 
% See also check_filenames_for_save, SavedataGUI, exp2asc

% turn the warning off each time a new sheet is added in excel
warning('off',  'MATLAB:xlswrite:AddSheet')
letstr = 'ABCDEFGH';
% save data
if strcmp(type,'raw')
    if strcmp(prop.cordtyp,'pin') || strcmp(prop.cordtyp,'submesh')
        sizedat = size(prop.rawdata);
        if strcmp(prop.cordtyp,'submesh')
            data = reshape(data,sqrt(sizedat(1)),sqrt(sizedat(1)),sizedat(2));
            sizedat = size(data);
        end
        %% TODO: take away this loop and create the matrix first and only use on xlswrite!!
        for i = 1:sizedat(3)
            xlswrite([prop.filename '.xls'],i,'rawdata',['A' num2str(1 + (i-1)*sizedat(1))])
            xlswrite([prop.filename '.xls'],data(:,:,i),'rawdata',['B' num2str(1 + (i-1)*sizedat(1))]);
        
        end
        return
    end
    if strcmp(prop.cordtyp,'submesh')
        sizedat = size(prop.rawdata);
        
        for i = 1:sizedat(3)
            xlswrite([prop.filename '.xls'],i,'rawdata',['A' num2str(1 + (i-1)*sizedat(1))])
            xlswrite([prop.filename '.xls'],data(:,:,i),'rawdata',['B' num2str(1 + (i-1)*sizedat(1))]);
        
        end
        return
    end
    
    
    
    if isfield(prop,'sym') && ~strcmpi(prop.sym,'full')
        data = data(:,1:length(prop.rawxlab));
    end
    if length(data) > 256, 
        rawdata = data'; 
        zlabs = prop.rawxlab;
        
        stpos = [letstr(size(prop.rawxlab,2)+1) '1'];
    else
        rawdata = data;
        zlabs = prop.rawxlab';
        stpos = ['A' num2str(size(prop.rawxlab,2)+1)];
    end
    if isfield(prop,'rawxlab') && ~isfield(prop,'plotxvar')
        xlswrite([prop.filename '.xls'],zlabs,'rawdata')
        xlswrite([prop.filename '.xls'],rawdata,'rawdata',stpos)
    elseif isfield(prop,'rawxlab') && isfield(prop,'plotxvar')
        if length(data) > 256,
            zlabs = reshape([zlabs zlabs]',length(zlabs)*2,1);
        else
            
        end
        xlswrite([prop.filename '.xls'],zlabs,'rawdata')
        xlswrite([prop.filename '.xls'],rawdata,'rawdata',stpos)
    else
        xlswrite([prop.filename '.xls'],rawdata)
    end
        
else
    if isfield(prop,'plotxlab') && isfield(prop,'plotylab')
        switch prop.cordtyp
            case 'ij'
                sizedat = size(prop.plotdata);
                ylab(:,1) = 1:sizedat(2);
                xlab = 1:sizedat(1);
            case 'pltspc'
                xlab = prop.plotxlab;
                ylab = prop.plotylab';
            case 'pltsc'
                xlab = prop.plotxlab;
                ylab = prop.plotylab';                
            case 'pin'
                xlab = prop.plotxlab;
                ylab = flipud(prop.plotylab');
            case 'submesh'
                for i = 1:prop.nsubs
                    xla(i,:) = prop.plotxlab; 
                    yla(i,:) = prop.plotylab;
                end
                xlab = reshape(xla,1,prop.nsubs*length(prop.plotxlab));
                
                ylab = reshape(yla,prop.nsubs*length(prop.plotylab),1);
                
        end
        xlswrite([prop.filename '.xls'],xlab,'plotdata','B1')
        xlswrite([prop.filename '.xls'],ylab,'plotdata','A2')
        xlswrite([prop.filename '.xls'],prop.plotdata,'plotdata','B2')
        
    elseif isfield(prop,'plotxlab') && ~isfield(prop,'plotxvar') 
        if length(data) > 256, 
            plotdata = data'; 
            zlabs = prop.plotxlab;
            stpos = 'B1';
        else
            plotdata = data;
            zlabs = prop.plotxlab';
            stpos = 'A2';
        end
            xlswrite([prop.filename '.xls'],zlabs,'plotdata');
            xlswrite([prop.filename '.xls'],plotdata,'plotdata',stpos);
    elseif isfield(prop,'plotxlab') && isfield(prop,'plotxvar')
        zlabs = reshape([prop.plotxlab prop.plotxlab]',1,length(prop.plotxlab)*2);
        
        xlswrite([prop.filename '.xls'],zlabs,'plotdata');
        xlswrite([prop.filename '.xls'],data,'plotdata','A2');
        
    else
        xlswrite([prop.filename '.xls'],data,'plotdata')
    end
end