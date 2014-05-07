function ds=Labview2plotmat(filnamn)
%% Read raw data
ds=ReadLabview(filnamn);
%% Adapt to a format plotmat recognizes
N=size(ds.data,2);
signaler=char(32*ones(N+2,86));
%                       1         2         3         4         5         6
%              1234567890123456789012345678901234567890123456789012345678901234567890
signaler(1,:)='Nr  NAME             UNIT   Lowlimit     Highlimit    Gain         COMMENTS           ';
signaler(2,:)='++  ++++             ++++   ++++++++     +++++++++    ++++         +++++++++          ';
tabs=find(ds.sig{5}==9);
signaler(3,1)='1';
signaler(3,5:8)='Time';
signaler(3,22)='s';
lolim=min(ds.data);
hilim=max(ds.data);
str=sprintf('%g',lolim(1));
signaler(3,29:28+length(str))=str;
str=sprintf('%g',hilim(1));
signaler(3,42:41+length(str))=str;
signaler(3,55)='1';
signaler(3,68:71)='Time';
maxlen=16;
for i=2:N,
    ic=sprintf('%i',i);
    signaler(i+2,1:length(ic))=ic;
    vnam=char(ds.varnam{i});
    lv=length(vnam);
    len=min(maxlen,lv);
    signaler(i+2,5:len+4)=vnam(1:len);
    str=sprintf('%g',lolim(i));
    signaler(i+2,29:28+length(str))=str;
    str=sprintf('%g',hilim(i));
    signaler(i+2,42:41+length(str))=str;
    signaler(i+2,55)='1';
    signaler(i+2,68:67+lv)=vnam;
end

ds.signaler=signaler;

