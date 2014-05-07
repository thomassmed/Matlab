function h = findplot(h,key,value)


hdls = findall(h,key,value);
if(length(hdls) < 1)
    h = figure();
    set(h,key,value);
    return
end

if(length(hdls) > 1)
    for i = 1:(length(hdls)-1)
        delete(hdls(i));
    end
end

h = hdls(1);
hold off

end