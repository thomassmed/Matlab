%@(#)   ladda_burupd.m 1.3	 04/03/25     16:08:17
%
% ladda_burupd('eocfil')
% utfilen blir i dosformat.
function ladda_burupd(eocfil)
%från polca7
burnup=(readdist7(eocfil,'burnup'));
asyid=(readdist7(eocfil,'asyid'));
kcold=(readdist7(eocfil,'kcold'))';
efph=readdist7(eocfil,'efph')';
crrea=0.01500;
% crrea = ett typiskt värde på Polca7 beräknad crrea vid 25 grader
burnup=mean(burnup)'.*1000;
crkcold=kcold-crrea;

% skriva till fil
prifil=[eocfil,'-.utb'];
fid=fopen(prifil,'w');
fprintf(fid,'\n');
fprintf(fid,'   PAT.NR   MWD/TU   KCOLD  CRKCOLD  EFPH');
fprintf(fid,'\n');
for i=1:length(asyid);
fprintf(fid,' %8s%8.0f%8.3f%8.3f%8.0f\n',asyid(i,:),burnup(i),kcold(i),crkcold(i),efph(i));
%fprintf(fid,'\n');
end
fprintf(fid,'END');
fclose(fid);
