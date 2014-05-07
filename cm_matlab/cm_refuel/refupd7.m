% $Id$
%
function refupd7(refufile)

xm=[];
pool=[];

% Load refufile
if exist(refufile,'file')
    refu=load(refufile);
else
    error('Refufile not found!');
end

bocfile=refu.bocfile;
eocfile=refu.eocfile;
skyinpfile=refu.skyinpfile;
compkhotfile=refu.compkhotfile;

% Read eocfile
[eocbuid,mminj,konrod,bb,hy,mz,ks,eocbunt]=readdist7(eocfile,'asyid');
eocburn=readdist7(eocfile,'burnup');

% Read bocfile
[bocbuid,mminj,konrod,bb,hy,mz,ks,bocbunt]=readdist7(bocfile,'asyid');
bocburn=readdist7(bocfile,'burnup');

% Get channel numbers
[right,left]=knumhalf(mminj);

% Get symmetry
sym=refu.symmetry;


%% Laddning av färska
freshload=refu.freshload;
for i=1:length(freshload)
    
    ikan=freshload(i).ikan;
    newbun=freshload(i).newbun;

    for ii=1:length(ikan)
        bocbunt(ikan(ii),1:4)=sprintf('%4s',newbun);
        bocbuid(ikan(ii),1:6)=sprintf('%6s',newbun);
        bocburn(1:mz(11),ikan(ii))=zeros(mz(11),1);
        if sym==3
            sykan=size(bocburn,2)+1-ikan(ii);
            bocbunt(sykan,1:4)=sprintf('%4s',newbun);
            bocbuid(sykan,1:6)=sprintf('%6s',newbun);
            bocburn(1:mz(11),sykan)=zeros(mz(11),1);
        end
    end
    
end
freshload=[];
save(refufile,'-append','freshload','bocbunt','bocbuid','bocburn');


%% Skyffling
mmat=refu.shuffles;
if ~isempty(mmat)
    xm=mmat(1,:);
    ym=mmat(2,:);
end
l=length(xm);
if l~=0
    xm(l+1)=0;
    ym(l+1)=0;
    z=find(xm==0);
    for knr=1:length(z)-1
        xx=xm(z(knr)+1:z(knr+1)-1);
        yy=ym(z(knr)+1:z(knr+1)-1);
        l=length(xx);
        for i=1:l
            ikan(i)=cpos2knum(yy(i),xx(i),mminj);
            if sym==3
                ikan(l+i)=left(find(ikan(i)==right));
            end
        end
        tempbunt=bocbunt(ikan(l),:);
        tempbuid=bocbuid(ikan(l),:);
        tempburn=bocburn(:,ikan(l));
        if sym==3
            leftbunt=bocbunt(ikan(2*l),:);
            leftbuid=bocbuid(ikan(2*l),:);
            leftburn=bocburn(:,ikan(2*l));
        end
        for i=l:-1:2
            bocbunt(ikan(i),:)=bocbunt(ikan(i-1),:);
            bocbuid(ikan(i),:)=bocbuid(ikan(i-1),:);
            bocburn(:,ikan(i))=bocburn(:,ikan(i-1));
            if sym==3
                bocbunt(ikan(l+i),:)=bocbunt(ikan(l+i-1),:);
                bocbuid(ikan(l+i),:)=bocbuid(ikan(l+i-1),:);
                bocburn(:,ikan(l+i))=bocburn(:,ikan(l+i-1));
            end
        end
        bocbunt(ikan(1),:)=tempbunt;
        bocbuid(ikan(1),:)=tempbuid;
        bocburn(:,ikan(1))=tempburn;
        if sym==3
            bocbunt(ikan(l+1),:)=leftbunt;
            bocbuid(ikan(l+1),:)=leftbuid;
            bocburn(:,ikan(l+1))=leftburn;
        end
    end

    shuffles=[];
    save(refufile,'-append','shuffles','bocbunt','bocbuid','bocburn');
end


%% Laddning från poolen
poolload=refu.poolload;
for i=1:length(poolload);   
    ldbuid=poolload(i).ldbuid;
    ldchan=poolload(i).ldchan;
    
    ldleftchan=left(find(right==ldchan));
    eocchan=strmatch(ldbuid,eocbuid);
    if isempty(eocchan)
        load(refu.poolfile)
        j=find(NCHTYP~=0);
        pos=strmatch(ldbuid,ASYID);
        xfile=DISTFIL(lastcyc(pos),:);
        [xbuid,mminj,konrod,bb,hy,mz,ks,xbunt]=readdist7(xfile,'asyid');
        chan=IPOS(pos,ITOT(pos));
        bocbuid(ldchan,:)=xbuid(chan,:);
        bocbunt(ldchan,:)=xbunt(chan,:);
        bocburn(1:mz(11),ldchan)=ones(mz(11),1);      % Dummy-utbränning
        if sym==3
            leftchan=left(find(right==chan));
            bocbuid(ldleftchan,:)=xbuid(leftchan,:);
            bocbunt(ldleftchan,:)=xbunt(leftchan,:);
            bocburn(1:mz(11),ldleftchan)=ones(mz(11),1);% Dummy-utbränning
        end
    else
        bocbuid(ldchan,:)=eocbuid(eocchan,:);
        bocbunt(ldchan,:)=eocbunt(eocchan,:);
        bocburn(1:mz(11),ldchan)=ones(mz(11),1);      % Dummy-utbränning
        if sym==3
            eocleftchan=left(find(right==eocchan));
            bocbuid(ldleftchan,:)=eocbuid(eocleftchan,:);
            bocbunt(ldleftchan,:)=eocbunt(eocleftchan,:);
            bocburn(1:mz(11),ldleftchan)=ones(mz(11),1);% Dummy-utbränning
        end
    end
    if isempty(find(bocfile=='.')),bocfile=sprintf('%s%s',bocfile,'.dat');end
    
    
end
poolload=[];
save(refufile,'-append','poolload','bocbunt','bocbuid','bocburn');


% Skapa skyffel input
mkskyinp(refufile, bocbunt, bocbuid, bocburn, mminj);

% Kör Skyffel samt Polca för uppdatering av khot fördelning
runsky('skyffel','polca',skyinpfile, compkhotfile);


