load eyedataE3.mat

%in this script, attT1 tarT1 and attT2 tarT2 count as att tarT1 and att
%tarT2 respectively

%Target factor: 1 = T1, 2 = T2

%Attend factor: 1 = Attended, 2 = Neutral, 3 = Unattended

T = [1 2];

A = [1 2 3];

S = length(subjects);

bdf = zeros(S*T(end)*A(end),4);

bdf(:,1:3) = fullfact([S T(end) A(end)]);

for i = 1:length(subjects)
    
    bdf(i,4) = pupildeconv(nanmean(t1norm(:,:,i)),duration,2);
    bdf(i+S,4) = pupildeconv(nanmean(t2norm(:,:,i)),duration,3);
    bdf(i+2*S,4) = pupildeconv(nanmean(neutralnorm(:,:,i)),duration,2);
    bdf(i+3*S,4) = pupildeconv(nanmean(neutralnorm(:,:,i)),duration,3);
    bdf(i+4*S,4) = pupildeconv(nanmean(t2norm(:,:,i)),duration,2);
    bdf(i+5*S,4) = pupildeconv(nanmean(t1norm(:,:,i)),duration,3);

end

% for i = 1:length(subjects)
%     
%     [Bmat(:,1,i),Xmat(:,1,i)] = pupildeconv(nanmean(t1norm(:,:,i)),duration);
%     [Bmat(:,2,i),Xmat(:,2,i)] = pupildeconv(nanmean(t2norm(:,:,i)),duration);
%     [Bmat(:,3,i),Xmat(:,3,i)] = pupildeconv(nanmean(neutralnorm(:,:,i)),duration);
% 
% end

