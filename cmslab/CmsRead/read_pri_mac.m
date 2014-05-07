function xs=read_pri_mac(outfile, str, core)
% read_pri_mac - Reads output from .out file printed with PRI.MAC
%
% xs=read_pri_mac(outfile,xsstr,mminj,kmax)
%
% Input
%   outfile - Filename of print file
%   xsstr   - string containing name as used on outfile
%             (D1,D2,SR1,SA1,SA2,NF1,NF2,K/N)
%   mminj   - Core contour. By default, mminj is read from restart-file (slower)
%   kmax    - number of axial nodes. By default, kmax is read from restart-file (slower)
%
% Output
%   xs - Cross section (kmax by kan)
%
% Example
%
%   [d1,mminj,kmax]=read_pri_mac('s3.out','D1');
%   d2=read_pri_mac('/cms/f3/c12/tip/s3.out','d2',mminj,kmax);
%   cmsplot s3.res d1
%   cmsplot s3.res d2
%   sigr1=read_pri_mac('../test_case/s3-1.out','sr1');
%
%
% See also cmsplot, reads3_out, read_restart_bin

if ~iscell(outfile),
    fid=fopen(TEXT,'r');
    TEXT = textscan(fid,'%s','delimiter','\n');
    TEXT = TEXT{1};
    fclose(fid);
else
    TEXT=outfile;
end
if nargin<3, 
    outinfo=AnalyzeOut(TEXT);
    core=outinfo.core;
    str=FindCard(outinfo,str);
end
%%
[sc,str]=GetScale(str);

iprimac= find(~cellfun(@isempty,regexp(TEXT,['^',str])));
%%
kd=core.kmax+2;
idr=core.iafull+2;
for i=1:length(iprimac),
    




kan=sum(length(mminj)-2*(mminj-1));
if length(iE)==(kmax+2)*2, l_r=1;else l_r=0;end
count=1;
for k=1:kmax+2,
    i_cr=find(icr>iE(count),1,'first');
    sc_fac=1;
    rad=file(icr(i_cr-1)+1:icr(i_cr)-1);
    i_sc=strfind(rad,'REAL VALUE *');
    if ~isempty(i_sc),
        rad_end=rad(i_sc+12:end);
        i_eq=strfind(rad_end,'=');
        sc_fac=sscanf(rad_end(1:i_eq-1),'%g');
        sc_fac=1/sc_fac;
    end
    colmns{count}=sscanf(file(icr(i_cr)+1:icr(i_cr+1)-1),'%g');
    count=count+1;
    for i=1:length(mminj)+2,
        rad=file(icr(i_cr+1+i)+1:icr(i_cr+2+i)-1);
        data{i,k}=sc_fac*sscanf(rad,'%g');
    end
    rowcount=i_cr+1+length(mminj)+3;
    testrad=file(icr(rowcount)+1:icr(rowcount+1)-1);
    coltest=sscanf(testrad,'%g');
    if l_r,
       i_cr=find(icr>iE(count),1,'first');
       colmns_r{count}=sscanf(file(icr(i_cr)+1:icr(i_cr+1)-1),'%g');
       count=count+1;
       for i=1:length(mminj)+2,
           rad=file(icr(i_cr+1+i)+1:icr(i_cr+2+i)-1);
           data_r{i,k}=sc_fac*sscanf(rad,'%g');
       end
     end
end
%%
xs=zeros(kmax,kan);
i2=length(mminj)/2;
for k=2:kmax+1,
    vec=[];
    for i=1:length(mminj),
        if i<i2, % Following row determines number of reflector nodes
            d_mminj=mminj(i)-mminj(i+1);
        elseif i>i2     % Preceeding row determines number of reflector nodes
            d_mminj=mminj(i)-mminj(i-1);
        else
            d_mminj=0;
        end
        % Remove row number and refl in each end
        % Not that number of reflector nodes depends on the length of preceeding or following row
        left=data{i+1,k}(3+d_mminj:end);right=data_r{i+1,k}(2:end-1-d_mminj); 
        vec=[vec;left;right];
    end
    xs(k-1,:)=vec';
end

