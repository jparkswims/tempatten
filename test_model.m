function test_model(window,locs,dec_type,tmax_type,B_type,tm0,b0)

trials = [0 100 200 300];

T = 930; %input tmax

B = rand(100,5); %input Beta weights
B = repmat(B,3,1);

testT = zeros(300,1); %output tmaxes

testB = zeros(300,5); %output Beta weights

s = [.002 .005 .008];
% n1 = 0.99; %make 3 different sigmas (noise levels)
% n2 = 1.01;

for j = 1:3
    
    for i = trials(j)+1:trials(j+1)
        
        X = glm_comps(window,locs,dec_type,T,B(i,:));
        
        N = s(j) .* randn(1,window(2));
        %   N = s .* randn(1,600);
        %   N = s .* repmat(N,5,1);
        %   N = reshape(N,1,3000);
        %   N = n1 + (n2-n1) .* rand(1,600); %normally distribute around 0 with some sigma/std
        %   N = repmat(N,5,1);
        %   N = reshape(N,1,3000);
        XX = N + X; %add, not multiply
        %   XX = N .* X;
        
        XX = [zeros(1,401) XX];
        
        [testT(i), testB(i,:)] = glm_optim(XX,window,locs,dec_type,tmax_type,B_type,tm0,b0);
        
    end
    
end

Tdev = abs(testT - T);

% Ttotal = sum(Tdev);

Bdev = abs(testB - B);

Btotal = sum(Bdev,1);

close all

figure
imagesc(Tdev)
colormap gray
title('imagesc of T devs')
colorbar

figure
imagesc(Bdev)
colormap gray
title('imagesc of B devs')
colorbar

figure
bar(Btotal)
title('B dev totals (abs difference)')
xlabel('B weight')
ylabel('total devation')

figure
hist(Tdev)
title('Histogram of T devs (abs difference)')

figure
subplot(2,3,1)
hist(Bdev(:,1),[0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4])
title('precue')
ylim([0 250])
xlim([0 0.4])

subplot(2,3,2)
hist(Bdev(:,2),[0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4])
title('t1')
ylim([0 250])
xlim([0 0.4])

subplot(2,3,3)
hist(Bdev(:,3),[0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4])
title('t2')
ylim([0 250])
xlim([0 0.4])

subplot(2,3,4)
hist(Bdev(:,4),[0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4])
title('postcue')
ylim([0 250])
xlim([0 0.4])

subplot(2,3,5)
hist(Bdev(:,5),[0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4])
title('decision')
ylim([0 250])
xlim([0 0.4])

figdir = ['/Users/jakeparker/Documents/tempatten/modelrecovery/' dec_type tmax_type B_type];
fig = [1 2 3 4 5];
fignames = {'T_imagesc' 'B_imagesc' 'B_totals' 'T_hist' 'B_hists'};
figprefix = 'ta';

rd_saveAllFigs(fig,fignames,figprefix, figdir)

close all

% plot(X)

