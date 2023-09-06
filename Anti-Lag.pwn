//Sistema desenvolvido por Walkerxinho7, nao retire os creditos.

#include <a_samp>

#if defined FILTERSCRIPT

#else

main(){}

new bool:Verificou[MAX_PLAYERS];
new MSG_string[128], PING_string[500], PING_string2[1000];
new PegandoPing[MAX_PLAYERS] = { -1, ... };

const MAX_PING = 500; //Voces podem trocar para um numero maior ou menor.

#define Funcao::%0(%1) 		forward %0(%1);\
					        public %0(%1)

stock NomeJogador(playerid)
{
    static nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    return nome;
}

public OnFilterScriptInit()
{
    print("Sistema de Anti-Lag > Walkerxinho7 loaded.");
	return 1;
}

public OnPlayerConnect(playerid)
{
	Verificou[playerid] = false;
	return true;
}

public OnPlayerDisconnect(playerid)
{
	KillTimer(PegandoPing[playerid]);
	PegandoPing[playerid] = -1;
	return true;
}

public OnPlayerSpawn(playerid)
{
    SetTimerEx("AntiBugPing", 3500, false, "i", playerid);
	return false; //Nao mude deixe marcado como false.
}

Funcao::AntiBugPing(playerid)
{
    PegandoPing[playerid] = SetTimerEx("VerificarPing", 1100, true, "i", playerid);
    return true;
}

Funcao::GiveKick(playerid)
{
	Kick(playerid);
	return true;
}

Funcao::VerificarPing(playerid)
{
    if(IsPlayerConnected(playerid))
    {
      	if(!Verificou[playerid])
    	{
            if(GetPlayerPing(playerid) >= MAX_PING)
            {
                format(MSG_string, sizeof(MSG_string), "[Anti-Lag]: %s foi kickado por atingir o limite maximo do ping, (PING MAXIMO: %d ms).", NomeJogador(playerid), MAX_PING);
                SendClientMessageToAll(0xEC3737FF, MSG_string);
                
                PegarInformacoes(playerid);
                
                Verificou[playerid] = true;
                SetTimerEx("GiveKick", 500, false, "i", playerid);
            }
        }
    }
    return true;
}

stock PegarInformacoes(playerid)
{
    if(IsPlayerConnected(playerid))
    {
		new ip[15], version[10];
		GetPlayerIp(playerid, ip, sizeof(ip)), GetPlayerVersion(playerid, version, sizeof(version));
		
        PING_string[0] = EOS;
	    format(PING_string2, sizeof(PING_string2), "{B4B5B7}Voce foi kickado do servidor por ultrapassar o limite\n");
  		strcat(PING_string, PING_string2);
    	format(PING_string2, sizeof(PING_string2), "{B4B5B7}maximo do ping permitido pelo servidor ({FFFFFF}%d{B4B5B7}).\n\n", MAX_PING);
    	strcat(PING_string, PING_string2);
	    format(PING_string2, sizeof(PING_string2), "{B4B5B7}Informacoes:\n");
      	strcat(PING_string, PING_string2);
       	format(PING_string2, sizeof(PING_string2), "{B4B5B7}Seu nome ({FFFFFF}%s{B4B5B7}).\n", NomeJogador(playerid));
      	strcat(PING_string, PING_string2);
		format(PING_string2, sizeof(PING_string2), "{B4B5B7}Seu IP ({FFFFFF}%s{B4B5B7}).\n", ip);
       	strcat(PING_string, PING_string2);
       	format(PING_string2, sizeof(PING_string2), "{B4B5B7}Sua versao ({FFFFFF}%s{B4B5B7}).\n", version);
       	strcat(PING_string, PING_string2);
       	format(PING_string2, sizeof(PING_string2), "{B4B5B7}Seu ping ({FFFFFF}%d{B4B5B7}).\n\n", GetPlayerPing(playerid));
       	strcat(PING_string, PING_string2);
       	format(PING_string2, sizeof(PING_string2), "{B4B5B7}Se voce estiver usando uma proxy(VPN), recomendamos que\n");
      	strcat(PING_string, PING_string2);
      	format(PING_string2, sizeof(PING_string2), "{B4B5B7}voce desative pois voce pode ser kickado novamento por\n");
   		strcat(PING_string, PING_string2);
       	format(PING_string2, sizeof(PING_string2), "{B4B5B7}ping maximo.\n");
       	strcat(PING_string, PING_string2);
       	ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "{FFFFFF}Revisao Anti-Lag", PING_string, "Informado","");
	}
	return true;
}

#endif

