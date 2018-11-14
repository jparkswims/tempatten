function Xout = optimize_param_space(Xin,LB,UB)
% optimize_param_space
% Xout = optimize_param_space(Xin,LB,UB)

f = @(X)space_cost(X,LB,UB);

Xout = fmincon(f,Xin,[],[],[],[],LB,UB);

    function cost = space_cost(X,LB,UB)
        cost = 0;
        for ii = 1:size(X,1)-1
            for jj = ii:size(X,1)
                cost = cost - distance(X(ii,:),X(jj,:));
            end
        end
        for ii = 1:size(X,1)
            cost = cost - bound_distance(X(ii,:),LB,UB);
        end
    end

    function d = distance(x,y)
        d = sqrt(sum((y-x).^2));
    end

    function d = bound_distance(x,LB,UB)
        d = sum(x-LB) + sum(UB-x);
    end

end
