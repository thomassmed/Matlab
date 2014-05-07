%@(#)   mfiltbun.m 1.2	 94/08/12     12:10:41
%
%function mmult=mfiltbun(buntyp,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10);
function mmult=mfiltbun(buntyp,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10);
if nargin>1,
  mult=filtbun(buntyp,b1);
end
if nargin>2,
  mult(:,2)=filtbun(buntyp,b2);
end
if nargin>3,
  mult(:,3)=filtbun(buntyp,b3);
end
if nargin>4,
  mult(:,4)=filtbun(buntyp,b4);
end
if nargin>5,
  mult(:,5)=filtbun(buntyp,b5);
end
if nargin>6,
  mult(:,6)=filtbun(buntyp,b6);
end
if nargin>7,
  mult(:,7)=filtbun(buntyp,b7);
end
if nargin>8,
  mult(:,8)=filtbun(buntyp,b8);
end
if nargin>9,
  mult(:,9)=filtbun(buntyp,b9);
end
if nargin>10
  mult(:,10)=filtbun(buntyp,b10);
end
if nargin>2,
  mmult=max(mult');
else
  mmult=mult;
end
