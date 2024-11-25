%% Initialization
clear; clc;
Ybus = [9-63i -3+19i -5+25i -1+19i;
        -3+19i 8-44i  0     -5+25i;
        -5+25i  0     8-40i -3+15i;
        -1+19i -5+25i -3+15i 9-59i];

V = [1 1.02 1.0 1.0];
phi = [0 0 0 0];
N = 4;

expected_P = [0.1632 0 -0.1];
expected_Q = [0.8976 0 -0.5];

%% Code for P
PixVec = Pifn(Ybus, V, phi, N);
QixVec = Qifn(Ybus, V, phi, N);

%% Comparison
tolerance = 1e-6; % Adjust this value based on your precision needs

% Compare P values with tolerance
if all(abs(PixVec - expected_P) < tolerance)
    disp('Pifn test passed!');
    disp(PixVec);
    disp(expected_P);
else
    disp('Pifn test failed!');
    disp('Difference:');
    disp(abs(PixVec - expected_P));
    disp('Values:');
    disp(PixVec);
    disp(expected_P);
end

% Compare Q values with tolerance
if all(abs(QixVec - expected_Q) < tolerance)
    disp('Qifn test passed!');
    disp(QixVec);
    disp(expected_Q);
else
    disp('Qifn test failed!');
    disp('Difference:');
    disp(abs(QixVec - expected_Q));
    disp('Values:');
    disp(QixVec);
    disp(expected_Q);
end