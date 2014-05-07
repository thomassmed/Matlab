function y = set_geometri(vec);
% y = set_geometri(vec)
%
% INPUT : Vektor som beskriver typ arean.
%
% OUTPUT : Omvandlad till termohydraulisk vektor.
%

global geom 

ncc=geom.ncc;
nsec=geom.nsec;

chanvec = vec(5:5+ncc);

temp = diag(chanvec);
temp1 = ones(nsec(5)+1,ncc+1);
temp2 = (temp1*temp)';
temp = temp2(:);

y = [vec(7+ncc);vec(1)*ones(nsec(1)+1,1);vec(2)*ones(nsec(2)+1,1);vec(3)*ones(nsec(3)+1,1);vec(4)*ones(nsec(4)+1,1)];
y = [y;temp;vec(6+ncc)*ones(nsec(6)+1,1) ];

return;
