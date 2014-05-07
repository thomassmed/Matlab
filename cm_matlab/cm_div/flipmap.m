%@(#)   flipmap.m 1.1	 99/06/02     13:25:24
%
function flipmap(filename)
% flipmap(filename);
% Denna funktion vrider safeguardfilen med pinnidentiteter 90 grader
fid=fopen(filename,'r');
fid2=fopen('printfil.txt','w');
bundleline=fgetl(fid);
fprintf(fid2,'%s',bundleline);
fprintf(fid2,'\n');
for i0=1:1000
     for i=1:10
     line1=fgetl(fid);
     if line1==-1, break;end
     line2=fgetl(fid);
     l=length(line1)+length(line2);
     helline(i,1:l)=[line1 line2];
     end

     if line1==-1, break;end

k=helline;
rad1a=[k(10,1:12) k(9,1:12) k(8,1:12) k(7,1:12) k(6,1:12) k(5,1:12)];  
rad1b=[k(4,1:12) k(3,1:12) k(2,1:12) k(1,1:12)];
%rad1=[rad1a rad1b]; 
fprintf(fid2,'%s',rad1a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad1b);
fprintf(fid2,'\n');

rad2a=[k(10,13:24) k(9,13:24) k(8,13:24) k(7,13:24) k(6,13:24)k(5,13:24)];  
rad2b=[k(4,13:24) k(3,13:24) k(2,13:24) k(1,13:24)];
%rad2=[rad2a rad2b]; 
fprintf(fid2,'%s',rad2a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad2b);
fprintf(fid2,'\n');

rad3a=[k(10,25:36) k(9,25:36) k(8,25:36) k(7,25:36) k(6,25:36)k(5,25:36)];  
rad3b=[k(4,25:36) k(3,25:36) k(2,25:36) k(1,25:36)];
%rad3=[rad3a rad3b]; 
fprintf(fid2,'%s',rad3a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad3b);
fprintf(fid2,'\n');


rad4a=[k(10,37:48) k(9,37:48) k(8,37:48) k(7,37:48) k(6,37:48)k(5,37:48)];  
rad4b=[k(4,37:48) k(3,37:48) k(2,37:48) k(1,37:48)];
%rad4=[rad4a rad4b]; 
fprintf(fid2,'%s',rad4a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad4b);
fprintf(fid2,'\n');


rad5a=[k(10,49:60) k(9,49:60) k(8,49:60) k(7,49:60) k(6,49:60)k(5,49:60)];  
rad5b=[k(4,49:60) k(3,49:60) k(2,49:60) k(1,49:60)];
%rad5=[rad5a rad5b]; 
fprintf(fid2,'%s',rad5a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad5b);
fprintf(fid2,'\n');

rad6a=[k(10,61:72) k(9,61:72) k(8,61:72) k(7,61:72) k(6,61:72)k(5,61:72)];  
rad6b=[k(4,61:72) k(3,61:72) k(2,61:72) k(1,61:72)];
%rad6=[rad6a rad6b]; 
fprintf(fid2,'%s',rad6a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad6b);
fprintf(fid2,'\n');


rad7a=[k(10,73:84) k(9,73:84) k(8,73:84) k(7,73:84) k(6,73:84)k(5,73:84)];  
rad7b=[k(4,73:84) k(3,73:84) k(2,73:84) k(1,73:84)];
%rad7=[rad7a rad7b]; 
fprintf(fid2,'%s',rad7a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad7b);
fprintf(fid2,'\n');


rad8a=[k(10,85:96) k(9,85:96) k(8,85:96) k(7,85:96) k(6,85:96)k(5,85:96)];  
rad8b=[k(4,85:96) k(3,85:96) k(2,85:96) k(1,85:96)];
%rad8=[rad8a rad8b]; 
fprintf(fid2,'%s',rad8a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad8b);
fprintf(fid2,'\n');


rad9a=[k(10,97:108) k(9,97:108) k(8,97:108) k(7,97:108) k(6,97:108)k(5,97:108)];  
rad9b=[k(4,97:108) k(3,97:108) k(2,97:108) k(1,97:108)];
%rad9=[rad9a rad9b]; 
fprintf(fid2,'%s',rad9a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad9b);
fprintf(fid2,'\n');

rad10a=[k(10,109:120) k(9,109:120) k(8,109:120) k(7,109:120) k(6,109:120)k(5,109:120)];  
rad10b=[k(4,109:120) k(3,109:120) k(2,109:120) k(1,109:120)];
%rad10=[rad10a rad10b]; 
fprintf(fid2,'%s',rad10a);
fprintf(fid2,'\n');
fprintf(fid2,'%s',rad10b);
fprintf(fid2,'\n');


bundleline=fgetl(fid);
	if bundleline==-1,break
	else
	fprintf(fid2,'%s',bundleline);
	fprintf(fid2,'\n');
	end
end
disp('klart! resultat på printfil.txt');
