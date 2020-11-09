clc, clear, close all,
%% import txt file: Gait data from book
% Gait raw [cycle hip knee ankle] unit deg
gait_raw = importdata('gait_raw.txt');
cycle_raw = gait_raw(:,1);
hip_raw = gait_raw(:,2);
knee_raw = gait_raw(:,3);
ankle_raw = gait_raw(:,4);

lengh = size(cycle_raw);

%% interpolation process
cycle_interpolate = 0:0.2:99.8; % sampling to 99.9 ->1000 point
%hip_interpolate = spline(cycle_raw,hip_raw,cycle_interpolate);

%hip polynimial interpolation
p_hip = polyfit(cycle_raw,hip_raw,11); % 11 is good https://www.mathworks.com/help/matlab/ref/polyfit.html
hip_interpolate = polyval(p_hip,cycle_interpolate);

%hip polynimial interpolation
p_knee = polyfit(cycle_raw,knee_raw,11); % 11 is good https://www.mathworks.com/help/matlab/ref/polyfit.html
knee_interpolate = polyval(p_knee,cycle_interpolate);


%% convert from deg to count
abs_encorder = 131072;

hip_interpolate =  hip_interpolate * abs_encorder /360;
hip_interpolate = round (hip_interpolate) % convert from float to int number

knee_interpolate =  knee_interpolate * abs_encorder /360;
knee_interpolate =  - round (knee_interpolate) % convert from float to int number

%% write to txt file
fid_hip = fopen('hip_interpolate.txt','wt');
fprintf(fid_hip,'%d\n',hip_interpolate);

fid_knee = fopen('knee_interpolate.txt','wt');
fprintf(fid_knee,'%d\n',knee_interpolate);

fid_hip_knee = fopen('hip_knee_interpolate.txt','wt');
fprintf(fid_hip_knee,'%d\n',hip_interpolate);
fprintf(fid_hip_knee,'%d\n',knee_interpolate);
%% Plot
grid on

plot (cycle_interpolate,hip_interpolate,'-.r+')
title('Interpolated hip position (count)')

figure;
plot (cycle_interpolate,knee_interpolate,'-.b+')
title('Interpolated knee position (count)')

figure;
plot (cycle_raw,hip_raw,'-.r*')
title('Raw hip position (deg)')

figure;
plot (cycle_raw,-knee_raw,'-.b*')
title('Raw knee position (deg)')