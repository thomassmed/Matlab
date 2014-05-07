               e3   = [   0,   72;
                    1900,   72;
                    10000,  126;
                    14000 , 126];

                ss9  = [    0,  76;
                    1900,  76;
                    10000, 130;
                    14000, 130];

                e4   = [    0,  81;
                    1900,  81;
                    10000, 135;
                    14000, 135];

                ss10 = [    0,  86;
                    1900, 86;
                    10000, 140;
                    14000, 140];

                delss = [   0,  30;
                    2800,  30;
                    9900, 160;
                    14000, 160];

               till = [2500  ,   0;
                    3100  ,  30;
                    6850  ,  99;
                    10000  ,  120;
                    12000  , 120;
                    12600 , 65;
                    12000 ,  55;
                    8000 ,  10;
                    8000 ,   0];
    
            scnsize=get(0,'ScreenSize');
            %subplot(3,4,1)
            %set(gcf,'Position',0.5*[scnsize(1),scnsize(2)+scnsize(2)+200,scnsize(3),scnsize(4)-280])
            h=area(till(:,1),till(:,2));
            hold on
            set(h,'FaceColor',[0,1,0]);
           % sig1=plot(h,data.signal(4).data,data.signal(2).data*100,data.signal(5).data,data.signal(3).data*100);
           % sig2=plot(h,data.signal(4).data(end),data.signal(2).data(end)*100,'xr',data.signal(5).data(end),data.signal(3).data(end)*100,'xr');
            %sig3=plot(h,data.signal(5).data(end),data.signal(3).data(end)*100,'xr');
            apa=plot(e3(:,1),e3(:,2),'-.',...
                e4(:,1),e4(:,2),'--',...
                ss9(:,1),ss9(:,2),'-.',...
                ss10(:,1),ss10(:,2),'--',...
                delss(:,1),delss(:,2),'-.');
            title('Driftområdesdiagram')
            xlabel('HC-flöde [kg/s]')
            ylabel('Effekt [%]')
            axis tight
            %axis([5000,9000,75,108]);