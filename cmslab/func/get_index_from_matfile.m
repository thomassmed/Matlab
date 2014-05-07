function indx=get_index_from_matfile(signaler,str)
sig_cell=cellstr(signaler);
irow=findrow(sig_cell,str);
for i=1:length(irow)
    temp=sscanf(sig_cell{irow(i)},'%i');
    indx(i)=temp(1);
end
