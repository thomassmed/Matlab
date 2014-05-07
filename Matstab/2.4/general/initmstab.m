function initmstab(distfile);

if nargin==0;
  disp('Distfile must be given');
else
  global msopt polcadata geom termo neu fuel

  [msopt,polcadata]=init_msopt(distfile);

  get_inp;
end
