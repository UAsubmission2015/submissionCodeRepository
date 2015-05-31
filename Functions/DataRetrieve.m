function [ WriteData ] = DataRetrieve(Tmin,Tmax,label,ExtractOption)
%dataread find the requested data in the existing data files and
%returns the all the : data=DataRetrieve(Tmin,Tmax,{'all';'TLTT101.temp';'TLPT101';'TL'});
% 'all'=all labels in datafile, 'TL'= all TL labels, 'TLTT101.temp'=
% specific label.
% It calculates as well the average, min and max value over tha time period
% The data, min, max and average are returned as substructures.
% data extract option is 1 then extract data to variables
% Tmin=cellstr(Tmin);
% Tmax=cellstr(Tmax);
 StartPath=pwd;    %Current path
%cd ..               %Root directory of test campaign

TestPath=pwd;       %Root directory of test campaign
eval(['cd ',StartPath]); % Change back to CSV directory 
MatlabDataPath=[TestPath,'\MatlabTestData']; %definition of mat file data storgae path
 
files = dir([MatlabDataPath,'\Data*).mat']);   
 for x=1:length(files)
      StartDate(x,1:20)=[files(x,1).name(5:6),'-',files(x,1).name(7:9),'-20',files(x,1).name(10:11),' '...
          ,files(x,1).name(13:14),':',files(x,1).name(15:16),':',files(x,1).name(17:18)];
       EndDate(x,1:20)=[files(x,1).name(21:22),'-',files(x,1).name(23:25),'-20',files(x,1).name(26:27),' '...
          ,files(x,1).name(29:30),':',files(x,1).name(31:32),':',files(x,1).name(33:34)];
 end
 
 StartDateOrg=StartDate;
 EndDateOrg=EndDate;
 
 StartDate=datestr(sort(datenum(StartDate)));
 EndDate=datestr(sort(datenum(EndDate)));
 
 for w=1:length(StartDate(:,1));
     for v=1:length(StartDateOrg(:,1));
         if strcmp(StartDate(w,:),StartDateOrg(v,:))==1;
             FileLocation(w)=v;
         end
     end
 end
     
 % check date chronology
 StartNum=datenum(StartDate);
 EndNum=datenum(EndDate);
 for x=2:length(StartDate(:,1));
     if StartNum(x)<EndNum(x-1)
         disp('Time of files are overlapping')
         error
     end
 end
 
 DateLimits=datenum([StartDate;EndDate]);
 if datenum(Tmin)<datenum(StartDate(1,:))
     Tmin=StartDate(1,:);
 end
 if datenum(Tmax)>datenum(EndDate(end,:))
     Tmax=EndDate(end,:);
 end
Tmin=cellstr(Tmin);
Tmax=cellstr(Tmax);
 DateLimits=sort(DateLimits);
 IntervalData={};
                            
        TimeSearchArray=abs(DateLimits(:,1)-datenum(Tmin))+DateLimits(:,1)-datenum(Tmin);
        Nmin=ceil(find(TimeSearchArray,1,'first')/2);
        
        TimeSearchArray=abs(DateLimits(:,1)-datenum(Tmax))+DateLimits(:,1)-datenum(Tmax);
        Nmax=floor(find(TimeSearchArray,1,'first')/2);
        if isempty(Nmax)==1
            Nmax=length(TimeSearchArray)/2;
        end
        if Nmin==Nmax
            eval(['load ' MatlabDataPath '\' files(FileLocation(Nmin),1).name ' FinalData'])
            %eval(['load ' pwd '\MatlabTestData\' files(Nmin,1).name ' FinalData'])
            %label={'TLTT101.temp';'SAPT101'}
        %label={'all';'TLTT101.temp'};
        elseif Nmin<Nmax;
            for q=Nmin:Nmax
                eval(['load ' MatlabDataPath '\' files(FileLocation(q),1).name ' FinalData'])
                if q==Nmin 
                    TempData=FinalData;    
                else
                    IntTime=(TempData.data(end,1)+ FinalData.data(1,1))/2;
                    IntRow=NaN(1,length(FinalData.data(1,:)));
                    IntRow(1,1)=IntTime;
                    FinalData.data=[TempData.data;IntRow;FinalData.data];
                    TempData=FinalData;
                end
            end
        
        else
            disp('No Data Available in Requested Time Interval');
            FinalData.data=[0,0;0,0];
            FinalData.info={'NoData','NoData'};
            FinalData.label={'NoData','NoData'};
            
        end
        labelpos=1;
            for x=1:length(label(:,1));
                if strcmp(label(x,1),'all')==1;
                    label(x,1)={''};
                else
                end
                l=length(label{x,:});
                for y=2:length(FinalData.data(1,:));
                    if strcmp(label(x,1),FinalData.label{1,y}(1:l))==1;
                        labelpos=[labelpos,y];
                    else
                    end

                end
            end
            
            for x=1:length(labelpos);
                y=labelpos(1,x);
                SortData.data(:,x)=FinalData.data(:,y);
                SortData.info(:,x)=FinalData.info(:,y);
                SortData.label(:,x)=FinalData.label(:,y);
            end
        
        IntervalData=steadydata(SortData,Tmin,Tmax,0);
        
       if  ExtractOption==1
       WriteData=extract(IntervalData); 
       else
           WriteData=IntervalData;
       end
end

