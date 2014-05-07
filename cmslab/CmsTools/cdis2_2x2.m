function cordis2x2=cdis2_2x2(cordis,resfile,fuel_data)
% cdis2_2x2
% cordis2x2=cdis2_2x2(cordis,resinfo,fuel_data)
% cordis2x2=cdis2_2x2(cordis,restart_file,fuel_data)
% or  cordis2x2=cdis2_2x2(cordis,fue_new,fuel_data)
% Expands from any symmetry 1x1 to a 2x2 for plotting in cmsplot
% 
% Input
%  cordis - output from pindis2cordis
%  restart_file (or ReadRes, fue_new)
%  fuel_data - output from read_pinfile
%
% Output
%  cordis2x2 - cell array of (1,ista), each state point contains a full kmax by kan distribution

if isstruct(resfile) % take care of fue_new, resinfo or filename as input
    if max(strcmp('core',fieldnames(resfile)))
        % resinfo
        resinfo = resfile;
        mminj=resinfo.mminj;
    else
        % fue_new
        fue_new = resfile;
        mminj=resinfo.mminj;
    end

elseif ischar(resfile)
      % filename
        resinfo = ReadRes(resfile,'full');
        mminj=resinfo.mminj;
end


[mminjh,sym,knum]=ij2mminj(fuel_data.IIAS,fuel_data.JJAS);

% Hard code for now that cordis is SE
% TODO be general!

cordis2x2=cell(1,length(cordis));

for i=1:length(cordis),
    temp=sym_full(cordis{i},knum);
    temp=expand2x2(temp,mminj,mminjh);
    cordis2x2{i}=temp;
end
    
    
    
    
    
    
   

function vecdis2x2=expand2x2(vecdis,mminj,mminjh)
[kmax,kan]=size(vecdis);
vecdis2x2=nan(kmax,4*kan);
for k=1:kmax,
    core=vec2cor(vecdis(k,:),mminjh);
    [imax,jmax]=size(core);
    core2x2=zeros(2*imax,2*jmax);
    for i=1:imax
        for j=1:jmax,
            core2x2(2*i-1,2*j-1)=core(i,j);
            core2x2(2*i-1,2*j)=core(i,j);
            core2x2(2*i,2*j-1)=core(i,j);
            core2x2(2*i,2*j)=core(i,j);
        end
        vecdis2x2(k,:)=cor2vec(core2x2,mminj);
    end
end
   
    
    