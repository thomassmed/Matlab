function [kpkt,unit,com]=fixb(b,nr)
% [kpkt,enhet,com]=fixb(b,nr)
% fixar till textvariabeln b fr�n ldracs eller mvar fr�n getf3
% nr �r signal nummret, default �r alla signaler
% flagga med f3 f�r f3 m�tdatafiler

if size(b,2)==123 %F3 format
  if exist('nr','var') 
    b=b(nr,:);
  end
  kpkt=b(:,4:24);
  unit=b(:,25:37);
  com=b(:,84:123);
else %F1/F2 racs-format
  b=b(b~=10);
  b=reshape(b,99,length(b)/99)';
  if exist('nr','var')
    b=b([1:2 2+nr],:);
  end
  kpkt=b(3:end,5:21);
  unit=b(3:end,22:28);
  com=b(3:end,68:99);
end
  

