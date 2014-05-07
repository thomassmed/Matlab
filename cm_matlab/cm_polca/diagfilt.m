%@(#)   diagfilt.m 1.2	 05/12/08     10:31:35
%
%function f=diagfilt(distfile,x)
function f=diagfilt(distfile,x)
[d,mminj,konrod,bb,hy,mz]=readdist7(distfile);
vec=ones(1,mz(14));
lm=length(mminj);
map=vec2core(vec,mminj);
for i=1:lm
  for j=1+x:2:lm
    map(i,j)=0;
  end
  x=1-x;
end
f=cor2vec(map,mminj);
