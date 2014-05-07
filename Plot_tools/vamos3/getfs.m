function [fs]=getfs(data,selsignal)

fs = data.fs;

if isfield(data.signal(selsignal),'fs')
	fs = data.signal(selsignal).fs;
end
