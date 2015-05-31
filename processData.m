%<Author> April 2015
%processes steady-state date to calculate error signals and thermodynamic
%properties of interest.
%processData
%Calculated signals
%Flow error calculation.
absFlowError=FT7524.Clean-FT3020.Clean;
relFlowError=absFlowError./FT3020.Clean;
%Calculating from REFPROP
cd analysisFunctions
cd thermodynamics
cd optimass
expectedDensity=[];
VQ=[];
for i=1:length(PT7450.Clean)
    [expectedDensity(end+1),VQ(end+1)] = findReturnDandQ2(PT7024.Clean(i),TT7024.Clean(i),EHDL1.Clean(i),EHDL2.Clean(i),FT3020.Clean(i),TT7424.Clean(i));
end
%Transpose property vectors
expectedDensity=expectedDensity';
VQ=VQ';
%calculate error signals
absDensityError=DT7424.Clean-expectedDensity;
relDensityError=absDensityError./expectedDensity;
measuredVelocity=[];
predictedVelocity=[];
sensorFlowVelocity=[];
%calculate aggregate flow velociteis
for i=1:length(PT7450.Clean)
    measuredVelocity(end+1) = calculateFlowVelocity(FT3020.Clean(i),DT7424.Clean(i),8);
    predictedVelocity(end+1)=calculateFlowVelocity(FT3020.Clean(i),expectedDensity(i),8);
    sensorFlowVelocity(end+1)=calculateFlowVelocity(FT7524.Clean(i),DT7424.Clean(i),8);
end
measuredVelocity=measuredVelocity';
predictedVelocity=predictedVelocity';
sensorFlowVelocity=sensorFlowVelocity';
%navigate to REFPROP directory
cd ..
cd REFPROP
%Calculate Optimass VQ signals
optimassVQ=[];
for i=1:length(VQ)
    optimassVQ(end+1)=refpropm('Q','T',(273+TT7424.Clean(i)),'D',DT7424.Clean(i),'CO2');
end
optimassVQ=optimassVQ';
absVQerror=optimassVQ-VQ;
relVQerror=absVQerror./VQ;
cd ../Optimass
%Calculate gas phase velocities
gasVolumetricFlow=zeros(length(VQ),1);
gasVelocity=zeros(length(VQ),1);
for i=1:length(VQ)
    if VQ(i)>0.001 && VQ(i)<1
        %Calculate gas velocity
        gasVelocity(i)=findGasVelocity(FT3020.Clean(i),VQ(i),TT7424.Clean(i),1.0053e-04);
    end        
end
%collect data in a single output matrix for saving
processedData=[cleanData,absFlowError,relFlowError,expectedDensity,VQ,absDensityError,relDensityError,measuredVelocity,predictedVelocity,sensorFlowVelocity,optimassVQ,absVQerror,relVQerror,gasVelocity];
%save the new database
cd ..
cd ..
cd ..
mkdir('postProcessedData');
cd postProcessedData
fileName=num2str(datenum(datestr(clock,0)));
mkdir(fileName);
cd(fileName)
save processedData
cd ..
cd ..