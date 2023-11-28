%MassPlotter_NonSCS.m

%Program structured similarly to MassPlotter_SCS but meant to plot results
%from wind-up and Woolf/Wall tests conducted using new iteration of model.

%Run this AFTER Foreman simulation is done to generate plots.

clear
close all
%CHANGEBLOCK
%Load vital variables
filenameA = 'SGSCS_Cell';
filenameB = 'T_Cell';
SourceID = {'A', 'C'};
NumCells = 1;
Interval = 1000./1;
HeatMapBins = 10;
%[GuideNums GuideNames] = xlsread('RunRecordSheet.xls');
%GuideVector = [0.1 0.2 0.5 1 2 5 10 20 50 100];
%SpikeBasisMain = 'CEX_Parameterization_10Tau';
%Due to size of EP Files, only load times specified within TimeRange with a
%specified dt
dt = 0.0125;
NumVars = 3; %Number of variables (co)varied in experiment.
%CHANGEBLOCK
PlotTitle = 'Foreman Response'

tstart = 16000;
tend = 41000;

Foreman1_XAxis = [0 0.14 0.16 0.33 0.69 1.45]./1.17;
Foreman1_YAxis = [2.63 0.25 0.4 1.55 1.66 2.3]./2.63;

Foreman2_XAxis = [0 0.22 0.44 0.69 0.86 2.19 3.53 4.83]./4.39;
Foreman2_YAxis = [4.42 0.93 0.80 2.33 2.37 3.34 3.63 3.60]./4.42;

Foreman3_XAxis = [0 0.14 0.98 1.64 2.61 3.32]./3.2;
Foreman3_YAxis = [3.25 0 0 1.62 3.12 4.28]./3.25;

Foreman4_XAxis = [0 0.14 2.56 3.2]./3.25;
Foreman4_YAxis = [3.25 0 0 3.25*0.4]./3.25;


%Step 2: Load IN and WDR cell spike times.

%Run Folder Weight Type
%24 05 Inter
%33 05 Input
%35 2 Input
%44 2 Inter

TotalHist = zeros(1, length(0:HeatMapBins:Interval));
        
P = 1 %In other versions of code, multiple Foreman bar plots could be plotted at same time.  This is remnant of this; simplified for new users.
AllSpikesLumped = [];    

for a = 1:NumCells
    
    fid = fopen(['Foreman SCS\' filenameA '_' num2str(a) '_Times.dat']);
    TempVar = fread(fid, 'double');
    eval([filenameA num2str(a) 'Times = TempVar;'])
    eval([filenameA num2str(a) 'IndexTracker = zeros(1, length(TempVar))+(2.*a-1);']);
    fclose(fid);
    fidB = fopen(['Foreman SCS\' filenameB '_' num2str(a) '_Times.dat']);
    TempVar2 = fread(fidB, 'double');
    eval([filenameB num2str(a) 'Times = TempVar2;'])
    eval([filenameB num2str(a) 'IndexTracker = zeros(1, length(TempVar2))+(2.*a);']);
    fclose(fidB);
end
    

%Need to split Spike Times into vectors corresponding to "Interval" sized
%blocks.
WithinIntervalMean = zeros(1, 101);
for A = (tstart/Interval):(tend/Interval)
    WithinIntervalIndices = find((T_Cell1Times>(Interval*(A-1))).*(T_Cell1Times<(Interval*A)))';
    WithinIntervalSpikes = T_Cell1Times(WithinIntervalIndices)';
    WithinIntervalSpikes = WithinIntervalSpikes-(A-1)*Interval;
    AllSpikesLumped = [AllSpikesLumped WithinIntervalSpikes];
    if ~isempty(WithinIntervalSpikes)
    WithinIntervalBins = histc(WithinIntervalSpikes, (0:HeatMapBins:(Interval)));
    if mean(WithinIntervalBins(1:10))~=0
    WithinIntervalMean = 1./(length((tstart/Interval):(tend/Interval))).*(WithinIntervalBins./(mean(WithinIntervalBins(1:10))))+WithinIntervalMean;
    mean(WithinIntervalBins(1:10))
    end
    end
end

%Build PSTHs.
AllSpikesSorted = sort(AllSpikesLumped);
eval(['PreHist_Run' num2str(P) ' = histc(AllSpikesSorted, (0:HeatMapBins:(Interval)));']);
eval(['PreHist_Run' num2str(P) '_Mean = PreHist_Run' num2str(P) './mean(PreHist_Run' num2str(P) '(1:10));'])
if ~isempty(AllSpikesSorted);
TotalHist(P,:) = histc(AllSpikesSorted, (0:HeatMapBins:(Interval)));
else
    TotalHist(P,:) = zeros(1, length(0:HeatMapBins:Interval))
end
%TotalHistAvg(P,:) = eval(['PreHist_Run' num2str(P) '_Mean'])./(mean(TotalHist(P,(1:10)))).*100; %TotalHist(P,:)./(mean(TotalHist(P,(1:10)))).*100;
TotalHistAvg(P,:) = eval(['PreHist_Run' num2str(P) '_Mean']).*100;
TotalHist(:, 11) = TotalHist(:, 11)+25; %+25 consistent with Foreman et al. (1976) wherein large initial spike at SCS time included their artifact detections.

TotalHistAvg(:,11) = 100;

%Line plot.
figure
subplot(3,5,[3 4 7 8 ])
hold on
for R = [1]
plot(0:10:100, TotalHistAvg(R, (11:21)),'LineWidth', 2, 'Color', 'k')
end
plot(Foreman1_XAxis.*100, Foreman1_YAxis.*100,  'LineWidth', 2, 'Color', [0.7 0.7 0.7])
plot(Foreman2_XAxis.*100, Foreman2_YAxis.*100,  'LineWidth', 2, 'Color', [0.7 0.7 0.7])
plot(Foreman3_XAxis.*100, Foreman3_YAxis.*100,  'LineWidth', 2, 'Color', [0.7 0.7 0.7])
plot(Foreman4_XAxis.*100, Foreman4_YAxis.*100, 'LineWidth', 2, 'Color', [0.7 0.7 0.7])
plot([0 100], [100 100], '-k')

%axis equal
set(gca, 'XTick', [0 50 100])
set(gca, 'YTick', [0 40 80 120 160])
xlim([0 100])
ylim([0 180])
%Bar plot.
subplot(3, 5, [11:15])
bar((1:(length(TotalHist(R,:))-1)).*10, TotalHist(R,(1:100)), 'k')    
xlim([0 500])
ylim([0 60])





