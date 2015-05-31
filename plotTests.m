function [void]= plotTests(processedData,Test,Temp,Flow,flows,temps,variable1,variable2,trendLines)
%%% [void]=plotTests(processedData,Test,Temp,Flow,flows,temps,variable1,variable2,trendLines)
%%% processedData- matrix generated by the script 'processData'
%%% Test, Temp, Flow - vectors generated by the script 'importTestLog'.
%%%                     After running 'importTestLog', use inputs:
%%%                     'Test','Temp' and 'Flow'. These are vectors in the
%%%                     workspace generated by 'importTestLog'.
%%% flows,temps - user input: the nominal flows [g/s] and temperatures [C] to be plotted.
%%%                 i.e. [20,30,50] and [-25,-20,-5]
%%% variable1, variable2- Strings identifying the variables to be plotted. 
%%%                     SCADA signals are called with the format <signal>.Clean, i.e. 'FT3020.Clean'
%%%                     calculated signals are identified with the unique
%%%                     strings generated in the script 'processData'. for
%%%                     example: 'Vapour Quality' and 'Relative Flow Error'
%%%                     trendLines: 1 to add 5th-order trendlines. 0 if not
%%%                     desired.
%%%<Author> May 2015
%%%Automatically generates figures to plot various trends of demand
%%%variables. Organises plots depending on user input by evaluating number
%%%of flows and temperatures. If trendLines=1, adds 5th order polynomial
%%%fit.

%USER SETTINGS***********************************************************
curveOrder=5; %The order of the polynomials calculated to fit curves to the data.
fontSize=16;
legendLocation='Southeast';%See 'help legend'
%**********************************************************************

%Housekeeping*****************************************************
masterColorVec={'r','g','b','k','c','r','g','b','k','c','r','g','b','k','c'};
masterMarkerVec={'o','x','+','s','d','v','p','h','>'};
flowLength=length(flows);
tempLength=length(temps);
caseString='both';
legendText={};
plotHandles=[];
%****************************************************************

%Input dimension handling to decide plot set up
if flowLength>1 && tempLength<2
    caseString='flows';
elseif flowLength<2 && tempLength>1
    caseString='temps'
end

figure;
switch caseString
    case 'both'
        disp('Both!')
        %No trendlines, dual nested loop, calling subset each time, overall
        %trends
        for i=1:tempLength
               
            for j=1:flowLength
                marker=masterMarkerVec{j};
                color=masterColorVec{j};
                testnums=findTestNums(Test,Temp,Flow,temps(i),flows(j));
                [var1,var2]=createSubSet(processedData,testnums,variable1,variable2);
                mark=strcat(color,marker);
                if length(testnums)>=1 
                    plotHandles(end+1)=plot(var1,var2,mark);
                    hold on
                    if trendLines==1
                        [xAxis,curve]=returnFit(var1,var2,curveOrder);                 
                        plot(xAxis,curve,color);
                    end
                    legendText{end+1}=[num2str(temps(i)),' C, ', num2str(flows(j)),' g/s'];
                end
                testnums=[];
            end
        end
        title([variable2, ' against ',variable1, ' for various test conditions'],'FontSize',fontSize)
        
    case 'flows'
        %one temperature, several flows.
        %makeplot2: uses differentcolor set up
        disp('Multi flows')
        for i=1:tempLength
            for j=1:flowLength
                color=masterColorVec{j};
                marker=masterMarkerVec{j};
                testnums=findTestNums(Test,Temp,Flow,temps(i),flows(j));
                [var1,var2]=createSubSet(processedData,testnums,variable1,variable2);
                mark=strcat(color,marker);
                if length(testnums)>=1 
                    plotHandles(end+1)=plot(var1,var2,mark);
                    hold on
                    if trendLines==1
                        [xAxis,curve]=returnFit(var1,var2,curveOrder);                 
                        plot(xAxis,curve,color);
                    end
                    legendText{end+1}=[num2str(temps(i)),' C, ', num2str(flows(j)),' g/s'];
                end
                testnums=[];
            end
        end
       
        title([variable2, ' against ',variable1, ' for various flow rates at ' num2str(temps(1)),' C Nominal temperature'],'FontSize',fontSize)
        
    case 'temps'
        %one flow, several temperatures.
        disp('multi temps')
    
        for i=1:tempLength
            for j=1:flowLength
                color=masterColorVec{i};
                marker=masterMarkerVec{i};
                testnums=findTestNums(Test,Temp,Flow,temps(i),flows(j));
                [var1,var2]=createSubSet(processedData,testnums,variable1,variable2);
                mark=strcat(color,marker);
                if length(testnums)>=1
                    plotHandles(end+1)=plot(var1,var2,mark);
                    hold on
                    if trendLines==1
                        [xAxis,curve]=returnFit(var1,var2,curveOrder);                 
                        plot(xAxis,curve,color);
                    end
                    legendText{end+1}=[num2str(temps(i)),' C, ', num2str(flows(j)),' g/s'];
                end
                testnums=[];
            end
        end
        title([variable2, ' against ',variable1, ' for various temperatures at ',num2str(flows(1)),' g/s nominal'],'FontSize',fontSize)
end
xlabel(variable1,'FontSize',fontSize)
ylabel(variable2,'FontSize',fontSize)
legend(plotHandles,legendText,'Location',legendLocation)
        
   
        
end
