function H = haar(N, fullFlag, showRowsFlag)

    doFull = exist('fullFlag', 'var') && ~isempty(fullFlag);

    if doFull
        N_rows = 2*N;
    else
        N_rows = N;
    end
    
    H = zeros(N_rows, N);

    ts = [0:N-1]/N;
    
    ks = 0:N_rows-1;
%     ps = zeros(1,N);
%     qs = zeros(1,N);
    
    H(1,:) = 1;
    
    for ki = 2:N_rows
        k = ks(ki)+1;
        if ~doFull
            idx = find(2.^ks < k, 1, 'last');
            ps(ki) = ks(idx);
            qs(ki) = k-2.^ps(ki);
            p = ps(ki);
            q = qs(ki);
        else
            idx = find(2.^(ks-1) < k, 1, 'last');
            ps(ki) = ks(idx);
            qs(ki) = k-2.^ps(ki);
            p = ps(ki);
            q = qs(ki);                        
        end
        
%         p = ks(idx);
%         q = k-2.^p;

        tp = 2^p;
        for ti = 1:N
            t = ts(ti);
            v = 0;
            if (q-1)/tp <= t && t < (q-.5)/tp
                v = 2^(p/2);
            elseif (q-.5)/tp <= t && t < q/tp
                v = -2^(p/2);
            end
            H(ki,ti) = v;
        end
    
    end
    H = H/sqrt(N);
    
%     ks
%     ps
%     qs
   
    
    showRows = exist('showRowsFlag', 'var') && ~isempty(showRowsFlag);

    if showRows
    
        subM = floor(sqrt(N_rows));
        subN = ceil(N_rows/subM);

        ext = @(x) [x, x(end)+diff(x(1:2))];
        rep = @(x) x([1:end, end]);

        figure(443); clf;
        for i = 1:N_rows
            subplot(subM, subN, i);

%             hnd_ax(2,i) = axes('position', p);
            h = rep(H(i,:));
            h = h/max(abs(h));
            xdata = [0:N] + .5;
%             xdata = linspace(0, 1, N+1);
            stairs(xdata, h, 'b'); hold on;
            plot(1:N, h(1:end-1), 'b.');        
            xlim([0, N]+.5);
            ylim([-1.2, 1.2]);
        end

    end
    
    
%     figure(9);
%     clf;
%     for i = 1:N
%         h(i) = subplot(2,4,i);
%         stairs(H(i,:)); hold on;
%         plot([1:N], H(i,:), '.'); hold on;
%     end
%     matchAxes('Y', h)
    
    


end







% /* Inputs: vec = input vector, n = size of input vector */
% void haar1d(float *vec, int n)
% {
%      int i=0;
%      int w=n;
%      float *vecp = new float[n];
%      for(i=0;i<n;i++)
%           vecp[i] = 0;
% 
%      while(w>1)
%      {
%           w/=2;
%           for(i=0;i<w;i++)
%           {
%                vecp[i] = (vec[2*i] + vec[2*i+1])/sqrt(2.0);
%                vecp[i+w] = (vec[2*i] - vec[2*i+1])/sqrt(2.0);
%           }
% 
%           for(i=0;i<(w*2);i++)
%                vec[i] = vecp[i]; 
%      }
% 
%      delete [] vecp;
% }