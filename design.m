%%% ----------------------------------------------------------------------
%%%
%%% Description: State-space feedback and observer design for the
%%% control of a dual-reservoir pumped-storage hydroelectricity plant.
%%%
%%% Author: Alkis Gotovos
%%% Created: 29 Jun 2010
%%%
%%% ----------------------------------------------------------------------


%% System parameters
A1 = 25.12;
A2 = 56.52;
R1 = 10;
R2 = 20;

%% Desired system attributes
% Settling time
ts = 400;

%% Open loop state-space model
A = [-(1/(R1*A2) + 1/(R2*A2)) 1/(R1*R2*A2); R2/(R1*A1) -1/(R1*A1)];
B = [0; 1/A1];
C = [1 0];
D = 0;
open = ss(A, B, C, D);

%% Check (open loop) stability - controllability - observability
isStable = isstable(open);
isControllable = rank(ctrb(open)) == 2;
isObservable = rank(obsv(open)) == 2;

%% Full-state feedback
z = 0.9;
wn = 4/(z*ts);
% Desired pole locations.
p = [-wn*z + wn*sqrt(1-z^2)*1i, -wn*z - wn*sqrt(1-z^2)*1i];
% State-feedback gain.
K = place(A, B, p);
% Reference signal gain for achieving zero steady-state error.
N = -1/(C*((A-B*K)\B));

%% Full-order observer
tsobs = ts/5;
zobs = 0.9;
wnobs = 4/(zobs*tsobs);
% Desired observer pole locations.
pobs = [-wnobs*zobs + wnobs*sqrt(1-zobs^2)*1i,...
        -wnobs*zobs - wnobs*sqrt(1-zobs^2)*1i];
Lfull = place(A, C', pobs);

%% Reduced-order observer
% Desired observer pole location (just one pole in this case).
preduced = -2*wnobs*zobs;
Lreduced = place(A(2, 2), A(1, 2), preduced);
D = A(2, 2) - Lreduced*A(1, 2);
F = D*Lreduced + A(2, 1) - Lreduced*A(1, 1);
G = B(2) - Lreduced*B(1);