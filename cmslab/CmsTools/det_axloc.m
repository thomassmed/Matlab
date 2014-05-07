function axloc=det_axloc(idetz,ddetz)

%%
ii=find(idetz);
axloc=[];
for i=1:length(ii)
    axloc(i)=(ddetz(ii(i))+ddetz(ii(i)+1))/2;
end