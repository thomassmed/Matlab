function [pindata,rec88,delgap,segenr,rec91,rec92,rec93,rec94,Segmnt]=read_cdfile_data(cdfile,seglist)
% read_cdfile_data  reads non-XS data from cd-file
%
% [pindata,rec88,delgap,segenr,rec91,rec92,rec93,rec94,Segmnt]=read_cdfile_data(cdfile[,seglist])
%
% Input
%   cdfile  - Name on library file
%   seglist - List of segments to be read. Can be a cell array of segment
%             names, or a char array (matrix) of segments names or an
%             integer list of the segments as numbered on the lib file
%             If seglist is not given, all segments on the file are read
%
% Output
%   pindata - pinwise loadings (rec 11 on library file)
%   rec88   - record 88 on library file
%   delgap  - delta water gap (rec 89 on library file)
%   segenr  - segment enr, wba, bap, bao, wpu (rec 90 on library file)
%   rec91   - libadf, munits, iffuel, nrodhs, nrodts (rec 91 on library file)
%   rec92   - dbron1, dbron2, precas, refden, xloadg, xarea, it3stm (rec 92 on library file)
%   rec93   - cold (0 or 1) (rec 93 on library file)
%   rec94   - nuclib, nuchit (rec 94 on library file)
%   Segmnt  - list of the segment names that have been picked up
%
% Examples:
%
% [pindata,rec88,delgap,segenr,rec91,rec92,rec93,rec94,Seg]=read_cdfile_data('cd-file.lib');
% seglist{1}='RADREF';seglist{2}='iniA8-1-121-00g00';
% seglist{3}='e01S-63-291-05g25p08';
% [pindata,rec88,delgap,segenr,rec91,rec92,rec93,rec94,Seg]=read_cdfile_data('cd-file.lib',seglist);
% To get the weights:
% Rec92=cell2mat(rec92);weights=Rec92(:,5);
%
% See also read_cdfile, xs_cms

[segmnt,segpos,nseg,niseg]=read_cdfile(cdfile);
%% Now do the read
fid=fopen(cdfile,'r','ieee-be');
N=size(segmnt,1);
if nargin<2, 
    iseglist=1:N;
elseif isnumeric(seglist),
    iseglist=seglist;
else
    seglist=cellstr(seglist);
    iseglist=cellstrmatch(seglist,cellstr(segmnt),'exact');
    iseglist=cell2mat(iseglist);
    iseglist=iseglist(:)'; % Make sure we have a row vector
end
N=length(iseglist);
pindata=cell(N,1);rec88=pindata;
delgap=rec88;segenr=rec88;rec91=rec88;rec92=rec88;rec94=rec88;
Segmnt=rec88;
icount=0;
for i=iseglist,
    icount=icount+1;
    Segmnt{icount}=strtrim(segmnt(i,:));
%% --RECORD 11 : Pin wise loadings heavy metall weight per pin and cm
j= niseg{i}(1,:)==11;
fseek(fid,segpos(i,j),-1);
pindata{icount}=PickUpRecord(fid);
%% --RECORD 88 - Water density and Temp in Kelvin
j=find(niseg{i}(1,:)==88);
if ~isempty(j),
fseek(fid,segpos(i,j),-1);
rec88{icount}=PickUpRecord(fid);
end
%% --RECORD 89 : DELTA WATER GAP Halfgaps: CR-Det-Det-CR
j= niseg{i}(1,:)==89;
fseek(fid,segpos(i,j),-1);
delgap{icount}=PickUpRecord(fid);
%% --RECORD 90 : SEGMENT ENR,  WBA, BAP,    BAO, WPU
%                            BAwei #of BA pins,  Plutonium enr
j= niseg{i}(1,:)==90;
fseek(fid,segpos(i,j),-1);
segenr{icount}=PickUpRecord(fid);
%% --RECORD 91 LIBADF,        MUNITS,IFFUEL,NRODHS,NRODTS
%              Disc fact flag, 
j= niseg{i}(1,:)==91;
fseek(fid,segpos(i,j),-1);
rec91{icount}=PickUpRecord(fid,'int');
%% --RECORD 92 DBRON1,DBRON2,         PRECAS,               REFDEN,          XLOADG,XAREA,IT3STM
%             Boron worths gr 1 and 2,Pressure Casmo (psia), Density lb/ft^3, Steam table option
j= niseg{i}(1,:)==92;
fseek(fid,segpos(i,j),-1);
rec92{icount}=PickUpRecord(fid);
%% --RECORD 93 COLD
j= niseg{i}(1,:)==93;
fseek(fid,segpos(i,j),-1);
rec93{icount}=PickUpRecord(fid,'*char');
%% --RECORD 94 NUCLIB Code: AtomicNumber_IsotopeNumber, NUCHIT (exists on file or not)
j= niseg{i}(1,:)==94;
fseek(fid,segpos(i,j),-1);
rec94{icount}=PickUpRecord(fid,'int');
%%
end
fclose(fid);
end
function [RecData,ndim]=PickUpRecord(fid,Format)
if nargin<2, Format='float';end
ndim=fread(fid,3,'int');
fseek(fid,8,0);
%%
RecData=zeros(ndim(3),ndim(2));
for j=1:ndim(3),
    RecData(j,:)=fread(fid,ndim(2),Format)'; 
end
end