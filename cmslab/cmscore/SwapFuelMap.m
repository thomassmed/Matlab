function SwapFuelMap(fue_new,ch,mapfil)

if ~isstruct(fue_new),
    resfil=fue_new;
    fue_new=read_restart_bin(resfil);
end

fid=fopen(mapfil,'w');
mminj=fue_new.mminj;

% Swap the fuel
fue_new.ser(ch(2:-1:1),:)=fue_new.ser(ch,:);



fprintf(fid,'''FUE.SER'', 6 /\r\n');

blank='      ';
% Left Core Half 
ikan=0;
[right,left]=knumhalf(mminj);
left=sort(left);
iahalf=length(mminj)/2;
for i=1:length(mminj),
    fprintf(fid,'%2i %2i',i,1);
    for j=1:mminj(i)-1, fprintf(fid,' %6s',blank);end
    for j=mminj(i):iahalf,
        ikan=ikan+1;
        fprintf(fid,' %6s',fue_new.ser(left(ikan),:));
    end
    fprintf(fid,'\r\n');
end

% Right Core Half 
ikan=0;
for i=1:length(mminj),
    fprintf(fid,'%2i %2i',i,iahalf+1);
    for j=mminj(i):iahalf,
        ikan=ikan+1;
        fprintf(fid,' %6s',fue_new.ser(right(ikan),:));
    end
    for j=1:mminj(i)-1, fprintf(fid,' %6s',blank);end
    fprintf(fid,'\r\n');    
end
fprintf(fid,'\r\n');
fclose(fid);
