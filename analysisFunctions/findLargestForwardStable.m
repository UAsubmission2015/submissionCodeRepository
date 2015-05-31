function [index] = findLargestForwardStable(vector,noise,futureSample,max)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
index=max;
for i=1:(length(vector)-futureSample)
    currentVector=vector(i:(i+futureSample))
    if isForwardStable(currnetVector,i,noise,futureSample)==false
        index=i;
        break
    end
end



end

