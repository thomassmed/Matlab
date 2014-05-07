function dA2dv=eq_dA2dv(NEIG,fa1,delta,X2nm,Y2nm,sigr,siga2,...
                        X2bl,Y2bl,sigrbl,siga2bl,bb,...
			X2wh,Y2wh,sigrwh,siga2wh,bw);
%function dA2dv=eq_dA2dv(NEIG,fa1,delta,X2nm,Y2nm,sigr,siga2,...
%              X2bl,Y2bl,sigrbl,siga2bl,bb,X2wh,Y2wh,sigrwh,siga2wh,bw);
			
NTOT=size(NEIG,1);
I=(1:NTOT)'; I6=[I;I;I;I;I;I];
fa1long=fa1;
fa1long(NTOT+1)=0;

%************************* sigr/siga ******************

dAsig=(sigrbl./siga2bl+sigrwh./siga2wh-2*sigr./siga2).*fa1/delta;


%******************* sum X2nm and sum Y2nm *******************

dXblbl=(sum(X2bl')'./siga2bl -sum(X2nm')'./siga2).*(bb.*fa1)/delta;
dXwhwh=(sum(X2wh')'./siga2wh -sum(X2nm')'./siga2).*(bw.*fa1)/delta;

dXblwh=NEIG*0;
dXwhbl=dXblwh;

dYblbl=NEIG(:,1)*0;
dYwhwh=dYblbl;

dYblwh=NEIG*0;
dYwhbl=dYblwh;


for i=1:6,
%************************ sum X2nm *********************
  dXblwh(:,i)=dXblwh(:,i)+(X2wh(:,i)./siga2wh-X2nm(:,i)./siga2).*(bb.*fa1)/delta; 
  dXwhbl(:,i)=dXwhbl(:,i)+(X2bl(:,i)./siga2bl-X2nm(:,i)./siga2).*(bw.*fa1)/delta;

%************************ sum Y2nm *********************
  dYblbl=dYblbl+(Y2bl(:,i)./siga2bl-Y2nm(:,i)./siga2).*(bb.*fa1long(NEIG(:,i)))/delta;
  dYwhwh=dYwhwh+(Y2wh(:,i)./siga2wh-Y2nm(:,i)./siga2).*(bw.*fa1long(NEIG(:,i)))/delta;

  dYblwh(:,i)=dYblwh(:,i)+(Y2wh(:,i)./siga2wh-Y2nm(:,i)./siga2).*(bb.*fa1long(NEIG(:,i)))/delta;
  dYwhbl(:,i)=dYwhbl(:,i)+(Y2bl(:,i)./siga2bl-Y2nm(:,i)./siga2).*(bw.*fa1long(NEIG(:,i)))/delta;
end

%********************** sum the components *************

dA2diag=dXblbl+dXwhwh+dYblbl+dYwhwh;

dA2offdia=dXblwh+dXwhbl+dYblwh+dYwhbl;

i=I6;j=NEIG(:);y=dA2offdia(:);
rbound=find(j==(NTOT+1));
i(rbound)=[];
j(rbound)=[];
y(rbound)=[];


dA2dv=spdiags(dA2diag,0,NTOT,NTOT)+sparse(i,j,y);

