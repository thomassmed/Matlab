function y = get_coretransf(corevector);
% y = set_coretransf(corevector)
%
% y: Vector describing the state for the fuel nodes
% corevector: Thermo hydraulic vector for the fuel nodes only

global geom

ncc=geom.ncc;
nsec =geom.nsec;

temp = [reshape(corevector,ncc,nsec(5));zeros(1,nsec(5))];
temp = temp(:);
temp = [zeros(1,sum(nsec(1:4)+1)+1+ncc+1) temp' zeros(1,nsec(6)+1)];

y = temp';
return;
