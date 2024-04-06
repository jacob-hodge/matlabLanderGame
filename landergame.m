%%%%%  INSTRUCTIONS %%%%

% up,left and right arrow keys to move
% get below 3m/s vertically and 1m/s horizontally to land
% land on flat area
% if fuel goes to zero game continues until you crash or land


%%%%%%%%%%%%%%%%%%%%%%%%%%     SETUP     %%%%%%%%%%%%%%%%%%%%%%%%%%%


clear clc; clear all; close all;
global thrust;
global engine;
global run;
global lander;


% Loading in the art
mars = imread('mars.png');
moon = imread('moon.png');
pluto = imread('pluto.png');
venus = imread('venus.png');


% defining figure + axes
landerfigure = figure('color',[0.5 0.5 0.5],'KeyPressFcn',@keysfunc,...
    'KeyReleaseFcn',@release,'Position',[200 70 800 600]);

landeraxes = axes('color', 'black', 'XLim',[0,110],'YLim',[0,110],...
    'position',[0,0,1,1],'Fontname','OCR A Extended','fontsize',24);

set(landeraxes,'YTick',[],'Xtick',[],'FontName','OCR A Extended');



%%%%%%%%%%%%%%%   MAIN LOOP  %%%%%%%%%%%%%%%%%%%%%%

run = 1;
while run == 1
    
    set(landerfigure,'color','black');
    delete(image); %deleting background from previous game
    choice = 1; %% choosing the level
    text1 = text(35,90,'Choose a level by');
    text7 = text(35,85,'typing the number');
    text2 = text(50,70,'Moon 1');
    text3 = text(50,60,'Mars 2');
    text4 = text(50,50,'Pluto 3');
    text5 = text(50,40,'Venus 4');
    text6 = text(45,20,'esc to exit');
    set(findall(gcf,'type','text'),'fontname','OCR A Extended',...
        'fontsize',24,'color','[0.7 0.7 0.7]');
    
    
    num = 0;
    while num == 0
        waitforbuttonpress 
        choice = double(get(gcf,'CurrentCharacter')); % this selects the
        % current character being pressed
        if choice == 49 %number 1 key
            landerposition = [50,100];
            g = -1.62; %gravity
            num = 1; 
            image = imshow(moon); %add bg image
            zone = [40,60]; %flat area to land
            set(landeraxes,'YDir','normal');
            set(landerfigure,'color','white');
            engine = 0.00162; %engine power for lander
            landerspeed = [0.2,-0.3]; %start speed
            fuel = 350; %start fuel
            
        elseif choice == 50 %number 2 key
            landerposition = [50,100];
            g = -3.7;
            num = 1;
            zone = [15,28];
            image = imshow(mars);
            set(landeraxes,'YDir','normal');
            set(landerfigure,'color','red');
            engine = 0.003;
            landerspeed = [-0.3,-0.4];
            fuel = 300;
        elseif choice == 51 %number 3 key
            landerposition = [20,100];
            g = -0.62;
            num = 1;
            zone = [42,50];
            image = imshow(pluto);
            set(landeraxes,'YDir','normal');
            set(landerfigure,'color','black');
            engine = 0.0015;
            landerspeed = [0,-0.1];
            fuel = 200;
        elseif choice == 52 % number 4
            landerposition = [50,100];
            g = -8.67;
            num = 1;
            zone = [76,81];
            image = imshow(venus);
            set(landeraxes,'YDir','normal');
            set(landerfigure,'color','yellow');
            engine = 0.0025;
            landerspeed = [0.2,-0.4];
            fuel = 500;
        elseif choice == 27 %esc key
            run = 0; %leaves both loops
            game = 0;
            close all;
            num = 1;
        end
    end
    
    
    
    delete(findall(gcf,'type','text'));

    
    Countdown; %function for 3,2,1, go countdown
    
    acc = [0,g/10000];
    thrust = [0,0];
    lander = line([landerposition(1),landerposition(1) + 2],...
        [landerposition(2),landerposition(2)],...
        'linewidth',10,'color','[0.7,0.7,0.7]');
    
    %text for speed, dist from ground etc
    vertveltext = text(10,95,'0');
    horizveltext = text(40,95,'0');
    heighttext = text(70,95,'0');
    fueltext = text(100,95,'0');
    nofuel = text(50,50,'');
    text(10,100,'vert vel');
    text(40,100,'horiz vel');
    text(70,100,'Height');
    text(100,100,'Fuel');
    set(findall(gcf,'type','text'),'fontname','OCR A Extended',...
        'fontsize',18,'color','[0.7,0.7,0.7]'); % changing color + font
    hold;
    
    %%%%%%%%%%%%%%%%%%%%    GAME LOOP     %%%%%%%%%%%%%%%%%%%
    
    
    game = 1;
    while game == 1 && run == 1

        acc = acc + thrust;
        landerspeed = landerspeed + acc;
        landerposition = landerposition + landerspeed;
        set(lander,'XData',[landerposition(1),landerposition(1) + 2],'YData',[landerposition(2),landerposition(2)]);
        acc = [0, g/10000];
        
        pause(0.01);
      
        %update speed + height
        vertveltext.String = ([num2str(round(landerspeed(2)*70,2)),'m/s']);
        horizveltext.String = ([num2str(round(landerspeed(1)*70,2)),'m/s']);
        heighttext.String = ([num2str(round(landerposition(2)-10,2)),'m']);
        fueltext.String = num2str(round(fuel,1));
        drawnow;
        
        %remove fuel if thrust is on
        if thrust(1) || thrust(2) ~= 0
            fuel = fuel - 1;
        end     
        
        %disp no fuel text and set engine to zero
        if fuel < 0
            engine = 0;
            fuel = 0;
            set(fueltext,'color','red');
            nofuel.String = (['NO FUEL']);
        end
        
        %change color of horiz velocity text if above 1m/s
        if abs(landerspeed(1)) > 0.0142
            set(horizveltext,'color','red');
        else
            set(horizveltext,'color','[0.7,0.7,0.7]');
        end
        
        %change color of vert velocity text if above 3m/s
        if landerspeed(2) < -0.0428
            set(vertveltext,'color','red')
        else
            set(vertveltext,'color','[0.7,0.7,0.7]');
        end
        
        %if lander is outside of box disp you lose and run menureset func
        if landerposition(1) < 0 || landerposition(1) > 110 || landerposition(2) > 110
            text(45,50,'you lose','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 24);
            game = 0;
            delete(nofuel);
            menuReset;
        end
        
        %if lander reaches bottom, check if it is in the zone for that
        %level and displat win/lose text and run reset menu func
        if landerposition(2) < 10
            game = 0;
            if landerposition(1) < zone(2) && landerposition(1) > zone(1) && landerspeed(2) > -0.0428 && abs(landerspeed(1)) < 0.0142
                text(45,50,'you win','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 24);
            else
                text(45,50,'you lose','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 24);
            end
            delete(nofuel);
            menuReset;
        end
    end
end

close all;

%%%%%%%% FUNCTIONS %%%%%%%%


%callback for the button press
function keysfunc(figure,event)
global thrust;
global engine;

if contains(event.Key,'leftarrow')
    thrust(1) = - engine;
elseif contains(event.Key,'rightarrow')
    thrust(1) = engine;
elseif contains(event.Key,'uparrow')
    thrust(2) = engine;
end

end

%callback for button release
function release(figure,event)
global thrust;

if contains(event.Key,'leftarrow')
    thrust(1) = 0;
elseif contains(event.Key,'rightarrow')
    thrust(1) = 0;
elseif contains(event.Key,'uparrow')
    thrust(2) = 0;
end
end

%reset the menu
function menuReset
global run;
global lander;
numb = 0;
text(25,45,'space to go to menu','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 24);
text(25,40,'esc to leave the game','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 24);
while numb == 0
    waitforbuttonpress
    retry = double(get(gcf,'CurrentCharacter'));
    if retry == 27 %esc
        run = 0;
        delete(lander);
        delete(findall(gcf,'type','text'));
        numb = 1;
    elseif retry == 32 %space
        numb = 1;
        delete(lander);
        delete(findall(gcf,'type','text'));
    end
    
end
end

%run countdown function
function Countdown
keytostarttext = text(20,50,'Press any key to start','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 24);
    waitforbuttonpress
    delete(keytostarttext);
    cd3 = text(50,55,'3','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 30);
    pause(0.5);
    delete(cd3);
    cd2 = text(50,55,'2','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 30);
    pause(0.5);
    delete(cd2);
    cd1 = text(50,55,'1','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 30);
    pause(0.5);
    delete(cd1);
    cdgo = text(50,55,'GO!','color','[0.7,0.7,0.7]','FontName','OCR A Extended','fontsize', 30);
    pause(0.5);
    delete(cdgo);
end
