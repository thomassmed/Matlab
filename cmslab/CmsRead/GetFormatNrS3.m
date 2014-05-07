function [FORMAT, nr] = GetFormatNrS3(Label,varargin)
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

    case 'LABELS'
        FORMAT{1}='*char';FORMAT{1,2}='*char';
        nr{1}=-1;nr{1,2}=-1;
        
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

    case 'UNITS'

        FORMAT=cell(1,2);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='int'; nr{1,2}=-1;   



    case 'HEAVY METAL'
        if nargin == 1
            warning('resinfo is needed to get FORMAT and nr')
            FORMAT = nan(1);
            nr = nan(1);
        else        
        FORMAT=cell(1,1);nr=FORMAT;
        FORMAT{1,1}='float'; nr{1,1}=iafull*iafull;
        end

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
        FORMAT{1,4}='*char';             FORMAT{1,5}='*char';  FORMAT{1,6}='*char'; nr{1,6} = -1;
        FORMAT{1,7}='*char';             FORMAT{1,8}='int'; nr{1,8}=-1;%lnrestp;


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
    case 'DETECTOR'

        FORMAT=cell(1,1);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;  


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



%     case 'ASSEMBLY DATA'
% 
%         FORMAT=cell(1,1);nr=FORMAT;
%         FORMAT{1,1}='uchar';nr{1,1}=-1;
% 
% 
% 
%     case 'ASSEMBLY LABELS'
% 
%         FORMAT=cell(4,1);nr=FORMAT;
%         FORMAT{1,1}='int';  nr{1,1}=3;
%         FORMAT{2,1}='*char'; nr{2,1}=6;
%         FORMAT{3,1}='*char'; nr{3,1}=6;
%         FORMAT{4,1}='int';   nr{4,1}=2;





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
        
        
        
%     case 'BPSHUFFLE'
%         FORMAT{1,1} = 'int';  nr{1,1} = 1;
%         FORMAT{2,1} = 'int';  nr{2,1} = 1;
%         FORMAT{1,2} = 'char'; nr{1,2} = iafull*iafull*6;
%         

       
    case 'SDMOPTIONS'
        FORMAT{1,1} = 'int';    nr{1,1} = 1;
        FORMAT{2,1} = '*char';    nr{2,1} = 20;
        FORMAT{1,2} = '*char';   nr{1,2} = 20;
        FORMAT{1,3} = 'float';  nr{1,3} = 101;%????
        
        
    case 'VOIDCOEF'
        FORMAT{1,1} = 'float';  nr{1,1} =1;
        FORMAT{2,1} = 'float';  nr{2,1} =1;
        FORMAT{1,2} = 'float';  nr{1,2} =1;
        FORMAT{2,2} = 'float';  nr{2,2} =1;
        FORMAT{3,2} = 'float';  nr{3,2} =1;
        FORMAT{4,2} = 'float';  nr{4,2} =1;
        FORMAT{5,2} = 'float';  nr{5,2} =1;
        FORMAT{6,2} = 'float';  nr{6,2} =1;
        FORMAT{7,2} = 'float';  nr{7,2} =1;
        FORMAT{8,2} = 'float';  nr{8,2} =1;
        FORMAT{9,2} = 'float';  nr{9,2} =1;
        
        
        
%     case 'TABLES'
        
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
        
    case 'PWREXCORE'
        FORMAT{1,1} = '*char';  nr{1,1} =4;
        FORMAT{1,2} = 'int';  nr{1,2}= 1;
        FORMAT{2,2} = 'float';  nr{2,2} =1;
        FORMAT{3,2} = 'float';  nr{3,2} =1;
        FORMAT{4,2} = 'float';  nr{4,2} =1;
        FORMAT{5,2} = 'float';  nr{5,2} =1;
        FORMAT{6,2} = 'int';  nr{6,2} =1;
        FORMAT{7,2} = 'int';  nr{7,2} =1;
        FORMAT{8,2} = 'float';  nr{8,2} =1;
        FORMAT{1,3} = 'float';  nr{1,3} =1; %% ?? behöver data från tidigare i samma record.... jobbigt va..
        FORMAT{2,3} = 'float';  nr{2,3} =1;
        FORMAT{3,3} = 'float';  nr{3,3} =1;
        FORMAT{1,4} = 'int';  nr{1,4} =1;
        FORMAT{1,5} = 'float';  nr{1,5} =1;
        FORMAT{2,5} = 'float';  nr{2,5} =1;
        FORMAT{3,5} = 'float';  nr{3,5} =1;
        FORMAT{4,5} = 'logic';  nr{4,5} =1;
        FORMAT{5,5} = 'logic';  nr{5,5} =1;
        FORMAT{6,5} = 'float';  nr{5,6} =1;
        FORMAT{1,6} = 'int';  nr{1,6} =1;
        FORMAT{2,6} = 'int';  nr{2,6} =1;
        FORMAT{1,7} = 'int';  nr{1,7} =1;
        FORMAT{2,7} = 'int';  nr{2,7} =1;
        FORMAT{3,7} = 'float';  nr{3,7} =1;
        FORMAT{1,8} = 'int';  nr{1,8} =1;
        
        

        
        
        
        
        
        
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
    case 'ROTATION'
        FORMAT{1,1} = 'int';  nr{1,1} =iafull^2;
    case 'LOCATION'
        FORMAT{1,1} = 'int';  nr{1,1} = -1;
    case 'PRICSV FILE'
        FORMAT{1,1} = 'logic';  nr{1,1} =1;
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
        FORMAT{7,1} = 'int';   nr{7,1} =1;
        

    case 'BORON DEPLETION'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{2,1} = 'float';   nr{2,1} =1;
        FORMAT{3,1} = 'float';   nr{3,1} =1;
        FORMAT{4,1} = 'float';   nr{4,1} =1;
        FORMAT{5,1} = 'float';   nr{5,1} =1;
        FORMAT{6,1} = 'float';   nr{6,1} =1;
        FORMAT{7,1} = 'float';   nr{7,1} =1;
        FORMAT{8,1} = 'float';   nr{8,1} =1;
        

%     case 'CRDHIST'
%         FORMAT{1,1} = 'float';   nr{1,1} =1;
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
        FORMAT{1,3} = 'int';   nr{1,3} =-1;
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
    case 'GAMMA3D'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{1,2} = 'float';   nr{1,2} =1;
        FORMAT{2,2} = 'float';   nr{2,2} =1;
        FORMAT{1,3} = 'int';   nr{1,3} =1;
        FORMAT{2,3} = 'int';   nr{2,3} =1;
        
%         FORMAT{} = '';   nr{} =;
    case 'RR1GMW'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{1,2} = 'int';   nr{1,2} =-1;
        FORMAT{1,3} = 'float';   nr{1,3} =-1;
%         FORMAT{} = '';   nr{} =;
    case 'HARMONIC'
        FORMAT{1,1} = 'logic';   nr{1,1} =1;
        FORMAT{1,2} = 'int';   nr{1,2} =1;
        FORMAT{2,2} = 'int';   nr{2,2} =1;
        FORMAT{3,2} = 'int';   nr{3,2} =1;
        FORMAT{1,3} = 'float';   nr{1,3} =1;
        FORMAT{2,3} = 'float';   nr{2,3} =1;
        FORMAT{3,3} = 'float';   nr{3,3} =1;
        FORMAT{4,3} = 'float';   nr{4,3} =1;
        FORMAT{5,3} = 'float';   nr{5,3} =1;
        
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
    case 'ERR.CHK'
        FORMAT{1,1} = 'int';   nr{1,1} =-1;
        FORMAT{1,2} = '*char';   nr{1,2} ={8,1,1};
        FORMAT{1,3} = 'int';   nr{1,3} =1;
        FORMAT{2,3} = 'int';   nr{2,3} =1;
        FORMAT{1,4} = 'float';   nr{1,4} =-1;
        FORMAT{1,5} = '*char';   nr{1,5} ={8,1,1};
        FORMAT{2,5} = 'int';   nr{2,5} =1;
        FORMAT{1,6} = 'int';   nr{1,6} =-1;
        
%         FORMAT{} = '';   nr{} =;
    case 'ASSEMBLY MAPS'
        FORMAT{1,1} = 'float';   nr{1,1} =-1;
        FORMAT{1,2} = 'int';   nr{1,2} =-1;
        FORMAT{1,3} = 'int';   nr{1,3} =-1;
        
%         FORMAT{} = '';   nr{} =;
    case 'SUB-ASSEMBLY MAPS'
        FORMAT{1,1} = 'int';   nr{1,1} =-1;
        FORMAT{1,2} = 'float';   nr{1,2} =-1;
        FORMAT{1,3} = 'float';   nr{1,3} =-1;
%         FORMAT{} = '';   nr{} =;
        
  
        
        
    otherwise
        warning('Label not found or FORMAT and nr not defined for input Label');
        FORMAT = nan(1);
        nr = nan(1);
end



            