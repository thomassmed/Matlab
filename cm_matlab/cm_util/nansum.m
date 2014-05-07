function s=nansum(a)

s=sum(a(~isnan(a)));
