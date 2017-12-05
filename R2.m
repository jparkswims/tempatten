
load E0E3tvc_32M
window = pa_tvc.window;
norm = 'max';
Btypes = pa_tvc.models(1).Btypes;

SSr = nan(length(pa_tvc.subjects),length(pa_tvc.fields));
SSt = nan(length(pa_tvc.subjects),length(pa_tvc.fields));

for f = 1:length(pa_tvc.fields)
    
    for s = 1:length(pa_tvc.subjects)
        B = pa_tvc.(pa_tvc.fields{f}).models(1).betas(s,:);
        Blocs = [num2cell(pa_tvc.(pa_tvc.fields{f}).models(1).locations(s,:)) [0 round(pa_tvc.dectime(s))]];
        tmax = pa_tvc.(pa_tvc.fields{f}).models(1).tmax(s);
        yint = pa_tvc.(pa_tvc.fields{f}).models(1).yint(s);
        Ymeas = pa_tvc.(pa_tvc.fields{f}).smeans(s,:);
        Ymeas(1:-window(1)) = [];
    
        Ycalc = glm_calc(window,B,Blocs,Btypes,tmax,yint,norm);
        SSr(s,f) = sum((Ymeas-Ycalc).^2);
        SSt(s,f) = sum((Ymeas-nanmean(Ymeas)).^2);
        
    end
end

R2mat = 1 - (SSr./SSt);
        