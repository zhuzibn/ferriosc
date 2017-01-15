%function [hh,a_parallel]=field_eta(mmm,Hd,Hext,Hk,Hk_,HdipoleFL,P1,P2,Je,Jp)
       %% field calculation 
       %freeze
    if ctop1

       ha=(Hk4d*ne*mmm')*ne;
       hd=mu_0*(Ms4d*mmm(2)+Ms2b*mm2(2))*nd;
       hex=-0.5*Hex4d*mm2;
       hext=Hext1;

       
    else

       ha=(Hk2b*ne*mmm')*ne;
       hd=mu_0*(Ms4d*mm1(2)+Ms2b*mmm(2))*nd;
       hex=-0.5*Hex2b*mm1;
       
       hext=Hext2;

       
    end
       %hext=Hext/Hk(2*(widt>leng)+1*(widt<leng));
     %hext=Hext;
        %% damping like torque 
        if STTDL           
        a_parallel_STT=Je/Jp*b/2;%[Tesla]
        else
        a_parallel_STT=0;
        end
        
        a_parallel=a_parallel_STT;

        hh=hex+ha+hext-hd; %total field 
    %end