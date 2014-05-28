%-----------------------------------------------------------------------------------------------%
%												%
% funktion:	lin_interp									%
%												%
% beskrivning:	tar fram värden för utbränningsvektor ur tabell  med linjär interpolation.	%
%												%
% indata:	n	antal temperatur-ingångar i tabellen					%
%		b 	utbrännings-ingångar, radvektor, b = [m b1 b2 .. bm ..]			%
%			där 	m är antalet utbrännings-ingångar i tabellen			%
%		y 	tabell, radvektor där y(k) svarar mot bi tj				%
%					ordning b1t1 b1t2 .. b2t1 b2t2 .. bmtn			%
%		burnup	utbränningsvektor, kolumnvektor						%
%												%
% utdata:	y	tabell där utbränningsberoendet reducerats (enbart temperatur-		%
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

m = b(1);					% m = antal utbrännings-ingångar

b = b(2:m+1);					% b = utbrännings-ingångar (radvektor)

mm = size(burnup,1);				% mm = antal utbrännigs-värden
					
if m~=0						% om utbränningsberoende finns...
  
  bmat	 = repmat(b,mm,1);			% utbränningsingångs-matris, rader motsvarar burnup			
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

	
  	
  
  	  




