%@(#)   readseq.m 1.3	 99/07/14     13:10:31
%
%function [konrod,mminj]=readseq(seqfile,pattsum)
function [konrod,mminj]=readseq(seqfile,pattsum)
reakdir=findreakdir;
txseq=readtextfile(seqfile);
crmanfile=[reakdir 'fil/cr-man.txt'];
txman=readtextfile(crmanfile);
crmapfile=[reakdir 'fil/cr-map.txt'];
txmap=readtextfile(crmapfile);
coremapfile=[reakdir 'fil/core-map.txt'];
txcore=readtextfile(coremapfile);
lmminj=str2num(txcore(1,1:4));
for j=1:lmminj,mminj(j,1)=str2num(txcore(4,(j-1)*2+1:j*2));end
i=find(txseq(:,1)==':');
cols=str2num(txseq(i(1),2));
s=size(txseq);
grps=[];
for j=1:s(2)/cols
  tmp=remblank(sprintf('%s',txseq(i(1)+1,(j-1)*cols+1:j*cols)));
  if isempty(tmp),break,end
  if length(tmp)<3, tmp=[tmp setstr(32*ones(1,3-length(tmp)))];end
  grps=[grps;tmp];
end
ugrps=size(grps,1);
for j=1:s(2)/cols
  tmp=remblank(sprintf('%s',txseq(i(2)+1,(j-1)*cols+1:j*cols)));
  if isempty(tmp),break,end
  if length(tmp)<3, tmp=[tmp setstr(32*ones(1,3-length(tmp)))];end
  grps=[grps;tmp];
end
egrps=size(grps,1)-ugrps;
crdata=zeros(1,ugrps);
for j=i(1)+2:i(2)-3
  s=size(crdata);
  crdata=[crdata; crdata(s(1),:)];
  for k=1:ugrps
    tmp=sprintf('%s',txseq(j,(k-1)*cols+1:k*cols));
    if ~isempty(remblank(tmp)), crdata(j-i(1),k)=str2num(tmp); end
  end
end
crdata=[crdata zeros(size(crdata,1),egrps)];
for j=i(2)+2:size(txseq,1)
  s=size(crdata);
  crdata=[crdata; crdata(s(1),:)];
  for k=1:egrps
    tmp=sprintf('%s',txseq(j,(k-1)*cols+1:k*cols));
%    if remblank(tmp)~='', crdata(j-i(2)+i(1)+1,ugrps+k)=str2num(tmp); end
    if ~isempty(remblank(tmp)), crdata(s(1)+1,ugrps+k)=str2num(tmp); end
  end
end
cry=remblank(txmap(2,:));
crx=remblank(txmap(3,:));
rods=[]; nrods=[];
for i=1:size(grps,1)
  if abs(grps(i,1))<65
    j=bucatch(grps(i,1:2),txman(:,1:2));
    nrod=str2num(txman(j,20));
    nrods=[nrods;nrod];
    for k=1:nrod
      rods=[rods; txman(j+1,6*(k-1)+1:6*(k-1)+3)];
    end
  else
    rods=[rods; grps(i,:)];
    nrods=[nrods;1];
  end
end
for i=1:size(crdata,1)
  if crdata(i,:)*nrods >= pattsum, break;end
end
patt=crdata(i,:)*nrods;
fprintf('\n%5.0f%6.0f ',pattsum,patt);
crvec=[];
for j=1:size(crdata,2)
  crvec=[crvec crdata(i,j)*ones(1,nrods(j))];
end
for i=1:length(crvec)
  konrod(crpos2crnum(axis2crpos(rods(i,1:3)),mminj))=crvec(i);
end
