% Neutronic model and numerics for matstab
%
% Steady state
%   solv_fi     - solve the diffusion equation
%   eq_A1nm     - Calulates A1nm
%   eq_FA2      - Computes thermal flux
%   eq_fisspow  - Computes fission power
%   eq_xy       - Calculates X1nm,Y1nm,X2nm,Y2nm
%   albedo_type - Determines type of albedo (inner-outer corner, side etc)
%
% Dynamics
%   A_neu       - Build the neutronic linearized matrix
%   A_f12       - Help function for A_neu
%   eq_dA2dv    - Help function for A_neu
%   find_dlam   - used in search of dynamic eigenvalue
%   newt_neu    - used in search of dynamic eigenvalue
%   pcgsolve    - x = cgsolve(A,b,x0,tol,maxiter,disp_mode)
%   dist2en     - statring guess for dynamic eigenvector
