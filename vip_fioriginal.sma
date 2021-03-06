#include <amxmodx>
#include <cstrike>
#include <fun>
#include <hamsandwich>
#include <engine>
#include <colorchat>

#define VIP_LEVEL_ACCES ADMIN_LEVEL_F

#define SCOREATTRIB_NONE    0
#define SCOREATTRIB_DEAD    ( 1 << 0 )
#define SCOREATTRIB_BOMB    ( 1 << 1 )
#define SCOREATTRIB_VIP  ( 1 << 2 )

new cvar_tag, cvar_start_hp, cvar_start_ap, cvar_start_money, cvar_vip_jump, cvar_hp_kill, cvar_ap_kill, jumpnum[33], bool: dojump[33], bool:use[33];

public plugin_init() 
{
	register_plugin("Classic VIP-FIROGINAL.RO", "1.8", "StefaN@CSX");
	
	RegisterHam(Ham_Spawn, "player", "Spawn", 1);
	
	register_clcmd("say /vmenu","vip_menu", -1);
	register_clcmd("say /vip","vip_info");
	register_clcmd("say", "handle_say");
	register_clcmd("say_team", "handle_say");
	
	set_task(120.0, "mesaj_info", _, _, _, "b");
	
	register_event("DeathMsg", "eDeathMsg", "a");
	register_event("HLTV", "Event_NewRound", "a", "1=0", "2=0");
	register_message( get_user_msgid( "ScoreAttrib" ), "MessageScoreAttrib" );
	
	cvar_tag = register_cvar("amx_vip_tag","VIP");
	cvar_start_hp = register_cvar("amx_start_hp","150");
	cvar_start_ap = register_cvar("amx_start_ap","180");
	cvar_start_money = register_cvar("amx_start_money","8000");
	cvar_vip_jump = register_cvar( "amx_vip_jump", "1" );
	cvar_hp_kill = register_cvar( "amx_vip_addhp", "10" );	
	cvar_ap_kill = register_cvar( "amx_vip_addap", "10" );
	
}

public Event_NewRound()
{
	arrayset( use, false, 33 );
}

public vip_menu(id) 
{
	new menu
	switch( cs_get_user_team( id ))
	{
		case CS_TEAM_CT:
		{
			menu = menu_create( "\y[\rVIP Classic\y] \wMeniu \yVIP \rCounter-Terrorists", "menu_ammunition" );
			menu_additem(menu, "\rM4A1 \y+ \rDEAGLE \y+ \rSET GRENAZI", "1", VIP_LEVEL_ACCES );
			menu_additem(menu, "\rFAMAS \y+ \rDEAGLE \y+ \rSET GRENAZI", "2", VIP_LEVEL_ACCES );
			menu_additem(menu, "\rAWP \y+ \rDEAGLE \y+ \rSET GRENAZI", "3", VIP_LEVEL_ACCES );
		}
	
		case CS_TEAM_T:
		{
			menu = menu_create( "\y[\rVIP Classic\y] \wMeniu \yVIP \rTerrorists", "menu_ammunition" );
			menu_additem(menu, "\rAK47 \y+ \rDEAGLE \y+ \rSET GRENAZI", "1", VIP_LEVEL_ACCES );
			menu_additem(menu, "\rGALIL \y+ \rDEAGLE \y+ \rSET GRENAZI", "2", VIP_LEVEL_ACCES );
			menu_additem(menu, "\rAWP \y+ \rDEAGLE \y+ \rSET GRENAZI", "3", VIP_LEVEL_ACCES );
		}
	}
	menu_display(id, menu, 0)
	return PLUGIN_HANDLED;
}

public menu_ammunition ( id, menu, item ) 
{
	new tag[ 32 ];
	get_pcvar_string( cvar_tag, tag, charsmax(tag) );
	
	if( use[id] )
	{
		ColorChat(id,GREEN,"^3[%s] ^1Meniul poate fi folosit doar o data pe runda !",tag);
		return PLUGIN_HANDLED;
	}
	
	if( item == MENU_EXIT )
	{
		return PLUGIN_HANDLED;
	}
	new data[6], szName[64];
	new access, callback;
	menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
	new key = str_to_num(data);
	if( cs_get_user_team( id ) == CS_TEAM_CT )
		switch(key)
	{
		case 1:
	{
			give_item(id, "weapon_m4a1");
			give_item(id, "weapon_deagle");
			give_item(id, "weapon_hegrenade");
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_smokegrenade");
			cs_set_user_bpammo (id , CSW_HEGRENADE , 1 );
			cs_set_user_bpammo (id , CSW_FLASHBANG , 2 );
			cs_set_user_bpammo (id , CSW_SMOKEGRENADE , 1 );
			cs_set_user_bpammo(id, CSW_M4A1, 90);
			cs_set_user_bpammo(id, CSW_DEAGLE, 35);
			ColorChat(id,GREEN,"^3[%s] ^1Ai primit ^4M4A1+DEAGLE+SET GRENAZI ^1gratis.",tag);
	}
		case 2:
	{
			give_item(id, "weapon_famas");
			give_item(id, "weapon_deagle");
			give_item(id, "weapon_hegrenade");
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_smokegrenade");
			cs_set_user_bpammo (id , CSW_HEGRENADE , 1 );
			cs_set_user_bpammo (id , CSW_FLASHBANG , 2 );
			cs_set_user_bpammo (id , CSW_SMOKEGRENADE , 1 );
			cs_set_user_bpammo(id, CSW_FAMAS, 90);
			cs_set_user_bpammo(id, CSW_DEAGLE, 35);
			ColorChat(id,GREEN,"^3[%s] ^1Ai primit ^4FAMAS+DEAGLE+SET GRENAZI ^1gratis.",tag);
	}
		case 3:
	{
			give_item(id, "weapon_awp");
			give_item(id, "weapon_deagle");
			give_item(id, "weapon_hegrenade");
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_smokegrenade");
			cs_set_user_bpammo (id , CSW_HEGRENADE , 1 );
			cs_set_user_bpammo (id , CSW_FLASHBANG , 2 );
			cs_set_user_bpammo (id , CSW_SMOKEGRENADE , 1 );
			cs_set_user_bpammo(id, CSW_AWP, 30);
			cs_set_user_bpammo(id, CSW_DEAGLE, 35);
			ColorChat(id,GREEN,"^3[%s] ^1Ai primit ^4AWP+DEAGLE+SET GRENAZI ^1gratis.",tag);
	}      
}
	if( cs_get_user_team( id ) == CS_TEAM_T )
		switch(key)
	{
		case 1:
	{
			give_item(id, "weapon_ak47");
			give_item(id, "weapon_deagle");
			give_item(id, "weapon_hegrenade");
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_smokegrenade");
			cs_set_user_bpammo (id , CSW_HEGRENADE , 1 );
			cs_set_user_bpammo (id , CSW_FLASHBANG , 2 );
			cs_set_user_bpammo (id , CSW_SMOKEGRENADE , 1 );
			cs_set_user_bpammo(id, CSW_AK47, 90);
			cs_set_user_bpammo(id, CSW_DEAGLE, 35);
			ColorChat(id,GREEN,"^3[%s] ^1Ai primit ^4AK47+DEAGLE+SET GRENAZI ^1gratis.",tag);
	}      
		case 2:
	{
			give_item(id, "weapon_galil");
			give_item(id, "weapon_deagle");
			give_item(id, "weapon_hegrenade");
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_smokegrenade");
			cs_set_user_bpammo (id , CSW_HEGRENADE , 1 );
			cs_set_user_bpammo (id , CSW_FLASHBANG , 2 );
			cs_set_user_bpammo (id , CSW_SMOKEGRENADE , 1 );
			cs_set_user_bpammo(id, CSW_GALIL, 90);
			cs_set_user_bpammo(id, CSW_DEAGLE, 35);
			ColorChat(id,GREEN,"^3[%s] ^1Ai primit ^4GALIL+DEAGLE+SET GRENAZI ^1gratis.",tag);
	}
		case 3:
	{
			give_item(id, "weapon_awp");
			give_item(id, "weapon_deagle");
			give_item(id, "weapon_hegrenade");
			give_item(id, "weapon_flashbang");
			give_item(id, "weapon_smokegrenade");
			cs_set_user_bpammo (id , CSW_HEGRENADE , 1 );
			cs_set_user_bpammo (id , CSW_FLASHBANG , 2 );
			cs_set_user_bpammo (id , CSW_SMOKEGRENADE , 1 );
			cs_set_user_bpammo(id, CSW_AWP, 30);
			cs_set_user_bpammo(id, CSW_DEAGLE, 35);
			ColorChat(id,GREEN,"^3[%s] ^1Ai primit ^4AWP+DEAGLE+SET GRENAZI ^1gratis.",tag);
	}      
	}
	menu_destroy(menu);
	use[id] = true;
	return  PLUGIN_HANDLED;  
}

public Spawn(id) 
{ 
	if (!is_user_alive(id))
		return;
    
	new CsTeams:team = cs_get_user_team(id) 
	if(get_user_flags(id) & VIP_LEVEL_ACCES) 
	{
		switch(team) 
	    {
		case CS_TEAM_T: 
		{
			set_user_health(id, get_pcvar_num(cvar_start_hp));
			set_user_armor(id, get_pcvar_num(cvar_start_ap));
			cs_set_user_money(id, cs_get_user_money(id) + get_pcvar_num(cvar_start_money));
		}
		case CS_TEAM_CT: {
			set_user_health(id, get_pcvar_num( cvar_start_hp ));
			set_user_armor(id, get_pcvar_num( cvar_start_ap ));
			cs_set_user_money(id, cs_get_user_money(id) + get_pcvar_num(cvar_start_money));
		}
	    }
	}
}

public client_putinserver(id) 
{ 
	set_task(2.0, "bun_venit", id);
	
	jumpnum[ id ] = 0;
	dojump[ id ] = false;
}

public client_disconnect( id )
{
	jumpnum[ id ] = 0;
	dojump[ id ] = false;
}

public client_PreThink( id )
{
	if( !is_user_alive( id ) ) 
		return PLUGIN_CONTINUE;

	new BUTON = get_user_button( id )
	new OLDBUTON = get_user_oldbutton( id )
	new JUMP_VIP = get_pcvar_num( cvar_vip_jump ) 

	if( ( BUTON & IN_JUMP ) && !( get_entity_flags( id ) & FL_ONGROUND ) && !( OLDBUTON & IN_JUMP ) )
	{
		if( ( ( get_user_flags( id ) & VIP_LEVEL_ACCES ) && ( jumpnum[ id ] < JUMP_VIP ) ) )
		{
			dojump[ id ] = true
			jumpnum[ id ]++
		}
	}

	if( ( BUTON & IN_JUMP ) && ( get_entity_flags( id ) & FL_ONGROUND ) )
	{
		jumpnum[ id ] = 0
	}

	return PLUGIN_CONTINUE;
}

public client_PostThink( id ) 
{
	if( !is_user_alive( id ) ) 
		return PLUGIN_CONTINUE;

	if( dojump[ id ] == true )
	{
		new Float: velocity[ 3 ]	
		entity_get_vector( id, EV_VEC_velocity, velocity )
		velocity[ 2 ] = random_float( 265.0, 285.0 )
		entity_set_vector( id, EV_VEC_velocity, velocity )
		dojump[ id ] = false
	}

	return PLUGIN_CONTINUE;
}

public eDeathMsg( )
{
	new id_Killer = read_data( 1 );
	new id_Attacker = read_data( 2 );
	if(is_user_alive(id_Killer))
	{
		if(cs_get_user_team(id_Attacker) == CS_TEAM_CT)
		if(get_user_flags(id_Killer) & VIP_LEVEL_ACCES )
			{
				set_user_health(id_Killer, get_user_health(id_Killer) + get_pcvar_num(cvar_hp_kill));
				set_user_armor(id_Killer, get_user_armor(id_Killer) + get_pcvar_num(cvar_ap_kill));
			}

		if(cs_get_user_team(id_Attacker) == CS_TEAM_T)
		if(get_user_flags(id_Killer) & VIP_LEVEL_ACCES )
			{
				set_user_health(id_Killer, get_user_health(id_Killer) + get_pcvar_num(cvar_hp_kill));
				set_user_armor(id_Killer, get_user_armor(id_Killer) + get_pcvar_num(cvar_ap_kill));
			}
	}
}

public bun_venit(id) 	
{
	new tag[32], name[32];

	get_pcvar_string( cvar_tag, tag, charsmax(tag) ); 
	get_user_name(id, name, charsmax(name) ); 

	if(get_user_flags(id) & VIP_LEVEL_ACCES)   
	{ 
		ColorChat(0,GREEN,"^3[%s] ^1VIP: ^4%s ^1s-a conectat. ", tag, name); 
	}
	return PLUGIN_HANDLED;
}

public vip_info(id)
{
	show_motd(id, "/addons/amxmodx/configs/vip_info.html");
}

public mesaj_info()	
{
	new tag[ 32 ];
	get_pcvar_string( cvar_tag, tag, charsmax(tag) );
	
	ColorChat(0,GREEN,"^3[%s] ^1Tastati in chat ^4/vip ^1pentru a vedea beneficiile si pretul vip-ului.",tag);
}

public handle_say(id) 
{
	new said[192];
	read_args(said,192);
	if(contain(said, "/vips") != -1)
		set_task(0.1,"print_adminlist",id);
	return PLUGIN_CONTINUE;
}

public print_adminlist(user) 
{
	new tag[ 32 ];
	get_pcvar_string( cvar_tag, tag, 31 );
	
	new adminnames[33][32];
	new message[256];
	new id, count, x, len;
    
	for(id = 1 ; id <= get_maxplayers() ; id++)
		if(is_user_connected(id))
			if(get_user_flags(id) & VIP_LEVEL_ACCES)
				get_user_name(id, adminnames[count++], charsmax(adminnames[ ]));
    
	len = format(message, 255, "^3[%s] ^1VIP-ii online sunt:^4 ",tag);
	if(count > 0) 
		{
		for(x = 0 ; x < count ; x++) 
		{
			len += format(message[len], 255-len, "%s%s ", adminnames[x], x < (count-1) ? ", ":"");
			if(len > 96) 
			{
				print_message(user, message);
				len = format(message, 255, " ");
			}
		}
		print_message(user, message);
		}
		else 
	{
			len += format(message[len], 255-len, "^x03[%s]^x04 Nu sunt VIP-i online.", tag);
			print_message(user, message);
	}   
}
print_message(id, msg[]) 
{
	message_begin(MSG_ONE, get_user_msgid("SayText"), {0,0,0}, id);
	write_byte(id);
	write_string(msg);
	message_end();
}

public MessageScoreAttrib( iMsgID, iDest, iReceiver ) 
{
    	new iPlayer = get_msg_arg_int( 1 );
    	if( is_user_connected( iPlayer )
    	&& ( get_user_flags( iPlayer ) & VIP_LEVEL_ACCES ) ) 
		{
        		set_msg_arg_int( 2, ARG_BYTE, is_user_alive( iPlayer ) ? SCOREATTRIB_VIP : SCOREATTRIB_DEAD );
    		}
}  
