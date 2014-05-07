%@(#)   sirm.m 1.2	 94/08/12     12:11:05
%
function sirm
sirmpos=[9 9
        9 13
        9 21
       13 21
       17 9
       21 17
       21 25
       25 9];
x=sirmpos(:,2);
y=sirmpos(:,1);
line(x,y,'linestyle','o','erasemode','none','color',[0 0 0]);
