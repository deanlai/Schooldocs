function salinity_model
% salinity_model  Use salinity data from Schlumberger to predict resistance
%                 of the salinity sensor in the ME 121 fish tank

% -- Resistivity data at 20C and 30C.  Sppm is salinity in parts per million
[Sppm, rho20, rho30] = resistanceData;

% -- Convert Sppm to wt%
wt_pct = Sppm./10000;

% -- Plot wt% vs. rho for 20C and 30C
plot(wt_pct, rho20, 'ro', wt_pct, rho30, 'bs')
xlabel('Salinity (%wt)')
ylabel('Resistivity (ohm * m)')
title('Resistivity vs. Salinity')
legend('20 C', '30 C')

% -- Define geometry of water column in m
d = 8.433*10^-3;            % diameter (m)
r = d/2;                    % convert to radius (m)
L = 12.7*10^-3;             % length (m)
R20 = rho20*L/((r)^2*pi);   % Resistance at 20C
R30 = rho30*L/((r)^2*pi);   % Resistance at 30C

% -- Create line fit to resistance data
% Note: also storing R2 value for possible future use
[c_20, r2_20] = powfit(wt_pct, R20);
[c_30, r2_30] = powfit(wt_pct, R30);
% -- Create number space to plot fit curve
wt_pct_fit = linspace(min(wt_pct), max(wt_pct));
% -- Create fitted resistance values using constants found with powfit
R20_fit = c_20(1)*wt_pct_fit.^c_20(2);
R30_fit = c_30(1)*wt_pct_fit.^c_30(2);

figure % New figure window
% -- Create plot of Resistance vs. weight percent with fit lines
plot(wt_pct, R20, 'ro',...
    wt_pct, R30, 'bs',...
    wt_pct_fit, R20_fit, 'k--',...
    wt_pct_fit, R30_fit, 'k--')
xlabel('Salinity (wt%)')
ylabel('Resistance (ohms)')
title('Resistance vs. Salinity')
legend('20 C', '30 C')

% Compute analog output values from resistance with voltage_divider
% function. 1023 was used as v_in instead of scaling by 5/1023.
analog20 = voltage_divider(1023, R20, 10000);
analog30 = voltage_divider(1023, R30, 10000);
analog20_fit = voltage_divider(1023, R20_fit, 10000);
analog30_fit = voltage_divider(1023, R30_fit, 10000);

figure % New figure window
% -- Create plot of Analog output vs. weight percent with fit lines
plot(wt_pct, analog20, 'ro',...
    wt_pct, analog30, 'bs',...
    wt_pct_fit, analog20_fit, 'k--',...
    wt_pct_fit, analog30_fit, 'k--');
xlabel('Salinity (wt%)')
ylabel('Analog Output')
title('Analog Output vs. Salinity')
legend('20 C', '30 C', 'Location', 'northwest')



