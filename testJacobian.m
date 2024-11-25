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
N = length(V);  % Total number of buses
Ng = 2;         % Number of generator buses (including slack)
Npq = N - Ng;   % Number of PQ buses

G = real(Ybus);
B = imag(Ybus);

% Initialize Jacobian with correct dimensions: 5x5 for this system
J = zeros(2*N-Ng-1, 2*N-Ng-1);

% Fill H submatrix (∂P/∂θ)
for i = 2:N
    for j = 2:N
        row = i-1;
        col = j-1;
        if i == j
            % Diagonal elements
            J(row,col) = -QixVec(i-1) - V(i)^2 * B(i,i);
        else
            % Off-diagonal elements
            J(row,col) = V(i)*V(j)*(G(i,j)*sin(phi(i)-phi(j)) - B(i,j)*cos(phi(i)-phi(j)));
        end
    end
end

% Fill N submatrix (∂P/∂V)
for i = 2:N
    for j = (Ng+1):N
        row = i-1;
        col = N-1+j-Ng;
        if i == j
            J(row,col) = PixVec(i-1)/V(i) + V(i)*G(i,i);
        else
            J(row,col) = V(i)*(G(i,j)*cos(phi(i)-phi(j)) + B(i,j)*sin(phi(i)-phi(j)));
        end
    end
end

% Fill M submatrix (∂Q/∂θ)
for i = (Ng+1):N
    for j = 2:N
        row = N-1+i-Ng;
        col = j-1;
        if i == j
            J(row,col) = PixVec(i-1) - V(i)^2*G(i,i);
        else
            J(row,col) = -V(i)*V(j)*(G(i,j)*cos(phi(i)-phi(j)) + B(i,j)*sin(phi(i)-phi(j)));
        end
    end
end

% Fill L submatrix (∂Q/∂V)
for i = (Ng+1):N
    for j = (Ng+1):N
        row = N-1+i-Ng;
        col = N-1+j-Ng;
        if i == j
            J(row,col) = QixVec(i-1)/V(i) - V(i)*B(i,i);
        else
            J(row,col) = V(i)*(G(i,j)*sin(phi(i)-phi(j)) - B(i,j)*cos(phi(i)-phi(j)));
        end
    end
end

%% Comparison
tolerance = 1e-4; % Define a tolerance level
if norm(J - expected_J, 'fro') < tolerance
    disp('Test Passed: Computed Jacobian matches the reference Jacobian.');
    disp(J);
    disp(expected_J);
else
    disp('Test Failed: Computed Jacobian does not match the reference Jacobian.');
    disp(J);
    disp(expected_J);
end