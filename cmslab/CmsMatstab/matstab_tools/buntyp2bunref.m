function bunref=buntyp2bunref(buntyp)
% bunref=buntyp2bunref(buntyp)
[l,k]=size(buntyp);
bunref=buntyp(1,:);
buntyp(1,:)=[];
j=strmatch(bunref(1,:),buntyp);buntyp(j,:)=[];
i=1;
while size(buntyp,1)>0,
    i=i+1;
    bunref(i,:)=buntyp(1,:);
    j=strmatch(bunref(i,:),buntyp);buntyp(j,:)=[];
end