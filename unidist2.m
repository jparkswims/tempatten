function [outx1, outx2] = unidist2(x1,x2,nbins,spb)

%[~,index] = makedist(x,nbins);
%uindex = [];

[~,index] = heatdist(x1,x2,[nbins nbins]);
% xbins = linspace(min(x1),max(x2),nbins+1);
% ybins = linspace(min(x2),max(x2),nbins+1);

% for i = 1:nbins
%     if sum(index{i}) >= spb
%         uindex = [uindex ; randsample(index{i},spb)];
%     end
% end

uindex = [];

for i = 1:nbins
    for j = 1:nbins
        if ~isempty(index{i,j})
%             uindex = [uindex index{i,j}(min(distance(mean([xbins(i) xbins(i+1)]),mean([ybins(i) ybins(i+1)]),x1(index{i,j}),x2(index{i,j}))) ...
%                == distance(mean([xbins(i) xbins(i+1)]),mean([ybins(i) ybins(i+1)]),x1(index{i,j}),x2(index{i,j})))];
            uindex = [uindex ; randsample(index{i,j},spb)];
        end
    end
end

outx1 = x1(uindex);
outx2 = x2(uindex);