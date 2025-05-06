function IHA_stat=stat(IHA_pre,IHA_post)
% :::Help:::
%
% IHA_stat=stat (IHA_pre, IHA_post)
%
% The function evaluates, for the pre-impact and post-impact data series, the statistics on
% the 34 IHA indicators,required by IHA method. These statistics are inter-annual means and standard
% deviations, for each indicator of each series. Then, comparing the statistics between the two series, 
% the function also evaluates the deviation magnitude and the deviation (%) both for the means and for the standard deviations. 
% 
%
% Input arguments:
%      IHA_pre:matrix containing the values of 34 IHA indicators of the pre-impact serie, evaluated by the function IHA_indicators. 
%                                                                                                                     -matrix [34xn°years]
%      IHA_post:matrix containing the values of 34 IHA indicators of the post-impact serie, evaluated by the function IHA_indicators.
%                                                                                                                     -matrix [34xn°years]
% Output arguments:
%      IHA_stat: matrix containing the statistics on the indicators.
%                  1st column: inter-annual means for the pre-impact serie.
%                  2nd column: inter-annual means for the post-impact serie.
%                  3rd column: means deviation magnitude (difference between pre and post impact).
%                  4th column: means deviation (fraction between pre and post impact).
%                  5th column: pre-impact standard deviation.
%                  6th column: post-impact standard deviation.
%                  7th column: standard deviation magnitude (difference between pre and post impact).
%                  8th column: standard deviation (fraction between pre and post impact).
%                  9th column: inferior limits (min) for the pre-impact river.
%                 10th column: superior limits (max) for the pre-impact river.
%                 11th column: inferior limits (min) for the post-impact river.
%                 12th column: superior limits (max) for the post-impact river.
%                 13th column: inferior targets
%                 14th column: superior targets
%                 15th column: rate of non-attainement (fraction, pre-impact).
%                 16th column: rate of non-attainement (fraction, post-impact).
%                 17th column: pre-impact coefficient of variation (CV), not SD (aggiunto 16/02/2012)
%                 18th column: post-impact coefficient of variation (CV), not SD (aggiunto 16/02/2012)
% The mean for the data indicators is calculated using the circular
% method of the function "mean_timing_var".
%
% Andrea Cominola, Emanuele Mason, Lorenzo Gorla 09-01-2012

%:::Calculating natural statistics:::
 sz=size(IHA_pre);
 N=sz(1);

 natural_stat = NaN(N,1);

 natural_stat(:,1)=nanmean(IHA_pre,2);
 natural_stat(:,2)=nanstd(IHA_pre,0,2);

%Timing variables: JD of 1day min (summer and winter) and max (spring and autumn)
 natural_stat(23,1)= mean_timing_var(IHA_pre(23,:));
 natural_stat(24,1)= mean_timing_var(IHA_pre(24,:));
 natural_stat(25,1)= mean_timing_var(IHA_pre(25,:));
 natural_stat(26,1)= mean_timing_var(IHA_pre(26,:));
 natural_stat(23,2)= sqrt(mean((IHA_pre(23,:) - natural_stat(23,1)).^2));
 natural_stat(24,2)= sqrt(mean((IHA_pre(24,:) - natural_stat(24,1)).^2));
 natural_stat(25,2)= sqrt(mean((IHA_pre(25,:) - natural_stat(25,1)).^2));
 natural_stat(26,2)= sqrt(mean((IHA_pre(26,:) - natural_stat(26,1)).^2));

%:::Calculating all the other statistics:::
 n=size(IHA_post);
 n=n(2);
  
 IHA_stat(:,1)=natural_stat(:,1);    % pre-impact streamflow mean
 IHA_stat(:,2)=nanmean(IHA_post,2);  % post-impact streamflow mean
  
 %Timing variables: mean of JD of 1day min and max. The mean is calculated
 %using the circular method of the funcion "mean_timing_var".
 IHA_stat(23,2)=mean_timing_var(IHA_post(23,:));
 IHA_stat(24,2)=mean_timing_var(IHA_post(24,:));
 IHA_stat(25,2)=mean_timing_var(IHA_post(25,:));
 IHA_stat(26,2)=mean_timing_var(IHA_post(26,:)); 
  
 IHA_stat(:,3) = IHA_stat(:,2) - IHA_stat(:,1); % means deviation magnitude (difference)
 %If the difference between the indicator calculated for the natural and
 %the post-impact serie is >183, 365 is subtracted from it. If it is <183, 365 is added. 
 if IHA_stat(23,3) > 183; IHA_stat(23,3) = - 365 + IHA_stat(23,3); end
 if IHA_stat(23,3) < -183; IHA_stat(23,3) = 365 - IHA_stat(23,3); end
 if IHA_stat(24,3) > 183; IHA_stat(24,3) = - 365 + IHA_stat(24,3); end
 if IHA_stat(24,3) < -183; IHA_stat(24,3) = 365 - IHA_stat(24,3); end
 if IHA_stat(25,3) > 183; IHA_stat(25,3) = - 365 + IHA_stat(25,3); end
 if IHA_stat(25,3) < -183; IHA_stat(25,3) = 365 - IHA_stat(25,3); end
 if IHA_stat(26,3) > 183; IHA_stat(26,3) = - 365 + IHA_stat(26,3); end
 if IHA_stat(26,3) < -183; IHA_stat(26,3) = 365 - IHA_stat(26,3); end
 
 IHA_stat(:,4) = (IHA_stat(:,3))./IHA_stat(:,1);% means deviation (fraction)
 IHA_stat(23,4) = (IHA_stat(23,3))./365;        % means deviation (fraction)
 IHA_stat(24,4) = (IHA_stat(24,3))./365;        % means deviation (fraction)
 IHA_stat(25,4) = (IHA_stat(25,3))./365;        % means deviation (fraction)
 IHA_stat(26,4) = (IHA_stat(26,3))./365;        % means deviation (fraction)
    
 IHA_stat(:,5)=natural_stat(:,2);    % pre-impact SD, not CV 
 IHA_stat(:,6)=nanstd(IHA_post,0,2); % post-impact SD, not CV
 
 % Timing variables: std dev of JD of 1day min and max
 IHA_stat(23,6)= sqrt(mean((IHA_post(23,:) - IHA_stat(23,2)).^2));
 IHA_stat(24,6)= sqrt(mean((IHA_post(24,:) - IHA_stat(24,2)).^2));
 IHA_stat(25,6)= sqrt(mean((IHA_post(25,:) - IHA_stat(25,2)).^2));
 IHA_stat(26,6)= sqrt(mean((IHA_post(26,:) - IHA_stat(26,2)).^2));
  
 IHA_stat(:,7)= IHA_stat(:,6)-IHA_stat(:,5);   % std deviation magnitude (difference)
 IHA_stat(:,8)= IHA_stat(:,6)./IHA_stat(:,5) ; % std deviation (fraction)
 
 % min e max inter-annual values (inferior and superior limits)
 IHA_stat(:,9)= nanmin(IHA_pre');
 IHA_stat(:,10)= nanmax(IHA_pre');
 IHA_stat(:,11)= nanmin(IHA_post');
 IHA_stat(:,12)= nanmax(IHA_post');
   
%  IHA_stat(:,13)=IHA_stat(:,1)-IHA_stat(:,5);   % inferior target for the pre-impact river
%  IHA_stat(:,14)=IHA_stat(:,1)+IHA_stat(:,5);   % superior target for the pre-impact river
 
 %RVA targets for post-impact river are based upon mean + or -1 sd, exept when such targets would
 %fall outside of pre-impact range limits (pre-impact range limits are then used)
 for i=1:length(IHA_stat)
 if (IHA_stat(i,1)-IHA_stat(i,5))>=IHA_stat(i,9); IHA_stat(i,13)=IHA_stat(i,1)-IHA_stat(i,5); else IHA_stat(i,13)=IHA_stat(i,9); end; % inferior target
 if (IHA_stat(i,1)+IHA_stat(i,5))<=IHA_stat(i,10); IHA_stat(i,14)=IHA_stat(i,1)+IHA_stat(i,5); else IHA_stat(i,14)=IHA_stat(i,10); end; % superior target
 end
 % Rate of non-attainement
 for i=1:N
    IHA_stat(i,15)=(sum(IHA_pre(i,:)<IHA_stat(i,13)) + sum((IHA_pre(i,:)>IHA_stat(i,14))))/size(IHA_pre,2); % Rate of non-attainement (fraction, pre-impact)
    IHA_stat(i,16)=(sum(IHA_post(i,:)<IHA_stat(i,13)) + sum((IHA_post(i,:)>IHA_stat(i,14))))/size(IHA_post,2); % Rate of non-attainement (fraction, post-impact)
 end
      
 IHA_stat(:,17)=natural_stat(:,2)./abs(IHA_stat(:,1));      % pre-impact coefficient of variation (CV), not SD (aggiunto 16/02/2012)
 IHA_stat(:,18)=(nanstd(IHA_post,0,2))./abs(IHA_stat(:,2)); % post-impactcoefficient of variation (CV), not SD (aggiunto 16/02/2012)
 
 % Timing variables: std dev of JD of 1day min and max
 IHA_stat(23,18)= sqrt(mean((IHA_post(23,:) - IHA_stat(23,2)).^2));
 IHA_stat(24,18)= sqrt(mean((IHA_post(24,:) - IHA_stat(24,2)).^2));
 IHA_stat(25,18)= sqrt(mean((IHA_post(25,:) - IHA_stat(25,2)).^2));
 IHA_stat(26,18)= sqrt(mean((IHA_post(26,:) - IHA_stat(26,2)).^2));
 
end