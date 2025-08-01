function dx = CART(t, x, p)
    dx = zeros(8,1);

    dx(1) = -p(1) * (x(4) / (p(12) + x(4))) * x(1) - p(2) * x(1);
    dx(2) = p(3) * (x(4) / (p(12) + x(4))) * x(1) + p(4) * (x(4) / (p(12) + x(4))) * x(2) ...
            - p(5) * (1 - (x(4) / (p(12) + x(4)))) * x(2) + p(6) * (x (4) / (p(12) + x(4))) * x(3) ...
            - p(7) * x(2);
    dx(3) = p(5) * (1 - (x(4) / (p(12) + x(4)))) * x(2) - p(6) * (x(4) / (p(12) + x(4))) * x(3) ...
            - p(8) * x(3);
    dx(4) = p(9) * x(4) * (1 - (x(4) + x(5)) / p(10)) - p(11) * (x(2) / (p(13) + x(2))) * x(4);
    dx(5) = p(9) * x(5) * (1 - (x(4) + x(5)) / p(10)) - p(20) * p(11) * (x(2) / (p(13) + x(2))) * x(5);
    dx(6) = p(15) - (p(21) * (x(4) / (p(12) + x(4))) * x(2) + p(22) * (x(2) / (p(13) + x(2))) * (x(4) + p(20) * x(5)) ...
            + p(23) * (x(7) / (p(14) + x(7))) * x(2)) * x(6) - p(16) * x(6);
    dx(7) = (p(21) * (x(4) / (p(12) + x(4))) * x(2) + p(22) * (x(2) / (p(13) + x(2))) * (x(4) + p(20) * x(5)) ...
            + p(23) * (x(7) / (p(14) + x(7))) * x(2)) * x(6) - p(16) * x(7);
    dx(8) = p(17) + p(18) * x(7) - p(19) * x(8);
end