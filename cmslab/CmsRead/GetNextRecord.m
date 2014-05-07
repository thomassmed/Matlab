function next_record=GetNextRecord(varargin)
% Used by GetResData
%
%   next_record=GetNextRecord(fid,label,search_range,FORMAT,nr,loop)
i_int=4;ifloat=4;
fid=varargin{1};
pos_record = varargin{2};
recnum = varargin{3};
Format=varargin{4};
nr = varargin{5};
if length(varargin)<6
    loop = 0;
else
    loop = 1;
end
label = char(pos_record.Label{recnum});
if iscell(pos_record.abs_pos)
    abpos = pos_record.abs_pos{recnum};
elseif strcmp(class(pos_record.abs_pos),'double')
    abpos = pos_record.abs_pos(recnum);
end
old_pos=ftell(fid);

%%
next_record.label=label;
if loop == 0
    ifind = abpos;
else
    ifind = ftell(fid);
end
next_record.abs_pos=ifind(1);
fseek(fid,next_record.abs_pos,-1);
new_pos=ftell(fid);
next_record.rel_pos=next_record.abs_pos-old_pos;
next_record.old_pos=old_pos;
blk_size=fread(fid,1,'int');
fseek(fid,blk_size+i_int,0);
next_record.blk_size=fread(fid,1,'int');
next_record.data_pos=ftell(fid);
if length(varargin)>3,
    Format=varargin{4};
    [iblk,jblk]=size(Format);
    next_record.data=cell(iblk,jblk);
    if length(varargin)==4,
        nr{iblk,jblk}=1;
    else
        nr=varargin{5};
        if numel(nr)~=numel(Format),
            nr{iblk,jblk}=1;
        end
    end
    fseek(fid,-i_int,0);
    for j=1:jblk,
        blk_size=fread(fid,1,'int');
        cur_pos=ftell(fid);
        for i=1:iblk,
            if ~isempty(Format{i,j}),
                form=char(Format(i,j));
                if isempty(nr{i,j}), 
                    nrr=1; 
                else
                    nrr=nr{i,j};
                end
                if iscell(nrr)
                    nrr = nrr{1} * next_record.data{nrr{2},nrr{3}};
                else
                    if strcmp(form,'*char'),            % if there is only one character on block, read whole block_size
                        if isempty(nr{i,j})||nr{i,j}<0,   % Check that we should read rest of block
                            if iblk>i, 
                                if ~isempty(Format{i+1,j})
                                    istr=num2str(i+1);jstr=num2str(j);
                                    errstr='If *char is read for unspecified length it MUST be last i for';
                                    errstr=[errstr ' that j in FORMAT(i,j). FORMAT{',istr,',',jstr,'} should be []'];
                                    error(errstr);
                                else
                                    nrr=blk_size-(ftell(fid)-cur_pos); %Take care of already read elements in block
                                end
                            else
                                nrr=blk_size-(ftell(fid)-cur_pos);
                            end
                        end
                    end
                    
                end
                if nrr<0, nrr=(blk_size-(ftell(fid)-cur_pos))/get_length(fid,form); end
                if strcmp(form,'logic')
                    nrr = nr{i,j};
                    form = 'int';
                    logi = fread(fid,nrr,form)';
                    for locit = 1:nrr
                        if logi(locit) ~= 0
                            next_record.data{i,j}(locit)=1;
                        else
                        next_record.data{i,j}(locit)=logi(locit);
                        end
                    end
                else
                next_record.data{i,j}=fread(fid,nrr,form)';
                end
            end
        end
        dif_pos=ftell(fid)-cur_pos;
        fseek(fid,blk_size-dif_pos,0);                          %Make sure we start at next block even if we did not pick up all variables
        blk_size=fread(fid,1,'int');
        cur_pos=ftell(fid);
    end
    next_record.blk_size=cur_pos-next_record.abs_pos;
end
next_record.ifind=ifind;

function iform=get_length(fid,form)     % Find length of format
cur_pos=ftell(fid);
dum=fread(fid,1,form);
new_pos=ftell(fid);
iform=new_pos-cur_pos;
fseek(fid,cur_pos-new_pos,0);