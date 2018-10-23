<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
#login_body{width:300px; height:250px; border:1px solid #D8D8D8; margin:10% auto; border-radius:5px; z-index:50; position:relative;}
#id_div,#pw_div{width:100%; height:60px; position:relative;}
#id,#password{width:80%; height:30px;}
#id_label,#pw_label{position:absolute; font-size:15px; color:silver; top:10px; left:40px; -webkit-transition-duration:0.5s;}
#login_btn,#find_btn{width:100px; height:30px; line-height:30px; color:white; background-color:black; border:1px solid black; border-radius:5px;
font-weight:bold; cursor:pointer;}
</style>
</head>
<body>
	<div id="login">
		
		<div id="login_body">
			<h1>login</h1>
			<div id="id_div">
				<label for="id" id="id_label">ID</label>
				<input type="text" id="id">
			</div>
			<div id="pw_div">
				<label for="password" id="pw_label">PASSWORD</label>
				<input type="text" id="password">
			</div>
			<div style="width:100%; height:60px;">
				<input type="button" id="login_btn" value="로그인">
				<input type="button" id="find_btn" value="회원정보 찾기">
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
$(document).ready(function(){
	$("#id").focus(function(){
		$("#id_label").css({'top':'-20px','left':'30px','font-size':'12px','color':'black'})
	})
	$("#id").blur(function(){
		if($("#id").val()==""){
			$("#id_label").css({'top':'10px','left':'40px','font-size':'15px','color':'silver'})
		}
	})
	$("#password").focus(function(){
		$("#pw_label").css({'top':'-20px','left':'30px','font-size':'12px','color':'black'})
	})
	$("#password").blur(function(){
		if($("#password").val()==""){
			$("#pw_label").css({'top':'10px','left':'40px','font-size':'15px','color':'silver'})
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
})
</script>
</html>