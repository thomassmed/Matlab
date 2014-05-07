%@(#)   crdiff.m 1.2	 94/02/08     12:31:17
%
%function crdiff(fil1,fil2,noplot)
%compares the tip-depletion in the files fil1 and fil2
%The difference is taken as fil1-fil2
%
%If plotta==0, no distplot is presented, default is plotta=1;
function crdiff(fil1,fil2,noplot)
if nargin<3, plotta=1;end
[crold,mminj]=readdist(fil2,'crburn');
crnew=readdist(fil1,'crburn');
crdiff=crnew-crold;
kvot=0.00145;
crdiff=(crdiff(1,:)+crdiff(27,:))*kvot;
cr2scr(crdiff,mminj,'%4.1f');
fprintf('\n')
fprintf('the results can also be found on crdiff.lis')
fprintf('\n')
cr2fil(crdiff,mminj,'crdiff.lis','%4.1f');
if plotta==1,
  distplot(fil1,'crdiff',upright,crdiff);
end
