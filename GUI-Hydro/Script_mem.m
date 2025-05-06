%% Script_mem : Storage in matrices of the different values calculated

conta=length(find(B1>0)); %Count the number of days during which the powerplant is producing electricity
giorni_funzionamento=conta/anni_sim;
mem_conta=conta;
mem_B1=B1';

