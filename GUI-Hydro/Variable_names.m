%Variables necessary to the code
Qmfr % Minimum flow requirement [m3/s]
Qn % Nominal flow rate [m3/s]
Qmec % Minimal flow for turbine [m3/s]
% The benefit-function for the hydropower plant is interpolated using a 
coef_A, coef_B, coef_C % second order polynomial : B1(Q)= a*x^2 + b*x + c
I %daily river flow
init_date_sim=[ 01 01 1983 ];
init_year=1983;