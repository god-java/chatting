package com.mnet.chat.dao;

import java.util.ArrayList;

import com.mnet.chat.dto.ChatMemberDTO;

public interface ChatMemberDAO {
	public void add_member(int sender_num, int member_num);
	public ArrayList<ChatMemberDTO> cm_member_info(int member_num);
	public ArrayList<ChatMemberDTO> cm_member_info2(int cr_num, int member_num);
	public ArrayList<Integer> find_member_num(int cr_num);
	public ArrayList<ChatMemberDTO> find_chat_member(int cr_num);
	public void add_member_group(ChatMemberDTO cmdto);
	public void exit_room(ChatMemberDTO cmdto);
	public void add_member_group_chat_room(ChatMemberDTO cmdto);
	public ArrayList<ChatMemberDTO> chat_member_info_cr_num(int cr_num);
}
