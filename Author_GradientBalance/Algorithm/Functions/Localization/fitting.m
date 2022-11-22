function p_output = fitting(img,p_input,fittingParam,judgeCross)
    %fitting the quadric surface, and refine the pixels to subpixels.
    %to be more specific, compute the saddle point of a saddle surface,
    %or the maximum of a Gaussian-like surface.
    %-p_output: refined subpixel locations of cross points
    %-img: origin image or vanishing power map
    %-p_input: init pixel locations of cross points
    %-fittingParam: parameters for fitting
    %-judgeCross: judge the pixel is a cross [true/false]
      
    if ~exist('judgeCross','var')
        judgeCross=false;
    end
    
    p_output=p_input;

    num_pixels = size(p_input,1);
    x=p_input(:,1)';
    y=p_input(:,2)';
    [mx,my] = meshgrid(1:size(img,2),1:size(img,1));

    qx=fittingParam.qx;
    qy=fittingParam.qy;
    pinvA=fittingParam.pinvA;

    %get the interp region of V
    V_interp = interp2(mx,my,img,x+qx,y+qy);
    %get the coefficients of:
    %f=c1*x^2 + c2*xy + c3*y^2 + c4*x + c5*y +c6.
    c = (pinvA*V_interp)';

    %check the rate of eigens to find cross,
    %and compute the subpixels   
    isCross=true(num_pixels,1);
    rateList=zeros(num_pixels,1);%todo: delete this
    for num = 1 : num_pixels
        M = [2*c(num,1),c(num,2);
            c(num,2),2*c(num,3);];
        v = [c(num,4);c(num,5)];
                
        d=sqrt((c(num,1)-c(num,3))^2+c(num,2)^2);
        add=c(num,1)+c(num,3);
        rate=(add-d)/(add+d);
        rateList(num)=rate;
                          
        p_output(num,:)= p_output(num,:)-(M\v)';
        if abs(rate)>=3  
            isCross(num,1)=false;
        end
    end
    if judgeCross
       p_output(~isCross,:)=[];
    end
end

