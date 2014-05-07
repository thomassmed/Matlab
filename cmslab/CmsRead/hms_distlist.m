function [distlist,Kd,Iden,NEL,WPE,Size,Ink_nr]=hms_distlist(hms_file)
% hms_distlist reads list of distributions stored on hms-file
%
% [distlist,Kd,Iden,NEL,WPE,Size,Ink_nr]=hms_distlist(hms_file)
%
% Input:
%    hms_file  - Hermes file name
%
% Output:
%    distlist - list of names of distributions stored on file
%    Kd
%    Iden
%    NEL
%    WPE      - Words Per Entry
%
% Examples:
%    distlist=hms_distlist('onldist.hms');
%    hms_file='onldist.hms';[distlist,Kd,Iden]=hms_distlist(hms_file);
%
% See also: hms_readdist, hms_pp2_read

%%
eval_string=['!PP2 ',hms_file,' LIB=matlab.pp2 VERB=0 ST=distlist'];
eval(eval_string);
%%
fid=fopen('HMS_SCRATCH.txt','r'); % open file
file = fread(fid)';     % read file
fclose(fid);            % close file
file = char(file);      % convert to ascii equivalents to characters
%% Remove line feeds from the file
lf = find(file == 13);  % find line feeds
file(lf) = [];          % remove line feeds

%% Index the carriage returns in the file
cr = find(file == 10);  % find carriage returns
%%
rad=file(cr(1)+2:cr(2)-1);
distlist=sscanf(rad(1:8),'%s');
%%
for i=2:length(cr)-1,
    rad=file(cr(i)+2:cr(i+1)-1);
    distlist=str2mat(distlist,sscanf(rad(1:8),'%s'));
end

if nargout>1,
    A=zeros(size(distlist,1),6);
    for i=1:length(cr)-1,
        rad=file(cr(i)+20:cr(i+1)-1);
        A(i,:)=sscanf(rad,'%g');
    end
    Kd=A(:,1);
    Iden=A(:,2);
    NEL=A(:,3);
    WPE=A(:,4);
    Size=A(:,5);
    Ink_nr=A(:,6);


end