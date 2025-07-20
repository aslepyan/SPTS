function [xr, r] = OMP(A,y,S)

% Sparse recovery based on Orthogonal Matching Pursuit
% read from serial read directly 
% measurement < senso measurement defined 
% 3 sensor 2 measurement 

% Inputs:
% A : Dictionary or Sensing Matrix
% y : Input data
% S : Targeted sparsity
%
% Outputs:
% xr: coefficients of best sparse representation
% r: residue
%
% Trac D. Tran

xr = zeros(size(A,2), 1);
r = y;
s = [];
for i = 1:S
    cor = abs(A' * r);
    [v,n] = max(cor); % n is the indices for max elem of cor
    s = union(s, n); % grow support set by 1
    x = pinv(A(:,s))*y; 
    old_norm_r = norm(r);
    r = y - A(:,s)*x; %new residual
    if norm(r)<1e-12 || norm(r)>=old_norm_r
        break
    end
end
xr(s) = x;

