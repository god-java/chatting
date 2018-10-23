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
import com.mnet.chat.dao.FriendDAO;
import com.mnet.chat.dao.MemberDAO;
import com.mnet.chat.dto.FriendDTO;
import com.mnet.chat.dto.MemberDTO;

@Controller
public class MemberController extends ObjectController {

	@RequestMapping(value="/login_ok")
	public void login_ok(HttpServletResponse resp,MemberDTO mdto,HttpSession s) throws IOException {
		mdao = sst.getMapper(MemberDAO.class);
		int login_status = 0;
		int count = mdao.login_ok(mdto);
		if(count>0) {
			login_status=1;
			MemberDTO mdto2 = mdao.member_info(mdto.getId());
			int member_num = mdto2.getMember_num();
			s.setAttribute("member_num", member_num);
		}else {
			login_status=0;
		}
		resp.getWriter().print(login_status);
	}
	@RequestMapping(value="/find_member")
	@ResponseBody
	public String find_member(String search,HttpSession s) {
		mdao = sst.getMapper(MemberDAO.class);
		fdao = sst.getMapper(FriendDAO.class);
		int member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		ArrayList<MemberDTO> mlist = mdao.find_member(search);
		for(MemberDTO mdto : mlist) {
			FriendDTO fdto = new FriendDTO();
			fdto.setSender_num(member_num);
			fdto.setReceiver_num(mdto.getMember_num());
			int count = fdao.friend_check(fdto);
			if(count>0) {
				mdto.setFriend_check("y");
			}else if(member_num == mdto.getMember_num()) {
				mdto.setFriend_check("my");
			}
		}
		String json = "";
		ObjectMapper mapper = new ObjectMapper();
		try {
			json = mapper.writeValueAsString(mlist);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
	@RequestMapping(value="/logout")
	public String logout(HttpSession s) {
		s.invalidate();
		return "main";
	}
	@RequestMapping(value="/join_ok")
	public void join_ok(MemberDTO mdto, HttpServletResponse resp) throws IOException {
		mdao = sst.getMapper(MemberDAO.class);
		int count = mdao.overlap_id(mdto.getId());
		if(count<1) {
			mdao.join_ok(mdto);
		}
		resp.getWriter().print(count);
		
	}
	@RequestMapping(value="/overlap_id")
	public void overlap_id(String id,HttpServletResponse resp) throws IOException {
		mdao = sst.getMapper(MemberDAO.class);
		int count = mdao.overlap_id(id);
		resp.getWriter().print(count);
	}
	@RequestMapping(value="/member_info")
	@ResponseBody
	public String member_info(int member_num) {
		mdao = sst.getMapper(MemberDAO.class);
		MemberDTO mdto = mdao.member_info_type_num(member_num);
		String json = "";
		ObjectMapper mapper = new ObjectMapper();
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("mdto", mdto);
		try {
			json = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
}
