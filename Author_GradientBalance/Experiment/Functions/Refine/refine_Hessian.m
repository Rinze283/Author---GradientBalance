function p_refined = refine_Hessian(img,p_init,~,~,~)
%compute the saddle point of a saddle surface by a second Taylor polynomial

[Gx,Gy] = imgradientxy(img,'central');
[Gxx,Gxy] = imgradientxy(Gx,'central');
[~,Gyy] = imgradientxy(Gy,'central');

p_refined=p_init;
num_pixels = size(p_init,1);
for it = 1 : num_pixels
    rx = Gx(p_refined(it,2),p_refined(it,1));
    ry = Gy(p_refined(it,2),p_refined(it,1));
    rxx = Gxx(p_refined(it,2),p_refined(it,1));
    rxy = Gxy(p_refined(it,2),p_refined(it,1));
    ryy = Gyy(p_refined(it,2),p_refined(it,1));
    
    bias_x=(ry*rxy-rx*ryy)/(rxx*ryy-rxy*rxy);
    bias_y=(rx*rxy-ry*rxx)/(rxx*ryy-rxy*rxy);
    p_refined(it,:)=p_refined(it,:)+[bias_x, bias_y];
end

end

