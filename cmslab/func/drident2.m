function [dk,fd,drs,ord,th]=drident(x,T,nn,varargin)
% [dk,fd,drs,ord,th]=drident(x,T,nn)
%
% Beräknar dämpkvoten för en signal x. Identifiering sker med
% ARMA - modeller av ordningen 2,3,4,5,6,7,8. 
%
% x  - Insignal
% T  - samplingstid
% dk - dämpkvot
% fd - dämpad egenfrekvens
% drs - standardavvikelse för dk
% ord - Vald modellordning
% nn - 2xn matris med ordningstal för n modeller som ska prövas
%      default nn=[2,2;3,3;4,4;5,5;6,6;7,7;8,8;9,9;10,10];
%      ett alternativ nn=[2,2;3,3;4,3;5,3;6,5;7,5;8,7;9,7;10,9];
% th - cell med alla theta modeller
%
% [dk,fd,drs,ord,th]=drident(x,T,nn,'disp') gör en plott av den valda modellen

% Pär Lansåker 1994-02-15
% Modified Gustav Dominicus 1999-11-02

lx=length(x);

if nargin<3, nn=[]; end

%if ~exist('nn','var')
if isempty(nn)
  nn=[2 2; 3 3; 4 4; 5 5;6 6; 7 7; 8 8; 9 9; 10 10];
end
r=size(nn,1);

% Avtrendning
y=detrend(x,1);

%Nedsampling
ns=max([1 floor(1/T/10)]);
ns=1;

% Decimering
y=decimate(y,ns,'fir');

% Identfiering
dkt=zeros(r,1);
fdt=zeros(r,1);
drst=zeros(r,1);

for i=1:r
  th{i}=armax(y,nn(i,:),[],[],[],[],ns*T);
  [dkt(i),fdt(i),drst(i)]=th2dk(th{i});
  if any(strcmp(varargin,'disp')) & 0 % fungerar inte när th saknar komplexa
    thplot(th{i})                     % poler
    pause
  end
end

if ~all(drst>0.1),
  j=find(max(dkt)==dkt);  
  dk=dkt(j);
  fd=fdt(j);
  drs=drst(j);
  ord=nn(j,:); 
else                %Om ingen bra skattning kan göras med högre
  i=i+1;            %ordningens modeller väljs ett 2:a ord. system
  th{i}=armax(y,[2 2],[],[],[],[],ns*T);
  [dkt(i),fdt(i),drst(i)]=th2dk(th{i});       
  nn=[nn;2 2];
  %ord=[2 2];
  dk=dkt(i);
  fd=fdt(i);
  drs=drst(i);
  ord=nn(i,:); 
  j=i;
  warning('Ingen bra skattning, väljer 2:a ordningens system')
end

disp('       dk     fd      drs     ord')
disp('    ------------------------------')
st=ones(i,4)*char(' '); st(j,4)=char('*'); %markera vald modell med *
disp([st,num2str([dkt,fdt,drst],'%1.4f  ') num2str(nn)])


if any(strcmp(varargin,'disp'))
  thplot(th{j},1)
end
  
