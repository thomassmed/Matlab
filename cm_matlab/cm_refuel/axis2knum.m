%@(#)   axis2knum.m 1.2	 94/03/16     14:39:36
%
%function knum=axis2knum(axisvec,mminj)
function knum=axis2knum(axisvec,mminj)
for i=1:size(axisvec,1)
  knum(i,:)=crpos2knum(axis2crpos(axisvec(i,:)),mminj);
end
