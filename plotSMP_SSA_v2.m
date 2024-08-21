% lets load the derivatives, samples, and surf/ground picks
site='2s7';
D=dir(['data/SMP/*' site '*_sg.csv']); % find the surf/ground picks
for n=1:length(D);
    T=readtable(['data/SMP/' D(n).name])
    S(n).surf=T.Var2(2); % grab surface location
    S(n).gnd=T.Var2(3); % grab ground location
    % now load samples
    f=D(n).name; f2=[f(1:end-6) 'samples.csv'];
    T=readtable(['data/SMP/' f2]);
    S(n).dist=T.distance_mm_;
    S(n).force=T.force_N_;
    Ix=S(n).dist>S(n).surf;
    S(n).dist=S(n).dist(Ix);
    S(n).force=S(n).force(Ix);
    % plot with surface and ground picks
    figure(1);
    plot(S(n).dist,S(n).force,'k'); hold on
    plot([S(n).surf S(n).surf],[0 max(S(n).force)],'r','linewidth',2)
    plot([S(n).gnd S(n).gnd],[0 max(S(n).force)],'g','linewidth',2)
    figure(2); % now plot from ground up
    S(n).dist2=S(n).gnd-S(n).dist;
    plot(S(n).dist2,S(n).force,'k'); hold on
    % now load SSA data
    f2=[f(1:end-6) 'derivatives.csv'];
    T=readtable(['data/SMP/' f2]);
    S(n).SSA_P2015=T.P2015_ssa_m_2_kg_;
    S(n).rho=T.P2015_density_kg_m_3_;
    S(n).dist3=T.distance_mm_;
    Ix=find(S(n).dist3>S(n).surf); % find data after surface
    S(n).SSA_P2015=S(n).SSA_P2015(Ix);
    S(n).rho=S(n).rho(Ix);
    S(n).dist3=S(n).dist3(Ix);
    S(n).dist4=S(n).gnd-S(n).dist3;
    figure(3);
    plot(S(n).dist4,S(n).SSA_P2015); hold on
    figure(4);
    plot(S(n).dist4,S(n).rho); hold on
end


%% now lets compare to microCT
T=readtable('data/microCT/microCT_pit2s7.csv')
figure(5);clf
for n=1:3
     h1=plot(S(n).dist4/10,S(n).SSA_P2015,'r','linewidth',1); hold on
end
h2=plot(T.height_ave_cm_,T.SSA_m2_kg_,'linewidth',4)
hold on
% lets average SMP over the microCT subsamples
for n=1:height(T)
    for m=1:3
        Ix=find(S(m).dist4/10>T.height_min_cm_(n) & S(m).dist4/10<T.height_max_cm_(n));
        SSA2(n,m)=median(S(m).SSA_P2015(Ix));
    end
end
figure(5); hold on
h3=plot(T.height_ave_cm_,SSA2,'g','linewidth',2)

% lets load the IceCube data at this site
f='data/SSA/DB_SSA_2S7.csv';
T=readtable(f);
SSA_IC=T.value;
SSA_IC_depth=T.depth;
h4=plot(SSA_IC_depth,SSA_IC,'ko','linewidth',3,'markersize',10)
set(gca,'LineWidth',2,'FontSize',14,'FontWeight','bold')
xlabel('depth above ground [cm]')
ylabel('SSA (m^2/kg)')
title('Pit 2s7')
legend([h1 h2 h3(1) h4],'SMP high-res','microCT','SMP median','IceCube')





