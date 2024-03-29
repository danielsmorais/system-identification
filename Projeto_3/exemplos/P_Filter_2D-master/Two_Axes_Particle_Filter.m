%script for a bearing only particle filter

clc;clear all;

axesLimits = [-500 500 -500 500];

numParticles = 3000;%the number of particles we will create

figure(1);close;

rHistory = [];%array to hold the history of the robot's true position

pfHistory = []%array to hold the history of the particle filter's estimated mean position

pillar1 = [-40 100]; %set up the pillar in the room

robot1 = [250 250];%the robot position when it enters the room

robotCo = 240 * pi/180;%robot's true heading in radians

robotCoErr = 0.3;%this value is in radians. reduce this to create tighter fitting particles around the true value

robotSpd = 15;%robots true speed

robotSpdErr = 5;%reduce this value to create tighter fitting particles around the true value

dT = 1;%update every one second

p0 = CreateUniformParticleDistribution(pillar1(1),pillar1(2),500,numParticles); %Create the particles...

%Plot the actual pillar and robot positions

plot(pillar1(1),pillar1(2),'ko','MarkerSize',14);

axis(axesLimits);

plot(robot1(1),robot1(2),'bo','MarkerSize',14); 

plot(p0(:,1),p0(:,2),'ko','MarkerSize',4);

%disp('Press a key to step through the process......');

%pause;

hold on;


for i=1:500%run the filter 500 times

   p1 = p0; %We need p0 to take on the old value of p1 so we can show each step of the filter

   if (~mod(i,20)) %after 10 iterations, the robot will change its motion characteristics
     robotCo = rand()* 2 * pi;
     robotSpd = 30 - rand() * 10;
   end
   
   %make sure the robot doesnt go outside the room.....
   
   if (robot1(1) < axesLimits(1) || robot1(1) > axesLimits(2))
        robotCo = robotCo - pi - pi/8;
     if (robotCo < 0)
        robotCo = 2 * pi + robotCo;
     end
   end
   
   if (robot1(2) < axesLimits(3) || robot1(2) > axesLimits(4))
     robotCo = robotCo - pi - pi/8;
     if (robotCo < 0)
        robotCo = 2 * pi + robotCo;
     end
   end
   
   
   
   
   
   %$$$$$$$$$$$$$$$-COMBINING WEIGHTS BEGINS-$$$$$$$$$$$$$$$$
   
   %This filter uses only two parameters -> range and bearing. When using multiple sensors such as an array
   %of echo sounders, we could implement a multi-variate particle filter using a multi variate gaussian
   %distribution to assign weights to each particle. 
   %In this case, The lines of code within $$$$$$$COMBINING WEIGHTS$$$$$$$$ comment lines
   %will need to be replaced by a multi variate weight assignment algorithm. Please visit my blog
   %http://bayesianadventures.wordpress.com as I will upload the code for multi variate particle filter soon.
   
   %set up and filter using range parameter

   predRng = Distance2D(pillar1,p1);%predict the range value for each particle

   rngWts = WeighAndNormalise(predRng,Distance2D(pillar1,robot1));%assign weights to each particle and normalise
   %by comparing the predicted ranges for each particle and the range observed from the robot's sensor

   %set up and filter using bearing parameter
   
   predBrg = TrueBearing(pillar1,p1);

   brgWts = WeighAndNormalise(predBrg,TrueBearing(pillar1,robot1));%assign weights to each particle and normalise
   %by comparing the predicted bearings for each particle and the bearing observed from the robot's sensor

   %combine range and bearing weights 
   
   f_Wts = brgWts .* rngWts;
   
   f_Wts = f_Wts/sum(f_Wts);%normalise the final weights
   
   %$$$$$$$$$$$$$$$$$-COMBINING WEIGHTS ENDS-$$$$$$$$$$$$$$$
   
   
   
   
   
   
   
  
   %RESAMPLING THE PARTICLES.............
   
   %###########THIS IS A BASIC RESAMPLING ALGORITHM WITH 2 LOOPS ################
   %###########IT IS PAINFULLY SLOW BUT EASY TO UNDERSTAND ######################
   
   %newPosX = Resample(p1(:,1),f_Wts);

   %newPosY = Resample(p1(:,2),f_Wts);
   
   %p1 = [newPosX newPosY];
   
   %#############################--END OF RESAMPLING METHOD 1--####################
   
   
   
   
   
   
   %###########THIS IS A VECTORISED RESAMPLING ALGORITHM ########################
   %###########IT IS FAST FOR SMALL NUMBER OF PARTICLES ( < 1000) ###############
   
   p1 = ResampleSmallSet(p1,f_Wts);

   %#################--END OF RESAMPLING METHOD 2--##############################
   
   
   
   
   
   %###########THIS IS A SINGLE LOOP RESAMPLING ALGORITHM ########################
   %###########IT IS FAST FOR LARGE NUMBER OF PARTICLES ( > 1000) #################
   
   %p1 = ResampleLargeSet(p1,f_Wts);

   %####################--END OF RESAMPLING METHOD 3--#######################
   
   %Append data to history arrays
   
   rHistory = [rHistory;[robot1(1),robot1(2)]];%robot true position history
   
   xMean = mean(p1(:,1));
   
   yMean = mean(p1(:,2));
   
   pfHistory = [pfHistory;[xMean,yMean]];
   
   %plot the results of the filtering
   
   hold off;
   
   %pause(1);
   
   %show particles from last iteration in green
   
   plot(p0(:,1),p0(:,2),'go','MarkerSize',4);
   
   axis(axesLimits);

   hold on;
   
   %show the filtered particles in red

   plot(p1(:,1),p1(:,2),'r+','MarkerSize',8);
   
   %show the pillar

   plot(pillar1(1),pillar1(2),'ko','MarkerSize',14);
   
   %if i < 10
   %plot(robot1(1),robot1(2),'bo','MarkerSize',14);%not relevant in a real world application   
   %endif
   
   %show the tracks of the true robot and the PF estimate
   
   plot(rHistory(:,1),rHistory(:,2),'ko-');%show true track of robot
   
   plot(pfHistory(:,1),pfHistory(:,2),'r+-');%show track estimated by PF
   
   pause(200/10000);%pause for 200 millisecs
   
   %pause;
   
   %prep for the next iteration
   
   p0 = DRWithError(p1,robotCo,robotCoErr,robotSpd,...
   				robotSpdErr,dT);%Move the particles as per the course and speed of the robot....
   				%...and add a small error. Thus we create a full population of new particles
   				%and all the new particles now have the SAME WEIGHT 
   
   robot1 = DRWithError(robot1,robotCo,0,robotSpd,0,dT);%now move the simulated robot
   %in a real world application, the robot would move on its own and this value would come from
   %its onboard kinematic sensors/ motor shaft encoders

end




