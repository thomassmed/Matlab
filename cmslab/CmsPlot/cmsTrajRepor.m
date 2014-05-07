function cmsTrajReport(varargin)
hfig = gcf;
pos = get(hfig, 'position');
cmsplot_prop = get(hfig, 'userdata');
if nargin==0,
    mcode=0;
else
    mcode=varargin{1};
end
dists=cmsplot_prop.dists;

mminj = cmsplot_prop.mminj;
knum = cmsplot_prop.knum;
sym = cmsplot_prop.sym;
kan = sum(length(mminj) - 2*(mminj-1));
node_plane=eval(cmsplot_prop.node_plane);
nodplan=check_dist(dists,node_plane);

Xpo=cmsplot_prop.Xpo;

ij = knum2cpos(1:kan,mminj);

mesg_string ={'Left click to select ';'                          ';'Right click to plot'};

figure(hfig);
hmsg = msgbox(mesg_string);
msgpos = [pos(1)+0.2*pos(3) pos(2)+0.15*pos(4) 141 115];
%    set(hmsg, 'position', msgpos);
    uiwait(hmsg);
    start = 1; i = round(kan/2); button=[];
    contin = 1;
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
   hcross(:,i)=line(xl,yl,'color','black','erasemode','none');
 end
end
ll=length(x);
%%
kan=cpos2knum(fix(y),fix(x),mminj);
N=length(Xpo);
matris=NaN(ll,N);
for i=1:N,
    if min(size(dists{i}))>1,
        vec=eval([cmsplot_prop.operator,'(dists{',num2str(i),'});']);
    else
        vec=dists{i};
    end
    matris(:,i)=vec(kan);
end

htraj=figure;
legstr=cell(ll,1);
hold all
for i=1:ll,
   plot(Xpo,matris(i,:)); 
   legstr{i}=sprintf('(i,j) = (%i,%i) chno=%i',fix(y(i)),fix(x(i)),kan(i));
end
legend(legstr,'location','best');
ylabel(cmsplot_prop.dist_name)
xlabel(cmsplot_prop.cmsinfo.ScalarNames{1});
grid on
