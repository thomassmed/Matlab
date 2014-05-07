function [nr_rod,rodenr,rodba,rodenr2,rodba2,rodtype2,rodtype,nr_rod2] = java_calc_rod()

global cs;

cs.calc_rod();
nr_rod = cs.nr_rod;
rodenr = cs.rodenr;
rodba = cs.rodba;
rodtype = cs.rodtype;

% rodtype2 = cs.rod(1:nr_rod,1);
% rodenr2 = cs.rod(1:nr_rod,2);
% rodba2 = cs.rod(1:nr_rod,3);

rodtype2 = cs.rodtype2;
rodenr2 = cs.rodenr2;
rodba2 = cs.rodba2;
nr_rod2 = cs.nr_rod2;


end