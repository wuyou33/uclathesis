function H = block_hankel(y,i,j)

% Make a (block) row vector from y
[l, nd] = size(y);
if nd < l
    y = y';
    [l, nd] = size(y);
end

% Check dimensions
if i < 0; error('block_hankel: i must be positive'); end
if j < 0; error('block_hankel: j must be positive'); end
if j > nd - i + 1; error('block_hankel: j too big'); end

% Generate block Hankel matrix
H = zeros(l*i, j);
for k = 1:i
    H( (k-1)*l+1 : k*l , : ) = y( : , k : k+j-1);
end