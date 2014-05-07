%% Exercise 5 - Read HDF5 file
%% Get info of file
fileinfo = hdf5info('Exercise5.h5');

%% 5.1 - How many groups exist under the root group
ngroups = numel(fileinfo.GroupHierarchy.Groups);

%% 5.2 - What are the names of these groups?
gnames=[];
for i=1:ngroups
    gnames = [gnames,fileinfo.GroupHierarchy.Groups(i).Name];
end

%% 5.3a - What is the average age of the contestants?
ages = hdf5read(fileinfo.GroupHierarchy.Groups(1).Datasets(1));
avg_age = mean(ages(:));

%% 5.3b - What is the unit of the ages?
age_unit = fileinfo.GroupHierarchy.Groups(1).Datasets(1).Attributes(1).Value.Data;

%% 5.4a - What descriptions are stored with the competitions?
cdesc1 = fileinfo.GroupHierarchy.Groups(2).Datasets(1).Attributes(1).Value.Data;
cdesc2 = fileinfo.GroupHierarchy.Groups(2).Datasets(2).Attributes(1).Value.Data;

%% 5.4b - What unit were the results measured in?
cunit1 = fileinfo.GroupHierarchy.Groups(2).Datasets(1).Attributes(2).Value.Data;
cunit2 = fileinfo.GroupHierarchy.Groups(2).Datasets(2).Attributes(2).Value.Data;

%% 5.4c - What was the best result in each of the competitions?
results1 = hdf5read(fileinfo.GroupHierarchy.Groups(2).Datasets(1));
min_time = min(results1(:));
results2 = hdf5read(fileinfo.GroupHierarchy.Groups(2).Datasets(2));
max_jump = max(results2(:));