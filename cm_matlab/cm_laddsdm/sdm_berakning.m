%@(#)   sdm_berakning.m 1.2   08/04/23     07:45:32
%
%function f = sdm_berakning(radnum, opnum, kref, crnum, id, knum, crit, fp, fp2, index, title)
%
%Funktionen används i ladsdm.

function index = sdm_berakning(radnum, opnum, kref, crnum, id, knum, crit, fp, fp2, index, title)
fprintf(fp, '\n _______________________________________________________________\n');
if nargin  == 11
  fprintf(fp, '\n Title    %s', title);
end

fprintf(fp, '\n Rows in shufflefile:\t%.0f', radnum);
fprintf(fp, '\n Bundle Case number:\t%.0f', opnum);
fprintf(fp, '\n Bundle Identity.\t%s', id);
fprintf(fp, '\n Moved to position:\t%0.f', knum); 
fprintf(fp, '\n ---- LADSDM ------ LADDSDM ------ LADDSDM ------ LADDSDM ----\n');
 
sum = sum2mlab7('sum.dat');    %Läser i smfilen.
sdmlista = [];
sdm = [];
flag = 0;

%Loopar igenom alla styrstavspositioner
for i = 1:length(crnum)
  if crnum(i) == 0
    sdmlista(i) = 0;
  else
    keff = sum(14, index);      %Sätter ett värde på keff från sumfilen.
    sdmlista(i) = (kref - keff)/kref * 100;    %Beräknar sdm.
    index = index + 1;
  end
end

sdm(1,:) = sdmlista(1:3);
sdm(2,:) = sdmlista(4:6);
sdm(3,:) = sdmlista(7:9);

for i = 1:size(sdm,1)
  for j = 1:size(sdm,2)
    if sdm(i,j) == 0
     fprintf(fp, '\t     ');
    else
      fprintf(fp, '\t%1.3f', sdm(i,j));
    end
  end
  fprintf(fp, '\n');
end

fprintf(fp, '__________________________________________\n');

for i = 1:size(sdm,1)
  for j = 1:size(sdm,2)
    if sdm(i,j) == 0
      fprintf(fp, '         ');
    elseif sdm(i,j) <= crit
      fprintf(fp, ' --crit--');
      flag = 1;
    else
      fprintf(fp, ' ---ok---');
    end
  end
  fprintf(fp, '\n');
end




%Skriver endast kritiska sdm.
if flag == 1
  fprintf(fp2, '\n _______________________________________________________________\n');
  if nargin  == 11
  fprintf(fp2, '\n Title    %s', title);
  end

  fprintf(fp2, '\n Rows in shufflefile:\t%.0f', radnum);
  fprintf(fp2, '\n Bundle Case number:\t%.0f', opnum);
  fprintf(fp2, '\n Bundle Identity.\t%s', id);
  fprintf(fp2, '\n Moved to position:\t%0.f', knum); 
  fprintf(fp2, '\n ---- LADSDM ------ LADDSDM ------ LADDSDM ------ LADDSDM ----\n');
 
  for i = 1:size(sdm,1)
    for j = 1:size(sdm,2)
      if sdm(i,j) == 0
       fprintf(fp2, '\t     ');
      else
        fprintf(fp2, '\t%1.3f', sdm(i,j));
      end
    end
    fprintf(fp2, '\n');
  end

  fprintf(fp2, '__________________________________________\n');

  for i = 1:size(sdm,1)
    for j = 1:size(sdm,2)
      if sdm(i,j) == 0
        fprintf(fp2, '         ');
      elseif sdm(i,j) <= crit
        fprintf(fp2, ' --crit--');
      else
        fprintf(fp2, ' ---ok---');
      end
    end
    fprintf(fp2, '\n');
  end
end
