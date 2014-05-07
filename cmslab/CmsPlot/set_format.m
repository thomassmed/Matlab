%% Set the format of the data in the data labels
function format = set_format(dis2d)
    mx = max(abs(dis2d));
    if (mx < 1),
        format='%7.4f';
    elseif (mx > 1 && mx < 10),
        format='%6.3f';
    elseif (mx > 10 && mx < 100),
        format='%5.2f';
    elseif (mx > 100 && mx < 1000),
        format='%5.1f';
    elseif (mx > 1000 && mx < 10000),
        format='%5.1f';
    elseif (mx > 10000 && mx < 100000),
        format='%5.0f';
    end
end