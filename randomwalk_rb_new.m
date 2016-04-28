function [res,sol]=randomwalk_rb_new(C,Q,tmax,N,alfa)
%--------------------------------------------------------------------------
%   ������tmax��ѭ���и���RBģ�͵�һ�����н⣬��������ҵ�����ô����ȫ�����顣
%   C��Q�ֱ�Ϊ������RBģ��ʵ����tmax������ѭ��������N�Ǳ���������alfa�ǲ���
%--------------------------------------------------------------------------
    d=round(N^alfa);%������Ĵ�С
    [~,k,t]=size(Q);%��������
    time = 0;
    res = 0;
    qw = 1:k;
    dw = 0:d-1;
    while(time < tmax)
        if(time==0)%time=0ʱҪ��N�����������ֵ
            sol=floor(rand(1,N)*d);%������ظ��Ӷ�������ȡ��N��ֵ��Ϊ��N�������������ֵ
        end
        %������ɼ������Լ����˳�������ĵ�һ���������Լ������Ϊ�㷨����Լ����
        jcsx=randperm(t);%������ظ�ѡȡ������˳��
        ci = 0;
        for ti = jcsx
            Cti = C(ti,:);%ȡ��Լ���������еĵ�ti��Լ��,��Cti�д�ŵ���Լ������
            Qti = Q(:,:,ti);
            solvv = sol(Cti(1:k));
            if is_exit(solvv,Qti)==1
                ci = ti;
                break;
            end
        end
        if ci~=0
            %��ô���൱������ҵ�һ���������Լ����
            Ci = C(ci,:);
            Qi = Q(:,:,ci);  
            indr = randi(k);%ȡ��һ�������λ��
            cindr = (qw~=indr);
            vr = Ci(indr);%ȡ��indr��Ӧ�ı���            
            cvr = Ci(cindr);
            sol_cvr = sol(cvr);
            loc = (Qi(:,cindr)==sol_cvr);
            iicQ = Qi(loc,indr);%ȫ����vr����ȡ��ֵ
            ocQ = setdiff(dw,iicQ);
            sol(vr)=ocQ(floor(rand()*length(ocQ)+1));%�Խ��������
            time = time + 1;
        else
            %��ô����ζ�Ų�û���ҵ��������Լ��
            %��sol�ǿ��н⡣
            res = 1;
            break;
        end
    end
    if(res==0 && time==tmax)
        sol = zeros(1,N);
    end
end

%  if(time==0)%time=0ʱҪ��N�����������ֵ
%             sol=floor(rand(1,N)*d);%������ظ��Ӷ�������ȡ��N��ֵ��Ϊ��N�������������ֵ
%         end
%         [zres,Ca] = jishu_new(C,Q,sol);
%         if  zres == 0
%             res = 1;
%             return;
%         end
%             qw = length(Ca);
%             vvr = fix(rand(1)*qw+1);%�������һ��λ��
%             ci = Ca(vvr);%��Ϊ����õ��Ĳ��������Լ��
%             %��ô���൱������ҵ�һ���������Լ����
%             Ci = C(ci,:);
%             icQ = Q(:,:,ci);
%             indr = randi(k);
%             vr = Ci(indr);
%             solCi = sol(Ci(1:k));
%             randv = randperm(d)-1;%������п��ܸ�ֵ
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