function [ boolean ] = withinRange(vector,value,noise)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
boolean=false;
if abs((value-mean(vector))/mean(vector))<noise
    boolean=true;
end


end

