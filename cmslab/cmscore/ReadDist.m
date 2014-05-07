function [core,color,options,absevoid,ecolor,core_ax]=ReadDist(fileinfo,options,varargin)
% [core,options]=JavaReadDist(fileinfo,options,'Property1',value1,'Property2',value2...


filename=fileinfo.fileinfo.fullname;
ext=file('extension',filename);

options=cmsviewset(options,varargin{:});


switch ext
    case '.mat'
        [core,color,absevoid,ecolor,core_ax]=ReadMat(fileinfo,options);
    case '.cms'
        [core,color,absevoid,ecolor,core_ax]=ReadCms(fileinfo,options);
end