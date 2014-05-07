function M = eq_Mel(n)
%eq_Mel
%
%M = eq_Mel(n) calculates the
%electrical torque of the recirkulation pump
%n is the pump speed. eq_Mel0 finds the stationary
%solution

%@(#)   eq_Mel.m 2.2   02/02/27     11:48:49

%global variables for pump speed, pumdata, hyraulic
%and friction torque
global NMOT
global termo
pump=termo.pump;

s = 1 - n/NMOT;

M = 2*pump(14)/(s/pump(13) + pump(13)/s);

