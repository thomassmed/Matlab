function [knum,sym]=Sum2knum(mminj,iafull,istart,jstart)

%%
kan=sum(iafull-2*(mminj-1));
ia=nan(kan,1); % Overallocate, for speed
ja=nan(kan,1); 
count=0;
for i=istart:iafull,
    for j=max(mminj(i),jstart):iafull-mminj(i)+1,
        count=count+1;
        ia(count)=i;
        ja(count)=j;
    end
end
%% Remove the overallocated piece
ia(count+1:end)=[];
ja(count+1:end)=[];
%%
[dum,sym,knum]=ij2mminj(ia,ja);

        
