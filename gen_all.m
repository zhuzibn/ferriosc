%% generate multiple folder based on a sample folder
% by Zhifeng, March.18.2016
clear all;clc;close('all')
%---configuration---
ssp=4;%/1 icrange/2 initangle relaxation/3 miloop/4 Hext
switch ssp
    case 1
        ptmp=[1:1:8];
        ck=2;%set ck=2 to get both +-I value
        ck2=1;
        inittheta=5;
        foldername=sprintf('get_i_range');
        valname='Ic';
    case 2
        ck=1;
        ck2=1;
        foldername=sprintf('randinit');
        valname='randinit';
        inittheta=5;
    case 3
        ck=1;
        ck2=1;
        foldername=sprintf('miloop');
    case 4
        ck=2;
        %1st run:Hext along z,-z; 2nd tun:Hext along 45 degree b/w zy
        ck2=2;%change two variables, Hext and Je
        foldername=sprintf('hext');
        inittheta=5;
        Jini=-26;%e-7A/cm2
end
if (exist(foldername,'dir')==7)
    %do nothing
else
    mkdir(foldername);
end

for ct1=1:ck
    switch ssp
        case 1
            paramet=(-1)^ct1*3.^ptmp;
        case 2
            paramet=[1,2,3,4];
        case 3
            if ct1==1
                inittheta=5;
                paramet=[-246:1:-242];
                valname='miloopp';
            elseif ct1==2
                inittheta=175;
                paramet=[240:2:256];
                valname='miloopn';
            end
        case 4
            if ct1==1%Hext along z direction
                paramet=[-10:3:10];
                valname='hextz';
            elseif ct1==2
                paramet=[-10:3:10];%Hext along 45 degree b/w yz direction
                valname='hext45';
            end
            ck2var=Jini;
    end
    %-------------------
    spath = pwd;addpath(spath);
    prt_fder='mmain'; %assign parent folder
    
    sz1=size(paramet,2);
    for ct2=1:sz1
        cd(spath);
        vue=paramet(ct2);
        fold_name=sprintf('pa%s_%d',valname,vue);
        mkdir(fold_name);
        
        copyfile(prt_fder,fold_name);
        cd(fold_name)
            job_name=sprintf('r%s_%d',valname,vue);
            matname=sprintf('final%s_%d.mat',valname,vue);
            initthe=sprintf('thet_ini=%d*pi/180;',inittheta);
        for ct2var=1:ck2
            gen_sub();
            gen_sub2();
            
            fin = fopen('PBSScript');
            copyfile('PBSScript','PBSScript0')
            fout = fopen('PBSScript0','w');
            while ~feof(fin)
                s = fgetl(fin);
                s = strrep(s, 'run', job_name);
                fprintf(fout,'%s\n',s);
            end
            fclose(fin);
            fclose(fout);
            
            fin = fopen('main.m');
            copyfile('main.m','main0.m')
            fout = fopen('main0.m','w');
            while ~feof(fin)
                s = fgetl(fin);
                s = strrep(s, 'final.mat', matname);
                s = strrep(s, substori, substval);
                s = strrep(s, 'thet_ini=78*pi/180;', initthe);
                fprintf(fout,'%s\n',s);
                %disp(s)
            end
            fclose(fin);
            fclose(fout);
            
            delete main.m PBSScript
            movefile('main0.m','main.m')
            movefile('PBSScript0','PBSScript')
        end %end of ct2var
        cd ..
        movefile(fold_name,foldername)
    end
end


