using LinearAlgebra
using DSP
using Random
using Plots
plotly()

#7.15 b) Numerical example. Generate a signal u of length m = 50, with each entry a random value
# that is either −1 or +1. Plot u and y = c ∗ u, with c = (1,0.7,−0.3). 
# Also plot the equalized signal z = h ∗ y, with h = (0.9, −0.5, 0.5, −0.4, 0.3, −0.3, 0.2, −0.1).

rng = MersenneTwister(1234);
u = shuffle(rng, Vector(1:50))
X = -1;
Y = +1;
C = findall(u.<=25);
D = findall(u.>25);
u[C] .= X;
u[D] .= Y;
c = [1,0.7,-0.3];
h = [0.9, -0.5, 0.5, -0.4, 0.3, -0.3, 0.2, -0.1];
y = conv(c,u);
z = conv(h,y);
plot(1:length(u),u)
plot(1:length(y),y)
plot(1:length(z),z)

#A7.1 Equalization in communication. Run the file channel_equalization_data.jl, which will define 
# a message s, a channel c, and an equalizer h. (Your are welcome to look inside the file to 
# see how we designed the equalizer.) Plot c, h, and h ∗ c. Make a brief comment about the channel
# and equalized channel impulse responses. Plots,y,and y ̃over the index range i=1,...,100. 
# Is it clear from this plot that sˆ=round(y1:N) eq will be worse estimate of s than
# sˆ = round(y ̃1:N )? Report the BER for sˆ (estimating the message without equalization), 
# and for sˆ (estimating the message with equalization).

include("channel_equalization_data.jl")
hc = conv(h,c);
y = conv(c,s);
y_tilda = conv(h,y);

plot(1:length(c), c)
plot(1:length(h), h)
plot(1:length(hc), hc)

plot(1:length(s[1:100]), s[1:100])
plot(1:length(y[1:100]), y[1:100]) 
plot(1:length(y_tilda[1:100]), y_tilda[1:100])

s_cap = 1*(y .> 0.5);
s_cap_eq = 1*(y_tilda .> 0.5);

BER = sum( broadcast(abs, s_cap[1:1000]-s))/1000;
BER_eq = sum( broadcast(abs, s_cap_eq[1:1000]-s))/1000;
println("Bit Error rate for non-equilized transmission signal: ",BER)
println("Bit Error rate for equilized transmission signal: ",BER_eq)

#A7.3 Audio filtering. When the vector x represents an audio signal, and h is another (usually much shorter) vector, 
# the convolution y = h ∗ x is called the filtered version of x, and h is called the filter impulse response. 
# Filters can be used to smooth out audio signals (which reduces high frquency sounds and enhances low frequency sounds), 
# or to sharpen them (which enhances high frequency sounds and reduces low frequency sounds), as in audio bass 
# and treble tone controls. In this problem you will experiment with, and listen to, the effects of several audio filters.
# The file audio_filtering_original.wav contains a 10-second recording with sample rate of f = 44100/sec. 
# We let x denote the 441000-vector representing this recording. You can read in x and the sample rate f using the following code:
#Pkg.add("WAV")
#using WAV
#x, f = wavread("audio_filtering_original.wav");
#x = vec(x);
#To play the signal, run:
#wavplay(x, f);
#If this not supported on your system, you can write the signal into a file, download the file from 
# JuliaBox if you are using that, and then listen to it on your machine:
# wavwrite(x, f, "filename.wav");
#(a) 1ms smoothing filter. Let hsmooth be the 44-vector hsmooth = 1 144. (The subscript 44 gives 44
#the length of the vector.) The signal hsmooth ∗ x is the 1ms moving average of the input x. 
# We can construct the vector hsmooth and compute the output signal as follows:
# h_smooth = 1 / 44 * ones(44);
# output = conv(h_smooth, x);
# wavplay(output, f);
# Listen to the output signal and briefly describe the effect of convolving hsmooth with x in one sentence.
# (b) Echo filter. What filter (i.e., vector) hecho has the property that hecho ∗ x consists of the original 
# recording, plus an echo of the original recording 0.25 seconds delayed, with half the original amplitude? 
# Since sound travels at about 340m/s, this is equivalent to the effect of hearing an echo from a wall about 42.5m away. 
# Construct hecho using Julia and listen to the output signal hecho ∗ x to confirm the effect. 
# Form and listen to the signal hecho ∗ hecho ∗ x and very briefly describe what you hear.
# Hint. The entries of the output signal y = hecho ∗ x satisfy yi = xi + 0.5xi−k, 
# where we take xj = 0 for j outside the range 1, . . . , 441000, and k is the number of samples in 0.25 seconds.

using WAV
x, f = wavread("audio_filtering_original.wav");
x = vec(x);
#a) 
h_smooth = 1 / 44 * ones(44);
output = conv(h_smooth, x);
wavplay(output, f); #Play Audio
#The volume of the audio has decreased and we cannot hear less sharp noises.
#b)
IR = zeros(convert(Int32,round(0.03125*f,digits=0))); #Impulse Response
IR[1,1] = 1;
d = f*0.25
k = 0.5
drypath = vcat(IR,zeros(convert(Int32,d)));
wetpath = vcat(zeros(convert(Int32,d)),IR);
out = zeros(size(drypath));
for n in 1:length(drypath)
    out[n,1] = drypath[n,1]+k*wetpath[n,1];
end
echo_IR = conv(out,x); #h_echo*x
wavplay(echo_IR, f); #Play Audio
echo_IR_2 = conv(out,echo_IR); #h_echo*h_echo*x
wavplay(echo_IR_2, f); #Play Audio