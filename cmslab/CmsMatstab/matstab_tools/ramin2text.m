function [spacer_p7,bunpol,bunnr,ptyp]=ramin2text(f_ramona);

% [spacer_p7,bunpol,bunnr,ptyp]=ramin2text(f_ramona);
%
% reads all lines that start with a cardnumber from a ramona inputdesk.
%
% num = vector with card numbers
% dat = corresponding data
%
% ex: i=find(num==200000); KMAX=mat(i,3);
%

%@(#)   ramin2text.m 1.1   99/05/31     14:00:41

f_ramona=expand(f_ramona,'inp');
fid=fopen(f_ramona);
file = fread(fid);
po=[0;find(file==10)];
j=1;

spacer_p7=[];

bunpol=setstr(zeros(200,4));
ptyp=setstr(zeros(100,8));
bunnr=zeros(200,1);
ityp=1;
ibnr=1;
flag33=0;
for i = 1:length(po)-1
  [dat1,nout]=sscanf(setstr(file(po(i)+1:po(i+1)-1)'),'%f');
  if ~isempty(dat1)
    if dat1(1)==332000
      if flag33==2, 
        disp('Warning Input card 332000 MUST NOT be combined');
        disp('with input card 339900!');
      end
      flag33=1;
      rad=setstr(file(po(i)+1:po(i+1)-1)');
      dat1=sscanf(rad,'%f%f%s')';
      fnutt=find(abs(rad)==34);                                                   
      bunpol(dat1(2),1:fnutt(2)-fnutt(1)-1)=rad(fnutt(1)+1:fnutt(2)-1);
      ibnr=ibnr+1;
      dat(j,1:length(dat1))=dat1;
    elseif dat1(1)==529900,
      if flag33==1, 
        disp('Warning Input card 332000 MUST NOT be combined');
        disp('with input card 339900!');
      end
      flag33=2;
      rad=setstr(file(po(i)+1:po(i+1)-1)');
      dat1=sscanf(rad,'%f%f%s%s')';
      fnutt=find(abs(rad)==34);                                                   
      ptyp(dat1(2),1:fnutt(2)-fnutt(1)-1)=setstr(rad(fnutt(1)+1:fnutt(2)-1));
      ityp=ityp+1;
      btyps=setstr(rad(fnutt(3)+1:fnutt(4)-1));
      ibt=find(btyps==',');
      ibt=[0 ibt length(btyps)+1];
      for i1=1:length(ibt)-1,
        bunpol(ibnr,1:ibt(i1+1)-ibt(i1)-1)=btyps(ibt(i1)+1:ibt(i1+1)-1);
        bunnr(ibnr)=dat1(2);
	ibnr=ibnr+1;
      end
    elseif dat1(1)==289900,
      [dum,cou,errmsg,nextind]=sscanf(setstr(file(po(i)+1:po(i+1)-1)'),'%f');
      spacer_p7=sscanf(setstr(file(po(i)+nextind:po(i+1)-1)'),'%s');
    end
    j=j+1;
  end
end
bunpol=bunpol(1:ibnr-1,:);
ptyp=ptyp(1:ityp-1,:);
bunnr=bunnr(1:ibnr-1);
fclose(fid);



