function value=set_defaults(value,def_value)
if length(value)==length(def_value), return;end

n=length(def_value);
for i=1:n,
    if length(value)<i, value(i)=def_value(i);end
end