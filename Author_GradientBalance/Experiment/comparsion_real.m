
clear
close all

%% read images
imageFileNames_checker=getImageFileNames('checkerboard');
imageFileNames_grid=getImageFileNames('gridboard');

%% detect the subpixel points 
%using the Matlab results as the input of other checkerboard calibration
%using the same detection results for all gridboard calibration
load('imagePoints.mat');
[imagePoints_cb_Matlab,boardSize,imagesUsed] = detectCheckerboardPoints(imageFileNames_checker);
imagePoints_cb_OpenCV=detectCrossPoints_OpenCV(imageFileNames_checker,imagePoints_cb_Matlab);
imagePoints_cb_GB=detectCrossPoints_GB(imageFileNames_checker,imagePoints_cb_Matlab);
imagePoints_gb_OpenCV=detectCrossPoints_OpenCV(imageFileNames_grid,imagePoints);
imagePoints_gb_Chen=detectCrossPoints_Chen(imageFileNames_grid,imagePoints);
imagePoints_gb_GB=detectCrossPoints_GB(imageFileNames_grid,imagePoints);

%% compute the reprojection errors
squareSizeInMM = 20;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);
imageSize = size(imread(imageFileNames_checker{1}));

params_cb_Matlab = estimateCameraParameters(imagePoints_cb_Matlab,worldPoints,'ImageSize',imageSize);
params_cb_OpenCV = estimateCameraParameters(imagePoints_cb_OpenCV,worldPoints,'ImageSize',imageSize);
params_cb_GB = estimateCameraParameters(imagePoints_cb_GB,worldPoints,'ImageSize',imageSize);
params_gb_OpenCV = estimateCameraParameters(imagePoints_gb_OpenCV,worldPoints,'ImageSize',imageSize);
params_gb_Chen = estimateCameraParameters(imagePoints_gb_Chen,worldPoints,'ImageSize',imageSize);
params_gb_GB = estimateCameraParameters(imagePoints_gb_GB,worldPoints,'ImageSize',imageSize);

%% show results
figure('Name','Checkerboard-Matlab')
showReprojectionErrors(params_cb_Matlab);
figure('Name','Checkerboard-OpenCV')
showReprojectionErrors(params_cb_OpenCV);
figure('Name','Checkerboard-GradientBalance')
showReprojectionErrors(params_cb_GB);
figure('Name','Gridboard-OpenCV')
showReprojectionErrors(params_gb_OpenCV);
figure('Name','Gridboard-Chen at al')
showReprojectionErrors(params_gb_Chen);
figure('Name','Gridboard-GradientBalance')
showReprojectionErrors(params_gb_GB);





function imagePoints_GB=detectCrossPoints_GB(imageFileNames,imagePoints)
s=size(imagePoints);
imagePoints_GB=zeros(s);
numImages=s(3);
sigma=3.5;
r=2;
num_iters=5;
for i=1:numImages
    I = imread(imageFileNames{i});
    numChannel=numel(size(I));
    if numChannel==3
        I= im2double(rgb2gray(I));
    else
        I=im2double(I);
    end
    points=imagePoints(:,:,i);
    points=round(points);
    points_refined = refine_GradientBalance(I,points,r,num_iters,sigma);
    imagePoints_GB(:,:,i)=points_refined;
end

end

function imagePoints_OpenCV=detectCrossPoints_OpenCV(imageFileNames,imagePoints)
s=size(imagePoints);
imagePoints_OpenCV=zeros(s);
numImages=s(3);
r=2;
num_iters=5;
for i=1:numImages
    I = imread(imageFileNames{i});
    numChannel=numel(size(I));
    if numChannel==3
        I= im2double(rgb2gray(I));
    else
        I=im2double(I);
    end
    points=imagePoints(:,:,i);
    points=round(points);
    points_refined = refine_OpenCV(I,points,r,num_iters);
    imagePoints_OpenCV(:,:,i)=points_refined;
end

end

function imagePoints_Chen=detectCrossPoints_Chen(imageFileNames,imagePoints)
s=size(imagePoints);
imagePoints_Chen=zeros(s);
numImages=s(3);
% r=2;
% num_iters=5;
for i=1:numImages
    I = imread(imageFileNames{i});
    numChannel=numel(size(I));
    if numChannel==3
        I= im2double(rgb2gray(I));
    else
        I=im2double(I);
    end
    points=imagePoints(:,:,i);
    points_refined = refine_Hessian(I,points);
    imagePoints_Chen(:,:,i)=points_refined;
end
end

function imageFileNames=getImageFileNames(foldName)
currPath = fileparts(mfilename('fullpath'));
fsep = filesep;
pathArray = strfind(currPath,fsep);
rootPath = currPath(1:pathArray(length(pathArray))-1);
filePath=strcat(rootPath,'\Data\CalibrationBoards\',foldName,'\');
imgPathList=dir(strcat(filePath,'*.bmp'));
numImages=length(imgPathList);

imageFileNames=cell(1,length(numImages));
for i=1:numImages
    imgName=imgPathList(i).name;
    imageFileNames{i}=strcat(filePath,imgName);
end
end

