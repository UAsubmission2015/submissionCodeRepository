function [ gasVelocity ] = findGasVelocity(massFlow,VQ,Temp,CSA)
%%%[flowVelocity [m/s]]=findFlowVelocity(volumetric Flow rate [m^3/s],
%%%cross-sectional area [m^2])
%   Returns the volumetric flow rate of the gas phase in a saturated fluid.
%   
volumetricFlowRate=findGasVolumetricFlow(massFlow,VQ,Temp);
gasVelocity=volumetricFlowRate/CSA;

end

