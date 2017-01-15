%% main
clear all;clc;close all;
%notes:to add thermal noise
%% parameters
%constant
const();
%a. time control 
runtime=50e-12;%[s]
ts=0.03e-15;%timestep
num_step=round(runtime/ts);
%materials
alpha=3.5e-3;
Ku2b=-0.09e6;%J/m3
Ms2b=604e3;%A/m
Ku4d=2.26e6;%J/m3
Ms4d=770e3;%A/m
Jex=2.48e9;%J/m3

tferri=2e-9;%[nm]

ne=[0,0,1];

%calc
Ms2b_tmp=Ms2b*1e-3;%[A/m]->[emu/cm3]
Ku2b_tmp=Ku2b*10;%[J/m3]->[erg/cm3]
Hk2b_tmp=2*Ku2b_tmp/Ms2b_tmp;%[Oe]
Hk2b=Hk2b_tmp*1e-4;%[Oe]->[Tesla]

Ms4d_tmp=Ms4d*1e-3;%[A/m]->[emu/cm3]
Ku4d_tmp=Ku4d*10;%[J/m3]->[erg/cm3]
Hk4d_tmp=2*Ku4d_tmp/Ms4d_tmp;%[Oe]
Hk4d=Hk4d_tmp*1e-4;%[Oe]->[Tesla]

Hex4d=Jex/Ms4d;%[Tesla]
Hex2b=Jex/Ms2b;%[Tesla]

%Hd=mu_0*(Ms4d-Ms2b);%[Tesla]
nd=[0,1,0];%y is thin film vertical direction
%Hex=0;
Hx=0;Hy=0;Hz=0;%[Tesla]
Hext1=[Hx,Hy,Hz];%act on mA
%Hext2=[0,0,-Hz];%act on mB
Hext2=Hext1;
p=[0,0,1];
% other parameters
STTDL=1;
if STTDL  
   b=0.4;
   %STTpolarizer=[0,0,1];
end

Je=0*1e7;%[A/m2]
% e. control parameters
dimensionlessLLG=0;%solve dimensionless LLG equation
STTDL=1;%damping like torque
thermalH=0;%enable random thermal field
%initial condition
randinit=0;
if randinit
    rng('shuffle');
 thet_ini=((rand(1)-0.5)*180)*pi/180;
 phi_ini=((rand(1)-0.5)*360)*pi/180;
else
thet_ini=78*pi/180;
phi_ini=5*pi/180;
end
m_init_top_tmp=[sin(thet_ini)*cos(phi_ini),sin(thet_ini)*sin(phi_ini),cos(thet_ini)];
m_init_top=m_init_top_tmp/norm(m_init_top_tmp);
m_init_btm_tmp=-[sin(thet_ini)*cos(phi_ini),sin(thet_ini)*sin(phi_ini),cos(thet_ini)];
m_init_btm=m_init_btm_tmp/norm(m_init_btm_tmp);

rk4_4llg_IMA_FLT();
save('final.mat')
if (0)
figure(1)
plot(tt*1e12,mmx(:,1),'-*',tt*1e12,mmy(:,1),tt*1e12,mmz(:,1));
legend('mx','my','mz')
xlabel('time(ps)');ylabel('m');
end
if (0)
figure(2)
plot(tt*1e12,mmx(:,2),'-*',tt*1e12,mmy(:,2),tt*1e12,mmz(:,2),'-+');
legend('mx','my','mz')
xlabel('time(ps)');ylabel('m');
end
if (0)
plot3(mmx(:,2),mmy(:,2),mmz(:,2))
xlabel('mx');ylabel('my');zlabel('mz');
end









