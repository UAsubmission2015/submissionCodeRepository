function [var1,var2] = createSubSet(processedData,testNum,variable1, variable2)
%[var1, var2] =createSubSet(processed data matrix, test number, str variable 1,
%str variable 2)
%%%<Author> April 2015
%%%Creates a subset of the processed data matrix returning the demanded
%%%variables only within the demanded test.
[rows, columns]=size(processedData);
indexVec=[];
for i=1:rows
    if ismember(processedData(i,1),testNum)
        indexVec(end+1)=i;
        
    end
end
%THESE ARE THE UNIQUE STRING IDENTIFIERS FOR ORIGINAL AND CALCULATED
%SIGNALS - THEY MUST BE USED TO CALL SIGNALS FOR PLOTS
varStrings={'Test','Flow','Temp','FT3020','EHDL1','EHDL2','PT7024','TT7024','PT7450','FT7524','DT7424','TT7424','PT7056','TT7056','absFlowError','Relative Flow Error','expectedDensity','Vapour Quality','absDensityError','Relative Density Error','measuredVelocity','predictedVelocity','sensorFlowVelocity','Optimass Vapour Quality','absVQerror','Relative Vapour Quality Error','Gas Velocity'};
columnsOfInterest=[];
for j=1:length(varStrings)
    if strcmp(varStrings{j},variable1)
        columnsOfInterest(end+1)=j;
    end
end
for j=1:length(varStrings)
    if strcmp(varStrings{j},variable2)
        columnsOfInterest(end+1)=j;
    end
end
var1=processedData(indexVec,columnsOfInterest(1));
var2=processedData(indexVec,columnsOfInterest(2));
end

