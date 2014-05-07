%@(#)   sortprint.m 1.3	 94/08/12     12:15:47
%
%function sortprint(sorton,pool,lastcyclewise,prifil,matfil,basfil);
% 
%Sort and print primitive file (argument basfil, output file from command bunhist),
%and create a MATLAB-file (argument matfil) and an ASCII-printfile (argument prifil)
%options:
%  sorton - 'buidnt','burnup','kinf', default='kinf'
%  pool   - 'full','pool','core','clab','reuse', default='pool'
%  lastcyclewise - 0 or 1, if lastcyclewise is =1 , all bundles with the same
%                  last cycle are grouped together, default=0
%
%files:
%  prifil - Print the result in Ascii on this file, default=sorton, i.e.
%           if the result is sorted on buidnt, the result will be printed on buidnt.lis
%           If prifil is a number no printing is made.
%  basfil - Output file from program bunhist, default='utfil.mat'
%  matfil - Save the result in this file on MATLAB-format, default=same as sorton, i.e.
%           if the result is sorted on buidnt, the result will be stored on buidnt.mat
%
%
% Example 1: sortprint
% Example 2: sortprint('buidnt','full')
% Example 2a: sortprint  buidnt full
% Example 3: sortprint('buidnt','pool',0,'buidnt.lis','buidnt.mat','utfil.mat')
% Example 3a: sortprint buidnt pool 0 buidnt.lis buidnt.mat utfil.mat
% Example 4: sortprint('buidnt','burnup>30000',0,'buidnt.lis','buidnt.mat','utfil.mat')
function sortprint(sorton,pool,lastcyclewise,prifil,matfil,basfil);
if nargin<1, sorton='kinf';end
if nargin<2, pool='pool';end
if nargin<3, lastcyclewise=0;end
if nargin<4, prifil=[remblank(sorton),'.lis'];end
if nargin<5, matfil=[remblank(sorton),'.mat'];end
if nargin<6, basfil='utfil.mat';end
if isstr(lastcyclewise), lastcyclewise=str2num(lastcyclewise);end
pool=remblank(pool);
sorton=lower(sorton);sorton=remblank(sorton);
[ierr,errtext]=findfuel(basfil,matfil,pool);
titel=[pool,' inventory, sorted on ',sorton];
if ierr==0,
  load(matfil)
  isort=(1:length(ITOT));
  if strcmp(sorton,'kinf'),
    [x,isort]=sort(kinf);
    isort(length(isort):-1:1)=isort;
  elseif strcmp(sorton,'burnup'),
    [x,isort]=sort(burnup);
  elseif strcmp(sorton,'buidnt'),
    [x,isort]=ascsort(BUIDNT);
  else
    disp('Error in sortprint unknown value for argument sorton')
    ierr=2;
  end
  if ierr==0,
    sortfil(matfil,matfil,isort)
    if lastcyclewise>0,
      load(matfil);
      [lc,isort]=sort(lastcyc);
      sortfil(matfil,matfil,isort)
      titel=[titel,' cyclewise'];
    end
    fulll=0;
    if strcmp(pool,'full'), fulll=1;end
    if isstr(prifil),
       pristat(matfil,prifil,titel,fulll)
    end
  end
end
