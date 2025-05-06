%% analyse
%
%   Input:  - station: 
%           - p_e: 
%           - p_h: 
%           - p_f: 
%           - year: 
%   Output: - ...
%           - ...

function [Ind_final_gain,B1_gain,Hydro1_selec,Hydro2_selec,Hydro3_selec,Eco1_selec,Eco2_selec,Eco3_selec,B1_sort_inverse,Ind_final_sort_inverse,B1_sort_standard,Ind_final_sort_standard,B1_selec,Ind_final_selec,B1_sc1_8,Ind_final_sc1_8,Hydro1_sc1_8,Hydro2_sc1_8,Hydro3_sc1_8,Eco1_sc1_8,Eco2_sc1_8,Eco3_sc1_8,front]=analyse(p_e,p_h,p_f,year,I,fermi,prop,max_under_treshold_young_nat,max_under_treshold_adult_nat)


size_I=length(I);

%Hydrological indicators
% Fermi scenarios
Hydro1_fermi=fermi.indicatori_medi_fermi(1,:);
Hydro2_fermi=fermi.indicatori_medi_fermi(2,:);                             
Hydro3_fermi=exp((p_h*log(Hydro1_fermi)+(1-p_h)*log(Hydro2_fermi)));  %geometric weighted mean    
%Proportional scenarios
Hydro1_prop=prop.indicatori_medi_prop(1,:);
Hydro2_prop=prop.indicatori_medi_prop(2,:);                             
Hydro3_prop=exp((p_h*log(Hydro1_prop)+(1-p_h)*log(Hydro2_prop)));  %geometric weighted mean   


%% Normalisation of the ecological indicators and computation of Eco1, Eco2 and Eco3
% Fermi scenarios
Eco1_fermi=1-((fermi.max_under_treshold_young_fermi-max_under_treshold_young_nat)./(fermi.max_under_treshold_young_fermi+max_under_treshold_young_nat));
Eco2_fermi=1-((fermi.max_under_treshold_adult_fermi-max_under_treshold_adult_nat)./(fermi.max_under_treshold_adult_fermi+max_under_treshold_adult_nat));
Eco3_fermi=exp((p_e*log(Eco1_fermi)+(1-p_e)*log(Eco2_fermi))); %geometric weighted mean 
%Proportional scenarios
Eco1_prop=1-((prop.max_under_treshold_young_prop-max_under_treshold_young_nat)./(prop.max_under_treshold_young_prop+max_under_treshold_young_nat));
Eco2_prop=1-((prop.max_under_treshold_adult_prop-max_under_treshold_adult_nat)./(prop.max_under_treshold_adult_prop+max_under_treshold_adult_nat));
Eco3_prop=exp((p_e*log(Eco1_prop)+(1-p_e)*log(Eco2_prop)));  %geometric weighted mean 


%% Computation of the Env Indicator and the Energy Production (to plot on the final graphic)
% Fermi scenarios
Env_fermi=exp((p_f*log(Hydro3_fermi)+(1-p_f)*log(Eco3_fermi))); %geometric weighted mean 
B1=fermi.indicatori_medi_fermi(3,:);
%Proportional scenarios
Env_prop=exp((p_f*log(Hydro3_prop)+(1-p_f)*log(Eco3_prop))); %geometric weighted mean 
B1=prop.indicatori_medi_prop(3,:);


%% Data treatment
i_fermi=Fermi_parameters(1,:);
j_fermi=Fermi_parameters(2,:);
a_fermi=Fermi_parameters(3,:);
b_fermi=Fermi_parameters(4,:);

[B1_sort I_sorted]=sort(B1,'ascend');
min_B1=min(B1_sort);
max_B1=max(B1_sort);

for k=1:length(B1)
    
    i=I_sorted(k);
    i_fermi_sort(k)=i_fermi(i);
    j_fermi_sort(k)=j_fermi(i);
    a_fermi_sort(k)=a_fermi(i);
    b_fermi_sort(k)=b_fermi(i);
    Ind_final_sort(k)=Env_fermi(i);
    
end

m=1;
inv=1;
eg=1;

%division into standard fermi function, inverse fermi function and
%proportional case 
for n=1:length(B1)
    if i_fermi_sort(n)>j_fermi_sort(n)
        B1_sort_inverse(inv)=B1_sort(n);
        Ind_final_sort_inverse(inv)=Ind_final_sort(n);
        inv=inv+1;
    elseif i_fermi_sort(n)==j_fermi_sort(n)
        B1_sort_eg(eg)=B1_sort(n);
        Ind_final_sort_eg(eg)=Ind_final_sort(n);
        eg=eg+1;        
    else
        B1_sort_standard(m)=B1_sort(n);
        Ind_final_sort_standard(m)=Ind_final_sort(n);
        istd(m)=i_fermi_sort(n);
        jstd(m)=j_fermi_sort(n);
        astd(m)=a_fermi_sort(n);
        bstd(m)=b_fermi_sort(n);
        m=m+1;
    end
    
end

%% Pareto frontier selection
mex paretofront.c;
front=paretofront([-B1_sort' -Ind_final_sort']);
% front_inverse=paretofront([-B1_sort_inverse' -Ind_final_sort_inverse']);
% front_standard=paretofront([-B1_sort_standard' -Ind_final_sort_standard']);

B1_selec=B1_sort(front);
Ind_final_selec=Ind_final_sort(front);
i_unsorted=I_sorted(front);

i_fermi_selec=i_fermi(i_unsorted);
j_fermi_selec=j_fermi(i_unsorted);
a_fermi_selec=a_fermi(i_unsorted);
b_fermi_selec=b_fermi(i_unsorted);

fermi_parameters_selec=[i_fermi_selec; j_fermi_selec; a_fermi_selec; b_fermi_selec];

Hydro1_selec=Hydro1_fermi(i_unsorted);
Hydro2_selec=Hydro2_fermi(i_unsorted);
Hydro3_selec=Hydro3_fermi(i_unsorted);

if station==1 || station==2
Eco1_selec=Eco1_fermi(i_unsorted);
Eco2_selec=Eco2_fermi(i_unsorted);
Eco3_selec=Eco3_fermi(i_unsorted);
else
Eco1_selec=NaN;
Eco2_selec=NaN;
Eco3_selec=NaN;
end

for i=1:81

   B1_diff=abs(B1_selec-B1_sc1_8(i+2));
   Ind_final_diff=abs(Ind_final_selec-Ind_final_sc1_8(i+2));   
           
   [min_B1_diff,indice_min_B1_diff(i)]=min(B1_diff);
   [min_Ind_final_diff,indice_min_Ind_final_diff(i)]=min(Ind_final_diff);   
   
   if Ind_final_sc1_8(i+2)>0
   Ind_final_gain(i)=((Ind_final_selec(indice_min_B1_diff(i))-Ind_final_sc1_8(i+2))/(Ind_final_sc1_8(i+2)))*100;
   else
   Ind_final_gain(i)=NaN;
   end
   
   if B1_sc1_8(i+2)>0
   B1_gain(i)=((B1_selec(indice_min_Ind_final_diff(i))-B1_sc1_8(i+2))/(B1_sc1_8(i+2)))*100;
   else
   B1_gain(i)=NaN;
   end
   
   
end

mean_Ind_gain=nanmean(Ind_final_gain);
mean_B1_gain=nanmean(B1_gain);

Fermi_param_ind_gain=[i_fermi_selec(indice_min_B1_diff);j_fermi_selec(indice_min_B1_diff);a_fermi_selec(indice_min_B1_diff);b_fermi_selec(indice_min_B1_diff)];
Fermi_param_B1_gain=[i_fermi_selec(indice_min_Ind_final_diff);j_fermi_selec(indice_min_Ind_final_diff);a_fermi_selec(indice_min_Ind_final_diff);b_fermi_selec(indice_min_Ind_final_diff)];


end
