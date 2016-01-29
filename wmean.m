function output = wmean(x,w)

output = zeros(1,size(x,2));

for i = 1:size(x,2)
    
    output(i) = (nansum(x(:,i) .* w(:,i)))/(nansum(w(:,i)));
    
end