function [offset,Nrow]=GetOffset(stpt,suminfo)

minstpt=min(stpt);
maxstpt=max(stpt);
offset=suminfo.file.newcase_byte(minstpt);
Nrow=[suminfo.file.newcase_row(minstpt)+1;suminfo.file.newcase_row(maxstpt+1)];