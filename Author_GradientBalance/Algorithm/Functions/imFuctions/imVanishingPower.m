function V=imVanishingPower(img,kernel)
    %compute the vanishing power map of the input image 
    %-V: vanishing power map
    %-img: input image
    %-kernel: the sampling kernel (see our article for details)
    [Gx,Gy] = imgradientxy(img,'central');
    Gmag = imfilter((Gx.^2+Gy.^2).^0.5,kernel);
    Gvec = (imfilter(Gx,kernel).^2 + imfilter(Gy,kernel).^2).^0.5;
    V = Gmag-Gvec;
end