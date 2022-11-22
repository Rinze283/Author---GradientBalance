function p_refined = localization_VanishingPower(V_patch,p_init,fittingParam,judgeCross)
    %localization, refine the init pixels to better subpixel locations.
    %-p_refined: refined subpixel locations of cross points 
    %-V: vanishing power map
    %-p_init: init pixel locations of cross points
    %-r: radius of the fitting size (2*r+1)
    %-iter: number of iterations 
    %-judgeCross: judge the pixel is a cross [true/false]
    
    if ~exist('judgeCross','var')
        judgeCross=true;
    end
    
    p_refined=p_init;
    iter=fittingParam.iter;
    for t = 1 : iter
        p_refined = fitting(V_patch,p_refined,fittingParam,judgeCross);
    end
end