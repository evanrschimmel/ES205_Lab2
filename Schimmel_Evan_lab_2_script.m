clear all
close all
clc

% Load data from source folder
load Schimmel_Evan_lab_2_data
import = data;
realdata = import.';

for i=1:length(realdata)
    tdata(i) = realdata(i,1);
    xdata(i) = realdata(i,2);
end

% figure
% plot(tdata, xdata, 'k-')
% xlabel('Time (s)')
% ylabel('Position (cm)')

Fin = 8; % N

Xss=xdata(end);
K=Xss/Fin;

Xp=max(xdata);
Tp=tdata(find(xdata==max(xdata),1));
pOS=((Xp-Xss)/Xss)*100;
zeta=sqrt( (log(pOS/100))^2 / ((log(pOS/100))^2 + pi^2 ));
omegaD=pi/Tp;
omegaN=omegaD/(sqrt(1-zeta^2));

mLab=(1/((omegaN^2)*K));
cLab=(2*zeta)/(omegaN*K);
kLab=1/K;

% Define initial conditions
m = mLab; % kg
c = cLab*2.65; % N-s/m
k = kLab; % N/m
g = 9.81; % m/s^2

tf = tdata(end); % s
maxstep = 0.01; % s
tol = 1e-6;

v0 = 0; % m/s
x0 = 0; % m

mu = 0.15;

% Run simulation
sim('Schimmel_Evan_lab_2_model')

% Calculate sum for inside of SEE calculation
sum=0;
for i=1:length(tdata)
    sum=sum+(x(i)-xdata(i))^2;
end

% Calculate SEE value
SEE=sqrt(sum/(length(xdata)-2)); % cm

% Create time-series plot
figure
plot(t, x, 'k-', tdata, xdata, 'ob')
xlabel('Time (s)')
ylabel('Position (cm)')
set(gcf, 'color', 'w')
legend('Model', 'Data')