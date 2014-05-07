function [dist,node] = ReadOut2D(TEXT, str, outinfo, stpt)
% ReadOut2D - reads 2D distributions from outfile
%
% [dist,node] = ReadOut2D(outfile, str, core)
% [dist,node] = ReadOut2D(TEXT, str, core)
%
% Input:
% outfile    - name of out file containing the SIM cases
%  or TEXT   - cell array for file with each row in a cell 
% str        - string to find, e.g '2RPF', '2DEN', 'PFLP'
% core       - geometry information (from AnalyzeOut or AnalyzeSum)
%
% Output:
% dist       - cell array of 1 by num_bundles matrices containing distribution values
% node       - for certain distributions, axial position is edited, e.g. PLHGR
%
% Example:
%  >> den2=ReadOut2D('s3.out','2DEN');
%
% See also ReadOut, ReadOut3D, ReadPriMac

% reads3_tip_calc, reads3_tip_calc_CASENO, reads3_tip_map,
% reads3_tip_meas, reads3_tip_meas_CASENO 
% 
%% Make sure TEXT contains what is expected
if ~iscell(TEXT),
    fid=fopen(TEXT,'r');
    TEXT = textscan(fid,'%s','delimiter','\n');
    TEXT = TEXT{1};
    fclose(fid);
end
if nargin<3, 
    outinfo=AnalyzeOut(TEXT);
    str=FindCard(outinfo,str);
    stpt = 1:length(outinfo.Xpo);
elseif nargin <4
    stpt = 1:length(outinfo.Xpo);
end
core = outinfo.core;
[sc,str]=GetScale(str);


str=strrep(str,'(','\(');
str=strrep(str,')','\)');

iprista= find(~cellfun(@isempty,regexp(TEXT,['^',str])));

dif_iprista=diff(iprista);
idif = dif_iprista>100;
ilong=find(idif);
ishort= ~idif;
%% Test For Single assembly, May casuse problems in line 101?!!
N=length(stpt);
temp=iprista;
clear iprista
iprista(1)=temp(1);
if length(temp)>1
    istpt=2;icoun=2;ipstp=1;
    if ishort(1)
        iprista(icoun)=temp(2);
        icoun=icoun+1;
    end
    istart=icoun;
    for i=istart:length(temp)
        if any(istpt==stpt),
            iprista(icoun)=temp(i);
            ipstp=ipstp+1;
            icoun=icoun+1;
        end
        if ipstp>=N&&i==length(temp), break;end
        if  ~ishort(i),
            istpt=istpt+1;
        end
    end
    n=ones(size(iprista));
    dif_iprista=diff(iprista);
    idif = dif_iprista<100;
    ishort=find(idif);
    n(ishort+1)=2;
    if length(n)>N
        n=n(2:2:end); %TODO Fixa
    end
else
    n=1;
end
iafull=core.iafull;
mminj=core.mminj;
mmaxj=iafull+1-mminj;
PWRNodal=false;
if core.if2x2==2&&~isempty(strfind(upper(str),'NODAL')),
    PWRNodal=true;
    mminj=core.mminj2x2;
    mminj=[mminj(1:iafull);1;1;mminj(iafull+1:iafull*2)];
    iafull=iafull*2+2;
    mmaxj=iafull+1-mminj;
end
skipend=true;
if PWRNodal, skipend=false;end
if PWRNodal&&~isempty(strfind(str,'PIN.EDT'))
    skipend=true;
    mminj=core.mminj2x2;
    iafull=core.iafull*2;
    mmaxj=iafull+1-mminj;
end

if any(ishort)
    extraline=mean(dif_iprista(ishort))/iafull>2;
else
    extraline=0;
end
tlm=false;
if strfind(str,'TLM.EDT'),extraline=1;tlm=true;end
if strfind(str,'TLM.EDT 2CPR'),extraline=0;tlm=true;end
dist=cell(1,N);      % Number of state points
if extraline, node=dist;else node=[];end
%% read the distribution
icoun=0;
ett=1+extraline;
do_not_read_rhs=false;
locmap=false;
refflag=false;
for i=1:N
    ettt=0;
    dist{i}=NaN(iafull,iafull);
    if extraline, node{i}=dist{i};m=2;else m=1;end
    icoun=icoun+1;
    row=TEXT{iprista(icoun)+ett};
    iren=findstr(row,'Renorm');
    if iren,
        sc=GetScale(row);
        ettt=1;
        row=TEXT{iprista(icoun)+ett+ettt};
    end
    row(row=='*')=[];
    jcoor=sscanf(row,'%i');
    if min(jcoor)==2, refflag=true;jcoor=jcoor-1;end
    jmax=max(jcoor);
    for i1=1:iafull,
        row=TEXT{iprista(icoun)+ett+ettt+m*i1};
        if isempty(row),
            ettt=ettt+1;
            row=TEXT{iprista(icoun)+ett+ettt+m*i1};
        end
        if skipend,
            row(end-1:end)=[];
        end
        row=strrep(row,'*',' ');
        rowval=sscanf(row,'%g');
        icoor=rowval(1);rowval(1)=[];
        if refflag, icoor=icoor-1;end
        if length(rowval)==1,
            locmap=true;
        end
        if locmap,
            if i1==1, dist2{i}=NaN(iafull,iafull);end
            row=strrep(row,',',' ');
            rowval=sscanf(row,'%g');
            rowval(1)=[];
        end
        juse=jmax;
        if jmax>iafull,
            mminj(2:2:2*iafull)=outinfo.core.mminj*2-1;
            mminj(1:2:end)=outinfo.core.mminj*2-1;
        elseif jmax>(iafull-mminj(icoor)+1),
            do_not_read_rhs=true;
            juse=iafull-mminj(icoor)+1;
        end
        if locmap
            dist{i}(icoor,mminj(icoor):juse)=rowval(1:2:end);
            dist2{i}(icoor,mminj(icoor):juse)=rowval(2:2:end);
        else
            dist{i}(icoor,mminj(icoor):juse)=rowval/sc; % Overkill to deal with the situation when
                                                                     % '0' is used for coordinates rather than 'O'
        end
        if extraline,
            row=TEXT{iprista(icoun)+ett+ettt+m*i1+1};
            rowval=sscanf(row,'%g');
            node{i}(icoor,mminj(icoor):juse)=rowval(1:juse+1-mminj(icoor));
        end
    end
    % This portion takes care of the fact that A-PRI.STA 2RPF does not
    % repeat the A-PRI.STA card before printing rhs of core
    tre=3;
    if PWRNodal, tre=1;end
    testrow=TEXT{iprista(icoun)+ett+ettt+m*iafull+tre};
    read_rhs=false;offset=0;
    if PWRNodal,
        if skipend,
            read_rhs=true;
            offset=1+m*iafull+2;
        else
            rowval= sscanf(testrow,'%g');
            if rowval(1)==juse+1,
                read_rhs=true;
                offset=1+m*iafull;
            end
        end
    else
        if ~isempty(regexp(testrow,'^[*][*] ', 'once')),
            offset=3+m*iafull;read_rhs=true;
        end
    end
    if tlm,
       if ~isempty(regexp(TEXT{iprista(icoun)+ett+ettt+offset+1},'^1S I', 'once')),
           offset=offset+5;
       end
    end
    if n(i)>1, icoun=icoun+1;read_rhs=true;offset=0;ettt=0;end
    if do_not_read_rhs, read_rhs=false; end
    if read_rhs %Read also right hand side
        row=TEXT{iprista(icoun)+ett+ettt+offset};
        row(row=='*')=[];
        jcoor=sscanf(row,'%i');
        if refflag, jcoor=jcoor-1;end
        jmin=min(jcoor);
        for i1=1:iafull,
            row=TEXT{iprista(icoun)+ett+ettt+m*i1+offset};
            if isempty(row),
                ettt=ettt+1;
                row=TEXT{iprista(icoun)+ett+ettt+m*i1+offset};
            end
            rowval=sscanf(row,'%g');
            icoor=rowval(1);rowval(1)=[];
            if refflag, icoor=icoor-1;end
            dist{i}(icoor,jmin:mmaxj(icoor))=rowval(1:mmaxj(icoor)+1-jmin)/sc;
            if extraline,
                row=TEXT{iprista(icoun)+ett+ettt+m*i1+1};
                rowval=sscanf(row,'%g');
                node{i}(icoor,jmin:mmaxj(icoor))=rowval(1:mmaxj(icoor)+1-jmin);
            end
        end
    end
end
if locmap,
    temp=dist;
    clear dist
    dist{1}=temp;
    dist{2}=dist2;
end