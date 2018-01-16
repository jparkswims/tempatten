function parPoolTest(wnum)

parfor i = 1:wnum
    fprintf('%d\n',i)
end

i = 1:wnum;
save('TestSave.mat',i)