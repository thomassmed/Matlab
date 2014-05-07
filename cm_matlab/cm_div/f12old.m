%function varargout=f12old(InColorPlease, DelSSPlease, )
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

% [h, linj, tx] = f2dd
% returnerar handtag till figur, linjer respektive text.
%
function varargout=f12old(InColorPlease, DelSSPlease, OPRMplease)
%
% Rev. historik
% --------------------------------------------------------------------------------
%
% 2005-12-20, bsc
% Uppdaterad och uppfr�schad. Underlag h�mtat fr�n utskrivet driftomr�de, 
% undertecknat av Kenneth Johansson, 2005-05-11.
%
% VDB: Uppdaterad 2004-10-08 enl underlag fr�n UBM f�r nyritning av driftomr�det
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
%
% 2011-04-28 rdj
% Uppdatering av till�tet omr�de enligt FT-2006-1279 rev 6
% och rekomenderat omr�de enligt FT-2009-1696 rev 1
%
% 2012-10-30 rdj
% Justerat hj�lplinjer f�r effektuppg�ng och rekomenderat driftomr�de
% till att �verensst�mma med ritning 10008721 med underlag fr�n
% FT-2006-1653 rev 2
%
% 2014-04-09 Special f�r ursprungliga driftomr�det

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
%clf
col1=[1 1 0.3]; % f�rg till�tet driftomr�de
col2=[0 1 0]; % f�rg rekommenderat driftomr�de
col3=[0.1 0.3 1]; % f�rg n�san

% Till�tet driftomr�de
%     HC-fl�de, APRM
till = [3600  ,  20;
        4000  ,  74;
        8500  , 100;
       11000  , 100;
       11000  ,   0];

% Rekommenderat driftomr�de
%     HC-fl�de, APRM
rek  = [2925   ,   0;
        3525   ,  30;
        7492   ,  99;
       10200   , 120;
       12000   , 120;
       12169   , 104.47;
        6250   ,  65;
        5638   ,   0];

% "N�san"
%      HC-fl�de, APRM
%nasan =[12000  , 108; 
%        12600  ,  55;
%        12000  ,  55];

% Nedstyrning p� filtrerad signal
%      HC-fl�de, APRM
e3   = [    0  ,  72;
         1900  ,  72;
        10000  , 126;
        14000  , 126];

% SS p� filtrerad signal
%      HC-fl�de, APRM
ss9  = [    0  ,  76;
         1900  ,  76;
        10000  , 130;
        14000  , 130];

% Nedstyrning p� ofiltrerad signal
%      HC-fl�de, APRM
e4   = [    0  ,  81;
         1900  ,  81;
        10000  , 135;
        14000  , 135];

% SS p� ofiltrerad signal
%      HC-fl�de, APRM
ss10 = [    0  ,  86;
         1900  ,  86;
        10000  , 140;
        14000  , 140];
        
% Delsnabbstoppslinje
delss = [    0 ,  30;
          2800 ,  30;
          9900 , 160;
         14000 , 160];

% Effektpendlingsskyddets aktiva omr�de
effpend = [   0,  30;
           3525,  30;
          11000, 160;
          14000, 160];
          
% St�dlinjer f�r uppg�ng
uppgang = [ 6250,  65;
           11500, 100;
           10000, 100;
           11500, 110;
           10000, 110;
           11500, 120];

if col
linje = fill(till(:,1),till(:,2),col1,rek(:,1),rek(:,2),col2);
else
  linje = plot(till(:,1),till(:,2),'k','linewidth',2);
end

hold on;
% plot(uppgang(:,1),uppgang(:,2),'k');
% 
% hold on;
% linje(end+1:end+4) = plot(e3(:,1),e3(:,2),'-.',...
%                           ss9(:,1),ss9(:,2),'--',...
%                           e4(:,1),e4(:,2),'-.',...
%                           ss10(:,1),ss10(:,2),'--');
% if del
%   linje(end+1) = plot(delss(:,1),delss(:,2),'r -.','LineWidth',2);
% end
% if oprm
%   linje(end+1) = plot(effpend(:,1),effpend(:,2),'b -.','LineWidth',2);
% end
% 
% set(linje(1),'LineWidth',2);
% 
% % Om ej f�rgs�tta, m�la bara svarta linjer
% if ~col
%   for ind = 1:length(linje)
%     if strcmp(get(linje(ind),'type'),'line')
%       set(linje(ind),'Color','k');
%     end
%   end
% end

xmin = 2000;
xmax = 10400;
ymin = 0;
ymax = 110;

xtl = ['2000 ';'     ';
       '3000 ';'     ';
       '4000 ';'     ';
       '5000 ';'     ';
       '6000 ';'     ';
       '7000 ';'     ';
       '8000 ';'     ';
       '9000 ';'     ';
       '10000';'     ';
       '11000';'     ';];


set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax],'Box','on',...
        'XTick',(2000:500:15000),'YTick',(0:10:150),'XTickLabel',xtl,...
        'xgrid','on','ygrid','on','layer','top');

% tx(1) = text(xmax + 50, max(rek(:,2)), ...
%                              sprintf('%3.0d%%', max(rek(:,2))));
% tx(2) = text(xmax + 50, e3(end,2),   sprintf('%3.0d%%',  e3(end,2)));
% tx(3) = text(xmax + 50, ss9(end,2),  sprintf('%3.0d%%', ss9(end,2)));
% tx(4) = text(xmax + 50, e4(end,2),   sprintf('%3.0d%%',  e4(end,2)));
% tx(5) = text(xmax + 50, ss10(end,2), sprintf('%3.0d%%',ss10(end,2)));
% tx(6) = text(10800, e3(end,2), 'E3');
% tx(7) = text(10800, ss9(end,2),'SS9');
% tx(8) = text(10800, e4(end,2), 'E4');
% tx(9) = text(10800, ss10(end,2),'SS10');
% 
% set(tx(6:9),'HorizontalAlignment','Right','VerticalAlignment','top')
% 
% if del
%   tx(end+1) = text(delss(1,1)+2000,delss(1,2),'Del-SS',...
%                    'VerticalAlignment','bottom');
% end
% if oprm
%     tx(end+1) = text(effpend(2,1)+100,effpend(1,2),'OPRM',...
%                    'VerticalAlignment','top',...
%                    'HorizontalAlignment','left');
% end
% 

xlabel('HC-fl�de [kg/s]')
ylabel('Termisk effekt [%]')
title('Forsmark 2 - Ursprungligt Driftomr�de (2711 MWth)')
set(gca,'layer','top')

if nargout>0, varargout{1} = h;    end
if nargout>1, varargout{2} = linje;end
if nargout>2, varargout{3} = tx;   end















