package com.sock.handler;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.mnet.chat.dao.ChatContentDAO;
import com.mnet.chat.dao.ChatMemberDAO;
import com.mnet.chat.dao.ChatRoomDAO;
import com.mnet.chat.dto.ChatContentDTO;
import com.mnet.chat.dto.ChatRoomDTO;

public class WebSocketHandler extends TextWebSocketHandler {

	@Autowired
	private SqlSessionTemplate sst;
	private ChatRoomDAO crdao;
	private ChatMemberDAO cmdao;
	private ChatContentDAO ccdao;
	
	
	public void setMapper() {
		crdao = sst.getMapper(ChatRoomDAO.class);
		cmdao = sst.getMapper(ChatMemberDAO.class);
		ccdao = sst.getMapper(ChatContentDAO.class);
	}
	
	public void add_content(int member_num, String message) {
		ChatContentDTO ccdto = new ChatContentDTO();
		int cr_num = crdao.max_cr_num(member_num);
		ccdto.setCr_num(cr_num);
		ccdto.setSender_num(member_num);
		ccdto.setCc_content(message);
		ccdto.setImage_check("x");
		ccdto.setAudio_check("x");
		ccdto.setFile_check("x");
		ccdao.add_content(ccdto);
	}
	public void add_content2(int member_num, String message, ChatRoomDTO crdto) {
		ChatContentDTO ccdto = new ChatContentDTO();
		int cr_num = crdao.find_cr_num(crdto);
		ccdto.setCr_num(cr_num);
		ccdto.setSender_num(member_num);
		ccdto.setCc_content(message);
		ccdto.setImage_check("x");
		ccdto.setAudio_check("x");
		ccdto.setFile_check("x");
		ccdao.add_content(ccdto);
	}
	public void cr_add_content(int member_num, int cr_num,String type, String content) {
		ChatContentDTO ccdto = new ChatContentDTO();
		ccdto.setMember_num(member_num);
		ccdto.setCr_num(cr_num);
		ccdto.setCc_content(content);
		ccdto.setImage_check("x");
		ccdto.setAudio_check("x");
		ccdto.setFile_check("x");
		ccdao.cr_add_content(ccdto);
		crdao.update_date(cr_num);
		
	}
	public void add_member(int member_num, int receiver_num) {
		int[] array_member = new int[2];
		array_member[0]=member_num;
		array_member[1]=receiver_num;
		for(int i=0; i<array_member.length; i++) {
			System.err.println(array_member[0]);
			cmdao.add_member(array_member[0], array_member[i]);
		}
	}
	public ChatRoomDTO setDTO(int member_num,int receiver_num) {
		ChatRoomDTO crdto = new ChatRoomDTO();
		crdto.setCr_leader(member_num);
		crdto.setSender_num(member_num);
		crdto.setReceiver_num(receiver_num);
		return crdto;
	}
	Map<String,WebSocketSession> list = new HashMap<String,WebSocketSession>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.err.println("접속");
	}

	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		setMapper();
		String mess = (String) message.getPayload();
		String[] spl_message = mess.split("/");
		if(spl_message[0].equals("access")) {
			
			list.put(spl_message[1], session);
			
		}else if(spl_message[0].equals("chat")) {
			
			
			int member_num = Integer.parseInt(spl_message[2]);	//보낸사람(sender_num)
			int receiver_num = Integer.parseInt(spl_message[3]);
			ChatRoomDTO crdto = setDTO(member_num, receiver_num);	// dto맵핑 메소드
			int overlap_room = crdao.overlap_room(crdto);		// 방이 이미 있는지 확인
			if(overlap_room<1){
				crdao.make_room(crdto);
				add_member(member_num, receiver_num);		//멤버 추가 메소드
				add_content(member_num,spl_message[1]);		//채팅 내용 추가 메소드
			}else {
				add_content2(member_num, spl_message[1], crdto);
			}
			int cr_num = crdao.find_cr_num(crdto);
			System.err.println(list.get(spl_message[3])+"!!!");
			if(list.get(spl_message[3].toString())!=null){				//null일 경우 웹소켓 끊김 ... 꼭 toString() 해줘야함 키값은 String!!
				list.get(spl_message[3]).sendMessage(new TextMessage(spl_message[0]+"/"+spl_message[2]+"/"+spl_message[3]+"/"+cr_num));
			}
		}else if(spl_message[0].equals("cr_chat")) {
			int member_num = Integer.parseInt(spl_message[2]);	//보낸사람(sender_num)
			int cr_num= Integer.parseInt(spl_message[3]);		//방 번호
			String content = spl_message[1];
			if(member_num!=0 && !spl_message[4].equals("image_send")) {
				System.out.println(spl_message[4]);
				System.err.println("!@#!@#QWQAASD!@#!@#!");
				cr_add_content(member_num,cr_num,spl_message[0],content);
			}
			ArrayList<Integer> in_member_list = cmdao.find_member_num(cr_num);
			for(int i=0; i<in_member_list.size(); i++) {
				if(list.get(in_member_list.get(i).toString())!=null && member_num != in_member_list.get(i)){				//null일 경우 웹소켓 끊김 ...
					list.get(in_member_list.get(i).toString()).sendMessage(new TextMessage(spl_message[0]+"/"+spl_message[2]+"/"+spl_message[3]));
					System.out.println("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBDFBDFBF\n\n\n\nasdasd");
				}
				
			}
			System.out.println("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBDFBDFBF\n\n\n\nasdasd");
		}else if(spl_message[0].equals("logout")) {
			list.remove(spl_message[1].toString());
			System.err.println("AAAAAAAAAAAAAADDDDDDDDDDDDDDDDFFFFFFFFFFFFFFFFFF");
		}else if(spl_message[0].equals("exit_room")) {
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		list.values().removeAll(Collections.singleton(session));
		System.err.println(list.size());
	}
	

}
