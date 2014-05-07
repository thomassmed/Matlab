function pri_det(dist,detloc,fid,Format)
% pri_det - prints detector string info
%
% pri_det(dist,detloc,fid,Format)
% 
% Input
%   dist   - dist to be printed (n by no of strings)
%   detloc - fuenew.detloc, detector location map
%   fid    - file identifier, 1 = screen (default), can be filename too
%  Format  - cell array of Format strings, default:
%              10<max(abs(dist(i,:))<1000 : %6.2f
%              0.1<max(abs(dist(i,:))<10  : %6.3f
%              else                       : %6g
%
% Example:
%  Ac=read_tipmeas('s3-u-1.sum',1);
%  A=read_tipmeas('s3-u-1.det');A=A/mean(A(:));
%  fue_new=read_restart_bin('s3-u-1.res');
%  pri_det([mean(Ac);mean(A)],fue_new.detloc);
%  Format{1}='%6.3f';Format{2}='%6.3f';Format{3}='%6.1f';
%  pri_det([mean(Ac);mean(A);100*(mean(Ac)-mean(A))],fue_new.detloc,'det.lis',Format);

% Written Thomas Smed 2009-05-01
%%
if nargin<3, fid=1;end
fc=0;
if ischar(fid), fid=fopen(fid,'w');fc=1;end
if nargin<4,
    for i=1:size(dist,1),
        num=max(abs(dist(i,:)));
        if num<1000&&num>10,
            Format{i}='%6.2f';
        elseif num<10&&num>.1,
            Format{i}='%6.3f';
        else
            Format{i}='%6g';
        end
    end
elseif ~iscell(Format),
    Fmt=Format;clear Format
    for i=1:size(dist,1),
        Format{i}=Fmt;
    end
end
for i=1:size(detloc,1)
    for i1=1:size(dist,1)
        if any(detloc(i,:)),
            for j=1:size(detloc,2)
                if ~detloc(i,j),
                    fprintf(fid,'      ');
                else
                    fprintf(fid,Format{i1},dist(i1,detloc(i,j)));
                end
            end
        end
        fprintf(fid,'\n');
    end
end
if fc, fclose(fid);end