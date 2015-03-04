function h_out = updateErrorbar(h, varargin)
%{
    eg first time, call:
        h_plot= updateTitle([], x, y, 'linestyle', ':')
    next time (to update), call:
        h_plot = updateText(plot, X2, Y2, 'linestyle', ':')
%}

    syntaxPossibilities = {{'numeric', 'numeric', 'numeric'},            @(x,y,e) {'xdata', x, 'ydata', y, 'ldata', e, 'udata', e};
                           {'numeric', 'numeric', 'numeric', 'numeric'}, {'xdata', 'ydata', 'ldata', 'udata'}  };  
                       
    h_out_tmp = updateHGFunction(@plot, h, syntaxPossibilities, varargin{:});    

    if nargout > 0
        h_out = h_out_tmp;
    end        

end


% function v = linespec2args(s)
% 
%     allLineStyles = {'--', ':', '-.', '-'};
%     allMarkers = '+o*.xsd^v><ph';
%     allColors = 'rgbcmykw';
% 
%     v = {};
% 
%     % Color
%     for col_i = 1:length(allColors)    
%         idx = strfind(s, allColors(col_i)) ;
%         if ~isempty(idx)
%             v = [v, {'Color', allColors(col_i)}]; %#ok<*AGROW>
%             break;
%         end
%     end
% 
%     % Marker 
%     for mk_i = 1:length(allMarkers)    
%         idx = strfind(s, allMarkers(mk_i)) ;
%         if ~isempty(idx)
%             v = [v, {'Marker', allMarkers(mk_i)}];
%             break;
%         end
%     end
% 
%     % LineStyle 
%     for mk_i = 1:length(allLineStyles)    
%         idx = strfind(s, allLineStyles{mk_i}) ;
%         if ~isempty(idx)
%             v = [v, {'LineStyle', allLineStyles{mk_i}}];
%             break;
%         end
%     end
% 
% end