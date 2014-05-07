function [maxburnup] = get_maxburnup(i)

global cs;
maxburnup = cs.s(i).max_burnup;

end