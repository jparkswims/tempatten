function trueVSbounds(uinALL,uoutALL,inind,startALL)

figure
[~,~] = quick_glm_calc(uinALL(inind,:),1);
title('True Value GLM Regressors')

fitind = find(squeeze(uoutALL(inind,7,:)) < 520);
h = ceil(length(fitind)/5);
w = length(fitind)/h;

figure
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (640*w) (480*h)])
set(gcf,'PaperPosition',[0 0 ((640*w)/150) ((480*h)/150)])
for i = 1:length(fitind)
    subplot(h,w,i)
    [~,~] = quick_glm_calc(uoutALL(inind,:,fitind(i)),1);
end

set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (640*w) (480*h)])
set(gcf,'PaperPosition',[0 0 ((640*w)/150) ((480*h)/150)])

figure
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (640*w) (480*h)])
set(gcf,'PaperPosition',[0 0 ((640*w)/150) ((480*h)/150)])
for i = 1:length(fitind)
    subplot(h,w,i)
    [~] = quick_glm_optim2(uinALL(inind,:),startALL(fitind(i),:));
end

set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (640*w) (480*h)])
set(gcf,'PaperPosition',[0 0 ((640*w)/150) ((480*h)/150)])
    





