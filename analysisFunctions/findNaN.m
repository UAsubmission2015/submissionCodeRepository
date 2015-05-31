function [booleanVec] = findNaN(inputMatrix)
%[boolean vector] = findNaN(input matrix)
%   Looks through a data set for the value 0.0123, returns a binary vector
%   that is low at every index where NaN was found in any column of the
%   matrix.

[rows columns]=size(inputMatrix);
booleanVec=ones(rows,1);
for i=1:columns
    %iterating through each column
    for j=1:rows%iterating through each row
        if inputMatrix(j,i)==.0123
            booleanVec(j)=0;
            j
        end
    end
end



end

