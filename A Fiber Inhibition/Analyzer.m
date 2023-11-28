function DidItWork = Analyzer(NumCells, filenameA, filenameB, filenameC, filenameD, PlotTitle, dt)
%Analyzer.m
%Function "Processes" data generated using NEURON network simulation
%programs.  Each .dat file is presumably the spike raster for each neuron,
%BUT this can be changed according to the simulation desired.
%INPUTS: 
%NumCells = number of cells for which there is data.
%filenameA = file 1 to open for analysis.
%filenameB = file 2 to open for analysis
%PlotTitle = title for spike plot.
%dt: delta t used in NEURON to run simulations.
%OUTPUTS:
%All relevant data.
%DidItWork Checksum, if needed.

for a = 1:NumCells
    
    fid = fopen([filenameA '_' num2str(a) '.dat']);
    TempVar = fread(fid, 'double');
    assignin('base', [filenameA '_' num2str(a) '_Vm'], TempVar); %Spike Timing.  X-axis in plots
    assignin('base', [filenameA '_' num2str(a) '_Time'], ((1:length(TempVar))-1).*dt); %Index to time via multiplication by dt.
    fclose(fid);
    fidB = fopen([filenameB '_' num2str(a) '.dat']);
    TempVar2 = fread(fidB, 'double');
    assignin('base', [filenameB '_' num2str(a) '_Vm'], TempVar2); %Spike Timing.  X-axis in plots
    assignin('base', [filenameB '_' num2str(a) '_Time'], ((1:length(TempVar2))-1).*dt); %Index to time via multiplication by dt.
    fclose(fidB);
    fidC = fopen([filenameC '_' num2str(a) '.dat']);
    TempVar3 = fread(fidC, 'double');
    assignin('base', [filenameC '_' num2str(a) '_Vm'], TempVar3); %Spike Timing.  X-axis in plots
    assignin('base', [filenameC '_' num2str(a) '_Time'], ((1:length(TempVar3))-1).*dt); %Index to time via multiplication by dt.
    fclose(fidC);
    fidD = fopen([filenameD '_' num2str(a) '.dat']);
    TempVar4 = fread(fidD, 'double');
    assignin('base', [filenameD '_' num2str(a) '_Vm'], TempVar4); %Spike Timing.  X-axis in plots
    assignin('base', [filenameD '_' num2str(a) '_Time'], ((1:length(TempVar4))-1).*dt); %Index to time via multiplication by dt.
    fclose(fidD);
    disp('PRINT')
    
end
figure(1)
for a = 1:NumCells

assignin('base', 'TVector', evalin('base', [char(filenameA) '_' num2str(1) '_Time']));

clf
hold on
subplot(4,1,1)
plot(evalin('base', [filenameA '_' num2str(a) '_Time']), evalin('base',[char(filenameA) '_' num2str(a) '_Vm']), '-r')
subplot(4,1,2)
plot(evalin('base', [filenameB '_' num2str(a) '_Time']), evalin('base',[char(filenameB) '_' num2str(a) '_Vm']), '-g')
ylabel('Vm (mV) ')
subplot(4,1,3)
plot(evalin('base', [filenameC '_' num2str(a) '_Time']), evalin('base',[char(filenameC) '_' num2str(a) '_Vm']), '-b')
subplot(4,1,4)
plot(evalin('base', [filenameD '_' num2str(a) '_Time']), evalin('base',[char(filenameD) '_' num2str(a) '_Vm']), '-b')
xlabel('Time (ms)')
axis([0 length(evalin('base',[char(filenameB) '_' num2str(a) '_Vm'])).*dt -80 40])
title([PlotTitle ' Cell ' num2str(a) ' Voltage'])
saveas(gcf, [char(filenameA) '_Pair_' num2str(a) '_Vm.png'], 'png')
end

DidItWork = 1;

