function xut=pindis2cordis(A,funfcn,skip)
% pindis2cordis reduces a pin distribution to a core distribution
% cordis=pindis2cordis(pindis,funfcn,skip)
%
% Input:
%   pindis - Pin distribution {ista}{IAFULL*IAFULL} cell, each cell contains a matirx NPIN by NPIN by KDFUEL
%   funfcn - operation to be performed, default= @max
%   skip   - Numerical value to skip, default=0
%
% Output
%   cordis - (1 by ista) cell array of matrices kmax by knum
%
% Example
% pinpow=read_pinfile('recalcs.pin');
% pow=pindis2cordis(pinpow,@mean);
%Sometimes you need to get rid of NaN:
% pinpow1=read_pinfile(pfile1);
% pinpow2=read_pinfile(pfile2);
% pin_rat=pin_oper(pinpow1,pinpow2,'/');
% pin_rat_av=pindis2cordis(pin_rat,@mean,NaN);
%
% See also read_pinfile, pin_delta, pin_oper, pmap2ptraj

%%
if nargin<3, skip=0;end
if nargin<2, funfcn=@max;end

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
                    temptemp=temptemp(:);
                    if isnan(skip),
                        iremove=isnan(temptemp);
                    else
                        iremove= temptemp==skip;
                    end
                    temptemp(iremove)=[];
                    temp(j,icount)=funfcn(temptemp);
                end
            end
        end
    end
    xut{i}=temp;
end
if maxsta==1,
    xut=xut{1};
end
