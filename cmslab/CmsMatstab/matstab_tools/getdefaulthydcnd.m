function hydcnd=getdefaulthydcnd(nrods,nhyd)
nhyds=unique(nhyd);
for i=1:length(nhyds),
    index=find(nhyd==nhyds(i),1,'first');
    npin=round(nrods(2,index));
    switch npin
        case {60,61,62,63,64}
            hydcnd{i}=[nhyds(i) 0.5220 0.5325 0.6125]; % 8x8-1
        case {72,74,75,76,77,78,79,80,81}
            hydcnd{i}=[nhyds(i) 0.4640 0.473  0.5375]; % 9x9-1
        case {88,89,90,91,92,93,94,95}
            hydcnd{i}=[nhyds(i) .4380 .447 .531]; % GE12/GE14
        case {96,97,98,99,100}
            hydcnd{i}=[nhyds(i) 0.4095,0.418,0.481]; %SVEA 96
    end
end