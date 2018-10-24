<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="resources/js/jquery-3.3.1.min..js"></script>
<script src="//apps.bdimg.com/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
<style type="text/css">
html,body,div,ul,li,a,span{margin:0; padding:0; outline:0; font-size:12px; text-align:center;}
li{list-style:none;}
a{text-decoration:none;}
#header{width:100%; height:50px; background-color:rgba(0,0,0,0.5);}
#header ul{width:100%; height:50px; font-size:0px; display:flex;}
#header li{width:10%; height:30px; margin-top:15px;}

#right_list{width:300px; height:100%; position:fixed; right:0; top:0; border-left:1px solid gray;}
#member_list{width:100%; height:50px; border-bottom:1px solid #D8D8D8; line-height:50px;}
#center{width:100%;}

#chat_box{width:400px; height:500px; border:1px solid black; position:fixed; left:30%; top:20%; display:none; z-index:9999; background:white;}
#chat_center_box{width:90%; height:80%; position:absolute; top:10%; left:5%;}
#chat_content_box{width:100%; height:320px; border:1px solid black; overflow-y:scroll; background-color:#B2CCFF;}
#chat_input_box{width:100%; height:110px; display:flex; margin-top:10px;} 
#chat_send_box{width:80%; height:100%;}
#chat_btn_box{width:20%; height:100%;}
#chat_content{width:100%; height:95%;}
#send_btn{width:100%; height:100%; border:1px solid black; color:white; background-color:black; cursor:pointer;}

#main_body{width:450px; height:600px; border:1px solid black; position:fixed; top:10%; right:20%; background-color:white;}
.menu_btn:hover{background:#EAEAEA;}
.freind_list:hover{background:#EAEAEA;}

::-webkit-scrollbar{width:12px; height:12px}
/* ::-webkit-scrollbar-button:start:decrement, 
::-webkit-scrollbar-button:end:increment{width:12px; height:12px; display:block; border-radius:100%; background:rgba(0,0,0,0.3)} */
::-webkit-scrollbar-track{background:rgba(0,0,0,0.3); border-radius:10px;}
::-webkit-scrollbar-thumb{background:rgba(0,0,0,0.5); border-radius:10px;}

</style>
</head>
<script type="text/javascript">
$(document).ready(function(){
	$("#main_body").draggable({scroll:true})
	$("#chat_box").draggable({scroll:true})
	$("#find_friend_body").draggable({scroll:true})
	$("#view_image_body").draggable({scroll:true})
	
	var sock = new WebSocket("ws://192.168.0.29:8282/chat/echo-ws")
	var member_num = "${member_num}"
	var receiver_num = 0
	var start_row = 0
	var end_row = 10
	var scroll_swit = 0
	var chat_window = 0
	var cr_num = 0
	var enter_type = ""	
	var room_swit = "off"
	var message_count = 100
	var remove_count = 100
	var z_index = 10
	var audio = new Audio('resources/sounds/카톡.mp3')
	var shift_key = 0
	var enter_key = 0
	var group_member = ""
	sock.onclose = function(){
		sock.send("close/"+member_num)
	}
	$("#chat_box").click(function(){
		z_index++
		$("#chat_box").css({'z-index':z_index})
	})
	$("#main_body").click(function(){
		z_index++
		$("#main_body").css({'z-index':z_index})
	})
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	function update_chat_content(){
		$.ajax({
			url : 'chat_content_cr_num',
			dataType : 'json',
			type : 'get',
			data : {
					'start_row': '0',
					'end_row' : '10',
					'cr_num' : cr_num
					},
			success : function(data){
				var cclist = data.cclist
				var room_name = data.room_name
				var chat_content_html = "";
				$("#chat_content_box").html("")
				$("#room_name").html(room_name)
				$.each(cclist,function(i){
					chat_content_html ="";
					if(cclist[i].sender_num==0){
						chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
						chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
						chat_content_html += "</div>";
					}else if(cclist[i].sender_num!=member_num){
						chat_content_html +="<div style='width:60%; display:flex;'>";
						chat_content_html +=	"<div style='width:30%; height:50px;'>";
						chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
						chat_content_html +=	"</div>";
						chat_content_html +=	"<div style='width:70%; position:relative;'>";
						if(cclist[i].image_check!='o'){
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:white; border:1px solid white; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";							
						}
						chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
						chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
						chat_content_html +=		"</div>";
						chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
						chat_content_html +=			""+cclist[i].name+"";
						chat_content_html +=		"</div>";
						if(cclist[i].image_check=='o'){
							chat_content_html +=		"<div style='border-radius:5px;'>";
						}else{
							chat_content_html +=		"<div style='background:white; border-radius:5px;'>";							
						}
						chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
						chat_content_html +=				""+cclist[i].cc_content+"";
						chat_content_html +=			"</span>";
						chat_content_html +=		"</div>";
						chat_content_html +=	"</div>";
						chat_content_html +="</div>";
					}else{   
						chat_content_html +="<div style='width:60%; display:flex; float:right;'>";
						chat_content_html +=	"<div style='width:30%; height:50px;'>";
						chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
						chat_content_html +=	"</div>";
						chat_content_html +=	"<div style='width:70%; position:relative;'>";
						if(cclist[i].image_check!='o'){
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
						}
						chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
						chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
						chat_content_html +=		"</div>";
						chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
						chat_content_html +=			"나";
						chat_content_html +=		"</div>";
						if(cclist[i].image_check=='o'){
							chat_content_html +=		"<div style='border-radius:5px;'>";							
						}else{
							chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
						}
						chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
						chat_content_html +=				""+cclist[i].cc_content+"";
						chat_content_html +=			"</span>";
						chat_content_html +=		"</div>";
						chat_content_html +=	"</div>";
						chat_content_html +="</div>";
					}
					
					$("#chat_content_box").append(chat_content_html)
					
				})
				var height = $("#chat_content_box")[0].scrollHeight
				$("#chat_content_box").animate({scrollTop : height},0)
			}
		})
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	function new_message(cclist){
		var news_html = "";
		news_html += "<div id='new_message"+message_count+"' class='new_message' param='"+cclist[cclist.length-1].cr_num+"' style='width:250px; height:110px; border:1px solid black; position:fixed; bottom:-130px; right:0; background:white; -webkit-transition-duration:0.5s; z-index:"+message_count+";'>";
		news_html += "<div style='width:100%; height:30px; line-height:30px; position:relative;'>";
		news_html += "<span style='font-weight:bold;'>새 메세지가 왔습니다.</span>";
		news_html += "<div class='new_remove' style='position:absolute; width:30px; height:30px; right:0; line-height:30px; top:0; cursor:pointer'>";
		news_html += "X";
		news_html += "</div>";
		news_html += "</div>";
		news_html += "<div style='width:100%; height:70px;'>";
		news_html += "<div style='width:90%; height:90%; position:relative; top:5%; left:5%; display:flex;'>";
		news_html += "<div style='width:30%; height:100%;'>";
		news_html += "<img src='resources/profile_image/"+cclist[cclist.length-1].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
		news_html += "</div>";
		news_html += "<div style='width:70%; height:100%;'>";
		news_html += "<div style='width:100%; height:30%; text-align:left;'>";
		news_html += "<span style='font-weight:bold;'>"+cclist[cclist.length-1].name+"</span>";
		news_html += "</div>";
		news_html += "<div style='width:100%; height:70%; text-align:left;'>";
		news_html += "<span style='color:silver;'>"+cclist[cclist.length-1].cc_content+"</span>";
		news_html += "</div>";
		news_html += "</div>";
		news_html += "</div>";
		news_html += "</div>";
		news_html += "</div>";
		audio.play()
		$("html").append(news_html)
		$("#new_message"+message_count).animate({'bottom':'0px'})
		message_count++
		setTimeout(function(){
			$("#new_message"+remove_count).remove()
			remove_count++
		},5000)
	}
	$(document).on('click','.new_remove',function(){
		$(this).parent().parent().remove()
		return false
	})
	$(document).on('click','.new_message',function(){
		room_swit = "on"
		cr_num = $(this).attr("param")
		enter_type = "cr_enter"
		start_row=0
		end_row=10
		$.ajax({
			url : 'chat_content_cr_num',
			dataType : 'json',
			type : 'get',
			data : {
					'start_row': '0',
					'end_row' : '10',
					'cr_num' : cr_num
					},
			success : function(data){
				var cclist = data.cclist
				var room_name = data.room_name
				var chat_content_html = "";
				$("#chat_content_box").html("")
				$("#room_name").html(room_name)
				$.each(cclist,function(i){
					chat_content_html ="";
					if(cclist[i].sender_num==0){
						chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
						chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
						chat_content_html += "</div>";
					}else if(cclist[i].sender_num!=member_num){
						chat_content_html +="<div style='width:60%; display:flex;'>";
						chat_content_html +=	"<div style='width:30%; height:50px;'>";
						chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
						chat_content_html +=	"</div>";
						chat_content_html +=	"<div style='width:70%; position:relative;'>";
						if(cclist[i].image_check!='o'){
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:white; border:1px solid white; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";							
						}
						chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
						chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
						chat_content_html +=		"</div>";
						chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
						chat_content_html +=			""+cclist[i].name+"";
						chat_content_html +=		"</div>";
						if(cclist[i].image_check=='o'){
							chat_content_html +=		"<div style='border-radius:5px;'>";
						}else{
							chat_content_html +=		"<div style='background:white; border-radius:5px;'>";							
						}
						chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
						chat_content_html +=				""+cclist[i].cc_content+"";
						chat_content_html +=			"</span>";
						chat_content_html +=		"</div>";
						chat_content_html +=	"</div>";
						chat_content_html +="</div>";
					}else{   
						chat_content_html +="<div style='width:60%; display:flex; float:right;'>";
						chat_content_html +=	"<div style='width:30%; height:50px;'>";
						chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
						chat_content_html +=	"</div>";
						chat_content_html +=	"<div style='width:70%; position:relative;'>";
						if(cclist[i].image_check!='o'){
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
						}
						chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
						chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
						chat_content_html +=		"</div>";
						chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
						chat_content_html +=			"나";
						chat_content_html +=		"</div>";
						if(cclist[i].image_check=='o'){
							chat_content_html +=		"<div style='border-radius:5px;'>";							
						}else{
							chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
						}
						chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
						chat_content_html +=				""+cclist[i].cc_content+"";
						chat_content_html +=			"</span>";
						chat_content_html +=		"</div>";
						chat_content_html +=	"</div>";
						chat_content_html +="</div>";
					}
					
					$("#chat_content_box").append(chat_content_html)
					
				})
				var height = $("#chat_content_box")[0].scrollHeight
				$("#chat_content_box").animate({scrollTop : height},0)
			}
		})
		z_index++
		$("#chat_box").css({'z-index':z_index})
		$("#chat_box").show()
		$(this).remove()
	})
	function push_list(member_num1, member_num2, receive_cr_num){		//receive_cr_num = 소켓 통해서 넘어온 cr_num
		start_row = 0
		end_row = 10
		receiver_num = member_num1
		$.ajax({
			url : 'chat_content_list',
			dataType : 'json',
			type : 'get',
			data : {'sender_num':member_num1,
					'receiver_num':member_num2,
					'start_row' : '0',
					'end_row' : '10'
					},
			success : function(data){
				var cclist = data.cclist
				var chat_content_html = "";
				if(receive_cr_num == cr_num){
					$("#chat_content_box").html("")
					$.each(cclist,function(i){
						chat_content_html ="";
						if(cclist[i].sender_num==0){
							chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
							chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
							chat_content_html += "</div>";
						}else if(cclist[i].sender_num!=member_num){
							chat_content_html +="<div style='width:60%; display:flex;'>";
							chat_content_html +=	"<div style='width:30%; height:50px;'>";
							chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
							chat_content_html +=	"</div>";
							chat_content_html +=	"<div style='width:70%; position:relative;'>";
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:white; border:1px solid white; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
							chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
							chat_content_html +=			""+cclist[i].name+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='background:white; border-radius:5px;'>";
							chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
							chat_content_html +=				""+cclist[i].cc_content+"";
							chat_content_html +=			"</span>";
							chat_content_html +=		"</div>";
							chat_content_html +=	"</div>";
							chat_content_html +="</div>";
						}else{   
							chat_content_html +="<div style='width:60%; display:flex; float:right;'>";
							chat_content_html +=	"<div style='width:30%; height:50px;'>";
							chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
							chat_content_html +=	"</div>";
							chat_content_html +=	"<div style='width:70%; position:relative;'>";
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
							chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
							chat_content_html +=			"나";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
							chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
							chat_content_html +=				""+cclist[i].cc_content+"";
							chat_content_html +=			"</span>";
							chat_content_html +=		"</div>";
							chat_content_html +=	"</div>";
							chat_content_html +="</div>";
						}
						
						$("#chat_content_box").append(chat_content_html)
						
					})
					var height = $("#chat_content_box")[0].scrollHeight
					$("#chat_content_box").animate({scrollTop : height},0)
					$("#chat_box").show()
				}else{
					new_message(cclist)
				}
			}
		})
	}
	function crlist_content(){
		$.ajax({
			url : 'room_list',
			type : 'get',
			dataType : 'json',
			data : {'member_num':member_num},
			success : function(data){
				var crlist = data
				var search_hrml = "<div style='width:100%; height:40px; border-bottom:1px solid black; position:relative;'>";
				var search_hrml = 	"<input type='text' style='width:95%; height:75%; position:absolute; top:6%; left:2%; border:none; outline:none;' placeholder='채팅방 검색...'>";
				var search_hrml = "</div>";
				var crlsit_html = "";
				$("#center_info").html("")
				$.each(crlist,function(i){
					crlist_html="";
					crlist_html += "<div class='crlist_body' id='crlist_body"+crlist[i].cr_num+"' param='"+crlist[i].cr_num+"' style='width:100%; height:70px; display:flex; border-bottom:1px solid #D8D8D8;'>";
					crlist_html += 	"<div style='width:20%; height:70px; line-height:70px;'>";
					crlist_html += 		"<img src='resources/profile_image/"+crlist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%; position:relative; top:15px;''>";
					crlist_html += 	"</div>";
					crlist_html += 	"<div style='width:80%; height:70px; text-align:left;'>";
					crlist_html += 		"<div style='width:100%; height:35px; text-align:left; line-height:40px;'>";
					crlist_html += 			"<span style='font-weight:bold;'>"+crlist[i].cr_name+"</span>";
					crlist_html +=			"<span style='float:right; margin-right:10px;'>"+crlist[i].send_date+"</span>"
					crlist_html += 		"</div>";
					crlist_html += 		"<div style='width:100%; height:35px; text-align:left;'>";
					if(crlist[i].image_check=="o"){
						crlist_html += 			"<span style='color:silver; font-weight:bold;'>사진</span>";
					}else if(crlist[i].audio_check=="o"){
						crlist_html += 			"<span style='color:silver; font-weight:bold;'>음성파일</span>";
					}else{
						crlist_html += 			"<span style='color:silver;'>"+crlist[i].cc_content+"</span>";
					}
					crlist_html += 		"</div>";
					crlist_html += 	"</div>";
					crlist_html += "</div>";
					$("#center_info").append(crlist_html)
				})
			}
		})
	}
	
	if(member_num!=null){
		sock.onopen = function(){
			sock.send("access/"+member_num)
		}
		sock.onmessage = function(message){
			/* spl_message[2] 넘어오는 cr_num임!!!! */
			var data = message.data
			var spl_message = data.split("/")
			chat_window = 1
			scroll_swit = 0
			if(spl_message[0]=="chat"){
				push_list(spl_message[1],spl_message[2],spl_message[3])		//3번방 cr_num
				crlist_content()
			}else if(spl_message[0]=="cr_chat"){
					enter_type = "cr_enter"
					$.ajax({
						url : 'chat_content_cr_num',
						dataType : 'json',
						type : 'get',
						data : {
								'start_row': '0',
								'end_row' : '10',
								'cr_num' : spl_message[2]
								},
						success : function(data){
							var cclist = data.cclist
							if(room_swit == "on" && spl_message[2] == cr_num){		//채팅방이 켜져있고 지금 켜져있는 채팅방에 내용이 추가될 경우
								var chat_content_html = "";
								$("#chat_content_box").html("")
								$.each(cclist,function(i){
									chat_content_html ="";
									if(cclist[i].sender_num==0){
										chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
										chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
										chat_content_html += "</div>";
									}else if(cclist[i].sender_num!=member_num){
										chat_content_html +="<div style='width:60%; display:flex;'>";
										chat_content_html +=	"<div style='width:30%; height:50px;'>";
										chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
										chat_content_html +=	"</div>";
										chat_content_html +=	"<div style='width:70%; position:relative;'>";
										if(cclist[i].image_check!='o'){
											chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:white; border:1px solid white; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
											chat_content_html +=		"</div>";							
										}
										chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
										chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
										chat_content_html +=		"</div>";
										chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
										chat_content_html +=			""+cclist[i].name+"";
										chat_content_html +=		"</div>";
										if(cclist[i].image_check=='o'){
											chat_content_html +=		"<div style='border-radius:5px;'>";
										}else{
											chat_content_html +=		"<div style='background:white; border-radius:5px;'>";							
										}
										chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
										chat_content_html +=				""+cclist[i].cc_content+"";
										chat_content_html +=			"</span>";
										chat_content_html +=		"</div>";
										chat_content_html +=	"</div>";
										chat_content_html +="</div>";
									}else{   
										chat_content_html +="<div style='width:60%; display:flex; float:right;'>";
										chat_content_html +=	"<div style='width:30%; height:50px;'>";
										chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
										chat_content_html +=	"</div>";
										chat_content_html +=	"<div style='width:70%; position:relative;'>";
										if(cclist[i].image_check!='o'){
											chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
											chat_content_html +=		"</div>";
										}
										chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
										chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
										chat_content_html +=		"</div>";
										chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
										chat_content_html +=			"나";
										chat_content_html +=		"</div>";
										if(cclist[i].image_check=='o'){
											chat_content_html +=		"<div style='border-radius:5px;'>";							
										}else{
											chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
										}
										chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
										chat_content_html +=				""+cclist[i].cc_content+"";
										chat_content_html +=			"</span>";
										chat_content_html +=		"</div>";
										chat_content_html +=	"</div>";
										chat_content_html +="</div>";
									}
									
									
									$("#chat_content_box").append(chat_content_html)
									
								})
								var height = $("#chat_content_box")[0].scrollHeight
								$("#chat_content_box").animate({scrollTop : height},0)
								$("#chat_box").show()
								/* audio.play() */
								crlist_content()
							}else if(room_swit != "on" && spl_message[2] != cr_num && spl_message[1]!=0){
								
								new_message(cclist,message_count,remove_count)
							}
						}
					})
				crlist_content()
			}
				
		}
	}
	$(document).on('dblclick','#friend',function(){
		start_row = 0
		end_row = 10
		receiver_num = $(this).attr("param")
		$.ajax({
			url : 'chat_content_list',
			dataType : 'json',
			type : 'get',
			data : {'sender_num':member_num,
					'receiver_num':receiver_num,
					'start_row' : start_row,
					'end_row' : end_row
					},
			success : function(data){
				var cclist = data.cclist
				var room_name = data.room_name
				var chat_content_html = "";
				$("#chat_content_box").html("")
				$("#room_name").html(room_name)
				if(cclist[0].cr_num!=0){
					cr_num = cclist[0].cr_num
					$.each(cclist,function(i){
						chat_content_html ="";
						if(cclist[i].sender_num==0){
							chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
							chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
							chat_content_html += "</div>";
						}else if(cclist[i].sender_num!=member_num){
							chat_content_html +="<div style='width:60%; display:flex;'>";
							chat_content_html +=	"<div style='width:30%; height:50px;'>";
							chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
							chat_content_html +=	"</div>";
							chat_content_html +=	"<div style='width:70%; position:relative;'>";
							if(cclist[i].image_check!='o'){
								chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:white; border:1px solid white; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
								chat_content_html +=		"</div>";							
							}
							chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
							chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
							chat_content_html +=			""+cclist[i].name+"";
							chat_content_html +=		"</div>";
							if(cclist[i].image_check=='o'){
								chat_content_html +=		"<div style='border-radius:5px;'>";
							}else{
								chat_content_html +=		"<div style='background:white; border-radius:5px;'>";							
							}
							chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
							chat_content_html +=				""+cclist[i].cc_content+"";
							chat_content_html +=			"</span>";
							chat_content_html +=		"</div>";
							chat_content_html +=	"</div>";
							chat_content_html +="</div>";
						}else{   
							chat_content_html +="<div style='width:60%; display:flex; float:right;'>";
							chat_content_html +=	"<div style='width:30%; height:50px;'>";
							chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
							chat_content_html +=	"</div>";
							chat_content_html +=	"<div style='width:70%; position:relative;'>";
							if(cclist[i].image_check!='o'){
								chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
								chat_content_html +=		"</div>";
							}
							chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
							chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
							chat_content_html +=			"나";
							chat_content_html +=		"</div>";
							if(cclist[i].image_check=='o'){
								chat_content_html +=		"<div style='border-radius:5px;'>";							
							}else{
								chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
							}
							chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
							chat_content_html +=				""+cclist[i].cc_content+"";
							chat_content_html +=			"</span>";
							chat_content_html +=		"</div>";
							chat_content_html +=	"</div>";
							chat_content_html +="</div>";
						}
						
						$("#chat_content_box").append(chat_content_html)
						
					})
					var height = $("#chat_content_box")[0].scrollHeight
					$("#chat_content_box").animate({scrollTop : height},0)
				}
			}
		})
		z_index++
		$("#chat_box").css({'z-index':z_index})
		$("#chat_box").show()
	})
	$(document).on('keydown','#chat_content',function(e){
		if(e.keyCode=="16"){
			shift_key = 1
		}
		if(shift_key == 1 && e.keyCode=="13"){
			$("#chat_content").append("\n")
		}
	})
	$(document).on('keyup','#chat_content',function(e){
		if(e.keyCode=="16"){
			shift_key = 0
		}
		if(e.keyCode=="13" && shift_key == 0){	
			start_row = 0
			end_row = 10
			var url = ""
			var content = $($("#chat_content")).val()
			content = content.replace(/\n|\r\n/g,"<br>")
			$("#chat_content").val(content)
			if(enter_type=='cr_enter'){																//채팅방을 눌러서 들어갔을때
				url = 'chat_content_cr_num'
				sock.send("cr_chat/"+$("#chat_content").val()+"/"+member_num+"/"+cr_num+"/text")	// /text ㅡ> 글인지 이미지인지...
			}else{																					//친구를 직접 클릭해서 들어갔을때
				url = 'chat_content_list'
				sock.send("chat/"+$("#chat_content").val()+"/"+member_num+"/"+receiver_num)
			}
 			
			$("#chat_content").val("")
 			setTimeout(function(){
 				$.ajax({
 					url : url,
 					dataType : 'json',
 					type : 'get',
 					data : {'sender_num':member_num,
 							'receiver_num':receiver_num,
 							'start_row': start_row,
 							'end_row' : end_row,
 							'cr_num' : cr_num
 							},
 					success : function(data){
 						var cclist = data.cclist
 						var chat_content_html = "";
 						$("#chat_content_box").html("")
 						$.each(cclist,function(i){
 							chat_content_html ="";
 							if(cclist[i].sender_num==0){
 								chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
 								chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
 								chat_content_html += "</div>";
 							}else if(cclist[i].sender_num!=member_num){
 								chat_content_html +="<div style='width:60%; display:flex;'>";
 								chat_content_html +=	"<div style='width:30%; height:50px;'>";
 								chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
 								chat_content_html +=	"</div>";
 								chat_content_html +=	"<div style='width:70%; position:relative;'>";
 								if(cclist[i].image_check!='o'){
 									chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:white; border:1px solid white; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
 									chat_content_html +=		"</div>";							
 								}
 								chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
 								chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
 								chat_content_html +=		"</div>";
 								chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
 								chat_content_html +=			""+cclist[i].name+"";
 								chat_content_html +=		"</div>";
 								if(cclist[i].image_check=='o'){
 									chat_content_html +=		"<div style='border-radius:5px;'>";
 								}else{
 									chat_content_html +=		"<div style='background:white; border-radius:5px;'>";							
 								}
 								chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
 								chat_content_html +=				""+cclist[i].cc_content+"";
 								chat_content_html +=			"</span>";
 								chat_content_html +=		"</div>";
 								chat_content_html +=	"</div>";
 								chat_content_html +="</div>";
 							}else{   
 								chat_content_html +="<div style='width:60%; display:flex; float:right;'>";
 								chat_content_html +=	"<div style='width:30%; height:50px;'>";
 								chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
 								chat_content_html +=	"</div>";
 								chat_content_html +=	"<div style='width:70%; position:relative;'>";
 								if(cclist[i].image_check!='o'){
 									chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
 									chat_content_html +=		"</div>";
 								}
 								chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
 								chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
 								chat_content_html +=		"</div>";
 								chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
 								chat_content_html +=			"나";
 								chat_content_html +=		"</div>";
 								if(cclist[i].image_check=='o'){
 									chat_content_html +=		"<div style='border-radius:5px;'>";							
 								}else{
 									chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
 								}
 								chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
 								chat_content_html +=				""+cclist[i].cc_content+"";
 								chat_content_html +=			"</span>";
 								chat_content_html +=		"</div>";
 								chat_content_html +=	"</div>";
 								chat_content_html +="</div>";
 							}
 							
 							$("#chat_content_box").append(chat_content_html)
 							
 						})
 						var height = $("#chat_content_box")[0].scrollHeight
 						$("#chat_content_box").animate({scrollTop : height},0)
 					}
 				})
			},400)  
			setTimeout(function(){
				crlist_content()
			},400)
			
		}
	})
	$("#chat_content_box").scroll(function(){
		var box_top = $(this).scrollTop()
		var url = ""
		if(enter_type=='cr_enter'){
			url = 'chat_content_cr_num'
		}else{
			url = 'chat_content_list'
		}
		if(box_top==0){
			if(scroll_swit==0){
				start_row += 11
			}else{
				start_row += 10
			}
			end_row += 10
			scroll_swit = 1
			
			$.ajax({
				url : url,
				dataType : 'json',
				type : 'get',
				data : {'sender_num':member_num,
						'receiver_num':receiver_num,
						'start_row' : start_row,
						'end_row' : end_row,
						'cr_num' : cr_num
						},
				success : function(data){
					var cclist = data.cclist
					var chat_content_html = "";
					$.each(cclist,function(i){
						if(cclist[i].sender_num==0){
							chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
							chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
							chat_content_html += "</div>";
						}else if(cclist[i].sender_num!=member_num){
							chat_content_html +="<div style='width:60%; display:flex;'>";
							chat_content_html +=	"<div style='width:30%; height:50px;'>";
							chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
							chat_content_html +=	"</div>";
							chat_content_html +=	"<div style='width:70%; position:relative;'>";
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:white; border:1px solid white; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
							chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
							chat_content_html +=			""+cclist[i].name+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='background:white; border-radius:5px;'>";
							chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
							chat_content_html +=				""+cclist[i].cc_content+"";
							chat_content_html +=			"</span>";
							chat_content_html +=		"</div>";
							chat_content_html +=	"</div>";
							chat_content_html +="</div>";
						}else{   
							chat_content_html +="<div style='width:60%; display:flex; float:right;'>";
							chat_content_html +=	"<div style='width:30%; height:50px;'>";
							chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
							chat_content_html +=	"</div>";
							chat_content_html +=	"<div style='width:70%; position:relative;'>";
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
							chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
							chat_content_html +=			"나";
							chat_content_html +=		"</div>";
							chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
							chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
							chat_content_html +=				""+cclist[i].cc_content+"";
							chat_content_html +=			"</span>";
							chat_content_html +=		"</div>";
							chat_content_html +=	"</div>";
							chat_content_html +="</div>";
						}
					})
					$("#chat_content_box").prepend(chat_content_html)
					var height = 1
					
					$("#chat_content_box").animate({scrollTop : height+"px"},0)
				}
			})
		}
	})
	$(document).on('click','#chat_room_btn',function(){
		crlist_content()
		$("#search_input").attr("placeholder","채팅방 이름 검색...")
	})
	$(document).on('mouseover','.crlist_body',function(){
		var param = $(this).attr("param")
		$("#crlist_body"+param).css({'background':'#EAEAEA'})
		
	})
	$(document).on('mouseout','.crlist_body',function(){
		var param = $(this).attr("param")
		$("#crlist_body"+param).css({'background':'white'})
	})
	$(document).on('dblclick','.crlist_body',function(){
		room_swit = "on"
		cr_num = $(this).attr("param")
		enter_type = "cr_enter"
		start_row=0
		end_row=10
		$("#exit_room").attr("param",cr_num)
		$.ajax({
			url : 'chat_content_cr_num',
			dataType : 'json',
			type : 'get',
			data : {
					'start_row': '0',
					'end_row' : '10',
					'cr_num' : cr_num
					},
			success : function(data){
				var cclist = data.cclist
				var room_name = data.room_name
				var chat_content_html = "";
				$("#chat_content_box").html("")
				$("#room_name").html(room_name)
				$.each(cclist,function(i){
					chat_content_html ="";
					if(cclist[i].sender_num==0){
						chat_content_html += "<div style='width:100%; height:20px; line-height:20px; display:flex; background:rgba(0,0,0,0.5); color:white; text-align:center; border-radius:10px;'>";
						chat_content_html += 	"<span style='margin:0 auto;'>"+cclist[i].cc_content+"</span>";
						chat_content_html += "</div>";
					}else if(cclist[i].sender_num!=member_num){
						chat_content_html +="<div style='width:60%; display:flex;'>";
						chat_content_html +=	"<div style='width:30%; height:50px;'>";
						chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
						chat_content_html +=	"</div>";
						chat_content_html +=	"<div style='width:70%; position:relative;'>";
						if(cclist[i].image_check!='o' && cclist[i].audio_check != 'o'){
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
						}
						chat_content_html +=		"<div style='position:absolute; bottom:10px; right:-65px; font-size:11px;'>";
						chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
						chat_content_html +=		"</div>";
						chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
						chat_content_html +=			""+cclist[i].name+"";
						chat_content_html +=		"</div>";
						if(cclist[i].image_check=='o' || cclist[i].audio_check == 'o'){
							chat_content_html +=		"<div style='border-radius:5px;'>";							
						}else{
							chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
						}
						chat_content_html +=			"<span style='color:black;; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
						chat_content_html +=				""+cclist[i].cc_content+"";
						chat_content_html +=			"</span>";
						chat_content_html +=		"</div>";
						chat_content_html +=	"</div>";
						chat_content_html +="</div>";
					}else{   
						chat_content_html +="<div style='width:60%; display:flex; float:right; '>";
						chat_content_html +=	"<div style='width:30%; height:50px;'>";
						chat_content_html +=		"<img src='resources/profile_image/"+cclist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%;'>";
						chat_content_html +=	"</div>";
						chat_content_html +=	"<div style='width:70%; position:relative;'>";
						if(cclist[i].image_check!='o' && cclist[i].audio_check != 'o'){
							chat_content_html +=		"<div style='position:absolute; width:7px; height:7px; background:#FFF612; border:1px solid #FFF612; -webkit-transform:rotate(45deg); top:23px; left:-3px;'>";
							chat_content_html +=		"</div>";
						}else{
							
						}
						chat_content_html +=		"<div style='position:absolute; bottom:10px; left:-110px; font-size:11px;'>";
						chat_content_html +=			""+cclist[i].send_date.substring(10,19)+"";
						chat_content_html +=		"</div>";
						chat_content_html +=		"<div style='width:100%; height:20px; text-align:left; font-weight:bold;'>";
						chat_content_html +=			"나";
						chat_content_html +=		"</div>";
						if(cclist[i].image_check=='o' || cclist[i].audio_check == 'o'){
							chat_content_html +=		"<div style='border-radius:5px;'>";							
						}else{
							chat_content_html +=		"<div style='background:#FFF612; border-radius:5px;'>";
						}
						chat_content_html +=			"<span style='color:black; display:block; width:80%; height:80%; text-align:left; position:relative; left:10%; top:10%;'>";
						if(cclist[i].file_check=='o'){
							chat_content_html += "파일 : 누르면 다운로드 <a href='resources/file_upload/"+cclist[i].cc_content+"' download style='color:blue'>"+cclist[i].cc_content+"</a>"
						}else{
						chat_content_html +=				""+cclist[i].cc_content+"";									
						}
						chat_content_html +=			"</span>";
						chat_content_html +=		"</div>";
						chat_content_html +=	"</div>";
						chat_content_html +="</div>";
					}
					
					$("#chat_content_box").append(chat_content_html)
					
				})
				var height = $("#chat_content_box")[0].scrollHeight
				$("#chat_content_box").animate({scrollTop : height},0)
			}
		})
		z_index++
		$("#chat_box").css({'z-index':z_index})
		$("#chat_box").show()
	})
	
	$(document).on('click','#friend_list_btn',function(){
		$.ajax({
			url : 'friend_list',
			type : 'get',
			dataType: 'json',
			data : {},
			success : function(data){
				var mlist = data.mlist
				var mlist_html = "";
				$("#center_info").html("")
				$.each(mlist, function(i){
					mlist_html = "<div class='freind_list' style='width:100%; height:70px; display:flex; border-bottom:1px solid #D8D8D8;'>";
					mlist_html += 	"<div style='width:20%; height:70px; line-height:70px;'>";
					mlist_html += 		"<img src='resources/profile_image/"+mlist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%; position:relative; top:15px;'>";
					mlist_html += 	"</div>";
					mlist_html += 	"<div id='friend' param='"+mlist[i].member_num+"' style='width:80%; height:70px; text-align:left; line-height:70px;'>";
					mlist_html += 		"<span style='font-weight:bolder;'>"+mlist[i].name+"</span>";
					mlist_html += 	"</div>";
					mlist_html += "</div>";
					$("#center_info").append(mlist_html)
				})
			
				
			}
		})
	})
	$(document).on('keyup','#search_friend',function(e){
		if(e.keyCode=='13'){
			$.ajax({
				url : 'find_member',
				type : 'get',
				dataType : 'json',
				data : {'search' : $("#search_friend").val()},
				success : function(data){
					$("#search_friend").val("")  
					var mlist = data
					$("#find_friend_list").html("")
					var list_html = "";
					$.each(mlist, function(i){
						list_html = "";
						list_html += "<div style='width:100%; height:50px; border-bottom:1px solid #D8D8D8; display:flex;'>";
						list_html += 	"<div style='width:20%; height:50px;'>";
						list_html += 		"<img src='resources/profile_image/"+mlist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%; margin-top:5px;'>";
						list_html += 	"</div>";
						list_html += 	"<div style='width:80%; height:50px; line-height:50px; text-align:left;'>";
						list_html += 		"<span style='font-weight:bold;'>"+mlist[i].name+"</span>";
						list_html += 		"<div id='add_friend_body"+mlist[i].member_num+"' style='width:100px; height:50px; line-height:50px; float:right;'>";
						if(mlist[i].friend_check == 'y'){
							list_html +=			"<button class='delete_friend_btn' id='delete_friend_btn"+mlist[i].member_num+"' param='"+mlist[i].member_num+"' style='margin-top:10px; width:80px; height:30px; background:#597812; cursor:pointer; border:1px solid #597812; color:white; font-weight:bold; border-radius:5px;'>친구</button>";
						}else if(mlist[i].friend_check == 'my'){
							list_html += 			"<div style='width:80px; height:80px;'>나</div>";
						}else{
							list_html += 			"<button class='add_friend_btn' id='add_friend_btn"+mlist[i].member_num+"' param='"+mlist[i].member_num+"' style='margin-top:10px; width:80px; height:30px; background:#783712; cursor:pointer; border:1px solid #783712; color:white; font-weight:bold; border-radius:5px;'>친구추가</button>";
						}
						
						
						list_html += 		"</div>";
						list_html += 	"</div>";
						list_html += "</div>";
						$("#find_friend_list").append(list_html)
					})
				} 
			})
		}
	})
	$(document).on('keyup','#search_friend_group',function(e){
		if(e.keyCode=='13'){
			$.ajax({
				url : 'find_member',
				type : 'get',
				dataType : 'json',
				data : {'search' : $("#search_friend_group").val()},
				success : function(data){
					$("#search_friend_group").val("")  
					var mlist = data
					$("#find_friend_list_group").html("")
					var list_html = "";
					$.each(mlist, function(i){
						list_html = "";
						list_html += "<div style='width:100%; height:50px; border-bottom:1px solid #D8D8D8; display:flex;'>";
						list_html += 	"<div style='width:20%; height:50px;'>";
						list_html += 		"<img src='resources/profile_image/"+mlist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%; margin-top:5px;'>";
						list_html += 	"</div>";
						list_html += 	"<div style='width:80%; height:50px; line-height:50px; text-align:left;'>";
						list_html += 		"<span style='font-weight:bold;'>"+mlist[i].name+"</span>";
						list_html += 		"<div id='add_friend_body"+mlist[i].member_num+"' style='width:100px; height:50px; line-height:50px; float:right;'>";
						if(mlist[i].member_num==member_num){
							list_html += 			"나";
						}else{
							list_html +=			"<button class='add_group' id='add_group"+mlist[i].member_num+"' param='"+mlist[i].member_num+"' name='"+mlist[i].name+"' style='margin-top:10px; width:80px; height:30px; background:#597812; cursor:pointer; border:1px solid #597812; color:white; font-weight:bold; border-radius:5px;'>추가</button>";
						}
						list_html += 		"</div>";
						list_html += 	"</div>";
						list_html += "</div>";
						$("#find_friend_list_group").append(list_html)
					})
				} 
			})
		}
	})
	$(document).on('keyup','#search_friend_add_group',function(e){
		if(e.keyCode=='13'){
			$.ajax({
				url : 'find_member',
				type : 'get',
				dataType : 'json',
				data : {'search' : $("#search_friend_add_group").val()},
				success : function(data){
					$("#search_friend_add_group").val("")  
					var mlist = data
					$("#find_friend_add_list_group").html("")
					var list_html = "";
					$.each(mlist, function(i){
						list_html = "";
						list_html += "<div style='width:100%; height:50px; border-bottom:1px solid #D8D8D8; display:flex;'>";
						list_html += 	"<div style='width:20%; height:50px;'>";
						list_html += 		"<img src='resources/profile_image/"+mlist[i].profile_image+"' style='width:40px; height:40px; border-radius:100%; margin-top:5px;'>";
						list_html += 	"</div>";
						list_html += 	"<div style='width:80%; height:50px; line-height:50px; text-align:left;'>";
						list_html += 		"<span style='font-weight:bold;'>"+mlist[i].name+"</span>";
						list_html += 		"<div id='add_friend_body"+mlist[i].member_num+"' style='width:100px; height:50px; line-height:50px; float:right;'>";
						if(mlist[i].member_num==member_num){
							list_html += 			"나";
						}else{
							list_html +=			"<button class='add_group2' id='add_group2"+mlist[i].member_num+"' param='"+mlist[i].member_num+"' name='"+mlist[i].name+"' style='margin-top:10px; width:80px; height:30px; background:#597812; cursor:pointer; border:1px solid #597812; color:white; font-weight:bold; border-radius:5px;'>추가</button>";
						}
						list_html += 		"</div>";
						list_html += 	"</div>";
						list_html += "</div>";
						$("#find_friend_add_list_group").append(list_html)
					})
				} 
			})
		}
	})
	$(document).on('click','.add_group',function(){
		var param = $(this).attr("param")
		var name = $(this).attr("name")
		var add_group_html = "";
		add_group_html += "<div style='width:80px; height:30px; line-height:30px; border:1px solid #662500; border-radius:5px; display:inline-block; position:relative; background:#662500; font-weight:bolder; color:white; margin:2px 2px;'>";
		add_group_html += 	"<div id='group_delete"+param+"' class='group_delete' param='"+param+"' style='width:10px; height:10px; line-height:9px; position:absolute; top:10px; right:2px; cursor:pointer; font-weight:bolder; background:#662500;'>";
		add_group_html += 		"<span style='font-weight:bolder; color:white;'>X</span>";
		add_group_html += 	"</div>";
		add_group_html += 	name;
		add_group_html += "</div>";
		add_group_html += "<input type='hidden' id='group_input"+param+"' class='group_input' value='"+param+"'>";
		add_group_html += "";
		add_group_html += "";
		add_group_html += "";
		if($("#group_input"+param).val()!=null){
			alert("이미 추가 되었습니다.")
			return false
		}
		$("#add_group_list").append(add_group_html)
	})
	$(document).on('click','.add_group2',function(){
		var param = $(this).attr("param")
		var name = $(this).attr("name")
		
		for(var i=0; i<group_member.length; i++){
			if(group_member[i].member_num == param){
				alert("이미 채팅방에 참여한 회원입니다.")
				return false
			}
		}
		
		var add_group_html = "";
		add_group_html += "<div style='width:80px; height:30px; line-height:30px; border:1px solid #662500; border-radius:5px; display:inline-block; position:relative; background:#662500; font-weight:bolder; color:white; margin:2px 2px;'>";
		add_group_html += 	"<div id='group_delete2"+param+"' class='group_delete2' param='"+param+"' style='width:10px; height:10px; line-height:9px; position:absolute; top:10px; right:2px; cursor:pointer; font-weight:bolder; background:#662500;'>";
		add_group_html += 		"<span style='font-weight:bolder; color:white;'>X</span>";
		add_group_html += 	"</div>";
		add_group_html += 	name;
		add_group_html += "</div>";
		add_group_html += "<input type='hidden' id='group_input2"+param+"' class='group_input2' value='"+param+"'>";
		add_group_html += "";
		add_group_html += "";
		add_group_html += "";
		if($("#group_input2"+param).val()!=null){
			alert("이미 추가 되었습니다.")
			return false
		}
		$("#add_group_list2").append(add_group_html)
	})
	$(document).on('click','.group_delete',function(){
		var param = $(this).attr("param")
		$("#group_input"+param).remove()
		$(this).parent().remove()
	})
	$(document).on('click','.group_delete2',function(){
		var param = $(this).attr("param")
		$("#group_input2"+param).remove()
		$(this).parent().remove()
	})
	$(document).on('click','#make_group_ok',function(){
		var add_num = "";
		var group_input = document.getElementsByClassName("group_input")
		for(var i=0; i<group_input.length; i++){
			add_num += group_input[i].value+"/"
		}
		$.ajax({
			url : 'make_group_ok',
			type : 'post',
			data : {'add_num' : add_num},
			success : function(data){
				
			}
		})
	})
	$(document).on('click','#add_group_ok',function(){
		var add_num = "";
		var group_input = document.getElementsByClassName("group_input2")
		for(var i=0; i<group_input.length; i++){
			add_num += group_input[i].value+"/"
		}
		$.ajax({
			url : 'add_group_ok',
			type : 'post',
			data : {'add_num' : add_num,
					'cr_num' : cr_num},
			success : function(data){
				sock.send("cr_chat/"+$("#chat_content").val()+"/"+0+"/"+cr_num)
			}
		})
	})
	$(document).on('click','.add_friend_btn',function(){
		var param = $(this).attr("param")
		$.ajax({
			url : 'add_friend',
			type : 'get',
			data : {'sender_num' : member_num,
					'receiver_num' : param
					},
			success : function(data){
				var res = data
				if(res == 1){
					var new_html = "<button class='delete_friend_btn' id='delete_friend_btn"+param+"' param='"+param+"' style='margin-top:10px; width:80px; height:30px; background:#597812; cursor:pointer; border:1px solid #597812; color:white; font-weight:bold; border-radius:5px;'>친구</button>";
					
					$("#add_friend_body"+param).html(new_html)
				}
			}
		})
	})
	$(document).on('click','.delete_friend_btn',function(){
		var param = $(this).attr("param")
		$.ajax({
			url : 'delete_friend',
			type : 'get',
			data : {'sender_num' : member_num,
					'receiver_num' : param
					},
			success : function(data){
				var res = data
				if(res == 1){
					var new_html = "<button class='add_friend_btn' id='add_friend_btn"+param+"' param='"+param+"' style='margin-top:10px; width:80px; height:30px; background:#783712; cursor:pointer; border:1px solid #783712; color:white; font-weight:bold; border-radius:5px;'>친구추가</button>";
					
					$("#add_friend_body"+param).html(new_html)
				}
			}
		})
	})
	var menu_swit=0
	$(document).on('click','#menu_btn',function(){
		if(menu_swit == 0){
			$("#menu_list").show()	
			menu_swit = 1
		}else{
			$("#menu_list").hide()
			menu_swit = 0
		}
		
	})
	$(document).on('click','#menu_find_friend',function(){
		$("#find_friend_body").show()
		$("#menu_list").hide()
		menu_swit = 0
	})
	$(document).on('click','#close_find_freind',function(){
		$("#find_friend_body").hide()
		$("#find_friend_list").html("")
		$("#search_friend").val("")
	})
	$(document).on('click','#menu_logout',function(){
		sock.send("logout/"+member_num)
		location.href="logout"
	})
	$(document).on('click','#close_room',function(){
		start_row = 0;
		end_row = 10;
		$("#chat_content_box").html("<div style='height:550px;'></div>")
		$("#chat_content").val("")
		$("#room_name").html("")
		$("#chat_box").hide()
		room_swit = "off"
		cr_num = 0
		
	})
	$(document).on('click','#menu_make_group',function(){
		menu_swit = 0
		$("#menu_list").hide()
		$("#make_group_body").show()
	})
	$(document).on('click','#close_group',function(){
		$("#make_group_body").hide()
	})
	$(document).on('click','#menu_my_info',function(){
		$.ajax({
			url : 'member_info',
			type : 'post',
			dataType : 'json',
			data : {'member_num' : member_num},
			success : function(data){
				$("#menu_list").hide()
				menu_swit = 0
				var mdto = data.mdto
				$("#center_info").html("")
				var mdto_html = "";
				mdto_html += "<div style='width:100%; height:170px;'>";
				mdto_html += 	"<img src='resources/profile_image/"+mdto.profile_image+"' style='width:150px; height:150px; border-radius:100%;'>";
				mdto_html += "</div>";
				mdto_html += "<div style='width:100%; height:30px; position:relative;'>";
				mdto_html += 	"<input type='file' id='file' style='display:none;'>";
				mdto_html += 	"<label for='file' style='font-size:13px; cursor:pointer;'>프로필 사진 변경</label>";
				mdto_html += "</div>";
				mdto_html += "<div style='width:100%; height:30px;'>";
				mdto_html += 	"<span style='font-size:20px; font-weight:bolder;'>"+mdto.name+"</span>";
				mdto_html += "</div>";
				mdto_html += "<div style='width:100%; height:30px;'>";
				mdto_html += 	"<span style='font-size:15px; font-weight:bolder;'>"+mdto.id+"</span>";
				mdto_html += "</div>";
				$("#center_info").append(mdto_html)
			}
		})
	})
	$(document).on('click','#exit_room',function(){
		var param = $(this).attr("param")
		$.ajax({
			url : 'exit_room',
			type : 'get',
			data : {'member_num' : member_num,
					'cr_num' : param
					},
			success : function(data){
				var res = data
				if(res>0){
					sock.send("cr_chat/"+$("#chat_content").val()+"/"+0+"/"+cr_num)
					location.href="main"
				}
			}
		})
	})
	var chat_menu_swit=0
	$(document).on('click','#chat_menu',function(){
		if(chat_menu_swit==0){
			$("#chat_menu_list").show()
			chat_menu_swit=1		
		}else{
			$("#chat_menu_list").hide()
			chat_menu_swit=0	
		}
	})
	$(document).on('click','#add_member_group',function(){
		$("#group_add_body").show()
		$("#chat_menu_list").hide()
		chat_menu_swit=0
		$.ajax({
			url : 'group_member_list',
			dataType : 'json',
			type : 'get',
			data : {'cr_num' : cr_num},
			success : function(data){
				group_member = data.group_member
				alert(group_member)
			}
		})
	})
	$(document).on('click','#close_add_group',function(){
		$("#group_add_body").hide()
	})
	$(document).on('change','#file',function(){
		var url = URL.createObjectURL(event.target.files[0])
		$("#view_image").html("<img src='"+url+"' style='width:100%; height:100%;'>")
		z_index++;
		$("#image_send_body").css({'z-index':z_index})
		$("#chat_menu_list").hide()
		$("#image_send_body").show()
	})
	$(document).on('click','#image_send_btn',function(){
		var fd = new FormData($("form")[0])	
		fd.append("cr_num",cr_num)
		$.ajax({
			url : 'send_image_ok',
			processData : false,
			contentType : false,
			data : fd,
			type : 'post',
			success : function(data){
				var res = data
				$("#image_send_body").hide()
				$("html").append("<div id='ss' style='width:100%; height:100%; position:absolute; top:0; left:0; background:black; z-index:9999; display:none;'><span style='position:absolute; top:40%; left:30%; font-size:100px; color:white;'>사진 업로드중...</span></div>")
				$("#ss").fadeTo('slow','0.5')
				setTimeout(function(){
					sock.send("cr_chat/"+$("#chat_content").val()+"/"+member_num+"/"+cr_num+"/image_send")
					crlist_content()
					update_chat_content()
					$("#ss").remove()
				},4000)
				
			}
		})
		
	})
	$(document).on('click','#image_send_close',function(){
		$("#file").val("")
		$("#image_send_body").hide()
	})
	$(document).on('click','.image_name',function(){
		var param = $(this).attr("param")
		$("#view_close_up").html("<img src='resources/image_upload/"+param+"' style='width:100%; height:100%;'>")
		z_index++;
		$("#view_image_body").css({'z-index':z_index})
		$("#view_image_body").show()
	})
	$(document).on('click','#view_close_up_close',function(){
		$("#view_image_body").hide()
		$("#view_close_up").html("")
	})
	$(document).on('change','#audio_file',function(){
		var url = URL.createObjectURL(event.target.files[0])
		var file_name = $(this).val()
		var file_name_spl = file_name.split(".")
		alert(file_name_spl[file_name_spl.length-1])
		var extension = file_name_spl[file_name_spl.length-1]
		if(extension!="mp3" && extension!="wav" && extension!="wma"){
			alert("mp3 / wav / wma 파일만 업로드 가능합니다.")
			return false
		}else{
			$("#audio_view").html("<audio src='"+url+"' controls='controls'>")
			$("#audio_send_body").show()
			
		}
	})
	$(document).on('click','#audio_send_btn',function(){
		var fd = new FormData($("form")[1])
		fd.append("cr_num",cr_num)
		$.ajax({
			url : 'send_audio_ok',
			contentType : false,
			processData : false,
			data : fd,
			type : 'post',
			success : function(data){
				var res = data
				$("#image_send_body").hide()
				$("html").append("<div id='audio_upload_loading' style='width:100%; height:100%; position:absolute; top:0; left:0; background:black; z-index:9999; display:none;'><span style='position:absolute; top:40%; left:30%; font-size:100px; color:white;'>음성파일 업로드중...</span></div>")
				$("#audio_upload_loading").fadeTo('slow','0.5')
				setTimeout(function(){
					sock.send("cr_chat/"+$("#chat_content").val()+"/"+member_num+"/"+cr_num+"/image_send")
					crlist_content()
					update_chat_content() 
					$("#audio_upload_loading").remove()
				},4000)
			}
		})
	})
	$(document).on('click','#audio_send_close',function(){
		$("#audio_file").val("")
		$("#audio_send_body").hide()
	})
	$("#audio").draggable({scroll:true})
	$(document).on('change','#file2',function(){
		z_index++
		var file_name = $(this).val()
		var file_name_spl = file_name.split("\\")
		$("#file_view").html(file_name_spl[2])
		$("#file_send_body").css({'z-index':z_index})
		$("#file_send_body").show()
	})
	$(document).on('click','#file_send_btn',function(){
		var fd = new FormData($("form")[2])
		fd.append("cr_num",cr_num)
		$.ajax({
			url : 'send_file_ok',
			processData : false,
			contentType : false,
			data : fd,
			type : 'post',
			success : function(data){
				var res = data
				
			},
			error : function(error){
				alert(error.data)
			}
		})
	})
})
</script>
<body>
<a href="resources/image_upload/2017062212392915633-540x689.jpg" download>dd</a>
</audio>
<div id="view_image_body" style="width:800px; height:700px; position:fixed; top:5%; left:10%; border:1px solid black; display:none; background:white;">
	<div style="width:100%; height:30px; position:relative; background:#662500; line-height:30px;">
		<div id="view_close_up_close" style="width:30px; height:30px; position:absolute; top:0; right:0; font-weight:bolder; color:white; cursor:pointer;">
			X
		</div>
		<span style="font-weight:bolder; color:white;">이미지 상세보기</span>
	</div>
	<div id="view_close_up" style="width:90%; height:80%; position:relative; top:5%; left:5%;">
	
	</div>
</div>
<div id="image_send_body" style="width:500px; height:500px; border:1px solid black; top:20%; left:20%; position:fixed; display:none; background:white;">
	<div style="width:100%; height:30px; position:relative; background:#662500; line-height:30px;">
		<div id="image_send_close" style="width:30px; height:30px; position:absolute; top:0; right:0; font-weight:bolder; color:white; cursor:pointer;">
			X
		</div>
		<span style="font-weight:bolder; color:white;">이미지 보내기</span>
	</div>
	<div style="width:90%; height:80%; position:relative; top:5%; left:5%;">
		<div id="view_image" style="width:100%; height:400px; border:1px solid gray;">
		
		</div>
		<div id="send_body" style="width:100%; height:50px; line-height:50px;">
			<input type="button" id="image_send_btn" value="보내기" style="position:relative; width:100px; height:30px; top:5px; border:1px solid #662500; color:white; background:#662500; font-weight:bolder; border-radius:5px; cursor:pointer">
		</div>
	</div>
</div>
<div id="audio_send_body" style="width:350px; height:150px; border:1px solid black; top:20%; left:20%; position:fixed; display:none; background:white;">
	<div style="width:100%; height:30px; position:relative; background:#662500; line-height:30px;">
		<div id="audio_send_close" style="width:30px; height:30px; position:absolute; top:0; right:0; font-weight:bolder; color:white; cursor:pointer;">
			X
		</div>
		<span style="font-weight:bolder; color:white;">음성파일 보내기</span>
	</div>
	<div style="width:90%; height:80%; position:relative; top:5%; left:5%;">
		<div id="audio_view" style="width:100%; height:70px; border:1px solid gray;">
		
		</div>
		<div id="send_body" style="width:100%; height:50px; line-height:50px;">
			<input type="button" id="audio_send_btn" value="보내기" style="position:relative; width:100px; height:30px; top:5px; border:1px solid #662500; color:white; background:#662500; font-weight:bolder; border-radius:5px; cursor:pointer">
		</div>
	</div>
</div>
<div id="file_send_body" style="width:350px; height:150px; border:1px solid black; top:20%; left:20%; position:fixed; display:none; background:white;">
	<div style="width:100%; height:30px; position:relative; background:#662500; line-height:30px;">
		<div id="file_send_close" style="width:30px; height:30px; position:absolute; top:0; right:0; font-weight:bolder; color:white; cursor:pointer;">
			X
		</div>
		<span style="font-weight:bolder; color:white;">파일 보내기</span>
	</div>
	<div style="width:90%; height:80%; position:relative; top:5%; left:5%;">
		<div id="file_view" style="width:100%; height:70px; line-height:70px; font-weight:bolder; border:1px solid gray;">
		
		</div>
		<div id="file_body" style="width:100%; height:50px; line-height:50px;">
			<input type="button" id="file_send_btn" value="보내기" style="position:relative; width:100px; height:30px; top:5px; border:1px solid #662500; color:white; background:#662500; font-weight:bolder; border-radius:5px; cursor:pointer">
		</div>
	</div>
</div>
<div id="chat_box">
	<div id="group_add_body" style="position:absolute; width:70%; height:80%; top:15%; left:15%; border:1px solid black; background:white; z-index:11; display:none;">
		<div style="width:100%; height:40px; background:#662500; position:relative;">
			<span style="color:white; font-weight:bold; line-height:40px;">대화상대 초대</span>
			<div id="close_add_group" style="display:inline-block; position:absolute; width:40px; height:40px; right:0; line-height:40px; color:white; font-weight:bolder; cursor:pointer;">X</div>
		</div>
		<div style="width:100%; height:560px;">
			<div style="width:100%; height:50px; border-bottom:1px solid #D8D8D8;">
				<input type="text" id="search_friend_add_group" style="width:90%; height:75%; position:relative; top:5%; border:none; outline:none;" placeholder="이름 or 아이디 검색...">
			</div>
			<div id="find_friend_add_list_group" style="width:90%; height:100px; position:relative; top:5%; left:5%; overflow-y:scroll;">
			
			</div>
			<div id="add_group_list2" style="width:90%; height:100px; overflow-y:scroll; position:relative; top:7%; left:5%; text-align:left;">
			
			</div>
			<div style="width:90%; height:50px; position:relative; top:5%; left:5%; line-height:50px;">
				<input type="button" id="add_group_ok" value="초대" style="width:100px; height:30px; margin-top:10px; font-weight:bolder; border:1px solid #662500; border-radius:5px; color:white; background:#662500;">
			</div>
		</div>
	</div>
	<div style="width:100%; height:30px; line-height:30px; text-align:left; background:#662500; position:relative;">
		<div id="chat_menu_list" style="width:150px; height:200px; border:1px solid black; background-color:white; position:absolute; top:25px; z-index:10; right:-20px; display:none;">
			<div style="width:90%; height:90%; position:relative; top:5%; left:5%;">
				<div id="add_member_group" class="menu_btn" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
					<span style="font-weight:bold;">대화상대 초대</span>
				</div>
				<div id="exit_room" class="menu_btn" param="" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
					<span style="font-weight:bold;">대화방 나가기</span>
				</div>
				<div id="send_image" class="menu_btn" param="" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
					<form id="form" action="send_image" method="post" enctype="multipart/form-data">
						<input type="file" name="file" id="file" style="display:none;">
						<!-- <input type="hidden" name="cr_num" id="cr_num" value="0"> -->
						<label for="file" style="font-weight:bold; display:block; width:100%; height:100%; cursor:pointer;">사진 보내기</label>
					</form>
				</div>
				<div id="send_audio" class="menu_btn" param="" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
					<form id="form2" action="send_audio" method="post" enctype="multipart/form-data">
						<input type="file" name="audio_file" id="audio_file" style="display:none;">
						<label for="audio_file" style="font-weight:bold; display:block; width:100%; height:100%; cursor:pointer;">음성파일 보내기</label>
					</form>
				</div>
				<div id="send_file" class="menu_btn" param="" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
					<form id="form3" action="send_file" method="post" enctype="multipart/form-data">
						<input type="file" name="file2" id="file2" style="display:none;">
						<label for="file2" style="font-weight:bold; display:block; width:100%; height:100%; cursor:pointer;">파일 보내기</label>
					</form>
				</div>
			</div>
		</div>
		<div id="close_room" style="width:30px; height:30px; position:absolute; right:0; cursor:pointer; color:white; font-weight:bolder; z-index:50;">
			X
		</div>
		<div id="chat_menu" style="width:30px; height:30px; position:absolute; right:30px; cursor:pointer; color:white; font-weight:bolder; z-index:50;">
			메뉴
		</div>
		<span id="room_name" style="margin-left:30px; font-weight:bolder; color:white;"></span>
	</div>
	<div id="chat_center_box">
		<div id="chat_content_box">
		
		</div>
		<div style="width:100%; height:30px; line-height:30px; position:relative;">
			
			<div style="width:300px; height:300px; position:absolute; border:1px solid gray; background:white;">
				<div style="width:90%; height:90%; position:relative; top:5%; left:5%;">
					<div style="width:100%; height:50px; border:1px solid gray;">
						<c:if test="${member_num!=null }">
							<c:forEach var="elist" items="${elist }">
								<div style="width:50px; height:50x; border:1px solid black; display:inline-block;">
									<img src="resources/emoticon/${elist.emo_main_image }" style="width:100%; height:100%; border-radius:100%;">
								</div>
							</c:forEach>
						</c:if>
					</div>
				</div>
			</div>
		</div>
		<div id="chat_input_box">
			<div id="chat_send_box">
				<textarea id="chat_content"></textarea>
			</div>
			<div id="chat_btn_box">
				<input type="button" id="send_btn" value="보내기">
			</div>
		</div>
	</div>
</div>

<div id="main_body">
	<c:if test="${member_num!=null }">
		<div style="width:100%; height:100px; background:#662500;">
			<div style="width:100%; height:30px; line-height:30px; text-align:left;">
				<span style="color:white; font-weight:bolder; margin-left:20px;">M-NET TALK</span>
			</div>
			<div style="width:100%; height:70px; text-align:left;">
				<div id="friend_list_btn" style="width:70px; height:70px; display:inline-block; margin-left:10px; line-height:70px; cursor:pointer;">
					<img src="resources/icon/friend_image1.png" style="width:40px; height:40px;">
				</div>
				<div id="chat_room_btn" style="width:70px; height:70px; display:inline-block; line-height:70px; cursor:pointer;">
					<img src="resources/icon/chat_icon.png" style="width:40px; height:40px;">
				</div>
				<div style="width:70px; height:70px; display:inline-block; line-height:70px; float:right; position:relative;">
					<img id="menu_btn" src="resources/icon/menu_icon1.png" style="width:40px; height:40px; cursor:pointer;">
					<div id="menu_list" style="width:150px; height:200px; border:1px solid black; background-color:white; position:absolute; top:40px; z-index:10; right:-20px; display:none;">
						<div style="width:90%; height:90%; position:relative; top:5%; left:5%;">
							<div id="menu_my_info" class="menu_btn" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
								<span style="font-weight:bold;">내 정보 보기</span>
							</div>
							<div id="menu_find_friend" class="menu_btn" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
								<span style="font-weight:bold;">친구찾기</span>
							</div>
							<div id="menu_make_group" class="menu_btn" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
								<span style="font-weight:bold;">그룹방 만들기</span>
							</div>
							<div id="menu_logout" class="menu_btn" style="width:100%; height:30px; line-height:30px; cursor:pointer;">
								<span style="font-weight:bold;">로그아웃</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="main_center" style="width:100%; height:500px; position:relative;">
			<div id="find_friend_body" style="position:absolute; width:70%; height:70%; top:15%; left:15%; border:1px solid black; background:white; z-index:11; display:none;">
				<div style="width:100%; height:40px; background:#662500; position:relative;">
					<span style="color:white; font-weight:bold; line-height:40px;">친구찾기</span>
					<div id="close_find_freind" style="display:inline-block; position:absolute; width:40px; height:40px; right:0; line-height:40px; color:white; font-weight:bolder; cursor:pointer;">X</div>
				</div>
				<div style="width:100%; height:560px;">
					<div style="width:100%; height:50px; border-bottom:1px solid #D8D8D8;">
						<input type="text" id="search_friend" style="width:90%; height:80%; position:relative; top:5%; border:none; outline:none;" placeholder="이름 or 아이디 검색...">
					</div>
					<div id="find_friend_list" style="width:90%; height:200px; position:relative; top:5%; left:5%; overflow-y:scroll;">
					
					</div>
				</div>
			</div>
			<div id="make_group_body" style="position:absolute; width:70%; height:80%; top:15%; left:15%; border:1px solid black; background:white; z-index:11; display:none;">
				<div style="width:100%; height:40px; background:#662500; position:relative;">
					<span style="color:white; font-weight:bold; line-height:40px;">그룹방 만들기</span>
					<div id="close_group" style="display:inline-block; position:absolute; width:40px; height:40px; right:0; line-height:40px; color:white; font-weight:bolder; cursor:pointer;">X</div>
				</div>
				<div style="width:100%; height:560px;">
					<div style="width:100%; height:50px; border-bottom:1px solid #D8D8D8;">
						<input type="text" id="search_friend_group" style="width:90%; height:75%; position:relative; top:5%; border:none; outline:none;" placeholder="이름 or 아이디 검색...">
					</div>
					<div id="find_friend_list_group" style="width:90%; height:100px; position:relative; top:5%; left:5%; overflow-y:scroll;">
					
					</div>
					<div id="add_group_list" style="width:90%; height:100px; overflow-y:scroll; position:relative; top:7%; left:5%; text-align:left;">
					
					</div>
					<div style="width:90%; height:50px; position:relative; top:5%; left:5%; line-height:50px;">
						<input type="button" id="make_group_ok" value="그룹방 만들기" style="width:100px; height:30px; margin-top:10px; font-weight:bolder; border:1px solid #662500; border-radius:5px; color:white; background:#662500;">
					</div>
				</div>
			</div>
			<div style="width:100%; height:40px; border-bottom:1px solid black; position:relative;">
				<input type="text" id="search_input" style="width:95%; height:75%; position:absolute; top:6%; left:2%; border:none; outline:none;" placeholder="친구검색...">
			</div>
				<div id="center_info" style="width:90%; height:80%; position:absolute; top:15%; left:5%; overflow-y:scroll;">
					<c:if test="${mlist.size()>0 }">
						<c:forEach var="mlist" items="${mlist }">
							<div class="freind_list" style="width:100%; height:70px; display:flex; border-bottom:1px solid #D8D8D8;">
								<div style="width:20%; height:70px; line-height:70px;">
									<img src="resources/profile_image/${mlist.profile_image }" style="width:40px; height:40px; border-radius:100%; position:relative; top:15px;">
								</div>
								<div id="friend" param="${mlist.member_num }" style="width:80%; height:70px; text-align:left; line-height:70px;">
									<span style="font-weight:bolder;">${mlist.name }</span>
								</div>
							</div>
						</c:forEach>
					</c:if>
				</div>
		</div>
	</c:if>
	<c:if test="${member_num==null }">
		<div style="width:100%; height:30px; line-height:30px; text-align:left; background:#662500;position:relative; top:-1px; border:1px solid #662500;">
			<span style="color:white; font-weight:bolder; margin-left:20px;">M-NET TALK</span>
		</div>
		<div style="width:90%; height:90%; position:relative; top:5%; left:5%;">
			<div style="width:100%; height:100px;">
				<h1 id="log_join_title" style="font-size:4em;">LOGIN</h1>
			</div>
			<div id="log_join_center" style="width:100%; height:300px; position:relative;">
				<div style="width:100%; height:50px; position:relative;">
					<label for="id" id="id_label" style="position:absolute; font-size:20px; left:70px; top:7px; color:silver; cursor:text; -webkit-transition-duration:0.5s;">ID</label>
					<input type="text" id="id" style="width:70%; height:40px; font-size:20px; border:none; border-bottom:1px solid black; outline:none;">
				</div>
				<div style="width:100%; height:50px; position:relative;">
					<label for="password" id="pw_label" style="position:absolute; font-size:20px; left:70px; top:7px; color:silver; cursor:text; -webkit-transition-duration:0.5s;">PASSWORD</label>
					<input type="password" id="password" style="width:70%; height:40px; font-size:20px; border:none; border-bottom:1px solid black; outline:none; ">
				</div>
				<div style="width:100%; height:50px; position:relative;">
					<input type="button" id="login_btn" value="로그인" style="width:70%; height:50px; border:1px solid #662500; font-size:15px; background:#662500; cursor:pointer; color:white; font-weight:bold;">
				</div>
				<div style="width:100%; height:50px; position:absolute; bottom:10px; display:flex;">
					<div style="width:50%; height:20px; text-align:right; border-right:1px solid #D8D8D8; line-height:20px;">
						<span id="find_info" style="margin-right:8px; cursor:pointer;">계정찾기</span>
					</div>
					<div style="width:50%; height:20px; text-align:left; line-height:20px;">
						<span id="join" style="margin-left:7px; cursor:pointer;">회원가입</span>
					</div>
				</div>
			</div>
		</div>
	</c:if>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$(document).on('focus','#id',function(){
		$("#id_label").css({'top':'-10px','left':'60px','font-size':'15px','color':'black'})
	})
	$(document).on('blur','#id',function(){
		if($("#id").val()==""){			
			$("#id_label").css({'top':'7px','left':'70px','font-size':'20px','color':'silver'})
		}
	})
	$(document).on('focus','#password',function(){
		$("#pw_label").css({'top':'-10px','left':'60px','font-size':'15px','color':'black'})
	})
	$(document).on('blur','#password',function(){
		if($("#password").val()==""){			
			$("#pw_label").css({'top':'7px','left':'70px','font-size':'20px','color':'silver'})
		}
	})
	$("#login_btn").click(function(){
		if($("#id").val()==""){
			alert("아이디를 입력해주세요.")
			$("#id").focus()
			return false
		}else if($("#password").val()==""){
			alert("비밀번호를 입력해주세요.")
			$("#password").focus()
			return false
		}
		
		$.ajax({
			url : 'login_ok',
			type : 'post',
			data : {'id':$("#id").val(),
					'password':$("#password").val()
					},
			success : function(data){
				var res = data
				if(res>0){
					location.href="main"
				}else{
					alert("아이디/비밀번호가 틀렸습니다.")
				}
			}
		})
	})
	$(document).on('click','#join',function(){
		var join_html = "";
		$("#log_join_title").html("JOIN")
		join_html += "<div style='width:100%; height:50px; position:relative;'>";
		join_html += 	"<div id='id_check' style='width:15px; height:15px; position:absolute; right:70px; top:10px; border:1px solid black; border-radius:100%; line-height:15px; font-size:11px; font-weight:bolder; display:none'>";
		join_html += 		"";
		join_html += 	"</div>";
		join_html += 	"<label for='join_id' id='join_id_label' style='position:absolute; font-size:20px; left:70px; top:7px; color:silver; cursor:text; -webkit-transition-duration:0.5s;'>아이디</label>";
		join_html += 	"<input type='text' id='join_id' style='width:70%; height:40px; font-size:15px; border:none; border-bottom:1px solid black; outline:none;'>";
		join_html += "</div>";
		join_html += "<div style='width:100%; height:50px; position:relative;'>";
		join_html += 	"<label for='join_password' id='join_pw_label' style='position:absolute; font-size:20px; left:70px; top:7px; color:silver; cursor:text; -webkit-transition-duration:0.5s;'>비밀번호</label>";
		join_html += 	"<input type='password' id='join_password' style='width:70%; height:40px; font-size:15px; border:none; border-bottom:1px solid black; outline:none;'>";
		join_html += "</div>";
		join_html += "<div style='width:100%; height:50px; position:relative;'>";
		join_html += 	"<label for='join_password2' id='join_pw_label2' style='position:absolute; font-size:20px; left:70px; top:7px; color:silver; cursor:text; -webkit-transition-duration:0.5s;'>비밀번호 확인</label>";
		join_html += 	"<div id='pw_check' style='width:15px; height:15px; position:absolute; right:70px; top:10px; border:1px solid black; border-radius:100%; line-height:15px; font-size:11px; font-weight:bolder; display:none;'>";
		join_html += 		"";
		join_html += 	"</div>";
		join_html += 	"<input type='password' id='join_password2' style='width:70%; height:40px; font-size:15px; border:none; border-bottom:1px solid black; outline:none;'>";
		join_html += "</div>";
		join_html += "<div style='width:100%; height:50px; position:relative;'>";
		join_html += 	"<label for='join_name' id='join_name_label' style='position:absolute; font-size:20px; left:70px; top:7px; color:silver; cursor:text; -webkit-transition-duration:0.5s;'>이름</label>";
		join_html += 	"<input type='text' id='join_name' style='width:70%; height:40px; font-size:15px; border:none; border-bottom:1px solid black; outline:none;'>";
		join_html += "</div>";
		join_html += "<div style='width:100%; height:50px; position:relative; margin-top:10px;'>";
		join_html += 	"<input type='button' id='join_ok_btn' value='회원가입' style='width:35%; height:50px; border:1px solid #662500; font-size:15px; background:#662500; cursor:pointer; color:white; font-weight:bold;'> ";
		join_html += 	"<input type='button' id='join_cancel_btn' value='취소' style='width:35%; height:50px; border:1px solid #662500; font-size:15px; background:#662500; cursor:pointer; color:white; font-weight:bold;'>";
		join_html += "</div>";
		$("#log_join_center").html(join_html)
	})
	$(document).on('focus','#join_id',function(){
		$("#join_id_label").css({'top':'-8px','left':'60px','font-size':'10px','color':'black'})
	})
	$(document).on('blur','#join_id',function(){
		if($("#join_id").val()==""){			
			$("#join_id_label").css({'top':'7px','left':'70px','font-size':'20px','color':'silver'})
		}
	})
	$(document).on('focus','#join_password',function(){
		$("#join_pw_label").css({'top':'-8px','left':'60px','font-size':'10px','color':'black'})
	})
	$(document).on('blur','#join_password',function(){
		if($("#join_password").val()==""){			
			$("#join_pw_label").css({'top':'7px','left':'70px','font-size':'20px','color':'silver'})
		}
	})
	$(document).on('focus','#join_password2',function(){
		$("#join_pw_label2").css({'top':'-8px','left':'60px','font-size':'10px','color':'black'})
	})
	$(document).on('blur','#join_password2',function(){
		if($("#join_password2").val()==""){			
			$("#join_pw_label2").css({'top':'7px','left':'70px','font-size':'20px','color':'silver'})
		}
	})
	$(document).on('focus','#join_name',function(){
		$("#join_name_label").css({'top':'-8px','left':'60px','font-size':'10px','color':'black'})
	})
	$(document).on('blur','#join_name',function(){
		if($("#join_name").val()==""){			
			$("#join_name_label").css({'top':'7px','left':'70px','font-size':'20px','color':'silver'})
		}
	})
	$(document).on('keyup','#join_id',function(){
		$.ajax({
			url : 'overlap_id',
			type : 'post',
			data : {'id':$("#join_id").val()
					},
			success : function(data){
				var res = data
				if(res>0){
					$("#id_check").css({'background-color':'red','color':'white','border':'1px solid red','display':'inline-block'})
					$("#id_check").html("!")
				}else if(res<1){
					$("#id_check").css({'background-color':'green','color':'white','border':'1px solid green','display':'inline-block'})
					$("#id_check").html("O")
				}
				if($("#join_id").val()==""){
					$("#id_check").css({'display':'none'})
				}
			}
		})
	})
	$(document).on('keyup','#join_password',function(){
		if($("#join_password").val()!=$("#join_password2").val() && $("#join_password2").val()!=""){
			$("#pw_check").css({'background-color':'red','color':'white','border':'1px solid red','display':'inline-block'})
			$("#pw_check").html("!")
		}else if($("#join_password").val()==$("#join_password2").val() && $("#join_password2").val()!=""){
			$("#pw_check").css({'background-color':'green','color':'white','border':'1px solid green','display':'inline-block'})
			$("#pw_check").html("O")
		}else if($("#join_password2").val()==""){
			$("#pw_check").css({'display':'none'})
		}
	})
	$(document).on('keyup','#join_password2',function(){
		if($("#join_password").val()!=$("#join_password2").val()){
			$("#pw_check").css({'background-color':'red','color':'white','border':'1px solid red','display':'inline-block'})
			$("#pw_check").html("!")
		}else if($("#join_password").val()==$("#join_password2").val() && $("#join_password2").val()!=""){
			$("#pw_check").css({'background-color':'green','color':'white','border':'1px solid green','display':'inline-block'})
			$("#pw_check").html("O")
		}else if($("#join_password2").val()==""){
			$("#pw_check").css({'display':'none'})
		}
	})
	
	$(document).on('click','#join_ok_btn',function(){
		if($("#join_id").val()==""){
			alert("아이디를 입력해주세요.")
			$("#join_id").focus()
			return false
		}else if($("#join_password").val()==""){
			alert("비밀번호를 입력해주세요.")
			$("#join_password").focus()
			return false
		}else if($("#join_password2").val()==""){
			alert("비밀번호 확인을 입력해주세요.")
			$("#join_password2").focus()
			return false
		}else if($("#join_name").val()==""){
			alert("이름을 입력해주세요.")
			$("#join_name").focus()
			return false
		}
		if($("#join_password").val()!=$("#join_password2").val()){
			alert("비밀번호가 일치하지 않습니다.")
			$("#join_password2").focus()
			return false
		}
		$.ajax({
			url : 'join_ok',
			type : 'post',
			data : {'id' : $("#join_id").val(),
					'password' : $("#join_password").val(),
					'name' : $("#join_name").val()
					},
			success : function(data){
				var res = data
				if(res<1){
					alert("회원가입이 완료되었습니다.")
					location.href="main"
				}else{
					alert("중복된 아이디 입니다.")
					return false
				}
			}
		})
	})
	$(document).on('click','#join_cancel_btn',function(){
		location.href="main"
	})
})
</script>
<!-- <div id="header">
	<ul>
		<li><a href="login">로그인</a></li>
		<li><a href="#none">회원가입</a></li>
	</ul>
</div> -->
<div id="center">
<jsp:include page="${center }"/>
</div>
<!-- <div style='width:250px; height:100px; border:1px solid black; position:absolute; bottom:0; right:0;'>
	<div style='width:100%; height:30px; line-height:30px; position:relative;'>
		<span style='font-weight:bold;'>새 메세지가 왔습니다.</span>
		<div style='position:absolute; width:30px; height:30px; right:0; line-height:30px; top:0;'>
			X
		</div>
	</div>
	<div style='width:100%; height:70px;'>
		<div style='width:90%; height:90%; position:relative; top:5%; left:5%; display:flex;'>
			<div style='width:30%; height:100%;'>
				<img src='asd' style='width:40px; height:40px; border-radius:100%;'>
			</div>
			<div style='width:70%; height:100%;'>
				<div style='width:100%; height:30%; text-align:left;'>
					<span style='font-weight:bold;'>a1231232</span>
				</div>
				<div style='width:100%; height:70%; text-align:left;'>
					<span style='color:silver;'>a1231232</span>
				</div>
			</div>
		</div>
	</div>
</div> -->
</body>
</html>