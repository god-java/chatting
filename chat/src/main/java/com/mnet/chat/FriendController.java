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
public class FriendController extends ObjectController {

	@RequestMapping(value="/add_friend")
	public void add_friend(FriendDTO fdto, HttpServletResponse resp) throws IOException {
		fdao = sst.getMapper(FriendDAO.class);
		fdao.add_friend(fdto);
		resp.getWriter().print(1);
	}
	@RequestMapping(value="/delete_friend")
	public void delete_friend(FriendDTO fdto, HttpServletResponse resp) throws IOException {
		fdao = sst.getMapper(FriendDAO.class);
		fdao.delete_friend(fdto);
		resp.getWriter().print(1);
	}
	@RequestMapping(value="/friend_list")
	@ResponseBody
	public String friend_list(HttpSession s) {
		int member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		mdao = sst.getMapper(MemberDAO.class);
		ArrayList<MemberDTO> mlist = mdao.member_list(member_num);
		String json = "";
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("mlist", mlist);
		ObjectMapper mapper = new ObjectMapper();
		try {
			json = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
}
