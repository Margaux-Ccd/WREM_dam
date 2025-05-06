function res=simulation(data)
%% Simulo_calculation_Q2 : Main script
%
% Computation of the flow rate released into river (Q2) for the
% non-proportional repartition
%
% In this optimisation process, many
% different ways to distribute the water are explored. With 5 differents
% parameters, it is possible to change Fermi functions in order to
% accordingly change the distribution percentages for water allocation.
% Two of the parameters are used to vary the
% water percentage left to the river at the beginning of the competition
% (for low flows) and at the end of it (for high flows).
%
% -------Fermi parameters-------
% a: modifies the curvature
% b: modifies the x-position of the inflexion point
% c: modifies the general shape of the curve (equal to 1 in our case)
% i: water fraction at the beginning of the competition
% j: water fraction at the end of the competition


%% waitbar
tic
bar = waitbar(0,'Please wait...');

%% Parameter necessary to the model

% River data
I=data.I; %Daily river flow (at least 20 years)
init_date_sim=[01 01 data.year1]; %1' day of the river flow series

%Power plant data
st.days_stop_machines=data.days_stop_machines;   %Number of days per year during which the machine can not produce due to maintenance.
st.Qn=data.Qn;   % Nominal flow rate [m3/s]
st.Qmec=data.Qmec;    % Lower boundary of the working range of the turbine [m3/s]
st.a=data.a;  %coefficient of the benefit function of the power plant B1(Q)= a*Q^2 + b*Q + c
st.b=data.b;
st.c=data.c;

%Ecosystem data
threshold_adult_fish= data.threshold_adult_fish;
threshold_young_fish= data.threshold_young_fish;

%Water allocation policies data
st.Qmfr=data.Qmfr; % Minimum flow requirement [m3/s]

if data.policies(2)>0 % Minimum flow requirement with seasonanility
    st.Qmfr2=data.Qmfr2; % Second threshold for the minimum flow requirement [m3/s]
    st.jdateQmfr2start=data.jdateQmfr2start; % starting day of the summer period
    st.jdateQmfrstart=data.jdateQmfrstart; % starting day of the winter period
end

if data.policies(3)>0 % Proportional policies
    prop =data.prop;
end

if data.policies(4)>0 % Non proportional policies
    fermi_i =  data.fermi_i;
    fermi_j =  data.fermi_j;
    fermi_a =  data.fermi_a;
    fermi_b =  data.fermi_b;
    fermi_c=1;
end

%% Variables setup

anni_sim=round(length(I)/365); %Number of years comprised in the simulation
size_I=length(I);

Qmin = st.Qmec+ st.Qmfr;

%% Fermi non proportional distributions

if data.policies(4)>0
    
    % Definition of variables (to decrease the computational time)
    indicatori_medi_fermi=[];
    max_under_treshold_young_fermi=[];
    max_under_treshold_adult_fermi=[];
    Fermi_parameters=[];
    indicatori_medi_fermi_int=[];
    max_under_treshold_young_fermi_int=[];
    max_under_treshold_adult_fermi_int=[];
    Fermi_parameters_int=[];
    %  n_scenario_fermi=length(fermi_i)*length(fermi_j)*length(fermi_a)*length(fermi_b); % total number of scenarios (actually are less)
    
    k=1;
    for i=1:length(fermi_i) % Variation of the fraction at the beginning of the competition
        
        %this to avoid to work on too big matrix and therefore to save computational time
        indicatori_medi_fermi=[indicatori_medi_fermi,indicatori_medi_fermi_int];
        max_under_treshold_young_fermi=[max_under_treshold_young_fermi,max_under_treshold_young_fermi_int];
        max_under_treshold_adult_fermi=[max_under_treshold_adult_fermi,max_under_treshold_adult_fermi_int];
        Fermi_parameters=[Fermi_parameters,Fermi_parameters_int];
        
        indicatori_medi_fermi_int=[];
        max_under_treshold_young_fermi_int=[];
        max_under_treshold_adult_fermi_int=[];
        Fermi_parameters_int=[];
        
        
        for j=1:length(fermi_j)  % Variation of the fraction at the end of the competition
            
            if fermi_i(i)~=fermi_j(j)% If the fractions are different, a non proportional distribution is performed (I consider just the non prop ones so when i is different from j)
                Qmax=(st.Qn-st.Qmec)/(1-fermi_j(j))+st.Qmec+st.Qmfr;
                
                
                for a=1:length(fermi_a)
                    for b=1:length(fermi_b)
                        
                        curr_fermi=[fermi_i(i) fermi_j(j) fermi_a(a) fermi_b(b)] % Printing of the position to see how the code is avancing
                        
                        [Q1_tilde, Q2_tilde, test_out] = pemu_scenario_fermi(I, fermi_i(i), fermi_j(j), fermi_a(a), fermi_b(b), fermi_c, st); %Repartition of water according to scenario 7
                        [tab_performances, IHA_ind, IHA_stat]=IHA_performances(I, Q2_tilde,init_date_sim);
                        
                        [B1]=calcul_benefits(Q2_tilde, Q1_tilde,st,size_I);
                        Script_mem;             % Storage of several usefull values
                        Script_eval_hydro_ind;  % For each scenario, the RnA, the CV and B1 are stored
                        Fermi_parameters(:,k)=[fermi_i(i);fermi_j(j);fermi_a(a);fermi_b(b)]; % The Fermi parameters are stored
                        
                        % Computation of the ecological indicators
                        [max_under_treshold_young_fermi(k)]= indic_fish_young(Q2_tilde,threshold_young_fish,data,size_I);
                        [max_under_treshold_adult_fermi(k)]= indic_fish_adult(Q2_tilde,threshold_adult_fish,data,size_I);
                        
                        k=k+1;
                        
                    end
                end
                
                
            end
        end
        
        waitbar((i-1)/length(fermi_i))
    end
end

%% Proportional distributions

if data.policies(3)>0
    
    n_scenario_prop=length(prop);
    
    indicatori_medi_prop=zeros(3,n_scenario_prop);
    max_under_treshold_young_prop=zeros(1,n_scenario_prop);
    max_under_treshold_adult_prop=zeros(1,n_scenario_prop);
    
    for hh=1:length(prop)
        curr_prop=prop(hh)
        [Q1_tilde, Q2_tilde, B1] = pemu_scenario_perc_fix(I,1-prop(hh),prop(hh),st);
        [tab_performances, IHA_ind, IHA_stat]=IHA_performances(I, Q2_tilde,init_date_sim);
        [max_under_treshold_young_prop(hh)]= indic_fish_young(Q2_tilde,threshold_young_fish,data,size_I);
        [max_under_treshold_adult_prop(hh)]= indic_fish_adult(Q2_tilde,threshold_adult_fish,data,size_I);
        Script_mem;             % Storage of several usefull values
        Script_eval_hydro_ind_prop;  % For each scenario, the RnA, the CV and B1 are stored
    end
end

%% Minimal flow release

if data.policies(1)>0
    [Q1_tilde, Q2_tilde, B1] = pemu_scenario_Qmfr(I,st);
    [tab_performances, IHA_ind, IHA_stat]=IHA_performances(I, Q2_tilde,init_date_sim);
    [max_under_treshold_young_Qmfr]= indic_fish_young(Q2_tilde,threshold_young_fish,data,size_I);
    [max_under_treshold_adult_Qmfr]= indic_fish_adult(Q2_tilde,threshold_adult_fish,data,size_I);
    Script_mem;             % Storage of several usefull values
    Script_eval_hydro_ind_Qmfr;
end

%% Minimal flow release with seasonality

if data.policies(2)>0
    [Q1_tilde, Q2_tilde, B1] = pemu_scenario_Qmfr2(I,st,init_date_sim);
    [tab_performances, IHA_ind, IHA_stat]=IHA_performances(I, Q2_tilde,init_date_sim);
    [max_under_treshold_young_Qmfr2]= indic_fish_young(Q2_tilde,threshold_young_fish,data,size_I);
    [max_under_treshold_adult_Qmfr2]= indic_fish_adult(Q2_tilde,threshold_adult_fish,data,size_I);
    Script_mem;             % Storage of several usefull values
    Script_eval_hydro_ind_Qmfr2;
end


%% Calculation of ecological index with the natural flow

[max_under_treshold_young_nat]= indic_fish_young(I,threshold_young_fish,data,size_I);
[max_under_treshold_adult_nat]= indic_fish_adult(I,threshold_adult_fish,data,size_I);

waitbar(1)

%% Analysis to obtain the Hydro and Eco indexes to finally compute the pareto frontier

p_h=0.5; %weight of Hydro1 (E1) with respect to Hydro2 (E2)
p_e=0.5; %weight of Eco1 (E3) with respect to Eco2 (E4)
p_f=0.5; %weight of Hydro3 with respect to Eco3

year=1;

% Hydrological indicators Hydro1, Hydro2, and Hydro3,
% Ecological indicators Eco1, Eco2 and Eco3 and
% Env Indicator and the Energy Production (to plot on the final graphic)

% Fermi scenarios
if data.policies(4)>0 && sum(size(indicatori_medi_fermi))>0
    Hydro1_fermi=indicatori_medi_fermi(1,:);
    Hydro2_fermi=indicatori_medi_fermi(2,:);
    Hydro3_fermi=exp((p_h*log(Hydro1_fermi)+(1-p_h)*log(Hydro2_fermi)));  %geometric weighted mean
    Eco1_fermi=1-((max_under_treshold_young_fermi-max_under_treshold_young_nat)./(max_under_treshold_young_fermi+max_under_treshold_young_nat));
    Eco2_fermi=1-((max_under_treshold_adult_fermi-max_under_treshold_adult_nat)./(max_under_treshold_adult_fermi+max_under_treshold_adult_nat));
    Eco3_fermi=exp((p_e*log(Eco1_fermi)+(1-p_e)*log(Eco2_fermi))); %geometric weighted mean
    Env_fermi=exp((p_f*log(Hydro3_fermi)+(1-p_f)*log(Eco3_fermi))); %geometric weighted mean
    B1_fermi=indicatori_medi_fermi(3,:);
end
%Proportional scenarios
if data.policies(3)>0
    Hydro1_prop=indicatori_medi_prop(1,:);
    Hydro2_prop=indicatori_medi_prop(2,:);
    Hydro3_prop=exp((p_h*log(Hydro1_prop)+(1-p_h)*log(Hydro2_prop)));  %geometric weighted mean
    Eco1_prop=1-((max_under_treshold_young_prop-max_under_treshold_young_nat)./(max_under_treshold_young_prop+max_under_treshold_young_nat));
    Eco2_prop=1-((max_under_treshold_adult_prop-max_under_treshold_adult_nat)./(max_under_treshold_adult_prop+max_under_treshold_adult_nat));
    Eco3_prop=exp((p_e*log(Eco1_prop)+(1-p_e)*log(Eco2_prop)));  %geometric weighted mean
    res.Env_prop=exp((p_f*log(Hydro3_prop)+(1-p_f)*log(Eco3_prop))); %geometric weighted mean
    res.B1_prop=indicatori_medi_prop(3,:);
end
%Minimal flow release scenario
if data.policies(1)>0
    Hydro1_Qmfr=indicatori_medi_Qmfr(1,:);
    Hydro2_Qmfr=indicatori_medi_Qmfr(2,:);
    Hydro3_Qmfr=exp((p_h*log(Hydro1_Qmfr)+(1-p_h)*log(Hydro2_Qmfr)));  %geometric weighted mean
    Eco1_Qmfr=1-((max_under_treshold_young_Qmfr-max_under_treshold_young_nat)./(max_under_treshold_young_Qmfr+max_under_treshold_young_nat));
    Eco2_Qmfr=1-((max_under_treshold_adult_Qmfr-max_under_treshold_adult_nat)./(max_under_treshold_adult_Qmfr+max_under_treshold_adult_nat));
    Eco3_Qmfr=exp((p_e*log(Eco1_Qmfr)+(1-p_e)*log(Eco2_Qmfr)));  %geometric weighted mean
    res.Env_Qmfr=exp((p_f*log(Hydro3_Qmfr)+(1-p_f)*log(Eco3_Qmfr))); %geometric weighted mean
    res.B1_Qmfr=indicatori_medi_Qmfr(3,:);
end
%Minimal flow release scenario with seasonality
if data.policies(2)>0
    Hydro1_Qmfr2=indicatori_medi_Qmfr2(1,:);
    Hydro2_Qmfr2=indicatori_medi_Qmfr2(2,:);
    Hydro3_Qmfr2=exp((p_h*log(Hydro1_Qmfr2)+(1-p_h)*log(Hydro2_Qmfr2)));  %geometric weighted mean
    Eco1_Qmfr2=1-((max_under_treshold_young_Qmfr2-max_under_treshold_young_nat)./(max_under_treshold_young_Qmfr2+max_under_treshold_young_nat));
    Eco2_Qmfr2=1-((max_under_treshold_adult_Qmfr2-max_under_treshold_adult_nat)./(max_under_treshold_adult_Qmfr2+max_under_treshold_adult_nat));
    Eco3_Qmfr2=exp((p_e*log(Eco1_Qmfr2)+(1-p_e)*log(Eco2_Qmfr2)));  %geometric weighted mean
    res.Env_Qmfr2=exp((p_f*log(Hydro3_Qmfr2)+(1-p_f)*log(Eco3_Qmfr2))); %geometric weighted mean
    res.B1_Qmfr2=indicatori_medi_Qmfr2(3,:);
end

%% Pareto frontier
if data.policies(4)==0 || sum(size(indicatori_medi_fermi))==0
    B1_fermi=[];
    Env_fermi=[];
    Fermi_parameters=[];
end
if data.policies(3)==0
    res.B1_prop=[];
    res.Env_prop=[];
end
if data.policies(1)==0
    res.B1_Qmfr=[];
    res.Env_Qmfr=[];
end
if data.policies(2)==0
    res.B1_Qmfr2=[];
    res.Env_Qmfr2=[];
end

res.xy=[[B1_fermi';res.B1_prop';res.B1_Qmfr';res.B1_Qmfr2'],[Env_fermi';res.Env_prop';res.Env_Qmfr';res.Env_Qmfr2']];

% In the first column is the energy producted, in the second the ecological
% indicators, in the third  a value=1 means that it is part of the
% Pareto frontier, in the last four column are the fermi parameter i j a b
% (or NaN if is not a fermi function)
B1_Env_pareto=[pareto_frontier(res.xy),nan(size(res.xy,1),4)];

if size(Fermi_parameters,2)>0
    B1_Env_pareto(1:size(Fermi_parameters,2),4:7)=Fermi_parameters';
end

%sorting for the energy produced (for plot the line)
[B1_sort, i_sort]=sort(B1_Env_pareto(:,1));

% This is equal to B1_Env_pareto but the line are sorted to have incresing
% enegy producted
res.B1_Env_pareto_sort=B1_Env_pareto(i_sort,:);

%% Inverse and standard Fermi function
if data.policies(4)>0 && sum(size(indicatori_medi_fermi))>0
    inv=1;
    stan=1;
    for ll=1:length(B1_fermi)
        if Fermi_parameters(1,ll)>Fermi_parameters(2,ll)
            res.B1_fermi_inverse(inv)=B1_fermi(ll);
            res.Env_fermi_inverse(inv)=Env_fermi(ll);
            inv=inv+1;
        elseif Fermi_parameters(1,ll)<Fermi_parameters(2,ll)
            res.B1_fermi_standard(stan)=B1_fermi(ll);
            res.Env_fermi_standard(stan)=Env_fermi(ll);
            stan=stan+1;
        end
        
    end
else
    res.B1_fermi_inverse=[];
    res.Env_fermi_inverse=[];
    res.B1_fermi_standard=[];
    res.Env_fermi_standard=[];
end


close(bar)
toc
end




