function [D, Q] = findReturnDandQ2(P3, T3, power1, power2, flow, T5)
%%%[Density [kg/m^3],Quality] = findDensity(Pressure3 [bar], Temperature 3 [C], Power 1 [W], Power 2 [W], flow [g/s], local temperature [C])
%%%Calculates the density of the two phase fluid on the return line using
%%%the manifold supply conditions, heater power, reference (liquid) flow
%%%rate and local temperature in the instrument. Temperature is used to
%%%calculate local pressure in 2-phase.
%<Author> April 2015
%Convert to refprop units
cd('../optimass')
P3=P3*100; %kPa
T5=T5+273;%kpa
T3=T3+273; %K
flow=flow/1000;

cd('../REFPROP')
%Calculate local pressure at instrument: the saturation P at T5
P5=refpropm('P','T',T5,'Q',0.5,'CO2');

%Calculate enthalpy before expansion valve on manifold loop.
h3=refpropm('H','T',T3,'P',P3,'CO2');

%Calculate change in enthalpy during evaporation.
dh=(power1+power2)/flow;

%calculate new enthalpy on return line.
h5=h3+dh;

%Determine density
D=refpropm('D','P',P5,'H',h5,'CO2');

%Determine Phase
Q=refpropm('Q','P',P5,'H',h5,'CO2');
cd('../optimass')
end