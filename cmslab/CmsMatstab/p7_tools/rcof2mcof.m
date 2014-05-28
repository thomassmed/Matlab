function [varargout] = rcof2mcof(nramon,mode)
% [ref,D1,D2,s1,s2,n1,n2,sg,nu] = rcof2mcof(nramon)
% [ref,sp1,sp2,b1,b2,b3,b4,b5,b6,ld]=rcof2mcof(nramon,'delayed')
% rcof2mcof numrerar om koefficienterna från polca till matstab
% beroende på vilken polca som används. Hjälpfunktion till xsec2mstab
% matstab använder 5 koefficienter för varje polynom

% I polca 3.0.. används 2:a grads polynom för båda densitetsintervallen, i 2.7
% används 1:a grad för 750<dens<1000. Därav skillnaden i antal koeff. 

if nargin==1
  if nramon == 200     %om polca 2.6
      ref(1) = 1;     %Density_mod
      ref(2) = 2;     %temp_fuel
      ref(3) = 3;     %Xenon
      ref(4) = 198;   %Rel. power
      ref(5) = 197;   %Steam void
      ref(6) = 196;   %CR fraction
      ref(7) = 4;     %D750, density treshhold
      D1 = 5:14;
      D2 = 15:24;
      s1 = 25:40;     %Siga1
      s2 = 41:61;     %Siga2 anvnder endast upp till s2(15)
      n1 = 62:71;     %NSF1
      n2 = 72:86;     %NSF2
      sg = 87:101;    %sigr
      nu = 102:111;
 
  elseif nramon == 250 %om polca 3.0
    ref(1) = 2;     %Density_mod
    ref(2) = 4;     %temp_fuel
    ref(3) = 5;     %Xenon
    ref(4) = 1;     %Rel. power
    ref(5) = 3;     %Steam void
    ref(6) = 6;     %CR fraction
    ref(7) = 10;    %D750, density treshhold
    D1(1:5) = 16:20;
    D1(6:10) = 22:26;
    D2(1:5) = 28:32;
    D2(6:10) = 34:38;
    s1(1:5) = 40:44;	    %Siga1
    s1(6:10) = 46:50;
    s1(11:15) = 52:56;
    s1(16) = 64;
    s2(1:5) = 65:69;	    %Siga2
    s2(6:10) = 71:75;
    s2(11:15) = 77:81;
    n1(1:5) = 97:101;	    %NSF1
    n1(6:10) = 103:107;
    n2(1:5) = 115:119;      %NSF2
    n2(6:10) = 121:125;
    n2(11:15) = 127:131;
    sg(1:5) = 139:143;
    sg(6:10) = 145:149;
    sg(11:15) = 151:155;    %sigr
    nu(1:5) = 164:168;
    nu(6:10) = 170:174;
  end
  varargout={ref,D1,D2,s1,s2,n1,n2,sg,nu};
elseif nargin==2 %delayed neutrons coeff
  if nramon == 200     %om polca 2.6
    ref(1) = 1;     %Density_mod
    ref(2) = 2;     %temp_fuel
    ref(3) = 3;     %Xenon
    ref(4) = 198;   %Rel. power
    ref(5) = 197;   %Steam void
    ref(6) = 196;   %CR fraction
    ref(7) = 4;     %D750, density treshhold
    sp1=122:126;
    sp2=127:131;
    b1=132:136;
    b2=137:141;
    b3=142:146;
    b4=147:151;
    b5=152:156;
    b6=157:161;
    ld=162:167; 
  elseif nramon == 250 %om polca 3.0
    ref(1) = 2;     %Density_mod
    ref(2) = 4;     %temp_fuel
    ref(3) = 5;     %Xenon
    ref(4) = 1;     %Rel. power
    ref(5) = 3;     %Steam void
    ref(6) = 6;     %CR fraction
    ref(7) = 10;    %D750, density treshhold
    sp1=188:192;
    sp2=194:198;
    b1=200:204;
    b2=206:210;
    b3=212:216;
    b4=218:222;
    b5=224:228;
    b6=230:234;
    ld=236:241;
  end
  varargout={ref,sp1,sp2,b1,b2,b3,b4,b5,b6,ld};
end
