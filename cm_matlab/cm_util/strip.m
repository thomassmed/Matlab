%@(#)   strip.m 1.2   96/02/09     13:17:50
% [fil,direc]=strip(infil)
%
% Removes the path from the filename
%Input:
%  infil - file name including path
%
%Output:
%  fil   - file name excluding path
%  direc - path
%
function [fil,direc]=strip(infil)
slash=max(find(infil=='/'));
if length(slash)>0,
   fil=infil(slash+1:length(infil));
   direc=infil(1:slash);
else
   fil=infil;
   [s,w] = unix('pwd');w=w(1:length(w)-1);direc=[w,'/'];
end
