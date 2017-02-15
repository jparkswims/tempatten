% http://www.pnas.org/content/suppl/2012/05/11/1201858109.DCSupplemental/sd02.txt

function output = hpupil(t,n,tmax,f)

% n+1 = number of laters (10.1)
% tmax = response maximum (930)
% f = scaling factor (1/10^27)

output = f.*(t.^n).*exp(-n.*t./tmax);
%output(1) = 0;
