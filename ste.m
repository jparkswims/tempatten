function output = ste(x,flag,dim)

output = std(x,flag,dim) / sqrt(size(x,dim));