% MEE5318 - Project 2 Frequency Response Data Processing
% Braidan Duffy, Mary Walker
% March 31, 2022

clc; clear all; close all;

%% Experimental FRF from VI
% Import magnitude and phase data generated from LabView VI
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [2, inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Frequency", "InputGain", "InputPhase", "x", "OutputGain", "OutputPhase"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
data = readtable("data/data.csv", opts);

Ts = 0; % Sampling time
W = data.Frequency; % Frequency vector

% Convert magnitude/phase data to input/output data
u = data.InputGain.*exp(1j*data.InputPhase);
y = data.OutputGain.*exp(1j*data.OutputPhase);
measured_gain = log(data.OutputGain ./ data.InputGain);
measured_phase = wrapTo180(data.OutputPhase - data.InputPhase);
data_func = iddata(y,u,Ts, 'Frequency',W);
G_exp = etfe(data_func); % Generate experimental transfer function from data
[mag_exp, phase_exp, w_exp] = bode(G_exp); % Plot the frequency response of the model
mag_exp = 20*log10(mag_exp);

%% Theoretical FRF

C1 = 27e-9;
C2 = 100e-9;
R1 = 56e3;
R2 = 1.5e3; 
G_theo = tf([C1*R1  0],[C1*R1*C2*R2  (C1*R1+C2*R2)  1]);
[mag_theo, phase_theo, w_theo] = bode(G_theo);
mag_theo = 20*log10(mag_theo);

%% Experimental FRF from ELVIS

opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = [4, inf];
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["Frequency", "Magnitude", "Phase", "Var4"];
opts.SelectedVariableNames = ["Frequency", "Magnitude", "Phase"];
opts.VariableTypes = ["double", "double", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% Specify variable properties
opts = setvaropts(opts, "Var4", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var4", "EmptyFieldRule", "auto");

% Import the data
ElvisData = readtable("data/BodeAnalyzerLog.txt", opts);

%% Display
figure   
    subplot(2,1,1)
        semilogx(w_theo(:,:), mag_theo(:,:))
        hold on
        semilogx(w_exp(:,:), mag_exp(:,:))
        semilogx(ElvisData.Frequency, ElvisData.Magnitude)
        grid on
        hold off
        title("Magnitude")
        xlabel("Frequency (Hz)")
        ylabel("Magnitude (dB)")
        legend("Circuit theory model", "Experimental VI data", "NI-ELVIS data")
    subplot(2,1,2)
        semilogx(w_theo(:,:), wrapTo180(phase_theo(:,:)))
        hold on
        semilogx(w_exp(:,:), phase_exp(:,:))
        semilogx(ElvisData.Frequency, ElvisData.Phase)
        grid on
        hold off
        title("Phase")
        xlabel("Frequency (Hz)")
        ylabel("Phase (Deg)")
        legend("Circuit theory model", "Experimental VI data", "NI-ELVIS data")