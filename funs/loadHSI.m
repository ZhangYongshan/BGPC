function [data3D, gt, ind, c] = loadHSI(dataType)

switch dataType
    case 'Salinas'
        HSIdata = load('Salinas_corrected.mat');
        data3D = HSIdata.salinas_corrected;
        HSIlabel = load('Salinas_gt.mat');
        gt2D = HSIlabel.salinas_gt;
    case 'PaviaU'
       HSIdata = load('PaviaU.mat');
        data3D = HSIdata.paviaU;
        HSIlabel = load('PaviaU_gt.mat');
        gt2D = HSIlabel.paviaU_gt;
    case 'PaviaC'
        HSIdata = load('Pavia.mat');
        data3D = HSIdata.pavia;
        HSIlabel = load('Pavia_gt.mat');
        gt2D = HSIlabel.pavia_gt;
end

gt = double(gt2D(:));
ind = find(gt);
c = length(unique(gt(ind)));

end