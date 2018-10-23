package com.mnet.chat.dao;

import java.util.ArrayList;

import com.mnet.chat.dto.ChatRoomDTO;

public interface ChatRoomDAO {

	public void make_room(ChatRoomDTO crdto);
	public int overlap_room(ChatRoomDTO crdto);
	public int max_cr_num(int member_num);
	public int find_cr_num(ChatRoomDTO crdto);
	public ArrayList<ChatRoomDTO> room_list(int member_num);
	public void update_date(int cr_num);
}
