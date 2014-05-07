function resize_list()
list = get(gcf,'Children');
sz = get(gcf,'Position');
set(list,'Position',[ 1 1 sz(3) sz(4) ]);
