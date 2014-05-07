function tut=tabint(burnup,void,chist,tab)

%tut=tabint(burnup,void,chist,tab);

  ntab=tab(1);
  ne=tab(2);
  nv=tab(3);
  nc=tab(4);
  nerc=tab(5);
  ista=7;
  ncx=ista+ne+nv+nc;
  nevc=ne*nv*nc;

  x=tab(ista+(1:ne));
  y=tab(ista+ne+(1:nv));
  z=tab(ista+ne+nv+(1:nc));

  x(end+1)=3*x(end)-2*x(end-1);
  y(end+1)=3*y(end)-2*y(end-1);
  y=[3*y(1)-2*y(2);y];
  z(end+1)=3*z(end)-2*z(end-1);
  z=[3*z(1)-2*z(2);z];
  for j=1:ntab
    tabs=reshape(tab(ista+ne+nv+nc+(1:nevc)+(j-1)*nevc),ne,nv,nc);
    tabs(:,:,nc+1)= 3*tabs(:,:,nc)-2*tabs(:,:,nc-1);
    tabs(:,nv+1,:)= 3*tabs(:,nv,:)-2*tabs(:,nv-1,:);
    tabs=cat(2,3*tabs(:,1,:)-2*tabs(:,2,:),tabs);
    tabs(ne+1,:,:)= 3*tabs(ne,:,:)-2*tabs(ne-1,:,:);
    tabs=cat(3,3*tabs(:,:,1)-2*tabs(:,:,2),tabs);
    tut{j}=interp3(y,x,z,tabs,void,burnup,chist);
  end

  if nerc == -1
    iad=ncx+nevc*ntab;
    tut{5}=tut{1};
    tut{7}=tut{2};
    tut{1}=tab(iad+1)*ones(size(burnup));
    tut{2}=tab(iad+2)*ones(size(burnup));
    tut{3}=tab(iad+3)*ones(size(burnup));
    tut{4}=tab(iad+4)*ones(size(burnup));
    tut{6}=tab(iad+5)*ones(size(burnup));
    tut{8}=tab(iad+6)*ones(size(burnup));
  end






