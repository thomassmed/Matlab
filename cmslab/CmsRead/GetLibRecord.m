function data = GetLibRecord(cdinfo,distlab,segment);

segmnt = cdinfo.segmnt;
niseg = cdinfo.niseg;
segpos = cdinfo.segpos;
if ischar(segment)
    segmposinv = find(strcmp(segment,segmnt));
else
    segmposinv = segment;
end

fid=fopen(cdinfo.fileinfo.fullname,'r','ieee-be');
switch upper(distlab)
    
    case 'SUBMESH DIMS'
        j=find(niseg{segmposinv}(1,:)==88);
        if ~isempty(j),
            fseek(fid,segpos(segmposinv,j),-1);
            ndim=fread(fid,3,'int');
            fseek(fid,8,0);
            read=zeros(ndim(3),ndim(2));
            ints = fread(fid,4,'int')'; 
            dims = fread(fid,2*ints(4),'float')';
            data.nsubs = ints(4);
            data.xmesh = dims(1:ints(4));
            data.ymesh = dims(ints(4)+1:end);
            
        end
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