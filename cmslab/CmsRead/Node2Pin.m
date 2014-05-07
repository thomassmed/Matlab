function PinDis=Node2Pin(NodeDis)
% Node2Pin - Transform from node format to pin format
%
% PinDis=Node2Pin(NodeDis);
%
% Input
%  NodeDis - Node oriented distribution {Ista}(NPIN,NPIN,K)
%
% Output
%  PinDis - Pin oriented distribution {NPIN,NPIN}(Ista,K)
%
% Examples:
% po3=read_pinfile(pinfile,'JLC496');
% Pinpow=Node2Pin(pow3{1}{8,8});
%
% See also read_pinfile, read_pinfile_asyid, Pin2Nod
%% Find out the size
ista=length(NodeDis);
[ip,jp,k]=size(NodeDis{1});
%% Prerallocate the cell array
PinDis=cell(ip,jp);
for i1=1:ip,
    for j1=1:jp,
        PinDis{i1,j1}=nan(ista,k);
        for i=1:ista,
            PinDis{i1,j1}(i,:)=NodeDis{i}(i1,j1,:);
        end
    end
end

