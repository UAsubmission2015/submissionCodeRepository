%SCRIPT -generatePlots2
%%%<Author> May 2015
%%%calls the plotTests functions to create various figures of interest,
%%%manage their dimensions, export them and save them in the correct
%%%directory. It only plots the nominal test conditoins defined in the vectors
%%%'flows' and 'temps'.

importTestLog;
%OVERVIEW - all flows and temperatures*********************************
flows=[20:10:90,105];
temps=[-25,-20,-10,-5,0,5];
%Figure 1: relative flow error against vq for all test conditions.
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Flow Error',0)
cd figureExport
%Maximise figure window
set(gcf,'units','normalized','outerposition',[0 0 1 1])
%Export figure to 'plots' directory.
export_fig ../plots/fig1.png
cd ..
%Figure 2: same with density error
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Density Error',0)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig2.png
cd ..

%Flow Trend - T=-10***************************************************
temps=[-10];
flows=[20,30,40,50,60,70,80,90,105];
%Figure3: relative flow error against vq for all test conditions.
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Flow Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig3.png
cd ..
%Figure 4: same with density error
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Density Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig4.png
cd ..
%Figure 5: Vapour phase velocity
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Gas Velocity',1)
%Append units for gas velocity!
ylabel('Vapour Phase Velocity [m/s]','FontSize',16)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig12.png
cd ..

%Temperature Trend - Flow = 70 g/s**************************************
flows=[70];
temps=[-25,-20,-10,-5,0,5,10];
%Figure 6- Flow Error
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Flow Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig5.png
cd ..
%Figure 7 - Density Error
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Density Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig6.png
cd ..

%Temperature  Trend - Flow = 30 g/s
flows=[30];
temps=[-25,-20,-10,-5,0,5,10];
%Figure 6- Flow Error
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Flow Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig7.png
cd ..
%Figure 7 - Density Error
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Density Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig8.png
cd ..
%Figure 8 - VQ Error
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Vapour Quality Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig9.png
cd ..

%Vapour Quality Error at 20 g/s**************************************
flows=[20];
plotTests(processedData,Test,Temp,Flow,flows,temps,'Vapour Quality','Relative Vapour Quality Error',1)
cd figureExport
set(gcf,'units','normalized','outerposition',[0 0 1 1])
export_fig ../plots/fig10.png
cd ..

