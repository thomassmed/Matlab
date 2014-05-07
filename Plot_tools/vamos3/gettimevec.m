function [timevec]=gettimevec(data,selsignal)

timevec = data.t;

if isfield(data.signal(selsignal),'t')
	timevec = data.signal(selsignal).t;
end
