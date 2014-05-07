%
% Growth Rate Based Algorithm
%
%
% Variables:
%	T0
%	T1
%	TP
%	TV
%	C1
%	S3
%
% Parameters:
%	TMAX
%	TMIN
%	S1
%	S2
%	DR3
%	
% Conditions:
%	S1COND
%	S1COND
%	ASFCOND
%
%
function [ASFCOND,S1COND,S2COND,S3] = grbaalg(T0,T1,TP,TV,C1,TMAX,TMIN,S1,S2,S3,DR3,S1COND,S2COND,ASFCOND)

if ((T0-TP) <= TMAX)
	if (T1 == TP)				% Peak
		if (C1 >= S1)
			S1COND = 1;
			if (S2COND)
				if (TMAX/2 >= (TP-TV)) && ((TP-TV) >= TMIN/2)
					if (C1 >= S3)
						ASFCOND = 1;
						S2COND = 0;
						S3 = (C1-1.0)*DR3 + 1.0;
						return;
					end
				end 
			end	
		end			
		ASFCOND = 0;
		S2COND = 0;
		S3 = (C1-1.0)*DR3 + 1.0;
		return;

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
