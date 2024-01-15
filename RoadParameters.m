P_Noise = 28.5;
V = 80;              % Vehicle Speed in km/h
u = V*1000/3600;     % Vehicle Speed in m/s

%Road Class B
GqOmega0 = 0.000004; % Road roughness coefficient
Gqn0 = 0.000064;
%Gqn0_upper_limit = 0.000128;
%Gqn0_lower_limit = 0.000512;

%{

Road Class A: GqOmega0 = 1 X 10^-6 (0.000001)
              Gqn0 = 16 x16 X 10^-6 (0.000016)


Road Class B: GqOmega0 = 4 X 10^-6 (0.000004)
              Gqn0 = 64 X 10^-6 (0.000064)

Road Class C: GqOmega0 = 16 X 10^-6 (0.000016)
              Gqn0 = 256 X 10^-6 (0.000256)

Road Class D: GqOmega0 = 64 X 10^-6 (0.000064)
              Gqn0 = 1024 X 10^-6 (0.001024)

Road Class E: GqOmega0 = 256 X 10^-6 (0.000256)
              Gqn0 = 4096 X 10^-6 (0.004096)
%}
