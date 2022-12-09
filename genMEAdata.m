%% genMEAdata.m
% This script is designed to generate MEA signals for 60 electrodes in
% standard pattern. The function for generation one electrode signal (genMEASignal) is
% from F. Lieb's SpikeDetection-Toolbox which is distributed on
% https://github.com/flieb/SpikeDetection-Toolbox
% 
% To generate the signal You have to enter following input parameters: 
% 
    % Length L which describes the total number of samples for the signal. 
    % 
    % Number of spikes numspikes You wish to integrate.
    % 
    % sigma which determines the signal-to-noise ratio for the signal.
%
% This script exports two files:
%
    % Data file
    %
    % Spike positions file


format compact;
clear all;

%% Parameters

L = 10000; %Length of the signal 
fs = 10000; %Sample frequency (not to be change)
numspikes = 20; %number of spikes (if this number is too large, with respect to L, then genMEASignal cannot place all spikes, resulting in an infinite loop)
sigma = 4; %determines SNR
number_of_electrodes = 60; %default 60, if You change this value, You have also to adjust Matrix_of_names, Matrix_of_names_without_t and Matrix_of_units

%% Generation of MEA data for 60 electrodes

column = number_of_electrodes;
line = L;

Matrix_of_signals = zeros(line, column);
Matrix_of_sppos = zeros(numspikes, column);

for n = 1:column
        
    
        %k
        [s,t,sppos,snr] = genMEASignal(L,fs,sigma,numspikes,'randpos');
        %r(k) = s
        %r_trans = r.'

    Matrix_of_signals(:,n) = s;
    Matrix_of_sppos(:,n) = sppos.';
    %M(:,n) = r_trans
end

% Merging time and amplitude data
t_transposed = t.';
Matrix_of_signals_and_time_for_dat = [t_transposed , Matrix_of_signals];
fprintf('data created\n');

%% Defining header for output files

Date = datestr(now,'dd.mm.yyyy')
Time = datestr(now,'HH:MM:SS')
Matrix_of_meta = [Date, Time, fs, "Hz", "Raw"];

Matrix_of_names = [ "t";"El21";"El31";"El41";"El51";"El61";"El71";"El12";"El22";"El32";"El42";"El52";"El62";"El72";"El82";"El13";"El23";"El33";"El43";"El53";"El63";"El73";"El83";"El14";"El24";"El34";"El44";"El54";"El64";"El74";"El84";"El15";"El25";"El35";"El45";"El55";"El65";"El75";"El85";"El16";"El26";"El36";"El46";"El56";"El66";"El76";"El86";"El17";"El27";"El37";"El47";"El57";"El67";"El77";"El87";"El28";"El38";"El48";"El58";"El68";"El78"];
Matrix_of_names_trans = Matrix_of_names.';

Matrix_of_names_without_t = ["El21";"El31";"El41";"El51";"El61";"El71";"El12";"El22";"El32";"El42";"El52";"El62";"El72";"El82";"El13";"El23";"El33";"El43";"El53";"El63";"El73";"El83";"El14";"El24";"El34";"El44";"El54";"El64";"El74";"El84";"El15";"El25";"El35";"El45";"El55";"El65";"El75";"El85";"El16";"El26";"El36";"El46";"El56";"El66";"El76";"El86";"El17";"El27";"El37";"El47";"El57";"El67";"El77";"El87";"El28";"El38";"El48";"El58";"El68";"El78"];
Matrix_of_names_without_t_trans = Matrix_of_names_without_t.';

Matrix_of_units =["[s]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]";"[µV]"];
Matrix_of_units_trans = Matrix_of_units.';

%% Writing output files

Filename = ['els_' num2str(number_of_electrodes) '_fs_' num2str(fs) '_snr_'  num2str(sigma,'%.2f') '_sps_' num2str(numspikes) '__' datestr(now,30) '__data.csv']
Filename_sppos = ['els_' num2str(number_of_electrodes) '_fs_' num2str(fs) '_snr_'  num2str(sigma,'%.2f') '_sps_' num2str(numspikes) '__' datestr(now,30) '__sppos.csv']

%Data file
writematrix(Matrix_of_meta, Filename, 'Delimiter',';');
writematrix(Matrix_of_names_trans, Filename, 'Delimiter',';','WriteMode','append');
writematrix(Matrix_of_units_trans, Filename, 'Delimiter',';','WriteMode','append');
writematrix(Matrix_of_signals_and_time_for_dat, Filename,'Delimiter',';','WriteMode','append');
fprintf('data file is written\n');

%Spike positions file
writematrix(Matrix_of_names_without_t_trans, Filename_sppos, 'Delimiter',';')
writematrix(Matrix_of_sppos, Filename_sppos,'Delimiter',';','WriteMode','append');
fprintf('spike positions file is written\n');


fprintf('program finished\n');
