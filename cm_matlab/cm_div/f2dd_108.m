%@(#)   f2dd.m 1.8	 08/09/01     08:49:23
%
%function varargout=f2dd(InColorPlease, DelSSPlease)
function varargout=f2dd_108(InColorPlease, DelSSPlease)
% handle=f2dd(col,del)
%
% Om argumentet col ges blir det en färgplot, annars bara linjer.
%
% Om argumentet del ges, ritas delsnabbstoppslinjen ut. Om ej färg önskas, 
% anges col = 0
%
% f2dd        ger bara linjer
% f2dd(1)     ger färgplot
% f2dd(0,1)   ger bara linjer, men med delSS
% f2dd(1,1)   ger färgplot, med delSS
%
% [h, linj, tx] = f2dd
% returnerar handtag till figur, linjer respektive text.
% 
%
% 2005-12-20, bsc
% Uppdaterad och uppfräschad. Underlag hämtat från utskrivet driftområde, 
% undertecknat av Kenneth Johansson, 2005-05-11.
%
% VDB: Uppdaterad 2004-10-08 enl underlag från UBM för nyritning av driftområdet

if nargin == 1
  col = true;
  del = false;
elseif nargin == 2
  col = logical(double(InColorPlease));
  del = true;
else
  col = false;
  del = false;
end
  
h=gcf;
%clf
col1=[1 1 0.3]; % färg tillåtet driftområde
col2=[0 1 0]; % färg rekommenderat driftområde
col3=[0.1 0.3 1]; % färg näsan
% Tillåtet driftområde
%     HC-flöde, APRM
till = [2500  ,   0;
        3000  ,  25;
        3700  ,  38;
        3900  ,  74;
        9500  , 108;
        12000 , 108;
        12000 ,  20;
         8000 ,  20;
         8000 ,   0];

% Rekommenderat driftområde
%     HC-flöde, APRM
rek  = [2700   ,   0;
        3200   ,  25;
        3900   ,  38;
        4000   ,  63;
        9500   , 108;
        11500  , 108;
        12100  , 100;
        5400   ,  60;
        5100   ,   0];

% "Näsan"
%      HC-flöde, APRM
nasan =[12000  , 108; 
        12600  ,  55;
        12000  ,  55];

% Nedstyrning på filtrerad signal
%      HC-flöde, APRM
e3   = [ 2000  ,  66;
         9500  , 114;
        13000  , 114];

% SS på filtrerad signal
%      HC-flöde, APRM
ss9  = [ 2000  ,  69;
         9500  , 117;
        13000  , 117];

% Nedstyrning på ofiltrerad signal
%      HC-flöde, APRM
e4   = [ 2000  ,  80.5;
         9500  , 126;
        13000  , 126];

% SS på ofiltrerad signal
%      HC-flöde, APRM
ss10 = [ 2000  ,  87.5;
         9500  , 133;
        13000  , 133];
% Delsnabbstoppslinje
delss = [ 2000 ,  60;
          4000 ,  60;
          9750 , 160;
         13000 , 160];

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
  linje(end+1) = plot(delss(:,1),delss(:,2),'r -.','LineWidth',3);
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
xmax = 12700;
ymin = 0;
ymax = 135;

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
       '12000';'     '];


set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax],'Box','on',...
        'XTick',(2000:500:15000),'YTick',(0:10:150),'XTickLabel',xtl,...
        'xgrid','on','ygrid','on','layer','top');

tx(1) = text(xmax + 50, max(rek(:,2)), ...
                             sprintf('%3.0d%%', max(rek(:,2))));
tx(2) = text(xmax + 50, e3(end,2),   sprintf('%3.0d%%',  e3(end,2)));
tx(3) = text(xmax + 50, ss9(end,2),  sprintf('%3.0d%%', ss9(end,2)));
tx(4) = text(xmax + 50, e4(end,2),   sprintf('%3.0d%%',  e4(end,2)));
tx(5) = text(xmax + 50, ss10(end,2), sprintf('%3.0d%%',ss10(end,2)));
tx(6) = text(9000, e3(end,2), 'E3');
tx(7) = text(9000, ss9(end,2),'SS9');
tx(8) = text(9000, e4(end,2), 'E4');
tx(9) = text(9000, ss10(end,2),'SS10');

set(tx(6:9),'HorizontalAlignment','Right','VerticalAlignment','top')

if del
  tx(end+1) = text(delss(1,1)+500,delss(1,2),'Del-SS',...
                   'VerticalAlignment','bottom');
end



xlabel('HC-flöde [kg/s]')
ylabel('Termisk effekt [%]')
title('Forsmark 2')
set(gca,'layer','top')

if nargout>0, varargout{1} = h;    end
if nargout>1, varargout{2} = linje;end
if nargout>2, varargout{3} = tx;   end















