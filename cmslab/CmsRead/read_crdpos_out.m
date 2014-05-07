function konrod=read_crdpos_out(blob,crmax)

if isempty(find(blob==10,1,'first')),
    blob=reads3_file(blob);
end
%%
cr=find(blob==10);
if nargin<2,
    crmax=get_num_card(blob,'CRD.DAT');
    if isempty(crmax),
        crmax=100;
    else
        crmax=crmax(1);
    end
end

crp=strfind(blob,'CONTROL ROD PATTERN    ');
konrod=cell(1,length(crp));
for j=1:length(crp),
    icrp=find(cr>crp(j),1,'first');
    krod=[];
    for i=1:30,
        line=blob(cr(icrp+1+i)+1:cr(icrp+2+i)-1);
        if length(line)<70, break;end
        line=line(58:end);
        line=strrep(line,'---',num2str(crmax));
        krod=[krod;sscanf(line,'%g')];
    end
    konrod{j}=krod';
end

if length(konrod)==1,konrod=konrod{1};end