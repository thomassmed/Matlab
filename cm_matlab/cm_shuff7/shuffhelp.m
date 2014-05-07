%@(#)   shuffhelp.m 1.1	 05/07/13     10:29:41
%

function shuffhelp

fprintf('\n\n\n');

fprintf('Shuffle7 är en program för att skapa laddsheman.');
fprintf('\n\n');

fprintf('BOC-FILE:\n');
fprintf('Ange nästkommande cykels bocfil.');
fprintf('\n\n');

fprintf('MAKE POOLFILE:\n');
fprintf('Ange motsvarande safeguardfil till den poolfil som ska skapas.\n');
fprintf('Detta behövs endast göras när första laddshemat görs. Poolfilen\n');
fprintf('kommer att få namnet poolfil.mat.');
fprintf('\n\n');

fprintf('POOLFILE:\n');
fprintf('Ange den poolfil som ska arbetas med.');
fprintf('\n\n');

fprintf('MANUAL SHUFFLE:\n');
fprintf('Om ingen poolfil angivits kommer en varningsruta upp och det\n');
fprintf('kommer att fungera att arbeta utan bassängerna.\n');
fprintf('Om en poolfil har angivits frågas det efter en bunhistfil. Det\n');
fprintf('är en .mat fil med bl.a. en lista över identitetsnummer på de\n');
fprintf('gamla patroner som står i bassängerna och i härden.\n');
fprintf('I menyn väljs hur många pilar som ska visas eller om manual\n');
fprintf('shuffle ska avslutas. Pliar kan även visas om valet är 0 med\n');
fprintf('musklikningar.');
fprintf('\n\n');

fprintf('Färger:\tBlå - ska ej flyttas.\n');
fprintf('\tGul - ska flyttas inom härden\n');
fprintf('\tRöd - ska flyttas till bassängen.\n');
fprintf('\tVit - vattenhål.\n');
fprintf('\tGrön - patronens tillposition är tom.\n');
fprintf('\tGrå - position för sensat flyttatde patron (vattenhål)\n');
fprintf('\tLjusblå - position för sensat flyttatde patron\n');
fprintf('\t         (står i härden)');
fprintf('\n\n');

fprintf('Bassäng: Orange - utbränd patron.\n');
fprintf('\t Grön - färsk patron.\n');
fprintf('\t X - position som ej ska användas\n');
fprintf('\t - - portar, endast färka patron får placeras där.');
fprintf('\n\n');

fprintf('Musklick inom härden:\n');
fprintf('Vänster - Skyfflar bränsle till/från position inom härden.\n');
fprintf('Höger -\t  Laddar bränsle till/från bassäng.\n');
fprintf('\t  Om bassänger används så klicka på patronen i härden och\n');
fprintf('\t  välj sedan bassäng. Kicka vart i bassängen patronen ska\n');
fprintf('\t  placeras.\n');
fprintf('Mitten -  Visar förflyttningspilar för patronen och den kedja\n');
fprintf('\t  som patronen ingår i. Patronen får en lila pil, de andra\n');
fprintf('\t  svarta. Klicka på någon av patronerna igen för att ta\n');
fprintf('\t  bort pilarna.');
fprintf('\n\n');

fprintf('Musklick utanför härden:\n');
fprintf('Vänster - Gåt tillbakas till menyn.\n');
fprintf('Höger -\t  Ångra senaste förflyttning.\n');
fprintf('Mitten -  Uppdatera skärmen');
fprintf('\n\n');

fprintf('För att avsluta manual shuffle gå tillbaks till menyn och välj\n');
fprintf('-1 för att avsluta. Skriv i filnamnet på det laddshema som\n');
fprintf('skapats. Välj om det ska adderas till ett gammalt eller sparas\n');
fprintf('som ett nytt genom att ange A eller S.');
fprintf('\n\n');

fprintf('UPDATE FROM INFIL:\n');
fprintf('Eocfilen och poolfilen som används uppdateras efter befintligt\n');
fprintf('laddshema.\n');
fprintf('Om bassängerna används så ange poolfilen under poolfile innan\n');
fprintf('uppdateringen. Sedan anges filnamnet på laddshemat under menyn\n');
fprintf('Update from infil.');
fprintf('\n\n');

fprintf('MONITOR:\n');
fprintf('Visar steg för steg hur den skapade förflyttningen sker. Ange\n');
fprintf('filnamnet på laddshemat');
fprintf('\n\n');

fprintf('FIND:\n');
fprintf('Ange identitestnummer på en sökt patron i härden. Om den\n');
fprintf('sökta patronen finns i härden kommer den att markeras med en\n');
fprintf('lila fyrkant i 5 sekunder.');
fprintf('\n\n');

fprintf('HELP:\n');
fprintf('Texten som visas nu.');
fprintf('\n\n\n');


