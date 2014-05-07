function [lfu] = java_increase_enr(cn,x,y)

global cs;

cs.s(cn).increase_enr(x,y);
lfu=cs.s(cn).lfu;
end