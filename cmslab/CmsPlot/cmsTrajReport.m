function cmsTrajReport(varargin)

% TODO fix m-code generator

hfig = gcf;
pos = get(hfig, 'position');
cmsplot_prop = get(hfig, 'userdata');
mminj = cmsplot_prop.core.mminj;
knum=cmsplot_prop.core.knum;
kmax=cmsplot_prop.core.kmax;
kan = sum(length(mminj) - 2*(mminj-1));
cornan=NaN(kmax,kan);
% if isfield(cmsplot_prop.fue_new,'vhist'),
%     vhist=cmsplot_prop.fue_new.vhist;
% else
    vhist=cornan;  
% end
if isnan(vhist),
    q{1}='Echoed info will be better if you attach a restart file.';
    q{2}='Attach a Restart File?';
    choice = questdlg(q, 'Attach Restart File?',...
'Continue Anyway','Attach Restart File','Cancel','Attach Restart File');
    if strcmp(choice,'Cancel'),
        return
    elseif strcmp(choice,'Attach Restart File'),
        success=AttachRestart(hfig);
        if success,
            cmsplot_prop=get(hfig,'userdata');
            vhist=cmsplot_prop.fue_new.vhist;
        end
    end
end

dists=cmsplot_prop.dists;
cmsinfo=cmsplot_prop.cmsinfo;

if isfield(cmsplot_prop.fue_new,'burnup'),
    burnup=cmsplot_prop.fue_new.burnup;
else
    burnup=cornan;
end

if isfield(cmsplot_prop.fue_new,'crdhist'),
    crdhist=cmsplot_prop.fue_new.crdhist;
else
    crdhist=cornan;
end
if isfield(cmsplot_prop.fue_new,'serial'),
    serial=cmsplot_prop.fue_new.ser;
else
    serial=cmsinfo.serial;
end
if isfield(cmsplot_prop.fue_new,'nfta'),
    nfta=cmsplot_prop.fue_new.nfta;
else
    nfta=cornan(1,:);
end
if isfield(cmsplot_prop.fue_new,'lab'),
    lab=cellstr(cmsplot_prop.fue_new.lab);
else
    lab=cell(kan,1);
end
if isfield(cmsplot_prop.fue_new,'asmnam'),
    asmnam=cellstr(cmsplot_prop.fue_new.asmnam);
    nftaList=unique(nfta);
    Asmnam=cell(kan,1);
    for i=1:length(nftaList),
        inft=find(nfta==nftaList(i));
        for i1=1:length(inft),
            Asmnam{inft(i1)}=asmnam{i};
        end
    end
else
    Asmnam=cell(kan,1);
end

Xpo=cmsplot_prop.Xpo;

mesg_string ={'Left click to select ';'Right click or';'Hit any key to plot'};
hmsg = msgbox(mesg_string);
msgpos = [pos(1)+0.2*pos(3) pos(2)+0.15*pos(4) 100 80];
set(hmsg, 'position', msgpos);
uiwait(hmsg);

figure(hfig);
button=1;
i=0;
sel=zeros(kan,1);
fprintf('%s','Nfta   Asmnam Serial   Label   Burnup  Vhist Crdhist   Pos.   Channel')
if min(size(knum))>1,
    fprintf('  Symmetry pos');
end
fprintf('\n')
while button==1
 [xx,yy,button]=ginput(1);
 if button==1
   i=i+1;
   x(i,1)=xx;
   y(i,1)=yy;
   nx=fix(xx);
   ny=fix(yy);
   xl=[nx nx+1;
       nx+1 nx];
   yl=[ny ny;
       ny+1 ny+1];
   kanNew(i)=cpos2knum(fix(y(i)),fix(x(i)),mminj);
   if kanNew(i)>0
      knm=kanNew(i);
      [knm1,jdum]=find(knum==knm);knm1=knm1(1);
      bur=round(mean(burnup(:,knm1)));
      vhi=mean(vhist(:,knm1));
      crdhi=mean(crdhist(:,knm1));
      ser=serial{knm};
      labl=lab{knm};
      asm=Asmnam{knm};
      fprintf('%3i %7s %8s %8s %6i  %6.3f%7.3f%s%2i%s%2i%s%8i%12.4g',nfta(knm1),asm,ser,labl,bur,vhi,crdhi,'  (',ny,',',nx,')',knm);
      if min(size(knum))>1,
          fprintf('    %i',knum(knm1,1));
      end
      fprintf('\n')
       if sel(kanNew(i))==1, % Unselect if already selected
           sel(kanNew(i))=0;
           ibefore=find(kanNew(i)==kanNew(1:end-1));
           for i1=1:length(ibefore),
               if ishandle(hcross(1,ibefore(i1))),
                   for i2=1:2,
                       delete(hcross(i2,ibefore(i1)));
                   end
               end
           end
       elseif sel(kanNew(i))==0, % Select if not selected
           sel(kanNew(i))=1;
           hcross(:,i)=line(xl,yl,'color','black');
       end
   else
       disp('Cannot select outside core');
   end
 end
end
ckan=find(sel);
ll=length(ckan);
N=length(Xpo);
matris=NaN(ll,N);
if isempty(ckan), return;end
Ckan=zeros(size(ckan));
for i=1:length(ckan),
    [ii,jj]=find(knum==ckan(i));ii=ii(1);
    Ckan(i)=ii;
end
for i=1:N,
    if min(size(dists{i}))>1,
        vec=eval([cmsplot_prop.operator,'(dists{',num2str(i),'});']);
    else
        vec=dists{i};
    end
    matris(:,i)=vec(Ckan);
end

htraj=figure;
legstr=cell(ll,1);
hold all
ij=knum2cpos(ckan,mminj);
for i=1:ll,
   plot(Xpo,matris(i,:)); 
   legstr{i}=sprintf('i,j = %2i,%2i chno=%i',ij(i,1),ij(i,2),ckan(i));
end
legend(legstr,'location','best');
ylabel([cmsplot_prop.operator,' ',cmsplot_prop.dist_name])
xlabel(cmsplot_prop.cmsinfo.ScalarNames{1});
grid on
