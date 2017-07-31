function r_anova(pa,regressor,varargin)

cd('/Users/jakeparker/Documents/R/code/tempatten')

bdf = pa.bdf;
ldf = pa.ldf;
study = pa.study;
model = num2str(pa.current_model);

% if strcmp(regressor,'target')
%     
%     s = size(ldf);
%     
%     for i = 1:s(1)
%         if ldf(i,2) == 2
%             ldf = [ldf ; ldf(i,:)];
%         end
%     end
%     
%     for i = s(1):-1:1
%         if ldf(i,2) == 2
%             ldf(i,:) = [];
%         end
%     end
%     
% end
    

if any(strcmp(varargin,'positive'))
    study_type = pa.type;
    study_type(end) = [];
    
    for i = size(bdf,1):-1:1
        
        if bdf(i,end-1) == 2
            
            bdf(i,:) = [];
            ldf(i,:) = [];
            
        end
        
    end
    
    bdf(:,end-1) = [];
    ldf(:,end-1) = [];
    
else
    
    study_type = pa.type;
    
end

if strcmp(regressor,'target')
    ldf1 = [];
    ldf2 = [];
    for i = 1:size(ldf,1)
        if ldf(i,2) == 1
            ldf1 = [ldf1;ldf(i,:)];
        else
            ldf2 = [ldf2;ldf(i,:)];
        end
    end
    ldf1(:,2) = [];
    ldf2(:,2) = [];
%     ldf1 = ldf(1:size(ldf,1)/2,:);
%     ldf1(:,2) = [];
%     ldf2 = ldf(size(ldf,1)/2+1:end,:);
%     ldf2(:,2) = [];
    
    save([pa.study study_type 'ANOVA' regressor model],'bdf','ldf1','ldf2','study_type','regressor','study','model')
else
    save([pa.study study_type 'ANOVA' regressor model],'bdf','ldf','study_type','regressor','study','model')
end

cd('/Users/jakeparker/Documents/MATLAB')