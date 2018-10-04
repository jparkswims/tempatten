function p = uncertplot(fignum,X,lci,uci,pdim,pmind,sjind,colorcell,markercell,shapecell,xlab,varargin)
    
    if any(strcmp(varargin,'jitter'))
        rr = (0.08*size(X,pdim))/2;
        xjit = linspace(-rr,rr,size(X,pdim));
    else
        xjit = zeros(1,size(X,pdim));
    end
    
    if any(strcmp(varargin,'1by1'))
        oneflag = true;
    else
        oneflag = false;
    end
    
    if any(strcmp(varargin,'E2'))
        L2 = varargin{find(strcmp('E2',varargin))+1};
        U2 = varargin{find(strcmp('E2',varargin))+2};
    else
        L2 = [];
        U2 = [];
    end
    
    figure(fignum)
    set(gcf,'Color',[1 1 1])
    %set(gcf,'Position',[100 100 840 630])
    hold on
    
    p = [];
    
    if ~ oneflag
        for pp = 1:size(X,pdim)
            if pdim == 1
                p = errorbar(pmind + xjit(pp),X(pp,pmind,sjind),lci(pp,pmind,sjind),uci(pp,pmind,sjind),shapecell{pp},'color',colorcell{pp},'MarkerFaceColor',markercell{pp});
            elseif pdim == 3
                p = errorbar(pmind + xjit(pp),X(sjind,pmind,pp),lci(sjind,pmind,pp),uci(sjind,pmind,pp),shapecell{pp},'color',colorcell{pp},'MarkerFaceColor',markercell{pp});
            end
        end
        set(gca,'XTick',pmind)
        set(gca,'XTickLabel',xlab(pmind))
        xlim([min(pmind)-1 max(pmind)+1])
    elseif oneflag
        for ii = 1:length(pmind)
            for pp = 1:size(X,pdim)
                if pdim == 1
                    if ii == length(pmind)
                        p = [p errorbar2(ii + xjit(pp),X(pp,pmind(ii),sjind),lci(pp,pmind(ii),sjind),uci(pp,pmind(ii),sjind),L2(pp,pmind(ii),sjind),U2(pp,pmind(ii),sjind),shapecell{pp},markercell{ii,pp},colorcell{ii},1.5,10)];
                    else
                        errorbar2(ii + xjit(pp),X(pp,pmind(ii),sjind),lci(pp,pmind(ii),sjind),uci(pp,pmind(ii),sjind),L2(pp,pmind(ii),sjind),U2(pp,pmind(ii),sjind),shapecell{pp},markercell{ii,pp},colorcell{ii},1.5,10);
                    end
                elseif pdim == 3
                    errorbar2(ii + xjit(pp),X(sjind,pmind(ii),pp),lci(sjind,pmind(ii),pp),uci(sjind,pmind(ii),pp),shapecell{pp},markercell{ii},colorcell{ii},2,10);
                end
            end
        end
        set(gca,'XTick',1:length(pmind))
        set(gca,'XTickLabel',xlab(pmind))
        xlim([min(1:length(pmind))-1 max(1:length(pmind))+1])
    end
    
%     xlim([min(pmind)-1 max(pmind)+1])
%     set(gca,'XTick',pmind)
%     set(gca,'XTickLabel',xlab(pmind))

end