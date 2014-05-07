function show(s);
%
%    Presenterar resultat fran drident
%    show(s), se help s
%

disp('--------------------------------------------------');
disp(sprintf('Dampkvot                   : %2.4f',s(5)))
disp(sprintf('Egenfrekvens   (Hz)        : %2.4f',s(9)))
disp(sprintf('Frekvenstopp (stabilitet)  : %2.4f',s(10)))
disp(sprintf('Frekvenstopp (annan)       : %2.4f',s(11)))
disp(sprintf('Modellordning              : %2.0f',s(12)))
disp(sprintf('Standardavvikelse dampkvot : %2.4f',s(13)))
disp('                                                 ')
