function  [cr,cr_w,cr_cusp,cr_gray]=konrod2crfrac(resfile)
% [cr,cr_w,cr_cusp]=konrod2crfrac(fue_new);
% 
% Input:
%   fue_new     - Output from read_restart_bin
% Output
%   cr          - Cell array of 3 kmax by kan matrices,  for 1 ,2nd and 3rd
%                 cr-type in node, 0 for all if no cr is present
%   cr_w        - weight factor for each of the above cr-type in node, crw{1} is 1 when no cr             
%
%
% See also read_restart_bin

if isstruct(resfile)
    if max(strcmp('core',fieldnames(resfile)))
      % resinfo
        resinfo = resfile;
        dat = ReadRes(resinfo,{'DIMS','CONTROL ROD'},1);
        fue_new = catstruct(dat.dims,dat.controlrod,dat.resinfo.core);
    else
      % fue_new
      fue_new = resfile;
    end
    
elseif ischar(resfile)
      % filename
        resinfo = ReadRes(resfile,'nodata');
        dat = ReadRes(resinfo,{'DIMS','CONTROL ROD'},1);
        fue_new = catstruct(dat.dims,dat.controlrod,dat.resinfo.core);
end


%%
kmax=fue_new.kmax;hz=fue_new.hz;
konrod=fue_new.konrod;dzstep=fue_new.dzstep;npfw=fue_new.crdsteps;
cr_length=dzstep*npfw;
crcov_frac=cr_length/fue_new.hcore;                   %Relative coverage of control rod   
%% Fix every controlrod
z=0:kmax;z=z*hz;
cr_list=unique(fue_new.crtyp);
CRBAS=zeros(kmax,length(fue_new.konrod));
CR1=zeros(kmax,length(fue_new.konrod));CR2=CR1;W1=CR1;W2=CR1;W1_cusp=ones(size(W1));
CR_gray=cell(1,3);
CR_1=ones(kmax,length(fue_new.konrod));CR_1=0*CR_1;
CR_gray{1}=CR_1;CR_gray{2}=CR_1;CR_gray{3}=CR_1;
for i=cr_list
    lim=fue_new.crdzon(:,i);lim=rensa(lim,0);
    lim(find(isnan(lim)))=[];llim=length(lim);
    ncrd=fue_new.ncrd(:,i);ncrd=rensa(ncrd,0);
    ncrd(isnan(ncrd))=[];ncrd=[ncrd;0;0];  % To allow for "overindexing"
    crd_gray=fue_new.crd_gray(:,i);
    crd_gray=[crd_gray;1;1];
    % First take fully withdrawn cr's
    icr_out=find(fue_new.crtyp==i&konrod==npfw);    llim=length(lim);
    cr_delta=max(lim)-cr_length;
    CRBAS(1,icr_out)=ncrd(llim); 
    CR_gray{1}(1,icr_out)=crd_gray(llim);
    if cr_delta>hz
        W1(2,icr_out)=(2*hz-cr_delta)/hz;
        W1_cusp(2,icr_out)=((2*hz-cr_delta)/hz)^2;        
        CRBAS(2,icr_out)=ncrd(llim); 
    else
        W1(1,icr_out)=(hz-cr_delta)/hz;
        W1_cusp(1,icr_out)=((hz-cr_delta)/hz)^2;
    end
    icr_in=find(fue_new.crtyp==i&konrod<npfw); 
    % Deal with each inserted control individually:
    for i1=icr_in,
        limcr=lim-konrod(i1)*dzstep;
        j=find(limcr>0,1,'first');
        lastnode=0;
        for j1=j:llim,
            limnod=find(limcr(j1)<z,1,'first')-1;
            if limnod>lastnode,
                CRBAS(lastnode+1:limnod,i1)=ncrd(j1);
                CR1(limnod,i1)=ncrd(j1+1);
                CR_gray{1}(lastnode+1:limnod,i1)=crd_gray(j1);
                CR_gray{2}(limnod,i1)=crd_gray(j1+1);
                W1(limnod,i1)=(z(limnod+1)-limcr(j1))/hz;
                lastnode=limnod;
                if j1<llim,  % Allow for two changes in the node, but only if we are not already at the end of the cr
                    if limcr(j1+1)<z(limnod+1), %Indeed we did have two changes
                        W1(limnod,i1)=(limcr(j1+1)-limcr(j1))/hz;
                        W2(limnod,i1)=(z(limnod+1)-limcr(j1+1))/hz;
                        CR2(limnod,i1)=ncrd(j1+2);
                        CR_gray{3}(limnod,i1)=crd_gray(j1+2);
                        W1_cusp(limnod,i1)=((limcr(j1+1)-z(limnod))/hz)^2;
                    end
                else         % if we are at the last nnode of the cr, apply cusp
                    W1_cusp(limnod,i1)=((limcr(llim)-z(limnod))/hz)^2;
                end
            end
        end
    end
end
%% Now translate all to core-distributions:
mminj=fue_new.mminj;
crmminj=fue_new.crmminj;
cr1=zeros(kmax,fue_new.kan);
crbas=cr1;cr2=cr1;w1=cr1;w2=cr1;cr_cusp=cr1;
cr_gray{1}=cr1;cr_gray{2}=cr1;cr_gray{3}=cr1;
indx=crnum2knum(1:length(konrod),mminj,crmminj);
for i=1:4,
    crbas(:,indx(:,i))=CRBAS;
    cr1(:,indx(:,i))=CR1;
    cr2(:,indx(:,i))=CR2;
    w1(:,indx(:,i))=W1;
    w2(:,indx(:,i))=W2;
    cr_cusp(:,indx(:,i))=W1_cusp;
    for j=1:3,
        cr_gray{j}(:,indx(:,i))=CR_gray{j};
    end
end
    
cr{1}=crbas;cr{2}=cr1;cr{3}=cr2;
cr_w{1}=(1-w1-w2);cr_w{2}=w1;cr_w{3}=w2;