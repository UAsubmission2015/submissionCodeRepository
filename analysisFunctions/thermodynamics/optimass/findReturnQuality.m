function [Q] = findReturnQuality(P3, T3, power1, power2, flow, P5)
%%%Density [kg/m^3] = findDensity(Pressure3 [bar], Temperature 3 [C], Power 1 [W], Power 2 [W], flow [g/s], local pressure [bar] )Calculates the density of the two phase fluid on the evaporator return
%%%line using the heater power and mass flow rate. P3 in bar abs, T3 in
%%%Celcius, Power in W, flow in 
%Convert to refprop units
cd('../optimass')
P3=P3*100; %kPa
P5=P5*100; %kpa
T3=T3+273; %K
flow=flow/1000;

%Calculate enthalpy before expansion valve on manifold loop.
cd('../REFPROP')
h3=refpropm('H','T',T3,'P',P3,'CO2');

%Calculate change in enthalpy during evaporation.
dh=(power1+power2)/flow;

%calculate new enthalpy on return line.
h4=h3+dh;

%Determine density
D=refpropm('D','P',P5,'H',h4,'CO2');

%Determine Phase
Q=refpropm('Q','P',P5,'H',h4,'CO2');
cd('../optimass')
end