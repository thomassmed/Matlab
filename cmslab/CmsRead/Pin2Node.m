function NodeDis=Pin2Node(PinDis)
% Pin2Node - Transform from pin format to Node format
%
% NodeDis=Pin2Node(PinDis);
%
% Input
%  PinDis - Pin oriented distribution {NPIN,NPIN}(Ista,K)
%
% Output
%  NodeDis - Node oriented distribution {Ista}(NPIN,NPIN,K)
%
% Examples:
% po3=read_pinfile_asyid(pinfile,'JLC496');
% Nodepow=Pin2Node(pow3);
%
% See also read_pinfile, read_pinfile_asyid, Node2Pin
%% Find out the size
[ip,jp]=size(PinDis);
[ista,k]=size(PinDis{1});
%% Prerallocate the cell array
NodeDis=cell(1,ista);
for i=1:ista,
    NodeDis{i}=nan(ip,jp,k);
    for i1=1:ip,
        for j1=1:jp,
            NodeDis{i}(i1,j1,:)=PinDis{i1,j1}(i,:);
        end
    end
end
