function [outdata outdata2]= convert2x2(option,knum,mminj,sym)
% convertPWR2x2 is used to handle 2x2 geometries.
%
%   outdata= convert2x2('2subnum',knum,mminj)
%   [outdata mminjk]= convert2x2('2core',knum,mminj)
%
% Input
%   option      - what operation wanted. See below.
%   knum        - data, dependent on the option.
%   mminj       - core conture
%
% Output
%   outdata     - matrix or vector, depens on the option
%   outdata2    - matrix or vector, depens on the option
%
% Descrition
% A various functions are available for the convert2x2  
% - '2subnum'   - input a scalar or vector of channel number, will return
%                 partial positions.
% - '2knum'     - input a partial position and returns the channel number
%                 will produce a number of which position in assembly 1..4
% - '2core'     - input a partial position array, will return a core map of
%                 partial positions. will produce a new mminj
% - '2vec'      - same as '2core' but returns a knum vector and a new mminj
% - '2fill'     - fill a vector from 1x1 to 2x2 values
%
% Example:
%
% subnums = convert2x2('2subnum',1:kan,mminj);
% knums = convert2x2('2knum',1:4*kan,mminj);
% [corem mminjnew] = convert2x2('2core',1:4*kan,mminj);
% [corem mminjnew] = convert2x2('2vec',1:4*kan,mminj);
%
% See also vec2cor

% Mikael Andersson 2011-10-03
% TODO: add symetries...

%% subnums belonging to knum
switch lower(option)
    case '2subnum'
        if nargin == 4 && ~strcmpi(sym,'full')
            numcheck = (length(mminj)/2 - floor(length(mminj)/2));
            [~, scol] = find(knum == 1);
            knums = sort(knum(:,scol));
            if numcheck == 0
                outdata = zeros(length(knums),4);
                for i = 1:length(knums)
                    outdata(i,:) = (4*(knums(i)-1)+1):(4*knums(i)) ;
                end
            else
                switch upper(sym)
                    case 'S'
                        knums = 1:max(knums)*4-length(mminj)*2;
                        k=1;
                        for i = 1:2:length(mminj)*2
                            outdata(k,3:4) = knums(i:i+1);
                            k=k+1;
                        end
                        for i = max(outdata(:))+1:4:max(knums)
                            outdata(k,:) = knums(i:i+3);
                            k=k+1;
                        end
                    case 'SE'
                        knums = 1:max(knum(:));
                        outdata(1,4) = 1;
                        k = 2;
                        for i = 2:2:length(mminj)
                            outdata(k,3:4) = knums(i:i+1);
                            k=k+1;
                        end
                        j = max(outdata(:))+1;
                        for i = 1:length(mminj)/2
                            
                            outdata(k,[2 4]) = knums(j:j+1);
                            j = j+2;
                            k = k+1;
                            negs = mminj(ceil(length(mminj)/2)+1:end);
                            for sd = 1:ceil(length(mminj)/2) - negs(i)
                                outdata(k,:) = [knums(j:j+3)];
                                k = k+1;
                                j = j+4;
                            end
                        end
                  
                end
            end
        
        else
            outdata = zeros(max(length(knum)),4);
            for i = 1:length(knum)
                outdata(i,:) = (4*(knum(i)-1)+1):(4*knum(i)) ;
            end
        end
%     case '2knum'
%         outdata = zeros(size(data));
%         outdata2 = outdata;
%         kan = sum(length(mminj) - 2*(mminj-1));
%         asspos = convert2x2('2asspos',1:kan,mminj);
%         for i = 1:length(data)
%             [outdata(i) outdata2(i)] = find(data(i) == asspos);
%         end
        
    case '2core'
%         kan = sum(length(mminj) - 2*(mminj-1));
        subnumm = convert2x2('2subnum',knum,mminj,sym);
        mminjh = 2*mminj-1;
        mminjk = reshape([mminjh mminjh]',2*length(mminjh),1);
        
        switch upper(sym)
            case 'FULL'
                itleng = length(mminj);
                bigcor = zeros(length(mminjk));
                currpos = 1;
                for i = 1:itleng
                    iu = 2*i-1;
                    ie = 2*i;
                    rowpos = mminjk(2*i):length(mminjk)-mminjk(2*i)+1;
                    logie = (rowpos/2)-round(rowpos/2) == 0;
                    logiu = ~logie;
                    posvec =  currpos:(currpos+length(rowpos)/2-1);
                    bigcor(iu,rowpos(logiu)) = subnumm(posvec,1);
                    bigcor(iu,rowpos(logie)) = subnumm(posvec,2);
                    bigcor(ie,rowpos(logiu)) = subnumm(posvec,3);
                    bigcor(ie,rowpos(logie)) = subnumm(posvec,4);

                    currpos = currpos + length(rowpos)/2;
                end
                
            case 'S'
                lengm = length(mminj);
                itleng = floor(lengm/2);
                mminjS = mminjk(lengm+1:end);
                bigcor = zeros(length(mminjk)/2,length(mminjk));
                firstrow = subnumm(1:lengm,:)';
                bigcor(1,:) = firstrow((subnumm(1:lengm,:)~=0)')';
                currpos = lengm+1;
                for i = 1:itleng
                    iu = 2*i+1;
                    ie = 2*i;
                    rowpos = mminjS(ie):length(mminjk)-mminjS(ie)+1;
                    logie = (rowpos/2)-round(rowpos/2) == 0;
                    logiu = ~logie;
                    posvec =  currpos:(currpos+length(rowpos)/2-1);
                    bigcor(ie,rowpos(logiu)) = subnumm(posvec,1);
                    bigcor(ie,rowpos(logie)) = subnumm(posvec,2);
                    bigcor(iu,rowpos(logiu)) = subnumm(posvec,3);
                    bigcor(iu,rowpos(logie)) = subnumm(posvec,4);
                    currpos = currpos + length(rowpos)/2;
                end
            case 'SE'
               lengm = length(mminj);
               itleng = floor(lengm/2);
               mminjS = mminjk(lengm+1:end);
               bigcor = zeros(length(mminjk)/2,length(mminjk)/2);
               firstrow = subnumm(1:ceil(lengm/2),:)';
               bigcor(1,:) = firstrow((firstrow ~= 0))';
               lrow = subnumm((subnumm(:,3) == 0 & subnumm(:,2) ~=0),:)';
               bigcor(2:end,1) = lrow(lrow ~= 0);
               subleft = subnumm(subnumm(:,1) ~=0,:);
               currpos = 1;
               for i = 1:itleng
                    ie = 2*i;
                    iu = 2*i+1;
                    
                    rowpos = 1:length(mminjS)-mminjS(ie)+1;
                    logs = (rowpos/2)-round(rowpos/2) == 0;
                    logie = logical([0 logs(2:end)]);
                    logiu = logical([0 ~logs(2:end)]);
                    posvec =  currpos:(currpos+length(rowpos)/2-1);
                    bigcor(ie,rowpos(logie)) = subleft(posvec,1);
                    bigcor(ie,rowpos(logiu)) = subleft(posvec,2);
                    bigcor(iu,rowpos(logie)) = subleft(posvec,3);
                    bigcor(iu,rowpos(logiu)) = subleft(posvec,4);
                    currpos = currpos + floor(length(rowpos)/2);
                end
        end
        outdata = bigcor;
        outdata2 = mminjk;
        
    case '2vec'
        core = convert2x2('2core',knum,mminj,sym);
        corevec = [];
        for i = 1:size(core,1)
            corevec = [corevec core(i,core(i,:) ~=0)];
        end
        outdata = corevec;

    case '2asspos'
        kan = sum(length(mminj) - 2*(mminj-1));
        cormap = fill2x2(1:kan,mminj,knum,sym,'mat');
        mminjh = 2*mminj-1;
        mminjk = reshape([mminjh mminjh]',2*length(mminjh),1);
        knumcore = vec2cor(1:4*kan,mminjk);
        outdata = zeros(kan,4);
        for i = 1:kan
            outdata(i,:) = sort(knumcore(cormap == i));
        end
%         
%     case '2ij'
%         kan = sum(length(mminj) - 2*(mminj-1));
%         % kanske nån grej för att kolla mminj...
%         core = convert2x2('2core',knum,mminj);
%         subnums = convert2x2('2subnum',knum,mminj);
%         for i = 1:length(data)
%             for j = 1:4
%                 [outdata(i,j) outdata2(i,j)] = find(core == subnums(i,j));
%             end
%         end
        
    otherwise 
        warning('Incorrect option');
        return
 
end
