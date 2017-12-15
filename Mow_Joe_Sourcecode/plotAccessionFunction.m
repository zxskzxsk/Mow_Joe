function [ output_args ] = plotAccessionFunction( accesion1,accesion2,folderPath )
%plot the accesion of NZ and Az
% it will plot each of the features in one plot
% the data of different accesions should be given to it seperately 
 accesion1TopPoint=accesion1(strcmp({accesion1.class},'TopPoint'),:);
 accesion2TopPoint=accesion2(strcmp({accesion2.class},'TopPoint'),:);
 %
 accesion1(strcmp({accesion1.class},'TopPoint'),:)=[];
 accesion2(strcmp({accesion2.class},'TopPoint'),:)=[];
 
 accesion1(strcmp({accesion1.class},'bottomPoint'),:)=[];
 accesion2(strcmp({accesion2.class},'bottomPoint'),:)=[];

 if cell2mat( strfind({accesion1(1,:).imageName}, 'Nz'))
      dataNzAz=[accesion1;accesion2];
      
 else 
      dataNzAz=[accesion2;accesion1];
 end
  allNames={dataNzAz.imageName};
  nzaz=cellfun(@(x) x(1:2),allNames(cellfun('length',{dataNzAz.imageName}) > 1),'un',0);
  screen_size = get(0, 'ScreenSize');
  featureNames={'area','Eccentricity','PerimeterLeaflet','branchLength','baseToBranch','interRachis','MinorAxisLength','MajorAxisLength','EquivDiameter'} ; 
  featureDescription={'Area[mm]','Eccentricity','Perimeter[mm]','Branch length[mm]', 'Base to branch distance[mm]','Inter rachis distance[mm]','Minor axis length[mm]','Major axis length[mm]','Equivalence diamter[mm]'};
  %hFig = figure;
   % set(hFig, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    color1=[1 0 0];
    color2=[0 0 1];
    colorComb=[color1;color2];
    
    for i=1:numel(featureNames)
        %subplot(4,4,i)
        figure('visible','off')
        hold on
        nzazN=nzaz;
        leafletIDClass={dataNzAz.leafletID};
        leafletClass={dataNzAz.class};
        leafletIDClass(ismember(leafletClass,'leaflet'));
        %
        leafletFeature=cell2mat({dataNzAz.(featureNames{i})});
        deleteTerminalLeaflet=0;
        if(strcmp(featureNames(i),'branchLength') || strcmp(featureNames(i),'interRachis'))
            deleteTerminalLeaflet=1;
        end
        %
        leafletFeature(~ismember(leafletClass,'leaflet'))=[];
        nzazN(~ismember(leafletClass,'leaflet'))=[];
        leafletIDClass(~ismember(leafletClass,'leaflet'))=[];
        %
        
        lealfelt8ID=find(cell2mat(leafletIDClass)==8);
        %
        leafletIDClass(lealfelt8ID)=[];
        leafletFeature(lealfelt8ID)=[];
        nzazN(lealfelt8ID)=[];
        %
        colorString='rbrbrbrbrbrr';
        if(deleteTerminalLeaflet)
            lealfeltTerminalID=find(cell2mat(leafletIDClass)==1);
            %
            leafletIDClass(lealfeltTerminalID)=[];
            leafletFeature(lealfeltTerminalID)=[];
            nzazN(lealfeltTerminalID)=[];
            %
             colorString='rbrbrbrbrr';
        end
        
        

          
        if(strcmp(featureNames(i),'baseToBranch') ||strcmp(featureNames(i),'EquivDiameter') || strcmp(featureNames(i),'branchLength') || strcmp(featureNames(i),'interRachis')|| strcmp(featureNames(i),'PerimeterLeaflet')||  strcmp(featureNames(i),'MinorAxisLength')|| strcmp(featureNames(i),'MajorAxisLength'))
           leafletFeature=(leafletFeature*4)*0.0446; 
        end   
            
         if(  strcmp(featureNames(i),'area'))
            leafletFeature=(leafletFeature*4*4)*0.0446*0.0446; 
        end
        boxplot(leafletFeature,{cell2mat(leafletIDClass),nzazN},'colors',colorString,'factorgap',[5 2],'labelverbosity','all','symbol','k+','medianstyle','target');
        set(gca,'xtickmode','auto','xticklabelmode','auto')
        set(gca,'xticklabel',[' '])
        h = findobj(gca,'Tag','Box');
        boxPositionsDev=get(h,'XData');
        colorsDev=[colorComb;colorComb;colorComb;colorComb;colorComb;color1;color1];
        if(deleteTerminalLeaflet)
            colorsDev=[colorComb;colorComb;colorComb;colorComb;color1;color1];
        end
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),colorsDev(length(h)-(j-1),:),'FaceAlpha',1);
        end
        boxplot(leafletFeature,{cell2mat(leafletIDClass),nzazN},'colors',colorString,'factorgap',[5 2],'labelverbosity','all','symbol','k+','medianstyle','target');

        set(gca,'xtickmode','auto','xticklabelmode','auto')
        set(gca,'xticklabel',[' '])

        set(findall(gca, '-property', 'FontSize'), 'FontSize', 20, 'fontWeight', 'normal');
        ylabel(featureDescription{i});
        hLegend = legend(findall(gca,'Tag','Box'), {'Nz','Ox'});
       
        hChildren = findall(get(hLegend,'Children'), 'Type','Line');

        set(hChildren(4),'Color',[1 0 0]);
        set(hChildren(2),'Color',[0 0 1]);
        set(hChildren(4),'linewidth',3);
        set(hChildren(2),'linewidth',3);
        leg = findobj(hChildren,'type','text');
        set(leg,'FontSize',13);
        % this will also work on a vector of handles

        %set(hChildren(2),'Color',[0 0.5 0])
        saveas(gcf,strcat(strcat(folderPath,filesep,featureNames{i}),'.png'), 'png')
        close;

    end
    
    %ploting of the whole leaf Features , such as LeafAra and
    %LeafPEriemeter
    
 if cell2mat( strfind({accesion1(1,:).imageName}, 'Nz'))
  dataNzAzWhole=[accesion1TopPoint;accesion2TopPoint];
else 
  dataNzAzWhole=[accesion1TopPoint;accesion2TopPoint];
end
featureNames={'LeafArea','leafPerimeter','distBottomTerminal'} ; 
nzazWhole=[repmat(1,numel(accesion1TopPoint),1);repmat(2,numel(accesion2TopPoint),1)];
featureDescription={'Area[mm]','Perimeter[mm]','Rachis length[mm]'}
screen_size = get(0, 'ScreenSize'); 
for  iss=1:numel(featureNames)
    hFig = figure('visible','off');
    hold on;
    set(hFig, 'Position', [0 0 screen_size(3) screen_size(4) ] );
    dataToPlot=cell2mat({dataNzAzWhole.(featureNames{iss})});
    if(strcmp(featureNames{iss},'LeafArea'))
        dataToPlot=dataToPlot*4*4*0.0446*0.0446;
    end
    if(strcmp(featureNames{iss},'distBottomTerminal') || strcmp(featureNames{iss},'leafPerimeter'))
        dataToPlot=dataToPlot*4*0.0446;
    end
    boxplot(dataToPlot,{nzazWhole},'colors','rbrbrbrbrbrr','labelverbosity','all','symbol','k+','medianstyle','target');
    %
    set(gca,'xtickmode','auto','xticklabelmode','auto')
    set(gca,'xticklabel',[' '])
    h = findobj(gca,'Tag','Box');
    boxPositionsDev=get(h,'XData');
    colorsDev=[colorComb;colorComb;colorComb;colorComb;colorComb;color1;color1];
    for j=1:length(h)
        patch(get(h(j),'XData'),get(h(j),'YData'),colorsDev(length(h)-(j-1),:),'FaceAlpha',1);
    end
    boxplot(dataToPlot,nzazWhole,'colors','rbrbrbrbrbrr','labelverbosity','all','symbol','k+','medianstyle','target');
    %
    set(gca,'xtickmode','auto','xticklabelmode','auto')
    set(gca,'xticklabel',[' '])
    set(findall(gca, '-property', 'FontSize'), 'FontSize', 20, 'fontWeight', 'normal');

    ylabel(featureDescription{iss});
    xlabel('Accesions');
    hLegend = legend(findall(gca,'Tag','Box'), {'Nz','Ox'});
    hChildren = findall(get(hLegend,'Children'), 'Type','Line');

    set(hChildren(4),'Color',[1 0 0]);
    set(hChildren(2),'Color',[0 0 1]);
    %set(hChildren(2),'Color',[0 0.5 0])
    saveas(gcf,strcat(folderPath,filesep,'Leaf_',featureDescription{iss},'.png'));
    close;
end
end
