function output = Bramp(B,loc)

sf = 1/300;

output = (0:1/(loc(2)-loc(1)):1) * B * sf;