ser=reshape(strtrim(cellstr(reshape(next_record.data{5},6,iafull*iafull)')),iafull,iafull)
%%
mminj=ones(iafull,1);
ihalf=floor(iafull/2)+1;
for i=ihalf:iafull,
  icount=0;
  for j=iafull:-1:ihalf
      icount=icount+1;
      if ~isempty(ser{i,j}), break;end
  end
  mminj(i)=icount;
end
mminj(1:ihalf-1)=mminj(iafull:-1:ihalf);