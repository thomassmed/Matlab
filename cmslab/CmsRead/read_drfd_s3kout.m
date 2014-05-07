function [dr,fd,time_window]=read_drfd_s3kout(s3kout)
%  Read decay ratio and frequency from s3k-outputfile
%
% [dr,fd,time_window]=read_drfd_s3out(s3kout)
%
% Example:
% >> [dr,fd]=read_drfd_s3out('s3k-1.out');
% >> s3kout=get_all_s3kout('Rec*');
% >> [dr,fd]=read_drfd_s3out(s3kout);
if ~iscell(s3kout),
    s3kout=cellstr(s3kout);
end
for i=1:length(s3kout)
    fid=fopen(char(s3kout{i}),'r');
    fil=fread(fid,'*char')';
    fclose(fid);
    lf=find(fil==13);
    fil(lf)=[];
    cr=find(fil==10);
    pos=strfind(fil,[10,' Core power  ']);
    if isempty(pos)
        dr(i)=NaN;
        fd(i)=NaN;
    else
        next_cr=find(cr>pos,1);
        drfd=sscanf(fil(pos+20:cr(next_cr)-1),'%g');
        dr(i)=drfd(1);
        fd(i)=drfd(2);
    end
    if nargout>2,
        pos=strfind(fil,'Results Analyzed in the time window');
        if isempty(pos)
            time_window(i,1)=NaN;
            time_window(i,2)=NaN;
        else
            next_cr=find(cr>pos,1);
            tw=sscanf(fil(pos+35:cr(next_cr)-1),'%g');
            time_window(i,1)=tw(1);
            time_window(i,2)=tw(2);
        end
    end
end
