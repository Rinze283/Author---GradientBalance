function points=detectGBFeatures(img,sigma)
ksize=4*sigma+1;
kernel=fspecial('gaussian',ksize,sigma);
V=imVanishingPower(img,kernel);

r=7;
threshold=struct('type','power','value',0);
Location=imNMS(V,r,threshold);
    
metricValues=V(sub2ind(size(V),Location(:,2),Location(:,1)));
points = cornerPoints(Location, 'Metric', metricValues(:));
end