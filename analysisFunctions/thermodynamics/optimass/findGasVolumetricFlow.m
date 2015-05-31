function [ volumetricFlow ] = findGasVolumetricFlow(massFlow,VQ,Temp)
%%%[gas volumetric flow rate [m^3/s]]=findGasVolumetricFlow(massFlowRate[g/s],vapour quality
%%%[decimal], saturation temperature [C])
%   Returns the volumetric flow rate of the gas phase in a saturated fluid.
%   
%REFPROP Units
massFlow=massFlow/1000;
Temp=Temp+273;

cd ..
cd REFPROP
gasDensity = refpropm('-','T',Temp,'Q',VQ,'CO2');
cd ..
cd Optimass

volumetricFlow=massFlow*VQ/gasDensity; %m^3/s

end

