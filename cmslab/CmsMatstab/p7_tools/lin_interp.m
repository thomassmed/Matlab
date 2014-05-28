%-----------------------------------------------------------------------------------------------%
%												%
% funktion:	lin_interp									%
%												%
% beskrivning:	tar fram v�rden f�r utbr�nningsvektor ur tabell  med linj�r interpolation.	%
%												%
% indata:	n	antal temperatur-ing�ngar i tabellen					%
%		b 	utbr�nnings-ing�ngar, radvektor, b = [m b1 b2 .. bm ..]			%
%			d�r 	m �r antalet utbr�nnings-ing�ngar i tabellen			%
%		y 	tabell, radvektor d�r y(k) svarar mot bi tj				%
%					ordning b1t1 b1t2 .. b2t1 b2t2 .. bmtn			%
%		burnup	utbr�nningsvektor, kolumnvektor						%
%												%
% utdata:	y	tabell d�r utbr�nningsberoendet reducerats (enbart temperatur-		%
%			beoende kvar), y(k,i) svarar mot burnup(k) och ti			%
%												%
% funk. anrop:	-										%
%												%
% glob. var:	-										%
%												%
%		Emma Lundgren 050930								%
%												%
%-----------------------------------------------------------------------------------------------%


function y = lin_interp(n,b,y,burnup)

m = b(1);					% m = antal utbr�nnings-ing�ngar

b = b(2:m+1);					% b = utbr�nnings-ing�ngar (radvektor)

mm = size(burnup,1);				% mm = antal utbr�nnigs-v�rden
					
if m~=0						% om utbr�nningsberoende finns...
  
  bmat	 = repmat(b,mm,1);			% utbr�nningsing�ngs-matris, rader motsvarar burnup			
  bupmat = repmat(burnup,1,m);
  
  bb	= (bupmat< bmat(:,1:m)) ...
	& (bupmat>=[zeros(mm,1) bmat(:,1:m-1)]);
		
  [v,u]	= find(bb');				% b(v-1) <= burnup < b(v)
  
  b1	= b(1,v-1);				
  b1	= b1';					% b1     <= burnup
  b2	= b(1,v  );				
  b2	= b2';					% burnup <  b2
  
  b1	 = repmat(b1,1,n);
  b2	 = repmat(b2,1,n);
  burnup = repmat(burnup,1,n);
  
  v	= n*(v-2);
  v	= repmat(v,1,n);
  add	= [1:n];
  add	= repmat(add,mm,1);
  v	= v+add;
  v	= v';
  v	= v(:);
    
  y1	= y(1,v);
  y1	= reshape(y1,n,mm);
  y1	= y1';					% y1(i,j) motsvarar b1(i,j)
    
  v	= v+n;
  
  y2	= y(1,v);
  y2	= reshape(y2,n,mm);
  y2	= y2';					% y2(i,j) motsvarar b2(i,j)
  
  y	= y1 + (burnup - b1).*(y2 - y1) ...
  	./(b2 - b1);				% y(i,j) motsvarar burnup(i,j)

else
  y = repmat(y(1,1:n),mm,1);
end	

	
  	
  
  	  




