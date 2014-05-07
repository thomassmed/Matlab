function [mag,phi,mag0]=compare_eigvec(e0,e1)
%compare_eigvec
%
%[mag,phi,mag0]=compare_eigvec(e0,e1);
%Gives the magnitudes and phase-angle for 
%eigenvectors. mag is the difference in magnitude
%phi is phase difference and mage0 is magnitude of
%reference vector e0.

%@(#)   compare_eigvec.m 1.1   96/08/21     14:00:28

e = e0./(e1+eps);

mag = abs(e);
phi = 180/pi*angle(e);
mag0 = abs(e0);

if nargout==0,
  disp('      MAG     PHI[deg]     MAG0')
  disp('-------------------------------');
  disp([mag,phi,mag0])
end

