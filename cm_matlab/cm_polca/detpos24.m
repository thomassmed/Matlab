% This function find fuel channel numbers for fuel in cells with 
% detector
% i.e. detpos4 will be four columns
% Input: kkan - a vector of channelnumbers,
%        mminj - Vector describing core contour
%
%
% Output: Matrix output of size N by 4  
%
%
% function detpos4=detpos24(chdet,mminj)
function detpos4=detpos24(chdet,mminj)
l=length(mminj);
yx=knum2cpos(chdet,mminj);
bunline=l+2-2*mminj(:);
detemp=bunline(yx(:,1))+(bunline(yx(:,1)+1)-bunline(yx(:,1)))./2;
detpos4=[chdet chdet+1  detemp+chdet detemp+chdet+1];

