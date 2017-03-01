% http://www.pnas.org/content/suppl/2012/05/11/1201858109.DCSupplemental/sd02.txt

function output = hpupil(t,n,tmax,f,loc)

% n+1 = number of laters (10.1)
% tmax = response maximum (930)
% f = scaling factor (1/10^27)

output = f.*((t-loc).^n).*exp(-n.*(t-loc)./tmax);
output((t-loc)<=0) = 0;
%output(1) = 0;
