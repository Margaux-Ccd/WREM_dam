%% pemu_scenario_1 : Minimal flow release repartition rule
%
% The water allocated to the environment is constantly equal to the minimal
% flow release prescribed by the law
%   Input:  - I: Inflow [m^3/s]
%           - st: station chosen for the simulation
%   Output: - Q1_tilde: Flow series for the hydropower plant [m^3/s]
%           - Q2_tilde: Flow series for the environment [m^3/s]
%           - B1: Economical benefits of the plant [Wh] 

function [Q1_tilde, Q2_tilde, B1] = pemu_scenario_Qmfr(I,st)


Q1=zeros(size(I));
Q2=zeros(size(I));
B1=zeros(size(I));

% Allocation of the water
for i=1:length(I)
    if ((I(i)>0) && (I(i)<=(st.Qmfr+st.Qmec)))
        Q1(i)=0;
        Q2(i)=I(i);
        B1(i)=NaN;
             
   elseif (I(i)>(st.Qmfr+st.Qmec)) && (I(i)<=(st.Qn+st.Qmfr))   
        Q1(i)=I(i)-st.Qmfr;
        Q2(i)=st.Qmfr;        
        B1(i)=(st.a*(Q1(i)^2)+st.b*Q1(i)+st.c)*24/1000000;
                 
    elseif I(i)>(st.Qn+st.Qmfr)
        Q1(i)=st.Qn;
        Q2(i)=I(i)-st.Qn;
        B1(i)=(st.a*(Q1(i)^2)+st.b*Q1(i)+st.c)*24/1000000;
  
    end
end  
        Q1_tilde=Q1;
        Q2_tilde=Q2;
end
    

