function output = Bbox(B,loc)

sf = 1/500;

output = ones(1,loc(2)-loc(1)+1) .* B .* sf;