function exp2asc(data,prop,type,twofiles)
% exp2asc saves the given data to an ascii file
%
% exp2asc(data,prop,type,twofiles)
%
% Input
%   data        - the data wanted saved
%   prop        - property struct given by SavedataGUI
%   type        - if it is rawdata or plotdata
%   twofiles    - if both plot and rawdata is saved
% Output
%   file        - output file depending on user input
% 
% See also check_filenames_for_save, SavedataGUI, exp2xls

% convert single data to double
if strcmpi(class(data),'single')
    data = double(data);
end
% set the filename
filename = prop.filename;
if nargin == 4
    if strcmp(type,'raw')
        exten = '_raw.txt';
    else
        exten = '_plt.txt';
    end
else
    exten = '.txt';
end
    
% save data
if strcmp(type,'raw')
    if strcmp(prop.cordtyp,'pin') || strcmp(prop.cordtyp,'submesh')
        
        if strcmp(prop.cordtyp,'submesh')
            sizedat = size(prop.rawdata);
            data = reshape(data,sqrt(sizedat(1)),sqrt(sizedat(1)),sizedat(2));
            lngt = size(data,3);
        else
            lngt = size(prop.rawdata,3);
        end
        
        for i = 1:lngt
            dat = data(:,:,i);
            hetemp = i;
            if i == 1
                save([filename exten],'hetemp','-ascii');
            else
                save([filename exten],'hetemp','-ascii','-append');
            end
            save([filename exten],'dat','-ascii','-append');
        end
        return
    end
    
    
    
    if isfield(prop,'sym') && ~strcmpi(prop.sym,'full')
        data = data(:,1:length(prop.rawxlab));
    end
    
    if isfield(prop,'rawxlab') && ~isfield(prop,'plotxvar')
        if size(prop.rawxlab,2) ~= size(data,2)
            label = prop.rawxlab';
        else
            label = prop.rawxlab;
        end
        save([filename exten],'label','-ascii')
        save([filename exten],'data','-ascii','-append');
    elseif isfield(prop,'rawxlab') && isfield(prop,'plotxvar')
        label = reshape([prop.rawxlab prop.rawxlab]',length(prop.rawxlab)*2,1);
        if size(label,2) ~= size(data,2), label = label'; end
        save([filename exten],'label','-ascii')
        save([filename exten],'data','-ascii','-append');
    else
        save([filename exten],'data','-ascii')
    end
    
    
%     save('data.txt','asdf','-ascii');
% save('data.txt','plotdata','-ascii','-append');
else
    if isfield(prop,'plotxlab') && isfield(prop,'plotylab')
%         switch prop.cordtyp
%             case 'ij'
%                 sizedat = size(prop.plotdata);
%                 ylab = 1:sizedat(2);
%                 xlab = 1:sizedat(1);
%             case 'pltspc'
%                 xlab = prop.plotxlab;
%                 ylab = prop.plotylab;
%             case 'pltsc'
%                 xlab = prop.plotxlab;
%                 ylab = prop.plotylab;                
%             case 'pin'
%                 xlab = prop.plotxlab;
%                 ylab = flipud(prop.plotylab);
%         end
% if strcmp(prop.cordtyp,'submesh')
    
% TODO: check, wont write letters just numbers.
        sizedat = size(prop.plotdata);
        ylab = 1:sizedat(2);
        xlab = 1:sizedat(1);
        save([filename exten],'xlab','-ascii');
        save([filename exten],'ylab','-ascii','-append');
        save([filename exten],'data','-ascii','-append');
    elseif isfield(prop,'plotxlab') && ~isfield(prop,'plotxvar')
        if size(prop.plotxlab,2) ~= size(data,2)
            xlab = prop.plotxlab';
        else
            xlab = prop.plotxlab;
        end
        save([filename exten],'xlab','-ascii');
        save([filename exten],'data','-ascii','-append');
    elseif isfield(prop,'plotxlab') && isfield(prop,'plotxvar')
        label = reshape([prop.plotxlab prop.plotxlab]',1,length(prop.plotxlab)*2);
        save([filename exten],'label','-ascii')
        save([filename exten],'data','-ascii','-append');
    else
        save([filename exten],'data','-ascii');
    end
    
end

end