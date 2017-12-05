% http://www.pnas.org/content/suppl/2012/05/11/1201858109.DCSupplemental/sd02.txt

function output = hpupil(t,n,tmax,loc,varargin)

% n+1 = number of laters (10.1)
% tmax = response maximum (930)
% function is normalized to a max of 1, in case tmax varies

output = ((t-loc).^n).*exp(-n.*(t-loc)./tmax);

output((t-loc)<=0) = 0;

if ~(max(output) == 0)
    if strcmp(varargin,'max')
        output = (output/(max(output))) .* 0.01;
    elseif strcmp(varargin,'area')
        x = 0:10000;
        fun = @(x) hpupil(x,n,tmax,0);
        output = (output/integral(fun,x(1),x(end))).* 7.39595595259277782673734691343270242214202880859375;
    %     output = output/(sum(pointavg(output))*(t(2)-t(1)));
    %       7.39595595259277782673734691343270242214202880859375
    end
end
%output(1) = 0;
