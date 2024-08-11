% parameters
Ra=2;
La=6.5e-5;
Jm=6e-7;
Ke=0.8;
Kt=Ke;
b=0.008;
% omega static model
a= b+Kt*Ke/Ra;
a0=Kt/(a*Ra);
a1=1/a;
% conversion
conversion=60/(2*pi)
% data 
inputs=[1 0;8 2;12 3;20 7.5;3 0;10 1;11 3;25 9;3 0.1;3 0]
Mylen=length(inputs)
omegarads=inputs*[a0;-a1];
omegarads=omegarads
omegatrmn=conversion*omegarads
noisyoutputsrads=omegarads+(0.5+0.5)*rand(Mylen,1)
noisyoutputstrmn=conversion*noisyoutputsrads
save('StaticDCMotorData.mat','inputs','omegarads','omegatrmn','noisyoutputsrads','noisyoutputstrmn','a0','a1')
