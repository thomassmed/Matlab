function varargout=ReadMat(filename)
% Alt 1 matinfo=ReadMat(filename)
% Alt 2 data=ReadMat(matinfo,distname,oper)

load(filename,'steady','fue_new','stab','geom', 'matr');

matcore.mminj=fue_new.mminj;
matcore.crmminj=fue_new.crmminj;
matcore.iafull=fue_new.iafull;
matcore.kmax=fue_new.kmax;
matcore.ij=knum2cpos(fue_new.knum,fue_new.mminj);
matcore.conrodcoor = knum2cpos(1:length(fue_new.konrod),fue_new.crmminj);
matcore.konrod = fue_new.konrod;
matcore.irmx = fue_new.irmx;
matcore.offset = fue_new.iofset;
% matcore.distlist={'Ppower'
%     'Pvoid'
%     'Pdens'
%     'alfa'
%     'burnup'
%     'Tfm'
%     'fa1'
%     'fa2'
%     'tfm'
%     'tcm'
%     'tw'
%     'Iboil'
%     'Wg'
%     'dP_core'
%     'ploss'
%     'dpin'
%     'dp_wr'};


matcore.number_of_points = 1;
matcore.crdsteps=fue_new.crdsteps;
matcore.tot_kan=geom.tot_kan;
matcore.tot_crd=max(size(fue_new.konrod));
matcore.xpo=0.0;

matcore.corekonrod=zeros(fue_new.iafull,fue_new.iafull,1);
matcore.corekonrod(:,:,1)=cr2core(fue_new.konrod,fue_new.mminj,fue_new.crmminj);


% distname=options.distname;
% matfile=fileinfo.fileinfo.fullname;
% load(matfile,'steady','fue_new','stab','geom', 'matr');

% core=zeros(fue_new.iafull,fue_new.iafull);
% core_ax= zeros(fue_new.kmax,1);
%
%
%
% distlist={'Ppower'
%     'Pvoid'
%     'Pdens'
%     'alfa'
%     'burnup'};


%% POWER
% if ~isempty(strmatch('Ppower',fieldnames(steady)))
if(max(strncmp('Ppower',fieldnames(steady),length('Ppower'))))
    eval(['matcore.RPF3D=steady.','Ppower',';']);
end

%% VOID
% if ~isempty(strmatch('Pvoid',fieldnames(steady)))
if(max(strncmp('Pvoid',fieldnames(steady),length('Pvoid'))))
    eval(['matcore.VOI3D=steady.','Pvoid',';']);
end

%% DENS
% if ~isempty(strmatch('Pdens',fieldnames(steady)))
if(max(strncmp('Pdens',fieldnames(steady),length('Pdens'))))
    eval(['matcore.DENS3D=steady.','Pdens',';']);
end

%% burnup
% if ~isempty(strmatch('burnup',fieldnames(fue_new)))
if(max(strncmp('burnup',fieldnames(fue_new),length('burnup'))))
    eval(['matcore.EXP3D=fue_new.','burnup',';']);
end

%% Evoid
ibast=matr.ibas_t;
knum=geom.knum;
kmax=fue_new.kmax;
ncc=size(knum,1);
evoid=sym_full(reshape(stab.et(ibast),kmax,ncc),knum);
matcore.EVOID3D=abs(evoid);

varargout{1}=matcore;

% dist=options.oper(dist(Nod,:));
% absevoid1=vec2cor(dist,fileinfo.core.mminj);
% absevoid=zeros(fileinfo.core.iafull,fileinfo.core.iafull,2);
% absevoid(:,:,1)=absevoid1;



% if ~isempty(strmatch(distname,fieldnames(fue_new)))
%     eval(['dist=fue_new.',distname,';']);
%     if size(dist,1)>1,
%         Nod=options.nodes;
%         dist=options.oper(dist(Nod,:));
%     end
%     if size(dist,2)<fue_new.kan,
%         dist=sym_full(dist,geom.knum);
%     end
%     core1=vec2cor(dist,fileinfo.core.mminj);
%     core(:,:,1)=core1;
%     varargout{1}=core;
%     
%     eval(['temp=fue_new.',distname,';']);
%     
%     core_ax(:,1)=mean(temp');
%     varargout{5}=core_ax;
%     
% end
% 
% 
% [~,ii]=sort(dist);
% drank(ii)=1:fue_new.kan;
% 
% color=zeros(fileinfo.core.iafull,fileinfo.core.iafull,2);
% color1=vec2cor(drank,fue_new.mminj);
% color(:,:,1)=color1;
% varargout{2}=color;
% 
% ibast=matr.ibas_t;
% knum=geom.knum;
% kmax=fue_new.kmax;
% ncc=size(knum,1);
% evoid=sym_full(reshape(stab.et(ibast),kmax,ncc),knum);
% dist=abs(evoid);
% dist=options.oper(dist(Nod,:));
% absevoid1=vec2cor(dist,fileinfo.core.mminj);
% absevoid=zeros(fileinfo.core.iafull,fileinfo.core.iafull,2);
% absevoid(:,:,1)=absevoid1;
% 
% [~,ii]=sort(dist);
% drank(ii)=1:fue_new.kan;
% 
% ecolor=zeros(fileinfo.core.iafull,fileinfo.core.iafull,2);
% ecolor1=vec2cor(drank,fue_new.mminj);
% ecolor(:,:,1)=ecolor1;
% 
% 
% 


%     [B,index] = sortrows(dist');
%     index1=index';
%     mminj=fue_new.mminj;
%     rank=knum2cpos(index1,mminj);
%
%     color = zeros(fue_new.iafull);
%     for i=1:fue_new.iafull
%         for j=1:fue_new.iafull
%             for m=1:fue_new.kan
%                 if (i == rank(m,1) && j == rank(m,2))
%                     color(i,j) = m;
%                 end
%             end
%         end
%
%     end
% varargout{3}=absevoid;
% varargout{4}=ecolor;
end






