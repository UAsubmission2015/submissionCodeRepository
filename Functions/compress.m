function [ CompressedData ] = compress( InputData,dT )
CompressedData=InputData;
CompressedData.data=[];
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
dT=dT/60/60/24;
q=0;
CompressedData.data(1,:)=InputData.data(1,:);
y=2;
 for x=2:length(InputData.data(:,1))

    if q==0;
    T1=InputData.data(x-1,1);
    T2=T1+dT;
    q=1;
    end

    if InputData.data(x,1)<T2;
    else
        CompressedData.data(y,:)=InputData.data(x,:);
        y=y+1;
        q=0;
    end
    
    
    LoopProgress=x/length(InputData.data(:,1))*100;
    clc
    disp(['Compress data to ', num2str(dT*60*60*24), ' seconds interval']);
    
    
    disp(['step ',num2str(x),' of ',num2str(length(InputData.data(:,1))),'(',num2str(LoopProgress),'%)']);
    toc;
end



end


