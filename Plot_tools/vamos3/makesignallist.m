function siglist=makesignallist(data)


siglist = {[data.signal(1).label data.signal(1).desc]};

for i=2:data.nvar
	siglist = [siglist; {[data.signal(i).label data.signal(i).desc]}];
end
