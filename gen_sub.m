switch  valname
    case 'Ic'
        substori='Je=0*1e7;';%original value    
    case 'Hext'
        paramet=[3:1:9];
        substori='Hz=0;';   
case 'randinit'
    substori='randinit=0;';
     case 'miloopp'
    substori='Je=0*1e7;';
    case 'miloopn'
    substori='Je=0*1e7;';
    case 'hextz'
        if ct2var==1
       substori='Hz=0;'; 
        elseif ct2var==2
       substori='Je=0*1e7;';  
        end
    case 'hext45'
        if ct2var==1
       substori='Hx=0;Hy=0;Hz=0;'; 
        elseif ct2var==2
       substori='Je=0*1e7;';  
        end
end