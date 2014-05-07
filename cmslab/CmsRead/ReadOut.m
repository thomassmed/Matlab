function [dist,str,node]=ReadOut(outfile,distname,stpt,varargin)
% ReadOut - Read from .out files
%
% [dist,Name,node]=ReadOut(outfile,distname)
% outinfo=ReadOut(outfile)
% [dist,Name,node]=ReadOut(outinfo,distname)
%
% Input
%   outfile - Name on output file
%
% Output
%   dist    - cell array of distributions found on file
%   node    - cell array of node for extreme values (for certain 2D distributions)
%   
% Examples:
%  outinfo=ReadOut('simfile-ra23-eq.out')
%  rpf2=ReadOut(outinfo,'2RPF'); 
%  dist=ReadOut(outfile,str); 
%  [Dist,name,node]=ReadOut(outfile,'PFLP');
%
% See also ReadOut2D, ReadOut3D, ReadPriMac, read_restart_bin, ReadSum
if nargin<3, stpt='all';end

if ischar(outfile),
    [outinfo,TEXT]=AnalyzeOut(outfile);
    if nargin==1,
        dist=outinfo;
        return
    end
    stpt=ParseStpt(stpt,outinfo);
else
    outinfo=outfile;
    stpt=ParseStpt(stpt,outinfo);
    [offset,Nrow]=GetOffset(stpt,outinfo);
    stpt=stpt-min(stpt)+1;
    TEXT=ReadAscii(outinfo.fileinfo.fullname,offset,diff(Nrow)+1);
end

core=outinfo.core;
%%
distname=cellstr(distname);
icount=0;
for i=1:length(distname),
    [temp1,temp2]=FindCard(outinfo,distname{i});
    if iscell(temp1),
        for j=1:length(temp1),
            icount=icount+1;
            str{icount}=temp1{j};
            card{icount}=temp2{j};
        end
    else
        icount=icount+1;
        str{icount}=temp1;
        card{icount}=temp2;
    end
end         


node={};
dist=cell(1,length(card));
for ic=1:length(card),
    switch upper(card{ic})
        case {'PRI.STA','A-PRI.STA','PRI.ISO'}
            if strcmp(str{ic}(9),'3')||(strcmpi(str{ic}(1:2),'A-')&&strcmp(str{ic}(11),'3')),
                dist{ic} = ReadOut3D(TEXT,str{ic},outinfo,stpt);
            else
                dist{ic}= ReadOut2D(TEXT,str{ic},outinfo,stpt);
                mminj=core.mminj;
                if core.if2x2==2,
                    iaf=size(dist{ic}{1},1);
                    if iaf>=2*core.iafull,
                        mminj=core.mminj2x2;
                    end
                    if iaf==core.iafull*2+2,
                        %remove reflector
                        for i=1:length(dist{ic}),
                            dist{ic}{i}(:,end)=[];
                            dist{ic}{i}(end,:)=[];
                            dist{ic}{i}(1,:)=[];
                            dist{ic}{i}(:,1)=[];
                        end
                    end
                end
                for i=1:length(dist{ic}),
                    dist{ic}{i}=cor2vec(dist{ic}{i},mminj);
                end
            end
        case 'PRI.MAC'
            dist{ic}=ReadPriMac(TEXT,str{ic},core);
            % Remove reflectors
            dist{ic}(:,:,end)=[];
            dist{ic}(:,:,1)=[];
            dist{ic}(1,:,:)=[];
            dist{ic}(end,:,:)=[];
            dist{ic}(:,1,:)=[];
            dist{ic}(:,end,:)=[];
            dist{ic}=cor3D2dis3(dist{ic},core.mminj);
            
        case {'TLM.EDT','PIN.EDT','PIN.SUM'} %TODO: This read is screwed up. Fix it later
            if strcmp(str{ic}(9),'3')||strcmp(str{ic}(9),'4'),
                dist{ic}=ReadOut3D(TEXT, str{ic}, outinfo, stpt);
            else
                [dist{ic},node{ic}]=ReadOut2D(TEXT,str{ic},outinfo,stpt);
                for i=1:length(dist{ic}),
                    if iscell(dist{ic}{i})
                        temp1=cor2vec(dist{i}{1},core.mminj);
                        temp2=cor2vec(dist{i}{2},core.mminj);
                        dist{ic}{i}=[temp1;temp2];
                    else
                        dist{ic}{i}=cor2vec(dist{ic}{i},core.mminj);
                    end
                end
                if ~isempty(node{ic}),
                    for i=1:length(node{ic}),
                        node{ic}{i}=cor2vec(node{ic}{i},core.mminj);
                    end
                end
            end
        case {'FUE.LAB','FUE.SER'}
            ifue=find(strcmp(card{ic},TEXT));
            for i=1:length(ifue)
                dist{ic}{i}=PickUpText(outinfo.core,ifue(i)+2,TEXT);
            end
        case 'FUE.TYP'
            ifue=find(strcmp(card{ic},TEXT));
            test=sscanf(TEXT{ifue(1)+3},'%i');
            n=length(test);
            for i=1:length(ifue)
                temp=PickUpFull(TEXT,ifue(i)+2,n-1,n,i);
                temp(:,1)=[];
                if n==core.iafull+3,
                    temp(1,:)=[];
                    temp(:,1)=[];
                    temp(:,end)=[];
                    temp(end,:)=[];
                end
                temp=reshape(temp,core.iafull,core.iafull);
                dist{ic}{i}=cor2vec(temp,core.mminj);
            end
            %TODO: case detectors, tip, weight, drfd from S3K etc tec ReadOut should be the hub of calling read
            %from .out files
    end
    if iscell(dist{ic}),
        if length(dist{ic})==1, dist{ic}=dist{ic}{1};end
      %  if ischar(dist{ic}{1}), dist{ic}=dist{1};end
    end
    if ~isempty(node)
        if length(node)>=ic,
            if iscell(node{ic}),
                if length(node{ic})==1, node{ic}=node{ic}{1};end
            end
        end
    end
end

if length(dist)==1,
    dist=dist{1};
end

