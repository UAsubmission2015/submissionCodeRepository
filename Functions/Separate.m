
for x=1:length(data.label(1,:));                   % read labels
     namedata = data.label{1,x};
    
     eval([namedata ' = data.data(:,x);']);         % define single array with name is label
     %ReadData.label{1,x}=namedata;
     LoopProgress=x/length(data.label(1,:))*100;
    clc
    disp('Separate variables from data ');
    disp(namedata);
    
    disp(['step ',num2str(x),' of ',num2str(length(data.label(1,:))),'(',num2str(LoopProgress),'%)']);
     clear name namedata
     
 end;
disp('renumber date of to Matlab definition');
Time.Day=DateTimeDays;                               % Set days time vector
Time.Hour=(Time.Day-floor(Time.Day(1))).*24;         % Set hours time vector
Time.Min=Time.Hour.*60;                              % Set minutes time vector
Time.Sec=Time.Min.*60;                               % Set seconds time vector
Time.Date=datestr(Time.Day);                         % Set date vector in date strings        
