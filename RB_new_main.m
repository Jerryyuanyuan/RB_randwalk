clc
clear
%  ѭ������RBģ��ʵ��������������ߵĽⷨ���RBģ��
k = 2;
N = 80;
alfa = 0.8;
r = 3;
p = 0:0.01:0.2;% ͨ������p����r�䶯���۲����㣡
tmax = 10^3;    %������߷��ĵ�������
M = 100;         %ͬһ�����������ʵ���ĸ���
P=zeros(1,length(p));
index = 1;
tic
for pi = p
    nums = 1;           %ͬһ��������ɵ�RBģ�͵ĸ���
    sol_nums = 0;       %��¼���������µĿɽ�ʵ���ĸ���
    while nums <= M
        [C,Q] = RB_plus(k,N,alfa,r,pi); 
        %����RBģ�͵�ʵ��
        [res,sol] = randomwalk_rb_new(C,Q,tmax,N,alfa); %ʹ��������߷��������
        if(res == 1)    %�ҵ�����ô�ͽ��ɽ�����1
            sol_nums = sol_nums + 1;
        end
            nums = nums + 1;
    end
    P(index) = sol_nums / M;      %����ó��ɽ�ĸ��ʣ�
    index = index + 1;
    if sum(P(1:index-1)==0)>3
        P(index:length(p))=0;
        break;
    end
end
toc
plot(p,P,':*');
