function [span] = findSteadyStateSpan( matrix,noise,futureSample,max)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
temp=max;
[row,column]=size(matrix);
for j=1:column
    attempt=findLargestForwardStable(matrix(:,j),noise,futureSample,max)
    if attempt<temp
        temp=attempt;
    end
end
span=temp;

end

