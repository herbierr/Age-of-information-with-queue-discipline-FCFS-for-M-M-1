close all;
clear all;
clc;
lambda_set=0.08:0.01:0.32;
mu=0.4;
rho=lambda_set/mu;
alpha=0.4;                                                                 %t1��ص�ϵ��
%% Monte carlo
for i=1:1:length(lambda_set)
    lambda=lambda_set(i);                                                  %�Ա���
    N=2000000;                                                             %ģ�����
    X=exprnd(1./lambda,1,N);                                               %����ʱ����
    S=exprnd(1./mu,1,N);                                                   %����ʱ��
    for j=1:N
        if j==1
            wait_time_1=0;
            service_1=S(j);
            wait_time(j)=wait_time_1;                                      %Q1��
            service_time(j)=service_1;
            time_1=alpha*X(i);
            delta_0=(1-alpha)*X(i);
        else
            if X(j)>=(service_time(j-1)+wait_time(j-1))                    %������ʱ�������ڷ���ʱ��͵ȴ�ʱ��֮��ʱ��
                ttemp=0;                                                   %��ǰ���ݰ��ĵȴ�ʱ��Ϊ0��
            else
                ttemp=service_time(j-1)+wait_time(j-1)-X(j);
            end
            wait_time(j)=ttemp;
            service_time(j)=S(j);
        end
        system_time(j)=wait_time(j)+service_time(j);
    end
    D=0;
    T=0;
    for t=2:N
        D=D+1/2*(X(t)+system_time(t)).^2-1/2*system_time(t).^2;
        T=T+X(t);
    end
    Delta_MC(i)=(1/2*(X(1)+system_time(1)).^2-1/2*system_time(1).^2+D+system_time(N).^2)/(T+alpha*X(1)+S(N));
end
%% ��ֵģ��
Delta=1/mu*(1+1./rho+rho.^2./(1-rho));
%%
figure;
plot(rho,Delta_MC,'or')
hold on
plot(rho,Delta,'-k')
hold on
xlabel('\rho');
ylabel('AoI\Delta');
title('M/M/1 FCFS');
[Delta_min,I]=min(Delta_MC);
hold on
plot(rho(I),Delta_MC(I),'rs','MarkerSize',6) 
str = ['P(' num2str(rho(I)) ',' num2str(Delta_MC(I)) ')'];
text(rho(I),Delta_MC(I),str)  

set(gca,'FontSize',14);
set(get(gca,'XLabel'),'FontSize',14);
set(get(gca,'YLabel'),'FontSize',14);

legend('simulation','analysis')