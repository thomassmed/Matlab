function x=stabload(file,varargin);
% x=stabload(file,variables)
% hämtar info ur matstab fil till struktur x
% Om variables anges hämtas dessa, annars hämtas
% Ppower, Pvoid, f_master, f_polca, lam och void och power från polcafil

[dum,dum,ext]=fileparts(file);
if ~strcmp(ext,'.mat')
  error([file 10 'is not a matstab file'])
end

if isempty(varargin)
  x=load(file,'lam','keff','Ppower','Pvoid','f_polca','f_master','besk');
else
  disp('Sorry, option with variables is not implemneted')
  return
end

if isempty(x.f_polca)
  error([file 10 ' is not a matstab file'])
end
if ~exist(x.f_polca,'file')
  warning(['Could not find POLCA file' 10 x.f_polca])
else
  [x.efi1,x.evoid,x.efi2]=f_matstab2dist(file);
  x.f_matstab=file;
  x.power=readdist(x.f_polca,'power');
  x.void=readdist(x.f_polca,'void');
end
