%@(#)   bransleflytt2.m 1.3	 05/05/04     13:24:35
%
function b=bransleflytt2(eocfil,bocfil,delta,utfil);
[eock,mminj,konrod,bb,hy,mz]=readdist7(eocfil,'khot');
bock=readdist7(bocfil,'khot');
eocid=readdist7(eocfil,'asyid');
bocid=readdist7(bocfil,'asyid');
a=mbucatch(bocid,eocid);
for i=1:length(a)
  if a(i)~=i
    k1=eock(i);
    b1=eocid(i,:);
    b2=bocid(i,:);
    n2=bucatch(b2,eocid);
    k2=eock(n2);
    n1=bucatch(b1,bocid);
    if abs(k2-k1)<delta & ~isempty(n1)
      yx1=knum2cpos(i,mminj);
      yx2=knum2cpos(n1,mminj);
      fprintf(1,'\n%3i%3i%10s ->%3i%3i%10.5f',yx1(1),yx1(2),b2,yx2(1),yx2(2),k2-k1);
    end
  end
end
fprintf(1,'\n');
