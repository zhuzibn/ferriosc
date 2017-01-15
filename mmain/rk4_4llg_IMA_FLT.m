%% 4th order Runge Kutta method, for LLG calaulation in PMA MTJ
% call this function using: [,]=rk4_4llg(,)

%zzf,March.18,19.2016;
%zzf,Aug.27,2016,remove function
%1.changed based on PMA;2.add in FL torque
%% input
% DemagFactorFL 3 by 3 matrix
% ts is time step, unit [s]
% num_step is total number of steps
% m_init is initial magnetization, it is a 1-by-3 matrix, unit vector
% Ms: saturation magnetization, unit [emu/cm3]
% Hk: uniaxial anisotropy field, one value unit [tesla]
% Hext: applied field, 1-by-3 vector, unit [tesla]
% alpha: damping constant
% P1,P2: polarization of free layer and pinned layer
% p: unit 1-by-3 vector, polarization of STT current, note the reflection type is opposite to m_pin_layer
% Ie: magnetitude of charge current, unit [Ampere]
% dimension FL_length,FL_width,FL_thickness, unit [nm]

%% output
%mmx,mmy,mmz: magnetization component, unit vector
%tt: simulation time list, unit [ns]
%Icri: critical current for switching unit:[Ampere]


%function [mmx,mmy,mmz,t]=rk4_4llg(ts,t0,m,sz,Hk,alpha,va_one,p,Je,Hd,Hext)
%% constant
% g = 0; % Gyromagnetic ratio [(rad)/(T.s)]
% e=0;%coulombs
% mu_0=0;%Vacumn permeability N/A2 
% mu_b=0;%Erg/G
% hbar=0;%planck constant [eV.s]

if dimensionlessLLG
    Hk_=Hk;
    Hk=[1*(FL_width<FL_length)*Hk,1*(FL_width>FL_length)*Hk,0];
    tau_c=(g*Hk(2*(FL_width>FL_length)+1*(FL_width<FL_length)))/(1+alpha^2); %natural time constant 1/s
    scal=1;
else
    Hk=[1,1,1];%normalization purpose
    tau_c=1;
    scal=g/(1+alpha^2);%scale parameter
end
ts1=ts*tau_c; %time step
%volum=leng*widt*thic*1e6;%[cm3]
%crossarea=leng*widt*1e4;%[cm2]

m01=m_init_top;
m02=m_init_btm;
ct1=1; %count 1
n=ts1;
sz=num_step;
t=zeros(1,sz);
mmx=zeros(sz,2);%(:,1)is top layer, (:,2)is bottom layer
mmy=zeros(sz,2);
mmz=zeros(sz,2);

while ct1<sz       
mmx(1,1)=m01(1);mmy(1,1)=m01(2);mmz(1,1)=m01(3);
mm1=[mmx(ct1,1),mmy(ct1,1),mmz(ct1,1)]; %top 
mmx(1,2)=m02(1);mmy(1,2)=m02(2);mmz(1,2)=m02(3);
mm2=[mmx(ct1,2),mmy(ct1,2),mmz(ct1,2)];  %bottom
    
    if mod(ct1*ts,1e-13)==0
        ct1*ts*1e13
       %freeze(); 
    end
    %% unit convension:
    %e_tmp:[e],unit electron charge
    %hbar_tmp:[ev.s]
    %d_tmp:[m],FL thickness
    %Hk_tmp:[Gauss]
    e_tmp=1;%[e],
    hbar_tmp=hbar;
    %t_tmp=thic; %[m]
    t(1,1)=0;
    t(1,ct1+1)=t(1,ct1)+n;
    
    ctop1=1;%start calc top magnet
    ctop2=~ctop1;
    if thermalH%equation (1) in JOURNAL OF APPLIED PHYSICS 97, 10N705 (2005)
        %calculate once for one time step
    volume_top_tmp=volum*1e-6;%[m3]
    volume_btm_tmp=volume_btm*1e-6;
    g_tmp=g*1e-4;%[Hz/Oe]
    Hthermal1=sqrt(2*kb*Temp*alpha/(0.1*volume_top_tmp*Ms*g_tmp*(1+alpha^2)*ts1));%[Oe]
    Hx1=normrnd(0,Hthermal1)*1e-4;%[Oe]->Tesla
    Hy1=normrnd(0,Hthermal1)*1e-4;
    Hz1=normrnd(0,Hthermal1)*1e-4;
    Hthermal2=sqrt(2*kb*Temp*alpha/(0.1*volume_btm_tmp*Ms*g_tmp*(1+alpha^2)*ts1));%[Oe]
    Hx2=normrnd(0,Hthermal1)*1e-4;%[Oe]->Tesla
    Hy2=normrnd(0,Hthermal1)*1e-4;
    Hz2=normrnd(0,Hthermal1)*1e-4;
    else
    Hx1=0;Hy1=0;Hz1=0;
    Hx2=0;Hy2=0;Hz2=0;
    end
    
    %% unit convension:
    %e_tmp:[e],unit electron charge
    %hbar_tmp:[ev.s]
    %d_tmp:[m],FL thickness
    %Hk_tmp:[Gauss]
    %Ms_tmp:[emu/cm3]
    e_tmp=1;%[e],
    hbar_tmp=hbar;
    t_tmp=tferri; %[m]
    
    Ms4d_tmp=Ms4d*1e-3;%[A/m/G]->emu/cm3/G
    tmp2=Ms4d_tmp*0.1;%[erg/cm3/G]->[J/m3/G]
    tmp3=tmp2*t_tmp/hbar_tmp;%[A/m2/G]
    Jp_tmp=tmp3*1e-4;%[A/m2/G]->[A/cm2/G]    
    Jp=Jp_tmp*1e4;%[A/cm2/T]
    
    mmm=mm1;
    field_eta();
    LLG_solver();
    kk1=scal*dmdt;
    
    mmm=mm1+kk1*n/2;
    field_eta();
    LLG_solver();
    kk2=scal*dmdt;
    
    mmm=mm1+kk2*n/2;
    field_eta();
    LLG_solver();
    kk3=scal*dmdt;
    
    mmm=mm1+kk3*n;
    field_eta();
    LLG_solver();
    kk4=scal*dmdt;
   
    mn1=mm1+n/6*(kk1+2*kk2+2*kk3+kk4);
    mn1=mn1/norm(mn1);
    mmx(ct1+1,1)=mn1(1);mmy(ct1+1,1)=mn1(2);mmz(ct1+1,1)=mn1(3);
    
    ctop1=0;%start calc bottom magnet
    ctop2=~ctop1;
    %% unit convension:
    %e_tmp:[e],unit electron charge
    %hbar_tmp:[ev.s]
    %d_tmp:[m],FL thickness
    %Hk_tmp:[Gauss]
    
    Ms2b_tmp=Ms2b*1e-3;%[A/m/G]->emu/cm3/G
    tmp2=Ms2b_tmp*0.1;%[erg/cm3/G]->[J/m3/G]
    tmp3=tmp2*t_tmp/hbar_tmp;%[A/m2/G]
    Jp_tmp=tmp3*1e-4;%[A/m2/G]->[A/cm2/G] 
    Jp=Jp_tmp*1e4;%[A/cm2/T]
    
    mmm=mm2;
    field_eta();
    LLG_solver();
    kk1=scal*dmdt;
    
    mmm=mm2+kk1*n/2;
    field_eta();
    LLG_solver();
    kk2=scal*dmdt;
    
    mmm=mm2+kk2*n/2;
    field_eta();
    LLG_solver();
    kk3=scal*dmdt;
    
    mmm=mm2+kk3*n;
    field_eta();
    LLG_solver();
    kk4=scal*dmdt;
   
    mn1=mm2+n/6*(kk1+2*kk2+2*kk3+kk4);
    mn1=mn1/norm(mn1);
    mmx(ct1+1,2)=mn1(1);mmy(ct1+1,2)=mn1(2);mmz(ct1+1,2)=mn1(3);
    
    ct1=ct1+1;
end
if dimensionlessLLG
    tt=t/tau_c*1e9;%unit[ns]
else
    tt=t;
end