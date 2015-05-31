function [ velocity ] = calculateFlowVelocity(massFlow,density,diameter)
%[velocity [m/s]]= calculateFlowVelocity( massFlow [g/s], density [kg/m^3],
%pipe diameter [mm])
%   Returns flow velocity
%Convert to SI units.
massFlow=massFlow/1000;%kg/s
diameter=diameter/1000;%m

area=pi()*diameter^2/4;
volumetricFlowRate=massFlow/density;
velocity=volumetricFlowRate/area;

end

