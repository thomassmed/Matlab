%@(#)   checkbp.m 1.2	 10/09/09     10:51:36
%
%
%function [ok,bumoved]=checkbp(fid,fid1,buidnt,mminj)
%Checks ONE bundle move in laddsdm w.r.t:
%       1) destination channel number (as compared to boc-file)
%       2) control rod withdrawal
function [ok,bumoved]=checkbp(fid,fid1,buidnt,mminj)
ok=1;
maxcc=length(mminj)/2;
rad=fgetl(fid);
slut=0;
while ~strcmp(rad(1:7),'move to'),
  rad=fgetl(fid);
  if ~isstr(rad), slut=1;break, end
end 
if slut==0,
  i=find(rad==' ');
  buid=rad(i(3)+1:i(4)-1);
  bumoved=sprintf('%6s',buid);
  rad=rad(i(4)+1:length(rad));
  knum=sscanf(rad,'%i');knum=knum(1);
  if knum>0,
    j=strmatch(buid,buidnt);  
    fprintf(fid1,'%s%s%s%3i%s%3i\n','buidnt:',buid,'  knum(check)= ',j,'  knum(laddsdm) = ',knum);
    if j~=knum,
       ok=0;
    end
    rad=fgetl(fid);
    while ~strcmp(rad(1:8),' average'),
      rad=fgetl(fid);
    end
    rad=fgetl(fid);
    if ~strcmp(rad(1:10),'running no')
      crnum=sscanf(rad,'%i');
      rad=fgetl(fid);
      crnum=[crnum sscanf(rad,'%i')];
      rad=fgetl(fid);  
      crnum=[crnum sscanf(rad,'%i')];
      crnum=crnum';
      cpos=knum2cpos(knum,mminj);
      crpos=fix((cpos+1)/2);
      ic=crpos(1);jc=crpos(2);
      for i1=1:3
        icc=ic-2+i1;
        for j1=1:3
          jcc=jc-2+j1;
          if icc<1|icc>maxcc|jcc<1|jcc>maxcc,
            crmatris(i1,j1)=0;
          else      
            crmatris(i1,j1)=crpos2crnum(icc,jcc,mminj);
          end      
        end
      end
      fprintf(fid1,'%s\n','     crcheck           crladdsdm');
      crtot=[crmatris,crnum];
      fprintf(fid1,'%7i',crtot(1,:));
      fprintf(fid1,'\n');
      fprintf(fid1,'%7i',crtot(2,:));
      fprintf(fid1,'\n');
      fprintf(fid1,'%7i',crtot(3,:));
      fprintf(fid1,'\n');
      if max(max(abs(crnum-crmatris)))>0,
        ok=0;
        fprintf(fid1,'\n%s\n','error when checking cr-withdrawal, crmatris=');
      end    
    end
  else
    fprintf(fid1,'%s%s\n','buidnt: ',buid);
  end
else
  ok=-1;
end
