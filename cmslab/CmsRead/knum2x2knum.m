function knum = knum2x2knum(knumold,mminj,sym,symc)

% rot 1 mirr 2
switch upper(sym)
    
    case 'FULL'
        knum(:,1) = 1:length(knumold)*4;
    case 'S'
        knumvec= 1:max(knumold)*4;
        mminjh = 2*mminj-1;
        mminjk = reshape([mminjh mminjh]',2*length(mminjh),1);
        knummat = vec2cor(knumvec,mminjk);
        kN = knummat(1:length(mminj),:);
        kS = knummat(length(mminj)+1:end,:);
        if symc == 1
            kN = rot90(kN,2);
        else
            kN = flipud(kN);
        end
        knt = kN';
        kst = kS';
        knum = [kst(kst~=0) knt(kst~=0)];
        
    case 'SE'
        knumvec= 1:max(knumold)*4;
        mminjh = 2*mminj-1;
        mminjk = reshape([mminjh mminjh]',2*length(mminjh),1);
        knummat = vec2cor(knumvec,mminjk);
        mid = length(mminj);
        kNW = knummat(1:mid,1:mid);
        kNE = knummat(1:mid,mid+1:end);
        kSW = knummat(mid+1:end,1:mid);
        kSE = knummat(mid+1:end,mid+1:end);
        kNW = rot90(kNW,2);
        if symc == 1
            kNE = rot90(kNE,-1);
            kSW = rot90(kSW,1);
        else
            kNE = flipud(kNE);
            kSW = fliplr(kSW);
        end
        kset = kSE';
        kswt = kSW';
        knet = kNE';
        knwt = kNW';
        knum = [kset(kset~=0) kswt(kswt~=0) knet(knet~=0) knwt(knwt~=0)];
        

end