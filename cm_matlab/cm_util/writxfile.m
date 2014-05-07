%@(#)   writxfile.m 1.5	 98/03/05     09:10:11
%
%function writxfile(filename,mat)
function writxfile(filename,mat)
fid=fopen(filename,'w');
s=size(mat);
for i=1:s(1)
  j=find(abs(mat(i,:))==0);
  if ~isempty(j),mat(i,j)=setstr(32*ones(1,length(j)));end
  j=find(abs(mat(i,:))~=32);
  if abs(mat(i,s(2)))~=32,j=s(2);end
  if ~isempty(j),fprintf(fid,'%s\n',mat(i,1:j(length(j))));
  else fprintf(fid,'\n');end
end
fclose(fid);
