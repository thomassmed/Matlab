function y = set_th2ne(thvec,ihydr)
%
% y = set_th2ne(thvec,ihydr)
%
% INDATA : Termohydraulisk variabel och beskrivande vektor för kanalerna mellan
%	   termohydrauliken och neutroniken.
%
% UTDATA : Termohydraulisk variabel omgjord till neutronikvariabel.
%

% Joakim Persson Forsmark 950411

global geom
ncc=geom.ncc;
nin=geom.nin;
nsec=geom.nsec;
kan=geom.kan;

stepth = 0:ncc+1:(ncc+1)*(nsec(5)-1);

startth = nin(5)+ncc;

nhydr = ihydr+startth;

temp = (diag(nhydr)*ones(kan,nsec(5)) + ones(kan,nsec(5))*diag(stepth))';
temp = temp(:);

y = thvec(temp);




