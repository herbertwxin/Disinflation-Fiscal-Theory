function out = rfmats(SET, z_f_i, z_f_f)
%function out = rfmats(SET, z_f_i, z_f_f)
%
%

n_ = SET.variable.n_ ;
l_ = SET.variable.l_ ;

%might have to change later if I want a different final regime
Qf = SET.mats.Q ; 

%% Setup

Tbstar = z_f_f ;

Qtilde = zeros(n_,n_,Tbstar);
Gtilde = zeros(n_,l_,Tbstar);
Qhat = zeros(n_,n_,Tbstar);
Ghat = zeros(n_,l_,Tbstar);

A0i = zeros(n_,n_,Tbstar) ;
A1i = zeros(n_,n_,Tbstar) ;
B0i = zeros(n_,n_,Tbstar) ;
D0i = zeros(n_,l_,Tbstar) ;
D2i = zeros(n_,l_,Tbstar) ;
Gammai = zeros(l_,l_,Tbstar) ;
Ai     = zeros(n_,n_,Tbstar) ;
A0invi = zeros(n_,n_,Tbstar) ;
Bi     = zeros(n_,n_,Tbstar) ;

%%

t_vec = 1:1:Tbstar ;
f_zlb = t_vec ;

f_zlb([1:(z_f_i-1), (z_f_f+1):Tbstar])=0 ;

for t_ = 1:Tbstar

    SET.mat_i = SET.mat_init ; %might have to change later

    A0i(:,:,t_) = SET.mat_i.A0 ;
    A1i(:,:,t_) = SET.mat_i.A1 ;
    B0i(:,:,t_) = SET.mat_i.B0 ;
    D0i(:,:,t_) = SET.mat_i.D0 ;
    D2i(:,:,t_) = SET.mat_i.D2 ;
    Gammai(:,:,t_) = SET.mat_i.Gamma ;

    if t_==f_zlb(t_)

        A0i(:,:,t_) = SET.mat_i_f_zlb.A0 ;
        A1i(:,:,t_) = SET.mat_i_f_zlb.A1 ;
        B0i(:,:,t_) = SET.mat_i_f_zlb.B0 ;
        D0i(:,:,t_) = SET.mat_i_f_zlb.D0 ;
        D2i(:,:,t_) = SET.mat_i_f_zlb.D2 ;
        Gammai(:,:,t_) = SET.mat_i_f_zlb.Gamma ;

    end 

    Ai(:,:,t_) = A0i(:,:,t_)\A1i(:,:,t_);
    A0invi(:,:,t_) = inv(A0i(:,:,t_));
    Bi(:,:,t_) = A0i(:,:,t_)\B0i(:,:,t_); 

end

Qtilde(:,:,end) = (eye(n_)-Bi(:,:,end)*Qf)\Ai(:,:,end);
Gtilde(:,:,end) = (eye(n_)-Bi(:,:,end)*Qf)\A0invi(:,:,end)*D0i(:,:,end);

for t = Tbstar-1:-1:1
    Qtilde(:,:,t) = (eye(n_)-Bi(:,:,t)*Qtilde(:,:,t+1))\Ai(:,:,t);
    Gtilde(:,:,t) = (eye(n_)-Bi(:,:,t)*Qtilde(:,:,t+1))\A0invi(:,:,t)*D0i(:,:,t);
end

for t = 1:Tbstar-1
    Qhat(:,:,t) = (A0i(:,:,t)-B0i(:,:,t)*Qtilde(:,:,t+1))\A1i(:,:,t);
    Ghat(:,:,t) = (A0i(:,:,t)-B0i(:,:,t)*Qtilde(:,:,t+1))\D0i(:,:,t);
end

Qhat(:,:,Tbstar) = (A0i(:,:,end)-B0i(:,:,end)*Qf)\A1i(:,:,end);
Ghat(:,:,Tbstar) = (A0i(:,:,end)-B0i(:,:,end)*Qf)\D0i(:,:,end);

%%

out.Qhat = Qhat ;
out.Ghat = Ghat ;