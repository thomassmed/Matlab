function [En,Ev]=get_harm(matfile)
% [En,Ev]=get_harm(matfile)
load(matfile,'stabh','geom','matr','msopt');
slask=zeros(geom.kmax,geom.tot_kan);
for i=1:size(stabh.en,2),
    slask(:,geom.knum(:,1))=reshape(stabh.en(:,i),geom.kmax,geom.kan);
    if msopt.CoreSym==2,
        slask(:,geom.knum(:,2))=-slask(:,geom.knum(:,1));
    end
    En{i}=slask;
    slask(:,geom.knum(:,1))=reshape(stabh.et(matr.ibas_t,i),geom.kmax,geom.kan);
    if msopt.CoreSym==2,
        slask(:,geom.knum(:,2))=-slask(:,geom.knum(:,1));
    end
    Ev{i}=slask;
end

