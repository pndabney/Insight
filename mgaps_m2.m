function varargout=mgaps_m2(sd,num,d,thresh,p)
% [C,pmis,SData]=MGAPS_M2(sd,num,d,thresh,p)
%
% Takes a time series and creates synthetic gaps
%
% INPUT:
%
% sd               Seismic data array (1-D)
% num              Number of gaps to create (default: 10)
% thresh           Integer of the minimum length of a segment (default:1)
%                  Segments shorter will be thrown out
% d                Distribution of gaps
%                  'rgaps' uniformly random distributed gaps (default)
%                  'egaps' evenly distributed gaps
% p                1 makes a plot
%                  0 does not make a plot (default)
% 
% OUTPUT:
%
% C                Cell array of the remaining segments
% pmis             Percentage of missing data
% SData            New seismic array with gaps (use for plots)
%
% EXAMPLE:
%
% sd = rand(4028,1); num = randi(10); d = 'rgaps'; thresh = 256;
% [C,pmis,~]=mgaps_m2(sd,num,d);
%
% Last modified by pdabney@princeton.edu 04/10/21

% Default values
defval('p',0);
defval('num',10);
defval('thresh',1);
defval('d','rgaps');


if isstr(d) & d=='rgaps'
    ng = sort(randi([1 length(sd)],1,2*num));
elseif isstr(d) & d=='egaps'
    % ensure t consists of integers
    ng = round(linspace(1,length(sd),2*num));
end
% Reshape into pairs
g= reshape(ng,2,[]);

% Replace values in of ranges g pairs with NaN
SData = sd;
for k=1:num
    SData(g(1,k):g(2,k))=NaN;
end

% Save data in a cell array
% first segment
C{1} = SData(1:ng(1)-1);
for index = 1:num-1
    C{index+1} = SData(ng(2*index)+1:ng(2*index+1)-1);
end
% last segment
C{num+1} = SData(ng(end)+1:length(sd));
   

% Ensure segments are longer than thresh
for k = length(C):-1:1
    if length(C{k}) <= thresh
        C(:,k)=[];
    end
end


% Data check
% difer(nansum(SData)-sum(cat(1,C{:})));

% Calculate the percent of data missing
pmis = ((length(sd)-sum(abs(~isnan(SData))))/length(sd)) * 100;
 

% Optional plot
if p == 1
    plot(SData);
    axis tight;
    xlabel('Time (s)');
    title(sprintf('Percent Missing: %.2f',pmis));
end


% Optional output
varns={C,pmis,SData};
varargout=varns(1:nargout);
end

