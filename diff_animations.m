clc;
clear;
close all;

% Total amount to be memorized
M = 450;

% Initial amount memorized (A(0) = 0)
A0 = 0;        

% Retention constants
a = [0.9662, 0.7407, 0.5556, 0.4444, 0.3704, 0.3175, 0.2778, 0.2469, 0.2245]; 

% Absorption rates
c = [0.0523, 0.0713, 0.1022, 0.1386, 0.1833, 0.2408, 0.3219, 0.4605, 0.9210]; 

% Amount memorized at t = 10
A10 = [177, 170, 160, 150, 140, 130, 120, 110, 101]; 

% Steady-state values
A_inf = [435, 333, 250, 200, 167, 143, 125, 111, 101];

% Time span
tspan = [0 80];

% Calculate k1 and k2 from a and c
k1 = a .* c;
k2 = c - k1; 

% Selecting specific values of a and c to plot
plot_selection = [2, 3, 5, length(a)];

% Generate distinct colors for each curve
colors = lines(length(plot_selection)); 

% Set up the figure
figure;
hold on;
xlabel('Time (t)');
ylabel('Amount Memorized (A)');
title('Memorization and Forgetfulness Model');
grid on;

% Setting the axes limits
xmin = min(tspan);
xmax = max(tspan);
ymin = 0; % Memorization starts from 0
ymax = 350; % Maximum possible memorization
axis([xmin xmax ymin ymax]); 

% Initialize empty plots for animation
memorizationCurve = gobjects(length(plot_selection), 1);

for i = 1:length(plot_selection)
    val = plot_selection(i);

    % Define ODE
    ode = @(t, A) k1(val) * (M - A) - k2(val) * A;

    % Solve the ODE using ode45
    [t, A] = ode45(ode, tspan, A0);

    % Create an empty plot for animation
    memorizationCurve(i) = plot(nan, nan, 'Color', colors(i,:), 'LineWidth', 2, ...
        'DisplayName', sprintf('A(10): %d  A(inf) = %d', A10(val), A_inf(val)));

    % Animate the curve drawing
    for j = 1:length(t)
        set(memorizationCurve(i), 'XData', t(1:j), 'YData', A(1:j)); % Update curve
        pause(0.02);
    end
end

% Show legend after animation
legend show;
hold off;
