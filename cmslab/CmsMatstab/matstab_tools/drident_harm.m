function [dro,fdo,drs,sca,e_meas,symdet,fftlprm,drg,fdg]=drident_harm(lprm,detloc,Ts,aprm)
% drident - try to find the out-of-phase mode from data
%
% [dro,fdo,drs,sca,e_meas,symdet,fftlprm,drg,fdg]=drident_harm(lprm,detloc,Ts[,aprm])

% It's a bloody hard task
% Started to write: Thomas Smed, May 2009
% Projected finish: Way later, hopefully with help from some guys smarter than me
%%
[idet,jdet,ndet]=find(detloc);
idetmax=size(detloc,1);
isym=idetmax+1-idet;
jsym=idetmax+1-jdet;
%% 
symdet=zeros(max(ndet),5);
Symdet=symdet;
D=zeros(max(ndet),1);
for i=1:length(ndet),
    di=isym(i)-idet;
    dj=jsym(i)-jdet;
    distans=abs(dj)+abs(di);
    dmin=min(distans);
    D(ndet(i))=dmin;
    imin=find(distans==dmin);
    symdet(ndet(i))=ndet(i);
    Symdet(ndet(i))=ndet(i);
    imindet=ndet(imin)';
    iimindet=find((imindet-ndet(i))>0);
    symdet(ndet(i),2:length(imin)+1)=imindet;
    Symdet(ndet(i),2:length(iimindet)+1)=imindet(iimindet);
end
%% 
if nargin<4,
    Aprm_M=mean(lprm,2);
    fftAprm=fft(detrend(Aprm_M),2048);
    e_meas=tt2eigvec(Aprm_M,lprm,Ts);
else
   % e_meas=tt2eigvec(aprm,lprm,Ts);
   e_meas=0;
    fftAprm=fft(detrend(aprm),2048);
end
fftlprm=fft(detrend(lprm),2048);
range_min=round(Ts*2048*.4);
range_max=round(Ts*2048*.7);
fftlprm_mean=mean(abs(fftlprm),2);
%[x,ia]=max(abs(fftAprm(range_min:range_max)));
[x,ia]=max(abs(fftlprm_mean(range_min:range_max)));
ia=ia+range_min-1
%% Pre-analysis
in_phase=0;
out_of_phase=0;
no_corr=0;
fdo=symdet;dro=symdet;drs=symdet;sca=symdet;calc_glob=zeros(size(symdet));
fdg=fdo;drg=dro;
calc_out_of_phase=calc_glob;
for i=1:max(ndet),
    for j=2:size(Symdet,2)
        if Symdet(i,j)&&any(lprm(:,i)),
            jj=Symdet(i,j);
            if any(lprm(:,jj))
            sca(i,j)=fftlprm(ia,i)/fftlprm(ia,jj);
            %sca(i,j)=e_meas(i)/e_meas(jj);
            Sca=abs(sca(i,j));
            ang_sca=angle(sca(i,j));
            %Sca=1;ang_sca=0;  % Short circuit the tests
            %fprintf(1,' lprm%i - %5.2f * lprm%i \n',i,Sca,jj);
            if Sca>.2&&Sca<5
                if abs(ang_sca)<.3,
                    in_phase=in_phase+1;
                    calc_out_of_phase(i,j)=2;
                    calc_glob(i,j)=1;
                elseif abs(abs(ang_sca)-pi)<0.3
                    out_of_phase=out_of_phase+1;
                    calc_glob(i,j)=2;
                    calc_out_of_phase(i,j)=1;
                else
                    no_corr=no_corr+1;
                end
            else
                no_corr=no_corr+1;
            end
            else
                Symdet(i,j)=0;
            end
        else
            Symdet(i,j)=0;
         end
    end
end
%%
fprintf(1,'Summary of global and out_of_phase pairs \n');
fprintf(1,'Total in_phase: %i Total out-of-phase %i Uncorrelated %i',in_phase,out_of_phase,no_corr)
fprintf(1,'\n');
%%   
for i=1:max(ndet),
    for j=2:size(Symdet,2)
        jj=Symdet(i,j);
        if calc_glob(i,j)
            Sca=abs(sca(i,j));
            ang_sca=angle(sca(i,j));
            %Sca=1;ang_sca=0;  % Short circuit the tests
            if calc_glob(i,j)==2,
                fprintf(1,'Lprms are out-of-phase \n');
                fprintf(1,'Angle = %i \n',round(ang_sca*180/pi));
            else
                fprintf(1,'Lprms are in phase \n');
            end
            fprintf(1,'Out-of-phase mode: \n');
            fprintf(1,' lprm%i - %5.2f * lprm%i \n',i,Sca,jj);
            [dro(i,j),fdo(i,j),drs(i,j)]=drident(lprm(:,i)-Sca*lprm(:,jj),Ts);
            fprintf(1,'Global mode: \n');
            fprintf(1,' lprm%i + %5.2f * lprm%i \n',i,Sca,jj);
            [drg(i,j),fdg(i,j)]=drident(lprm(:,i)+Sca*lprm(:,jj),Ts);
        elseif Symdet(i,j)
            fprintf(1,'Only calculate global mode \n');
            fprintf(1,' lprm%i + %5.2f * lprm%i \n',i,1,jj);
            [drg(i,j),fdg(i,j)]=drident(lprm(:,i)+lprm(:,jj),Ts);
        end
    end
end