function DF=cas2sim(fw,fs,nfra)
%
%
%
% DF is N E S W in core orientation
if size(fw,2)~= length(nfra), fw=reshape(fw,length(fw(:))/length(nfra),length(nfra)); end
if size(fs,2)~= length(nfra), fs=reshape(fs,length(fs(:))/length(nfra),length(nfra)); end
FN=nan(size(fw));
FE=FN;FS=FN;FW=FN;
ise=find(nfra==0);
FS(:,ise)=fs(:,ise);
FE(:,ise)=fs(:,ise);
FN(:,ise)=fw(:,ise);
FW(:,ise)=fw(:,ise);
isw=find(nfra==1);
FS(:,isw)=fs(:,isw);
FW(:,isw)=fs(:,isw);
FN(:,isw)=fw(:,isw);
FE(:,isw)=fw(:,isw);
inw=find(nfra==2);
FW(:,inw)=fs(:,inw);
FN(:,inw)=fs(:,inw);
FE(:,inw)=fw(:,inw);
FS(:,inw)=fw(:,inw);
ine=find(nfra==3);
FN(:,ine)=fs(:,ine);
FE(:,ine)=fs(:,ine);
FS(:,ine)=fw(:,ine);
FW(:,ine)=fw(:,ine);
DF=[FN(:) FE(:) FS(:) FW(:)];