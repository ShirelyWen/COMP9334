% Device 1 = CPU
% Device 2 = Disk 1
% Device 3 = Disk 2
% Device 4 = Disk 3   
T = 60*60;
U1 = 0.75;
U2 = 0.5;
U3 = 0.5;
U4 = 0.25;
C = 36000;
% Compute service demand
D = zeros(3,1);
X0 = C/T;
D(1) = U1/X0;
D(2) = U2/X0;
D(3) = U3/X0;
D(4) = U4/X0;
% The visit ratios are 1
V = ones(4,1);
Z = 7; 

% MVA for 1 to 200 users
Nmax = 200;
[R,X,nbar,Rzero,Xn,U] = mva_sc(D,V,Nmax,Z);
% Asymptotic bound
Xbound = min([(1:Nmax)/(sum(D)+Z) ; (1/max(D))*ones(1,Nmax)]);

% plot the graph
figure(1)
plot(1:Nmax,Xn(2:end),'bx-',1:Nmax,Xbound,'ro-','Linewidth',2)
legend('MVA','Bound','Location','Best')
xlabel('Number of terminals')
ylabel('System throughput')
%print -depsc week08_q1_tp 

% Find the speed up factor for CPU
sfv = 1:0.1:2;
Nsf = length(sfv);
rt_new = zeros(Nsf,1);
N = 70; 

for i = 1:Nsf
    sf = sfv(i);
    Dnew = D;
    Dnew(1) = Dnew(1) / sf; 
    [R,X,nbar,Rzero,Xn,U] = mva_sc(Dnew,V,N,Z);
    rt(i) = Rzero(end);
end    

figure(2)
plot(sfv,rt,'b-',[1 2],0.3*[1 1],'r-','Linewidth',2)
legend('response time','targe respons time','Location','Best')
grid
xlabel('Speeding up factor for CPU')
ylabel('Response time')
%print -depsc week06B_q1_rt 
    
    


