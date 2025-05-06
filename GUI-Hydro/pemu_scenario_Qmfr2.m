%% pemu_scenario_2 : Minimal flow release with seasonality 
%
% The water allocated to the environment is constantly equal to the minimal
% flow release (Qmfr1) during the winter period and a enhanced value
% (Qmfr2) during the summer period
%   Input:  - I: Inflow [m^3/s]
%           - code: The year must start the first of January. 
% If the firs year of the imput I is the first year after a leap year then the variable "code" must be set to "1";
% If the firs year of the imput I is the second year after a leap year then the variable "code" must be set to "1+365=366";
% If the firs year of the imput I is the third year after a leap year then the variable "code" must be set to "1+365+365=731";
% If the firs year of the imput I is a leap year then the variable "code" must be set to "1+365+365+365=1096";
%           - station: station chosen for the simulation
%   Output: - Q1_tilde: Flow series for the hydropower plant [m^3/s]
%           - Q2_tilde: Flow series for the environment [m^3/s]
%           - B1: Economical benefits of the plant [Wh] 

function [Q1_tilde, Q2_tilde, B1] = pemu_scenario_Qmfr2(I,st,init_date_sim)

Qmfr1=st.Qmfr;  % Minimal flow rate allocated to the river during the winter 
Qmfr2=st.Qmfr2; % Minimal flow rate allocated to the river during the summer

Q1=zeros(size(I));
Q2=zeros(size(I));
B1=zeros(size(I));

if ismember(init_date_sim(3),[1904:4:2100])==1
    code=1096;
elseif ismember(init_date_sim(3),[1905:4:2101])==1
    code=1;
elseif ismember(init_date_sim(3),[1906:4:2102])==1
    code=366;   
elseif ismember(init_date_sim(3),[1907:4:2103])==1
    code=731;  
end
    
% Allocation of the water
for i=1:length(I)     
    if code>(365+365+365+365+1)
        code=1;
    end
    
    if ((code>=1)&&(code<=(st.jdateQmfr2start)))||((code>(st.jdateQmfrstart))&&(code<=365)) || ...
            ((code>=(1+365))&&(code<=(st.jdateQmfr2start+365)))||((code>(st.jdateQmfrstart+365))&&(code<=(365+365))) || ...
            ((code>=(1+365+365))&&(code<=(st.jdateQmfr2start+365+365)))||((code>(st.jdateQmfrstart+365+365))&&(code<=(365+365+365))) || ...
            ((code>=(1+365+365+365))&&(code<=(st.jdateQmfr2start+365+365+365+1)))||((code>(st.jdateQmfrstart+365+365+365+1))&&(code<=(365+365+365+365+1)))
        
        Qmfr=Qmfr1;
        code=code+1;   
    else
        Qmfr=Qmfr2;
        code=code+1;
    end
    
    if ((I(i)>0) &&  (I(i)<=(Qmfr+st.Qmec)))
        Q1(i)=0;
        Q2(i)=I(i);
        B1(i)=NaN;
        
    elseif (I(i)>(Qmfr+st.Qmec)) && (I(i)<=(st.Qn+Qmfr))   
        Q1(i)=I(i)-Qmfr;
        Q2(i)=Qmfr;        
        B1(i)=(st.a*(Q1(i)^2)+st.b*Q1(i)+st.c)*24/1000000;
        
    elseif I(i)>(st.Qn+Qmfr)
        Q1(i)=st.Qn;
        Q2(i)=I(i)-st.Qn;              
        B1(i)=(st.a*(Q1(i)^2)+st.b*Q1(i)+st.c)*24/1000000;
    
    end
end       
        Q1_tilde=Q1;
        Q2_tilde=Q2;     
end
    

