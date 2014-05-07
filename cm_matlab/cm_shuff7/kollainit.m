%@(#)   kollainit.m 1.1	 05/07/13     10:29:34
%
%
fprintf('%s\n','  buid buiboc fu re from to');
for i=1:700,
%or i=1:size(buid,1),
   i1=i+1-1;
   fprintf('%7s%7s%2i%2i%4i%4i',buid(i,:),buidboc(i,:),fuel(i1),ready(i1),from(i1),to(i1));
   fprintf('\n');
end
