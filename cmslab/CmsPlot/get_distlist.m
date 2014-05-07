function dl=get_distlist(cmsplot_prop)

if nargin==0
    hfig=gcf;
    cmsplot_prop=get(hfig,'userdata');
end

%%
filetype=cmsplot_prop.filetype;
switch filetype
    case '.res'
        dl{1}='Power'; 
        searchcell = {'XENON' ,'SAMARIUM','IODINE','PROMETHIUM','BURNUP','TFUHIST','CRDHIST','VHIST','DENHIST','BORONDENS','SURFEXPYM','SURFEXPXP','SURFEXPYP','SURFEXPXM','SPECHIST', 'SPECHISTYM','SPECHISTXP','SPECHISTYP','SPECHISTXM','EB1','BP1','BP10','BP2','BP20','EB2','XTF','FLN','FLNYM','FLNXP','FLNYP', 'FLNXM'};
        l = 1;
        for i = 1:length(searchcell)
            if max(strcmp(searchcell{i},cmsplot_prop.coreinfo.distlist))
                avaldist{l} = lower(searchcell{i});
                l = l+1;
            end
        end
        dl{2}=[{'History'} avaldist];
        if strcmpi(cmsplot_prop.core.lwr,'BWR')
            dl{3}={'Assembly' 'nhyd' 'nload' 'ibat' 'afuel' 'dhfuel' 'phfuel' 'vhifuel' 'vhofuel' 'Xcin' 'orityp' 'A_wr{1}' 'Ph_wr{1}',...
            'Dhy_wr{1}' 'Kin_wr{1}' 'Kex_wr{1}'}; 
        else
            dl{3}={'Assembly' 'nhyd' 'nload' 'ibat'};
        end
        dl{4}={'lib' 'nfta' 'Core_Seg{1}' 'Core_Seg{2}' 'Seg_w{1}' 'Seg_w{2}'};
    case '.out'
         dl=cmsplot_prop.coreinfo.distlist;
         %dl=out2distlist(cmsplot_prop.filename); 
    case '.mat'
        dl{1}={'Power' 'S3 Power' 'Matstab Power'};
        dl{2}={'Thermo' 'alfa' 'chflow' 'Wl' 'Wg' 'ploss' 'tl' 'flowb' 'dens'};
        dl{3}={'Neu' 'fa1' 'fa2'};
        dl{4}={'Fuel' 'tfm' 'tw'};
        dl{5}={'Eigenvectors' 'evoid' 'efa1' 'eqfiss' 'etl' 'eWg' 'eWl' 'eGamw' 'eqprimw' 'ejm' 'etw' 'etf1' 'etf2' 'etf3' 'etf4' 'etc1' 'etc2'};
        if max(strcmp('stabh',cmsplot_prop.coreinfo.misclist))
            
            tempcell = {'evoid' 'efa1' 'eqfiss' 'etl' 'eWg' 'eWl' 'eGamw' 'eqprimw' 'ejm' 'etw' 'etf1' 'etf2' 'etf3' 'etf4' 'etc1' 'etc2'};
            for i=1:cmsplot_prop.coreinfo.fileinfo.numstabh
                str1=sprintf('Harmonic %2i',i);
                
                dl{5+i}=[str1,cellfun(@(x) [x '_harm' num2str(i)],tempcell,'uniformoutput',0)];
            
            end
        end
            
    case '.hms'
        DL=cellstr(hms_distlist(cmsplot_prop.filename));
        dl{1}={'Power'    '3RPF'    'T3RPF'    '3NPF'    'NODPOW'    'ACTPOW'    'POWRAD'    'POWRA2'};
        dl{2}={'Flux' 'FLP1AD'    'FLP1A2' 'ADJFA1'    'ADJFA2' '3LOA'    '3PIN'    '4PIN'};
        dl{3}={'Th'  'VOID' '3DEN' '3VOI' '3TMO' '2DLP' 'STQOUT' '2DPA' '2WTR' '2WBY' 'CHFLOW' 'FLWFUE'};
        dl{4}={'CPR' '2CPR' 'CPRLIM' '2BTF' '3BTF' 'MFLCPR' 'CPRAD' 'CPRA2' 'CPRS3' 'BWRMRG'};
        dl{5}={'LHGR' 'LHGR' 'MFLPD' 'LHLIM1' 'LHGRAD' 'LHGRA2'};
        dl{6}={'PCI' 'PCIUTL' 'CNDPRM' 'PCILLM' 'PCIBUM' 'PCISTM'};
        dl{7}={'HIS' '3EXP' '3XPO' '3XEN' '3IOD' '3PRO' '3SAM' '3HVO'};
        dl{8}={'Mech' 'THDIAM' 'HYDIAM' 'FLAREA'}; 
        % TODO: Make above list complete and logical
        % Then construct a function:
        % dl=remove_missing(dl,DL);
        % The function should check if DL contains the distributions in dl
        % Of course, the first element in each dl, Power, Flux etc should be kept
        % Flux may not be so smart, maybe it should be removed
        
    case {'.dat','.p7'}
        dl{1}={'Noplot' 'FISID1' 'FISID2' 'FICOR1' 'FICOR2' 'CUSID1' ...
               'CUSID2' 'SCOR1' 'SCOR2' 'BURSID' 'BURCOR' 'FLWBYP' ...
               'DNSBYP' 'TMPBYP' 'VOIBYP' 'STQBYP' 'ENTBYP' 'PRSBYP' ...
               'POWBYP' 'ASYTYP' 'ASYID' 'CONDPR' 'PCILHGR' 'PCIVIOL' ...
               'DETID' 'DETTYP' 'CRID' 'CRTYP' 'CRDENS' 'BOXFLU' ...
               'PINPOW' 'PINLHR' 'PINFIM' 'PINBUR' 'PINDRY' 'PINBA140' ...
               'PININD' 'RAMALB' 'RAMCOF' 'RAMDISF'};
        dl{2}={'Isotop' 'U235' 'U236' 'U238' 'PU238' 'PU239' ...
               'PU240' 'PU241' 'PU242' 'AM241' 'AM242' 'NP239' ...
               'RU103' 'RH103' 'RH105' 'CE143' 'PR143' 'ND143' ...
               'ND147' 'PM147' 'PM148' 'PM148M' 'PM149' 'SM147' ...
               'SM149' 'SM150' 'SM151' 'SM152' 'SM153' 'EU153' ...
               'EU154' 'EU155' 'GD155' 'BAEFF' 'BA140' 'LA140' ...
               'IODINE' 'XENON'};
        dl{3}={'Margins' 'LHGR' 'LHGR_PEL' 'APLHGR' 'SHF' 'CPR' ...
               'CPR_STAT' 'FL_LHGR1' 'FL_LHGR2' 'FL_LHGR3' 'FL_APLHG' 'FL_SHF' ...
               'FL_CPR1' 'FL_CPR2' 'FL_DNB' 'THMARG' 'CPRMOD' 'LHGRMOD' ...
               'ALHGRMOD' 'CONDPR' 'PCILHGR' 'PCIVIOL' 'PCIMAX' 'PCIRATE ' ...
               'PCIMARG'};
        dl{4}={'Sond' 'DETID' 'DETTYP' 'PRMNEU' 'PRMMEA' 'TIPNEU' ...
               'TIPGAM' 'TIPMEA' 'TIPCOR' 'TIPMC' 'TIPNG' 'TIPFI1' ...
               'TIPFI2' 'PRMEFPH' 'PRMU234' 'PRMU235' 'PRMUCAL' ...
               'PRMCACOR'};
        dl{5}={'CRod' 'CRID' 'CRTYP' 'CRWDR' 'CRDENS' 'CREFPH' ...
               'CRDEPL' 'CRDMAX' 'CRFLUE' 'SDM' 'SDM3D'};
        dl{6}={'TH' 'CHFLOW' 'FLWORI' 'FLWFUE' 'FLWWC' 'FLWHOL' ...
               'LEKBP2' 'LEKBP3' 'DENS' 'TMOD' 'TINLET' 'TOUTL' ...
               'VOID' 'STQUAL' 'STQOUT' 'NESTQUAL' 'ENTHAL' 'TFUEL' ...
               'BORC' 'PRESS' 'DPBOX' 'DPWCWALL' 'FLWBYP' 'DNSBYP' ...
               'TMPBYP' 'VOIBYP' 'STQBYP' 'ENTBYP' 'PRSBYP' 'POWBYP' ...
               'THRES' 'BUNLIFT'};
        [dl,dists_remain] = remove_missing(dl, cmsplot_prop.coreinfo.distlist);
        dl = dl(2:end);
        dl_start = length(dl);
        for i=1:length(dists_remain)
            dl{dl_start+i} = dists_remain(i,:);
        end
    case {'.cms','.sum'}
        ListNames=cmsplot_prop.coreinfo.distlist;
        ia=~cellfun(@isempty,strfind(cmsplot_prop.coreinfo.distlist,'CRD.POS'));
        ListNames(ia)=[];
        dl=ListNames;
end

end

function [dl,dist_remain]=remove_missing(dl, distlist)

dist_remain = strtrim(distlist);

keep = [];
for i=1:length(dl)
    dl_temp = {dl{i}{1}};
    for ii=2:length(dl{i})
        pos = strmatch(dl{i}{ii},dist_remain,'exact');
        if ~isempty(pos)
            dl_temp = [dl_temp dl{i}(ii)];
            dist_remain(pos(1),:) = [];
        end
    end
    dl{i}=dl_temp;
    if length(dl_temp) > 1
        keep=[keep i];
    end
end

dl = dl(keep);

end