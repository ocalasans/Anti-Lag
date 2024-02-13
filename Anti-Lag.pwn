/*
    * Filterscript Anti-Lag

    © [2024] [Calasans]. Todos os direitos reservados.

    Discord: ocalasans
    Youtube: Calasans
    Instagram: ocalasans

    SA:MP Programming Comunnity©: https://abre.ai/samp-spc
*/

#define FILTERSCRIPT
//
#include <a_samp>
//
main(){}
//
static bool:ALF_verificou[MAX_PLAYERS],
    ALF_string[128],
    ALF_ping[500],
    ALF_ping2[1000],
    ALF_pegando_ping[MAX_PLAYERS];
//
const ALF_MAX_PING = 500;
//
#define ALF_function:%0(%1) forward %0(%1);\
                            public %0(%1)
//
stock ALF_nome_player(playerid)
{
    static nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    //
    return nome;
}

stock ALF_pegar_infos(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        new ip[15],
            version[10];
        //
        GetPlayerIp(playerid, ip, sizeof(ip)), GetPlayerVersion(playerid, version, sizeof(version));
        //
        ALF_ping[0] = EOS;
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}Voce foi kickado do servidor por ultrapassar o limite\n");
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}maximo do ping permitido pelo servidor ({FFFFFF}%dms{B4B5B7}).\n\n", ALF_MAX_PING);
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}Informacoes:\n");
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}Seu nome ({FFFFFF}%s{B4B5B7}).\n", ALF_nome_player(playerid));
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}Seu IP ({FFFFFF}%s{B4B5B7}).\n", ip);
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}Sua versao ({FFFFFF}%s{B4B5B7}).\n", version);
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}Seu ping ({FFFFFF}%d{B4B5B7}).\n\n", GetPlayerPing(playerid));
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}Se voce estiver usando uma proxy(VPN), recomendamos que\n");
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}voce desative pois voce pode ser kickado novamento por\n");
        strcat(ALF_ping, ALF_ping2);
        format(ALF_ping2, sizeof(ALF_ping2), "{B4B5B7}ping maximo.\n");
        strcat(ALF_ping, ALF_ping2);
        //
        ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "{FFFFFF}Revisao Anti-Lag", ALF_ping, "Informado","");
        //
        return true;
    }
    return false;
}

ALF_function:ALF_bug_ping(playerid)
    return ALF_pegando_ping[playerid] = SetTimerEx("ALF_verificar_ping", 1100, true, "i", playerid);
//
ALF_function:ALF_give_kick(playerid)
    return Kick(playerid);
//
ALF_function:ALF_verificar_ping(playerid)
{
    if(IsPlayerConnected(playerid))
    {
      	if(!ALF_verificou[playerid])
    	{
            if(GetPlayerPing(playerid) >= ALF_MAX_PING)
            {
                format(ALF_string, sizeof(ALF_string), "[Anti-Lag]: %s foi kickado por atingir o limite maximo do ping, (PING MAXIMO: %dms).", ALF_nome_player(playerid), ALF_MAX_PING);
                SendClientMessageToAll(0xEC3737FF, ALF_string);
                //
                ALF_pegar_infos(playerid);
                //
                ALF_verificou[playerid] = true;
                SetTimerEx("ALF_give_kick", 500, false, "i", playerid);
            }
        }
        return true;
    }
    return false;
}

public OnFilterScriptInit()
{
    print(" ");
    print("__________________________________________________________________");
    print("||==============================================================||");
    print("||                                                              ||");
    print("||                    Filterscript Anti-Lag                     ||");
    print("||                                                              ||");
    print("||                        By: Calasans                          ||");
    print("||                  Discord: abre.ai/samp-spc                   ||");
    print("||                                                              ||");
    print("||==============================================================||");
    print("__________________________________________________________________");
    print(" ");
    //
    return true;
}

public OnPlayerConnect(playerid)
{
    ALF_verificou[playerid] = false;
    //
    return true;
}

public OnPlayerDisconnect(playerid)
{
    KillTimer(ALF_pegando_ping[playerid]);
    //
    return true;
}

public OnPlayerSpawn(playerid)
{
    SetTimerEx("ALF_bug_ping", 3500, false, "i", playerid);
    //
    return false;
}
