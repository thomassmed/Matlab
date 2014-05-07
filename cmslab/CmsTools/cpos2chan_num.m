function chan_num = cpos2chan_num(cpos, min_j)

x = cpos(:, 2);
y = cpos(:, 1);

lx = min(length(x), length(y));
ll = length(min_j) + 2;

chan_num = zeros(lx, 1);
for k = 1 : lx
  chan_num(k)=0;
  if (min(x(k), y(k)) > 0) && max(x(k),y(k))<length(min_j)
    if ~(x(k) < min_j(y(k)) || x(k) > (ll - 1 - min_j(y(k))))
        chan_num(k) = sum(ll - 2 * min_j(1 : y(k) - 1)) + x(k) - min_j(y(k)) + 1;
    end
  end
end