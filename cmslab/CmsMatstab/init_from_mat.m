function varargout=init_from_mat(msopt,opt,knum2)
%%
if nargin==1, opt='dyn';end
if ~get_bool(msopt.Init),
    varargout{1}=0;
    for i=2:nargout,
        varargout{i}=[];
    end
    if strcmpi(opt,'dyn'),
        varargout{2}=msopt.Lam;
    end
    return;
end

init_flag=0;
if exist(msopt.MstabFile,'file'),
    oldmsopt=load(msopt.MstabFile,'msopt');
    switch opt
        case 'dyn'
            oldfile=load(msopt.MstabFile,'stab');
            if strmatch('stab',fields(oldfile)),
                lam=oldfile.stab.lam;
                en=oldfile.stab.en;
                init_flag=1;
            end
        case 'ss'
            oldfile=load(msopt.MstabFile,'steady','msopt');
            if strmatch('steady',fields(oldfile)),
                power=oldfile.steady.power;
                alfa=oldfile.steady.alfa;
                tl=oldfile.steady.tl;
                Wg=oldfile.steady.Wg;
                Wl=oldfile.steady.Wl;
                tw=oldfile.steady.tw;
                flowb=oldfile.steady.flowb;
                fa1=oldfile.steady.fa1;
                fa2=oldfile.steady.fa2;
                ncc=size(power,2);
                kmax=size(power,1);
                init_flag=1;
            end
            init_xs=0;
            if get_bool(msopt.XSinit)&&get_bool(msopt.Midpoint)==get_bool(oldfile.msopt.Midpoint),
                xsold=load(msopt.MstabFile,'Xsec','XS','X');
                if strcmp(msopt.LibFile,oldfile.msopt.LibFile),
                    if isfield(xsold,'Xsec')&&isfield(xsold,'XS'),
                        if isfield(xsold.Xsec,'alfa0')
                            init_xs=1;
                            xsold.Xsec.d1=reshape(xsold.Xsec.d1,kmax,ncc);
                            xsold.Xsec.d1d=reshape(xsold.Xsec.d1d,kmax,ncc);
                            xsold.Xsec.d1t=reshape(xsold.Xsec.d1t,kmax,ncc);
                            xsold.Xsec.d2=reshape(xsold.Xsec.d2,kmax,ncc);
                            xsold.Xsec.d2d=reshape(xsold.Xsec.d2d,kmax,ncc);
                            xsold.Xsec.d2t=reshape(xsold.Xsec.d2t,kmax,ncc);
                            xsold.Xsec.sigr=reshape(xsold.Xsec.sigr,kmax,ncc);
                            xsold.Xsec.sigrd=reshape(xsold.Xsec.sigrd,kmax,ncc);
                            xsold.Xsec.sigrt=reshape(xsold.Xsec.sigrt,kmax,ncc);
                            xsold.Xsec.siga1=reshape(xsold.Xsec.siga1,kmax,ncc);
                            xsold.Xsec.siga1d=reshape(xsold.Xsec.siga1d,kmax,ncc);
                            xsold.Xsec.siga1t=reshape(xsold.Xsec.siga1t,kmax,ncc);
                            xsold.Xsec.siga2=reshape(xsold.Xsec.siga2,kmax,ncc);
                            xsold.Xsec.siga2d=reshape(xsold.Xsec.siga2d,kmax,ncc);
                            xsold.Xsec.siga2t=reshape(xsold.Xsec.siga2t,kmax,ncc);
                            xsold.Xsec.usig1=reshape(xsold.Xsec.usig1,kmax,ncc);
                            xsold.Xsec.usig1d=reshape(xsold.Xsec.usig1d,kmax,ncc);
                            xsold.Xsec.usig1t=reshape(xsold.Xsec.usig1t,kmax,ncc);
                            xsold.Xsec.usig2=reshape(xsold.Xsec.usig2,kmax,ncc);
                            xsold.Xsec.usig2d=reshape(xsold.Xsec.usig2d,kmax,ncc);
                            xsold.Xsec.usig2t=reshape(xsold.Xsec.usig2t,kmax,ncc);
                            xsold.Xsec.ny=reshape(xsold.Xsec.ny,kmax,ncc);
                        end
                    end
                end
            end
    end
    if  msopt.CoreSym~=oldmsopt.msopt.CoreSym
        sym1=oldmsopt.msopt.CoreSym;
        sym2=msopt.CoreSym;
        oldgeom=load(msopt.MstabFile,'geom');
        knum1=oldgeom.geom.knum;
        switch opt
            case 'dyn'
                en=sym2sym(reshape(en,oldgeom.geom.kmax,oldgeom.geom.kan),sym1,sym2,knum1,knum2);
                en=en(:);
            case 'ss'
                power=sym2sym(power,sym1,sym2,knum1,knum2);
                alfa=sym2sym(alfa,sym1,sym2,knum1,knum2);
                tl=sym2sym(tl,sym1,sym2,knum1,knum2);
                Wg=sym2sym(Wg,sym1,sym2,knum1,knum2);
                Wl=sym2sym(Wl,sym1,sym2,knum1,knum2);
                tw=sym2sym(tw,sym1,sym2,knum1,knum2);
                flowb=sym2sym(flowb,sym1,sym2,knum1,knum2);
                Fa1=reshape(fa1,oldgeom.geom.kmax,oldgeom.geom.ncc);
                Fa2=reshape(fa2,oldgeom.geom.kmax,oldgeom.geom.ncc);
                Fa1=sym2sym(Fa1,sym1,sym2,knum1,knum2);
                Fa2=sym2sym(Fa2,sym1,sym2,knum1,knum2);
                fa1=Fa1(:);
                fa2=Fa2(:);
        end
    end
end

if ~init_flag
    switch opt
        case 'dyn'
            lam=msopt.Lam;
            en=[];
        case 'ss'
            power=[];
            alfa=[];
            tl=[];
            Wg=[];
            Wl=[];
            tw=[];
           % flowb=[];
    end
end
varargout{1}=init_flag;
switch opt
    case 'dyn'
        varargout{2}=lam;
        varargout{3}=en;
    case 'ss'
        varargout{2}=power;
        varargout{3}=alfa;
        varargout{4}=tl;
        varargout{5}=Wg;
        varargout{6}=Wl;
        varargout{7}=tw;
        varargout{8}=flowb;
        varargout{9}=fa1;
        varargout{10}=fa2;
        xsold.Xsec.flag=init_xs;
        varargout{11}=xsold.Xsec;
        if init_xs,
            varargout{12}=xsold.XS;
            varargout{13}=xsold.X;
        else
            varargout{12}=[];
            varargout{13}=[];
        end 
end
