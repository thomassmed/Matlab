function j=get_realkpunkt(KPUNKT,mdkpunkt,real_kpunkt);
% j=get_realkpunkt(KPUNKT,mdkpunkt,real_kpunkt);
A=mdkpunkt';A=A(:)';
[mi,mj]=size(mdkpunkt);
ii=findstr(KPUNKT,A);
j=floor(ii/mj)+1;
%@(#)   get_realkpunkt.m 1.1   98/08/17     18:48:23
