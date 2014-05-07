function [dist,lam_th_dist,lam_neu_dist,lam_p,lam_sd,lam_dc,lam_lp,lam_riser,lam_bal,lam_pump]=excore_contribution(MstabFile);

%  [dist,lam_th_dist,lam_neu_dist,lam_out]=excore_contribution(MstabFile);
%

% Philipp Haenggi


load(MstabFile,'msopt','geom','termo','polcadata','stab','A0','AIm','B');

global msopt geom stab termo polcadata

distfile=msopt.DistFile;
kmax=geom.kmax;
kan=geom.kan;
ncc=geom.ncc;
nvt = geom.nvt;
nvn = geom.nvn;

e=stab.e;
v=stab.v;

dc  = length(get_dcnodes);
lp  = length([get_lp1nodes get_lp2nodes]);
core= length(get_corenodes);
riser=length(get_risernodes);
n=get_hydsize+kan*kmax*nvn;

[e0,v0]=expand_ev(A0,e,v);
v0=v0/(v0.'*B*e0);
Adr=spdiags(v0,0,n,n)*(A0+AIm*1j)*spdiags(e0,0,n,n);


start = 1;
stop  = 1;
lam_p    =sum(Adr(start:stop,:).');

start = stop+1;
stop  = stop+nvt;
lam_sd   =sum(Adr(start:stop,:).');

start = stop+1;
stop  = stop+dc*nvt;
lam_dc   =sum(Adr(start:stop,:).');

start = stop+1;
stop  = stop+lp*nvt;
lam_lp   =sum(Adr(start:stop,:).');

start = stop+1;
stop  = stop+core*nvt;
lam_th   =sum(Adr(start:stop,:).');
lam_th  =sum(reshape(lam_th,nvt,(ncc+1)*(kmax+1)));

start = stop+1;
stop  = stop+riser*nvt;
lam_riser=sum(Adr(start:stop,:).');

start = stop+1;
stop  = stop+ncc+1;
lam_bal  =sum(Adr(start:stop,:).');

start = stop+1;
stop  = stop+2;
lam_pump =sum(Adr(start:stop,:).');

start = stop+1;
stop  = stop+kan*kmax*nvn;
lam_neu  =sum(Adr(start:stop,:).');

lam_th_c=reshape(lam_th,ncc+1,kmax+1);
lam_th_in  =lam_th_c(2:ncc+1,2:kmax+1).';
lam_th_ex=(sum(lam_th_c(:,1))+sum(lam_th_c(1,:))-lam_th_c(1,1))/(kan*kmax);
lam_th  =lam_th_in+lam_th_ex;

lam_th  =lam_th(:);
lam_th_dist =mstab2dist(lam_th,distfile);

lam_neu  =sum(reshape(lam_neu,nvn,kan*kmax));
lam_neu_dist=mstab2dist(lam_neu,distfile);

lam_out     =sum([lam_p lam_sd lam_dc lam_lp lam_riser lam_bal lam_pump]);

dist=(real((lam_th_dist+lam_neu_dist)/2+lam_out/kan/kmax/2));

if nargout == 0
  distplot(distfile,'power',[],sum(real(dist)));
end
if nargout == 1
  distplot(distfile,'power');
end  
