package com.mnet.chat;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.mnet.chat.dao.ChatContentDAO;
import com.mnet.chat.dao.ChatMemberDAO;
import com.mnet.chat.dao.ChatRoomDAO;
import com.mnet.chat.dao.EmoBuyerDAO;
import com.mnet.chat.dao.EmoImageDAO;
import com.mnet.chat.dao.EmoticonDAO;
import com.mnet.chat.dao.FriendDAO;
import com.mnet.chat.dao.MemberDAO;

@Controller
public class ObjectController {
	@Autowired
	protected SqlSessionTemplate sst;
	protected MemberDAO mdao;
	protected ChatRoomDAO crdao;
	protected ChatMemberDAO cmdao;
	protected ChatContentDAO ccdao;
	protected FriendDAO fdao;
	protected EmoticonDAO edao;
	protected EmoImageDAO eidao;
	protected EmoBuyerDAO ebdao;
	
}
