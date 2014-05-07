function konrod=read_crdpos(blob,crmminj)
% Reads CRD.POS from an input file
%
% konrod=read_crdpos(blob,crmminj)
% or
% konrod=read_crdpos(filename,crmminj)
%
% Input
%   blob - Textstring to be parsed (or filename)
%   crmminj - Control rod contour vector
%
%  Output
%   konrod - vector of control rod positions
%
% Example:
%   fue_new=read_restart_bin('s3.res');
%   konrod=read_crdpos('s3.inp',fue_new.crmminj);
%   blob=read_simfile('s3.inp');
%   konrod=read_crdpos(blob,crmminj);
%
% See also get_card, read_simfile, read_restart_bin
%  

% Copyright Studsvik Scandpower 2009

%%

lf= blob==13; % Get rid of line feed
blob(lf)=[];
cr=find(blob==10);

if isempty(cr),
    blob=read_simfile(blob);
    cr=find(blob==10);
end 

card=[10,'''','CRD.POS',''''];

istart=strfind(blob,card);

if isempty(istart), konrod=[]; return;end


% Note the programming below is not absolutely water proof.
% construct counterexamples that will break
if length(istart)>1, %Deals with the case when CRD.POS is given on every row:
%'CRD.POS' 1 6*0                      100 100 100                      6*0/
%'CRD.POS' 2 3*0          100 100 100 100 100 100 100 100 100          3*0/ etc 
    konrod=ReadCrd(blob2cell(blob),crmminj);
else  %Deals with the case when only one CRD.POS card is given and all the data follows:
%'CRD.POS' 1
%6*0                      100 100 100                      6*0
%3*0          100 100 100 100 100 100 100 100 100          3*0  etc
    nrows=length(crmminj);
    icr=find(cr>istart,1,'first');
    aaa=[];
    for i=1:nrows,  % This can probably be solved in a more elegant way
        rad=blob(cr(icr+i-1)+1:cr(icr+i)-1);
        aa=[];
        while ~isempty(rad),
            [a,count,errmsg,nextindex]=sscanf(rad,'%i');
            aa=[aa;a];
            rad=rad(nextindex:end);
            if length(a)==nrows, break;end
            if isempty(rad), break;end
            if strcmp(rad(1),'*'),
                rad(1)=[];
                [amul,rad]=parse_star(rad);
                la=length(aa);na=aa(la);
                aa(la:la+na-1,1)=amul;
            end
        end
        aaa=[aaa;aa];
    end
    aaa=reshape(aaa,nrows,nrows)'; % Transpose neccesary
    konrod=cor2vec(aaa,crmminj);
end
        

    

function [amul,rad]=parse_star(rad) 
[amul,count,errms,nextindex]=sscanf(rad,'%i',1);
rad=rad(nextindex:end);
