D=dir('data/SMP/*2s7*_derivatives.csv');
%%
figure(1);clf
for n=1:length(D)
    T=readtable(['data/SMP/' D(n).name]);
    figure(1); hold on
    plot(T.distance_mm_,T.P2015_ssa_m_2_kg_,'r')
    pause
end
%% lets look at the force record first
D=dir('data/SMP/*2s7*_samples.csv');
figure(2);clf
for n=1:1
    T=readtable(['data/SMP/' D(n).name]);
    figure(2); hold on
    plot(T.distance_mm_,T.force_N_,'r')
end
hold on
plot([218.3 218.3],[0 20],'k-','linewidth',2)
plot([950 950],[0 20],'k-','linewidth',2)


%% get some meta info
f=D(n).name;
sg=readtable([f(1:end-12) '.PNT.sg'])

