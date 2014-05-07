%@(#)   lng2polca.m 1.3	 97/02/27     16:49:16
%
%function [xtid,pow,konrod,hc,tlowp,mminj]=lng2polca(cyc,lngsumfile,date,ttime,filtyp)
function [xtid,pow,konrod,hc,tlowp,mminj]=lng2polca(cyc,lngsumfile,date,ttime,filtyp)
filtyp=lower(filtyp);
[ierr,direc]=unix('pwd');
direc=direc(1:length(direc)-1);
if lngsumfile(1,1)~='/',lngsumfile=[direc '/' lngsumfile];end
if strcmp(filtyp,'lngsum')==1,logdata=readlngsum(lngsumfile);end
if strcmp(filtyp,'lngasc')==1,logdata=lngasc2lng(lngsumfile);end
if strcmp(filtyp,'sum')==1,logdata=sum2lng(lngsumfile);end
i=find(lngsumfile=='/');
catfile=[findreakdir cyc '/seq/cat.txt'];
tx=readtextfile(catfile);
s=size(tx);
tid=dat2tim([str2num(date(1:4)) str2num(date(6:7)) str2num(date(9:10)) str2num(date(13:14)) str2num(date(16:17))]);
ttid=tid-ttime;
for j=8:s(1)-1
  seqtid=dat2tim([str2num(tx(j,14:17)) str2num(tx(j,19:20)) str2num(tx(j,22:23)) str2num(tx(j,26:27)) str2num(tx(j,29:30))]);
  if seqtid>=tid,break;end
  seq=remblank(tx(j,1:13));
end
fprintf(1,'\nSekvens %s\n',seq);
s=size(logdata);
ind=2;
for j=1:s(2)
  logtid=dat2tim([logdata(1,j) logdata(2,j) logdata(3,j) logdata(4,j) logdata(5,j)]);
  if logtid>=tid,break,end
  if logtid>=ttid,
    xtid(ind)=logtid;
    pow(ind)=logdata(8,j);
    hc(ind)=logdata(9,j);
    pattsum(ind)=logdata(10,j);
    tlowp(ind)=logdata(11,j);
    if ind==2,
      seqfile=[findreakdir cyc '/seq/' lower(seq) '.txt'];
      tx=readtextfile(seqfile);
      xtid(1)=ttid;
      pow(1)=logdata(8,j-1);
      hc(1)=logdata(9,j-1);
      pattsum(1)=logdata(10,j-1);
      tlowp(1)=logdata(11,j-1);
      [konrod(1,:),mminj]=readseq(seqfile,pattsum(1));
      fprintf(1,'%5.1f%6.0f%6.1f  0.00',pow(1),hc(1),tlowp(1));
    end
    [konrod(ind,:),mminj]=readseq(seqfile,pattsum(ind));
    fprintf(1,'%5.1f%6.0f%6.1f%6.2f',pow(ind),hc(ind),tlowp(ind),(xtid(ind)-xtid(1))*24);
    ind=ind+1;
  end
end
fprintf(1,'\n');
