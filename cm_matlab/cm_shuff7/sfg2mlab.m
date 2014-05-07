%@(#)   sfg2mlab.m 1.1	 05/07/13     10:29:40
%
%
%function [to,buidnt,lline,cr]=sfg2mlab(infil)
function [to,buidnt,lline,cr]=sfg2mlab(infil)
fid=fopen(infil,'r');
for i=1:50
  s=fgetl(fid);
  if length(s)>1,
    if strcmp(upper(s(1:2)),'P,'), break;end
    if strcmp(upper(s(1:2)),'S,'), break;end
  end
end
ibu=0;
icr=0;
while isstr(s),
 if length(s)>1,
  if strcmp(s(1),'P')|strcmp(s(1),'S'),
    ii=find(s==',');
    is=length(s);
    buid=s(ii(1)+1:ii(2)-1);
    tostr=s(ii(3)+1:is);
    ibu=ibu+1;
    if ibu+icr==1,
      lline=s;
    else
      lline=str2mat(lline,s);
    end
    if strcmp(s(1),'P'),
      cr(ibu)=0;
      ito=axis2cpos(tostr);
    else
      cr(ibu)=1;
      ito=axis2crpos(tostr);
    end
    if max(ito)>0,
      buid=remblank(buid);
      %buid=sprintf('%6s',buid);
      
      lb=length(buid);
      buid = sprintf('%s%s',buid, setstr(32*ones(1,16-lb)));
      
      buidnt(ibu,:)=buid;
      to(ibu,:)=ito;
    elseif max(ito)==0
      to(ibu,:)=[0 0];
      buid=remblank(buid);lb=length(buid);
      %buid=sprintf('%6s',buid);
      
      buid = sprintf('%s%s',buid, setstr(32*ones(1,16-lb)));
      
      buidnt(ibu,:)=buid;
    end
  end
 end
 s=fgetl(fid);
end
fclose(fid);
