%gbs summary figs
%overlaid line histograms and CI's
close all
type = 'ta';
datadir = '/Users/jakeparker/Google Drive/TA_Pupil/HPC/';
basedir = '/Users/jakeparker/Documents/MATLAB';
xlab = {'pcB','t1B','t2B','rcB','decB','pcL','t1L','t2L','rcL','tmax','yint'};
cleanflag = false;
nbins = 15;

cd(basedir)
load(['E0E3' type '_noL.mat'])
eval(['pa = pa_' type ';'])
cd([datadir type '_noL/fit'])
load(['gbs_E0E3' type '_ALL'])

gbs_error = nan(100,11,length(pa.subjects));
gbs_perror = gbs_error;
eci = nan(2,11,length(pa.subjects));
peci = eci;
pests = nan(100,11);

%clean gbsall struct of redundant glmparams matrix
if cleanflag
    for s = 1:length(pa.subjects)
        for f = 1:length(pa.fields)
            gbsall.(pa.subjects{s}).(pa.fields{f}).glmparams = [];
        end
    end
end

%preallocate error matrices for each condition
gbsall.gbserror = [];
for f = 1:length(pa.fields)
    gbsall.gbserror.(pa.fields{f}) = [];
    gbsall.gbserror.(pa.fields{f}).error = gbs_error;
    gbsall.gbserror.(pa.fields{f}).perror = gbs_perror;
    gbsall.gbserror.(pa.fields{f}).eci = eci;
    gbsall.gbserror.(pa.fields{f}).peci = peci;
end

%calculate errors and percent errors
for f = 1:length(pa.fields)  
    pests = [pa.(pa.fields{f}).models.betas pa.(pa.fields{f}).models.locations pa.(pa.fields{f}).models.tmax pa.(pa.fields{f}).models.yint];
    for s = 1:length(pa.subjects)
        gbs_error(:,:,s) = bsxfun(@minus,gbsall.(pa.subjects{s}).(pa.fields{f}).glmparams(:,[1:9 12 13]),pests(s,:));
        gbs_perror(:,:,s) = bsxfun(@rdivide,gbs_error(:,:,s),pests(s,:));
        eci(1,:,s) = prctile(gbs_error(:,:,s),2.5);
        eci(2,:,s) = prctile(gbs_error(:,:,s),97.5);
        peci(1,:,s) = prctile(gbs_perror(:,:,s),2.5);
        peci(2,:,s) = prctile(gbs_perror(:,:,s),97.5);
    end
    gbsall.gbserror.(pa.fields{f}).error = gbs_error;
    gbsall.gbserror.(pa.fields{f}).perror = gbs_perror;
    gbsall.gbserror.(pa.fields{f}).eci = eci;
    gbsall.gbserror.(pa.fields{f}).peci = peci;
end

%make plots
figure
w = size(gbs_error,2);
h = length(pa.fields);
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

for j = 1:w  
    for k = 1:h
        subplot(h,w,(k-1)*w+j)
        histline(squeeze(gbsall.gbserror.(pa.fields{k}).error(:,j,:)),nbins)
%         hold on
%         ylimit = ylim;
%         ymax = ylimit(2);
%         ci_plot(squeeze(gbsall.gbserror.(pa.fields{k}).eci(:,j,:)),ymax)
        try
            xlim([min(min(squeeze(gbsall.gbserror.(pa.fields{k}).eci(:,j,:)))) max(max(squeeze(gbsall.gbserror.(pa.fields{k}).eci(:,j,:))))]);
        catch
        end
        if j == 1
            ylabel(pa.fields(k))
        end
        if k == h
            xlabel(xlab{j})
        end
    end
end
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

figure
w = size(gbs_perror,2);
h = length(pa.fields);
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

for j = 1:w  
    for k = 1:h
        subplot(h,w,(k-1)*w+j)
        histline(squeeze(gbsall.gbserror.(pa.fields{k}).perror(:,j,:)),nbins)
%         hold on
%         ylimit = ylim;
%         ymax = ylimit(2);
%         ci_plot(squeeze(gbsall.gbserror.(pa.fields{k}).peci(:,j,:)),ymax)
        try
            xlim([min(min(squeeze(gbsall.gbserror.(pa.fields{k}).peci(:,j,:)))) max(max(squeeze(gbsall.gbserror.(pa.fields{k}).peci(:,j,:))))]);
        catch
        end
        if j == 1
            ylabel(pa.fields(k))
        end
        if k == h
            xlabel(xlab{j})
        end
    end
end
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

figure
w = size(gbs_error,2);
h = length(pa.fields);
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

for j = 1:w  
    for k = 1:h
        subplot(h,w,(k-1)*w+j)
        tempdist = squeeze(gbsall.gbserror.(pa.fields{k}).error(:,j,:))';
        hist(tempdist(:),40)
        if j == 1
            ylabel(pa.fields(k))
        end
        if k == h
            xlabel(xlab{j})
        end
    end
end
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])


figure
w = size(gbs_error,2);
h = length(pa.fields);
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

for j = 1:w  
    for k = 1:h
        subplot(h,w,(k-1)*w+j)
        tempdist = squeeze(gbsall.gbserror.(pa.fields{k}).perror(:,j,:))';
        hist(tempdist(:),40)
        if j == 1
            ylabel(pa.fields(k))
        end
        if k == h
            xlabel(xlab{j})
        end
    end
end
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

figure
w = size(gbs_error,2);
h = length(pa.fields);
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

for j = 1:w  
    for k = 1:h
        subplot(h,w,(k-1)*w+j)
        tempdist = squeeze(gbsall.gbserror.(pa.fields{k}).eci(:,j,:));
        plot(repmat(1:size(tempdist,2),2,1),tempdist)
        if j == 1
            ylabel(pa.fields(k))
        end
        if k == h
            xlabel(xlab{j})
        end
    end
end
set(gcf,'Color',[1 1 1])
set(gcf,'Position',[100 100 (210*w) (157*h)])

cd([datadir type '_noL/fit'])
save(['gbs_E0E3' type '_ALL'],'gbsall')

fig = 1:5;
fignames = {'gbs_sj_errors','gbs_sj_perc_errors','gbs_group_errors','gbs_group_perc_errors','gbs_sj_error_ci'};
figprefix = '';
filedir = [datadir type '_noL/plot'];

rd_saveAllFigs(fig,fignames,figprefix, filedir)