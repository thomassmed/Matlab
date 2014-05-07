function figs=plot_drfd(dr,fd,drmeas,fdmeas,dr2,fd2,label2,titel)
% plot_drfd  plot decay ratio (dr) and frequency 
%
% figs=plot_drfd(matfiles)
%
%
% Example:
%     matfiles={'/cms/t2-jef/c18/s3k/s3k-1.mat','/cms/t2-jef/c19/s3k/s3k-1.mat'};
%     [dr_mstab,fd_mstab]=get_drfd(matfiles)
%     plot_drfd(dr_mstab,fd_mstab,drmeas,fdmeas); % or
%     plot_drfd(dr_mstab,fd_mstab,drmeas,fdmeas); % or
%     plot_drfd(dr_mstab,fd_mstab,drmeas,fdmeas,drs3k,fds3k,'s3k'); % or
%     plot_drfd(dr_mstab,fd_mstab,drmeas,fdmeas,dr_mstab1,fd_mstab1,'mstab_1');
%
% See Also
% get_drfd, prt_drfd2

if nargin<3, drmeas=nan(size(dr));end
if nargin<4, fdmeas=nan(size(fd));end
if nargin<7, label2='s3k';end
if nargin<8, titel=[];end

scrsz=get(0,'screensize');
xsz=scrsz(3);
ysz=scrsz(4);
NW=[.01*xsz ysz*.5 .49*xsz .45*ysz];
NE=[.5*xsz ysz*.5 .49*xsz .45*ysz];
SW=[.01*xsz .01*ysz xsz*.49 ysz*.45];
SE=[.5*xsz .01*ysz xsz*.49 ysz*.45];
figs(1)=figure('position',NW);plot(dr);hold on;plot(drmeas,'r');
title(['Decay Ratio ',titel]);
grid;
if nargin<5,
    legend('dr-matstab','dr-meas','location','NW');
else
    plot(dr2,'k');
    legend('dr-matstab','dr-meas',['dr-',label2],'location','NW');
end
figs(2)=figure('position',NE);plot(fd);hold on;plot(fdmeas,'r');
title(['Frequency ',titel]);
grid
if nargin<5,
    legend('fd-matstab','fd-meas','location','NW');
else
    plot(fd2,'k');
    legend('fd-matstab','fd-meas',['fd-',label2],'location','NW');
end

if nargin>2
    figs(3)=figure('position',SW);
    mx=max(max(drmeas),max(dr));mx=ceil(5*mx)/5;
    mx=max(1,mx);
    ml=min(length(drmeas),length(dr));
    tx=plot(drmeas(1:ml),dr(1:ml),'bx');xlabel('measured');ylabel('calculated');axis([0 mx 0 mx]);grid;
    set(tx,'markersize',8);
    set(tx,'linew',1.5);
    hold on
    if nargin>4,
        ml=min(length(drmeas),length(dr2));
        tx=plot(drmeas(1:ml),dr2(1:ml),'ro');
        set(tx,'markersize',8);
        set(tx,'linew',1.5);
        legend('dr-matstab',['dr-',label2],'location','NW');
    end
    plot([0 mx],[0 mx]);
    title(['Decay Ratio ',titel]);
end
if nargin>3
    figs(4)=figure('position',SE);
    ml=min(length(fdmeas),length(fd));
    tx=plot(fdmeas(1:ml),fd(1:ml),'bx');xlabel('measured');ylabel('calculated');axis([0 1 0 1]);grid;
    set(tx,'markersize',8);
    set(tx,'linew',1.5);
    hold on
    if nargin>4,
        ml=min(length(fdmeas),length(fd2));
        tx=plot(fdmeas(1:ml),fd2(1:ml),'ro');
        set(tx,'markersize',8);
        set(tx,'linew',1.5);
        legend('fd-matstab',['fd-',label2],'location','NW');
    end
    plot([0 1],[0 1]);
    title(['Frequency ',titel]);
end