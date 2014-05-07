function ao=aocalc(dis3d)
%%
[kmax,kan]=size(dis3d);

pb=sum(dis3d(1:floor(kmax/2),:));
pt=sum(dis3d(ceil(kmax/2)+1:kmax,:));

if mod(kmax,2)==1, 
    k_mid=ceil(kmax/2);
    pt=pt+0.5*dis3d(k_mid,:);
    pb=pb+0.5*dis3d(k_mid,:);
end

ao=(pt-pb)./(pt+pb);
