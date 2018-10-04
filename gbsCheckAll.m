%gbsCheckAll
cd('/Users/jakeparker/Google Drive/TA_Pupil/HPC/ta_noL')
dirstruct = dir('fit');
fitfiles = cell(1,length(dirstruct)-2);
for i = 3:length(dirstruct)
    fitfiles{i-2} = ['fit/' dirstruct(i).name];
end

close all

for i = 1:length(fitfiles)
    subject = fitfiles{i}(16:19);
    try
        gbsCheck(fitfiles{i})
        saveas(gcf,['plots/' subject],'png')
        close all
    catch
        fprintf('\nError with subject %s fit file\n',subject)
        close all
    end
end