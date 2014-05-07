function [data,t,ttid,pid,point_desc,c1,c2,key]=ReadMVD(mvddir)
% ReadMVD - Reads from GE MVD files 
%
% [data,t,ttid,pid,point_desc]=ReadMVD(mvddir)
%
% Input:
%   mvddir - directory
%
% Output:
%   data   - data
%     t    - time
%   pid    - cell array of process id's
%
% Example: [data,t,ttid,pid,point_desc]=ReadMVD;
%          [data,t,ttid,pid,point_desc]=ReadMVD('C:\Users\Thomas\Desktop\PowerUprate\MVD\BD\16mHz\MVBD_20121001_1521');
%
% See also: plotmat
%
if nargin==0,
    filename_profile='sampleprofile.dat';
    filename_data='sampledata.dat';
    filename_sampleascii='sampleascii.txt';
else
    filename_profile=[mvddir,filesep,'sampleprofile.dat'];
    filename_data=[mvddir,filesep,'sampledata.dat'];
    filename_sampleascii=[mvddir,filesep,'sampleascii.txt'];
end
%% Step 1 get the key QS: This step still escapes me. I identified the key thru the data.
% each column of key is IP,Channel,Slot,Offset
% Artificial for now
[key,pid,point_desc,c1,c2]=get_key(filename_sampleascii);

% TXT=ReadAscii(filename_sampleascii);
% 
% if findrow(TXT,'^point_id 531K801'), %BD
%     pid=importdata('pidBD.dat');
%     jj=[157:-1:154 72:-1:61 153:-1:138 60:-1:57 137:-1:134 56:-1:49 133:-1:130 48:-1:41 129:-1:122 40:-1:37 158 73];
% else
%     pid=importdata('pidAC.dat');
%     jj=[157:-1:150 72:-1:65 149:-1:142 64:-1:61 141:-1:138 60:-1:53 137:-1:130 52:-1:45 129:-1:126 44:-1:41 125:-1:122 40:-1:37 158 73];
% end
%end artificial

%% Explore sampleprofile.dat
fid1=fopen(filename_profile,'r','ieee-be');
sampleprofile=fread(fid1)';
iadr=strfind(sampleprofile,'ADR');
%%
% This first piece is artifical for now, until the proper way to find the
% key has been established
% key=zeros(4,length(jj)); %preallocate
% for i=1:length(jj), fseek(fid1,iadr(jj(i))+3,-1);key(:,i)=fread(fid1,4);end
% End artificial piece
%% Find the adresses for the interesting signals in an efficient way
smartkey=[256^3 256^2 256 1]*key';
fullkey=zeros(length(iadr),1); %preallocate
for i=1:length(iadr),
    fseek(fid1,iadr(i)+3,-1);
    fullkey(i)=fread(fid1,1,'int32');
end

adr_ind=0*smartkey; % preallocate
for i=1:length(smartkey),
    adr_ind(i)=find(fullkey==smartkey(i));
end 

%% 
% chk=max(abs(adr_ind-jj));
% if chk,
%     warning('something is probably wrong cannot find all indices');
% end
%% find the offsets. Of course '20' could be a variable read from sampleprofile.dat, but for now '20' is more clear in my mind.
offsets=zeros(20,length(adr_ind)); %preallaocate
No=zeros(length(adr_ind),1);
nskip=[];
for i=1:length(adr_ind), 
    fseek(fid1,iadr(adr_ind(i))+7,-1);
    No(i)=fread(fid1,1,'uint16');
    if No(i)==20,
        offsets(:,i)=fread(fid1,20,'uint16');
    else
        nskip=[nskip i];
    end
end
offsets(:,nskip)=[];
c1(nskip)=[];
c2(nskip)=[];
point_desc(nskip)=[];
fclose(fid1);

%% Now read the data
fid=fopen(filename_data,'r','ieee-be');
sampledatafile=fread(fid)';
itim=strfind(sampledatafile,'TIM');
idat=strfind(sampledatafile,'DAT');
fseek(fid,8,-1);
dm=fread(fid,2,'uint8');
y=fread(fid,1,'uint16');
N=length(idat);
tid=zeros(N,1);
data=zeros(N*20,size(offsets,2));
minoffs=min(offsets(:));
ndat=(max(offsets(:))-minoffs)/2+1;
%%
for i=1:N,
    fseek(fid,itim(i)+3,-1);
    tid(i)=fread(fid,1,'uint32');
    fseek(fid,idat(i)+5+minoffs,-1);
    temp=fread(fid,ndat,'uint16');
    data((i-1)*20+1:20*i,:)=temp((offsets-minoffs)/2+1);
end
fclose(fid);
[tstart,imin]=min(tid);

tstart=tstart/10000; % seconds
hf=tstart/3600;
h=floor(hf);
hfrac=hf-h;
mf=hfrac*60;
m=floor(mf);
sf=(mf-m)*60;
s=floor(sf);
ms=round((sf-s)*1000);
ttid=uint32([dm(:)' y h m s ms]);
% This has been fixed
data=data([(imin-1)*20+1:N*20 1:(imin-1)*20],:);
%data=data([imin*20+1:N*20 1:imin*20],:); %This is probably wrong, 
%                             but it comes out like this in the csv-files
% It should be: data=data([(imin-1)*20+1:18000 1:(imin-1)*20],:);
% This has been fixed
for i=1:length(c2),
    data(:,i)=c1(i)+c2(i)*data(:,i);
end
tid=tid([imin:N 1:imin-1]);
tid=tid-tid(1);
tid=tid/10000;
t=zeros(N*20,1);
for i=1:N-1,
    t((i-1)*20+1:i*20)=linspace(tid(i),tid(i+1),20);
end
t(N*20-19:N*20)=linspace(tid(N),tid(N)+mean(diff(tid)),20);