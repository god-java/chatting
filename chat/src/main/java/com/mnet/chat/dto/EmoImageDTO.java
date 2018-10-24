package com.mnet.chat.dto;

public class EmoImageDTO extends ObjectDTO {

	private int emo_image_num;
	private int emo_num;
	private String emo_image;
	public int getEmo_image_num() {
		return emo_image_num;
	}
	public void setEmo_image_num(int emo_image_num) {
		this.emo_image_num = emo_image_num;
	}
	public int getEmo_num() {
		return emo_num;
	}
	public void setEmo_num(int emo_num) {
		this.emo_num = emo_num;
	}
	public String getEmo_image() {
		return emo_image;
	}
	public void setEmo_image(String emo_image) {
		this.emo_image = emo_image;
	}
}
