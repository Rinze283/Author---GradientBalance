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