function bdf = pa_glm3T(pa,varargin)

%inputs: 'target', 'atten', 'correct'

%ALWAYS INCLUDE 'target' FOR NOW

S = pa.subjects;
dfl = length(S);

if nargin == 1
    error('Not enough arguments: specify factors')
end 

fstr = cell(1,3);

if any(strcmp('target',varargin))
    factor.target = 3;
    dfl = dfl*3;
    fstr = [fstr ; {'t1' 't2' 't3'}];
end

if any(strcmp('atten',varargin))
    factor.valid = 3;
    dfl = dfl*3;
    fstr = [fstr ; {'a' 'n' 'u'}];
end

if any(strcmp('correct',varargin))
    factor.correct = 2;
    dfl = dfl*2;
    fstr = [fstr ; {'c' 'i' '0'}];
end

fstr(1,:) = [];

names = fieldnames(factor);

numf = length(names);

if length(varargin) > numf
    error('invalid input arguments')
end

bdf = zeros(dfl,2+numf);

factor.all = [];

for i = 1:numf
    factor.all = [factor.all factor.(names{i})];
end

bdf(:,1:numf+1) = fullfact([length(S) factor.all]);

for i = 1:size(bdf,1)
    
    str = [];
    smean = [];
    xstr = [];
    xmeans = [];
    xcounts = [];
    t1means = [];
    t2means = [];
    t3means = [];
    t1counts = [];
    t2counts = [];
    t3counts = [];
    
    for j = 2:numf+1
        str = [str fstr{j-1,bdf(i,j)}];
    end
    
    fprintf('%s\n',str)
    
    if strcmp('0',str)
        error('Invalid dataframe value')
    end
    
    if length(str) == 4
        
        smean = pa.(str).smeans(bdf(i,1),:);
        
    elseif length(str) < 4
        
        if isempty(strfind(str,'c')) && isempty(strfind(str,'i'))

            if isempty(strfind(str,'a')) && isempty(strfind(str,'n')) && isempty(strfind(str,'u'))

                xstr = {[str 'ac'] [str 'ai'] [str 'nc'] [str 'ni'] [str 'uc'] [str 'ui']};

            elseif isempty(strfind(str,'t1')) && isempty(strfind(str,'t2')) && isempty(strfind(str,'t3'))

                xstr = {['t1' str 'c'] ['t1' str 'i'] ['t2' str 'c'] ['t2' str 'i'] ['t3' str 'c'] ['t3' str 'i']};

            else

                xstr = {[str 'c'] [str 'i']};

            end

        elseif isempty(strfind(str,'c')) == 0 || isempty(strfind(str,'i')) == 0

            if isempty(strfind(str,'t1')) == 0 || isempty(strfind(str,'t2')) == 0 || isempty(strfind(str,'t3')) == 0

                xstr = {[str(1:2) 'a' str(3)] [str(1:2) 'n' str(3)] [str(1:2) 'u' str(3)]};

            elseif isempty(strfind(str,'a')) == 0 || isempty(strfind(str,'n')) == 0 || isempty(strfind(str,'u')) == 0

                xstr = {['t1' str] ['t2' str] ['t3' str]};

            else
                
                xstr = {['t1a' str] ['t1n' str] ['t1u' str] ['t2a' str] ['t2n' str] ['t2u' str] ['t3a' str] ['t3n' str] ['t3u' str]};
                
            end
            
        end
        
        for j = 1:length(xstr)
            xmeans(j,:) = pa.(xstr{j}).smeans(bdf(i,1),:);
            xcounts(j,:) = pa.(xstr{j}).count(bdf(i,1),:);
        end
        
        smean = wmean(xmeans,xcounts);
        
    end
    
    if strncmp('t1',str,2) || strncmp('t2',str,2) || strncmp('t3',str,2)
        bdf(i,end) = pupildeconv(smean,size(pa.trialmat,2),pa.locs,bdf(i,2)+1);
    else
        t1str = ['t1' str];
        t2str = ['t2' str];
        t3str = ['t3' str];
        
        for j = 1:length(t1str)
            t1means(j,:) = pa.(t1str{j}).smeans(bdf(i,1),:);
            t1counts(j,:) = pa.(t1str{j}).count(bdf(i,1),:);
            t2means(j,:) = pa.(t2str{j}).smeans(bdf(i,1),:);
            t2counts(j,:) = pa.(t2str{j}).count(bdf(i,1),:);
            t3means(j,:) = pa.(t3str{j}).smeans(bdf(i,1),:);
            t3counts(j,:) = pa.(t3str{j}).count(bdf(i,1),:);
        end

        t1mean = wmean(t1means,t1counts);
        t2mean = wmean(t2means,t2counts);
        t3mean = wmean(t3means,t3counts);

        t1b = pupildeconv(t1mean,size(pa.trialmat,2),pa.locs,2);
        t2b = pupildeconv(t2mean,size(pa.trialmat,2),pa.locs,3);
        t3b = pupildeconv(t3mean,size(pa.trialmat,2),pa.locs,4);

        bdf(i,end) = mean([t1b t2b t3b]);

    end

end

if length(str) == 4

ls = length(S);
mbdf = zeros(size(bdf,1)/ls,1);
sbdf = zeros(size(bdf,1)/ls,1);
filedir = pa.filedir;
bmat = zeros(factor.valid,factor.correct,factor.target);
smat = zeros(factor.valid,factor.correct,factor.target);
    
    for j = 1:ls

        figure
        subplot(2,3,1)
        bar([1 2],[bdf(j,5)  bdf(j+3*ls,5)  bdf(j+6*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t1c')
        set(gca,'XTickLabel',{[fstr{1,bdf(j,2)} fstr{2,bdf(j,3)} fstr{3,bdf(j,4)} '   ' ...
        fstr{1,bdf(j+3*ls,2)} fstr{2,bdf(j+3*ls,3)} fstr{3,bdf(j+3*ls,4)} '   ' ...
        fstr{1,bdf(j+6*ls,2)} fstr{2,bdf(j+6*ls,3)} fstr{3,bdf(j+6*ls,4)}] '0'})
    
        subplot(2,3,4)
        bar([1 2],[bdf(j+9*ls,5)  bdf(j+12*ls,5)  bdf(j+15*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t1i')
        set(gca,'XTickLabel',{[fstr{1,bdf(j+9*ls,2)} fstr{2,bdf(j+9*ls,3)} fstr{3,bdf(j+9*ls,4)} '   ' ...
        fstr{1,bdf(j+12*ls,2)} fstr{2,bdf(j+12*ls,3)} fstr{3,bdf(j+12*ls,4)} '   ' ...
        fstr{1,bdf(j+15*ls,2)} fstr{2,bdf(j+15*ls,3)} fstr{3,bdf(j+15*ls,4)}] '0'})

        subplot(2,3,2)
        bar([1 2],[bdf(j+1*ls,5)  bdf(j+4*ls,5)  bdf(j+7*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t2c')
        set(gca,'XTickLabel',{[fstr{1,bdf(j+1*ls,2)} fstr{2,bdf(j+1*ls,3)} fstr{3,bdf(j+1*ls,4)} '   ' ...
        fstr{1,bdf(j+4*ls,2)} fstr{2,bdf(j+4*ls,3)} fstr{3,bdf(j+4*ls,4)} '   ' ...
        fstr{1,bdf(j+7*ls,2)} fstr{2,bdf(j+7*ls,3)} fstr{3,bdf(j+7*ls,4)}] '0'})
        
        subplot(2,3,5)
        bar([1 2],[bdf(j+10*ls,5)  bdf(j+13*ls,5)  bdf(j+16*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t2i')
        set(gca,'XTickLabel',{[fstr{1,bdf(j+7*ls,2)} fstr{2,bdf(j+7*ls,3)} fstr{3,bdf(j+7*ls,4)} '   ' ...
        fstr{1,bdf(j+9*ls,2)} fstr{2,bdf(j+9*ls,3)} fstr{3,bdf(j+9*ls,4)} '   ' ...
        fstr{1,bdf(j+11*ls,2)} fstr{2,bdf(j+11*ls,3)} fstr{3,bdf(j+11*ls,4)}] '0'})

        subplot(2,3,3)
        bar([1 2],[bdf(j+2*ls,5)  bdf(j+5*ls,5)  bdf(j+8*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t3c')
        set(gca,'XTickLabel',{[fstr{1,bdf(j,2)} fstr{2,bdf(j,3)} fstr{3,bdf(j,4)} '   ' ...
        fstr{1,bdf(j+3*ls,2)} fstr{2,bdf(j+3*ls,3)} fstr{3,bdf(j+3*ls,4)} '   ' ...
        fstr{1,bdf(j+6*ls,2)} fstr{2,bdf(j+6*ls,3)} fstr{3,bdf(j+6*ls,4)}] '0'})
    
        subplot(2,3,6)
        bar([1 2],[bdf(j+11*ls,5)  bdf(j+14*ls,5)  bdf(j+17*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t3i')
        set(gca,'XTickLabel',{[fstr{1,bdf(j+7*ls,2)} fstr{2,bdf(j+7*ls,3)} fstr{3,bdf(j+7*ls,4)} '   ' ...
        fstr{1,bdf(j+9*ls,2)} fstr{2,bdf(j+9*ls,3)} fstr{3,bdf(j+9*ls,4)} '   ' ...
        fstr{1,bdf(j+11*ls,2)} fstr{2,bdf(j+11*ls,3)} fstr{3,bdf(j+11*ls,4)}] '0'})
    
        figdir = [filedir '/' S{j}];
        fig = 1;
        fignames = {'tac_beta_weights'};
        figprefix = 'ta';
    
        rd_saveAllFigs(fig,fignames,figprefix, figdir)

        close all

    end

    for j = 1:size(bdf,1)/ls
        mbdf(j,:) = mean(bdf(j*ls-(ls-1):j*ls,5));
        sbdf(j,:) = std(bdf(j*ls-(ls-1):j*ls,5))/sqrt(ls);
    end

    bmat = reshape(mbdf,[3 3 2]);
    smat = reshape(sbdf,[3 3 2]);
    

    figure
    subplot(2,3,1)
    barwitherr([sbdf(1) sbdf(4) sbdf(7);0 0 0],[1 2],[mbdf(1) mbdf(4) mbdf(7); 0 0 0])
    hold on
    xlim([0.5 1.5])
    title('t1c')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-1 1.5])

    subplot(2,3,4)
    barwitherr([sbdf(10) sbdf(13) sbdf(16);0 0 0],[1 2],[mbdf(10) mbdf(13) mbdf(16); 0 0 0])
    xlim([0.5 1.5])
    title('t1i')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-1 1.5])

    subplot(2,3,2)
    barwitherr([sbdf(2) sbdf(5) sbdf(8);0 0 0],[1 2],[mbdf(2) mbdf(5) mbdf(8); 0 0 0])
    xlim([0.5 1.5])
    title('t2c')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-1 1.5])

    subplot(2,3,5)
    barwitherr([sbdf(11) sbdf(14) sbdf(17);0 0 0],[1 2],[mbdf(11) mbdf(14) mbdf(17); 0 0 0])
    xlim([0.5 1.5])
    title('t2i')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-1 1.5])
    
    subplot(2,3,3)
    barwitherr([sbdf(3) sbdf(6) sbdf(9);0 0 0],[1 2],[mbdf(3) mbdf(6) mbdf(9); 0 0 0])
    xlim([0.5 1.5])
    title('t3c')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-1 1.5])
    
    subplot(2,3,6)
    barwitherr([sbdf(12) sbdf(15) sbdf(18);0 0 0],[1 2],[mbdf(12) mbdf(15) mbdf(18); 0 0 0])
    xlim([0.5 1.5])
    title('t3i')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-1 1.5])

    fig = 1;
    fignames = {'tac_group_beta_weights'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)

    close all

    x = mean(bmat,3);

%   target and validity
    figure
    subplot(1,3,1)
    bar([1 2],[x(1,1) x(1,2) x(1,3); 0 0 0])
    xlim([0.5 1.5])
    title('t1 and validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-0.5 1])

    subplot(1,3,2)
    bar([1 2],[x(2,1) x(2,2) x(2,3); 0 0 0])
    xlim([0.5 1.5])
    title('t2 and validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-0.5 1])
    
    subplot(1,3,3)
    bar([1 2],[x(3,1) x(3,2) x(3,3); 0 0 0])
    xlim([0.5 1.5])
    title('t3 and validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})
    ylim([-0.5 1])

    x = mean(bmat,2);

    %target and correct
    figure
    subplot(1,3,1)
    bar([1 2],[x(1,1,1) x(1,1,2); 0 0])
    xlim([0.5 1.5])
    title('t1 and correctness')
    set(gca,'XTickLabel',{'c   i' '0'}) 
   
    subplot(1,3,2)
    bar([1 2],[x(2,1,1) x(2,1,2); 0 0])
    xlim([0.5 1.5])
    title('t2 and correctness')
    set(gca,'XTickLabel',{'c   i' '0'})  
    
    subplot(1,3,3)
    bar([1 2],[x(3,1,1) x(3,1,2); 0 0])
    xlim([0.5 1.5])
    title('t3 and correctness')
    set(gca,'XTickLabel',{'c   i' '0'})
  
    x = mean(bmat,1);
    
    %validity and correctness
    figure
    subplot(1,2,1)
    bar([1 2],[x(1,1,1) x(1,2,1) x(1,3,1); 0 0 0])
    xlim([0.5 1.5])
    title('correct and validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    subplot(1,2,2)
    bar([1 2],[x(1,1,2) x(1,2,2) x(1,3,2); 0 0 0])
    xlim([0.5 1.5])
    title('incorrect and validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    
    fig = [1 2 3];
    fignames = {'target_and_validity' 'target_and_correct' 'correct_and_validity'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)

    close all
    
    x = mean(mean(bmat,3),2);

    %targets
    figure
    bar([1 2],[x(1) x(2) x(3); 0 0 0])
    xlim([0.5 1.5])
    title('targets')
    set(gca,'XTickLabel',{'t1   t2   t3' '0'})

    x = mean(mean(bmat,3),1);

    %validity
    figure
    bar([1 2],[x(1) x(2) x(3); 0 0 0])
    xlim([0.5 1.5])
    title('validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    x = mean(mean(bmat,2),1);

    %correct
    figure
    bar([1 2],[x(1) 0 x(2); 0 0 0])
    xlim([0.5 1.5])
    title('correctness')
    set(gca,'XTickLabel',{'c     i' '0'})
    ylim([0 0.5])
    
    fig = [1 2 3];
    fignames = {'targets' 'validity' 'correctness'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)

    close all

    cd('/Users/jakeparker/Documents/R')

    save('paANOVA.mat','bdf')

end