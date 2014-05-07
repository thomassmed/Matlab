function dists = ReadMatStab(matfile,distlab)

if nargin>1,
    distlab=cellstr(distlab);
    is3p=find(strncmpi('S3 Power',distlab,8));
    for i=1:length(is3p), distlab{is3p(i)}='Power';end
    imsp=find(strncmpi('Matstab Power',distlab,13));
    for i=1:length(imsp), distlab{imsp(i)}='Ppower';end
    imsp=find(strncmpi('3RPF',distlab,4));
    for i=1:length(imsp), distlab{imsp(i)}='Ppower';end
    icrdpos=find(strncmpi('CRD.POS',distlab,7));
    for i=1:length(icrdpos), distlab{icrdpos(i)}='konrod';end
end

steadyc = {'P','Wl','flowb','tl','Ppower','Pdens','power','alfa','dens','Tfm','fa1','fa2','tfm','tcm','tw','Iboil','Wg','ploss','dpin','dp_wr'};
neuc = {'b','al','neig','betasum'};
matrc = {'ibas_t','ibas_f'};
geomc = {'a_by','dh_by'};
fuenewc = {'xenon','ibat','iodine','promethium','samarium','burnup','vhist','crdhist','tfuhist','nfra','nhyd','afuel','dhfuel','phfuel','A_wr','Ph_wr','Dhy_wr','Kin_wr','Kex_wr','Kin_wtr','Kex_wtr','vhifuel','vhofuel','Xcin','orityp','konrod','crtyp','nfta','lab','ser','nload','iaf','jaf'};
operc = {'Power','wby'};
eigharm = {'evoid', 'efa1', 'eqfiss', 'etl', 'eWg', 'eWl', 'eGamw', 'eqprimw', 'ejm', 'etw', 'etf1', 'etf2', 'etf3', 'etf4', 'etc1', 'etc2'};

if ischar(matfile)
% create matinfo     
    load(matfile,'fue_new','stab','msopt','geom')
    core.mminj = fue_new.mminj;
    core.kmax = fue_new.kmax;
    core.iafull = fue_new.iafull;
    core.kan = fue_new.kan;
    core.isymc = fue_new.isymc;
    core.irmx = fue_new.irmx;
    core.lwr = 'BWR'; % TODO: check if always bwr
    core.if2x2 = fue_new.if2x2;
    core.ihaveu = fue_new.ihaveu;
    core.sym = fue_new.sym;
    core.knum = fue_new.knum;
    core.hz = fue_new.hz;
    core.hx = fue_new.hx;
    core.hcore = fue_new.hcore;
    core.crmminj = fue_new.crmminj;
    core.detloc = fue_new.detloc;
    core.idetz = fue_new.idetz;
    core.ddetz = fue_new.ddetz;
    core.det_axloc = fue_new.det_axloc;
    dists.core = core;
    dists.fileinfo.type = 'mat';
    dists.fileinfo.fullname = file('normalize', matfile);
    dists.fileinfo.name = file('tail', matfile);
    dists.fileinfo.ismatlab = ismatlab;
    dists.Xpo = msopt.xpo;
    distlist = [steadyc'; neuc'; matrc'; geomc'; fuenewc'; operc'; eigharm'];
    
    
    
    misclist = {'Aj' 'Ajt' 'Atj' 'Bj' 'Oper' 'X' 'XS' 'Xsec' 'fue_new' 'geom' 'matr' 'msopt' 'mstabprint' 'neu' 'stab' 'steady' 'termo'}';

    if isfield(stab,'lamh'),
        misclist = [misclist; 'stabh'];
        load(matfile,'stabh');
        stabhl = size(stabh.et,2);
        dists.fileinfo.numstabh = stabhl;
        for i = 1:stabhl
            distlisttemp = cellfun(@(x) [x '_harm' num2str(i)],eigharm,'uniformoutput',0);
            distlist = [distlist; distlisttemp'];
        end
    end
    dists.distlist = distlist;
    dists.misclist = misclist;

    if nargin<2, 
        return; 
    else
        matinfo=dists;
    end
else
    matinfo = matfile;
end

numdist = length(distlab);

rsteadt = 0;
rneu = 0;
rmatr = 0;
rgeom = 0;
rfuenew = 0;
roper = 0;
rstab = 0;
rstabh = 0;
fullname = matinfo.fileinfo.fullname;
distcell = cell(1,numdist);
distread = 1;
for i = 1:numdist
    if max(strcmpi(distlab{i},matinfo.misclist))
        switch strtrim(lower(distlab{i}))
            case 'stab'
                if ~rstab
                    load(fullname,'steady')
                    rstab = 1;
                end
                distcell{i} = stab;
            case 'stabh'
                if ~rstabh
                    load(fullname,'stabh')
                    rstabh = 1;
                end
                distcell{i} = stabh;
            case 'steady'
                if ~rsteadt
                    load(fullname,'steady','geom')
                    rsteadt = 1;
                end
                distcell{i} = steady;
            case 'neu'
                if ~rneu
                    load(fullname,'neu','geom')
                    rneu = 1;
                end
                distcell{i} = neu;    
            case 'matr'
                if ~rmatr
                    load(fullname,'matr')
                    rsteadt = 1;
                end
                distcell{i} = matr;
            case 'geom'
                if ~rgeom
                    load(fullname,'geom')
                    rgeom = 1;
                end
                distcell{i} = geom;
            case 'fue_new' 
                if ~rfuenew
                    load(fullname,'fue_new')
                    rfuenew = 1;
                end
                distcell{i} = fue_new;
            case 'oper'
                if ~roper
                    load(fullname,'Oper')
                    roper = 1;
                end
                distcell{i} = Oper;
            otherwise
                load(fullname,distlab{i});
                eval(['distcell{i} = ' distlab{i} ';'])
                
        end
        distread = 0;
    else 
        if max(strcmp(distlab{i},steadyc))
            if ~rsteadt
                load(fullname,'steady','geom')
                rsteadt = 1;
            end
            temp=steady.(distlab{i});
            if size(temp,1)==geom.kmax*geom.ncc,
                temp=mean(temp,2);
                temp=reshape(temp,geom.kmax,geom.ncc);
            end
            if size(temp,2)==size(geom.knum,1),
                distcell{i}=sym_full(temp,geom.knum);
            else
                distcell{i}=temp;
            end
        elseif strcmp(distlab{i},'chflow')
            load(fullname,'steady','geom');
            distcell{i}=sym_full(steady.Wl(1,:),geom.knum);
        elseif max(strcmp(distlab{i},neuc))
            if ~rneu
                load(fullname,'neu')
                rneu = 1;
            end
            eval(['distcell{i} = neu.' distlab{i} ';']);
        elseif max(strcmp(distlab{i},matrc))     
            if ~rmatr
                load(fullname,'matr')
                rmatr = 1;
            end
            eval(['distcell{i} = matr.' distlab{i} ';']);
        elseif max(strcmp(distlab{i},geomc))
            if ~rgeom
                load(fullname,'geom')
                rgeom = 1;
            end
            eval(['distcell{i} = geom.' distlab{i} ';']);
        elseif max(strcmp(distlab{i},fuenewc))
            if ~rfuenew
                load(fullname,'fue_new')
                rfuenew = 1;
            end
            eval(['distcell{i} = fue_new.' distlab{i} ';']);
        elseif max(strcmp(distlab{i},operc))
            if ~roper
                load(fullname,'Oper')
                roper = 1;
            end
            eval(['distcell{i} = Oper.' distlab{i} ';']);
        elseif max(strncmp(distlab{i},eigharm,length(distlab{i})))
            if ~rstab
                load(fullname,'stab')
                rstab = 1;
            end
            if ~rmatr
                load(fullname,'matr')
                rmatr = 1;
            end
            if ~exist('ibas_t','var')
                ibas_t=matr.ibas_t;
                ibas_f=matr.ibas_f;
            end
            
            load(fullname,'geom');
            knum = matinfo.core.knum;
            kmax = matinfo.core.kmax;
            kan = matinfo.core.kan;
            switch distlab{i}
                case 'efa1'
                    distcell{i}=sym_full(reshape(stab.en,kmax,geom.kan),geom.knum);
                case 'eqfiss'
                    distcell{i}=sym_full(reshape(stab.eq,kmax,geom.kan),geom.knum);
                case 'evoid'
                    distcell{i}=sym_full(reshape(stab.et(ibas_t),kmax,geom.kan),geom.knum);
                case 'etl'
                    distcell{i}=sym_full(reshape(stab.et(ibas_t+1),kmax,geom.kan),geom.knum);
                case 'eWg'
                    distcell{i}=sym_full(reshape(stab.et(ibas_t+2),kmax,geom.kan),geom.knum);
                case 'eWl'
                    distcell{i}=sym_full(reshape(stab.et(ibas_t+3),kmax,geom.kan),geom.knum);
                case 'eGamw'
                    distcell{i}=sym_full(reshape(stab.et(ibas_t+4),kmax,geom.kan),geom.knum);
                case 'eqprimw'
                    distcell{i}=sym_full(reshape(stab.et(ibas_t+5),kmax,geom.kan),geom.knum);
                case 'ejm'
                    distcell{i}=sym_full(reshape(stab.et(ibas_t+6),kmax,geom.kan),geom.knum);
                case 'etf1'
                    distcell{i}=sym_full(reshape(stab.ef(ibas_f),kmax,geom.kan),geom.knum);
                case 'etf2'
                    distcell{i}=sym_full(reshape(stab.ef(ibas_f+1),kmax,geom.kan),geom.knum);
                case 'etf3'
                    distcell{i}=sym_full(reshape(stab.ef(ibas_f+2),kmax,geom.kan),geom.knum);
                case 'etf4'
                    distcell{i}=sym_full(reshape(stab.ef(ibas_f+3),kmax,geom.kan),geom.knum);
                case 'etc1'
                    distcell{i}=sym_full(reshape(stab.ef(ibas_f+4),kmax,geom.kan),geom.knum);
                case 'etc2'
                    distcell{i}=sym_full(reshape(stab.ef(ibas_f+5),kmax,geom.kan),geom.knum);
                case 'etw'
                    distcell{i}=sym_full(reshape(stab.ef(ibas_f+6),kmax,geom.kan),geom.knum);
            end


        elseif strfind(distlab{i},'harm') > 0 & ~isempty(cellfun(@(x) strfind(distlab{i},x),eigharm,'uniformoutput',0))

            if ~rstabh
                load(fullname,'stabh')
                rstabh = 1;
            end
            if ~rmatr
                load(fullname,'matr')
                rmatr = 1;
            end
            if ~exist('ibas_t','var')
                ibas_t=matr.ibas_t;
                ibas_f=matr.ibas_f;
            end
            knum = matinfo.core.knum;
            kmax = matinfo.core.kmax;
            kan = matinfo.core.kan;
            load(fullname,'geom');

            ih=str2double(distlab{i}(end));
            if isempty(ih)||isnan(ih), ih=1;end
            switch distlab{i}(1:strfind(distlab{i},'_harm')-1)
                case 'efa1'
                    distcell{i}=sym_full(reshape(stabh.en(:,ih),kmax,geom.kan),geom.knum,1);
                case 'eqfiss'
                    distcell{i}=sym_full(reshape(stabh.eq(:,ih),kmax,geom.kan),geom.knum,1);
                case 'evoid'
                    distcell{i}=sym_full(reshape(stabh.et(ibas_t,ih),kmax,geom.kan),geom.knum,1);
                case 'etl'
                    distcell{i}=sym_full(reshape(stabh.et(ibas_t+1,ih),kmax,geom.kan),geom.knum,1);
                case 'eWg'
                    distcell{i}=sym_full(reshape(stabh.et(ibas_t+2,ih),kmax,geom.kan),geom.knum,1);
                case 'eWl'
                    distcell{i}=sym_full(reshape(stabh.et(ibas_t+3,ih),kmax,geom.kan),geom.knum,1);
                case 'eGamw'
                    distcell{i}=sym_full(reshape(stabh.et(ibas_t+4,ih),kmax,geom.kan),geom.knum,1);
                case 'eqprimw'
                    distcell{i}=sym_full(reshape(stabh.et(ibas_t+5,ih),kmax,geom.kan),geom.knum,1);
                case 'ejm'
                    distcell{i}=sym_full(reshape(stabh.et(ibas_t+6,ih),kmax,geom.kan),geom.knum,1);
                case 'etf1'
                    distcell{i}=sym_full(reshape(stabh.ef(ibas_f,ih),kmax,geom.kan),geom.knum,1);
                case 'etf2'
                    distcell{i}=sym_full(reshape(stabh.ef(ibas_f+1,ih),kmax,geom.kan),geom.knum,1);
                case 'etf3'
                    distcell{i}=sym_full(reshape(stabh.ef(ibas_f+2,ih),kmax,geom.kan),geom.knum,1);
                case 'etf4'
                    distcell{i}=sym_full(reshape(stabh.ef(ibas_f+3,ih),kmax,geom.kan),geom.knum,1);
                case 'etc1'
                    distcell{i}=sym_full(reshape(stabh.ef(ibas_f+4,ih),kmax,geom.kan),geom.knum,1);
                case 'etc2'
                    distcell{i}=sym_full(reshape(stabh.ef(ibas_f+5,ih),kmax,geom.kan),geom.knum,1);
                case 'etw'
                    distcell{i}=sym_full(reshape(stabh.ef(ibas_f+6,ih),kmax,geom.kan),geom.knum,1);
            end
        end
    end
end
if isempty(distcell)
     warning('distribution not found, see matinfo.distlist or matinfo.misclist');
     return
end
if numdist == 1
    if isstruct(distcell{1}) && distread
        eval(['dists = distcell{1}.' distlab{i} ';'])
    else
        if ischar(distcell{1})
            dists=cellstr(distcell{1});
        else
            dists = distcell{1};
        end
    end
else
    distnames = distlab;
    for i = 1:numdist
        if isnumeric(distcell{i})
            eval(['endstruct.' distnames{i} '=' 'cell2mat(distcell(i));']);
        elseif isstruct(distcell{i})
            eval(['endstruct.' distnames{i} '=' 'distcell{i};']);
        else
            if iscell(distcell{i})
                dist = distcell{i};
            elseif ischar(distcell{i})
                dist=cellstr(distcell{i});
            else
                dist = distcell(i);
            end
            eval(['endstruct.' distnames{i} '=' 'dist;']);
        end
    end
    dists = endstruct;
end

