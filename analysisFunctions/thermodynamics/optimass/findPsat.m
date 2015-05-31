function [Psat] = findPsat(Tsat)
%[Psat [bar]] = findPsat(Tsat [C])
%   Returns the saturation pressure for a given temperature of 2-phase CO2

%REFPROP Unit conversions
Tsat=273+Tsat;%K

%Navigate to REFPROP directory
cd ..
cd REFPROP

Psat=refpropm('P','T',Tsat,'Q',0.5,'CO2'); %kpa

%Convert to practical units.
Psat=Psat/100;%bar

%navigate home
cd ..
cd Optimass
end

