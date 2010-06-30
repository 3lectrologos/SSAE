%% System parameters
A1 = 25.12;
A2 = 56.52;
R1 = 10;
R2 = 20;

%% Desired system attributes
% Settling time
ts = 400;

%% System state-space model
A = [-(1/(R1*A2) + 1/(R2*A2)) 1/(R1*R2*A2); R2/(R1*A1) -1/(R1*A1)];
B = [0; 1/A1];
C = [1 0];
D = 0;
open = ss(A, B, C, D);

%% Check (open loop) stability - controllability - observability
isStable = isstable(open);
isControllable = rank(ctrb(open)) == 2;
isObservable = rank(obsv(open)) == 2;

%% Open loop step response
tfinal = 10000;
r = 0.1 * ones([1 tfinal + 1]);
t = 0:tfinal;
[y, t, x] = lsim(open, r, t);
h2 = R2*x(:, 1);
figure;
plot(t, x(:, 1));

%% Full-state feedback
% Polynomial for desired poles.
z = 0.9;
wn = 4/(z*ts);
p = [-wn*z + wn*sqrt(1-z^2)*1i, -wn*z - wn*sqrt(1-z^2)*1i];
K = place(A, B, p);
N = -1/(C*((A-B*K)\B));
full = ss(A-B*K, N*B, C, D);

%% Full-state feedback step response.
tfinal = 1000;
r = 0.1 * ones([1 tfinal + 1]);
t = 0:tfinal;
[y, t, x] = lsim(full, r, t);
h2 = R2*x(:, 1);
figure;
plot(t, x(:, 1));
figure;
plot(t, x, t, h2);
figure;
plot(t, -K*x' + N*r);