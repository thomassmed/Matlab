function dists=ReadCms(coreinfo,label,stpt,asspos)

if  ischar(coreinfo),
    coreinfo=read_cms(coreinfo);
    if nargin==1,  return;end
end

label=cellstr(label);

if isempty(label{1}), label{1}=coreinfo.distlist{1};end

if nargin<3, stpt='all';end

stpt=ParseStpt(stpt,coreinfo);

if nargin<4, asspos='all'; end

if length(label)==1,
    if length(label{1})>3,
        if strncmpi(char(label{1}(1:4)),'scal',4),
            n=1:length(coreinfo.ScalarNames);
            dists=read_cms_scalar(coreinfo,n);
            dists=dists(:,stpt);
        end
    end
end


idist=[];
imisc=[];
iscal=[];
typ=zeros(length(label),1);
for i=1:length(label),
    ia=find(~cellfun(@isempty,strfind(coreinfo.distlist,label{i})));
    if length(ia)>1,
        mess=['Label ''',label{i},''' is ambiguous, ''',coreinfo.distlist{ia(1)},''' will be used'];
        warning(mess);
    end
    if isempty(ia),
        ia=find(~cellfun(@isempty,strfind(coreinfo.misclist,label{i})));
        if ~isempty(ia),
            typ(i)=2;
            imisc=[imisc;ia(1)];
        else
            ia=find(~cellfun(@isempty,strfind(coreinfo.ScalarNames,label{i})));
            if ~isempty(ia),
                iscal=[iscal ia(1)];
                typ(i)=3;
            end
        end
    else
        idist=[idist;ia(1)];
        typ(i)=1;
    end
end 

if ~isempty(idist)
    distdist=read_cms_dist(coreinfo,coreinfo.distlist(idist),stpt);
    ityp=find(typ==1);
    if length(label)>1,
        for i=1:length(ityp)
            if length(stpt)>1,
                dists{ityp(i)}=distdist(i,:);
            else
                dists{ityp(i)}=distdist{i};
            end
        end
    else
        dists=distdist;
    end
end

if ~isempty(imisc)
    distdist=read_cms_dist(coreinfo,coreinfo.misclist(imisc),stpt);
    ityp=find(typ==2);
    for i=1:length(ityp)
        if iscell(distdist)
            if all(cellfun(@isempty,distdist(i,2:end))),
                dists{ityp(i)}=distdist{i,1};
            else
                dists{ityp(i)}=distdist(i,:);
            end
        else
            if length(label)==1,
                dists=distdist;
            else
                dists{ityp(i)}=distdist;
            end
        end 
    end
end

if ~isempty(iscal),
    scalars=read_cms_scalar(coreinfo,iscal);
    ityp=find(typ==3);
    for i=1:length(iscal)
        dists{ityp(i)}=scalars(i,:);
    end
end

if length(label)==1 && length(dists)==1 && iscell(dists)
    if isnumeric(dists{1})
        dists=dists{1};
    end
end
    
    





