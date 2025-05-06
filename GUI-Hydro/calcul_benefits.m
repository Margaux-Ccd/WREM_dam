%% calcul_benefits : Compute the daily economical benefits of the plant
%
%INPUT: -Q2: The flow in the river Q2 for each day 
%       -Q1: The flow in the power plant Q1 for each day
%   
%OUTPUT: -B1: The benefits of the powerplant

function [B1] = calcul_benefits(Q2,Q1,st,size_I)

B1=zeros(size_I,1);

% Computation of the benefits
    for i=1:length(Q2)
          if Q1(i)>0 
            B1(i)=(st.a*(Q1(i)^2)+st.b*Q1(i)+st.c)*24/1000000;
          else
            B1(i)=NaN;
          end 
    end
end

