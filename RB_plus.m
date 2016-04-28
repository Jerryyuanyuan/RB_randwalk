function [C,Q]=RB_plus(k,N,alfa,r,p)
%--------------------------------------------------------------------------
%   %随机生成RB模型，C中存放各个约束的约束对象变量，Q中存放他们之间的不可兼容值
%--------------------------------------------------------------------------
%   由各个控制参数计算各个相应参数
%   k表示每个约束中含有的变量个数
d = round(N^alfa);         %各个变量的值域
t = round(r*N*log(N));     %约束的个数
q = round(p*d^k);          %不可兼容值的个数
%   初始化输出矩阵
C=zeros(t,k);
Q=zeros(q,k,t);            %Q中的三个维度：t表示对应的第几个约束，q 表示第几组不兼容值，k表示第几个变量。
%   首先随机可重复选取 t 组约束，每组约束是由随机不重复的从N个变量中选择k个变量
zb = [];
for i=1:t  
    C(i,:)=sort(randnorepeat(k,N));
    is_OK = true;
    while(is_OK)
        Mb = rand(2*q,k);
        Mb = floor(Mb*d);
        zb = [zb;Mb];
        zb = unique(zb,'rows');
        if(size(zb,1)>=q)
            is_OK = false;
        end
    end
    %随机从zb中抽取不可兼容的值。
    cmc = randperm(size(zb,1),q);
    Q(1:q,:,i) = zb(cmc,:);
end
end