function [nnr,nnrv,eqn,varn,part]=whatis(eq,par,A);

%[nnr,nnrv,des,var,part]=whatis(eq,par,A);
%
% nnr:  node number of the equation
% nnrv: node number of the variable
% eqn:  name of the equation
% varn:  name of the variabel
% part: name of the reactor section

%@(#)   whatis.m 1.3   98/06/26     08:13:09

global termo geom
NIN=geom.nin;
NOUT=geom.nout;
N_NEU_TFUEL=geom.nvn;
NCC=geom.ncc; 
ihydr=termo.ihydr;

% name of equation

if nargin==1
  par=eq;
end

eqn=get_varname(eq);
eqn=eqn(2,7:10);
eqn=['Equation:   D/Dt ' eqn];

% name of variabel

varn=get_varname(par);
varn=varn(2,7:10);
varn=['Varialbel:  ' varn];

%node for equation

if eq > get_hydsize
  thc=0;
  nnr=NIN(NCC+5)+1;
elseif ~isempty(find(eq==[1 [get_hydsize-2-NCC:get_hydsize]]));
  part='not a node';
  nnr=[];
else
  thc=1;
  nnr=ceil((eq-1)/get_varsize);
end

if ~isempty(nnr)

if nnr==1
  part='Node one';
elseif ~isempty(find(nnr==NIN))
  part=['NIN:       ' num2str(find(nnr==NIN))];
elseif ~isempty(find(nnr==NOUT))
  part=['NOUT:      ' num2str(find(nnr==NOUT))];
elseif  ~isempty(find(nnr==get_dc1nodes))
  part=['Downcomer1: ' num2str(find(nnr==get_dc1nodes)-1)];
elseif ~isempty(find(nnr==get_dc2nodes))
  part=['Downcomer2: ' num2str(find(nnr==get_dc2nodes)-1)];
elseif ~isempty(find(nnr==get_lp1nodes))
  part=['Lowerpl1:  ' num2str(find(nnr==get_lp1nodes)-1)];
elseif ~isempty(find(nnr==get_lp2nodes))
  part=['Lowerpl2: ' num2str(find(nnr==get_lp2nodes)-1)];
elseif ~isempty(find(nnr==get_chnodes))
  if thc
    part=['Core, hydraulic channel :  ' num2str(mod(nnr-NIN(NCC+5),NCC))];
  else
    part=['Core, neutronic channel :  ' num2str(ceil((eq-get_hydsize)/N_NEU_TFUEL/25))];
    nnr=mod(ceil((eq-get_hydsize)/N_NEU_TFUEL),25);
  end
elseif ~isempty(find(nnr==get_bnodes))
  part=['Bypass:   ' num2str(find(nnr==get_bnodes)-1)];
elseif ~isempty(find(nnr==get_risernodes))
  part=['Riser:    ' num2str(find(nnr==get_risernodes))];
end

end

%node for variabel

if par > get_hydsize
 % nnrv=NIN(NCC+5)+ihydr(ceil((par-get_hydsize)/N_NEU_TFUEL/25))+(NCC+1)*(mod(ceil((par-get_hydsize)/N_NEU_TFUEL),25)-1);
   nnrv=mod(ceil((par-get_hydsize)/N_NEU_TFUEL),25);
elseif ~isempty(find(par==[1 [get_hydsize-NCC-2:get_hydsize]]));
  nnrv=[];
else
  nnrv=ceil((par-1)/get_varsize);
end

disp(' ')
disp(part)
disp(' ')
disp(['node: ' num2str(nnr) '  ' eqn])
disp(['node: ' num2str(nnrv) '  ' varn])
disp(' ')

if nargin==3
  disp(['entry:  ' num2str(A(eq,par))])
end


