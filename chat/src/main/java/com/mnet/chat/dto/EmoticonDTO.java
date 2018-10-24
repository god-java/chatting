package com.mnet.chat.dto;

public class EmoticonDTO extends ObjectDTO{

	private int emo_num;
	private String emo_main_image;
	private String emo_name;
	public String getEmo_name() {
		return emo_name;
	}
	public void setEmo_name(String emo_name) {
		this.emo_name = emo_name;
	}
	public int getEmo_num() {
		return emo_num;
	}
	public void setEmo_num(int emo_num) {
		this.emo_num = emo_num;
	}
	public String getEmo_main_image() {
		return emo_main_image;
	}
	public void setEmo_main_image(String emo_main_image) {
		this.emo_main_image = emo_main_image;
	}
	
	
}
