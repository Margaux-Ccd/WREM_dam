function [IHA_g1] = monthy_means(q)
% :::HELP:::
% 
% [IHA_g1] = monthy_means(q)
% 
% Creates a vector of monthy streamflow means from a 1-year long vector of
% daily streamflow means. The output vector represents group 1 of IHA indicators:
% "magnitude of monthy water conditions".
% 
% Input arguments
%   q = vector of daily streamflow means [m^3/s] - vector [365 or 366x1]
%   
% Output arguments
%   IHA_g1 = vector of monthy streamflow means [m^3/s] - vector [12x1]
%
% Andrea Cominola, Emanuele Mason 28/09/2010

if (size(q,1) < 365) || (size(q,1) > 366);
    disp(' Error: q = vector of daily streamflow means [m3/s]; - vector [365 or 366x1]');
    return;
end

% Vector of months start days.
 monthsStart = [1,32,60,91,121,152,182,213,244,274,305,335] ;
 if length(q) == 366;
  monthsStart =[1,32,61,92,122,153,183,214,245,275,306,336];
 end
 % - Build lookup table day/month: e.g. LT(47) is month ID for day 47.
 LT = zeros( 365, 1 ) ;
 if length(q) == 366;
     LT = zeros( 366, 1 ) ;
 end
 LT(monthsStart) = 1 ;
 LT = cumsum( LT ) ;
 % - Accumulate using month ID as index.
 IHA_g1 = accumarray( LT, q, [12,1] , @mean);