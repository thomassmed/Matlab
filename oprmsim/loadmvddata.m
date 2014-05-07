%
% Laddar .csv-filer från MVD:en till matris i matlab
%
% Input:
%	filelist	Sökväg till fil innehåller lista med signaler som ska läsas
%
% Ouput:
%	data		Matris med data från csv-filer (1:a kolumnen är tidsvektorn)
%	besk		Vektor med signalnamn, i samma ordning som datamatrisen.
%
function [data,besk]=loadmvddata(filelist)


labels = textread(filelist,'%s');

filename1 = ['pid_' strtrim(char(labels{1})) '.csv'];
%-----------------------------------------------------------------
% Har korrigerat formatet för inläsning av "mätpunktsdata" i c6
% från integer (%d) till float (%f) (NEDAN)
% 061219, EML
%-----------------------------------------------------------------
[c1,c2,c3,c4,c5,c6] = textread(filename1,'%s%d%s%d%d%f','delimiter',',','headerlines',1);
c3 = char(c3);
clk = c3(:,find(isspace(c3(1,:)) == 1)+1:end);
for n=1:size(clk,1)
	[h(n,1),m(n,1),s(n,1)] = strread(clk(n,:),'%n%n%f','delimiter',':');
end
t0s = s(1,1);
t0m = m(1,1);
t0h = h(1,1);
time = (h(:,1)-t0h)*60*60 + (m(:,1)-t0m)*60 + s(:,1)-t0s;
data(:,1) = time;

for i=1:size(labels,1)
	filename = ['PID_' strtrim(char(labels{i})) '.csv'];

	data(:,i+1) = csvread(filename,1,5);
end

besk = [{'Time'};labels];
besk = besk';
