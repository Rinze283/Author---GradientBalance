function images=readSomeCalibrationPatterns
currPath = fileparts(mfilename('fullpath'));
fsep = filesep;
pathArray = strfind(currPath,fsep);
rootPath = currPath(1:pathArray(length(pathArray)-1)-1);
images=cell(10,1);
for i=1:10
    if i<=5
        filePath=strcat(rootPath,'\Data\CalibrationBoards\checkerboard\');
        imgPathList=dir(strcat(filePath,'*.bmp'));
        imgName=imgPathList(i).name;
        imgName=strcat(filePath,imgName);
        img=imread(imgName);
        img=im2double(img);
    else
        filePath=strcat(rootPath,'\Data\CalibrationBoards\gridboard\');
        imgPathList=dir(strcat(filePath,'*.bmp'));
        imgName=imgPathList(i).name;
        imgName=strcat(filePath,imgName);
        img=imread(imgName);
        img=im2double(img);
    end
    images{i}=img;
end
end