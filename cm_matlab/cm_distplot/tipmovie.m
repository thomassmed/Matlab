%@(#)   tipmovie.m 1.2	 94/01/25     12:43:37
%
function tipmovie
tipfig=gcf;
hvec=get(gcf,'userdata');
val=get(hvec(length(hvec)),'userdata');
nfiles=size(val,1);
hfil=hvec(length(hvec)-nfiles+1:length(hvec));
hfig=hvec(length(hvec)-nfiles);
hand=get(hfig,'userdata');
tipfiles=get(hfil(1),'userdata');
hand=get(hfig,'userdata');
M=get(hand(50),'userdata');
if size(M,1)==1
  figure(hfig);
  ival=find(val==1);
  hand=get(hfig,'userdata');
  ud=get(hand(2),'userdata');
  use=get(hand(51),'userdata');
  dname=remblank(use(5,:));
  setprop(4,dname);
  for j=ival:nfiles;
    figure(hfig);
    filename=remblank(tipfiles(j,:));
    setprop(5,filename);
    set(hand(1),'string',filename);
    disp(filename)
    ccplot;
    hand=get(hfig,'userdata');
    plmat=get(hand(3),'cdata');
    [ip,jp]=size(plmat);
    plmat(ip,jp-nfiles+j)=10.1;
    set(hand(3),'cdata',plmat);
    if j==ival
      M=moviein(nfiles-ival+1);
    end
    temp=getframe(hfig);
    M(1:length(temp),j-ival+1)=temp;
  end
  set(hand(50),'userdata',M);
end
figure(hfig);
movie(M,1,1);
