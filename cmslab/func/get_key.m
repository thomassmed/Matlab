function [Key,Pid,point_description,cconst1,cconst2]=get_key(filename)
TXT=ReadAscii(filename);
i531=findrow(TXT,'^point_id 531K');
il=cellfun(@length,TXT(i531));
i531=i531(il==16);
%%
iIP=findrow(TXT,'^MVDIP ');
iPort=findrow(TXT,'^MVDIP_PORT ');
imessage=findrow(TXT,'^message_slot ');
%%
IP=zeros(length(iIP),1);
for i=1:length(iIP),
    iblank=strfind(TXT{iIP(i)},' ');
    IP(i)=sscanf(TXT{iIP(i)}(iblank+1:end),'%i');
end
Port=zeros(length(iPort),1);
for i=1:length(iPort),
    iblank=strfind(TXT{iPort(i)},' ');
    Port(i)=sscanf(TXT{iPort(i)}(iblank+1:end),'%i');
end
messg=zeros(size(imessage));
for i=1:length(imessage),
    iblank=strfind(TXT{imessage(i)},' ');
    messg(i)=sscanf(TXT{imessage(i)}(iblank+1:end),'%i');
end
%% Find key
N=length(i531);
Pid=cell(N,1);
Key=zeros(N,4);
point_description=cell(N,1);
cconst1=zeros(N,1);
cconst2=zeros(N,1);
nskip=[];
for i=1:length(i531),
    Pid{i}=TXT{i531(i)}(10:16);
    ikey=find(i531(i)>iIP,1,'last');
    Key(i,1)=IP(ikey);
    ikey=find(i531(i)>iPort,1,'last');
    Key(i,2)=Port(ikey);
    ikey=find(i531(i)>imessage,1,'last');
    Key(i,3)=messg(ikey);
    imslot=findrow(TXT(i531(i):i531(i)+50),'^message_offset ');
    Key(i,4)=sscanf(TXT{i531(i)+imslot(1)-1}(16:end),'%i');
    iptdes=findrow(TXT(i531(i):i531(i)+50),'^point_desc ');
    point_description{i}=TXT{i531(i)+iptdes(1)-1}(12:end);
    iconst1=findrow(TXT(i531(i):i531(i)+50),'^cconst1 ');
    cconst1(i)=sscanf(TXT{i531(i)+iconst1(1)-1}(9:end),'%f');
    iconst2=findrow(TXT(i531(i):i531(i)+50),'^cconst2 ');
    cconst2(i)=sscanf(TXT{i531(i)+iconst2(1)-1}(9:end),'%f');    
    if strncmp('LPRM',point_description{i}(1:4),4),
        Key(i,4)=Key(i,4)+1;
        if Key(i,4)==37, 
            Key(i,4)=1;
            Key(i,3)=Key(i,3)+1;
        end
    else %APRM
        if strfind(point_description{i},'FLUX')
            Key(i,4)=Key(i,4)-1;
            if Key(i,4)==0, Key(i,4)=36;end
            Key(i,3)=Key(i,3)+1;
        else
            nskip=[nskip i];
        end
    end
end
Key(nskip,:)=[];
point_description(nskip)=[];
cconst1(nskip)=[];
cconst2(nskip)=[];
Pid(nskip)=[];