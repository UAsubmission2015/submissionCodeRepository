function [ element ] = locate( array,number )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for x=1:length(array)
    if array(x)==number;
        element(x)=1;
    else element(x)=0;
    end
end
element=find(element);
  



end

