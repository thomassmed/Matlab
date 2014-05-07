function [FORMAT, nr] = GetFormatNrS5(Label,varargin)
% GetFormatNR Returns the FORMAT and nr cells to be used in reading
% binary files. Will not work for all Labels, where different dimensions
% are needed to get nr. 
%
%  [FORMAT, nr] = GetFormatNr(Label)
%  [FORMAT, nr] = GetFormatNr(Label,resinfo)
%
% Input
%   Label       - Label 
%   resinfo     - from FindLabels
%   
% Output
%   FORMAT      - Cell array with the format of the binary file part
%   nr          - Cell array with the length of the FORMAT in binary file
%
% Example:
%
% [FORMAT,nr]=GetFormatNr('Parameters');
% [FORMAT,nr]=GetFormatNr('SEGMENT',resinfo);
%
% See also FindLabels, GetNextRecord
%
% TODO: Check for all logical and change to FORMAT 'logic'

% Programmers notes: 
if nargin == 2
    resinfo = varargin{:};
    Parameters = resinfo.data.Parameters;
    Dimensions = resinfo.data.Dimensions;
    LMPAR=double(Parameters{1,1});
    limaclo=LMPAR(1);   limc=LMPAR(2);      limseg=LMPAR(3);    limhyd=LMPAR(4);    limid=LMPAR(5);     limfue=LMPAR(16);
    limnht=LMPAR(17);   limpas=LMPAR(18);   limray=LMPAR(19);   limreg=LMPAR(20);   limtfu=LMPAR(22);   limzon=LMPAR(23);   lmnhyd=LMPAR(24);
    limida = LMPAR(6);
    LMPAR2=double(Parameters{1,2});
    limnd=LMPAR2(1);    limctp=LMPAR2(2);   limspa=LMPAR2(3);   limtab=LMPAR2(4);   limtv1=LMPAR2(5);   limtv2=LMPAR2(6);   limele=LMPAR2(7);
    limcrd=LMPAR2(8);   lcrzon=LMPAR2(9);   limch1=LMPAR2(29);  limzmd=LMPAR2(30);  limlkg=LMPAR2(33);  limwtr=LMPAR2(35);  limsup=LMPAR2(36);
    limir=LMPAR2(58);   limct=LMPAR2(65);   nsegch=LMPAR2(91);
    lisinp = LMPAR2(10);
    lixinp = LMPAR2(11);
    lisqpa = LMPAR2(12);
    lissta = LMPAR2(13);
    lismac = LMPAR2(14);
    lisdfs = LMPAR2(15);
    lixsta = LMPAR2(16);
    lisdet = LMPAR2(17);
    lixdet = LMPAR2(18);
    lispin = LMPAR2(19);
    limbat=Parameters{1,3};
    lngng=Parameters{1,4}(1); lnstp=Parameters{1,4}(2); lngngstp=Parameters{1,4}(3);  lnrestp=Parameters{1,4}(4);
    lwr=char(Dimensions{1,1});
    iafull=double(Dimensions{2,1}(1));
    irmx=double(Dimensions{2,1}(2));
    ilmx=double(Dimensions{2,1}(3));
    iofset=double(Dimensions{2,1}(4));
    ihaveu=double(Dimensions{1,2}(1));
    if2x2=double(Dimensions{1,2}(3));
    kmax=double(Dimensions{1,2}(2));
    isymc=double(Dimensions{1,2}(6));
    ida=double(Dimensions{1,2}(7));
    jda=double(Dimensions{1,2}(8));
    id=double(Dimensions{1,2}(9));
    jd=double(Dimensions{1,2}(10));
    kd=double(Dimensions{1,2}(11));
end

for i= fliplr(1:length(Label)); 
    if Label(i) ~= ' '
        newstr = Label(1:i);
        break;
    end
end

switch upper(strtrim(newstr))

    case 'PARAMETERS'
        

        FORMAT=cell(3,4);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;  FORMAT{1,2}='int';   nr{1,2}=91; FORMAT{1,3}='int'; nr{1,3}=1; FORMAT{1,4}='int'; nr{1,4}=-1;
                                FORMAT{2,2}='float'; nr{2,2}=1;
                                FORMAT{3,2}='int';   nr{3,2}=-1;
                                FORMAT{1,5} = 'int'; nr{1,5} = 1;

    case 'TITLE'
        FORMAT=cell(2,4);nr=FORMAT;
        FORMAT{1,1}='*char';   FORMAT{1,2}='*char';   FORMAT{1,3}='float'; nr{1,3}=3;
                                                    FORMAT{2,3}='int';
        FORMAT{1,4}='int'; nr{1,4} = 3;
        FORMAT{2,4}='*char';

    case 'S5 PARAMETERS'
        FORMAT{1,1} = 'int';   nr{1,1} =-1;
        FORMAT{1,2} = 'int';   nr{1,2} =-1;

        
    case 'DIMENSIONS'
        FORMAT=cell(2,4);nr=FORMAT;
        FORMAT{1,1}='*char'; nr{1,1}=3;   FORMAT{1,2}='int'; nr{1,2}=12;   FORMAT{1,3}='*char';     FORMAT{1,4}='int'; nr{1,4}=-1; 
        FORMAT{2,1}='int'; nr{2,1}=4;  


    case 'DERIVED TERMS'

        FORMAT=cell(2,3);nr=FORMAT;
        FORMAT{1,1}='double';               
        FORMAT{1,2}='float';  nr{1,2}=6;    
       
        FORMAT{1,3}='float'; nr{1,3}=-1;
        FORMAT{2,1}='float'; nr{2,1}=5;     
        FORMAT{2,2}='int';    nr{2,2}=5;
        
%     case 'BPSHUFFLE'
%         FORMAT{1,1} = 'int';  nr{1,1} = 1;
%         FORMAT{2,1} = 'int';  nr{2,1} = 1;
%         FORMAT{1,2} = 'char'; nr{1,2} = iafull*iafull*6;

    case 'CORE'

        FORMAT=cell(1,5);nr=FORMAT;
        FORMAT{1,1}='float';    nr{1,1}=26;       
        FORMAT{1,2}='int';      nr{1,2}=5;    
        FORMAT{1,3}='float';    nr{1,3}=1;
        FORMAT{1,4}='int';      nr{1,4}=2;          
        FORMAT{1,5}='float';    nr{1,5}=1;



    case 'CUSTOM'

        FORMAT=cell(1,3);nr=FORMAT;
        FORMAT{1,1}='*char'; nr{1,1}=16;        FORMAT{1,2}='int'; nr{1,2}=1;    FORMAT{1,3}='*char'; nr{1,3}=400;



    case 'ITERATION'

        FORMAT=cell(2,6);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=3;           FORMAT{1,2}='int'; nr{1,2}=8;       FORMAT{1,3}='double'; nr{1,3}=2;
                                                                                    FORMAT{2,3}='float';  nr{2,3}=4;
        FORMAT{1,4}='float';  nr{1,4}=5;        FORMAT{1,5}='int';  nr{1,5}=8;      FORMAT{1,6}='int';    nr{1,6}=1;

    case 'NEU3ITER'
        FORMAT{1,1} = 'int';   nr{1,1} =1; %ne_itpvmax
        FORMAT{2,1} = 'int';   nr{2,1} =1; %ne_itcoef
        FORMAT{3,1} = 'int';   nr{3,1} =1; %ne_itcheb
        FORMAT{4,1} = 'int';   nr{4,1} =1; %ne_itfsout
        FORMAT{5,1} = 'int';   nr{5,1} =1; %ne_itfsin
        
        FORMAT{1,2} = 'float';   nr{1,2} =1; %ne_accpow
        FORMAT{2,2} = 'float';   nr{2,2} =1; %ne_gamche
        FORMAT{3,2} = 'float';   nr{3,2} =1; %ne_omeflx
        FORMAT{4,2} = 'float';   nr{4,2} =1; %ne_ometrl
        
        FORMAT{1,3} = 'logic';   nr{1,3} =-1; %ifupscat
        
        FORMAT{1,4} = 'int';   nr{1,4} =1; %ne_itmeth
        FORMAT{2,4} = 'int';   nr{2,4} =1; %inewder
        
        FORMAT{1,5} = 'int';   nr{1,5} =1; %ismx
        FORMAT{2,5} = 'int';   nr{2,5} =1; %nsplt
        
        FORMAT{1,6} = 'int';   nr{1,6} =1; %ne_nsubflat
        FORMAT{2,6} = 'logic';   nr{2,6} =1; %ne_ppowrec
        
        FORMAT{1,7} = 'int';   nr{1,7} =1; %ne_smxmodl
        FORMAT{2,7} = 'float';   nr{2,7} =1; %ne_omefis
        FORMAT{3,7} = 'int';   nr{3,7} =1; %ne_p3_tr
        FORMAT{4,7} = 'int';   nr{4,7} =1; %ne_it_cmrb
        FORMAT{5,7} = 'int';   nr{5,7} =1; %ne_pinopt
        FORMAT{6,7} = 'int';   nr{6,7} =1; %ne_smx_baf
        FORMAT{7,7} = 'int';   nr{7,7} =1; %ne_smx_drv
        FORMAT{8,7} = 'float';   nr{8,7} =1; %ne_omesmx
        FORMAT{9,7} = 'float';   nr{9,7} =-1;
        
        FORMAT{1,8} = 'logic';   nr{1,8} =-1; %ne_xs2flc
        
        FORMAT{1,9} = 'int';   nr{1,9} =1; %ne_detopt
        FORMAT{2,9} = 'logic';   nr{2,9} =1; %ne_useexy
        FORMAT{3,9} = 'logic';   nr{3,9} =1; %ne_usetfxy
        FORMAT{4,9} = 'logic';   nr{4,9} =1; %ne_usexnxy
        FORMAT{5,9} = 'int';   nr{5,9} =1; %ne_smxopt
        FORMAT{6,9} = 'int';   nr{6,9} =1; %ne_smx_fd
        
        
        %         FORMAT{} = '';   nr{} =;
    case 'NEU3ALBEDO'
        FORMAT{1,1} = 'int';   nr{1,1} =1; %maxgrp
        FORMAT{2,1} = 'int';   nr{2,1} =1; %ialbbot
        FORMAT{3,1} = 'int';   nr{3,1} =1; %ialbtop
        FORMAT{4,1} = 'int';   nr{4,1} =1; %ialbsid
        FORMAT{5,1} = 'int';   nr{5,1} =1; %ialbout
        FORMAT{6,1} = 'int';   nr{6,1} =1; %ialbinr
        FORMAT{7,1} = 'float';   nr{7,1} =1; %dzrefbot
        
        FORMAT{1,2} = 'float';   nr{1,2} =-1; %albbot
        FORMAT{1,3} = 'float';   nr{1,3} =-1; %albtop
        FORMAT{1,4} = 'float';   nr{1,4} =-1; %albsid
        FORMAT{1,5} = 'float';   nr{1,5} =-1; %albout
        FORMAT{1,6} = 'float';   nr{1,6} =-1; %albinr
        
        FORMAT{1,7} = 'float';   nr{1,7} =1; %dzrefbot
        FORMAT{2,7} = 'float';   nr{2,7} =1; %dzreftop
        %         FORMAT{} = '';   nr{} =; %
	case 'SDMOPTIONS'
        FORMAT{1,1} = 'int';    nr{1,1} = 1;
        FORMAT{2,1} = '*char';    nr{2,1} = 20;
        FORMAT{1,2} = '*char';   nr{1,2} = 20;
        FORMAT{1,3} = 'float';  nr{1,3} = -1;%????   
        
    case 'DEPLETION'

        FORMAT=cell(3,3);nr=FORMAT;
        FORMAT{1,1}='float'; nr{1,1}=5;    FORMAT{1,2}='float'; nr{1,2}=1;       FORMAT{1,3}='int';  nr{1,3}=1;
        FORMAT{2,1}='int'; nr{2,1}=1;
        FORMAT{3,1}='float'; nr{3,1}=3;



    case 'SDCDATA'

        FORMAT=cell(2,5);nr=FORMAT;
        FORMAT{1,1}='float'; nr{1,1}=3; FORMAT{1,2}='int'; nr{1,2}=-1;   FORMAT{1,3}='float'; nr{1,3}=1; 
        FORMAT{2,1}='int'; nr{2,1}=-1;             

    case 'FUEL'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(6,3);nr=FORMAT;
        FORMAT{1,1}='int';  FORMAT{1,2}='int';   nr{1,2}=limzon*limfue;    FORMAT{1,3}='int';  nr{1,3}=limfue;
        nr{1,1}=1;          FORMAT{2,2}='float'; nr{2,2}=(limzon+1)*limfue;  FORMAT{2,3}='*char'; nr{2,3}=limfue*20;
                    FORMAT{3,2}='int';   nr{3,2}=limreg*limfue;
                    FORMAT{4,2}='float'; nr{4,2}=limreg*limfue;
                    FORMAT{5,2}='int';   nr{5,2}=3*limfue;
                    FORMAT{6,2}='float'; nr{6,2}=-1;    
        end           
                    

    case 'GRID'

        FORMAT=cell(2,5);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=3;   FORMAT{1,2}='float'; nr{1,2}=4; FORMAT{1,3}='*char'; nr{1,3}=-1; 
            FORMAT{1,4}='int'; nr{1,4}=20;     FORMAT{1,5}='*char'; nr{1,5}=-1;
            FORMAT{2,4}='float'; nr{2,4}=776;   


    case 'SEGMENT'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(5,5);nr=FORMAT;
        nr{1,1}=limseg*nsegch;
        FORMAT{1,1}='*char';            FORMAT{1,2}='int'; nr{1,2}=-1;  FORMAT{1,3}='float'; nr{1,3}=9*limseg;
        FORMAT{2,1}='int'; nr{2,1}=limseg;                              FORMAT{2,3}='float'; nr{2,3}=8*limseg;
        FORMAT{3,1}='int'; nr{3,1}=limseg;
        FORMAT{4,1}='int'; nr{4,1}=limseg;
        FORMAT{5,1}='int'; nr{5,1}=limseg;
            FORMAT{1,4}='float';  nr{1,4}=-1;   FORMAT{1,5}='float';  nr{1,5}=-1;
        end

	case 'SEGMENT TFU'    
                FORMAT{1,1} = 'int';   nr{1,1} =-1; %segotfu
    case 'TABLES'     
        %         FORMAT{} = '';   nr{} =; %
    case 'HYDRAULICS'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(4,6);nr=FORMAT;
        FORMAT{1,1}='float'; nr{1,1}=limc;      FORMAT{1,2}='int'; nr{1,2}=2*lmnhyd;      
        FORMAT{2,1}='float'; nr{2,1}=limhyd;    FORMAT{2,2}='float'; nr{2,2}=13*lmnhyd+limnht+2+limbat+limele;
                                        FORMAT{3,2}='int'; nr{3,2}=1;
                                        FORMAT{4,2}='float'; nr{4,2}=9;
        for i=3:5, FORMAT{1,i}='float=>real*4';nr{1,i}=1;end;    FORMAT{1,6}='int'; nr{1,6}=1;
                                                                FORMAT{2,6}='float'; nr{2,6}=-1;
        end    
        
    case 'TH-S5-PRO'

        FORMAT{1,1} = 'int';   nr{1,1} =1;
        FORMAT{2,1} = 'float';   nr{2,1} =1;
        FORMAT{3,1} = 'float';   nr{3,1} =1;
        FORMAT{4,1} = 'float';   nr{4,1} =1;
        FORMAT{5,1} = 'float';   nr{5,1} =1;
        FORMAT{6,1} = 'float';   nr{6,1} =1;
        FORMAT{7,1} = 'int';   nr{7,1} =1;
        FORMAT{8,1} = 'float';   nr{8,1} ={1,7,1};
        FORMAT{9,1} = 'float';   nr{9,1} =1;
        FORMAT{10,1} = 'float';   nr{10,1} =1;
        FORMAT{11,1} = 'int';   nr{11,1} =1;
        FORMAT{12,1} = 'float';   nr{12,1} =1;
        FORMAT{13,1} = 'float';   nr{13,1} =1;
        FORMAT{14,1} = 'float';   nr{14,1} =1;
        FORMAT{15,1} = 'float';   nr{15,1} =1;
        FORMAT{16,1} = 'int';   nr{16,1} =1; 
        FORMAT{17,1} = 'float';   nr{17,1} =1;
        FORMAT{18,1} = 'int';   nr{18,1} =1;
        FORMAT{19,1} = 'int';   nr{19,1} =1;

        nrec = findnumrec('TH-S5-PRO',resinfo);
        if nrec == 5
            FORMAT{1,2} = 'float';   nr{1,3} =-1;
            FORMAT{1,3} = 'float';   nr{1,2} =-1;
        elseif nrec == 4
            FORMAT{1,2} = 'float';   nr{1,3} =-1;
            % VILKEN SKA MAN VÄLJA!?!?! ELLER FIXA SÅ MAN KAN VETA... 18,1
            % o 19,1 säger förstås vilken det är...
        end
            
        FORMAT{1,4} = 'int';   nr{1,4} =-1;
        
        FORMAT{1,5} = 'int';   nr{1,5} =1;
        FORMAT{2,5} = 'float';   nr{2,5} =1;
        FORMAT{3,5} = 'float';   nr{3,5} =1;
        %         FORMAT{} = '';   nr{} =;
    case 'TH-S5-HYD'
        FORMAT{1,1} = 'int';   nr{1,1} =1;
        FORMAT{2,1} = 'int';   nr{2,1} =1;
        FORMAT{3,1} = 'int';   nr{3,1} =1;
        FORMAT{4,1} = 'int';   nr{4,1} =1;
        FORMAT{5,1} = 'int';   nr{5,1} =1;
        FORMAT{6,1} = 'int';   nr{6,1} =1;
        FORMAT{7,1} = 'int';   nr{7,1} =1;
        FORMAT{8,1} = 'int';   nr{8,1} =1;
        FORMAT{9,1} = 'int';   nr{9,1} =1;
        FORMAT{10,1} = 'int';   nr{10,1} =1;
        FORMAT{11,1} = 'int';   nr{11,1} ={2,10,1};
        FORMAT{12,1} = 'logic';   nr{12,1} =2;
        FORMAT{13,1} = 'float';   nr{13,1} =1;
        FORMAT{14,1} = 'float';   nr{14,1} =1;
        FORMAT{15,1} = 'float';   nr{15,1} =1;
        FORMAT{16,1} = '*char';   nr{16,1} =5*8;
        FORMAT{17,1} = 'float';   nr{17,1} =1;
        FORMAT{18,1} = 'float';   nr{18,1} =1;
        FORMAT{19,1} = 'float';   nr{19,1} =1;
        FORMAT{20,1} = 'float';   nr{20,1} =1;
        FORMAT{21,1} = 'float';   nr{21,1} =1;
        FORMAT{22,1} = 'float';   nr{22,1} =1;
        FORMAT{23,1} = 'float';   nr{23,1} =1;
        FORMAT{24,1} = 'float';   nr{24,1} =1;
        FORMAT{25,1} = 'float';   nr{25,1} =1;
        FORMAT{26,1} = 'float';   nr{26,1} =1;
        FORMAT{27,1} = 'float';   nr{27,1} =1;
        FORMAT{28,1} = 'int';   nr{28,1} =1;
%         FORMAT{29,1} = '*char';   nr{29,1} =; TODO: find size?!?!
%         FORMAT{30,1} = '';   nr{30,1} =;
        

        nrec = findnumrec('TH-S5-HYD',resinfo);
        for it = 2:nrec-2
            FORMAT{1,it} = 'int';   nr{1,it} =-1;
        end

        FORMAT{1,6} = 'int';   nr{1,6} =1;
        FORMAT{2,6} = 'float';   nr{2,6} ={2,1,6};
        FORMAT{3,6} = 'int';   nr{3,6} =1;
        FORMAT{4,6} = 'float';   nr{4,6} ={2,3,6};
        FORMAT{5,6} = 'int';   nr{5,6} =1;
        FORMAT{6,6} = 'float';   nr{6,6} ={2,5,6};
        FORMAT{7,6} = 'int';   nr{7,6} =1;
        FORMAT{8,6} = 'float';   nr{8,6} ={2,7,6};
        FORMAT{9,6} = 'int';   nr{9,6} =1;
        FORMAT{10,6} = 'float';   nr{10,6} ={2,9,6};

        FORMAT{1,7} = 'int';   nr{1,7} =1;
        %         FORMAT{} = '';   nr{} =;
    case 'TH-S5-BWR'
        FORMAT{1,1} = 'int';   nr{1,1} =1; %th_thonly
        FORMAT{2,1} = 'int';   nr{2,1} =1; %th_thiso
        FORMAT{3,1} = 'int';   nr{3,1} =1; %th_subth
        FORMAT{4,1} = '*char';   nr{4,1} =8; %t1_tmpopt
        FORMAT{5,1} = '*char';   nr{5,1} =8; %th_flwtotop
        FORMAT{6,1} = '*char';   nr{6,1} =8; %th_flwdisop
        FORMAT{7,1} = '*char';   nr{7,1} =8; %th_prsctrl
        FORMAT{8,1} = 'int';   nr{8,1} =1; %th_prsdep
        FORMAT{9,1} = 'float';   nr{9,1} =1; %th_wclean
        FORMAT{10,1} = 'float';   nr{10,1} =1; %th_tcleann
        FORMAT{11,1} = 'float';   nr{11,1} =1; %th_wcrud
        FORMAT{12,1} = 'float';   nr{12,1} =1; %th_tcrudn
        FORMAT{13,1} = 'float';   nr{13,1} =1; %th_qpumpn
        FORMAT{14,1} = 'float';   nr{14,1} =1; %th_qradn
        FORMAT{15,1} = 'float';   nr{15,1} =1; %th_fmoist
        FORMAT{16,1} = 'int';   nr{16,1} =1; %th_nxcutab
        FORMAT{17,1} = 'int';   nr{17,1} =1; %th_nqpump
        FORMAT{18,1} = 'int';   nr{18,1} =1; %th_nfeed
        FORMAT{19,1} = 'float';   nr{19,1} =1; %th_hlowp
        FORMAT{20,1} = 'float';   nr{20,1} =1; %th_alowp
        FORMAT{21,1} = 'float';   nr{21,2} =1; %th_dlowp
        FORMAT{22,1} = 'float';   nr{22,1} =1; %th_klowp
        FORMAT{23,1} = 'float';   nr{23,1} =1; %th_lalowp
        FORMAT{24,1} = 'float';   nr{24,1} =1; %th_aorif
        FORMAT{25,1} = 'float';   nr{25,1} =1; %th_reorif
        FORMAT{26,1} = 'int';   nr{26,1} =1; %th_norizon  
        FORMAT{27,1} = 'float';   nr{27,1} ={1,26,1}; % arr
        FORMAT{28,1} = '*char';   nr{28,1} =8; % th_bypopt
        FORMAT{29,1} = 'float';   nr{29,1} =1; % th_wfrfixbp
        FORMAT{30,1} = 'float';   nr{30,1} =1; % th_wfroutbp
        FORMAT{31,1} = 'float';   nr{31,1} =1; % th_dzinl
        FORMAT{32,1} = 'float';   nr{32,1} =1; % th_dzout
        FORMAT{33,1} = 'int';   nr{33,1} =1; % th_nwfrtab
        FORMAT{34,1} = 'float';   nr{34,1} =1; % rdum       
        FORMAT{35,1} = 'float';   nr{35,1} =1; % rdum       
        FORMAT{36,1} = 'float';   nr{36,1} =1; % th_hchim
        FORMAT{37,1} = 'int';   nr{37,1} =1; % th_nchiax
        FORMAT{38,1} = 'float';   nr{38,1} =1; % th_huple
        FORMAT{39,1} = 'float';   nr{39,1} =1; %th_auple
        FORMAT{40,1} = 'float';   nr{40,1} =1; %th_duple
        FORMAT{41,1} = 'float';   nr{41,1} =1; %th_kuple
        FORMAT{42,1} = 'float';   nr{42,1} =1; %th_lauple
        FORMAT{43,1} = 'float';   nr{43,1} =1; %th_hstpi
        FORMAT{44,1} = 'float';   nr{44,1} =1; %th_dstpi 
        FORMAT{45,1} = 'float';   nr{45,1} =1; %th_kstpi
        FORMAT{46,1} = 'float';   nr{46,1} =1; %rdum       
        FORMAT{47,1} = 'float';   nr{47,1} =1; %th_lastpi 
        FORMAT{48,1} = 'float';   nr{48,1} =1; %th_nsep
        FORMAT{49,1} = 'float';   nr{49,1} =1; %th_hsepwat
        FORMAT{50,1} = 'float';   nr{50,1} =1; %th_hsepout
        FORMAT{51,1} = 'float';   nr{51,1} =1; %th_dsep
        FORMAT{52,1} = 'float';   nr{52,1} =1; %th_kasep
        FORMAT{53,1} = 'float';   nr{53,1} =1; %th_resep
        FORMAT{54,1} = 'float';   nr{54,1} =1; %th_lasep
        FORMAT{55,1} = 'int';   nr{55,1} =1; %1
        FORMAT{56,1} = '*char';   nr{56,1} =10; %th_pmptyp
        FORMAT{57,1} = 'float';   nr{57,1} =1; %th_hudc
        FORMAT{58,1} = 'float';   nr{58,1} =1; %th_audc
        FORMAT{59,1} = 'float';   nr{59,1} =1; %th_dudc
        FORMAT{60,1} = 'float';   nr{60,1} =1; %th_kudc
        FORMAT{61,1} = 'float';   nr{61,1} =1; %rdum       
        FORMAT{62,1} = 'float';   nr{62,1} =1; %th_laudc
        FORMAT{63,1} = 'float';   nr{63,1} =1; %th_aldc
        FORMAT{64,1} = 'float';   nr{64,1} =1; %th_dldc
        FORMAT{65,1} = 'float';   nr{65,1} =1; %th_kldc
        FORMAT{66,1} = 'float';   nr{66,1} =1; %rdum       
        FORMAT{67,1} = 'float';   nr{67,1} =1; %th_laldc
        
        FORMAT{1,2} = 'int';   nr{1,2} ={1,16,1}; % th_xcutab
        FORMAT{2,2} = 'float';   nr{2,2} ={2,17,1}; % th_qpumpt
        FORMAT{3,2} = 'float';   nr{3,2} ={2,18,1}; % th_tfeedq 
        FORMAT{4,2} = 'int';   nr{4,2} ={1,33,1}; % th_wfrtabbp
        FORMAT{5,2} = 'float';   nr{5,2} =2; % arr
        
        FORMAT{1,3} = 'int';   nr{1,3} =-1; % th_tfuopt
        
        FORMAT{1,4} = 'float';   nr{1,4} =1; % th_fcufix
        FORMAT{2,4} = 'float';   nr{2,4} =1; % th_kbpout
        FORMAT{3,4} = 'float';   nr{3,4} =1; % th_dzudcss
        FORMAT{4,4} = 'float';   nr{4,4} =1; % th_kbsep
        
        FORMAT{1,5} = '*char';   nr{1,5} =-1; % th_hbaltyp
        
        FORMAT{1,6} = 'int';   nr{1,6} =1; % mp_flag
        FORMAT{2,6} = 'float';   nr{2,6} =1; % mp_prenom
        FORMAT{3,6} = 'float';   nr{3,6} =1; % mp_tinnom
        
        
        %         FORMAT{} = '';   nr{} =; % 
    case 'TH-S5-PWR'
        FORMAT{1,1} = 'int';   nr{1,1} =1; % th_thonly
        FORMAT{2,1} = 'int';   nr{2,1} =1; % th_thiso   
        FORMAT{3,1} = '*char';   nr{3,1} =8; % t1_tmpopt
        FORMAT{4,1} = '*char';   nr{4,1} =8; % th_tmpctrl
        FORMAT{5,1} = '*char';   nr{5,1} =8; % th_flwdisop
        FORMAT{6,1} = '*char';   nr{6,1} =8; % th_bypopt
        FORMAT{7,1} = 'int';   nr{7,1} =1; % th_prsdep
        FORMAT{8,1} = 'float';   nr{8,1} =1; % th_wfrbb
        FORMAT{9,1} = '*char';   nr{9,1} =8; % th_crsflw
        FORMAT{10,1} = 'int';   nr{10,1} =1; % th_noddiv
        FORMAT{11,1} = 'float';   nr{11,1} =1; % th_kcrf 
        FORMAT{12,1} = 'float';   nr{12,1} =1; % th_sl
        FORMAT{13,1} = 'float';   nr{13,1} =1; % th_sidgap
        FORMAT{14,1} = 'float';   nr{14,1} =1; % th_omeflow
        FORMAT{15,1} = 'float';   nr{15,1} =1; % th_omedpla
        FORMAT{16,1} = 'int';   nr{16,1} =1; % th_ntinlq 
        
        FORMAT{1,2} = 'float';   nr{1,2} =-1; %th_tinlq
        
        FORMAT{1,3} = 'int';   nr{1,3} =-1; % th_tfuopt

        
        FORMAT{1,4} = 'int';   nr{1,4} =1; % mp_flag
        FORMAT{2,4} = 'float';   nr{2,4} =1; % mp_prenom
        FORMAT{3,4} = 'float';   nr{3,4} =1; % mp_tinnom
        
        %         FORMAT{} = '';   nr{} =; % 
    case 'TH-BWR/PWR'
        
        
        FORMAT{1,1} = 'int';   nr{1,1} =1; % th_thskip                                        
        FORMAT{2,1} = '*char';   nr{2,1} =8; % t2_tmpopt  
        FORMAT{3,1} = '*char';   nr{3,1} =8; % th_flwtotop                          
        FORMAT{4,1} = 'float';   nr{4,1} =1; % th_taverag                                        
        FORMAT{5,1} = 'int';   nr{5,1} =1; % th_maxsup 
        FORMAT{6,1} = 'int';   nr{6,1} =1; % th_numsup   
        FORMAT{7,1} = 'float';   nr{7,1} =1; % th_cofsup   
        FORMAT{8,1} = 'float';   nr{8,1} =1; % th_rhosup   
        FORMAT{9,1} = 'float';   nr{9,1} =1; % th_slipchi 
        FORMAT{10,1} = 'float';   nr{10,1} =1; % th_slipuple 
        FORMAT{11,1} = 'float';   nr{11,1} =1; % th_slipudc            
        FORMAT{12,1} = 'int';   nr{12,1} =1; % th_prsinp  
        FORMAT{13,1} = 'float';   nr{13,1} =1; % th_dpstli                           
        FORMAT{14,1} = 'float';   nr{14,1} =1; % th_pspeed  
        FORMAT{15,1} = 'float';   nr{15,1} =1; % th_pspednom 
        FORMAT{16,1} = 'float';   nr{16,1} =1; % th_pheadnom 
        FORMAT{17,1} = 'float';   nr{17,1} =1; % th_pflownom  
        FORMAT{18,1} = 'int';   nr{18,1} =1; % th_ntavgq  
        FORMAT{19,1} = 'int';   nr{19,1} =1; % th_nhomol         
        
        
        
        %         FORMAT{} = '';   nr{} =; % 
        
        
        nrec = findnumrec('TH-BWR/PWR',resinfo);
        for it = 2:nrec
            FORMAT{1,it} = 'float';   nr{1,it} =-1;
        end
        
        
        
        
        
    case 'TH-MEC2'
        %         FORMAT{} = '';   nr{} =;
    case 'PWR.STM'
        FORMAT{1,1} = 'int';   nr{1,1} =1; %str_isropt
        FORMAT{2,1} = 'int';   nr{2,1} =1; %str_isredit
        FORMAT{3,1} = '*char';   nr{3,1} =4; %str_correl
        FORMAT{4,1} = '*char';   nr{4,1} =4; %str_edit
        FORMAT{5,1} = 'float';   nr{5,1} =1; % str_pinmix
        
%         %         FORMAT{} = '';   nr{} =;
%     case 'ITE.SDM-HWR'
%         FORMAT{1,1} = '';   nr{1,1} =;%sd_kcrit 
%         FORMAT{2,1} = '';   nr{2,1} =;%sd_temp
%         FORMAT{3,1} = '';   nr{3,1} =;%sd_sym
%         FORMAT{4,1} = '';   nr{4,1} =;%sd_dkacc
%         FORMAT{5,1} = '';   nr{5,1} =;%sd_triganm
%         FORMAT{6,1} = '';   nr{6,1} =;%sd_trigadv
%         FORMAT{7,1} = '';   nr{7,1} =;%sd_mcsize
%         FORMAT{8,1} = '';   nr{8,1} =;%sd_maxadd 
%         FORMAT{9,1} = '';   nr{9,1} =;%sd_cib
%         FORMAT{10,1} = '';   nr{10,1} =;%sd_omeflx
%         
%         FORMAT{1,2} = '';   nr{1,2} =;%hwr_typ
%         FORMAT{2,2} = '';   nr{2,2} =;%hwr_sym
%         FORMAT{3,2} = '';   nr{3,2} =;%hwr_dkacc
%         FORMAT{4,2} = '';   nr{4,2} =;%hwr_trigadv
%         
%         
%         %         FORMAT{} = '';   nr{} =;
% 	case 'ITE.HAR'
%         FORMAT{1,1} = '';   nr{1,1} =; %ha_nofeig
%         FORMAT{2,1} = '';   nr{2,1} =; %ha_epsit 
%         FORMAT{3,1} = '';   nr{3,1} =; %ha_iterin
%         FORMAT{4,1} = '';   nr{4,1} =; %ha_iterout
%         FORMAT{5,1} = '';   nr{5,1} =; %ha_shiftk
%         FORMAT{6,1} = '';   nr{6,1} =; %ha_rhogs
%         
%             %         FORMAT{} = '';   nr{} =; %
            
    case 'UNIFORM MDT'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(1,4);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=1;  FORMAT{1,2}='float'; nr{1,2}=lmnhyd;  FORMAT{1,3}='int'; nr{1,3}=lmnhyd; 
        FORMAT{1,4}='float'; nr{1,4}=limnht*lmnhyd;
        end

        

    case 'AXIAL MDT'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(1,6);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=2;  FORMAT{1,2}='float'; nr{1,2}=lmnhyd*limspa;  
        for i=3:6, FORMAT{1,i}='float'; nr{1,i}=limzmd*lmnhyd; end 
        end



    case 'BYPASS FLOW'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(6,6);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=4;  FORMAT{1,2}='int';   nr{1,2}=2;  FORMAT{1,3}='float'; nr{1,3}=lmnhyd; 
                                       FORMAT{2,2}='float'; nr{2,2}=2;  FORMAT{2,3}='float'; nr{2,3}=lmnhyd;
                                       FORMAT{3,2}='int';   nr{3,2}=1;
                                       FORMAT{4,2}='float'; nr{4,2}=1;  
                                       FORMAT{5,2}='int';   nr{5,2}=1;
                                       FORMAT{6,2}='float'; nr{6,2}=1;                                 
       

        FORMAT{1,4}='float'; nr{1,4}=-1; FORMAT{1,5}='int'; nr{1,5}=limwtr*lmnhyd; FORMAT{1,6}='int'; nr{1,6}=limsup;
                                         FORMAT{2,5}='float'; nr{2,5}=-1;          FORMAT{2,6}='float'; nr{2,6}=-1;


         end
    case 'BYPASS VOID'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else        
        FORMAT=cell(2,12);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=3;            FORMAT{1,2}='int';   nr{1,2}=-1;          FORMAT{1,3}='float'; nr{1,3}=-1; 
        FORMAT{1,4}='float'; nr{1,4}=-1;         FORMAT{1,5}='float'; nr{1,5}=-1;          FORMAT{1,6}='*char';
        FORMAT{1,7}='*char';                     FORMAT{1,8}='int'; nr{1,8}=limwtr*lmnhyd; FORMAT{1,9}='int'; nr{1,9}=limwtr*lmnhyd; 
                                                FORMAT{2,8}='float'; nr{2,8}=-1;          FORMAT{2,9}='float'; nr{2,9}=-1;
        FORMAT{1,10}='int'; nr{1,10}=2;          FORMAT{1,11}='float'; nr{1,11}=-1;        FORMAT{1,12}='float'; nr{1,12}=-1;


        end
    case 'CORWIJ'

        FORMAT=cell(1,5);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='int'; nr{1,2}=-1;   FORMAT{1,3}='int'; nr{1,3}=-1;    FORMAT{1,4}='float'; nr{1,4}=-1;
        FORMAT{1,5}='int'; nr{1,5}=-1;



    case 'VOIDQUAL'

        FORMAT=cell(1,1);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=1;   


    case 'EPRIMOD'

        FORMAT=cell(1,5);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='float'; nr{1,2}=-1;    FORMAT{1,3}='float'; nr{1,3}=-1;
        FORMAT{1,4}='float'; nr{1,4}=-1;  FORMAT{1,5}='float'; nr{1,5}=-1;

        
	case 'BWR TLM'
        FORMAT{1,1} = '*char';  nr{1,1} =256;
        FORMAT{2,1} = '*char';  nr{2,1} =8;
        FORMAT{3,1} = '*char';  nr{3,1} =8;
        FORMAT{1,2} = 'int';  nr{1,2} =1;
        FORMAT{2,2} = '*char';  nr{2,2} =-1;
        
    case 'PRIASM'
        FORMAT{1,1} = 'int';  nr{1,1} =1;
        FORMAT{1,2} = 'int';  nr{1,2} =1;
        FORMAT{1,3} = '*char';  nr{1,3} =-1;   
        
        
	case 'PWR DATA'
        FORMAT{1,1} = 'float';  nr{1,1} =limctp;
        FORMAT{2,1} = 'float';  nr{2,1} =limctp;   
        
	case 'CVCS DATA'
        FORMAT{1,1} = 'int';  nr{1,1} =1;
        FORMAT{2,1} = 'float';  nr{2,1} =1;
        FORMAT{3,1} = 'float';  nr{3,1} =1;
        FORMAT{4,1} = 'int';  nr{4,1} =1;
        FORMAT{5,1} = 'float';  nr{5,1} =1;
        FORMAT{6,1} = 'float';  nr{6,1} =1;
        FORMAT{7,1} = 'float';  nr{7,1} =1;
        FORMAT{8,1} = 'float';  nr{8,1} =1;
        
        
	case 'PWRSTEAM'
            %         FORMAT{} = '';   nr{} =;
	case 'PIN PCI'
        %         FORMAT{} = '';   nr{} =;
    case 'PRINT'
        
        FORMAT{1,1} = 'int';    nr{1,1} = 10;
        FORMAT{2,1} = '*char';   nr{2,1} =limida*2;
        FORMAT{3,1} = '*char';   nr{3,1} =limida*2;
        FORMAT{4,1} = 'int';    nr{4,1} =1;
        FORMAT{5,1} = 'int';    nr{5,1} =1;
        FORMAT{6,1} = 'int';    nr{6,1} =1;
        
        FORMAT{1,2} = 'logic';  nr{1,2} =1;
        FORMAT{2,2} = '*char';  nr{2,2} =lisinp*4;
        FORMAT{3,2} = '*char';  nr{3,2} =4;
        FORMAT{4,2} = '*char';  nr{4,2} =lisqpa*4;
        FORMAT{5,2} = '*char';  nr{5,2} =lissta*4;
        FORMAT{6,2} = '*char';  nr{6,2} =4;
        FORMAT{7,2} = '*char';  nr{7,2} =4;
        FORMAT{8,2} = '*char';  nr{8,2} =4;
        FORMAT{9,2} = '*char';  nr{9,2} =4*lisdet;
        FORMAT{10,2} = '*char';  nr{10,2} =4*lismac;
        FORMAT{11,2} = '*char';  nr{11,2} =4*lisdfs;
        FORMAT{12,2} = '*char';  nr{12,2} =4*lixinp;
        FORMAT{13,2} = '*char';  nr{13,2} =4*lixsta;
        FORMAT{14,2} = '*char';  nr{14,2} =4*lixdet;
        
        FORMAT{1,3} = 'int';  nr{1,3} =1;
        FORMAT{2,3} = 'int';  nr{2,3} =1;
        FORMAT{3,3} = 'int';  nr{3,3} =1;
        
        FORMAT{1,4} = '*char';  nr{1,4} =4*lispin;
        
        FORMAT{1,5} = 'int';  nr{1,5} =1;
        
        FORMAT{1,6} = 'int';  nr{1,6} =1;
        
        FORMAT{1,7} = 'float';  nr{1,7} =-1;
        
        FORMAT{1,8} = 'int';  nr{1,8} =1;    
        
    case 'UNITS'

        FORMAT=cell(1,2);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='int'; nr{1,2}=-1;   

    case 'DIMSTR'
        FORMAT{1,1} = 'logic';  nr{1,1} =1;         
    case 'STEAM'
        FORMAT{1,1} = 'int';  nr{1,1} =1;
    case 'CMSVIEW' 
        % TODO: do not know if thisd does the right thing..
        FORMAT{1,1} = 'int';  nr{1,1} =1;
        FORMAT{1,2} = '*char';  nr{1,2} =4;
        FORMAT{2,2} = '*char';  nr{2,2} ={8,1,1};
        FORMAT{3,2} = 'float';  nr{3,2} ={1,1,1};
        FORMAT{4,2} = 'int';  nr{4,2} ={1,1,1};
        FORMAT{1,3} = '*char';  nr{1,3} =-1;
    case 'PINFIL'
        FORMAT{1,1} = '*char';  nr{1,1} =4;
        FORMAT{1,2} = 'int';  nr{1,2} =1;
    case 'PIN EXPOSURE CONTROL'
        FORMAT{1,1} = 'int';  nr{1,1} =1;
        FORMAT{1,2} = 'int';  nr{1,2} =1;
        FORMAT{1,3} = 'logic';  nr{1,3} =1;

    case 'LABELS'
        FORMAT{1}='*char';FORMAT{1,2}='*char';
        nr{1}=-1;nr{1,2}=-1;
        
    case 'HEAVY METAL'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else        
        FORMAT=cell(1,1);nr=FORMAT;
        FORMAT{1,1}='float'; nr{1,1}=iafull*iafull;
        end
    case 'ROTATION'
        FORMAT{1,1} = 'int';  nr{1,1} =iafull^2;
    case 'LOCATION'
        FORMAT{1,1} = 'int';  nr{1,1} = -1;
        
    case 'FIXED MAPS'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else        
        FORMAT=cell(1,6);nr=FORMAT;
        FORMAT{1,1}='float'; nr{1,1}=id*jd;
        for i=[3 4 5], FORMAT{1,i}='float'; nr{1,i}=ida*jda; end
        for i=[2 6], FORMAT{1,i}='int'; nr{1,i}=ida*jda; end
        end

    case 'CRD STP'

        FORMAT=cell(1,8);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='*char';  FORMAT{1,3}='*char';
        FORMAT{1,4}='*char';             FORMAT{1,5}='*char';  FORMAT{1,6}='*char';
        FORMAT{1,7}='*char';             FORMAT{1,8}='int'; nr{1,8}=-1;%lnrestp;

    case 'PRICSV FILE'
        FORMAT{1,1} = 'logic';  nr{1,1} =1;
        
    case 'ROD'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(5,6);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=3; for i=2:4, FORMAT{1,i}='int'; nr{1,i}=irmx*irmx; end;    FORMAT{1,5}='float'; nr{1,5}=lcrzon*limcrd;
        FORMAT{2,1}='int'; nr{2,1}=limray*limpas;                                         FORMAT{2,5}='float'; nr{2,5}=2*(limct+1);
        FORMAT{3,1}='int'; nr{3,1}=2;           % Note on nr{2,5}: it should not be
        FORMAT{4,1}='float'; nr{4,1}=-1;         % like this, but it has to to make
                                                % it work! It should really be
                                                % nr{2,5}=2*limct; !!!
                                                                                                FORMAT{3,5}='int';   nr{3,5}=lcrzon*limcrd;
                                                                                        FORMAT{4,5}='int';   nr{4,5}=limcrd;
                                                                                        FORMAT{5,5}='*char'; nr{5,5}=-1;
                                                FORMAT{1,6}='float'; nr{1,6}=-1;


        end
        
	case 'SEARCH'
        FORMAT{1,1} = 'logic';  nr{1,1} = 1;
        FORMAT{2,1} = 'int';   nr{2,1} =1;
        FORMAT{3,1} = 'int';   nr{3,1} =1;
        FORMAT{4,1} = 'int';   nr{4,1} =1;
        FORMAT{5,1} = 'int';   nr{5,1} =1;
        FORMAT{1,2} = 'float';   nr{1,2} =1;
        FORMAT{2,2} = 'float';   nr{2,2} =1;
        FORMAT{3,2} = 'float';   nr{3,2} =1;
        FORMAT{4,2} = 'float';   nr{4,2} =1;
        FORMAT{5,2} = 'float';   nr{5,2} =1;
        FORMAT{6,2} = 'float';   nr{6,2} =1;
        FORMAT{1,3} = 'float';   nr{1,3} =-1;
        FORMAT{1,4} = 'float';   nr{1,4} =-1;
        FORMAT{1,5} = 'float';   nr{1,5} =-1;
        % TABSR is not here   
        
    case 'SPEED'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{2,1} = 'logic';   nr{2,1} =1;
        FORMAT{3,1} = 'logic';   nr{3,1} =1;
        FORMAT{4,1} = 'logic';   nr{4,1} =1;
        FORMAT{5,1} = 'logic';   nr{5,1} =1;
        FORMAT{6,1} = 'logic';   nr{6,1} =1;
%         FORMAT{7,1} = 'int';   nr{7,1} =1;
%         
%     case 'SUBNODE'
%         
%         FORMAT{1,1} = '';   nr{1,1} =; %isubopt0
%         FORMAT{2,1} = '';   nr{2,1} =; %isubdep
%         FORMAT{3,1} = '';   nr{3,1} =; %isubxen
%         FORMAT{4,1} = '';   nr{4,1} =; %ifpcdep
%         
%         FORMAT{1,2} = '';   nr{1,2} =; %ifhist
        
    %         FORMAT{} = '';   nr{} =; %
    case 'BORON DEPLETION'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{2,1} = 'float';   nr{2,1} =1;
        FORMAT{3,1} = 'float';   nr{3,1} =1;
        FORMAT{4,1} = 'float';   nr{4,1} =1;
        FORMAT{5,1} = 'float';   nr{5,1} =1;
        FORMAT{6,1} = 'float';   nr{6,1} =1;
        FORMAT{7,1} = 'float';   nr{7,1} =1;
        FORMAT{8,1} = 'float';   nr{8,1} =1;
        
%         % TODO: there are more of these...
%         
%     case 'ADAPTLPRM'
%         FORMAT{1,1} = '';   nr{1,1} =; %lmlprm
%         FORMAT{2,1} = '';   nr{2,1} =; %kdfuel
%         
%         FORMAT{1,2} = '';   nr{1,2} =; %ntipac
%         FORMAT{2,2} = '';   nr{2,2} =; %etlprm
%         FORMAT{3,2} = '';   nr{3,2} =; %tipmax
%         FORMAT{4,2} = '';   nr{4,2} =; %tipmin
%         FORMAT{5,2} = '';   nr{5,2} =; %prmmax
%         FORMAT{6,2} = '';   nr{6,2} =; %prmmin
%         FORMAT{7,2} = '';   nr{7,2} =; %dprmde
%         
%         FORMAT{1,3} = '';   nr{1,3} =-1; %maskdt
%         FORMAT{1,4} = '';   nr{1,4} =-1; %resd1
%         FORMAT{1,5} = '';   nr{1,5} =-1; %resd2
%         FORMAT{1,6} = '';   nr{1,6} =-1; %resd3
%         FORMAT{1,7} = '';   nr{1,7} =-1; %resd4
%         FORMAT{1,8} = '';   nr{1,8} =-1; %resd5
%         FORMAT{1,9} = '';   nr{1,9} =-1; %adp3d
%         
%         %         FORMAT{} = '';   nr{} =; %
%     case 'ADAPTLPRM-EXP'
%         FORMAT{1,1} = '';   nr{1,1} =;
%         FORMAT{2,1} = '';   nr{2,1} =;
%         FORMAT{3,1} = '';   nr{3,1} =;
%         
%         FORMAT{1,2} = '';   nr{1,2} =-1;
%         
%         FORMAT{1,2} = '';   nr{1,2} =-1;
%         
%     case 'ADAPTLPRM-MODEL'
%         FORMAT{} = '';   nr{} =;
%         FORMAT{} = '';   nr{} =;
%         FORMAT{} = '';   nr{} =;
%         % ... 23 st...
%         
%         FORMAT{1,2} = '';   nr{1,2} =-1;
%         FORMAT{1,3} = '';   nr{1,3} =-1;
%         FORMAT{1,4} = '';   nr{1,4} =-1;
%         FORMAT{1,5} = '';   nr{1,5} =;
%         FORMAT{2,5} = '';   nr{2,5} =;
%         FORMAT{3,5} = '';   nr{3,5} =;
%         FORMAT{1,6} = '';   nr{1,6} =-1;
        
    case 'ADAPTLPRM-CALIB'
        %         FORMAT{} = '';   nr{} =; %
    case 'CRDHIST'
        FORMAT{1,1} = 'float';   nr{1,1} =6;
%         FORMAT{2,1} = 'float';   nr{2,1} =1;
%         FORMAT{3,1} = 'float';   nr{3,1} =1;
%         FORMAT{4,1} = 'float';   nr{4,1} =1;
%         FORMAT{5,1} = 'float';   nr{5,1} =1;
%         FORMAT{6,1} = 'float';   nr{6,1} =1;
        
    case 'SPECTRAL'
        FORMAT{1,1} = 'float';   nr{1,1} =-1;
        FORMAT{1,2} = 'float';   nr{1,2} =-1;
        FORMAT{1,3} = 'float';   nr{1,3} =-1;
        FORMAT{1,4} = 'float';   nr{1,4} =-1;
        FORMAT{1,5} = 'float';   nr{1,5} =-1;
        FORMAT{1,6} = 'float';   nr{1,6} =-1;
        FORMAT{1,7} = 'float';   nr{1,7} =-1;
        FORMAT{1,8} = 'float';   nr{1,8} =-1;
        FORMAT{1,9} = 'float';   nr{1,9} =-1;
        FORMAT{1,10} = 'float';   nr{1,10} =-1;
        FORMAT{1,11} = 'int';   nr{1,11} =-1;
        FORMAT{1,12} = 'float';   nr{1,12} =1;
        FORMAT{2,12} = 'float';   nr{2,12} =1;
        FORMAT{3,12} = 'float';   nr{3,12} =1;
        FORMAT{1,13} = '*char';   nr{1,13} =-1;
        FORMAT{1,14} = 'float';   nr{1,14} =-1;
        

    case 'BWROPTS'
        FORMAT{1,1} = 'int';   nr{1,1} =-1;
        FORMAT{1,2} = 'int';   nr{1,2} =-1;
    case 'FLUENCE'
        FORMAT{1,1} = 'float';   nr{1,1} =-1;
        
    case 'BOW'
        
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{2,1} = 'float';   nr{2,1} =1;
        FORMAT{3,1} = 'float';   nr{3,1} =1;
        FORMAT{4,1} = '*char';   nr{4,1} =8;
        FORMAT{5,1} = 'int';   nr{5,1} =1;
        FORMAT{6,1} = 'int';   nr{6,1} =1;
        
        FORMAT{1,2} = 'float';   nr{1,2} =-1;
        FORMAT{1,3} = 'float';   nr{1,3} =-1;
        FORMAT{1,4} = 'float';   nr{1,4} =-1;
        
        %TODO: check if nessesary the rest
        
%         FORMAT{} = '';   nr{} =;

%         FORMAT{} = '';   nr{} =;
    case 'RR1GMW'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{1,2} = 'int';   nr{1,2} =-1;
        FORMAT{1,3} = 'float';   nr{1,3} =-1;
%         FORMAT{} = '';   nr{} =;
        
%         FORMAT{} = '';   nr{} =;
    case 'PRM'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{2,1} = 'logic';   nr{2,1} =1;
        FORMAT{3,1} = 'logic';   nr{3,1} =1;
        FORMAT{4,1} = 'logic';   nr{4,1} =1;
        FORMAT{5,1} = 'logic';   nr{5,1} =1;
        FORMAT{6,1} = 'int';   nr{6,1} =-1;
        
        FORMAT{1,2} = 'int';   nr{1,2} =1;
        FORMAT{2,2} = 'float';   nr{2,2} =1;
        FORMAT{3,2} = 'float';   nr{3,2} =-1;
        
        FORMAT{1,3} = 'int';   nr{1,3} =-1;
        
        FORMAT{1,4} = 'int';   nr{1,4} =-1;
        
        FORMAT{1,5} = 'float';   nr{1,5} =-1;
        
        FORMAT{1,6} = 'float';   nr{1,6} =-1;
        
        FORMAT{1,7} = 'float';   nr{1,7} =-1;
        
        FORMAT{1,8} = 'float';   nr{1,8} =-1;
        
        FORMAT{1,9} = '*char';   nr{1,9} =-1;
        
        FORMAT{1,10} = '*char';   nr{1,10} =-1;
        
        FORMAT{1,11} = '*char';   nr{1,11} =-1;
        
        FORMAT{1,12} = 'float';   nr{1,12} =-1;
        
        FORMAT{1,13} = 'int';   nr{1,13} =-1;
        
        FORMAT{1,14} = 'int';   nr{1,14} =-1;
        
        FORMAT{1,15} = 'float';   nr{1,15} =-1;
        
        FORMAT{1,16} = 'float';   nr{1,16} =-1;
        
        FORMAT{1,17} = 'float';   nr{1,17} =-1;
        
%         FORMAT{1,18} = '';   nr{1,18} =;
        
        FORMAT{1,19} = '*char';   nr{1,19} =-1;
%         FORMAT{} = '';   nr{} =;

    case 'DETECTOR'

        FORMAT=cell(1,1);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;  
% 
% 	case 'EXCORE_DET'
%         FORMAT{1,1} = '';   nr{1,1} =; %ne_runexc
%         FORMAT{2,1} = '';   nr{2,1} =; %ne_nexdet
%         FORMAT{3,1} = '';   nr{3,1} =; %ne_rtank
%         FORMAT{4,1} = '';   nr{4,1} =; %ne_rexdet
%         FORMAT{5,1} = '';   nr{5,1} =; %ne_zexdet
%         FORMAT{6,1} = '';   nr{6,1} =; %ne_exitmu2
%         FORMAT{7,1} = '';   nr{7,1} =; %ne_angle
%         FORMAT{8,1} = '';   nr{8,1} =; %ne_calib
        
%         FORMAT{} = '';   nr{} =; %
    case 'VERSION 2.20'

        FORMAT=cell(1,1);nr=FORMAT;
        FORMAT{1,1}='float'; nr{1,1}=-1;     


    case 'VERSION 2.40'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
        FORMAT=cell(4,1);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=kd;      
        FORMAT{2,1}='float'; nr{2,1}=kd;    
        FORMAT{3,1}='int'; nr{3,1}=kd;      
        FORMAT{4,1}='float'; nr{4,1}=2;    
        end

    case 'VERSION 2.60'

        FORMAT=cell(2,4);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=1;       FORMAT{1,2}='int'; nr{1,2}=1;      FORMAT{1,3}='*char'; nr{1,3}=-1;
        FORMAT{2,1}='*char'; nr{2,1}=-1;    %FORMAT{2,1}='*char'; nr{2,2}=-1;

        FORMAT{1,4}='int';  nr{1,4}=5;
        FORMAT{2,4}='float'; nr{2,4}=-1;

    case 'ERR.CHK'
        FORMAT{1,1} = 'int';   nr{1,1} =-1;
        FORMAT{1,2} = '*char';   nr{1,2} ={8,1,1};
        FORMAT{1,3} = 'int';   nr{1,3} =1;
        FORMAT{2,3} = 'int';   nr{2,3} =1;
        FORMAT{1,4} = 'float';   nr{1,4} =-1;
        FORMAT{1,5} = '*char';   nr{1,5} ={8,1,1};
        FORMAT{2,5} = 'int';   nr{2,5} =1;
        FORMAT{1,6} = 'int';   nr{1,6} =-1;

        
    case 'ASSEMBLY MAPS'
        FORMAT{1,1} = 'float';   nr{1,1} =-1;
        FORMAT{1,2} = 'int';   nr{1,2} =-1;
        FORMAT{1,3} = 'int';   nr{1,3} =-1;
        
%         FORMAT{} = '';   nr{} =;
    case 'SUB-ASSEMBLY MAPS'
        FORMAT{1,1} = 'int';   nr{1,1} =-1;
        FORMAT{1,2} = 'float';   nr{1,2} =-1;
        FORMAT{1,3} = 'float';   nr{1,3} =-1;        
        
%     case 'NEW ASSEMBLY DATA'
%        %         FORMAT{} = '';   nr{} =;
%     case 'ASSEMBLY DATA'
% 
%         FORMAT=cell(1,1);nr=FORMAT;
%         FORMAT{1,1}='uchar';nr{1,1}=-1;

%     case 'SUBNODE GEOMETRY'
%         FORMAT{1,1} = '';   nr{1,1} =; %kbt
%         FORMAT{2,1} = '';   nr{2,1} =; %dep_xhgt
        
        %         FORMAT{} = '';   nr{} =; %
%     case 'SUBMESH DATA'
%         %         FORMAT{} = '';   nr{} =;
    case 'MICRO DEPLETION'
        FORMAT{1,1} = 'logic';   nr{1,1} =1; %ifmicdep
        FORMAT{2,1} = 'logic';   nr{2,1} =1; %ifmicsmx
        FORMAT{3,1} = 'int';   nr{3,1} =1; %modmdp
        FORMAT{4,1} = 'int';   nr{4,1} =1; %modmdpgd
        FORMAT{5,1} = 'int';   nr{5,1} =1; %modmdpsmx
        FORMAT{6,1} = 'logic';   nr{6,1} =1; %ifmdp_asloa
        FORMAT{7,1} = 'logic';   nr{7,1} =1; %ifmdp_asenr
        
        %         FORMAT{} = '';   nr{} =; %
        % TODO: if case...
%     case 'ASSEMBLY ISOTOPICS' 
%         FORMAT{} = '';   nr{} =; %
%         
        
        %         FORMAT{} = '';   nr{} =; %
%     case 'SUBMESH ISOTOPICS'
        %         FORMAT{} = '';   nr{} =;
%     case 'PIN BURNUP'
%         FORMAT{} = '';   nr{} =;
%     case 'MORE ASSEMBLY DATA'
        %         FORMAT{} = '';   nr{} =;
%         
%     case 'ASSEMBLY LABELS'
% 
%         FORMAT=cell(4,1);nr=FORMAT;
%         FORMAT{1,1}='int';  nr{1,1}=3;
%         FORMAT{2,1}='*char'; nr{2,1}=6;
%         FORMAT{3,1}='*char'; nr{3,1}=6;
%         FORMAT{4,1}='int';   nr{4,1}=2;

    case 'SHUFFLE DATA'
        FORMAT{1,1}='float';  nr{1,1}=iafull*iafull;
        FORMAT{2,1}='float';  nr{1,1}=iafull*iafull;
        FORMAT{3,1}='int';  nr{1,1}=iafull*iafull;
        FORMAT{4,1}='float';  nr{1,1}=iafull*iafull;
        FORMAT{5,1}='int';  nr{1,1}=iafull*iafull;


    case '3D NODAL RPF'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else
            FORMAT=cell(1,kmax+2);nr=FORMAT;
            id=double(Dimensions{1,2}(9));
            jd=double(Dimensions{1,2}(10));

            for i=1:kmax+2,
              FORMAT{1,i}='float'; nr{1,i}=id*jd;
            end
        end
        
        
 

        

    otherwise
        warning('Label not found or FORMAT and nr not defined for input Label');
        FORMAT = nan(1);
        nr = nan(1);
end
end
% check number of inputs
function y = findnumrec(label,resinfo)
        
    fid1 = fopen(resinfo.fileinfo.fullname,'r','ieee-be');
    fseek(fid1,FindPos(resinfo.data,label)+4,-1);
    y = fread(fid1,1,'int');
    fclose(fid1);
end
            