% Output arguments:
%      tab_performances: matrix containing tab Richter 1997 + 2 columns
%                  1st column: inter-annual means for the pre-impact serie.
%                  2nd column: inter-annual CVs for the pre-impact serie.
%                  3rd column: lowest value for the pre-impact serie.
%                  4th column: highest value for the pre-impact serie.
%                  5th column: inter-annual means for the post-impact serie.
%                  6th column: inter-annual CVs for the post-impact serie.
%                  7th column: lowest value for the post-impact serie.
%                  8th column: highest value for the post-impact serie.
%                  9th column: rate of non-attainement (low treshold).
%                 10th column: rate of non-attainement (high treshold).
%                 11th column: rate of non-attainement (fraction, pre-impact).
%                 12th column: rate of non-attainement (fraction, post-impact).
%                 13th column: differences between pre and post-impact means
%                 14th column: differences between pre and post-impact SDs
%                 15th column: differences between pre and post-impact CVs
%       IHA_ind_sim: -number of rows = 34 (number of indicators);
%                    -number of columns = number of years of the serie.
%                    -see IHA_indicators for more information


function [tab_performances, IHA_ind_sim, IHA_stat]=IHA_performances(signal_nat, signal,init_date_sim)

perc.q25th=prctile(signal_nat,25);
perc.q75th=prctile(signal_nat,75);

perc_sim.q25th=prctile(signal,25);%%%
perc_sim.q75th=prctile(signal,75);%%%

init_year=init_date_sim(3);

[IHA_ind_nat]= IHA_indicators( signal_nat, perc, init_date_sim, init_year );
save -ascii IHA_ind_nat.txt IHA_ind_nat
load IHA_ind_nat.txt
[IHA_ind_sim]= IHA_indicators( signal, perc_sim, init_date_sim, init_year );%%%

IHA_stat=stat(IHA_ind_nat,IHA_ind_sim);

tab_richter=[IHA_stat(:,1) IHA_stat(:,5) IHA_stat(:,9) IHA_stat(:,10) IHA_stat(:,2) IHA_stat(:,6) IHA_stat(:,11) IHA_stat(:,12) IHA_stat(:,13) IHA_stat(:,14) IHA_stat(:,15) IHA_stat(:,16)];
tab_performances=[tab_richter IHA_stat(:,7) IHA_stat(:,3) (IHA_stat(:,18)-IHA_stat(:,17))]; % The difference the values of CV are added at the end of the Richter table

% The indicators corresponding to Group 3 are removed
tab_performances=[tab_performances(1:22,:);tab_performances(27:end,:)];
end