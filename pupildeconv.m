function [B,X] = pupildeconv(Y,duration,locs,Bret)

%B(2) and B(3) are app of T1 and T2 respectively

%Bret is made a vector made of values 1-5 that determine which B values are
%returned and in what order they are returned in (add one to values to get
%targets of interest (T1 = 2, T2 = 3, etc))

%Y = neutralnormwm; is a mean of normalized pupil size time series
Y(1:400) = [];


n = 10.1;
tmax = 930;
f = 1/(10^27);

locs = locs+1;
sf = 1/(10^5);

h = hpupil(1:5000,n,tmax,f);

xmat = zeros(length(locs)+1,duration-400);

for i = 1:length(locs)
    eval(sprintf('x%d = [zeros(1,locs(%d)) h];',i,i))
    eval(sprintf('x%d(duration+1-400:end) = [];',i))
end

eval(sprintf('x%d = ([1:duration-400])*sf;',i+1))

for i = 1:length(locs)+1
    eval(sprintf('xmat(%d,:) = x%d;',i,i))
end

% x1 = [zeros(1,xloc(1)) h];
% x1(duration+1-400:end) = [];
% 
% x2 = [zeros(1,xloc(2)) h];
% x2(duration+1-400:end) = [];
% 
% x3 = [zeros(1,xloc(3)) h];
% x3(duration+1-400:end) = [];
% 
% x4 = [zeros(1,xloc(4)) h];
% x4(duration+1-400:end) = [];

% x5 = ([1:duration-400])*sf;

% xmat(1,:) = x1;
% xmat(2,:) = x2;
% xmat(3,:) = x3;
% xmat(4,:) = x4;
% xmat(5,:) = x5;

B = regress(Y',xmat');

%X = (x1*B(1)) + (x2*B(2)) + (x3*B(3)) + (x4*B(4)) + (x5*B(5));
X = xmat' * B;

% figure
% plot(Y,'b')
% hold on
% plot(X,'r')
% 

if nargin > 2
    B = B(Bret);
end
