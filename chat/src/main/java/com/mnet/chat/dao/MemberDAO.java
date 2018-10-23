package com.mnet.chat.dao;

import java.util.ArrayList;

import com.mnet.chat.dto.MemberDTO;

public interface MemberDAO {

	public ArrayList<MemberDTO> member_list(int member_num);
	public int login_ok(MemberDTO mdto);
	public MemberDTO member_info(String id);
	public MemberDTO member_info_type_num(int member_num);
	public ArrayList<MemberDTO> find_member(String search);
	public void join_ok(MemberDTO mdto);
	public int overlap_id(String id);
}
