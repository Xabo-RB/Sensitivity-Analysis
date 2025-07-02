function odeFunction = selectODEModel(modelName)
    % selectODEModel: Devuelve el handle de la función ODE basado en el nombre del modelo.
    %
    % Entrada:
    %   modelName - Nombre del modelo (string) ('model1', 'model2', etc.)
    %
    % Salida:
    %   odeFunction - Handle a la función ODE seleccionada.

    switch modelName
        case 'myODEFunction'
            odeFunction = @myODEFunction;
        case 'ODESerialTrig'
            odeFunction = @ODESerialTrig;
    end
end


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







