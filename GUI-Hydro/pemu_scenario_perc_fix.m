%% pemu_scenario_perc_fix : Proportional repartition rule
%
% The water allocated to the environment is a fixed percentage of the inflow
%   Input:  - I: Inflow [m^3/s]
%           - fraz_expl: fraction of water left to the hydropower plant
%           - fraz_amb: fraction of water left to the river
%           - station: station chosen for the simulation
%   Output: - Q1_tilde: Flow series for the hydropower plant [m^3/s]
%           - Q2_tilde: Flow series for the environment [m^3/s]
%           - B1: Economical benefits of the plant [Wh] 

function [Q1_tilde, Q2_tilde, B1] = pemu_scenario_perc_fix(I,fraz_expl,fraz_amb,st)

Q1=zeros(size(I));
Q2=zeros(size(I));
B1=zeros(size(I));

% Allocation of the water
for i=1:length(I)
    if (I(i)<0)
        disp( 'Error: I(i)<0' );
        return;
    end
    
    if I(i)<=st.Qmfr+st.Qmec
        Q1(i)=0;
        Q2(i)=I(i);
        
        % When the value of the inflow is lower than Qmfr+Qmec, all the water
        % is allocated to the river
        
    elseif (I(i)>(st.Qmfr+st.Qmec))
        Q1(i)=st.Qmec+(I(i)-(st.Qmfr+st.Qmec))*fraz_expl;
        Q2(i)=st.Qmfr+(I(i)-(st.Qmfr+st.Qmec))*fraz_amb;
        % During the competition, the water allocated to the river corresponds
        % to a fixed percentage of the inflow
        
    end
end

% Beyond the nominal flow rate, the all the additional water is
% left to the river
for i=1:length(I)
    if Q1(i)>st.Qn
        Q1(i)=st.Qn;
        Q2(i)=I(i)-st.Qn;
    end
end

% The economical benefits are calculated depending the flow rates left to
% the turbine and the technical features of the plant
for i=1:length(I)
    if I(i)<=(st.Qmfr+st.Qmec)
        B1(i)=NaN;
    else
        B1(i)=(st.a*(Q1(i)^2)+st.b*Q1(i)+st.c)*24/1000000;
    end
end
Q1_tilde=Q1;
Q2_tilde=Q2;
end


