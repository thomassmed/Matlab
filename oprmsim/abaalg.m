%
% Amplitude based algorithm
%
%
% Variables:
%	T0
%	T1
%	TP
%	TV
%	C1
%
% Parameters:
%	TMAX
%	TMIN
%	SMAX
%	S1
%	S2
%	
% Conditions:
%	S1COND
%	S1COND
%	ASFCOND
%
%
function [ASFCOND,S1COND,S2COND] = abaalg(T0,T1,TP,TV,C1,TMAX,TMIN,SMAX,S1,S2,S1COND,S2COND,ASFCOND)


if ((T0 - TP) <= TMAX)

	if (T1 == TP)				% Peak
		if (C1 >= S1)
			S1COND = 1;
			if (S2COND)
				if (TMAX/2 >= (TP-TV)) && ((TP-TV) >= TMIN/2)
					if (C1 >= SMAX)
						ASFCOND = 1;
						S2COND = 0;
						return;
					else
						if (C1 <= (SMAX - 0.05))
							ASFCOND = 0;
						end
						S2COND = 0;
						return;
					end
				else
					ASFCOND = 0;
					S2COND = 0;
					return;
				end
			else
				ASFCOND = 0;
				S2COND = 0;
				return;
			end						
		else
			ASFCOND = 0;
			S2COND = 0;
			return;
		end
		
			
	elseif (T1 == TV)			%  Valley
		if (TMAX/2 >= (TV-TP)) && ((TV-TP) >= TMIN/2)	
			if (C1 < S2)
				if (S1COND)
					S2COND = 1;
					S1COND = 0;
					return;
				else
					S1COND = 0;
					return;
				end
			else
				S1COND = 0;
				return;
			end
		else
			S1COND = 0;
			return;
		end
		
	else
		return;
	end
	
	
else
	S1COND = 0;
	S2COND = 0;
	ASFCOND = 0;
	return;
end
