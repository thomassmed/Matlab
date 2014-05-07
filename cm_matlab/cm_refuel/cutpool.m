%@(#)   cutpool.m 1.4	 94/03/16     14:39:38
%
function pool=cutpool(oldpool,optionfile)
pool=oldpool;
load(optionfile)
if notbuntyp~=[]
  for i=1:size(notbuntyp,1)
    s=size(remblank(notbuntyp(i,:)));
    j=bucatch(notbuntyp(i,:),pool(:,14:13+s(2)));
    if j~=[]
      pool(j,:)='';
    end
  end
end
if notbuidnt~=[]
  for i=1:size(notbuidnt,1)
    s=size(remblank(notbuidnt(i,:)));
    j=bucatch(notbuidnt(i,:),pool(:,8:7+s(2)));
    if j~=[]
      pool(j,:)='';
    end
  end
end
