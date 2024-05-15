function labels = cubseg(data,cc)

[M,N,B]=size(data);
Y_scale=scaleForSVM(reshape(data,M*N,B));
p = 1;
[Y_pca] = pca(Y_scale, p);
img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));
K=cc;

labels = mex_ers(double(img),K);
labels = labels + 1; % Because the first segmentation label is zero.

end