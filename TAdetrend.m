
t1det1 = zeros(1,size(t1norm,2),size(t1norm,3));
t2det1 = zeros(1,size(t2norm,2),size(t2norm,3));
neutraldet1 = zeros(1,size(neutralnorm,2),size(neutralnorm,3));
t1det2 = zeros(1,size(t1norm,2),size(t1norm,3));
t2det2 = zeros(1,size(t2norm,2),size(t2norm,3));
neutraldet2 = zeros(1,size(neutralnorm,2),size(neutralnorm,3));
trialmatnorm = zeros(3,size(trialmat,2),size(trialmat,3));

% det = input('For mean subraction detrending enter 1\nFor fitted line detrending enter 2\nEnter:');

for i = 1:length(subjects)

        trialmatnorm(:,:,i) = [nanmean(t1norm(:,:,i)) ; nanmean(t2norm(:,:,i)) ; nanmean(neutralnorm(:,:,i))];

 end

%if det == 1

    for i = 1:length(subjects)
        
        t1det1(1,:,i) = nanmean(t1norm(:,:,i)) - nanmean(trialmatnorm(:,:,i),1);
        t2det1(1,:,i) = nanmean(t2norm(:,:,i)) - nanmean(trialmatnorm(:,:,i),1);
        neutraldet1(1,:,i) = nanmean(neutralnorm(:,:,i)) - nanmean(trialmatnorm(:,:,i),1);

%         for j = 1:size(t1norm,1)
% 
%             t1det(j,:,i) = t1norm(j,:,i) - nanmean(trialmatnorm(:,:,i),1);
% 
%             t2det(j,:,i) = t2norm(j,:,i) - nanmean(trialmatnorm(:,:,i),1);
% 
%         end
% 
%         for j = 1:size(neutralnorm,1)
% 
%             neutraldet(j,:,i) = neutralnorm(j,:,i) - nanmean(trialmatnorm(:,:,i),1);
% 
%         end

    end
    
%elseif det == 2
    
    for i = 1:length(subjects)
        
        drift = polyfit(0:1750,nanmean(trialmatnorm(:,401:2151,i)),1);
        
        t1det2(1,:,i) = nanmean(t1norm(:,:,i)) - (drift(1) .* [-400:2500] + drift(2));
        t2det2(1,:,i) = nanmean(t2norm(:,:,i)) - (drift(1) .* [-400:2500] + drift(2));
        neutraldet2(1,:,i) = nanmean(neutralnorm(:,:,i)) - (drift(1) .* [-400:2500] + drift(2));
        
%         for j = 1:size(t1norm,1)
%             
%             t1det(j,:,i) = t1norm(j,:,i) - (drift(1) .* [-400:2500] + drift(2));
%             
%             t2det(j,:,i) = t2norm(j,:,i) - (drift(1) .* [-400:2500] + drift(2));
%             
%         end
%         
%         for j = 1:size(neutralnorm,1)
%             
%             neutraldet(j,:,i) = neutralnorm(j,:,i) - (drift(1) .* [-400:2500] + drift(2));
%             
%         end
        
    end
    
%end