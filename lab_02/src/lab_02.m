clear all;
pkg load statistics

X = [8.00, 3.38,1.21,1.85,2.24,4.17,2.99,4.81,2.71,2.70,4.41,3.21,3.15,2.77, 4.05,3.89,1.56,2.78,2.04,2.82,3.28,2.63,1.89,3.57,3.15,3.80,5.40,3.25,2.04,2.61,5.06,2.87,2.66,4.80,3.86,0.09,2.45,2.40,2.14,1.69,2.36,5.44,2.77,1.94,2.55,3.97,1.88,3.01,4.21,4.74,2.02,2.38,2.46,3.51,2.89,1.57,3.53,0.77,3.31,3.58,2.77,3.61,3.71,2.38,3.06,4.29,4.76,1.69,1.59,3.21,2.74,3.99,3.53,3.52,2.84,1.21,2.82,4.34,3.65,2.22,2.87,3.14,3.58,1.96,3.41,3.85,1.96,3.02,4.22,3.10,2.68,3.67,1.70,5.47,5.02,2.52,3.09,2.19,4.44,2.33,2.27,3.34,3.05,4.35,3.58,3.43,4.49,3.57,3.20,1.53,3.53,3.53,1.27,3.40,4.53,2.21,3.28,3.50,2.01,3.30, 0.00, 1.86]; 
gamma = 0.9;
N = length(X);

% 1) и 2)
% muHat — Estimate of mean
% sigmaHat — Estimate of standard deviation
% muCI — Confidence interval for mean
% sigmaCI — Confidence interval for standard deviation
[muhat, sigmahat, muci, sigmaci] = normfit(X, 1 - gamma);
S2 = sigmahat ^ 2; % тк нужно для квадратов
sigmaci2 = sigmaci .^ 2;
% 1.а
fprintf('μ̂ = %f, S² = %f\n', muhat, S2);
% 1.б
fprintf('доверительный интервал для μ = (%f; %f)\n', muci(1), muci(2));
% 1.в
fprintf('доверительный интервал для σ² = (%f; %f)\n', sigmaci2(1), sigmaci2(2));

% 3)
function [muhat, muci] = normfitmu(X, alpha)
	% Границы доверительного интервала для математического ожидания
	[muhat, ~, muci, ~] = normfit(X, alpha);
end

function [sigmahat2, sigmaci2] = normfitsigma2(X, alpha)
	% Границы доверительного интервала для дисперсии
	[~, sigmahat, ~, sigmaci] = normfit(X, alpha);
	sigmahat2 = sigmahat ^ 2;
	sigmaci2 = sigmaci .^ 2;
end

% Построение графиков
%	X - генеральная совокупность
%	gamma - уровень доверия
%	est - точечная оценка
%	fit - функция точечной оценки и границ
%	label_line  - подпись к графику точечной оценки от x_N
%	label_est   - подпись к графику точечной оценки от x_n
%	label_over  - подпись к графику верхней границы от x_n
%	label_under - подпись к графику нижней границы от x_n
function graph(X, gamma, est, fit, label_line, label_est, label_over, label_under)
	N = length(X);
	n_start = 10;
	figure
	plot([n_start, N], [est, est], 'LineWidth', 2);
	hold on;
	grid on;

	ests = zeros(1, N);
	cis = zeros(2, N);

	for n = 10:N
		[ests(n), cis(:, n)] = fit(X(1:n), 1 - gamma);
	end

	plot(n_start:N, ests(n_start:N), 'LineWidth', 2);
	plot(n_start:N, cis(1, n_start:N), 'LineWidth', 2);
	plot(n_start:N, cis(2, n_start:N), 'LineWidth', 2);

	l = legend(label_line, label_est, label_over, label_under);
	set(l, 'Interpreter', 'latex', 'fontsize', 14);
	hold off;
end

% histfit(X);
% а) graph μ̂
graph(X, gamma, muhat, @normfitmu, '$\mu(\vec x_N)$', '$\mu(\vec x_n)$', '$\underline\mu(\vec x_n)$', '$\overline\mu(\vec x_n)$');
% б) graph S²
graph(X, gamma, S2, @normfitsigma2, '$\sigma^2(\vec x_N)$', '$\sigma^2(\vec x_n)$', '$\underline\sigma^2(\vec x_n)$', '$\overline\sigma^2(\vec x_n)$');

