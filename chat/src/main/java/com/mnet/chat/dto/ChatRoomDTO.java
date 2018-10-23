package com.mnet.chat.dto;

public class ChatRoomDTO extends ObjectDTO {
	private int cr_num;
	private int cr_leader;
	private String cr_name;
	private String cr_made_date;
	private int sender_num;
	private int receiver_num;
	public int getCr_num() {
		return cr_num;
	}
	public void setCr_num(int cr_num) {
		this.cr_num = cr_num;
	}
	public int getCr_leader() {
		return cr_leader;
	}
	public void setCr_leader(int cr_leader) {
		this.cr_leader = cr_leader;
	}
	public String getCr_name() {
		return cr_name;
	}
	public void setCr_name(String cr_name) {
		this.cr_name = cr_name;
	}
	public String getCr_made_date() {
		return cr_made_date;
	}
	public void setCr_made_date(String cr_made_date) {
		this.cr_made_date = cr_made_date;
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
