function Subpow = Submesh2Power(Power,Submesh,geometr,hz,kmax)

datpos = SubNode2NodePos(geometr,hz,kmax);
Subpow = cell(size(Submesh));
for i = 1:length(Submesh)
   for k = 1:length(Submesh{i})
       Subpow{i}(:,k) = Power(datpos{i}(k),i) + Submesh{i}(:,k);
   end
end
end