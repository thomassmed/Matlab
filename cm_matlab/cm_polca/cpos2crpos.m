%@(#)   cpos2crpos.m 1.2	 01/03/06     13:30:34
%
%function yx=cpos2crpos(cpos,mminj)
function yx=cpos2crpos(cpos,mminj)
y=floor((cpos(:,1)+1)/2);
x=floor((cpos(:,2)+1)/2);
ll=length(mminj);
mmaxj=ll+1-mminj;
for i=1:size(cpos,1)
  if mminj(cpos(i,1))/2==round(mminj(cpos(i,1))/2)
    if cpos(i,2)==mminj(cpos(i,1)),x(i)=[];y(i)=[];end
    if cpos(i,2)==mmaxj(cpos(i,1)),x(i)=[];y(i)=[];end
  else
    if mminj(cpos(i,2))/2==round(mminj(cpos(i,2))/2)
      if cpos(i,1)==mminj(cpos(i,2)),x(i)=[];y(i)=[];end
      if cpos(i,1)==mmaxj(cpos(i,2)),x(i)=[];y(i)=[];end
    end
  end
  if cpos(i,2)<mminj(cpos(i,1))|cpos(i,2)>mmaxj(cpos(i,1))|cpos(i,1)<mminj(cpos(i,2))|cpos(i,1)>mmaxj(cpos(i,2)),x(i)=[];y(i)=[];end
end
yx=[y x];
