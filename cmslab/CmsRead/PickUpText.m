function str=PickUpText(core,indx,TEXT,strlen)
if nargin<4, strlen=7;end
str=cell(core.kan,1);
iafull=core.iafull;
Ntimes=1;
if iafull>20, Ntimes=2;end
icount=0;
N=iafull/Ntimes;

for i=1:iafull,
    lT=length(TEXT{indx+i});
    row=TEXT{indx+i}(6:end);
    tmp=textscan(row,'%6s');tmp=tmp{1};
    lt=length(tmp);
    str(icount+1:icount+lt)=tmp;
    icount=icount+lt;
end
if Ntimes>1,
    for i=1:iafull,
        lT=length(TEXT{indx+i+iafull});
        row=TEXT{indx+i+iafull}(6:end);
        tmp=textscan(row,'%6s');tmp=tmp{1};
        lt=length(tmp);
        str(icount+1:icount+lt)=tmp;
        icount=icount+lt;
    end
    [right,left]=knumhalf(core.mminj);
    left=sort(left);
    lr=[left(:);right(:)];
    str(lr)=str;
end




