%@(#)   vec2core.m 1.2	 94/08/12     12:11:09
%
% This function creates a core for 3D-plotting
% Input: vec2d - a 2-dimensional distrubution,
%                e.g. MAX(SHF), CPR etc.
%
%        mminj - Vector describing core contour
%
%
% Output: core - Matrix output of size N by N (i.e., 30 by 30 for Forsmark) 
%
%
%function core=vec2core(vec2d,mminj)
function core=vec2core(vec2d,mminj)
l=length(mminj);
lv=size(vec2d);
if lv(1)>1,
    vec2d=vec2d';
end
v=zeros(l,l);
ind=0;
for i=1:l,
  nind=l+2-2*mminj(i);
  core(i,mminj(i):l+1-mminj(i))=vec2d(ind+1:ind+nind);
  ind=ind+nind;
end
