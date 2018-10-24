package com.mnet.chat;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mnet.chat.dao.ChatContentDAO;
import com.mnet.chat.dao.ChatMemberDAO;
import com.mnet.chat.dao.MemberDAO;
import com.mnet.chat.dto.ChatContentDTO;
import com.mnet.chat.dto.ChatMemberDTO;
import com.mnet.chat.dto.MemberDTO;

@Controller
public class ChatContentController extends ObjectController {

	@RequestMapping(value="/chat_content_list")
	@ResponseBody
	public String chat_content_list(ChatContentDTO ccdto,HttpSession s) {
		ccdao = sst.getMapper(ChatContentDAO.class);
		cmdao = sst.getMapper(ChatMemberDAO.class);
		mdao = sst.getMapper(MemberDAO.class);
		int member_num = ccdto.getReceiver_num();
		MemberDTO mdto = mdao.member_info_type_num(member_num);
		Map<String,Object> map = new HashMap<String,Object>();
		String json="";
		ArrayList<ChatContentDTO> cclist = ccdao.test_list(ccdto);
		if(cclist.size()==0) {										//리스트에 아무것도 없을 시에 처음 방 생성시에 에러남
			ChatContentDTO dto = new ChatContentDTO();
			cclist.add(dto);
			cclist.get(0).setCr_num(0);
		}
		map.put("cclist", cclist);
		map.put("room_name", mdto.getName());
		ObjectMapper mapper = new ObjectMapper();
		try {
			json = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
	@RequestMapping(value="/chat_input")
	@ResponseBody
	public String chat_input(ChatContentDTO ccdto) {
		ccdao = sst.getMapper(ChatContentDAO.class);
		Map<String,Object> map = new HashMap<String,Object>();
		String json="";
		ArrayList<ChatContentDTO> cclist = ccdao.content_list(ccdto);
		map.put("cclist", cclist);
		ObjectMapper mapper = new ObjectMapper();
		try {
			json = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
	@RequestMapping(value="/chat_content_cr_num")
	@ResponseBody
	public String chat_content_cr_num(ChatContentDTO ccdto,HttpSession s) {
		ccdao = sst.getMapper(ChatContentDAO.class);
		cmdao = sst.getMapper(ChatMemberDAO.class);
		String room_name = "";
		int member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		ccdto.setMember_num(member_num);
		ccdto.setInequality_sign(">=");
		Map<String,Object> map = new HashMap<String,Object>();
		String json="";
		ArrayList<ChatContentDTO> cclist = ccdao.chat_content_cr_num(ccdto);
		ArrayList<ChatMemberDTO> cmlist = cmdao.find_chat_member(ccdto.getCr_num());
		for(ChatMemberDTO cmdto : cmlist) {
			if(cmdto.getMember_num()!=member_num) {
				room_name += cmdto.getName()+",";
			}
		}
		if(room_name.length()>20) {
			room_name = room_name.substring(0,19)+"...["+cmlist.size()+"]";
		}else {			
			room_name = room_name.substring(0,room_name.length()-1);
		}
		map.put("cclist",cclist);
		map.put("room_name", room_name);
		ObjectMapper mapper = new ObjectMapper();
		try {
			json = mapper.writeValueAsString(map);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
	
	@RequestMapping(value="/send_image_ok", produces="application/text; charset=utf-8")
	public void send_image_ok(HttpServletResponse resp, HttpSession s, @RequestParam(value="file") MultipartFile file,int cr_num) throws IllegalStateException, IOException {
		ccdao = sst.getMapper(ChatContentDAO.class);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmssSSS");
		Date date = new Date();
		String time = sdf.format(date);
		String file_name = time+file.getOriginalFilename();
		int member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		ChatContentDTO ccdto = new ChatContentDTO();
		ccdto.setCr_num(cr_num);
		ccdto.setMember_num(member_num);
		ccdto.setSender_num(member_num);
		ccdto.setCc_content("<img src=\"resources/image_upload/"+file_name+"\" class=\"image_name\" style=\"width:100px; height: 100px; border-radius:10px; cursor:pointer;\" param=\""+file_name+"\">");
		ccdto.setImage_check("o");
		ccdto.setAudio_check("x");
		ccdto.setFile_check("x");
		String path = "C:\\Users\\user\\git\\chatting\\chat\\src\\main\\webapp\\resources\\image_upload\\";
		File f = new File(path+file_name);
		file.transferTo(f);
		ccdao.cr_add_content(ccdto);
		System.err.println(ccdto.getSender_num());
		resp.getWriter().print(1);
	}
	@RequestMapping(value="/send_audio_ok", produces="application/text; charset=utf-8")
	public void send_audio_ok(HttpServletResponse resp, HttpSession s, @RequestParam(value="audio_file") MultipartFile file,int cr_num) throws IllegalStateException, IOException {
		int member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		Date date = new Date();
		ccdao = sst.getMapper(ChatContentDAO.class);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmssSSS");
		String time = sdf.format(date);
		String file_name = time+file.getOriginalFilename();
		String path = "C:\\Users\\user\\git\\chatting\\chat\\src\\main\\webapp\\resources\\audio_upload\\";
		File f = new File(path+file_name);
		file.transferTo(f);
		ChatContentDTO ccdto = new ChatContentDTO();
		ccdto.setCr_num(cr_num);
		ccdto.setMember_num(member_num);
		ccdto.setSender_num(member_num);
		ccdto.setCc_content("<audio src=\"resources/audio_upload/"+file_name+"\" class=\"audio_name\" controls=\"controls\" style=\"width:80px;\" param=\""+file_name+"\"></audio>");
		ccdto.setImage_check("x");
		ccdto.setAudio_check("o");
		ccdto.setFile_check("x");
		ccdao.cr_add_content(ccdto);
		resp.getWriter().print(1);
		
	}
	@RequestMapping(value="/send_file_ok", produces="application/text; charset=utf-8")
	public void send_file_ok(HttpServletResponse resp, HttpSession s, @RequestParam(value="file2") MultipartFile file,int cr_num) throws IllegalStateException, IOException {
		int member_num = Integer.parseInt(s.getAttribute("member_num").toString());
		Date date = new Date();
		System.out.println("~~~~");
		ccdao = sst.getMapper(ChatContentDAO.class);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmssSSS");
		String time = sdf.format(date);
		String file_name = time+file.getOriginalFilename();
		String path = "C:\\Users\\user\\git\\chatting\\chat\\src\\main\\webapp\\resources\\file_upload\\";
		File f = new File(path+file_name);
		file.transferTo(f);
		ChatContentDTO ccdto = new ChatContentDTO();
		ccdto.setCr_num(cr_num);
		ccdto.setMember_num(member_num);
		ccdto.setSender_num(member_num);
		ccdto.setCc_content(file_name);
		ccdto.setImage_check("x");
		ccdto.setAudio_check("x");
		ccdto.setFile_check("o");
		ccdao.cr_add_content(ccdto);
		resp.getWriter().print(1);
	}
}
