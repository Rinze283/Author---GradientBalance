function p_init=imNMS(V,r,threshold)
V_nms=V;
% non-maximum suppression
V_nms(imdilate(V_nms,strel('square',2*r+1))~=V_nms)=0;
%remove pixels on the boundary
V_nms(1:r,:) = 0; V_nms(end-r+1:end,:) = 0;
V_nms(:,1:r) = 0; V_nms(:,end-r+1:end) = 0;

if strcmp(threshold.type,'number')
    V_sort=V_nms(:);
    V_sort = sort(V_sort,'descend');
    %pick the candidates with top-"number" V power
    [im,in] = ind2sub(size(V_nms),find(V_nms>=V_sort(min(threshold.value,size(V_sort,1)))));
elseif strcmp(threshold.type,'power')
    %pick the candidates with responses larger than "power"
    [im,in] = ind2sub(size(V_nms),find(V_nms>threshold.value));
end

p_init = [in,im];

%in fact, only the patches of V is used in the next step

% edge=2*r+3;
% V_patch=zeros(edge*size(p_init,1),edge);
% for i=1:size(p_init,1)
%     n=p_init(i,1);m=p_init(i,2);
%     V_patch(edge*(i-1)+1:edge*i,:)=V(m-r-1:m+r+1,n-r-1:n+r+1);
% end

end