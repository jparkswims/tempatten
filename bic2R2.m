load E0E3tvc_32M

SSr = nan(length(pa_tvc.subjects),length(pa_tvc.fields));
SSt = nan(length(pa_tvc.subjects),length(pa_tvc.fields));
n = pa_tvc.window(2)+1;
k = 11;

for f = 1:length(pa_tvc.fields)
    
    SSr(:,f) = n .* ((exp(pa_tvc.(pa_tvc.fields{f}).bic(:,:,1))./(n^k)) .^ (1/n));
    
    for t = 1:length(pa_tvc.subjects)
        
        smean = pa_tvc.(pa_tvc.fields{f}).smeans(t,:);
        SSt(t,f) = sum((smean-nanmean(smean)).^2);
        
    end
    
end

R2 = 1 - (SSr./SSt);