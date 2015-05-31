%Script: autoProcess
%Tym Pakulski 
%May 2015
%tsp26@bath.ac.uk
homeDirectory=pwd;
timestampsPath=[homeDirectory,'/timestamps'];
testLogPath=[homeDirectory,'/testlog'];
%Import the steady-state timestamps.
importTimestamps;
createTimeFilter3;

processData;
