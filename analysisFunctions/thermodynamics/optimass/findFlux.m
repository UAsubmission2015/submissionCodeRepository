function [flux]=findFlux(flowRate)
CSA=1.0053e-04;%m^2
flow=flowRate/1000;
flux=flow/CSA;
end
