function rms=verify_polca(varargin)

% compare matstab to polca power
%verify_polca('f1');
%verify_polca('f1','f3');
% the 'dist' option gives a distplot of the specified distribution ie 'power'
% the 'rms' option gives a root-mean-square of the difference between matstab
% and polca for the specified distribution ie 'void'
% verify_polca('f1','f3','dist','power','rms','void');
% OBS: only implemeted for power so far
%

if nargin==0
  error('Give plant-identifier as input')
end
[tmp,MATLAB_HOME]=unix('echo $MATLAB_HOME');
MATLAB_HOME(length(MATLAB_HOME))=[];
dist=[];
rms=[];
flag=[];
axial=[];
key1=[];
keyw={'dist','rms','axial'};
for kk=1:length(varargin)
  if any(strcmp(varargin{kk},keyw))
    flag=varargin{kk}; % sätt flag till ett keyword
    if isempty(key1), key1=kk; end
  elseif strcmp(flag,'dist')
    dist=str2mat(dist,varargin{kk});
  elseif strcmp(flag,'rms')
    rms=str2mat(rms,varargin{kk});
  elseif strcmp(flag,'axial')
    axial=str2mat(axial,varargin{kk});
  end
end

for kk=1:(key1-1)
%  staton=eval(['s' int2str(kk)]);
  staton=varargin{kk};
  [casenr,f_polca_list,dat,qrel,hc,drmeas,fdmeas,stdmeas,modord,racsfil_list]=...
    read_fillista([MATLAB_HOME '/matstab/input/' staton '/case_list.txt']);

  for i=1:size(f_polca_list,1)
    f_polca=deblank(f_polca_list(i,:));
    f_polca=expand(f_polca,'dat');
    f_polca=which(f_polca);
    if ~isempty(f_polca)
      [Pow,keff,fa1,fa2]=cmp_polca(f_polca,0);
      Ppower=readdist(f_polca,'power');
      if ~isempty(axial)
        h1=plot(mean(Ppower,2),1:25);
        hold on
        h2=plot(mean(Pow,2),1:25,'r-.');
        hold off
        grid on
        legend([h1 h2],'POLCA','MATSTAB')
        title(['POLCA vs MATSTAB with polca void distribution' 10 'case: ',f_polca_list(i,:)],'Interpreter','none')
        xlabel('Axial Power')    
        print('-depsc','-tiff', [f_polca_list(i,:), '_cmpPow.eps'])
      end
      if ~isempty(dist)
        disp('Not implemented yet')
      end
      if ~isempty(rms)
        [M,N]=size(Pow);
        m(i)=(sum(sum((Ppower-Pow).^2))/(M*N))^0.5;
      end
    else
      disp(['Warning:' f_polca_list(i,:) ' not found'])
    end
  end
end
if exist('m','var')
  rms=m;
else
  rms=[];
end
  
  
