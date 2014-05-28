%@(#)   half2full.m 1.3	 97/08/03     19:56:17
%
%function kfull=half2full(khalf,mminj)
%translates half-core channelnumber to full-core channel number
%First index (khalf(i,1)) always refers to right half core,
%second index (khalf(i,2)) refers to left half core,
function kfull=half2full(khalf,mminj)
ll=length(khalf);
iimax=length(mminj);
iihalf=iimax/2;
kfull=zeros(ll,2);
kkan=sum(iimax+2-2*mminj);
for i=1:ll
  summa=0;
  if khalf(i)>kkan/2,
    kfull(i,:)=[0 0];
    disp('Error: half channel number too large:');
    disp(['khalf(',sprintf('%2i',khalf(i)),') = ',sprintf('%3i',khalf(i))]);
  else
    for j=1:iimax,
      summa=summa+(iimax+2-2*mminj(j))/2;
      if summa>=khalf(i), break;end
    end
    kfull(i,1)=summa+khalf(i);
  end 
end
kfull(:,2)=kkan+1-kfull(:,1);
