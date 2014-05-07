function [mvar,mdata,sampl,mtext]=racs2md(in,besk,table)
% [mvar,mdata,sampl,mtext]=racs2md(in,besk,table)
% Konverterar racsformatet till f3-mätdator-format
%
i=find(besk==10);
besk(i)=[];
[r,k]=size(table);
mv=zeros(99,k+2);
mv(:)=besk;
mv=mv(6:99,4:(k+2))';
mvar=setstr(ones(k-1,120)*32);
mvar(:,1:16)=mv(:,1:16);
mvar(:,22:28)=mv(:,17:23);
mvar(:,36:45)=mv(:,24:33);
mvar(:,46:55)=mv(:,37:46);
mvar(:,56:60)=mv(:,50:54);
mvar(:,81:112)=mv(:,63:94);
mdata=table(:,2:k)';
sampl=zeros(5,6);
tmp=in(21:50);
i=find(tmp=='-');
j=find(tmp==':');
sampl(1,1)=str2num(tmp(1:2));
sampl(1,2)=str2num(tmp(4:(i(2)-1)));
sampl(1,3)=str2num(tmp((i(2)+1):(i(2)+1)+1));
sampl(1,4)=str2num(tmp((j(1)-2):(j(1)-1)));
sampl(1,5)=str2num(tmp((j(1)+1):(j(2)-1)));
sampl(1,6)=str2num(tmp((j(2)+1):(j(2)+3)));
sampl(2,1)=1/(table(2)-table(1));
mtext=in; 
