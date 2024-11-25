%% Initialization
clear; clc;
Ybus = [9-63i -3+19i -5+25i -1+19i;
        -3+19i 8-44i  0     -5+25i;
        -5+25i  0     8-40i -3+15i;
        -1+19i -5+25i -3+15i 9-59i];

V = [1 1.02 1.0 1.0];
phi = [0 0 0 0];

Pknown = [0.1632 0 -0.1];
Qknown = [0.8976 0 -0.5];

Vk = [1 1.02];
Vg = Vk; 
Ng = 2;

x = [0 0 0 1.0 1.0];

expected_J = [44.8800  0     -25.5000  0     -5.1000;
          0      40.0000 -15.0000  8.0000 -3.0000;
        -25.5000 -15.0000 59.5000 -3.0000  8.9000;
          0      -8.0000  3.0000  40.0000 -15.0000;
          5.1000  3.0000 -9.1000 -15.0000 58.5000];

% Convergence criteria
tol = 1e-6;       % Tolerance for mismatch vector
max_iter = 10;    % Maximum number of iterations

% Run Newton-Raphson solver
fprintf('Running Newton-Raphson power flow...\n');
[V_final, phi_final, iterations] = newtonRaphsonPowerFlow(Ybus, Pknown, Qknown, V, phi, Vg, Ng, tol, max_iter);

% Display results
fprintf('Newton-Raphson Results:\n');
fprintf('Number of iterations: %d\n', iterations);
disp('Final Voltage Magnitudes (p.u.):');
disp(V_final);
disp('Final Voltage Angles (radians):');
disp(phi_final);
disp("X: ")
disp(x);

% Validation: Compute mismatches
PixVec = Pifn(Ybus, V_final, phi_final, length(V_final));
QixVec = Qifn(Ybus, V_final, phi_final, length(V_final));
f = pqmismatch([phi_final(2:end); V_final(Ng+1:end)], Pknown, Qknown, PixVec, QixVec);

% Check mismatches
fprintf('Active Power Mismatch (DeltaP):\n');
disp(f(1:length(Pknown))); % DeltaP values
fprintf('Reactive Power Mismatch (DeltaQ):\n');
disp(f(length(Pknown)+1:end)); % DeltaQ values

% Verify if mismatches are within tolerance
if max(abs(f)) < tol
    fprintf('Test Passed: Mismatches are within tolerance.\n');
else
    fprintf('Test Failed: Mismatches exceed tolerance.\n');
end

% Optional: Verify Jacobian matrix at the solution point
fprintf('Jacobian matrix at the solution point:\n');
Jacobian = pfJacobian(Ybus, V_final, phi_final, PixVec, QixVec);
disp(Jacobian);

% Compute condition number of the Jacobian
cond_number = cond(Jacobian);
fprintf('Condition number of the Jacobian: %.2f\n', cond_number);
