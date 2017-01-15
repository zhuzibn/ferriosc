switch valname
    case 'Ic'
        substval=sprintf('Je=%d*1e7;',vue);
    case 'Hext'
        substval=sprintf('Hz=%d;',vue);
    case 'randinit'
        substval=sprintf('randinit=1;');
    case 'miloopp'
        substval=sprintf('Je=%d*1e6;',vue);
    case 'miloopn'
        substval=sprintf('Je=%d*1e6;',vue);
    case 'hextz'
        if ct2var==1
            substval=sprintf('Hz=%de-1;',vue);
        elseif ct2var==2
            substval=sprintf('Je=%d*1e7;',ck2var);
        end
            case 'hext45'
        if ct2var==1
            substval=sprintf('Hx=0;Hy=%de-1;Hz=%de-1;',vue,vue);
        elseif ct2var==2
            substval=sprintf('Je=%d*1e7;',ck2var);
        end
        
end