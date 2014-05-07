%
% Oprm simulator
%	Simulerar oprm algoritmerna för en oprm-cell
%
% Input:
%	data		Matris med tidsvektor och 4 LPRM-signaler
%
% Output:
%	output 		Struct med resultat från simulering
%
function output=oprmsim(data,varargin)

% Parameters

% Defaults
TMIN = 1.20;
TMAX = 4.00;
S1 = 1.10;
S2 = 0.92;
EP = 0.100;
FC = 1;

% GRBA
DR3H1 = 1.20;
DR3H2 = 1.25;
DR3H3 = 1.30;

% ABA
SMAXH1 = 1.20;
SMAXH2 = 1.25;
SMAXH3 = 1.30;

% PBA
NPH1 = 6;
NPH2 = 8;
NPH3 = 10;
SPH1 = 1.05;
SPH2 = 1.08;
SPH3 = 1.10;


% Override default parameters with those in parameterfile
if ~isempty(varargin) & exists(varargin{1})
	load(varargin{1});
end


t = data(:,1);
rn = data(:,2:end);

% Hitta samplingsintervall från tidsvektorn
tsampl = t(2)-t(1);

% Lågpass-filter för att avlägsna brus
fn = oprmfilter(t,rn,FC,tsampl);

% Kombinering av lprm-signaler till en OPRM-cell
sn = (fn(:,1)+fn(:,2)+fn(:,3)+fn(:,4))/4;

% Filter för medelvärdesbildning
an = oprmfilter(t,sn,0.167,tsampl);

% Normalisering
cn = sn ./ an;

% Length of timevector
tlength = length(t);

% Initial values
TP = 0;
TP1 = 0;
TV = 0;
TV1 = 0;
TSP = 0;
TSV = 0;
T = 0;
SIGN = 0;
PEAK = 0;
VALLEY = 0;

S1CONDH1 = 0;
S1CONDH2 = 0;
S1CONDH3 = 0;
S2CONDH1 = 0;
S2CONDH2 = 0;
S2CONDH3 = 0;
S1CONDAH1 = 0;
S1CONDAH2 = 0;
S1CONDAH3 = 0;
S2CONDAH1 = 0;
S2CONDAH2 = 0;
S2CONDAH3 = 0;

T0H1 = 0;
T0H2 = 0;
T0H3 = 0;
NCH1 = 0;
NCH2 = 0;
NCH3 = 0;
S3H1 = 0;
S3H2 = 0;
S3H3 = 0;

GRBAH1 = 0;
GRBAH2 = 0;
GRBAH3 = 0;

ABAH1 = 0;
ABAH2 = 0;
ABAH3 = 0;

PBAH1 = 0;
PBAH2 = 0;
PBAH3 = 0;

% Initialize alarm matrices
grba_trip = zeros(tlength,1);
grba_pretrip = zeros(tlength,1);
grba_alarm = zeros(tlength,1);

aba_trip = zeros(tlength,1);
aba_pretrip = zeros(tlength,1);
aba_alarm = zeros(tlength,1);

pba_trip = zeros(tlength,1);
pba_pretrip = zeros(tlength,1);
pba_alarm = zeros(tlength,1);

confcount = zeros(tlength,1);

period = zeros(tlength,1);
period0 = zeros(tlength,1);

% Run algorithms on signal
for i=3:tlength
	
	[T,TP,TP1,TV,TV1,TSP,TSV,SIGN,PEAK,VALLEY] = peakdetect(cn(i),cn(i-1),cn(i-2),t(i),t(i-1),t(i-2),TP,TP1,TV,TV1,TSP,TSV,T,SIGN,PEAK,VALLEY);
	period(i) = T;
	
	[PBAH1,T0H1,NCH1] = pbaalg(t(i),t(i-1),T,T0H1,TP,TV,TMIN,TMAX,cn(i-1),NCH1,NPH1,SPH1,EP,PBAH1);
	pba_alarm(i) = PBAH1;
	[PBAH2,T0H2,NCH2] = pbaalg(t(i),t(i-1),T,T0H2,TP,TV,TMIN,TMAX,cn(i-1),NCH2,NPH2,SPH2,EP,PBAH2);
	pba_pretrip(i) = PBAH2;
	[PBAH3,T0H3,NCH3] = pbaalg(t(i),t(i-1),T,T0H3,TP,TV,TMIN,TMAX,cn(i-1),NCH3,NPH3,SPH3,EP,PBAH3);
	pba_trip(i) = PBAH3;
	
	confcount(i) = NCH1;
	period0(i) = T0H1;
	
	
	[ABAH1,S1CONDAH1,S2CONDAH1] = abaalg(t(i),t(i-1),TP,TV,cn(i-1),TMAX,TMIN,SMAXH1,S1,S2,S1CONDAH1,S2CONDAH1,ABAH1);
	aba_alarm(i) = ABAH1;
	[ABAH2,S1CONDAH2,S2CONDAH2] = abaalg(t(i),t(i-1),TP,TV,cn(i-1),TMAX,TMIN,SMAXH2,S1,S2,S1CONDAH2,S2CONDAH2,ABAH2);
	aba_pretrip(i) = ABAH2;
	[ABAH3,S1CONDAH3,S2CONDAH3] = abaalg(t(i),t(i-1),TP,TV,cn(i-1),TMAX,TMIN,SMAXH3,S1,S2,S1CONDAH3,S2CONDAH3,ABAH3);
	aba_trip(i) = ABAH3;
	
	
	[GRBAH1,S1CONDH1,S2CONDH1,S3H1] = grbaalg(t(i),t(i-1),TP,TV,cn(i-1),TMAX,TMIN,S1,S2,S3H1,DR3H1,S1CONDH1,S2CONDH1,GRBAH1);
	grba_alarm(i) = GRBAH1;
	[GRBAH2,S1CONDH2,S2CONDH2,S3H2] = grbaalg(t(i),t(i-1),TP,TV,cn(i-1),TMAX,TMIN,S1,S2,S3H2,DR3H2,S1CONDH2,S2CONDH2,GRBAH2);
	grba_pretrip(i) = GRBAH2;
	[GRBAH3,S1CONDH3,S2CONDH3,S3H3] = grbaalg(t(i),t(i-1),TP,TV,cn(i-1),TMAX,TMIN,S1,S2,S3H3,DR3H3,S1CONDH3,S2CONDH3,GRBAH3);
	grba_trip(i) = GRBAH3;
	
end


% Construct output structure
output.time = t;
output.peak = cn;
output.period = period;
output.period0 = period0;

output.pba_alarm = pba_alarm;
output.pba_pretrip = pba_pretrip;
output.pba_trip = pba_trip;

output.aba_alarm = aba_alarm;
output.aba_pretrip = aba_pretrip;
output.aba_trip = aba_trip;

output.grba_alarm = grba_alarm;
output.grba_pretrip = grba_pretrip;
output.grba_trip = grba_trip;

output.confcount = confcount;

