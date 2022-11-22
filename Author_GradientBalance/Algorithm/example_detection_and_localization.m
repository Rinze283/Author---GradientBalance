%%
%centrosymmetric cross point detection and localization
%green dots in image (or the subpixels in workspace) 
%is the final subpixel locations
%%
clear
close all
%%
%read some calibration patterns (which used in our localization comparison)
images=readSomeCalibrationPatterns;

sigma=3.5;% standard deviation of sampling kernel 
r=2;%radius of the fitting size (2*r+1)
iter=5;%number of iterations 

for i=1:length(images)   
    img=images{i};
   
    threshold=struct('type','power','value',0.03);%use absolute vanishing power as threshold
    %threshold=struct('type','number','value',120);%use expecsted number as threshold
    subpixels=detectGradientBalancePoints(img,sigma,threshold,r,iter);
    
    figure
    imshow(img,[]);
    hold on
    scatter(subpixels(:,1),subpixels(:,2),100,'g','filled','o','LineWidth',1);
end

