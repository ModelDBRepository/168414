

%clear all
%close all

T = 1000.0;  % stimulation period [ms]
Nstim = 15;  % number of stimuli
tzone = 100; %
tstart = 1000;   % stimuli start time [ms]

fid = fopen('WindUp\T_Cell_1_Times.dat');
data = fread(fid, 'double');
fclose(fid);
%data = load('wdr_spike_times_CTRL.dat');
%data = load('wdr_spike_times_Triplets.dat');
data = data - tstart;

x = mod(data,T);
y = floor(data/T)+1;

figure, 
axes('FontSize', 14)
scatter(x,y,'.k')

xlim([0 500])
set(gca, 'YTick', [0 3 6 9 12 15 18])
counter = zeros(Nstim,1);

t0 = 0;
s = 1;
for i=1:size(x,1)
	
	if y(i) > Nstim
		break;
	end
    
    if x(i) > t0
        if x(i) > tzone
            counter(s) = counter(s) + 1;
        end
    else
        s = s + 1;
    end
    
    t0 = x(i);
    
end

figure

plot(counter/counter(1),'-x')    
out = counter/counter(1);