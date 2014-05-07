% $Id: crwea_fetch_case_data.m 44 2012-07-16 10:18:15Z rdj $
%
function data=crwea_fetch_case_data(res,readdists)

    data=[];

    if isfield(res,'er')
        wdfields=fieldnames(res.er);
        for i=1:length(wdfields)  
            fwd=wdfields{i};
            data.er.pos(i)=str2double(fliplr(strtok(fliplr(fwd),'_')));
            data.er.power(i)=res.er.(fwd).power;
            data.er.hcflow(i)=res.er.(fwd).hcflow;
            data.er.cprmin(i)=res.er.(fwd).cprmin;
            if isfield(res.er.(fwd),'lhgrmax') % Compability with old files
                data.er.lhgrmax(i)=res.er.(fwd).lhgrmax;
            end
            
            if readdists
                 if isfield(res.er.(fwd),'cpr')
                    data.er.cpr{i}=res.er.(fwd).cpr;
                end
                if isfield(res.er.(fwd),'lhgr')
                    data.er.lhgr{i}=res.er.(fwd).lhgr;
                end
            end        
        end
    end
    
    if isfield(res,'vr')
        wdfields=fieldnames(res.vr);
        for i=1:length(wdfields)  
            fwd=wdfields{i};
            data.vr.pos(i)=str2double(fliplr(strtok(fliplr(fwd),'_')));
            data.vr.power(i)=res.vr.(fwd).power;
            data.vr.hcflow(i)=res.vr.(fwd).hcflow;
            data.vr.cprmin(i)=res.vr.(fwd).cprmin;
            if isfield(res.er.(fwd),'lhgrmax') % Compability with old files
                data.vr.lhgrmax(i)=res.vr.(fwd).lhgrmax;
            end
            
            if readdists
                if isfield(res.vr.(fwd),'cpr')
                    data.vr.cpr{i}=res.vr.(fwd).cpr;
                end
                if isfield(res.vr.(fwd),'lhgr')
                    data.vr.lhgr{i}=res.vr.(fwd).lhgr;
                end
            end        
        end
    end

end
