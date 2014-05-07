function java_calcbow(cn,channel_bow)

global cs;

cs.s(cn).calc_channel_bow(channel_bow);
cs.s(cn).fint  = squeeze(max(max(cs.s(cn).pow)));

end
