function [V, phi, iterations] = newtonRaphsonPowerFlow(Ybus, Pknown, Qknown, V_init, phi_init, Vg, Ng, tol, max_iter)
    % NEWTON_RAPHSON - Power flow solution using Newton-Raphson method.

    % Ensure inputs are column vectors
    V_init = V_init(:);
    phi_init = phi_init(:);
    Vg = Vg(:);

    % Initialize variables
    N = length(Ybus); % Total number of buses
    
    % Validate dimensions for Ng (number of generator buses)
    if Ng >= N
        error('Ng (number of generator buses) must be less than total number of buses (N).');
    end

    % Initial guess for unknowns
    % phi_init(2:end): Exclude slack bus angle
    % V_init(Ng+1:end): Exclude voltages for slack and generator buses
    x = [phi_init(2:end); V_init(Ng+1:end)];
    epsilon = tol; % Error tolerance for convergence
    
    fprintf('Starting Newton-Raphson Iterations...\n');
    
    % Iterative process
    for iterations = 1:max_iter
        % Step 1: Convert x to full voltage magnitudes and angles
        V = x2V(x, Vg, Ng, N); % Ensure dimensions are correct in x2V
        phi = x2phi(x, Ng, N);
        
        % Step 2: Compute active and reactive power injections
        PixVec = Pifn(Ybus, V, phi, N); % Active power injections
        QixVec = Qifn(Ybus, V, phi, N); % Reactive power injections
        
        % Step 3: Calculate mismatch vector
        f = pqmismatch(x, Pknown, Qknown, PixVec, QixVec);
        
        % Step 4: Check for convergence
        mismatch_norm = norm(f, 2); % Euclidean norm of mismatch vector
        fprintf('Iteration %d: Mismatch Norm = %.8f\n', iterations, mismatch_norm);
        if mismatch_norm < epsilon
            fprintf('Convergence achieved in %d iterations.\n', iterations);
            return;
        end
        
        % Step 5: Compute Jacobian matrix
        J = pfJacobian(Ybus, V, phi, PixVec, QixVec);
        
        % Step 6: Solve for update step
        delta_x = -J \ f; % Solving J * delta_x = -f(x)
        
        % Step 7: Update variables
        x = x + delta_x;
    end
    
    % If convergence is not achieved within max_iter
    fprintf('Maximum iterations reached (%d). Solution may not have converged.\n', max_iter);
end
