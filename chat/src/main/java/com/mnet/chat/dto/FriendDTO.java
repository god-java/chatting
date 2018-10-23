package com.mnet.chat.dto;

public class FriendDTO extends ObjectDTO {

	private int friend_num;
	private int sender_num;
	private int receiver_num;
	private String friend_check;
	public String getFriend_check() {
		return friend_check;
	}
	public void setFriend_check(String friend_check) {
		this.friend_check = friend_check;
	}
	public int getFriend_num() {
		return friend_num;
	}
	public void setFriend_num(int friend_num) {
		this.friend_num = friend_num;
	}
	public int getSender_num() {
		return sender_num;
	}
	public void setSender_num(int sender_num) {
		this.sender_num = sender_num;
	}
	public int getReceiver_num() {
		return receiver_num;
	}
	public void setReceiver_num(int receiver_num) {
		this.receiver_num = receiver_num;
	}
}
