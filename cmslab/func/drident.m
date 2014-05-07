function [dk,fd,drs,ord,th]=drident(x,T,nn,varargin)
% [dk,fd,drs,ord,th]=drident(x,T,nn,u)
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

u=[];
if nargin>3,
    for i=1:length(varargin)
        if strcmp(class(varargin{i}),'double')
            u=varargin{i};
        end
    end
end

%TODO fix single and stupid transpose
%if ~exist('nn','var')
if isempty(nn)
  %nn=[2 2; 3 3; 4 4; 5 5;6 6; 7 7; 8 8; 9 9; 10 10];
  nn=[4 4; 5 5;6 6; 7 7; 8 8; 9 9; 10 10];
end
r=size(nn,1);

% Avtrendning
y=detrend(x,1);

%Nedsampling
ns=max([1 floor(1/T/10)]);

% Decimering
y=decimate(y,ns,'fir');
if ~isempty(u)
    u=detrend(u,1);
    u=decimate(u,ns,'fir');
    if size(nn,2)==2,
        nn=[nn nn(:,1) zeros(r,1)];
    end
end

% Identfiering
dkt=zeros(r,1);
fdt=zeros(r,1);
drst=zeros(r,1);

drdata=iddata(y,u,ns*T);
for i=1:r
  th{i}=armax(drdata,nn(i,:));
  [dkt(i),fdt(i),drst(i)]=th2dk(th{i});
  if any(strcmp(varargin,'disp')) % fungerar inte när th saknar komplexa
    if i==1, figure;end
    zpplot(th{i})                     % poler
    figure(gcf)
    disp('Press any key to continue');
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
  th{i}=armax(drdata,[2 2]);
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
    zpplot(th{i})                     % poler
    figure(gcf)
end
  
