function [segmnt,segpos,nseg,niseg,sss,nextblock]=read_cdfile(cdfile)
% [segmnt,segpos,nseg,niseg]=read_cdfile(cdfile)
% Reads the cd-file, finds the position and structure of the segments.
% Input: cdfile - Library file name (.lib)
%
% Output:
% segmnt - segment names dimension no of segment by 20
% segpos - Get segment position on file dimension no of segment by no
%              cross sections per segment
% nseg   - Identifier immediately after segment name dim: # of segments by 6
% niseg  - Cell data array dim # of segments Contains info on xs-type,
%                       block size and # of blocks
% To actually read selected data, use get_segmnt_blob after read_cdfile
% Example:
%
%  [segmnt,segpos,nseg,niseg]=read_cdfile('cd-file.lib');
%  [V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y]=get_segmnt_blob('cd-file.lib',82,3,1:8,segpos,niseg);
%
% See also get_segmnt_blob, xs_cms

%%
[fid,msg]=fopen(cdfile,'r','ieee-be');
if fid<=0,
    error([msg,': ',cdfile]);
end
Max_No_of_Segments=500;
%%
fseek(fid,0,1);
neof=ftell(fid);                            %Check file length
segsize=800000;
NoOfSeg=round(neof/segsize); % Basis for approximate preallocation
nseg=nan(NoOfSeg,6);
segmnt=cell(NoOfSeg,1);
niseg=cell(1,NoOfSeg);
nextblock=nan(NoOfSeg,15);
segpos=nan(NoOfSeg,35);
fseek(fid,0,-1);                            % Rewind
endmark='END OF FILE TRAIL DATA';
%%
segpos(1)=2;        % may be platform dependent 
fseek(fid,4,-1);
imax=1;
for iseg=1:Max_No_of_Segments,
    segmnt{iseg}=fread(fid,20,'*char')';
    nseg(iseg,1:5)=fread(fid,5,'int32')';
    nseg(iseg,6)=fread(fid,1,'float');
    for i=1:10,
        a=char(fread(fid,2025,'*uint8'))';
        istr=strfind(a,endmark);
        if ~isempty(istr), break;end
        fseek(fid,-25,0);
    end
    fseek(fid,istr(1)-2025-1+80,0);
    for i=1:100,
        imax=max(i,imax);
        %sss{iseg}(i,1:2)=fread(fid,2,'int32');
        fseek(fid,8,0);
        segpos(iseg,i)=ftell(fid);
        niseg{iseg}(:,i)=fread(fid,3,'int32');
        %sss{iseg}(i,3)=fread(fid,1,'int32');
        fseek(fid,4,0);
        if ftell(fid)==neof, break;end
        nextblock(iseg,i)=fread(fid,1,'int32');
        if niseg{iseg}(1,i)==99, break;end
        fseek(fid,nextblock(iseg,i),0);
    end
    if ftell(fid)==neof, break;end
end
%% Remove unneeded preallocation
niseg(iseg+1:end)=[];
nextblock(iseg+1:end,:)=[];
nseg(iseg+1:end,:)=[];
segmnt(iseg+1:end)=[];
segpos(iseg+1:end,:)=[];
segpos(:,imax+1:end)=[];
sss=[];
fclose(fid);
segmnt=char(segmnt); %For compatibility, will be changed back later

