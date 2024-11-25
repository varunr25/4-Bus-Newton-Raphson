%% Initialization
clear; clc;
Ybus = [9-63i -3+19i -5+25i -1+19i;
        -3+19i 8-44i  0     -5+25i;
        -5+25i  0     8-40i -3+15i;
        -1+19i -5+25i -3+15i 9-59i];

V = [1 1.02 1.0 1.0];
phi = [0 0 0 0];

x = [0 0 0 1.0 1.0];
Pknown = [2.2 -1.7 -2];
Qknown = [-0.5 -1.05 -1.25];

PixVec = [0.1632 0 -0.1];
QixVec = [0.8976 0 -0.5];

expected_fx = [-2.0368 1.7 1.9 1.05 0.75];

%% Code
Pknown = Pknown(:);
Qknown = Qknown(:);
PixVec = PixVec(:);
QixVec = QixVec(:);

deltaP = PixVec - Pknown;
deltaQ = QixVec(2:end) - Qknown(2:end);

fx = vertcat(deltaP, deltaQ);

%% Comparison
if isequal(round(fx, 4), round(expected_fx', 4))
    disp('Test Passed: The mismatch vector matches the expected values.');
    disp(fx);
    disp(expected_fx');
else
    disp('Test Failed: The mismatch vector does not match the expected values.');
    disp(fx);
    disp(expected_fx');
end