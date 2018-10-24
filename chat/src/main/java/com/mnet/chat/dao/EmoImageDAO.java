package com.mnet.chat.dao;

import java.util.ArrayList;

import com.mnet.chat.dto.EmoImageDTO;

public interface EmoImageDAO {

	public ArrayList<EmoImageDTO> emo_image_list(int emo_num);
}
