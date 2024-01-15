load ModelParameters.mat;
SimulinkEnv = 'Q_Car_RL_TD3_Road_Signal';

obsInfo = rlNumericSpec([6 1],...
    'LowerLimit',[-inf -inf -inf -inf -inf -inf]',...
    'UpperLimit',[ inf  inf inf inf inf inf]');
obsInfo.Name = 'observations';
obsInfo.Description = 'Int Acc Body, Acc Body, Der Acc Body,Int Dis Suspension, Dis Suspension, Der Dis Suspension';
numObservations = obsInfo.Dimension(1);

actInfo = rlNumericSpec([1 1],...
    'LowerLimit',-4000,...
    'UpperLimit',4000);
actInfo.Name = 'force';
numActions = actInfo.Dimension(1);

env = rlSimulinkEnv(SimulinkEnv,strcat(SimulinkEnv,'/RL Agent'),...
    obsInfo,actInfo);
env.ResetFcn = @(in)localResetFcn(in);

Ts = 0.001;
Tf = 4;
rng(0);
useGPU = false;

L = 96; % number of neurons

statePath = [
    imageInputLayer([numObservations 1 1],'Normalization','none','Name','State')
    fullyConnectedLayer(L,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(L,'Name','CriticStateFC2')];
actionPath = [
    imageInputLayer([numActions 1 1],'Normalization','none','Name','Action')
    fullyConnectedLayer(L,'Name','CriticActionFC1')];
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(L,'Name','CriticCommonFC')
    reluLayer('Name','CriticCommonRelu1')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');

criticOpts = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);
critic1 = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,'Observation',{'State'},'Action',{'Action'},criticOpts);
critic2 = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,'Observation',{'State'},'Action',{'Action'},criticOpts);

actorNetwork = [
    imageInputLayer([numObservations 1 1],'Normalization','none',"Name","State")
    fullyConnectedLayer(L,"Name","actorFC1")
    reluLayer("Name","actorRelu1")
    fullyConnectedLayer(L,"Name","actorFC2")
    reluLayer("Name","actorRelu2")
    fullyConnectedLayer(L,"Name","actorFC3")
    reluLayer("Name","actorRelu3")
    fullyConnectedLayer(1,"Name","Action")
%     tanhLayer("Name","actorTanh")
%     scalingLayer("Name","Action","Scale",25000)
    ];

actorOptions = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1);
actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'State'},'Action',{'Action'},actorOptions);

agentOpts = rlTD3AgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'DiscountFactor',0.9, ...
    'MiniBatchSize',64, ...
    'ExperienceBufferLength',1e6); 
% agentOpts.NoiseOptions.Variance = 0.6;
% agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;


maxepisodes = 250;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes, ...
    'MaxStepsPerEpisode',maxsteps, ...
    'ScoreAveragingWindowLength',20, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',100);

trainOpts.UseParallel = false;
agentOpts.SaveExperienceBufferWithAgent = true;
USE_PRE_TRAINED_MODEL = false; % Set to true, to use pre-trained
PRE_TRAINED_MODEL_FILE = "savedAgents\Agent1000.mat" ;

% Set agent option parameter:
agentOpts.ResetExperienceBufferBeforeTraining = not(USE_PRE_TRAINED_MODEL);
if USE_PRE_TRAINED_MODEL
    % Load experiences from pre-trained agent    
    sprintf('- Continue training pre-trained model: %s', PRE_TRAINED_MODEL_FILE);   
    load(PRE_TRAINED_MODEL_FILE,'saved_agent');
    agent = saved_agent;
else
    % Create a fresh new agent
    agent = rlTD3Agent(actor,[critic1 critic2],agentOpts);
end
% Train the agent
trainingStats = train(agent, env, trainOpts);

%after training finish, save the final agent and the training status.
save(trainOpts.SaveAgentDirectory + "/finalAgent.mat",'agent');
save(trainOpts.SaveAgentDirectory + "/training_status.mat",'trainingStats');

%After training finish, if episode manager is closed, can use below command to
%reopen it. 
%load ./savedAgents/training_status.mat
%rlPlotTrainingResults(trainingStats)