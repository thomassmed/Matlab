function [lfu] = java_decrease_enr(cn,x,y)

global cs;

cs.s(cn).decrease_enr(x,y);
lfu=cs.s(cn).lfu;
end
