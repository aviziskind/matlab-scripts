function [t_itp, y_itp] = sincInterp(t, y, itpFactor, itpWidth, t_lims)
    % fourier interpolation of y (a single vector, or columns of vectors)
    % - itpWidth determines how many points on either side are used to interpolate.
    % - to only output the function within a certain range, use "t_lims" (2-element vector with the desired range).

    persistent sincArr

    if isvector(y)
        y = y(:);
    end    
    [Ny, ncols] = size(y);
    
    if length(t) ~= Ny
        error('Length of t must be the same length as the columns of y');
    end
    
    if nargin < 4
        itpFactor = 10;
    end
    
    itpWidthInput = exist('itpWidth', 'var') && ~isempty(itpWidth);
    t_limsInput = exist('t_lims', 'var') && ~isempty(t_lims);
    
    if ~t_limsInput && ~t_limsInput
        error('You must provide either the interpolation width or the interpolation limits');
    end        
    
    if ~itpWidthInput
        itpWidth = 40;
    end
    if ~t_limsInput
        t_lims = t([itpWidth+1,  end-itpWidth-1]);
    end    
    
    if length(t_lims) > 2
        t_lims = [t_lims(1), t_lims(end)];
    end
    
    if (t_lims(1) <= t(1)) || (t_lims(2) >= t(end))
        error('the output limits range (t_lims) must be within the range of the input (t)');
    end
    dt = diff(t(1:2));
    
    itpWidthMax = round( min( t_lims(1)-t(1), t(end)-t_lims(2)) /dt);
    itpWidth = min(itpWidth, itpWidthMax);
    
    if isempty(sincArr) || ~isequal(size(sincArr), [itpFactor-1, itpWidth*2+1]);  
%         sincArr = zeros(itpFactor-1, itpWidth*2+1);
        phase= bsxfun(@minus, [1 : itpFactor-1]'/itpFactor, [-itpWidth : itpWidth]);
        sincArr = sin(pi*phase)./(pi*phase) .* (1 - (phase/itpWidth).^2); % sinc function x Welch window.
    end
    
    % determine output t (t_itp)
    dt = diff(t(1:2));       
    t_idxInWindow = find ( ibetween(t, t_lims(1), t_lims(2)) );     
    Ny_inWindow = length(t_idxInWindow);        
    
    t_range = t(t_idxInWindow([1, end])) ;
    Ny_itp = round ( diff(t_range) / (dt/itpFactor) )+1;       
    t_itp = linspace( t_range(1), t_range(2), Ny_itp);
    
    
    % determine output y (y_itp)
    itpWidthVec  = -itpWidth:itpWidth;
    itpVec       = 1:itpFactor-1;
    
    y_itp = zeros(Ny_itp, ncols);    
    y_itp(itpFactor*[0:Ny_inWindow-1]+1,:) = y(t_idxInWindow,:);
    
    for pos_idx = 1:length(t_idxInWindow)-1
        pos = t_idxInWindow(pos_idx);
        ipos = itpFactor*(pos_idx-1)+1;
        
        interp_vals = sincArr * y(pos+itpWidthVec,:);
        y_itp(ipos+itpVec,:)=interp_vals;
    end

end

%   for (pos=left_position; pos < right_position; pos++){
%     ipos = interp_factor*(pos - left_position);
%     y_itp[ipos]=sgetSample( grp, chnl, pos);
%     for (i=1; i<interp_factor; i++) {
%       interp_sum=0.0;
%       for(j=-interp_h_width; j<interp_h_width+1; j++) {
%         interp_sum += (double)sgetSample( grp, chnl, pos+j)* \
%             sincArr[i-1][j+interp_h_width];
%       }
%       y_itp[i+ipos]=(int)interp_sum;
%     }
%   }
%   y_itp[interp_factor*(right_position-left_position)]=sgetSample( grp, chnl, right_position);
  


%         sincArr = zeros(itpFactor-1,itpWidth*2+1);
%         for i = [-itpWidth : itpWidth]
%             for sub_i = 0 : itpFactor-1
%                 phase=((sub_i+1)/itpFactor) - i;
%                 sincArr(sub_i+1, i+itpWidth+1) = sin(pi*phase)/(pi*phase)* ...
%                     (1 - (phase/itpWidth)*(phase/itpWidth));
%             end
%         end

%           interp_sum=0;
%           for j= -itpWidth:itpWidth
%               interp_sum = interp_sum + y(pos+j)*sincArr(i, j+itpWidth+1);
%           end
%           y_itp(i+ipos)=interp_sum;
          
%           
%       for i = 1:itpFactor-1
%           interp_val = y(pos+itpWidthVec)'*sincArr(itpWidthVec0, i);
%           y_itp(i+ipos)=interp_val;
%       end

%       y_itp(ipos,:) = y(pos,:);
%   y_itp(end,:) = y(t_idxInWindow(end),:) ;
