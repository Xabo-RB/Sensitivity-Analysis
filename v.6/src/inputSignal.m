function u = inputSignal(t, t_u, u_vec)

    if t < t_u(1) || t > t_u(end) %Por si estuviera fuera del intervalo
        u = interp1(t_u, u_vec, t, 'linear', 'extrap');
    else
        u = interp1(t_u, u_vec, t, 'linear');
    end
    
end