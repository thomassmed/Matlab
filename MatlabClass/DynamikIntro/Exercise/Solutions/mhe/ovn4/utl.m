
%%
% Konstanter

rf = [7.41 4.61 3.08 1.83 1.15 0.727]./1000;
rg = [7.41 4.61 3.08 1.83 1.15 1.15]./1000;
xf = [0.099 0.099 0.093 0.087 0.082 0.082]./1000;
xl = [0.113 0.112 0.11 0.103 0.100 0.09]./1000;

c = 0.8;
Up = 500;
Us = 230;
uz = 0.033;
S = 3000;
L = 70;
qf = 1.2;
qg = 1.2;

Zf = 64.8./1000;
Iu = 120;
%%

Zmax = c .* Up ./Iu
Zt = uz .* Up.^2 ./S
l = 1:L;
Z61 = zeros(length(rf),length(rf));
for i = 1:length(rf)
    for k = 1:length(rf)
        Z61(k,i) = Zmax - Zt - Zf - ...
                   60 .* sqrt((qg.*rg(k) + qf .*rf(k)).^2 + xl(k).^2) - ...
                   10 .* sqrt((qg.*rg(i) + qf .*rf(i)).^2 + xl(i).^2).*Us.^2./Up.^2;
    end
end

Z16 = zeros(length(rf),length(rf));
for i = 1:length(rf)
    for k = 1:length(rf)
        Z16(k,i) = Zmax - Zt - Zf - ...
                   5 .* sqrt((qg.*rg(k) + qf .*rf(k)).^2 + xl(k).^2) - ...
                   60 .* sqrt((qg.*rg(i) + qf .*rf(i)).^2 + xl(i).^2).*Us.^2./Up.^2;
    end
end

Z61
Z16