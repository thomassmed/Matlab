function [plotmaxfint,plotmaxbtf,plotminbtf,plotmaxkinf,plotminkinf,plotoldmaxfint,plotoldmaxbtf,plotoldminbtf] = java_get_plotdata()

global cs;

cs.maxmin_values();

plotmaxfint= cs.plotmaxfint;
plotoldmaxfint= cs.plotoldmaxfint;
plotmaxbtf = cs.plotmaxbtf;
plotminbtf = cs.plotminbtf;
plotoldmaxbtf = cs.plotmaxbtf;
plotoldminbtf = cs.plotminbtf;
plotmaxkinf = cs.plotmaxkinf;
plotminkinf = cs.plotminkinf;

end





