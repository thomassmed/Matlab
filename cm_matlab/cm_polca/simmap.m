%@(#)   simmap.m 1.3	 06/06/13     15:35:02
%
%function txmap=simmap(simfile,utfil,efphstart);
function txmap=simmap(simfile,utfil,efphstart);
if nargin<2,utfil='sskarta.ss';end
if nargin<3,efphstart=0;end
load sim/simfile;
irad=1;
for i=1:size(filenames,1);
  [dist,mminj,konrod,bb]=readdist7(filenames(i,:));
  if i==1,
    fil=bocfile;
  else
    fil=filenames(i-1,:);
  end
  [dist,mminj,k,bb1]=readdist7(fil);
  [map,mpos]=cr2map(konrod,mminj);
  iss=1;
  txmap(irad,1:38)=sprintf('       %4i EFPH SS %5i Keff %7.5f',efphstart+bb1(73),bb(18),bb(96));
  irad=irad+1;
  for j=1:size(map,1)
    rad='';
    for k=1:size(map,2)
      if [j k]==mpos(iss,:),
        if konrod(iss)==1000
          rad=[rad sprintf(' --')];
        else
          rad=[rad sprintf('%3i',konrod(iss)/10)];
        end
        iss=iss+1;
        if iss==length(konrod)+1,break;end
      else
        rad=[rad sprintf('   ')];
      end
    end
    txmap(irad,1:length(rad))=rad;
    irad=irad+1;
  end
  txmap=[txmap; setstr(32*ones(2,size(txmap,2)))];
  irad=irad+2;
end
txmap1='';
txmap2='';
s=size(map);
s=s+[3 0];
stx=size(txmap);
nmap=(irad-1)/s(1);
for i=1:2:nmap
  txmap1=[txmap1; txmap((i-1)*s(1)+1:i*s(1),:)];
  if i<nmap
    txmap2=[txmap2; txmap(i*s(1)+1:(i+1)*s(1),:)];
  else
    txmap2=[txmap2; setstr(32*ones(s(1),stx(2)))];
  end
end
txmap=[txmap1 setstr(32*ones(size(txmap1,1),5)) txmap2];
writxfile(utfil,txmap);
