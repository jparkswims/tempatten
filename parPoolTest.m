function parPoolTest(wnum)

parpool(wnum);

parfor i = 1:wnum
    fprintf('%d\n',i)
end

i = 1:wnum;
save('~/fit/TA_Pupil/TestSave.mat','i')
