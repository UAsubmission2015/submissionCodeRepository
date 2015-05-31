% The steadydata command takes the interval data between Tmin and Tmax and 
% returns the same data format between the limits. It also returns the
% lowest, highest and average value of all the datapoints

function[IntervalData]=steadydata(ReadData,Tmin,Tmax,MinMaxAvr)      
TimeSearchArray=abs(ReadData.data(:,1)-datenum(Tmin))+ReadData.data(:,1)-datenum(Tmin);
    Nmin=find(TimeSearchArray,1,'first');
    TimeSearchArray=abs(ReadData.data(:,1)-datenum(Tmax))+ReadData.data(:,1)-datenum(Tmax);
    Nmax=find(TimeSearchArray,1,'first')-1;
    if isempty(Nmax)==1
        Nmax=length(ReadData.data(:,1));
    end
    IntervalData=ReadData;
    IntervalData.data=ReadData.data(Nmin:Nmax,1:end);
    IntervalData.min=NaN(1,1);
    IntervalData.max=NaN(1,1);
    IntervalData.avr=NaN(1,1);
    IntervalData.std=NaN(1,1);
  if MinMaxAvr==1  
        for x=2:length(IntervalData.data(1,:));
            IntervalData.min(1,x)=min(IntervalData.data(:,x));
            IntervalData.max(1,x)=max(IntervalData.data(:,x));
            [IntervalData.avr(1,x),IntervalData.std(1,x)]=MeanWithNaN(IntervalData.data(:,x));
            
        end
  end 
end
