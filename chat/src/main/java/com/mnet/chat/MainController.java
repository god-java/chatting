package com.mnet.chat;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mnet.chat.dao.MemberDAO;
import com.mnet.chat.dto.MemberDTO;

@Controller
public class MainController extends ObjectController {
	
	@RequestMapping(value="/main")
	public String main(Model m,HttpSession s) {
		mdao = sst.getMapper(MemberDAO.class);
		int member_num = 0;
		if(s.getAttribute("member_num")!=null) {
			member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		}
		ArrayList<MemberDTO> mlist = mdao.member_list(member_num);
		m.addAttribute("mlist",mlist);
		return "main";
	}
	
	@RequestMapping(value="/login")
	public String login(Model m) {
		m.addAttribute("center","login.jsp");
		return "main";
	}
}
