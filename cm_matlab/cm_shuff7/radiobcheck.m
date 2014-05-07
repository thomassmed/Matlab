%@(#)   radiobcheck.m 1.1	 05/07/13     10:29:38
%
%
function s=radiobcheck(i)

nr=1;
handle=gcf;
userdata=get(handle,'userdata');
hbutton=userdata(1,1:5);
l=max(size(hbutton));

if i==10|i==11,
  hrbundles=get(userdata(54),'userdata');
  hrcrods=get(userdata(55),'userdata');  
  if i==10,set(hrcrods,'Value',0);end;
  if i==11,set(hrbundles,'Value',0);end;
else
  %-------------------------------
  %Custom for hfchoice knapparna>>
  %-------------------------------
  if isstr(i),
	h=userdata(1,26:27);
	if strcmp(i,'rmonitor')==1,
		set(h(2),'Value',0);		
	else
		set(h(1),'Value',0);
	end	
	s=0;
	for count=1:5,
		onoff=get(hbutton(count),'Value');
		if onoff==1,
			s=1;
		end
	end	
	if s==0,
		set(h(1),'Value',0);
		set(h(2),'Value',0);
	end
  %------------
  %Slut custom.
  %------------
  else
	while nr<=l
		temp=get(hbutton(nr),'Value');
		if (temp==1)&(nr~=i),
			set(hbutton(nr),'Value',0);
		end
	nr=nr+1;
	end
  end;%if isstr(i)
end;%if i==10|i==11		
