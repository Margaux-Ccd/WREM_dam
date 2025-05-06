function [xy_p] = pareto_frontier(xy)

[N, m] = size(xy);
clear m

M=2;    % number of objectives

xy_p=zeros(N,2);


xy_p(:,1)=-(xy(:,1));
xy_p(:,2)=-(xy(:,2));

xy=xy_p;

front = 1;


for i = 1 : N
    
    %     individual(i).n = 0;
    t=0;
        %
    %     individual(i).p = [];
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M
            if (xy(i, k) < xy(j, k))
                dom_less = dom_less + 1;
                
            elseif (xy(i, k) == xy(j, k))
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M
            %             individual(i).n = individual(i).n + 1;
            t=t+1;
            
            %         elseif dom_more == 0 && dom_equal ~= M
            %             individual(i).p = [individual(i).p j];
        end
        
        %         if individual(i).n ~= 0
        if t ~= 0
            break
        end
        
    end
    %     if individual(i).n == 0
    if t == 0
        xy_p(i,M + 1) = 1;
        %         F(front).f = [F(front).f i];
    end
end

xy_p(:,1) = -xy_p(:,1);
xy_p(:,2) = -xy_p(:,2);

end



