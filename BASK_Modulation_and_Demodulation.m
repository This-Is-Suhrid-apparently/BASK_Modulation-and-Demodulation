%BASK Modulation and Demodulation

%% Input Bits Generation
N=10; %Input Size
n=randi([0 1],1,N); % Random N bits generation : 1 or 0

%% Unipolar Mapping
for ii=1:N
    if n(ii)==0
        nn(ii)=0;
    else 
        nn(ii)=1;
    end
end

%% Unipolar NRZ signal
S=100; %Sampling frequency for MATLAB, basically it is the number of points for representation of 1 bit
       %Simply called "Samples per Bit"
i=1;
t=0:1/S:N;
for j=1:length(t)
    if t(j)<=i
        m(j)=nn(i);
    else
        m(j)=nn(i);%This line of code is written to maintain a continuum in the waveform
        i=i+1;
    end
end
subplot(411);
plot(t,m,'m'); xlabel('Time'); ylabel('Amplitude');
title('NRZ Unipolar Line coded Signal');

%% Carrier Signal Generation
c=cos(2*pi*2*t);
subplot(412);
plot(t,c,'r'); xlabel('Time'); ylabel('Amplitude');
title('Carrier Signal');


%% BASK Signal Generation
x=m.*c;
subplot(413);
plot(t,x,'k'); xlabel('Time'); ylabel('Amplitude');
title('BASK Signal');

%% Coherent Detection
% We consider no noise case
y=x; %Received Signal=Transmitted Signal, since Coherent Detection

y1=y.*c; %Product Modulator Output
subplot(414);
plot(t,y1,'k'); xlabel('Time'); ylabel('Amplitude');
title('Product Modulator Output');

%% Integrator
int_op=[];
for ii=0:S:length(y1)-S %from 0 to the second last bit as integrating the second last goes on to the last bit
                        %trapz: Trapezoidal Numerical Integration
                        %division by S is done to find the average area
                        %between every 2 bits
    int_o=(1/S)*trapz(y1(ii+1:ii+S));
    int_op=[int_op  int_o];
end

%% Decision Device
Th= 0.5; %Threshold for BASK
disp('Detected Bits:')
det=(round(int_op,1)>=Th) %round(input,number of significant places) and compare with the Threshold  

%% BER Computation
ber=sum(n~=det)/N %Count number of detected bits which are not equal to the original input 

% Clearly as there is no noise so the BER=0
