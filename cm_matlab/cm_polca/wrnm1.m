%@(#)   wrnm1.m 1.2	 94/08/12     12:11:13
%
function wrnm1(farg,symbol)
if nargin<1, farg=[0 0 0];end
if nargin<2, symbol='o';end
wrnmpos=[5 13
        9 17
        9 25
       17 5 
       17 13
       17 25
       25 9 
       25 17];
x=wrnmpos(:,2);
y=wrnmpos(:,1);
line(x,y,'linestyle',symbol,'erasemode','none','color',farg);
