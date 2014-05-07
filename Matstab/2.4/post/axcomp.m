function [hand,handd]=axcomp(varargin)
% h=axcomp(dist1,dist2,dist3,...,channel,'diff')
%   or 
% h=axcomp(matfile,distname,channel,'diff')
%
% plots the axial distributions dist1,dist2, etc
% dist are distributions (use eg. readdist)
% channel is the fuel channel number (polca), default= axial average
% 
% If a filename of a matstab-output file is given, axcomp compares 
% the polca and matstab distributions, distname= power, void or dens
% Examples:
%  
%     axcomp(Pv7,Pvoid)
%     axcomp('f2_boc_22.mat','void')
%     axcomp('f2_boc_22.mat','void','diff')
%     axcomp('f2_boc_22.mat','void',185,'diff')

nV=length(varargin);

if isstr(varargin{1})  % matstab output file => compare polca vs matstab 
  file=varargin{1};
  load(file,'steady');
  load(file,'msopt');
  % get distributions to compare
  if nV<2 || strcmp(remblank(varargin{2}),'diff') || ~ischar(varargin{2})
    distname=[];
  else   
    distname=varargin{2}; 
  end
  if isempty(distname), distname='power';end % default = power
  if findstr(distname,'power')
    pdist=readdist(msopt.DistFile,'power');
    mdist=steady.Ppower;
  elseif findstr(distname,'void')
    pdist=readdist(msopt.DistFile,'void');
    mdist=steady.Pvoid;
  elseif findstr(distname,'dens')
    pdist=readdist(msopt.DistFile,'dens');
    mdist=steady.Pdens;
  end
  % channel to plot
  if nV>1 && ~ischar(varargin{2})
    channel=varargin{2};
  elseif nV>2 && ~ischar(varargin{3})
    channel=varargin{3};
  else 
    channel=[];
  end
  if strcmp('diff',varargin{nV}), 
    diff='diff';
  else
    diff='';
  end
  if isstr(channel), channel=str2num(channel); end
  [hand,handd]=axcomp(pdist,mdist,channel,diff);
  % Add some text to the figure
  if isempty(channel), 
    chstr=' Axial average'; 
  else
    if length(channel)>1
      chstr=[' Channel: ', num2str(channel(1)) ,' : ', num2str(channel(end))];
    else
      chstr=[' Channel: ' num2str(channel(1))];
    end
  end
  title([file,' ',upper(distname),chstr],'interpreter','none')
  if findstr(distname,'void')
    legend(hand,'polca','matstab',4); % legenden längst ner till höger
  else
    legend(hand,'polca','matstab');  % legenden längst upp till höger
  end
  
  if diff
    legend(handd,'matstab - polca');
  end  
else 
  % function call with distributions
  % count number of distributions
  k=1;
  while k<nV & (size(varargin{k})==size(varargin{k+1}))
    k=k+1;
  end
  nComp=k;
  if nComp+1<=nV
    channel=varargin{nComp+1};
  else 
    channel=[];
  end
  if isstr(channel), channel=str2num(channel); end
%  if nComp+2<=nV
%    col=varargin{nComp+2};
%  else
%    col=[];
%  end
  for i=1:nComp
    mat{i}=varargin{i};
  end
%  if isempty(col)
    col=[  0         0    1.0000;
      1.0000         0         0;
           0    0.8000         0;
           0    0.7500    0.7500;
      0.7500         0    0.7500;
      0.7500    0.7500         0;
      0.2500    0.2500    0.2500];
%  end

  %if ~ishold
  %  clf
  %  hold on
  %end
  if isempty(channel), channel=1:size(mat{1},2); end
  wasHold=ishold;
  if strcmp('diff',varargin{nV}), 
    nsubfig=2;
  else
    nsubfig=1;
  end
  for i=1:length(mat)
    subplot(1,nsubfig,1)
    h(i)=plot(mean(mat{i}(:,channel),2),1:size(mat{i},1));
    if i==1
      hold on
    elseif nsubfig==2
      subplot(1,2,2)
      hd(i-1)=plot(mean(mat{i}(:,channel)-mat{1}(:,channel),2),1:size(mat{i},1)); % dist_i-dist_1
      set(hd(i-1),'color',col(i,:))
      title('Difference dist(i)-dist(1)')
      hold on
    end      
    set(h(i),'color',col(i,:))
  end
  % Add some text to the figure
  subplot(1,nsubfig,1)
  if length(channel)==size(mat{1},2)  
    chstr=' Axial average'; 
  else
    if length(channel)>1
      chstr=[' Channel: ', num2str(channel(1)) ,' -> ', num2str(channel(end))];
    else
      chstr=[' Channel: ' num2str(channel(1))];
    end
  end
  title(chstr)
  legend(h,num2str([1:length(h)]'),0)
  
  if nsubfig==2
    legend(hd,[num2str([2:length(hd)+1]') repmat(' - ',length(hd),1) repmat('1',length(hd),1)]);
  else
    hd = 0;
  end    
  
  if ~wasHold
    if nsubfig==2, 
      subplot(1,2,2)
      hold off, 
    end
    subplot(1,nsubfig,1)
    hold off
  end
  
  if nargout>0
    hand=h;  
  end
  if nargout>1
    handd = hd;
  end
end  
  
  
  
  
  
  
