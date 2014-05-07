function dists = ReadPolca(distfile,distlab,asspos)
% ReadPolca Read from Polca distribution files, often .dat
%
%   polcainfo = ReadPolca(resfile)
%   resinfo = ReadPolca(resfile,readopt)
%   data = ReadPolca(resinfo,label)
%   data = ReadPolca(resinfo,label)
%   data = ReadPolca(resinfo,label,asspos)
%
% Input
%   resfile     - name of res file
%   readopt     - 'nodata' for short version of resinfo (without all adresses to fuel data position
%                 or 'full' for complete resinfo (default 'nodata')
%   label       - labels or distributions both found in resinfo (if more
%                 than one it needs to be placed in a cell array)
%   asspos      - i and j coordinates for separate assemblies, or channel
%                 numbers, serial number of assembly
%   
% Output
%   polcainfo     - for first call a summary of content of resfile. 
%   data          - second call: if one dist or label is choosen, resinfo will be a matrix or
%                 cell array containing the data. If more than one dist or
%                 label resinfo will be a structure .
%
%   Without 2nd input ReadPolca will return polcainfo, which is a struct containing
%   the distrubution list of avaliable distlists and labels and core
%   geometry information.
% Example:
%
% polcainfo = ReadPolca('boc.dat')
% distrubutions=ReadPolca(resinfo,{'XENON', 'SAMARIUM', 'IODINE', 'PROMETHIUM'},[1 2 3]);
% will return a structure with xenon, samarium and iodine distrubutions for
% state points 1,2 and 3.   
% 
% See also ReadCore, ReadRes, ReadOut, ReadSum, ReadCms
if nargin==1||ischar(distfile),
    [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile);
  polcainfo.distlist=cellstr(distlist);
  polcainfo.core.mminj=mminj;
  polcainfo.core.iafull=mz(12);
  polcainfo.core.kmax=mz(11);
  polcainfo.core.kan=mz(14);
  if mod(mz(2),2)==0, %mirror
      polcainfo.core.symc=2;
  else
      polcainfo.core.symc=1;
  end
  polcainfo.core.irmx=mz(68);
  polcainfo.core.ilmx=mz(68)-1; % Quick and dirty for now Warning!!
  if mz(1)==1, 
      polcainfo.core.lwr='BWR';
  elseif mz(1)==2,
      polcainfo.core.lwr='PWR';
  else
      polcainfo.core.lwr='UNKNOWN';
  end
  polcainfo.core.if2x2=mz(3);
  Iwant=[4 3 3 2 2 3 3 2 2];
  if mz(2)>3&&mz<8,
      warning('symmetry not supported, results may be wrong');
  end
  polcainfo.core.iwant=Iwant(mz(2));
  polcainfo.core.ihaveu=polcainfo.core.iwant;
  polcainfo.core.crmminj=mminj2crmminj(mminj,polcainfo.core.irmx);
  switch polcainfo.core.iwant
      case 1
          polcainfo.core.sym='1/8';
      case 2
          polcainfo.core.sym='QUART';
      case 3
          polcainfo.core.sym='HALF';
      case 4
          polcainfo.core.sym='FULL';
  end
  polcainfo.core.knum=(1:polcainfo.core.kan)';
  n=polcainfo.core.iafull-2;
  detmap=vec2cor(detpos,mminj);
  polcainfo.core.detloc=detmap(2:2:n,2:2:n);
  polcainfo.core.hz=100*bb(1)/polcainfo.core.kmax;
  polcainfo.core.hx=100*bb(13);
  polcainfo.Xpo=bb(41);
  polcainfo.fileinfo.fullname=file('normalize',distfile);
  polcainfo.fileinfo.name=file('tail',distfile);
  polcainfo.fileinfo.Sim='P7';
  polcainfo.fileinfo.ismatlab=ismatlab;
  polcainfo.misclist={''};
  polcainfo.core.konrod=konrod;
  dists=polcainfo;
else
    polcainfo=distfile;
end

if nargin>1,
    if strcmpi(distlab,'KONROD')||strcmpi(distlab,'CRD.POS'),
        dists=polcainfo.core.konrod;
    else
        dists=readdist7(polcainfo.fileinfo.fullname,distlab);
    end
end
    
    
