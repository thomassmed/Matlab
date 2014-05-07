function chnum = knumhalf_row(mminj, nrow)
ncore_2 = length(mminj) / 2;
if (nrow == 1) 
    istart = 0;
else
    istart = sum(ncore_2 + 1 - mminj(1 : nrow - 1));
end
chnum = (1 : ncore_2 + 1 - mminj(nrow)) + istart;