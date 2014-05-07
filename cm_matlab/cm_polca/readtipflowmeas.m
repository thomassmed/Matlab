%@(#)   readtipflowmeas.m 1.5	 05/12/08     15:59:08
%
%function chmeas=readtipflowmeas(tipfiles)
%
%Finds the files /cm/fx/cy/tip/flow-??????.txt corresponding
%to the tipfiles given by input argument tipfiles, and reads the
%measured channel flows given in flow-??????.txt, ordered in alphabetical
%K-identity order, the i:th row of chmeas contains 8 values and corresponds to
%the i:th tipfile given by input argument tipfiles
%
function chmeas=readtipflowmeas(tipfiles)
date=tip2date(tipfiles);
it=find(tipfiles(1,:)=='/');unit=tipfiles(1,it(2)+1:it(3)-1);
[chnum,knam]=flopos(unit);
lt=size(tipfiles,1);
lc=length(chnum);
chmeas=zeros(lt,lc);
for i=1:lt
  it=find(tipfiles(i,:)=='/');tipdir=[tipfiles(i,1:it(length(it)-1)),'tip/flow-'];
  fid=fopen([tipdir,remblank(date(i,:)),'.txt']);
  if fid>0,
    rad=fgetl(fid);
    if strcmp(upper(rad(1:3)),'TIT'),
      rad=fgetl(fid);
    end
    kname(1,:)=sscanf(rad,'%s',1);
    lk=length(kname(1,:));
    chf(1)=sscanf(rad(lk+2:length(rad)),'%f',1);
    for j=2:lc
      rad=fgetl(fid);
      kname(j,:)=sscanf(rad,'%s',1);
      chf(j)=sscanf(rad(lk+2:length(rad)),'%f',1);
    end
    [dum,ic]=ascsort(kname);
    chmeas(i,:)=chf(ic);
    fclose(fid);
  end
end
         
