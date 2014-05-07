%@(#)   temppofil.m 1.1	 05/07/13     10:29:42
%


function tempfil = temppofil(poolfil)

load(poolfil)
tempasyid = asyid;
temppos = pos;
temppbox = pbox;

tempfil = 'temppofil.mat';
evstr=['save ' tempfil ' temppos tempasyid temppbox'];
eval(evstr);
