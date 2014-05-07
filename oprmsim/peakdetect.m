%
% Peak,Valley and Period detection algoritm
%
function [T,TP,TP1,TV,TV1,TSP,TSV,SIGN,PEAK,VALLEY] = peakdetect(S0,S1,S2,T0,T1,T2,TP,TP1,TV,TV1,TSP,TSV,T,SIGN,PEAK,VALLEY)

PEAK = 0;
VALLEY = 0;

if (S0 > S1)
	TSP = T0;
end

if (S0 < S1)
	TSV = T0;
end

if (S1 > S2)
	SIGN = 1;
end

if (S1 < S2)
	SIGN = -1;
end


if (S2 <= S1) && (S1 > S0)
	if (SIGN > 0)
		TP = T1 - (T1-TSP)/2;
		T = TP - TP1;
		TP1 = TP;
		PEAK = 1;
	end
end


if (S2 >= S1) && (S1 < S0)
	if (SIGN < 0)
		TV = T1 - (T1-TSV)/2;
		T = TV - TV1;
		TV1 = TV;
		VALLEY = 1;
	end
end



