%@(#)   plotonechain.m 1.1	 05/07/13     10:29:36
%
%
function [Ppil,Pring]=plotonechain(kedja,mminj, knum, Ppil, Pring)
%function [Ppil,Pring]=plotonechains(kedja,mminj)
%function [Ppil,Pring,gonu]=plotonechains(curfile,bocfile,knum,OK)



s_kedja = size(kedja);

plats = 0;
for i = 1:s_kedja(1)
	
	for j = 1:s_kedja(2)
		
		if knum == kedja(i,j)
			plats = i;
		end
	end
end



if plats ~= 0

	ked=kedja(plats,:);
	ked=ked(find(ked>0));
	lk=length(ked);
	ked=ked(lk:-1:1);




	%Om de ska tas bort
	if Ppil(ked(1)) ~= 0
	
		for j = 1:lk-1
			plats = ked(1,j);
			delete(Ppil(plats));
			Ppil(plats) = 0;
			
			delete(Pring(plats));
			Pring(plats) = 0;
		
		
		
		
		end


	%Om de ska ritas
	else

		for j = 1:lk
		
			if knum == ked(j)
				knumpos =  j;
				break;
			end		
		
		end
		
		
		[ppil,pring]=plotpilkedja(ked,mminj,knumpos);
		Ppil(ked(1:lk-1))=ppil; Pring(ked(1:lk-1))=pring;
	
	end
end
