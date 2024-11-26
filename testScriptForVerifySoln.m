%% Example code for using the verifySoln function
% Suggestions: Append the following code at the end of your code to verify 
% whether you are getting correct solutions. You should use variables that 
% you compute to replace the zeros in different rows of the sol vector, and
% call the function verifySoln.
% If you choose to hard-code the elements in sol with numbers, make sure
% that you keep 4 decimal places to avoid misreporting. 

% set alpha and beta values based on your initials
alpha = 22; % V is 22 
beta = 18;  % R is 18

% provide your solutions to the questions in the project
% solution to some questions should be provided using two values
% the tolerance for the verification function is 0.001
% please keep enough significant digits when you report the solutions
sol = [ 0 % item 1: voltage rms at bus 4 in p.u.;
        0; % item 2: voltage phase angle at bus 4 in rad;
        0; % item 3: real power generation at bus 2 in MW;
        0; % item 4: reactive power generation at bus 2 in MVAr;
        0; % item 5: total real power generation within this system in MW;
        0; % item 6: real power leaving bus 1 towards bus 3 in MW;
        0; % item 7: reactive power leaving bus 1 towards bus 3 in MVAr;
        ];
    
verifySoln(alpha, beta, sol)    