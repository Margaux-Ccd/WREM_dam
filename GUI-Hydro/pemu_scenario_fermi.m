%% pemu_scenario_fermi : Non-proportional repartition rule
%
% The water distribution is given by Fraz_inf at the beginning of the
% competition and changes to attain Fraz_sup at the end. The variation
% between these two values depends on the Fermi-parameters a,b and c.
%   Input:  - I: Inflow [m^3/s]
%           - Fraz_inf: fraction of water left to the river at the
%           beginning of the competition
%           - Fraz_sup: fraction of water left to the river at the
%           end of the competition
%           - a,b,c: Fermi parameters acting on the shape of the
%           repartition curve    
%   Output: - Q1_tilde: Flow series for the hydropower plant [m^3/s]
%           - Q2_tilde: Flow series for the environment [m^3/s]
%           - test: ok if the value is equal to 1

function [Q1_tilde, Q2_tilde, test] = pemu_scenario_fermi(I, Fraz_inf, Fraz_sup, a, b, c, st)

Q1=zeros(size(I));
Q2=zeros(size(I));

% Definition of system thresholds  
S2=(st.Qmfr+st.Qmec);
S3=(st.Qn-st.Qmec)/(1-Fraz_sup)+st.Qmec+st.Qmfr; 

z=0;
A=(exp(-a*b)+c)/(exp(a*(1-b))+c);
M=(z-A)/(1-A);
Y=(1-M)*(exp(-a*b)+c);

% Test to verify that the derivatives of Q1 and Q2 by I are always
% positive even when I is close to the end of the competition.
value_to_test=(1-z)/(1-A);
if value_to_test > 0
    test=1;
else
    test=0;
end

% Allocation of the water
for k=1:length(I)
        if ((I(k)>=0) && (I(k)<=S2))
            Q1(k)=0;
            Q2(k)=I(k);
        % When the value of the inflow is lower than the S2, all the water 
        % is allocated to the river
                        
        elseif ((I(k)>S2) && (I(k)<S3))            
            x=(I(k)-S2)/(S3-S2);
            Fra_amb=(1-(Y/(exp(a*(x-b))+c)+M))*(Fraz_sup-Fraz_inf)+Fraz_inf;
            Q1(k)=(1-Fra_amb)*(I(k)-st.Qmec-st.Qmfr)+st.Qmec;
            Q2(k)=I(k)-Q1(k);
        % During the competition, the water allocated to the river is
        % given by the Fermi function
                
             if Q1(k)>st.Qn
                Q1(k)=st.Qn;
                Q2(k)=I(k)-st.Qn;
             end
             % Beyond the nominal flow rate, the all the additional water is 
             % left to the river
             
        else           
            Q1(k)=st.Qn;
            Q2(k)=I(k)-st.Qn;     
        end
end
    
Q1_tilde=Q1;
Q2_tilde=Q2;

end
    

