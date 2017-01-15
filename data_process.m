% post process
%% sweep VDD,VG,tFL-->osc freq. & ave IMTJ
if (1)
    clear all;clc;close all;
    %--------config
    cass=4;%1Icrange/2initangle/3miloop/4hext
    PClap=1;%1:PC 2:laptop
    %----------
    switch cass
        case 1
            ptmp=[1:1:8];
            VDD_0=3.^ptmp;%VDD 
            %VDD_0=-3.^ptmp;%VDD 
            %note, there are two runs for +- I
        case 2
            VDD_0=[1:1:4];%VDD
        case 3
            VDD_0=[-260:2:-244];%mp
            %VDD_0=[240:2:256];%mn
            %note, there are two runs for init +- m
        case 4
            VDD_0=[-10:3:10];%mp
            %VDD_0=[-10:3:10];%mn
           %note, there are two runs for init hext in z axis& 
           %45 degree b/w yz axis
    end
    szVDD_0=length(VDD_0);
    
    for ctVDD_0=1:szVDD_0
        VDD_0(ctVDD_0)
        switch PClap
            case 1
                switch cass
                    case 1
matname=sprintf('C:\\Users\\a0132576\\Documents\\MobaXterm\\home\\icrange\\final_%d.mat',VDD_0(ctVDD_0));
                    case 2
matname=sprintf('C:\\Users\\a0132576\\Documents\\MobaXterm\\home\\randinit\\final%d.mat',VDD_0(ctVDD_0));
                    case 3
matname=sprintf('C:\\Users\\a0132576\\Documents\\MobaXterm\\home\\miloop\\final_%d.mat',VDD_0(ctVDD_0));
                    case 4
matname=sprintf('C:\\Users\\a0132576\\Documents\\MobaXterm\\home\\hextdat\\finalhext45_%d.mat',VDD_0(ctVDD_0));
                end
            case 2
                switch cass
                    case 1
matname=sprintf('C:\\Users\\zzbrian\\AppData\\Local\\Temp\\Mxt86\\tmp\\home_zzbrian\\icrange\\final%d.mat',VDD_0(ctVDD_0));
                    case 2
matname=sprintf('C:\\Users\\zzbrian\\AppData\\Local\\Temp\\Mxt86\\tmp\\home_zzbrian\\randinit\\final_%d.mat',VDD_0(ctVDD_0));
                    case 3
matname=sprintf('C:\\Users\\zzbrian\\AppData\\Local\\Temp\\Mxt86\\tmp\\home_zzbrian\\miloop\\final_%d.mat',VDD_0(ctVDD_0));
                end
        end
        
        load(matname);
        %fprintf('load %s',matname)
        if (0)%calc codes
            cursor_info(2).Position(1)-cursor_info(1).Position(1)
        end
        
        if (1)%mxyz for 4d
            figg=figure;
            hold on
            tp=10;
            % figure(1)
            plot(tt(1:tp:end)*1e12,mmx(1:tp:end,1),tt(1:tp:end)*1e12,mmy(1:tp:end,1),tt(1:tp:end)*1e12,mmz(1:tp:end,1),'linewidth',3);
            legend('mx','my','mz')
            xlabel('time(ps)');ylabel('m');
            xlabel('time(ps)','fontsize',20);ylabel('m','fontsize',20)
            set(gca,'linewidth',3,'fontsize',20)
            close(figg);
            (mmz(end,1)*Ms4d+mmz(end,2)*Ms2b)/(Ms4d-Ms2b)
            %abs(1/(cursor_info(2).Position(1)-cursor_info(1).Position(1)))%THz
        end
        if (0)%mxyz for 2b

            figure;
            hold on
            tp=10;   
            plot(tt(1:tp:end)*1e12,mmx(1:tp:end,2),tt(1:tp:end)*1e12,mmy(1:tp:end,2),tt(1:tp:end)*1e12,mmz(1:tp:end,2),'linewidth',3);
            legend('mx','my','mz')
            xlabel('time(ps)');ylabel('m');
            xlabel('time(ps)','fontsize',20);ylabel('m','fontsize',20)
            set(gca,'linewidth',3,'fontsize',20)
            %close(figure);

        end
         if (0)%3d for 4d,2b
            tp=10;
            figure
            hold on
            plot3(mmx(1:tp:end,1),mmy(1:tp:end,1),mmz(1:tp:end,1),'r')
            xlabel('mx');ylabel('my');zlabel('mz');
            quiver3(0,0,0,mmx(end,1),mmy(end,1),mmz(end,1),'k')
            quiver3(0,0,0,mmx(1,1),mmy(1,1),mmz(1,1),'m')
            plot3(mmx(1:tp:end,2),mmy(1:tp:end,2),mmz(1:tp:end,2),'b')
            xlabel('mx');ylabel('my');zlabel('mz');
            quiver3(0,0,0,mmx(end,2),mmy(end,2),mmz(end,2),'k')
            quiver3(0,0,0,mmx(1,2),mmy(1,2),mmz(1,2),'m')
            view(45,45)
            legend('traj4d','final4d','init4d','traj2b','final2b','init2b')
            close(figure);
        end
          if (0)%mx,y,z
            thet_ini/pi*180;
            phi_ini/pi*180;
            figboth=figure;
            hold on
            tp=10;
            % figure(1)
            plot(tt(1:tp:end)*1e12,(Ms4d*mmx(1:tp:end,1)+Ms2b*mmx(1:tp:end,2))/(Ms4d-Ms2b),'linewidth',3);
            plot(tt(1:tp:end)*1e12,(Ms4d*mmy(1:tp:end,1)+Ms2b*mmy(1:tp:end,2))/(Ms4d-Ms2b),'linewidth',3);
            plot(tt(1:tp:end)*1e12,(Ms4d*mmz(1:tp:end,1)+Ms2b*mmz(1:tp:end,2))/(Ms4d-Ms2b),'linewidth',3);
            xlim([0,50]);
            legend('mx','my','mz')
            xlabel('time(ps)');ylabel('m');
            xlabel('time(ps)','fontsize',20);ylabel('m','fontsize',20)
            set(gca,'linewidth',3,'fontsize',20)
%             [mmx(1,1),mmy(1,1),mmz(1,1)]
%             [mmx(1,2),mmy(1,2),mmz(1,2)]
            close(figboth);
            
            %mmz(end,1)
            %(mmz(end,1)*Ms4d+mmz(end,2)*Ms2b)/(Ms4d-Ms2b)
            %abs(1/(cursor_info(3).Position(1)-cursor_info(1).Position(1)))%THz
            %abs(cursor_info(2).Position(2)-cursor_info(1).Position(2))%m-pp
          end
         if (0)%3d for mx,y,z
            tp=10;
            figure
            hold on
            plot3((Ms4d*mmx(1:tp:end,1)+Ms2b*mmx(1:tp:end,2))/(Ms4d-Ms2b)...
                ,(Ms4d*mmy(1:tp:end,1)+Ms2b*mmy(1:tp:end,2))/(Ms4d-Ms2b),...
               (Ms4d*mmz(1:tp:end,1)+Ms2b*mmz(1:tp:end,2))/(Ms4d-Ms2b),'r')
            xlabel('mx');ylabel('my');zlabel('mz');
            quiver3(0,0,0,(Ms4d*mmx(end,1)+Ms2b*mmx(end,2))/(Ms4d-Ms2b),...
                (Ms4d*mmy(end,1)+Ms2b*mmy(end,2))/(Ms4d-Ms2b),...
                (Ms4d*mmz(end,1)+Ms2b*mmz(end,2))/(Ms4d-Ms2b),'k')
            quiver3(0,0,0,(Ms4d*mmx(1,1)+Ms2b*mmx(1,2))/(Ms4d-Ms2b),...
                (Ms4d*mmy(1,1)+Ms2b*mmy(1,2))/(Ms4d-Ms2b),...
                (Ms4d*mmz(1,1)+Ms2b*mmz(1,2))/(Ms4d-Ms2b),'m')
            view(-35,45)
            legend('traj','final','init')
            close(figure);
        end
        
        
    end
end
