package com.mnet.chat;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mnet.chat.dao.ChatContentDAO;
import com.mnet.chat.dao.ChatMemberDAO;
import com.mnet.chat.dao.MemberDAO;
import com.mnet.chat.dto.ChatContentDTO;
import com.mnet.chat.dto.ChatMemberDTO;
import com.mnet.chat.dto.MemberDTO;

@Controller
public class ChatMemberController extends ObjectController {
	@RequestMapping(value="/exit_room")
	public void exit_room(HttpServletResponse resp, ChatMemberDTO cmdto) throws IOException {
		cmdao = sst.getMapper(ChatMemberDAO.class);
		ccdao = sst.getMapper(ChatContentDAO.class);
		mdao = sst.getMapper(MemberDAO.class);
		MemberDTO mdto = mdao.member_info_type_num(cmdto.getMember_num());
		ChatContentDTO ccdto = new ChatContentDTO();
		ccdto.setCr_num(cmdto.getCr_num());
		ccdto.setCc_content(mdto.getName()+"님께서 방을 나가셨습니다.");
		ccdto.setSender_num(0);
		ccdto.setImage_check("x");
		cmdao.exit_room(cmdto);
		ccdao.add_content(ccdto);
		resp.getWriter().print(1);
	}
	@RequestMapping(value="/add_group_ok")
	public void add_group_ok(ChatMemberDTO cmdto,String add_num,HttpServletResponse resp, HttpSession s) throws IOException {
		cmdao = sst.getMapper(ChatMemberDAO.class);
		ccdao = sst.getMapper(ChatContentDAO.class);
		mdao = sst.getMapper(MemberDAO.class);
		int my_num = Integer.parseInt(s.getAttribute("member_num").toString());
		MemberDTO mdto = mdao.member_info_type_num(my_num);
		String name = mdto.getName();
		ChatContentDTO ccdto = new ChatContentDTO();
		String[] add_num_spl = add_num.split("/");
		ccdto.setSender_num(0);
		ccdto.setImage_check("x");
		ccdto.setCr_num(cmdto.getCr_num());
		for(int i=0; i<add_num_spl.length; i++) {
			int member_num = Integer.parseInt(add_num_spl[i].toString());
			MemberDTO mdto2 = mdao.member_info_type_num(member_num);
			String receiver_name = mdto2.getName();
			cmdto.setMember_num(member_num);
			cmdao.add_member_group_chat_room(cmdto);
			ccdto.setCc_content(name+"님이 "+receiver_name+"님을 초대하였습니다.");
			ccdao.add_content(ccdto);
		}
		
		resp.getWriter().print(1);
	}
	@RequestMapping(value="/group_member_list")
	@ResponseBody
	public String group_member_list(int cr_num) {
		cmdao = sst.getMapper(ChatMemberDAO.class);
		ArrayList<ChatMemberDTO> cmlist = cmdao.chat_member_info_cr_num(cr_num);
		String group_member = "";
		String json="";
		ObjectMapper mapper = new ObjectMapper();
		
		for(ChatMemberDTO cmdto : cmlist) {
			group_member += cmdto.getMember_num();
		}
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("group_member",cmlist);
		try {
			json = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
		
	}
}
