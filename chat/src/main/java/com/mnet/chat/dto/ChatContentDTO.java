package com.mnet.chat.dto;

public class ChatContentDTO extends ObjectDTO {
	private int cc_num;
	private int sender_num;
	private String cc_content;
	private String send_date;
	private String image_check;
	public String getImage_check() {
		return image_check;
	}
	public void setImage_check(String image_check) {
		this.image_check = image_check;
	}
	public int getCc_num() {
		return cc_num;
	}
	public void setCc_num(int cc_num) {
		this.cc_num = cc_num;
	}
	public int getSender_num() {
		return sender_num;
	}
	public void setSender_num(int sender_num) {
		this.sender_num = sender_num;
	}
	public String getCc_content() {
		return cc_content;
	}
	public void setCc_content(String cc_content) {
		this.cc_content = cc_content;
	}
	public String getSend_date() {
		return send_date;
	}
	public void setSend_date(String send_date) {
		this.send_date = send_date;
	}
}
