function [Indicator_ECO] = indic_fish_young(signal,threshold_young_fish,data,size_I)

%%
% % Computation of the ecological indicators for the young trouts based on 
% % the report made by EcoControl SA 
%     %   Input:  - signal: flow series for each scenario
%     %           - station: location of the hydropower plant
%     %           - size_I: length of the flow series
%     %   Output: - max_under_treshold_adult: maximal number of consecutive
%     %             days under the fixed threshold is computed for the entire
%     %             flow series
%  
%     % The thresholds are determined from the curves obtained for each
%     % station. They correspond to the flow rate for which a break in the
%     % slope is observed.
%     
%     
%     % For the entire time series, find the day for which the flow rate is under the threshold
%     [l c] = size(signal);
%     day_below=zeros(l,c);
% 
%     indice=find(signal(:,:)<threshold_young_fish); 
%     day_below(indice)=1;
%     
%     % Count the number of consecutive days for which the flow rate fall under the threshold
%     day_compt = day_below;
%     
%     for j=1:c
%         k=0;
%         for i=1:l
%             if day_compt(i,j)==1
%                 k = k + 1;
%                 day_compt(i,j)=k;
%             elseif day_compt(i,j)==0
%                 k=0;
%                 day_compt(i,j)=k;
%             end
%         end
%     end
%     
%     day_cumul = zeros(l,c);
%     day_cmp_cop = day_compt(2:end,:);
%     
%     for j=1:c
%         for i=1:l-1
%             if day_compt(i,j)~=0 & day_cmp_cop(i,j)==0
%                 day_cumul(i,j)= day_compt(i,j);
%             else
%                 continue
%             end
%         end
%         for i=l
%             day_cumul(i,j)= day_compt(i,j);
%         end
%     end
%     
%     % Computation of the cumulated frequency under threshold for one year 
%      max_day_cumul = max(max(day_cumul));
%      day_cum_freq = zeros(max_day_cumul,c);   % Occurence table                                 
%      nbr_day_cumul = zeros(max_day_cumul,c);  % Number of consecutive days under threshold                                    
% 
%      for j=1:c                                                                  
%          for i=1:max_day_cumul                                                  
%              if isempty(find(day_cumul(:,j)==i))==0
%                 day_cum_freq(i,j) = (length(find(day_cumul(:,j)==i)))/l;      
%                 nbr_day_cumul(i,j) = length(find(day_cumul(:,j)==i));          
%              elseif isempty(find(day_cumul(:,j)==i))==1
%                  continue
%              end
%          end
%      end
%          
%     % Y_trout_d_below =  day_below;
%     % Y_trout_d_cumul = day_cumul;
%     % Y_trout_d_cum_freq = [day_cum_freq; nan(10592-length(day_cum_freq),1)];
%      
%     % Computation of the ecological indicator being the maximal serie of days under threshold
%      Young_nbr_d_cumul = [nbr_day_cumul; nan(size_I-length(day_cum_freq),1)];        
%      continuous_durations_young=flipud(find(Young_nbr_d_cumul(:,1)~=0 & isnan(Young_nbr_d_cumul(:,1))~=1));
%      max_under_treshold_young=continuous_durations_young(1);    
       
%% Improvement: The more the flow rate is far from (and inferior to) the threshold
%  the greater the penalisation is 

% f_Ql=-419.93*(threshold_young_fish).^2+1425.5*(threshold_young_fish)+22.067;
f_Ql=data.a1*(threshold_young_fish).^2+data.b1*(threshold_young_fish)+data.c1;
f_Q2=repmat(f_Ql,length(signal),1);
% f_Q2(signal<threshold_young_fish)=-419.93*(signal(signal<threshold_young_fish)).^2+1425.5*(signal(signal<threshold_young_fish))+22.067;
f_Q2(signal<threshold_young_fish)=data.a1*(signal(signal<threshold_young_fish)).^2+data.b1*(signal(signal<threshold_young_fish))+data.c1;

dif=(abs(f_Q2-f_Ql)).^2;

count=0;
ECO_sum(1)=0;
k=0;
count=0;

for i=1:length(dif)  
    if dif(i)==0
        k=0;
    elseif k==0 && dif(i)~=0
        count=count+1;
        ECO_sum(count)=dif(i);
        k=1;
    elseif k==1
        ECO_sum(count)=ECO_sum(count)+dif(i);
    end
end

Indicator_ECO=max(ECO_sum);




     
end