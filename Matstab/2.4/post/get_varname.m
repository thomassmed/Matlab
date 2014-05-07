function name=get_varname(iva)
%get_varname
%
% name=get_varname(iva)
%Gives the name of a variable

global KMAX ihydr NCC

nvt = get_varsize;
nvn = get_varsize('neut');
[r,k]=get_neutnodes;
rr=ind_tnr(1,nvt);

if nargin==0, iva=rr(1):(rr(2)-1);end

for i=2:length(iva)+1, siffra(i,:)=[sprintf('%4i',mod(i-2,nvt)),'  '];end


xstrt=['al  '
      'E   '
      '    '
      'Wl  '
      'ga  '
      'qw  '
      'tl  '
      'tw  '
      'Wg  '
      'wg  '
      'S   '
      'jm  '
      'ph  '];

xst1=['al  '
      'E   '
      'al  '
      'Wl  '
      'ga  '
      'qw  '
      'tl  '
      'tw  '
      'Wg  '
      'wg  '
      'S   '
      'jm  '
      'ph  '];


xstrn=['Fa1 '
      'Fa2 '
      'Ksi '
      'fn1 '
      'D0.5'
      'q_3f'
      'Tf1 '
      'Tf2 '
      'Tf3 '
      'Tf4 '
      'Tc1 '
      'Tc2 '];
xsn1=[' Fa1'
      ' Fa2'
      ' Ksi'
      ' fn1'
      'D0.5'
      'q_3f'
      ' Tf1'
      ' Tf2'
      ' Tf3'
      ' Tf4'
      ' Tc1'
      ' Tc2'];
for i=1:length(iva),
   if iva(i)==1,
     name(i,:)='P     P ';
   else
     it=iva(i)- rr(max(find(rr<=iva(i))))+1;
     if it<=nvt,
       name(i,:)=[xstrt(it,:) xst1(it,:)];
     elseif it<=nvt+NCC+3
       if it<=(nvt+NCC),
          name(i,:)=[' I1  I1 '];
       elseif it==(nvt+NCC+1),
          name(i,:)=[' I2  I2 '];
       elseif it==(nvt+NCC+2),
          name(i,:)=[' NP  NP '];
       elseif it==(nvt+NCC+3),
          name(i,:)=[' HP  HP '];
       end
     else
       it=iva(i)- k(max(find(k<=iva(i))))+1;
       name(i,:)=[xstrn(it,:) xsn1(it,:)] ;
     end
  end
end
name=['Var Eqn.';name];
name=[siffra name siffra];
