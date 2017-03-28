%% test data

%% Create test data structure

load E0tvc.mat

pa_test.fields = pa_tvc.fields;

for i = 1:length(pa_test.fields)
    
    pa_test.(pa_test.fields{i}) = [];
    
end

pa_test.subjects = pa_tvc.subjects;
pa_test.window = [0 3500];
pa_test.duration = pa_tvc.duration;
pa_test.locs = pa_tvc.locs;
pa_test.loclabels = pa_tvc.loclabels;
pa_test.filedir = '/Users/jakeparker/Documents/tempatten/Etest/tvc';
pa_test.study = 'E0';
pa_test.type = 'tvc';
pa_test.baseline = 200;
pa_test.dectime = pa_tvc.dectime;
pa_test.targets = 2;

%% Build test data with specified patterns
B.t1v = [0.2 1.2 0.6 0.2 1];
B.t1n = [0.6 0.6 0.9 0.6 1];
B.t1i = [0.2 0.3 1.2 0.9 1];
B.t2v = [0.2 0.3 1.2 0.2 1];
B.t2n = [0.6 0.6 0.9 0.6 1];
B.t2i = [0.2 1.2 0.6 0.9 1];

B.t1c = [0 1.0 0.5 0 0];
B.t1f = zeros(1,5);
B.t2c = [0 0.5 1.0 0 0];
B.t2f = zeros(1,5);

rng(0)

for i = 1:length(pa_test.fields)
    
    f = pa_test.fields{i};
    v = f(1:end-1);
    c = f;
    c(end-1) = [];
    b = B.(v) + B.(c);
    B.(f) = [(b(1)+0.1.*randn(length(pa_test.subjects),1)) ...
        (b(2)+0.1.*randn(length(pa_test.subjects),1)) ...
        (b(3)+0.1.*randn(length(pa_test.subjects),1)) ...
        (b(4)+0.1.*randn(length(pa_test.subjects),1)) ...
        (b(5)+0.1.*randn(length(pa_test.subjects),1))]; ...
    
end

locations = [(0+20.*randn(length(pa_test.subjects),1)) ...
    (800+100.*randn(length(pa_test.subjects),1)) ...
    (1350+100.*randn(length(pa_test.subjects),1)) ...
    (1750+20.*randn(length(pa_test.subjects),1)) ];

tmaxs = 930 + 200.*randn(length(pa_test.subjects),1);

yints = 0 + 0.01.*randn(length(pa_test.subjects),1);

for i = 1:length(pa_test.fields)
    
    for j = 1:length(pa_test.subjects)

        pa_test.(pa_test.fields{i}).smeans(j,:) = glm_calc(pa_test.window,B.(pa_test.fields{i})(j,:),[num2cell(locations(j,:)) [0 round(pa_test.dectime(j))]],{'stick' 'stick' 'stick' 'stick' 'box'},tmaxs(j),yints(j));
        
    end
end



