function [ind,str]=racsb2ind(b,kpkt)
% [ind,str]=racsb2ind(b,kpkt)
% return index to c and description string for K-punkt.


str=[];

if min(size(b))==1 %F1 or F2 file format
  nyrad=findstr(b,10);
  for i=1:size(kpkt,1)
    nx=findstr(b,kpkt(i,:));
    if ~isempty(nx)
      irad=find((nx-nyrad<0));
      irad=irad(1)-1;
      ind(i)=str2num(b(nyrad(irad)+1:nyrad(irad)+4));
      str=strvcat(str,b(nyrad(irad)+1:nyrad(irad+1)-1));
    else
      warning(['Signal ',kpkt(i,:),' not found'])
    end
  end
else % F3 format
  % remove row index in b
  n=min(find(b(end,:)==' '));
  bb=b(:,n+1:end);
  for i=1:size(kpkt,1)
    nx=strmatch(kpkt(i,:),bb);
    if length(nx)==1 
      ind(i)=nx;
      str=strvcat(str,b(ind(i),:));
    else
      warning(['Signal ',kpkt(i,:),' not found'])
    end
  end
end
  
  
