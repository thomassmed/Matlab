function PlotSegData(segment1,segment2,weight)
% PlotSegData plots the segments into segfig

% Mikael Andersson 2011-11-25
%% get data from segplot
segfig = gcf;
segplot_prop=get(segfig,'userdata');
y1 = segment1';
y2 = segment2';
y = [y1; y2]';
uni = unique(y);
if min(uni) == 0
    uni= uni(2:end);
end
%% get rid of old segment plot
if max(strcmp(fieldnames(segplot_prop),'hsegs1'))% && max(pinplot_prop.hsegplot == segcheck)
    if max(strcmp(fieldnames(segplot_prop),'hsegs2'))
        delete(segplot_prop.hsegs2);
    end
    delete(segplot_prop.hsegs1);
    delete(segplot_prop.fulseg);
    delete(segplot_prop.hsegtex);
    delete(segplot_prop.segleg);
    delete(segplot_prop.textfills);
end
%% create the colorvector used
colv = colormap('jet');
colorvec(uni,:) = colv(floor((1:length(uni))*length(colv)/length(uni)),:);
hold on

%% plot segments to get correct legend. 
% TODO: Very bad way of getting the correct legend... should be a easier way..
for j = 1:length(uni)
        fulseg(j) = fill([0 1 1 0],[j-0.5 j-0.5 j+0.5 j+0.5],colorvec(uni(j),:));
end
%% plot the segments
k = 1;
for i = 1:length(y1)
    seg1 = y1(i);
    seg2 = y2(i);
    
    if seg2 ~= 0
        % plotta två segment
        hsegs1(i) = fill([0 0.5 0.5 0],[i-0.5 i-0.5 i+0.5 i+0.5],colorvec(seg1,:));
        hsegs2(k) = fill([0.5 1 1 0.5],[i-0.5 i-0.5 i+0.5 i+0.5],colorvec(seg2,:));
        k=k+1;
    else
        hsegs1(i) = fill([0 1 1 0],[i-0.5 i-0.5 i+0.5 i+0.5],colorvec(seg1,:));
    end
    textfills(i) = fill([1 1.4 1.4 1],[i-0.5 i-0.5 i+0.5 i+0.5],[1 1 1]);
    
end
%% add segment weights
for i = 1:length(y1)
    westr = num2str(weight(i));
    if length(westr) < 6
        hsegtex(i) = text(1.1,i,westr(1:length(westr)));
    else    
        hsegtex(i) =  text(1.1,i,westr(1:6));
    end
end

%% save data to segplot
segplot_prop.hsegs1 = hsegs1;
segplot_prop.hsegs2 = hsegs2;
segplot_prop.hsegtex = hsegtex;
segplot_prop.fulseg = fulseg;
segplot_prop.textfills = textfills;
set(segfig,'userdata',segplot_prop);
