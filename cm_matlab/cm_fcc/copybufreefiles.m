%@(#)   copybufreefiles.m 1.1	 99/01/12     10:09:23
%
%Denna funktion kopierar automatiskt bufreefil.mat (utfil från findfree) till
% /cm/fx/div/bunhist/freebundles.mat
% /cm/fx/div/bunhist/freefiles/bufree-year.mat
% Den kopierar även freedata.mat(utfil från findfree) till
% /cm/fx/div/bunhist/free-year.mat
% VARNING används endast efter rev

function copybufreefiles

reakdir=findreakdir;
bufreefil=[findreakdir,'div/bunhist/bufreefil.mat'];
freedatafil=[findreakdir,'div/bunhist/freedata.mat'];
freebundlesfil=[findreakdir,'div/bunhist/freebundles.mat'];
ar=datestr(datenum(date),10);
bufreearfil=[findreakdir,'div/bunhist/freefiles/bufree-',ar,'.mat'];
freearfil=[findreakdir,'div/bunhist/freefiles/free-',ar,'.mat'];
ramsa1=['!cp ',bufreefil,' ',freebundlesfil];
ramsa2=['!cp ',bufreefil,' ',bufreearfil];
ramsa3=['!cp ',freedatafil,' ',freearfil];
eval(ramsa1)
eval(ramsa2)
eval(ramsa3)
