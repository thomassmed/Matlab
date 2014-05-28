function get_polcadata


global msopt polcadata geom neu termo

neu.NeuModel=polca_version(msopt.DistFile);

if ~strcmp(neu.NeuModel,'POLCA7')
  error('MATSTAB 2.2 must be combined with POLCA 7')
end  


[dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(msopt.DistFile);

polcadata=struct( ...
'mminj',mminj, ...
'konrod',konrod, ...
'bb',bb, ...
'hy',hy, ...
'mz',mz, ...
'ks',ks, ...
'buntyp',asytyp, ...
'bunref',asyref, ...
'distlist',distlist, ...
'staton',staton, ...
'rubrik',rubrik, ...
'detpos',detpos, ...
'fu',fu, ...
'op',op, ...
'au',au, ...
'flopos',flopos, ...
'soufil',soufil);
  
geom.kmax=mz(17);                   	% No. of axial nodes
geom.kan=mz(14)/get_sym;            	% No. of bundles
geom.hz=bb(1)/geom.kmax*100;        	% Node hight (cm)
geom.hx=bb(13)*100;                 	% Node width (cm)
geom.crcovr=bb(16);                 	% Avg travel distance (m) covered by control rod
termo.Wtot=hy(2);                   	% core flow
termo.Wnom=hy(10);                  	% nominal core flow
termo.Qtot=hy(1)*hy(11);            	% thermal power
termo.Qnom=hy(1);                   	% nominal thermal power
termo.tlp=hy(14);                   	% temp lower plenum
termo.p=hy(3);                      	% top of reactor vessel pressure (Pa)
geom.nastyp=mz(44);			% No. of fuel assembly types	 				% inlagd 2005-12-09, Emma Lundgren
    
    
% Kommer distributionsfilen från POLCA7 Version: 4.5.0.1 eller från tidigare POLCA7 version???
% Testar med hy(36)
% hy(36) = tmpout (Core outlet coolant avg temperature (C)) för version 4.5.0.1
% hy(36) = flototpr (Total coolant flow, input start value (kg/s)) för tidigare versioner
% 		- kanske inte optimalt test dock...							% 2005-12-09, Emma Lundgren
   
    
if hy(36) < 1000			% Version 4.5.0.1
    
  termo.htc = hy(28);			% heat transfer coefficient channel/bypass			%ändrad plats från 31 till 28 iom 4.5	
  termo.Wfw=hy(165);			% Feed water flow (kg/s)					%ändrad plats från 135 till 165 iom 4.5
  neu.keffpolca=bb(96);			% keff polca							%ändrad plats från 91 till 96 iom 4.5
    
  %----------------------------------------------------------------------------------------------------
  termo.dpcore = hy(56);		% Average core pressure drop (Pa)				%ändrad plats från 61 till 56 iom 4.5
  termo.plowp = hy(57);			% Lower plenum inlet pressure (Pa)				%ändrad plats från 62 till 57 iom 4.5
  termo.putcor = hy(58);		% Core outlet pressure (Pa) (= Upper plenum inlet pressure)	%ändrad plats från 63 till 58 iom 4.5
  termo.putlowp = hy(59);		% Lower plenum outlet pressure (Pa)				%ändrad plats från 64 till 59 iom 4.5
  termo.pupple = hy(62);		% Upper plenum outlet pressure (Pa)				%ändrad plats från 67 till 62 iom 4.5
  termo.dpavin = hy(68);		% Avg. core inlet pressure drop (Pa) (incl CSP throttling)	%ändrad plats från 73 till 68 iom 4.5
  termo.spltot = hy(151);		% Total bypass flow as fraction of total core flow (-)		%ändrad plats från 121 till 151 iom 4.5
  % inlagda 2005-12-09, Emma Lundgren
  %---------------------------------------------------------------------------------------------------- 
  
  neu.NeuModelVersion = '4.5.0.1';
else 
   
  termo.htc=hy(31);			% heat transfer coefficient channel/bypass
  termo.Wfw=hy(135);             	% Feed water flow (kg/s)
  neu.keffpolca=bb(91);          	% keff polca
  
  %----------------------------------------------------------------------------------------------------
  termo.dpcore = hy(61);		% Average core pressure drop (Pa) 
  termo.plowp = hy(62);		% Lower plenum inlet pressure (Pa) 
  termo.putcor = hy(63);		% Core outlet pressure (Pa) (= Upper plenum inlet pressure)
  termo.putlowp = hy(64);		% Lower plenum outlet pressure (Pa) 
  termo.pupple = hy(67);		% Upper plenum outlet pressure (Pa) 
  termo.dpavin = hy(73);		% Avg. core inlet pressure drop (Pa) (incl CSP throttling)
  termo.spltot = hy(121);		% Total bypass flow as fraction of total core flow (-)
  % inlagda 2005-12-09, Emma Lundgren
  %---------------------------------------------------------------------------------------------------- 
    
  neu.NeuModelVersion = '3.0.6.x';
end
  
% check staton
switch lower(staton)
case {'leibstadt','l'}
  staton='l';
case {'forsmark 1','f1'}
  staton='f1';
case {'forsmark 2','f2'}
  staton='f2';
case {'forsmark 3','f3'}
  staton='f3';
case {'ringhals 1','r1'}
  staton='r1';
otherwise
  error(['MATSTAB does''nt support ',staton,' at the moment'])
end

polcadata.staton=staton;
