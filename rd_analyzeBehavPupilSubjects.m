% rd_analyzeBehavPupilSubjects.m

%% setup
subjectInits = {'ma','ad','bl','ec','ty','zw','rd','hl','jp', ...
   'blE3','rdE3','idE3','ecE3','ldE3','enE3','sjE3','mlE3','caE3','jlE3','ewE3','jxE3'};
tilt = '*';
contrast = '*'; % '64'; % 
contrastIdx = 1; % only plot one contrast at a time
soa1 = 1000;
soa2 = 1250;

run = 9;

normalizeNeutral = 1;
normalizeMorey = 0;

saveFigs = 0;

nSubjects = numel(subjectInits);

%% Get data
for iSubject = 1:nSubjects 
    subjectInit = subjectInits{iSubject};
    
    if strfind(subjectInit, 'E3')
        exptName = 'a1';
        exptDir = 'E3_adjust';
    else
        switch subjectInit
            case 'jp'
                exptName = 'cbD15';
                exptDir = 'pilot';
            case {'hl','rd'}
                exptName = 'cbD6';
                exptDir = 'E2_SOA_cbD6';
            otherwise
                exptName = 'cb';
                exptDir = 'E0_cb';
        end
    end
    dataDir = sprintf('%s/%s/%s', pathToExpt('data'), exptDir, subjectInit(1:2));
    
    exptStr = sprintf('%s_%s_soa%d-%d*', exptName, contrast, soa1, soa2);
    subjectID = sprintf('%s*_%s', subjectInit(1:2), exptStr);
    
    % load data from a given soa
    if strcmp(subjectInit,'jp')
        dataFile = dir(sprintf('%s/%s_none_run%02d*', dataDir, subjectID, run));
    else
        dataFile = dir(sprintf('%s/%s_run%02d_T*', dataDir, subjectID, run));
    end
    if numel(dataFile)~=1
        sprintf('%s/%s_run%02d*', dataDir, subjectID, run)
        error('more or fewer than one matching data file')
    else
        load(sprintf('%s/%s', dataDir, dataFile.name))
    end
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%% if you want to reanalyze, do it here %%%
%     T1T2Axis = 'same';
%     [expt results] = rd_analyzeTemporalAttention(expt, 0, 0, 0, 0, T1T2Axis, 0);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % read out the accuracy and rt
    for iEL = 1:2 % early/late
        accData{iEL}(:,iSubject) = results.accMean{iEL}(:,contrastIdx);
        rtData{iEL}(:,iSubject) = results.rtMean{iEL}(:,contrastIdx);
    end
    
    % also gather all the data for all contrasts
    for iContrast = 1:numel(expt.p.targetContrasts)
        for iEL = 1:2 % early/late
            accDataAll{iEL}(:,iSubject,iContrast) = results.accMean{iEL}(:,iContrast);
            rtDataAll{iEL}(:,iSubject,iContrast) = results.rtMean{iEL}(:,iContrast);
            
            % average across contrasts
            accDataC{iEL}(:,iSubject) = mean(results.accMean{iEL},2);
            rtDataC{iEL}(:,iSubject) = mean(results.rtMean{iEL},2);
        end
    end
end

%% Normalize and summarize
if normalizeNeutral
    neutralValsAcc = (accDataC{1}(3,:) + accDataC{2}(3,:))/2;
    neutralValsRT = (rtDataC{1}(3,:) + rtDataC{2}(3,:))/2;
    for iEL = 1:2
        accDataC{iEL} = accDataC{iEL}./repmat(neutralValsAcc,3,1);
        rtDataC{iEL} = rtDataC{iEL}./repmat(neutralValsRT,3,1);
    end
end

if normalizeMorey
    % use the Morey 2008 correction
    a = cat(3, accDataC{1}, accDataC{2});
    b = normalizeDC(shiftdim(a,2));
    c = shiftdim(b,1);
    accDataC{1} = c(:,:,1);
    accDataC{2} = c(:,:,2);
    
    a = cat(3, rtDataC{1}, rtDataC{2});
    b = normalizeDC(shiftdim(a,2));
    c = shiftdim(b,1);
    rtDataC{1} = c(:,:,1);
    rtDataC{2} = c(:,:,2);
    
    [fixed1 fixed2 N] = size(b);
    M = fixed1*fixed2;
    morey = M/(M-1);
    
    for iEL = 1:2
        accMeanC(:,iEL) = mean(accDataC{iEL},2);
        accSteC(:,iEL) = sqrt(morey*var(accDataC{iEL},0,2)./(nSubjects));
        rtMeanC(:,iEL) = mean(rtDataC{iEL},2);
        rtSteC(:,iEL) = sqrt(morey*var(rtDataC{iEL},0,2)./(nSubjects));
    end
else
    for iEL = 1:2 % early/late
        accMeanC(:,iEL) = mean(accDataC{iEL},2);
        accSteC(:,iEL) = std(accDataC{iEL},0,2)./sqrt(nSubjects);
        rtMeanC(:,iEL) = mean(rtDataC{iEL},2);
        rtSteC(:,iEL) = std(rtDataC{iEL},0,2)./sqrt(nSubjects);
    end
end

%% Plot
p = expt.p;
nCV = numel(p.cueValidity);
intervalNames = {'Target 1','Target 2'};
cueNames = {'Valid','Invalid','Neutral'};
accLims = [0 2];
rtLims = [0 2];
xlims = [0 nSubjects+1];
axTitle = '';
[y, idx] = sort(p.cueValidity,2,'descend');

% indiv subjects
figure
for iRI = 1:numel(p.respInterval)
    subplot(1,numel(p.respInterval),iRI);
    hold on
    
    p1 = bar(repmat((1:nSubjects)',1,nCV),...
        accDataC{iRI}(idx,:)');

    set(gca,'XTick',1:nSubjects)
    xlabel('subject')
    ylabel('acc')
    legend(p1, cueNames(idx),'location','best')
    title(intervalNames{iRI})
    xlim(xlims)
    ylim(accLims)
    rd_supertitle(sprintf('N=%d', nSubjects));
    rd_raiseAxis(gca);
end

figure
for iRI = 1:numel(p.respInterval)
    subplot(1,numel(p.respInterval),iRI);
    
    p1 = bar(repmat((1:nSubjects)',1,nCV),...
        rtDataC{iRI}(idx,:)');
    
    set(gca,'XTick',1:nSubjects)
    xlabel('subject')
    ylabel('rt')
    legend(cueNames(idx),'location','best')
    title(intervalNames{iRI})
    xlim(xlims)
    ylim(rtLims)
    box off
    rd_supertitle(sprintf('N=%d', nSubjects));
    rd_raiseAxis(gca);
end

% group
figure
for iRI = 1:numel(p.respInterval)
    subplot(1,numel(p.respInterval),iRI);
    title(intervalNames{iRI},'FontSize',14)
    hold on
    
    b1 = bar(1:nCV, accMeanC(idx,iRI),'FaceColor',[.5 .5 .5]);
    p1 = errorbar(1:nCV, accMeanC(idx,iRI)', accSteC(idx,iRI)','k','LineStyle','none');
    
    set(gca,'XTick',1:nCV)
    set(gca,'XTickLabel', cueNames(idx),'FontSize',13)
    xlabel('Cue Validity','FontSize',12)
    ylabel('Accuracy (normalized)','FontSize',16)
    ylim([.6 1.2])
    box off
%     rd_supertitle(sprintf('N=%d', nSubjects));
    rd_raiseAxis(gca);
    pbaspect([3 5 3])
end

figure
for iRI = 1:numel(p.respInterval)
    subplot(1,numel(p.respInterval),iRI);
    hold on
    
    b1 = bar(1:nCV, rtMeanC(idx,iRI),'FaceColor',[.5 .5 .5]);
    p1 = errorbar(1:nCV, rtMeanC(idx,iRI)', rtSteC(idx,iRI)','k','LineStyle','none');
    
    set(gca,'XTick',1:nCV)
    set(gca,'XTickLabel', cueNames(idx))
    xlabel('cue validity')
    ylabel('rt')
    title(intervalNames{iRI})
    ylim([0.6 1.2]);
    box off
    rd_supertitle(sprintf('N=%d', nSubjects));
    rd_raiseAxis(gca);
end

fig = 3;
figdir = '/Users/jakeparker/Documents/tempatten';
fignames = {'fig6'};
figprefix = 'urc';

rd_saveAllFigs(fig,fignames,figprefix, figdir)

