function dis=read_pp2man(filename,disname,kmax,nsond)

%%

fid=fopen(filename,'r');
file=fread(fid);
fclose(fid);
file(file==13)=[];
file=char(file');
%%
iE=strfind(file,[10,disname]);
cr=find(file==10);
icr=find(cr>iE(1),1);
icc=icr-1;
dis=nan(kmax,nsond);
sond_name=cell(1,nsond);
for i=1:nsond,
    icc=icc+1;
    rad=file(cr(icc)+1:cr(icc+1)-1);
    if strcmp(rad(1),'!'), break;end
    temp=sscanf(rad,'%i%s');
    nlp=temp(1);temp(1)=[];
    sond_name{i}=char(temp');
    temp=[];
    for i1=1:ceil(kmax/5),
        icc=icc+1;
        rad=file(cr(icc)+1:cr(icc+1)-1);
        temp=[temp;sscanf(rad,'%g')];
    end
    dis(:,i)=temp;
end
    
