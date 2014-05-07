function [dr,fd,qrel,Hcflow,QREL,DR]=tvo_mat2drfd(stab_mat)
for i=1:length(stab_mat),
    load(stab_mat{i})
    Ts=double(time(2)-time(1));
    [drr{1},fdd{1}]=Drident_tvo(double(CH531K951.Values)',Ts);
    [drr{2},fdd{2}]=Drident_tvo(double(CH531K952.Values)',Ts);
    [drr{3},fdd{3}]=Drident_tvo(double(CH531K953.Values)',Ts);
    [drr{4},fdd{4}]=Drident_tvo(double(CH531K954.Values)',Ts);
    [dr(i),j]=max(drr);
    DR(i,:)=drr;
    fd(i)=fdd(j);
    QREL(i,1)=mean(double(CH531K951.Values));
    QREL(i,2)=mean(double(CH531K952.Values));
    QREL(i,3)=mean(double(CH531K953.Values));
    QREL(i,4)=mean(double(CH531K954.Values));
    qrel(i)=mean(QREL(i,:));
    Hcflow(i)=mean(double(CH211K036.Values));
end