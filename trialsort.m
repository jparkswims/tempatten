if strcmp(study,'E0') || strcmp(study,'E3') || strcmp(study,'E0E3')
    if strcmp(type,'cue')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        x = 1; y = 1; z = 1;
        t1x = []; t2x = []; nx = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1x(x,:) = trialmatx(j,:);
                    x = x+1;
                case 2
                    t2x(y,:) = trialmatx(j,:);
                    y = y+1;
                case 0
                    nx(z,:) = trialmatx(j,:);
                    z = z+1;
            end
            
        end
        
    elseif strcmp(type,'ta')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        x1 = 1; x2 = 1; x3 = 1;
        
        t1ax = []; t1ux = []; t1nx = [];
        t2ax = []; t2ux = []; t2nx = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1ax(x1,:) = trialmatx(j,:);
                    t2ux(x1,:) = trialmatx(j,:);
                    x1 = x1+1;
                case 2
                    t1ux(x2,:) = trialmatx(j,:);
                    t2ax(x2,:) = trialmatx(j,:);
                    x2 = x2+1;
                case 0
                    t1nx(x3,:) = trialmatx(j,:);
                    t2nx(x3,:) = trialmatx(j,:);
                    x3 = x3+1;
            end
            
        end
        
    elseif strcmp(type,'tvc')
        
        ival = find(strcmp(expt.trials_headers,'cueValidity'));
        icor = find(strcmp(expt.trials_headers,'correct'));
        icue = find(strcmp(expt.trials_headers,'respInterval'));
        
        x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1; x6 = 1;
        y1 = 1; y2 = 1; y3 = 1; y4 = 1; y5 = 1; y6 = 1;
        
        t1acx = []; t1ucx = []; t1ncx = []; t1afx = []; t1ufx = []; t1nfx = [];
        t2acx = []; t2ucx = []; t2ncx = []; t2afx = []; t2ufx = []; t2nfx = [];
        
        for j = 1:size(trialmatx,1)
            if trialsPresented(j,icue) == 1
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t1acx(x1,:) = trialmatx(j,:);
                            x1 = x1+1;
                        case 2
                            t1ucx(x2,:) = trialmatx(j,:);
                            x2 = x2+1;
                        case 3
                            t1ncx(x3,:) = trialmatx(j,:);
                            x3 = x3+1;
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t1afx(x4,:) = trialmatx(j,:);
                            x4 = x4+1;
                        case 2
                            t1ufx(x5,:) = trialmatx(j,:);
                            x5 = x5+1;
                        case 3
                            t1nfx(x3,:) = trialmatx(j,:);
                            x6 = x6+1;
                    end
                end
            elseif trialsPresented(j,icue) == 2
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t2acx(y1,:) = trialmatx(j,:);
                            y1 = y1+1;
                        case 2
                            t2ucx(y2,:) = trialmatx(j,:);
                            y2 = y2+1;
                        case 3
                            t2ncx(y3,:) = trialmatx(j,:);
                            y3 = y3+1;
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t2afx(y4,:) = trialmatx(j,:);
                            y4 = y4+1;
                        case 2
                            t2ufx(y5,:) = trialmatx(j,:);
                            y5 = y5+1;
                        case 3
                            t2nfx(y6,:) = trialmatx(j,:);
                            y6 = y6+1;
                    end
                end
            end
        end
    end
elseif strcmp(study,'E5')
    if strcmp(type,'cue')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        x = 1; y = 1; w = 1; z = 1;
        t1x = []; t2x = []; t3x = []; nx = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1x(x,:) = trialmatx(j,:);
                    x = x+1;
                case 2
                    t2x(y,:) = trialmatx(j,:);
                    y = y+1;
                case 3
                    t3x(w,:) = trialmatx(j,:);
                    w = w+1;
                case 0
                    nx(z,:) = trialmatx(j,:);
                    z = z+1;
            end
            
        end
        
    elseif strcmp(type,'ta')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        t1ax = []; t1ux = []; t1nx = [];
        t2ax = []; t2ux = []; t2nx = [];
        t3ax = []; t3ux = []; t3nx = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1ax = [t1ax ; trialmatx(j,:)];
                    t2ux = [t2ux ; trialmatx(j,:)];
                    t3ux = [t3ux ; trialmatx(j,:)];
                case 2
                    t1ux = [t1ux ; trialmatx(j,:)];
                    t2ax = [t2ax ; trialmatx(j,:)];
                    t3ux = [t3ux ; trialmatx(j,:)];
                case 3
                    t1ux = [t1ux ; trialmatx(j,:)];
                    t2ux = [t2ux ; trialmatx(j,:)];
                    t3ax = [t3ax ; trialmatx(j,:)];
                case 0
                    t1nx = [t1nx ; trialmatx(j,:)];
                    t2nx = [t2nx ; trialmatx(j,:)];
                    t3nx = [t3nx ; trialmatx(j,:)];
            end
            
        end
        
    elseif strcmp(type,'tvc')
        
        ival = find(strcmp(expt.trials_headers,'cueValidity'));
        icor = find(strcmp(expt.trials_headers,'correct'));
        icue = find(strcmp(expt.trials_headers,'respInterval'));
        
        t1acx = []; t1ucx = []; t1ncx = []; t1afx = []; t1ufx = []; t1nfx = [];
        t2acx = []; t2ucx = []; t2ncx = []; t2afx = []; t2ufx = []; t2nfx = [];
        t3acx = []; t3ucx = []; t3ncx = []; t3afx = []; t3ufx = []; t3nfx = [];
        
        for j = 1:size(trialmatx,1)
            if trialsPresented(j,icue) == 1
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t1acx = [t1acx ; trialmatx(j,:)];
                        case 2
                            t1ucx = [t1ucx ; trialmatx(j,:)];
                        case 3
                            t1ncx = [t1ncx ; trialmatx(j,:)];
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t1afx = [t1afx ; trialmatx(j,:)];
                        case 2
                            t1ufx = [t1ufx ; trialmatx(j,:)];
                        case 3
                            t1nfx = [t1nfx ; trialmatx(j,:)];
                    end
                end
            elseif trialsPresented(j,icue) == 2
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t2acx = [t2acx ; trialmatx(j,:)];
                        case 2
                            t2ucx = [t2ucx ; trialmatx(j,:)];
                        case 3
                            t2ncx = [t2ncx ; trialmatx(j,:)];
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t2afx = [t2afx ; trialmatx(j,:)];
                        case 2
                            t2ufx = [t2ufx ; trialmatx(j,:)];
                        case 3
                            t2nfx = [t2nfx ; trialmatx(j,:)];
                    end
                end
            elseif trialsPresented(j,icue) == 3
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t3acx = [t3acx ; trialmatx(j,:)];
                        case 2
                            t3ucx = [t3ucx ; trialmatx(j,:)];
                        case 3
                            t3ncx = [t3ncx ; trialmatx(j,:)];
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t3afx = [t3afx ; trialmatx(j,:)];
                        case 2
                            t3ufx = [t3ufx ; trialmatx(j,:)];
                        case 3
                            t3nfx = [t3nfx ; trialmatx(j,:)];
                    end
                end
            end
        end
    end
end