function output = wstd(x,wm,w)

output = zeros(1,size(x,2));

for i = 1:size(x,2)
    
    output(i) = sqrt((sum(w(:,i) .* (x(:,i) - wm(i)).^2)) / (((size(x,1)-1) * sum(w(:,i))) / (size(x,1))));
    
end