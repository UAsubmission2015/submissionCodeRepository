%<redacted author> April 2015

mkdir temp
mkdir processedCSV
CurrentDir=pwd;
addpath([CurrentDir,'\Functions\']);
files=dir('.\CSVfiles\*');
%Datae format: dd-Mmm-yyyy hh:mm:ss
Tmin='01-Jan-2000 1:00:00';
Tmax='01-Jan-2020 1:00:00';
argument=0;
for x=3:length(files);
   cd CSVfiles
   movefile(files(x).name, '.././temp/');
   cd ..
   cd temp
   data=CSVimport(Tmin, Tmax,0 ,argument,'a',0);
   argument=1;
   cd ..
   movefile ('./temp/*', './processedCSV/');
end
       