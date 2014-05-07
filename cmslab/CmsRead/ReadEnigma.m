function [Data,RawData]=ReadEnigma(filename)
% ReadEnigma Read from Enigma output file
%
% [Data,RawData]=ReadEnigma(filename)
%
% Input 
%    filename - Enigma output file name
%
% Output
%    Data    - Struct with fields TfAve, TfSurf, TfCent, TrSurf, Stress, xpo,
%              StepStr, StepNum, SubStepStr, SubStepNum
%    RawData - Contains all the data in channel 7
%
%
%  Example:
%  [data,rawdata]=ReadEnigma('oa1_1_ramp.out0');plot(data.xpo,data.TfAve)
%
% See also ReadEnigmacsv


%%
txt=ReadAscii(filename);
%% find the starting rows for each time step
ich7=findrow(txt,'\*\*\*\* Channel 7: Summary printout \*\*\*\*\*');
ich=findrow(txt,'\*\*\*\* Channel');
ichnext=ich(find(ich>ich7,1,'first'));
irad=findrow(txt,'[0-9][0-9][0-9][0-9]/[0-9][0-9][0-9][0-9]');
irad=irad(irad>ich7&irad<ichnext); % Get rid of other channels that happen to have the same pattern
%% Now read the data
kmax=irad(2)-irad(1)-2;
Nstep=length(irad);
RawData=cell(1,Nstep);
%Preallocate
Step=cell(Nstep,1);SubStep=Step;
time=nan(Nstep,1);
xpo =nan(Nstep,1);
%%
for i=1:length(irad),
    % First make a test for the first row to get info (that is unsensitive to changes in ENIGMA edits) for allocation
    row=txt{irad(i)};
    if i==1,
        testvec=sscanf(row(15:end),'%g'); % was 10
        Ndata=length(testvec)-1;
    end
    RawData{i}=nan(kmax,Ndata);
%Preallocate;
    for j=1:kmax,
        if j==1,
            Step{i}=row(1:4);
            SubStep{i}=row(6:9);
            row(1:15)=[];
        elseif j==2,
            row=txt{irad(i)+j-1};
            xxx=sscanf(row,'%g%');
            time(i)=xxx;%sscanf(row,'%g');
            row(1:15)=[];
        else
            row=txt{irad(i)+j-1};
            row(1:2)=[];
        end
        temp=sscanf(row,'%g');
        RawData{i}(j,:)=temp';
    end    
    if kmax == 1;
       row=txt{irad(i)++1};
       time(i)=sscanf(row(1:11),'%g');
    end
    if kmax > 1;
        row=txt{irad(i)+kmax};
        xpo(i)=sscanf(row(16:22),'%g');
    else
        xpo(i)= RawData{i}(1,1);
    end
end
%% Now pull out what you need (Add more as you see fit)
%                 1     2      3      4      5    6    7    8    9   10    11    12     13     14     15      16     17      18      19      20     21     22     23
%STEP,                 MASS  LINEAR <--- TEMPS (C) --->  GAS RAD CRACK   FUEL  ROD PIE  CLAD  CLAD  <-CLAD HOOP->  CLAD H STRN /E4    SCC <-TOTAL LEN-> AV FUEL  HELIUM
%TIME    AXIAL BURNUP RATING RATING  ROD FUEL FUEL FUEL  REL GAP  STRN  RADIUS  RADIUS RIDGE OXIDE   STRESS (MPa)    CUMVE    CONC  CRACK <-CHANGE mm-> DENSITY RELEASE
%hrs      ZONE MWd/tU  W/gU   kW/m  SURF SURF MEAN CENT   %  mic   /E4    mm      mm   - microns -    MEAN   CONC    TOTAL   CREEP     %    FUEL   CLAD  kg/m3     %
for i=1:length(RawData),
    Data.Burnup    (:,i)=RawData{i}(:, 1)/1000;  % Convert to MWd/kgHM
    Data.Mrat      (:,i)=RawData{i}(:, 2);
    Data.Lhgr      (:,i)=RawData{i}(:, 3);
    Data.TrSurf    (:,i)=RawData{i}(:, 4)+273.2; % Convert degC to K
    Data.TfSurf    (:,i)=RawData{i}(:, 5)+273.2; % Convert degC to K    
    Data.TfAve     (:,i)=RawData{i}(:, 6)+273.2; % Convert degC to K
    Data.TfCent    (:,i)=RawData{i}(:, 7)+273.2; % Convert degC to K
    Data.GasRel    (:,i)=RawData{i}(:, 8);
    Data.RadialGap (:,i)=RawData{i}(:, 9);
    Data.StrnCrack (:,i)=RawData{i}(:,10)/100.;  % Convert to %
    Data.FuelRad   (:,i)=RawData{i}(:,11);
    Data.RodPieRad (:,i)=RawData{i}(:,12);
    Data.CladRidge (:,i)=RawData{i}(:,13);
    Data.CladOxide (:,i)=RawData{i}(:,14);
    Data.StressMean(:,i)=RawData{i}(:,15);
    Data.StressConc(:,i)=RawData{i}(:,16);
    Data.StrnCumve (:,i)=RawData{i}(:,17)/100.;  % Convert to %
    Data.StrnCreep (:,i)=RawData{i}(:,18)/100.;  % Convert to %
    Data.SccCrack  (:,i)=RawData{i}(:,19);
    Data.FuelLen   (:,i)=RawData{i}(:,20)*1000.; % Convert mm to microns
    Data.CladLen   (:,i)=RawData{i}(:,21)*1000.; % Convert mm to microns
    Data.FuelDens  (:,i)=RawData{i}(:,22);
    Data.HeRel     (:,i)=RawData{i}(:,23);
end
Data.Time=time;
Data.Xpo = xpo/1000.;
Data.StepStr=Step;
Data.StepNum=cellfun(@str2num,Step);
Data.SubStepStr=SubStep;
Data.SubStepNum=cellfun(@str2num,SubStep);
%% Read Channel 9
ich9=findrow(txt,'\*\*\*\* Channel 9: Specialised printout \*\*\*\*\*');
ich=findrow(txt,'\*\*\*\* Channel');
ichnext=ich(find(ich>ich9,1,'first'));
irad=findrow(txt,'[0-9][0-9][0-9][0-9]/[0-9][0-9][0-9][0-9]');
irad=irad(irad>ich9&irad<ichnext); % Get rid of other channels that happen to have the same pattern
%% Now read the data
kmax=irad(2)-irad(1)-1;
Nstep=length(irad);
clear RawData
RawData=cell(1,Nstep);
%%
for i=1:length(irad),
    % First make a test for the first row to get info (that is unsensitive to changes in ENIGMA edits) for allocation
    row=txt{irad(i)};
    if i==1,
        testvec=sscanf(row(19:end),'%g');
        Ndata=length(testvec);
    end
    RawData{i}=nan(kmax,Ndata);
%
    for j=1:kmax,
        row=txt{irad(i)+j-1};
        if j==1,
            row(1:18)=[];
        end
        temp=sscanf(row,'%g');
        RawData{i}(j,:)=temp';
    end    
end
%
%                 1       2      3      4       5        6       7       8        9
%
% STEP   TIME   AXIAL  <- CONCENTRATED STRESS, MPa ->  CLAD    YIELD   MARGIN   EPLE(Z)
%        hours  ZONE    HOOP   AXIAL  RADIAL   GEN.    TEMP,C   MPa     MPa       /E4  
%     
for i=1:length(RawData),
    Data.StressConcHop(:,i)=RawData{i}(:, 2);
    Data.StressConcAxl(:,i)=RawData{i}(:, 3);
    Data.StressConcRad(:,i)=RawData{i}(:, 4);
    Data.StressConcGen(:,i)=RawData{i}(:, 5); 
    Data.TcladAve     (:,i)=RawData{i}(:, 6)+273.2; % Convert degC to K
    Data.StressClYld  (:,i)=RawData{i}(:, 7);
    Data.MarginYld    (:,i)=RawData{i}(:, 8);
    Data.PermHoopStrn (:,i)=RawData{i}(:, 9)/100.;
end
