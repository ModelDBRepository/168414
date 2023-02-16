This folder contains the necessary NEURON files to reproduce the data
shown in Fig. 3a (Wind-Up), Fig. 5b (A-fiber Inhibition), and Fig. 7C
(Foreman SCS, or single pulses of SCS with accompanying peripheral
input) in Zhang TC et al., J Neurophysiology (2014).  "WindUp" and "A
Fiber Inhibition" feature the model architectures without surround
inhibition.  "Foreman SCS" features the model architecture with
surround inhibition.

Transient-firing and Delayed-firing interneurons shown in Figure 2 can
be substituted into the network by copying the associated cell
template from the "Transient_Delayed_Firing_Variants" folder.

.mod files defining membrane currents and synaptic properties are
located in the "Critical Mod Files" folder.

In addition, Excel files listing the source, destination, weight,
synaptic delay, and reversal potentials of all connections in the
model in the order that they are fed into NEURON (respectively via the
files "FromVector.txt", "ToVector.txt", "WeightVector.txt",
"DelayVector.txt", and "ERevVector.txt") are included.  Query the
"nclist" object in the NEURON command line to check/confirm
connectivities.

Spike trains to be applied to each A and C fiber input to the model
are also included ("SpikeTimesVector.txt").  Please note that due to
the way NEURON imports external spike trains, EACH INDIVIDUAL SYNAPSE
is connected to its own "S_Netstim" object, and there are more
S_Netstim objects than the 15 A-Beta, 15-Adelta, and 30 C-fibers
listed in the paper; to get around this limitation, synapses connected
to S_Netstim objects with the same index on a given cell
(e.g. AMPA_DynSyn[15] and NMDA_DynSyn[15]) are set to correspond to
the same "input fiber" and therefore receive the same spike train.

PLEASE NOTE THAT MOST VISUALIZATION WAS DONE IN MATLAB USING THE
".DAT" TRANSMEMBRANE POTENTIAL AND SPIKE TIME OUTPUTS FROM "RunSim"
SCRIPTS.  As such, this model cannot be run in the web browser.
However, the MATLAB code required to generate the relevant plots has
been included in this package.

Specific Notes below:


Wind-Up: Run "Shell."  Note that surround inhibition is NOT
implemented here.


A Fiber Inhibition: Run "Shell".  Note that surround inhibition is
implemented in the network (in case one wishes to assess what Local +
Surround inhibition with A-fiber inhibition would look like) but that
no spikes (within time range; spikes are set to start at t = 1e9) are
fed into those inputs during the simulation time frame.


Foreman: Simply run "Shell" and files will output as they need to.


Fig 3a in "WindUp" directory.
Fig 5b in "A Fiber Inhibition" directory.
Fig 7c in "Foreman SCS" directory.

Updated 2/16/23 to include B_Adapt.mod
