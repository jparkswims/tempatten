function plotlines(locs,y,marker)

for num = 1:length(locs)

    plot([locs(num) locs(num)],[y(1) y(2)],marker)

end