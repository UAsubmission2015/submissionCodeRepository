% CSVimport(Tmin,Tmax,argument) reads CSV files in the currednt direcrtories 
% from PVSS and combines them by filling the
% empty spaces with previous values. It removes the double time stamps.
% The argument determs the filling of the first empty value. 
% 0 = 0.0123456789, other numbers is the last value from the previous data
% file in \MatlabTestData\
% First Values of -0.0123456789 are due to a difference in length of the
% processed file and previous file.
% Tmin is the minimum requested date and time, Tmax the maximum requested
% date and time. Date string must be written as: '04-Oct-2009 1:00:00'

function [FinalData] = CSVimport(Tmin,Tmax,dT,argument,MultipleDataHandler,Statistic)

if nargin==2;
    dT=1;
    argument=0;
    MultipleDataHandler='a';
    Statistic=1;
elseif nargin<2;
    Tmin='01-Jan-2000 0:00:00';
    Tmax='01-Jan-2020 0:00:00';
    dT=0;
    argument=0;
    MultipleDataHandler='a';
    Statistic=1;
end

tic;
toc;
CSVDataPath=pwd;    %Path of the raw CSV data
%cd ..
cd ..               %Root directory of test campaign
mkdir MatlabTestData   %Creatiuon of \MatlabTestData for mat file storage
TestPath=pwd;       %Root directory of test campaign
eval(['cd ',CSVDataPath]); % Change back to CSV directory 
MatlabDataPath=[TestPath,'\MatlabTestData']; %definition of mat file data storgae path

if argument==0;         %load previous data file if previous value matching is asked
else
    files = dir([MatlabDataPath,'\Data*).mat']);   % List the existing data files

    eval(['load ',MatlabDataPath,'\' files(end,1).name ' FinalData']); % Read the last data file
 
   
end  
                 
DataSize=[0 1];                                  %Set Master matrix size
ProcData.info(1,1)={'Da_teTimeDays'};
files = dir([pwd '\*.csv']);
FileType='csv';

if isempty(files)==1
    files = dir([pwd '\*.mat']);
    FileType='mat';
end

% Find CSV files for import
for x=1:length(files);

    
     if strcmp(files(x,1).name(1,end-5),'_')==1;
     else
        if strcmp(FileType,'csv')==1;

            TempData=importdata(files(x,1).name);        % Load individual CSV file
            if length(TempData.textdata(:,1))>2
                for q=2:length(TempData.textdata(1,:))
                %TempData.colheaders{1,q}=TempData.textdata{1,q};   
                TempData.colheaders{1,q}=TempData.textdata{2,q};
                end
                
                TimeVector=datenum(TempData.textdata(3:end,1))-datenum('30-Dec-1899');
                TempData.data=[TimeVector,TempData.data];
            end
        elseif strcmp(FileType,'mat')==1;
            clear Label
            load(files(x,1).name);

            TempData.data=MATdata;
%            for q=1:length(Label);
%                
%                Header{1,q}=[Label{1,q},'  ',OrgHeader{1,q}];
%            end
%            
           if exist('Label','var')==1
            TempData.colheaders=[' ',OrgHeader;' ',Label];
           else
             TempData.colheaders=[' ',OrgHeader;' ',OrgHeader];  
           end 
            
        end
%         
%         %%%%% for testing (limit matrix to 1000)
%         SZ=floor(length(TempData.data(:,1))/10000);
%         e=1;
%         clear compData
%        for c=[1,2:SZ:length(TempData.data(:,1))-1,length(TempData.data(:,1))]
%            
%            compData.data(e,:)=TempData.data(c,:);
%            e=e+1;
%        end
%         TempData.data=compData.data;
%          %%%%%%%%%%%end for testing
        
        disp(['import of ',files(x,1).name]);
        Row=DataSize(1);                             %Last Row of existing matrix
        Col=DataSize(2);                             %Last Column of existing matrix
        RowQty=length(TempData.data(:,1));           %Qty of Rows of loaded CSV flie  
        ColQty=length(TempData.data(1,:));           %Qty of Columns of loaded CSV flie  

        ProcData.data(Row+1:Row+RowQty,1)=TempData.data(:,1);                         %Filling in CSV time data in master matrix
        ProcData.data(Row+1:Row+RowQty,Col+1:Col+ColQty-1)=TempData.data(:,2:ColQty); %Filling in CSV data in master matrix
        ProcData.data(Row+1:Row+RowQty,2:Col)=NaN(RowQty,Col-1);                      %Filling remaining fields with NaN data
        ProcData.data(1:Row,Col+1:Col+ColQty-1)=NaN(Row,ColQty-1);                    %Filling remaining fields with NaN data
        ProcData.info(1,Col+1:Col+ColQty-1)=TempData.colheaders(1,2:ColQty);         %Fill Header Labels

        DataSize=size(ProcData.data);                %Determine new master matrix size
        toc;
     end
    
%      if ProcData.data(1,1)>datenum(Tmin)-datenum('30-Dec-1899');
%          Tmin=datestr(ProcData.data(1,1)+datenum('30-Dec-1899'));
%      end
%      
%      if ProcData.data(end,1)<datenum(Tmax)-datenum('30-Dec-1899');
%          Tmax=datestr(ProcData.data(end,1)+datenum('30-Dec-1899'));
%      end
end
disp(['Master Data file Created']);
toc;
%clear Col ColQty Row RowQty DataSize  files x TempData
disp('Sorting time vector');
ProcData.data=sortrows(ProcData.data);          %Sort Data on time
toc;
% Master matrix produced

% Fill in NaNs and remove double time stamps.
TimeStatus(1,1)=1;

for x=2:length(ProcData.data(:,1));
    LoopProgress=x/length(ProcData.data(:,1))*100;
    clc
    disp('Finding double time stamps');
    toc
    disp(['step ',num2str(x),' of ',num2str(length(ProcData.data(:,1))),'(',num2str(LoopProgress),'%)']);
    if ProcData.data(x,1)==ProcData.data(x-1,1)          %If time x is equal to previous time
        TimeStatus(x,1)=TimeStatus(x-1,1);                 %Fill time status vector with equal number
    else
        TimeStatus(x,1)=TimeStatus(x-1,1)+1;               %Fill time status vector with 1 extra
    end
end

% Do DataStatistic
if Statistic==1;
   DeadBand=ProcData.data*NaN;
   DeadBandSum=zeros(1,length(ProcData.data(1,:)));
   PrevValue=ProcData.data(1,:);
   Counter=ProcData.data(1,:);
   Counter=abs(isnan(Counter)-1);
    for x=2:length(ProcData.data(:,1));
       LoopProgress=x/ProcData.data(end,1)*100;
       clc
       disp('Statistic Analyses');
       toc
       disp(['step ',num2str(x),' of ',num2str(length(ProcData.data(:,1))),'(',num2str(LoopProgress),'%)']);

       for y=2:length(ProcData.data(1,:))
            if isnan(ProcData.data(x,y))==0

                DeadBand(x,y)=ProcData.data(x,y)-PrevValue(y);
                if isnan(DeadBand(x,y))==0;
                DeadBandSum(y)=DeadBandSum(y)+abs(DeadBand(x,y));
                end
                PrevValue(y)=ProcData.data(x,y);
                Counter(y)=Counter(y)+1;
            end
       end
    end  
    %    Counter=Counter(:,2:end);
%    DeadBand=DeadBand(:,2:end);
%    DeadBandSum=DeadBandSum(1,2:end);

   for y=1:length(Counter)
       ValueReport.max(y)=max(abs(DeadBand(:,y)));
       ValueReport.min(y)=min(abs(DeadBand(:,y)));
       ValueReport.avr(y)=DeadBandSum(y)/(Counter(y)-1);
       ValueReport.exist(y)=100*Counter(y)/length(DeadBand(:,y));
   end
end


nl=0;                                                      %initial value of time(x)
ReducedData=NaN(TimeStatus(end),length(ProcData.data(1,:)));

for x=1:TimeStatus(end);
    LoopProgress=x/TimeStatus(end)*100;
    clc
    disp('Filling NaNs');
    toc
    disp(['step ',num2str(x),' of ',num2str(TimeStatus(end)),'(',num2str(LoopProgress),'%)']);
    nf=nl+1;                                            % first value of time(x)
    nq=length(TimeStatus);                              % last value of time all
    if x==TimeStatus(end);
        nl=nq;                                          % set nl to last to prevent empty cell
    else
        nl=find(TimeStatus(nf:nq)-x,1,'first')-2+nf;    % last value of time(x)
    end

    for y=2:length(ProcData.data(1,:));                % Fill in NaNs with single value of same time stamps
        MinValue=min(ProcData.data(nf:nl,y));          % find minimum value in same timestamp
        MaxValue=max(ProcData.data(nf:nl,y));          % find maximum value in same time stamp
        if isnan(MaxValue);                             % If all NaN than previous value
            if nf==1;
                if argument==0
                ProcData.data(nf:nl,y)=0.0123456789;
                else                                   % sets previous demanded value to -0.0123456789 if previous data has a different amount of values
                    if length(FinalData.data(1,:))==length(ProcData.data(1,:));
                    ProcData.data(nf:nl,y)=FinalData.data(end,y);
                    else
                        ProcData.data(nf:nl,y)=-0.0123456789;
                        disp('DataFiles have not the same length');
                    end
                end
            else
            ProcData.data(nf:nl,y)=ProcData.data(nf-1,y);
            end
        else
            if MinValue==MaxValue;                      % Min and max must be the same, 1 value must be present
                ProcData.data(nf:nl,y)=MaxValue;
            else
                disp([ProcData.info{1,y},' has multiple values at time: ',num2str(ProcData.data(nl,1)),' with min and max values being:',num2str(min(ProcData.data(nf:nl,y))), ' and ',num2str(max(ProcData.data(nf:nl,y)))]);
                if strcmp(MultipleDataHandler,'NotDefined')==1;
                question=input('Indicate which value to take [min, max, avr, stop]','s');
                else question=MultipleDataHandler;
                end
                if strcmp(question,'min')==1;
                    ProcData.data(nf:nl,y)=MinValue;
                elseif strcmp(question,'max')==1;
                    ProcData.data(nf:nl,y)=MaxValue;
                elseif strcmp(question,'avr')==1;
                    ProcData.data(nf:nl,y)=mean([MinValue,MaxValue]);
                    elseif strcmp(question,'a')==1;
                    ProcData.data(nf:nl,y)=mean([MinValue,MaxValue]);
                else
                error % if more than 1 value per time stamp, than stop program, repair csv file at indicated label
                end
            end
        end
       
    end
    clear FinalData
    ReducedData(x,:)=ProcData.data(nf,:);              % remove double time stamps
end
clear ProcData.data;
ProcData.data=ReducedData;
ProcData.data(:,1)=ProcData.data(:,1)+datenum('30-Dec-1899');    %Modify excell time format to Matlab format
clear ReducedData MaxValue MinValue x y nf nl nq TimeStatus LoopProgress
toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for q=1:length(files)+1;
    if ProcData.data(2,1)-ProcData.data(1,1)>6.944444e-4*60; %If 1st time is more than 10 minutes earlier than remove
       ProcData.data=ProcData.data(2:end,:);
    end
    if ProcData.data(end,1)-ProcData.data(end-1,1)>6.944444e-4*60; %If last time is more than 10 minutes earlier than remove
       ProcData.data=ProcData.data(1:end-1,:);
    end
end
    
TimeSearchArray=abs(ProcData.data(:,1)-datenum(Tmin))+ProcData.data(:,1)-datenum(Tmin);  %Reduces data between Tmin and Tmax
    Nmin=find(TimeSearchArray,1,'first');
    TimeSearchArray=abs(ProcData.data(:,1)-datenum(Tmax))+ProcData.data(:,1)-datenum(Tmax);
    Nmax=find(TimeSearchArray,1,'first')-1;
    if Nmax>0;
      
    else
     Nmax=length(ProcData.data(:,1));   
    end
    ProcData.data=ProcData.data(Nmin:Nmax,1:end);
    clear TimeSearchArray Nmax Nmin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for x=1:length(ProcData.info(1,:));                   % read labels
    
   
            name = ProcData.info{1,x};
             point=locate(name,'.');
             len=length(name);
             if isempty(point)

             elseif len-point(1)>4
                 space=locate(name,' ');
                 if isempty(space)==1
                     name=name;
                 else
                     name=name(1:space(1)-1);
                 end
             end

        %      name1=name;
        %      for w=1:length(name)-4;
        %         if strcmp(name(w),'.')==1
        %         name1 = name(1:w+4);
        %         end
        %      end
        %         name=name1;
    
    
     if strcmp(name(3),'_')==1
        namedata = [name(1:2),name(4:end)];
     else
         namedata = name;   
     end
%      eval([namedata ' = ProcData.data(:,x)']);         % define single array with name is label
     ProcData.label{1,x}=namedata;
     LoopProgress=x/length(ProcData.info(1,:))*100;
    clc
%     disp('Separate variables from data ');
    disp(namedata);
    toc
    disp(['step ',num2str(x),' of ',num2str(length(ProcData.info(1,:))),'(',num2str(LoopProgress),'%)']);
     clear name namedata files
 end;
% disp('renumber date of to Matlab definition');
% Time.Day=DateTimeExcl;                               % Set days time vector
% Time.Hour=(Time.Day-floor(Time.Day(1))).*24;         % Set hours time vector
% Time.Min=Time.Hour.*60;                              % Set minutes time vector
% Time.Sec=Time.Min.*60;                               % Set seconds time vector
% Time.Date=datestr(Time.Day);                         % Set date vector in date strings        
% toc;    

% ProcData.Time=Time;

ProcData=compress(ProcData,dT);

FinalData=extract(ProcData);
if Statistic==1;
    FinalData.ValueReport=ValueReport;
end
clear DateTime LoopProgress x ProcData space q point len e dT compData c ans TempData SZ RowQty Row ProcData OrgHeader MATdata LoopProgress Label DataSize ColQty Col 


eval(['save ',MatlabDataPath,'\Data' FinalData.Time.Date(1,1:2),FinalData.Time.Date(1,4:6),FinalData.Time.Date(1,10:11),'(',FinalData.Time.Date(1,13:14),FinalData.Time.Date(1,16:17),FinalData.Time.Date(1,19:20),')_',FinalData.Time.Date(end,1:2),FinalData.Time.Date(end,4:6),FinalData.Time.Date(end,10:11),'(',FinalData.Time.Date(end,13:14),FinalData.Time.Date(end,16:17),FinalData.Time.Date(end,19:20),')']);

toc;

FileName=[MatlabDataPath,'\Data' FinalData.Time.Date(1,1:2),FinalData.Time.Date(1,4:6),FinalData.Time.Date(1,10:11),'(',FinalData.Time.Date(1,13:14),FinalData.Time.Date(1,16:17),FinalData.Time.Date(1,19:20),')_',FinalData.Time.Date(end,1:2),FinalData.Time.Date(end,4:6),FinalData.Time.Date(end,10:11),'(',FinalData.Time.Date(end,13:14),FinalData.Time.Date(end,16:17),FinalData.Time.Date(end,19:20),')'];
for x=1:length(FinalData.Time.Date(:,1))
    dateS{x,1}=FinalData.Time.Date(x,:);
    dateN(x,1)=FinalData.data(x,1)-datenum('30-Dec-1899');
end   
a=1;
for x=1:65000:length(dateS);
    y=x+65000-1;
    if y>length(dateS)
        y=length(dateS);
    end
    Sheet=['Data',num2str(a)];
    xlswrite(FileName,FinalData.info,Sheet,'B1');
    xlswrite(FileName,FinalData.label,Sheet,'B2');
    xlswrite(FileName,dateS(x:y),Sheet,'A3');   
    xlswrite(FileName,FinalData.data (x:y,2:end),Sheet,'C3');
    xlswrite(FileName,dateN(x:y),Sheet,'B3');
    a=a+1;
end
if Statistic==1;
    Sheet='Statistics';
    xlswrite(FileName,FinalData.label',Sheet,'A2');
    
    
    StatisticText={'Average Deadband';'Maximum Deadband';'Minimum Deadband';'Data Occurence (%)'};
    xlswrite(FileName,StatisticText',Sheet,'B1');
    StatisticValues=[ValueReport.avr;ValueReport.max;ValueReport.min;ValueReport.exist];
    xlswrite(FileName,StatisticValues',Sheet,'B2');
    xlswrite(FileName,['-','-','-','-','-'],Sheet,'A2');
end
end
