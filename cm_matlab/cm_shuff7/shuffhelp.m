%@(#)   shuffhelp.m 1.1	 05/07/13     10:29:41
%

function shuffhelp

fprintf('\n\n\n');

fprintf('Shuffle7 �r en program f�r att skapa laddsheman.');
fprintf('\n\n');

fprintf('BOC-FILE:\n');
fprintf('Ange n�stkommande cykels bocfil.');
fprintf('\n\n');

fprintf('MAKE POOLFILE:\n');
fprintf('Ange motsvarande safeguardfil till den poolfil som ska skapas.\n');
fprintf('Detta beh�vs endast g�ras n�r f�rsta laddshemat g�rs. Poolfilen\n');
fprintf('kommer att f� namnet poolfil.mat.');
fprintf('\n\n');

fprintf('POOLFILE:\n');
fprintf('Ange den poolfil som ska arbetas med.');
fprintf('\n\n');

fprintf('MANUAL SHUFFLE:\n');
fprintf('Om ingen poolfil angivits kommer en varningsruta upp och det\n');
fprintf('kommer att fungera att arbeta utan bass�ngerna.\n');
fprintf('Om en poolfil har angivits fr�gas det efter en bunhistfil. Det\n');
fprintf('�r en .mat fil med bl.a. en lista �ver identitetsnummer p� de\n');
fprintf('gamla patroner som st�r i bass�ngerna och i h�rden.\n');
fprintf('I menyn v�ljs hur m�nga pilar som ska visas eller om manual\n');
fprintf('shuffle ska avslutas. Pliar kan �ven visas om valet �r 0 med\n');
fprintf('musklikningar.');
fprintf('\n\n');

fprintf('F�rger:\tBl� - ska ej flyttas.\n');
fprintf('\tGul - ska flyttas inom h�rden\n');
fprintf('\tR�d - ska flyttas till bass�ngen.\n');
fprintf('\tVit - vattenh�l.\n');
fprintf('\tGr�n - patronens tillposition �r tom.\n');
fprintf('\tGr� - position f�r sensat flyttatde patron (vattenh�l)\n');
fprintf('\tLjusbl� - position f�r sensat flyttatde patron\n');
fprintf('\t         (st�r i h�rden)');
fprintf('\n\n');

fprintf('Bass�ng: Orange - utbr�nd patron.\n');
fprintf('\t Gr�n - f�rsk patron.\n');
fprintf('\t X - position som ej ska anv�ndas\n');
fprintf('\t - - portar, endast f�rka patron f�r placeras d�r.');
fprintf('\n\n');

fprintf('Musklick inom h�rden:\n');
fprintf('V�nster - Skyfflar br�nsle till/fr�n position inom h�rden.\n');
fprintf('H�ger -\t  Laddar br�nsle till/fr�n bass�ng.\n');
fprintf('\t  Om bass�nger anv�nds s� klicka p� patronen i h�rden och\n');
fprintf('\t  v�lj sedan bass�ng. Kicka vart i bass�ngen patronen ska\n');
fprintf('\t  placeras.\n');
fprintf('Mitten -  Visar f�rflyttningspilar f�r patronen och den kedja\n');
fprintf('\t  som patronen ing�r i. Patronen f�r en lila pil, de andra\n');
fprintf('\t  svarta. Klicka p� n�gon av patronerna igen f�r att ta\n');
fprintf('\t  bort pilarna.');
fprintf('\n\n');

fprintf('Musklick utanf�r h�rden:\n');
fprintf('V�nster - G�t tillbakas till menyn.\n');
fprintf('H�ger -\t  �ngra senaste f�rflyttning.\n');
fprintf('Mitten -  Uppdatera sk�rmen');
fprintf('\n\n');

fprintf('F�r att avsluta manual shuffle g� tillbaks till menyn och v�lj\n');
fprintf('-1 f�r att avsluta. Skriv i filnamnet p� det laddshema som\n');
fprintf('skapats. V�lj om det ska adderas till ett gammalt eller sparas\n');
fprintf('som ett nytt genom att ange A eller S.');
fprintf('\n\n');

fprintf('UPDATE FROM INFIL:\n');
fprintf('Eocfilen och poolfilen som anv�nds uppdateras efter befintligt\n');
fprintf('laddshema.\n');
fprintf('Om bass�ngerna anv�nds s� ange poolfilen under poolfile innan\n');
fprintf('uppdateringen. Sedan anges filnamnet p� laddshemat under menyn\n');
fprintf('Update from infil.');
fprintf('\n\n');

fprintf('MONITOR:\n');
fprintf('Visar steg f�r steg hur den skapade f�rflyttningen sker. Ange\n');
fprintf('filnamnet p� laddshemat');
fprintf('\n\n');

fprintf('FIND:\n');
fprintf('Ange identitestnummer p� en s�kt patron i h�rden. Om den\n');
fprintf('s�kta patronen finns i h�rden kommer den att markeras med en\n');
fprintf('lila fyrkant i 5 sekunder.');
fprintf('\n\n');

fprintf('HELP:\n');
fprintf('Texten som visas nu.');
fprintf('\n\n\n');


