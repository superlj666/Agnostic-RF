clear;
title = 'a6a';
[y, X] = libsvmread(['./datasets/', title]);
y(y==0) = -1;
save(['./data/', title]);