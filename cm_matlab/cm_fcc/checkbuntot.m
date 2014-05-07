%@(#)   checkbuntot.m 1.2	 94/08/12     12:15:01
%
function ierr=checkbuntot(buntot1,buntot2)
[i1,k1]=size(buntot1);
[i2,k2]=size(buntot2);
ierr=0;
if i1==i2&k1==k2,
  di=abs(abs(buntot1)-abs(buntot2));
  di=max(di')';
  if max(di)>0, 
    ierr=1;
    disp(' The BUNTYP:s in batchdata-file differ from those in');
    disp(' the batchcost-file, please check.');
    i=find(di>0);
    disp(' ');
    disp([' buntot1:',buntot1(i,:)]);
    disp([' buntot2:',buntot2(i,:)]);
  end
elseif i1~=i2,
  ierr=1;
  disp('The number of BUNTYP:s in batchdata-file differ from the number');
  disp('of BUNTYP:s the batchcost-file, please check');
else
  ierr=1;
  disp('The BUNTYP:s in batchdata-file differ from those in');
  disp('the batchcost-file, please check');
end
