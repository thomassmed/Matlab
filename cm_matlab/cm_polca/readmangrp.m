%@(#)   readmangrp.m 1.1	 95/02/15     09:01:28
%
%function [name,nrod,rods]=readmangrp(cmanfile)
function [name,nrod,rods]=readmangrp(cmanfile)
t=readtextfile(cmanfile);
ind=0;
for i=1:2:size(t,1)-1
  ind=ind+1;
  name(ind,1:2)=t(i,1:2);
  nrods=str2num(sprintf('%s',t(i,20:20)));
  nrod(ind)=nrods;
  l=6*nrods;
  if l>size(t,2),l=size(t,2);end
  rods(ind,1:l)=t(i+1,1:l);
end
nrod=nrod';
