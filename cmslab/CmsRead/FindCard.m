function [str,card]=FindCard(outinfo,distname)
%%
str=[];
card=[];
ifind=0;
if isfield(outinfo,'prista')
    for i=1:length(outinfo.prista),
        istr=strfind(outinfo.prista{i},distname);
        if ~isempty(istr),
            ifind=ifind+1;
            card{ifind}='PRI.STA';
            str{ifind}=outinfo.prista{i};
            if istr==1,
                str=str{ifind};
                card=card{ifind};
                return;
            end
        end
    end
    for i=1:length(outinfo.aprista),
        istr=strfind(outinfo.aprista{i},distname);
        if ~isempty(istr),
            ifind=ifind+1;
            card{ifind}='A-PRI.STA';
            str{ifind}=outinfo.aprista{i};
            if istr==1,
                str=str{ifind};
                card=card{ifind};
                return;
            end
        end
    end
    for i=1:length(outinfo.priiso),
        istr=strfind(outinfo.priiso{i},distname);
        if ~isempty(istr),
            ifind=ifind+1;
            card{ifind}='PRI.ISO';
            str{ifind}=outinfo.priiso{i};
            if istr==1,
                str=str{ifind};
                card=card{ifind};
                return;
            end
        end
    end
   
    for i=1:length(outinfo.primac),
        if strfind(outinfo.primac{i},distname),
            ifind=ifind+1;
            card{ifind}='PRI.MAC';
            str{ifind}=outinfo.primac{i};
        end
    end
    for i=1:length(outinfo.tlmedt),
        if strfind(outinfo.tlmedt{i},distname),
            ifind=ifind+1;
            card{ifind}='TLM.EDT';
            str{ifind}=outinfo.tlmedt{i};
        end
    end
    for i=1:length(outinfo.pinedt),
        if strfind(outinfo.pinedt{i},distname),
            ifind=ifind+1;
            card{ifind}='PIN.EDT';
            str{ifind}=outinfo.pinedt{i};
        end
    end
else
    for i=1:length(outinfo.distlist),
        if strfind(outinfo.distlist{i},distname),
            ifind=ifind+1;
            card{ifind}=outinfo.distlist{i}(1:7);
            str{ifind}=outinfo.distlist{i};
        end
    end
    for i=1:length(outinfo.misclist),
        if strfind(outinfo.misclist{i},distname),
            ifind=ifind+1;
            card{ifind}=outinfo.misclist{i}(1:7);
            str{ifind}=outinfo.misclist{i};
        end
    end
end

if length(str)==1, str=char(str);card=char(card);end
if isempty(card), card=distname; str=card;end