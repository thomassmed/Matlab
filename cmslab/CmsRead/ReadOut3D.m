function dist = ReadOut3D(TEXT, str, outinfo, stpt)
% ReadOut3D - reads 3D distributions from outfile
%
% dist = ReadOut2D(outfile, str, core)
% dist = ReadOut2D(TEXT, str, core)
%
% Input:
% outfile    - name of out file containing the SIM cases
%  or TEXT   - cell array for file with each row in a cell 
% str        - string to find, e.g '2RPF', '2DEN', 'PFLP'
% core       - geometry information (from AnalyzeOut or AnalyzeSum)
%
% Output:
% dist       - cell array of 1 by num_bundles matrices containing distribution values
%
% Example:
%  >> den3=ReadOut3D('s3.out','2DEN');
%  >> apow=ReadOut3D('s3.out','A-PRI.STA 3RPF');
%
% See also ReadOut, ReadOut2D, read_restart_bin, read_pri_mac
% reads3_tip_calc, reads3_tip_calc_CASENO, reads3_tip_map,
% reads3_tip_meas, reads3_tip_meas_CASENO 
% 
%% Make sure TEXT contains what is expected
if nargin<4, stpt='all';end

if ischar(TEXT),
    [outinfo,TEXT]=AnalyzeOut(TEXT);
    if nargin==1,
        dist=outinfo;
        return
    end
    stpt=ParseStpt(stpt,outinfo);
    [offset,Nrow]=GetOffset(stpt,outinfo);
    TEXT=TEXT(Nrow(1):Nrow(2));
else
    if nargin<3,
        outinfo=AnalyzeOut(TEXT);
    end
    stpt=ParseStpt(stpt,outinfo);
end



core=outinfo.core;
str=FindCard(outinfo,str);
[sc,str]=GetScale(str);

%%
iprista= find(~cellfun(@isempty,regexp(TEXT,['^',regexptranslate('escape',str)])));
dif_iprista=diff(iprista);
newcase = dif_iprista>200;
newcase=[true;newcase(:)];
N=length(find(newcase));
if length(stpt)>N,
    warning('DistNotFound','Distribution may not be found in all state point');
elseif length(stpt)<N,
    warning('TooManyDists','Seems to be more than one distribution in some state point');
end
iafull=core.iafull;
half=false;
if min(dif_iprista)>(2*iafull+5), half=true;end
dist=cell(1,N);      % Number of state points
%% read the distribution
n=0; %reset state point counter
mminj=core.mminj;
mmaxj=iafull+1-mminj;
kmax=core.kmax;
kan=core.kan;
%%
if strfind(str,'PRI.STA')
    for i=1:length(iprista)
        irow=0;
        if newcase(i),
            n=n+1;
            dist{n}=NaN(kmax,kan);
        end
        for j=1:2,
            irow=irow+1;
            row=TEXT{iprista(i)+irow};
            icoor=sscanf(row(5:7),'%i');
            if j==1,
                irow=irow+1;
                row=TEXT{iprista(i)+irow};
                jcor=textscan(row,'%d/%s');
                jcoor=jcor{1};%jcoorname=jcor{2};
                jmin=min(jcoor);
                jmax=max(jcoor);
                if isempty(TEXT{iprista(i)+irow+1}),
                    irow=irow+1; % take care of the empty row
                end
            end
            if jmin==1,  %Left hand side of core
                jrow=mminj(icoor):jmax;
            else         % Right hand side of core
                jrow=jmin:mmaxj(icoor);
            end
            knum=cpos2knum(icoor*ones(size(jrow)),jrow,mminj);
            for i1=1:kmax,
                irow=irow+1;
                row=TEXT{iprista(i)+irow};
                rowval=sscanf(row,'%g');
                k=rowval(1);rowval(1)=[];
                dist{n}(k,knum)=rowval(1:length(knum)); % Overkill to deal with the situation when
                % '0' is used for coordinates rather than 'O'
            end
            if isempty(regexp(TEXT{iprista(i)+irow+1},'^(ROW')), break;end
        end
    end
else
    leftfirst=cpos2knum(1:iafull,mminj,mminj);
    bun_in_row=iafull-2*(mminj-1);
    two=1+half;
    for i=1:length(iprista)        
        irow=0;
        if newcase(i),
            n=n+1;
            dist{n}=NaN(kmax,kan);
        end
        sc=1;
        irow=irow+1;
        row=TEXT{iprista(i)+irow};
        ir=strfind(upper(row),'RENORM');
        if ir,
            sc=sscanf(row(ir+8:ir+24),'%g');
            k=sscanf(row(end-2:end),'%i');
            irow=irow+1;
            row=TEXT{iprista(i)+irow};
        end
        row=strrep(row,'*',' ');
        jcoor=sscanf(row,'%i');
        for i1=1:iafull,
            irow=irow+1;
            row=TEXT{iprista(i)+irow};
            temp=sscanf(row(1:end-4),'%g');
            icor=temp(1);
            jc=max(mminj(icor),jcoor(1));
            istart=cpos2knum(icor,jc,mminj);
            istop=istart+length(temp)-2;
            dist{n}(k,istart:istop)=temp(2:end)';
        end
        if half,
            irow=irow+3;
            row=TEXT{iprista(i)+irow};
            row=strrep(row,'*',' ');
            jcoor=sscanf(row,'%i');
            for i1=1:iafull,
                irow=irow+1;
                row=TEXT{iprista(i)+irow};
                temp=sscanf(row(1:end-4),'%g');
                icor=temp(1);
                jc=max(mminj(icor),jcoor(1));
                istart=cpos2knum(icor,jc,mminj);
                istop=istart+length(temp)-2;
                dist{n}(k,istart:istop)=temp(2:end)';
            end
        end
    end
end

if length(dist)==1, dist=dist{1};end