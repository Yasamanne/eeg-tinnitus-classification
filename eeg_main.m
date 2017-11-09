choice = menu('EEG ANALYSIS_ TINNITUS','create music silence files for Normal/patients','run ICA','Plot Ica','Labeling', 'concatenate files','Randomize Samples', 'Add Header!','IBL', 'KNN for individual','Run SVM', 'MyKnn model 10 neighbors', 'KNN for new subject','Linear Kernel SVMfor test dataset', 'Linear SVM for Individual');

switch choice
    case 1
        num = input('How many files you want to include in the experiments?\n','s');
        k = str2num(num);
        for i = 1:k
            NT = {'TI','Normal'};
            [Selection,ok] = listdlg('ListString',NT);

                if Selection == 1
                    stat = 1;
                else
                    stat = 2;
                end
            [FileName,PathName] = uigetfile('*.edf');
            [pathstr,name,ext] = fileparts(FileName) ;
            modifiedStr = strrep(PathName, '\', '/');
            FinalPath = strcat(modifiedStr,FileName);
            [hdr,datastream] = edfread(FinalPath);
            datastreamC = datastream((3:16),:);                  %select the channels and remove unrelated data
            silence = datastreamC(:,640:22400);                  %select from sec 5 to 175 which is silence
            endof_datastream = size(datastreamC,1)- 23040;
            classical_music = datastreamC(:,24320:endof_datastream);        %select 190-235 seconds which is classical music
            i = num2str(i);
            stat = num2str(stat);
            CSV_silence_final_name = strcat ('C:/Users/yasaman/Documents/MATLAB/','/',stat,i,'_silence', '.csv');        %create the filename for silent (normal/TI + silenec/classical music + name of the subject)
            CSV_classical_music_final_name = strcat ('C:/Users/yasaman/Documents/MATLAB/','/',stat,i,'_classical_music','.csv');  %create a file name for classical music
            csvwrite (CSV_silence_final_name,silence);
            csvwrite (CSV_classical_music_final_name,classical_music);
            msgbox('yeyyyy successful!!!','Success');
        end
        
    case 2
        num = input('How many files you want to include in the experiments?\n','s');
        k = str2num(num);          
            [FileName, Pathname, filterindex] = uigetfile( ...
                    {  '*.csv','CSV-files (*.csv)'; ...
                      }, ...
                       'Pick a file', ...
                       'MultiSelect', 'on');           
            for i = 1:k
            if k>1
                name = FileName{i};
            else 
                name = FileName;
            end
            FinalPath = strcat(Pathname,name);
            outp_finalPath = csvread(FinalPath);
            [Zica, A, T, mu] = myICA(outp_finalPath,14,true);
            ICA_final = Zica.';
            CSV_name_silence_ICA = strcat ('C:/Users/yasaman/Documents/MATLAB/','/',name,' - - AfterICA','.csv');
            csvwrite(CSV_name_silence_ICA,ICA_final);
            msg = strcat('ICA CSV file has been generated for ',name);
            msgbox(msg,'Success');
            end
    case 3 
                ch1 = silence(1,:);
                ch2 = silence(2,:);
                ch3 = silence(3,:);
                ch4 = silence(4,:);
                ch5 = silence(5,:);
                ch6 = silence(6,:);
                ch7 = silence(7,:);
                ch8 = silence(8,:);
                ch9 = silence(9,:);
                ch10 = silence(10,:);
                ch11 = silence(11,:);
                ch12 = silence(12,:);
                ch13 = silence(13,:);
                ch14 = silence(14,:);
                
                AF3 = ICA_final(:,1);
                %channel_name = 'AF3'; 
                 F7 = ICA_final(:,2);
                %channel_name = 'F7'; 
                 F3 = ICA_final(:,3);
                %channel_name = 'FC5'; 
                 FC5 = ICA_final(:,4);
                %channel_name = 'T7'; 
                 T7 = ICA_final(:,5);
                %channel_name = 'P7'; 
                 P7 = ICA_final(:,6);
                %channel_name = 'O1'; 
                 O1 = ICA_final(:,7);
                %channel_name = 'AF3'; 
                O2 = ICA_final(:,8);
                P8 = ICA_final(:,9);
                T8 = ICA_final(:,10);
                FC6 = ICA_final(:,11);
                F4 = ICA_final(:,12);
                F8 = ICA_final(:,13);
                AF4 = ICA_final(:,14);                 
                A = {ch1,AF3,ch2,F7,ch3,F3,ch4,FC5,ch5,T7,ch6,P7,ch7,O1,ch8,O2,ch9,P8,ch10,T8,ch11,FC6,ch12,F4,ch13,F8,ch14,AF4}; 
                    for i = 1:28
                           subplot(14,2,i);
                           B = A(i) ;
                           C = cell2mat(B);
                           plot (C);
                           set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
                           if i == 1
                               title('Channels Raw EEG')
                           end
                           if i == 2
                               title('Channels ICA Components')
                           end                          
                    end
          
    case 4
            num = input('How many files you want to Label?\n','s');
            k = str2num(num);
             NT = {'TI','Normal'};
            [Selection,ok] = listdlg('ListString',NT);

                if Selection == 1
                        stat = 1;
                else
                        stat = 2;
                end
            [FileName, Pathname, filterindex] = uigetfile( ...
                    {  '*.csv','CSV-files (*.csv)'; ...
                      }, ...
                       'Pick a file', ...
                       'MultiSelect', 'on');
            for i = 1:k
                if i>1
                FileName = FileName{i};
                end
                FinalPath = strcat(Pathname,FileName);
                outp_finalPath = csvread(FinalPath);
                       
                for j = 1 :size(outp_finalPath,1)
                    L (j,1)= stat;
                end
            Labeling = [outp_finalPath L];
            Labeling_name = strcat('C:/Users/yasaman/Documents/MATLAB/',set_series,'/',FileName{i},' -- Labeled','.csv');
            csvwrite(Labeling_name,Labeling);
            msg = strcat('Labeling the file has been done for ',FileName{i});
            msgbox(msg,'DONE!');
            end
    case 5
       [filename, pathname, filterindex] = uigetfile( ...
        {  '*.csv','CSV-files (*.csv)'; ...
           '*.slx;*.mdl','Models (*.slx, *.mdl)'; ...
           '*.*',  'All Files (*.*)'}, ...
           'Pick a file', ...
           'MultiSelect', 'on');
        Finalconcat =[];    
        endof = size((filename(1,:).'),1);
        for i = 1:endof
            v = filename{i};
            an = strcat(pathname,v);
            varname = csvread(an);
            Finalconcat = [Finalconcat; varname];

        end
        concat_name = strcat(pathname,'Concatenated_file','.csv');
        csvwrite(concat_name,Finalconcat);
        msgbox('Your Concatenated file is ready!','Ready!');
   
    case 6
        [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        Input = csvread(Current_path);
        n = size(Input,1);
        ordering = randperm(n);
        Randomized_Input = Input(ordering, :);
        Write_path = strcat(modifiedStr,FileName,'_Randomized','.csv');
        csvwrite(Write_path,Randomized_Input);
        msgbox('Randomized file has been created','File Ready!');
    
    case 7  
        [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        Input = readtable(Current_path);
        Input.Properties.VariableNames = {'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
 
    case 8
       
        [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        Input = csvread(Current_path);
        n = size(Input,1);
        test_label = Input(:,15);
        test = Input(:, 1:14);
        predict = bestKNNm.predictFcn(test);
        end_loop = size (test_label,1);
        sum =0;
        res = abs(test_label - predict);
        for i = 1: end_loop
            sum = sum+res(i);
        end
        AC_knn_testset = (1 - (sum/end_loop))*100;
            
   case 9
       [FileName,PathName] = uigetfile('*.csv');
       [pathstr,name,ext] = fileparts(FileName) ;
       modifiedStr = strrep(PathName, '\', '/');
       Current_path = strcat(modifiedStr,FileName);
       test = csvread(Current_path);
       size_test = size(test(:,1));
       train_size = (size(Input,1))*2/3;
       train = Input(1:train_size, 1:14);
       train_label = Input(1:train_size,15);
       predict = knnclassify(test,train,train_label,3);
       end_loop = size_test(1,1);
       TI_KNN_prediction =0;
       for i = 1: end_loop
            if predict(i)==1
                TI_KNN_prediction = TI_KNN_prediction+1;
            end
       end
       if TI_KNN_prediction>(end_loop/2)
           Result = 'TI';
       else 
           Result = 'Normal';
       end
           res = strcat('The result shows this subject is:',Result);
           msgbox(res,'File Ready!');     
            
    case 10 
        [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        Input = csvread(Current_path);
        train_size = (size(Input,1))*2/3;
        data = Input(1:train_size, 1:14);
        test_start_record = train_size+1;
        Group = Input(1:train_size,15);
        SVMStruct = fitcsvm(data,Group,'CrossVal','on');
        test = Input(test_start_record:n, 1:14);
        Group = Input(test_start_record:n,15);
        [LABEL,SCORE,COST] = kfoldPredict(SVMStruct);
        [count_row_COST, count_column_COST] = size(COST);
        sum_COST = sum(COST,1, 'double');
        accuracy = sum_COST(:,2)/count_row_COST;
        disp(sum_COST(:,2))

    case 11
        [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        n = size(Current_path,1);
        Input = readtable(Current_path);
        channels = Input(:,1:14);
        test_Labels = Input (:,15);
        yfit = SVN_Gaussian.predictFcn(channels);
        correct_predicted = 0;
        for l= 1:size(test_Labels,1)
            if  test_Labels.class(l) == yfit(l)
                correct_predicted = correct_predicted + 1;
            end
        end
        IB1_accuracy = correct_predicted/(size(test_Labels,1));
        
    case 12
       [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        n = size(Current_path,1);
        I = readtable(Current_path);
        I = I(2560:3000,:);
        I.Properties.VariableNames = {'AF3','F7','F3','FC5','T7','P7','O1','O2','P8','T8','FC6','F4','F8','AF4'};
        yfit = SVN_Gaussian.predictFcn(I);
        yfit_s = (size(yfit,1));
         Normal_predicted = 0;
         for l= 1:yfit_s
             if  yfit(l,1) == 2
                Normal_predicted = Normal_predicted + 1;
             end
         end
         if Normal_predicted>(yfit_s/2)
             Result = 'Normal';
         else 
             Result = 'TI';
         end
         res = strcat('The result shows this subject is:',Result);
         msgbox(res,'File Ready!');
   
    case 13
        [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        n = size(Current_path,1);

        DF = csvread(Current_path);
        data = DF(1:100,1:14);
        Group = DF(1:100,15);
        SVMStruct = fitcsvm(data,Group,'Standardize',true,'KernelScale','auto',...
        'BoxConstraint',Inf,'ClassNames',[1,2]);
        CVSVMModel = crossval(SVMStruct);
        ScoreSVMModel = fitPosterior(SVMStruct,data,Group);
        L = kfoldLoss(CVSVMModel);
        [label,score] = predict(SVMStruct,DF(100:200,1:14));
        size_predicted_file = size(Group(:,1));
        correct_instance_predicted = 0;
        for i = 1 : size_predicted_file(1,1)
            if label(i)==Group(i)
                correct_instance_predicted=correct_instance_predicted+1;
            end
        end
        Accuracy_SVMStr = correct_instance_predicted/size_predicted_file(1,1);

    case 14
         [FileName,PathName] = uigetfile('*.csv');
        [pathstr,name,ext] = fileparts(FileName) ;
        modifiedStr = strrep(PathName, '\', '/');
        Current_path = strcat(modifiedStr,FileName);
        n = size(Current_path,1);
        DF = csvread(Current_path);
        [label,score] = predict(SVMStruct,DF);
        size_predicted_file = size(DF(:,1));
        size_predicted_file = size_predicted_file(1,1);
        TI_instance_predicted = 0;
        for i = 1 : size_predicted_file
            if label(i)==1
                TI_instance_predicted=TI_instance_predicted+1;
            end
        end
        if TI_instance_predicted>(size_predicted_file)/2
            Result = 'TI';
        else 
            Result = 'Normal';
        end
        res = strcat('The result shows this subject is:',Result);
        msgbox(res,'File Ready!');
end