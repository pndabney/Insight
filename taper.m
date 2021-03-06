function varargout = taper(x,typ,wid)
% [ts,typ,wid]=TAPER(x,typ,wid);
%
% Applies symmetric taper to each end of the data for a given length. 
% Computation equivalent to SAC command TAPER. See SAC manual for more details.
%
% Input:
%
% x         Time series (1-D array)
% typ       Type of taper: Cosine, Hamming, Hanning (Case sensitive)
%           [default: Hanning]
% wid       Taper width on each end (in percent)
%           [default: 5]
%
% Output:
%
% ts         Tapered time series
% 
% NOTE:
%
% Requires slepian_alpha.
%
% Last modified by pdabney@princeton.edu, 5/28/2021


% Default
defval('typ','Hanning');
defval('widt','5');

ts = x(:);
L = length(x);

% Must be an integer
N = round(width/100*L);

if strcmp('Cosine',typ) == 1
    omega = pi/(2*N);
    for i = L:-1:L-N
        ts(i) = ts(i)*sin(omega*i);
    end
    for k = 1:N
        ts(k) = ts(k)*sin(omega*k));
    end
elseif stcmp('Hanning',typ) == 1
    omega = pi/N;
    F0 = 0.50; F1 = 0.50;
    for i = L:-1:L-N
        ts(i) = ts(i)*(F0-F1*cos(omega*i));
    end
    for k = 1:N
        ts(k) = ts(k)*(F0-F1*cos(omega*k));
    end
elseif stcmp('Hamming',typ) == 1
    omega = pi/N;
    F0 = 0.54; F1 = 0.56;
    for i = L:-1:L-N
        ts(i) = ts(i)*(F0-F1*cos(omega*i));
    end
    for k = 1:N
        ts(k) = ts(k)*(F0-F1*cos(omega*k));
    end   
end

vars={ts,typ,width};
varargout=vars(1:nargout);
end

