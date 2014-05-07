function recordpos = GetLabelPosFromBin(fid,Labels)
% GetLabelPosFromBin  Search a binary file and finds the positions of the
% given Labels. Used by ReadRestartBin.
%
% recordpos = GetLabelPosFromBin(fid,Labels);
%
% Input
%   fid         - file identifier 
%   Labels      - cell array with strings of the Labels wanted to be found
%   
% Outputart file
%   recordpos   - Structure with the Labels and the positions where they
%                 are found
%
% Example:
%
% Labels = {'Title', 'Parameters'};
% fid = fopen(restart_file,'r','ieee-be');
% recordpos = GetLabelPosRfromBin(fid,Labels);
%
% See also ReadRestartBin, GetNextRecord


%% finding positions
fseek(fid,0,1);
neof=ftell(fid);
fseek(fid,0,-1);
search_range = 5000000;
% search_str=fread(fid,5000000,'uint8=>char')';
% realposreg = regexp(search_str, Labels, 'start');
posreg = cell(1,length(Labels));
% fseek(fid,0,-1);
offset = 0;
while ftell(fid)<neof
    search_str=fread(fid,search_range,'uint8=>char')';
    posregp = regexp(search_str, Labels, 'start');
    for i = 1:length(Labels)
        if ~isempty(posregp{i})
            if isempty(posreg{i})
                posreg{i} = posregp{i} + offset; 
            else
                posreg{i} = [posreg{i} posregp{i}+offset] ;
            end
        end
    end
    offset = offset + search_range;
end



testvec = cellfun('isempty',posreg);
if isequal(unique(testvec),[0 1]) || isequal(unique(testvec),1) || cellfun('prodofsize', posreg(30)) ~= cellfun('prodofsize', posreg(31))
    posreg = cell(1,length(Labels));
    fseek(fid,0,-1);
    offset = 0;
    while ftell(fid)<neof
        search_str=fread(fid,10000000,'uint8=>char')';
        posregp = regexp(search_str, Labels, 'start');
        for i = 1:length(Labels)
            if ~isempty(posregp{i})
                if isempty(posreg{i})
                    posreg{i} = posregp{i} + offset; 
                else
                    posreg{i} = [posreg{i} posregp{i}+offset] ;
                end
            end
        end
    	offset = offset + search_range;
    end    
    if isequal(unique(testvec),[0 1]) || isequal(unique(testvec),1)
        next_record.comment='Label not found on restartfile';
        next_record.data=[];
        fseek(fid,0,-1);
        return;
    end
end
    
    
%% place absolut positions
for i = 1:length(Labels)
    recordpos.Label{i} = Labels(i);
    recordpos.abs_pos{i} = posreg{i}-9;
%     fseek(fid,recordpos.abs_pos{i},-1)
%     blk_size = fread(fid,1,'int');
%     fseek(fid,blk_size+4,0);
%     recordpos.blk_size{i} = fread(fid,1,'int');

end
recordpos.abs_pos{5} = recordpos.abs_pos{5}(1); 
recordpos.abs_pos{8} = recordpos.abs_pos{8}(1); 
fseek(fid,0,-1);

