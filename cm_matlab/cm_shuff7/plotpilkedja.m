%@(#)   plotpilkedja.m 1.1	 05/07/13     10:29:36
%
%
function [hpil,hring]=plotkedjatest(kedja,mminj,knumpos)
%setprop(16,'off');
l=length(kedja);
ct=knum2cpos(kedja(2:l),mminj);
cf=knum2cpos(kedja(1:l-1),mminj);
xl=[cf(:,2)'+.7;ct(:,2)'+.35];
yl=[cf(:,1)'+.7;ct(:,1)'+.45];
hpil=zeros(l-1,1);hring=hpil;


farg = [0, 0, 0
0.7, 0.2, 1.0];
%0, 0.75, 0];






for i=1:l-1,
  v=[xl(1,i)-xl(2,i) yl(1,i)-yl(2,i)];
  v=v/norm(v)*0.2;
  vort=[-v(2) v(1)]/2;
  x3=xl(2,i)+v(1)+vort(1);
  x4=xl(2,i)+v(1)-vort(1);
  xl1(:,i)=[xl(:,i);x3;x4;xl(2,i)];  
  y3=yl(2,i)+v(2)+vort(2);
  y4=yl(2,i)+v(2)-vort(2);
  yl1(:,i)=[yl(:,i);y3;y4;yl(2,i)];
  



  if i == knumpos
  	hring(i)=line(cf(i,2)+.75,cf(i,1)+.75,'marker','o','color',farg(2,:),'erasemode','normal', 'linewidth', 2.0);
  	hpil(i)=line(xl1(:,i),yl1(:,i),'color',farg(2,:),'erasemode','normal', 'linewidth', 2.0);
  
  
  
  else
  	hring(i)=line(cf(i,2)+.75,cf(i,1)+.75,'marker','o','color',farg(1,:),'erasemode','normal', 'linewidth', 2.0);
  	hpil(i)=line(xl1(:,i),yl1(:,i),'color',farg(1,:),'erasemode','normal', 'linewidth', 2.0);
  end


end



%hpil=line(xl1,yl1,'color',farg,'erasemode','normal', 'linewidth', 2.0);


