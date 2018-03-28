function pa_view_optim(imfiles)

if ischar(imfiles)
    imfiles = {imfiles};
elseif ~iscell(imfiles)
    error('Input must be one file name string or cell array of file names')
end

figure(1)

for imf = 1:length(imfiles)
    
    load(imfiles{imf})
   
    for iter = 1:size(optimplot.x,1)
        
        clf
        pa_optim_plot(optimplot.x(iter,:),optimplot.Ymeas,optimplot.decloc,optimplot.optimval(iter))
        pause(0.05)
        
    end
    
    clear optimplot
    
end
        