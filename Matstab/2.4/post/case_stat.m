function [f_polca_list,ppf,frad,fax]=case_stat(s1,s2,s3,s4,s5)
%case_stat('f1');
%casse_stat('f1','f3');
%
%etc.
% listar PPF, FRAD, och FAX för Polcafiler i case_list.txt för resp. block
% VDB 2001-01-26 

if nargin==0
  error('Give plant-identifier as input')
end
			% [tmp,MATLAB_HOME]=unix('echo $MATLAB_HOME');
			% MATLAB_HOME(length(MATLAB_HOME))=[];

			% [casenr,f_polca_list,dat,qrel,hc,drmeas,fdmeas,stdmeas,modord,racsfil_list]=...
			% read_fillista([MATLAB_HOME '/matstab/input/f2/case_list.txt']);

for kk=1:nargin
  staton=eval(['s' int2str(kk)]);
  
  
			%  [casenr,f_polca_list,dat,qrel,hc,drmeas,fdmeas,stdmeas,modord,racsfil_list]=...
			%    read_fillista([MATLAB_HOME '/matstab/input/' staton '/case_list.txt']); % gammal sökväg
			
			
  [casenr,f_polca_list,dat,qrel,hc,drmeas,fdmeas,stdmeas,modord,racsfil_list]=...
     read_fillista(['/cm/' staton '/matstab/ver/input/case_list.txt']); % ny sökväg, eml 060424
			
			
			%  filename = ['ver-full-',staton,'-',remblank(datestr(now))];
			%  diary(filename)
			%  filenamelis=[filename,'.lis'];
			%  fid=fopen(filenamelis,'w');
			%  fprintf(fid,'  Verification results for %s\n',filename);
			%  fprintf(fid,'\n');
			%  fprintf(fid,' Case      File           Qrel   hc      drmeas  drmstab fdmeas  fdmstab CPU-Time(s) Real Time(s)  tol');
			%  fidd=fid;
			%  get_all_defaults;
			%  fid=fidd;
			
			
  for i=1:size(f_polca_list,1)
  
  
     			% f_polca=remblank([MATLAB_HOME,'/matstab/input/',staton,'/',f_polca_list(i,:),'.dat']); % gammal sökväg
			
			
     f_polca=remblank(['/cm/',staton,'/matstab/ver/dist/',f_polca_list(i,:),'.dat']);   % ny sökväg, eml 060424      
     p=readdist(f_polca,'power');
     ppf(i)=max(max(p));
     frad(i)=max(mean(p));
     fax(i)=max(mean(p,2));
     [dum,f_polca_name]=fileparts(f_polca);
     disp([num2str(i),' ',f_polca_name '  ' num2str([ppf(i) frad(i) fax(i)])]);
			%     if ~(exist('tol')==1), tol=[];end
			%      fprintf(fid,' %i %15s \t %5.1f  ',casenr(i),f_polca_list(i,:),qrel(i));      
			%    fprintf(fid,'%5i  %6.2f  %6.2f  %6.2f  %6.2f',round(hc(i)),drmeas(i),drmstab(i),fdmeas(i),fdmstab(i)); 
			%     fprintf(fid,'  %7i  %7i   %16g',round(Tid(i)),round(Real_time(i)),abs(tol));
			%     if ~(exist('lamh')==1), lamh=[];end
			%     for ih=1:length(lamh),
			%       [drmstab,fdmstab]=p2drfd(lamh(ih));
			%       fprintf(fid,'  %5.2f  %5.2f  ',drmstab,fdmstab);  
			%     end
			%     fprintf(fid,'\n');

  end
end

ppf = ppf(1:size(f_polca_list,1));
frad = frad(1:size(f_polca_list,1));
fax = fax(1:size(f_polca_list,1));

stat={f_polca_list ppf frad fax};
