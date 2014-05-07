function varargout=ReadRes(varargin)

[limits,Xpo,Titles]=read_restart_bin(varargin{:},-1);
[fue_new,Oper,Title,Parameters,Dimensions,Derived_Terms,Fuel_Data,Grid,Segment,Core]=read_restart_bin(varargin{1},limits(1),limits(2));

matcore.fue_new=fue_new;

matcore.mminj=fue_new.mminj;
matcore.nfra=vec2cor(fue_new.nfra,fue_new.mminj);

matcore.crmminj=fue_new.crmminj;
matcore.iafull=fue_new.iafull;
matcore.kmax=fue_new.kmax;
matcore.ij=knum2cpos(fue_new.knum,fue_new.mminj);
matcore.conrodcoor = knum2cpos(1:length(fue_new.konrod),fue_new.crmminj);
matcore.irmx = fue_new.irmx;
matcore.offset = fue_new.iofset;
matcore.number_of_points = 1;
matcore.crdsteps=fue_new.crdsteps;
matcore.tot_kan=fue_new.kan;
matcore.tot_crd=max(size(fue_new.konrod));
matcore.ser=fue_new.ser;

matcore.xpo=zeros(length(Xpo),1);
for i=1:length(Xpo)
    matcore.xpo(i)=Xpo(i);
end

for i=1:length(Xpo)   
%% DENS
matcore.DENS3D(:,:,i) = zeros(fue_new.kmax,fue_new.kan);

%% Evoid
matcore.EVOID3D(:,:,i) = zeros(fue_new.kmax,fue_new.kan);

end

varargout{1}=matcore;

end






