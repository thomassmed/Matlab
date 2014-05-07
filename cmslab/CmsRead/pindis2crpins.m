function xut=pindis2crpins(A,nfra,funfcn,skip)
% pindis2crpins analyses pins closest to control rods
% cordis=pindis2crpins(pindis,nfra,funfcn,skip)
%
% Input:
%   pindis - Pin distribution {ista}{IAFULL*IAFULL} cell, each cell contains a matrix NPIN by NPIN by KDFUEL
%   nfra   - loading orientation 0-SE, 1-SW, 2-NW, 3-NE (found in fue_new.nfra)
%   funfcn - operation to be performed, default= @max
%   skip   - Numerical value to skip, default=0
%
% Output
%   cordis - (1 by ista) cell array of matrices kmax (=KDFUEL) by knum
%
% Example
% pinpow=read_pinfile('c21_c5s5noqth.pinfile');
% pow=pindis2crpins(pinpow,nfra);
% [pinpow,fuel_data]=read_pinfile('c21_c5s5noqth.pinfile');
% crpow=pindis2crpins(pinpow,fuel_data.IROT);
%
% See also read_pinfile, pin_delta, pin_oper, pmap2ptraj, pindis2cordis

%%
if nargin<4, skip=0;end
if nargin<3, funfcn=@max;end

%% set up dimesnsions and preallocate
if ~iscell(A{1}), % If only one state-point, adjust to the other format
    Atemp{1}=A;
    A=Atemp;
    clear Atemp
end
[iafull,jafull]=size(A{1});
maxsta=length(A);
xut=cell(1,maxsta);
for i=1:maxsta,
    icount=0;
    for i1=1:iafull
        for i2=1:jafull,
            if ~isempty(A{i}{i1,i2}),
                ijk=size(A{i}{i1,i2});
                if length(ijk)>2,
                    kmax=ijk(3);
                else
                    kmax=1;
                end
                icount=icount+1;
                for j=1:kmax,
                    temptemp=A{i}{i1,i2}(:,:,j);
                    ijA=size(temptemp);np=ijA(1);
                    switch nfra(icount)
                        case 0
                            temp1=[temptemp(1,:)';temptemp(2:np,1)];
                        case 1
                            temp1=[temptemp(1,:)';temptemp(2:np,np)];
                        case 2
                            temp1=[temptemp(np,:)';temptemp(1:np-1,np)];
                        case 3
                            temp1=[temptemp(np,:)';temptemp(1:np-1,np)];
                    end
                    if isnan(skip),
                        iremove=isnan(temp1);
                    else
                        iremove= temp1==skip;
                    end
                    temp1(iremove)=[];
                    temp(j,icount)=funfcn(temp1);
                end
            end
        end
    end
    xut{i}=temp;
end
if maxsta==1,
    xut=xut{1};
end
