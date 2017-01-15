%% function dmdt=LLG_solver(~,m)
%% LLG equation with precession term, damping term, spin current

% call this function by feval(@(t,m) LLG_solver(t,m,Hk,alpha),t0,m0)
% t0 is the initial value of t
% m0 is the initial value of m
    
    dmdt=-cross(mmm,hh)-alpha*cross(mmm,cross(mmm,hh))-a_parallel*cross(mmm,...
    cross(mmm,p))+alpha*a_parallel*cross(mmm,p);

%end