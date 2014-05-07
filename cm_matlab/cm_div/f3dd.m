%function varargout=f3dd(InColorPlease, DelSSPlease, OPRMplease)
%
% Om argumentet col ges blir det en färgplot, annars bara linjer.
%
% Om argumentet del ges, ritas delsnabbstoppslinjen ut. Om ej färg önskas, 
% anges col = 0
%
% Om oprm ges, ritas effektpendlingsskyddets aktiva område ut.
%
% f3dd        ger bara linjer
% f3dd(1)     ger färgplot
% f3dd(0,1)   ger bara linjer, men med delSS
% f3dd(1,1)   ger färgplot, med delSS
% f3dd(1,0,1) ger färgplot, utan delSS, med OPRM
% f3dd(0,1,0) ger bara linjer, med delSS och OPRM

% [h, linj, tx] = f2dd
% returnerar handtag till figur, linjer respektive text.
%
function varargout=f3dd(InColorPlease, DelSSPlease, OPRMplease)
%
% Rev. historik
% --------------------------------------------------------------------------------
%
% 2011-08-11, rdj
% Ritad enligt underlag från:
% G:\Org\Ft\Ftb\Kontoret\Ftb\f3\Driftområde\Driftområdes diagram
%

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
  oprm = logical(double(OPRMplease));
else
  col = false;
  del = false;
  oprm = false;
end


h=gcf;
%clf
col1=[1 1 0.3]; % färg tillåtet driftområde
col2=[0 1 0]; % färg rekommenderat driftområde

% Tillåtet driftområde
%     HC-flöde, APRM
till = [2500  ,   0.0;
        3700  ,  30.0;
        3900  ,  68.0;
       12100  , 109.3;
       13100  , 109.3;
       13800  ,  65.0;
       13100  ,  63.0;
       13100  ,  22.0;
        6600  ,  22.0;
        6600  ,   0.0];

% Rekommenderat driftområde
%     HC-flöde, APRM
rek  = [2500  ,   0.0;
        3700  ,  30.0;
        3900  ,  68.0;
       12100  , 109.3;
       13100  , 109.3;
       13100  , 104.0;
       11500  ,  94.0;
       13100  ,  94.0;
        7500  ,  65.0;
       10100  ,  65.0;
        5550  ,  45.0;
        5500  ,   0.0];

% Nedstyrning på filtrerad signal F6
%      HC-flöde, APRM
f6 = [    0  ,  55;
      12260  , 116;
      13800  , 116];

% SS på filtrerad signal SS13
%      HC-flöde, APRM
ss13 = [    0  ,  58;
        12240  , 119;
        13800  , 119];

% Nedstyrning på ofiltrerad signal F7
%      HC-flöde, APRM
f7 = [    0  ,  64;
      12260  , 125;
      13800  , 125];

% SS på ofiltrerad signal SS14
%      HC-flöde, APRM
ss14 = [    0  ,  74;
            12420  , 136;
            13800  , 136];
        
% Delsnabbstoppslinje
delss = [    0 ,  60.0;
          4000 ,  60.0;
          6810 , 109.3];

% Effektpendlingsskyddets aktiva område
effpend = [   0,  30;
           6000,  30;
           6000, 160];

if col
linje = fill(till(:,1),till(:,2),col1,rek(:,1),rek(:,2),col2);
else
  linje = plot(till(:,1),till(:,2),'k',rek(:,1),rek(:,2),'k');
end

hold on;
linje(end+1:end+4) = plot(f6(:,1),f6(:,2),'-.',...
                          ss13(:,1),ss13(:,2),'--',...
                          f7(:,1),f7(:,2),'-.',...
                          ss14(:,1),ss14(:,2),'--');
if del
  linje(end+1) = plot(delss(:,1),delss(:,2),'r -.','LineWidth',2);
end
if oprm
  linje(end+1) = plot(effpend(:,1),effpend(:,2),'b -.','LineWidth',2);
end

set(linje(1),'LineWidth',2);

% Om ej färgsätta, måla bara svarta linjer
if ~col
  for ind = 1:length(linje)
    if strcmp(get(linje(ind),'type'),'line')
      set(linje(ind),'Color','k');
    end
  end
end

xmin = 2000;
xmax = 14000;
ymin = 0;
ymax = 145;

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
       '14000';'     '];


set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax],'Box','on',...
        'XTick',(2000:500:15000),'YTick',(0:10:150),'XTickLabel',xtl,...
        'xgrid','on','ygrid','on','layer','top');

tx(1) = text(xmax + 50, max(rek(:,2)), ...
                             sprintf('%3.1f%%', max(rek(:,2))));
tx(2) = text(xmax + 50, f6(end,2),   sprintf('%3.0d%%',  f6(end,2)));
tx(3) = text(xmax + 50, ss13(end,2),  sprintf('%3.0d%%', ss13(end,2)));
tx(4) = text(xmax + 50, f7(end,2),   sprintf('%3.0d%%',  f7(end,2)));
tx(5) = text(xmax + 50, ss14(end,2), sprintf('%3.0d%%',ss14(end,2)));
tx(6) = text(13000, f6(end,2), 'F6');
tx(7) = text(13000, ss13(end,2),'SS13');
tx(8) = text(13000, f7(end,2), 'F7');
tx(9) = text(13000, ss14(end,2),'SS14');

set(tx(6:9),'HorizontalAlignment','Right','VerticalAlignment','top')

if del
  tx(end+1) = text(delss(1,1)+2000,delss(1,2),'Del-SS',...
                   'VerticalAlignment','bottom');
end
if oprm
    tx(end+1) = text(effpend(2,1)+100,effpend(1,2),'OPRM',...
                   'VerticalAlignment','top',...
                   'HorizontalAlignment','left');
end


xlabel('HC-flöde [kg/s]')
ylabel('Termisk effekt [%]')
title('Forsmark 3 - Driftområde 3300 MWth')
set(gca,'layer','top')

if nargout>0, varargout{1} = h;    end
if nargout>1, varargout{2} = linje;end
if nargout>2, varargout{3} = tx;   end















