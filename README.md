# QCar_TD3
This is an official code release for this project  
__Quarter Car Suspension Control by Reinforcement Learning with TD3 agent__

## Introduction
Coming with the rising focus of the driving comfort request, more efforts are being delivered into the study of suspension system. Comparing with other traditional control methods, the machine learning control strategy has demonstrated its optimality in dealing with different class of roads. The work presented in this paper is to apply twin delayed deep deterministic policy gradients (TD3) in suspension control which enables suspension controller to go beyond searching for an optimal set of system parameters from traditional control method in dealing with different class of pavements. To achieve this, a suspension model has been established together with a reinforcement learning algorithm and an input signal of pavement in this project. The performance of the twin delayed reinforcement agent is compared against deep deterministic policy gradients (DDPG) and deep Q-learning (DQN) algorithms under different types of pavement. The simulation result shows its superiority, robustness and learning efficiency over other reinforcement learning algorithms.


## Instructions
This code is based on Matlab and Simulink version 2020b. This case study is using a quarter car suspention model stimulated by Class B pavement signal as the Environment for a TD3 agnet to explore and learn. Everything is setup, please follow below process to conduct the learning.
* Step 1: Open and run *LoadParameters.m* (this will load the quarter car model parameters and pavement parameters before the learning initiates.)
* Step 2: Open *Q_Car_RL_TD3_Road_Signal.slx* (this will open the Simulink model which contains __Road Signal Model, Suspension Model and Reinforcement Learning Frame__.)
* Step 3: Open and run *Learning_Algorithm_TD3.m* (This will launch the learning progress and an episode manager window will appear automaticlly.I set episode to 250 with 4000 steps in each episode, so it is 1 million iterations totally)
* Step 4: Once the learning is done, (it might take around 4-6 hours depending on your hardware), the result will be saved in the folder namded __savedAgents__, there will be two files there, *finalAgent.mat* and *training_status.mat*. The former one is the final agent from the training which can be reused or trained further later on, the latter one is a record of the whole training progress. It can be reopened by episode manager to recheck your rewawrds curve during learning.
* Step 5: If you want to reopen or reuse the agent you have trained after you close matlab and simulink, redo Step 1 and Step 2, then open and run *Agent_Run.m*, this will load your final trained agent which is saved in the folder namded __savedAgents__.

## Critical Parameters
To be updated

## Papers and Citations
If you find this project useful in your research, please give us a star and consider citing:

[Twin delayed deep deterministic reinforcement learning application in vehicle electrical suspension control](https://www.inderscienceonline.com/doi/epdf/10.1504/IJVP.2023.133852)  
[A Study on Active Suspension System with Reinforcement Learning](https://opus.lib.uts.edu.au/handle/10453/167608)
