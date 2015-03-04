% testIterateAndPlotAll

tests = [1:5];

if any(tests == 1)      %  1 variables
    
    % 1a) 1 variable,  1 output,  1 trial
    f1 = @(x)   rand*x;
    f1v = @(x)  rand(3,1)*x;
    xs = [1:10];
    vars = {xs};
    labels = {'x'};
    labelsv = {'x', {'a', 'b', 'c'}};
    nTrials = 5;
    data1 = iterateOverValues( f1, vars );
    data1n = iterateOverValues( f1, vars, nTrials );
    
    % 1.1.1 a) 1 input,  1 output, single trial -- Single axis   
    close all;
    plotAllResults(data1, vars, labels, {'plot'});
    input('1 input, 1 output, 1 trial. Single axis. OK?');

    % 1.1.2 b) 1 input,  1 output, N trials    
    close all;
    plotAllResults(data1n, vars, labels, {'plot'});
    input('1 input, 1 output, N trials. Single axis. OK?');
    
    
    % 1.2.1 a) 1 input, vector output,  1 trial.  Plot on same axes
    data1v = iterateOverValues( f1v, vars );
    close all;
    plotAllResults(data1v, vars, labelsv, {'plot'});
    input('1 input, vector output, 1 trial. Single axis.  OK?');

    % 1.2.2 b) 1 input, vector output, N trials
    data1vn = iterateOverValues( f1v, vars, nTrials );
    close all;
    plotAllResults(data1vn, vars, labelsv, {'plot'});
    input('1 input, vector output, N trials. OK?');
    
end


if any(tests == 2)      %  2 variables
    
    f2 = @(x,y)  y + (randn*x);
    f2v = @(x,y)  y + (randn(4,1)*x);

    xs = [2:10];
    ys = [.1 .2];
    vars = {xs, ys};
    labels = {'x', 'y'};
    labelsv = {'x', {'a', 'b', 'c', 'd'}, 'y'};
    nTrials = 5;
    data2 = iterateOverValues( f2, vars );
    data2n = iterateOverValues( f2, vars, nTrials );
    data2v = iterateOverValues( f2v, vars );
    data2vn = iterateOverValues( f2v, vars, nTrials);
    
    
    %%%%%%% SCALAR output. 
    %2.1.1 a) 2 inputs, 1 output,  1 trial.  Plot on same axis
    close all;
    plotAllResults(data2, vars, labels, {'plot', 'plot'})
    input('2 inputs, 1 output, 1 trial.  Plot on same axis. OK?');

    %2.1.1 b) 2 inputs, 1 output,  n trials.  Plot on same axis
    close all;
    plotAllResults(data2n, vars, labels, {'plot', 'plot'})
    input('2 inputs, 1 output, N trials.  Plot on same axis. OK?');
    

    %2.1.2 a) 2 inputs, 1 output,  1 trial.  Plot on different subfigures
    close all;
    plotAllResults(data2, vars, labels, {'plot', 'sub'})
    input('2 inputs, 1 output, 1 trial.  Plot on different subfigures: OK?');

    %2.1.2 b) 2 inputs, 1 output,  n trials.  Plot on different subfigures
    close all;
    plotAllResults(data2n, vars, labels, {'plot', 'sub'})
    input('2 inputs, 1 output, N trials.  Plot on different subfigures: OK?');
    
    
    %2.1.3 a) 2 inputs, 1 output,  1 trial.  Plot on different figures
    close all;
    plotAllResults(data2, vars, labels, {'plot', 'fig'})
    input('2 inputs, 1 output, 1 trial.  Plot on different figures: OK?');
    
    %2.1.3 b) 2 inputs, 1 output,  n trials.  Plot on different figures
    close all;
    plotAllResults(data2n, vars, labels, {'plot', 'fig'})
    input('2 inputs, 1 output, N trials.  Plot on different figures: OK?');
   
    
    
    %%%%%% VECTOR output. 
    %2.2.1 a) 2 inputs, vector output,  1 trial.  Plot on same axes, then subfigures
    close all;
    plotAllResults(data2v, vars, labelsv, {'plot', 'sub'})
    input('2 inputs, vector output, 1 trial.  Plot on same axes, then different subfigures: OK?');

    %2.2.1 b) 2 inputs, vector output,  n trials.  Plot on same axes, then subfigures
    close all;
    plotAllResults(data2vn, vars, labelsv, {'plot', 'sub'})
    input('2 inputs, vector output, N trials.  Plot on same axes, then different subfigures: OK?');


    
    %2.2.2 a) 2 inputs, vector output,  1 trial.  Plot on same axes, then different figures
    close all;
    plotAllResults(data2v, vars, labelsv, {'plot', 'fig'})
    input('2 inputs, vector output, 1 trial.  Plot on same axes, then different figures: OK?');
                    
    %2.2.2 b) 2 inputs, vector output,  n trials.  Plot on same axes, then  different figures
    close all;
    plotAllResults(data2vn, vars, labelsv, {'plot', 'fig'})
    input('2 inputs, vector output, N trials.  Plot on same axes, then different figures: OK?');
    
    
    
end


if any(tests == 3)      %  3 variables

    f3 = @(x,y,z)   y + (randn*x) + z;
    f3v = @(x,y,z)  y + (randn(4,1)*x) + z;
    
    xs = [2:10];
    ys = [.1 .2 .3];
    zs = [20 40 100 200];
    vars = {xs, ys, zs};
    labels = {'x', 'y', 'z'};
    labelsv = {'x', {'a', 'b', 'c', 'd'}, 'y', 'z'};
    nTrials = 5;
    
    data3 = iterateOverValues( f3, vars );
    data3v = iterateOverValues( f3v, vars );
    data3n = iterateOverValues( f3, vars, nTrials );
    data3vn = iterateOverValues( f3v, vars, nTrials );
    

    %%% Single output. 
    %3.1.1 a) 3 inputs, 1 output,  1 trial.  Plot on same axis, then subfigures 
    close all;
    plotAllResults(data3, vars, labels, {'plot', 'plot', 'sub'})
    input('3 inputs, 1 output, 1 trial.  Plot on same axis, then subfigures: OK?');
    
    %3.1.1 b) 3 inputs, 1 output,  N trials.  Plot on same axis, then subfigures
    close all;
    plotAllResults(data3n, vars, labels, {'plot', 'plot', 'sub'})
    input('3 inputs, 1 output, N trials.  Plot on same axis, then subfigures: OK?');


    %3.1.1 a) 3 inputs, 1 output,  1 trial.  Plot on same axis, then figures 
    close all;
    plotAllResults(data3, vars, labels, {'plot', 'plot', 'fig'})
    input('3 inputs, 1 output, 1 trial.  Plot on same axis, then figures: OK?');
    
    %3.1.1 b) 3 inputs, 1 output,  N trials.  Plot on same axis, then figures
    close all;
    plotAllResults(data3n, vars, labels, {'plot', 'plot', 'fig'})
    input('3 inputs, 1 output, N trials.  Plot on same axis, then figures: OK?');
    
    
    %3.1.2 a) 3 inputs, 1 output,  1 trial.  Plot on subfigures x, y
    close all;
    plotAllResults(data3, vars, labels, {'plot', 'sub', 'sub'})
    input('3 inputs, 1 output, 1 trial.  Plot on subfigures x, y: OK?');

    %3.1.2 b) 3 inputs, 1 output,  N trials.  Plot on subfigures x, y
    close all;
    plotAllResults(data3n, vars, labels, {'plot', 'sub', 'sub'})
    input('3 inputs, 1 output, N trials.  Plot on subfigures x, y: OK?');

    
    %3.1.3 a) 3 inputs, 1 output,  1 trial.  Plot on subfigures, then figures
    close all;
    plotAllResults(data3, vars, labels, {'plot', 'sub', 'fig'})
    input('3 inputs, 1 output, 1 trial.  Plot on subfigures, then figures: OK?');
       
    %3.1.3 b) 3 inputs, 1 output,  N trials.  Plot on subfigures, then figures
    close all;
    plotAllResults(data3n, vars, labels, {'plot', 'sub', 'fig'})
    input('3 inputs, 1 output, N trials.  Plot on subfigures, then figures: OK?');


    
    %%% Vector output. Single trial            
    %3.2.1 a) 3 inputs, vector output,  1 trial.  Plot on subfigures x, y
    close all;
    plotAllResults(data3v, vars, labelsv, {'plot', 'sub', 'sub'})
    input('3 inputs, vector output, 1 trial.  Plot on subfigures x, y: OK?');

    %3.2.2 b) 3 inputs, vector output,  N trials.  Plot on subfigures x, y
    close all;
    plotAllResults(data3vn, vars, labelsv, {'plot', 'sub', 'sub'})
    input('3 inputs, vector output, N trials.  Plot on subfigures x, y: OK?');

    
    %3.2.1 b) 3 inputs, vector output,  1 trial.  Plot on subfigures, then different figures
    close all;
    plotAllResults(data3v, vars, labelsv, {'plot', 'sub', 'fig'})
    input('3 inputs, vector output, 1 trial.  Plot on subfigures, then different figures: OK?');

    %3.2.2 b) 3 inputs, vector output,  N trials.  Plot on subfigures ,then different figures
    close all;
    plotAllResults(data3vn, vars, labelsv, {'plot', 'sub', 'fig'})
    input('3 inputs, vector output, N trials.  Plot on subfigures, then different figures: OK?');

    

end


if any(tests == 4)      %  4 variables

    f4 = @(x,y,z,w)  y + (randn*x) + z - w;
    f4v = @(x,y,z,w)  y + (randn(1,3)*x) + z - w;

    xs = [2:10];
    ys = [.1 .2];
    zs = [20 40 60];
    ws = [6:7];
    vars = {xs, ys, zs, ws};
    labels = {'x', 'y', 'z', 'w'};
    labelsv = {'x', {'a', 'b', 'c'}, 'y', 'z', 'w'};
    nTrials = 5;
    
    data4 = iterateOverValues( f4, vars );
    data4v = iterateOverValues( f4v, vars );
    data4n = iterateOverValues( f4, vars, nTrials );
    data4vn = iterateOverValues( f4v, vars, nTrials );
    
    
    %%% Single output. 
    %4.1.1 a) 4 inputs, 1 output,  1 trial.  Plot on same axis, then subfigures x, y
    close all;
    plotAllResults(data4, vars, labels, {'plot', 'plot', 'sub', 'sub'})
    input('4 inputs, 1 output, 1 trial.  Plot on same axis, then subfigures x, y: OK?');
    
    %4.1.1 b) 4 inputs, 1 output,  N trials.  Plot on same axis, then subfigures
    close all;
    plotAllResults(data4n, vars, labels, {'plot', 'plot', 'sub', 'sub'})
    input('4 inputs, 1 output, N trials.  Plot on same axis, then subfigures x, y: OK?');

   
    %4.1.2 a) 4 inputs, 1 output,  1 trial.  Plot on same axis, then subfigures, then figures 
    close all;
    plotAllResults(data4, vars, labels, {'plot', 'plot', 'sub', 'fig'})
    input('4 inputs, 1 output, 1 trial.  Plot on same axis, then subfigures, then figures: OK?');
    
    %4.1.2 b) 4 inputs, 1 output,  N trials.  Plot on same axis, then subfigures, then figures
    close all;
    plotAllResults(data4n, vars, labels, {'plot', 'plot', 'sub', 'fig'})
    input('4 inputs, 1 output, N trials.  Plot on same axis, then subfigures, then figures: OK?');
    
    
    %4.1.3 a) 4 inputs, 1 output,  1 trial.  Plot on subfigures x, y, then figures
    close all;
    plotAllResults(data4, vars, labels, {'plot', 'sub', 'sub', 'fig'})
    input('4 inputs, 1 output, 1 trial.  Plot on subfigures x, y, then figures: OK?');

    %4.1.3 b) 4 inputs, 1 output,  N trials.  Plot on subfigures x, y, then figures
    close all;
    plotAllResults(data4n, vars, labels, {'plot', 'sub', 'sub', 'fig'})
    input('4 inputs, 1 output, N trials.  Plot on subfigures x, y, then figures: OK?');

    
    %%% Vector output. Single trial            
    %4.2.1 a) 4 inputs, vector output,  1 trial.  Plot on subfigures x, y, then figures
    close all;
    plotAllResults(data4v, vars, labelsv, {'plot', 'sub', 'sub', 'fig'})
    input('4 inputs, vector output, 1 trial.  Plot on subfigures x, y, then figures: OK?');

    %4.2.2 b) 4 inputs, vector output,  N trials.  Plot on subfigures x, y, then figures
    close all;
    plotAllResults(data4vn, vars, labelsv, {'plot', 'sub', 'sub', 'fig'})
    input('4 inputs, vector output, N trials.  Plot on subfigures x, y, then figures: OK?');
    

end


if any(tests == 5)      %  5 variables

    f5 = @(x,y,z,w,u)  y + (randn*x) + z - w * u;
%     f5v = @(x,y,z,w)  y + (randn(1,3)*x) + z - w;

    xs = [2:10];
    ys = [.1 .2];
    zs = [20 40 60];
    ws = [6:7];
    us = [9,10];
    vars = {xs, ys, zs, ws, us};
    labels = {'x', 'y', 'z', 'w', 'u'};
%     labelsv = {'x', 'V', 'y', 'z', 'w'};
    nTrials = 5;
    
    data5 = iterateOverValues( f5, vars );
    data5n = iterateOverValues( f5, vars, nTrials );
%     data5v = iterateOverValues( f5v, vars );
%     data5vn = iterateOverValues( f5v, vars, nTrials );
    
    
    %%% Single output. 
    %5.1.1 a) 5 inputs, 1 output,  1 trial.  Plot on same axis, then subfigures x, y, then figures
    close all;
    plotAllResults(data5, vars, labels, {'plot', 'plot', 'sub', 'sub', 'fig'})
    input('5 inputs, 1 output, 1 trial.  Plot on on same axis, then subfigures x, y, then figures: OK?');
    
    %5.1.1 b) 5 inputs, 1 output,  N trials.  Plot on same axis, then subfigures x, y, then figures
    close all;
    plotAllResults(data5n, vars, labels, {'plot', 'plot', 'sub', 'sub', 'fig'})
    input('5 inputs, 1 output, N trials.  Plot on same axis, then subfigures x, y, then figures: OK?');

   


end
