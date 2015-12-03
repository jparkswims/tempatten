function output = noblink(trialmat,t1,t2,window,t3,t4,e1,e2,m)

tmat = trialmat(:,t1:t2);

for i = 1:size(trialmat,1)
    if all(tmat(i,:)) == 0
        bstd = std(diff(trialmat(i,t3:t4)));
        z1 = find(tmat(i,:) == 0,1,'first');
        if z1 <= window
            wmat = tmat(i,1:z1);
        else
            wmat = tmat(i,z1-window:z1);
        end
        t5 = find(abs(diff(wmat)) > m*bstd,1,'first');
        if isempty(t5)
            tb1 = z1;
        else
            tb1 = z1 - (length(wmat)-t5) - e1;
        end
        z2 = find(tmat(i,:) == 0,1,'last');
        if z2 > t2-t1-window
            wmat = tmat(i,z2:end);
        else
            wmat = tmat(i,z2:z2+window);
        end
        t6 = find(abs(diff(wmat)) > m*bstd,1,'last');
        if isempty(t6)
            tb2 = z2;
        else
            tb2 = z2 + t6 + e2;
        end
        tmat(i,tb1:tb2) = nan;
        trialmat(i,t1:t2) = tmat(i,:);
    end
end

output = trialmat;