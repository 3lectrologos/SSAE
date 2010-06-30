%%% ----------------------------------------------------------------------
%%%
%%% Description: Script for plotting simulation results.
%%%
%%% Author: Alkis Gotovos
%%% Created: 29 Jun 2010
%%%
%%% ----------------------------------------------------------------------

function plot_results(tout, yout, fignum)
%% Plot output flow
output_handle = figure;
hold on;
plot(tout, yout(:, 1), '-b',...
     'LineWidth', 1, 'Color', [0.4 0.4 0.4]);
plot(tout, 0.98*yout(:, 2), ':k',...
     tout, 1.02*yout(:, 2), ':k',...
     tout, yout(:, 2), '--k');
xlabel('t');
ylabel('q_0(t)');
% Find 2% settling time.
[wee1, ind] = findpeaks(-abs(yout(:, 1) - 0.98*yout(:, 2)));
ts = ind(1);
[s, wee2] = sprintf('\\uparrow \\newline Settling time: %ds', ts);
text(ts, yout(ts, 1), s,...
     'HorizontalAlignment', 'left',...
     'VerticalAlignment', 'top');
% Find overshoot
[wee3, ind] = max(yout(:, 1));
to = ind(1);
[s, wee4] = sprintf('Overshoot: %.2f%% \\newline \\downarrow',...
                    100*(yout(to, 1)/yout(to, 2) - 1));
text(to, yout(to, 1), s,...
     'HorizontalAlignment', 'left',...
     'VerticalAlignment', 'bottom');
 
 %% Plot reservoir heights
 center = floor(length(tout)/2);
 heights_handle = figure;
 plot(tout, yout(:, 3), '-b', tout, yout(:, 4), '-b',...
      'LineWidth', 1, 'Color', [0.4 0.4 0.4]);
 ylim([0 7]);
 xlabel('t');
 text(center, yout(center, 3), 'h2(t)',...
      'VerticalAlignment', 'bottom');
 text(center, yout(center, 4), 'h1(t)',...
      'VerticalAlignment', 'bottom');
  
 %% Plot input flow
 input_handle = figure;
 plot(tout, yout(:, 5),...
      'LineWidth', 1, 'Color', [0.4 0.4 0.4]);
 ylim([0 3.5]);
 xlabel('t');
 ylabel('q_i(t)');
 
 %% Save figures to pdf files
 savefig(sprintf('input_%d', fignum), input_handle, 'pdf');
 savefig(sprintf('output_%d', fignum), output_handle, 'pdf');
 savefig(sprintf('heights_%d', fignum), heights_handle, 'pdf');