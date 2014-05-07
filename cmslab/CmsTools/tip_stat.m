function tipstat=tip_stat(Ac,A,Iskip)
% tipstat=tip_stat(Ac,A)
ntip=length(A);
ndet=size(A{1},2);
if nargin<3,
    for i=1:ntip, Iskip{i}=[];end
end
for i=1:ntip
    dA=Ac{i}-A{i};DA{i}=dA;
    RmsNodal(i)=rms(dA(:))*100;
    AvDiffNodal(i)=mean(abs(dA(:)))*100;
    MaxDiffNodal(i)=minmax(minmax(dA)')*100;
    RmsAxial(i)=rms(mean(dA'))*100;
    AvDiffAxial(i)=mean(abs(mean(dA')))*100;
    MaxDiffAxial(i)=minmax(mean(dA')')*100;
    RmsRadial(i)=rms(mean(dA))*100;
    AvDiffRadial(i)=mean(abs(mean(dA)))*100;
    MaxDiffRadial(i)=minmax(mean(dA)')*100;
    if ~isempty(Iskip{i}),
        kv=ndet/(ndet-length(Iskip{i}));
        RmsNodal(i)=RmsNodal(i)*sqrt(kv);
        RmsAxial(i)=RmsAxial(i)*sqrt(kv);
        RmsRadial(i)=RmsRadial(i)*sqrt(kv);
        AvDiffNodal(i)=AvDiffNodal(i)*kv;
        AvDiffAxial(i)=AvDiffAxial(i)*kv;
        AvDiffRadial(i)=AvDiffRadial(i)*kv;
    end
end


tipstat.RmsNodal=RmsNodal;
tipstat.RmsAxial=RmsAxial;
tipstat.RmsRadial=RmsRadial;
tipstat.AvDiffNodal=AvDiffNodal;
tipstat.AvDiffAxial=AvDiffAxial;
tipstat.AvDiffRadial=AvDiffRadial;
tipstat.MaxDiffNodal=MaxDiffNodal;
tipstat.MaxDiffAxial=MaxDiffAxial;
tipstat.MaxDiffRadial=MaxDiffRadial;
tipstat.DA=DA;

