clc
close all
clear all

%% --- Data

maxW = 10; % max weight [kg]
payloadW = 1.25; % min payload weight [kg]
% We assume worst case scenario, structural mass = 50%
structW = 0.5*maxW; % weight of the structure[kg]
g = 9.81; % [m/s^2]
rho = 1.225; %[kg/m3]
l = 10; % maximum takeoff length[m]
CLflap = 1.6;
e = 0.7; % assume Oswald coefficient to be 0.7
b = 5; % impose maximum wingspan 

tof = 15*60; % time of flight [s]
%We can assume TAS = EAS since the drone will be flying close to the ground
EAS = [40:50]./1.94384; % Equivalent air speed [m/s]

%% --- Motor data from T-motor
maxT = [4805;4116;4316;3854;2844]./1000;
% ----- (Thrust[g] -- E)
Engine_eff=[1382	7.11    973	    8.40    1076	7.72    1021	7.60    921	    9.11
            1581	6.85    1169	7.76    1332	7.24    1214	7.23    1030	8.62
            1795	6.49    1408	7.38    1583	6.65    1468	6.74    1168	8.16
            2063	6.16    1689	6.75    1881	6.22    1785	6.28    1328	7.70
            2369	5.80    1954	6.39    2185	5.84    2033	5.92    1534	7.17
            2736	5.45    2247	5.96    2526	5.47    2323	5.54    1730	6.75
            3104	5.13    2529	5.62    2817	5.17    2570	5.26    1914	6.42
            3450	4.90    2863	5.26    3101	4.87    2852	4.96    2140	6.02
            3826	4.69    3216	4.99    3457	4.58    3111	4.73    2317	5.80
            4265	4.42    3787	4.49    4072	4.14    3607	4.30    2680	5.35
            4805	3.80    4116	4.26    4316	3.93    3854	4.09    2844	5.16
    ];

%% --- Take off calculation
vf = (g.*maxT./maxW).*sqrt((2.*l)./(g.*maxT./maxW)); % final speed per engine
vf_margin = vf.*0.9; % margin for takeoff

%% --- Wing designed based on take off speed (NACA0012 airfoil)
% Realistic values assumed
xg = 0.52; % Position of COG
xn = 0.55; % Position of COL
xlc = 2.5; % Position of COL of tail

L = maxW./(1-((xn-xg)./(xlc-xg))); % momentum equilibrium
Wing_surface = (2*L*g)./(rho.*(vf_margin.^2)*CLflap);
AR = (b.^2)./Wing_surface; % We use 5 m as the max wingspan to be realistic
% and impose a max AR of 20 for structural integrity

c = Wing_surface./b;
% Stability margin of the 5 configurations
sm = (xn - xg)./c

x = 1:length(maxT);
yw = 20.*ones(length(x),1);
plot(x,AR,'o',x,Wing_surface,'*',x,vf_margin,'x',x,yw,'r--','LineWidth',2)
grid on
legend('Aspect Ratio', 'Wing Surface', 'Takeoff speed')


CL = (2.*L.*g)./(rho.*(EAS.^2).*Wing_surface);

% - NACA 0012 airfoil data with Re = 200.000
polar=[0.000   0.0000   0.01020   0.00520   0.0000   0.9046   0.9047
       0.250   0.0350   0.01022   0.00521  -0.0004   0.8886   0.9182
       0.500   0.0700   0.01025   0.00522  -0.0009   0.8696   0.9304
       0.750   0.1048   0.01028   0.00521  -0.0015   0.8482   0.9424
       1.000   0.1454   0.01034   0.00519  -0.0033   0.8255   0.9510
       1.250   0.1861   0.01040   0.00518  -0.0054   0.7978   0.9593
       1.500   0.2255   0.01048   0.00517  -0.0072   0.7684   0.9686
       1.750   0.2684   0.01056   0.00512  -0.0100   0.7357   0.9756
       2.000   0.3085   0.01066   0.00509  -0.0122   0.7012   0.9843
       2.250   0.3513   0.01075   0.00504  -0.0152   0.6637   0.9915
       2.500   0.3942   0.01085   0.00497  -0.0183   0.6249   0.9979
       2.750   0.4235   0.01094   0.00492  -0.0188   0.5886   1.0000
       3.000   0.4462   0.01104   0.00489  -0.0180   0.5545   1.0000
       3.250   0.4689   0.01118   0.00489  -0.0172   0.5202   1.0000
       3.500   0.4915   0.01134   0.00492  -0.0163   0.4857   1.0000
       3.750   0.5138   0.01153   0.00498  -0.0155   0.4509   1.0000
       4.000   0.5357   0.01176   0.00507  -0.0145   0.4160   1.0000
       4.250   0.5571   0.01203   0.00521  -0.0134   0.3810   1.0000
       4.500   0.5782   0.01234   0.00536  -0.0123   0.3456   1.0000
       4.750   0.5990   0.01268   0.00556  -0.0111   0.3101   1.0000
       5.000   0.6195   0.01306   0.00580  -0.0099   0.2744   1.0000
       5.250   0.6395   0.01350   0.00609  -0.0086   0.2398   1.0000
       5.500   0.6591   0.01400   0.00643  -0.0072   0.2077   1.0000
       5.750   0.6784   0.01455   0.00683  -0.0058   0.1796   1.0000
       6.000   0.6971   0.01516   0.00729  -0.0043   0.1563   1.0000
       6.250   0.7161   0.01577   0.00781  -0.0028   0.1374   1.0000
       6.500   0.7351   0.01641   0.00837  -0.0013   0.1223   1.0000
       6.750   0.7535   0.01712   0.00900   0.0003   0.1104   1.0000
       7.000   0.7725   0.01776   0.00961   0.0018   0.1005   1.0000
       7.250   0.7919   0.01844   0.01031   0.0033   0.0925   1.0000
       7.500   0.8096   0.01936   0.01114   0.0049   0.0858   1.0000
       7.750   0.8300   0.01995   0.01181   0.0062   0.0799   1.0000
       8.000   0.8481   0.02112   0.01285   0.0077   0.0749   1.0000
       8.250   0.8690   0.02173   0.01362   0.0089   0.0707   1.0000
       8.500   0.8890   0.02251   0.01438   0.0101   0.0667   1.0000
       8.750   0.9087   0.02387   0.01574   0.0112   0.0635   1.0000
       9.000   0.9291   0.02472   0.01674   0.0124   0.0604   1.0000
       9.250   0.9492   0.02559   0.01762   0.0135   0.0575   1.0000
       9.500   0.9693   0.02734   0.01932   0.0143   0.0550   1.0000
       9.750   0.9882   0.02844   0.02068   0.0156   0.0532   1.0000
      10.000   1.0067   0.02966   0.02206   0.0168   0.0511   1.0000
      10.250   1.0251   0.03077   0.02323   0.0179   0.0492   1.0000
      10.500   1.0445   0.03262   0.02503   0.0185   0.0474   1.0000
      10.750   1.0571   0.03445   0.02718   0.0203   0.0462   1.0000
      11.000   1.0681   0.03636   0.02942   0.0222   0.0451   1.0000
      11.250   1.0773   0.03842   0.03177   0.0241   0.0441   1.0000
      11.500   1.0860   0.04035   0.03390   0.0258   0.0430   1.0000
      11.750   1.0969   0.04194   0.03558   0.0272   0.0419   1.0000
      12.000   1.1068   0.04366   0.03735   0.0286   0.0410   1.0000
      12.250   1.1101   0.04727   0.04108   0.0298   0.0401   1.0000
      12.500   1.0959   0.04960   0.04372   0.0334   0.0399   1.0000
      12.750   1.0790   0.05258   0.04700   0.0360   0.0397   1.0000
      13.000   1.0599   0.05626   0.05095   0.0372   0.0396   1.0000
      13.250   1.0385   0.06069   0.05564   0.0369   0.0396   1.0000
      13.500   1.0150   0.06603   0.06120   0.0352   0.0396   1.0000
      13.750   0.9898   0.07237   0.06774   0.0319   0.0398   1.0000
      14.000   0.9632   0.07976   0.07532   0.0275   0.0399   1.0000
        ];

CDplot = linspace(0.01020,0.07976,10000);
CLplot = interp1(polar(:,3),polar(:,2),CDplot);

CDbody = 0.03; % Assumed
CD = interp1(polar(:,2),polar(:,3),CL);
CDi = (CL.^2)./(pi.*AR.*e); % Inuced drag coefficient
E = CL./(CD + CDi + CDbody);

figure()
plot(CDplot,CLplot,polar(:,3),polar(:,2),'o')
grid on; title('CL v CD');
legend('','CL')

T = 1000.*maxW./E;
motor = 1:length(maxT);

figure
surf(EAS.*1.94384,motor,E)
colorbar; title('Efficiency')
xlabel('EAS [kts]'); ylabel('Motor number'); zlabel('Efficiency')
grid on;

figure
surf(EAS.*1.94384,motor,T)
colorbar; title('Required thrust')
xlabel('EAS [kts]'); ylabel('Motor number'); zlabel('Thrust [g]')
grid on

E = [interp1(Engine_eff(:,1),Engine_eff(:,2),T(1,:))
    interp1(Engine_eff(:,3),Engine_eff(:,4),T(2,:))
    interp1(Engine_eff(:,5),Engine_eff(:,6),T(3,:))
    interp1(Engine_eff(:,7),Engine_eff(:,8),T(4,:))
    interp1(Engine_eff(:,9),Engine_eff(:,10),T(5,:))];

x5 = linspace(0,4805,5000);

%% --- Energy consumption for the flight
Energy = 0.25.*T./E;
% plotting power consumed
figure
surf(EAS.*1.94384,motor,Energy)
colorbar; title('Energy consumed in cruise')
xlabel('EAS [kts]'); ylabel('Motor number'); zlabel('Energy consumed [Wh]')
grid on;

maxP = [1263.33;966.63;1098.29;942.71;550.80];
% assume 20 s of maxT to takeoff - ascent
Energy_start = (20./3600).*maxP;
EnergyTot = [Energy(1,:) + Energy_start(1)
            Energy(2,:) + Energy_start(2)
            Energy(3,:) + Energy_start(3)
            Energy(4,:) + Energy_start(4)
            Energy(5,:) + Energy_start(5)];

figure
surf(EAS.*1.94384,motor,EnergyTot)
colorbar; title('Energy consumed in total')
xlabel('EAS [kts]'); ylabel('Motor number'); zlabel('Energy consumed [Wh]')
grid on;

%% Battery and motor weight calculation
Energy_for_batteries = EnergyTot(1:4,1); % Motor 5 is too inefficient
Engine_weight = [298;218;219;221];
Voltage = [22;22;18;15.2];
Battery_capacity_req = ((Energy_for_batteries.*1000)./Voltage)./0.8
Battery_weight = [434;495;553;468];
Total_weight = Battery_weight + Engine_weight

figure
plot(motor(1:4),Total_weight,'k*','LineWidth',2);
grid on; xlabel('Engine n'); ylabel('Total weight');
title('Total weight of engine + battery configuration');

%% --- Inertia tensor calculations

% I will approximate the plane a cylinder(fuselage + payload + tail section)
% with two beams (wing)

m_fuselage = 0.8*maxW; % mass of the cylinder
m_wings = maxW - m_fuselage; % mass of the wings
r_fuselage = 0.2; % radius of the fuselage, I assume 20cm
l_fuselage = 2.5; % length of the fuselage, I assume 2.5m

Ixx = (1/12)*m_wings*(b^2) + 0.5*m_fuselage*(r_fuselage^2);
Iyy = (1/12)*m_fuselage*(3*(r_fuselage^2) + (l_fuselage^2)); % Assume wing inertia to be negligible in pitch
Izz = (1/12)*m_wings*(b^2) + (1/12)*m_fuselage*(3*(r_fuselage^2) + (l_fuselage^2));

I = diag([Ixx Iyy Izz])