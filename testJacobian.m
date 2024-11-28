%% Initialization
clear; clc;
Ybus = [9-63i -3+19i -5+25i -1+19i;
        -3+19i 8-44i  0     -5+25i;
        -5+25i  0     8-40i -3+15i;
        -1+19i -5+25i -3+15i 9-59i];

V = [1 1.02 1.0 1.0];
phi = [0 0 0 0];

PixVec = [0.1632 0 -0.1];
QixVec = [0.8976 0 -0.5];

expected_J = [44.8800  0     -25.5000  0     -5.1000;
          0      40.0000 -15.0000  8.0000 -3.0000;
        -25.5000 -15.0000 59.5000 -3.0000  8.9000;
          0      -8.0000  3.0000  40.0000 -15.0000;
          5.1000  3.0000 -9.1000 -15.0000 58.5000];

%% Code
J = pfJacobian(Ybus, V, phi, PixVec, QixVec);

%% Comparison
tolerance = 1e-4; % Define a tolerance level
if norm(J - expected_J, 'fro') < tolerance
    disp('Test Passed: Computed Jacobian matches the reference Jacobian.');
    disp('Calculated J: ');
    disp(J);
    disp('Expected J: ');
    disp(expected_J);
else
    disp('Test Failed: Computed Jacobian does not match the reference Jacobian.');
    disp('Calculated J: ');
    disp(J);
    disp('Expected J: ');
    disp(expected_J);
end