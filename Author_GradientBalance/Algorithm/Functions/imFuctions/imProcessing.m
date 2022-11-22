function I_output = imProcessing(I_input,a,z,n,b,isResize)
    %warp, blur and add noise to the image
    %-I_output: output image
    %-I_input: input image
    %-a:azimuth angle (degree)
    %-z:zenith angle (degree)
    %-n:noise degree
    %-b:blur degree
    %-isResize:resize image for grid pattern
    R = angle2dcm(a*pi/180,z*pi/180,0);
    R(3,:) = [0,0,1];
    M=size(I_input,1);
    N=size(I_input,2);
    I = imwarp(I_input,imref2d([M,N],[-1, 1],[-1, 1]),projective2d(R),...
        'OutputView',imref2d([M,N],[-1, 1],[-1, 1]),'FillValues',0.5,'interp','cubic');
    if isResize
        I=imresize(I,0.25);
    end
    if b > 0
        bsize = 2*ceil(2*b)+1;
        kernal = fspecial('gaussian', [bsize bsize], b);
        I = imfilter(I, kernal);
    end
    if n>0
        I = imnoise(I, 'gaussian', 0, n^2);
    end
    I_output=I;
end