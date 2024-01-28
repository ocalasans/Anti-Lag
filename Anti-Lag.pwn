/*
    * Filterscript Anti-Lag

    © [2024] [Calasans (Walkerxinho7)]. Todos os direitos reservados.

    Discord: walkerxinho7 ou Walkerxinho7#9124
    Youtube: Walkerxinho
    Instagram: ocalasans

    SA:MP Programming Comunnity©: https://abre.ai/samp-spc
*/

#include <a_samp>
//
main(){}
//
static bool:ALI_verificou[MAX_PLAYERS],
    ALI_string[128],
    ALI_ping[500],
    ALI_ping2[1000],
    ALI_pegando_ping[MAX_PLAYERS];
//
const ALI_MAX_PING = 500;
//
#define ALI_function:%0(%1) forward %0(%1);\
                            public %0(%1)
//
stock ALI_nome_player(playerid)
{
    static nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    //
    return nome;
}

stock ALI_pegar_infos(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        new ip[15],
            version[10];
        //
        GetPlayerIp(playerid, ip, sizeof(ip)), GetPlayerVersion(playerid, version, sizeof(version));
        //
        ALI_ping[0] = EOS;
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}Voce foi kickado do servidor por ultrapassar o limite\n");
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}maximo do ping permitido pelo servidor ({FFFFFF}%dms{B4B5B7}).\n\n", ALI_MAX_PING);
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}Informacoes:\n");
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}Seu nome ({FFFFFF}%s{B4B5B7}).\n", ALI_nome_player(playerid));
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}Seu IP ({FFFFFF}%s{B4B5B7}).\n", ip);
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}Sua versao ({FFFFFF}%s{B4B5B7}).\n", version);
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}Seu ping ({FFFFFF}%d{B4B5B7}).\n\n", GetPlayerPing(playerid));
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}Se voce estiver usando uma proxy(VPN), recomendamos que\n");
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}voce desative pois voce pode ser kickado novamento por\n");
        strcat(ALI_ping, ALI_ping2);
        format(ALI_ping2, sizeof(ALI_ping2), "{B4B5B7}ping maximo.\n");
        strcat(ALI_ping, ALI_ping2);
        //
        ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "{FFFFFF}Revisao Anti-Lag", ALI_ping, "Informado","");
        //
        return true;
    }
    return false;
}

ALI_function:ALI_bug_ping(playerid)
    return ALI_pegando_ping[playerid] = SetTimerEx("ALI_verificar_ping", 1100, true, "i", playerid);
//
ALI_function:ALI_give_kick(playerid)
    return Kick(playerid);
//
ALI_function:ALI_verificar_ping(playerid)
{
    if(IsPlayerConnected(playerid))
    {
      	if(!ALI_verificou[playerid])
    	{
            if(GetPlayerPing(playerid) >= ALI_MAX_PING)
            {
                format(ALI_string, sizeof(ALI_string), "[Anti-Lag]: %s foi kickado por atingir o limite maximo do ping, (PING MAXIMO: %dms).", ALI_nome_player(playerid), ALI_MAX_PING);
                SendClientMessageToAll(0xEC3737FF, ALI_string);
                //
                ALI_pegar_infos(playerid);
                //
                ALI_verificou[playerid] = true;
                SetTimerEx("ALI_give_kick", 500, false, "i", playerid);
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
    print("||                 By: Calasans (Walkerxinho7)                  ||");
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
    ALI_verificou[playerid] = false;
    //
    return true;
}

public OnPlayerDisconnect(playerid)
{
    KillTimer(ALI_pegando_ping[playerid]);
    //
    return true;
}

public OnPlayerSpawn(playerid)
{
    SetTimerEx("ALI_bug_ping", 3500, false, "i", playerid);
    //
    return false;
}
