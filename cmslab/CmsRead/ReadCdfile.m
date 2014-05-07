function data = ReadCdfile(cdfile,distlab,segment)

%% get cdinfo
if ~isstruct(cdfile)
    if nargin == 1 
        [segmnt,segpos,nseg,niseg] = read_cdfile(cdfile);
        segs = size(segmnt); 
        data.segmnt = mat2cell(segmnt,ones(1,segs(1)),segs(2));
        data.segpos = segpos;
        data.nseg = nseg;
        data.niseg = niseg;
        filtype = file('extension', cdfile);
        data.fileinfo.type = filtype(2:end);
        data.fileinfo.fullname = file('normalize', cdfile);
        data.fileinfo.name = file('tail', cdfile);
        return;
    else
        warning('For faster read use resinfo = ReadRes(resfile), then use ReadRes with resinfo as input');
        [segmnt,segpos,nseg,niseg] = read_cdfile(cdfile);
        segs = size(segmnt); 
        cdinfo.segmnt = mat2cell(segmnt,ones(1,segs(1)),segs(2));
        cdinfo.segpos = segpos;
        cdinfo.nseg = nseg;
        cdinfo.niseg = niseg;
        filtype = file('extension', cdfile);
        cdinfo.fileinfo.type = filtype(2:end);
        cdinfo.fileinfo.fullname = file('normalize', cdfile);
        cdinfo.fileinfo.name = file('tail', cdfile);
    end
elseif isstruct(cdfile)
    cdinfo = cdfile;
end


%% prepare inputdata

if iscell(distlab)
    ndist = length(distlab);
    distlist = distlab;
	distnames = lower(genvarname(distlist));
else
    ndist = 1;
    distlist = {distlab};
end

if iscell(segment)
    numsegs = length(segment);
    seglist = segment;
    isnumseg = 0;
elseif isnumeric(segment)
    numsegs = length(segment);
    for i = 1:numsegs
        seglist{i} = segment(i);
    end
    isnumseg = 1;
    
else
    isnumseg = 0;
    numsegs = 1;
    seglist = {segment};
end

%% get records
distcell = cell(ndist,numsegs);
structm = zeros(ndist,numsegs);
for d = 1:ndist
    for s = 1:numsegs
        distcell{d,s} = GetLibRecord(cdinfo,distlist{d},seglist{s});
        structm(d,s) = isstruct(distcell{d,s});
    end
end

%% arrange the data to structures or cells depending on what data is asked for.

if numsegs == 1 && ndist ==1
    data = distcell{1};
    if isstruct(data)
        data.resinfo = cdinfo;
    else 
        if iscell(data) && size(data,1) == 1 && size(data,2) == 1 &&  isfloat(data{1})
            data = data{1};
        end
    end
    return
end

structvar = logical(structm(:,1));
if max(structvar) == 1
    for i = 1:ndist
        if structvar(i)
            finam = fieldnames(distcell{i,1});
            
            for l = 1:length(finam)
                for k = 1:numsegs
                    c = struct2cell(distcell{i,k});
                    if ndist ==1
                        if numsegs == 1
                            eval(['data.'  finam{l} '=' 'c{l}' ';']);
                        else
                            eval(['data.'  finam{l} '{k}' '=' 'c{l}' ';']);
                        end
                    else 
                        if numsegs == 1
                            eval(['data.' distnames{i} '.' finam{l} '=' 'c{l}' ';']); 
                        else
                            eval(['data.' distnames{i} '.' finam{l} '{k}' '=' 'c{l}' ';']); 
                        end
                    end
                end   
            end
        else
            if isscalar(distcell{i,1})
                eval(['data.' distnames{i} '=' 'cell2mat(distcell(i,:));']);
            else
                if numsegs == 1
                    eval(['data.' distnames{i} '=' 'distcell{i,:};']);
                else
                    eval(['data.' distnames{i} '=' 'distcell(i,:);']); 
                end
            end

        end
    end
    if numsegs >1
        data.segment = segment;
    end
    data.resinfo = cdinfo;
    return;
    
end

if ndist >1
    for i=1:ndist
        if isscalar(distcell{i,1})
            eval(['data.' distnames{i} '=' 'cell2mat(distcell(i,:));']);
        else
            eval(['data.' distnames{i} '=' 'distcell(i,:);']);
        end
    end
else
    data = distcell;
end

if isstruct(data)
    data.resinfo = cdinfo;
end

if ndist ==1 && isscalar(data{1})
    if iscell(data{1}) 
        if isscalar(data{1}{1})
            for i = 1:numsegs
                datan(i) = cell2mat(data{i});
            end
            data = datan;
        else
            for i = 1:numsegs
                datan{i} = cell2mat(data{i});
            end
            data = datan;
        end
    else
        data = cell2mat(data);
    end
end
