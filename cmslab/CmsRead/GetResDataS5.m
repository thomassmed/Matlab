function dists = GetResDataS5(resinfo,distlab,stptinp,asspos)
% GetResData is used by ReadRes to get the data or distribution given in
% input
%
%   dists = GetResData(resinfo,distlab)
%   dists = GetResData(resinfo,distlab,stptsinp)
%
% Input
%   resfile     - resinfo gotten from ReadRes(resfile) or ReadRes(resfile,'FULL')
%   distlab     - the label or distribution wanted
%   stptinp     - the state point wanted (default is first statepoint)
%
% Output
%   dists       - matrix or cell array of data.
%
% Example:
%
% xenon = GetResData(resinfo,'XENON')
% samarium3 = GetResData(resinfo,'SAMARIUM',3);
% 
% See also ReadRes, FindLabels

% Mikael Andersson 2011-10-03

% Programmers notes: If GetResData is called with just 'exceptions'
% GetResData('exceptions') all cases that are not options. If you have
% cases in another case, see 'THERMAL HYD'. If more cases that are not
% options for GetResData put the cases in variable "exceptions".

if ischar(resinfo)
    if strcmpi(resinfo,'EXCEPTIONS')
        exceptions = {'GEN','TUBE','BWR.WTG','BWR.WTR','FULL','SE','S','E','ESE',1,2,3,4};
        dists = exceptions;
        return
    elseif strcmpi(resinfo,'NONDISTS')
        nondists = {'OPER','ASMNAM','KEFF','NEW ASSEMBLY DATA', 'ASSEMBLY DATA','NUM MICRO DEP','SUBMESH DATA','ASSEMBLY ISOTOPICS','SUBMESH ISOTOPICS', 'ASSEMBLY LABELS','PINDATA','LIBRARY','THERMAL HYD','CONTROL ROD','NFTA DIST','NHYD DIST','KONROD','FUE NEW','DIMS','FLK DATA'};        dists = nondists;
        dists = nondists;
        return
    end
end

% set up of state points
if nargin >=3
    offsetstpt = resinfo.data.st_pts_pos(stptinp);
else
    offsetstpt = 0;
end

if nargin == 4
    allass = 0;
    assknu = size(asspos);
    if assknu(2) == 2 && min(asspos) < resinfo.core.iafull
        iareq = asspos(:,1);
        jareq = asspos(:,2);
        knumit = cpos2knum(iareq,jareq,resinfo.core.mminj);
    else
        knumit = asspos; 
    end
else
    allass = 1;
end
Parameters = resinfo.data.Parameters;
Dimensions = resinfo.data.Dimensions;



%% Open file to read
fid=fopen(resinfo.fileinfo.fullname,'r','ieee-be'); % should be taken away to save time
fseek(fid,0,-1);fread(fid,1,'int');i_int=ftell(fid);
fseek(fid,0,-1);fread(fid,1,'float');ifloat=ftell(fid);

% try 
if max(strcmpi(strtrim(distlab),CaseReader('GetFormatNrS5.m')))
    dists = GetDist(resinfo,distlab,fid,offsetstpt);
    fclose(fid);
else
    DISTLAB = upper(distlab);
    
    switch strtrim(DISTLAB)
        
        case {'NEW ASSEMBLY DATA', 'ASSEMBLY DATA'}
            [datpos] = FindPos(resinfo.data.Fuel_data,strtrim(DISTLAB));
            datapos = datpos{1} + offsetstpt;
            fseek(fid,datapos(1),-1);
            sizeread=fread(fid,2,'int');
            nd = sizeread(2) - 1;
            kan = GetSymKan(resinfo);
            if resinfo.core.if2x2 == 2
                kan = kan*4;
            end
            for i = 1:kan
                fseek(fid,datapos(i)+sizeread(1)+12,-1);
                geomread = fread(fid,6,'int');
                geomread(length(geomread)+1) = fread(fid,1,'float');
                geomread(length(geomread)+1:length(geomread)+4) = fread(fid,4,'int');
                fseek(fid,4,0);
                datsizefread = fread(fid,1,'int');
                for l = 1:nd
                    fseek(fid,datapos(i)+sizeread(1)+64 + (l-1)*(datsizefread + 8),-1);
                    dist{i,l}=fread(fid,datsizefread/4,'float');
                end
                is(i) = geomread(1);
                js(i) = geomread(2);
                kbt(i) = geomread(3);
                nft(i) = geomread(4);
                nfr(i) = geomread(5);
                yy(i) = geomread(7);
                nfta(i) = geomread(8);
                ibat(i) = geomread(9);
                ibatf(i) = geomread(10);
            end
            if resinfo.core.if2x2 == 2
                subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                is = is(subnums);
                js = js(subnums);
                kbt = kbt(subnums);
                nft = nft(subnums);
                nfr = nfr(subnums);
                yy = yy(subnums);
                nfta = nfta(subnums);
                ibat = ibat(subnums);
                ibatf = ibatf(subnums);
                for i = 1:nd
                    dist(:,i) = dist(subnums,i);
                end
            end
            
            dists.is = is;
            dists.js = js;
            dists.kbt = kbt;
            dists.nft = nft;
            dists.nfr = nfr;
            dists.yy = yy;
            dists.nfta = nfta;
            dists.ibat = ibat;
            dists.ibatf = ibatf;
            dists.conc = dist;
            fclose(fid);
        case {'XENON' ,'SAMARIUM','IODINE','PROMETHIUM','BURNUP','TFUHIST','CRDHIST','VHIST','DENHIST','BORONDENS','SURFEXPYM','SURFEXPXP','SURFEXPYP','SURFEXPXM','SPECHIST', 'SPECHISTYM','SPECHISTXP','SPECHISTYP','SPECHISTXM','EB1','BP1','BP10','BP2','BP20','EB2','XTF','FLN','FLNYM','FLNXP','FLNYP', 'FLNXM'}
            % done
            [datpos] = FindPos(resinfo.data.Fuel_data,'ASSEMBLY DATA       ');
            datapos = datpos{1} + offsetstpt;
            fseek(fid,datapos(1),-1);
            blk_size=fread(fid,1,'int');
            relpos = RelativePosInData(DISTLAB,resinfo.core.kmax,resinfo,stptinp);
            kan = GetSymKan(resinfo);
            if allass
                if resinfo.core.if2x2 == 2
                    kan = kan*4;
                end
                for i = 1:kan
                    fseek(fid,datapos(i)+blk_size+3*i_int + 4*i_int+ifloat + relpos,-1);
                    dist(:,i)=fread(fid,resinfo.core.kmax,'float32');
                end
                if resinfo.core.if2x2 == 2
                    coreind = convert2x2('2vec',1:kan*4,resinfo.core.mminj);
                    dist = dist(:,coreind);
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        dist = cell(length(knumit),1);
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k))+blk_size+3*i_int + 4*i_int+ifloat + relpos,-1);
                                dist{i}(:,j)=fread(fid,resinfo.core.kmax,'float32');
                                k = k+1;
                            end
                        end
                        dists = dist;
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i))+blk_size+3*i_int + 4*i_int+ifloat + relpos,-1);
                    dist(:,i)=fread(fid,resinfo.core.kmax,'float32');
                end
            end
            
            dists = dist;
            fclose(fid);
        case {'SUB XENON' ,'SUB SAMARIUM','SUB IODINE','SUB PROMETHIUM','SUB BURNUP','SUB TFUHIST','SUB CRDHIST','SUB VHIST','SUB DENHIST','SUB BORONDENS','SUB SURFEXPYM','SUB SURFEXPXP','SUB SURFEXPYP','SUB SURFEXPXM','SUB SPECHIST', 'SUB SPECHISTYM','SUB SPECHISTXP','SUB SPECHISTYP','SUB SPECHISTXM','SUB EB1','SUB BP1','SUB BP10','SUB BP2','SUB BP20','SUB EB2','SUB XTF','SUB FLN','SUB FLNYM','SUB FLNXP','SUB FLNYP', 'SUB FLNXM'}
            % done
            [datpos] = FindPos(resinfo.data.Fuel_data,'NEW ASSEMBLY DATA       ');
            datapos = datpos{1} + offsetstpt;
            fseek(fid,datapos(1),-1);
            blk_size=fread(fid,1,'int');
            
            kan = GetSymKan(resinfo);
            if resinfo.core.if2x2 == 2
                kan = kan*4;
            end
            if allass
                for i = 1:kan
                    fseek(fid,datapos(i)+blk_size+5*4,-1);
                    knods = fread(fid,1,'int');
                    relpos = RelativePosInData(DISTLAB(5:end),knods,resinfo,stptinp);
                    fseek(fid,datapos(i)+blk_size+3*i_int + 4*i_int+ifloat + relpos,-1);
                    dist{i}=fread(fid,knods,'float32');
                end
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                    dist = dist(subnums);
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k))+blk_size+5*4,-1);
                                knods = fread(fid,1,'int');
                                relpos = RelativePosInData(DISTLAB(5:end),knods,resinfo,stptinp);
                                fseek(fid,datapos(knums(k))+blk_size+3*i_int + 4*i_int+ifloat + relpos,-1);
                                dist{i}{j}=fread(fid,knods,'float32');
                                k = k+1;
                            end
                        end
                        dists = dist;
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i))+blk_size+5*4,-1);
                    knods = fread(fid,1,'int');
                    relpos = RelativePosInData(DISTLAB(5:end),knods,resinfo,stptinp);
                    fseek(fid,datapos(knums(i))+blk_size+3*i_int + 4*i_int+ifloat + relpos,-1);
                    dist{:,i}=fread(fid,knods,'float32');
                end
            end
            dists = dist;
            fclose(fid);
        case 'SUBNODE GEOMETRY'
        % done
            [datpos] = FindPos(resinfo.data.Fuel_data,'SUBNODE GEOMETRY');
            datapos = datpos{1} + offsetstpt;
            fseek(fid,datapos(1),-1);
            sizeread=fread(fid,1,'int');
            kan = GetSymKan(resinfo);
            if resinfo.core.if2x2 == 2
                kan = kan*4;
            end
            if allass
                for i = 1:kan
                    fseek(fid,datapos(i)+sizeread(1)+12,-1);
                    kbt(i) = fread(fid,1,'int');
                    dist{i}=fread(fid,kbt(i),'float');
                end
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                    dist = dist(subnums);
                end
            else 
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k))+sizeread(1)+12,-1);
                                kbt(k) = fread(fid,1,'int');
                                dist{i}{j}=fread(fid,kbt(k),'float');
                                k = k+1;
                            end
                        end
                        dists = dist;
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end
                
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i))+sizeread(1)+12,-1);
                    kbt(i) = fread(fid,1,'int');
                    dist{i}=fread(fid,kbt(i),'float');
                end
            end
            if ~allass && length(knumit) == 1 && resinfo.core.if2x2 ~=2
                dist = dist{1};
            end
            dists = dist;
            fclose(fid);
        
        case {'SUBMESH DATA','SUBMESH DATA POW','SUBMESH DATA EXP'}
        
            [datpos] = FindPos(resinfo.data.Fuel_data,'SUBMESH DATA');
            datapos = datpos{1} + offsetstpt;
            kan = GetSymKan(resinfo);
            if ~isempty(regexp(DISTLAB,'POW','once'))
                powexp = 1;
            elseif ~isempty(regexp(DISTLAB,'EXP','once'))
                powexp = 2;
            else
                powexp = 0;
            end
            if resinfo.core.if2x2 == 2
                kan = kan*4;
            end
            if allass
                for i = 1:kan
                    fseek(fid,datapos(i),-1);
                    sizeread=fread(fid,2,'int');
                    nrofreads = sizeread(2)/2;
                    fseek(fid,datapos(i)+sizeread(1)+4,-1);
                    read1 = fread(fid,2,'int');
                    size1 = read1(2);
                    if powexp == 2 || powexp == 0
                        for l = 1:nrofreads
                            dist1{i}(:,l) = fread(fid,size1/4,'float=>single');
                            fseek(fid,8,0);
                        end
                        fseek(fid,-8,0);
                    else
                        fseek(fid,size1*nrofreads+8*(nrofreads-1),0);
                    end
                        
                    read2 = fread(fid,2,'int');
                    size2 = read2(2);    
                    if powexp == 1 || powexp == 0 
                        for l = 1:nrofreads
                            dist2{i}(:,l) = fread(fid,size2/4,'float=>single');
                            fseek(fid,8,0);
                        end
                        fseek(fid,-8,0);
                    else
                        fseek(fid,size2*nrofreads+8*(nrofreads-1),0);
                    end
                end
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                    if powexp == 1 
                        dist2 = dist2(subnums);
                    elseif powexp == 2
                        dist1 = dist1(subnums);
                    else 
                        dist1 = dist1(subnums);
                        dist2 = dist2(subnums);
                    end
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k)),-1);
                                sizeread=fread(fid,2,'int');
                                nrofreads = sizeread(2)/2;
                                fseek(fid,datapos(knums(k))+sizeread(1)+4,-1);
                                read1 = fread(fid,2,'int');
                                size1 = read1(2);
                                if powexp == 2 || powexp == 0
                                    for l = 1:nrofreads
                                        dist1{i}{j}(:,l) = fread(fid,size1/4,'float=>single');
                                        fseek(fid,8,0);
                                    end
                                    fseek(fid,-8,0);
                                else
                                    fseek(fid,size1*nrofreads+8*(nrofreads-1),0);
                                end

                                read2 = fread(fid,2,'int');
                                size2 = read2(2);    
                                if powexp == 1 || powexp == 0 
                                    for l = 1:nrofreads
                                        dist2{i}{j}(:,l) = fread(fid,size2/4,'float=>single');
                                        fseek(fid,8,0);
                                    end
                                    fseek(fid,-8,0);
                                else
                                    fseek(fid,size2*nrofreads+8*(nrofreads-1),0);
                                end
                                k = k+1;
                            end
                        end
                        if powexp == 2
                            dists = dist1;
                        elseif powexp == 1
                            dists = dist2;
                        else
                            dists.Pow = dist2;
                            dists.Exp = dist1;
                            dists.knums = knums;
                        end
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end
                    
                    
                    
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i)),-1);
                    sizeread=fread(fid,2,'int');
                    nrofreads = sizeread(2)/2;
                    fseek(fid,datapos(knums(i))+sizeread(1)+4,-1);
                    read1 = fread(fid,2,'int');
                    size1 = read1(2);
                    if powexp == 2 || powexp == 0
                        for l = 1:nrofreads
                            dist1{i}(:,l) = fread(fid,size1/4,'float=>single');
                            fseek(fid,8,0);
                        end
                        fseek(fid,-8,0);
                    else
                        fseek(fid,size1*nrofreads+8*(nrofreads-1),0);
                    end
                        
                    read2 = fread(fid,2,'int');
                    size2 = read2(2);    
                    if powexp == 1 || powexp == 0 
                        for l = 1:nrofreads
                            dist2{i}(:,l) = fread(fid,size2/4,'float=>single');
                            fseek(fid,8,0);
                        end
                        fseek(fid,-8,0);
                    else
                        fseek(fid,size2*nrofreads+8*(nrofreads-1),0);
                    end
                end
            end
            
            if powexp == 2
                if exist('knumit','var') && length(knumit) == 1 && ~resinfo.core.if2x2
                    dist1 = dist1{1};
                end
                dists = dist1;
            elseif powexp == 1
                if exist('knumit','var') && length(knumit) == 1 && ~resinfo.core.if2x2
                        dist2 = dist2{1};
                end
                dists = dist2;
            else
                if exist('knumit','var') && length(knumit) == 1 && ~resinfo.core.if2x2
                        dist1 = dist1{1};
                        dist2 = dist2{1};
                end
                    dists.Pow = dist2;
                    dists.Exp = dist1;
                if ~allass
                    dists.knums = knums;
                end
            end
            fclose(fid);
        
        case 'ASSEMBLY ISOTOPICS'
            [datpos] = FindPos(resinfo.data.Fuel_data,'ASSEMBLY ISOTOPICS');
            datapos = datpos{1} + offsetstpt;
            kan = GetSymKan(resinfo);
            if resinfo.core.if2x2 == 2
                kan = kan*4;
            end
            for i = 1:kan
                fseek(fid,datapos(i),-1);
                sizeread=fread(fid,2,'int');
                fseek(fid,datapos(i)+sizeread(1)+12,-1);
                microdata{i} = fread(fid,7,'int');
                fseek(fid,4,0);
                rec2 = fread(fid,2,'int');
                nconl = (rec2(1)-4)/4;
                nrofreads = rec2(2);
                ncon = fread(fid,nconl,'int');
                fseek(fid,4,0);
                rec3 = fread(fid,1,'int')/4;
                for j = 1:nrofreads
                    dist{i}(:,j) = fread(fid,rec3,'float=>single');
                end
            end
            if resinfo.core.if2x2 == 2
                subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                dist = dist(subnums);
            end
            dists = dist;
            fclose(fid);
        case 'SUBMESH ISOTOPICS'
            [datpos] = FindPos(resinfo.data.Fuel_data,'SUBMESH ISOTOPICS');
            datapos = datpos{1} + offsetstpt;
            smx = 5;
            kan = GetSymKan(resinfo);
            if allass
                if resinfo.core.if2x2 == 2
                    kan = kan*4;
                end
                for i = 1:kan
                    fseek(fid,datapos(i),-1);
                    sizeread = fread(fid,2,'int');
                    nrofread = sizeread(2);
                    fseek(fid,datapos(i)+sizeread(1)+8,-1);
                    numr = fread(fid,1,'int');
                    for j = 1:nrofread
                        dataread{i}(:,j) = fread(fid,numr/4+2,'float=>single');
                    end
                end
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                    dataread = dataread(subnums);
                end
                disvec = cumsum(ones(1,numr/4/smx-1)*smx);
                for i = 1:length(dataread)
                    nu235{i} = dataread{i}(1,:);
                    nu238{i} = dataread{i}(2,:);
                    npu239{i} = dataread{i}(3,:);
                    npu240{i} = dataread{i}(4,:);
                    npu241{i} = dataread{i}(5,:);
                    su235{i} = dataread{i}(disvec+1,:);
                    su238{i} = dataread{i}(disvec+2,:);
                    spu239{i} = dataread{i}(disvec+3,:);
                    spu240{i} = dataread{i}(disvec+4,:);
                    spu241{i} = dataread{i}(disvec+5,:);
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k)),-1);
                                sizeread = fread(fid,2,'int');
                                nrofread = sizeread(2);
                                fseek(fid,datapos(knums(k))+sizeread(1)+8,-1);
                                numr = fread(fid,1,'int');
                                for l = 1:nrofread
                                    dataread{i}{j}(:,l) = fread(fid,numr/4+2,'float=>single');
                                end    
                                k = k+1;
                            end
                        end
                        disvec = cumsum([ones(1,numr/4/smx-1)*smx]);
                        for i = 1:length(dataread)
                            for j = 1:4
                                nu235{i}{j} = dataread{i}{j}(1,:);
                                nu238{i}{j} = dataread{i}{j}(2,:);
                                npu239{i}{j} = dataread{i}{j}(3,:);
                                npu240{i}{j} = dataread{i}{j}(4,:);
                                npu241{i}{j} = dataread{i}{j}(5,:);
                                su235{i}{j} = dataread{i}{j}(disvec+1,:);
                                su238{i}{j} = dataread{i}{j}(disvec+2,:);
                                spu239{i}{j} = dataread{i}{j}(disvec+3,:);
                                spu240{i}{j} = dataread{i}{j}(disvec+4,:);
                                spu241{i}{j} = dataread{i}{j}(disvec+5,:);
                            end
                        end
                        dists.subnode.U235 = nu235;
                        dists.subnode.U238 = nu238;
                        dists.subnode.PU239 = npu239;
                        dists.subnode.PU240 = npu240;
                        dists.subnode.PU241 = npu241;
                        dists.submesh.U235 = su235;
                        dists.submesh.U238 = su238;
                        dists.submesh.PU239 = spu239;
                        dists.submesh.PU240 = spu240;
                        dists.submesh.PU241 = spu241;
                        fclose(fid);
                        return
                    end
                else 
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i)),-1);
                    sizeread = fread(fid,2,'int');
                    nrofread = sizeread(2);
                    fseek(fid,datapos(knums(i))+sizeread(1)+8,-1);
                    numr = fread(fid,1,'int');
                    for j = 1:nrofread
                        dataread{i}(:,j) = fread(fid,numr/4+2,'float=>single');
                    end
                end
                disvec = cumsum([ones(1,numr/4/smx-1)*smx]);
                if length(knums) == 1
                    nu235 = dataread{1}(1,:);
                    nu238 = dataread{1}(2,:);
                    npu239 = dataread{1}(3,:);
                    npu240 = dataread{1}(4,:);
                    npu241 = dataread{1}(5,:);
                    su235 = dataread{1}(disvec+1,:);
                    su238 = dataread{1}(disvec+2,:);
                    spu239 = dataread{1}(disvec+3,:);
                    spu240 = dataread{1}(disvec+4,:);
                    spu241 = dataread{1}(disvec+5,:);
                else
                    for i = 1:length(dataread)
                        nu235{i} = dataread{i}(1,:);
                        nu238{i} = dataread{i}(2,:);
                        npu239{i} = dataread{i}(3,:);
                        npu240{i} = dataread{i}(4,:);
                        npu241{i} = dataread{i}(5,:);
                        su235{i} = dataread{i}(disvec+1,:);
                        su238{i} = dataread{i}(disvec+2,:);
                        spu239{i} = dataread{i}(disvec+3,:);
                        spu240{i} = dataread{i}(disvec+4,:);
                        spu241{i} = dataread{i}(disvec+5,:);
                    end
                end
            end
            
            dists.subnode.U235 = nu235;
            dists.subnode.U238 = nu238;
            dists.subnode.PU239 = npu239;
            dists.subnode.PU240 = npu240;
            dists.subnode.PU241 = npu241;
            dists.submesh.U235 = su235;
            dists.submesh.U238 = su238;
            dists.submesh.PU239 = spu239;
            dists.submesh.PU240 = spu240;
            dists.submesh.PU241 = spu241;
            if ~allass
                dists.knums = knumit;
            end
            fclose(fid);
%         case {'MICRO 1','MICRO 2','MICRO 3','MICRO 4','MICRO 5','MICRO 6','MICRO 7','MICRO 8','MICRO 9','MICRO 10','MICRO 11','MICRO 12','MICRO 13','MICRO 14','MICRO 15','MICRO 16','MICRO 17','MICRO 18','MICRO 19','MICRO 20','MICRO 21','MICRO 22','MICRO 23','MICRO 24','MICRO 25','MICRO 26','MICRO 27','MICRO 28','MICRO 29','MICRO 30','MICRO 31','MICRO 32','MICRO 33','MICRO 34','MICRO 35','MICRO 36','MICRO 37','MICRO 38','MICRO 39','MICRO 40','MICRO 41','MICRO 42','MICRO 43','MICRO 44','MICRO 45','MICRO 46','MICRO 47','MICRO 48','MICRO 49','MICRO 50','MICRO 51','MICRO 52','MICRO 53','MICRO 54'}    
        case {'MICRO U234', 'MICRO U235', 'MICRO U236', 'MICRO U238', 'MICRO NP237', 'MICRO NP239', 'MICRO PU238', 'MICRO PU239', 'MICRO PU240', 'MICRO PU241',  'MICRO PU242', 'MICRO AM241', 'MICRO AM242', 'MICRO AM243', 'MICRO CM242', 'MICRO CM244', 'MICRO PUDMY', 'MICRO ZR95', 'MICRO NB95', 'MICRO MO95', 'MICRO RU103', 'MICRO RH103', 'MICRO RH105', 'MICRO I131', 'MICRO XE131', 'MICRO XE133', 'MICRO CS133', 'MICRO CS134', 'MICRO CE143', 'MICRO PR143', 'MICRO ND143', 'MICRO TC99', 'MICRO AG109', 'MICRO ND145', 'MICRO ND147', 'MICRO PM147', 'MICRO PM148', 'MICRO PM148M', 'MICRO PM149', 'MICRO SM147', 'MICRO SM149', 'MICRO SM150', 'MICRO SM151', 'MICRO SM152', 'MICRO SM153', 'MICRO EU153', 'MICRO EU154', 'MICRO EU155', 'MICRO GD155F', 'MICRO BA140', 'MICRO LA140', 'MICRO B10', 'MICRO B20', 'MICRO GDEFF', 'MICRO GD154', 'MICRO GD155', 'MICRO GD156', 'MICRO GD157', 'MICRO I135', 'MICRO XE135','NUM MICRO DEP'}      
    
            [datpos] = FindPos(resinfo.data.Fuel_data,'ASSEMBLY ISOTOPICS');
            datapos = datpos{1} + offsetstpt;
            kan = GetSymKan(resinfo);
            searchcell = {'MICRO U234', 'MICRO U235', 'MICRO U236', 'MICRO U238', 'MICRO NP237', 'MICRO NP239', 'MICRO PU238', 'MICRO PU239', 'MICRO PU240', 'MICRO PU241',  'MICRO PU242', 'MICRO AM241', 'MICRO AM242', 'MICRO AM243', 'MICRO CM242', 'MICRO CM244', 'MICRO PUDMY', 'MICRO ZR95', 'MICRO NB95', 'MICRO MO95', 'MICRO RU103', 'MICRO RH103', 'MICRO RH105', 'MICRO I131', 'MICRO XE131', 'MICRO XE133', 'MICRO CS133', 'MICRO CS134', 'MICRO CE143', 'MICRO PR143', 'MICRO ND143', 'MICRO TC99', 'MICRO AG109', 'MICRO ND145', 'MICRO ND147', 'MICRO PM147', 'MICRO PM148', 'MICRO PM148M', 'MICRO PM149', 'MICRO SM147', 'MICRO SM149', 'MICRO SM150', 'MICRO SM151', 'MICRO SM152', 'MICRO SM153', 'MICRO EU153', 'MICRO EU154', 'MICRO EU155', 'MICRO GD155F', 'MICRO BA140', 'MICRO LA140', 'MICRO B10', 'MICRO B20', 'MICRO GDEFF', 'MICRO GD154', 'MICRO GD155', 'MICRO GD156', 'MICRO GD157', 'MICRO I135', 'MICRO XE135','NUM MICRO DEP'};      
            disnum = find(strcmpi(DISTLAB,searchcell));
            numofdist = length(searchcell);
            %%
            if strcmpi('NUM MICRO DEP',DISTLAB)
                fseek(fid,datapos(1),-1);
                sizeread=fread(fid,2,'int');
                fseek(fid,datapos(1)+sizeread(1)+12,-1);
                fseek(fid,4+7*4,0);
                rec2 = fread(fid,2,'int');
                dists = rec2(2);
                fclose(fid);
                return;
            end
            if resinfo.core.if2x2 == 2
                kan = kan*4;               
            end
            if allass
                for i = 1:kan
                    fseek(fid,datapos(i),-1);
                    sizeread=fread(fid,2,'int');
                    fseek(fid,datapos(i)+sizeread(1)+12,-1);
                    fseek(fid,4+7*4,0);
                    rec2 = fread(fid,2,'int');
                    if rec2(2) < disnum 
                        warning('Distribution not present in this restart file');
                        fclose(fid);
                        return;
                    end
                    nconl = (rec2(1)-4);
                    fseek(fid,4 + nconl,0);
                    rec3 = fread(fid,1,'int')/4;
                    % read from file
                    fseek(fid,rec3*4*(disnum-1),0);
                    dist{i} = fread(fid,rec3,'float=>single');
                end
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                    dist = dist(subnums);
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k)),-1);
                                sizeread=fread(fid,2,'int');
                                fseek(fid,datapos(knums(k))+sizeread(1)+12,-1);
                                fseek(fid,4+7*4,0);
                                rec2 = fread(fid,2,'int');
                                if rec2(2) < disnum 
                                    warning('Distribution not present in this restart file');
                                    fclose(fid);
                                    return;
                                end
                                nconl = (rec2(1)-4);
                                fseek(fid,4 + nconl,0);
                                rec3 = fread(fid,1,'int')/4;
                                % read from file
                                fseek(fid,rec3*4*(disnum-1),0);
                                dist{i}{j} = fread(fid,rec3,'float=>single');
                                k = k+1;
                            end
                        end
                        dists = dist;
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i)),-1);
                    sizeread=fread(fid,2,'int');
                    fseek(fid,datapos(knums(i))+sizeread(1)+12,-1);
                    fseek(fid,4+7*4,0);
                    rec2 = fread(fid,2,'int');
                    if rec2(2) < disnum 
                        warning('Distribution not present in this restart file');
                        fclose(fid);
                        return;
                    end
                    nconl = (rec2(1)-4);
                    fseek(fid,4 + nconl,0);
                    rec3 = fread(fid,1,'int')/4;
                    % read from file
                    fseek(fid,rec3*4*(disnum-1),0);
                    dist{i} = fread(fid,rec3,'float=>single');
                end
                if length(knumit) == 1 && ~(resinfo.core.if2x2==2)
                    dist = dist{1};
                end
            end
            dists = dist;
            fclose(fid);
                
        
        
        case {'SUBNODE U235','SUBNODE U238','SUBNODE PU239','SUBNODE PU240','SUBNODE PU241','SUBMESH U235', 'SUBMESH U238', 'SUBMESH PU239', 'SUBMESH PU240', 'SUBMESH PU241'}
                        
            if allass
                subdata = GetResDataS5(resinfo,'SUBMESH ISOTOPICS',stptinp);
            else
                subdata = GetResDataS5(resinfo,'SUBMESH ISOTOPICS',stptinp,asspos);
            end
            evalstr = ['dists = subdata.' lower(DISTLAB(1:7)) '.' DISTLAB(9:end) ';'];
            eval(evalstr);
            fclose(fid);        
        case 'PINDATA'
            % this is almost a copy of the data you get out of S3 PINDATA
            % but not everything is on the same place in the restart file
            % so its more a combination.
            if allass
                asslab = GetResDataS5(resinfo,'ASSEMBLY LABELS',stptinp);
                pinexp = GetResDataS5(resinfo,'PIN BURNUP',stptinp);
                geoms = GetResDataS5(resinfo,'SUBNODE GEOMETRY',stptinp);
                kdfuel = zeros(1,length(geoms));
                for i = 1:length(geoms)
                    kdfuel(i) = length(geoms{i});
                end
                dists.ia = asslab.iaf;
                dists.ja = asslab.jaf;
                dists.npin = pinexp.npin;
                dists.nfran = asslab.nfra;
                dists.ser = asslab.ser;
                dists.lab = asslab.lab;
                dists.pinexp = pinexp.pinexp;
                dists.Xpo = resinfo.data.Xpo(stptinp);
                dists.geoms = geoms;
            else
                asslab = GetResDataS5(resinfo,'ASSEMBLY LABELS',stptinp,asspos);
                pinexp = GetResDataS5(resinfo,'PIN BURNUP',stptinp,asspos);
                geoms = GetResDataS5(resinfo,'SUBNODE GEOMETRY',stptinp,asspos);
                kdfuel = zeros(1,length(geoms));
                if length(knumit == 1) && resinfo.core.if2x2 ~=2
                    kdfuel = length(geoms);
                else
                    for i = 1:length(geoms)
                        kdfuel(i) = length(geoms{i});
                    end
                end
                dists.ia = asslab.iaf;
                dists.ja = asslab.jaf;
                dists.npin = pinexp.npin;
                dists.kdfuel = kdfuel;
                dists.nfran = asslab.nfra;
                dists.ser = asslab.ser;
                dists.lab = asslab.lab;
                dists.pinexp = pinexp.pinexp;
                dists.Xpo = resinfo.data.Xpo(stptinp);
                dists.geoms = geoms;
                if ~allass
                    if resinfo.core.if2x2 == 2
                        knms = convert2x2('2asspos',knumit,resinfo.core.mminj);
                        if length(knumit) == 1
                            dists.knums = knms;
                        else
                            for i = 1:length(knumit)
                                dists.knums{i} = knms(i,:);
                            end
                        end
                    else
                        dists.knums = knumit;
                    end
                end
            end
            fclose(fid);
        case {'PIN BURNUP', 'PINEXP'}
            
            [datpos] = FindPos(resinfo.data.Fuel_data,'PIN BURNUP');
            datapos = datpos{1} + offsetstpt;
            kan = GetSymKan(resinfo);
            knum = resinfo.core.knum;
            if allass
                if resinfo.core.if2x2 == 2
                    kan = kan*4;      
                    cormap = convert2x2('2core',1:resinfo.core.kan*4,resinfo.core.mminj2x2);
                    knum = convert2x2('2fill',knum,resinfo.core.mminj)';
                else
                    cormap = vec2cor(1:resinfo.core.kan,resinfo.core.mminj);
%                     knm = 1:kan;
%                     [ia,ja]=mminj2ij(resinfo.core.mminj);
                end

                for i = 1:kan
                    fseek(fid,datapos(i),-1);
                    sizeread=fread(fid,2,'int');
                    fseek(fid,datapos(i)+sizeread(1)+12,-1);
                    npins(i) = fread(fid,1,'int');
                    fseek(fid,12,0);
                    [ia,ja] = find(cormap == knum(i,1));
                    for j = 1:sizeread(2)-1
                        dist{ia,ja}(:,:,j) = reshape(fread(fid,npins(i)*npins(i),'float'),npins(i),npins(i));
                        fseek(fid,8,0);
                    end
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k)),-1);
                                sizeread=fread(fid,2,'int');
                                fseek(fid,datapos(knums(k))+sizeread(1)+12,-1);
                                npins{i}(j) = fread(fid,1,'int');
                                fseek(fid,12,0);

                                for l = 1:sizeread(2)-1
                                    dist{i}{j}(:,:,l) = reshape(fread(fid,npins{i}(j)*npins{i}(j),'float=>single'),npins{i}(j),npins{i}(j));
                                    fseek(fid,8,0);
                                end
                                k = k+1;
                            end
                        end
                        dists.npin = npins;
                        dists.pinexp = dist;
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end
                        
                for i = 1:1:length(knums)
                    fseek(fid,datapos(knums(i)),-1);
                    sizeread=fread(fid,2,'int');
                    fseek(fid,datapos(knums(i))+sizeread(1)+12,-1);
                    npins(i) = fread(fid,1,'int');
                    fseek(fid,12,0);

                    for j = 1:sizeread(2)-1
                        dist{i}(:,:,j) = reshape(fread(fid,npins(i)*npins(i),'float=>single'),npins(i),npins(i));
                        fseek(fid,8,0);
                    end
                end
            end
            if strcmpi(DISTLAB,'PINEXP')
                dists = dist;
            else
                if ~allass && length(knumit) ==1 && resinfo.core.if2x2 ~= 2
                    dist = dist{1};
                end
                dists.npin = npins;
                dists.pinexp = dist;
            end
            fclose(fid);
            
            
            
            
        case 'EXP2D'
            [datpos] = FindPos(resinfo.data.Fuel_data,'MORE ASSEMBLY DATA  ');
            datapos = datpos{1} + offsetstpt;
            kan = length(sym2knum(resinfo.core.mminj,resinfo.core.sym));
            if resinfo.core.if2x2 == 2
                kan = kan*4;
            end
            fseek(fid,datapos(1),-1);
            blk_size=fread(fid,1,'int');
            if allass
                ia = zeros(1,kan);
                ja = zeros(1,kan);
                nfcrt = zeros(1,kan);
                for i = 1:kan
                    fseek(fid,datapos(i) + blk_size + 12,-1);
                    fdat = fread(fid,3,'int');
                    ia(i) = fdat(1);
                    ja(i) = fdat(2);
                    nfcrt(i) = fdat(3);
                    expv(i) = fread(fid,1,'float');
                end
                if resinfo.core.if2x2 == 2
                    dists = convert2x2('2core',expv,resinfo.core.mminj);
                else
%                     dists = vec2cor(expv,resinfo.core.mminj);
                    dists = expv;
                end
                %%
            else
                kannum = length(knumit);
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums;
                    if kannum > 1
                        k = 1;
                        for i = 1:length(knumit)
                            for j = 1:4
                                fseek(fid,datapos(knums(k)) + blk_size + 12,-1);
                                fdat = fread(fid,3,'int');
                                exp2d{i}(j) = fread(fid,1,'float');
                            end
                        end
                        dists = exp2d;
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) ~] = find(resinfo.core.knum == knumit(i));
                    end
                end

                exp2d = zeros(size(kannum));
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i)) + blk_size + 12,-1);
                    fdat = fread(fid,3,'int');
                    exp2d(i) = fread(fid,1,'float');
                end
                dists = exp2d;
            end
            
            
%             [datpos] = FindPos(resinfo.data.Fuel_data,'MORE ASSEMBLY DATA');
%             datapos = datpos{1} + offsetstpt;
%             fseek(fid,datapos(1),-1);
%             sizeread=fread(fid,1,'int');
%             
%             kan = GetSymKan(resinfo);
%         
%             for i = 1:kan
%                 fseek(fid,datapos(i) + sizeread + 12,-1);
%                 iajanf{i} = fread(fid,3,'int');
%                 exp2d(i) = fread(fid,1,'float');
%                 ia(i) =iajanf{i}(1);
%                 ja(i) =iajanf{i}(2);
%                 nfcrt(i) = iajanf{i}(3);
%                 
%             end
%         
% %                 dists.ia = ia;
% %                 dists.ja = ja;
% %                 dists.nfcrt = nfcrt;
%                 dists.exp2d = exp2d;
        
        fclose(fid);
        case 'ASSEMBLY LABELS'
            [datpos] = FindPos(resinfo.data.Fuel_data,'ASSEMBLY LABELS');
            datapos = datpos{1} + offsetstpt;
            fseek(fid,datapos(1),-1);
            sizeread=fread(fid,1,'int');
            
            kan = GetSymKan(resinfo);
            if allass
                if resinfo.core.if2x2 == 2
                    kan = 4*kan;
                end
                for i = 1:kan
                    fseek(fid,datapos(i)+4,-1);
                    itts = fread(fid,1,'int');
                    fseek(fid,datapos(i)+sizeread+12,-1);
                    for j = 1:itts

                        piaja = fread(fid,3,'int');
                        nfser = fread(fid,12,'*char');
                        nn = fread(fid,2,'int');
                        fseek(fid,8,0);
                        p(i,j) = piaja(1);
                        iaf(i,j) = piaja(2);
                        jaf(i,j) = piaja(3);
                        nftid{i,j} = nfser(1:6);
                        serial{i,j} = nfser(7:end);
                        nload(i,j) = nn(1);
                        nfra(i,j) = nn(2);
                    end
                end
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2vec',1:kan,resinfo.core.mminj);
                    [iaf jaf] = mminj2ij(resinfo.core.mminj2x2);
                    dists.iaf = iaf;
                    dists.jaf = jaf;
                    dists.lab = nftid(subnums);
                    dists.ser = serial(subnums);
                    dists.nload = nload(subnums);
                    dists.nfra = nfra(subnums);                    
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knums = subnums';
                    if length(knumit) >1
                        k = 1;
                        [ia ja] = convert2x2('2ij',knumit,resinfo.core.mminj);
                        for i = 1:length(knumit)
                            fseek(fid,datapos(knums(k))+4,-1);
                            itts = fread(fid,1,'int');
                            fseek(fid,datapos(knums(k))+sizeread+12,-1);
                            iaf{i} = ia(i,:);
                            jaf{i} = ja(i,:);
                            for l = 1:4
                                for j = 1:itts
                                
                                    piaja = fread(fid,3,'int');
                                    nfser = fread(fid,12,'*char');
                                    nn = fread(fid,2,'int');
                                    fseek(fid,8,0);
                                    p{i}(l,j) = piaja(1);
                                    nftid{i}{l,j} = nfser(1:6);
                                    serial{i}{l,j} = nfser(7:end);
                                    nload{i}(l,j) = nn(1);
                                    nfra{i}(l,j) = nn(2);
                                    
                                end
                                k = k+1;
                            end
                        end
                        dists.iaf = iaf;
                        dists.jaf = jaf;
                        dists.lab = nftid;
                        dists.ser = serial;
                        dists.nload = nload;
                        dists.nfra = nfra;
                        fclose(fid);
                        return
                    end
                else
                    for i = 1:length(knumit);
                        [knums(i) pos(i)] = find(resinfo.core.knum == knumit(i));
                    end
                end
                            
                for i = 1:length(knums)
                    fseek(fid,datapos(knums(i))+4,-1);
                    itts = fread(fid,1,'int');
                    fseek(fid,datapos(knums(i))+sizeread+12,-1);
                    for j = 1:itts

                        piaja = fread(fid,3,'int');
                        nfser = fread(fid,12,'*char');
                        nn = fread(fid,2,'int');
                        fseek(fid,8,0);
                        p(i,j) = piaja(1);
                        iaf(i,j) = piaja(2);
                        jaf(i,j) = piaja(3);
                        nftid{i,j} = nfser(1:6);
                        serial{i,j} = nfser(7:end);
                        nload(i,j) = nn(1);
                        nfra(i,j) = nn(2);
                    end
                end
                if resinfo.core.if2x2 == 2
                    [iaf jaf] = convert2x2('2ij',knumit,resinfo.core.mminj);
                end
                if length(knumit) == 1 && itts == 1 && resinfo.core.if2x2 ~= 2
                   serial = serial{1}; 
                   nftid = nftid{1};
                end
            end
        
            
            if ~allass && ~strcmpi(resinfo.core.sym,'full') 
                if itts ~=1
                    dists.knums = cpos2knum(iaf,jaf,resinfo.core.mminj);
                end
                for i = 1:length(knumit)
                    dists.iaf(i) = iaf(i,pos(i));
                    dists.jaf(i) = jaf(i,pos(i));
                    dists.lab(i) = nftid(i,pos(i));
                    dists.ser(i) = serial(i,pos(i));
                    dists.nload(i) = nload(i,pos(i));
                    dists.nfra(i) = nfra(i,pos(i));
                end
                if itts ~=1
                    dists.knums = cpos2knum(dists.iaf,dists.jaf,resinfo.core.mminj);
                end

            else
            
                dists.iaf = iaf;
                dists.jaf = jaf;
                dists.lab = nftid;
                dists.ser = serial;
                dists.nload = nload;
                dists.nfra = nfra;
            end
        fclose(fid);
        
        case {'IBAT' } 
            [datpos] = FindPos(resinfo.data.Fuel_data,'ASSEMBLY DATA       ');
            datapos = datpos{1} + offsetstpt;
            fseek(fid,datapos(1),-1);
            blk_size=fread(fid,1,'int');
            kan = GetSymKan(resinfo);
            if allass
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',1:kan,resinfo.core.mminj);
                    itvec = subnums(:,1)';
                else
                    itvec = 1:kan;
                end
                dist = zeros(1,kan);
                it = 1;
                for i = itvec
                    fseek(fid,datapos(i)+blk_size+3*i_int + 4*i_int+ifloat + 12,-1);
                    dist(it)=fread(fid,1,'int32');
                    it = it+1;
                end
            else
                if resinfo.core.if2x2 == 2
                    subnums = convert2x2('2subnum',knumit,resinfo.core.mminj);
                    knumit = subnums(:,1)';
                end
                % TODO: kolla denna om den gör rätt på halv/kvart...
                dist = zeros(size(knumit));
                for i = 1:length(knumit)
                    fseek(fid,datapos(i)+blk_size+3*i_int + 4*i_int+ifloat + 12,-1);
                    dist(i)=fread(fid,1,'int32');
                end
            end
            dists = dist';
            fclose(fid);
        
        case 'LIBRARY'
            derivedterms = GetDist(resinfo,'derived terms           ',fid,offsetstpt);
            Core = GetDist(resinfo,'CORE                ',fid,offsetstpt);
            nfta = GetResData(resinfo,'nfta',stptinp);
            fueldata = GetDist(resinfo,'FUEL      ',fid,offsetstpt);
            segment = GetDist(resinfo,'SEGMENT           ',fid,offsetstpt);
            hvmtl = GetDist(resinfo,'HEAVY METAL         ',fid,offsetstpt);
            vers26 = GetDist(resinfo,'VERSION 2.60        ',fid,offsetstpt);
            LMPAR=double(Parameters{1,1});
            
            limfue=LMPAR(16);
            limzon=LMPAR(23); 
            limtfu=LMPAR(22);
            limseg=LMPAR(3);
            dxassm=Core{1,1}(1);
            hz=double(derivedterms{1,2}(2));
            Nzon=reshape(fueldata{1,2}',limzon,limfue);
            Zzon=reshape(fueldata{2,2}',limzon+1,limfue);
            segments=reshape(segment{1,1},20,length(segment{1,1})/20)';
            heavym=segment{1,4}(limtfu*limseg+1:(limtfu+1)*limseg);
            hvy741=reshape(hvmtl{1},resinfo.core.iafull,resinfo.core.iafull);
            cd_file=deblank(vers26{1,3});
            
            % taken from read_restart_bin
            nfta_list=[];
            for i=min(nfta):max(nfta);
                ii=find(nfta==i);
                if ~isempty(ii)
                    lim=Zzon(2:end,i);
                    ibort= lim==0;
                    lim(ibort)=[];
                    lim=[0;lim];
                    number=Nzon(:,i);
                    ibort= number==0;
                    number(ibort)=[];
                    number(1)=[];
                    [nodal,nodal2,w2,nodal3,w3]=set_nodal_value(number,lim,hz,resinfo.core.kmax);
                    nfta_list=[nfta_list i];
                    for j=1:length(ii),
                        Core_Seg(:,ii(j))=nodal;
                        Core_Seg2(:,ii(j))=nodal2;
                        Core_Seg3(:,ii(j))=nodal3;
                        Seg2_w(:,ii(j))=w2;
                        Seg3_w(:,ii(j))=w3;
                    end
                end
            end
            dists.Core_Seg{1}=Core_Seg;
            dists.Core_Seg{2}=Core_Seg2;
            dists.Core_Seg{3}=Core_Seg3;
            dists.Seg_w{1}=1-Seg2_w-Seg3_w;
            dists.Seg_w{2}=Seg2_w;
            dists.Seg_w{3}=Seg3_w;
            dists.Segment=segments;
            iseg=unique([dists.Core_Seg{1}(:);dists.Core_Seg{2}(:)]);
            iseg(iseg==0)=[];
            segnodw=heavym(iseg)*dxassm*dxassm*hz/1e3;
            iseg1=dists.Core_Seg{1};
            iseg2=dists.Core_Seg{2};
            wseg1=zeros(size(iseg1));wseg2=wseg1;
            for i=1:length(iseg),
                wseg1(iseg1==iseg(i))=segnodw(i);
                wseg2(iseg2==iseg(i))=segnodw(i);
            end
            dists.NodeWCas=dists.Seg_w{1}.*wseg1+dists.Seg_w{2}.*wseg2;
            Wfac=cor2vec(hvy741,resinfo.core.mminj)./sum(dists.NodeWCas);
            Wfac=repmat(Wfac,resinfo.core.kmax,1);
            dists.NodeW=dists.NodeWCas.*Wfac;
            dists.fueloa=hvy741;
            dists.cd_file=cd_file;
            fclose(fid);
        case 'NFTA'
            locat = GetDist(resinfo,'LOCATION',fid,offsetstpt);
            iafull = resinfo.core.iafull;
            mminj = resinfo.core.mminj;
            sym = resinfo.core.sym;
            switch sym
                case 'FULL'
                    fnfcor = reshape(locat{1},iafull+2,iafull+2);
                    nftcor = fnfcor(2:end-1,2:end-1);
                    nfta = cor2vec(nftcor,mminj); 
                case 'S'
                    fnfcor = reshape(locat{1},ceil((iafull+2)/2),iafull+2);
                    nftcor = fnfcor(1:end-1,2:end-1);
                    knum = sym2knum(mminj,sym);
                    nfta = cor2vec(nftcor,mminj,knum,sym);

                case 'SE'
                    fnfcor = reshape(locat{1},ceil((iafull+2)/2),ceil((iafull+2)/2));
                    nftcor = fnfcor(1:end-1,1:end-1);
                    knum = sym2knum(mminj,sym);
                    nfta = cor2vec(nftcor,mminj,knum,sym);
            end  

            dists = nfta;
            fclose(fid);
        
        case 'CONTROL ROD'
            mminj = resinfo.core.mminj;
            irmx = resinfo.core.irmx;
            roddata = GetDist(resinfo,'ROD                 ',fid,offsetstpt);
            rodstep = GetDist(resinfo,'CRD STP             ',fid,offsetstpt);
            ver22 = GetDist(resinfo,'VERSION 2.20        ',fid,offsetstpt);
            LMPAR2=double(Parameters{1,2});    
            lngng=Parameters{1,4}(1);
            lngngstp=Parameters{1,4}(3);
            dzstep=ver22{1};
            limcrd=LMPAR2(8);   
            lcrzon=LMPAR2(9);
            npfw=roddata{3,1}(1);
            konrod=double(reshape(roddata{1,2},irmx,irmx));
            crdnam=roddata{5,5};
            Crdnam=cellstr(reshape(crdnam,10,length(crdnam)/10)');
            ncrd=reshape(roddata{3,5},lcrzon,limcrd);
            NoOfCRD=find(ncrd(1,:), 1,'last');
            Crdnam=Crdnam(1:NoOfCRD);
            crd_gray=reshape(roddata{1,6},lcrzon,limcrd);
            crdzon=reshape(roddata{1,5},lcrzon,limcrd);
            crdgng=reshape(rodstep{5},lngng*5,lngngstp)';
            crtyp_map=double(reshape(roddata{1,4},irmx,irmx));
            
            if length(find(crtyp_map(:)))==irmx*irmx,
                crmminj=mminj2crmminj(mminj,irmx);
            else
                crmminj=mminj2crmminj(crtyp_map);
            end
            
            crdcellid=textscan(rodstep{4},'%5s');
            crdid=crdcellid{1};
            crtyp_vec=cor2vec(crtyp_map,crmminj);
            dists.crtyp=crtyp_vec;
            dists.crmminj = crmminj;
            dists.konrod = cor2vec(konrod,crmminj);
            dists.crdnam=Crdnam;
            dists.crdid = crdid;
            dists.crdgng = crdgng;
            dists.dzstep = dzstep;
            dists.crdsteps = npfw;
            dists.crdzon = crdzon;
            dists.crd_gray = crd_gray;
            dists.ncrd = ncrd;
            dists.iofset = Dimensions{2,1}(4);
            fclose(fid);
            
        case 'KEFF'

            dervived_terms = GetDist(resinfo,'DERIVED TERMS       ',fid,offsetstpt);
            keff = dervived_terms{1,1};
            dists = keff;
            fclose(fid);
        case 'NFRA'
            rotat = GetDist(resinfo,'ROTATION',fid,offsetstpt);
            iafull = resinfo.core.iafull;
            nfcor = reshape(rotat{1},iafull,iafull);
            nfra = cor2vec(nfcor,resinfo.core.mminj);
            
            
            dists = nfra;
            fclose(fid);
            
            
        
            
        case 'NFTA DIST' 
            nfta = GetResData(resinfo,'NFTA',stptinp);
            nftauni = unique(nfta);
            for i = 1:length(nftauni)
                nftanum(i) = sum(nfta==nftauni(i));
            end
            nftadist = nftanum./sum(nftanum);
            dists.nfta = nfta;
            dists.nftanum = nftauni;
            dists.nftadist = nftadist;
            fclose(fid);
        
        
        case {'KONROD','CRD.POS'}
            roddata = GetDist(resinfo,'ROD                 ',fid,offsetstpt);
            ctrdat = GetResDataS3(resinfo,'CONTROL ROD',stptinp);
            crmminj = ctrdat.crmminj;
            konrod=double(reshape(roddata{1,2},resinfo.core.irmx,resinfo.core.irmx));
            konrod=cor2vec(konrod,crmminj);
            dists = konrod;
            fclose(fid);
        
        case 'POWER'
            nodrpf = GetResData(resinfo,'3D NODAL RPF',stptinp);
            kmax = resinfo.core.kmax;
            mminj = resinfo.core.mminj;
            sym = resinfo.core.sym;
            knum = resinfo.core.knum;
            kkan = resinfo.core.kan;


            if2x2 = resinfo.core.if2x2;
            id=double(Dimensions{1,2}(9));
            jd=double(Dimensions{1,2}(10));

            if if2x2 == 2
                id = [id-1 id];
                jd = [jd-1 jd];
                beg = [1 2];
                kkan = 4*kkan;
            else
                beg = 1;
            end
            %TODO: fix the other symmetries
            switch sym
                case 'FULL'
                    power=NaN(kmax,kkan);
                    for i=2:kmax+1,
                        plan=nodrpf{i};
                        plan=reshape(plan,max(id),max(jd));
                        plan(:,jd)=[];
                        plan(id,:)=[];
                        plan(beg,:)=[];
                        plan(:,beg)=[];
                        power(i-1,:)=cor2vec(plan,mminj);
                    end
                case 'SE'
                     power=NaN(kmax,kkan);
                     for i=2:kmax+1,
                        plan=nodrpf{i};
                        plan=reshape(plan,max(id),max(id));
                        plan(:,jd)=[];
                        plan(id,:)=[];
                        zp=NaN(size(plan));
                        plan=[zp zp
                              zp plan];
                        power(i-1,:)=cor2vec(plan,mminj);
                     end
                     power=sym_full(power(:,knum(:,1)),knum);
                case 'S'
                     power=NaN(kmax,kkan);
                     for i=2:kmax+1,
                        plan=nodrpf{i};
                        plan=reshape(plan,max(id),max(jd));
                        plan(id,:)=[];
                        plan(:,jd)=[];
                        plan(:,beg)=[];
                        zp=NaN(size(plan));
                        plan=[zp
                             plan];
                        power(i-1,:)=cor2vec(plan,mminj);
                     end
                     power=sym_full(power(:,knum(:,1)),knum);         
                case 'E'
                     power=NaN(kmax,kkan);
                     for i=2:kmax+1,
                        plan=nodrpf{i};
                        plan=reshape(plan,id,jd);
                        plan(:,jd)=[];
                        plan(id,:)=[];
                        plan(1,:)=[];
                        zp=NaN(size(plan));
                        plan=[zp plan];
                        power(i-1,:)=cor2vec(plan,mminj);
                     end
                     power=sym_full(power(:,knum(:,1)),knum);
                case 'ESE'
                    for i=2:kmax+1,
                        plan=nodrpf{i};
                        plan=reshape(plan,id,jd);            
                        plan(:,jd)=[];
                        plan(id,:)=[];
                        zp=NaN(size(plan));
                        plan=[zp zp
                              zp plan];
                          power(i-1,:)=cor2vec(plan,mminj);
                    end
                    power=sym_full(power(:,knum(:,1)),knum);
            end
            
            dists = power;
            fclose(fid);
            
            
        case 'NHYD'
            %% TODO: kolla om denna ska göras till separat funktion istället??
            fueldata = GetResData(resinfo,'THERMAL HYD',stptinp);
            nhyd=fueldata.nhyd;
            dists = nhyd;
            fclose(fid);
        case 'NHYD DIST'
            fueldata = GetResData(resinfo,'THERMAL HYD',stptinp);
            nhyd=fueldata.nhyd;
            nhyduni = unique(nhyd);
            for i = 1:length(nhyduni)
                nhydnum(i) = sum(nhyd==nhyduni(i));
            end
            nhyddist = nhydnum./sum(nhydnum);
            
            dists.nhyd = nhyd;
            dists.nhydnum = nhyduni;
            dists.nhyddist = nhyddist;
            fclose(fid);
        case 'OPER'
            Core = GetDist(resinfo,'CORE                ',fid,offsetstpt);
            Derived_Terms = GetDist(resinfo,'DERIVED TERMS       ',fid,offsetstpt);
            FuelData = GetDist(resinfo,'FUEL                ',fid,offsetstpt);
            nfta = GetResData(resinfo,'NFTA',stptinp);
            vers26 = GetDist(resinfo,'VERSION 2.60        ',fid,offsetstpt);
            power = GetResData(resinfo,'POWER',stptinp);
            nodalrpf = GetResData(resinfo,'3D NODAL RPF    ',stptinp);
            units = GetResData(resinfo,'UNITS',stptinp);
            hydral = GetResData(resinfo,'THERMAL HYD',stptinp);
            wby = GetResData(resinfo,'WBY',stptinp);
            C = hydral.C;
            kan = resinfo.core.kan;
            percwt=Core{1,1}(6);
            dxassm=Core{1,1}(1);
            floden=Core{1,1}(4)/3600; 
            perctp=Core{1,1}(5);
            powden=Core{1,1}(3);
            pr1=Core{1,1}(7);
            pr2=Core{1,1}(8);
            pr3=Core{1,1}(9);
           
            
            hinlet=Core{1,1}(11);
            hx = double(Derived_Terms{1,2}(1));
            LMPAR=double(Parameters{1,1});
            limzon=LMPAR(23);
            limfue=LMPAR(16);
            Wnom=dxassm*dxassm*resinfo.core.kan*floden; 
            Wrel=percwt;                        % Relative Core flow (%)
            Wtot=Wnom*Wrel/100;                 % Core flow (kg/s)
            Zzon=reshape(FuelData{2,2}',limzon+1,limfue);
            active_hcore=mean(max(Zzon(:,nfta)));
            Qnom=hx*hx*active_hcore*powden*kan;
            
            Oper.Qrel=perctp;                   % Core relative power (%)
            Oper.Qtot=Qnom*Oper.Qrel/100;       % Core Total power (W)
            Oper.Qnom=Qnom;                     % Core nominal (=100%) power
            Oper.Wtot=Wtot;         
            Oper.Wrel=Wrel;
            Oper.Wnom=Wnom;
            Oper.powden=powden;
            Oper.floden=floden*3600;
            Oper.floden_hour=floden;
            Oper.pr1=pr1;
            Oper.pr2=pr2;
            Oper.pr3=pr3;
            psipas=6894.75729; 
            Btu_kJ=1.05505585;
            lbkg=0.45359237;
            Btulb_kJkg=Btu_kJ/lbkg;
            Oper.Hinlet=hinlet*Btulb_kJkg;
            Oper.p_psia = pr1+pr2*perctp+pr3*perctp*perctp;
            Oper.p=Oper.p_psia*psipas;
            Oper.tlp=fzero(@(x) h_v(x,Oper.p)-Oper.Hinlet,270+273.15)-273.15;
            Oper.tlp_F = C2F(Oper.tlp);
%             Oper.Hinlet=hinlet;
            Oper.Hinlet_BTU_lb=hinlet;
            Oper.keff=Derived_Terms{1,1};
            Oper.Power=power;

            bwr_wlt_dim=vers26{1,4};
            bwr_wlt_table=vers26{2,4};
            limwlw=bwr_wlt_dim(2);
            limwlp=bwr_wlt_dim(3);
            nwlcwt=bwr_wlt_dim(4);
            nwlctp=bwr_wlt_dim(5);
            wlt_cwt=bwr_wlt_table(1:nwlcwt);
            wlt_ctp=bwr_wlt_table(limwlw+1:limwlw+nwlctp);
            bwr_wlt_table(1:(limwlw+limwlp))=[];
            wlt_bypass_frac=reshape(bwr_wlt_table',limwlw,limwlp);
            wlt_bypass_frac=wlt_bypass_frac(1:nwlcwt,1:nwlctp)';
            wlk_wt=nodalrpf{1,1}(3);
            
            Oper.wlt_cwt=wlt_cwt;
            Oper.wlt_ctp=wlt_ctp;
            Oper.wlt_bypass_frac=wlt_bypass_frac;
            Oper.wby=wby;
            Oper.wlk_wt=wlk_wt;
            Oper.ifmeti=units{1}(1);
            Oper.Qloss=C(44)*Oper.Qnom;
            Oper.Qcu=C(45)*Oper.Qnom;
            Oper.Wcrd=C(43)*Oper.Wnom;
            Oper.Xco=C(41);
            dists = Oper;
            fclose(fid);
% 
            
%             
        case 'THERMAL HYD'
            hyddata = GetDist(resinfo,'HYDRAULICS          ',fid,offsetstpt);
            unformmdt = GetDist(resinfo,'UNIFORM MDT',fid,offsetstpt);
            bypassvoid = GetDist(resinfo,'BYPASS VOID       ',fid,offsetstpt);
            bypassflow = GetDist(resinfo,'BYPASS FLOW  ',fid,offsetstpt);
            fueldata = GetDist(resinfo,'FUEL      ',fid,offsetstpt);
            axmdt = GetDist(resinfo,'AXIAL MDT       ',fid,offsetstpt);
            vers26 = GetDist(resinfo,'VERSION 2.60    ',fid,offsetstpt);
            units = GetDist(resinfo,'UNITS       ',fid,offsetstpt);
            nfta = GetResData(resinfo,'NFTA',stptinp);
            derivedterms = GetDist(resinfo, 'DERIVED TERMS       ',fid,offsetstpt);
            fixedmaps = GetDist(resinfo,'FIXED MAPS',fid,offsetstpt);
            crddata = GetDist(resinfo,'ROD  ',fid,offsetstpt);
            asslab = GetResData(resinfo,'ASSEMBLY LABELS',stptinp);
            kmax = resinfo.core.kmax;
            lwr = resinfo.core.lwr;
            mminj = resinfo.core.mminj;
            knum = resinfo.core.knum;
            irmx = resinfo.core.irmx;
            ifmeti=units{1}(1);
            bwr_wlt_dim=vers26{1,4};
            bwr_wlt_table=vers26{2,4};
            nhyd=fueldata{1,3};
            LMPAR=double(Parameters{1,1});
            limaclo=LMPAR(1);   limc=LMPAR(2);      limseg=LMPAR(3);    limhyd=LMPAR(4);    limid=LMPAR(5);     limfue=LMPAR(16);
            limnht=LMPAR(17);   limpas=LMPAR(18);   limray=LMPAR(19);   limreg=LMPAR(20);   limtfu=LMPAR(22);   limzon=LMPAR(23);   lmnhyd=LMPAR(24);
            limbat=Parameters{1,3};
            LMPAR2=double(Parameters{1,2});
            limnd=LMPAR2(1);    limctp=LMPAR2(2);   limspa=LMPAR2(3);   limtab=LMPAR2(4);   limtv1=LMPAR2(5);   limtv2=LMPAR2(6);   limele=LMPAR2(7);
            limcrd=LMPAR2(8);   lcrzon=LMPAR2(9);   limch1=LMPAR2(29);  limzmd=LMPAR2(30);  limlkg=LMPAR2(33);  limwtr=LMPAR2(35);  limsup=LMPAR2(36);
            limir=LMPAR2(58);   limct=LMPAR2(65);   nsegch=LMPAR2(91);
            ida=double(Dimensions{1,2}(7));
            jda=double(Dimensions{1,2}(8));
            
            sym = resinfo.core.sym;
%             [~,sym]=ij2mminj(asslab.iaf,asslab.jaf,asslab.nload);
            
            dimzmd=axmdt{1,1}(1);
            dimspa=axmdt{1,1}(2);
            if dimspa~=limspa||dimzmd~=limzmd,
                FORMAT{1,2}='float'; nr{1,2}=lmnhyd*dimspa;
                for i=3:6, FORMAT{1,i}='float'; nr{1,i}=dimzmd*lmnhyd; end 
                [~,nia] = FindPos(resinfo.data,distlab);
                fseek(fid,offsetstpt + resinfo.data.abs_pos(nia),-1);
                next_record=GetNextRecord(fid,resinfo.data,nia,FORMAT,nr,0);     
                axmdt = next_record.data;
            end
            xxkspa=reshape(axmdt{1,2},dimspa,lmnhyd)';
            dimwtr=bypassflow{1,1}(3);
            
            
            
            aht=hyddata{2,2}(1:lmnhyd);                  
            afl=hyddata{2,2}(lmnhyd+1:2*lmnhyd);      
            dhe=hyddata{2,2}(2*lmnhyd+3:3*lmnhyd+2);    
            xcin=hyddata{2,2}(4*lmnhyd+3:(4*lmnhyd+2+limnht));
            fricm=hyddata{2,2}(4*lmnhyd+limnht+3:(4*lmnhyd+limnht+2+limbat));
            diafue=hyddata{2,2}(4*lmnhyd+limnht+limbat+3:(5*lmnhyd+limnht+2+limbat));
            diawtr=hyddata{2,2}(5*lmnhyd+limnht+limbat+3:(6*lmnhyd+limnht+2+limbat));
            chanel=hyddata{2,2}(6*lmnhyd+limnht+limbat+3:(10*lmnhyd+limnht+2+limbat));
            chanel=reshape(chanel,4,lmnhyd);
            elevat=hyddata{2,2}(10*lmnhyd+limnht+limbat+3:(10*lmnhyd+limnht+2+limbat+limele));
            xkspac=hyddata{2,2}((10*lmnhyd+limnht+3+limbat+limele):(11*lmnhyd+limnht+2+limbat+limele));
            kltp=hyddata{2,2}((11*lmnhyd+limnht+3+limbat+limele):(12*lmnhyd+limnht+2+limbat+limele));
            kutp=hyddata{2,2}((12*lmnhyd+limnht+3+limbat+limele):(13*lmnhyd+limnht+2+limbat+limele));
            nsepat=hyddata{3,2}(1);
            ksepat=hyddata{4,2}(1);
            wlorif=hyddata{4,2}(9);
            ispacr=hyddata{1,6}(1);
            spavoi=hyddata{2,6}(1);
            dzflow=hyddata{2,6}(2);
            voidpt=hyddata{2,6}(3);
            voifac=hyddata{2,6}(4);
            Profil=hyddata{2,6}(5);
            chanel5=unformmdt{1,2};
            zspacr=fueldata{6,2};
            zspacr=reshape(zspacr,limspa,lmnhyd)';
            zspacr=rensa(zspacr,0);
            ninwrg=bypassvoid{1,8};ninwrg=reshape(ninwrg',dimwtr,lmnhyd)';
            kinwtr=reshape(bypassflow{2,5}(4*dimwtr*lmnhyd+1:5*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
            bypass_card=reshape(bypassvoid{1,7}',8,lmnhyd)';
            bypass_type=reshape(bypassvoid{1,6}',dimwtr*4,lmnhyd)';
            aflmdt=reshape(axmdt{1,3},dimzmd,lmnhyd)';
            kan_res=double(round(derivedterms{1,2}(6)));
            dinwtr=reshape(bypassflow{2,5}(2*dimwtr*lmnhyd+1:3*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
            dowtr=reshape(bypassflow{2,5}(3*dimwtr*lmnhyd+1:4*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
            dimrin=bypassvoid{1,1}(2);
            kinwrg=bypassvoid{2,8}(dimwtr*dimrin*lmnhyd+1:2*dimwtr*dimrin*lmnhyd);
            kinwrg=reshape(kinwrg',dimrin*dimwtr,lmnhyd)';
            kexwtr=reshape(bypassflow{2,5}(5*dimwtr*lmnhyd+1:6*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
            dimrex=bypassvoid{1,1}(3);
            nexwrg=bypassvoid{1,9};nexwrg=reshape(nexwrg',dimwtr,lmnhyd)';
            kexwrg=bypassvoid{2,9}(dimwtr*dimrex*lmnhyd+1:2*dimwtr*dimrex*lmnhyd);
            kexwrg=reshape(kexwrg',dimrex*dimwtr,lmnhyd)';
            zmdt=reshape(axmdt{1,6},dimzmd,lmnhyd)';
            dhymdt=reshape(axmdt{1,4},dimzmd,lmnhyd)';
            phmdt=reshape(axmdt{1,5},dimzmd,lmnhyd)';
            crtyp_map=double(reshape(crddata{1,4},irmx,irmx));
            
            if size(chanel5,2)==size(chanel,2), chanel=[chanel;chanel5]; end
            xxcin=unformmdt{1,4};
            xxcin=reshape(xxcin,limnht,lmnhyd)';
            xxcin=rensa(xxcin,-10000);
            AWTR=reshape(bypassvoid{1,3}(3*lmnhyd+1:3*lmnhyd+lmnhyd*limwtr),limwtr,lmnhyd)';
            BWTR=reshape(bypassvoid{1,3}(3*lmnhyd+lmnhyd*limwtr+1:3*lmnhyd+2*lmnhyd*limwtr),limwtr,lmnhyd)';
            AMDT=bypassvoid{1,3}(1:lmnhyd);
            BMDT=bypassvoid{1,3}(lmnhyd+1:2*lmnhyd);
            CMDT=bypassvoid{1,3}(2*lmnhyd+1:3*lmnhyd);
            dimsup=bypassflow{1,1}(4);
            if_wlt=bwr_wlt_dim(1);
            nsup=bypassflow{1,6}(1:dimsup);
            nsup0= nsup==0;nsup(nsup0)=[];
            lsup=length(nsup);
            casup=bypassflow{2,6}(1:lsup);
            cbsup=bypassflow{2,6}(dimsup+1:dimsup+lsup);
            ccsup=bypassflow{2,6}(2*dimsup+1:2*dimsup+lsup);
            rho_ref_bypass=bypassflow{2,6}(3*dimsup+1:3*dimsup+lsup);
            nht=reshape(fixedmaps{1,2},ida,jda);
            
            %% loop taken from read_restart_bin
            if strncmp(lwr,'BWR',3),
                Kin_wtr={};
                Kex_wtr={};
                Kin_wr_lump={};
                Kex_wr_lump={};
                hz=double(derivedterms{1,2}(2));
                nhyd_in_core=unique(nhyd(unique(nfta)));
                iwtr=0;
                for i=nhyd_in_core,                           % find max no of wtr rods
                    iwtr=max(iwtr,length(find(ninwrg(i,:))));
                    iwtr=max(length(find(kinwtr(i,:))),iwtr);
                end
                % Preallocate and Predimension
                A_wr=cell(1,iwtr);
                Ph_wr=cell(1,iwtr);
                Dhy_wr=cell(1,iwtr);
                for i=1:iwtr,
                    A_wr{i}=zeros(1,kan_res);
                    Ph_wr{i}=zeros(1,kan_res);
                    Dhy_wr{i}=zeros(1,kan_res);
                end

                for i=nhyd_in_core,                           % i loops over mechanical types in core
                    i_nhyd=find(nhyd(nfta)==i);
                    iwtr=length(find(ninwrg(i,:)));
                    iwtr=max(length(find(kinwtr(i,:))),iwtr);
                    for i1=1:iwtr,                                     % i1 loops over types of water rods
                        rod_type=remblank(bypass_type(i,(i1-1)*4+1:i1*4));
                        switch rod_type
                            case 'GEN'
                                A_wr{i1}(i_nhyd)=dinwtr(i,i1);           % For case 'GEN', Area is to be found in dinwtr!
                                Ph_wr{i1}(i_nhyd)=dowtr(i,i1);           % and inside wetted perimeter in dowtr!!
                                Dhy_wr{i1}(i_nhyd)=4*A_wr{i1}(i_nhyd)./Ph_wr{i1}(i_nhyd); % cf SUBROUTINE setbwr in S3
                            case 'TUBE'
                                Dhy_wr{i1}(i_nhyd)=dinwtr(i,i1);
                                A_wr{i1}(i_nhyd)=pi*Dhy_wr{i1}(i_nhyd).*Dhy_wr{i1}(i_nhyd)/4;
                                Ph_wr{i1}(i_nhyd)=pi*Dhy_wr{i1}(i_nhyd);
                        end
                        switch bypass_card(i,:)
                            case 'BWR.WTG '
                                one_sqrt_Klump=0;
                                for j=1:ninwrg(i,i1),                              % j loops over number of inlets to water rod
                                    Kin_wtr{i1,j}(i_nhyd)=kinwrg(i,(i1-1)*dimrin+j);
                                    one_sqrt_Klump=one_sqrt_Klump+1/sqrt(kinwrg(i,(i1-1)*dimrin+j));
                                end
                                Kin_wr_lump{i1}(i_nhyd)=1/(one_sqrt_Klump)^2;
                                one_sqrt_Klump=0;
                                for j=1:nexwrg(i,i1)                               % j loops over number of exits from water rod
                                    Kex_wtr{i1,j}(i_nhyd)=kexwrg(i,(i1-1)*dimrin+j);
                                    one_sqrt_Klump=one_sqrt_Klump+1/sqrt(kexwrg(i,(i1-1)*dimrin+j));
                                end
                                Kex_wr_lump{i1}(i_nhyd)=1/(one_sqrt_Klump)^2;
                            case 'BWR.WTR '
                                Kin_wtr{i1}(i_nhyd)=kinwtr(i);
                                Kin_wr_lump{i1}(i_nhyd)=kinwtr(i);
                                Kex_wtr{i1}(i_nhyd)=kexwtr(i);
                                Kex_wr_lump{i1}(i_nhyd)=kexwtr(i);
                        end
                    end
                end
                %%
                ftcm=30.48;
                afuel=zeros(kmax,kan_res);dhfuel=afuel;phfuel=afuel;
                uniflag=ones(length(nhyd_in_core),1);
                Xcin=zeros(1,kan_res);vhifuel=Xcin;vhofuel=Xcin;
                for i=nhyd_in_core,
                    if aflmdt(i,1)==0,
                        uniflag(i)=1;
                    else
                        uniflag(i)=0;
                    end
                    if isnan(xxcin(i,1)),
                        XCIN=xcin(1);
                    else
                        XCIN=xxcin(i,1);
                    end
                    if uniflag(i),
                        AFL(1:kmax,1)=afl(i)*ftcm*ftcm;   % These are in feet
                        DHY(1:kmax,1)=diafue(i)*ftcm;
                        PH(1:kmax,1)=dhe(i)*ftcm;
                    else
                        zmdti=rensa(zmdt(i,:),-10000);
                        aflmdti=rensa(aflmdt(i,:),0);
                        [number,lim]=set_lim(aflmdti,zmdti,kmax,hz);
                        AFL=set_nodal_value(number,lim,hz,kmax);
                        dhymdti=rensa(dhymdt(i,:),0);
                        [number,lim]=set_lim(dhymdti,zmdti,kmax,hz);
                        DHY=set_nodal_value(number,lim,hz,kmax);
                        lz=length(find(~isnan(zmdti)));
                        if lz==1,
                            PH(1:kmax,1)=phmdt(i,1);
                        else
                            [number,lim]=set_lim(phmdt(i,:),zmdti,kmax,hz);
                            PH=set_nodal_value(number,lim,hz,kmax);
                        end
                    end
                    i_nhyd=find(nhyd(nfta)==i);
                    for i1=1:kmax,
                        afuel(i1,i_nhyd)=AFL(i1);
                        dhfuel(i1,i_nhyd)=DHY(i1);
                        phfuel(i1,i_nhyd)=PH(i1);
                    end
                    Xcin(i_nhyd)=XCIN*AFL(1)^2/1e4;               % First we just assume normal orifice, we deal with specials later
                    vhifuel(i_nhyd)=kltp(i);                      % Reference area = 100 cm2, thus 1e4 (=Aref^2)
                    vhofuel(i_nhyd)=kutp(i);
                end
                %%
                orityp=cor2vec(nht,mminj,knum,sym);                     % Now fix the special orifices
                orityp=orityp(knum(:,1)');
                num_orityp=length(unique(orityp));
                for j=2:num_orityp
                    for i=nhyd_in_core
                        if isnan(xxcin(i,1)),
                            kvot=xcin(j)/xcin(1);
                        else
                            kvot=xxcin(i,j)/xxcin(i,1);
                        end
                        ind=find(orityp==j&nhyd(nfta(knum(:,1)))==i);
                        Xcin(ind)=Xcin(ind)*kvot;
                    end
                end
                %%
            %     fue_new.chanel=chanel;
            %     fue_new.elevat=elevat;
                dists.afuel=afuel;
                dists.dhfuel=dhfuel;
                dists.phfuel=phfuel;
                dists.xxcin=xxcin;
                dists.A_wr=A_wr;
                dists.Ph_wr=Ph_wr;
                dists.Dhy_wr=Dhy_wr;
                % TODO fix this properly! (i.e. find out what Kin_wr_lump should be!)
                if exist('Kin_wr_lump','var'),
                    for i=1:length(Kin_wr_lump),
                        if length(Kin_wr_lump{i})<kan_res,
                            Kin_wr_lump{i}(kan_res)=0;
                        end
                    end
                    % TODO fix this properly! (i.e. preallocate instead)
                    for i=1:length(Kex_wr_lump),
                        if length(Kex_wr_lump{i})<kan_res,
                            Kex_wr_lump{i}(kan_res)=0;
                        end
                    end
                else
                    Kin_wr_lump=[];Kex_wr_lump=[];
                end
                dists.Kin_wr=Kin_wr_lump;
                dists.Kex_wr=Kex_wr_lump;
                dists.Kin_wtr=Kin_wtr;
                dists.Kex_wtr=Kex_wtr;
                dists.vhifuel=-vhifuel;
                dists.vhofuel=-vhofuel;
                dists.Xcin=-Xcin;
                dists.orityp=orityp;


            else % PWR
                dists.crtyp_map=crtyp_map;
                % TODO: kolla upp PWR grejer...
                if resinfo.core.if2x2==2,
            %             if length(find(crtyp_map(:)))==irmx*irmx,
            %         crmminj=mminj2crmminj(mminj,irmx);
            %     else
            %         crmminj=mminj2crmminj(crtyp_map);
            %     end
            %         dists.ia=ia;
            %         dists.ja=ja;
            %         dists.mminjh=(mminj(1:2:end)+1)/2;
            %         dists.crmminj=fue_new.mminjh;
            %         dists.crtyp=cor2vec(crtyp_map,fue_new.crmminj);
            %         dists.konrod_map=konrod;
            %         konrod=cor2vec(konrod,fue_new.crmminj);
                end
            end
       
            dists.C=hyddata{1,1};
            dists.chanel=chanel;
            dists.elevat= elevat;            
            dists.xxcin = xxcin;
            dists.awtr = AWTR;
            dists.bwtr = BWTR;
            dists.nhyd = nhyd(nfta);
            dists.amdt = AMDT(nhyd(nfta));
            dists.bmdt = BMDT(nhyd(nfta));
            dists.cmdt = CMDT(nhyd(nfta));
            dists.xxkspa = xxkspa;
            dists.xkspac = xkspac;
            dists.zspacr = zspacr;
            dists.if_wlt = if_wlt;
            dists.casup = casup;
            dists.cbsup =cbsup;
            dists.ccsup =ccsup;
            dists.rhoref_bypas = rho_ref_bypass;
            dists.ifmeti = ifmeti;
            fclose(fid);

%             
%         
%             
%             
%             
%         
%             
%             
%         case 'FUE NEW'
%             
%             exceptions = GetResData('exceptions');
%             if resinfo.core.ihaveu == 4
%                 excep = {exceptions{:}, 'FUE NEW', 'OPER','PINPOW','PINEXP','NFRA','NFTA','NHYD','KONROD','IBAT'};
%             else
%                 excep = {exceptions{:}, 'FUE NEW', 'OPER','PINPOW','PINEXP','NFRA','NFTA','NHYD','KONROD','IBAT','PINDATA'};
%             end
% 
% %             excep = {exceptions{:}, 'FUE NEW', 'OPER','PINPOW','PINEXP','NFRA','NFTA','NHYD','KONROD','IBAT','WBY'};
%             Dists = CaseReader('GetResData.m',excep,0);
%             distnames = upper(genvarname(Dists));
%             for i = 1:length(Dists)
%             dist = GetResData(resinfo,Dists{i},stptinp);
%                 if isstruct(dist)
%                     finam = fieldnames(dist);
%                     c = struct2cell(dist);
%                     for l = 1:length(finam)
%                         eval(['dists.'  finam{l} '=' 'c{l}' ';']);
%                     end
%                 else
%                     eval(['dists.' distnames{i} '=' 'dist;']);
%                 end
%             end
%             
            
            
        
%             
        case 'WBY'
            nodrpf = GetResData(resinfo,'3D NODAL RPF',stptinp);
            id=double(Dimensions{1,2}(9));
            jd=double(Dimensions{1,2}(10));
            mminj = resinfo.core.mminj;
            

            sym = resinfo.core.sym;
            knum = sym2knum(mminj,sym);
            if ~isempty(nodrpf),
                wbyxy=reshape(nodrpf{1,2},id,jd);
                switch sym
                    case 'FULL'
                        wbyxy(:,jd)=[]; % Remove reflector layers
                        wbyxy(id,:)=[];
                        wbyxy(1,:)=[];
                        wbyxy(:,1)=[];
                        wby=cor2vec(wbyxy,mminj);
                    case 'SE'
                        wbyxy(:,jd)=[]; % Remove reflector layers
                        wbyxy(id,:)=[];
                        zp=zeros(size(wbyxy));
                        wbyxy=[zp zp
                            zp wbyxy];
                        wby=cor2vec(wbyxy,mminj);
                        wby=sym_full(wby(knum(:,1)),knum);
                    case 'S'
                        wbyxy(:,jd)=[]; % Remove reflector layers
                        wbyxy(id,:)=[];
                        wbyxy(:,1)=[];
                        zp=zeros(size(wbyxy));
                        wbyxy=[zp;wbyxy];
                        wby=cor2vec(wbyxy,mminj);
                        wby=sym_full(wby(knum(:,1)),knum);
                    case 'E'
                        wbyxy(:,jd)=[]; % Remove reflector layers
                        wbyxy(id,:)=[];
                        wbyxy(1,:)=[];
                        zp=zeros(size(wbyxy));
                        wbyxy=[zp wbyxy];
                        wby=cor2vec(wbyxy,mminj);
                        wby=sym_full(wby(knum(:,1)),knum);
                    case 'ESE'
                        wbyxy(:,jd)=[]; % Remove reflector layers
                        wbyxy(id,:)=[];
                        zp=zeros(size(wbyxy));
                        wbyxy=[zp zp
                            zp wbyxy];
                        wby=cor2vec(wbyxy,mminj);
                        wby=sym_full(wby(knum(:,1)),knum);
                end
            else
                wby=[];

            end
            dists = wby;
            fclose(fid);
        case 'DIMS'
            derivedterms = GetDist(resinfo,'DERIVED TERMS',fid,offsetstpt);
            Core = GetDist(resinfo,'CORE',fid,offsetstpt);
            Fuel_Data = GetDist(resinfo,'FUEL',fid,offsetstpt);
            nfta = GetResDataS3(resinfo,'NFTA',stptinp);
            limzon =Parameters{1,1}(23);
            limfue = Parameters{1,1}(16);
            Zzon=reshape(Fuel_Data{2,2}',limzon+1,limfue);
            
            active_hcore=mean(max(Zzon(:,nfta)));
            dxassm=Core{1,1}(1);
            hcore=Core{1,1}(2);
            hx = derivedterms{1,2}(1);
            hz = derivedterms{1,2}(2);
            dists.hx = hx;
            dists.hz = hz;
            dists.dxassm = dxassm;
            dists.hcore = hcore;
            dists.active_hcore = active_hcore;
            fclose(fid);
        case 'ASMNAM'
            Fuel_Data = GetDist(resinfo,'FUEL',fid,offsetstpt);
            limfue=Parameters{1}(16);
            asmnam=reshape(Fuel_Data{2,3},20,limfue)';
%             nfta = GetResDataS3(resinfo,'NFTA',stptinp);
            dists = asmnam;
            fclose(fid);
        case 'NLOAD' 
            asslab = GetResData(resinfo,'ASSEMBLY LABELS',stptinp);
            nload = asslab.nload;
            dists = nload;
            fclose(fid);
        case {'AFUEL','DHFUEL','PHFUEL','XCIN','VHIFUEL','VHOFUEL','ORITYP'}
            therhyd = GetResData(resinfo,'THERMAL HYD',stptinp);
            
            fnam = fieldnames(therhyd);
            fistr = fnam(strcmpi(distlab,fieldnames(therhyd)));
            
            eval(['dists=therhyd.' fistr{1} ';'])
            fclose(fid);
        case  {'A_WR{1}', 'PH_WR{1}', 'DHY_WR{1}', 'KIN_WR{1}', 'KEX_WR{1}'}
            therhyd = GetResData(resinfo,'THERMAL HYD',stptinp);
            
            distlabtrim = strtrim(distlab);
            nonumstr = distlabtrim(1:end-3);
            fnam = fieldnames(therhyd);
            fistr = fnam(strcmpi(nonumstr,fieldnames(therhyd)));
            evalstr = ['dists = therhyd.' fistr{1} distlabtrim(end-2:end) ';'];
            eval(evalstr)
            fclose(fid);
        case {'CORE_SEG{1}', 'CORE_SEG{2}', 'SEG_W{1}', 'SEG_W{2}'}
            lib = GetResData(resinfo,'LIBRARY',stptinp);
            
            distlabtrim = strtrim(distlab);
            nonumstr = distlabtrim(1:end-3);
            fnam = fieldnames(lib);
            fistr = fnam(strcmpi(nonumstr,fieldnames(lib)));
            evalstr = ['dists = lib.' fistr{1} distlabtrim(end-2:end) ';'];
            eval(evalstr)
            fclose(fid);
        case 'FLK DATA'
            bypassvoid = GetDist(resinfo,'BYPASS VOID       ',fid,offsetstpt);
            dists.fch = bypassvoid{1,11}(1);
            dists.flk = bypassvoid{1,11}(2);
            dists.flkbox = bypassvoid{1,11}(3);
            dists.flkrod = bypassvoid{1,11}(4);
            fclose(fid);
            
        case 'AXIS LABELS'
            crdstp = GetDist(resinfo,'CRD STP',fid,offsetstpt);
            print = GetDist(resinfo,'PRINT',fid,offsetstpt);
            fclose(fid); 
            % assembly labels
            lab1 = deblank(print{2});
            lab2 = deblank(print{3});
            if ~isempty(lab1)
                dists.asslabs = 1;
                for i = 1:resinfo.core.iafull
                    dists.ax1{i} = lab1((2*i-1):2*i);
                    dists.ax2{i} = lab2((2*i-1):2*i);
                end
            else
                dists.asslabs = 0;
            end
            
            % supercell labels
            lab1 = crdstp{2};
            lab2 = deblank(crdstp{3});
            nosp1 = lab1(~isspace(lab1));
            if ~isempty(lab2)
                dists.sclabs = 1;
                for i = 1:length(nosp1)
                    dists.sc1{i} = nosp1(i);
                    dists.sc2{i} = lab2((2*i-1):2*i);
                end
            else
                dists.sclabs = 0;
            end
        otherwise
            warning('distlist does not exist, see resinfo for complete distlist');
            fclose(fid);
            return;
    end 
        
        
end % end switch
% catch err
%     fclose(fid);
%     error('GetResDataS5:noread', 'Problem reading, ')
%     
% 
% end % end try

end

%% Function using GetNextRecord to read data from a label. If FORMATs and nr is to be added see GetFormatNr.m
function dist = GetDist(resinfo,distlab,fid,offsetst)
    [pos,nia] = FindPos(resinfo.data,distlab);
    [FORMAT nr] = GetFormatNrS5(distlab,resinfo);
    fseek(fid,offsetst + pos,-1);
    next_record=GetNextRecord(fid,resinfo.data,nia,FORMAT,nr,0);                                            
    dist=next_record.data;   
end


function kan = GetSymKan(resinfo)
    ihaveu = resinfo.core.ihaveu;
    % TODO: check if this is correct, if not, change ihaveu to sym.
switch ihaveu
    case 4
        kan = resinfo.core.kan;
    case 3 
        kan = resinfo.core.kan/2;
    case 2 
        kan = resinfo.core.kan/4;
    case 1
        kan = resinfo.core.kan/8;
end
end







