clear all
close all
% TDI Example 
x = [8 7 6 5 4 3 2 1];
t = 1:length(x);

figure
plot(t,x,'x--')
title("OG Example")

% For window 3
figure
y = [6 7 8 3 4 5 1 2]
plot(t,y,'x--')
title("TDI with window 3")