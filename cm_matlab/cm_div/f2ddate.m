%@(#)   f2ddate.m 1.1	 05/12/08     13:20:13
%
function handle=f2dd(InColorPlease)
% handle=f2dd(col)
% om argument col ges blir det en färgplot, annars bara linjer.
h=gcf;
clf
col1=[1 1 0.3]; % färg tillåtet driftområde
col2=[0 1 0]; % färg rekommenderat driftområde
% Tillåtet driftområde
x=[2500      
3000
3600           
3900         
9500          
11000           
11000];
y=[0
25
38
74
108
108
0];   
if nargin>0
  fill(x,y,col1)
else
  plot(x,y,'gr')
end
hold
% rekommenderat driftområde
x=[2700
3200
3850
4000
9500
11000
10250           
10750
9150
10350
5400
5100];
y=[0
25
38
63
108
108
105
105
92
92
60
0];
if nargin>0
  fill(x,y,col2)
else
  plot(x,y,'gr')
end
% delsnabbstoppslinje
x=[2000
4000
6300];
y=[60
60
100];
line(x,y)
% slut delsnabbstoppslinje
x=[2000
9500
11000];
y=[66
114
114];
line(x,y)
y=[70
117
117];
line(x,y)
y=[78
126
126];
line(x,y)
y=[86
133
133];
line(x,y)
xtl=['2000 '
'     '
'3000 '
'     '
'4000 '
'     '
'5000 '   
'     '
'6000 '
'     '
'7000 '
'     '
'8000 '
'     '
'9000 '
'     '
'10000'
'     '
'11000'];
set(gca,'XLim',[2000 11000],'YLim',[0 133],'Box','on',...
'XTick',(2000:500:11000),'YTick',(0:10:130),'XTickLabel',xtl);
text(11100,108,'108%')
text(11100,114,'114%')
text(11100,117,'117%')
text(11100,126,'126%')
text(11100,133,'133%')
xlabel('HC-fl [kg/s]'),ylabel('Termisk effekt [%]'),title('Forsmark 2')
set(gca,'layer','top')
grid
if nargout>0, handle=h;end
















