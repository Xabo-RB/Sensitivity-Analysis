function solution = sensitivityMain1(x0, p, d, tspan, odeFunction, solver, rel_tol, abs_tol)
    % sensitivityMain: Computes the sensitivities of a dynamic system 
    % with respect to its parameters.
    %
    % Input:
    %   x0          - Initial vector of initial conditions (initial state).
    %   p           - Parameter vector of the model.
    %   d           - Small scalar for complex perturbation.
    %   tspan       - Integration interval [t_initial, t_final].
    %   odeFunction - Handle or name of the ODE system function.
    %
    % Output:
    %   solution - Cell array where each element contains:
    %       - First column: Solution of the system without perturbation.
    %       - Subsequent columns: Sensitivities with respect to each parameter.

    if nargin < 8 % esto es para que sensitivitymain1() tenga los 8 argumentos y si no pues que te salte error, si te olvidaste de poner solver, tolerancias... (al parecer funciona así)
        error('This function must be called with 8 arguments.');
    end

    if ~isvector(x0) || ~isnumeric(x0)
        error('x0 must be a numeric vector.');
    end
    if ~isvector(p) || ~isnumeric(p)
        error('p must be a numeric vector.');
    end
    if ~isscalar(d) || d <= 0
        error('d must be a positive scalar.');
    end
    if ~isvector(tspan) || tspan(1) >= tspan(2)
        error('tspan must be defined differently.');
    end
    if ~isa(odeFunction, 'function_handle')
        error('odeFunction must be a function handle.');
    end
    solver_handle = str2func(func2str(solver));

    % Esto es para cambiar las tolerancias desde main también, que antes se
    % repetían 2 veces (dentro y fuera del buvle, y no hace falta):

    options = odeset('RelTol', rel_tol, 'AbsTol', abs_tol, 'Refine', 1);


    % Esto es para generalizar el solver y poderlo llamar desde el archivo
    % principal:
    [~, x] = solver_handle(@(t,y)odeFunction(t, y, p), tspan, x0, options);

    lp = length(p);
    lx = length(x0);
    ls = size(x, 1);

    % esto son dos bucles que había antes, unido en uno solo
    solution = cell(1, lx);
    for i = 1:lx
        solution{i} = zeros(ls, lp + 1);
        solution{i}(:, 1) = x(:, i);
    end

    for j = 1:lp
        p(j) = p(j) + d * 1i;
        neg = @(t, y) odeFunction(t, y, p);
        [~, xPert] = solver_handle(neg, tspan, x0, options); % cambio esto para que admita el cambio de solver de antes
        
        p(j) = real(p(j));
        xSens = imag(xPert) ./ d;

        for k = 1:lx
            solution{k}(:, j + 1) = xSens(:, k);
        end

    end
end