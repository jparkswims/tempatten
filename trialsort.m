if strcmp(study,'E0') || strcmp(study,'E3') || strcmp(study,'E0E3')
    if strcmp(type,'cue')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        x = 1; y = 1; z = 1;
        t1x = []; t2x = []; nx = [];
        t1dec = []; t2dec = []; ndec = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1x(x,:) = trialmatx(j,:);
                    t1dec(x) = trialsPresented(j,irt);
                    x = x+1;
                case 2
                    t2x(y,:) = trialmatx(j,:);
                    t2dec(y) = trialsPresented(j,irt);
                    y = y+1;
                case 0
                    nx(z,:) = trialmatx(j,:);
                    ndec(z) = trialsPresented(j,irt);
                    z = z+1;
            end
            
        end
        
    elseif strcmp(type,'ta')
        
        icue = find(strcmp(expt.trials_headers,'cuedInterval'));
        
        x1 = 1; x2 = 1; x3 = 1;
        
        t1ax = []; t1ux = []; t1nx = [];
        t2ax = []; t2ux = []; t2nx = [];
        t1adec = []; t1udec = []; t1ndec = [];
        t2adec = []; t2udec = []; t2ndec = [];
        
        for j = 1:size(trialmatx,1)
            
            switch trialsPresented(j,icue)
                case 1
                    t1ax(x1,:) = trialmatx(j,:);
                    t1adec(x1) = trialsPresented(j,irt);
                    t2ux(x1,:) = trialmatx(j,:);
                    t2udec(x1) = trialsPresented(j,irt);
                    x1 = x1+1;
                case 2
                    t1ux(x2,:) = trialmatx(j,:);
                    t1udec(x2) = trialsPresented(j,irt);
                    t2ax(x2,:) = trialmatx(j,:);
                    t2adec(x2) = trialsPresented(j,irt);
                    x2 = x2+1;
                case 0
                    t1nx(x3,:) = trialmatx(j,:);
                    t1ndec(x3) = trialsPresented(j,irt);
                    t2nx(x3,:) = trialmatx(j,:);
                    t2ndec(x3) = trialsPresented(j,irt);
                    x3 = x3+1;
            end
            
        end
        
    elseif strcmp(type,'tvc')
        
        ival = find(strcmp(expt.trials_headers,'cueValidity'));
        icor = find(strcmp(expt.trials_headers,'correct'));
        icue = find(strcmp(expt.trials_headers,'respInterval'));
        
        x1 = 1; x2 = 1; x3 = 1; x4 = 1; x5 = 1; x6 = 1;
        y1 = 1; y2 = 1; y3 = 1; y4 = 1; y5 = 1; y6 = 1;
        
        t1vcx = []; t1icx = []; t1ncx = []; t1vfx = []; t1ifx = []; t1nfx = [];
        t2vcx = []; t2icx = []; t2ncx = []; t2vfx = []; t2ifx = []; t2nfx = [];
        t1vcdec = []; t1icdec = []; t1ncdec = []; t1vfdec = []; t1ifdec = []; t1nfdec = [];
        t2vcdec = []; t2icdec = []; t2ncdec = []; t2vfdec = []; t2ifdec = []; t2nfdec = [];
        
        for j = 1:size(trialmatx,1)
            if trialsPresented(j,icue) == 1
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t1vcx(x1,:) = trialmatx(j,:);
                            t1vcdec(x1) = trialsPresented(j,irt);
                            x1 = x1+1;
                        case 2
                            t1icx(x2,:) = trialmatx(j,:);
                            t1icdec(x2) = trialsPresented(j,irt);
                            x2 = x2+1;
                        case 3
                            t1ncx(x3,:) = trialmatx(j,:);
                            t1ncdec(x3) = trialsPresented(j,irt);
                            x3 = x3+1;
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t1vfx(x4,:) = trialmatx(j,:);
                            t1vfdec(x4) = trialsPresented(j,irt);
                            x4 = x4+1;
                        case 2
                            t1ifx(x5,:) = trialmatx(j,:);
                            t1ifdec(x5) = trialsPresented(j,irt);
                            x5 = x5+1;
                        case 3
                            t1nfx(x6,:) = trialmatx(j,:);
                            t1nfdec(x6) = trialsPresented(j,irt);
                            x6 = x6+1;
                    end
                end
            elseif trialsPresented(j,icue) == 2
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t2vcx(y1,:) = trialmatx(j,:);
                            t2vcdec(y1) = trialsPresented(j,irt);
                            y1 = y1+1;
                        case 2
                            t2icx(y2,:) = trialmatx(j,:);
                            t2icdec(y2) = trialsPresented(j,irt);
                            y2 = y2+1;
                        case 3
                            t2ncx(y3,:) = trialmatx(j,:);
                            t2ncdec(y3) = trialsPresented(j,irt);
                            y3 = y3+1;
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t2vfx(y4,:) = trialmatx(j,:);
                            t2vfdec(y4) = trialsPresented(j,irt);
                            y4 = y4+1;
                        case 2
                            t2ifx(y5,:) = trialmatx(j,:);
                            t2ifdec(y5) = trialsPresented(j,irt);
                            y5 = y5+1;
                        case 3
                            t2nfx(y6,:) = trialmatx(j,:);
                            t2nfdec(y6) = trialsPresented(j,irt);
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
        
        t1vcx = []; t1icx = []; t1ncx = []; t1vfx = []; t1ifx = []; t1nfx = [];
        t2vcx = []; t2icx = []; t2ncx = []; t2vfx = []; t2ifx = []; t2nfx = [];
        t3vcx = []; t3icx = []; t3ncx = []; t3vfx = []; t3ifx = []; t3nfx = [];
        
        for j = 1:size(trialmatx,1)
            if trialsPresented(j,icue) == 1
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t1vcx = [t1vcx ; trialmatx(j,:)];
                        case 2
                            t1icx = [t1icx ; trialmatx(j,:)];
                        case 3
                            t1ncx = [t1ncx ; trialmatx(j,:)];
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t1vfx = [t1vfx ; trialmatx(j,:)];
                        case 2
                            t1ifx = [t1ifx ; trialmatx(j,:)];
                        case 3
                            t1nfx = [t1nfx ; trialmatx(j,:)];
                    end
                end
            elseif trialsPresented(j,icue) == 2
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t2vcx = [t2vcx ; trialmatx(j,:)];
                        case 2
                            t2icx = [t2icx ; trialmatx(j,:)];
                        case 3
                            t2ncx = [t2ncx ; trialmatx(j,:)];
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t2vfx = [t2vfx ; trialmatx(j,:)];
                        case 2
                            t2ifx = [t2ifx ; trialmatx(j,:)];
                        case 3
                            t2nfx = [t2nfx ; trialmatx(j,:)];
                    end
                end
            elseif trialsPresented(j,icue) == 3
                if trialsPresented(j,icor) == 1
                    switch trialsPresented(j,ival)
                        case 1
                            t3vcx = [t3vcx ; trialmatx(j,:)];
                        case 2
                            t3icx = [t3icx ; trialmatx(j,:)];
                        case 3
                            t3ncx = [t3ncx ; trialmatx(j,:)];
                    end
                elseif trialsPresented(j,icor) == 0
                    switch trialsPresented(j,ival)
                        case 1
                            t3vfx = [t3vfx ; trialmatx(j,:)];
                        case 2
                            t3ifx = [t3ifx ; trialmatx(j,:)];
                        case 3
                            t3nfx = [t3nfx ; trialmatx(j,:)];
                    end
                end
            end
        end
    end
end