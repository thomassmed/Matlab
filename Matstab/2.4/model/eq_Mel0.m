function M = eq_Mel0(n)
%eq_Mel0
%
%M = eq_Mel0(n) calculates the
%electrical torque of the recirkulation pump
%n is the pump motor speed.
%Used for steady state calculation with
%fzero('eq_Mel0',nhcpump)

%@(#)   eq_Mel0.m 2.2   02/02/27     11:48:51

%global variables for pump speed, pumdata, hyraulic
%and friction torque
global NPUMP MMOT
global termo
pump=termo.pump;


s = 1 - NPUMP/n;

M = 2*pump(14)/(s/pump(13) + pump(13)/s) - MMOT;

