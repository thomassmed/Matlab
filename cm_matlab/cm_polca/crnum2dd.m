%
%@(#)   crnum2dd.m 1.2	 95/01/19     16:06:50
%
%function ddnum=crnum2dd(crnum,mminj)
function ddnum=crnum2dd(crnum,mminj)
ll=length(mminj);
for cr=1:length(crnum)
  ij=crnum2crpos(crnum(cr),mminj);
  ind=0;
  for i=-1:1
    for j=-1:1
      ind=ind+1;
      ddpos=[ij(1)+i ij(2)+j];
      if min(ddpos)<1|max(ddpos)>ll/2,ddnum(ind,cr)=0;
      else ddnum(ind,cr)=crpos2crnum(ddpos,mminj);end
    end
  end
end
