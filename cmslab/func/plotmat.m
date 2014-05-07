function plotmat(filename)

if nargin==0, %If no input argument, get cms file
    [filename,pathname]=uigetfile({'*.mat;*.dat;*.racs'},'select a mat- or a dat-file');
    if filename==0, return;end %Cancel if no file is given
    filename=[pathname,filename];
else
    filename=expandpath(filename);
end

fid=fopen(filename);test=char(fread(fid,8)');fclose(fid);
if strcmpi('MeasData',test), 
    datfile=1;
elseif findstr(test,'LabVIEW')
    datfile=3;
else
    datfile=0;
end

[pstr,nam,ext]=fileparts(filename);
if strncmp('.mat',ext,4), datfile=2;end

if strncmp('.racs',ext,5), datfile=4;end


if datfile==1,
    ds=ReadMatdataFil(filename);
    data=ds.data;
    signaler=ds.signaler;
    ns=size(data,2);
    minc=67;
elseif datfile==2
    minc=60;
    load(filename);
    whs=true;
    if ~exist('data','var'),
        dafound=false;
        if whs
            varwho=whos;
            whs=false;
        end
        for i=1:length(varwho),
            if strcmp(varwho(i).class,'double')
                datest=eval(varwho(i).name);
                if numel(datest)>2000,
                    data=datest;
                    dafound=true;
                end
            end
            if dafound, break;end
        end
    end
    
    ns=size(data,2);
    
    if ~exist('signaler','var'),
        sigfound=false;
        if whs
            varwho=whos;
            whs=false;
        end
        for i=1:length(varwho),
            if strcmp(varwho(i).class,'char')
                sigtest=eval(varwho(i).name);
                if numel(sigtest)>1000,
                    if strcmpi(sigtest(1,1),'n')|strcmpi(sigtest(1),'t'),
                        signaler=sigtest;
                        sigfound=true;
                    end
                end
                if sigfound, break;end
            end
        end
    end
elseif datfile==3,
    ds=Labview2plotmat(filename);
    data=ds.data;
    signaler=ds.signaler;
    ns=size(data,2);
    minc=67;
elseif datfile==4,
    ds=racsread(filename);
    data=ds.data;
    signaler=ds.signaler;
    ns=size(data,2);
    minc=67;
end

sig_orig=signaler;

if min(size(signaler))==1,
    signaler=blob2cell(signaler);
    signaler=char(signaler);
end

data=cleandata(data);

nss=size(signaler,1);

if strcmp(signaler(2,1),'+'), signaler(2,:)=[];nss=nss-1;end

if nss==ns, %nss should be ns+1, so this means something is wrong
    if min(size(sig_orig))==1,
        inl=find(sig_orig==10);
        line_len=inl(1);
        sig_orig(line_len:line_len:end)=[];
        nrows=length(sig_orig)/(line_len-1);
        signaler=reshape(sig_orig,line_len-1,nrows)';
    end
    nss=size(signaler,1);
    if strcmp(signaler(2,1),'+'), signaler(2,:)=[];nss=nss-1;end
end


hmainFig=figure('units','Normalized','position',[0.37,0.1,0.6,0.8],'menubar','none','name',filename);
prop.data=data;
prop.signaler=signaler;
%prop.beskrivning=beskrivning;
maxc=min(97,size(signaler,2));
if datfile==3,
    NamesSel=cellstr(signaler(2:end,1:17));
else
    NamesSel=cellstr([signaler(2:end,1:15),signaler(2:end,minc:maxc)]);
end
sta=2;
if ~strcmpi(signaler(1,1),'N'), sta=1;end
if strcmp(signaler(sta,1),'1')|strcmp(signaler(sta,1),'2'),
    Legs=cellstr(signaler(sta:end,5:19));
else
    Legs=cellstr(signaler(sta:end,1:15));
end
prop.legend=Legs;
hvar=uicontrol (hmainFig, 'style', 'listbox','Max',100,'string', NamesSel,...
    'units','Normalized','position', [0 0.01 .20 0.98]);
set(hvar,'callback',{@plot_matfil,gcbo});

hplot_button=uicontrol('style','pushbutton', 'units','Normalized',...
                       'position',[.22 .95 .07 .04],...
                       'string','plot in new', ...
                       'callback',{@plot_matfil,gcbo});     
hax=axes('position',[0.25 0.05 0.73 0.87]);     %Axes handle 
prop.hvar=hvar;
prop.hax=hax;
set(hmainFig,'userdata',prop);