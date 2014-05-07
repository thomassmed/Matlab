function npclinje(x,y,arg,ampl)
% npclinje(x,y,arg,ampl)
% Funktionen npclinje ritar ut linjen fr�n punkten (x,y) i en distplot.        
% Argumentet ARG ges i radianer. AMPL �r linjens l�ngd.
% Funktionen �r en hj�lpfunktion till funktionen visar_plot();

arg=-arg;
     
x1=[x (x+3*ampl*cos(arg))];
y1=[y (y+3*ampl*sin(arg))];

h1=line(x1,y1);
set(h1,'color','k');
set(h1,'LineWidth',2.5);
               
                        
                    


         
              
               
                        
                    