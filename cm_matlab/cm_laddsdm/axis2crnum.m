%@(#)   axis2crnum.m 1.2   08/04/23     07:44:04
%
%function vec = axis2crnum(bocfil, axstr)
%
%Funktionen används i ladsdm.
function vec = axis2crnum(bocfil, axstr)
[idlista, mminj, konrod, bb, hy , mz] = readdist7(bocfil, 'asyid');    %Läser in asyidlista, mminj och mz.
fprintf(1, '\n\n\n');
cpos = axis2cpos(axstr);        %Beräknar koordinaten för identiteten från axiskoordinater.
knum = cpos2knum(cpos, mminj);
crpos = cpos2crpos(cpos, mminj);      %Beräkanar koordinaten för styrstaven.
sizecrpos = size(crpos);        %Beräknar storleken på styrstanvkoordinaten.
remove = 0;
if sizecrpos(1) == 1 & sizecrpos(2) == 0      %Om identiteten inte har någon styrstav.
  if cpos(2) <= 15          %Om identitetens koordinater är mindre eller lika med 15.
    knum = knum + 2;        %Tar en annan bränslepatron.
    cpos = knum2cpos(knum, mminj);
    crposprov = cpos2crpos(cpos, mminj);    %Provisorisk styrstavskoordinat.
    crpos = [crposprov(1), crposprov(2) - 1];  %Den riktaiga koordinaten.
    remove = 1;
  else
    knum = knum - 2;        %Tar en annan bränslepatron.
    cpos = knum2cpos(knum, mminj);
    crposprov = cpos2crpos(cpos, mminj);    %Provisorisk styrstavskoordinat.
    crpos = [crposprov(1), crposprov(2) + 1];  %Den riktaiga koordinaten.
    remove = 1;
  end
end
%Beräknar koordinater för runtliggande styrstavar.
right = [crpos(1), crpos(2) + 1];
left = [crpos(1), crpos(2) - 1];
up = [crpos(1) - 1, crpos(2)];
down = [crpos(1) + 1, crpos(2)];
rightup = [crpos(1) - 1, crpos(2) + 1];
rightdown = [crpos(1) + 1, crpos(2) + 1];
leftup = [crpos(1) - 1, crpos(2) - 1];
leftdown = [crpos(1) + 1, crpos(2) - 1];
for i = 0:16        %Loopar igenom över och underkanter för att ta bort rundligande styrstavar som inte finns.
  if leftup == [0,i]
    leftup = 0;
  end
  if up == [0,i]
    up = 0;
  end
  if rightup == [0,i]
    rightup = 0;
  end
  if leftdown == [16,i]
    leftdown = 0;
  end
  if down == [16,i]
    down = 0;
  end
  if rightdown == [16,i]
    rightdown = 0;
  end
end
%Skapar två vektorer som motsvarar platser där rundliggande styrstavskoordinater ska tas bort för f1 och f2.
if mz(14) == 676;
  removeleft = [6 4 2 2 1 1 0 0 0 1 1 2 2 4 6];
  removeright = [10 12 14 14 15 15 16 16 16 15 15 14 14 12 10];
%Skapar två vektorer som motsvarar platser där rundliggande styrstavskoordinater ska tas bort för f3.
elseif mz(14) == 700;
  removeleft = [6 3 2 1 1 1 0 0 0 1 1 1 2 3 6];
  removeright = [10 13 14 15 15 15 16 16 16 15 15 15 14 13 10];
end
%Vänster sida.
for i = 1:15
  for j = 0:removeleft(i)      %Loopar igenom rader och kolonner för att ta bort extra rundliggande styrstavar som inte finns.
    if leftup == [i, j]
      leftup = 0;    %Sätter dem lika med noll.
    end
    if left == [i, j]
      left = 0;
    end
    if leftdown == [i, j]
      leftdown = 0;
    end
    if up == [i, j]
      up = 0;
    end
    if down == [i, j]
      down = 0;
    end
    if rightup == [i, j]
      rightup = 0;
    end
    if rightdown == [i, j]
      rightdown = 0;
    end
  end
end
%Höger sida.
for i = 1:15
  for j = removeright(i):16    %Loopar igenom rader och kolonner för att ta bort extra rundliggande styrstavar som inte finns.
    if rightup == [i, j]
      rightup = 0;    %Sätter dem lika med noll.
    end
    if right == [i, j]
      right = 0;
    end
    if rightdown == [i, j]
      rightdown = 0;
    end
    if up == [i, j]
      up = 0;
    end
    if down == [i, j]
      down = 0;
    end
    if leftup == [i, j]
      leftup = 0;
    end
    if leftdown == [i, j]
      leftdown = 0;
    end
  end
end
if remove == 1          %Sätter crpos till noll när angivna identitetten inte har någon stystav.
  crnum = 0;
else            %Annars beräknas styrstavsnummret.
  crnum = crpos2crnum(crpos, mminj);
end
%Beräkning av styrstavsnummer om inte koordinaterna är satta till noll.
if right ~= 0
  right  = crpos2crnum(right, mminj);
end
if left ~= 0
  left = crpos2crnum(left, mminj);
end
if up ~= 0
  up = crpos2crnum(up, mminj);
end
if down ~= 0
  down = crpos2crnum(down, mminj);
end
if rightup ~= 0
  rightup = crpos2crnum(rightup, mminj);
end
if rightdown ~= 0
  rightdown = crpos2crnum(rightdown, mminj);
end
if leftup ~= 0
  leftup = crpos2crnum(leftup, mminj);
end
if leftdown ~= 0
  leftdown = crpos2crnum(leftdown, mminj);
end
vec = [leftup, up, rightup, left, crnum, right, leftdown, down, rightdown];
fprintf(1, '\n\n\n');
