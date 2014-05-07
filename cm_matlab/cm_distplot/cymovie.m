%@(#)   cymovie.m 1.3	 95/03/29     08:19:27
%
function cymovie
hmat=get(gcf,'userdata');
hvec=hmat(1,:);
ll=length(hvec)-2;
hpar=hvec(ll+1);
hand=get(hpar,'userdata');
M=get(hand(50),'userdata');
if size(M,1)==1
  load('simfile');
  s=size(filenames);
  refdist=get(hand(51),'userdata');
  hfil=hvec(ll+2);
  for j=1:ll
    i(j)=get(hvec(j),'value');
  end
  dname=refdist(find(i),:);
  filename=get(hfil,'string');
  figure(hpar)
  i=[];
  for j=1:s(1)
    i(j)=strcmp(filename,filenames(j,:));
  end
  i=find(i);
  for j=i:s(1);
    filename=filenames(j,:);
    setprop(5,filename);
    set(hand(1),'string',filename);
    init(dname);
    if j==i
      M=moviein(s(1)+1-i);
    end
    M(:,j-i+1)=getframe;
  end
  set(hand(50),'userdata',M);
end
figure(hpar);
movie(M,0,2);
