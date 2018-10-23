package com.mnet.chat.dao;

import java.util.ArrayList;

import com.mnet.chat.dto.ChatContentDTO;

public interface ChatContentDAO {
	public void add_content(ChatContentDTO ccdto);
	public void cr_add_content(ChatContentDTO ccdto);
	public ArrayList<ChatContentDTO> content_list(ChatContentDTO ccdto);
	public ArrayList<ChatContentDTO> test_list(ChatContentDTO ccdoo);
	public ArrayList<ChatContentDTO> chat_scroll(ChatContentDTO ccdoo);
	public ArrayList<ChatContentDTO> chat_content_cr_num(ChatContentDTO ccdto);	//cr_num받아서 출력
	public ChatContentDTO content_info(int cr_num);
}
