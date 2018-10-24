clc; clear; %reset

%parametros
 prompt = 'Amostras por passo? ';
 samples=input(prompt);

 prompt = 'Duração amostra em seg? ';
 length=input(prompt);
 
 current_step = 1;

% ciclo de leituras
for angle = -90 : 1 : 270

        disp(['Dealing with angle: ',num2str(angle)]);
        
        powertable(current_step,1)=pi*angle/180;

        for j = 2:samples+1
            rec = audiorecorder(16000, 16, 1); %IMPORTANTE!!!
                                               %mudar para o sample rate do
                                               %device em causa, ex:(44100,16,1)
            % grava segmento
            disp(['A receber amostra ', num2str(j-1), '...']);
            recordblocking(rec, length);
            disp('Terminado.');

            % guarda dados
            recording = getaudiodata(rec,'int16');
            powertable(current_step,j)= (rms(recording))^2;
        end

        mean=1;
        for j = 2:samples+1
            mean=mean*powertable(current_step,j);
        end
        
        mean=nthroot(mean,samples);
        powertable(current_step,samples+2)=mean;  %media geometrica da potencia
        
        
        %cria dois arrays para o grafico polar de cada iteração
        for i = 1:current_step
            anglearray(i)=powertable(i,1);
            powerarray(i)=powertable(i,samples+2);
        end
        powerarray=powerarray/max(abs(powerarray)); %normaliza array
        %angulo com potencia maxima -> 1 ; -3dB = 0.5

        figure(1); title('polar plot');
        polarplot(anglearray,powerarray);
        
        current_step = current_step + 1;
        
        %roda(1);
end

total_steps = current_step;

% cria tabela para leitura directa no ecran
for i = 1:total_steps
    anglevspower(i,1)=round(180*anglearray(i)/pi,0);
    anglevspower(i,2)=powerarray(i);
end

Data = [anglevspower];    % convert to cell array
f = figure('Position', [100 100 300 800]);
t = uitable('Parent', f, 'Position', [50 50 200 700], 'Data', Data);
t.ColumnName = {'Angulo', 'Potencia'};
t.Data = Data;




