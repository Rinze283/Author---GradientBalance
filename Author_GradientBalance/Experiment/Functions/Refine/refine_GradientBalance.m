function p_refined = refine_GradientBalance(img,p_init,r,iter,sigma)
%refine the subpixel locations by gradient balance prior

%1.compute vanishing power
ksize=4*sigma+1;
kernel=fspecial('gaussian',ksize,sigma);
V=imVanishingPower(img,kernel);

%2.refinement
params=CfittingParam(r,iter);
judgeCross =false;
p_refined=localization_VanishingPower(V,p_init,params,judgeCross);
end




