function ys=smooth(y,Fc)
%
%ys=smooth(y);    
%
%Ger en utjmnad signal ys av insignalen y
%
if nargin<2, Fc=0.05;end

if ischar(Fc)||Fc>1.99
    if isnumeric(Fc), N=Fc;else N=2;end
    y1=decimate(y,N);
    ys=interp(y1,N);
    if size(ys,1)>size(y,1),
        ys((size(y,1)+1):end,:)=[];
    end
    for i=1:size(y,2)
        ys(:,i)=ys(:,i)+mean(y(:,i))-mean(ys(:,i));
    end
    return
end


h=fdesign.lowpass('N,F3dB',20,Fc);d1 = design(h,'butter');
ys=filtfilt(d1.sosMatrix,d1.ScaleValues,y);



