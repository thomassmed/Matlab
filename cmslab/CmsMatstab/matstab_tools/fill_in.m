function e_meas=fill_in(names,emeas)

%%
lfind=zeros(112,1);

for i=1:112,
    knum=800+i;
    str=['CH531K',sprintf('%3i',knum)];
    if strmatch(str,names,'exact'), lfind(i)=1;end
end

if nargin<2,
    e_meas=lfind;
else
    ict=0;
    e_meas=zeros(112,1);
    for i=1:length(lfind),
        if lfind(i),
            ict=ict+1;
            e_meas(i)=emeas(ict);
        end
    end
end