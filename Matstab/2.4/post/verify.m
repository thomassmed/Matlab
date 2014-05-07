%function verify(varargin)
%
% Runs verification cases for selected reactors
%
% Examples:
%
% verify('f1');
% verify('f1','f3');
% verify('f1','test') Only runs the initilazation of matstab 
%                    to test if all files etc are OK
%
function verify(varargin)

CM_HOME=['/cm'];

t0=cputime;

if nargin==0
  error('Give plant-identifier as input')
end

if find(strcmp('test',varargin))
  varargin(find(strcmp('test',varargin)))=[];
  testonly=1;
else
  testonly=0;
end

if find(strcmp('p7_4501',varargin))
  varargin(find(strcmp('p7_4501',varargin)))=[];
  ver_4501=1;
else
  ver_4501=0;
end

for kk=1:length(varargin)
  staton=varargin{kk};
%  staton=eval(['s' int2str(kk)]);
  [casenr,f_polca_list,dat,qrel,hc,drmeas,fdmeas,stdmeas,modord,racsfil_list]=...
    read_fillista([CM_HOME,filesep,staton,'/matstab/ver/input/case_list.txt']);
  filename = ['ver-full-',staton,'-',remblank(datestr(now))];
  filenamelis=[filename,'.lis'];
  fid=fopen(filenamelis,'w');
  fprintf(fid,'  Verification results for %s\n',filename);
  fprintf(fid,'\n');
  fprintf(fid,' Case      File           Qrel   hc      drmeas  drmstab fdmeas  fdmstab CPU-Time(s) Real Time(s)  MaxAx(node 1-15)(polca-matstab)');
  fprintf(fid,'\n');
  for i=1:size(f_polca_list,1)
     t=cputime;
     
     if ver_4501
       compfile=remblank([CM_HOME,filesep,remblank(staton),'/matstab/ver/input/matstab/matstab-p7_4501-',f_polca_list(i,:),'.txt']);
       mstabfile=remblank([pwd(),filesep(),'p7_4501-', f_polca_list(i,:),'.mat']);
       f_polca=remblank([CM_HOME,filesep,staton,'/matstab/ver/dist/p7_4501-',f_polca_list(i,:)]);
     else 
       compfile=remblank([CM_HOME,filesep,remblank(staton),'/matstab/ver/input/matstab/matstab_',f_polca_list(i,:),'.txt']); 
       mstabfile=remblank([pwd(),filesep(),f_polca_list(i,:),'.mat']);
       f_polca=remblank([CM_HOME,filesep,staton,'/matstab/ver/dist/',f_polca_list(i,:)]);
     end  
     
     disp([num2str(i),' ',f_polca]);

     if testonly
       matstab(f_polca,'SteadyState','off','Global','off')
       fidpri=fopen(filename,'a');
       global msopt
       load(msopt.MstabFile,'mstabprint');
       fprintf(fidpri,mstabprint);
	   fprintf(fid,' %i %15s\t Input data OK\n',casenr(i),f_polca_list(i,:)); 
       fclose(fidpri);
     else
       t00=clock;
       
       matstab(compfile,'MstabFile',mstabfile);	 
       	   
       fidpri=fopen(filename,'a');
       global msopt
       load(msopt.MstabFile,'mstabprint');
       fprintf(fidpri,mstabprint);
       fclose(fidpri);
       global stab
       lam(i)=stab.lam;
       [drmstab,fdmstab]=p2drfd(lam);
       Real_time(i)=etime(clock,t00);
       Tid(i)=cputime-t;
       [drmstab,fdmstab]=p2drfd(lam);
       f_matstab=strip(f_polca);
       iii=findstr(f_matstab,'.dat');
       if length(iii)>0, f_matstab(iii:iii+3)=[];end
       f_matstab=remblank(f_matstab);

       % get maximum deviations
       global steady msopt
       power=readdist(msopt.DistFile,'POWER');
       [maxax,iax]=max(abs(mean(power(1:15,:)')-mean(steady.Ppower(1:15,:)')));
       maxax=mean(power(1:15,:)')-mean(steady.Ppower(1:15,:)');
% %     maxrad=max(abs(mean(power)-mean(steady.Ppower)));

       %Print results
       fprintf(fid,' %i %15s \t %5.1f  ',casenr(i),f_polca_list(i,:),qrel(i));      
       fprintf(fid,'%5i  %6.2f  %6.2f  %6.2f  %6.2f',round(hc(i)),drmeas(i),drmstab(i),fdmeas(i),fdmstab(i)); 
       fprintf(fid,'  %7i  %7i   %16g',round(Tid(i)),round(Real_time(i)));
       fprintf(fid,'  %6.2f',maxax(iax));

       fprintf(fid,'\n');
     end
  end
end
fclose(fid);
diary off

save(filename);


%@(#)   verify.m 1.3   97/09/16     13:54:36
