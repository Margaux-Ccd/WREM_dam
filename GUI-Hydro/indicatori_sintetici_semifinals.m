% Computation of the two intermediate indicators (RnA & CV) for each Group (1,2,4,5)

% For each group, the sub-indicators are weighted and then aggregated
%   - Group 1 : all the sub-indicators have the same weigth
%   - Group 2 : all the sub-indicators have the same weigth
%   - Group 4 : all the sub-indicators have the same weigth
%   - Group 5 : the means of pos/negative differences are weighted 2 times
%               the number of rises/falls are weighted 1 time

% Group 3 has been removed: in the case of a flow diversion, the values of
% the natural and simulated sub-indicators are the same (SIM-NAT=0)

function [indicators_RNA_semifinals, indicators_dif_fraz_CVs_semifinals, indicators_sum_fraz_CVs_semifinals] = indicatori_sintetici_semifinals(indicators_RNA, dif_fraz_CVs, sum_fraz_CVs)

for i=1:size(indicators_RNA,2)

indicators_RNA_GR1_mean(1,i)=nanmean(indicators_RNA(1:12,i));
indicators_RNA_GR2_mean(1,i)=nanmean(indicators_RNA(13:22,i));
indicators_RNA_GR4_mean(1,i)=nanmean(indicators_RNA(23:26,i));
indicators_RNA_GR5_mean(1,i)=nanmean([indicators_RNA(27:28,i);indicators_RNA(27:28,i);indicators_RNA(29:30,i)]); 

end

for i=1:size(dif_fraz_CVs,2)

dif_fraz_CVs_GR1_mean(1,i)=nanmean(dif_fraz_CVs(1:12,i));
dif_fraz_CVs_GR2_mean(1,i)=nanmean(dif_fraz_CVs(13:22,i));
dif_fraz_CVs_GR4_mean(1,i)=nanmean(dif_fraz_CVs(23:26,i));
dif_fraz_CVs_GR5_mean(1,i)=nanmean([dif_fraz_CVs(27:28,i);dif_fraz_CVs(27:28,i);dif_fraz_CVs(29:30,i)]);

end

for i=1:size(sum_fraz_CVs,2)

sum_fraz_CVs_GR1_mean(1,i)=nanmean(sum_fraz_CVs(1:12,i));
sum_fraz_CVs_GR2_mean(1,i)=nanmean(sum_fraz_CVs(13:22,i));
sum_fraz_CVs_GR4_mean(1,i)=nanmean(sum_fraz_CVs(23:26,i));
sum_fraz_CVs_GR5_mean(1,i)=nanmean([sum_fraz_CVs(27:28,i);sum_fraz_CVs(27:28,i);sum_fraz_CVs(29:30,i)]);

end

% The sub-means obtained for each group are stored into 2 matrix (one per indicator)
indicators_RNA_semifinals=[indicators_RNA_GR1_mean; indicators_RNA_GR2_mean; indicators_RNA_GR4_mean; indicators_RNA_GR5_mean;];
indicators_dif_fraz_CVs_semifinals=[dif_fraz_CVs_GR1_mean; dif_fraz_CVs_GR2_mean; dif_fraz_CVs_GR4_mean; dif_fraz_CVs_GR5_mean];
indicators_sum_fraz_CVs_semifinals=[sum_fraz_CVs_GR1_mean; sum_fraz_CVs_GR2_mean; sum_fraz_CVs_GR4_mean; sum_fraz_CVs_GR5_mean];

end