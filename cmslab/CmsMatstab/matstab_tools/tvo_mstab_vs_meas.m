function [e_meas,e_mstab,lprm,aprm,efi2]=tvo_mstab_vs_meas(mstabfile,matfile)
% tvo_vs_meas - compares measured eigenvectors with calculated
%
% [e_meas,e_mstab,lprm,aprm,efi2]=tvo_mstab_vs_meas(mstabfile,matfile)
%
% Input:
%   mstabfile - matstab result file
%   matfile   - measurement file, tvo
%
% Output
%    e_meas  - measured phasors
%    e_mstab - calculated phasors
%  

mstabfile=cellstr(mstabfile);
matfile=cellstr(matfile);
%%
for i=1:length(mstabfile),
    fprintf(1,'Matstab file:     %s \n',mstabfile{i});
    fprintf(1,'Measurement file: %s \n',matfile{i});
    x=who('-file',matfile{i});
    if length(x)==1,
        load(matfile{i});
        MeasLoad=1;
    else
        MeasLoad=0;
        [lprm,aprm,Ts]=tvo_LPRM(matfile{i});
        if exist('armax.m','file'),
            [e_meas,e_meas1]=tt2eigvec(aprm.Values(:,1),lprm.Values,Ts);
        else
            fftlprm=fft(detrend(lprm.Values),528);
            [maxfft,Ifft]=max(abs(fftlprm));
            ifft=median(Ifft);
            e_meas=fftlprm(ifft,:);
        end
        if length(lprm.Name)<112,
            e_meas=fill_in(lprm.Name,e_meas);
        end
        e_meas=reshape(e_meas,4,length(e_meas)/4);
    end

    
    e_bot=e_meas(:);e_bot=e_bot(4:4:end);
    [xx,ii]=max(abs(e_bot));ii=4*ii;
    e_meas=e_meas/e_meas(ii);
    i0=find(e_meas==0);
    
    [pathstr, name, ext, versn] = fileparts(mstabfile{i});
    switch ext
        case '.mat'
            [e_mstab,efi2]=get_lprm_eigvec(mstabfile{i});
            hfig=cmsplot(mstabfile{i},abs(efi2));
        case '.cms'
            cmsinfo=read_cms(mstabfile{i});
            t=read_cms_scalar(cmsinfo,1);
            Lprm=read_cms_scalar(cmsinfo,'LPRM');
            Lprm=Lprm';t=t';
            %itid=t>10;lprm(itid,:)=[];t(itid)=[];
            [dr,fd]=read_drfd_s3kout(strrep(mstabfile{i},'.cms','.out'));
            [e_mstab,xest,xx,tx,drx,fdx,p,p0]=get_phasor(t,Lprm,dr,fd,5);
            
            e_mstab=reshape(e_mstab,4,length(e_mstab)/4);
            e_mstab=e_mstab(4:-1:1,:);
            if size(cmsinfo.DistNames,1)>1, % Assume there are a 3D or 2D disttribution
                plotfile=mstabfile{i};
            else  %If there is no 3D or 2D dist, use the restart_file
                inpfile=strrep(mstabfile{i},'.cms','.inp');
                blob=read_simfile(inpfile);
                rescard=get_card(blob,'RES');
                plotfile=rescard{1};
            end
            hfig=cmsplot(plotfile);
    end
    e_mstab=e_mstab*e_meas(ii)/e_mstab(ii);
    e_mstab(i0)=0;
  
    tilt=exp(-1j*pi/6); % 30 degree tilt to improve visibility
    add_phasors(e_meas*tilt,e_mstab*tilt,hfig,ii)
end



