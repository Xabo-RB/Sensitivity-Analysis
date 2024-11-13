clear

%% INITIAL VALUES FOR INTEGRATION
    % initial values
x0 = complex([0, 0, 0, 0], 0); 
    % step size and time interval in days
d = 1.0e-16; 
tspan = 0.0:0.05:50;
p = complex([0.61, 0.0055, 0.0011, 0.001, 5, 1, 0.094], 0);

% Parameter of interest:
pI = 4;
% State variable for the sensitivity analysis
SS = 4;

% (Initial conditions, parameters, step size, time interval, ODE MODEL)
% Solution -> Cell array / {nº of states}(derivatives with respect to which parameter) 
% i.e. {2}(0) = x2 without derivative / {2}(2) = dx2/dtheta1 and so on
solution = sensitivityMain(x0, p, d, tspan, @ODESerialTrig); 



%% PARAMETER TO STUDY WITHIN A RANGE

    % --------------- i.e. EFFECTIVE RATE -----------------------------
% Vector for that parameter (range)
keffVect = 0.0001:0.0005:0.5;

pI = pI + 1;
results_matrix = zeros(length(keffVect), length(solution{1}(:, 1))); 
for i = 1:length(keffVect)
    
    % -> Change the element in parameter vector for an element of the parameter interval
    p = complex([0.61, 0.0055, 0.0011, keffVect(i), 5, 1, 0.094], 0);
    
    % ->(Initial conditions, parameters, step size, time interval, ODE MODEL)
    solution = sensitivityMain(x0, p, d, tspan, @ODESerialTrig);

    % -> Select the parameter and the state you are interested in solution{4}(:, 5)
    SolResponse = solution{SS}(:, pI); 
    newSol = (SolResponse .* keffVect(i)) ./ solution{SS}(:, 1); 

    % En la fila que define un valor de koff
    results_matrix(i, :) = newSol;
end

inferno = csvread('inferno_colormap.csv');
%inferno = flipud(inferno);
figure; 
% imagesc(tspan, koffVect, results_matrix); 
% results_matrix = log10(results_matrix); results_matrix = real(results_matrix); NO
%results_matrix = log10(abs(results_matrix));
imagesc(tspan, keffVect, results_matrix); 
colormap(inferno);
cb = colorbar;
cb.Label.String = 'Sensitivity';
xlabel('Time (s)');
ylabel('Dissociate rate (koff)');
title('Serial Triggering');
set(gca, 'YDir', 'normal');
hold on



%plot(tspan,solution{1}(:,1))

function dydt = myODEFunction(t, x, p)
    dydt = [-p(1) * x(1) + p(2) * x(2);
            p(3) * x(1) - p(4) * x(2)];
end

function dx = ODESerialTrig(t, x, p)
    dx = zeros(4,1);
    dx(1) = -p(1) * p(2) * (x(1) - x(2)) + p(3) * (1 - x(1));
    dx(2) = p(2) * (x(1) - x(2)) + p(3) * (1 - x(2)) - p(4) * (x(2)^p(5)) * (p(6)^p(5));
    dx(3) = p(4) * (x(2)^p(5)) * (p(6)^p(5)) - p(7) * x(3);
    dx(4) = x(1) / (p(1) + 1) + ((x(2) + x(3)) * p(1) / (p(1) + 1));
end
