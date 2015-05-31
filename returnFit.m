function [xAxis,curve]= returnFit(var1,var2,order)
%%% [xAxis,curve]=returnFit(var1,var2,order)
%%%<author> 2015
%%% Returns an nth order curve given input variables and desired variable. 
%%% Curve defined by a linspace vector and corresponding y values.
stepSize=(max(var1)-min(var1))/100;
xAxis=min(var1):stepSize:max(var1);
p=polyfit(var1,var2,order);
curve=polyval(p,xAxis);
end
