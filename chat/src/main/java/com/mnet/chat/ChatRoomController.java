package com.mnet.chat;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mnet.chat.dao.ChatContentDAO;
import com.mnet.chat.dao.ChatMemberDAO;
import com.mnet.chat.dao.ChatRoomDAO;
import com.mnet.chat.dto.ChatContentDTO;
import com.mnet.chat.dto.ChatMemberDTO;
import com.mnet.chat.dto.ChatRoomDTO;

@Controller
public class ChatRoomController extends ObjectController {

	@RequestMapping(value="/room_list")
	@ResponseBody
	public String room_list(int member_num) {
		crdao = sst.getMapper(ChatRoomDAO.class);
		cmdao = sst.getMapper(ChatMemberDAO.class);
		ccdao = sst.getMapper(ChatContentDAO.class);
		String json="";
		ObjectMapper mapper = new ObjectMapper();
		ArrayList<ChatRoomDTO> crlist = crdao.room_list(member_num);
		ArrayList<ChatMemberDTO> cmlist = cmdao.cm_member_info(member_num);
		for(ChatRoomDTO crdto : crlist) {
			ArrayList<ChatMemberDTO> list = cmdao.cm_member_info2(crdto.getCr_num(), member_num);
			ChatContentDTO ccdto = ccdao.content_info(crdto.getCr_num());
			crdto.setImage_check(ccdto.getImage_check());
			String cr_name = "";
			int person = 0;											//채팅방에 속해있는 인원 수
			for(ChatMemberDTO dto : list) {
				cr_name += dto.getName()+",";
				person++;
			}
			person += 1; 											//+1 해주는 이유는 내가 포함이 안돼있어서!! 나 포함+1
			if(cr_name.length()>11) {
				cr_name = cr_name.substring(0,10)+"...["+person+"]";
				crdto.setCr_name(cr_name.substring(0,cr_name.length()));
				crdto.setProfile_image(list.get(0).getProfile_image());
			}else if(cr_name.length()<11 && cr_name.length()>0){			
				cr_name = cr_name.substring(0,cr_name.length()-1);
				crdto.setCr_name(cr_name.substring(0,cr_name.length()));
				crdto.setProfile_image(list.get(0).getProfile_image());
			}else {
				cr_name = "대화상대 없음";
				crdto.setCr_name(cr_name.substring(0,cr_name.length()));
				/*crdto.setProfile_image(list.get(0).getProfile_image());*/
			}
			
			if(ccdto!=null) {
				crdto.setCc_content(ccdto.getCc_content());
				crdto.setSend_date(ccdto.getSend_date());
			}
		}
		/*for(ChatRoomDTO crdto : crlist) {
			for(ChatMemberDTO cdto : cmlist) {
				if(crdto.getCr_num() == cdto.getCr_num()) {
					crdto.setProfile_image(cdto.getProfile_image());
					crdto.setId(cdto.getId());
						String cr_name = "";
						for(ChatMemberDTO cdto2 : cmlist) {
							cr_name += cdto2.getId()+",";
						}
						crdto.setCr_name(cr_name.substring(0,cr_name.length()-1));
				}
			}
		}*/
		try {
			json = mapper.writeValueAsString(crlist);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for(ChatRoomDTO crdto : crlist) {
			System.out.println(crdto.getId());
			System.out.println(crdto.getProfile_image());
			System.out.println(crdto.getCr_name());
		}
		return json;
		
	}
	@RequestMapping(value="/make_group_ok")
	public void make_group_ok(String add_num,ChatRoomDTO crdto,ChatMemberDTO cmdto, HttpServletResponse resp, HttpSession s) throws IOException {
		int member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		add_num += member_num;
		String[] add_num_spl = add_num.split("/");
		ChatContentDTO ccdto = new ChatContentDTO();
		crdao = sst.getMapper(ChatRoomDAO.class);
		cmdao = sst.getMapper(ChatMemberDAO.class);
		ccdao = sst.getMapper(ChatContentDAO.class);
		crdto.setCr_leader(member_num);
		crdto.setSender_num(member_num);
		crdto.setReceiver_num(member_num);
		cmdto.setCr_leader(member_num);
		crdao.make_room(crdto);
		int cr_num = crdao.max_cr_num(member_num);
		ccdto.setCr_num(cr_num);
		ccdto.setSender_num(0);
		ccdto.setCc_content("대화방이 생성되었습니다.");
		ccdto.setImage_check("x");
		for(int i=0; i<add_num_spl.length; i++) {
			System.err.println(add_num_spl[i]);
			int member_num2 = Integer.parseInt(add_num_spl[i].toString());
			cmdto.setMember_num(member_num2);
			cmdao.add_member_group(cmdto);
		}
		ccdao.add_content(ccdto);
		resp.getWriter().print(1);
	}
	
}
