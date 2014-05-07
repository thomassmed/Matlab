%@(#)   hrot2qrot.m 1.1	 06/09/13     15:09:41
%
%function hrot2qrot(distfil_in,distfil_ut);
function hrot2qrot(distfil_in,distfil_ut);
dist_str=['ASYID   ';'ASYTYP  '];
dist_2d= ['EFPH    ';'KHOT    '];
dist_3d= ['BURNUP  '];
[khot,mminj]=readdist7(distfil_in,'khot');
burnup=readdist7(distfil_in,'burnup');
i=find(mean(burnup)==0);
khot(i)=khot(i)+ones(size(i));
mat=knumsym(mminj,5);
[i,rank]=sort(khot(mat(:,1)));
[i,rank2]=sort(khot(mat(:,2)));
[i,rank4]=sort(khot(mat(:,4)));

% Strängfördelningar

for jj=1:size(dist_str,1)
  dname=remblank(dist_str(jj,:));
  dist=readdist7(distfil_in,dname);
  tmp=dist;
  for j=1:size(mat,1)
    i=find(rank2==rank(j));
    tmp(mat(rank(i),2),:)=dist(mat(rank2(i),2),:);
    tmp(mat(rank(i),4),:)=dist(mat(rank4(i),4),:);
  end
  writedist7(distfil_ut,tmp,dname)
end

% 2D-fördelningar

for jj=1:size(dist_2d,1)
  dname=remblank(dist_2d(jj,:));
  dist=readdist7(distfil_in,dname);
  tmp=dist;
  for j=1:size(mat,1)
    i=find(rank2==rank(j));
    tmp(mat(rank(i),2))=dist(mat(rank2(i),2));
    tmp(mat(rank(i),4))=dist(mat(rank4(i),4));
  end
  writedist7(distfil_ut,tmp,dname)
end

% 3D-fördelningar

for jj=1:size(dist_3d,1)
  dname=remblank(dist_3d(jj,:));
  dist=readdist7(distfil_in,dname);
  tmp=dist;
  for j=1:size(mat,1)
    i=find(rank2==rank(j));
    tmp(:,mat(rank(i),2))=dist(:,mat(rank2(i),2));
    tmp(:,mat(rank(i),4))=dist(:,mat(rank4(i),4));
  end
  writedist7(distfil_ut,tmp,dname)
end
