n_vector = [1 10 40 200 400 450 490 499 500];
n_vector = [n_vector n_vector+500];
n_vector = n_vector(1:end-1);
timer_period = 1;

spekt_plot(NaN, NaN, n_vector(1));
for k=2:length(n_vector)
    t1 = timer('StartDelay',timer_period,'TasksToExecute',1,'TimerFcn', {@spekt_plot, n_vector(k)});
    start(t1)
    wait(t1)
end