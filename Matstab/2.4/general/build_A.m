function [A0,B,AIm]=build_A(lam)

global msopt


% FUEL

[iAtf,jAtf,xAtf,iBtf,jBtf,xBtf]=A_tfuel(lam);


% NEUTRONICS

[iAneu,jAneu,xAneu]=A_neu(lam); 

xImAneu=imag(xAneu);
xAneu=real(xAneu);
iBneu=1;jBneu=1;xBneu=0;


% THEMO HYDRAULICS

[iAhyd,jAhyd,xAhyd,iBhyd,jBhyd,xBhyd]=A_hydro;


% BUILDING THE A AND B

B=sparse([iBhyd;iBneu;iBtf],[jBhyd;jBneu;jBtf],[xBhyd;xBneu;xBtf]);
A0=sparse([iAhyd;iAneu;iAtf],[jAhyd;jAneu;jAtf],[xAhyd;xAneu;xAtf]);
na=size(A0,1);
AIm=sparse(iAneu,jAneu,xImAneu,na,na);

A0 = scale_A(A0);
AIm = scale_A(AIm);

if strcmp(msopt.SaveOption,'large')
  save('-append',msopt.MstabFile,'A0','B','AIm');
end
