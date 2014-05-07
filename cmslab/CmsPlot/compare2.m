%compare2 - Compares any number 3-D distributions in a 4-D array
%of the form (rows,columns,nodes,number_of_dists)
%
% compare2(dist, distnames)
%
% Input
%   dist - array of distributions
%   distname - cell array of distribution names
%
% Output 
%   A cmsplot window has to be active (check that gcf
%   results in a figure number with a cmsplot).
%   A new figure is created and axial shape of 
%   current channel is plotted in the new window
%
% Example
%   [fue_new,Oper]=read_restart_bin('s3-1.res');
%   pow=Oper.Power;
%   apow=reads3_out('s3-1.out','3RPF-A');
%   cmsplot s3-1.res
%   compare2(pow,apow)
%
% See also cmsplot, reads3_out

% TODO: Dynamic positioning of windows
function compare2(varargin)
    hfig = gcf;
    pos = get(hfig, 'position');
    cmsplot_prop = get(hfig, 'userdata');
    mminj=cmsplot_prop.mminj;
    knum = cmsplot_prop.knum;
    sym = cmsplot_prop.core.sym;
    if ~iscell(varargin{2}),
        dist=cell(1,nargin);
        kmax=size(varargin{1},1);
        kan=size(varargin{1},2);
        dis3=zeros(kmax,kan,nargin);
        for i=1:nargin,
            dist{i}=varargin{i};
            dis3(:,:,i)=varargin{i};
            distnames{i}=inputname(i);
        end
        kmax=size(dis3,1);
        ifsubnods=zeros(nargin,1);
    elseif nargin == 3
        % TODO: need to check this for other files..
        coreinfo = varargin{3};
        distnames = varargin{2};
        dist = varargin{1};
        for j = 1:length(dist)
            if strcmpi(coreinfo{j}.fileinfo.type,'res') && ~strcmpi(coreinfo{j}.core.sym,'FULL')
                if coreinfo{j}.core.if2x2 == 2
                    dist{j} = sym_full(dist{j},coreinfo{j}.core.knum2x2);
                else
                    dist{j} = sym_full(dist{j},coreinfo{j}.core.knum);
                end
            end
            if strcmp(cmsplot_prop.coreinfo.fileinfo.fullname,coreinfo{j}.fileinfo.fullname)
                newfile(j) = 0;
            else
                newfile(j) = 1;
            end
            if iscell(dist{j})
                ifsubnods(j) = 1;
            else
                ifsubnods(j) = 0;
            end
        end
        
        if max(ifsubnods)
            for k = 1:length(dist)
                if ifsubnods(k)
                    distcell{k} = dist{k};
                    maxval(k) = max(cellfun(@max,dist{k}));
                    minval(k) = min(cellfun(@min,dist{k}));
                    if newfile(k)
                        % TODO: need to be checked for other files..
                        subgeoms = ReadCore(coreinfo{k},'SUBNODE GEOMETRY',1);
                        sizecell{k} = cellfun(@cumsum,subgeoms,'UniformOutput',0);
                    else
                        sizecell{k} = cellfun(@cumsum,cmsplot_prop.subgeom,'UniformOutput',0);
                    end
                else
                    distcell{k} = mat2cell(dist{k},size(dist{k},1),ones(1,size(dist{k},2)));
                    hz = cmsplot_prop.hz;
                    kmax = size(dist{k},1);
                    sizecell{k} = (1:kmax)'*hz;
                    maxval(k) = max(dist{k}(:));
                    minval(k) = min(dist{k}(:));
                end
            end
                
        else
            for j = 1:length(dist)
                dis3(:,:,j) = cor3D2dis3(dist{j}, mminj, knum, sym);
                kmax = size(dis3,1);
            end
        end
        
    else
        dist=varargin{1};
        distnames=varargin{2};
        for j = 1:size(dist,4)
            dis3(:,:,j) = cor3D2dis3(dist(:,:,:,j), mminj, knum, sym);
        end
        kmax = size(dist, 3);
    end
    kan = sum(length(mminj) - 2*(mminj-1));
    
    if max(ifsubnods)
        xmax = max(max(maxval),0);
        xmin = min(min(minval),0);
    else
        xmax = max(max(max(dis3)));
        xmin = min(min(min(dis3)));
        xmin = min(xmin,0);
        xmax = max(xmax,0);
    end

    ij = knum2cpos(1:kan,mminj);

    mesg_string = [ 'Left click to select starting point '
                    '                                    '
                    'Arrows to navigate                  '
                    '                                    '
                    'Left click again for new start point'
                    '                                    '        
                    'Right click or <CR> to quit         '];

    figure(hfig);
    hmsg = msgbox(mesg_string);
    msgpos = [pos(1)+0.1*pos(3) pos(2)+0.1*pos(4) 141 115];
   set(hmsg, 'position', msgpos);
    uiwait(hmsg);
    start = 1; i = round(kan/2); button=[];
    contin = 1;

while contin
    %set(hfig,'CurrentAxes',cmsplot_prop.handles(10,1));
    [xx, yy, button] = ginput(1);
    
    if isempty(button), break;end
    switch(button)
        case 1
            nx = fix(xx);
            ny = fix(yy);
            ny=max(ny,1);
            ny=min(ny,length(mminj));  
            nx=max(nx,mminj(ny));
            nx=min(nx,length(mminj)-mminj(ny)+1);
            i = cpos2knum(ny, nx, mminj);
        case 3
            contin = 0; return;
        case 28
            if i>1, i=i-1; end
        case 29
            if i<kan, i=i+1; end
        case 30
            nxy = knum2cpos(i, mminj);
            ny = nxy(1); nx = nxy(2);        
            if ny>1, ny=ny-1; end
            i = cpos2knum(ny, nx, mminj);
        case 31
            nxy = knum2cpos(i, mminj);
            ny = nxy(1); nx = nxy(2);
            if ny<length(mminj), ny=ny+1; end
            i = cpos2knum(ny, nx, mminj);
        otherwise
            i = i + 1;
    end
    
    if start
        newpos = pos;
        newpos(3) = pos(3) * 0.7;
        newpos(1) = pos(1) - newpos(3) * 1.02;
        g1=figure('position',newpos);
%         g1 = figure('position', newpos, 'menubar', 'none');
%         uimenu('label','Export Data','callback','SavedataGUI(0);');
    end
    
    start = 0;
    figure(g1); hold off; g1 = gcf;
    
    if max(ifsubnods)
        for j = 1:length(distcell)
            
            if ifsubnods(j)
                plot(distcell{j}{i},sizecell{j}{i});
%                 compfig_prop.plotdata(:,j) = distcell{j}{i};
            else
                plot(distcell{j}{i},sizecell{j});
%                 compfig_prop.plotdata(:,j) = distcell{j}{i};
            end
            
            hold all
        end
        axis([xmin xmax 0 cmsplot_prop.hcore]);
    else
        for j = 1:length(dist)
            plot(dis3(:,i,j), 1:kmax); hold all;
            if (j == size(dis3,3)), hold off; grid; end
            compfig_prop.plotdata(:,j) = dis3(:,i,j);
        end
        axis([xmin xmax 0 kmax]);
        
    end
%     set(g1,'userdata',compfig_prop)
    distnames = strrep(distnames,'\','/');
    legend(distnames, 'Location', 'Best');
%     if nargin>2,
%         legend(inputname(1),inputname(2),inputname(3),'Location','North');
%     else
%         legend(inputname(1),inputname(2),'Location','North');
%     end
    title(['knum: ' num2str(i) '. Pos: ' num2str(ij(i,:))]);
    figure(hfig); 
    xl = [ij(i,2) ij(i,2)+1;ij(i,2)+1 ij(i,2)];
    yl = [ij(i,1) ij(i,1);ij(i,1)+1 ij(i,1)+1];
    cmsplot_now;
    h = line(xl, yl, 'color', 'black', 'erasemode', 'none', 'linew', 2); drawnow;
end
figure(hfig);