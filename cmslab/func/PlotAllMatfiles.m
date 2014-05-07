function PlotAllMatfiles(Kpunkt)
allmatfiles=dir('*.mat');
allmatfiles={allmatfiles.name}';
icount=0;
figure
for i=1:length(allmatfiles),
    out=whos('-file',allmatfiles{i});
    sigexist=strmatch('signaler',{out.name});
    if ~isempty(sigexist)
        load(allmatfiles{i});
        isig=get_index_from_matfile(signaler,Kpunkt);
        if ~isempty(isig)
            icount=icount+1;
            matfiles{icount}=allmatfiles{i};
            plot(data(:,1),data(:,isig));
            if icount==1, hold all;end
        end
        clear data signaler
    end
end
legend(matfiles)
title(Kpunkt)