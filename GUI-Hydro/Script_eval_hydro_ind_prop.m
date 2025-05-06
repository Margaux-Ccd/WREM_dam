%% Script_eval_hydro_ind : Evaluate the hydrological indicators
%
% Return the matrix indicatori_medi_prop:
%   - 1st line: Rate of non attainment (RnA) -Hydro1-
%   - 2nd line: Coefficient of Variation (CV) -Hydro2-
%   - 3rd line: Economical benefits (B1) Energy product in a year on
%   average

rate_nn_attainments=[tab_performances(:,11) tab_performances(:,12)];

% Difference between the simulated and the natural values SIM-NAT
dif_indicators_RNA=(rate_nn_attainments(:,2)-rate_nn_attainments(:,1));
dif_fraz_CVs=tab_performances(:,15);
sum_fraz_CVs=IHA_stat(:,18)+IHA_stat(:,17);

% Computation of the distance between the simulated and the natural values [SIM-NAT]²
indicators_RNA=zeros(30,1);
indicators_fraz_CVs=zeros(30,1);

for m=1:size(dif_indicators_RNA,2)
indicators_RNA(:,m)=dif_indicators_RNA(:,m).^2;
indicators_fraz_CVs(:,m)=dif_fraz_CVs(:,m).^2;
indicators_fraz_CVs_denominator(:,m)=(sum_fraz_CVs(:,m)).^2;
end

% Computation of the intermediate indicators
[indicators_RNA_semifinals, indicators_dif_fraz_CVs_semifinals,indicators_sum_fraz_CVs_semifinals] = indicatori_sintetici_semifinals(indicators_RNA, indicators_fraz_CVs, indicators_fraz_CVs_denominator);
indicatori_medi_prop(1:2,hh)=[1-mean(indicators_RNA_semifinals);1-(mean(indicators_dif_fraz_CVs_semifinals)/mean(indicators_sum_fraz_CVs_semifinals))];
mem_B1(hh)=nanmean(mem_B1).*(giorni_funzionamento-st.days_stop_machines);
indicatori_medi_prop(1:3,hh)=[indicatori_medi_prop(1:2,hh);mem_B1(hh)];

