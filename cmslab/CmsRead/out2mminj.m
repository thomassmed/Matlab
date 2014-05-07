function mminj=out2mminj(blob,iafull)

%% Read file if filename
if length(blob)<100, 
    fid = fopen(blob);      % open file
    blob = fread(fid)';     % read file
    fclose(fid);            % close file
    blob = char(blob);      % convert to ascii equivalents to characters
end
%%
if nargin<2,
    [kmax,iafull,irmx,ilmx,nref,ihave,iofset,if2x2,ida,jda]=out2param(blob);
end
%% find out the number of cols
lf=find(blob==13);
blob(lf)=[];
cr=find(blob==10);
iE=strfind(blob,[10,' PRI.STA 2RPF ']);
if ~isempty(iE),
    icr=find(cr>iE(1),1);
    cols=sscanf(blob(cr(icr)+5:cr(icr+1)-3),'%i');
    mminj=zeros(iafull,1);
    for i=1:length(cols),
        rad=blob(cr(icr+i)+5:cr(icr+1+i)-4);
        mminj(i,1)=length(cols)-length(sscanf(rad,'%g'))+1;
    end
    for i=length(cols)+1:iafull,
        mminj(i)=mminj(iafull-i+1);
    end
else
    mminj=0;
end
%% Extra safety
if max(mminj)==0,
   iE=strfind(blob,'Opening restart file:');
   if numel(iE)==0,
       iE=strfind(blob,'OPENING RESTART FILE');
   end
   icr=find(cr>iE(1),1);
   restart_file=deblank(char(blob(iE(1)+21:cr(icr)-1)));
   resinfo=ReadRes(restart_file,'nodata');
   mminj=resinfo.core.mminj;
   disp('Reading core contour (mminj) from restart file')
end




    
    

