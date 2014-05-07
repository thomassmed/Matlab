%function varargout=f12old(InColorPlease, DelSSPlease, )
%
% Om argumentet col ges blir det en färgplot, annars bara linjer.
%
% Om argumentet del ges, ritas delsnabbstoppslinjen ut. Om ej färg önskas, 
% anges col = 0
%
% Om oprm ges, ritas effektpendlingsskyddets aktiva område ut.
%
% f2dd        ger bara linjer
% f2dd(1)     ger färgplot
% f2dd(0,1)   ger bara linjer, men med delSS
% f2dd(1,1)   ger färgplot, med delSS
% f2dd(1,0,1) ger färgplot, utan delSS, med OPRM
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
% Uppdaterad och uppfräschad. Underlag hämtat från utskrivet driftområde, 
% undertecknat av Kenneth Johansson, 2005-05-11.
%
% VDB: Uppdaterad 2004-10-08 enl underlag från UBM för nyritning av driftområdet
%
% 2006-03-07 bsc
% Driftområde för effekthöjd reaktor. Driftområde från SES 05-252
%
% 2006-10-26 bsc
% Senaste driftområdet efter möte med driftledning, FTPS, FTB, och FTT.
% Innehåller ett särskilt område som endast är tillåtet under 
% stabilitetsmätningar. Se FT-2006-1279.
%
% 2008-09-01 bsc
% Nytt driftområde, se FT-2006-1279 rev 2
%
% 2011-04-28 rdj
% Uppdatering av tillåtet område enligt FT-2006-1279 rev 6
% och rekomenderat område enligt FT-2009-1696 rev 1
%
% 2012-10-30 rdj
% Justerat hjälplinjer för effektuppgång och rekomenderat driftområde
% till att överensstämma med ritning 10008721 med underlag från
% FT-2006-1653 rev 2
%
% 2014-04-09 Special för ursprungliga driftområdet

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
col1=[1 1 0.3]; % färg tillåtet driftområde
col2=[0 1 0]; % färg rekommenderat driftområde
col3=[0.1 0.3 1]; % färg näsan

% Tillåtet driftområde
%     HC-flöde, APRM
till = [3600  ,  20;
        4000  ,  74;
        8500  , 100;
       11000  , 100;
       11000  ,   0];

% Rekommenderat driftområde
%     HC-flöde, APRM
rek  = [2925   ,   0;
        3525   ,  30;
        7492   ,  99;
       10200   , 120;
       12000   , 120;
       12169   , 104.47;
        6250   ,  65;
        5638   ,   0];

% "Näsan"
%      HC-flöde, APRM
%nasan =[12000  , 108; 
%        12600  ,  55;
%        12000  ,  55];

% Nedstyrning på filtrerad signal
%      HC-flöde, APRM
e3   = [    0  ,  72;
         1900  ,  72;
        10000  , 126;
        14000  , 126];

% SS på filtrerad signal
%      HC-flöde, APRM
ss9  = [    0  ,  76;
         1900  ,  76;
        10000  , 130;
        14000  , 130];

% Nedstyrning på ofiltrerad signal
%      HC-flöde, APRM
e4   = [    0  ,  81;
         1900  ,  81;
        10000  , 135;
        14000  , 135];

% SS på ofiltrerad signal
%      HC-flöde, APRM
ss10 = [    0  ,  86;
         1900  ,  86;
        10000  , 140;
        14000  , 140];
        
% Delsnabbstoppslinje
delss = [    0 ,  30;
          2800 ,  30;
          9900 , 160;
         14000 , 160];

% Effektpendlingsskyddets aktiva område
effpend = [   0,  30;
           3525,  30;
          11000, 160;
          14000, 160];
          
% Stödlinjer för uppgång
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
% % Om ej färgsätta, måla bara svarta linjer
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

xlabel('HC-flöde [kg/s]')
ylabel('Termisk effekt [%]')
title('Forsmark 2 - Ursprungligt Driftområde (2711 MWth)')
set(gca,'layer','top')

if nargout>0, varargout{1} = h;    end
if nargout>1, varargout{2} = linje;end
if nargout>2, varargout{3} = tx;   end















