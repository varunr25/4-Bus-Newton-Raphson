%% Initialization
clear; clc;
Ybus = [9-63i -3+19i -5+25i -1+19i;
        -3+19i 8-44i  0     -5+25i;
        -5+25i  0     8-40i -3+15i;
        -1+19i -5+25i -3+15i 9-59i];

V = [1 1.02 1.0 1.0];
phi = [0 0 0 0];

% Pknown = [0.1632 0 -0.1];
% Qknown = [0.8976 0 -0.5];

Pknown = [2.2 -1.7 -2];
Qknown = [-0.5 -1.05 -1.25];

Vk = [1 1.02];
Vg = Vk; 
Ng = 2;
N = 4; % Total number of buses

x = [0 0 0 1.0 1.0];

expected_J = [44.8800  0     -25.5000  0     -5.1000;
          0      40.0000 -15.0000  8.0000 -3.0000;
        -25.5000 -15.0000 59.5000 -3.0000  8.9000;
          0      -8.0000  3.0000  40.0000 -15.0000;
          5.1000  3.0000 -9.1000 -15.0000 58.5000];

expected_x = [0.0239 -0.0502 -0.0331 0.9524 0.9690];

% Convergence criteria
tol = 1e-6; % Tolerance for convergence
maxIter = 2; % Maximum number of iterations

%% Run the Newton-Raphson function
try
    [computed_x, iter] = newtonRaphsonPowerFlow(Ybus, Pknown, Qknown, Vg, Ng, N, tol, maxIter);
    fprintf('Newton-Raphson completed in %d iterations.\n', iter);

    % Compare computed results to expected results
    diff = abs(computed_x - expected_x);
    if all(diff < tol)
        fprintf('Test PASSED: Computed values match expected values within tolerance.\n');
    else
        fprintf('Test FAILED: Computed values do not match expected values.\n');
        disp('Computed X');
        disp(computed_x');
        disp('Expected X');
        disp(expected_x);
        disp("Number of Iterations");
        disp(iter);
    end
catch ME
    % Handle errors
    fprintf('Test FAILED: Newton-Raphson function encountered an error.\n');
    fprintf('Error message: %s\n', ME.message);
end