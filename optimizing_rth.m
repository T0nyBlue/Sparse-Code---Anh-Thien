function [output] = optimizing_rth(sigma_mu, P1, P)
    P1_init = 2e-4;
    p1_init = 1.02e-4;
    p0_init = 1e-6;
    Pr = (p1_init - P1_init/2)/(1 - P1_init/2);
    P0 = 2*p0_init/(1 - Pr);
    
    p0 = P0/2*(1 - Pr);
    q0 = (1 - P0/2) + P0/2 * Pr;
    p1 = P1/2 + (1 - P1/2) * Pr;
    q1 = (1 - P1/2) * (1 - Pr);
    
    mu_0 = 1;
    mu_1 = 2;

    sigma_0 = mu_0*sigma_mu;
    sigma_1 = mu_1*sigma_mu;

    a = sigma_0^2 - sigma_1^2;
    b = 2*(mu_0*sigma_1^2 - mu_1*sigma_0^2);
    c = sigma_0^2*mu_1^2 - sigma_1^2*mu_0^2 + 2*sigma_1^2*sigma_0^2*log(((1-P)*p1 - P*q0)/(P*p0 - (1-P)*q1)*sigma_1/sigma_0);

    delta = b^2 - 4*a*c;
    output = ((-b+sqrt(delta))/(2*a));
    if output <= 0
        output = ((-b-sqrt(delta))/(2*a));
    end
end