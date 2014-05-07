%@(#)   sortprint7.m 1.6	 06/02/17     08:19:13
%
%function sortprint7(sorton,pool,lastcyclewise,prifil,matfil,basfil);
% 
%Sort and print primitive file (argument basfil, output file from command bunhist),
%and create a MATLAB-file (argument matfil) and an ASCII-printfile (argument prifil)
%options:
%  sorton - 'asyid','burnup','khot', default='khot'
%  pool   - 'full','pool','core','clab','reuse', default='pool'
%  lastcyclewise - 0 or 1, if lastcyclewise is =1 , all bundles with the same
%                  last cycle are grouped together, default=0
%
%files:
%  prifil - Print the result in Ascii on this file, default=sorton, i.e.
%           if the result is sorted on asyid, the result will be printed on asyid.lis
%           If prifil is a number no printing is made.
%  basfil - Output file from program bunhist, default='utfil.mat'
%  matfil - Save the result in this file on MATLAB-format, default=same as sorton, i.e.
%           if the result is sorted on asyid, the result will be stored on asyid.mat
%
%
% Example 1: sortprint7
% Example 2: sortprint7('asyid','full')
% Example 2a: sortprint7  asyid full
% Example 3: sortprint7('asyid','pool',0,'asyid.lis','asyid.mat','utfil.mat')
% Example 3a: sortprint7 asyid pool 0 asyid.lis asyid.mat utfil.mat
% Example 4: sortprint7('asyid','burnup>30000',0,'asyid.lis','asyid.mat','utfil.mat')
function sortprint7(sorton,pool,lastcyclewise,prifil,matfil,basfil);
if nargin<1, sorton='khot';end
if nargin<2, pool='pool';end
if nargin<3, lastcyclewise=0;end
if nargin<4, prifil=[remblank(sorton),'.lis'];end
if nargin<5, matfil=[remblank(sorton),'.mat'];end
if nargin<6, basfil='utfil.mat';end
if isstr(lastcyclewise), lastcyclewise=str2num(lastcyclewise);end
pool=remblank(pool);
sorton=lower(sorton);sorton=remblank(sorton);
[ierr,errtext]=findfuel7(basfil,matfil,pool);
titel=[pool,' inventory, sorted on ',sorton];
if ierr==0,
  load(matfil)
  isort=(1:length(ITOT));
  switch sorton
    case 'khot'
      [x,isort]=sort(khot);
      isort(length(isort):-1:1)=isort;
    case 'burnup'
      [x,isort]=sort(burnup);
    case 'asyid'
      [x,isort]=sortrows(right_adjust(ASYID));
    otherwise
      disp('Error in sortprint7 unknown value for argument sorton')
      ierr=2;
  end
  if ierr==0,
    sortfil7(matfil,matfil,isort)
    if lastcyclewise>0,
      load(matfil);
      [lc,isort]=sort(lastcyc);
      sortfil7(matfil,matfil,isort)
      titel=[titel,' cyclewise'];
    end
    fulll=0;
    if strcmp(pool,'full'), fulll=1;end
    if isstr(prifil),
       pristat7(matfil,prifil,titel,fulll)
    end
  end
end
