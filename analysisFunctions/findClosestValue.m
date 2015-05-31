function [index] = findClosestValue(vector, value)
%[index] = findClosestValue(input vector, key)
%%% Returns the index of a value in an input vector closest to the
%%% requested value. Do not input vectors with repeating numbers.
tempVector=vector-value;
[closest, index]=min(abs(tempVector));

end

