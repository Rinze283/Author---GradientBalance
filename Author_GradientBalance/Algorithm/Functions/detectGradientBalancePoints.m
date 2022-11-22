function subpixels=detectGradientBalancePoints(img,sigma,threshold,r,iter)
%detect the subpixel locations of centrosymmetric cross points

%1.compute vanishing power
%require origin image
ksize=4*sigma+1;
kernel=fspecial('gaussian',ksize,sigma);
V=imVanishingPower(img,kernel);

%2.non-maximum suppression
%require V
p_init=imNMS(V,r,threshold);

%3.refinement
%although we still use V here for clear codes, 
%in fact, only some patches of V is needed. 
params=CfittingParam(r,iter);
p_refined=localization_VanishingPower(V,p_init,params);% V maybe V_patches
subpixels=p_refined;
end

