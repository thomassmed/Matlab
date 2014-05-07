%@(#)   updatbp.m 1.2	 10/09/09     10:39:22
%
%
%function updatbp(distfil,buidnt,to,bocfil,dumbun,dumburn);
%Update distribution file with moves 
%to may be a (n by 1)-vector of channel numbers or a vector of
%or        a (n by 2)-vector of channel positions
%dumburn and dummy may be omitted if there are dummies on file
function updatbp(distfil,buidnt,to,bocfil,dumbun,dumburn);
[burnup,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist7(distfil,'burnup');		
[burnboc,mminj,konrod,bb,hy,mz,ks,bunboc]=readdist7(bocfil,'burnup');		
[it,jt]=size(to);
if it<3&jt>2, to=to';end
if nargin<6,
  buid=readdist7(distfil,'asyid');
  j=strmatch('vat',buid);
  if length(j)>0,
    jdum=j(1);
    dumbun=buntyp(jdum,:);
    if nargin<6
      dumburn=mean(burnup(:,jdum));
    end
  end
end
for i=1:4,
  if length(dumbun)<4,
    dumbun=[' ',dumbun];		%Mellanslag
  end
end
BUIDNT=readdist7(distfil,'asyid');

%Uppdaterad
%History
BURSID = readdist7(distfil, 'bursid');
BURCOR = readdist7(distfil, 'burcor');
DNSHIS = readdist7(distfil, 'dnshis');
CRHIS = readdist7(distfil, 'crhis');
CRHFRC = readdist7(distfil, 'crhfrc');
CREIN = readdist7(distfil, 'CREIN');
CREOUT = readdist7(distfil, 'CREOUT');
EFPH = readdist7(distfil, 'EFPH');
SIHIS = readdist7(distfil, 'SIHIS');
SIHSID = readdist7(distfil, 'SIHSID');
SIHCOR = readdist7(distfil, 'SIHCOR');
U235 = readdist7(distfil, 'u235');
U236 = readdist7(distfil, 'u236');
U238 = readdist7(distfil, 'u238');
Np239 = readdist7(distfil, 'np239');
Pu239 = readdist7(distfil, 'pu239');
Pu240 = readdist7(distfil, 'pu240');
Pu241 = readdist7(distfil, 'pu241');
Pu242 = readdist7(distfil, 'pu242');
Am241 = readdist7(distfil, 'am241');
Am242 = readdist7(distfil, 'am242');
Ru103 = readdist7(distfil, 'ru103');
Rh103 = readdist7(distfil, 'rh103');
Rh105 = readdist7(distfil, 'rh105');
Ce143 = readdist7(distfil, 'ce143');
Pr143 = readdist7(distfil, 'pr143');
Nd143 = readdist7(distfil, 'nd143');
Nd147 = readdist7(distfil, 'nd147');
Pm147 = readdist7(distfil, 'pm147');
Pm148 = readdist7(distfil, 'pm148');
Pm148m = readdist7(distfil, 'pm148m');
Pm149 = readdist7(distfil, 'pm149');
Sm147 = readdist7(distfil, 'sm147');
Sm149 = readdist7(distfil, 'sm149');
Sm150 = readdist7(distfil, 'sm150');
Sm151 = readdist7(distfil, 'sm151');
Sm152 = readdist7(distfil, 'sm152');
Sm153 = readdist7(distfil, 'sm153');
Eu153 = readdist7(distfil, 'eu153');
Eu154 = readdist7(distfil, 'eu154');
Eu155 = readdist7(distfil, 'eu155');
Gd155 = readdist7(distfil, 'gd155');
BAeff = readdist7(distfil, 'BAeff');
u235sid = readdist7(distfil, 'u235sid');
pu239sid = readdist7(distfil, 'pu239sid');
pu240sid = readdist7(distfil, 'pu240sid');
pu241sid = readdist7(distfil, 'pu241sid');
BOXEFPH = readdist7(distfil, 'boxefph');
BOXFLU = readdist7(distfil, 'boxflu');



buidboc=readdist7(bocfil,'asyid');

%Uppdaterad
%History
BURSIDBOC = readdist7(bocfil, 'bursid');
BURCORBOC = readdist7(bocfil, 'burcor');
DNSHISBOC = readdist7(bocfil, 'dnshis');
CRHISBOC = readdist7(bocfil, 'crhis');
CRHFRCBOC = readdist7(bocfil, 'crhfrc');
CREINBOC = readdist7(bocfil, 'CREIN');
CREOUTBOC = readdist7(bocfil, 'CREOUT');
EFPHBOC = readdist7(bocfil, 'EFPH');
SIHISBOC = readdist7(bocfil, 'SIHIS');
SIHSIDBOC = readdist7(bocfil, 'SIHSID');
SIHCORBOC = readdist7(bocfil, 'SIHCOR');
U235BOC = readdist7(bocfil, 'u235');
U236BOC = readdist7(bocfil, 'u236');
U238BOC = readdist7(bocfil, 'u238');
Np239BOC = readdist7(bocfil, 'np239');
Pu239BOC = readdist7(bocfil, 'pu239');
Pu240BOC = readdist7(bocfil, 'pu240');
Pu241BOC = readdist7(bocfil, 'pu241');
Pu242BOC = readdist7(bocfil, 'pu242');
Am241BOC = readdist7(bocfil, 'am241');
Am242BOC = readdist7(bocfil, 'am242');
Ru103BOC = readdist7(bocfil, 'ru103');
Rh103BOC = readdist7(bocfil, 'rh103');
Rh105BOC = readdist7(bocfil, 'rh105');
Ce143BOC = readdist7(bocfil, 'ce143');
Pr143BOC = readdist7(bocfil, 'pr143');
Nd143BOC = readdist7(bocfil, 'nd143');
Nd147BOC = readdist7(bocfil, 'nd147');
Pm147BOC = readdist7(bocfil, 'pm147');
Pm148BOC = readdist7(bocfil, 'pm148');
Pm148mBOC = readdist7(bocfil, 'pm148m');
Pm149BOC = readdist7(bocfil, 'pm149');
Sm147BOC = readdist7(bocfil, 'sm147');
Sm149BOC = readdist7(bocfil, 'sm149');
Sm150BOC = readdist7(bocfil, 'sm150');
Sm151BOC = readdist7(bocfil, 'sm151');
Sm152BOC = readdist7(bocfil, 'sm152');
Sm153BOC = readdist7(bocfil, 'sm153');
Eu153BOC = readdist7(bocfil, 'eu153');
Eu154BOC = readdist7(bocfil, 'eu154');
Eu155BOC = readdist7(bocfil, 'eu155');
Gd155BOC = readdist7(bocfil, 'gd155');
BAeffBOC = readdist7(bocfil, 'BAeff');
u235sidBOC = readdist7(bocfil, 'u235sid');
pu239sidBOC = readdist7(bocfil, 'pu239sid');
pu240sidBOC = readdist7(bocfil, 'pu240sid');
pu241sidBOC = readdist7(bocfil, 'pu241sid');
BOXEFPHBOC = readdist7(bocfil, 'boxefph');
BOXFLUBOC = readdist7(bocfil, 'boxflu');






for i=1:size(to,1)
  ifrom=strmatch(buidnt(i,:),BUIDNT);
% Move bundle from pool
  if size(to,2)==2,   % corepos given in input
    if min(to(i,:))==0,
       tonum=0;
    else
      tonum=cpos2knum(to(i,:),mminj);
    end
  elseif size(to,2)==1,  % channel number given in input
    tonum=to(i);
  end
  if length(ifrom)==0,
    if tonum==0,
     disp(['Something is wrong, ',buidnt(i,:),' should be unloaded, but']);
     disp(['cannot be found on file ',distfil]);
    else
     buto=BUIDNT(tonum,:);
     buto=remblank(buto);
     if strcmp(buto(1:3),'vat'),
        if length(strmatch(buidnt(i,:),buidboc(tonum,:)))==0,
           disp('****** Warning SEVERE ERROR *******');
           disp(['You are trying to load bundle ',buidnt(i,:)]);
           disp(['into a position where bundle ',buidboc(tonum,:)]);
           disp('should be loaded.  You are STRONGLY recommended to'); 
           disp('interrupt what You are doing and try to find out what is wrong');              
           disp(['Position: ',sprintf('(%i,%i)',to(i,1),to(i,2))]);
           disp('')
           disp('Hit any key to continue');
           pause;
        end
        BUIDNT(tonum,:)=buidnt(i,:);
        burnup(:,tonum)=burnboc(:,tonum);
        
	
	%Uppdaterad
	BURSID(:,tonum) = BURSIDBOC(:,tonum);
	BURCOR(:,tonum) = BURCORBOC(:,tonum);
	DNSHIS(:,tonum) = DNSHISBOC(:,tonum);
	CRHIS(:,tonum) = CRHISBOC(:,tonum);
	CRHFRC(:,tonum) = CRHFRCBOC(:,tonum);
	CREIN(:,tonum) = CREINBOC(:,tonum);
	CREOUT(:,tonum) = CREOUTBOC(:,tonum);
	EFPH(:,tonum) = EFPHBOC(:,tonum);
	SIHIS(:,tonum) = SIHISBOC(:,tonum);
	SIHSID(:,tonum) = SIHSIDBOC(:,tonum);
	SIHCOR(:,tonum) = SIHCORBOC(:,tonum);
	U235(:,tonum) = U235BOC(:,tonum);
	U236(:,tonum) = U236BOC(:,tonum);
	U238(:,tonum) = U238BOC(:,tonum);
	Np239(:,tonum) = Np239BOC(:,tonum);
	Pu239(:,tonum) = Pu239BOC(:,tonum);
	Pu240(:,tonum) = Pu240BOC(:,tonum);
	Pu241(:,tonum) = Pu241BOC(:,tonum);
	Pu242(:,tonum) = Pu242BOC(:,tonum);
	Am241(:,tonum) = Am241BOC(:,tonum);
	Am242(:,tonum) = Am242BOC(:,tonum);
	Ru103(:,tonum) = Ru103BOC(:,tonum);
	Rh103(:,tonum) = Rh103BOC(:,tonum);
	Rh105(:,tonum) = Rh105BOC(:,tonum);
	Ce143(:,tonum) = Ce143BOC(:,tonum);
	Pr143(:,tonum) = Pr143BOC(:,tonum);
	Nd143(:,tonum) = Nd143BOC(:,tonum);
	Nd147(:,tonum) = Nd147BOC(:,tonum);
	Pm147(:,tonum) = Pm147BOC(:,tonum);
	Pm148(:,tonum) = Pm148BOC(:,tonum);
	Pm148m(:,tonum) = Pm148mBOC(:,tonum);
	Pm149(:,tonum) = Pm149BOC(:,tonum);
	Sm147(:,tonum) = Sm147BOC(:,tonum);
	Sm149(:,tonum) = Sm149BOC(:,tonum);
	Sm150(:,tonum) = Sm150BOC(:,tonum);
	Sm151(:,tonum) = Sm151BOC(:,tonum);
	Sm152(:,tonum) = Sm152BOC(:,tonum);
	Sm153(:,tonum) = Sm153BOC(:,tonum);
	Eu153(:,tonum) = Eu153BOC(:,tonum);
	Eu154(:,tonum) = Eu154BOC(:,tonum);
	Eu155(:,tonum) = Eu155BOC(:,tonum);
	Gd155(:,tonum) = Gd155BOC(:,tonum);
	BAeff(:,tonum) = BAeffBOC(:,tonum);
	u235sid(:,tonum) = u235sidBOC(:,tonum);
	pu239sid(:,tonum) = pu239sidBOC(:,tonum);
	pu240sid(:,tonum) = pu240sidBOC(:,tonum);
	pu241sid(:,tonum) = pu241sidBOC(:,tonum);
	BOXEFPH(:,tonum) = BOXEFPHBOC(:,tonum);
	BOXFLU(:,tonum) = BOXFLUBOC(:,tonum);
        
	buntyp(tonum,:)=bunboc(tonum,:);
     else
        disp('Error in updatbp: to-position not empty')
        disp(['tonum= ',num2str(tonum),' i= ',num2str(i)]);
        disp(['BUIDNT(tonum,:)= ',BUIDNT(tonum,:)]);
     end
    end
% Move bundle from other position in core
  else
    if length(ifrom)==1,
      if tonum==0
        BUIDNT(ifrom,:)='vatten          ';
        burnup(:,ifrom)=dumburn*ones(size(burnup(:,ifrom)));
        
	%Uppdaterat
	BURSID(:,ifrom) = 0*BURSID(:,ifrom);
	BURCOR(:,ifrom) = 0*BURCOR(:,ifrom);
	DNSHIS(:,ifrom) = 0*DNSHIS(:,ifrom);
	CRHIS(:,ifrom) = 0*CRHIS(:,ifrom);
	CRHFRC(:,ifrom) = 0*CRHFRC(:,ifrom);
	CREIN(:,ifrom) = 0*CREIN(:,ifrom);
	CREOUT(:,ifrom) = 0*CREOUT(:,ifrom);
	EFPH(:,ifrom) = 0*EFPH(:,ifrom);
	SIHIS(:,ifrom) = 0*SIHIS(:,ifrom);
	SIHSID(:,ifrom) = 0*SIHSID(:,ifrom);
	SIHCOR(:,ifrom) = 0*SIHCOR(:,ifrom);
	U235(:,ifrom) = 0*U235(:,ifrom);
	U236(:,ifrom) = 0*U236(:,ifrom);
	U238(:,ifrom) = 0*U238(:,ifrom);
	Np239(:,ifrom) = 0*Np239(:,ifrom);
	Pu239(:,ifrom) = 0*Pu239(:,ifrom);
	Pu240(:,ifrom) = 0*Pu240(:,ifrom);
	Pu241(:,ifrom) = 0*Pu241(:,ifrom);
	Pu242(:,ifrom) = 0*Pu242(:,ifrom);
	Am241(:,ifrom) = 0*Am241(:,ifrom);
	Am242(:,ifrom) = 0*Am242(:,ifrom);
	Ru103(:,ifrom) = 0*Ru103(:,ifrom);
	Rh103(:,ifrom) = 0*Rh103(:,ifrom);
	Rh105(:,ifrom) = 0*Rh105(:,ifrom);
	Ce143(:,ifrom) = 0*Ce143(:,ifrom);
	Pr143(:,ifrom) = 0*Pr143(:,ifrom);
	Nd143(:,ifrom) = 0*Nd143(:,ifrom);
	Nd147(:,ifrom) = 0*Nd147(:,ifrom);
	Pm147(:,ifrom) = 0*Pm147(:,ifrom);
	Pm148(:,ifrom) = 0*Pm148(:,ifrom);
	Pm148m(:,ifrom) = 0*Pm148m(:,ifrom);
	Pm149(:,ifrom) = 0*Pm149(:,ifrom);
	Sm147(:,ifrom) = 0*Sm147(:,ifrom);
	Sm149(:,ifrom) = 0*Sm149(:,ifrom);
	Sm150(:,ifrom) = 0*Sm150(:,ifrom);
	Sm151(:,ifrom) = 0*Sm151(:,ifrom);
	Sm152(:,ifrom) = 0*Sm152(:,ifrom);
	Sm153(:,ifrom) = 0*Sm153(:,ifrom);
	Eu153(:,ifrom) = 0*Eu153(:,ifrom);
	Eu154(:,ifrom) = 0*Eu154(:,ifrom);
	Eu155(:,ifrom) = 0*Eu155(:,ifrom);
	Gd155(:,ifrom) = 0*Gd155(:,ifrom);
	BAeff(:,ifrom) = 0*BAeff(:,ifrom);
	u235sid(:,ifrom) = 0*u235sid(:,ifrom);
	pu239sid(:,ifrom) = 0*pu239sid(:,ifrom);
	pu240sid(:,ifrom) = 0*pu240sid(:,ifrom);
	pu241sid(:,ifrom) = 0*pu241sid(:,ifrom);
	BOXEFPH(:,ifrom) = 0*BOXEFPH(:,ifrom);
	BOXFLU(:,ifrom) = 0*BOXFLU(:,ifrom);

	
	buntyp(ifrom,:)=dumbun;

      else
        buto=BUIDNT(tonum,:);
        buto=remblank(buto);
buto
size(buto)
        if strcmp(buto(1:3),'vat'),
           if length(strmatch(buidnt(i,:),buidboc(tonum,:)))==0,
             disp('****** Warning SEVERE ERROR *******');
             disp(['You are trying to load bundle ',buidnt(i,:)]);
             disp(['into a position where bundle ',buidboc(tonum,:)]);
             disp('should be loaded.  You are STRONGLY recommended to'); 
             disp('interrupt what You are doing and try to find out what is wrong');              
             disp(['Position: ',sprintf('(%i,%i)',to(i,1),to(i,2))]);
             disp('')
             disp('Hit any key to continue');
             pause;
           end
size(BUIDNT)
size(buidnt)
buidnt
           BUIDNT(tonum,:)=buidnt(i,:);
           burnup(:,tonum)=burnup(:,ifrom);
           
	   
	   %Uppdaterat
	   BURSID(:,tonum) = BURSID(:,ifrom);
	   BURCOR(:,tonum) = BURCOR(:,ifrom);
	   DNSHIS(:,tonum) = DNSHIS(:,ifrom);
	   CRHIS(:,tonum) = CRHIS(:,ifrom);
	   CRHFRC(:,tonum) = CRHFRC(:,ifrom);
	   CREIN(:,tonum) = CREIN(:,ifrom);
	   CREOUT(:,tonum) = CREOUT(:,ifrom);
	   EFPH(:,tonum) = EFPH(:,ifrom);
	   SIHIS(:,tonum) = SIHIS(:,ifrom);
	   SIHSID(:,tonum) = SIHSID(:,ifrom);
	   SIHCOR(:,tonum) = SIHCOR(:,ifrom);
	   U235(:,tonum) = U235(:,ifrom);
	   U236(:,tonum) = U236(:,ifrom);
	   U238(:,tonum) = U238(:,ifrom);
	   Np239(:,tonum) = Np239(:,ifrom);
	   Pu239(:,tonum) = Pu239(:,ifrom);
	   Pu240(:,tonum) = Pu240(:,ifrom);
	   Pu241(:,tonum) = Pu241(:,ifrom);
	   Pu242(:,tonum) = Pu242(:,ifrom);
	   Am241(:,tonum) = Am241(:,ifrom);
	   Am242(:,tonum) = Am242(:,ifrom);
	   Ru103(:,tonum) = Ru103(:,ifrom);
	   Rh103(:,tonum) = Rh103(:,ifrom);
	   Rh105(:,tonum) = Rh105(:,ifrom);
	   Ce143(:,tonum) = Ce143(:,ifrom);
	   Pr143(:,tonum) = Pr143(:,ifrom);
	   Nd143(:,tonum) = Nd143(:,ifrom);
	   Nd147(:,tonum) = Nd147(:,ifrom);
	   Pm147(:,tonum) = Pm147(:,ifrom);
	   Pm148(:,tonum) = Pm148(:,ifrom);
	   Pm148m(:,tonum) = Pm148m(:,ifrom);
	   Pm149(:,tonum) = Pm149(:,ifrom);
	   Sm147(:,tonum) = Sm147(:,ifrom);
	   Sm149(:,tonum) = Sm149(:,ifrom);
	   Sm150(:,tonum) = Sm150(:,ifrom);
	   Sm151(:,tonum) = Sm151(:,ifrom);
	   Sm152(:,tonum) = Sm152(:,ifrom);
	   Sm153(:,tonum) = Sm153(:,ifrom);
	   Eu153(:,tonum) = Eu153(:,ifrom);
	   Eu154(:,tonum) = Eu154(:,ifrom);
	   Eu155(:,tonum) = Eu155(:,ifrom);
	   Gd155(:,tonum) = Gd155(:,ifrom);
	   BAeff(:,tonum) = BAeff(:,ifrom);
	   u235sid(:,tonum) = u235sid(:,ifrom);
	   pu239sid(:,tonum) = pu239sid(:,ifrom);
	   pu240sid(:,tonum) = pu240sid(:,ifrom);
	   pu241sid(:,tonum) = pu241sid(:,ifrom);
	   BOXEFPH(:,tonum) = BOXEFPH(:,ifrom);
	   BOXFLU(:,tonum) = BOXFLU(:,ifrom);

	   
	   buntyp(tonum,:)=buntyp(ifrom,:);
           BUIDNT(ifrom,:)='vatten          ';
           burnup(:,ifrom)=dumburn*ones(size(burnup(:,ifrom)));
           
	   
	   
	   %Uppdaterat
	   BURSID(:,ifrom) = 0*BURSID(:,ifrom);
	   BURCOR(:,ifrom) = 0*BURCOR(:,ifrom);
	   DNSHIS(:,ifrom) = 0*DNSHIS(:,ifrom);
	   CRHIS(:,ifrom) = 0*CRHIS(:,ifrom);
	   CRHFRC(:,ifrom) = 0*CRHFRC(:,ifrom);
	   CREIN(:,ifrom) = 0*CREIN(:,ifrom);
	   CREOUT(:,ifrom) = 0*CREOUT(:,ifrom);
	   EFPH(:,ifrom) = 0*EFPH(:,ifrom);
	   SIHIS(:,ifrom) = 0*SIHIS(:,ifrom);
	   SIHSID(:,ifrom) = 0*SIHSID(:,ifrom);
	   SIHCOR(:,ifrom) = 0*SIHCOR(:,ifrom);
	   U235(:,ifrom) = 0*U235(:,ifrom);
	   U236(:,ifrom) = 0*U236(:,ifrom);
	   U238(:,ifrom) = 0*U238(:,ifrom);
	   Np239(:,ifrom) = 0*Np239(:,ifrom);
	   Pu239(:,ifrom) = 0*Pu239(:,ifrom);
	   Pu240(:,ifrom) = 0*Pu240(:,ifrom);
	   Pu241(:,ifrom) = 0*Pu241(:,ifrom);
	   Pu242(:,ifrom) = 0*Pu242(:,ifrom);
	   Am241(:,ifrom) = 0*Am241(:,ifrom);
	   Am242(:,ifrom) = 0*Am242(:,ifrom);
	   Ru103(:,ifrom) = 0*Ru103(:,ifrom);
	   Rh103(:,ifrom) = 0*Rh103(:,ifrom);
	   Rh105(:,ifrom) = 0*Rh105(:,ifrom);
	   Ce143(:,ifrom) = 0*Ce143(:,ifrom);
	   Pr143(:,ifrom) = 0*Pr143(:,ifrom);
	   Nd143(:,ifrom) = 0*Nd143(:,ifrom);
	   Nd147(:,ifrom) = 0*Nd147(:,ifrom);
	   Pm147(:,ifrom) = 0*Pm147(:,ifrom);
	   Pm148(:,ifrom) = 0*Pm148(:,ifrom);
	   Pm148m(:,ifrom) = 0*Pm148m(:,ifrom);
	   Pm149(:,ifrom) = 0*Pm149(:,ifrom);
	   Sm147(:,ifrom) = 0*Sm147(:,ifrom);
	   Sm149(:,ifrom) = 0*Sm149(:,ifrom);
	   Sm150(:,ifrom) = 0*Sm150(:,ifrom);
	   Sm151(:,ifrom) = 0*Sm151(:,ifrom);
	   Sm152(:,ifrom) = 0*Sm152(:,ifrom);
	   Sm153(:,ifrom) = 0*Sm153(:,ifrom);
	   Eu153(:,ifrom) = 0*Eu153(:,ifrom);
	   Eu154(:,ifrom) = 0*Eu154(:,ifrom);
	   Eu155(:,ifrom) = 0*Eu155(:,ifrom);
	   Gd155(:,ifrom) = 0*Gd155(:,ifrom);
	   BAeff(:,ifrom) = 0*BAeff(:,ifrom);
	   u235sid(:,ifrom) = 0*u235sid(:,ifrom);
	   pu239sid(:,ifrom) = 0*pu239sid(:,ifrom);
	   pu240sid(:,ifrom) = 0*pu240sid(:,ifrom);
	   pu241sid(:,ifrom) = 0*pu241sid(:,ifrom);
	   BOXEFPH(:,ifrom) = 0*BOXEFPH(:,ifrom);
	   BOXFLU(:,ifrom) = 0*BOXFLU(:,ifrom);
	   	   
	   buntyp(ifrom,:)=dumbun;

        else
           disp('Error in updatbp: to-position not empty')
           disp(['tonum= ',num2str(tonum),' i= ',num2str(i)]);
           disp(['BUIDNT(tonum,:)= ',BUIDNT(tonum,:)]);
        end
      end
    elseif length(ifrom)>1,
      disp('Error in updatbp: more than one buidnt found in file')
      disp([distfil,' buidnt: ',buidnt(i,:)]);
    else
      disp('Error in updatbp:  buidnt not found in file')
      disp([distfil,' buidnt: ',buidnt(i,:)]);
    end
  end
end




%Fortsätt här
writedist7(distfil, burnup, 'burnup');
writedist7(distfil, buntyp, 'asytyp');
writedist7(distfil, BUIDNT, 'asyid');

%Uppdaterat
writedist7(distfil, BURSID, 'BURSID');
writedist7(distfil,BURCOR , 'BURCOR');
writedist7(distfil, DNSHIS, 'DNSHIS');
writedist7(distfil, CRHIS, 'CRHIS');
writedist7(distfil, CRHFRC, 'CRHFRC');
writedist7(distfil, CREIN, 'CREIN');
writedist7(distfil, CREOUT, 'CREOUT');
writedist7(distfil, EFPH, 'EFPH');
writedist7(distfil, SIHIS, 'SIHIS');
writedist7(distfil, SIHSID, 'SIHSID');
writedist7(distfil, SIHCOR, 'SIHCOR');
writedist7(distfil, U235, 'U235');
writedist7(distfil, U236, 'U236');
writedist7(distfil, U238, 'U238');
writedist7(distfil, Np239, 'Np239');
writedist7(distfil, Pu239, 'Pu239');
writedist7(distfil, Pu240, 'Pu240');
writedist7(distfil, Pu241, 'Pu241');
writedist7(distfil, Pu242, 'Pu242');
writedist7(distfil, Am241, 'Am241');
writedist7(distfil, Am242, 'Am242');
writedist7(distfil, Ru103, 'Ru103');
writedist7(distfil, Rh103, 'Rh103');
writedist7(distfil, Rh105, 'Rh105');
writedist7(distfil, Ce143, 'Ce143');
writedist7(distfil, Pr143, 'Pr143');
writedist7(distfil, Nd143, 'Nd143');
writedist7(distfil, Nd147, 'Nd147');
writedist7(distfil, Pm147, 'Pm147');
writedist7(distfil, Pm148, 'Pm148');
writedist7(distfil, Pm148m, 'Pm148m');
writedist7(distfil, Pm149, 'Pm149');
writedist7(distfil, Sm147, 'Sm147');
writedist7(distfil, Sm149, 'Sm149');
writedist7(distfil, Sm150, 'Sm150');
writedist7(distfil, Sm151, 'Sm151');
writedist7(distfil, Sm152, 'Sm152');
writedist7(distfil, Sm153, 'Sm153');
writedist7(distfil, Eu153, 'Eu153');
writedist7(distfil, Eu154, 'Eu154');
writedist7(distfil, Eu155, 'Eu155');
writedist7(distfil, Gd155, 'Gd155');
writedist7(distfil, BAeff, 'BAeff');
writedist7(distfil, u235sid, 'u235sid');
writedist7(distfil, pu239sid, 'pu239sid');
writedist7(distfil, pu240sid, 'pu240sid');
writedist7(distfil, pu241sid, 'pu241sid');
writedist7(distfil, BOXEFPH, 'BOXEFPH');
writedist7(distfil, BOXFLU, 'BOXFLU');



