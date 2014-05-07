%@(#)   f2dd.m 1.7	 05/12/20     15:11:42
%
% handle=f2dd(col,del,oprm)
%
% Om argumentet col ges blir det en f�rgplot, annars bara linjer.
%
% Om argumentet del ges, ritas delsnabbstoppslinjen ut. Om ej f�rg �nskas, 
% anges col = 0
%
% Om oprm ges, ritas effektpendlingsskyddets aktiva omr�de ut.
%
% f2dd        ger bara linjer
% f2dd(1)     ger f�rgplot
% f2dd(0,1)   ger bara linjer, men med delSS
% f2dd(1,1)   ger f�rgplot, med delSS
% f2dd(1,0,1) ger f�rgplot, utan delSS, med OPRM
% f2dd(0,1,0) ger bara linjer, med delSS och OPRM
%
% [h, linj, tx] = f2dd
% returnerar handtag till figur, linjer respektive text.
% 
%
% 2006-03-07 bsc
% Driftomr�de f�r effekth�jd reaktor. Driftomr�de fr�n SES 05-252
%
% 2006-10-26 bsc
% Senaste driftomr�det efter m�te med driftledning, FTPS, FTB, och FTT.
% Inneh�ller ett s�rskilt omr�de som endast �r till�tet under 
% stabilitetsm�tningar. Se FT-2006-1279.
%
% 2008-09-01 bsc
% Nytt driftomr�de, se FT-2006-1279 rev 2

function varargout=f2dd_powup(InColorPlease, DelSSPlease, OPRMplease)


disp('Detta driftomr�de �r fortfarande inte spikat, utan fortfarande')
disp('under utveckling. Se FT-2006-1279.')

if nargin == 1
  col = true;
  del = false;
  oprm = false;
elseif nargin == 2
  col = logical(double(InColorPlease));
  del = true;
  oprm = false;
elseif nargin == 3
  col = logical(double(InColorPlease));
  del = logical(double(DelSSPlease));
  oprm = true;
else
  col = false;
  del = false;
  oprm = false;
end
  
h=gcf;
clf
col1=[0 1 0]; % f�rg till�tet driftomr�de
col2=[1 1 0.3]; % f�rg rekommenderat driftomr�de
col3=[0.1 0.3 1]; % f�rg n�san
% Till�tet driftomr�de
%     HC-fl�de, APRM
till = [2500  ,   0;
        3100  ,  30;
        6850  ,  99;
        10000 , 120;
        12000 , 120;
        12600 ,  65;
        12000 ,  55;
        12000 ,  20;
        8000  ,  20;
        8000  ,   0];

% Rekommenderat driftomr�de
%     HC-fl�de, APRM
% rek  = [2700   ,   0;
%         3200   ,  25;
%         3900   ,  38;
%         4000   ,  63;
%         9500   , 108;
%         11500  , 108;
%         12100  , 100;
%         5400   ,  60;
%         5100   ,   0];

% Till�tet omr�de under stabilitetsm�tning
rek = [3100,   30;
       3460,   48;
       5900,   93;
       6850,   99;
       3100,   30;];

effpend = [   0,  30;
           3525,  30;
          11000, 160;
          14000, 160;];



% % "N�san"
% %      HC-fl�de, APRM
% nasan =[12000  , 108; 
%         12600  ,  55;
%         12000  ,  55];
nasan = [0 0];;
% Nedstyrning p� filtrerad signal
%      HC-fl�de, APRM
e3   = [   0,   72;
        1900,   72;
       10000,  126;
       20000 , 126];

% SS p� filtrerad signal
%      HC-fl�de, APRM
ss9  = [    0,  76;
         1900,  76;
        10000, 130;
        20000, 130];


% Nedstyrning p� ofiltrerad signal
%      HC-fl�de, APRM
e4   = [    0,  81;
         1900,  81;
        10000, 135;
        20000, 135];

% SS p� ofiltrerad signal
%      HC-fl�de, APRM
ss10 = [    0,  86;
          1900, 86;
        10000, 140;
        20000, 140];

% Delsnabbstoppslinje
delss = [   0,  30;
         2800,  30;
         9900, 160;
        20000, 160];

if col
  linje = fill(till(:,1),till(:,2),col1,rek(:,1),rek(:,2),col2,...
               nasan(:,1),nasan(:,2),col3);
else
  linje = plot(till(:,1),till(:,2),'k',rek(:,1),rek(:,2),'k',...
               nasan(:,1),nasan(:,2),'k');
end

hold on;
linje(end+1:end+4) = plot(e3(:,1),e3(:,2),'-.',...
                          ss9(:,1),ss9(:,2),'--',...
                          e4(:,1),e4(:,2),'-.',...
                          ss10(:,1),ss10(:,2),'--');
if del
  linje(end+1) = plot(delss(:,1),delss(:,2),'r -.','LineWidth',1);
end
if oprm
  linje(end+1) = plot(effpend(:,1),effpend(:,2),'b -.','LineWidth',1);
end

set(linje(1),'LineWidth',2);

% Om ej f�rgs�tta, m�la bara svarta linjer
if ~col
  for ind = 1:length(linje)
    if strcmp(get(linje(ind),'type'),'line')
      set(linje(ind),'Color','k');
    end
  end
end

xmin = 2000;
xmax = 12700;
ymin = 0;
if del || oprm
  ymax = 164;
else
  ymax = 145;
end


xtl = ['2000 ';'     ';
       '3000 ';'     ';
       '4000 ';'     ';
       '5000 ';'     ';
       '6000 ';'     ';
       '7000 ';'     ';
       '8000 ';'     ';
       '9000 ';'     ';
       '10000';'     ';
       '11000';'     ';
       '12000';'     ';
       '13000';'     ';
       '14000';'     ';
       '15000';'     '];


set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax],'Box','on',...
        'XTick',(2000:500:15000),'YTick',(0:10:200),'XTickLabel',xtl,...
        'xgrid','on','ygrid','on','layer','top',...
        'XMinorTick','on','YMinorTick','on');

tx(1) = text(xmax + 50, max(till(:,2)), ...
                             sprintf('%3.0d%%', max(till(:,2))));
tx(2) = text(xmax + 50, e3(end,2),   sprintf('%3.0d%%',  e3(end,2)));
tx(3) = text(xmax + 50, ss9(end,2),  sprintf('%3.0d%%', ss9(end,2)));
tx(4) = text(xmax + 50, e4(end,2),   sprintf('%3.0d%%',  e4(end,2)));
tx(5) = text(xmax + 50, ss10(end,2), sprintf('%3.0d%%',ss10(end,2)));
tx(6) = text(xmax - 100, e3(end,2), 'E3');
tx(7) = text(xmax - 100, ss9(end,2),'SS9');
tx(8) = text(xmax - 100, e4(end,2), 'E4');
tx(9) = text(xmax - 100, ss10(end,2),'SS10');

set(tx(6:9),'HorizontalAlignment','Right')

if del
  tx(end+1) = text(delss(2,1),delss(1,2),'Del-SS',...
                   'VerticalAlignment','bottom',...
                   'HorizontalAlignment','right');
end
if oprm
    tx(end+1) = text(effpend(2,1)+100,effpend(1,2),'OPRM',...
                   'VerticalAlignment','top',...
                   'HorizontalAlignment','left');
end


xlabel('HC-fl�de [kg/s]')
ylabel('Termisk effekt [%]')
title('Forsmark 2, effekth�jd')
set(gca,'layer','top')

if nargout>0, varargout{1} = h;    end
if nargout>1, varargout{2} = linje;end
if nargout>2, varargout{3} = tx;   end
