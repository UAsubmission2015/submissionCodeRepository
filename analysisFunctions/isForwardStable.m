function [boolean] = isForwardStable( vector,index,noise,futureSample )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
boolean=withinRange(vector,mean(vector(index:(index+futureSample))));

end

