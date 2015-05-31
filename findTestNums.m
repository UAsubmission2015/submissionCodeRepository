%Manage testnums
function [testnums]=findTestNums(Test,Temp,Flow,demandT,demandF)
%%%<Author> May 2015
%%%[test numbers]=findTestNums(demand Temperature [C], demand Flow Rate [g/s]
%%%Imports the test log file and returns the numbers of tests meeting the
%%%input conditions.

rawTests=[];
for i=1:length(Test)
    if demandT==Temp(i) && demandF==Flow(i)
        rawTests(end+1)=Test(i);
    end
end
testnums=rawTests;
end
