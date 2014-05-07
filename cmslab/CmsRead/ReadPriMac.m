function data=ReadPriMac(outfile, str, core)
% ReadPriMac - Reads output from .out file printed with PRI.MAC
%
% xs=ReadPriMac(outfile,xsstr)
%
% Input
%   outfile - Filename of print file
%   xsstr   - string containing name as used on outfile
%             (D1,D2,SR1,SA1,SA2,NF1,NF2,K/N)
%
% Output
%   xs - Cross section (IDR by IDR by KD), includes reflector, use ReadOut
%        to get kmax by kan with no reflector
%
% Example
%
%   d1=ReadPriMac('s3.out','D1');
%   d2=ReadPriMac('/cms/f3/c12/tip/s3.out','D2');
%   sigr1=ReadPriMac('../test_case/s3-1.out','SR1');
%
%
% See also ReadOut

if ~iscell(outfile),
    fid=fopen(outfile,'r');
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
str=str(1:30);
iprimac= find(~cellfun(@isempty,regexp(TEXT,['^',str])));
%%
kd=core.kmax+2;
idr=core.iafull+2;
data=nan(idr,idr,kd);
for n=1:length(iprimac),
    row=TEXT{iprimac(n)};
    sc=GetScale(row);
    ik=strfind(row,'K =');
    k=sscanf(row(ik+3:ik+6),'%i')+1;
    rowcoun=iprimac(n)+1;
    for j=1:2,
        jcoor=sscanf(TEXT{rowcoun},'%g');
        jmin=min(jcoor);
        jmax=max(jcoor);
        rowcoun=rowcoun+2; %Empty row first
        for i=1:idr,
            rowval=sscanf(TEXT{rowcoun},'%g');
            rowcoun=rowcoun+1;
            icoor=rowval(1);rowval(1)=[];
            if jmin==1,
                jrow=jmax-length(rowval)+1:jmax;
            else
                jrow=jmin:(jmin+length(rowval)-1);
            end
            data(icoor,jrow,k)=rowval/sc;
        end
    end
    if j==1
        jtest=sscanf(TEXT{rowcoun},'%g');
        if (min(jest)==(max(jccor)+1)) && (length(jtest)==(idr-length(jccor))) && (max(jtest)==idr),
            cont=true;
        else
            break
        end
    end
end
