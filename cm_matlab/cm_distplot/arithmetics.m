%@(#)   arithmetics.m 1.4	 05/12/08     13:48:29
%
function arithmetics
harwin2=gcf;
z=get(gcf,'userdata');

distlist2=get(z(1),'string');
i=get(z(1),'value');
dname2=remblank(distlist2(i,:));

distfile2=get(z(2),'string');

[dist2,mminj2,konrod2,bb2,hy2,mz2,d1,d2,d3,staton2]=readdist7(distfile2,dname2);
[i2,j2]=size(dist2);
curf=z(3);
hand=get(curf,'userdata');
harwin1=get(hand(48),'userdata');
z1=get(harwin1,'userdata');

distlist1=get(z1(1),'string');
i=get(z1(1),'value');
dname1=remblank(distlist1(i,:));
 
distfile1=get(z1(2),'string');

[dist1,mminj1,konrod1,bb1,hy1,mz1,d1,d2,d2,d3,staton1]=readdist7(distfile1,dname1);
[i1,j1]=size(dist1);
%opnr=find(z1(2*ll+4:2*ll+7)==1);

opnr=find(z1(4:7)==1);

if length(opnr)>1, opnr=opnr(1);end
%opstr=get(z1(2*ll+7+opnr),'string');

opstr=get(z1(7+opnr),'string');

size(opstr);
if strcmp(opstr,'*')|strcmp(opstr,'/'),
 opstr=['.',opstr];
end
if all(mminj1==mminj2)
  if i1~=i2,
    imin=min(i1,i2);
    disp('Warning: number of values per channels are different');
    disp('The smallest one will be used')
    dist1=dist1(1:imin,:);
    dist2=dist2(1:imin,:);
    i1=imin;
    i2=imin;
  end
  if j1~=j2
    if j1==mz1(69)&j2==mz2(14)
      ikan=filtcr(konrod1,mminj1,0,100);
      dis1=zeros(i1,j2);
      for i=1:size(ikan,1),
        for j=1:4
          dis1(:,ikan(i,j))=dist1(:,i);
        end
      end
      dist1=dis1;
    elseif j2==mz2(69)&j1==mz1(14)
      ikan=filtcr(konrod2,mminj2,0,100);
      dis2=zeros(i2,j1);
      for i=1:size(ikan,1),
        for j=1:4
          dis2(:,ikan(i,j))=dist2(:,i);
        end
      end
      dist2=dis2;
    end
  end
  evvar=['aritvar=dist1',opstr,'dist2;'];
  eval(evvar);
  figure(curf);
  setprop(4,'MATLAB:Arithmetics');
  setprop(9,'auto');
  ccplot(aritvar);
  hpar=gcf;
else
  disp('Error: the two files have different core-geometries')
  disp([distfile1,': ',staton1]);
  disp([distfile2,': ',staton2]);
  disp('Make appropriate changes and try again')
end
