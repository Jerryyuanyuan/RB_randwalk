function [res,sol]=randomwalk_rb_new(C,Q,tmax,N,alfa)
%--------------------------------------------------------------------------
%   尝试在tmax次循环中给出RB模型的一个可行解，如果不能找到，那么返回全零数组。
%   C、Q分别为产生的RB模型实例，tmax是最大的循环次数，N是变量个数，alfa是参数
%--------------------------------------------------------------------------
    d=round(N^alfa);%定义域的大小
    [~,k,t]=size(Q);%其他参数
    time = 0;
    res = 0;
    qw = 1:k;
    dw = 0:d-1;
    while(time < tmax)
        if(time==0)%time=0时要对N个变量随机赋值
            sol=floor(rand(1,N)*d);%随机可重复从定义域中取出N个值作为对N个变量的随机赋值
        end
        %随机生成检验各个约束的顺序，遇到的第一个不满足的约束，作为算法所求约束。
        jcsx=randperm(t);%随机不重复选取出检验顺序
        ci = 0;
        for ti = jcsx
            Cti = C(ti,:);%取出约束变量集中的第ti个约束,即Cti中存放的是约束变量
            Qti = Q(:,:,ti);
            solvv = sol(Cti(1:k));
            if is_exit(solvv,Qti)==1
                ci = ti;
                break;
            end
        end
        if ci~=0
            %那么就相当于随机找到一个不满足的约束。
            Ci = C(ci,:);
            Qi = Q(:,:,ci);  
            indr = randi(k);%取出一个随机的位置
            cindr = (qw~=indr);
            vr = Ci(indr);%取出indr对应的变量            
            cvr = Ci(cindr);
            sol_cvr = sol(cvr);
            loc = (Qi(:,cindr)==sol_cvr);
            iicQ = Qi(loc,indr);%全部的vr不能取得值
            ocQ = setdiff(dw,iicQ);
            sol(vr)=ocQ(floor(rand()*length(ocQ)+1));%对解进行修正
            time = time + 1;
        else
            %那么就意味着并没有找到不满足的约束
            %则sol是可行解。
            res = 1;
            break;
        end
    end
    if(res==0 && time==tmax)
        sol = zeros(1,N);
    end
end

%  if(time==0)%time=0时要对N个变量随机赋值
%             sol=floor(rand(1,N)*d);%随机可重复从定义域中取出N个值作为对N个变量的随机赋值
%         end
%         [zres,Ca] = jishu_new(C,Q,sol);
%         if  zres == 0
%             res = 1;
%             return;
%         end
%             qw = length(Ca);
%             vvr = fix(rand(1)*qw+1);%随机给出一个位置
%             ci = Ca(vvr);%即为随机得到的不可满足的约束
%             %那么就相当于随机找到一个不满足的约束。
%             Ci = C(ci,:);
%             icQ = Q(:,:,ci);
%             indr = randi(k);
%             vr = Ci(indr);
%             solCi = sol(Ci(1:k));
%             randv = randperm(d)-1;%随机排列可能赋值
%             sol_vr = randv(end);
%             for vri = randv
%                 solCi(indr) = vri;
%                 if ismember(solCi,icQ,'rows')==1
%                     continue;
%                 else
%                     sol_vr = vri;
%                     break;
%                 end
%             end
%             sol(vr)=sol_vr;
%             time = time + 1;
%     end
%     if(res==0 && time==tmax)
%         sol = zeros(1,N);
%     end