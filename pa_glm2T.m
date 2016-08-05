function bdf = pa_glm2T(pa,varargin)

%ALWAYS INCLUDE 'target' FOR NOW

S = pa.subjects;
dfl = length(S);

if nargin == 1
    error('Not enough arguments: specify factors')
end 

fstr = cell(1,3);

if any(strcmp('target',varargin))
    factor.target = 2;
    dfl = dfl*2;
    fstr = [fstr ; {'t1' 't2' '0'}];
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

% switch numf
%     case 1
%         bdf(:,1:2) = fullfact([length(S) factor.(names{1})]);
%     case 2
%         bdf(:,1:3) = fullfact([length(S) factor.(names{1}) factor.(names{2})]);
%     case 3
%         bdf(:,1:4) = fullfact([length(S) factor.(names{1}) factor.(names{2}) factor.(names{3})]);
% end



for i = 1:size(bdf,1)
    
    str = [];
    smean = [];
    xstr = [];
    xmeans = [];
    xcounts = [];
    t1means = [];
    t2means = [];
    t1counts = [];
    t2counts = [];
    
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
        
        if strcmp('c',str) == 0 && strcmp('i',str) == 0

            if strcmp('a',str) == 0 && strcmp('n',str) == 0 && strcmp('u',str) == 0

                xstr = {[str 'ac'] [str 'ai'] [str 'nc'] [str 'ni'] [str 'uc'] [str 'ui']};

            elseif strcmp('t1',str) == 0 && strcmp('t2',str) == 0

                xstr = {['t1' str 'c'] ['t1' str 'i'] ['t2' str 'c'] ['t2' str 'i']};

            else

                xstr = {[str 'c'] [str 'i']};

            end

        elseif strcmp('c',str) || strcmp('i',str)

            if strcmp('t1',str) || strcmp('t2',str)

                xstr = {[str(1:2) 'a' str(3)] [str(1:2) 'n' str(3)] [str(1:2) 'u' str(3)]};

            elseif strcmp('a',str) || strcmp('n',str) || strcmp('u',str)

                xstr = {['t1' str] ['t2' str]};

            else
                
                xstr = {['t1a' str] ['t1n' str] ['t1u' str] ['t2a' str] ['t2n' str] ['t2u' str]};
                
            end
            
        end
        
        for j = 1:length(xstr)
            xmeans(j,:) = pa.(xstr{j}).smeans(bdf(i,1),:);
            xcounts(j,:) = pa.(xstr{j}).count(bdf(i,1),:);
        end
        
        smean = wmean(xmeans,xcounts);
        
    end
    
    if strncmp('t1',str,2) || strncmp('t2',str,2)
        bdf(i,end) = pupildeconv(smean,size(pa.trialmat,2),bdf(i,2)+1);
    else
        t1str = str(strcmp('t1',str));
        t2str = str(strcmp('t2',str));
        
        for j = 1:length(t1str)
            t1means(j,:) = pa.(t1str{j}).smeans(bdf(i,1),:);
            t1counts(j,:) = pa.(t1str{j}).count(bdf(i,1),:);
            t2means(j,:) = pa.(t2str{j}).smeans(bdf(i,1),:);
            t2counts(j,:) = pa.(t2str{j}).count(bdf(i,1),:);
        end

        t1mean = wmean(t1means,t1counts);
        t2mean = wmean(t2means,t2counts);

        t1b = pupildeconv(t1mean,size(pa.trialmat,2),2);
        t2b = pupildeconv(t2mean,size(pa.trialmat,2),3);

        bdf(i,end) = mean([t1b t2b]);

    end

end

if length(str) == 4

ls = length(S);
mbdf = zeros(size(bdf,1)/ls,1);
sbdf = zeros(size(bdf,1)/ls,1);
filedir = '/Users/jakeparker/Documents/tempatten/E0_cb/t-a-c';
bmat = zeros(factor.valid,factor.correct,factor.target);
smat = zeros(factor.valid,factor.correct,factor.target);
    
    for j = 1:ls

        figure
        subplot(2,2,1)
        bar([1 2],[bdf(j,5)  bdf(j+2*ls,5)  bdf(j+4*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t1c')
        set(gca,'XTickLabel',{[fstr{1,bdf(j,2)} fstr{2,bdf(j,3)} fstr{3,bdf(j,4)} '   ' ...
        fstr{1,bdf(j+2*ls,2)} fstr{2,bdf(j+2*ls,3)} fstr{3,bdf(j+2*ls,4)} '   ' ...
        fstr{1,bdf(j+4*ls,2)} fstr{2,bdf(j+4*ls,3)} fstr{3,bdf(j+4*ls,4)}] '0'})
    
        subplot(2,2,2)
        bar([1 2],[bdf(j+6*ls,5)  bdf(j+8*ls,5)  bdf(j+10*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t1i')
        set(gca,'XTickLabel',{[fstr{1,bdf(j+6*ls,2)} fstr{2,bdf(j+6*ls,3)} fstr{3,bdf(j+6*ls,4)} '   ' ...
        fstr{1,bdf(j+8*ls,2)} fstr{2,bdf(j+8*ls,3)} fstr{3,bdf(j+8*ls,4)} '   ' ...
        fstr{1,bdf(j+10*ls,2)} fstr{2,bdf(j+10*ls,3)} fstr{3,bdf(j+10*ls,4)}] '0'})

        subplot(2,2,3)
        bar([1 2],[bdf(j+1*ls,5)  bdf(j+3*ls,5)  bdf(j+5*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t2c')
        set(gca,'XTickLabel',{[fstr{1,bdf(j+1*ls,2)} fstr{2,bdf(j+1*ls,3)} fstr{3,bdf(j+1*ls,4)} '   ' ...
        fstr{1,bdf(j+3*ls,2)} fstr{2,bdf(j+3*ls,3)} fstr{3,bdf(j+3*ls,4)} '   ' ...
        fstr{1,bdf(j+5*ls,2)} fstr{2,bdf(j+5*ls,3)} fstr{3,bdf(j+5*ls,4)}] '0'})
        
        subplot(2,2,4)
        bar([1 2],[bdf(j+7*ls,5)  bdf(j+9*ls,5)  bdf(j+11*ls,5); 0 0 0])
        xlim([0.5 1.5])
        title('t2i')
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

    bmat = reshape(mbdf,[2 3 2]);
    smat = reshape(sbdf,[2 3 2]);
    

    figure
    subplot(2,2,1)
    barwitherr([sbdf(1) sbdf(3) sbdf(5);0 0 0],[1 2],[mbdf(1) mbdf(3) mbdf(5); 0 0 0])
    hold on
    xlim([0.5 1.5])
    title('t1c')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    subplot(2,2,2)
    barwitherr([sbdf(7) sbdf(9) sbdf(11);0 0 0],[1 2],[mbdf(7) mbdf(9) mbdf(11); 0 0 0])
    xlim([0.5 1.5])
    title('t1i')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    subplot(2,2,3)
    barwitherr([sbdf(2) sbdf(4) sbdf(6);0 0 0],[1 2],[mbdf(2) mbdf(4) mbdf(6); 0 0 0])
    xlim([0.5 1.5])
    title('t2c')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    subplot(2,2,4)
    barwitherr([sbdf(8) sbdf(10) sbdf(12);0 0 0],[1 2],[mbdf(8) mbdf(10) mbdf(12); 0 0 0])
    xlim([0.5 1.5])
    title('t2i')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    fig = 1;
    fignames = {'tac_group_beta_weights'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)

    close all

    x = mean(bmat,3);

%   target and validity
    figure
    subplot(1,2,1)
    bar([1 2],[x(1,1) x(1,2) x(1,3); 0 0 0])
    xlim([0.5 1.5])
    title('t1 and validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    subplot(1,2,2)
    bar([1 2],[x(2,1) x(2,2) x(2,3); 0 0 0])
    xlim([0.5 1.5])
    title('t2 and validity')
    set(gca,'XTickLabel',{'a   n   u' '0'})

    x = mean(bmat,2);

    %target and correct
    figure
    subplot(1,2,1)
    bar([1 2],[x(1,1,1) x(1,1,2); 0 0])
    xlim([0.5 1.5])
    title('t1 and correctness')
    set(gca,'XTickLabel',{'c   i' '0'}) 
   
    subplot(1,2,2)
    bar([1 2],[x(2,1,1) x(2,1,2); 0 0])
    xlim([0.5 1.5])
    title('t2 and correctness')
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
    bar([1 2],[x(1) 0 x(2); 0 0 0])
    xlim([0.5 1.5])
    title('targets')
    set(gca,'XTickLabel',{'t1     t2' '0'})

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
    
    fig = [1 2 3];
    fignames = {'targets' 'validity' 'correctness'};
    figprefix = 'ta';
    
    rd_saveAllFigs(fig,fignames,figprefix, filedir)

    close all

    cd('/Users/jakeparker/Documents/R')

    save('paANOVA.mat','bdf')

end


        

% ls = length(S);
% 
% for i = 1:(size(bdf,1)/ls)
% 
%     x = ls*i;
% 
%     



