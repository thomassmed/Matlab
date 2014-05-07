function dist=contrib2dist(f_matstab,eq,var);

% dist=contrib2dist(f_matstab,eq,var);
%

% Philipp Haenggi

load(f_matstab,'geom','stab','termo','A0','AIm','B');

global geom stab

kan=geom.kan;
kmax=geom.kmax;
nvt = geom.nvt;
nvn = geom.nvn;

dc  = length(get_dcnodes);
lp  = length([get_lp1nodes get_lp2nodes]);
core= length(get_corenodes);
riser=length(get_risernodes);
n=get_hydsize+kan*kmax*nvn;
nv=nvt+nvn;
[r,k]=get_neutnodes;

lam=stab.lam;
e=stab.e;
v=stab.v;
[e0,v0]=expand_ev(A0,e,v);
v0=v0/(v0.'*B*e0);
Adr=spdiags(v0,0,n,n)*(A0+AIm*1j)*spdiags(e0,0,n,n);

if eq==0,
  eq=1;eqs=nv;
else
  eqs=eq;
end
if var==0,
  var=1;vars=nv;
else
  vars=var;
end

vec=0;
if eq<=nvt,
   x=r;
else
   x=k;
end
if var<=nvt
   y=r;
else
   y=k;
end

x=r;
for i=1:nvt
  lam_vareq(i,:,:)=full(sum(Adr(x+i-1,:).'));
  lam_vareq(i+nv,:,:)=full(sum(Adr(:,x+i-1)));
end

x=k;
for ii=1:nvn
  lam_vareq(nvt+ii,:,:)=full(sum(Adr(x+ii-1,:).'));
  lam_vareq(nvt+ii+nv,:,:)=full(sum(Adr(:,x+ii-1)));
end

dist=lam_vareq;
return
