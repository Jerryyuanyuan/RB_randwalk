clc
clear
%  循环产生RB模型实例，利用随机游走的解法求解RB模型
k = 2;
N = 80;
alfa = 0.8;
r = 3;
p = 0:0.01:0.2;% 通过参数p或者r变动来观测相变点！
tmax = 10^3;    %随机游走法的迭代次数
M = 100;         %同一组参量产生的实例的个数
P=zeros(1,length(p));
index = 1;
tic
for pi = p
    nums = 1;           %同一组参量生成的RB模型的个数
    sol_nums = 0;       %记录这组条件下的可解实例的个数
    while nums <= M
        [C,Q] = RB_plus(k,N,alfa,r,pi); 
        %生成RB模型的实例
        [res,sol] = randomwalk_rb_new(C,Q,tmax,N,alfa); %使用随机游走法尝试求解
        if(res == 1)    %找到解那么就将可解数加1
            sol_nums = sol_nums + 1;
        end
            nums = nums + 1;
    end
    P(index) = sol_nums / M;      %计算得出可解的概率！
    index = index + 1;
    if sum(P(1:index-1)==0)>3
        P(index:length(p))=0;
        break;
    end
end
toc
plot(p,P,':*');
