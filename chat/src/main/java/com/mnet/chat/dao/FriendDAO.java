package com.mnet.chat.dao;

import com.mnet.chat.dto.FriendDTO;

public interface FriendDAO {

	public void add_friend(FriendDTO fdto);
	public int friend_check(FriendDTO fdto);
	public void delete_friend(FriendDTO fdto);
}
