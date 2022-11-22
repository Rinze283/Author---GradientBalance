%%
%the comparsion of detection in our paper
%%
clear
close all
%%
I=imread('tiling.jpg');

crosses1 = detectGBFeatures(I,5);
showResult(I,crosses1,'GradientBalance');

crosses2 = detectFASTFeatures(I);
showResult(I,crosses2,'FAST');

crosses3 = detectHarrisFeatures(I);
showResult(I,crosses3,'Harris');

crosses4 = detectBRISKFeatures(I);
showResult(I,crosses4,'BRISK');

crosses5 = detectKAZEFeatures(I);
showResult(I,crosses5,'KAZE');

crosses6 = detectORBFeatures(I);
showResult(I,crosses6,'ORB');

crosses7 = detectSURFFeatures(I);
showResult(I,crosses7,'SURF');

%%

function showResult(I,crosses,figName)
strongest=crosses.selectStrongest(45);
figure('Name',figName)
imshow(I);
hold on
j=jet;
gap=floor(size(j,1)/45);
c=j(1:gap:end,:);%color
c=c(1:45,:);
c=flip(c,1);
scatter(strongest.Location(:,1),strongest.Location(:,2),500,c,'o','LineWidth',5);
end






