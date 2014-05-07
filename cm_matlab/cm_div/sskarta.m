%
% Function sskarta('infil','sskartfil')
% Prepares cr-maps from distr.-files
%
% Om infil används ska den innehålla: Title,filnamn,EFPH
% enligt exemplet nedan:
% TITLE FORSMARK 2 - Sim. av cykel 22, 3252 till 9090 EFPH
% /cm/f2/c22/dist/4000.dat 3500
% /cm/f2/c22/dist/4500.dat 4000
% /cm/f2/c22/dist/5000.dat 4500
%
% Om infil ej ges, så letar programmet efter indata-map.txt
% Om utfil ej anges, så skapas sskarta.ss
% 
% Version 2.0 Jan Karjalainen, FTB 2004
%
function sskarta(infil,utfil)
  disp('*')
  disp('*')
  disp('------------------------------------------')
  disp('           SSKARTA Version 2.0')
if nargin<1
  infil='indata-map.txt';
  disp('------------------------------------------')
  disp('Indata will be read from indata-map.txt')
else
  disp('------------------------------------------')
  disp('Indata will be read from '), eval('infil') 
end
if nargin<2
  utfil='sskarta.ss';
    disp('------------------------------------------')
    disp('Control-maps will be printed on sskarta.ss')
else
  disp('---------------------------------------')
  disp('Control-maps will be printed on '), eval('utfil') 
end
fid=fopen(infil);
if fid==-1
    disp('------------------------------------------')
    disp('Infilen saknas!!')
    disp('------------------------------------------')
else
titel=fgetl(fid);
rad=fgetl(fid);
pos=find(rad==32);
distfiler=rad(1:pos(1)-1);
langd=length(rad);
efph=rad(pos(1)+1:langd);
	for i=2:100;
  	rad=fgetl(fid);
  	langd=length(rad);
  		if langd>2
  		pos=find(rad==32);
  		distfiler=strvcat(distfiler,rad(1:pos(1)-1));
  		efph=strvcat(efph,rad(pos(1)+1:langd));
  		else break
  		end
	end
fel=0;
efph=str2num(efph);  
	try
	printsskarta(distfiler,efph,titel,utfil);
	catch
	disp('------------------------------------------')
	disp('Ett fel har uppstått. En eller flera ')
    	disp('distfiler saknas eller är felaktiga.')
    	disp('------------------------------------------')
	fel=1;
	end
		if fel==0
		disp('------------------------------------------')
		disp('CR-maps for the following EFPH values')
		disp('have been produced:')
		efph
		fclose(fid);
		disp('------------------------------------------')
		disp('         SSKARTA orderly terminated.')
		disp('------------------------------------------')
		disp('*')
  		disp('*')
  		end
end
