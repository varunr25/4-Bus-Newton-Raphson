%% Initialization
clear; clc;

alpha = 22; beta = 18; % Based on my initials (V.R.)

Y12 = 3 - 19j;                                  % Line from Bus 1 to Bus 2
Y13 = 5 - 25j;                                  % Line from Bus 1 to Bus 3
Y14 = alpha - beta*1j;                          % Line from Bus 1 to Bus 4
Y24 = 5 - 25j;                                  % Line from Bus 2 to Bus 4
Y34 = 3 - 15j;                                  % Line from Bus 3 to Bus 4

Ybus = [Y12 + Y13 + Y14, -Y12, -Y13, -Y14;      % Bus 1
        -Y12, Y12 + Y24, 0, -Y24;               % Bus 2
        -Y13, 0, Y13 + Y34, -Y34;               % Bus 3
        -Y14, -Y24, -Y34, Y14 + Y24 + Y34];     % Bus 4

Pknown = [2.2; -1.7; -2]; % Known real power for Buses 2, 3, 4 (in pu)
Qknown = [-0.5; -1.05; -1.25]; % Known reactive power for Buses 3, 4 (in pu)

Vg = [1; 1.02]; % Slack (Bus 1) and PV (Bus 2)

N = 4;  % Total buses
Ng = 2; % Number of generator buses

maxIter = 10;

%% Invoking the Newton-Raphson function
[x, iter] = newtonRaphsonPowerFlow(Ybus, Pknown, Qknown, Vg, Ng, N, maxIter);

V = x2V(x, Vg, Ng, N);
phi = x2phi(x, Ng, N);

%% 1. Voltage phasor at Bus 4
V4 = V(4) * exp(1j * phi(4));
V4_rms = abs(V4); % RMS voltage magnitude
V4_angle = phi(4); % Phase angle in radians
fprintf('1. Voltage phasor at Bus 4: %.5f ∠ %.5f° (pu)\n', V4_rms, rad2deg(V4_angle));

%% 2. Real and reactive power generation at Bus 2
Pgen2 = 300; % Real power generation at Bus 2 (MW)
Qgen2_pu = imag(conj(V(2) * sum(V .* Ybus(2, :)))); % Reactive power generation at Bus 2 (in pu)
Qgen2 = Qgen2_pu * 100; % Reactive power generation at Bus 2 (MVAr)

fprintf('2. Complex power generation at Bus 2: %.5f MW + %.5fj MVAr\n', Pgen2, Qgen2);

%% 3. Total real power generation within the system
Pload2 = 80; % Real power load at Bus 2 (MW)
Ptotal_gen = Pgen2 - Pload2; % Total real power generation (MW)
fprintf('3. Total real power generation: %.5f MW\n', Ptotal_gen);

%% 4. Complex power leaving Bus 1 towards Bus 3
V1 = V(1) * exp(1j * phi(1)); % Voltage phasor at Bus 1
V3 = V(3) * exp(1j * phi(3)); % Voltage phasor at Bus 3

%% Use admittance matrix to calculate power flow
I13 = (V1 - V3) * Y13; % Current flowing from Bus 1 to Bus 3
S13 = V1 * conj(I13); % Complex power from Bus 1 to Bus 3
P13 = real(S13) * 100; % Real power (MW)
Q13 = imag(S13) * 100; % Reactive power (MVAr)

fprintf('4. Complex power leaving Bus 1 towards Bus 3: %.5f MW + %.5fj MVAr\n', P13, Q13);

%% Populate Solution Vector & Verify Solutions
sol = [ V4_rms;       % Item 1: Voltage RMS at Bus 4 in pu
        V4_angle;     % Item 2: Voltage phase angle at Bus 4 in radians
        Pgen2;        % Item 3: Real power generation at Bus 2 in MW
        Qgen2;        % Item 4: Reactive power generation at Bus 2 in MVAr
        Ptotal_gen;   % Item 5: Total real power generation in MW
        P13;          % Item 6: Real power leaving Bus 1 towards Bus 3 in MW
        Q13];         % Item 7: Reactive power leaving Bus 1 towards Bus 3 in MVAr

verifySoln(alpha, beta, sol)