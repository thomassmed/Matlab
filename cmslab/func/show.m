function show(s);
%
%    Presenterar resultat fran drident
%    show(s), se help s
%

disp('---------------------------------------------------------------------');
disp(sprintf('Identifierade polparets dampkvot               : %2.4f',s(5)))
disp(sprintf('Identifierade polparets egenfrekvens   (Hz)    : %2.4f',s(9)))
disp(sprintf('Dominerande frekvenstopp i omradet 0.3-0.7 Hz  : %2.4f',s(10)))
disp(sprintf('Eventuell frekvenstopp i omradet 0.7-Fs/2 Hz   : %2.4f',s(11)))
disp(sprintf('Modellordning hos ARMA-modellen                : %2.0f',s(12)))
disp(sprintf('Standardavvikelse for decay ratio              : %2.4f',s(13)))
disp('                                                                     ')
