function next_record=get_next_record(varargin)
% Used by read_restart_bin
%
%   next_record=get_next_record(fid,label,search_range,FORMAT,nr]
i_int=4;ifloat=4;
fid=varargin{1};
label=varargin{2};
old_pos=ftell(fid);
ifind=[];
if length(varargin)<3,
    search_range=1000;
else
    search_range=varargin{3};
end
if length(varargin)>6,
    nstart=varargin{6};
    nstop=varargin{7};
else
    nstart=0;
    fseek(fid,0,1);
    nstop=ftell(fid);
    fseek(fid,old_pos,-1);
end
if search_range<0,                      %search all file
    offset=nstart;
    fseek(fid,0,1);
    neof=ftell(fid);
    fseek(fid,old_pos,-1);
    while ftell(fid)<neof,
        search_str=fread(fid,5000000,'uint8')';
        search_str(search_str==255)=0; % Temporary work around bug in octave for linux
        ifind=strfind(search_str,label);
        if ~isempty(ifind), break; end;
        offset=offset+5000000;
    end
    ifind=ifind-9+offset;
else
    search_str=fread(fid,search_range,'uint8')';
    search_str(search_str==255)=0; % Temporary work around bug in octave for linux
    ifind=strfind(search_str,label);
    nd=strfind(search_str,label);
    ifind=ifind+old_pos-9;
end
if isempty(ifind),
    fseek(fid,nstart,-1);
    offset=nstart;
    while ftell(fid)<nstop,
        search_str=fread(fid,1000000,'uint8')';
        search_str(search_str==255)=0; % Temporary work around bug in octave for linux
        ifind=strfind(search_str,label);
        if ~isempty(ifind), break; end;
        offset=offset+1000000;
    end
    if isempty(ifind),
        next_record.comment='Label not found on restartfile';
        next_record.data=[];
        fseek(fid,old_pos,-1);
        return;
    end
    ifind=ifind-9+offset;
end
next_record.label=label;
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
                if nrr<0, nrr=(blk_size-(ftell(fid)-cur_pos))/get_length(fid,form); end
                next_record.data{i,j}=fread(fid,nrr,form)';
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