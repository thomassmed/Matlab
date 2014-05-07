%@(#)   poolplot.m 1.1	 05/07/13     10:29:37
%
%function [hapool,hepool,htpool]=poolplot(block);
function [hapool,hepool,htpool]=poolplot(block);
if strcmp(upper(block),'F2') | strcmp(upper(block),'F1')
  hapool=figure('position',[10 400 400 450],'color',[.8 .8 .8]);
  amat=4*ones(24,20);
  image(amat);
  colormap(jett);
  title([upper(block) ' A-bassäng'],'color','k');
  for i=1:24,
    if i<21,line([i-.5 i-.5],[33 0],'color','k');end
    line([0 21],[i-.5 i-.5],'color','k');
  end
  set(gca,'ytick',1:24);
  labvec=['110';'111';'112';'113';'114';'115';'116';'117';'118';'119';'120'];
  labvec=[labvec;'121';'122';'123';'124';'125';'126';'127';'128';'129';'130'];
  labvec=[labvec;'131';'132';'133'];
  set(gca,'fontname','courier');
  set(gca,'yticklabel',labvec);
  set(gca,'xtick',1:20);
  labvec=['AA';'AB';'AC';'AD';'AE';'AF';'AG';'AH';'AI';'AK'];
  labvec=[labvec; 'BA';'BB';'BC';'BD';'BE';'BF';'BG';'BH';'BI';'BK'];
  ud=labvec;
  set(gca,'userdata',ud);
  set(gca,'xticklabel',labvec);
  set(gca,'ycolor','k');
  set(gca,'xcolor','k');
%
% F1/F2 E-bassäng
%
  hepool=figure('position',[450 400 400 450],'color',[.8 .8 .8]);
  epx=[9 10 11 12 13 14 15 16 10 11 12 13 14 15 16 11 12 13 14 15 16];
  epx=[epx 12 13 14 15 16 14 15 16 1 1];
  epy=[1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 5 5 5 23 24];
  exx=[19 20 19 20 19 20 19 20 19 20];
  exy=[1 1 2 2 3 3 4 4 5 5];
  if strcmp(upper(block),'F1')
    exx=[10 4 15];		%Ändrad från exx=[exx 10 4 15]
    exy=[5 21 23];		%Ändrad från exy=[exy 5 21 23]
  end
  if strcmp(upper(block),'F2')
    exx=[exx 2 3 4];
    exy=[exy 24 24 24];
  end
  emat=4*ones(24,20);
  image(emat);
  colormap(jett);
  for i=1:length(epx)
    line([epx(i)-.2 epx(i)+.2],[epy(i) epy(i)],'color','k');
  end
  for i=1:length(exx)
    line([exx(i)-.5 exx(i)+.5],[exy(i)+.5 exy(i)-.5],'color','k');
    line([exx(i)-.5 exx(i)+.5],[exy(i)-.5 exy(i)+.5],'color','k');
  end
  for i=1:24,
    if i<21,line([i-.5 i-.5],[25 0],'color','k');end
    line([0 21],[i-.5 i-.5],'color','k');
  end
  set(gca,'ytick',1:24);
  labvec=['116';'117';'118';'119';'120';'121';'122';'123';'124';'125';'126'];
  labvec=[labvec;'127';'128';'129';'130';'131';'132';'133';'134';'135'];
  labvec=[labvec;'136';'137';'138';'139'];
  set(gca,'ycolor','k');
  set(gca,'xcolor','k');
  title([upper(block) ' E-bassäng'],'color','k');
  set(gca,'fontname','courier');
  set(gca,'yticklabel',labvec);
  set(gca,'xtick',1:20);
  labvec=['CA';'CB';'CC';'CD';'CE';'CF';'CG';'CH';'CI';'CK';'DA';'DB'];
  labvec=[labvec; 'DC';'DD';'DE';'DF';'DG';'DH';'DI';'DK'];
  ud=labvec;
  set(gca,'xticklabel',labvec);
  set(gca,'userdata',ud);
end
%
% F1 Tätpackningsställ A-bass
%
if strcmp(upper(block),'F1')
  htpool=figure('position',[10 80 600 300],'color',[.8 .8 .8]);
  epx=[31 32 30 31 32 29 30 31 32 29 30 31 32 28 29 30 31 32 33];
  epx=[epx 28 29 30 31 32 33 28 29 30 31 32 33 28 29 30 31 32 33];
  epx=[epx 28 29 30 31 32 33 28 29 30 31 32 33 28 29 30 31 32 33];
  epx=[epx 28 29 30 31 32 33 29 30 31 32 33 33 33 33 33];
  epy=[2 2 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 6 6 7 7 7 7 7 7];
  epy=[epy 8 8 8 8 8 8 9 9 9 9 9 9 10 10 10 10 10 10 11 11 11 11 11 11];
  epy=[epy 12 12 12 12 12 12 13 13 13 13 13 13 14 14 14 14 1 2 3 4 5];
  %exx=[33 33 33 33 33];
  
  exx=[1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5];
  exy=[1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4 5 5 5 5 5 6 6 6 6 6];
  
  %exy=[1 2 3 4 5];
  emat=4*ones(14,33);
  image(emat);
  colormap(jett);
  for i=1:length(epx)
    line([epx(i)-.2 epx(i)+.2],[epy(i) epy(i)],'color','k');
  end
  for i=1:length(exx)
    line([exx(i)-.5 exx(i)+.5],[exy(i)+.5 exy(i)-.5],'color','k');
    line([exx(i)-.5 exx(i)+.5],[exy(i)-.5 exy(i)+.5],'color','k');
  end
  for i=1:33,
    line([i-.5 i-.5],[15 0],'color','k');
    if i<15,line([0 34],[i-.5 i-.5],'color','k');end
  end
  set(gca,'ytick',1:14);
  labvec=['201';'202';'203';'204';'205';'206';'207';'208';'209';'210'];
  labvec=[labvec;'211';'212';'213';'214'];
  set(gca,'ycolor','k');
  set(gca,'xcolor','k');
  title('F1 A-bassäng, tätpackningsställ','color','k');
  set(gca,'fontname','courier');
  set(gca,'yticklabel',labvec);
  set(gca,'xtick',1:33);
  labvec=['EA';'EB';'EC';'ED';'EE';'EF';'EG';'EH';'EI';'EK';'EL'];
  labvec=[labvec; 'FA';'FB';'FC';'FD';'FE';'FF';'FG';'FH';'FI';'FK';'FL'];
  labvec=[labvec; 'GA';'GB';'GC';'GD';'GE';'GF';'GG';'GH';'GI';'GK';'GL'];
  ud=labvec;
  set(gca,'xticklabel',labvec);
  set(gca,'userdata',ud);
end
%
% F2 Tätpackningsställ A-bass
%
if strcmp(upper(block),'F2')
  htpool=figure('position',[10 200 450 300],'color',[.8 .8 .8]);
  epx=[21 20 21 19 20 21 18 19 20 21 22 18 19 20 21 22 17 18 19 20 21 22];
  epx=[epx 17 18 19 20 21 22 17 18 19 20 21 22 17 18 19 20 21 22];
  epx=[epx 17 18 19 20 21 22 17 18 19 20 21 22 17 18 19 20 21 22];
  epx=[epx 18 19 20 21 22];
  epy=[2 3 3 4 4 4 5 5 5 5 5 6 6 6 6 6 7 7 7 7 7 7 8 8 8 8 8 8 9 9 9 9 9 9];
  epy=[epy 10 10 10 10 10 10 11 11 11 11 11 11 12 12 12 12 12 12];
  epy=[epy 13 13 13 13 13 13 14 14 14 14 14];
  exx=[22 22 22 22];
  exy=[1 2 3 4];
  emat=4*ones(14,22);
  image(emat);
  colormap(jett);
  for i=1:length(epx)
    line([epx(i)-.2 epx(i)+.2],[epy(i) epy(i)],'color','k');
  end
  for i=1:length(exx)
    line([exx(i)-.5 exx(i)+.5],[exy(i)+.5 exy(i)-.5],'color','k');
    line([exx(i)-.5 exx(i)+.5],[exy(i)-.5 exy(i)+.5],'color','k');
  end
  for i=1:22,
    line([i-.5 i-.5],[15 0],'color','k');
    if i<15,line([0 23],[i-.5 i-.5],'color','k');end
  end
  set(gca,'ytick',1:14);
  labvec=['201';'202';'203';'204';'205';'206';'207';'208';'209';'210'];
  labvec=[labvec;'211';'212';'213';'214'];
  set(gca,'ycolor','k');
  set(gca,'xcolor','k');
  title('F2 A-bassäng, tätpackningsställ','color','k');
  set(gca,'fontname','courier');
  set(gca,'yticklabel',labvec);
  set(gca,'xtick',1:22);
  labvec=['FA';'FB';'FC';'FD';'FE';'FF';'FG';'FH';'FI';'FK';'FL'];
  labvec=[labvec; 'GA';'GB';'GC';'GD';'GE';'GF';'GG';'GH';'GI';'GK';'GL'];
  ud=labvec;
  set(gca,'xticklabel',labvec);
  set(gca,'userdata',ud);
end

%%%%%%%%%%%%
%  F3
%%%%%%%%%%%
if strcmp(upper(block),'F3'),
  apx=[1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 3 4 4 4 4 4 4 5 5 5 5];
  apy=[21 22 23 24 25 26 27 28 22 23 24 25 26 27 28 22 23 24 25 26 27 28];
  apy=[apy 23 24 25 26 27 28 25 26 27 28];
  axx=[1 1 1 1 1 1 1 1 1  1  1  1  1  1  1  1  1  1  1  1  6];
  axy=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 23];
  hapool=figure('position',[10 250 400 600],'color',[.8 .8 .8]);
  amat=4*ones(32,20);
  image(amat);
  colormap(jett);
  title('F3 A-bassäng','color','k');
  for i=1:length(apx)
    line([apx(i)-.2 apx(i)+.2],[apy(i) apy(i)],'color','k');
  end
  for i=1:length(axx)
    line([axx(i)-.5 axx(i)+.5],[axy(i)+.5 axy(i)-.5],'color','k');
    line([axx(i)-.5 axx(i)+.5],[axy(i)-.5 axy(i)+.5],'color','k');
  end
  for i=1:33,
    if i<21,line([i-.5 i-.5],[33 0],'color','k');end
    line([0 21],[i-.5 i-.5],'color','k');
  end
% Icke rekommenderade områden
  line([1.45 19.55 19.55 18.55 18.55  5.45  5.45  4.45  4.45  3.45  3.45  1.45 1.45],...
       [1.45  1.45 30.55 30.55 31.55 31.55 24.55 24.55 22.55 22.55 21.55 21.55 1.45],...
       'color','k');
%
  set(gca,'ytick',1:32);
  labvec=['AI';'AK';'BA';'BB';'BC';'BD';'BE';'BF';'BG';'BH';'BI';'BK';'CA'];
  labvec=[labvec;'CB';'CC';'CD';'CE';'CF';'CG';'CH';'CI';'CK';'DA';'DB'];
  labvec=[labvec;'DC';'DD';'DE';'DF';'DG';'DH';'DI';'DK'];
  set(gca,'fontname','courier');
  set(gca,'yticklabel',labvec);
  set(gca,'xtick',1:2:19);
  labvec=['120';'118';'116';'114';'112';'110';'108';'106';'104';'102'];
  ud=['120';'119';'118';'117';'116';'115';'114';'113';'112';'111';'110'];
  ud=[ud;'109';'108';'107';'106';'105';'104';'103';'102';'101'];
  set(gca,'userdata',ud);
  set(gca,'xticklabel',labvec);
  set(gca,'ycolor','k');
  set(gca,'xcolor','k');
%
% F3 E-bassäng
%
  hepool=figure('position',[450 400 400 450],'color',[.8 .8 .8]);
  epx=[2 3 4 5 6 7 8 9 10 2 3 4 5 6 7 8 2 3 4 5 6 7 8 9 2 3 4 5 6 7 8];
  epx=[epx 2 3 4 5 6 7 2 3 4];
  epx=[epx 17 19 20 16 17 18 19 20 16 17 18 19 20 16 17 18 19 20];
  epx=[epx 16 17 18 19 20 17 18 19 20 18 19 20 19 20];
  epy=[1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4];
  epy=[epy 5 5 5 5 5 5 6 6 6];
  epy=[epy 12 12 12 13 13 13 13 13 14 14 14 14 14 15 15 15 15 15];
  epy=[epy 16 16 16 16 16 17 17 17 17 18 18 18 19 19];
  exx=[11 12 13 14 15 16 17 18 19 20 9 11 12 13 14 15 16 17 18 19 20];
  exx=[exx 11 12 13 14 15 16 17 18 19 20 11 12 13 14 15 16 17 18 19 20];
  exx=[exx 10 11 12 13 14 15 16 17 18 19 20 11 12 13 14 15 16 17 18 19 20];
  exx=[exx 11 12 13 14 15 16 17 18 19 20 10 11 12 13 14 15 16 17 18 19 20];
  exx=[exx 11 12 13 14 15 16 17 18 19 20 16 18 17];
  exy=[1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3];
  exy=[exy 4 4 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6 6 6 6 6 6];
  exy=[exy 7 7 7 7 7 7 7 7 7 7 8 8 8 8 8 8 8 8 8 8 8 9 9 9 9 9 9 9 9 9 9];
  exy=[exy 12 12 18];
  emat=4*ones(24,20);
  image(emat);
  colormap(jett);
  for i=1:length(epx)
    line([epx(i)-.2 epx(i)+.2],[epy(i) epy(i)],'color','k');
  end
  for i=1:length(exx)
    line([exx(i)-.5 exx(i)+.5],[exy(i)+.5 exy(i)-.5],'color','k');
    line([exx(i)-.5 exx(i)+.5],[exy(i)-.5 exy(i)+.5],'color','k');
  end
  for i=1:25,
    if i<21,line([i-.5 i-.5],[25 0],'color','k');end
    line([0 21],[i-.5 i-.5],'color','k');
  end
% Icke rekommenderade områden
  line([0.50 7.45 7.45 8.45 8.45 9.55 9.55 13.55 13.55 16.55 16.55 18.55 18.55 20.45],...
       [5.45 5.45 4.45 4.45 3.45 3.45 9.45  9.45 16.45 16.45 18.45 18.45 19.45 19.45],...
       'color','k');
  line([10.45 10.45 20.5],[ 0.55  8.55 8.55],'color','k');
  line([17.55 17.55 20.5],[ 0.55  1.45 1.45],'color','k');
  set(gca,'ytick',1:24);
  labvec=['BF';'BG';'BH';'BI';'BK';'CA';'CB';'CC';'CD';'CE';'CF';'CG';'CH'];
  labvec=[labvec;'CI';'CK';'DA';'DB';'DC';'DD';'DE';'DF';'DG';'DH';'DI'];
  set(gca,'ycolor','k');
  set(gca,'xcolor','k');
  title('F3 E-bassäng','color','k');
  set(gca,'fontname','courier');
  set(gca,'yticklabel',labvec);
  set(gca,'xtick',1:2:19);
  labvec=['140';'138';'136';'134';'132';'130';'128';'126';'124';'122'];
  ud=['140';'139';'138';'137';'136';'135';'134';'133';'132';'131'];
  ud=[ud;'130';'129';'128';'127';'126';'125';'124';'123';'122';'121'];
  set(gca,'xticklabel',labvec);
  set(gca,'userdata',ud);
end
