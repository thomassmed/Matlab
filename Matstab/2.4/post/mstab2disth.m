function dist=mstab2disth(e,distfil,isym)
% dist=mstab2disth(e,distfil)
% dist=mstab2disth(e,distfil,isym)
% alfa_dist=mstab2disth(alfa,distfil)
%
% Translates eigenvector or steady-state variables of the matstab-solution
% to a  "POLCA-distribution" matrix, i.e. a (25,676)-matrix
% for Forsmark 1 and 2.
%
% Input:
%  e       - Interesting portion of eigenvector or steady-state variable
%  distfil - Distribution file
%  isym    - Symmetry according to RAMONA, default halfcore, isym=2
%
% Output:
% dist     - kmax by kkan matrix to be plotted i distplot

global msopt termo geom polcadata

ihydr=termo.ihydr;

if nargin<3, isym=msopt.CoreSym; end

%Check if e is T/H steady-state variable
lth=get_thsize;
if ~isempty(lth),
  if length(e)==lth,
   e = set_th2ne(e,ihydr);
  end
end

%[dum,mminj,konrod,bb,hy,mz]=readdist(distfil); % hämtar värden från matstab-distribution istället för från distfil, gör distfil överflödig
% som input. Lämnar ändå distfil kvar som input för att ej behöva ändra gamla script
mminj = polcadata.mminj;
iimax=length(mminj); 
kan=sum(iimax-2*(mminj-1)); 
kmax=geom.kmax;	
kanramona=length(e)/kmax;
knum=ramnum2knum(mminj,1:kanramona,isym);
dist=zeros(kmax,kan);

dist(:,knum(:,1))=reshape(e,kmax,kanramona);
if isym==2,
  dist(:,knum(:,2))=-dist(:,knum(:,1));
end
