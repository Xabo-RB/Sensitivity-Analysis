function dx = HIV(t, x, p)
    dx = zeros(3,1);

    dx(1) = p(1) - x(1)*p(2) - x(1)*x(3);
    dx(2) = x(1)*x(3) - x(2)*p(4);
    dx(3) = p(3)*x(2)*p(4) - x(3)*p(5);
end
