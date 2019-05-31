%MassPlotter_WoolfWall.m

%Program is designed to plot Woolf and Wall epicenters/time constants based
%on "Subdirectory" organization.

clear
%close all
%CHANGEBLOCK
%Load vital variables
filenameA = 'SG_Cell';
filenameB = 'T_Cell';
SourceID = {'A', 'C'};
%RunIndex =1:100;
%NumRuns = 100;
NumCells = 1;
DirType = {''}
Interval = 1000;
%[GuideNums GuideNames] = xlsread('RunRecordSheet.xls');
%GuideVector = [0.1 0.2 0.5 1 2 5 10 20 50 100];
%SpikeBasisMain = 'CEX_Parameterization_10Tau';
%Due to size of EP Files, only load times specified within TimeRange with a
%specified dt
%CHANGEBLOCK
PlotTitle = 'Woolf and Wall'
RunToPlot = 2; 

tend = 221000;

%Step 2: Load SG and T cell spike times.
for M = 1:length(DirType)
    filenameA = 'SG_Cell';
    filenameB = 'T_Cell';
for a = 1:NumCells 
    fid = fopen(['A Fiber Inhibition\' filenameA '_' num2str(a) '_Times.dat']);
    TempVar = fread(fid, 'double');
    eval([filenameA num2str(a) 'Times = TempVar;'])
    eval([filenameA num2str(a) 'IndexTracker = zeros(1, length(TempVar))+(2.*a-1);']);
    fclose(fid);
    fidB = fopen(['A Fiber Inhibition\' filenameB '_' num2str(a) '_Times.dat']);
    TempVar2 = fread(fidB, 'double');
    eval([filenameB num2str(a) 'Times = TempVar2;'])
    eval([filenameB num2str(a) 'IndexTracker = zeros(1, length(TempVar2))+(2.*a);']);
    fclose(fidB);
    disp('PRINT')
    
end

%Need to split Spike Times into vectors corresponding to "Interval" sized
%blocks.

NumRows = ceil(tend./Interval)
for m = 1:NumRows
    eval([filenameA num2str(a) 'TimesSeg' num2str(m) ' = [];']);
    eval([filenameA num2str(a) 'IndexSeg' num2str(m) ' = [];']);
    eval([filenameB num2str(a) 'TimesSeg' num2str(m) ' = [];']);
    eval([filenameB num2str(a) 'IndexSeg' num2str(m) ' = [];']);
end
    
if isempty(TempVar)==0
    for n = 1:length(TempVar)
        RowIndex = ceil(TempVar(n)./Interval);
        Placement = 221-ceil(TempVar(n)./Interval);
        eval([filenameA num2str(a) 'TimesSeg' num2str(RowIndex) ' = [' filenameA num2str(a) 'TimesSeg' num2str(RowIndex) ' TempVar(n)];']);
        eval([filenameA num2str(a) 'IndexSeg' num2str(RowIndex) ' = [' filenameA num2str(a) 'IndexSeg' num2str(RowIndex) ' ' num2str(Placement) '];']);
    end
end

if isempty(TempVar2)==0
    for n = 1:length(TempVar2)
        RowIndex = ceil(TempVar2(n)./Interval);
        Placement =221-ceil(TempVar2(n)./Interval);
        eval([filenameB num2str(a) 'TimesSeg' num2str(RowIndex) ' = [' filenameB num2str(a) 'TimesSeg' num2str(RowIndex) ' TempVar2(n)];']);
        eval([filenameB num2str(a) 'IndexSeg' num2str(RowIndex) ' = [' filenameB num2str(a) 'IndexSeg' num2str(RowIndex) ' ' num2str(Placement) '];']);
    end
end


%Raster Plots.  For now, use stem plots (idea from David Brocker) with no
%marker, solid lines spanning zone between index corresponding to 1 below
%cell and 1 at cell.  For single SG/T cell analyses, Cell 1 = SG cell, Cell
%2 = T Cell (Outputs)
%For inputs:
%Cell 1 = A Inputs
%Cell 2 = C Inputs 

figure(M+8)
clf
hold on
for a = 1:NumCells
    %If loops ensure that empty matrices (i.e. silent cells) don't stop the routine.
    for b = 1:NumRows
    if isempty(eval([filenameA num2str(a) 'TimesSeg' num2str(b)]))==0
    A = stem(eval([filenameA num2str(a) 'TimesSeg' num2str(b) './1000-(b-1)']), eval([filenameA num2str(a) 'IndexSeg' num2str(b)]), 'BaseValue', eval([filenameA num2str(a) 'IndexSeg' num2str(b) '(end)-0.75']), 'Marker', 'none')
    baseline_handle = get(A,'BaseLine');
    set(baseline_handle,'Color','w');
    set(A, 'Color', 'k')
    end
    end
end
xlim([0 0.18])
ylim([1 tend/1000])
ylabel([filenameA ' Spikes (' num2str(Interval/1000) 's Intervals)'])
title(['Output Activity: ' char(PlotTitle) ' SG'])

figure(M+9)
clf
hold on
for a = 1:NumCells
    for b = 1:NumRows
    if isempty(eval([filenameB num2str(a) 'TimesSeg' num2str(b)]))==0
    B = stem(eval([filenameB num2str(a) 'TimesSeg' num2str(b) './1000-(b-1)']), eval([filenameB num2str(a) 'IndexSeg' num2str(b)]), 'BaseValue', eval([filenameA num2str(a) 'IndexSeg' num2str(b) '(end)-0.75']), 'Marker', 'none', 'LineWidth', 2)
    baseline_handle = get(B,'BaseLine');
    set(baseline_handle,'Color','w');
    set(B, 'Color', 'k')
    end
    end
end
xlim([0 0.18])
ylim([1 tend/1000])
ylabel([filenameB ' Spikes (' num2str(Interval/1000) 's Intervals)'])
title(['Output Activity: ' char(PlotTitle) ' WDR'])

%saveas(gcf, [char(PlotTitle) '_Pair_' num2str(a) '_Output_Raster.png'], 'png')


%Analyze number of spikes per section.  NOTE: current assumption that each
%"section" is 1 second long.  In addition, "early" fiber response will be
%defined as the first 100 ms of each section, and "late' fiber response
%will be defined as everything past 100ms.  These time ranges are set
%according (roughly) to delay times between A fiber and C fiber signal
%arrival. (A fibers: mean 30ms, SD 10 ms; C fibers: mean 275 ms, SD 75ms).

%Reference values: total number of spikes (as expressed by lengths
%of total spike time vector for SG and T Cells). 

DidItWork = 1;
end