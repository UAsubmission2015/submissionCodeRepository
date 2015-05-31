%SCRIPT createTimeFilter3*************************************************
%<Author> May 2015
%Imports steady state timestamps and implements a foreword scanning
%algorithm to identify steady-state intervals. averaging the data across
%these intervals to return a single state vector for each desired time
%step.


%USER INPUT*********************************************************
%Define the maximum allowable time interval in forward averaging, to
%override the steady-state idntification algorithm.
%Define allowable noise level for data  to be considered steady state
%points
%Define number of points to be grabbed at a time and averaged to assess
%stability.
%Define data vectors to evaluate for stability.
maxTimeInterval=30;%seconds
allowableNoise=.01; % 1%
forwardHandful=3; %points
%Signals to evaluate for steady-state conditions.
dataToFilter=[FT3020.PosSt,FT7524.PosSt,EHDL1.PosSt.*EHDL2.PosSt,DT7424.PosSt];
%END USER INPUT*****************************************************

%Define timestamps path
homeDirectory=pwd;
timestampsPath=[homeDirectory,'/timestamps'];
importTimestamps; %Calls the path defined above^
%Merge time and date into a single float value.
ssStamps=ssDates+ssTimes;
maxTimeIntervalInDays=maxTimeInterval/86400;%86400 seconds per day

%Define a matrix with all raw data.
allData=[FT3020.PosSt,EHDL1.PosSt,EHDL2.PosSt,PT7024.PosSt,TT7024.PosSt,PT7450.PosSt,FT7524.PosSt,DT7424.PosSt,TT7424.PosSt,PT7056.PosSt,TT7056.PosSt];
%Change directory for our data analysis functions.
cd analysisFunctions
%Define a vector that will hold the indeces of all the steady state
%timestamps in the raw data.
indexVector=[];
%Populate the index vector by comparing ss-timestamps to time data in
%database.
for i=1:length(ssStamps)
   indexVector(end+1)=findClosestValue(Time.Day,ssStamps(i));
end
%The reach vector exists parallel to the index vector, each index housing
%the last steady state value going forward in time from the steady-state
%timestamp.
reachVector=[];
%Populate Reach Vector with maximum values.
for i=1:length(indexVector)
    reachVector(i)=findClosestValue(Time.Day,(ssStamps(i)+maxTimeIntervalInDays));
end
%override reach vector values with steady state values.
for i=1:length(reachVector)
    dataSubSet=dataToFilter(indexVector(i):reachVector(i));
    reachVector(i)=indexVector(i)+findSteadyStateSpan(dataSubSet,allowableNoise,forwardHandful,(reachVector(i)-indexVector(i)));
end
[rows, columns]=size(allData);
%create empty matrix with dimension of number of columns and ss timestamp
%rows.
cleanUnlabeled=zeros(length(indexVector),columns);
for column=1:columns %iterate through each column of cleanUnlabeled
    for row=1:length(indexVector) %iterate through each row.
        handFull=[indexVector(row):1:reachVector(row)];
        cleanUnlabeled(row,column)=mean(allData(handFull,column));
    end
end
%Define new steady-state data vectors
FT3020.Clean=cleanUnlabeled(:,1);
EHDL1.Clean=cleanUnlabeled(:,2);
EHDL2.Clean=cleanUnlabeled(:,3);
PT7024.Clean=cleanUnlabeled(:,4);
TT7024.Clean=cleanUnlabeled(:,5);
PT7450.Clean=cleanUnlabeled(:,6);
FT7524.Clean=cleanUnlabeled(:,7);
DT7424.Clean=cleanUnlabeled(:,8);
TT7424.Clean=cleanUnlabeled(:,9);
PT7056.Clean=cleanUnlabeled(:,10);
TT7056.Clean=cleanUnlabeled(:,11);
%collect steady state signals in a single matrix.
cleanData=[Test,Flow,Temp,FT3020.Clean,EHDL1.Clean,EHDL2.Clean,PT7024.Clean,TT7024.Clean,PT7450.Clean,FT7524.Clean,DT7424.Clean,TT7424.Clean,PT7056.Clean,TT7056.Clean];
cd ..