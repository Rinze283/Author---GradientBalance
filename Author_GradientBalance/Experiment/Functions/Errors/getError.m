function dis = getError(p_refined,p_true)
p_diff=p_refined-p_true;
p_diff=p_diff.^2;
p_diff=sum(p_diff,1);
p_diff=sqrt(p_diff);
dis=mean(p_diff);
end