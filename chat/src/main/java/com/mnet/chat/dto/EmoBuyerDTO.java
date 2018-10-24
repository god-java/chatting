package com.mnet.chat.dto;

public class EmoBuyerDTO extends ObjectDTO{

	private int member_num;
	private int emo_num;
	public int getMember_num() {
		return member_num;
	}
	public void setMember_num(int member_num) {
		this.member_num = member_num;
	}
	public int getEmo_num() {
		return emo_num;
	}
	public void setEmo_num(int emo_num) {
		this.emo_num = emo_num;
	}
}
