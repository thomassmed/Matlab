function alb_mat=albedo_type(mminj,ap,ai,ay)
%function alb_mat=albedo_type(mminj.ap,ai,ay)
%
% alb_mat is a 4-by-kan (no. of channels) matrix
% which contains information on side reflector:
%
%  0        - No boundary
%  ap       - Normal flat side boundary
% (ap+ai)/2 - Inner Corner
% (ay+ai)/2 - Inner-Outer Corner
% (ap+ay)/2 - Outer Corner
%
% The information is stored in four columns concerning direction:
%
% 1st column: North
% 2nd column: East
% 3rd column: South
% 4th column: West

lm=length(mminj);kan=sum(lm+2-2*mminj);
alb_mat=zeros(kan,4);
alb_mat(1,1)=(ap+ay)/2; % North
alb_mat(1,4)=(ap+ay)/2; % West
alb_mat(lm+2-2*mminj(1),1)=(ap+ay)/2; % North
alb_mat(lm+2-2*mminj(1),2)=(ap+ay)/2; % East

alb_mat(2:(lm+1-2*mminj(1)),1)=ap*ones(lm-2*mminj(1),1); % Planar side, North

n=lm+2-2*mminj(1);
for i=2:lm/2,
  nrad=lm-2*mminj(i)+2; 
  % West- East aspects:
  if (mminj(i+1)==mminj(i)) & (mminj(i)==mminj(i-1)), % Flat side 
    alb_mat(n+1,4)=ap;alb_mat(n+nrad,2)=ap;
  elseif (mminj(i+1)<mminj(i)) & (mminj(i)==mminj(i-1)),  % Inner corner   
    alb_mat(n+1,4)=(ap+ai)/2;alb_mat(n+nrad,2)=(ap+ai)/2;
  elseif (mminj(i+1)<mminj(i)) & (mminj(i)<mminj(i-1)),  % Inner-Outer corner   
    alb_mat(n+1,4)=(ay+ai)/2;alb_mat(n+nrad,2)=(ay+ai)/2;
  elseif (mminj(i+1)==mminj(i)) & (mminj(i)<mminj(i-1)), % Outer Corner
    alb_mat(n+1,4)=(ap+ay)/2;alb_mat(n+nrad,2)=(ap+ay)/2;
  else,
    disp('Something is wrong in function albedo_type. East-West aspects.');
  end
  % North aspects  
  if mminj(i-1)>mminj(i),
    if (mminj(i-1)-1)==mminj(i),
      alb_mat(n+1,1)=(ay+ai)/2;alb_mat(n+nrad,1)=(ay+ai)/2; % N Inner-Outer corner
    else
      dm=mminj(i-1)-mminj(i);
      alb_mat(n+1,1)=(ap+ay)/2;alb_mat(n+nrad,1)=(ap+ay)/2; % N Outer corner
      alb_mat(n+dm,1)=(ap+ai)/2;alb_mat(n+nrad-dm+1,1)=(ap+ai)/2;% N Inner corner
      if dm>2,
        alb_mat(n+2:n+dm-1,1)=ap*ones(dm-2,1); % N Flat side
	alb_mat(n+nrad-dm+2:n+nrad-1,1)=ap*ones(dm-2,1); % N Flat side
      end
    end
  end     
   n=n+nrad;
end 
 
  
alb_mat(kan/2+1:kan,3)=alb_mat(kan/2:-1:1,1); % North - South
alb_mat(kan/2+1:kan,4)=alb_mat(kan/2:-1:1,2); % West - East
alb_mat(kan/2+1:kan,2)=alb_mat(kan/2:-1:1,4); % East - West

