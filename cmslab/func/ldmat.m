function [inf,vars,data]=ldmat(file)
%
%[inf,vars,data]=ldmat(file)
%
% Input:      file:  	namn på .mat-fil
% Output:     inf:	Beskrivning
%             vars:	MätpunktInfo
%             data:	MätpunktsData
%
% Syfte:	Överföra formatet för pdb-.matfiler från
%		mdata,mvar,mvarb,mtext till
%		inf,vars,data som motsvarar output från ldracs
%		ldmat fungerar för samtliga filer under
%		matfil d.v.s. storning,ventilmatning och matning

%	961119	Benny Lind

if ( nargin==0 | nargout~=3 )
	disp('Usage: [inf,vars,data]=ldmat(file)');
	return
end
%
load(file)
%------------------
% i n f
%------------------
inf=mtext;
%------------------
% v a r s
%------------------
[im,jm]=size(mvar);
tvar=blanks(jm+6);
tvar(1:30)='  1   TID                  sek';
for i=1:im
	vtmp=sprintf('%3d   %s',i+1,mvar(i,:));
	vtmp2(i,:)=vtmp;
end
vars=[tvar;vtmp2];
%
%-------------------
% d a t a
%-------------------
[im,jm]=size(mdata);
TS=1/sampl(2,1);
t=0:TS:(jm-1)*TS;
data(1,:)=t;
%
for j=1:im
   	data(j+1,:)=mdata(j,:)*(mvarb(j,2)-mvarb(j,1))/2^15+mvarb(j,1);
end
%
data=data';
end
 

