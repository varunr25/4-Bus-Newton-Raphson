function f = pqmismatch(x, Pknown, Qknown, PixVec, QixVec)
    % Function to calculate mismatch vector for power flow equations.
    %
    % Inputs:
    %   x        - Voltage unknowns [phi2, phi3, ..., V3, V4, ...]
    %   Pknown   - Known active power injections [P2, P3, ..., PN]
    %   Qknown   - Known reactive power injections [QNG+1, ..., QN]
    %   PixVec   - Calculated active power injections [P2x, P3x, ..., PNx]
    %   QixVec   - Calculated reactive power injections [QNG+1x, ..., QNx]
    %
    % Output:
    %   f        - Mismatch vector [DeltaP2, ..., DeltaPN, DeltaQNG+1, ..., DeltaQN]
    
    % Ensure all inputs are column vectors
    Pknown = Pknown(:);
    Qknown = Qknown(:);
    PixVec = PixVec(:);
    QixVec = QixVec(:);

    % Calculate active power mismatches for all non-slack buses
    deltaP = PixVec - Pknown;

    % Calculate reactive power mismatches only for load buses
    % Skip the first entry in QixVec (generator bus)
    deltaQ = QixVec(2:end) - Qknown(2:end);

    % Combine into a single column vector
    f = vertcat(deltaP, deltaQ);
end