%
% Period Based Algorithm
%
%
% Variables:
%	T1
%	T
%	T0
%	TP
%	TV
%	C1
%	NC
%
% Parameters:
%	TMAX
%	TMIN
%	NP
%	SP
%	EP
%	
% Conditions:
%	ASFCOND
%
%
function [ASFCOND,T0,NC] = pbaalg(T00,T1,T,T0,TP,TV,TMIN,TMAX,C1,NC,NP,SP,EP,ASFCOND)

if (abs(T00-TP) <= TMAX)
	if (T1 == TP) || (T1 == TV)		% Peak or valley
		if (TMIN <= T) & (T <= TMAX)
			if (T0 > 0)
				if ((T0-EP) <= T) & (T <= (T0+EP))
					T0 = (T+NC*T0)/(NC+1);
					NC = NC+1;
					if (NC < NP)
						ASFCOND = 0;
						return;
					end
					if (T1 == TP)	% Peak
						if (C1 < (SP-0.05))
							ASFCOND = 0;
							return;
						end
						if (C1 >= SP)
							ASFCOND = 1;
							return;
						else
							return;
						end
					else
						return;
					end
				else
					T0 = 0;
					NC = 0;
					ASFCOND = 0;
					return;
				end
			else
				T0 = T;
				return;
			end
		else
			T0 = 0;
			NC = 0;
			ASFCOND = 0;
			return;
		end
	else
		if (NC >= NP)
			if (C1 >= SP)
				ASFCOND = 1;
				return;
			end
			return;
		end
		return;
	end
else
	T0 = 0;
	NC = 0;
	ASFCOND = 0;
end
