function [data,varnam]=read_f99(f99name)
% read_f99 - Reads data from relap output file
%
% [data,varnam]=read_f99(filename)
%
% Input 
%  filename - Name on relap output file (.99)
%
% Output
%  data - data (no of time-steps by number of variables
%  varnam - Name on variables, cell array (number of variables long)
%
% Example:
%  [data,varnam]=read_f99('f3-20c.99');
%
% See also
%  read_cms

%% 
%f99name='f3-20c.99';
fid=fopen(f99name,'r');
file=fread(fid);
fclose(fid);
%% 
file(file==13)=[];
cr=find(file==10);
filehead=char(file(1:cr(4)))';
%%
fidout=fopen([f99name,'.tmp'],'w');
fprintf(fidout,'%s\n',char(file(1:cr(1)-13))');
for i=2:length(cr)-1,
    fprintf(fidout,'%s\n',char(file(cr(i-1)+1:cr(i)-13))');
end
fclose(fidout);
%%
i=4;
tmp=sscanf(char(file(cr(i)+1:cr(i+1)-13)),'%g');
lt=length(tmp);
data=nan(lt,length(cr)-4);
data(:,1)=tmp;
for i=5:length(cr)-1,
    tmp=sscanf(char(file(cr(i)+1:cr(i+1)-13)),'%g');
    if length(tmp)==lt,
        data(:,i-3)=tmp;
    else
        disp(i)
        disp(length(tmp))
    end
end
%%
rad=cell(1,4);
rad{1}=filehead(2:cr(1)-1);
for irad=2:4,
   rad{irad}=filehead(cr(irad-1)+2:cr(irad)-1);
end
%%
varnam=cell(lt,1);
for i=1:lt,
    tmpstr1=[remblank(rad{1}(1+(i-1)*13:13*i)),'_',remblank(rad{2}(1+(i-1)*13:13*i))];
    tmpstr2=[remblank(rad{3}(1+(i-1)*13:13*i)),'_',remblank(rad{4}(1+(i-1)*13:13*i))];
    varnam{i}=[tmpstr1,'_',tmpstr2];
end
 
disp(['Cleaned up file printed on ',[f99name,'.tmp']]);